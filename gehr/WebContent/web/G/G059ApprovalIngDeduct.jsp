<%/******************************************************************************/
/*                                                                              */
/*   System Name  : e-HR                                                        */
/*   1Depth Name  : HR 결재함                                                   */
/*   2Depth Name  : 결재 진행중 문서                                            */
/*   Program Name : 근로소득/갑근세 결재 진행중/취소                            */
/*   Program ID   : G059ApprovalIngDeduct.jsp                                   */
/*   Description  : 근로소득/갑근세 결재 진행중/취소                            */
/*   Note         : 없음                                                        */
/*   Creation     : 2005-03-11 유용원                                           */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ page errorPage="/web/err/error.jsp"%>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.util.*" %>
<%@ page import="hris.A.A18Deduct.*" %>
<%@ page import="hris.A.A18Deduct.rfc.*" %>
<%@ page import="hris.G.rfc.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%
    WebUserData   user             = (WebUserData)session.getAttribute("user");
    Vector        A18DeductData_vt = (Vector)request.getAttribute("A18DeductData_vt");
    A18DeductData data             = ( A18DeductData )A18DeductData_vt.get(0);
    String        GUEN_TEXT        = "";

    //구분의 TEXT를 읽어온다.
    A18GuenTypeRFC func           = new A18GuenTypeRFC();
    Vector         a18GuenType_vt = func.getGuenType();
    for( int i = 0; i < a18GuenType_vt.size(); i++ ){
        CodeEntity entity = (CodeEntity)a18GuenType_vt.get(i);
        if( ( data.GUEN_TYPE ).equals( entity.code.substring(2,4) ) ){
            GUEN_TEXT = entity.value;
            break;
        }
    }

    //사업장 주소 select박스.
    BizPlaceDataRFC funcBiz     = new BizPlaceDataRFC();
    Vector          bizPlace_vt = funcBiz.getBizPlacesCodeEntity(user.companyCode, "28"); //28->원천징수

    //결재자정보
    Vector vcAppLineData   = (Vector)request.getAttribute("vcAppLineData");
    String RequestPageName = (String)request.getAttribute("RequestPageName");

    boolean isCanGoList ;
    if (RequestPageName == null || RequestPageName.equals("")) {
        isCanGoList = false;
    } else {
        isCanGoList = true;
    } // end if

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
    function cancel()
    {
        if(!confirm("취소 하시겠습니까.")) {
            return;
        } // end if
        var frm = document.form1;
        frm.APPR_STAT.value = "";
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


//-->
</script>
</head>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<form name="form1" method="post" action="">
<input type="hidden" name="jobid" value="save">
<input type="hidden" name="APPU_TYPE" value="<%=docinfo.getAPPU_TYPE()%>">
<input type="hidden" name="APPR_SEQN" value="<%=docinfo.getAPPR_SEQN()%>">
<input type="hidden" name="BUKRS" value="<%=user.companyCode%>">

<input type="hidden" name="ZPERNR"       value="<%=data.ZPERNR %>" >
<input type="hidden" name="AINF_SEQN"    value="<%=data.AINF_SEQN%>">
<input type="hidden" name="PERNR"        value="<%=data.PERNR%>">
<input type="hidden" name="BEGDA"        value="<%=data.BEGDA%>">

<input type="hidden" name="APPR_STAT">
<input type="hidden" name="RequestPageName"   value="<%=RequestPageName%>">
<input type="hidden" name="approvalStep" value="<%=approvalStep%>">
  <table width="796" border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td width="16">&nbsp;</td>
      <td><table width="780" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><table width="780" border="0" cellpadding="0" cellspacing="0">
                <tr>
                  <td height="5" colspan="2"></td>
                </tr>
                <tr>
                  <td width="624" class="title02">
                    <img src="<%= WebUtil.ImageURL %>ehr/title01.gif"> 원천징수 영수증 결재진행 중 문서
                  </td>
                  <td align="right" style="padding-bottom:4px">
                 </td>
                </tr>
              </table></td>
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
              <!-- 상단 입력 테이블 시작-->
              <table width="780" border="0" cellspacing="1" cellpadding="5" class="table02">
                <tr>
                  <td class="tr01"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                      <tr>
                        <td>

                          <table width="100%" border="0" cellpadding="0" cellspacing="1">
                            <tr>
                              <td width="13%" class="td01">신청일자</td>
                              <td width="87%" class="td09">
                                <input type="text" name="BEGDA" size="20" class="input04" value="<%= WebUtil.printDate(data.BEGDA,".") %>" readonly>
                              </td>
                            </tr>
                            <tr>
                              <td width="13%" class="td01">구분</td>
                              <td width="87%" class="td09">
                                <input type="text" name="guentype" size="25" class="input04" value="<%= GUEN_TEXT %>" readonly>
                                <input type="hidden" name="GUEN_TYPE" value="<%= data.GUEN_TYPE %>">
                              </td>
                            </tr>
                            <tr>
                              <td width="13%" class="td01">발행부수</td>
                              <td width="87%" class="td09">
                                <input type="text" name="PRINT_NUM" size="12" class="input04" value="<%= Integer.parseInt( data.PRINT_NUM ) %>" readonly>
                              </td>
                            </tr>
			    <!--[CSR ID:1263333]-->
                            <tr> 
                              <td class="td01">발행방법</td>
                              <td class="td09" colspan="2"> 
                                <input type="radio" name="PRINT_CHK" value="1" <%= data.PRINT_CHK.equals("1") ? "checked" : "" %> disabled>본인발행
                                <input type="radio" name="PRINT_CHK" value="2" <%= data.PRINT_CHK.equals("2") ? "checked" : "" %> disabled>담당부서 요청발행
                              </td>
                            </tr>  
                            <tr>
                              <td width="13%" class="td01">전화번호</td>
                              <td width="87%" class="td09">
                                <input type="text" name="PHONE_NUM" size="12" class="input04" value="<%= user.e_cell_phone %>" readonly>
                              </td>
                            </tr>

                            <tr>
                              <td width="13%" class="td01">제출처</td>
                              <td width="87%" class="td09">
                                <input type="text" name="SUBMIT_PLACE" size="60" class="input04" value="<%= data.SUBMIT_PLACE %>" readonly>
                              </td>
                            </tr>
                            <tr>
                              <td width="13%" class="td01">사용목적</td>
                              <td width="87%" class="td09">
                                <input type="text" name="USE_PLACE" size="60" class="input04" value="<%= data.USE_PLACE %>" readonly>
                              </td>
                            </tr>
                            <tr>
                              <td width="13%" class="td01">선택기간&nbsp;</td>
                              <td width="87%" class="td09">
                              <%
                                //'0001':근로소득 원천징수 영수증, '0002':갑근세 원천징수 증명서
                                String strReadOnly = "";
                                if (data.GUEN_TYPE.equals("01")) {
                                     strReadOnly = "readOnly";
                                }
                              %>
                                <input type="text" name="EBEGDA" value="<%= data.EBEGDA.equals("0000-00-00")||data.EBEGDA.equals("") ? "" : WebUtil.printDate(data.EBEGDA) %>" size="20" class="input04" onBlur="dateFormat(this);" <%= strReadOnly %>  readonly>
                                부터
                                <input type="text" name="EENDDA" value="<%= data.EENDDA.equals("0000-00-00")||data.EENDDA.equals("") ? "" : WebUtil.printDate(data.EENDDA) %>" size="20" class="input04" onBlur="dateFormat(this);" <%= strReadOnly %>  readonly>
                                까지
                              </td>
                            </tr>
                            <tr>
                              <td width="13%" class="td01">특기사항</td>
                              <td width="87%" class="td09">
                                <textarea name="SPEC_ENTRY" wrap="VIRTUAL" cols="60" class="input04" rows="5"  readonly><%= data.SPEC_ENTRY1 +"\n"+ data.SPEC_ENTRY2 +"\n"+ data.SPEC_ENTRY3 +"\n"+ data.SPEC_ENTRY4 +"\n"+ data.SPEC_ENTRY5 %></textarea>
                              </td>
                            </tr>
<!--                            
                            <tr>
                              <td width="13%" class="td01">사업장주소선택</td>
                              <td width="87%" class="td09">
                              <% if(data.JUSO_CODE !=null && !data.JUSO_CODE.equals("")){ %>  
                                    <%= WebUtil.printOptionText( bizPlace_vt, data.JUSO_CODE ) %>
                              <% }else{ %>   
                                 선택된 사업장이 없습니다.
                              <% } %>  
                              </td>
                            </tr>
-->
    		            <input type="hidden" name="JUSO_CODE"       value="<%= data.JUSO_CODE       %>">

                          </table>

                        </td>
                      </tr>
                    </table></td>
                </tr>
              </table>
              <!-- 상단 입력 테이블 끝-->
            </td>
          </tr>
          <tr>
            <td>&nbsp;</td>
          </tr>
       <%
            boolean visible = false;
            for (int i = 0; i < vcAppLineData.size(); i++) {
                AppLineData ald = (AppLineData) vcAppLineData.get(i);
                if (ald.APPL_BIGO_TEXT != null && !ald.APPL_BIGO_TEXT.equals("")) {
                    visible = true;
                    break;
                } // end if
            } // end for
       %>
       <%   if (visible) { %>
          <tr>
            <td class="font01" style="padding-bottom:2px"><img src="<%= WebUtil.ImageURL %>ehr/icon_o.gif"> 적요</td>
          </tr>
          <tr>
            <td>
                <table width="780" border="0" cellpadding="0" cellspacing="1" class="table03">
                <% for (int i = 0; i < vcAppLineData.size(); i++) { %>
                    <% AppLineData ald = (AppLineData) vcAppLineData.get(i); %>
                       <% if (ald.APPL_BIGO_TEXT != null && !ald.APPL_BIGO_TEXT.equals("")) { %>
                    <tr>
                       <td width="80" class="td03"><%=ald.APPL_ENAME%></td>
                       <td class="td09"><%=ald.APPL_BIGO_TEXT%></td>
                    </tr>
                    <% } // end if %>
                <% } // end for %>
                </table>
            </td>
          </tr>
        <% } // end if %>
          <tr>
            <td> <table width="780" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td>&nbsp;</td>
                </tr>
                <tr>
                  <td>&nbsp;</td>
                </tr>
                <tr>
                  <td class="font01" style="padding-bottom:2px"><img src="<%= WebUtil.ImageURL %>ehr/icon_o.gif">
                    결재정보</td>
                </tr>
                <tr>
                  <td><table width="780" border="0" cellspacing="0" cellpadding="0">
                      <tr>
                        <td>
                          <!--결재정보 테이블 시작-->
                          <%= AppUtil.getAppDetail(vcAppLineData) %>
                          <!--결재정보 테이블 끝-->
                        </td>
                      </tr>
                    </table></td>
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
                        <% if (isCanGoList) {  %>
                          <a href="javascript:goToList()"><img src="<%= WebUtil.ImageURL %>btn_list.gif" border="0"></a>&nbsp;&nbsp;&nbsp;
                        <% } // end if %>
                        <% if (docinfo.isHasCancel()) {  %>
                          <a href="javascript:cancel()"><img src="<%= WebUtil.ImageURL %>btn_cancel01.gif" border="0" /></a>&nbsp;&nbsp;&nbsp;
                        <% } // end if %>
                        </td>
                      </tr>
                    </table>
                  <!--버튼 들어가는 테이블 끝 -->
                  </td>
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

<!---- hidden field ---->
    <input type="hidden" name="jobid" >
    <input type="hidden" name="MANDT"       value="<%= data.MANDT       %>">
    <input type="hidden" name="PERNR"       value="<%= data.PERNR       %>">
    <input type="hidden" name="AINF_SEQN"   value="<%= data.AINF_SEQN   %>">
    <input type="hidden" name="SPEC_ENTRY1" value="">
    <input type="hidden" name="SPEC_ENTRY2" value="">
    <input type="hidden" name="SPEC_ENTRY3" value="">
    <input type="hidden" name="SPEC_ENTRY4" value="">
    <input type="hidden" name="SPEC_ENTRY5" value="">
    <input type="hidden" name="PUBLIC_NUM"  value="<%= data.PUBLIC_NUM  %>">
    <input type="hidden" name="PUBLIC_DTE"  value="<%= data.PUBLIC_DTE  %>">
    <input type="hidden" name="PUBLIC_MAN"  value="<%= data.PUBLIC_MAN  %>">
    <input type="hidden" name="ZUNAME"      value="<%= data.ZUNAME      %>">
    <input type="hidden" name="AEDTM"       value="<%= data.AEDTM       %>">
    <input type="hidden" name="UNAME"       value="<%= data.UNAME       %>">
    <!---- hidden field ---->
</form>
<%@ include file="/web/common/commonEnd.jsp" %>
