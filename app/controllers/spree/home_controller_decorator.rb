module Spree
  class HomeController < Spree::StoreController
    helper 'spree/products'
    respond_to :html

    def index
      @searcher = build_searcher(params.merge(include_images: true))
      @products = @searcher.retrieve_products
      @taxonomies = Spree::Taxonomy.includes(root: :children)
      @stores = [
        {
          name: "Jewelry the Hut",
          description: "Phat jewelry like jabba. like j abbalike ja bba. like jabbajewelry like jabba.",
          lat: 39.7374451,
          lng: -104.9822545,
          img: "jewelry.jpg"
        },
        {
          name: "Wax Trax",
          description: "CDs are for fools. Same goes for MP3s.CDs are Wax TraxWWax. Traxax Trax.",
          lat: 39.7367626,
          lng: -104.9789276,
          img: "wax.jpg"
        },
        {
          name: "The Buffalo Exchange",
          description: "We heard you like used goods, so we overpriced them. goods, so The Buffalo Exchange.",
          lat: 39.736774,
          lng: -104.9862716,
          img: "clothes.jpg"
        }
      ]
      @user_marker = Gmaps4rails.build_markers([@geocoder_result]) do |gr, marker|
        marker.lat gr["latitude"]
        marker.lng gr["longitude"]
        marker.infowindow gr["ip"]
      end

      index = 0
      @store_markers = Gmaps4rails.build_markers(@stores) do |store, marker|
        marker.lat store[:lat]
        marker.lng store[:lng]
        marker.infowindow render_to_string(:partial => "/spree/partials/store_marker", locals: { store: store, index: index})
        marker.json({ id: index })
        index += 1
      end
      @markers = @store_markers + @user_marker
    end
  end
end
