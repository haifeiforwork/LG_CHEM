<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   2Depth Name  : 가족사항                                                    */
/*   Program Name : 부양가족 변경(해지) 신청 조회                               */
/*   Program ID   : A12SupportCancelDetail.jsp                                  */
/*   Description  : 부양가족 변경(해지) 신청에 대한 상세내용을 조회하는 화면    */
/*   Note         :                                                             */
/*   Creation     : 2003-02-24  김도신                                          */
/*   Update       : 2005-03-08  윤정현                                          */
/*                      2014-12-02 [CSR ID:2654794] 부양가족 신청화면 변경요청                                                         */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.util.*" %>
<%@ page import="hris.A.A12Family.*" %>
<%@ page import="hris.A.A12Family.rfc.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%
    WebUserData user = WebUtil.getSessionUser(request);

    /* 현재 레코드를 vector로 받는다*/
    Vector              a12FamilyBuyangData_vt = (Vector)request.getAttribute("a12FamilyBuyangData_vt");
    A12FamilyBuyangData data                   = (A12FamilyBuyangData)a12FamilyBuyangData_vt.get(0);

    /* 신청할 가족 데이터 */
    A12FamilyListRFC    rfc_list               = new A12FamilyListRFC();
    Vector              a12FamilyListData_vt   = rfc_list.getFamilyList(user.empNo, data.SUBTY, data.OBJPS);
    A12FamilyListData   data_list              = (A12FamilyListData)a12FamilyListData_vt.get(0);

    /* 결제정보를 vector로 받는다*/
    Vector              AppLineData_vt         = (Vector)request.getAttribute("AppLineData_vt");
    String ThisJspName = (String)request.getAttribute("ThisJspName");
    String RequestPageName = (String)request.getAttribute("RequestPageName");
    
    // 현재 결재자 구분
    DocumentInfo docinfo = new DocumentInfo(data.AINF_SEQN ,user.empNo);
    int approvalStep = docinfo.getApprovalStep();    
%>
<html>
<head>
<title>ESS</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr.css" type="text/css">

<script language="javascript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>
<script language="JavaScript">
<!--
function do_list(){
    document.form1.jobid.value = "";
    document.form1.action = "<%=RequestPageName.replace('|','&')%>";
    document.form1.submit();
}

function do_change(){
    if( chk_APPR_STAT(0) ){
        document.form1.jobid.value = "first";
        document.form1.AINF_SEQN.value = "<%= data.AINF_SEQN %>";

        document.form1.action = "<%= WebUtil.ServletURL %>hris.A.A12Family.A12SupportCancelChangeSV";
        document.form1.method = "post";
        document.form1.submit();
    }
}

function do_delete(){
    if( chk_APPR_STAT(1) && confirm("정말 삭제하시겠습니까?") ) {
        document.form1.jobid.value     = "delete";
        document.form1.AINF_SEQN.value = "<%= data.AINF_SEQN %>";
        document.form1.SUBTY.value     = "<%= data.SUBTY %>";
        document.form1.OBJPS.value     = "<%= data.OBJPS %>";

        document.form1.action = "<%= WebUtil.ServletURL %>hris.A.A12Family.A12SupportCancelDetailSV";
        document.form1.method = "post";
        document.form1.submit();
    }
}

function do_preview(){
    document.form1.action = "<%= WebUtil.ServletURL %>hris.A.A04FamilyDetailSV";
    document.form1.method = "post";
    document.form1.submit();
}

