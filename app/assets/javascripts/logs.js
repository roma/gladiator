$(window).load(function() {

    if (gon.routing_list) {
        //Tabs
        jQuery.each(gon.routing_list, function() {
            $("#"+this+"-tabs").click(function(){
                $("#tabs li").removeClass("active");
                $(this).parent().addClass("active");
                $("#tabs .panel").hide();
                $(this.hash).fadeIn();
                return false;
            });
        });
        $("#"+gon.routing_list[0]+"-tabs:eq(0)").trigger('click');
  
        //Table sorter
        $('table.log-table')
        .tablesorter({
            theme: 'default',
            sortList: [[0,1]],
            widthFixed: true,
            widgets: ["filter"], 
            headers: {0: { filter: false }},
            widgetOptions : { 
                pager_removeRows : false, 
                filter_reset : 'button.reset-filter',
                filter_cssFilter : 'tablesorter-filter', 
                filter_functions : {
                  1 : true
                }
            } 
        })
        .tablesorterPager({
            container: $("#pager"),
            size: 30,
            removeRows: false,
            positionFixed: false
        });
    }

    //for v1.0.0
    $("#logs-button").click(function() {
        $(".access-loader").css({"display":"inline"});
        $("#log-button-msg").text("gathering log data");
        $("#logs-button").css({"background-color":"#222222", "border-color":"#222222"});
        $("#logs-button").attr('disabled', true);
    });

    //for after v1.1.0
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

    $("#get-logs-button").click(function() {
        $(".access-loader").css({"display":"inline"});
        $(this).val("gathering log data");
        $(this).css({"background-color":"grey", "border-color":"grey"});
        $(this).attr('disabled', true);
        $(this).closest('form').submit(); //for chrome
    });

})
