$(document).ready(function() {
  $('#calendar').datepicker({});
  !function ($) {
      $(document).on("click","ul.nav li.parent > a > span.icon", function(){
        $(this).find('em:first').toggleClass("glyphicon-minus");
      });
      $(".sidebar span.icon").find('em:first').addClass("glyphicon-plus");
  }
  (window.jQuery);
  $(window).on('resize', function () {
    if ($(window).width() > 768) $('#sidebar-collapse').collapse('show')
  })
  $(window).on('resize', function () {
    if ($(window).width() <= 767) $('#sidebar-collapse').collapse('hide')
  });
});

function changeImgProduct(input){
    if(input.files && input.files[0]){
        var reader = new FileReader();
        reader.onload = function(e){
            $('#product_img').attr('src',e.target.result);
        }
        reader.readAsDataURL(input.files[0]);
    }
}
$(document).ready(function() {
  $('#product_img').click(function(){
      $('#product_picture').click();
  });

  $('#select_category').one('mouseover', function(){
     $.ajax({
      url: '/admin/products/categories',
      type: 'GET',
      success: function(data) {
        $('#select_category').append(each_categoris_or_types(data.categories));
      },
      error: function($error) {
        alert(I18n.t('admin.categories.fail'))
      }
    })
  });

  $('#select_product_type').one('mouseover', function(){
     $.ajax({
      url: '/admin/products/product_types',
      type: 'GET',
      success: function(data) {
        $('#select_product_type').append(each_categoris_or_types(data.product_types));
      },
      error: function($error) {
        alert(I18n.t('admin.categories.fail'))
      }
    })
  });

});

function each_categoris_or_types(data){
  var html = "";
  if (data.length > 0) {
    $.each($(data), function(index, item){
      html += '<option value="' + item[0] + '">' + item[1] + '</option>';
    })
  }else{
    html += '<option value="">' + I18n.t('admin.categories.empty') + ' </option>';
  }
  return html;
}
