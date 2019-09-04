$(document).ready(function($) {
  $('#searchUsers').keyup(function(event) {
      var search = $(this).val();
      console.log(search)
      $.ajax({
          url: 'users/search',
          type: 'GET',
          data: {
            search: search,
          },
          success: function(data) {
            $("#getUsers").html(each_users(data));
          },
          error: function($error) {
            alert(I18n.t('admin.fail'));
          }
      })
  });

  function each_users(data){
    var html_user = "";
    if (data.users.length > 0) {
      $.each($(data.users), function(index, item){
        html_user += '<tr><td>' + item.id + '</td><td>' + item.name
        + '</td><td>' + item.email + '</td><td>' + I18n.t('users.'+item.sex) +
        '</td><td>' + item.phone + '</td><td>' + item.address + '</td><td>'
        + '<span class="btn-' + check_role(item.role) + ' btn-role">'
        + item.role + '</span>' + '</td><td><li class="dropdown li-option">' +
        '<a class="dropdown-toggle a-opiton" data-toggle="dropdown" href="#">' +
        I18n.t('users.option') + '</a><ul class="dropdown-menu" role="menu">' +
        '<li><a href="/admin/users/' + item.id +'/edit">' +
        '<span class="glyphicon glyphicon-pencil"></span> ' +
        I18n.t('users.edit') + '</a></li><li>' +
        '<a data-confirm="' + I18n.t('cart.you_sure') + '" rel="nofollow"' +
        'data-method="delete" href="/vi/admin/users/' + item.id + '">' +
        '<span class="glyphicon glyphicon-trash"></span> ' +
        I18n.t('users.delete') + '</a></li></ul></li></td></tr>'
      })
    }else{
      html_user += '<tr><td colspan="7">' + I18n.t('users.user_empty') +
      '</td></tr>'
    }
    return html_user;
  }

  function check_role(role) {
    return role == 'admin' ? 'danger' : 'info'
  }
})
