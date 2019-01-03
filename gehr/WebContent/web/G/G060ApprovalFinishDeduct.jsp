<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : 결재해야할 문서                                             */
/*   2Depth Name  :                                                             */
/*   Program Name : 근로소득/갑근세 결재                                        */
/*   Program ID   : G059ApprovalDeduct.jsp                                      */
/*   Description  : 근로소득/갑근세 결재를 위한 jsp 파일                        */
/*   Note         : 없음                                                        */
/*   Creation     : 2005-03-11 유용원                                           */
/*   Update       :  2015-12-16 이지은 [CSR ID:2940449] 원천징수영수증 출력오류가이드 설정                                                           */
/*            update 2016-03-02 이지은 [CSR ID:2999302] 원천징수 영수증 출력 관련      */
/*                      2016/03/   [CSR ID:3021110] 원천징수 영수증 출력 설정  */
/*                      2016.04.11 [CSR ID:3031090] 원천징수영수증 출력 관련 안내   */
/*						 2016.07.21 [CSR ID:3121978] 원천징수영수증 안내창 수정  김불휘S */
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
    Vector      vcAppLineData     = (Vector)request.getAttribute("vcAppLineData");
    String      RequestPageName   = (String)request.getAttribute("RequestPageName");

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
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr_style.css" type="text/css">
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr_wsg.css" type="text/css">

<script language="javascript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>

<script language="JavaScript">
<!--

    function goToList()
    {
        var frm = document.form1;
    <% if (isCanGoList) { %>
        frm.action = "<%=RequestPageName.replace('|' ,'&')%>";
    <% } // end if %>
        frm.jobid.value ="";
        frm.submit();
    }
function go_print() {

    //@임시if( !confirm("Acrobat Reader8 이상 버젼이 설치 되어 있는지 확인하였습니까?")) {
    //	return;
    //}
    if(  "<%= data.PRINT_CHK%>" == "1" &&  document.form1.PRINT_END.value == "X" ) {
        alert("발행은 1회만 인쇄 가능합니다.");
        return;
    }
    if( "<%= data.PRINT_CHK%>" == "1" ){//본인
    	//[CSR ID:3121978] 원천징수영수증 안내창 수정
    	//msg ="발행은 1회만 인쇄 가능합니다. 인쇄 하시겠습니까?";
    	if(!confirm("Acrobat Reader 버전 및 출력오류가이드를 확인하셨습니까?")){
    		return;
    	}
    	msg ="발행은 1회만 인쇄 가능합니다. 인쇄 하시겠습니까?";
    }else { //담당자
       msg ="인쇄 하시겠습니까?";
    }

    if( confirm(msg) ) {            window.open('', 'essPrintWindow', "toolbar=0,location=0,directories=0,status=0,menubar=1,resizable=0,width=760,height=650,left=100,top=60");
            document.form1.jobid.value = "print_certi";
            document.form1.target      = "essPrintWindow";
            document.form1.action      = '<%= WebUtil.ServletURL %>hris.G.G060ApprovalFinishDeductSV';
            document.form1.method      = "post";
            document.form1.submit();

        document.form2.target = "ifHidden";
        document.form2.action = "<%=WebUtil.JspURL%>common/PrintCntUpdate.jsp";
        document.form2.submit();
    }
}

//[CSR ID:2940449]
function fn_downGuide(){
	//alert("본인발행 시 보아니2 버전이 58인지 확인하시고,\n원천징수영수증 출력오류 가이드를 참고해주시기 바랍니다.");
	location.href="<%= WebUtil.ImageURL %>withholding_tax_install_guide.ppt";
}

