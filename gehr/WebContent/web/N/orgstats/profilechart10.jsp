<html lang="ko">
<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%@ page import="hris.A.*" %>
<%
    Vector a22resultOfThreeYear_vt   = (Vector)request.getAttribute("a22resultOfThreeYear_vt");    // 3개년 평가
    A22resultOfProfileData data = new A22resultOfProfileData();
    String m1 = "";
    String m2 = "";
    String m3 = "";
    String year = "";
    String year_1="";
    String year_2="";
    if (a22resultOfThreeYear_vt != null && a22resultOfThreeYear_vt.size() > 0 ) {
        //for (int i =0 ; i< a22resultOfThreeYear_vt.size();i++){
        data = (A22resultOfProfileData)a22resultOfThreeYear_vt.get(0);
        m1  = data.MISSAP1;//16년도 데이터
        m2  = data.MISSAP2;//15
        m3  = data.MISSAP3;//14
        year  =  data.YEAR1;
        //}
    }
    if(!year.equals("")){
        year_1 = DataUtil.getAfterYear(year+"0101", -1).substring(0, 4);
        year_2 = DataUtil.getAfterYear(year+"0101", -2).substring(0, 4);
    }
%>
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=edge">

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
<!-- [CSR ID:3460886] chart size 조정-->
<div style="width:140px;height:245px;">
    <canvas id="canvas" width="140" height="245"></canvas>
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
        var year = ['<%=year_2%>','<%=year_1%>','<%=year%>'];
        var x1 = "5";
        var y1 =tempCalc("<%=m3 %>");
        var x2 = "15";
        var y2 = tempCalc("<%=m2 %>");
        var x3 = "25";
        var y3 = tempCalc("<%=m1 %>");

        var scatterChart = new Chart(ctx, {
            data: {
                //labels: ["下", "中", "上"],
                datasets: [{
                    labels: ["下", "中", "上"],
                    type : 'line',
                    lineTension: 0.1,
                    label: 'Mission',
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
                                    //alert(index);
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
