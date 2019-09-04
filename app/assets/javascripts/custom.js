$(document).ready(function(){
  setTimeout(function(){
  $('.alert-success').slideUp();
  },3000)
})

jQuery(document).ready(function($){
  pos = $('#menuTop').position();
  $(window).scroll(function(){
      var possScroll = $(document).scrollTop();
      if (parseInt(possScroll) > parseInt(pos.top)) {
          $('#menuTop').addClass('navbar-fixed-top menu-style');
      }else{
          $('#menuTop').removeClass('navbar-fixed-top menu-style');
      }
  });
});
