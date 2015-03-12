$(window).load(function() {

    //if (gon.routing_list) {
    //    //Tabs
    //    jQuery.each(gon.routing_list, function() {
    //        $("#"+this+"-tabs").click(function(){
    //            $("#tabs li").removeClass("active");
    //            $(this).parent().addClass("active");
    //            $("#tabs .panel").hide();
    //            $(this.hash).fadeIn();
    //            return false;
    //        });
    //    });
    //    $("#"+gon.routing_list[0]+"-tabs:eq(0)").trigger('click');
  
    //    //Table sorter
    //    $('table.log-table')
    //    .tablesorter({
    //        theme: 'default',
    //        sortList: [[0,1]],
    //        widthFixed: true,
    //        widgets: ["filter"], 
    //        headers: {0: { filter: false }},
    //        widgetOptions : { 
    //            pager_removeRows : false, 
    //            filter_reset : 'button.reset-filter',
    //            filter_cssFilter : 'tablesorter-filter', 
    //            filter_functions : {
    //              1 : true
    //            }
    //        } 
    //    })
    //    .tablesorterPager({
    //        container: $("#pager"),
    //        size: 30,
    //        removeRows: false,
    //        positionFixed: false
    //    });
    //}


$("#chart1").chart({
 template : "pie_basic_2",
 values : {
  serie1 : [22, 67, 33, 83],
  serie2 : [76, 41, 77, 72]
 },
 labels : ["a", "b", "c", "d"],
 tooltips : {
  serie1 : ["a", "b", "c", "d"],
  serie2 : ["a", "b", "c", "d"]
 },
 defaultSeries : {
  values : [{
   plotProps : {
    fill : "red"
   }
  }, {
   plotProps : {
    fill : "blue"
   }
  }, {
   plotProps : {
    fill : "green"
   }
  }, {
   plotProps : {
    fill : "gray"
   }
  }]
 }
});


  //g = new Dygraph(

  //  // containing div
  //  document.getElementById("graphdiv"),

  //  // CSV or path to a CSV file.
  //  "Date,Temperature\n" +
  //  "2008-05-07,75\n" +
  //  "2008-05-08,70\n" +
  //  "2008-05-09,80\n"

  //);

//g = new Dygraph(
//
//    // containing div
//    document.getElementById("graphdiv"),
//
//    // CSV or path to a CSV file.
//    "Date,Temperature\n"+
//    "2008-05-07,75\n"+
//    "2008-05-08,70\n"+
//    "2008-05-09,80\n"
//
//  );

g2 = new Dygraph(
    document.getElementById("graphdiv2"),

    //gon.test_csv, 

    "Date,High,Low\n"+
    "2007-01-01T00:00:00,62,9\n"+
    "2007-01-01T01:00:00,62,38\n"+
    "2007-01-01T02:00:00,NaN,7\n"+
    "2007-01-01T03:00:00,5,7\n"+
    "2007-01-01T04:00:00,6,35\n"+
    "2007-01-01T05:00:00,67,3\n",


    //".ytemperatures.csv", // path to CSV file
    {
      //rollPeriod: 7,
      //showRoller: true
    }
  );

//g3 = new Dygraph(
//    document.getElementById("graphdiv3"),
//    "temperatures.csv",
//    {
//      rollPeriod: 7,
//      showRoller: true
//    }
//  );


})

$.elycharts.templates['pie_basic_2'] = {
  type: "pie",
  style: {
    "background-color": "black"
  },
  defaultSeries: {
    plotProps: {
      stroke: "black",
      "stroke-width": 2,
      opacity: 0.6
    },
    highlight: {
      newProps: {
        opacity: 1
      }
    },
    tooltip: {
      frameProps: {
        opacity: 0.8
      }
    },
    label: {
      active: true,
      props: {
        fill: "white"
      }
    },
    startAnimation: {
      active: true,
      type: "avg"
    }
  }
};



//$("#chart1").chart({
// type : "line",
// labels : ["a", "b", "c", "d"],
// tooltips : {
//  serie1 : ["a", "b", "c", "d"],
//  serie2 : ["a", "b", "c", "d"]
// },
// values : {
//  serie1 : [79, 20, 0, 99],
//  serie2 : [75, 82, 54, 23]
// },
// margins : [10, 10, 20, 50],
// series : {
//  serie1 : {
//   color : "red"
//  },
//  serie2 : {
//   color : "purple"
//  }
// },
// defaultAxis : {
//  labels : true
// },
// features : {
//  grid : {
//   draw : true,
//   forceBorder : true
//  }
// }
//});




$("#make-glaph-button").click(function() {
    $(".access-loader").css({"display":"inline"});
    $(this).val("making glaph...");
    $(this).css({"background-color":"grey", "border-color":"grey"});
    $(this).attr('disabled', true);
    $(this).closest('form').submit(); //for chrome
});

