<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.A.A16Appl.*" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="hris.E.E05House.*" %>
<%@ page import="hris.E.E05House.rfc.*" %>

<%@ page import="com.sns.jdf.util.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%
    String          jobid              = (String)request.getAttribute("jobid");
  	String          paging             = (String)request.getAttribute("page");
  	A16ApplListKey  key                = (A16ApplListKey)request.getAttribute("A16ApplListKey");
  	Vector          A16ApplListData_vt = (Vector)request.getAttribute("A16ApplListData_vt");
    WebUserData     user               = (WebUserData)session.getAttribute("user");//회사코드사용위해

  	//PageUtil 관련 - Page 사용시 반드시 써줄것.
  	PageUtil pu = null;
  	try {
  		pu = new PageUtil(A16ApplListData_vt.size(), paging , 10, 10);
      Logger.debug.println(this, "page : "+paging);
  	} catch (Exception ex) {
  		Logger.debug.println(DataUtil.getStackTrace(ex));
  	}
%>

<html>
<head>
<title>ESS</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ess8.css" type="text/css">

<script language="javascript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>
<script language="javascript">
<!--
function on_Load(){
    if( '<%= jobid %>' == 'first' ) {
		    document.form1.UPMU_TYPE.value = "";
		    document.form1.STAT_TYPE.value = "";
		    document.form1.BEGDA.value = '<%= key.BEGDA %>';
		    document.form1.ENDDA.value = '<%= key.ENDDA %>';
		    document.form1.jobid.value = "search";

		    document.form1.action = '<%= WebUtil.ServletURL %>hris.A.A16Appl.A16ApplListSV';
		    document.form1.submit();
		}
}

function doSubmit(){
	if( check_data() ) {
		document.form1.UPMU_TYPE.value = document.form1.UPMU_TYPE[form1.UPMU_TYPE.selectedIndex].value;
		document.form1.STAT_TYPE.value = document.form1.STAT_TYPE[form1.STAT_TYPE.selectedIndex].value;
		document.form1.BEGDA.value = changeChar( document.form1.from_date.value, ".", "" );
		document.form1.ENDDA.value = changeChar( document.form1.to_date.value, ".", "" );
		document.form1.jobid.value = "search";

		document.form1.action = '<%= WebUtil.ServletURL %>hris.A.A16Appl.A16ApplListSV';
		document.form1.submit();
	}
}

function check_data() {
	def = dayDiff(document.form1.from_date.value, document.form1.to_date.value);
	if( def < 0 ) {
		alert("신청일의 범위가 올바르지 않습니다.");
		return false;
	}
	return true;
}

