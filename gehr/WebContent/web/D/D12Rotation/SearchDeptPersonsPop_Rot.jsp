<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : 공통                                                        */
/*   2Depth Name  :                                                             */
/*   Program Name : 사원검색창                                                  */
/*   Program ID   : SearchDeptPersonsPop_Rot.jsp                                */
/*   Description  : 사원검색창(대리신청)                                        */
/*   Note         : 없음                                                        */
/*   Creation     : 2005-01-07  윤정현                                          */
/*   Update       :                                                             */
/*                                                                              */
/*                                                                              */
/********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/popupPorcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.D.D12Rotation.*" %>
<%@ page import="hris.D.D12Rotation.rfc.*" %>
<%@ page import="com.sns.jdf.util.*" %>

<%
    WebUserData user                   = (WebUserData)session.getAttribute("user");
    boolean isFirst             = true;
    Vector  D12RotationSearchData_vt = new Vector();

    String  count               = request.getParameter("count");
    long    l_count             = 0;
    if( count != null ) {
        l_count                 = Long.parseLong(count);
    }
//  page 처리
    String  paging              = request.getParameter("page");

    String  jobid               = request.getParameter("jobid");
    String  i_dept              = user.empNo;
    String  e_retir             = user.e_retir;
    String  retir_chk           = request.getParameter("retir_chk");
    String  i_value1            = request.getParameter("I_VALUE1");
    String  i_gubun             = request.getParameter("I_GBN");
    String i_deptTime  = request.getParameter("I_DeptTime");

    if( i_gubun == null || i_gubun.equals("") ) {
        i_gubun = "2";
    }
    Vector ret = new Vector();
    if( jobid != null && paging == null ) {

        try{

        if(!i_deptTime.equals("Y")){
            if (i_gubun.equals("PERNRS")){//사번
                    	ret      = ( new SearchDeptNameRotRFC() ).getPernrDeptName(user.empNo,  "",       i_value1 );
            }else{
                 ret      = ( new SearchDeptNameRotRFC() ).getDeptName(user.empNo,  "",       i_value1 );
            }
        }else {
            if (i_gubun.equals("PERNR")){//사번
            	ret      = ( new SearchDeptNameRotDeptTimeRFC() ).getDeptName(user.empNo,  "",       i_value1 );
          }else{
              ret      = ( new SearchDeptNameRotDeptTimeRFC() ).getDeptName(user.empNo,       i_value1 ,  "");
          }
        }
            D12RotationSearchData_vt    = (Vector)ret.get(0);
            l_count = D12RotationSearchData_vt.size();
        }catch(Exception ex){
            D12RotationSearchData_vt = null;
        }

        isFirst = false;

    } else if( jobid != null && paging != null ) {

        isFirst = false;

        for( int i = 0 ; i < l_count ; i++ ) {
            D12RotationSearchData deptData = new D12RotationSearchData();

            deptData.SPERNR = request.getParameter("SPERNR"+i);    // /사원 번호
            deptData.OBJID = request.getParameter("OBJID"+i);    // /오브젝트 ID
            deptData.STEXT = request.getParameter("STEXT"+i);    // /오브젝트 이름
            deptData.EPERNR = request.getParameter("EPERNR"+i);    // /사원 번호
            deptData.ENAME = request.getParameter("ENAME"+i);    // /조직ID
            deptData.OBJTXT = request.getParameter("OBJTXT"+i);    // /사원 또는 지원자의 포맷된 이름

            D12RotationSearchData_vt.addElement(deptData);
        }
    }

//  PageUtil 관련 - Page 사용시 반드시 써줄것.
    PageUtil pu = null;
    if( jobid != null ) {
        try {
            pu = new PageUtil(D12RotationSearchData_vt.size(), paging , 10, 10);
          Logger.debug.println(this, "page : "+paging);
        } catch (Exception ex) {
            Logger.debug.println(DataUtil.getStackTrace(ex));
        }
    }
%>
<html>
<head>
<title>사원 검색</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr.css" type="text/css">
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr_style.css" type="text/css">
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr_wsg.css" type="text/css">

<script language="JavaScript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>

<SCRIPT LANGUAGE="JavaScript">
<!--
function init(){
<%
    if( D12RotationSearchData_vt != null ) {
        if( D12RotationSearchData_vt.size() == 1 ) {
            D12RotationSearchData data = (D12RotationSearchData)D12RotationSearchData_vt.get(0);
%>

    changeAppData("0");

<%
        }
    }
%>
}

function PageMove() {
    document.form1.action = "<%=WebUtil.JspURL%>"+"D/D12Rotation/SearchDeptPersonsPop_Rot.jsp";
    document.form1.submit();
}

function changeAppData( idx ){
    obj = new Object();

    obj.SPERNR = eval("document.form1.SPERNR"+idx+".value");   //  사원 번호
    obj.OBJID = eval("document.form1.OBJID"+idx+".value");    //  오브젝트 ID
    obj.STEXT = eval("document.form1.STEXT"+idx+".value");    //  오브젝트 이름
    obj.EPERNR = eval("document.form1.EPERNR"+idx+".value");   // 사원 번호
    obj.ENAME = eval("document.form1.ENAME"+idx+".value");    //  조직ID
    obj.OBJTXT = eval("document.form1.OBJTXT"+idx+".value");   //  사원 또는 지원자의 포맷된 이름
    opener.setPersInfo(obj);
    close();
}

function gubun_change() {
    document.form1.I_VALUE1.value    = "";
    document.form1.I_VALUE1.focus();
}

//PageUtil 관련 script - page처리시 반드시 써준다...
function pageChange(page){
    document.form1.page.value = page;
    PageMove();
}

//PageUtil 관련 script - selectBox 사용시 - Option
function selectPage(obj){
    val = obj[obj.selectedIndex].value;
    pageChange(val);
}
//-->
</SCRIPT>
<script>
//    window.resizeTo(690,490);
</script>
</head>
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="init()">
<div class="winPop">
<form name="form1" method="post" onsubmit="return false">

    <div class="header">
        <span><!--사원검색--><%=g.getMessage("LABEL.D.D12.0048")%></span>
        <a href="javascript:self.close();"><img src="<%=WebUtil.ImageURL%>sshr/btn_popup_close.png" /></a>
    </div>


    <div class="body">
        <div class="listArea">
<%
    if ( D12RotationSearchData_vt != null && D12RotationSearchData_vt.size() > 0 ) {
%>
            <div class="listTop">
                <span class="listCnt"><%= pu == null ? "" : pu.pageInfo() %></span>
            </div>
<%
    }
%>

            <div class="table">
                <table class="listTable">
                  <tr>
                    <th><!--  선택--><%=g.getMessage("LABEL.D.D12.0049")%></th>
                    <th><!--  사번--><%=g.getMessage("LABEL.D.D15.0149")%></th>
                    <th><!--  성명--><%=g.getMessage("LABEL.D.D12.0018")%></th>
                    <th class="lastCol"><!--  부서--><%=g.getMessage("LABEL.D.D12.0051")%></th>

                  </tr>
<%
   if( !isFirst ){
        if( D12RotationSearchData_vt != null && D12RotationSearchData_vt.size() > 0 ){
            for( int i = pu.formRow() ; i < pu.toRow(); i++ ) {
                D12RotationSearchData D12RotationSearchData = (D12RotationSearchData)D12RotationSearchData_vt.get(i);
%>
              <tr>
                <td><input type="radio" name="radiobutton" value="radiobutton" onClick="javascript:changeAppData('<%= i %>');"></td>
                <td><%=WebUtil.printString( D12RotationSearchData.EPERNR )%></td>
                <td><%=WebUtil.printString( D12RotationSearchData.ENAME )%></td>
                <td class="lastCol"><%=WebUtil.printString( D12RotationSearchData.STEXT )%></td>

              </tr>
<%
            }

            for( int i = 0 ; i < D12RotationSearchData_vt.size(); i++ ) {
                D12RotationSearchData D12RotationSearchData = (D12RotationSearchData)D12RotationSearchData_vt.get(i);
%>
              <input type="hidden" name="SPERNR<%= i %>" value="<%= D12RotationSearchData.SPERNR %>">
              <input type="hidden" name="OBJID<%= i %>" value="<%= D12RotationSearchData.OBJID %>">
              <input type="hidden" name="STEXT<%= i %>" value="<%= D12RotationSearchData.STEXT %>">
              <input type="hidden" name="EPERNR<%= i %>" value="<%= D12RotationSearchData.EPERNR %>">
              <input type="hidden" name="ENAME<%= i %>" value="<%= D12RotationSearchData.ENAME %>">
              <input type="hidden" name="OBJTXT<%= i %>" value="<%= D12RotationSearchData.OBJTXT %>">
<%
            }
%>
                </table>
                <div class="align_center"><%= pu == null ? "" : pu.pageControl() %></div>
            </div>
        </div>

<%
        } else {

%>
                    <tr class="oddRow">
                        <td class="lastCol" colspan="<%= e_retir.equals("Y") ? "9" : "8" %>"><!--인사정보 조회대상이 아니거나 사원마스터가 없습니다.--><%=g.getMessage("MSG.D.D12.0024")%></td>
                    </tr>
                </table>
            </div>
        </div>

<%
        }
%>


<%
    }
%>

        <div class="buttonArea">
            <ul class="btn_crud">
                <li><a href="javascript:self.close()"><span><%=g.getMessage("BUTTON.COMMON.CLOSE")%></span></a></li>
            </ul>
        </div>

    </div>

  <input type="hidden" name="I_VALUE1" value="<%= ( i_value1 == null || i_value1.equals("") ) ? "" : i_value1 %>">
  <input type="hidden" name="jobid"    value="">
  <input type="hidden" name="I_DEPT"   value="<%= user.empNo %>">
  <input type="hidden" name="E_RETIR"  value="<%= e_retir  %>">
  <input type="hidden" name="page"     value="">
  <input type="hidden" name="count"    value="<%= l_count %>">
  <input type="hidden" name="empNo"    value="">
<input type="hidden" name="I_DeptTime"   value="<%= i_deptTime  %>">
</form>
<form name="form2" method="post">
    <input type="hidden" name="empNo"   value="">
    <input type="hidden" name="i_dept"  value="">
    <input type="hidden" name="e_retir" value="">
    <input type="hidden" name="i_stat2" value="">
</form>
</div>
<%@ include file="/web/common/commonEnd.jsp" %>