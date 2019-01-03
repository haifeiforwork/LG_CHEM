<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 연말정산                                                    */
/*   Program Name : 연말정산                                                    */
/*   Program ID   : D11TaxAdjustEduBuild.jsp                                    */
/*   Description  : 특별공제 교육비 입력 및 조회                                */
/*   Note         : 없음                                                        */
/*   Creation     :                                                             */
/*   Update       : 2005-02-01  윤정현                                          */
/*                  2005-11-24  @v1.1 lsa C2005111701000000551 및 버튼 분리작업 */
/*                  2005-11-28  @v1.2 lsa 성명선택시 관계에 자동셋팅            */
/*                              @v1.3 직계존속은 신청 불가                      */
/*                              @v1.4 본인만 학력에 대학원선택가능하게 처리     */
/*                  2006-11-23  @v1.5 lsa 국세청자료 추가                       */
/*                              @v1.6     대학교,대학원,사이버대학인 경우 국세청자료체크 비활성처리*/
/*                                                                              */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page import="java.util.Vector" %>
<%@ page import="hris.D.*" %>
<%@ page import="hris.D.rfc.*" %>
<%@ page import="hris.D.D11TaxAdjust.*" %>
<%@ page import="hris.D.D11TaxAdjust.rfc.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%
    WebUserData  user = (WebUserData)session.getAttribute("user");
    D00TaxAdjustPeriodRFC  periodRFC           = new D00TaxAdjustPeriodRFC();
    D00TaxAdjustPeriodData taxAdjustPeriodData = new D00TaxAdjustPeriodData();
    taxAdjustPeriodData = (D00TaxAdjustPeriodData)periodRFC.getPeriod(((WebUserData)session.getAttribute("user")).companyCode,((WebUserData)session.getAttribute("user")).empNo);

    String targetYear = (String)request.getAttribute("targetYear" );
    Vector edu_vt     = (Vector)request.getAttribute("edu_vt" );

//  2002.12.04. 연말정산 확정여부 조회
    String o_flag     = (String)request.getAttribute("o_flag" );

//  2002.12.03 내역조회가 가능한지 날짜를 체크한다.
    String currentDate = DataUtil.getCurrentDate();
    int appl_from = DataUtil.getBetween(currentDate, DataUtil.removeStructur(taxAdjustPeriodData.APPL_FROM,"-"));
    int appl_toxx = DataUtil.getBetween(currentDate, DataUtil.removeStructur(taxAdjustPeriodData.APPL_TOXX,"-"));
    int disp_from = DataUtil.getBetween(currentDate, DataUtil.removeStructur(taxAdjustPeriodData.DISP_FROM,"-"));
    int disp_toxx = DataUtil.getBetween(currentDate, DataUtil.removeStructur(taxAdjustPeriodData.DISP_TOXX,"-"));

    String Gubn = "Tax03";    //@v1.1

    //@v1.3
    D11TaxAdjustPePersonRFC   rfcPeP   = new D11TaxAdjustPePersonRFC();
    Vector EduPeP_vt = new Vector();
    EduPeP_vt      = rfcPeP.getPePerson( "3",user.empNo, targetYear  ); //I_GUBUN :1 - 보험료 2- 의료비  3-교육비 4-신용카드

%>

<html>
<head>
<title>ESS</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr.css" type="text/css">

<script language="JavaScript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>
<SCRIPT LANGUAGE="JavaScript">
// 연말정산 내역조회가 가능한지 check
function do_Check() {
    if( <%= disp_from %> <= 0 && <%= disp_toxx %> >= 0 ) {
        return true;
    } else {
        //alert("연말정산 내역조회 기간이 아닙니다.");
        //return false;
    }
}

