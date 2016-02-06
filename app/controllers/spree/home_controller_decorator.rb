module Spree
  class HomeController < Spree::StoreController
    helper 'spree/products'
    respond_to :html

    def index
      subdomain = request.subdomain
      if subdomain.empty? || subdomain == "www" || subdomain == "flea"
        @searcher = build_searcher(params.merge(include_images: true))
        @products = @searcher.retrieve_products
        @taxonomies = Spree::Taxonomy.includes(root: :children)
        @stores = Spree::Store.showcases

        products = @stores.map do |s|
          s.products.showcases.limit(4)
        end

        @product_batches = (0..3).map do |i|
          (0..@stores.length - 1).map do |store_index|
            products[store_index][i]
          end
        end

        #user_marker = Gmaps4rails.build_markers([@geocoder_result]) do |gr, marker|
        #marker.lat gr["latitude"]
        #marker.lng gr["longitude"]
        #marker.infowindow gr["ip"]
        #end

        #index = 0
        #store_markers = Gmaps4rails.build_markers(@stores) do |store, marker|
        #marker.lat store[:latitude]
        #marker.lng store[:longitude]
        #marker.infowindow render_to_string(:partial => "/spree/partials/store_marker", locals: { store: store, index: index})
        #marker.json({ id: index })
        #index += 1
        #end
        #@markers = store_markers + user_marker
      else
        store = Spree::Store.find_by(code: subdomain)
        if store
          render "spree/stores/show"
        else
          render text: 'Not Found', status: 404
        end
      end
    end
  end
end
