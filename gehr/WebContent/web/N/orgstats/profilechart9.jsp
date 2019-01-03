
<%@ page contentType="text/html; charset=utf-8"%>
<%@ include file="/web/common/commonProcess.jsp"%>
<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%@ page import="hris.A.*" %>

<%
	Vector a22resultOfThreeYear_vt   = (Vector)request.getAttribute("a22resultOfThreeYear_vt");    // 3개년 평가
	A22resultOfProfileData data = new A22resultOfProfileData();
	String l1 = "";
	String l2 = "";
	String l3 = "";
	String ap1 = "";
	String ap2 = "";
	String ap3 = "";
	String year = "";
	String year_1="";
	String year_2="";
	if (a22resultOfThreeYear_vt != null && a22resultOfThreeYear_vt.size() > 0 ) {
		//for (int i =0 ; i< a22resultOfThreeYear_vt.size();i++){
		data = (A22resultOfProfileData)a22resultOfThreeYear_vt.get(0);
		l1  = data.LEADAP1;
		l2  = data.LEADAP2;
		l3  =  data.LEADAP3;
		ap1  = data.MBOAP1;
		ap2  = data.MBOAP2;
		ap3  = data.MBOAP3;
		year  = data.YEAR1;
		//}
	}
	if(!year.equals("")){
		year_1 = DataUtil.getAfterYear(year+"0101", -1).substring(0, 4);
		year_2 = DataUtil.getAfterYear(year+"0101", -2).substring(0, 4);
	}
%>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="description" content="LG화학 e-HR 시스템" />
	<link rel="stylesheet" type="text/css" 	href="<%= WebUtil.ImageURL %>css/ehr_style.css" />
	<script language="JavaScript" src="<%= WebUtil.ImageURL %>js/jquery-1.12.4.min.js?v1"></script>
	<script language="JavaScript" src="<%= WebUtil.ImageURL %>chart/dist/Chart.bundle.js"></script>
	<style>
		canvas {
			-moz-user-select: none;
			-webkit-user-select: none;
			-ms-user-select: none;
		}
	</style>
</head>

<body>

<div style="width:150px;height:245px;margin-top: 7px">
	<canvas id="canvas" width="150" height="245"></canvas>
</div>
<script>
    function tempCalc(va){
        var ret;
        if(va == 1){//상
            ret = 25;
        }else if(va == 2){//중
            ret = 15;
        }else if(va == 3){//하
            ret = 5;
        }else{
            ret = null;
        }
        return ret;
    }




    window.onload = function() {
        var ctx = document.getElementById("canvas").getContext("2d");
        var ticks = ['下', '中', '上'];
        var year =  ['<%=year%>','<%=year_1%>','<%=year_2%>'];
        var x3 = tempCalc("<%=l3 %>");//15
        var y3 = tempCalc("<%=ap3 %>");
        var x2 = tempCalc("<%=l2 %>");//14
        var y2 = tempCalc("<%=ap2 %>");
        var x1 = tempCalc("<%=l1 %>");//13
        var y1 = tempCalc("<%=ap1 %>")


        if(x3==x2&&y3==y2){
            y2 += 2;
        }
        if(x3==x1&&y3==y1){
            y1 += 2;
        }
        if(x2==x1&&y2==y1){
            y1 += 2;
        }
        //alert(x1+", "+x2+", "+x3);



        var scatterChart = new Chart(ctx, {
            data: {
                //labels: ["下", "中", "上"],
                datasets: [{
                    labels: ["下", "中", "上"],
                    type : 'line',
                    lineTension: 0.1,
                    label: '성과/리더십',
                    backgroundColor: "rgba(75,192,192,0.4)",
                    borderColor: "rgba(75,192,192,1)",
                    borderCapStyle: 'butt',
                    borderDash: [],
                    borderDashOffset: 0.0,
                    borderJoinStyle: 'miter',

                    pointBorderColor: "rgba(75,192,192,1)",
                    pointBackgroundColor: "red",
                    pointBorderWidth: 5,
                    pointHoverRadius: 10,
                    pointHoverBackgroundColor: "red",
                    pointHoverBorderColor: "rgba(220,220,220,1)",
                    pointHoverBorderWidth: 2,

                    //pointStyle : "triangle",
                    data: [{
                        x: x1,
                        y: y1
                    }, {
                        x: x2,
                        y: y2
                    }, {
                        x: x3,
                        y: y3
                    }],
                    fill: false
                }]
            },
            options: {
                animation: {
                    onComplete: function () {
                        var chartInstance = this.chart;
                        var ctx = chartInstance.ctx;
                        ctx.textAlign = "center";

                        Chart.helpers.each(this.data.datasets.forEach(function (dataset, i) {
                            var meta = chartInstance.controller.getDatasetMeta(i);
                            Chart.helpers.each(
                                meta.data.forEach(function (bar, index) {
                                    //alert(index+", "+year[index]+", "+bar._model.x);
                                    //ctx.fillText(dataset.data[index], bar._model.x, bar._model.y - 10);
                                    ctx.fillText(year[index], bar._model.x ,bar._model.y -20);
                                    //ctx.fillText(ticks[index], 0,bar._model.y);
                                    //ctx.fillText(ticks[index], bar._model.x, 400);
                                }),this)
                        }),this);
                    }
                },
                responsive: true,
                scales: {
                    xAxes: [{
                        type: 'linear',
                        position: 'bottom',
                        display: true,
                        //id: "x-axis-1",
						/*       			gridLines: {
						 offsetGridLines: true
						 }, */
                        ticks :{max: 30,
                            min: 0,
                            stepSize: 10,
                            backdropPaddingY : 100,
                            backdropPaddingX : 100,
                            fontSize : 0,
                            userCallback: function(dataLabel, index) {
                                return dataLabel;
                            }
                        }

                    }],
                    yAxes: [{
                        //id: "y-axis-1",
						/*     				gridLines: {
						 offsetGridLines: true
						 }, */
                        display: true,
                        ticks :{max: 30,
                            min: 0,
                            stepSize: 10,
                            fontSize : 0,
                            padding :  5,
                            backdropPaddingY : 10,
                            backdropColor :  'rgba(255, 255, 255, 0.75)'
                            //showLabelBackdrop : true
                        }
                    }]
                },


                series:[
                    {pointLabels:{
                        //display: true,
                        show: true,
                        //labels:['2013', '2014', '2015']
                    }}],
                axesDefaults: {
                    pad: 1
                }
            }
        });

        window.myLine = scatterChart;
    };



</script>
</body>

</html>
