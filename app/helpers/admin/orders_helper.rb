module Admin::OrdersHelper
  def order_stats
    [
      {
        label:      "Total Orders",
        value:      @total_orders,
        change:     @total_orders_change,
        icon_class: "fas fa-shopping-bag",
        icon_bg:    "bg-blue-100",
        icon_color: "text-blue-600"
      },
      {
        label:      "Pending Orders",
        value:      @pending_orders,
        change:     @pending_orders_change,
        icon_class: "fas fa-clock",
        icon_bg:    "bg-yellow-100",
        icon_color: "text-yellow-600"
      },
      {
        label:      "Completed Orders",
        value:      @completed_orders,
        change:     @completed_orders_change,
        icon_class: "fas fa-check-circle",
        icon_bg:    "bg-green-100",
        icon_color: "text-green-600"
      }
    ]
  end

  def order_status_classes(status)
    case status.to_s.downcase
    when "completed"
      "bg-green-100 text-green-700"
    when "processing"
      "bg-blue-100 text-blue-700"
    when "pending"
      "bg-yellow-100 text-yellow-700"
    when "cancelled"
      "bg-red-100 text-red-700"
    else
      "bg-gray-100 text-gray-700"
    end
  end
end
