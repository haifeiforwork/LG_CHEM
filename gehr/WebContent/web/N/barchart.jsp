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
    
   <script language="javascript" type="text/javascript" src="<%= WebUtil.ImageURL %>js/jqplot_js/excanvas.js"></script>
    
    <script class="include" type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>
    <STYLE type=text/css> #chart3 .jqplot-point-label  {        padding: 1px 3px;   } </STYLE>
   
   <style type="text/css">
    
    .totalSum  {
        font-size: 1.2em;
        margin-top: -25px; 
    }
    .jqplot-yaxis-tick {
      white-space: nowrap;
    }
    
    
  </style>
</head>
<body>
    
    <div class="">
      <div class="colleft">
        <div class="col1" id="example-content">

  
<!-- Example scripts go here -->


	<div style="width:800px;text-align:center"> 조직통계 </div>
   <style type="text/css">
    
    .note {
        font-size: 0.8em;
    }
    .jqplot-yaxis-tick {
      white-space: nowrap;
    }
    
    
  </style>
        
    

    
    
    <div id="chart3" style="width:780px; height:400px;"></div>

 
 
 

<script  type="text/javascript">
$(document).ready(function(){
 var s1 = [178, 279, 379]	
	
	var s2 = [244, 234, 222]	
	
	var s3 = [233,333, 343]	
	
	var s4 = [0, 0, 0]	
	
	var s5 = [0, 0, 0]	
  
  
  
  
  var pLabels1 = []; // arrays for each inner label
  var pLabels2 = [];
  var pLabels3 = [];
  var pLabels4 = [];
  var pLabelsTotal = []; // array of totals above each column
  for (var i = 0; i < s1.length; i++){
      pLabels1.push(s1[i]);
      pLabels2.push('<a href="http://www.daum.net"><div style="border:1px solid red">'+s2[i]+'</div></a>');
      //pLabels2.push(s2[i]);
      pLabels3.push(s3[i]);
      pLabels4.push(s4[i]);
      pLabelsTotal.push('<div class="totalSum">'+(s1[i]+s2[i]+s3[i]+s4[i]) +'</div>');      
  }   
   
  var ticks = ['13년말','14년말','15.5.31'];
  plot3 = $.jqplot('chart3', [s1, s2, s3, s4,s5], {
    animate: true,
    // Tell the plot to stack the bars.
    //stack 에 막대그래프 중간중간 칸을 넣는다.
    stackSeries: true,
    /*a마우스 오른쪽 클릭할경우 저장이 안됨*/
    //captureRightClick: true,
     cursor: {
                show: true,
                zoom: true,
                showTooltip: true
            },
    seriesDefaults:{
      renderer:$.jqplot.BarRenderer,
      
      //pointLabels: {show: true },
      // labels:['fourteen', 'thirty two', 'fourty one', 'fourty four', 'fourty'] 
      //pointLabels: {show: true , stackedValue: true},
      // pointLabels: {show: true , labelsFromSeries:true},
      //pointLabels: {show: true , labels:['37', '29', '16', 30', '11'] },
     
      rendererOptions: {
          // Put a 30 pixel margin between bars.
          barMargin:150,
          // Highlight bars when mouse button pressed.
          // Disables default highlighting on mouse over.
          /* bar를 마우스로 선택하고 클릭해야만 색깔이 흐려진다. */
          highlightMouseDown: true    
      }
      
    },
     series:[
            
            {
            	label:'임원',
	            pointLabels:{
	            	
	                show:true,
	                labels:pLabels1,
	                ypadding: -25,
	                escapeHTML:false
	            }
            }
            ,
            {
                label: '간부',
	            pointLabels:{
	                show:true,
	                labels:pLabels2,
	                ypadding: -25,
	                escapeHTML:false
	            	}
            }
            ,
            {
                label: '사원',
	            pointLabels:{
	                show:true,
	                labels:pLabels3,
	                ypadding:-25,
	                escapeHTML:false
	            }
            }
            ,
            {
                label: '현장',            
	            pointLabels:{
	                show:true,
	                labels:pLabels4,
	                ypadding: -25,
	                escapeHTML:false
            	}
            },
            {
	            //label: '총계',            
	            showLabel:false, //legend에 보여주지 않기 위해 설정한다.
	            pointLabels:{
	                show:true,
	                labels:pLabelsTotal,
	                ypadding: -25,
	                escapeHTML:false
	            }
        	}
             //{pointLabels: {show: true , labels:['37', '29', '16'] }}
        ],
    axes: {
      xaxis: {
          renderer: $.jqplot.CategoryAxisRenderer,
            ticks: ticks
      },
      yaxis: {
        // Don't pad out the bottom of the data range.  By default,
        // axes scaled as if data extended 10% above and below the
        // actual range to prevent data points right on grid boundaries.
        // Don't want to do that here.
       padMin: 0,
        min: 0
      }
    },
    legend: {
      show: true,
      rendererOptions: {
       //numberColumns:2
    	},
      
      location: 'ne',
      placement: 'inside'
    }      
  });
  // Bind a listener to the "jqplotDataClick" event.  Here, simply change
  // the text of the info3 element to show what series and ponit were
  // clicked along with the data for that point.
  $('#chart3').bind('jqplotDataClick', 
    function (ev, seriesIndex, pointIndex, data) {
      $('#info3').html('series: '+seriesIndex+', point: '+pointIndex+', data: '+data);
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

  <script class="include" language="javascript" type="text/javascript" src="<%= WebUtil.ImageURL %>js/jqplot_js/plugins/jqplot.barRenderer.min.js"></script>
    <script class="include" language="javascript" type="text/javascript" src="<%= WebUtil.ImageURL %>js/jqplot_js/plugins/jqplot.categoryAxisRenderer.min.js"></script>
    <script class="include" language="javascript" type="text/javascript" src="<%= WebUtil.ImageURL %>js/jqplot_js/plugins/jqplot.pointLabels.min.js"></script>

 
<!-- End additional plugins -->

        </div>
         
               </div>
    </div>
    <script type="text/javascript" src="<%= WebUtil.ImageURL %>js/jqplot_js/example.min.js"></script>

</body>


</html>
