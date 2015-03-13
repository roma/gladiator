$(window).load(function() {

    // pie chart initialize
    $("#pie-chart").chart({
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

    //line chart 
    g = new Dygraph(
        document.getElementById("line-chart"),
        gon.connection_count, 
        {
            labels: gon.label,
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

//submit button
$("#make-glaph-button").click(function() {
    $(".access-loader").css({"display":"inline"});
    $(this).val("making glaph...");
    $(this).css({"background-color":"grey", "border-color":"grey"});
    $(this).attr('disabled', true);
    $(this).closest('form').submit(); //for chrome
});

