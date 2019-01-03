<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="ko">
<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.*" %>
<%@ page import="com.sns.jdf.util.*" %>
  <head>
	
<title>A Basic xChart</title>
  
     <script src="http://cdnjs.cloudflare.com/ajax/libs/jquery/2.1.3/jquery.min.js"></script>
    <script src="<%= WebUtil.ImageURL %>chart/dist/Chart.bundle.js"></script>
<style>
        canvas {
            -moz-user-select: none;
            -webkit-user-select: none;
            -ms-user-select: none;
        }
    </style>
</head>

<body>
    <div style="width:75%;">
        <canvas id="canvas"></canvas>
    </div>
    <script>
    var ticks = ['下', '中', '上'];
    var d1 =  [[1,3],[3,2],[2,1]];
      
        var config = {
            type: 'line',
            data: {
                labels: ["상", "중","하"],
                //labels : 'test',
                datasets: [{
                    label: "My Third dataset - No bezier",
                    data:  [
{x : 1, y : 3},
{x : 3, y : 2},
{x : 2, y : 1}		],
                   //lineTension: 5,
                    fill: false,
                }]
            },
            options: {
          /*      responsive: true,
                legend: {
                    position: 'bottom',
                },
             
                axesDefaults: {
                    pad: 1
                },
                scales: {
                    xAxes: [{
                        display: true,
                        scaleLabel: {
                            display: true,
                            labelString: 'Month'
                        },
                        ticks : ticks
                    }],
                    yAxes: [{
                        display: true,
                        scaleLabel: {
                            display: true,
                            labelString: 'Value'
                        }
                    }]
                },
                title: {
                    display: true,
                    text: 'Chart.js Line Chart - Legend'
                },
                series:[
                        {pointLabels:{
                          show: true,
                          labels:['2013', '2014', '2015']
                        }}]*/
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
							type : 'linear',
							position : 'bottom',
        			        //ticks: ["2015", "2014", "2013" ]
        			    	ticks : ticks
        			        //timeformat: "%b"

        			    }
            }
        };



        window.onload = function() {
            var ctx = document.getElementById("canvas").getContext("2d");
            window.myLine = new Chart(ctx, config);
        };



       
    </script>
</body>

</html>
