class Spree::ProductBatchHelper
  class << self
    def get_batches(stores, products)
      products = @stores.map do |s|
        s.products.showcases.limit(4)
      end

      #only 4 images in the grid, hence (0..3)
      (0..3).map do |i|
        (0..@stores.length - 1).map do |store_index|
          products[store_index][i]
        end
      end
    end
  end
end
