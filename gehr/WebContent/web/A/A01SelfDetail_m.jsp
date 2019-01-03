<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : 인사정보조회                                                */
/*   Program Name : 인사정보조회                                                */
/*   Program ID   : A01SelfDetail_m.jsp                                         */
/*   Description  : 사원의 인사정보 조회                                        */
/*   Note         :                                                             */
/*   Creation     : 2001-12-17  김성일                                          */
/*   Update       : 2005-01-11  윤정현                                          */
/*                  2005-11-07  lsa @v1.1사진사이즈수정 원본:136:164-> 110->116.1 :140*/
/*                  2006-03-17  @v1.2 lsa 급여작업으로 막음                     */
/*                  2006-05-17  @v1.2 lsa 5월급여작업으로 막음  전문기술직만    */
/*                  2006-06-16  @v1.2 kdy 임금인상관련 급여화면 제어              */
/*   Update       :  구분추가 C20140210_84209                            */
/*                                                                              */
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
    Vector a01SelfDetailData_vt   = (Vector)request.getAttribute("a01SelfDetailData_vt");    // 개인사항
    Vector a08LicenseDetail_vt    = (Vector)request.getAttribute("a08LicenseDetail_vt");     // 자격사항
    Vector a02SchoolData_vt       = (Vector)request.getAttribute("a02SchoolData_vt");        // 학력사항
    Vector a04FamilyDetailData_vt = (Vector)request.getAttribute("a04FamilyDetailData_vt");  // 가족사항

    A01SelfDetailData data   = new A01SelfDetailData();
    String            imgUrl = (String)request.getAttribute("imgUrl");
    if (a01SelfDetailData_vt != null && a01SelfDetailData_vt.size() > 0 ) {
        data = (A01SelfDetailData)a01SelfDetailData_vt.get(0);
    }
    int insaFlag = user.e_authorization.indexOf("H");    //인사담당
%>

<SCRIPT LANGUAGE="JavaScript">
<!--
function  doSearchDetail() {
    document.form1.action = "<%= WebUtil.ServletURL %>hris.A.A01SelfDetailSV_m";
    document.form1.method = "post";
    document.form1.target = "menuContentIframe";
    document.form1.submit();
}

function view_detail(idx) {
    licn_code = eval("document.form1.LICN_CODE" + idx + ".value");
    flag      = eval("document.form1.FLAG"      + idx + ".value");

    if( flag == "X" ) {    // 자격수당이 있는 경우..
        window.open('', 'essPopup', "toolbar=0,location=0,directories=0,status=0,menubar=0,resizable=0,width=552,height=365,left=100,top=100");

        document.form1.jobid2.value    = "license_pop";
        document.form1.licn_code.value = licn_code;

        document.form1.target = "essPopup";
        document.form1.action = "<%= WebUtil.ServletURL %>hris.A.A01SelfDetailSV_m";
        document.form1.method = "post";
        document.form1.submit();
    }
}

function go_Insaprint(){

    window.open('', 'essPrintWindow', "toolbar=no,location=no, directories=no,status=no,menubar=yes,resizable=no,width=1010,height=662,left=0,top=2");

    document.form1.target = "essPrintWindow";
    document.form1.action = "<%= WebUtil.JspURL %>common/printFrame_insa.jsp";
    document.form1.method = "post";
    document.form1.submit();
}

//-->
</SCRIPT>
<html>
<head>
<title>ESS</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr.css" type="text/css">

<script language="JavaScript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" oncontextmenu="return false" ondragstart="return false" onselectstart="return false">
<form name="form1" method="post">
  <table width="791" border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td width="16">&nbsp;</td>
      <td><table width="780" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td width="780"><table width="780" border="0" cellpadding="0" cellspacing="0">
                <tr>
                  <td height="5" colspan="2"></td>
                </tr>
                <tr>
                  <td class="title02"><img src="<%= WebUtil.ImageURL %>ehr/title01.gif">개인 인적사항 조회</td>
                  <td class="titleRight"><a href="javascript:open_help('X03PersonInfo.html');" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image6','','<%= WebUtil.ImageURL %>btn_help_on.gif',1)"></a></td>
                </tr>
              </table></td>
          </tr>
          <!--   사원검색 보여주는 부분 시작   -->
          <%@ include file="/web/common/SearchDeptPersons_m.jsp" %>
          <!--   사원검색 보여주는 부분  끝    -->
          <tr>
            <td height="10">&nbsp;</td>
          </tr>
