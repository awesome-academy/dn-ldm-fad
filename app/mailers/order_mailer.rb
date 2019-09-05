class OrderMailer < ApplicationMailer
  def order_confirm user, carts, order
    @user = user
    @carts = carts
    @order = order
    @products = @order.products
    @total_price = total_price @carts, @products
    mail to: user.email, subject: t("mail.order.subject")
  end

  private

  def total_price carts, products
    products.reduce(0){|a, e| a + e.price * carts[e.id.to_s]}
  end
end
