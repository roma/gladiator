$(window).load(function() {
    if (gon.connection_count) {
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

        // pie chart
        var r = Raphael("pie-chart",640,480);
        var pieData= gon.source_count;
        var pieLegends = gon.source_label;
        var pie = r.piechart( 320, 240, 150, pieData, { legend:pieLegends });
        pie.hover( function(){
            /* on mouse over */
            this.sector.animate({scale:[1.1, 1.1, this.cx, this.cy]},50,"linear");
            /*
             * animate legends text and mark.
             * - label[0] : circle next to text
             * - label[1] : legend text
             */
            //this.label[0].animate({scale:[1.2,1.2]},50,"linear");
            this.label[0].attr({"stroke-width":"1", "stroke":"red"});
            this.label[1].attr({"font-weight":"bold","fill":"red"});
            /* display popup */
            //this.flag = r.g.popup(this.sector.middle.x, this.sector.middle.y, 
            //this.label[1].node.textContent );

        }, function(){
            /* on mouse out */
            this.sector.animate({scale:[1, 1, this.cx, this.cy]},200,"linear");
            this.label[0].animate({scale:[1,1]},100,"linear");
            this.label[0].attr({"stroke-width":0});
            this.label[1].attr({"font-weight":"normal","fill":"#999999"});
            //this.flag.animate({opacity:0},200,function(){ this.remove(); });
        } );
    }
})

//submit button
$("#make-graph-button").click(function() {
    $(".access-loader").css({"display":"inline"});
    $(this).val("making graph...");
    $(this).css({"background-color":"grey", "border-color":"grey"});
    $(this).attr('disabled', true);
    $(this).closest('form').submit(); //for chrome
});

