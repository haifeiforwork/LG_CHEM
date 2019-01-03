<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.util.*,java.net.*" %>
<%@ page import="com.sns.jdf.*" %>
<%@ page import="com.sns.jdf.util.*"%>


<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=9" />
    <title>Pie Charts and Options 2</title>

    <link class="include" rel="stylesheet" type="text/css" href="<%= WebUtil.ImageURL %>js/jqplot_css/jquery.jqplot.min.css" />
    <link rel="stylesheet" type="text/css" href="<%= WebUtil.ImageURL %>js/jqplot_css/examples.min.css" />
    <link type="text/css" rel="stylesheet" href="<%= WebUtil.ImageURL %>js/jqplot_css/syntaxhighlighter/styles/shCoreDefault.min.css" />
    <link type="text/css" rel="stylesheet" href="<%= WebUtil.ImageURL %>js/jqplot_css/syntaxhighlighter/styles/shThemejqPlot.min.css" />
    <!--  if lt IE 9 -->
    <script language="javascript" type="text/javascript" src="<%= WebUtil.ImageURL %>js/jqplot_js/excanvas.js"></script>
    <script class="include" type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>
    
   
</head>
<body>
    
    <div class="">
      <div class="colleft">
        <div class="col1" id="example-content">

  
<!-- Example scripts go here -->


<div style="width:700px;text-align:center"> 조직통계 </div>
<div class="example-plot" id="chart4"></div>  
    <style type="text/css">
      .jqplot-point-label {white-space: nowrap;}
    .jqplot-yaxis-label {font-size: 14pt;}
    .jqplot-yaxis-tick {font-size: 7pt;}

    div.jqplot-target {
        height: 400px;
        width: 750px;
        margin: 70px;
    }
    </style>
    
    

  
 <script class="code" type="text/javascript" language="javascript">
$(document).ready(function(){

    var line = [['Cup Holder Pinion Bob', 7], ['Generic Fog Lamp', 9], ['HDTV Receiver', 15], 
    ['8 Track Control Module', 12], [' Sludge Pump Fourier Modulator', 3], 
    ['Transcender/Spice Rack', 6], ['Hair Spray Danger Indicator', 18]];

    var line2 = [['Nickle', 28], ['Aluminum', 13], ['Xenon', 54], ['Silver', 47], 
    ['Sulfer', 16], ['Silicon', 14], ['Vanadium', 23]];

    var plot4 = $.jqplot('chart4', [line, line2], {
        title: 'Concern vs. Occurrance',
        
        series:[{renderer:$.jqplot.BarRenderer}, {xaxis:'x2axis', yaxis:'y2axis' }],
        axes: {
            xaxis: {
                renderer: $.jqplot.CategoryAxisRenderer,
                label: 'Warranty Concern',
                labelRenderer: $.jqplot.CanvasAxisLabelRenderer,
                tickRenderer: $.jqplot.CanvasAxisTickRenderer,
                tickOptions: {
                    angle: 30
                }
            },
            x2axis: {
                renderer: $.jqplot.CategoryAxisRenderer,
                label: 'Metal',
                labelRenderer: $.jqplot.CanvasAxisLabelRenderer,
                tickRenderer: $.jqplot.CanvasAxisTickRenderer,
                tickOptions: {
                    angle: 30
                }
            },
            yaxis: {
                autoscale:true,
                label: 'Occurance',
                labelRenderer: $.jqplot.CanvasAxisLabelRenderer,
                tickRenderer: $.jqplot.CanvasAxisTickRenderer,
                tickOptions: {
                    angle: 30
                }
            },
            y2axis: {
                autoscale:true,
                label: 'Number',
                labelRenderer: $.jqplot.CanvasAxisLabelRenderer,
                tickRenderer: $.jqplot.CanvasAxisTickRenderer,
                tickOptions: {
                    angle: 30
                }
            }
        }
    });
});
    </script>
  
<!-- End example scripts -->

<!-- Don't touch this! -->


    <script class="include" type="text/javascript" src="<%= WebUtil.ImageURL %>js/jqplot_js/jquery.jqplot.min.js"></script>
    <script type="text/javascript" src="<%= WebUtil.ImageURL %>js/jqplot_js/syntaxhighlighter/scripts/shCore.min.js"></script>
    <script type="text/javascript" src="<%= WebUtil.ImageURL %>js/jqplot_js/syntaxhighlighter/scripts/shBrushJScript.min.js"></script>
    <script type="text/javascript" src="<%= WebUtil.ImageURL %>js/jqplot_js/syntaxhighlighter/scripts/shBrushXml.min.js"></script>
<!-- End Don't touch this! -->

<!-- Additional plugins go here -->
   <script class="include" type="text/javascript" src="<%= WebUtil.ImageURL %>js/jqplot_js/plugins/jqplot.logAxisRenderer.min.js"></script>
    <script class="include" type="text/javascript" src="<%= WebUtil.ImageURL %>js/jqplot_js/plugins/jqplot.canvasTextRenderer.min.js"></script>
    <script class="include" type="text/javascript" src="<%= WebUtil.ImageURL %>js/jqplot_js/plugins/jqplot.canvasAxisLabelRenderer.min.js"></script>
    <script class="include" type="text/javascript" src="<%= WebUtil.ImageURL %>js/jqplot_js/plugins/jqplot.canvasAxisTickRenderer.min.js"></script>
    <script class="include" type="text/javascript" src="<%= WebUtil.ImageURL %>js/jqplot_js/plugins/jqplot.dateAxisRenderer.min.js"></script>
    <script class="include" type="text/javascript" src="<%= WebUtil.ImageURL %>js/jqplot_js/plugins/jqplot.categoryAxisRenderer.min.js"></script>
    <script class="include" type="text/javascript" src="<%= WebUtil.ImageURL %>js/jqplot_js/plugins/jqplot.barRenderer.min.js"></script>



  
 
<!-- End additional plugins -->

        </div>
         
               </div>
    </div>
    <script type="text/javascript" src="<%= WebUtil.ImageURL %>js/jqplot_js/example.min.js"></script>

</body>


</html>
