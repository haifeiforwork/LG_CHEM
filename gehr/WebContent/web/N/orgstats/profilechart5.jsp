<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="ko">
<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<head>
    
    <script src="<%= WebUtil.ImageURL %>RGraph/libraries/RGraph.common.core.js" ></script>
    <script src="<%= WebUtil.ImageURL %>RGraph/libraries/RGraph.common.dynamic.js" ></script>
    <script src="<%= WebUtil.ImageURL %>RGraph/libraries/RGraph.common.effects.js" ></script>
    <script src="<%= WebUtil.ImageURL %>RGraph/libraries/RGraph.line.js" ></script>
    
    <title>Line chart with Trace effect</title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <meta name="robots" content="noindex,nofollow" />
    <meta name="description" content="A Line chart with Trace effect" />
     
</head>
<body>

    <script>
    window.onload = function() {
    	//값 없을때는 Y 축에 null 대입! X 축말고 Y축!
    	var x_v2 = 5;
    	var y_v2 = 30;
    	var x_v1 = 30;
    	var y_v1 = 20;
    	var x_v0 = 20;
    	var y_v0 = 10;
    	var currY = "2015";
    	
		var chart = new CanvasJS.Chart("chartContainer", {
			title: {
				text: "Line Chart"
			},
			axisX: {
				title: "리더십",
				interval: 10
			},
			axisY: {
				title: "성과",
				maximum : 39
//				valueFormatString: ["하"],["중"],["상"]
			},
			data: [{
				type: "line",
				dataPoints: [
				/*  { x: x_v2, y: y_v2 , label : "下" , indexLabel: "2013", markerType: "triangle",name : "하"},
				  { x: x_v1, y: y_v1  , label : "中" , indexLabel: "2014", markerType: "triangle",name : "중"},
				  { x: x_v0, y: y_v0  , label : "上" , indexLabel: currY, markerType: "triangle",name : "상"}*/
				  { x: x_v2, y: y_v2 , indexLabel: "2013", markerType: "triangle",name : "하"},
				  { x: x_v1, y: y_v1  ,  indexLabel: "2014", markerType: "triangle",name : "중"},
				  { x: x_v0, y: y_v0  ,  indexLabel: currY, markerType: "triangle",name : "상"}
//		var d1 =  [[1,3],[3,2],[2,1]];
				]
			}]
		});
		chart.render();
	}
	</script>
	<script src="<%= WebUtil.ImageURL %>canvasjs/canvasjs.min.js"></script>
	<title>CanvasJS Example</title>
</head>

<body>
	<div id="chartContainer" style="height: 400px; width: 600px;"></div>
</body>

</html>