// 특별공제 교육비 - 신청
function do_build() {

    for( var i = 0 ; i < "<%= edu_vt.size() %>" ; i++ ) {
        subty_i    = eval("document.form1.subty_i"+i+".value");
        ename_i    = eval("document.form1.ename_i"+i+".value");
        fasar_i    = eval("document.form1.fasar_i"+i+".value");
        addbetrg_i = eval("document.form1.addbetrg"+i+".value");
        actbetrg_i = eval("document.form1.actbetrg"+i+".value");
        auto_betrg_i = eval("document.form1.auto_betrg"+i+".value");

        if ( subty_i != "" && ( ename_i == "" || fasar_i == "") ) {
            alert("<spring:message code='MSG.D.D11.0030' />"); //관계, 성명, 학력은 필수 항목입니다.
            return;
        } else if ( ename_i != "" && ( subty_i == "" || fasar_i == "") )  {
            alert("<spring:message code='MSG.D.D11.0030' />"); //관계, 성명, 학력은 필수 항목입니다.
            return;
        } else if ( fasar_i != "" && ( subty_i == "" || ename_i == "") )  {
            alert("<spring:message code='MSG.D.D11.0030' />"); //관계, 성명, 학력은 필수 항목입니다.
            return;
        }
        if ( ( subty_i != "" &&   ename_i != "" && fasar_i != ""&& auto_betrg_i == 0) && (addbetrg_i =="" &&actbetrg_i=="") ) {
            alert("<spring:message code='MSG.D.D11.0031' />"); //개인추가분 또는 재활비에 값을 입력하세요.
            return;
        }

    }

    for( var i = 0 ; i < "<%= edu_vt.size() %>" ; i++ ) {
        goje_flag = eval("document.form1.GOJE_FLAG"+i+".value");
        if( goje_flag == "1" ) {
          eval("document.form1.SUBTY"+i+".value = document.form1.subty_i"+i+".value;");
          if( eval("document.form1.subty_i"+i+".selectedIndex") > 0 ) {
              eval("document.form1.STEXT"+i+".value = document.form1.subty_i"+i+"[document.form1.subty_i"+i+".selectedIndex].text;");
          }
          eval("document.form1.ENAME"+i+".value     = document.form1.ename_i"+i+".value;");
          eval("document.form1.FASAR"+i+".value     = document.form1.fasar_i"+i+".value;");
          eval("document.form1.ADD_BETRG"+i+".value = removeComma(document.form1.addbetrg"+i+".value);");
          eval("document.form1.ACT_BETRG"+i+".value = removeComma(document.form1.actbetrg"+i+".value);");
        }
        eval("document.form1.subty_i"+i+".disabled  = false;");//@v1.2

        //@v1.5
        if( eval("document.form1.CHNTS"+ i + ".checked == true") ) {
            eval("document.form1.CHNTS"+ i + ".value ='X';");
        } else {
            eval("document.form1.CHNTS"+ i + ".value ='';");
        }
        //@2011 교복구입비
        if( eval("document.form1.EXSTY"+ i + ".checked == true") ) {
            eval("document.form1.EXSTY"+ i + ".value ='X';");
        } else {
            eval("document.form1.EXSTY"+ i + ".value ='';");
        }
        eval("document.form1.EXSTY"+ i + ".disabled = false;") ;

        eval("document.form1.OMIT_FLAG"+ i + ".disabled = false;") ;
        if( eval("document.form1.OMIT_FLAG"+ i + ".checked == true") ) {
            eval("document.form1.OMIT_FLAG"+ i + ".value ='X';");
        } else {
            eval("document.form1.OMIT_FLAG"+ i + ".value ='';");
        }

    }
    eval("document.form1.FSTID.disabled = false;") ; //세대주여부
    if( eval("document.form1.FSTID.checked == true") )
        eval("document.form1.FSTID.value ='X';");

    document.form1.jobid.value = "build";
    document.form1.action      = "<%= WebUtil.ServletURL %>hris.D.D11TaxAdjust.D11TaxAdjustEduSV";
    document.form1.method      = "post";
    document.form1.target      = "menuContentIframe";
    document.form1.submit();
}

// 값이 변경되었는지 체크한다
function chk_change() {
    flag = false;
    for( var i = 0 ; i < "<%= edu_vt.size() %>" ; i++ ) {
        goje_flag = eval("document.form1.GOJE_FLAG"+i+".value");
        if( goje_flag == "1" ) {
            old_value = eval("document.form1.SUBTY"+i+".value;");
            new_value = eval("document.form1.subty_i"+i+".value;");
            if( old_value != new_value ) {
                flag = true;
            }

            old_value = eval("document.form1.ENAME"+i+".value;");
            new_value = eval("document.form1.ename_i"+i+".value;");
            if( old_value != new_value ) {
                flag = true;
            }

            old_value = eval("document.form1.FASAR"+i+".value;");
            new_value = eval("document.form1.fasar_i"+i+".value;");
            if( old_value != new_value ) {
                flag = true;
            }

            old_value = Number(eval("document.form1.ADD_BETRG"+i+".value;"));
            new_value = Number(eval("removeComma(document.form1.addbetrg"+i+".value);"));
            if( old_value != new_value ) {
                flag = true;
            }

            old_value = Number(eval("document.form1.ACT_BETRG"+i+".value;"));
            new_value = Number(eval("removeComma(document.form1.actbetrg"+i+".value);"));
            if( old_value != new_value ) {
                flag = true;
            }
        }
    }

}
//-->