<% //@v1.2 
   //if (user_m != null&& (user_m.e_persk.equals("32")||user_m.e_persk.equals("33") ) && Integer.parseInt(DataUtil.getCurrentDate()) >= 20060616 &&  Integer.parseInt(DataUtil.getCurrentDate())  < 20060623 ) { 
   String O_CHECK_FLAG = "";
  if (user_m != null ) {  
      O_CHECK_FLAG = ( new D05ScreenControlRFC() ).getScreenCheckYn( user_m.empNo );
  }
  if (user_m != null && O_CHECK_FLAG.equals("N") ) {
%>            
                    <table border="0" cellspacing="0" cellpadding="0">
                      <tr>
                        <td class="td09" align="left">
                           <font color="red">※ 급여작업으로 인해 메뉴 사용을 일시 중지합니다.<br><br></font><!--@v1.1-->
                         </td>
                      </tr>
                    </table>
<% } else {  //@v1.2 else %>

          <%
// 사원 검색한 사람이 없을때
if ( user_m != null ) {
%>
		  <%  if( insaFlag > 0 ) {   //인사담당만 인사기록부 조회할 수 있도 %>
          <tr>
            <td align="right" style="padding-bottom:5px"><a href="javascript:go_Insaprint();"><img src="<%= WebUtil.ImageURL %>ehr/bt_g01.gif" border="0"></a></td>
          </tr>
          
          <input type="hidden" name="Screen"   value="Y"><!-- C20140210_84209 -->
          <%  } %>
          <tr>
            <td><table width="780" border="0" cellspacing="1" cellpadding="10" bgcolor="#B7A68A">
                <tr>
                  <td bgcolor="#FFFFFF"><table width="100%" border="0" cellpadding="0" cellspacing="" bgcolor="#FFFFFF">
                      <tr>
                        <td> <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                              <td width="120"><table width="115" border="0" cellspacing="1" cellpadding="0" height="148" class="table02">
                                  <tr>
                                    <td class="td04"><img name="photo" border="0" src="<%= imgUrl %>" width="116.1" height="140" ></td>
                                  </tr>
                                </table></td>
                              <td width="5">&nbsp;</td>
                              <td><table width="610" border="0" cellspacing="1" cellpadding="3" class="table02">
                                  <tr>
                                    <td class="td03" width="80">사번</td>
                                    <td class="td04" width="109"><%= data.PERNR %>&nbsp;</td>
                                    <td class="td03" width="80">소속</td>
                                    <td colspan="3" class="td04"><%= data.ORGTX %>&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td class="td03">성명(한글)</td>
                                    <td class="td04"><%= data.KNAME %>&nbsp;</td>
                                    <td class="td03">성명(한자)</td>
                                    <td class="td04" width="80"><%= data.CNAME %>&nbsp;</td>
                                    <td class="td03" width="80">성명(영어)</td>
                                    <td class="td04" width="138"><%= data.YNAME %>&nbsp;</td>
                                  </tr>
                                  <tr>
                                    <td class="td03">직위</td>
                                    <td class="td04"><%= data.TITEL %>&nbsp;</td>
                                    <td class="td03">생년월일</td>
                                    <td class="td04"><%= WebUtil.printDate(data.GBDAT) %>&nbsp;</td>
                                    <td class="td03">주민번호</td>
                                    <td class="td04"><%= data.REGNO.substring(0, 6) + "-*******" %>&nbsp;</td>
                                  </tr>
                                  <tr>
                                    <td class="td03">신분</td>
                                    <td class="td04"><%= data.PTEXT %>&nbsp;</td>
                                    <td class="td03">그룹입사일</td>
                                    <td class="td04"><%= (data.DAT02).equals("0000-00-00") ? "" : WebUtil.printDate(data.DAT02) %>&nbsp;</td>
                                    <td class="td03">입사구분</td>
                                    <td class="td04"><%= data.MGTXT %>&nbsp;</td>
                                  </tr>
                                  <tr>
                                    <td class="td03">직무</td>
                                    <td class="td04"><%= data.STLTX %>&nbsp;</td>
                                    <td class="td03">자사입사일</td>
                                    <td class="td04"><%= (data.DAT03).equals("0000-00-00") ? "" : WebUtil.printDate(data.DAT03) %>&nbsp;</td>
                                    <td class="td03">입사시학력</td>
                                    <td class="td04"><%= data.SLABS %>&nbsp;</td>
                                  </tr>
                                  <tr>
                                    <td class="td03">직책</td>
                                    <td class="td04"><%= data.TITL2 %>&nbsp;</td>
                                    <td class="td03">현직위승진</td>
                                    <td class="td04"><%= (data.BEGDA).equals("0000-00-00") ? "" : WebUtil.printDate(data.BEGDA) %>&nbsp;</td>
                                    <td class="td03">근무지</td>
                                    <td class="td04"><%= data.BTEXT %>&nbsp;</td>
                                  </tr>
                                  <tr>
                                    <td class="td03">급호/년차</td>
                                    <td class="td04"><%= data.VGLST %>&nbsp;</td>
                                    <td class="td03">근속기준일</td>
                                    <td class="td04"><%= (data.DAT01).equals("0000-00-00") ? "" : WebUtil.printDate(data.DAT01) %>&nbsp;</td>
                                    <td class="td03">국적</td>
                                    <td class="td04"><%= data.LANDX %>&nbsp;</td>
                                  </tr>
                                </table></td>
                            </tr>
                          </table></td>
                      </tr>
                      <tr>
                        <td>&nbsp;</td>
                      </tr>
                      <tr>
                        <td class="font01" style="padding-bottom:2px"><img src="<%= WebUtil.ImageURL %>ehr/icon_o.gif">
                          주소 및 신상</td>
                      </tr>
                      <tr>
                        <td> <table width="100%" border="0" cellspacing="1" cellpadding="3" class="table02">
                            <tr>
                              <td class="td03" width="80">현주소</td>
                              <td colspan="4" class="td04" style="text-align:left">&nbsp;&nbsp;<%= data.STRAS1 %></td>
                              <td class="td03" width="80">우편번호</td>
                              <td colspan="2" class="td04"><%= data.PSTLZ1 %>&nbsp;</td>
                            </tr>
                            <tr>
                              <td class="td03">본적</td>
                              <td colspan="4" class="td04" style="text-align:left">&nbsp;&nbsp;<%= data.STRAS %></td>
                              <td class="td03">우편번호</td>
                              <td colspan="2" class="td04"><%= data.PSTLZ %>&nbsp;</td>
                            </tr>
                            <tr>
                              <td class="td03" width="100">신장</td>
                              <td class="td04" width="80"><%= data.NMF01.equals("") ? "" : WebUtil.printNum(data.NMF01) + " ㎝" %>&nbsp;</td>
                              <td class="td03" width="100">체중</td>
                              <td class="td04" width="80"><%= data.NMF02.equals("") ? "" : WebUtil.printNum(data.NMF02) +" ㎏" %>&nbsp;</td>
                              <td class="td03" width="100">시력(좌)</td>
                              <td class="td04" width="80"><%= data.NMF06.equals("") ? "" : WebUtil.printNumFormat(data.NMF06,1) %>&nbsp;</td>
                              <td class="td03" width="100">시력(우)</td>
                              <td class="td04" width="90"><%= data.NMF07.equals("") ? "" : WebUtil.printNumFormat(data.NMF07,1) %>&nbsp;</td>
                            </tr>
                            <tr>
                              <td class="td03">색맹</td>
                              <td class="td04"><%= data.FLAG.equals("N") ? "정상" : "비정상" %>&nbsp;</td>
                              <td class="td03">혈액형</td>
                              <td class="td04"><%= data.STEXT %>&nbsp;</td>
                              <td class="td03">장애</td>
                              <td class="td04"><%= data.FLAG1.equals("N") ? "" : data.FLAG1 %>&nbsp;</td>
                              <td class="td03">특기</td>
                              <td class="td04"><%= data.HBBY_TEXT1 %>&nbsp;</td>
                            </tr>
                            <tr>
                              <td class="td03">혼인여부</td>
                              <td class="td04"><%= data.FTEXT %>&nbsp;</td>
                              <td class="td03">주거형태</td>
                              <td class="td04"><%= data.LIVE_TEXT %>&nbsp;</td>
                              <td class="td03">종교</td>
                              <td class="td04"><%= data.KTEXT %>&nbsp;</td>
                              <td class="td03">취미</td>
                              <td class="td04"><%= data.HBBY_TEXT %>&nbsp;</td>
                            </tr>
                            <tr>
                              <%
    if( user_m.companyCode.equals("C100") ) {
%>
                              <td class="td03">보훈대상</td>
                              <td colspan="7" class="td04" style="text-align:left">&nbsp;&nbsp;<%= data.CONTX %>&nbsp;</td>
                              <%
//  석유화학의 경우 개인의 핸드폰 번호를 보여준다.
    } else if( user_m.companyCode.equals("N100") ) {
%>
                              <td class="td03">보훈대상</td>
                              <td colspan="4" class="td04" style="text-align:left">&nbsp;&nbsp;<%= data.CONTX %>&nbsp;</td>
                              <td class="td03" width="80">휴대폰</td>
                              <td colspan="2" class="td04">&nbsp;</td>
                              <%
    }
%>
                            </tr>
                          </table></td>
                      </tr>
                      <tr>
                        <td>&nbsp;</td>
                      </tr>
                      <tr>
                        <td class="font01" style="padding-bottom:2px"><img src="<%= WebUtil.ImageURL %>ehr/icon_o.gif">
                          병역사항</td>
                      </tr>
                      <tr>
                        <td> <table width="100%" border="0" cellspacing="1" cellpadding="3" class="table02">
                            <tr>
                              <td class="td03" width="80">실역구분</td>
                              <td class="td04" width="120"><%= data.TRAN_TEXT %>&nbsp;</td>
                              <td class="td03" width="80">면제사유</td>
                              <td colspan="5" class="td04"><%= data.RSEXP %>&nbsp;</td>
                            </tr>
                            <tr>
                              <td class="td03">군별</td>
                              <td class="td04"><%= data.SERTX %>&nbsp;</td>
                              <td class="td03">계급</td>
                              <td class="td04" width="100"><%= data.RKTXT %>&nbsp;</td>
                              <td class="td03" width="80">주특기</td>
                              <td class="td04"><%= data.JBTXT %>&nbsp;</td>
                              <td class="td03" width="80">근무부대</td>
                              <td class="td04" width="110"><%= data.SERUT %>&nbsp;</td>
                            </tr>
                            <tr>
                              <td class="td03">전역사유</td>
                              <td class="td04"><%= data.RTEXT %>&nbsp;</td>
                              <td class="td03">군번</td>
                              <td colspan="2" class="td04"><%= data.IDNUM %>&nbsp;</td>
                              <td class="td03" width="80">복무기간</td>
                              <td colspan="2" class="td04"><%= data.PERIOD.equals("0000.00.00~0000.00.00") ? "" : data.PERIOD %>&nbsp;</td>
                            </tr>
                          </table></td>
                      </tr>
                      <tr>
                        <td>&nbsp;</td>
                      </tr>
                      <tr>
                        <td class="font01" style="padding-bottom:2px"><img src="<%= WebUtil.ImageURL %>ehr/icon_o.gif">
                          자격면허</td>
                      </tr>
                      <tr>
                        <td> <table width="100%" border="0" cellspacing="1" cellpadding="3" class="table02">
                            <tr>
                              <td class="td03" width="200">자격면허</td>
                              <td class="td03" width="100">취득일</td>
                              <td class="td03" width="100">등급</td>
                              <td class="td03" width="200">발행기관</td>
                              <td class="td03" width="130">법정선임사유</td>
                            </tr>
                            <%
    if( a08LicenseDetail_vt.size() > 0 ) {
          for ( int i = 0 ; i < a08LicenseDetail_vt.size() ; i++ ) {
            A08LicenseDetailData licndata = (A08LicenseDetailData)a08LicenseDetail_vt.get(i);
%>
                            <tr>
                              <%
            if( licndata.FLAG.equals("X") ) {
%>
                              <td class="td04"><a href="javascript:view_detail(<%=i%>)"><font color="#006699"><%= licndata.LICN_NAME %></font></a></td>
                              <%
            } else {
%>
                              <td class="td04"><%= licndata.LICN_NAME %></td>
                              <%
            }
%>
                              <td class="td04"><%= licndata.OBN_DATE.equals("0000-00-00") ? "" : WebUtil.printDate(licndata.OBN_DATE) %></td>
                              <td class="td04"><%= licndata.GRAD_NAME %></td>
                              <td class="td04"><%= licndata.PUBL_ORGH %></td>
                              <td class="td04"><%= licndata.ESTA_AREA %></td>
                              <input type="hidden" name="LICN_CODE<%= i %>" value="<%= licndata.LICN_CODE %>">
                              <input type="hidden" name="FLAG<%= i %>"      value="<%= licndata.FLAG %>">
                            </tr>
                            <%
        }
    } else {
%>
                            <tr align="center">
                              <td class="td04" colspan="5">해당하는 데이터가 존재하지 않습니다.</td>
                            </tr>
                            <%
    }
%>
                          </table></td>
                      </tr>
                      <tr>
                        <td>&nbsp;</td>
                      </tr>
                      <tr>
                        <td class="font01" style="padding-bottom:2px"><img src="<%= WebUtil.ImageURL %>ehr/icon_o.gif">
                          학력사항</td>
                      </tr>
                      <tr>
                        <td> <table width="100%" border="0" cellspacing="1" cellpadding="3" class="table02">
                            <tr>
                              <td class="td03" width="130">기 간</td>
                              <td class="td03" width="120">학교명</td>
                              <td class="td03" width="120">전 공</td>
                              <td class="td03" width="80">졸업구분</td>
                              <td class="td03" width="200">소재지</td>
                              <td class="td03" width="80">입사시 학력</td>
                            </tr>
                            <%
    int cnt = 5;
    if ( a02SchoolData_vt.size() < 5 ) { // 학력사항은 최근 5개 학력만 display 한다.
        cnt = a02SchoolData_vt.size();
    }
    if( a02SchoolData_vt.size() > 0 ) {
        for ( int i = 0 ; i < cnt ; i++ ) {
            A02SchoolData schldata = (A02SchoolData)a02SchoolData_vt.get(i);
%>
                            <tr align="center">
                              <td class="td04"><%= schldata.PERIOD    %></td>
                              <td class="td04"><%= schldata.LART_TEXT %></td>
                              <td class="td04"><%= schldata.FTEXT     %></td>
                              <td class="td04"><%= schldata.STEXT     %></td>
                              <td class="td04" style="text-align:left">&nbsp;&nbsp;<%= schldata.SOJAE.equals("") ? "" : schldata.SOJAE %></td>
                              <td class="td04"><%= ( (schldata.EMARK).toUpperCase() ).equals("N") ? "" : schldata.EMARK %></td>
                            </tr>
                            <%
        }
    } else {
%>
                            <tr align="center">
                              <td class="td04" colspan="6">해당하는 데이터가 존재하지 않습니다.</td>
                            </tr>
                            <%
    }
%>
                          </table></td>
                      </tr>
                      <tr>
                        <td>&nbsp;</td>
                      </tr>
                      <tr>
                        <td class="font01" style="padding-bottom:2px"><img src="<%= WebUtil.ImageURL %>ehr/icon_o.gif">
                          가족사항</td>
                      </tr>
                      <tr>
                        <td> <table width="100%" border="0" cellspacing="1" cellpadding="3" class="table02">
                            <tr>
                              <td class="td03" width="90">가족유형</td>
                              <td class="td03" width="90">성 명</td>
                              <td class="td03" width="150">주민등록번호</td>
                              <td class="td03" width="200">학력 / 교육기관</td>
                              <td class="td03" width="200">직업</td>
                            </tr>
                            <%
    if( a04FamilyDetailData_vt.size() > 0 ) {
        for ( int i = 0 ; i < a04FamilyDetailData_vt.size() ; i++ ) {
            A04FamilyDetailData famldata = (A04FamilyDetailData)a04FamilyDetailData_vt.get(i);
           // if ( !famldata.SUBTY.equals("7") ) { //가족친척은 조회안되게 (담당자인경우 
%>
                            <tr>
                              <td class="td04"><%= famldata.STEXT %></td>
                              <td class="td04"><%= famldata.LNMHG %> <%= famldata.FNMHG %></td>
                              <td class="td04"><%= famldata.REGNO.substring(0, 6) + "-*******" %></td>
                              <td class="td04"><%= famldata.STEXT1 %><%= famldata.FASIN.equals("") ? "" : " / " + famldata.FASIN %> </td>
                              <td class="td04"><%= famldata.FAJOB %></td>
                            </tr>
                            <%
           //  }
        }
    } else {
%>
                            <tr align="center">
                              <td class="td04" colspan="5">해당하는 데이터가 존재하지 않습니다.</td>
                            </tr>
                            <%
    }
%>
                          </table></td>
                      </tr>
                    </table></td>
                </tr>
              </table></td>
          </tr>
        </table>
        <table width="100%" height="20" border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td height="30">&nbsp;</td>
          </tr>
        </table></td>
    </tr>
  </table>
<%
}
%>
<% } //@v1.2 end %>              

  <input type="hidden" name="jobid2"   value="">
  <input type="hidden" name="licn_code" value="">
</form>
<%@ include file="/web/common/commonEnd.jsp" %>
</body>
</html>
