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
        flash[:notice] = "Thank you for signing up. You can now log in and list products."
        redirect_to admin_orders_path
      else
        flash[:notice] = @store.errors.full_messages.join
        render "spree/stores/new"
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