//@v1.2 성명변경시 관계 값 선택
function subty_change(row, obj) {
 	  var val = obj[obj.selectedIndex].value;//DREL_CODE
    var inx = obj.selectedIndex;
    if( inx > 0 ) {
        var fami_rlat =  eval( "document.form1.FAMI_RLAT"+(inx-1)+".value"); //선택된 성명의 관계코드
        var fami_regn =  eval( "document.form1.FAMI_REGN"+(inx-1)+".value"); //선택된 성명의 주민번호
        var HNDID =  eval( "document.form1.HNDID"+(inx-1)+".value"); //선택된 성명의 장애인에 대한 지시자

        var subI = eval("document.form1.subty_i0.length");     //화면의관계코드index
        //화면의성명에 해당하는 관계코드setting
        for ( i=0; i< subI ; i++ ) {
            if ( eval( "document.form1.subty_i"+row+"["+i+"].value") == fami_rlat )
                eval( "document.form1.subty_i"+row+"["+i+"].selected = true;");
        }
        //화면의성명에 해당하는 주민번호setting
        eval( "document.form1.REGNO"+row+".value = \""+fami_regn+"\";");
    } else {
        eval( "document.form1.subty_i"+row+"["+inx+"].selected = true;");
        eval( "document.form1.REGNO"+row+".value = \"\";");
        eval("document.form1.fasar_i"+row+".value     = \"\";");
        eval("document.form1.addbetrg"+row+".value = \"\";");
        eval("document.form1.actbetrg"+row+".value = \"\";");
        eval("document.form1.CHNTS"+row+".checked = false;");
        eval("document.form1.EXSTY"+row+".checked = false;");
        var HNDID =  eval( "document.form1.HNDID.value"); //선택된 성명의 장애인에 대한 지시자

    }

    // 관계코드 인경우 금액 비활성처리(직계존속은 교육비 공제 안됨):
    // 01-부, 02-모, 11-조부, 12-조모, 13-장인, 14-장모, 22-시부, 23-시모,
    // 26-처조부, 27-처조모, 30-외조부, 31-외조모, 45-시조모, 46-시조부

    var notValue = new Array("01",
                             "02",
                             "11",
                             "12",
                             "13",
                             "14",
                             "22",
                             "23",
                             "26",
                             "27",
                             "30",
                             "31",
                             "45",
                             "46");

    eval( "document.form1.addbetrg"+row+".disabled  = false;");
    eval( "document.form1.actbetrg"+row+".disabled  = false;");
    for (r=0;r< notValue.length;r++) {
       if ( eval("document.form1.subty_i"+row+".value;") == notValue[r]) {
           if ( HNDID == "X") {    //장애면 개인추가금만 입력불가
              eval( "document.form1.addbetrg"+row+".value = \"\";");
              eval( "document.form1.addbetrg"+row+".disabled  = true;");
           }else{

              eval( "document.form1.addbetrg"+row+".value = \"\";");
              eval( "document.form1.actbetrg"+row+".value = \"\";");
              eval( "document.form1.addbetrg"+row+".disabled  = true;");
              eval( "document.form1.actbetrg"+row+".disabled  = true;");

              alert("<spring:message code='MSG.D.D11.0032' />"); //직계존속은 공제대상이 아닙니다.

           }
       }
    }
    school_change(row);
}
//@v1.4 본인( subty:35)인 경우만 대학원(H1) 선택가능하게
function school_change(row) {
    var sch = eval("document.form1.fasar_i"+row+"[document.form1.fasar_i"+row+".selectedIndex].value");//DREL_CODE
    var subty = eval( "document.form1.subty_i"+row+".value");
    var ename = eval( "document.form1.ename_i"+row+".value");
    if ( ename != "") {
        if ( ( sch == "H1" ) && (subty != "35"  ) ) {
            eval( "document.form1.fasar_i"+row+"[0].selected = true;");
            alert("<spring:message code='MSG.D.D11.0033' />"); //대학원 교육비 공제는 본인만 가능합니다.!
        }
        //@2011 교복구입비 D1:중학생, E1:고등학생인 경우만 가능
        if (  ( sch == "D1" ||sch == "E1")  ) {
            eval("document.form1.EXSTY"+ row +".disabled  = false;");
        }else{
            eval("document.form1.EXSTY"+ row +".disabled  = true;");
            eval("document.form1.EXSTY"+ row + ".checked =false;");
        }
    }

}
</SCRIPT>
</head>