function viewDetail(upmu, begin_date, seqno, stat){
  document.form2.BEGDA.value = begin_date;
  document.form2.AINF_SEQN.value = seqno;
  document.form2.ThisJspName.value = "A16ApplList.jsp";
  if(upmu =="04") {
      document.form2.STAT_TYPE.value=stat;
   }
  switch(upmu){
    case "01":    // 경조금
      document.form2.action = '<%= WebUtil.ServletURL %>hris.E.E19Congra.E19CongraDetailSV';
      break;
    case "02":    // 개인연금
      document.form2.action = '<%= WebUtil.ServletURL %>hris.E.E10Personal.E10PersonalDetailSV';
      break;
    case "03":    // 의료비
      document.form2.action = '<%= WebUtil.ServletURL %>hris.E.E17Hospital.E17HospitalDetailSV';
      break;
    case "04":    // 종합검진
      document.form2.action = '<%= WebUtil.ServletURL %>hris.E.E15General.E15GeneralDetailSV';
      break;
    case "05":    // 입학축하금
      document.form2.action = '<%= WebUtil.ServletURL %>hris.E.E21Entrance.E21EntranceDetailSV';
      break;
    case "06":    // 학자금/장학금
      document.form2.action = '<%= WebUtil.ServletURL %>hris.E.E21Expense.E21ExpenseDetailSV';
      break;
    case "07":    // 가족사항(부양가족 신청)
      document.form2.action = '<%= WebUtil.ServletURL %>hris.A.A12Family.A12SupportDetailSV';
      break;
    case "08":    // 교육과정신청 
<%
//  석유화학 교육신청 메뉴를 따로 가기로함. - kds
    if( user.companyCode.equals("N100") && user.empNo.equals("118627") ) {
%>
      document.form2.action = '<%= WebUtil.ServletURL %>hris.C.C10Education.C10EducationDetailSV';
<%
    } else {
%>
      document.form2.action = '<%= WebUtil.ServletURL %>hris.C.C02Curri.C02CurriDetailSV';
<%
    }
%>
      break;
    case "09":    // 재해신청
      document.form2.action = '<%= WebUtil.ServletURL %>hris.E.E19Disaster.E19CongraDetailSV';
      break;
    case "10":    // 급여계좌
      document.form2.action = '<%= WebUtil.ServletURL %>hris.A.A14Bank.A14BankDetailSV';
      break;
    case "11":    // 증권계좌
      document.form2.action = '<%= WebUtil.ServletURL %>hris.E.E12Stock.E12StockDetailSV';
      break;
    case "12":    // 주택자금신청
      document.form2.action = '<%= WebUtil.ServletURL %>hris.E.E05House.E05HouseDetailSV';
      break;
    case "13":    // 주택자금상환
      document.form2.action = '<%= WebUtil.ServletURL %>hris.E.E06Rehouse.E06RehouseDetailSV';
      break;
    case "14":    // 자격사항
      document.form2.action = '<%= WebUtil.ServletURL %>hris.A.A17Licence.A17LicenceDetailSV';
      break;
    case "15":    // 어학검정
      document.form2.action = '';
      break;
    case "16":    // 재직증명서
      document.form2.action = '<%= WebUtil.ServletURL %>hris.A.A15Certi.A15CertiDetailSV';
      break;
    case "17":    // 초과근무신청
      document.form2.action = '<%= WebUtil.ServletURL %>hris.D.D01OT.D01OTDetailSV';
      break;
    case "18":    // 휴가신청
      document.form2.action = '<%= WebUtil.ServletURL %>hris.D.D03Vocation.D03VocationDetailSV';
      break;
    case "19":    // 동호회
      document.form2.action = '<%= WebUtil.ServletURL %>hris.E.E25Infojoin.E25InfoDetailSV';
      break;
    case "20":    // 건강보허 피부양자
      document.form2.action = '<%= WebUtil.ServletURL %>hris.E.E01Medicare.E01MedicareDetailSV';
      break;
    case "21":    // 건강보험증 기재사항 변경/재발급
      document.form2.action = '<%= WebUtil.ServletURL %>hris.E.E02Medicare.E02MedicareDetailSV';
      break;
    case "22":    // 국민연금 자격변경
      document.form2.action = '<%= WebUtil.ServletURL %>hris.E.E04Pension.E04PensionChngDetailSV';
      break;
    case "24":    // 가족수당
      document.form2.action = '<%= WebUtil.ServletURL %>hris.A.A12Family.A12AllowanceDetailSV';
      break;
    case "26":    // 개인연금해약
      document.form2.action = '<%= WebUtil.ServletURL %>hris.E.E11Personal.E11AnuulmentDetailSV';
      break;
    case "27":    // 동호회 탈퇴
      document.form2.action = '<%= WebUtil.ServletURL %>hris.E.E26InfoState.E26InfosecessionDetailSV';
      break;
    case "28":    // 근로소득 원천징수 영수증 및 갑근세 
      document.form2.action = '<%= WebUtil.ServletURL %>hris.A.A18Deduct.A18DeductDetailSV';
      break;
    case "29":    // 가족수당상실
      document.form2.action = '<%= WebUtil.ServletURL %>hris.A.A12Family.A12AllowanceCancelDetailSV';
      break;
    case "30":    // 부양가족 변경(해지)
      document.form2.action = '<%= WebUtil.ServletURL %>hris.A.A12Family.A12SupportCancelDetailSV';
      break;
    case "31":    // LG석유화학-어학지원 신청
      document.form2.action = '<%= WebUtil.ServletURL %>hris.C.C07Language.C07LanguageDetailSV';
      break;
    case "32":    // LG석유화학-산전후 휴가신청
      document.form2.action = '<%= WebUtil.ServletURL %>hris.D.D07Maternity.D07MaternityDetailSV';
      break;
  }
  document.form2.submit();
}

