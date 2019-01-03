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
        
    <div id="chart1" style="width:800px; height:350px;"></div>

    <pre class="code brush: js"></pre>

    <div id="chart2" style="width:400px; height:300px;"></div>

    <pre class="code brush: js"></pre>

    <p class="text">Click on a bar in the plot below to update the text box.</p>
    <p class="text">You Clicked: 
    <span id="info3">Nothing yet.</span>
    </p>
    <div id="chart3" style="width:600px; height:400px;"></div>

    <pre class="code brush: js"></pre>
 <div id="chart4" style="width:600px; height:400px;"></div>
  <script class="code" type="text/javascript">
$(document).ready(function(){
	/* 5개 직급에 따른  구분   
                [ 1,    2,     3,    4,    5    ]	
	*/
    var s1 = [200, 600, 700, 1000,1200]; /*기본급 */
    var s2 = [460, 210, 690, 820,1500];  /* 상여 */
    var s3 = [-26, 240, 320, 600,1600];  /* 퇴직금 */
  
  
    
    // Can specify a custom tick Array.
    // Ticks should match up one for each y value (category) in the series.
    
    /* x축에 표시된 ticks */
    var ticks = ['사원','대리', '과장','차장', '부장']; 
    
    var plot1 = $.jqplot('chart1', [s1, s2, s3], {
        // The "seriesDefaults" option is an options object that will
        // be applied to all series in the chart.
        // stackSeries: true,
    /*기본적인 그래프의  크기조정 */ 
    width: 800,      
        seriesDefaults:{
            renderer:$.jqplot.BarRenderer,
            
            /* 기본적으로 - 값이 존재할경우 0 부터 그래프를 그린다....*/
            rendererOptions: {fillToZero: true},
            pointLabels: { show: true, location: 'n', edgeTolerance: -15 },
        },
        
        
        // Custom labels for the series are specified with the "label"
        // option on the series option.  Here a series option object
        // is specified for each series.
        
        /* 기본적인 바의 이름 legend속성값으로 표시된다. */
        series:[
            {label:'기본급'},
            {label:'상여'},
            {label:'퇴직금'}
        ],
        
        // Show the legend and put it outside the grid, but inside the
        // plot container, shrinking the grid to accomodate the legend.
        // A value of "outside" would not shrink the grid and allow
        // the legend to overflow the container.
        
        /* 범례 */
        legend: {
            show: true,
            placement: 'outsideGrid'
        },
        
        axes: {
            // Use a category axis on the x axis and use our custom ticks.
            xaxis: {
                renderer: $.jqplot.CategoryAxisRenderer,
                /* x축에 해당하는 좌표구분명 : 상위에 배열로 정의 */
                ticks: ticks
            },
            // Pad the y axis just a little so bars can get close to, but
            // not touch, the grid boundaries.  1.2 is the default padding.
            yaxis: {
                pad: 1.05,
                tickOptions: {formatString: "%'d만원"}
            }
        }
    });
});
  </script>
  

<script class="code" type="text/javascript">
$(document).ready(function(){
    // For horizontal bar charts, x an y values must will be "flipped"
    // from their vertical bar counterpart.
    //세로로 읽는다.[2,1] [5,1],[4,1] 이 첫번째 그래프
   
    var plot2 = $.jqplot('chart2', [
        [[2,1], [4,2], [6,3], [3,4]], 
        [[5,1], [1,2], [3,3], [4,4]], 
        [[4,1], [7,2], [1,3], [2,4]]], {
        seriesDefaults: {
            renderer:$.jqplot.BarRenderer,
            // Show point labels to the right ('e'ast) of each bar.
            // edgeTolerance of -15 allows labels flow outside the grid
            // up to 15 pixels.  If they flow out more than that, they 
            // will be hidden.
            pointLabels: { show: true, location: 'e', edgeTolerance: 5 },
            // Rotate the bar shadow as if bar is lit from top right.
            /* 그림자 각도 */
            shadowAngle: 135,
            // Here's where we tell the chart it is oriented horizontally.
            rendererOptions: {
                barDirection: 'horizontal'
            }
        },
         axes: {
            yaxis: {
                renderer: $.jqplot.CategoryAxisRenderer
            }
        }
    });
});
</script>