<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<form name="form1" method="post">
  <table width="796" border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td width="16">&nbsp;</td>
      <td>
        <table width="780" border="0" cellspacing="0" cellpadding="0">
    <%@ include file="/web/D/D11TaxAdjust/D11TaxAdjustButton.jsp" %>

  <tr>
    <td>
      <!--특별공제 테이블 시작-->
      <table width="780" border="0" cellspacing="1" cellpadding="2" class="table02" bordercolor="#999999">
        <tr>
          <td class="td03" rowspan="2" width="100"><spring:message code="LABEL.D.D11.0009" /><!-- 관계 --></td>
          <td class="td03" rowspan="2" width="80"><spring:message code="LABEL.D.D11.0005" /><!-- 성명 --></td>
          <td class="td03" rowspan="2" width="90"><spring:message code="LABEL.D.D11.0018" /><!-- 학력 --></td>
          <td class="td03" rowspan="2" width="80"><spring:message code="LABEL.D.D11.0111" /><!-- 개인추가분 --></td>
          <td class="td03" rowspan="2" width="80"><spring:message code="LABEL.D.D11.0112" /><!-- 재활비 --></td>
          <td class="td03" colspan="2"><spring:message code="LABEL.D.D11.0113" /><!-- 자동반영분 --></td>
          <td class="td03" rowspan="2" width="45"><spring:message code="LABEL.D.D11.0114" /><!-- 교복구입비 --></td>
          <td class="td03" rowspan="2" width="45"><spring:message code="LABEL.D.D11.0053" /><!-- 국세청자료 --></td>
          <td class="td03" rowspan="2" width="30"><spring:message code="LABEL.D.D11.0055" /><!-- 연말정산삭제 --></td>
        </tr>
        <tr>
          <td class="td03" width="90"><spring:message code="LABEL.D.D11.0069" /><!-- 금액 --></td>
          <td class="td03" width="170"><spring:message code="LABEL.D.D11.0115" /><!-- 내용 --></td>
        </tr>
<%
    String old_Name = "";
    // @v1.2
    int index = 0;
    for( int j = 0 ; j < EduPeP_vt.size() ; j++ ){
        D11TaxAdjustPrePersonData fdata = (D11TaxAdjustPrePersonData)EduPeP_vt.get(j);
             if (!fdata.ENAME.equals(old_Name)&& !fdata.ENAME.equals("")&& !fdata.REGNO.equals("")) {

%>
                <input type=hidden name="FAMI_RLAT<%= index %>" value="<%=fdata.KDSVH%>">
                <input type=hidden name="FAMI_REGN<%= index %>" value="<%=fdata.REGNO%>">
                <input type=hidden name="HNDID<%= index %>" value="<%=fdata.HNDID%>">
<%
             index = index + 1;

             }
             old_Name = fdata.ENAME;
        }
%>


