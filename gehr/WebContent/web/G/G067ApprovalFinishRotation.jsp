<%/******************************************************************************/
/*																				*/
/*   System Name  : MSS															*/
/*   1Depth Name  : 신청															*/
/*   2Depth Name  : 부서근태														*/
/*   Program Name : 부서근태마감													*/
/*   Program ID   : D12RotationBuild|G67ApprovalFinishRotation.jsp				*/
/*   Description  : 부서근태 결재완료 화면											*/
/*   Note         : 															*/
/*   Creation     : 2009-02-10  김종서												*/
/*   Update       : 															*/
/*																				*/
/********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ page import="java.util.Vector" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Date" %>
<%@ page import="hris.common.util.*" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.D.D12Rotation.*" %>
<%@ page import="com.sns.jdf.util.*" %>

<%
	WebUserData user = WebUtil.getSessionUser(request);

	String jobid      = (String)request.getAttribute("jobid");
	String deptNm = (String)request.getAttribute("deptNm");
	Vector AppLineData_vt       = (Vector)request.getAttribute("AppLineData_vt"); //결재라인
    Vector main_vt1    = (Vector)request.getAttribute("main_vt1");
    Vector main_vt2    = (Vector)request.getAttribute("main_vt2");
    Vector main_vt3    = (Vector)request.getAttribute("main_vt3");

    String AINF_SEQN  = WebUtil.nvl((String)request.getAttribute("AINF_SEQN"));
    String E_FROMDA  = WebUtil.nvl((String)request.getAttribute("E_FROMDA"));
    String E_TODA  = WebUtil.nvl((String)request.getAttribute("E_TODA"));
    String E_ORGEH  = WebUtil.nvl((String)request.getAttribute("E_ORGEH"));
    String E_STEXT  = WebUtil.nvl((String)request.getAttribute("E_STEXT"));
    String E_BIGO  = WebUtil.nvl((String)request.getAttribute("E_BIGO"));
    String RequestPageName = (String)request.getAttribute("RequestPageName");

    String rowCount   = (String)request.getAttribute("rowCount" );

    int  emp_count = main_vt1.size();
    int  result_count = main_vt2.size();
    int  date_count = main_vt3.size();

    int from_date = Integer.parseInt(E_FROMDA.replaceAll("-",""));
	int to_date = Integer.parseInt(E_TODA.replaceAll("-",""));

	boolean isCanGoList ;
    if (RequestPageName == null || RequestPageName.equals("")) {
        isCanGoList = false;
    } else {
        isCanGoList = true;
    } // end if

    int dateSize = 40;
    int tableSize = 215+(main_vt3.size()*dateSize);


    D12RotationBuild2Data first_data = (D12RotationBuild2Data)main_vt3.get(0);
    D12RotationBuild2Data last_data = (D12RotationBuild2Data)main_vt3.get(main_vt3.size()-1);

    String first_date = first_data.BEGDA;
    String last_date = last_data.BEGDA;
%>

<html>
<head>
<title>ESS</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr.css" type="text/css">
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr_style.css" type="text/css">
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr_wsg.css" type="text/css">

<script language="javascript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>
<script language="JavaScript">
<!--
function msg(){
	//alert("jobid : <%=jobid%>\ndeptNm : <%=deptNm%>\nAppLineData_vt : <%=AppLineData_vt%>\nAINF_SEQN : <%=AINF_SEQN%>\nE_FROMDA : <%=E_FROMDA%>\nE_TODA : <%=E_TODA%>\nmain_vt1 : <%=emp_count%>\nmain_vt2 : <%=result_count%>\nmain_vt3 : <%=date_count%>");
}

function handleError (err, url, line) {
   alert('오류 : '+err + '\nURL : ' + url + '\n줄 : '+line);
   return true;
}

function goToList(){
    var frm = document.form1;
    <% if (isCanGoList) { %>
        frm.action = "<%=RequestPageName.replace('|' ,'&')%>";
    <% } // end if %>
        frm.jobid.value ="";
        frm.submit();
}





-->
</script>
<style>
.oddRow .td10 {background:#f7f2c6;}
.oddRow .td12{background:#f7ddda;}
</style>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" >
<form name="form1" method="post" action="">
  <input type="hidden" name="jobid" value="search">
  <input type="hidden" name="APPR_STAT">
  <input type="hidden" name="RequestPageName"   value="<%=RequestPageName%>">

  <table width="796" border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td width="16">&nbsp;</td>
      <td>
        <table width="780" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td>
              <table width="780" border="0" cellpadding="0" cellspacing="0">
                <tr>
                  <td height="5" colspan="2"></td>
                </tr>
                <tr>
                  <td class="subhead"><h2>근태신청 결재 완료 문서</h2></td>
                </tr>
              </table>
            </td>
          </tr>
          <tr>
            <td height="10">&nbsp;</td>
          </tr>
          <tr>
            <td height="10">
              <!-- 신청자 기본 정보 시작 -->
              <%@ include file="/web/common/ApprovalIncludePersInfo.jsp" %>
              <!--  신청자 기본 정보 끝-->
            </td>
          </tr>
          <tr>
            <td height="10">&nbsp;</td>
          </tr>
          <tr>
            <td>
              <!-- 상단 테이블 시작-->
              <table width="780" height="29" border="0" cellpadding="0" cellspacing="0" >
              	<tr>
              		<td>
			           	<div class="buttonArea">
			           		<ul class="btn_crud">
			                   <% if (isCanGoList) {  %>
			           			<li><a href="javascript:goToList()"><span>목록보기</span></a></li>
			                   <% } // end if %>
			           		</ul>
			           	</div>
              		</td>
              	</tr>
                <tr>
                  <td><h2 class="subtitle">신청정보</h2></td>
                </tr>
                <tr>
                  <td width="100%" align="right">
                  	<div class="tableArea">
	                    <table class="tableGeneral">
	                      <tr>
	                        <th width="100">신청기간</th>
	                        <td width="150">
	                          <%= WebUtil.printDate(E_FROMDA) %>
	                      	        &nbsp;
	                              ~&nbsp;
	                          <%= WebUtil.printDate(E_TODA) %>

	                        </td>
	                        <th class="th02" width="100">부서명</th>
	                        <td><%=E_STEXT%></td>
	                      </tr>
	                    </table>
                    </div>
                  </td>
                </tr>
                <tr>
                  <td>
                    <table width="780" height="20" border="0" cellpadding="0" cellspacing="0">
                      <tr>
                        <td width="60%" height="10">
                        <td width="40%" align="right">[<font color="#FFE4E1">■</font>:요청일 ,<font color="#FFFACD">■</font>:토,일요일 ,<font color="#FFB6C1">■</font>:결재진행중 ,<font color="#EAEAEA">■</font>:결재완료]</td>
                      </tr>
                    </table>
                  </td>
                </tr>
              </table>
              <!-- 상단 테이블 끝-->
            </td>
          </tr>
        </table>
      </td>
    </tr>
  </table>
  <table width="<%=tableSize %>" border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td width="15">&nbsp;</td>
      <td>
      <!-- 근태일자 Field Table Header 시작 -->

      <!-- 근태일자 Field Table Header 끝 -->

      <!-- 상단 입력 테이블 시작-->
        <table border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td class="tr01">
              <table border="0" cellspacing="1" cellpadding="0">
                <tr>
                  <td class="tr01" colspan="4">

                  	<div class="tableArea">
                    <table class="listTable">
<!-- 아래, 위 프레임의 사이즈를 고정시킨다 -->
                      <tr>
                        <th width="30"  rowspan="2">구분</th>
                        <th width="60"  rowspan="2">성명</th>
                        <th width="60"  rowspan="2">사번</th>
                        <th width="35" rowspan="2">잔여휴가</th>
                        <th class="lastCol" colspan=<%=main_vt3.size() %>>&nbsp;근태내용(<%=first_date %> ~ <%=last_date %> )</th>
                      </tr>
                      <tr>
                      <%
                      for(int i = 0 ; i < date_count ; i++){
                    	  D12RotationBuild2Data data3 = (D12RotationBuild2Data)main_vt3.get(i);
                      %>
                        <th width="<%=dateSize %>" ><%=data3.BEGDA.substring(8,10) %></th>
                      <%
                      }
                      %>
                      </tr>

<!-- 아래, 위 프레임의 사이즈를 고정시킨다 -->
<%




    for( int i = 0 ; i < emp_count ; i++ ) {
        D12RotationBuildData data = (D12RotationBuildData)main_vt1.get(i);

        String tr_class = "";

        if(i%2 == 0){
            tr_class="oddRow";
        }else{
            tr_class="";
        }
%>

                      <tr class="<%=tr_class%>" height=25>
                        <td class="td04">
                        <%=i+1%>
                        </td>
                        <td><%= data.ENAME %></td>
                        <td><%= data.PERNR %></td>
                        <td><%= Math.abs(Double.parseDouble(data.QUATA)) %></td>
                      <%
                      for(int j = 0 ; j < main_vt3.size() ; j++){
                    	  D12RotationBuild2Data data3 = (D12RotationBuild2Data)main_vt3.get(j);
                    	  String cellData = "";
                    	  String title = "";
                    	  Map map = new HashMap();
                    	  for(int l=0; l<main_vt2.size(); l++){
                    		  D12RotationBuildData data2 = (D12RotationBuildData)main_vt2.get(l);

                    		  if(data.PERNR.equals(data2.PERNR) && data3.BEGDA.equals(data2.BEGDA)){
                    			  cellData = cellData + data2.ACODE + " : " + data2.ATIME + "<br>";
                    			  title = title+data2.ATEXT+" "+data2.ATIME+"시간\n";
                    			  map.put(data2.BEGDA, data2.APPR_STAT);
                    		  }
                    	  }
                    	  String bgColor = "";
                    	  int today = Integer.parseInt(data3.BEGDA.replaceAll("-",""));

                    	  if((data3.APPR_STAT.equals("A")&&cellData.equals("")) || (data3.APPR_STAT.equals("A")&&!cellData.equals("")&&map.get(data3.BEGDA).equals("A")) || (!data3.APPR_STAT.equals("A")&&!cellData.equals("")&&map.get(data3.BEGDA).equals("A"))){ //승인된 항목
                    		  String tdClass = "";
                    		  if(from_date<=today && today<=to_date){
                    			  tdClass = "td12";
                        	  }

                      %>
                        <td class="<%=tdClass %>" title="<%= title %>"><%= cellData %></td>
                      <%
                    	  }else if(data3.APPR_STAT.equals("I")){
                    		  String tdClass = "";
                    		  if(from_date<=today && today<=to_date){
                    			  tdClass = "td12";
                        	  }
                      %>
                        <td class="<%=tdClass %>" title="<%= title %>"><%= cellData %></td>
                      <%
                          }else{
                        	  String[] dateArray = data3.BEGDA.split("-");
                        	  Date df = new Date(Integer.parseInt(dateArray[0])-1900, Integer.parseInt(dateArray[1])-1, Integer.parseInt(dateArray[2]));

                        	  String tdClass = "";
                        	  if(df.getDay()==0||df.getDay()==6){
                        		  tdClass = "td10";
                        	  }
                        	  if(from_date<=today && today<=to_date){
                    			  tdClass = "td12";
                        	  }
                      %>
                        <td class="<%=tdClass %>" title="<%= title %>"><%= cellData %></td>
                      <%
                          }
                      }
                      %>
                      </tr>
<%
    }
%>
                    </table>
                    </div>
                  </td>
                </tr>

<!-----ADD ROW ---------------------------------->
<!---- ADD ROW ---------------------------------->
              </table>
            </td>
          </tr>


        </table>
        <!-- 상단 입력 테이블 끝-->
      </td>
    </tr>
    <tr>
      <td>&nbsp;</td>
      <td>
        <table width="780" border="0" cellspacing="0" cellpadding="0">
          <%
            boolean visible = false;

            if (E_BIGO != null && !E_BIGO.equals("")) {
                visible = true;
            } // end if


            if (visible) {
          %>
          <tr>
            <td><h2 class="subtitle">적요</h2></td>
          </tr>
          <tr>
            <td>
              <table width="780" border="0" cellpadding="0" cellspacing="1">
                <tr>
                  <td>
                  	<div class="tableArea">
                  		<table class="tableGeneral">
                  			<tr>
                  				<td><%=E_BIGO%></td>
                  			</tr>
                  		</table>
                  	</div>
                  </td>
                </tr>
              </table>
            </td>
          </tr>
          <%
            }
          %>
          <tr>
            <td>
              <table width="780" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td>&nbsp;</td>
                </tr>
                <tr>
                  <td><h2 class="subtitle">결재정보</h2></td>
                </tr>
                <tr>
                  <td>
                    <table width="780" border="0" cellspacing="0" cellpadding="0">
                      <tr>
                        <td>
                          <!--결재정보 테이블 시작-->
                          <%= AppUtil.getAppDetail(AppLineData_vt) %>
                          <!--결재정보 테이블 끝-->
                        </td>
                      </tr>
                    </table>
                  </td>
                </tr>
                <tr>
                  <td>&nbsp;</td>
                </tr>
                <tr>
                  <td>
                  <!--버튼 들어가는 테이블 시작 -->
		           	<div class="buttonArea">
		           		<ul class="btn_crud">
		                   <% if (isCanGoList) {  %>
		           			<li><a href="javascript:goToList()"><span>목록보기</span></a></li>
		                   <% } // end if %>
		           		</ul>
		           	</div>
                  <!--버튼 들어가는 테이블 끝 -->
                  </td>
                  <!--버튼끝-->
                </tr>
                <tr>
                  <td>&nbsp;</td>
                </tr>
              </table></td>
          </tr>
        </table>
      </td>
    </tr>
  </table>
  </form>
<%@ include file="/web/common/commonEnd.jsp" %>