<script class="code" type="text/javascript">
$(document).ready(function(){
  var s1 = [2, 6, 7, 10,2];
  var s2 = [7, 5, 3, 4,1];
  var s3 = [14, 9, 3, 8,7];
  var s4 = [14, 9, 3, 8,1];
  
  var s5 = [0, 0, 0, 0,0]; 
  
  
  
  
  var pLabels1 = []; // arrays for each inner label
  var pLabels2 = [];
  var pLabels3 = [];
  var pLabels4 = [];
  var pLabelsTotal = []; // array of totals above each column
  for (var i = 0; i < s1.length; i++){
      pLabels1.push(s1[i]);
      //pLabels2.push('<div style="border:1px solid gray">'+s2[i]+'</div>');
      pLabels2.push(s2[i]);
      pLabels3.push(s3[i]);
      pLabels4.push(s4[i]);
      pLabelsTotal.push('<div class="totalSum">'+(s1[i]+s2[i]+s3[i]+s4[i]) +'</div>');      
  }   
   
  var ticks = ['HR서비스팀','노경<br>담당','인사담당', '인재개발','총무팀'];
  plot3 = $.jqplot('chart3', [s1, s2, s3,s4,s5], {
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
          barMargin: 50,
          // Highlight bars when mouse button pressed.
          // Disables default highlighting on mouse over.
          /* bar를 마우스로 선택하고 클릭해야만 색깔이 흐려진다. */
          highlightMouseDown: true    
      }
      
    },
     series:[
            
            {
            	label:'대리',
	            pointLabels:{
	            	
	                show:true,
	                labels:pLabels1,
	                ypadding: -25,
	                escapeHTML:false
	            }
            }
            ,
            {
                label: '과장',
	            pointLabels:{
	                show:true,
	                labels:pLabels2,
	                ypadding: -25,
	                escapeHTML:false
	            	}
            }
            ,
            {
                label: '차장',
	            pointLabels:{
	                show:true,
	                labels:pLabels3,
	                ypadding:-25,
	                escapeHTML:false
	            }
            }
            ,
            {
                label: '부장',            
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
            // {pointLabels: {show: true , labels:['37', '29', '16', 30', '11'] }}
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
      
      location: 'e',
      placement: 'outside'
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
<script class="code" type="text/javascript">
$(document).ready(function(){
  var s1 = [5, 6];
  var s2 = [7, 5];
  var s3 = [14, 9];
  var s4 = [0, 0]; //empty series just for total labels

  var pLabels1 = []; // arrays for each inner label
  var pLabels2 = [];
  var pLabels3 = [];
  var pLabelsTotal = []; // array of totals above each column
  for (var i = 0; i < s1.length; i++){
      pLabels1.push('<div style="border:1px solid gray">'+s1[i]+'</div>');
      pLabels2.push('<div style="border:1px solid gray">'+s2[i]+'</div>');
      pLabels3.push('<div style="border:1px solid gray">'+s3[i]+'</div>');
      pLabelsTotal.push(s1[i]+s2[i]+s3[i]);      
  }   

  plot3 = $.jqplot('chart4', [s1, s2, s3, s4], {
    // Tell the plot to stack the bars.
    stackSeries: true,
    captureRightClick: true,
    seriesDefaults:{
      renderer:$.jqplot.BarRenderer,
      rendererOptions: {
          // Put a 30 pixel margin between bars.
          barMargin: 30,
          // Highlight bars when mouse button pressed.
          // Disables default highlighting on mouse over.
          highlightMouseDown: true   
      },
    },
    series:[
        {
            pointLabels:{
                show:true,
                labels:pLabels1,
                ypadding: -25,
                escapeHTML:false
            }
        },
        {
            pointLabels:{
                show:true,
                labels:pLabels2,
                ypadding: -25,
                escapeHTML:false
            }
        },
                {
            pointLabels:{
                show:true,
                labels:pLabels3,
                ypadding: -25,
                escapeHTML:false
            }
        },
              {
            pointLabels:{
                show:true,
                labels:pLabelsTotal,
                ypadding: 7,
                escapeHTML:false
            }
        }
    ],
    axes: {
      xaxis: {
          renderer: $.jqplot.CategoryAxisRenderer
      },
      yaxis: {
        padMin: 0,
        min: 0
      }
    },
    legend: {
      show: false,
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
