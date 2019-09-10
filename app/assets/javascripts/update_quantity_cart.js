$(document).ready(function(){
  $('.quantityCart').change(function(event) {
    const obj = $(this)
      var quantity = obj.val();
      var product_id =  obj.attr('dataid');
      var price =  obj.attr('dataprice');
      $.ajax({
        url: '/cart/update',
        type: 'GET',
        data: {
          product_id: product_id,
          quantity: quantity,
          price: price,
                },
          success: function(data) {
          obj.parent().parent().next().html('<br/><br/>'
            + I18n.toCurrency(data['amount']))
          $('.total_price').html(I18n.toCurrency(data['total']));
          $('#message-cart').html(
            '<div class = "alert alert-success a">' +
            I18n.t("cart.update_cart_success") + '</div>');
        },
        error: function($error) {
          $('#message-cart').html(
            '<div class = "alert alert-alert a">' +
            I18n.t("cart.update_cart_fail") + '</div>');
        }
      })
  });
});
