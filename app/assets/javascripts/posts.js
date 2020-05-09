$(function(){

  $(document).on('keyup', '#PostTitle' ,function(){
    var countNum = $(this).val().length;
    $("#PostTitle-counter").text(countNum + "文字 / 30文字");
  });

  $(document).on('keyup', '#PostPlace' ,function(){
    var countNum = $(this).val().length;
    $("#PostPlace-counter").text(countNum + "文字 / 10文字");
  });

  $(document).on('keyup', '#PostOverview' ,function(){
    var countNum = $(this).val().length;
    $("#PostOverview-counter").text(countNum + "文字 / 100文字");
  });



  $(document).on('cocoon:after-insert', '#SpotCreate-form-wrapper' ,function(){
    check_to_hide_or_show_add_link();
    check_to_hide_or_show_remove_link();
  });

  $(document).on('cocoon:after-remove', '#SpotCreate-form-wrapper' ,function(){
    check_to_hide_or_show_add_link();
    check_to_hide_or_show_remove_link()
  });

  function check_to_hide_or_show_add_link(){
    if ($('.nested-fields').length == 5 ){
      $('#add-link').hide();
    }else{
      $('#add-link').show();
    }
  }

  function check_to_hide_or_show_remove_link(){
    if ($('.nested-fields').length == 1 ){
      $('.remove-link').css('visibility','hidden');
    }else{
      $('.remove-link').css('visibility','visible');
    }
  }


  $(document).on('keyup', '.SpotPlace-field' ,function(){
    var countNum = $(this).val().length;
    var target = $(this).parent('.nested-fields')
    var countElement = $('.nested-fields').index(target);
    $('.nested-fields').eq(countElement).children('.SpotPlace-counter').text(countNum + "文字 / 20文字");
  });

  $(document).on('keyup', '.SpotExplaine-field' ,function(){
    var countNum = $(this).val().length;
    var target = $(this).parent('.nested-fields')
    var countElement = $('.nested-fields').index(target);
    $('.nested-fields').eq(countElement).children('.SpotExplaine-counter').text(countNum + "文字 / 300文字");
  });





});
