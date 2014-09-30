$(function(){

    //plugin check
    if($(".login-error").length){
        errorMsg = $(".login-error").text();
        if (errorMsg.match(/missing plugin/)) {
          $('#plugin-modal').modal({
              show: true,
          });
        }
    }

    //version check
    if($(".login-error").length){
        errorMsg = $(".login-error").text();
        if (errorMsg.match(/unsupport version/)) {
          $('#version-restrict-modal').modal({
              show: true,
          });
        }
    }
});
