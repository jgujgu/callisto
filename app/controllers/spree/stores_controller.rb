require "hurley"

module Spree
  class StoresController < Spree::StoreController
    def new
      if current_spree_user.store
        flash[:notice] = "A shop tied to this account already exists."
        redirect_to root_path
      else
        @store = Store.new
      end
    end

    def create
      slug = new_store_params[:name].parameterize
      extra_attributes = {
        code: slug,
        url: "http://#{slug}.#{request.host_with_port}",
        mail_from_address: "changeme@flea.boutique"
      }
      store_params = new_store_params.merge(extra_attributes)
      @store = Store.new(store_params)
      if @store.save
        current_spree_user.update(store_id: @store.id)
        current_spree_user.user_stock_locations.create(stock_location_id: Spree::StockLocation.find_by(code: @store.code).id)
        @store.store_payment_methods.create(payment_method_id: Spree::PaymentMethod.find_by(type:"Spree::Gateway::StripeCheckout").id)
        redirect_to connect_stripe_path
      else
        flash[:notice] = @store.errors.full_messages.join
        render "spree/stores/new"
      end
    end

    def connect_stripe
      store = current_spree_user.store
      stripe_user_email = current_spree_user.email
      stripe_user_url = store.url
      stripe_user_country = "US"
      stripe_user_phone_number = store.phone_number.gsub(/\D/, '')
      stripe_user_street_address = store.street_address
      stripe_user_city = store.city
      stripe_user_state = store.state.abbr
      stripe_user_zip = store.zipcode
      stripe_user_product_description = store.description
      stripe_user_product_business_name = store.name

      @stripe_connect_url = "https://connect.stripe.com/oauth/authorize?response_type=code&scope=read_write"
      @stripe_connect_url += "&client_id=#{ENV["STRIPE_CLIENT_ID"]}"
      @stripe_connect_url += "&stripe_user[email]=#{stripe_user_email}"
      @stripe_connect_url += "&stripe_user[url]=#{stripe_user_url}"
      @stripe_connect_url += "&stripe_user[country]=#{stripe_user_country}"
      @stripe_connect_url += "&stripe_user[phone_number]=#{stripe_user_phone_number}"
      @stripe_connect_url += "&stripe_user[street_address]=#{stripe_user_street_address}"
      @stripe_connect_url += "&stripe_user[city]=#{stripe_user_city}"
      @stripe_connect_url += "&stripe_user[state]=#{stripe_user_state}"
      @stripe_connect_url += "&stripe_user[zip]=#{stripe_user_zip}"
      @stripe_connect_url += "&stripe_user[product_description]=#{stripe_user_product_description}"
      @stripe_connect_url += "&stripe_user[business_name]=#{stripe_user_product_business_name}"
    end

    def connect_stripe_complete
      client = Hurley::Client.new "https://connect.stripe.com"
      result = client.post(
        "oauth/token",
        {
          grant_type: "authorization_code",
          client_secret: ENV["STRIPE_SECRET_KEY"],
          code: params[:code]
        }
      )
      body = JSON.parse(result.body)
      if body["error"]
        flash[:notice] = "We could not connect your Stripe account. Please try again."
        redirect_to connect_stripe_path
      else
        store = current_spree_user.store
        store.stripe_user_id = body["stripe_user_id"]
        store.save
        flash[:notice] = "Thank you for signing up. You can now log in and list products."
        redirect_to admin_orders_path
      end
    end

    private

    def new_store_params
      params.require(:store).permit(
        :name,
        :description,
        :street_address,
        :city,
        :state_id,
        :zipcode,
        :phone_number,
        :hero
      )
    end
  end
end
