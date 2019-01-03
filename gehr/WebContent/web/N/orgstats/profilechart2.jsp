<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.util.*,java.net.*" %>
<%@ page import="com.sns.jdf.*" %>
<%@ page import="com.sns.jdf.util.*"%>


<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=9" />
    <title>Pie Charts and Options 2</title>

<%@ include file="/web/common/jqPlotScriptAll.jsp" %>
</head>


<body>

     <div class="">
      <div class="colleft">
        <div class="col1" id="example-content">

  
<!-- Example scripts go here -->

<p>Data renderers allow jqPlot to pull data from any external source (e.g. a function implementing an AJAX call).  Simply assign the external source to the "dataRenderer" plot option.  The only requirement on data renderers is that it must return a valid jqPlot data array.</p>

<div id="chart1" style="height:300px; width:500px;"></div>

<pre class="code brush: js"></pre>


<div id="chart2" style="height:300px; width:500px;"></div>

<pre class="code brush: js"></pre>


<script class="code" type="text/javascript">
$(document).ready(function () {
    var s1 = [[2002, 112000], [2003, 122000], [2004, 104000], [2005, 99000], [2006, 121000], 
    [2007, 148000], [2008, 114000], [2009, 133000], [2010, 161000], [2011, 173000]];
    var s2 = [[2002, 10200], [2003, 10800], [2004, 11200], [2005, 11800], [2006, 12400], 
    [2007, 12800], [2008, 13200], [2009, 12600], [2010, 13100]];
 
    plot1 = $.jqplot("chart1", [s2, s1], {
        // Turns on animatino for all series in this plot.
        animate: true,
        // Will animate plot on calls to plot1.replot({resetAxes:true})
        animateReplot: true,
        cursor: {
            show: true,
            zoom: true,
            looseZoom: true,
            showTooltip: false
        },
        series:[
            {
                pointLabels: {
                    show: true
                },
                renderer: $.jqplot.BarRenderer,
                showHighlight: false,
                yaxis: 'y2axis',
                rendererOptions: {
                    // Speed up the animation a little bit.
                    // This is a number of milliseconds.  
                    // Default for bar series is 3000.  
                    animation: {
                        speed: 2500
                    },
                    barWidth: 15,
                    barPadding: -15,
                    barMargin: 0,
                    highlightMouseOver: false
                }
            }, 
            {
                rendererOptions: {
                    // speed up the animation a little bit.
                    // This is a number of milliseconds.
                    // Default for a line series is 2500.
                    animation: {
                        speed: 2000
                    }
                }
            }
        ],
        axesDefaults: {
            pad: 0
        },
        axes: {
            // These options will set up the x axis like a category axis.
            xaxis: {
                tickInterval: 1,
                drawMajorGridlines: false,
                drawMinorGridlines: true,
                drawMajorTickMarks: false,
                rendererOptions: {
                tickInset: 0.5,
                minorTicks: 1
            }
            },
            yaxis: {
                tickOptions: {
                    formatString: "$%'d"
                },
                rendererOptions: {
                    forceTickAt0: true
                }
            },
            y2axis: {
                tickOptions: {
                    formatString: "$%'d"
                },
                rendererOptions: {
                    // align the ticks on the y2 axis with the y axis.
                    alignTicks: true,
                    forceTickAt0: true
                }
            }
        },
        highlighter: {
            show: true, 
            showLabel: true, 
            tooltipAxes: 'y',
            sizeAdjust: 7.5 , tooltipLocation : 'ne'
        }
    });
   
});

</script>

  
<script class="code" type="text/javascript">
$(document).ready(function(){
	  var line1 = [14, 32, 41, 44, 40, 47, 53, 67];
	  var plot1 = $.jqplot('chart1', [line1], {
	      title: 'Chart with Point Labels', 
	      seriesDefaults: { 
	        showMarker:false,
	        pointLabels: { show:true } 
	      }
	  });
	});

</script>
<!-- End example scripts -->


        </div>
         
               </div>
    </div>
   

</body>


</html>
