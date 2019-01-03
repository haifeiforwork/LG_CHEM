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

    <div id="chart1" style="margin-top:20px; margin-left:20px; width:460px; height:300px;"></div>
    
    <pre class="code brush:js"></pre>
 
    <div id="chart2" style="margin-top:20px; margin-left:20px; width:460px; height:300px;"></div>
    
    <pre class="code brush:js"></pre>

    <div id="chart3" style="margin-top:20px; margin-left:20px; width:460px; height:300px;"></div>
    <pre class="code brush:js"></pre>
  
    <div id="chart4" style="margin-top:20px; margin-left:20px; width:460px; height:300px;"></div>
    <pre class="code brush:js"></pre>

    <div id="chart5" style="margin-top:20px; margin-left:20px; width:460px; height:300px;"></div>
    <pre class="code brush:js"></pre>

    <div id="chart6" style="margin-top:20px; margin-left:20px; width:460px; height:300px;"></div>
    <pre class="code brush:js"></pre>

    <div id="chart7" style="margin-top:20px; margin-left:20px; width:460px; height:300px;"></div>
    <pre class="code brush:js"></pre>

    <div id="chart8" style="margin-top:20px; margin-left:20px; width:460px; height:300px;"></div>
    <pre class="code brush:js"></pre>

    <div id="chart9" style="margin-top:20px; margin-left:20px; width:460px; height:300px;"></div>
    <pre class="code brush:js"></pre>

    <div id="chart10" style="margin-top:20px; margin-left:20px; width:460px; height:300px;"></div>
    <pre class="code brush:js"></pre>

<script class="code" type="text/javascript">$(document).ready(function(){
    jQuery.jqplot.config.enablePlugins = true;
    plot1 = jQuery.jqplot('chart1', 
        [[['Verwerkende FruedenStunde Companaziert Eine industrie', 9],['Retail', 8], ['Primaire producent', 7], 
        ['Out of home', 6],['Groothandel', 5], ['Grondstof', 4], ['Consument', 3], ['Bewerkende industrie', 2]]], 
        {
            title: "<div style='color:blue'>조직 통계</div> ", 
            seriesDefaults: {
        shadow: true, 
        renderer: jQuery.jqplot.PieRenderer, 
        rendererOptions: { padding: 2, sliceMargin: 1, showDataLabels: false } 
      }, 
            legend: { show:true, location: 'e' }
        }
    );
});
</script>


<script class="code" type="text/javascript">$(document).ready(function(){
  plot2 = jQuery.jqplot('chart2', 
    [[['Verwerkende industrie', 9],['Retail', 0], ['Primaire producent', 0], 
    ['Out of home', 0],['Groothandel', 0], ['Grondstof', 0], ['Consument', 3], ['Bewerkende industrie', 2]]], 
    {
      title: ' ', 
      seriesDefaults: {
        shadow: false, 
        renderer: jQuery.jqplot.PieRenderer, 
        rendererOptions: { 
          startAngle: 180, 
          sliceMargin: 4, 
          showDataLabels: true } 
      }, 
      legend: { show:true, location: 'w' }
    }
  );
});
</script>

<script class="code" type="text/javascript">$(document).ready(function(){
  plot3 = jQuery.jqplot('chart3', 
    [[['Verwerkende industrie', 9],['Retail', 0], ['Primaire producent', 0], 
    ['Out of home', 0],['Groothandel', 0], ['Grondstof', 0], ['Consument', 0], ['Bewerkende industrie', 2]]], 
    {
      title: ' ', 
      seriesDefaults: {
        shadow: false, 
        renderer: jQuery.jqplot.PieRenderer, 
        rendererOptions: { 
          sliceMargin: 4, 
          showDataLabels: true 
        } 
      }, 
      legend: { show:true, location: 'e' }
    }
  );

  
});
</script>

<script class="code" type="text/javascript">$(document).ready(function(){
  plot4 = jQuery.jqplot('chart4', 
    [[['Verwerkende industrie', 30],['Retail', 0], ['Primaire producent', 0], 
    ['Out of home', 0],['Groothandel', 0], ['Grondstof', 0], ['Consument', 0], ['Bewerkende industrie', 1]]], 
    {
      title: ' ', 
      seriesDefaults: {shadow: false, renderer: jQuery.jqplot.PieRenderer, rendererOptions: { sliceMargin: 4, showDataLabels: true } }, 
      legend: { show:true, location: 'e' }
    }
  );

  
});
</script>

