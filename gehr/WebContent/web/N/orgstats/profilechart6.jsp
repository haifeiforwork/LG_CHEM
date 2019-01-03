<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="ko">
<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.*" %>
<%@ page import="com.sns.jdf.util.*" %>
  <head>
    <meta http-equiv="Content-Type" content="text/html;charset=utf-8">
    <title>One Graph</title>
    <script type="text/javascript" src="http://mbostock.github.com/d3/d3.v2.js"></script>
    <script type="text/javascript" src="<%= WebUtil.ImageURL %>d3/test.js"></script>
    <style type="text/css">
      body { font: 13px sans-serif; }
      rect { fill: #fff; }
      ul {
        list-style-type: none;
        margin: 0.5em 0em 0.5em 0em;
        width: 100%; }
        ul li {
          display: table-cell;
          vertical-align: middle;
          margin: 0em;
          padding: 0em 1em; }
      .axis { font-size: 1.5em;
                //display: none; 
                }
      .chart {
        background-color: #F7F2C5;
        width: 960px;
        height: 500px; }
      circle, .line {
        fill: none;
        stroke: steelblue;
        stroke-width: 2px; }
      circle {
        fill: white;
        fill-opacity: 0.2;
        cursor: move; }
        circle.selected {
          fill: #ff7f0e;
          stroke: #ff7f0e; }
        circle:hover {
          fill: #ff7f0e;
          stroke: #707f0e; }
        circle.selected:hover {
          fill: #ff7f0e;
          stroke: #ff7f0e; }
    </style>
  </head>
  <body>
    <div id="chart1" class="chart"></div>
    <script type="text/javascript">
      graph = new SimpleGraph("chart1", {
          "xmax": 60, "xmin": 0,
          "ymax": 40, "ymin": 0, 
          "title": "Simple Graph1",
          "xlabel": "리더십",
          "ylabel": "성과"  
        });
    </script>
  </body>
</html>
