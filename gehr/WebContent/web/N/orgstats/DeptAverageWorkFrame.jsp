<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.util.*" %>
<%@ page import="com.sns.jdf.*" %>
<%@ page import="com.sns.jdf.util.*"%>
<%

	HashMap qlHM = (HashMap)request.getAttribute("resultVT"); 
	Vector orgVT = (Vector)qlHM.get("T_EXPORT2"); 
	
	//
	Vector xcontent = new Vector();
	int qlSize = orgVT.size();

	int countYear = 0;  //년도의 갯수를 구한다. 
	HashMap<String, String> qlhm = new HashMap<String, String>();

	
	Vector lengvt = new Vector(); //legend 필드명
	int reSize =0;
	int conSize = 0;
	
	if(qlSize > 0  ){
		for(int k = 0 ; k < qlSize ; k++){ 
			qlhm = (HashMap)orgVT.get(k);
			String codtx = qlhm.get("CODTX");
			String gnsok = qlhm.get("GNSOK");
			Vector xdatavt = new Vector(); //해당년도 
			Vector ydatavt = new Vector(); //해당년도 
		   	xdatavt.add("\'"+codtx+"\'");
		   	xdatavt.add(gnsok);	
		   	xcontent.add(xdatavt);
				
		}
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
     
    <div id="work" style="margin-left:40px;width:720px; height:370px;"></div>

<script type="text/javascript">

$(document).ready(function(){
    var line1 =<%=xcontent%>;

    $('#work').jqplot([line1], {
        title:'<span style="font-family:malgun gothic;font-size:12px;font-weight:bold;color:#339aa6;"> [ 사무직 평균근속 ] </span>',
        seriesDefaults:{
            renderer:$.jqplot.BarRenderer,
            rendererOptions: {
                // Set the varyBarColor option to true to use different colors for each bar.
                // The default series colors are used.
                 barMargin:45,
                  highlightMouseDown: true    ,
                varyBarColor: true
                
            }
        },
        axes:{
            xaxis:{
                renderer: $.jqplot.CategoryAxisRenderer
            },
		     yaxis: {
		     
		       
		       show:false,
		       autoscale: false ,
		     
		       
		        tickOptions: {
		        show: false
	        } //포멧 
	      }
        }
    });
});
</script>

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

 
<!-- End additional plugins -->

        </div>
      </div>
    </div>
</body>


</html>
