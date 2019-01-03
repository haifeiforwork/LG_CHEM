<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 가족사항                                                    */
/*   Program Name : 부양가족여부 수정                                           */
/*   Program ID   : A12SupportChange.jsp                                        */
/*   Description  : 부양가족여부 수정                                           */
/*   Note         : 없음                                                        */
/*   Creation     : 2002-01-03  김도신                                          */
/*   Update       : 2005-03-03  윤정현                                          */
/*                  2008-04-21  lsa @v1.0 [CSR ID:1254077]대리신청시 정보조회안되게수정*/
/*                  2014-12-02 [CSR ID:2654794] 부양가족 신청화면 변경요청                                                             */

/*                  2015-11-02 [CSR ID:2908196] 부양가족 신청 안내화면 수정    */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
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
    Vector              a12FamilyListData_vt   = rfc_list.getFamilyList(data.PERNR, data.SUBTY, data.OBJPS);
    A12FamilyListData   data_list              = (A12FamilyListData)a12FamilyListData_vt.get(0);

    /* 결제정보를 vector로 받는다*/
    Vector  AppLineData_vt             = (Vector)request.getAttribute("AppLineData_vt");
    String RequestPageName = (String)request.getAttribute("RequestPageName");

    // 2015- 06-08 개인정보 통합시 subView ="Y";

    String subView = WebUtil.nvl(request.getParameter("subView"));
%>
<html>
<head>
<title>ESS</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr.css" type="text/css">

<script language="javascript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>
<script language="JavaScript">
<!--

<%if(subView.equals("Y")){ %>  

parent.window.scroll(0,0);

<%}%>
function do_change(){
    if( check_data() ){
    
        document.form1.jobid.value = "change";
        document.form1.AINF_SEQN.value = "<%= data.AINF_SEQN %>";
        
        if ( document.form1.DPTID.checked == true ) {
            document.form1.DPTID.value = "X";
        } else {
            document.form1.DPTID.value = "";
        }
        if ( document.form1.HNDID.checked == true ) {
            document.form1.HNDID.value = "X";
        } else {
            document.form1.HNDID.value = "";
        }
        if ( document.form1.LIVID.checked == true ) {
            document.form1.LIVID.value = "X";
        } else {
            document.form1.LIVID.value = "";
        }
        if ( document.form1.BALID.checked == true ) {
            document.form1.BALID.value = "X";
        } else {
            document.form1.BALID.value = "";
        }
<%
    if( data.SUBTY.equals("2") ) {
%>

/*  [CSR ID:2654794] 부양가족 신청화면 변경요청    
        if ( document.form1.CHDID.checked == true ) {
            document.form1.CHDID.value = "X";
        } else {
            document.form1.CHDID.value = "";
        }

*/        
<%
    }
%>        
        document.form1.action = "<%= WebUtil.ServletURL %>hris.A.A12Family.A12SupportChangeSV?subView=<%=subView%>";

        <%if(subView.equals("Y")){ %>  

         document.form1.target = "listFrame";

        <%}%>
        document.form1.method = "post";
        document.form1.submit();
    }
}

function check_data(){
    // 신청관련 단위 모듈에서 필히 넣어야?l 항목...
    if ( check_empNo() ){
        return false;
    }
    // 신청관련 단위 모듈에서 필히 넣어야?l 항목...

    return true;
}



function open_help2(param) {

  small_window=window.open("/web/help_online/help_C100/"+param,"","toolbar=0,location=0,directories=0,status=0,scrollbars=yes,menubar=1,resizable=no,width=850,height=600,left=100,top=100");

  small_window.focus();

}
//-->
</script>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<form name="form1" method="post">
  <table width="796" border="0" cellspacing="0" cellpadding="0">
    <tr>
<%if(subView.equals("Y")){ %>    

      <td width="1">&nbsp;</td>

<%}else{ %>      

 		<td width="16">&nbsp;</td>

<%}%>      
      <td>
        <table width="780" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td width="780">
              <table width="780" border="0" cellpadding="0" cellspacing="0">
                <tr>
                  <td height="5" colspan="2"></td>
                </tr>
                <tr>
                  <td class="font01" style="padding-bottom:2px"><img src="<%= WebUtil.ImageURL %>ehr/icon_o.gif">부양가족여부 신청 수정</td>

                  <!-- [CSR ID:2908196] 부양가족 신청 안내화면 수정 -->                  
                  <td align="right"><a href="javascript:open_help2('A12Family.html');" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image6','','<%= WebUtil.ImageURL %>btn_help_on.gif',1)"><img name="Image6" border="0" src="<%= WebUtil.ImageURL %>btn_help_off.gif" width="90" height="15" alt="도움말"></a></td>

                  <!-- <td class="titleRight"></td>-->
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
                    <table width="770" border="0" cellspacing="0" cellpadding="0" align="center">
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
                              <%
                                String reg_no = "";
                                if( !user.empNo.equals(data.PERNR) ) {
                                    //reg_no = data_list.REGNO.substring( 0, 6 ) + "*******";
                                    reg_no =  "*************";
                                } else {
                                    reg_no = data_list.REGNO;
                                }
                              %>                             
                            <tr>
                              <td class="td01">주민등록번호</td>
                              <td class="td09">
                                <input type="text" name="regno"  value="<%= DataUtil.addSeparate(reg_no) %>" class="input04" size="20" readonly>
                              </td>
                              <td width="80" class="td01">관 계</td>
                              <td class="td09">
                                <input type="text" name="atext"  value="<%= data_list.ATEXT %>" class="input04" size="20" readonly>
                              </td>
                            </tr>
