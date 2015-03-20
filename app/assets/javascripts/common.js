$(function(){

    //initialize of gon
    if (typeof gon === "undefined") {
      gon = false
    }

    $("[data-toggle=tooltip_navbar]").tooltip({
      placement: 'bottom',
      delay: { show: 200, hide: 50 },
    });

    // gathering logs for log and connection glaph
    $('#date_timepicker_start').datetimepicker({
        format:'Y/m/d H:i',
        onShow:function( ct ){
            this.setOptions({
             maxDate:jQuery('#date_timepicker_end').val()?jQuery('#date_timepicker_end').val():false
            })
        },
        validateOnBlur: true,
        defaultDate: new Date(),
        defaultTime: '00:00',
        allowBlank: false,
        timepicker:true
    });
    $('#date_timepicker_end').datetimepicker({
        format:'Y/m/d H:i',
        onShow:function( ct ){
            this.setOptions({
             minDate:jQuery('#date_timepicker_start').val()?jQuery('#date_timepicker_start').val():false
            })
        },
        validateOnBlur: true,
        defaultDate: new Date(),
        defaultTime: '23:59',
        allowBlank: false,
        timepicker:true
    });

});
