$(function(){

  $(document).on('keyup', '#UserEdit-name' ,function(){
    let countNum = $(this).val().length;
    $("#name-counter").text(countNum + "文字 / 30文字");
  });

  $(document).on('keyup', '#UserEdit-introduction' ,function(){
    let countNum = $(this).val().length;
    $('#introduction-counter').text(countNum + "文字 / 180文字");
  });

});