<% //@v1.0 
  if( user.empNo.equals(data.PERNR) ) {
%>                   
                            
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
<% } %>                               
                          </table>
                        </td>
                      </tr>
                      <tr>
                        <td class="font01">&nbsp;</td>
                      </tr>
                      <tr>
                        <td><font color="#006699">해당사항에 체크하여 주시기 바랍니다.</font></td>
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
                            <tr>
                              <td valign="top">
                                <table width="305" border="0" cellspacing="1" cellpadding="0" class="table02">
                                  <tr>
                                    <td bgcolor="#FFFFFF">
                                      <table width="303" border="0" cellspacing="1" cellpadding="3">
                                        <tr>
                                          <td class="td09">
                                        <input type="checkbox" name="DPTID" value="<%= data.DPTID %>" <%= data.DPTID.equals("X") ? "checked" : "" %>>
                                        부양가족
                                      </td>
                                          <td class="td09">
                                        <input type="checkbox" name="BALID" value="<%= data.BALID %>" <%= data.BALID.equals("X") ? "checked" : "" %>>
                                        수급자
                                      </td>                                      
                                    </tr>
                                    <tr>
                                      <td class="td09">
                                        <input type="checkbox" name="HNDID" value="<%= data.HNDID %>" <%= data.HNDID.equals("X") ? "checked" : "" %>>
                                        장애인
                                      </td>
                                    </tr>
<%
    if( data.SUBTY.equals("2") ) {
%>

 <!-- 20141202 박난이S 요청(연말정산) [CSR ID:2654794] 부양가족 신청화면 변경요청 
                                    <tr>
                                      <td class="td09">
                                        <input type="checkbox" name="CHDID" value="<%= data.CHDID %>" <%= data.CHDID.equals("X") ? "checked" : "" %>>
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
                                    <input type="checkbox" name="LIVID" value="<%= data.LIVID %>" <%= data.LIVID.equals("X") ? "checked" : "" %>>
                                    동거여부
                                     </td>
                                    </tr>
                                  </table>
                                </td>
                              </tr>
                            </table>
                          </td>
                        </tr>
                      </table>
                    </td>
                  </tr>
                </table>
              </td>
            </tr>
          </table>
          <!--상단 입력 테이블 끝-->
        </td>
      </tr>
      <tr>
        <td class="td09">
          <font color="#006699">&nbsp;&nbsp;※ 부양가족여부는 연말정산자료로서 자격요건에 해당하는 경우에만 신청하시기 바랍니다.<br>
                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;신청하시기전에 사용방법안내에서 자격요건과 제출서류를 반드시 확인해 주시기 바랍니다.</font>
        </td>
      </tr>
      <tr>
        <td>&nbsp;</td>
      </tr>
      <tr>
        <td>
          <table width="780" border="0" cellspacing="0" cellpadding="0">
            <tr>
              <td class="font01" style="padding-bottom:2px"><img src="<%= WebUtil.ImageURL %>ehr/icon_o.gif"> 결재정보</td>
            </tr>
          </table>
        </td>
      </tr>
      <tr>
        <td>
        <!-- 결재자 입력 테이블 시작-->
<%= hris.common.util.AppUtil.getAppBuild(AppLineData_vt,data.PERNR) %>
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
                <a href="javascript:do_change();">
                  <img src="<%= WebUtil.ImageURL %>btn_input.gif" align="absmiddle" border="0"></a>
                <a href="javascript:history.back();">
                  <img src="<%= WebUtil.ImageURL %>btn_cancel.gif" align="absmiddle" border="0"></a>
              </td>
            </tr>
          </table>
        </td>
      </tr>
    </table>
    </td>
  </tr>
</table>
<!--  HIDDEN  처리해야할 부분 시작-->
  <input type="hidden" name="jobid"     value="">
  <input type="hidden" name="AINF_SEQN" value="">
  <input type="hidden" name="GUBUN"     value="X">    <!-- 구분 'X':부양가족, ' ':가족수당 -->
  <input type="hidden" name="BEGDA"     value="<%= data.BEGDA %>">
  <input type="hidden" name="SUBTY"     value="<%= data_list.SUBTY %>">
  <input type="hidden" name="OBJPS"     value="<%= data_list.OBJPS %>">
  <input type="hidden" name="LNMHG"     value="<%= data_list.LNMHG %>">
  <input type="hidden" name="FNMHG"     value="<%= data_list.FNMHG %>">
  <input type="hidden" name="REGNO"     value="<%= data_list.REGNO %>">
  <input type="hidden" name="RequestPageName" value="<%=RequestPageName%>">
<%
/*  XxxDetail.jsp로 넘겨주기위해서.. */
    String ThisJspName = (String)request.getAttribute("ThisJspName");
    Logger.debug.println(this, "ThisJspName : "+ ThisJspName);
%>
  <input type="hidden" name="ThisJspName" value="<%= ThisJspName %>">
<!--  HIDDEN  처리해야할 부분 끝-->
</form>
<%@ include file="/web/common/commonEnd.jsp" %>