//[CSR ID:2940449]
//[CSR ID:3021110] 원천징수 영수증 출력 설정  -> 사용안함.
//[CSR ID:3031090] 원천징수영수증 출력 관련 안내  -> 다시 사용
function init(){
<%
	 if(   data.PRINT_CHK.equals("1") && user.empNo.equals(data.PERNR) ) {
%>
//[CSR ID:3121978] 원천징수영수증 안내창 수정
//alert("★ Adobe Reader DC (G-cloud) 다운로드 후 출력해주시기 바랍니다.");
alert("★출력 전 반드시 Acrobat Reader DC 설치 및 출력오류가이드 확인 후    출력바랍니다.★");
<%	}%>
	//location.href="<%= WebUtil.ImageURL %>withholding_tax_install_guide.ppt";
}

//-->
</script>
</head>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="init();MM_preloadImages('<%= WebUtil.ImageURL %>btn_help_on.gif');">
<form name="form1" method="post" action="">
<input type="hidden" name="jobid" value="save">
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
                  <td class="subhead"><h2>원천징수 영수증 결재완료 문서</h2></td>
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
            <td>
              <!-- 상단 입력 테이블 시작-->

					<div class="tableArea">
	                      <table class="tableGeneral">
			                <tr>
			                  <th width="100">신청일자</th>
			                  <td width="260">
			                    <input type="text" name="BEGDA" size="20" class="input04" value="<%= WebUtil.printDate(data.BEGDA,".") %>" readonly>
			                  </td>
								<td align="right">
<%

//   if( ( data.PRINT_CHK.equals("1") && user.empNo.equals(data.PERNR) ) ||
//        ( data.PRINT_CHK.equals("2")) &&  (approvalStep == DocumentInfo.DUTY_CHARGER|| approvalStep == DocumentInfo.DUTY_MANGER ) ) {
    if(   data.PRINT_CHK.equals("1") && user.empNo.equals(data.PERNR) ) {
%>
                                          <a class="inlineBtn" href="javascript:go_print();"><span>인쇄하기</span></a>&nbsp;
<%
    } else {
%>
                    &nbsp;
<%
    }
