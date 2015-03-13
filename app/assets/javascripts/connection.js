$(window).load(function() {

    // pie chart initialize
    $("#pie-chart").chart({
     template : "pie_basic_1",
     values : {
      //serie1 : [17, 51, 61, 30]
      serie1 : gon.source_count
     },
     labels : gon.source_label,
     legend : gon.source_label,
     tooltips : {
      serie1 : gon.source_count
     },
     //labels : ["a", "b", "c", "d"],
     //legend : ["a", "b", "c", "d"],
     //tooltips : {
     // serie1 : ["a", "b", "c", "d"]
     //},
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

    //$("#pie-chart").chart({
    // template : "pie_basic_2",
    // values : {
    //  serie1 : [22, 67, 33, 83],
    //  serie2 : [76, 41, 77, 72]
    // },
    // labels : ["a", "b", "c", "d"],
    // tooltips : {
    //  serie1 : ["a", "b", "c", "d"],
    //  serie2 : ["a", "b", "c", "d"]
    // },
    // defaultSeries : {
    //  values : [{
    //   plotProps : {
    //    fill : "red"
    //   }
    //  }, {
    //   plotProps : {
    //    fill : "blue"
    //   }
    //  }, {
    //   plotProps : {
    //    fill : "green"
    //   }
    //  }, {
    //   plotProps : {
    //    fill : "gray"
    //   }
    //  }]
    // }
    //});

    //line chart 
    g = new Dygraph(
        document.getElementById("line-chart"),
        gon.connection_count, 
        {
            labels: gon.connection_label,
            labelsDiv:document.getElementById("label-position"),
            labelsSeparateLines: true,
            showRangeSelector: true,
            highlightSeriesOpts: {
                strokeWidth: 3,
                strokeBorderWidth: 1,
                highlightCircleSize: 5
            },
            connectSeparatedPoints: true,
            drawPoints: true
        }
    );

    var makeClickCallback = function(graph) {
        var isLocked = false;
        return function(ev) {
            if (isLocked) {
              graph.clearSelection();
              isLocked = false;
            } else {
              graph.setSelection(graph.getSelection(), graph.getHighlightSeries(), true);
              isLocked = true;
            }
        };
    };

g.updateOptions({clickCallback: makeClickCallback(g)}, true);
})



//pie chart
$.elycharts.templates['pie_basic_1'] = {
  type: "pie",
  defaultSeries: {
    plotProps: {
      stroke: "white",
      "stroke-width": 2,
      opacity: 0.8
    },
    highlight: {
      move: 20
    },
    tooltip: {
      frameProps: {
        opacity: 0.5
      }
    },
    startAnimation: {
      active: true,
      type: "grow"
    }
  },
  features: {
    legend: {
      horizontal: false,
      width: 200,
      //height: 25 * gon.source_label.length,
      height: 100,
      x: 600,
      y: 100,
      borderProps: {
        "fill-opacity": 0.3
      }
    }
  }
};

//$.elycharts.templates['pie_basic_2'] = {
//  type: "pie",
//  style: {
//    "background-color": "black"
//  },
//  defaultSeries: {
//    plotProps: {
//      stroke: "black",
//      "stroke-width": 2,
//      opacity: 0.6
//    },
//    highlight: {
//      newProps: {
//        opacity: 1
//      }
//    },
//    tooltip: {
//      frameProps: {
//        opacity: 0.8
//      }
//    },
//    label: {
//      active: true,
//      props: {
//        fill: "white"
//      }
//    },
//    startAnimation: {
//      active: true,
//      type: "avg"
//    }
//  }
//};

//submit button
$("#make-glaph-button").click(function() {
    $(".access-loader").css({"display":"inline"});
    $(this).val("making glaph...");
    $(this).css({"background-color":"grey", "border-color":"grey"});
    $(this).attr('disabled', true);
    $(this).closest('form').submit(); //for chrome
});

