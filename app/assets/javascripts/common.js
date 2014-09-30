$(function(){

    //initialize of gon
    if (typeof gon === "undefined") {
      gon = false
    }

    $("[data-toggle=tooltip_navbar]").tooltip({
      placement: 'bottom',
      delay: { show: 200, hide: 50 },
    });

});