<%
    for( int i = 0 ; i < edu_vt.size() ; i++ ){
        D11TaxAdjustDeductData data = (D11TaxAdjustDeductData)edu_vt.get(i);
%>
        <tr>
            <input type=hidden name="auto_betrg<%= i %>" value="<%=data.AUTO_BETRG%>">

<!--          <td class="td04" style="text-align:left">&nbsp;<%= data.GUBN_TEXT %></td>-->
<%
        if( data.GOJE_FLAG.equals("1") ) {
%>
          <td class="td04">
            <select name="subty_i<%= i %>" class="input04" disabled>
              <option value="">---------------</option>
<%= WebUtil.printOption((new D11FamilyRelationRFC()).getFamilyRelation(""), data.SUBTY) %>
            </select>
          </td>
          <td class="td04">
              <select name="ename_i<%= i %>" class="<%= data.AUTO_BETRG.equals("0.0")  ? "input03" : "input04" %>" width=10 onChange="javascript:subty_change(<%=i%>,this);" <%= data.AUTO_BETRG.equals("0.0")  ? "" : "disabled" %>>
                <option value="">---------</option>
<%
    //@v1.3
    old_Name = "";
    for( int j = 0 ; j < EduPeP_vt.size() ; j++ ){
        D11TaxAdjustPrePersonData fdata = (D11TaxAdjustPrePersonData)EduPeP_vt.get(j);
        if (!fdata.ENAME.equals(old_Name)&& !fdata.ENAME.equals("")&& !fdata.REGNO.equals("")) {
%>
             <option value="<%=fdata.ENAME%>"  <%=fdata.REGNO.equals(data.REGNO) ? "selected" : ""%>><%=fdata.ENAME%></option>
<%
         }
         old_Name = fdata.ENAME;

    }
%>

              </select>
          </td>
          <td class="td04">
            <select name="fasar_i<%= i %>" class="<%= data.AUTO_BETRG.equals("0.0")  ? "input03" : "input04" %>" onChange="javascript:school_change(<%=i%>);" <%= data.AUTO_BETRG.equals("0.0")  ? "" : "disabled" %>>
              <option value="">-----------</option>
<%= WebUtil.printOption((new D11FamilyScholarshipRFC()).getFamilyScholarship(), data.FASAR) %>
            </select>
          </td>
          <td class="td04">
            <input type="text" name="addbetrg<%= i %>" value="<%= data.ADD_BETRG.equals("0.0")  ? "" : WebUtil.printNumFormat(data.ADD_BETRG) %>" size="12" class="<%= data.AUTO_BETRG.equals("0.0")  ? "input03" : "input04" %>" onKeyUp="javascript:moneyChkEventForWon(this);" style="text-align:right" onFocus="this.select()" <%= data.AUTO_BETRG.equals("0.0")  ? "" : "disabled" %>>
          </td>
          <td class="td04">
            <input type="text" name="actbetrg<%= i %>" value="<%= data.ACT_BETRG.equals("0.0")  ? "" : WebUtil.printNumFormat(data.ACT_BETRG) %>" size="12" class="<%= data.AUTO_BETRG.equals("0.0")  ? "input03" : "input04" %>" onKeyUp="javascript:moneyChkEventForWon(this);" style="text-align:right" onFocus="this.select()" <%= data.AUTO_BETRG.equals("0.0")  ? "" : "disabled" %>>
          </td>
<%
        } else {
%>
          <td class="td04"><%= data.STEXT %></td>
          <td class="td04"><%= data.ENAME %></td>
          <td class="td04"><%= data.FASAR %></td>
          <td class="td04" style="text-align:right"><%= data.ADD_BETRG.equals("0.0")  ? "&nbsp;" : WebUtil.printNumFormat(data.ADD_BETRG)  %>&nbsp;</td>
          <td class="td04" style="text-align:right"><%= data.ACT_BETRG.equals("0.0")  ? "&nbsp;" : WebUtil.printNumFormat(data.ACT_BETRG)  %>&nbsp;</td>
<%
        }
%>
          <td class="td04" style="text-align:right"><%= data.AUTO_BETRG.equals("0.0")  ? "&nbsp;" : WebUtil.printNumFormat(data.AUTO_BETRG) %>&nbsp;</td>
          <td class="td04" style="text-align:left">&nbsp;<%= data.AUTO_TEXT %></td>
          <td class="td04"><!--@2011 교복구입비 -->
            <input type="checkbox" name="EXSTY<%=i%>" value="<%=  data.EXSTY.equals("") ? "" : data.EXSTY %>" <%= data.EXSTY.equals("X")  ? "checked" : "" %> class="<%= data.AUTO_BETRG.equals("0.0")  ? "input03" : "input04" %>" <%= data.AUTO_BETRG.equals("0.0")  ? "" : "disabled" %>>
          </td>
          <td class="td04"><!--@v1.5-->
            <input type="checkbox" name="CHNTS<%=i%>" value="<%=  data.CHNTS.equals("") ? "" : data.CHNTS %>" <%= data.CHNTS.equals("X")  ? "checked" : "" %> class="<%= data.AUTO_BETRG.equals("0.0")  ? "input03" : "input04" %>" <%= data.AUTO_BETRG.equals("0.0")  ? "" : "disabled" %>>
          </td>
          <td class="td04">
            <input type="checkbox" name="OMIT_FLAG<%=i%>" value="<%=  data.OMIT_FLAG.equals("") ? "" : data.OMIT_FLAG %>" <%= data.OMIT_FLAG.equals("X")  ? "checked" : "" %> class="input03"  <%= data.AUTO_BETRG.equals("0.0")  ? "disabled" : "" %>>
          </td>
        </tr>
<%
    }
