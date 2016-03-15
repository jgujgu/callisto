# Address Stuff

ship_address = @order.ship_address
bill_address = @order.bill_address
anonymous = @order.email =~ /@example.net$/

def address_info(address, address_2)
  info = %Q{
    #{address.first_name} #{address.last_name}
    #{address.address1}
  }
  info += "#{address.address2}\n" if address.address2.present?
  state = address.state ? address.state.abbr : ""
  info += "#{address.city}, #{state} #{address.zipcode}\n"
  info.strip
end

def order_info(address, address_2)
  info = ""
  info += "Customer Name: #{address_2.firstname} #{address_2.lastname}\n"
  info += "Email: #{@order.email}\n"
  info += "Phone: #{address.phone}\n"
  info += "\n"
  info += "Shop: #{current_store.name}"
  info.strip
end

current_shipment = @order.shipments.detect { |shipment| shipment.stock_location_id == current_store.stock_location.id }

data = [
  [Spree.t(:shipping_address), Spree.t(:order_information)],
  [address_info(ship_address, bill_address) + "\n\nShipping Method: #{current_shipment.shipping_method.name}", order_info(ship_address, bill_address)]
]

move_down 75
table(data, :width => 540) do
  row(0).font_style = :bold

  # Billing address header
  row(0).column(0).borders = [:top, :right, :bottom, :left]
  row(0).column(0).border_widths = [0.5, 0, 0.5, 0.5]

  # Shipping address header
  row(0).column(1).borders = [:top, :right, :bottom, :left]
  row(0).column(1).border_widths = [0.5, 0.5, 0.5, 0]

  # Bill address information
  row(1).column(0).borders = [:top, :right, :bottom, :left]
  row(1).column(0).border_widths = [0.5, 0, 0.5, 0.5]

  # Ship address information
  row(1).column(1).borders = [:top, :right, :bottom, :left]
  row(1).column(1).border_widths = [0.5, 0.5, 0.5, 0]
end
