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
          lon: -104.9822545,
          img: "jewelry.jpg"
        },
        {
          name: "Wax Trax",
          description: "CDs are for fools. Same goes for MP3s.CDs are Wax TraxWWax. Traxax Trax.",
          lat: 39.7367626,
          lon: -104.9789276,
          img: "wax.jpg"
        },
        {
          name: "The Buffalo Exchange",
          description: "We heard you like used goods, so we overpriced them. goods, so The Buffalo Exchange.",
          lat: 39.736774,
          lon: -105.0541641,
          img: "clothes.jpg"
        }
      ]
    end
  end
end