// 달력 사용
function fn_openCal(Objectname){
   var lastDate;
    
    lastDate = eval("document.form1." + Objectname + ".value");
    small_window  = window.open("<%=WebUtil.JspURL%>common/calendar.jsp?formname=form1&fieldname="+ Objectname + "&curDate=" + lastDate + "&iflag=0","essCal", "toolbar=0,location=0,directories=0,status=0,menubar=0,resizable=0,width=300,height=300");
    small_window.focus();
}
// 달력 사용

// PageUtil 관련 script - page처리시 반드시 써준다...
function pageChange(page){
  document.form1.page.value = page;
  doSubmit();
}
// PageUtil 관련 script - page처리시 반드시 써준다...

// PageUtil 관련 script - selectBox 사용시 - Option
function selectPage(obj){
  val = obj[obj.selectedIndex].value;
  pageChange(val);
}
// PageUtil 관련 script - selectBox 사용시 - Option

//-->
</script>
</head>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('<%= WebUtil.ImageURL %>btn_help_on.gif')">
<form name="form1" method="post" action="">
<input TYPE="hidden" name="jobid" value="">
<input TYPE="hidden" name="ThisJspName" value="">
<input TYPE="hidden" name="BeforeJspName" value="">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr> 
    <td width="15">&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr> 
    <td width="15">&nbsp; </td>
    <td> 
      <!--타이틀 테이블 시작-->
        <table width="790" border="0" cellspacing="0" cellpadding="0">
          <tr> 
            <td align="right">
              &nbsp;<a href="javascript:open_help('A16Appl.html');" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image6','','<%= WebUtil.ImageURL %>btn_help_on.gif',1)"></a>
            </td>
          </tr>
          <tr> 
            <td class="title01">결재 진행 현황</td>
          </tr>
        </table>
      <!--타이틀 테이블 끝-->
    </td>
  </tr>
  <tr> 
    <td width="15">&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
    <tr> 
      <td width="15">&nbsp; </td>
      <td> 
        <!-- 상단 검색테이블 시작-->
        <table width="580" border="0" cellspacing="1" cellpadding="0" class="table01">
          <tr> 
            <td class="tr01"> 
              <table width="560" border="0" cellspacing="1" cellpadding="2">
                <tr> 
                  <td width="80" class="td01">업무구분</td>
                  <td class="td02" width="150"> 
                    <select name="UPMU_TYPE" class="input03">
<%= WebUtil.printOption( ( new UpmuCodeRFC() ).getUpmuCode(user.companyCode), key.UPMU_TYPE ) %>
                    </select>
                  </td>
                  <td width="80" class="td01">상 태</td>
                  <td class="td02" width="198"> 
                    <select name="STAT_TYPE" class="input03">
                      <option value=""   <%= key.STAT_TYPE.equals("")   ? "selected" : "" %>>전체</option>
                      <option value="01" <%= key.STAT_TYPE.equals("01") ? "selected" : "" %>>미결재</option>
                      <option value="02" <%= key.STAT_TYPE.equals("02") ? "selected" : "" %>>진행중</option>
                      <option value="03" <%= key.STAT_TYPE.equals("03") ? "selected" : "" %>>결재완료</option>
                    </select>
                  </td>
                  <td class="td02" width="52">&nbsp;</td>
                </tr>
                <tr> 
                  <td width="80" class="td01">신청일</td>
                  <td class="td02" colspan="3">
				            <input type="hidden" name="BEGDA" value="">
					          <input type="hidden" name="ENDDA" value="">
                    <input type="text" name="from_date" size="15" class='input03' value='<%= WebUtil.printDate(key.BEGDA,".") %>' onBlur="dateFormat(this);">
                    <a href="javascript:fn_openCal('from_date')"><img src="<%= WebUtil.ImageURL %>btn_serch.gif" width="31" height="21" align="absmiddle" border="0"></a> 
                    - 
                    <input type="text" name="to_date" size="15" class="input03" value='<%= WebUtil.printDate(key.ENDDA,".") %>' onBlur="dateFormat(this);">
                    <a href="javascript:fn_openCal('to_date')"><img src="<%= WebUtil.ImageURL %>btn_serch.gif" width="31" height="21" align="absmiddle" border="0"></a>
                    (예: 2001.12.13)</td>
                  <td class="td02" width="52">
                  <a href="javascript:doSubmit();">
                  <img src="<%= WebUtil.ImageURL %>btn_serch02.gif" width="52" height="20" border="0"></a>
                  </td>
                </tr>
              </table>
            </td>
          </tr>
        </table>
        <!-- 상단 검색테이블 끝-->
      </td>
    </tr>
   <tr> 
    <td width="15">&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr> 
    <td width="15">&nbsp; </td>
    <td> 
      <table width="585" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td class="font01" background="<%= WebUtil.ImageURL %>bg_pixel02.gif">
          <img src="<%= WebUtil.ImageURL %>bg_pixel02.gif" width="4" height="13"></td>
        </tr>
      </table>
    </td>
  </tr>
  <tr> 
    <td width="15">&nbsp;</td>
    <td> 
      <!-- 결재자 입력 테이블 시작-->
      <table width="580" border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td>
            <table width="484" border="0" cellspacing="3" cellpadding="0" align="center">
		          <tr> 
