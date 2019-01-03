<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.util.*" %>
<%@ page import="com.sns.jdf.*" %>
<%@ page import="com.sns.jdf.util.*"%>
<%

	HashMap qlHM = (HashMap)request.getAttribute("resultVT"); 
	Vector orgVT = (Vector)qlHM.get("T_EXPORT1"); 
	
	//
	Vector content = new Vector();
	int qlSize = orgVT.size();

	int countYear = 0;  //년도의 갯수를 구한다. 
	HashMap<String, String> qlhm = new HashMap<String, String>();
	String sDa = "";
	Vector datavt = new Vector(); //해당년도 
	Vector lengvt = new Vector(); //legend 필드명
	int reSize =0;
	int conSize = 0;
	if(qlSize > 0  ){
		
		Vector subvt=null;
		for(int k = 0 ; k < qlSize ; k++){ 
			qlhm = (HashMap)orgVT.get(k);
			String zcode = qlhm.get("ZCODE");
			String count = qlhm.get("COUNT");
			String codtx = qlhm.get("CODTX");
			if(!zcode.equals(sDa)){ 
				if(k > 0){
					content.add(subvt);
				}
				lengvt.add(codtx);
				subvt = new Vector();
				subvt.add(count);
				countYear ++; 
			}else{
				subvt.add(count);
			}
			if(k == (qlSize-1)){ //마지막 Vector 저장 
				content.add(subvt);
			}
			sDa = zcode;
		}
		
		reSize = qlSize / countYear; 
		
		/******** 총개를 구할경우 사용함 *********/
		Vector sumvt = new Vector();
		for(int i =0 ; i < reSize ; i ++){
			sumvt.add(0);
		}
		content.add(sumvt);
		/*********************************/
		for(int k = 0 ; k < reSize ; k++){ 
			qlhm = (HashMap)orgVT.get(k);
			String sDATUM = qlhm.get("DATUM");
			if(!sDATUM.equals(sDa)){ 
				if(sDATUM.substring(0,4).equals(DataUtil.getCurrentYear())) {
					datavt.add("\'"+ WebUtil.printDate(sDATUM)+"\'"); 
				}else{
					datavt.add("\'"+ sDATUM.substring(2,4)   +"년末\'"); 
				}
				
			}
			sDa = sDATUM;
		}
		
		conSize = content.size();
	}	
	//
	//
%>


<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=9" />
    <title></title>

    <link class="include" rel="stylesheet" type="text/css" href="<%= WebUtil.ImageURL %>js/jqplot_css/jquery.jqplot.min.css" />
    <link rel="stylesheet" type="text/css" href="<%= WebUtil.ImageURL %>js/jqplot_css/examples.min.css" />
    <link type="text/css" rel="stylesheet" href="<%= WebUtil.ImageURL %>js/jqplot_css/syntaxhighlighter/styles/shCoreDefault.min.css" />
    <link type="text/css" rel="stylesheet" href="<%= WebUtil.ImageURL %>js/jqplot_css/syntaxhighlighter/styles/shThemejqPlot.min.css" />
	<script language="javascript" type="text/javascript" src="<%= WebUtil.ImageURL %>js/jqplot_js/excanvas.js"></script>
    <script class="include" type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>
    <STYLE type=text/css> #position .jqplot-point-label  {        padding: 1px 3px;   } </STYLE>
   
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
<style type="text/css">
    
    .note {
        font-size: 0.8em;
    }
    .jqplot-yaxis-tick {
      white-space: nowrap;
    }
    
    
  </style>
  
<!-- Example scripts go here -->


	
   <style type="text/css">
    
    .note {
        font-size: 0.8em;
    }
    .jqplot-yaxis-tick {
      white-space: nowrap;
    }
    
    
  </style>
     
    <div id="position" style="margin-left:40px;width:720px; height:370px;"></div>

<script type="text/javascript">

	function comma(str) {    
		 str = String(str);     
		 return str.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,'); 
	}

$(document).ready(function(){

<%
	for(int k = 0 ; k < conSize ; k++){ 		
%>	
	var s<%=k+1%> = <%=content.get(k)%>	
<%	
		if(k == conSize-1){
%>		
	   var pLabelsTotal  = [];
<%	   
		}else{
%>		
		var pLabels<%=k+1%> = [];
	
<%		
		}	
	}

%>

  
  var totSum =0;
  for (var i = 0; i < s1.length; i++){
  	for(var j = 0 ; j < <%=conSize%>; j++){
  	
  		if(j == <%=conSize-1%>){
			pLabelsTotal.push('<div class="totalSum">'+comma(totSum) +'</div>');      			
			
			totSum =0;
  		}else{
  		    totSum  += eval("s"+(j+1)+"["+i+"]" );
  			eval("pLabels"+(j+1)+".push(s"+(j+1)+"["+i+"])" );
		}
      }
  }   
   
  var ticks = <%=datavt%>; //X 축 날짜를 보여준다.
  position1 = $.jqplot('position', <%=content%>,{
  
    title:'<span style="font-family:malgun gothic;font-size:12px;font-weight:bold;color:#339aa6;"> [ 직급별 인원구성추이 ] </span>',
  //animate: true,
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
      //pointLabels: {show: true , labelsFromSeries:true},
      //pointLabels: {show: true , labels:['37', '29', '16', 30', '11'] },
     
      rendererOptions: {
          // Put a 30 pixel margin between bars.
          barMargin:160,
          // Highlight bars when mouse button pressed.
          // Disables default highlighting on mouse over.
          /* bar를 마우스로 선택하고 클릭해야만 색깔이 흐려진다. */
          highlightMouseDown: true    
      }
      
    },
     series:[
 <% 
 for(int k = 0 ; k < content.size()-1 ; k++){ 
 %>           
            {
            	label:'<%=lengvt.get(k)%>',
	            pointLabels:{
	                show:true,  //그래프 숫자값 디스플레이
	                labels:pLabels<%=k+1%>,
	                ypadding: 6,
	               // edgeTolerance :-5,
	                hideZeros: true,
	                location: 'n',
	                xpadding: 30,
	                escapeHTML:false
	            }
            }
            ,
<%}%>            
           
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
       padMin: 450,
       show:false,
       autoscale: false ,
      //max: 9000,
        min: -420,
        tickOptions: {
        show: false,
        	formatString: "%'d"
        } //포멧 
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
  $('#position').bind('jqplotDataClick', 
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
</body>


</html>
