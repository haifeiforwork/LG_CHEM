<%@ page import="com.sns.jdf.util.WebUtil" %>
<%/******************************************************************************/
/*                                                                              */
/*   System Name  : e-HR                                                     */
/*   1Depth Name  : HR 결재                                                     */
/*   2Depth Name  : 결재 해야할 문서 리스트                                     */
/*   Program Name : 결재 해야할 문서                                            */
/*   Program ID   : G001ApprovalDocList.jsp                                     */
/*   Description  : 문서 목록보기                                               */
/*   Note         : 없음                                                        */
/*   Creation     : 2003-03-26  이승희                                          */
/*   Update       : 2003-03-26  이승희                                          */
/*   Update       : 2007-10-17  @v1.0 석유화학이관사번만 결재할문서 11~5일까지막음*/
/*                              @v2.0 결재할문서 메뉴정리                       */
/*                      2017-10-20 eunha [CSR ID:3500559] 의료비지원 기준 변경에 대한 요청의 건                                */
/*                                                                              */
/********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ page errorPage="/web/err/error.jsp"%>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="tags-approval" tagdir="/WEB-INF/tags/G" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<c:set var="user" value="<%=WebUtil.getSessionUser(request)%>"/>
<tags-approval:approval-list-layout>
    <tags:script>
        <script>
      //[CSR ID:3500559] 의료비지원 기준 변경에 대한 요청의 건 start
       <%-- $(function() {
            <c:if test="${isHospital}">
	            alert('<spring:message code="MSG.E.E17.0031" />');
            </c:if>
        });--%>
      //[CSR ID:3500559] 의료비지원 기준 변경에 대한 요청의 건 end
        </script>
    </tags:script>
    <table class="listTable noover">
        <thead>
        <tr>
            <th><input type="checkbox" id="allCheck" onClick = "checkAll(this.checked)"></th>
            <th><spring:message code="LABEL.G.G01.0001" /><!-- 순번 --></th>
            <th><spring:message code="LABEL.G.G01.0010" /><!-- 업무 구분 --></th>
            <th><spring:message code="MSG.APPROVAL.0015" /><!-- 부서 --></th>
            <th><spring:message code="LABEL.G.G01.0003" /><!-- 신청자 --></th>
            <th class="lastCol"><spring:message code="LABEL.G.G01.0004" /><!-- 신청일 --></th>
        </tr>
        </thead>
            <%--@elvariable id="resultList" type="java.util.Vector<hris.G.G001Approval.ApprovalDocList>"--%>
        <c:set var="rowCount" value="0"/>
        <c:forEach var="row" items="${resultList}" varStatus="status" begin="${pu.from}" end="${pu.to > 0 ? pu.to - 1 : pu.to}">
            <c:set var="rowCount" value="${status.count}"/>
            <tr id="row_${status.index}" class="${f:printOddRow(status.index)}" data-type="${row.UPMU_TYPE}" data-pernr="${row.PERNR}"  data-seq="${row.AINF_SEQN}" >
                <td>
                    <input type="checkbox" class="approvalSeq" name="approvalSeq"  value="${row.AINF_SEQN}" ${f:isMultiApproval(g.sapType, row.UPMU_TYPE, row.APPU_TYPE, row.APPR_SEQN) ? "" : "disabled"}>
                    <input type="hidden" name="AINF_SEQN" value="${row.AINF_SEQN}" >
                    <input type="hidden" name="BUKRS" value = "${row.BUKRS}">
                    <input type="hidden" name="PERNR" value = "${row.PERNR}">
                    <input type="hidden" name="ENAME" value = "${row.ENAME}">
                    <input type="hidden" name="BEGDA" value = "${row.BEGDA}">
                    <input type="hidden" name="UPMU_FLAG" value = "${row.UPMU_FLAG}">
                    <input type="hidden" name="UPMU_TYPE" value = "${row.UPMU_TYPE}">
                    <input type="hidden" name="UPMU_NAME" value = "${row.UPMU_NAME}">
                    <input type="hidden" name="APPR_TYPE" value = "${row.APPR_TYPE}">
                    <input type="hidden" name="APPU_TYPE" value = "${row.APPU_TYPE}">
                    <input type="hidden" name="APPR_SEQN" value = "${row.APPR_SEQN}">

                    <input type="hidden" name="OBJID"     value = "${row.OBJID}">
                    <input type="hidden" name="APPU_NUMB" value = "${row.APPU_NUMB}">
                    <input type="hidden" name="APPR_STAT" value = "">
                </td>
                <td>${pu.from + status.count}</td>
                <td style="cursor: pointer;" <c:if test="${isLocal != true}"> onClick="viewDetail(${status.index});" </c:if> >
                    ${row.UPMU_NAME}
                    <c:if test="${isLocal == true}">
                        (${row.AINF_SEQN})
                    </c:if>
                </td>
                <td class="align_left" style="cursor: pointer;" onClick="viewDetail(${status.index});">${row.STEXT}</td>
                <td>${row.ENAME}</td>
                <td class="lastCol">${f:printDate(row.BEGDA)}</td>
            </tr>
        </c:forEach>
        <c:if test="${f:getSize(resultList) <= pu.from}">
            <tags:table-row-nodata list="${resultList}" col="7" />
        </c:if>
        <input type="hidden" name="rowCount" value="${rowCount}"/>

    </table>
</tags-approval:approval-list-layout>




<%--








<%@ page import="java.util.Vector" %>
<%@ page import="com.sns.jdf.util.*" %>
<%@ page import="hris.G.G001Approval.*"%>
<%@ page import="hris.common.rfc.*"%>

<%
    WebUserData      user    = (WebUserData)session.getAttribute("user");

    Vector vcApprovalDocList = (Vector) request.getAttribute("vcApprovalDocList");
    ApprovalListKey alk = (ApprovalListKey) request.getAttribute("ApprovalListKey");

    Vector vcUpmucode = ( new UpmuCodeRFC() ).getUpmuCode(user.companyCode);

    String paging             = (String)request.getAttribute("page");

    //PageUtil 관련 - Page 사용시 반드시 써줄것.
    PageUtil pu = null;
    try {
        pu = new PageUtil(vcApprovalDocList.size(), paging , 10, 10);
      Logger.debug.println(this, "page : "+paging);
    } catch (Exception ex) {
        Logger.debug.println(DataUtil.getStackTrace(ex));
    }
%>
<html>
<head>
<title>ESS</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr2.css" type="text/css">
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr_style.css" type="text/css">
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr_wsg.css" type="text/css">

<script language="JavaScript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>
<script language="JavaScript" type="text/JavaScript">
<!--


//-->
</script>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<!---- waiting message start-->
<DIV id="waiting" style="Z-INDEX: 1; LEFT: 50px; VISIBILITY: hidden; WIDTH: 250px; POSITION: absolute; TOP: 120px; HEIGHT: 45px">
<TABLE cellSpacing=1 cellPadding=0 width="98%" bgColor=black border=0>
  <TBODY>
  <TR bgColor=white>
    <TD>
      <TABLE cellSpacing=0 cellPadding=0 width="100%" border=0>
        <TBODY>
        <TR>
          <TD class=icms align=middle height=70 id = "job_message">검색중입니다... 잠시만 기다려주십시요 </TD>
        </TR>
        </TBODY>
      </TABLE>
    </TD>
  </TR>
  </TBODY>
</TABLE>
</DIV>
<!---- waiting message end-->

<form name="form1" method="post" action="">
<input type="hidden" name="RequestPageName" >
<input TYPE="hidden" name="jobid" value="">
<input TYPE="hidden" name="GUBUN" value="<%=alk.I_AGUBN %>">

<div class="subWrapper">
    <div class="title"><h1>결재해야할 문서</h1></div>

    <!--  검색테이블 시작 -->
    <div class="tableInquiry">
        <table>
            <tr>
                <th>업무항목</th>
                <td>
                    <select name="UPMU_TYPE" >
                        <option value="">선택하세요 </option>
   <%
    //입학축하금신청:05,개인연금신청:02,개인연금해약신청:26,가족수당신청:24,가족수당해약신청:29
    for( int i = 0 ; i < vcUpmucode.size() ; i++ ) {
        com.sns.jdf.util.CodeEntity ck = (com.sns.jdf.util.CodeEntity)vcUpmucode.get(i);

        if (!(ck.code.equals("05")||ck.code.equals("02")||ck.code.equals("26")||ck.code.equals("24")||ck.code.equals("29")) ) {
   %>
        <option value="<%=ck.code%>"><%=ck.value %></option>
   <%
        }
    }
   %>
                    </select>
                </td>
                <th>신청자 사번</th>
                <td>
                    <input type="text" name="APPL_PERNR" value="<%=alk.I_ITPNR%>" size="10" maxlength = "8">
                </td>
            </tr>
            <tr>
                <th>신청일자</th>
                <td colspan="3">
                    <input name="BEGDA" type="text" size="11" maxlenth="10" value="<%=WebUtil.printDate(alk.I_BEGDA)%>">
                    <a href="javascript:fn_openCal('BEGDA')"><img src="<%= WebUtil.ImageURL %>sshr/ico_calendar.gif" alt="날짜검색" border="0"></a>
                    ~
                    <input name="ENDDA" type="text"  size="11" maxlenth="10" value="<%=WebUtil.printDate(alk.I_ENDDA)%>">
                    <a href="javascript:fn_openCal('ENDDA')"><img src="<%= WebUtil.ImageURL %>sshr/ico_calendar.gif" alt="날짜검색" border="0"></a>
                    <span>(예 : 2005.01.28)</span>
                </td>
                <td>
                    <div class="tableBtnSearch">
                        <a href="javascript:doSubmit()" class="search"><span>조회</span></a>
                    </div>
                </td>
            </tr>
        </table>
    </div>
    <!--  검색테이블 끝-->

    <!-- 리스트테이블 시작 -->
    <div class="listArea">
        <div class="listTop">
            <span class="listCnt"><%= pu == null ? "" : pu.pageInfo() %></span>
        </div>
        <div class="table">
            <table class="listTable">
                <tr>
                    <th><input type="checkbox" onClick = "allSetValue(this.checked)"></th>
                    <th>순번</th>
                    <th> 업무 구분 </th>
                    <th>부서</th>
                    <th>신청자</th>
                    <th class="lastCol">신청일</th>
                </tr>
<%          for( int i = pu.formRow() ; i < pu.toRow(); i++ ) {
                     ApprovalDocList apl = (ApprovalDocList)vcApprovalDocList.get(i);
                     int index = i - pu.formRow();

                        String tr_class = "";

                        if(i%2 == 0){
                            tr_class="oddRow";
                        }else{
                            tr_class="";
                        }
 %>
                <tr class="<%=tr_class%>">
                  <input type="hidden" name="BUKRS<%=index%>" value = "<%=apl.BUKRS%>">
                  <input type="hidden" name="PERNR<%=index%>" value = "<%=apl.PERNR%>">
                  <input type="hidden" name="ENAME<%=index%>" value = "<%=apl.ENAME%>">
                  <input type="hidden" name="BEGDA<%=index%>" value = "<%=apl.BEGDA%>">
                  <input type="hidden" name="UPMU_FLAG<%=index%>" value = "<%=apl.UPMU_FLAG%>">
                  <input type="hidden" name="UPMU_TYPE<%=index%>" value = "<%=apl.UPMU_TYPE%>">
                  <input type="hidden" name="UPMU_NAME<%=index%>" value = "<%=apl.UPMU_NAME%>">
                  <input type="hidden" name="APPR_TYPE<%=index%>" value = "<%=apl.APPR_TYPE%>">
                  <input type="hidden" name="APPU_TYPE<%=index%>" value = "<%=apl.APPU_TYPE%>">
                  <input type="hidden" name="APPR_SEQN<%=index%>" value = "<%=apl.APPR_SEQN%>">

                  <input type="hidden" name="OBJID<%=index%>"     value = "<%=apl.OBJID%>">
                  <input type="hidden" name="APPU_NUMB<%=index%>" value = "<%=apl.APPU_NUMB%>">
                  <input type="hidden" name="APPR_STAT<%=index%>" value = "">

                  <td onClick ="">
                    <input type="checkbox" name="AINF_SEQN<%=index%>" value="<%=apl.AINF_SEQN%>" <%=isCanBlock(apl)%> >
                  </td>
                  <td><%=i + 1%></td>
                  <td style="cursor: 'hand';" onClick="viewDetail('<%=apl.UPMU_TYPE%>','<%=apl.AINF_SEQN%>')"><%=apl.UPMU_NAME%></td>
                  <td style="cursor: 'hand';" onClick="viewDetail('<%=apl.UPMU_TYPE%>','<%=apl.AINF_SEQN%>')"><%=apl.STEXT%></td>
                  <td><%=apl.ENAME%></td>
                  <td class="lastCol"><%=WebUtil.printDate(apl.BEGDA)%></td>
                </tr>
                  <% } // end for %>
                   <input type="hidden" name="rowCount" value = "<%=pu.toRow() - pu.formRow()%>">
            </table>
            <div class="align_center">
                <input type="hidden" name="page" value="">
                <%= pu == null ? "" : pu.pageControl() %>
            </div>
        </div>
    </div>
    <!-- 리스트테이블 끝-->

    <!--결재버튼 들어가는 테이블 시작 -->
    <div class="buttonArea">
        <ul class="btn_crud">
            <li><a href="javascript:approval()"><span>결제</span></a></li>
        </ul>
    </div>
    <!--결재버튼 들어가는 테이블 끝 -->

    <div class="commentImportant" style="width:640px;">
        <p>※ 본화면에서의 결재버튼은 일괄로 결재가 가능한 항목에 대해서만 사용할 수 있습니다.</p>
        <p>※ 식대 결재시 퇴직자 또는 퇴직예정자에 대해서는 퇴직일 전일까지의 근무일수를 계산하여 결재바랍니다.</p>
    </div>

  </div>
  </form>
  <form name="form2" method="post">
    <input type="hidden" name="AINF_SEQN" >
    <input type="hidden" name="isEditAble" value="false">
    <input type="hidden" name="RequestPageName" >
    <input type="hidden" name="jobid">
  </form>
</body>
</html>
<%!

    private String isCanBlock(ApprovalDocList apl)
    {
        String retValue = "disabled";

        //17:초과근무,18:휴가, 23:식권영업사원
        if (apl.UPMU_TYPE.equals("17") || apl.UPMU_TYPE.equals("18") || apl.UPMU_TYPE.equals("23")) {
            retValue = "";
        } else if (   apl.APPU_TYPE.equals("02") && apl.APPR_SEQN.equals("02")) {
        //} else if ( !apl.UPMU_TYPE.equals("03")  && apl.APPU_TYPE.equals("02") && apl.APPR_SEQN.equals("02")) { //03:의료비는 팀장결재시한도금액체크하므로 일괄결재 막음
            retValue = "";
        } // end if
        return retValue;
    }
%>
--%>
