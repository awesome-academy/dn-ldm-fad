$(document).ready(function() {
  $('.confirm_destroy_category').one('mouseover', function(){
    var id = $(this).attr('data-id');
     $.ajax({
      url: '/admin/categories/confirm_before_destroy',
      type: 'GET',
      data: {
            id: id,
          },
      success: function(data) {
        $('#destroy-category-' + id).attr('data-confirm', data.message);
      },
      error: function($error) {
        alert(I18n.t('admin.categories.fail'))
      }
    })
  });
});