<% 
    if ( A16ApplListData_vt.size() > 0 ) {
%>
                <td align="right" class="td02"><%= pu == null ? "" : pu.pageInfo() %></td>
<%
    } else {
%>
                <td align="right" class="td02">&nbsp;</td>
<%
    } 
%>
              </tr>
              <tr> 
                <td> 
                  <table width="480" border="0" cellspacing="1" cellpadding="2" class="table01">
                    <tr> 
                      <td class="td03" width="60">No.</td>
                      <td class="td03" width="120">신청일</td>
                      <td class="td03" width="200">업무구분</td>
                      <td class="td03" width="100">상 태</td>
                    </tr>
<% 
    if ( A16ApplListData_vt.size() > 0 ) {
        for( int i = pu.formRow() ; i < pu.toRow(); i++ ) {
            A16ApplListData data = (A16ApplListData)A16ApplListData_vt.get(i);
%>
                      <tr align="center"> 
                      <td class="td02" width="60"><%= (i + 1) %></td>
                      <td class="td02" width="120" >
                        <a href="javascript:viewDetail('<%= data.UPMU_TYPE %>', '<%= data.BEGDA %>','<%= data.AINF_SEQN %>','<%= data.STAT_TYPE %>');">
                        <%= WebUtil.printDate(data.BEGDA,".") %></a></td>
                      <td class="td02" width="200">
                        <a href="javascript:viewDetail('<%= data.UPMU_TYPE %>', '<%= data.BEGDA %>','<%= data.AINF_SEQN %>','<%= data.STAT_TYPE %>');">
                        <%= data.UPMU_NAME.trim() %></a></td>
                      <td class="td02" width="100">
                         <%=
                          data.STAT_TYPE.equals("01") ? "<img src='"+WebUtil.ImageURL+"icon_red.gif' border=0 >" : 
                          data.STAT_TYPE.equals("02") ? "<img src='"+WebUtil.ImageURL+"icon_yellow.gif' border=0 >" : 
                          data.STAT_TYPE.equals("03") ? "<img src='"+WebUtil.ImageURL+"icon_green.gif' border=0 >" : "" 
                          %>
                      </td>
                    </tr>
<%
        }
%>
                  </table>
                </td>
              </tr>
<!-- PageUtil 관련 - 반드시 써준다. -->
              <tr> 
                <td align="center" height="25" valign="bottom" class="td02">
                  <input type="hidden" name="page" value="">
<%= pu == null ? "" : pu.pageControl() %>
	              </td>
              </tr>
<!-- PageUtil 관련 - 반드시 써준다. -->
            </table>
          </td>
        </tr>
      </table>
      <!-- 결재자 입력 테이블 시작-->
    </td>
  </tr>
<%
    } else {
%>
                    <tr> 
                      <td class="td02" align="center" colspan="4">해당하는 데이타가 없습니다.</td>
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
<%
    }
%>
</table>
</form>
<form name="form2" method="post" action="">
  <INPUT TYPE="hidden" name="ThisJspName"   value="">
  <INPUT TYPE="hidden" name="BeforeJspName" value="">
  <INPUT TYPE="hidden" name="jobid"         value="">
  <INPUT TYPE="hidden" name="BEGDA"         value="">
  <INPUT TYPE="hidden" name="AINF_SEQN"     value="">
  <INPUT TYPE="hidden" name="STAT_TYPE"     value="">
</form>
<%@ include file="/web/common/commonEnd.jsp" %>