function do_preview_1(){
    document.form1.jobid.value = "first";
    document.form1.SUBTY.value = "<%= data.SUBTY %>";
    document.form1.OBJPS.value = "<%= data.OBJPS %>";

    document.form1.action = "<%= WebUtil.ServletURL %>hris.A.A12Family.A12FamilyBuild01SV";
    document.form1.method = "post";
    document.form1.submit();
}
//-->
</script>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<form name="form1" method="post">
  <table width="796" border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td width="16">&nbsp;</td>
      <td>
        <table width="780" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td width="780">
              <table width="780" border="0" cellpadding="0" cellspacing="0">
                <tr>
                  <td height="5" colspan="2"></td>
                </tr>
                <tr>
                  <td class="font01" style="padding-bottom:2px"><img src="<%= WebUtil.ImageURL %>ehr/icon_o.gif">부양가족 변경(해지) 신청 조회</td>
                  <td class="titleRight"></td>
                </tr>
              </table></td>
          </tr>
          <tr>
            <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td class="titleLine"><img src="<%= WebUtil.ImageURL %>ehr/space.gif"></td>
                </tr>
              </table>
            </td>
          </tr>
          <tr>
            <td height="10">&nbsp;</td>
          </tr>
<%
    if ("Y".equals(user.e_representative) ) {
%>
          <!--   사원검색 보여주는 부분 시작   -->
          <%@ include file="/web/common/PersonInfo.jsp" %>
          <!--   사원검색 보여주는 부분  끝    -->
          <tr>
            <td height="10">&nbsp;</td>
          </tr>
<%
    }
%>
          <tr>
            <td>
              <!-- 상단 입력 테이블 시작-->
              <table width="780" border="0" cellspacing="1" cellpadding="5" class="table01">
                <tr>
                  <td class="tr01">
                    <table width="760" border="0" cellspacing="0" cellpadding="0" align="center">
                    <tr>
                      <td class="font01" style="padding-bottom:2px"><img src="<%= WebUtil.ImageURL %>ehr/icon_o.gif"> 대상자</td>
                    </tr>
                    <tr>
                      <td class="font01">
                        <table width="760" border="0" cellspacing="1" cellpadding="3" class="table02">
                          <tr>
                            <td class="td01" width="100">성명(한글)</td>
                            <td class="td09" width="290">
                              <input type="text" name="name" value="<%= data_list.LNMHG %> <%= data_list.FNMHG %>" class="input04" readonly>
                            </td>
                            <td class="td01" width="100">가족유형</td>
                            <td class="td09" width="290">
                              <input type="text" name="STEXT"  value="<%= data_list.STEXT %>" class="input04" size="20" readonly>
                            </td>
                          </tr>
                          <tr>
                            <td class="td01">주민등록번호</td>
                            <td class="td09">
                              <input type="text" name="regno"  value="<%= DataUtil.addSeparate(data_list.REGNO) %>" class="input04" size="20" readonly>
                            </td>
                            <td width="80" class="td01">관 계</td>
                            <td class="td09">
                              <input type="text" name="atext"  value="<%= data_list.ATEXT %>" class="input04" size="20" readonly>
                            </td>
                          </tr>
                          <tr>
                            <td class="td01">생년월일</td>
                            <td class="td09">
                              <input type="text" name="year"  value="<%= data_list.FGBDT.substring(0, 4) %>" class="input04" size="4" readonly>
                              년
                              <input type="text" name="month" value="<%= data_list.FGBDT.substring(5, 7) %>" class="input04" size="2" readonly>
                              월
                              <input type="text" name="day"   value="<%= data_list.FGBDT.substring(8, 10) %>" class="input04" size="2" readonly>
                              일
                            </td>
                            <td class="td01">성 별</td>
                            <td class="td09">
                              <input type="radio" name="fasex" value="1" <%= data_list.FASEX.equals("1") ? "checked" : "" %> disabled>
                              남
                              <input type="radio" name="fasex" value="2" <%= data_list.FASEX.equals("2") ? "checked" : "" %> disabled>
                              여
                          </td>
                          </tr>
                          <tr>
                            <td class="td01">출생지</td>
                            <td class="td09">
                              <input type="text" name="fgbot" value="<%= data_list.FGBOT %>" class="input04" size="20" readonly>
                            </td>
                            <td class="td01">학 력</td>
                            <td class="td09">
                              <input type="text" name="stext1"  value="<%= data_list.STEXT1 %>" class="input04" size="20" readonly>
                            </td>
                          </tr>
                          <tr>
                            <td class="td01">출생국</td>
                            <td class="td09">
                              <input type="text" name="landx"  value="<%= data_list.LANDX %>" class="input04" size="20" readonly>
                            </td>
                            <td class="td01">교육기관</td>
                            <td class="td09">
                              <input type="text" name="fasin"  value="<%= data_list.FASIN %>" class="input04" size="20" readonly>
                            </td>
                          </tr>
                          <tr>
                             <td class="td01">국 적</td>
                            <td class="td09">
                              <input type="text" name="natio"  value="<%= data_list.NATIO %>" class="input04" size="20" readonly>
                            </td>
                            <td class="td01">직 업</td>
                            <td class="td09">
                              <input type="text" name="FAJOB"  value="<%= data_list.FAJOB %>" class="input04" size="20" readonly>
                            </td>
                          </tr>
                        </table>
                      </td>
                    </tr>
                    <tr>
                      <td class="font01">&nbsp;</td>
                    </tr>
                    <tr>
                      <td class="font01">&nbsp;</td>
                    </tr>
                    <tr>
                     <td class="font01">
                       <table width="760" border="0" cellspacing="0" cellpadding="0">
                         <tr>
                           <td class="font01" style="padding-bottom:2px"><img src="<%= WebUtil.ImageURL %>ehr/icon_o.gif"> 종속성(세금)</td>
                           <td width="10">&nbsp;</td>
                           <td class="font01" style="padding-bottom:2px"><img src="<%= WebUtil.ImageURL %>ehr/icon_o.gif"> 종속성(기타)</td>
                         </tr>
                         <tr>
                           <td valign="top">
                             <table width="305" border="0" cellspacing="1" cellpadding="0" class="table02">
                               <tr>
                                 <td bgcolor="#FFFFFF">
                                   <table width="303" border="0" cellspacing="1" cellpadding="3">
                                     <tr>
                                       <td class="td09">
                                          <input type="checkbox" name="DPTID" value="<%= data.DPTID %>" <%= data.DPTID.equals("X") ? "checked" : "" %> disabled>
                                          부양가족
                                        </td>
                                      </tr>
                                      <tr>
                                        <td class="td09">
                                          <input type="checkbox" name="HNDID" value="<%= data.HNDID %>" <%= data.HNDID.equals("X") ? "checked" : "" %> disabled>
                                          장애인
                                        </td>
                                      </tr>
