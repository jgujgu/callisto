module Spree
  class HomeController < Spree::StoreController
    helper 'spree/products'
    respond_to :html

    def index
      subdomain = request.subdomain
      if subdomain == "www" || subdomain == "flea" || subdomain.empty?
        @stores = Spree::Store.showcases
        @products = @searcher.retrieve_products
        @markers = MapMarkerHelper.getMarkers(@stores, @geocoder_result)
        @product_batches = ProductBatchHelper.get_batches(@stores, @products)
        @searcher = build_searcher(params.merge(include_images: true))
        @taxonomies = Spree::Taxonomy.includes(root: :children)
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
