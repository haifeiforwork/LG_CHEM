<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : HR 결재함                                                   */
/*   2Depth Name  : 근태신청 결재                                      */
/*   Program Name : 근태신청 결재                                      */
/*   Program ID   : G066ApprovalRotation.jsp                                     */
/*   Description  : 근태신청 결재할 수 있도록 하는 화면                */
/*   Note         :                                                             */
/*   Creation     : 2009-02-25  김종서                                          */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Date" %>
<%@ page import="hris.common.util.*" %>
<%@ page import="hris.common.*" %>
<%@ page import="com.sns.jdf.util.*" %>

<%@ page import="hris.common.WebUserData" %>
<%@ page import="hris.D.D12Rotation.*" %>

<%
    WebUserData user = WebUtil.getSessionUser(request);

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
	String RequestPageName = (String)request.getAttribute("RequestPageName");
	
	String rowCount   = (String)request.getAttribute("rowCount" );
	    
	int  emp_count = main_vt1.size();
	int  result_count = main_vt2.size();
	int  date_count = main_vt3.size();
	
	int from_date = Integer.parseInt(E_FROMDA.replaceAll("-",""));
	int to_date = Integer.parseInt(E_TODA.replaceAll("-",""));

    //Vector       vcAppLineData   = (Vector)request.getAttribute("vcAppLineData");

    boolean isCanGoList ;
    if (RequestPageName == null || RequestPageName.equals("")) {
        isCanGoList = false;
    } else {
        isCanGoList = true;
    } // end if


    // 현재 결재자 구분
    DocumentInfo docinfo = new DocumentInfo(AINF_SEQN ,user.empNo, false);
    int approvalStep = docinfo.getApprovalStep();
    
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

<script language="javascript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>

<script language="JavaScript">
<!--
//alert("emp_count : "+<%=emp_count %>);
//alert("date_count : "+<%=date_count %>);
function goRotationDetail(deptId, yyyymmdd){
	
	window.open("<%= WebUtil.ServletURL %>hris.D.D12Rotation.D12RotationSV?hdn_isPop=APPROVAL&jobid=&hdn_deptId="+deptId+"&I_DATE="+yyyymmdd+"&I_SEARCHDATA="+deptId,"RotataionDetail","toolbar=0,location=0,directories=0,status=0,menubar=0,resizable=1,width=800,height=600, scrollbars=1");
}
function approval()
{
    var frm = document.form1;



    if(!confirm("결재 하시겠습니까.")) {
        return;
    } // end if

    frm.APPR_STAT.value = "A";
    frm.submit();
}

function reject()
{
    if(!confirm("반려 하시겠습니까.")) {
        return;
    } // end if
    var frm = document.form1;
    
    frm.APPR_STAT.value = "R";

    frm.submit();
}

function goToList()
{
    var frm = document.form1;
    frm.jobid.value ="";
<% if (RequestPageName != null ) { %>
    frm.action = "<%=RequestPageName.replace('|' ,'&')%>";
<% } // end if %>

    frm.submit();
}

// 달력 사용
function fn_openCal(Objectname){
    var lastDate;
    lastDate = eval("document.form1." + Objectname + ".value");
    small_window=window.open("<%=WebUtil.JspURL%>common/calendar.jsp?formname=form1&fieldname="+Objectname+"&curDate="+lastDate+"&iflag=0","essCalendar","toolbar=0,location=0,directories=0,status=0,menubar=0,resizable=0,width=300,height=300");
    small_window.focus();
}
//-->
</script>
</head>
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" >
<form name="form1" method="post" action="">
  <input type="hidden" name="jobid" value="save">
  <input type="hidden" name="APPU_TYPE" value="<%=docinfo.getAPPU_TYPE()%>">
  <input type="hidden" name="APPR_SEQN" value="<%=docinfo.getAPPR_SEQN()%>">
  <input type="hidden" name="BUKRS" value="<%=user.companyCode%>">


  <input type="hidden" name="APPR_STAT">
  <input type="hidden" name="RequestPageName"   value="<%=RequestPageName%>">
  <input type="hidden" name="approvalStep" value="<%=approvalStep%>">

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
                  <td width="780" class="title02"><img src="<%= WebUtil.ImageURL %>ehr/title01.gif">부서일일근태 결재해야 할 문서 </td>
                  <td align="right" style="padding-bottom:4px"><a href="javascript:open_help('E06Rehouse.html');" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image6','','<%= WebUtil.ImageURL %>btn_help_on.gif',1)"></a>
                  </td>
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
                  <td class="font01" style="padding-bottom:2px"><img src="<%= WebUtil.ImageURL %>ehr/icon_o.gif"> 
                          신청정보
                  </td>
                </tr>
                <tr> 
                  <td width="100%" align="right">
                    <table width="100%" border="0" cellpadding="0" cellspacing="1" class="table03">
                      <tr>
                        <td width="100" class="td01">&nbsp;&nbsp;&nbsp;신 청 기 간</td>
                        <td width="150" class="td09"> 
                          <%= WebUtil.printDate(E_FROMDA) %>
                      	        &nbsp;
                              ~&nbsp;
                          <%= WebUtil.printDate(E_TODA) %>
                               
                        </td>
                        <td class="td03" width="100" align="right">
                          <font color="#585858">부서명</font>
                        </td>
                        <td width="*" class="td09">
                          <%=E_STEXT%>
                        </td>
                      </tr>
                    </table>
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
                    <table border="0" cellspacing="1" cellpadding="0" class="table02" >
