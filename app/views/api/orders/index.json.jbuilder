json.orders @orders do |order|
  json.code order.code

  json.status OrderStatus.human_attribute_name("status.#{order.current_status}")
  json.total order.calculate_total

  json.client do
    json.name order.client_name
    json.phone_number order.phone_number
  end

  json.items order.order_portions do |order_portion|
      json.name order_portion.portion.item.name
      json.note order_portion.note
      json.portion order_portion.portion.description
      json.price order_portion.price    
  end

end

  
