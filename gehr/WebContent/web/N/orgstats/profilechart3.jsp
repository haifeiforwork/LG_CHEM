<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	<title>Flot Examples: Series Types</title>
	<link href="<%= WebUtil.ImageURL %>flotcharts/examples.css" rel="stylesheet" type="text/css">
	<!--[if lte IE 8]><script language="javascript" type="text/javascript" src="../../excanvas.min.js"></script><![endif]-->
	<script language="javascript" type="text/javascript" src="<%= WebUtil.ImageURL %>flotcharts/jquery.js"></script>
	<script language="javascript" type="text/javascript" src="<%= WebUtil.ImageURL %>flotcharts/jquery.flot.js"></script>
	
	<script type="text/javascript">

	$(function() {


		var d1 =  [[1,3],[3,2],[2,1]];
		var ticks = ["하", "중", "상"];
		
		var data = [{ data: d1, label: "Pressure", color: "#333" }];
		
		var options = {
			    series: {//그래프 종류
			        lines: { 
			        	show: true,
			        	lineWidth : 10,
			        	label : {
			        		show : true,
			        		threshold: 0.1
			        	}
			        	//fill : true
			        	
			        },
			        points: { show: true }
			    },
			    grid: {
			        aboveData: true,
			        //color: "green",
			        backgroundColor: null,
			        margin:10,
			        labelMargin: 10,
			        axisMargin: 10
			        //markings: [xaxis : {from : 0, to 2},yaxis{from : 0, to 2}]
			    },
			    legend: {
			        show: true
			    }
			   // ,showTooltip(item.pageX, item.pageY, item.series.label + " at " + x + ": $" + y);
			    ,xaxis : {//X축 설정
			        //mode          : "time",

			        //ticks: ["2015", "2014", "2013" ]
			    	ticks : ticks
			        //timeformat: "%b"

			    }

			};
		

		
		//$.plot(차트명, data, options);
		$.plot("#chart1", data, options);



	});

	$("#chart1").bind("plotclick", function(event, pos, item){
		alert("sss");
	    //alert(item.datapoint);
	});
	</script>
</head>
<body>

	<div id="header">
		<h2>Series Types</h2>
	</div>

	<div id="content">

		<div class="demo-container">
			<div id="chart1" class="demo-placeholder"></div>
		</div>

	</div>

	

</body>
</html>