<!-- 아래, 위 프레임의 사이즈를 고정시킨다 --> 
                      <tr> 
                        <td class="td03" width="30"  rowspan="2">구분</td>
                        <td class="td03" width="60"  rowspan="2">성명</td>
                        <td class="td03" width="60"  rowspan="2">사번</td>
                        <td class="td03" width="35" rowspan="2">잔여휴가</td>
                        <td class="td01" colspan=<%=main_vt3.size() %>>&nbsp;&nbsp;근태내용(<%=first_date %> ~ <%=last_date %> )</td>
                      </tr>
                      <tr>
                      <%
                      for(int i = 0 ; i < date_count ; i++){
                    	  D12RotationBuild2Data data3 = (D12RotationBuild2Data)main_vt3.get(i);
                      %>
                        <td class="td03" width="<%=dateSize %>" ><a href="javascript:goRotationDetail('<%=E_ORGEH%>','<%=data3.BEGDA%>');"><%=data3.BEGDA.substring(8,10) %></a></td>                        
                      <%
                      }
                      %>
                      </tr>                    
                    
<!-- 아래, 위 프레임의 사이즈를 고정시킨다 -->
<%
    
    
    
    
       	
    for( int i = 0 ; i < emp_count ; i++ ) {
        D12RotationBuildData data = (D12RotationBuildData)main_vt1.get(i);           
        
        
%>

                      <tr height=25> 
                        <td class="td04">
                        <%=i+1%>
                        </td>                           
                        <td class="td04"><%= data.ENAME %></td>
                        <td class="td04"><%= data.PERNR %></td>
                        <td class="td04"><%= Math.abs(Double.parseDouble(data.QUATA)) %></td>
                      <%
                      for(int j = 0 ; j < date_count ; j++){
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
                    	  
                    	  int today = Integer.parseInt(data3.BEGDA.replaceAll("-",""));
                    	  
                    	  if((data3.APPR_STAT.equals("A")&&cellData.equals("")) || (data3.APPR_STAT.equals("A")&&!cellData.equals("")&&map.get(data3.BEGDA).equals("A")) || (!data3.APPR_STAT.equals("A")&&!cellData.equals("")&&map.get(data3.BEGDA).equals("A"))){ //승인된 항목
                    		  String tdClass = "td07";
                    		  if(from_date<=today && today<=to_date){
                    			  tdClass = "td12";
                        	  }
                      %>
                        <td class="<%=tdClass %>" title="<%= title %>"><%= cellData %></td>
                      <%
                    	  }else if(data3.APPR_STAT.equals("I")){
                    		  String tdClass = "td11";
                    		  if(from_date<=today && today<=to_date){
                    			  tdClass = "td12";
                        	  }
                      %>
                        <td class="<%=tdClass %>" title="<%= title %>"><%= cellData %></td>
                      <%
                          }else{
                        	  String[] dateArray = data3.BEGDA.split("-");
                        	  Date df = new Date(Integer.parseInt(dateArray[0])-1900, Integer.parseInt(dateArray[1])-1, Integer.parseInt(dateArray[2]));
                        	  
                        	  String tdClass = "td04";
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
          <tr>
            <td class="font01" style="padding-bottom:2px"><img src="<%= WebUtil.ImageURL %>ehr/icon_o.gif"> 적요</td>
          </tr>
          <%
          String tmpBigo = "";
          for (int i = 0; i < AppLineData_vt.size(); i++) {
        	  AppLineData ald = (AppLineData) AppLineData_vt.get(i);
        	  if (ald.APPL_BIGO_TEXT != null && !ald.APPL_BIGO_TEXT.equals("")) {
        		  if (ald.APPL_PERNR.equals(user.empNo)) {
        			  tmpBigo = ald.APPL_BIGO_TEXT;
        		  }else{
          %>
          <tr>
            <td>
              <table width="780" border="0" cellpadding="0" cellspacing="1" class="table03">
                <tr>
                  <td width="80" class="td03"><%=ald.APPL_ENAME%></td>
                  <td class="td09"><%=ald.APPL_BIGO_TEXT%></td>
                </tr>
              </table>
            </td>
          </tr>
          <%		  
        		  }
        	  }
          }
          %>
          <tr>
            <td class="td03" style="padding-top:5px;padding-bottom:5px">
                <textarea name="BIGO_TEXT" cols="80" rows="2"><%=tmpBigo%></textarea>
            </td>
          </tr>
          <tr>
            <td>
              <table width="780" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td>&nbsp;</td>
                </tr>
                <tr>
                  <td class="font01" style="padding-bottom:2px"><img src="<%= WebUtil.ImageURL %>ehr/icon_o.gif">
                    결재정보</td>
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
                  <td align="center">
                  <!--버튼 들어가는 테이블 시작 -->
                      <table width="780" border="0" cellpadding="0" cellspacing="0">
                        <tr>
                          <td class="td04">
                          <% if (isCanGoList) { %>
                            <a href="javascript:goToList()"><img src="<%= WebUtil.ImageURL %>btn_list.gif" border="0"></a>&nbsp;&nbsp;&nbsp;
                          <%  } // end if %>
                            <a href="javascript:approval()"><img src="<%= WebUtil.ImageURL %>btn_submit.gif" border="0" /></a>&nbsp;&nbsp;&nbsp;
                            <a href="javascript:reject()"><img src="<%= WebUtil.ImageURL %>btn_return.gif" border="0"></a>
                          </td>
                        </tr>
                      </table>
                  <!--버튼 들어가는 테이블 끝 -->
                  </td>
                  <!--버튼끝-->
                </tr>
                <tr>
                  <td>&nbsp;</td>
                </tr>
              </table></td>
          </tr>
          
  <!-------------------------> 
  <tr>
    <td colspan="2" >
      <table width="100%" border="0" cellpadding="0" cellspacing="0" align="left">
        <tr>
          <td>
            <table width="100%" border="0" cellpadding="0" cellspacing="0" align="left">
              <tr>
                <td class="font01" style="padding-bottom:2px">* 근태유형 및 단위</td>
              </tr>
            </table>
          </td>
        </tr>
        <tr>
          <td>
            <table width="100%" border="0" cellpadding="0" cellspacing="1" class="table01" align="left">
              <tr class="td07">
                <td width="100">&nbsp;</td>
                <td>시간</td>
                <td>일수</td>
                <td width="140">횟수</td>
              </tr>
              <tr>
                <td class="td07">비근무</td>
                <td class="td09">L:시간공가 U:휴일근무 V:비근무<br/>W:모성보호휴가</td><!--※CSR ID:C20111025_86242-->
                <td class="td09" nowrap>D:반일휴가(전반) E:반일휴가(후반) F:반일휴가(토요일)<br/>
                  C:전일휴가 G:경조휴가 H:하계휴가 I:보건휴가<br>1:무급휴일, 3:무급자녀출산휴가, K:전일공가</td>
                <td class="td09">O:지각 P:조퇴 Q:외출</td>
              </tr>
              <tr>
                <td class="td07">근무</td>
                <td class="td09">&nbsp;</td>
                <td class="td09">A:교육(근무시간내) B:출장</td>
                <td class="td09">&nbsp;</td>
              </tr>
              <tr>
                <td class="td07">초과근무</td>
                <td class="td09" nowrap>OA:휴일특근 OB:토요특근 OC:명절특근<br>OD:명절특근(토)
                  OE:휴일연장 OF:연장근무<br>OG:야간근로 OH:야간근로(명절)</td>
                <td class="td09">&nbsp;</td>
                <td class="td09">&nbsp;</td>
              </tr>
              <tr>
                <td class="td07">기타</td>
                <td class="td09">EA: 향군(근무시간외) EB:교육(근무시간외)</td>
                <td class="td09">&nbsp;</td>
                <td class="td09">&nbsp;</td>
              </tr>
            </table>
          </td>
        </tr>
      </table>
  </tr>
  <tr><td height="16"></td></tr>
  <!------------------------->          
        </table>
      </td>
    </tr>
    
  </table>
  </form>
<%@ include file="/web/common/commonEnd.jsp" %>
