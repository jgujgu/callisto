module Spree
  class HomeController < Spree::StoreController
    helper 'spree/products'
    respond_to :html

    def index
      if Rails.env.development? || Rails.env.test?
        @ip_address = "75.148.122.29"
      else
        @ip_address = request.remote_ip
      end
      @geocoder_result = Geocoder.search(@ip_address).first.data
      @searcher = build_searcher(params.merge(include_images: true))
      @products = @searcher.retrieve_products
      @taxonomies = Spree::Taxonomy.includes(root: :children)
    end
  end
end
