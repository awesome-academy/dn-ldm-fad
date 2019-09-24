$(document).ready(function($) {
  $('#orderStatus').change(function(event) {
    var status = $(this).val();
    $.ajax({
      url: '/admin/orders/filter_by_status',
      type: 'GET',
      data: {
        status:status,
              },
      success: function(data) {
        $("#getOrder").html(each_orders(data));
      },
      error: function($error) {
        alert(I18n.t("admin.orders.fail"));
      }
    })
  });
});

function each_orders(data){
  var html_order = "";
  if (data.orders.length > 0) {
    $.each($(data.orders), function(index, item){
      html_order += '<tr><td>' + item.id + '</td><td>' + item.customer
      + '</td><td>' + item.phone + '</td><td>' + item.address + '</td><td>' +
      check_description(item.description) + '</td><td>' + item.created_at + '</td><td>' +
      '<span class="btn btn-'+ item.status + ' btn-order">' +
      I18n.t('admin.orders.' + item.status) + '</span>' + '</td><td>' +
      '<a href="/vi/admin/orders/' + item.id +'"><span class="btn glyphicon glyphicon-search"></span></a>' +
      '<a data-confirm="' + I18n.t("admin.orders.you_sure") + '" rel="nofollow" data-method="delete"' +
      'href="/vi/admin/orders/' + item.id +'"><span class="glyphicon glyphicon-trash text-danger"></span></a>'
    })
  }else{
    html_order += '<tr><td colspan="8">' + I18n.t("admin.orders.empty") + '</td></tr>'
  }
  return html_order;
}

function check_description(description) {
  return description ? description : I18n.t('admin.orders.note_empty')
}
