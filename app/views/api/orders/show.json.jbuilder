json.code @order.code
json.client_name @order.client_name
json.status Order.human_attribute_name("status.#{@order.status}")
json.entry_data @order.created_at

json.items @order.order_portions do |order_portion|
  json.name order_portion.portion.item.name
  json.portion order_portion.portion.description
  json.note order_portion.note
end