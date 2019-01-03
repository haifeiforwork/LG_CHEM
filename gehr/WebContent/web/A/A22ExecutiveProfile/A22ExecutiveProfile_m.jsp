<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 임원 Profile                                          */
/*   Program Name : 임원 Profile                                         */
/*   Program ID   : A22ExecutiveProfile_m.jsp                                         */
/*   Description  : 임원 Profile                                              */
/*   Note         :                                                             */
/*   Creation     : 2016-05-30 rdcamel      [CSR ID:3089281] 임원 1Page 프로파일 시스템 개발 요청의 건.                                                       */
/*   Update       :                      */
/********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.A.*" %>
<%@ page import="hris.D.D05Mpay.rfc.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%
	WebUserData user_m = WebUtil.getSessionMSSUser(request);
	WebUserData user = WebUtil.getSessionUser(request);

	Vector a22StrengthData_vt    = (Vector)request.getAttribute("a22StrengthData_vt");     // 성과
	Vector a22LeadershipData_vt    = (Vector)request.getAttribute("a22LeadershipData_vt");     //리더십

	Vector a22busi_vt    = (Vector)request.getAttribute("a22busi_vt");     //사업가후보
	Vector a22punish_vt    = (Vector)request.getAttribute("a22punish_vt");     //징계
	Vector a22edu_vt    = (Vector)request.getAttribute("a22edu_vt");     //교육이력
	Vector a22role_vt    = (Vector)request.getAttribute("a22role_vt");     //역할급
	Vector a22career_vt    = (Vector)request.getAttribute("a22career_vt");     //직위
	Vector a22school_vt    = (Vector)request.getAttribute("a22school_vt");     //학력
	Vector a22language_vt    = (Vector)request.getAttribute("a22language_vt");     //어학
	Vector a22Info_vt    = (Vector)request.getAttribute("a22Info_vt");     //인사기본정보
	String imwonAge = (String)request.getAttribute("imwonAge");
	String geunsokAge = (String)request.getAttribute("geunsokAge");

	String imgUrl = (String)request.getAttribute("imgUrl");
	Double age = 0.00;

	A22resultOfProfileData data   = new A22resultOfProfileData();
	if (a22Info_vt != null && a22Info_vt.size() > 0 ) {
		data = (A22resultOfProfileData)a22Info_vt.get(0);
	}
	int insaFlag = user.e_authorization.indexOf("H");    //인사담당

	//화상조직도에서  조회하는 화면일 경우 처리 2015-06-18
	String ViewOrg = WebUtil.nvl(request.getParameter("ViewOrg"));

	int row_num = 21;//직위/직책 line 수
%>
<jsp:include page="/include/header.jsp" />

<SCRIPT LANGUAGE="JavaScript">
    <!--
    //상단 인원 검색 용 공통 function
    function  doSearchDetail() {
        document.form1.action = "<%= WebUtil.ServletURL %>hris.A.A22ExecutiveProfile.A22ExecutiveProfileSV_m?jobid2=first";
        document.form1.method = "post";
        document.form1.target = "";
        document.form1.submit();
        //document.form1.reload();
    }

    function go_Profileprint(){

        window.open('', 'essPrintWindow', "toolbar=no,location=no, directories=no,status=no,menubar=yes,resizable=no,width=1430,height=842,left=80,top=2");
        document.form1.target = "essPrintWindow";
        //document.form1.action = "<%= WebUtil.JspURL %>common/printFrame_Executive_Profile.jsp";
        document.form1.action = "<%= WebUtil.ServletURL %>hris.A.A22ExecutiveProfile.A22ExecutiveProfileSV_m?jobid2=print";
        document.form1.method = "post";
        document.form1.submit();

    }

    function chartPrint(){
        <%if ( user_m != null && "X".equals(user_m.e_mss) && "11".equals(user_m.e_persk)  ) {%>
        window.open('', 'essPrintWindow', "toolbar=0,location=50,directories=0,status=0,menubar=1,resizable=0,width=1330,height=890,scrollbars=yes");
        document.form1.jobid2.value = "print";
        document.form1.target = "essPrintWindow";
        document.form1.action = '<%= WebUtil.ServletURL %>hris.A.A22ExecutiveProfile.A22ExecutiveProfileSV_m';
        document.form1.method = "post";
        document.form1.submit();
        <%}%>
    }

    $(function() {
        chartPrint();
    });
    //-->
</SCRIPT>

<!-- body header 부 title 및 body 시작 부 선언 -->
<jsp:include page="/include/body-header.jsp">
	<jsp:param name="title" value="COMMON.MENU.MSS_PA_EXEU_FILES"/>
</jsp:include>
<form name="form1" method="post" onsubmit="return false">
	<%if(ViewOrg.equals("")){ %>
	<!--   사원검색 보여주는 부분 시작   -->
	<%@ include file="/web/common/SearchDeptPersons_m.jsp" %>
	<!--   사원검색 보여주는 부분  끝    -->
	<%} %>

	<input type="hidden" name="jobid2"   value="">
	<input type="hidden" name="licn_code" value="">
	<input type="hidden" name="I_IMWON" value="X">
</form>
<jsp:include page="/include/body-footer.jsp" />
<jsp:include page="/include/footer.jsp" />