<%
    if( data.SUBTY.equals("2") ) {
%>
 <!-- 20141202 박난이S 요청(연말정산)  [CSR ID:2654794] 부양가족 신청화면 변경요청 
                                      <tr>
                                        <td class="td09">
                                          <input type="checkbox" name="CHDID" value="<%= data.CHDID %>" <%= data.CHDID.equals("X") ? "checked" : "" %> disabled>
                                          자녀양육
                                        </td>
                                      </tr>
-->                                      
<%
    }
%>
                                    </table>
                                  </td>
                                </tr>
                              </table>
                            </td>
                            <td width="10">&nbsp;</td>
                            <td valign="top">
                              <table width="314" border="0" cellspacing="1" cellpadding="0" class="table02">
                                <tr>
                                  <td bgcolor="#FFFFFF">
                                    <table width="315" border="0" cellspacing="1" cellpadding="3">
                                      <tr>
                                        <td class="td09">
                                          <input type="checkbox" name="LIVID" value="X" <%= data.LIVID.equals("X") ? "checked" : "" %> disabled>
                                          동거여부
                                        </td>
                                      </tr>
                                    </table></td>
                                </tr>
                              </table></td>
                          </tr>
                        </table></td>
                    </tr>
                  </table></td>
              </tr>
            </table>
            <!--상단 입력 테이블 끝-->
          </td>
        </tr>
        <tr>
          <td>&nbsp;</td>
        </tr>
        <tr>
          <td class="font01">
            <table width="780" border="0" cellspacing="1" cellpadding="0" class="table02">
              <tr>
                <td class="td01" width="100">해지사유</td>
                <td class="td09">
                  <select name="CANC_CODE" class="input04" disabled>
                    <option value="">-----------------------------</option>
