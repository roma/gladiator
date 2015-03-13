$(window).load(function() {

    // pie chart
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


    g2 = new Dygraph(
        document.getElementById("graphdiv2"),
    
        gon.test_csv, 
    
        //"Date,High,Low,Inter\n"+
        //"2007-01-01T00:00:00,62,9,54\n"+
        //"2007-01-01T01:00:00,null,38,11\n"+
        //"2007-01-01T02:00:00,45,7,90\n"+
        //"2007-01-01T03:00:00,5,,34\n"+
        //"2007-01-01T04:00:00,6,35,88\n"+
        //"2007-01-01T05:00:00,67,3,78\n",
    
        {
            labels: ['x', 'instanceA', 'instanceB', 'instanceC' ],
            connectSeparatedPoints: true,
            drawPoints: true
        }
    );

})

//pie glaph
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

$("#make-glaph-button").click(function() {
    $(".access-loader").css({"display":"inline"});
    $(this).val("making glaph...");
    $(this).css({"background-color":"grey", "border-color":"grey"});
    $(this).attr('disabled', true);
    $(this).closest('form').submit(); //for chrome
});

