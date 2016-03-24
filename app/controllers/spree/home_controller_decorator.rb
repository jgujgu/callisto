module Spree
  class HomeController < Spree::StoreController
    helper 'spree/products'
    respond_to :html

    def index
      subdomain = request.subdomain
      if subdomain == "www" || subdomain == "flea" || subdomain.empty?
        @stores = Spree::Store.showcases
        @searcher = build_searcher(params.merge(include_images: true))
        @product_batches = ProductBatchService.get_batches(@stores)
        @taxonomies = Spree::Taxonomy.includes(root: :children)

        user_marker = Gmaps4rails.build_markers([@geocoder_result]) do |gr, marker|
          marker.lat gr["latitude"]
          marker.lng gr["longitude"]
          marker.infowindow gr["ip"]
        end

        index = 0
        store_markers = Gmaps4rails.build_markers(@stores) do |store, marker|
          directions_link = "http://maps.google.com/maps?saddr=@#{@geocoder_result["latitude"]},#{@geocoder_result["longitude"]}&daddr=@#{store[:latitude]},#{store[:longitude]}"
          marker.lat store[:latitude]
          marker.lng store[:longitude]
          marker.infowindow render_to_string(:partial => "/spree/partials/store_marker", locals: { store: store, index: index, directions_link: directions_link })
          marker.json({ id: index })
          index += 1
        end

        @markers = store_markers + user_marker
      else
        store = Spree::Store.find_by(code: subdomain)
        @products = store.products.where(["available_on <= ?", Date.today.to_time(:utc)])
        @markers = Gmaps4rails.build_markers([store]) do |single_store, marker|
          directions_link = "http://maps.google.com/maps?saddr=@#{@geocoder_result["latitude"]},#{@geocoder_result["longitude"]}&daddr=@#{single_store[:latitude]},#{single_store[:longitude]}"
          marker.lat single_store[:latitude]
          marker.lng single_store[:longitude]
          marker.infowindow render_to_string(:partial => "/spree/partials/store_marker", locals: { store: single_store, index: 0, directions_link: directions_link })
          marker.json({ id: 0 })
        end
        if store
          render "spree/stores/show"
        else
          render text: 'Not Found', status: 404
        end
      end
    end
  end
end
