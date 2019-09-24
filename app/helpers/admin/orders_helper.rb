module Admin::OrdersHelper
  def load_order_status
    Order.statuses.map{|k, _v| [I18n.t("admin.orders.#{k}"), k]}
  end

  def load_order_status_detail order
    statuses = Order.statuses
    if order.waiting?
      statuses = statuses.slice :approve, :cancel
    elsif order.approve?
      statuses = statuses.slice :delivering, :delivered, :cancel
    elsif order.delivering?
      statuses = statuses.slice :delivered, :cancel
    end
    statuses.map{|k, v| [I18n.t("admin.orders.#{k}"), v]}
  end
end
