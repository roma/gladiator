$(function(){

    $(".reload-btn").click(function(){
      location.reload();
    });

    $("dd").css("display","none");

    $("dl dt").click(function(){
        if($("+dd",this).css("display")=="none"){
            $("dd").slideUp("slow");
            $("dt span").html("<i class='icon-chevron-right'></i>");
            $("+dd",this).slideDown("slow");
            $(".accordion-status-"+$(this).attr('class')).html("<i class='icon-chevron-down'></i>");
        }else{
            $("dd").slideUp("slow");
            $(".accordion-status-"+$(this).attr('class')).html("<i class='icon-chevron-right'></i>");
        }
    });

    $("[data-toggle=tooltip]").tooltip({
        placement: 'left',
        html: true
    });

});
