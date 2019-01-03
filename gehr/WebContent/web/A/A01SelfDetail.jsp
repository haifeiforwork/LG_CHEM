<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 개인인적사항                                                */
/*   Program Name : 개인인적사항 조회                                           */
/*   Program ID   : A01SelfDetail.jsp                                           */
/*   Description  : 개인인적사항 조회                                           */
/*   Note         : 없음                                                        */
/*   Creation     :                                                             */
/*   Update       : 2005-01-31  윤정현                                          */
/*                  2005-11-07  lsa @v1.1사진사이즈수정 원본:136:164-> 110->116.1 :140*/
/*                  2006-03-17  @v1.2 lsa 급여작업으로 막음                     */
/*                  2006-05-17  @v1.2 lsa 5월급여작업으로 막음  전문기술직만    */
/*                  2006-06-16  @v1.2 kdy 임금인상관련 급여화면 제어              */
/*                  2008-04-21  lsa @v1.0 [CSR ID:1254077]대리신청시 정보조회안되게수정*/
/*                  2013-08-21 [CSR ID:2389767] [정보보안] e-HR MSS시스템 수정  */
/*   Update       :  구분추가 C20140210_84209                            */
/*                                                                              */
/********************************************************************************/%>


<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.A.*" %>
<%@ page import="hris.D.D05Mpay.rfc.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%@ page import="hris.B.db.*" %> 
 
<%
    WebUserData user = WebUtil.getSessionUser(request);

    Vector a01SelfDetailData_vt = (Vector)request.getAttribute("A01SelfDetailData_vt");
    String imgUrl               = (String)request.getAttribute("imgUrl");
    A01SelfDetailData data      = (A01SelfDetailData)a01SelfDetailData_vt.get(0);

    String DB_YEAR   = "";
    String StartDate = "";
    B01ValuateDetailDB valuateDetailDB     = new B01ValuateDetailDB();
    Vector             B01ValuateDBData_vt = new Vector();

    DB_YEAR   = valuateDetailDB.getYEAR();
    StartDate = valuateDetailDB.getStartDate();  
       
%>
<html>
<head>
<title>ESS</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr.css" type="text/css">

<script language="JavaScript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>
<script language="JavaScript">
function message(){
}
 
