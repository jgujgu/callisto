Spree::BaseHelper.class_eval do
    def link_to_cart(text = nil)
      text = "<i class='fa fa-shopping-cart fa-3'></i>"
      css_class = "nav-link "

      if simple_current_order.nil? or simple_current_order.item_count.zero?
        css_class += 'empty'
      else
        css_class += 'full'
      end
      qty = simple_current_order.item_count
      total = simple_current_order.display_total.to_html

      link_to text.html_safe, spree.cart_path, :class => "cart-info #{css_class}", "data-toggle": "tooltip", "data-placement": "bottom", title: "#{total} (#{qty})"
    end
end
