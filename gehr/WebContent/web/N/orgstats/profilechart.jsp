<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.util.*,java.net.*" %>
<%@ page import="com.sns.jdf.*" %>
<%@ page import="com.sns.jdf.util.*"%>
<%@ include file="/web/common/jqPlotScriptAll.jsp" %>

<%



%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=9" />
    <title>Pie Charts and Options 2</title>   
<script class="code" type="text/javascript">
$(document).ready(function(){
  var line1 = [[1,3],[3,2],[2,1]];
  var ticks = ['下', '中', '上'];
  var plot1 = $.jqplot('chart1', [line1], {
	  //animate: true,//동적으로
	  showMarker: true,
	  //animateReplot: true,//?
	  cursor: {//커서가 변함
          show: true,
          //zoom: true,
         // looseZoom: true,
          showTooltip: true
      },
      title: '성과/리더십', 
      seriesDefaults: {renderer: $.jqplot.BarRenderer},
      series:[
       {pointLabels:{
         show: true,
         labels:['2013', '2014', '2015']
       }}],
     
            
            
            
            
            axesDefaults: {
                pad: 1
            },
      //axesDefaults: {//?
      //    pad: 0.5
      //},
      axes: {
                // These options will set up the x axis like a category axis.
                
                xaxis: {
                	label: '리더십',
                    tickInterval: 1,
                    drawMajorGridlines: true,
                    drawMinorGridlines: false,
                    drawMajorTickMarks: true,
                    rendererOptions: {
	                    tickInset: 1,
	                    //minorTicks: 1
                    },
                    renderer: $.jqplot.CategoryAxisRenderer,
                    ticks: ticks
                
               },
                yaxis: {
                	 label: '성과',
                	 tickInterval: 1,
                     drawMajorGridlines: true,
                     drawMinorGridlines: true,
                     drawMajorTickMarks: true,
                     renderer: $.jqplot.CategoryAxisRenderer,
                     ticks: ticks
                }
            },
      seriesDefaults: { 
        showMarker:false,
        pointLabels: { show:true } 
      }
  });
});


$(document).ready(function(){
	  var line1 = [[1,1],[2,3],[3,1]];
	  var ticks = ['&nbsp;', '&nbsp;', '&nbsp;'];
	  var ticks2 = ['&nbsp;','&nbsp;','&nbsp;'];
	  var plot1 = $.jqplot('chart2', [line1], {
		  animate: true,//동적으로
		  showMarker: false,
		  animateReplot: true,//?
		  cursor: {//커서가 변함
	          show: true,
	          //zoom: true,
	          looseZoom: true,
	          showTooltip: false
	      },
	      title: 'Mission', 
	      seriesDefaults: {renderer: $.jqplot.BarRenderer},
	      series:[
	       {pointLabels:{
	          show: true,
	          labels:['2013', '2014', '2015']
	        }}],

	      //axesDefaults: {//?
	      //    pad: 0.5
	      //},
	      axes: {
	                // These options will set up the x axis like a category axis.
	                
	                xaxis: {
	                	label:'&nbsp;',
	                    tickInterval: 1,
	                    drawMajorGridlines: true,
	                    drawMinorGridlines: false,
	                    drawMajorTickMarks: true,
	                    renderer: $.jqplot.CategoryAxisRenderer,
	                     ticks: ticks2
	                
	               },
	                yaxis: {
	                	 tickInterval: 1,
	                     drawMajorGridlines: true,
	                     drawMinorGridlines: true,
	                     drawMajorTickMarks: true,
	                     renderer: $.jqplot.CategoryAxisRenderer,
	                     ticks: ticks
	                }
	            },
	      seriesDefaults: { 
	        showMarker:false,
	        pointLabels: { show:true } 
	      }
	  });
	});
</script>   
</head>
<body>
    
    <div class="">
      <div class="colleft">
        <div class="col1" id="example-content">

  
<!-- Example scripts go here -->

    <!-- <div id="chart1" style="width:300px; height:300px;display:inline-block;"></div> --> 
    <div id="chart2" style="width:100px; height:300px;display:inline-block;" ></div>






        </div>  
    	</div>
    </div>

</body>


</html>
