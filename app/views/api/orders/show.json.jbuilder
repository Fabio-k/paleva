json.code @order.code
json.client_name @order.client_name
json.status OrderStatus.human_attribute_name("status.#{@order.current_status}")
json.entry_data @order.created_at
json.total @order.calculate_total

json.items @order.order_portions do |order_portion|
  json.name order_portion.portion.item.name
  json.portion order_portion.portion.description
  json.note order_portion.note
  json.quantity order_portion.quantity
  json.price order_portion.price
end