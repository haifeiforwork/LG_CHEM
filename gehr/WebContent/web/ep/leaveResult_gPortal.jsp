<%/*****************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : 공통                                                        */
/*   2Depth Name  : 인원현황                                                    */
/*   Program Name : 초기화면                                                    */
/*   Program ID   : leaveResult_gPortal.jsp                                     */
/*   Description  : 초기화면을 위한 jsp 파일                                    */
/*   Note         : 없음                                                        */
/*   Creation     : 2013-11-18 lsa                                              */
/*   Update       : G포탈 HR센터 메인 포틀릿 : 개인휴가 ,부서휴가		*/
/*                                                                              */
/********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
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
<%
    ViewEmpVacationData empVacationData = (ViewEmpVacationData)((Vector)vcInit.get(2)).get(0);
%>

	function tabChgEHR(nu) {



            <%
                //관리자 일경우 사전부여휴가 대신 휴가사용율을 보여줌.
                if(orgFlag>0 || !empVacationData.OCCUR1.equals("") && !empVacationData.OCCUR1.equals("0")){
            %>

        if(nu == '0'){
            firstTD.background = '<%= WebUtil.ImageURL %>ep/r_temp_schedule_stitleback.gif';
            secondTD.background = '<%= WebUtil.ImageURL %>ep/r_temp_schedule_dtitleback02.gif';
            t7Menu00_OFF.style.display='block';
            t7Menu01_OFF.style.display='none';
         }else if(nu == '1'){

            firstTD.background = '<%= WebUtil.ImageURL %>ep/r_temp_schedule_dtitleback.gif';
            secondTD.background = '<%= WebUtil.ImageURL %>ep/r_temp_schedule_stitleback02.gif';
            t7Menu00_OFF.style.display='none';
            t7Menu01_OFF.style.display='block';
         }
        <%
        }
        %>
	}

//-->
</script>
</head>
<%
String laf = request.getParameter("laf");
%>

<body>
    <!-- HR Service Start -->
    <!--div class="HR_wrapper"-->
    	<!-- HR Service top Contents Start -->
    	<div class="HR_img">
        	<div class="HR_vacationBox HR_private">
            	<h2 class="HR_vacationBox_title">개인휴가</h2>
                <div class="HR_vacationBox_detail">
                	<ul>
                        <li>
                            <span><%= WebUtil.printNumFormat(empVacationData.OCCUR,1) %></span>
                            <h3>발생일수</h3>
                        </li>
                        <li>
                            <span><%= WebUtil.printNumFormat(empVacationData.ABWTG,1) %></span>
                            <h3>사용일수</h3>
                        </li>
                        <li>
                            <span class="HR_vacationBox_left"><%= WebUtil.printNumFormat(empVacationData.ZKVRB,1) %></span>
                            <h3>잔여일수</h3>
                        </li>
                    </ul>
                </div>
            </div>
            <%
                //관리자 일경우 사전부여휴가 대신 휴가사용율을 보여줌.
                if(orgFlag>0){
                    ViewDeptVacationData deptVacationData = (ViewDeptVacationData)((Vector)vcInit.get(3)).get(0);
            %>            
            <div class="HR_vacationBox HR_group">
            	<h2 class="HR_vacationBox_title">부서휴가<span>(<%= deptVacationData.CONSUMRATE %>%)</span></h2>
                <div class="HR_vacationBox_detail">
                	<ul>
                        <li>
                            <span><%= WebUtil.printNumFormat(deptVacationData.OCCUR,1) %></span>
                            <h3>발생일수</h3>
                        </li>
                        <li>
                            <span><%= WebUtil.printNumFormat(deptVacationData.ABWTG,1) %></span>
                            <h3>사용일수</h3>
                        </li>
                        <li>
                            <span class="HR_vacationBox_left"><%= WebUtil.printNumFormat(deptVacationData.ZKVRB,1) %></span>
                            <h3>잔여일수</h3>
                        </li>
                    </ul>
                </div>
            </div>
            <%   
                }else{
                    //사전부여휴가
                    if (!empVacationData.OCCUR1.equals("") && !empVacationData.OCCUR1.equals("0")) {
            %> 
            <div class="HR_vacationBox HR_group">
            	<h2 class="HR_vacationBox_title">사전휴가</h2>
                <div class="HR_vacationBox_detail">
                	<ul>
                        <li>
                            <span><%= WebUtil.printNumFormat(empVacationData.OCCUR1,1) %></span>
                            <h3>발생일수</h3>
                        </li>
                        <li>
                            <span><%= WebUtil.printNumFormat(empVacationData.ABWTG1,1) %></span>
                            <h3>사용일수</h3>
                        </li>
                        <li>
                            <span class="HR_vacationBox_left"><%= WebUtil.printNumFormat(empVacationData.ZKVRB1,1) %></span>
                            <h3>잔여일수</h3>
                        </li>
                    </ul>
                </div>
            </div>
        <%	  	}//사전휴가 end
              }//부서휴가 end
        %>
        </div>
        <!--// HR Service top Contents End --> 
   
        <!--/div-->
    <!--// HR Service End -->
</body>
</html>
<input type=hidden name="7">
<%
String mainlogin = (String)   session.getAttribute("mainlogin");

//if(mainlogin == null)
if(false)
{
%>
<iframe src="/ep/sessionremove.jsp" width="0" height="0">
<%
}
%>