%>
      </table>
      <!--특별공제 테이블 끝-->
    </td>
  </tr>
    <tr>
      <td height="8"></td>
    </tr>
    <tr>
      <td class="td02" style="text-align:left"><font color=blue><spring:message code="LABEL.D.D11.0079" /><!-- *주의사항* --></font></td>
    </tr>
    <tr>
      <td class="td02" style="text-align:left"><font color=green><spring:message code="LABEL.D.D11.0116" /><!-- 1. 교육비(장/학자금) 中 회사지원분은 전산 자동반영 됨 --></font></td>
    </tr>
    <tr>
      <td class="td02" style="text-align:left"><font color=green>&nbsp;&nbsp;&nbsp;<spring:message code="LABEL.D.D11.0117" /><!-- -. 연말정산 간소화 서비스의 교육비 지출액에 자동반영 회사지원분이 포함되어 있을시에는 회사지원분을 차감하고 입력 --></font></td>
    </tr>
    <tr>
      <td class="td02" style="text-align:left"><font color=green>&nbsp;&nbsp;&nbsp;<spring:message code="LABEL.D.D11.0118" /><!-- -. 자동반영된 회사지원액을 제외하고자 하는 경우에는 제외하고자 하는 해당항목의 "연말정산삭제" 체크박스에 체크 후 저장 --></font></td>
    </tr>
  <tr>
    <td>&nbsp;</td>
  </tr>
<%
    //if( appl_from <= 0 && appl_toxx >= 0 && !o_flag.equals("X") ) {
    if(  !o_flag.equals("X") ) {
%>
  <tr>
    <td>
      <table width="780" border="0" cellspacing="1" cellpadding="0">
        <tr>
          <td align="center">
            <a href="javascript:do_build();">
            <img src="<%= WebUtil.ImageURL %>btn_input02.gif" border="0" align="absmiddle"></a>
          </td>
        </tr>
      </table>
    </td>
  </tr>
<%
    }
%>
</table>
<!-- 숨겨진 필드 -->
<input type="hidden" name="jobid"      value="">
<input type="hidden" name="targetYear" value="<%= targetYear %>">
<input type="hidden" name="rowCount"   value="<%= edu_vt.size() %>">
<%
    for( int i = 0 ; i < edu_vt.size() ; i++ ){
        D11TaxAdjustDeductData data = (D11TaxAdjustDeductData)edu_vt.get(i);
%>
    <input type="hidden" name="GUBN_CODE<%= i %>"  value="<%= data.GUBN_CODE  %>">
    <input type="hidden" name="GOJE_CODE<%= i %>"  value="<%= data.GOJE_CODE  %>">
    <input type="hidden" name="GUBN_TEXT<%= i %>"  value="<%= data.GUBN_TEXT  %>">
    <input type="hidden" name="SUBTY<%= i %>"      value="<%= data.SUBTY      %>">
    <input type="hidden" name="STEXT<%= i %>"      value="<%= data.STEXT      %>">
    <input type="hidden" name="ENAME<%= i %>"      value="<%= data.ENAME      %>">
    <input type="hidden" name="REGNO<%= i %>"      value="<%= data.REGNO      %>">
    <input type="hidden" name="FASAR<%= i %>"      value="<%= data.FASAR      %>">
    <input type="hidden" name="ADD_BETRG<%= i %>"  value="<%= data.ADD_BETRG  %>">
    <input type="hidden" name="ACT_BETRG<%= i %>"  value="<%= data.ACT_BETRG  %>">
    <input type="hidden" name="AUTO_BETRG<%= i %>" value="<%= data.AUTO_BETRG %>">
    <input type="hidden" name="AUTO_TEXT<%= i %>"  value="<%= data.AUTO_TEXT  %>">
    <input type="hidden" name="GOJE_FLAG<%= i %>"  value="<%= data.GOJE_FLAG  %>">
    <input type="hidden" name="FTEXT<%= i %>"      value="<%= data.FTEXT      %>">
    <input type="hidden" name="FLAG<%= i %>"       value="<%= data.FLAG       %>">
<%
    }
%>
<!-- 숨겨진 필드 -->
</form>
<%@ include file="/web/common/commonEnd.jsp" %>
