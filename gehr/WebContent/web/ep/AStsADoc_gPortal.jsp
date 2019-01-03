<%/*****************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : 공통                                                        */
/*   2Depth Name  : 인원현황                                                    */
/*   Program Name : 초기화면                                                    */
/*   Program ID   : AStsADoc_gPortal.jsp                                        */
/*   Description  : 초기화면을 위한 jsp 파일                                    */
/*   Note         : 없음                                                        */
/*   Creation     : 2005-02-15 유용원                                           */
/*   Update       : 2013-11-18 lsa  G포탈 HR센터 메인 포틀릿 : 개인휴가 ,부서휴가*/
/*                                                                              */
/********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%-- @ include file="/web/common/commonProcess.jsp" --%>
<%@ page errorPage="/web/err/error.jsp"%>
<%@ page import="hris.common.*" %>
<%@ page import="hris.G.G001Approval.*" %>
<%@ page import="hris.A.A16Appl.rfc.*" %>
<%@ page import="hris.A.A16Appl.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.lang.*" %>
<%@ page import="com.sns.jdf.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%@ page import="hris.common.WebUserData" %> 

 <%@ include file="ep.jspf" %>
<%
	String ep_server = "";
	if(_debug)
		//ep_server = "epsvr1.lgchem.com:8101";
		ep_server = "epdev.lgchem.com:8101";
	else
		ep_server = "gportal.lgchem.com";

    WebUserData user = null;
    user = (WebUserData)session.getAttribute("epuser");
     
    if(user == null)
        user = (WebUserData)session.getAttribute("user");

    int appFlag = user.e_authorization.indexOf("W");    //결재권한여부.
    int orgFlag = user.e_authorization.indexOf("M");    //조직도권한여부.
    int insaFlag = user.e_authorization.indexOf("H");    //인사담당
    Vector vcInit = (new InitViewRFC()).getInitViewData(user.empNo ,user.e_objid ,user.e_authorization);
    //Logger.debug.println(this ,user.empNo + "\t" + user.e_objid + "\t" + user.e_authorization);

    String webUserID = "";

    if (user.webUserId == null ||user.webUserId.equals("") )
        webUserID = "";
    else
        webUserID = user.webUserId.substring(0,6).toUpperCase();

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=8" />
<title></title> 

<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/hrService.css" type="text/css">
<script language="JavaScript" type="text/JavaScript">
<!--
    function MM_preloadImages() { //v3.0
      var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
        var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
        if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
    }

    function MM_findObj(n, d) { //v4.01
      var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
        d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
      if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
      for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
      if(!x && d.getElementById) x=d.getElementById(n); return x;
    }

    // 결재 해야 할 문서
    function viewDetail1(UPMU_TYPE, AINF_SEQN)
    {
        document.form2.isEditAble.value = "false";
        document.form2.AINF_SEQN.value = AINF_SEQN;
        document.form2.action = "<%=WebUtil.ServletURL%>hris.G.G000ApprovalDocMapSV";
        document.form2.RequestPageName.value = "";
        document.form2.jobid.value = "";
        parent.location.href = "http://<%=ep_server%>/portal/lgchemMenu/lgchemHrMenu.do?menu=hrApproval&url=<%=WebUtil.ServletURL%>hris.G.G000ApprovalDocMapSV&isEditAble=false&AINF_SEQN="+AINF_SEQN;
    }

    // 신청 진행현황
    function viewDetail2(UPMU_TYPE, AINF_SEQN)
    {
        document.form2.isEditAble.value = "true";
        document.form2.AINF_SEQN.value = AINF_SEQN;
        document.form2.action = "<%=WebUtil.ServletURL%>hris.G.G000ApprovalDocMapSV";
        document.form2.RequestPageName.value = "";
        document.form2.jobid.value = "";
//        parent.location.href = "http://<%=ep_server%>/portal/lgchemMenu/lgchemHrMenu.do?menu=hrApply&url=<%=WebUtil.ServletURL%>hris.G.G000ApprovalDocMapSV&sEditAble=true&AINF_SEQN="+AINF_SEQN;
        parent.location.href = "http://<%=ep_server%>/portal/lgchemMenu/lgchemHrMenu.do?menu=hrApproval&url=&url=<%=WebUtil.ServletURL%>hris.G.G000ApprovalDocMapSV&sEditAble=true&AINF_SEQN="+AINF_SEQN;

    }

    function chngTable(sw)
    {
       if (sw == 2) { 
           tab2.style.display ="block";
           tab1.style.display ="none";
           approval.style.display ="block";
           request.style.display ="none";
       } else if (sw ==1) { 
           tab1.style.display ="block";
           tab2.style.display ="none";
           approval.style.display ="none";
           request.style.display ="block";
       } // end if
    }

//-->
</script>
</head>
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<%
    //결재권한이 있는 경우.(20050303:유용원)
    if( appFlag > 0 ){
%>

<!-- HR Service bottom Contents Start -->
    	<!--<div class="HR_bottomC">-->
        	<div class="HR_bottomC_board">
        		<h4>결재 신청정보</h4>
        		<div style="display : block;font-size:14px; margin:0 0 25px 1px;" id="tab1">
            		<span><a href="#" onMouseOver= "chngTable(1)" style="cursor:'hand'"><b>신청진행현황</b></a></span> | 
            		<span><a href="#" onMouseOver= "chngTable(2)" style="cursor:'hand'">결재해야할문서</a></span> 
            		</div>
 
        		<div style="display : none;font-size:14px; margin:0 0 25px 1px;" id="tab2">
            		<span><a href="#" onMouseOver= "chngTable(1)" style="cursor:'hand'">신청진행현황</a></span> | 
            		<span><a href="#" onMouseOver= "chngTable(2)" style="cursor:'hand'"><b>결재해야할문서</b></a></span> 
            		</div>  
                <table id = "request"  style="display: block;">
                	<colgroup>
                    	<col width="136px*" />
                        <col width="150px" />
                        <col width="150px" />
                    </colgroup>
                	<tbody>
            <!-- 신청진행현황 테이블 시작 -->
            <%  Vector A16ApplListData_vt = (Vector)vcInit.get(1); %>
            <% for( int i = 0 ; i < A16ApplListData_vt.size() && i < 4; i++ ) { %>
                <%  A16ApplListData data = (A16ApplListData)A16ApplListData_vt.get(i);
                    String statText = "";
                    //01 신청 ,02 결재진행중 ,03 결재완료 ,04 반려
                    if ("01".equals(data.STAT_TYPE)) {
                        statText = "신청";
                    } else if ("02".equals(data.STAT_TYPE)) {
                        statText = "결재진행중";
                    } else if ("03".equals(data.STAT_TYPE)) {
                        statText = "결재완료";
                    } else if ("04".equals(data.STAT_TYPE)) {
                        statText = "반려";
                    } // end if
                %>                	
                    	<tr>
                            <th><a href="javascript:viewDetail2('<%= data.UPMU_TYPE %>', '<%= data.AINF_SEQN %>');"><%= data.UPMU_NAME.trim() %></a></th>
                            <td><%=statText%></td>
                            <td><%= WebUtil.printDate(data.BEGDA,"-")%></td>
                        </tr>
            <% } // end for%>     

            <% if (A16ApplListData_vt.size() == 0 ) { %>
                    	<tr>
                            <th colspan=3>&nbsp;&nbsp;해당 데이터가 없습니다.</td>
                        </tr>                        
            <% } // end  %> 
                    </tbody>
                </table>
                <table  id = "approval" style="display : none">
                	<colgroup>
                    	<col width="86px" />
                        <col width="200px" />
                        <col width="80px" />
                        <col width="70px" />
                    </colgroup>
                	<tbody>
                	
            <!-- 결재해야할문서 테이블 끝 -->
            <%   Vector vcApprovalDocList = (Vector)vcInit.get(0); %>
            <% for (int i = 0; i < vcApprovalDocList.size() && i < 4; i++) { %>
                <%
                    ApprovalDocList apl = (ApprovalDocList)vcApprovalDocList.get(i);
                    String bgColor = (i % 2) == 0 ? "bgcolor=\"F4F4F4\"" : "";
                %>        
            	
                    	<tr>
                            <th><a href="javascript:viewDetail1('<%=apl.UPMU_TYPE%>','<%=apl.AINF_SEQN%>')"><%=apl.UPMU_NAME%></a></th><!--업무구분-->
                            <td><%=apl.STEXT%></td><!--부서-->
                            <td><%=apl.ENAME%></td><!--신청자-->
                            <td><%=apl.BEGDA%></td><!--날짜-->
                        </tr>
            <% } // end for%> 
            <% if (vcApprovalDocList.size() == 0 ) { %> 
            
                    	<tr>
                            <th colspan=3>&nbsp;&nbsp;해당 데이터가 없습니다.</td>
                        </tr>                           
            <% } // end  %>                
                    </tbody>
                </table>
            </div>
    <!--</div>-->
 
    <!--// HR Service End -->
<%
    //결재권한이 없는 경우..
    }else{
%>
        <!-- HR Service bottom Contents Start -->
    	<!--<div class="HR_bottomC">-->
        	<div class="HR_bottomC_board">
            	<h4>결재 신청정보</h4>
                <h5>신청진행현황</h5>
                <table>
                	<colgroup>
                    	<col width="136px" />
                        <col width="150px" />
                        <col width="150px" />
                    </colgroup>
                	<tbody>
            <%  Vector A16ApplListData_vt = (Vector)vcInit.get(1); %>
            <% for( int i = 0 ; i < A16ApplListData_vt.size() && i < 4; i++ ) { %>
                <%  A16ApplListData data = (A16ApplListData)A16ApplListData_vt.get(i);
                    String statText = "";
                    //01 신청 ,02 결재진행중 ,03 결재완료 ,04 반려
                    if ("01".equals(data.STAT_TYPE)) {
                        statText = "신청";
                    } else if ("02".equals(data.STAT_TYPE)) {
                        statText = "결재진행중";
                    } else if ("03".equals(data.STAT_TYPE)) {
                        statText = "결재완료";
                    } else if ("04".equals(data.STAT_TYPE)) {
                        statText = "반려";
                    } // end if
                %>                	
                    	<tr>
                        	<th><a href="javascript:viewDetail2('<%= data.UPMU_TYPE %>', '<%= data.AINF_SEQN %>');"><%= data.UPMU_NAME.trim() %></a></th>
                            <td><%=statText%></td>
                            <td><%= WebUtil.printDate(data.BEGDA,"-")%></td>
                        </tr>
            <% } // end for%> 
            
            <% if (A16ApplListData_vt.size() == 0 ) { %>
                    	<tr>
                            <th colspan=3>&nbsp;&nbsp;해당 데이터가 없습니다.</td>
                        </tr>                        
            <% } // end  %> 
                    </tbody>
                </table>
            
        </div>
        <!--// HR Service bottom Contents End -->
    <!--</div>-->
    <!--// HR Service End -->
<%
    } //end if
%>
<form name="form2" method="post">
  <input type="hidden" name="AINF_SEQN">
  <input type="hidden" name="isEditAble">
  <input type="hidden" name="RequestPageName" >
  <input type="hidden" name="jobid">
</form>

</body>
</html>
<%
String mainlogin = (String)session.getAttribute("mainlogin");

//if(mainlogin == null)
if(false)
{
%>
<iframe src="/ep/sessionremove.jsp" width="0" height="0">
<%
}
%>