</script>
</head>
<!--[CSR ID:2389767] [정보보안] e-HR MSS시스템 수정-->
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="javascript:message()"   oncontextmenu="return false" ondragstart="return false" onselectstart="return false" onKeyUp="ClipBoardClear()">
<form name="form1" method="post" action="">

  <input type="hidden" name="jobid2"  value="">
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
                  <td class="title02"><img src="<%= WebUtil.ImageURL %>ehr/title01.gif">개인 인적사항 조회</td>
                  <td align="right"></td>
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
<% //@v1.2 
   //if ( ( user.e_persk.equals("32")||user.e_persk.equals("33") ) && Integer.parseInt(DataUtil.getCurrentDate()) >= 20060616 &&  Integer.parseInt(DataUtil.getCurrentDate())  < 20060623 ) { 
   String O_CHECK_FLAG = ( new D05ScreenControlRFC() ).getScreenCheckYn( user.empNo );
  
  if (O_CHECK_FLAG.equals("N") ) {
%>            
                    <table border="0" cellspacing="0" cellpadding="0">
                      <tr>
                        <td class="td09" align="left">
                           <font color="red">※ 급여작업으로 인해 메뉴 사용을 일시 중지합니다.<br><br></font><!--@v1.1-->
                         </td>
                      </tr>
                    </table>
<% } else {  //@v1.2 else %>            
          
          <tr>
            <td height="10">&nbsp;</td>
          </tr>
<!-- CSR:  인사정보확인 위해 -->          
<%
      if(     Long.parseLong(StartDate) <= Long.parseLong(DataUtil.getCurrentDate())   ) { 
      
%>         
<!--[CSR ID:1558477] 인사기록부 개선 요청의 건-->
<script>
function go_Insaprint(){
    
    window.open('', 'essPrintWindow', "toolbar=no,location=no, directories=no,status=no,menubar=yes,resizable=no,width=1010,height=662,left=0,top=2");

    document.form1.target = "essPrintWindow";
    document.form1.jobid2.value = "printSelf";//C20140210_84209
    document.form1.action = "<%= WebUtil.JspURL %>common/printFrame_insa.jsp";
    document.form1.method = "post";
    document.form1.submit();     

}
</script>
         
         <tr>
            <td align="right" style="padding-bottom:5px"><a href="javascript:go_Insaprint();"><img src="<%= WebUtil.ImageURL %>ehr/bt_g01.gif" border="0"></a></td>
          </tr>          
          <tr>  
          <input type="hidden" name="pernr"   value="<%=DataUtil.encodeEmpNo(data.PERNR) %>">
          <input type="hidden" name="Screen"   value=""><!-- C20140210_84209 -->
          
<%
     }
%>           
            <td><table width="780" border="0" cellspacing="1" cellpadding="0">
                <tr>
                  <td bgcolor="#FFFFFF">
                    <table width="100%" border="0" cellpadding="0" cellspacing="" bgcolor="#FFFFFF">
                      <tr>
                        <td>
                          <table width="100%" border="0" cellspacing="0" cellpadding="0" class="table02">
                            <tr>
                              <td width="120" style="vertical-align:middle;border:solid 0px #ddd;background:#ddd;padding:0 7px 0 7px;">
                                <table width="115" border="0" cellspacing="1" cellpadding="0" height="148" class="table02 picTable">
                                  <tr>
                                    <td class="td04"><img name="photo1" border="0" src="<%= imgUrl %>" width="116.1" height="140" ></td>
                                  </tr>
                                </table>
                              </td>
                              <td>
                                <table width="610" border="0" cellspacing="1" cellpadding="3" class="table02" style="border-top:none;">
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
                                    <td class="td04"><%= DataUtil.addSeparate(data.REGNO) %>&nbsp;</td>
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
<%
	//사원하위 그룹 user
	String stext = "급호";
	String persk =user.e_persk;
	if(persk.equals("11") || persk.equals("12")  || persk.equals("13")){
		stext = "직급";
	}else if(persk.equals("21") || persk.equals("22")){
		stext = "직급/년차";
	}
%>                                  
                                  <tr>
                                    <td class="td03"><%=stext %></td>
                                    <td class="td04"><%= data.VGLST %>&nbsp;</td>
                                    <td class="td03">근속기준일</td>
                                    <td class="td04"><%= (data.DAT01).equals("0000-00-00") ? "" : WebUtil.printDate(data.DAT01) %>&nbsp;</td>
                                    <td class="td03">국적</td>
                                    <td class="td04"><%= data.LANDX %>&nbsp;</td>
                                  </tr>
                                </table>
                              </td>
                            </tr>
                          </table>
                        </td>
                      </tr>
                      <tr>
                        <td>&nbsp;</td>
                      </tr>
                      <tr>
                        <td class="font01" style="padding-bottom:2px"><img src="<%= WebUtil.ImageURL %>ehr/icon_o.gif"> 주소 및 신상</td>
                      </tr>
                      <tr>
                        <td>
                          <table width="730" border="0" cellspacing="1" cellpadding="3" class="table02">
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
    if( user.companyCode.equals("C100") ) {
%>
                              <td class="td03">보훈대상</td>
                              <td colspan="7" class="td04" style="text-align:left">&nbsp;&nbsp;<%= data.CONTX %>&nbsp;</td>
<%
//  석유화학의 경우 개인의 핸드폰 번호를 보여준다.
    } else if( user.companyCode.equals("N100") ) {
%>
                              <td class="td03">보훈대상</td>
                              <td colspan="4" class="td04" style="text-align:left">&nbsp;&nbsp;<%= data.CONTX %>&nbsp;</td>
                              <td class="td03" width="80">휴대폰</td>
                              <td colspan="2" class="td04"><%-- user.e_cell_phone --%>&nbsp;</td>
<%
    }
%>
                            </tr>
                          </table>
                        </td>
                      </tr>
                      <tr>
                        <td>&nbsp;</td>
                      </tr>
                      <tr>
                        <td class="font01" style="padding-bottom:2px"><img src="<%= WebUtil.ImageURL %>ehr/icon_o.gif"> 병역사항</td>                      
                      </tr>
                      <tr>
                        <td>
                          <table width="730" border="0" cellspacing="1" cellpadding="3" class="table02">
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
                          </table>
                        </td>
                      </tr>
                    </table>
                  </td>
                </tr>
              </table>
              <!--개인인적사항 테이블 끝-->
            </td>
          </tr>
          <tr>
            <td height="5"></td>
          </tr>
        </table>
      </td>
    </tr>
<% } //@v1.2 end %>              
              
  </table>
</form>
<%@ include file="/web/common/commonEnd.jsp" %>