<%= WebUtil.printOption((new A12FamilyCancelCodeRFC()).getCancelCode( user.companyCode ), data.CANC_CODE) %>
                  </select>
<%
    if( !data.CANC_ETCD.equals("") ) {
%>
                  &nbsp;<input type="text" name="CANC_ETCD" value="<%= data.CANC_ETCD %>" size="50" class="input04" readonly>
<%
    }
%>
                </td>
              </tr>
              <tr>
                <td class="td01">해지일자</td>
                <td class="td09">
                  <input type="text" name="CANC_DATE" value="<%= WebUtil.printDate(data.CANC_DATE, ".") %>" class="input04" size="20" readonly>
              </td>
            </tr>
          </table>
        </td>
      </tr>
      <tr>
        <td>&nbsp;</td>
      </tr>
      <tr>
        <td> <table width="780" border="0" cellspacing="0" cellpadding="0">
            <tr>
              <td class="font01" style="padding-bottom:2px"><img src="<%= WebUtil.ImageURL %>ehr/icon_o.gif">
                결재정보</td>
            </tr>
          </table></td>
      </tr>
      <tr>
        <td>
          <!-- 결재자 입력 테이블 시작-->
          <%= hris.common.util.AppUtil.getAppDetail(AppLineData_vt) %>
          <!-- 결재자 입력 테이블 시작-->
        </td>
      </tr>
      <tr>
        <td>&nbsp;</td>
      </tr>
      <tr>
        <td>
          <table width="780" border="0" cellspacing="0" cellpadding="0">
            <tr>
              <td align="center">
				<%  if ( RequestPageName != null && !RequestPageName.equals("")) { %>
                <a href="javascript:do_list();">
                  <img src="<%= WebUtil.ImageURL %>btn_list.gif" name="image3" border="0" align="absmiddle"></a>
                <%  } // end if %>
                <%  if (docinfo.isModefy()) { %>
                <a href="javascript:do_change();">
                  <img src="<%= WebUtil.ImageURL %>btn_change.gif" name="image" align="absmiddle" border="0"></a>
                <a href="javascript:do_delete();">
                  <img src="<%= WebUtil.ImageURL %>btn_delete.gif" name="image2" align="absmiddle" border="0"></a>
                <%  } // end if %>
				<%  if ( ThisJspName.equals("A04FamilyDetail.jsp")  ) { %>
                <a href="javascript:do_preview();">
                    <img src="<%= WebUtil.ImageURL %>btn_prevview.gif" align="absmiddle" border="0"></a>
                <%  } // end if %>
				<%  if ( ThisJspName.equals("A12FamilyBuild01.jsp")  ) { %>
                <a href="javascript:do_preview_1();">
                    <img src="<%= WebUtil.ImageURL %>btn_prevview.gif" align="absmiddle" border="0"></a>
                <%  } // end if %>
              </td>
            </tr>
          </table>
        </td>
      </tr>
  </table>
<!--  HIDDEN  처리해야할 부분 시작-->
    <input type="hidden" name="jobid"       value="">
    <input type="hidden" name="AINF_SEQN"   value="">
    <input type="hidden" name="SUBTY"       value="<%= data.SUBTY %>">
    <input type="hidden" name="OBJPS"       value="<%= data.OBJPS %>">
    <input type="hidden" name="ThisJspName" value="<%= ThisJspName %>">
    <input type="hidden" name="RequestPageName" value="<%=RequestPageName%>">
<!--  HIDDEN  처리해야할 부분 끝-->
</form>
<%@ include file="/web/common/commonEnd.jsp" %>
