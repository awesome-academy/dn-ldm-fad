$(document).ready(function(){
  $('.quantityCart').change(function(event) {
    const obj = $(this)
      var quantity = obj.val();
      if (quantity > 0) {
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
            if (data.status == 'fail') {
              $('#message-cart').html(
              '<div class = "alert alert-danger a">' +
              I18n.t("cart.update_cart_fail_qty") + '</div>');
            }else if (data.status == 'not_enough') {
              $('#message-cart').html(
              '<div class = "alert alert-danger a">' +
              I18n.t("cart.update_cart_fail_qty_not_enough") + '</div>');
            }else{
              $('.total_price').html(I18n.toCurrency(data.total));
              obj.parent().parent().next().html('<br/><br/>'
              + I18n.toCurrency(data.amount))
              $('#amount-price-' + product_id).html(I18n.toCurrency(data.amount));
              $('#message-cart').html(
              '<div class = "alert alert-success a">' +
              I18n.t("cart.update_cart_success") + '</div>');
            }
          },
          error: function($error) {
            $('#message-cart').html(
              '<div class = "alert alert-danger a">' +
              I18n.t("cart.update_cart_fail") + '</div>');
          }
        })
      }else{
       $('#message-cart').html(
         '<div class = "alert alert-danger a">' +
         I18n.t("cart.update_cart_fail_qty") + '</div>');
     }
  });
});