<script class="code" type="text/javascript">$(document).ready(function(){
  plot5 = jQuery.jqplot('chart5', 
    [[['Verwerkende industrie', 100],['Retail', 0], ['Primaire producent', 0], 
    ['Out of home', 0],['Groothandel', 0], ['Grondstof', 0], ['Consument', 0], ['Bewerkende industrie', 1]]], 
    {
      title: ' ', 
      seriesDefaults: {shadow: false, renderer: jQuery.jqplot.PieRenderer, rendererOptions: { sliceMargin: 4, showDataLabels: true } }, 
      legend: { show:true }
    }
  );
});
</script>

<script class="code" type="text/javascript">$(document).ready(function(){
  plot6 = jQuery.jqplot('chart6', 
    [[['Verwerkende industrie', 100]]], 
    {
      title: ' ', 
      seriesDefaults: {shadow: false, renderer: jQuery.jqplot.PieRenderer, rendererOptions: { sliceMargin: 4, showDataLabels: true } }, 
      legend: { show:true }
    }
  );
});
</script>

<script class="code" type="text/javascript">$(document).ready(function(){
  jQuery.jqplot.config.enablePlugins = true;
  plot7 = jQuery.jqplot('chart7', 
    [[['Verwerkende industrie', 9],['Retail', 8], ['Primaire producent', 7], 
    ['Out of home', 6],['Groothandel', 5], ['Grondstof', 4], ['Consument', 3], ['Bewerkende industrie', 2]]], 
    {
      title: ' ', 
      seriesDefaults: {shadow: true, renderer: jQuery.jqplot.PieRenderer, rendererOptions: { showDataLabels: true } }, 
      legend: { show:true }
    }
  );
});
</script>

<script class="code" type="text/javascript">$(document).ready(function(){
  plot8 = jQuery.jqplot('chart8', 
    [[['Verwerkende industrie', 100],['Retail', 0], ['Primaire producent', 0], 
    ['Out of home', 0],['Groothandel', 0], ['Grondstof', 0], ['Consument', 0], ['Bewerkende industrie', 1]]], 
    {
      title: ' ', 
      seriesDefaults: {shadow: true, renderer: jQuery.jqplot.PieRenderer, rendererOptions: { showDataLabels: true } }, 
      legend: { show:true }
    }
  );
});
</script>

<script class="code" type="text/javascript">$(document).ready(function(){
  jQuery.jqplot.config.enablePlugins = true;
  plot9 = jQuery.jqplot('chart9', 
    [[['Verwerkende industrie', 9],['Retail', 8], ['Primaire producent', 7], 
    ['Out of home', 6],['Groothandel', 5], ['Grondstof', 4], ['Consument', 3], ['Bewerkende industrie', 2]]], 
    {
      title: ' ', 
      seriesDefaults: {shadow: true, renderer: jQuery.jqplot.PieRenderer, rendererOptions: { 
          fill: false, 
          sliceMargin: 4, 
          showDataLabels: true 
          } 
      }, 
      legend: { show:true }
    }
  );
});
</script>

<script class="code" type="text/javascript">$(document).ready(function(){
  plot10 = jQuery.jqplot('chart10', 
    [[['Verwerkende industrie', 100],['Retail', 0], ['Primaire producent', 0], 
    ['Out of home', 0],['Groothandel', 0], ['Grondstof', 0], ['Consument', 0], ['Bewerkende industrie', 1]]], 
    {
      title: ' ', 
      seriesDefaults: {shadow: true, renderer: jQuery.jqplot.PieRenderer, rendererOptions: { 
          fill: false, 
          sliceMargin: 4, 
          showDataLabels: true 
        } 
      }, 
      legend: { show:true }
    }
  );
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

  <script class="include" type="text/javascript" src="<%= WebUtil.ImageURL %>js/jqplot_js/plugins/jqplot.pieRenderer.min.js"></script>

<!-- End additional plugins -->

        </div>
         
               </div>
    </div>
    <script type="text/javascript" src="<%= WebUtil.ImageURL %>js/jqplot_js/example.min.js"></script>

</body>


</html>