%>
                                         </td>
			                </tr>
			                <tr>
			                  <th>구분</th>
			                  <td colspan="2">
			                    <input type="text" name="guentype" size="25" value="<%= GUEN_TEXT %>" readonly>
			                    <input type="hidden" name="GUEN_TYPE" value="<%= data.GUEN_TYPE %>">
			                  </td>
			                </tr>
			                <tr>
			                  <th>발행부수</th>
			                  <td colspan="2">
			                    <input type="text" name="PRINT_NUM" size="12" class="input04" value="<%= Integer.parseInt( data.PRINT_NUM ) %>" readonly>
			                  </td>
			                </tr>
			                <!--[CSR ID:1263333]-->
                                        <tr>
                                          <th>발행방법</th>
                                          <td colspan="2">
                                            <input type="radio" name="PRINT_CHK" value="1" <%= data.PRINT_CHK.equals("1") ? "checked" : "" %> disabled>본인발행
                                            <input type="radio" name="PRINT_CHK" value="2" <%= data.PRINT_CHK.equals("2") ? "checked" : "" %> disabled>담당부서 요청발행
                                          </td>
                                        </tr>
			                <tr>
                                          <th>전화번호</th>
                                          <td colspan="2">
                                            <input type="text" name="PHONE_NUM" size="12" class="input04" value="<%= user.e_cell_phone %>" readonly>
                                          </td>
                                        </tr>

			                <tr>
			                  <th>제출처</th>
			                  <td colspan="2">
			                    <input type="text" name="SUBMIT_PLACE" size="60" class="input04" value="<%= data.SUBMIT_PLACE %>" readonly>
			                  </td>
			                </tr>
			                <tr>
			                  <th>사용목적</th>
			                  <td colspan="2">
			                    <input type="text" name="USE_PLACE" size="60" class="input04" value="<%= data.USE_PLACE %>" readonly>
			                  </td>
			                </tr>
			                <tr>
			                  <th>선택기간</th>
			                  <td colspan="2">
			                    <input type="text" name="EBEGDA" value="<%= data.EBEGDA.equals("0000-00-00")||data.EBEGDA.equals("") ? "" : WebUtil.printDate(data.EBEGDA) %>" size="20" class="input04" readonly>
			                    부터
			                    <input type="text" name="EENDDA" value="<%= data.EENDDA.equals("0000-00-00")||data.EENDDA.equals("") ? "" : WebUtil.printDate(data.EENDDA) %>" size="20" class="input04" readonly>
			                    까지
			                  </td>
			                </tr>
			                <tr>
			                  <th>특기사항</th>
			                  <td colspan="2">
			                    <textarea name="SPEC_ENTRY" wrap="VIRTUAL" cols="60" class="input04" rows="5" readonly><%= data.SPEC_ENTRY1 +"\n"+ data.SPEC_ENTRY2 +"\n"+ data.SPEC_ENTRY3 +"\n"+ data.SPEC_ENTRY4 +"\n"+ data.SPEC_ENTRY5 %></textarea>
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
			              </table>
					</div>
              <!-- 상단 입력 테이블 끝-->
            </td>
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
            <td><h2 class="subtitle">적요</h2></td>
          </tr>
          <tr>
            <td>
                <table width="780" border="0" cellpadding="0" cellspacing="1">
                <% for (int i = 0; i < vcAppLineData.size(); i++) { %>
                    <% AppLineData ald = (AppLineData) vcAppLineData.get(i); %>
                    <% if (ald.APPL_BIGO_TEXT != null && !ald.APPL_BIGO_TEXT.equals("")) { %>
                    <tr>
                    	<td>
                    		<div class="tableArea">
                    			<table class="tableGeneral">
                    				<tr>
                    					<th><%=ald.APPL_ENAME%></th>
                    					<td><%=ald.APPL_BIGO_TEXT%></td>
                    				</tr>
                    			</table>
                    		</div>
                    	</td>
                    </tr>
                    <% } // end if %>
                <% } // end for %>
                </table>
            </td>
          </tr>
        <% } // end if %>
        <%   if (data.PRINT_CHK.equals("1")) { //본인발행 %>
                   <!-- [CSR ID:3121978] 원천징수영수증 안내창 수정   -->
          <tr>
            <td class="td09"> <font color="red"><b>&nbsp;&nbsp;* 출력 전 Acrobat Reader DC 이하 버젼인 경우는 반드시 아래 버젼을 설치후 인쇄하기를 클릭하시기 바라며<br>
            																			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;원천징수영수증 출력오류가이드를 확인하여주시기바랍니다.</b></font>
    <!--  [CSR ID:2999302] 원천징수 영수증 출력 관련 -->
    <!--  [CSR ID:3021110] 원천징수 영수증 출력 설정
    <a href="<%= WebUtil.ImageURL %>AdbeRdr930_ko_KR.exe" target="_blankTOP">
    <img width="300" src="<%= WebUtil.ImageURL %>adobereader93.gif" border="0"></a>&nbsp;-->
			    <ul class="btn_mdl" style="margin:10px; 0">
			    	<li><a href="<%= WebUtil.ImageURL %>AcroRdrDC1500720033_ko_KR.exe" target="_blankTOP">
			    	<!--[CSR ID:3121978] 원천징수영수증 안내창 수정 width="300" 을 200 으로 수정하고 이미지도 바꿈 -->
			    	<img width="200" src="<%= WebUtil.ImageURL %>adobereaderDC.gif" border="0"></a></li>
			    </ul>
            </td>
          </tr>
          <tr>
        <% } // end if %>

          <tr>
            <td> <table width="780" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td>&nbsp;</td>
                </tr>
                <tr>
                  <td><h2 class="subtitle">결재정보</h2></td>
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
  <input type="hidden" name="PRINT_END"   value="<%= data.PRINT_END %>">
</form>


<form name="form2" method="post" action="">
<input type="hidden" name="PERNR"     value="<%=data.PERNR%>">
<input type="hidden" name="AINF_SEQN" value="<%=data.AINF_SEQN%>">
<input type="hidden" name="MENU" value="DEDUCT">
</form>
<iframe name="ifHidden" width="0" height="0" />
<%@ include file="/web/common/commonEnd.jsp" %>
