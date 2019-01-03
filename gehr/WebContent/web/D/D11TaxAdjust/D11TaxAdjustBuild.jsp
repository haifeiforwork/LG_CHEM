<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.D.*" %>
<%@ page import="hris.D.rfc.*" %>
<%@ page import="hris.D.D11TaxAdjust.*" %>
<%@ page import="hris.A.A12Family.rfc.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%
    D00TaxAdjustPeriodRFC  periodRFC           = new D00TaxAdjustPeriodRFC();
    D00TaxAdjustPeriodData taxAdjustPeriodData = new D00TaxAdjustPeriodData();
    taxAdjustPeriodData = (D00TaxAdjustPeriodData)periodRFC.getPeriod(((WebUserData)session.getAttribute("user")).companyCode,((WebUserData)session.getAttribute("user")).empNo);

    String targetYear     = (String)request.getAttribute("targetYear"    );
    Vector personalRed_vt = (Vector)request.getAttribute("personalRed_vt");
    Vector specialRed_vt  = (Vector)request.getAttribute("specialRed_vt" );
    Vector etcRed_vt      = (Vector)request.getAttribute("etcRed_vt"     );

    for( int i = 0 ; i < personalRed_vt.size() ; i++ ){
        D11TaxAdjustData data = (D11TaxAdjustData)personalRed_vt.get(i);

        data.REGNO    =(data.REGNO.equals("")       ?"":DataUtil.addSeparate(data.REGNO)        );// 주민등록번호
        data.BASIC_RED=(data.BASIC_RED.equals("0.0")?"":WebUtil.printNumFormat(data.BASIC_RED,0));// 기본공제
        data.OLD_RED  =(data.OLD_RED.equals("0.0")  ?"":WebUtil.printNumFormat(data.OLD_RED  ,0));// 경로우대
        data.HANDY_RED=(data.HANDY_RED.equals("0.0")?"":WebUtil.printNumFormat(data.HANDY_RED,0));// 장애자
        data.WOMEN_RED=(data.WOMEN_RED.equals("0.0")?"":WebUtil.printNumFormat(data.WOMEN_RED,0));// 부녀자
        data.CHILD_RED=(data.CHILD_RED.equals("0.0")?"":WebUtil.printNumFormat(data.CHILD_RED,0));// 자녀양육비
    }
    for( int i = 0 ; i < specialRed_vt.size() ; i++ ){
        D11TaxAdjustData data = (D11TaxAdjustData)specialRed_vt.get(i);

        data.REGNO   =( data.REGNO.equals("")      ?"":DataUtil.addSeparate(data.REGNO)       );// 주민등록번호
        data.ADD_AMT =( data.ADD_AMT.equals("0.0") ?"":WebUtil.printNumFormat(data.ADD_AMT ,0));// 개인추가분
        data.AUTO_AMT=( data.AUTO_AMT.equals("0.0")?"":WebUtil.printNumFormat(data.AUTO_AMT,0));// 자동반영분
    }
    for( int i = 0 ; i < etcRed_vt.size() ; i++ ){
        D11TaxAdjustData data = (D11TaxAdjustData)etcRed_vt.get(i);

        data.REGNO   =( data.REGNO.equals("")      ?"":DataUtil.addSeparate(data.REGNO)       );// 주민등록번호
        data.ADD_AMT =( data.ADD_AMT.equals("0.0") ?"":WebUtil.printNumFormat(data.ADD_AMT ,0));// 개인추가분
        data.AUTO_AMT=( data.AUTO_AMT.equals("0.0")?"":WebUtil.printNumFormat(data.AUTO_AMT,0));// 자동반영분
    }
    String spaceArea = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
%>

<jsp:include page="/include/header.jsp" />
<SCRIPT LANGUAGE="JavaScript">
<!--
/****** 원화일때 포멧 체크 : onKeyUp="javascript:moneyChkEventForWon(this);" *******/
function moneyChkEventForWon(obj){
    val = obj.value;
    if( unusableFirstChar(obj,'0,') && usableChar(obj,'0123456789,') ){
        addComma(obj);
    }
    /*  onKeyUp="addComma(this)" onBlur="javascript:unusableChar(this,'.');"  */
}
/**************************************************************** 문의 :  김성일 ****/

function do_build(){
    if( check_data() ){

        document.form1.jobid.value = "build";
        document.form1.action = "<%= WebUtil.ServletURL %>hris.D.D11TaxAdjust.D11TaxAdjustSV";
        document.form1.method = "post";
        document.form1.target = "menuContentIframe";
        document.form1.submit();
    }
}

function check_data(){

    // 특별공제중 교육비일때, 자동공제액과 추가공제액이 있다면 학력도 선택되어야한다
    for( inx = 13 ; inx <= <%=specialRed_vt.size()%> ; inx++ ){
        auto_amt = eval("document.form1.AUTO_AMT_"+inx+".value");
        add_amt  = eval("document.form1.ADD_AMT_"+inx+".value");
        fasar    = eval("document.form1.FASAR_"+inx+"[document.form1.FASAR_"+inx+".selectedIndex].value");
        if( (auto_amt != "" || add_amt != "") && fasar == "" ){
            alert("<spring:message code='MSG.D.D11.0001' />"); //교육비 수혜 대상자의 학력을 선택해주세요.
            eval("document.form1.FASAR_"+inx+".focus();");
          //eval("document.form1.FASAR_"+inx+".select();");
            return false;
        }
        if( inx != 13 ){
            rela   = eval("document.form1.RELA_"+inx+".value");
            i_name = eval("document.form1.NAME_"+inx+".value");
            regno  = eval("document.form1.REGNO_"+inx+".value");
            if( auto_amt != "" || add_amt != "" ){
                if( fasar == "" ){
                    alert("<spring:message code='MSG.D.D11.0001' />"); //교육비 수혜 대상자의 학력을 선택해주세요.
                    eval("document.form1.FASAR_"+inx+".focus();");
                  //eval("document.form1.FASAR_"+inx+".select();");
                    return false;
                }else if( rela == "" ){
                    alert("<spring:message code='MSG.D.D11.0002' />");//교육비 수혜 대상자의 관계를 선택해주세요.
                    eval("document.form1.RELA_"+inx+".focus();");
                    return false;
                }else if( i_name == "" ){
                    alert("<spring:message code='MSG.D.D11.0003' />"); //교육비 수혜 대상자의 성명을 선택해주세요.
                    eval("document.form1.NAME_"+inx+".focus();");
                    return false;
                }else if( regno == "" ){
                    alert("<spring:message code='MSG.D.D11.0004' />"); //교육비 수혜 대상자의 주민등록번호를 선택해주세요.
                    eval("document.form1.REGNO_"+inx+".focus();");
                    return false;
                }
            }
        }
    }
    // 모든 필드에 ","&"-" 콤마, 바 제거
    for ( j = 0 ; j < document.form1.elements.length ; j++ ){
        document.form1.elements[j].value = removeComma(document.form1.elements[j].value);
        document.form1.elements[j].value = removeResBar(document.form1.elements[j].value);
    }
    return true;
}
//-->
</SCRIPT>

 <jsp:include page="/include/body-header.jsp">
        <jsp:param name="click" value="Y"/>
 </jsp:include>

<form name="form1">
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td width="15">&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td width="15">&nbsp; </td>
      <td>
      <!--타이틀 테이블 시작-->
        <table width="" border="0" cellspacing="0" cellpadding="0">

          <tr>
            <td class="title"><h1><spring:message code="LABEL.D.D11.0001" /><!-- 연말정산공제신청 입력 --></h1></td>
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
      <td width="15">&nbsp;</td>
      <td class="font01"><spring:message code="LABEL.D.D11.0002" /><!-- 연도 --> : <%= targetYear %> &nbsp;&nbsp;&nbsp;<spring:message code="LABEL.D.D11.0003" /><!-- 신청기간 --> : <%= WebUtil.printDate(DataUtil.removeStructur(taxAdjustPeriodData.APPL_FROM,"-")) %> ~ <%= WebUtil.printDate(DataUtil.removeStructur(taxAdjustPeriodData.APPL_TOXX,"-")) %></td>
    </tr>
    <tr>
      <td width="15">&nbsp;</td>
      <td>
        <!--개인정보 테이블 시작-->
        <table width="790" border="0" cellspacing="1" cellpadding="2" class="table01" bordercolor="#999999">
          <tr>
            <td class="td01" rowspan="2" width="60"><spring:message code="LABEL.D.D11.0004" /><!-- 소득자 --></td>
            <td class="td01" width="50"><spring:message code="LABEL.D.D11.0005" /><!-- 성명 --></td>
            <td class="td02" width="199">&nbsp;&nbsp;<%= ((WebUserData)session.getAttribute("user")).ename %>&nbsp;</td>
            <td class="td01" width="90"><spring:message code="LABEL.D.D11.0006" /><!-- 주민등록번호 --></td>
            <td class="td02" width="199">&nbsp;&nbsp;<%= DataUtil.addSeparate(((WebUserData)session.getAttribute("user")).e_regno) %>&nbsp;</td>
          </tr>
          <tr>
            <td class="td01"><spring:message code="LABEL.D.D11.0007" /><!-- 주소 --></td>
            <td class="td02" colspan="3">&nbsp;&nbsp;<%= ((WebUserData)session.getAttribute("user")).e_stras %>&nbsp;<%= ((WebUserData)session.getAttribute("user")).e_locat %></td>
          </tr>
        </table>
        <!--개인정보 테이블 끝-->
      </td>
    </tr>
    <tr>
      <td width="15">&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td width="15">&nbsp;</td>
      <td class="font01"><font color="#6699FF">■</font> <spring:message code="LABEL.D.D11.0008" /><!-- 인적공제 --></td>
    </tr>
    <tr>
      <td width="15">&nbsp; </td>
      <td>
        <!--인적공제 테이블 시작-->
        <table width="790" border="0" cellspacing="1" cellpadding="2" class="table02" bordercolor="#999999">
          <tr>
            <td class="td03" width="50"><spring:message code="LABEL.D.D11.0009" /><!-- 관계 --></td>
            <td class="td03" width="63"><spring:message code="LABEL.D.D11.0005" /><!-- 성명 --></td>
            <td class="td03" width="110"><spring:message code="LABEL.D.D11.0010" /><!-- 주민번호 --></td>
            <td class="td03" width="72"><spring:message code="LABEL.D.D11.0015" /><!-- 기본공제 --></td>
            <td class="td03" width="72"><spring:message code="LABEL.D.D11.0011" /><!-- 경로우대 --></td>
            <td class="td03" width="72"><spring:message code="LABEL.D.D11.0012" /><!-- 장애자 --></td>
            <td class="td03" width="72"><spring:message code="LABEL.D.D11.0013" /><!-- 부녀자 --></td>
            <td class="td03" width="72"><spring:message code="LABEL.D.D11.0014" /><!-- 자녀양육비 --></td>
          </tr>
<%
        for( int i = 0 ; i < personalRed_vt.size() ; i++ ){
          D11TaxAdjustData d11TaxAdjustData = (D11TaxAdjustData)personalRed_vt.get(i);
%>
          <tr>
            <td class="td04">&nbsp;<%= d11TaxAdjustData.RELA.trim() %></td>
            <td class="td04"><%= d11TaxAdjustData.ENAME.trim() %>&nbsp;</td>
            <td class="td04"><%= d11TaxAdjustData.REGNO.trim() %>&nbsp;</td>
            <td class="td04" style="text-align:right"><%= d11TaxAdjustData.BASIC_RED.trim() %>&nbsp;</td>
            <td class="td04" style="text-align:right"><%= d11TaxAdjustData.OLD_RED.trim()   %>&nbsp;</td>
            <td class="td04" style="text-align:right"><%= d11TaxAdjustData.HANDY_RED.trim() %>&nbsp;</td>
            <td class="td04" style="text-align:right"><%= d11TaxAdjustData.WOMEN_RED.trim() %>&nbsp;</td>
            <td class="td04" style="text-align:right"><%= d11TaxAdjustData.CHILD_RED.trim() %>&nbsp;</td>
          </tr>
<%    }%>
        </table>
        <!--인적공제 테이블 끝-->
      </td>
    </tr>
    <tr>
      <td width="15">&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td width="15">&nbsp;</td>
      <td class="font01"><font color="#6699FF">■</font> <spring:message code="LABEL.D.D11.0016" /><!-- 특별공제 --></td>
    </tr>
    <tr>
      <td width="15">&nbsp;</td>
      <td>
        <!--특별공제 테이블 시작-->
        <table width="790" border="0" cellspacing="1" cellpadding="2" class="table02" bordercolor="#999999">
          <tr>
            <td class="td03" width="140"><spring:message code="LABEL.D.D11.0017" /><!-- 구분 --></td>
            <td class="td03" width="55" ><spring:message code="LABEL.D.D11.0009" /><!-- 관계 --></td>
            <td class="td03" width="70" ><spring:message code="LABEL.D.D11.0005" /><!-- 성명 --></td>
            <td class="td03" width="120"><spring:message code="LABEL.D.D11.0010" /><!-- 주민번호 --></td>
            <td class="td03" width="110"><spring:message code="LABEL.D.D11.0018" /><!-- 학력 --></td>
            <td class="td03" width="90" ><spring:message code="LABEL.D.D11.0019" /><!-- 개인추가 --></td>
            <td class="td03" width="95" ><spring:message code="LABEL.D.D11.0020" /><!-- 자동반영분금액 --></td>
            <td class="td03" width="110"><spring:message code="LABEL.D.D11.0021" /><!-- 자동반영분내용 --></td>
          </tr>
<%
        for( int i = 0 ; i < specialRed_vt.size() ; i++ ){
          D11TaxAdjustData d11TaxAdjustData = (D11TaxAdjustData)specialRed_vt.get(i);
          String inx = Integer.toString(i+1);
%>
          <tr>
            <td class="td04" style="text-align:left"><%=d11TaxAdjustData.GUBUN.trim().substring(0,1).equals("(") ? spaceArea : "" %><%=d11TaxAdjustData.GUBUN.trim().substring(0,1).equals("부") ? spaceArea : "" %><%= WebUtil.printString(d11TaxAdjustData.GUBUN.trim())%></td>
<%
          if( d11TaxAdjustData.GUBUN.trim().equals("건강보험") || d11TaxAdjustData.GUBUN.trim().equals("고용보험") || d11TaxAdjustData.GUBUN.trim().equals("교육비 본인") ){
%>
            <td class="td04" style="text-align:center"><%= d11TaxAdjustData.RELA.trim() %>&nbsp;</td>
            <td class="td04" style="text-align:center"><%= d11TaxAdjustData.ENAME.trim() %>&nbsp;</td>
            <td class="td04" style="text-align:center"><%= d11TaxAdjustData.REGNO.trim() %>&nbsp;</td>
<%
                if( d11TaxAdjustData.GUBUN.trim().equals("교육비 본인") ){
%>
            <td class="td04" style="text-align:center">
              <select name="FASAR_<%=DataUtil.fixEndZero(inx,2)%>">
                <option value="">----------</option>
                <%= WebUtil.printOption((new A12FamilyScholarshipRFC()).getFamilyScholarship(), d11TaxAdjustData.FASAR) %>
              </select></td>
            <td class="td04">
              <input type="text" name="ADD_AMT_<%=DataUtil.fixEndZero(inx,2)%>" value="<%= d11TaxAdjustData.ADD_AMT.trim() %>" onKeyUp="javascript:moneyChkEventForWon(this);" style="text-align:right" class="input03" size="10" maxlength="11"></td>
<%
                }else{
%>
            <td class="td04" style="text-align:center">&nbsp;</td>
            <td class="td04" style="text-align:right"><%= d11TaxAdjustData.ADD_AMT.trim() %>&nbsp;</td>
<%
                }
          }else{
%>
            <td class="td04">
              <input type="text" name="RELA_<%=DataUtil.fixEndZero(inx,2)%>" value="<%= d11TaxAdjustData.RELA.trim() %>" class="input03" maxlength="12" size="6" style="text-align:center"></td>
            <td class="td04">
              <input type="text" name="NAME_<%=DataUtil.fixEndZero(inx,2)%>" value="<%= d11TaxAdjustData.ENAME.trim() %>" class="input03" maxlength="10" size="6" style="text-align:center"></td>
            <td class="td04">
              <input type="text" name="REGNO_<%=DataUtil.fixEndZero(inx,2)%>" value="<%= d11TaxAdjustData.REGNO.trim() %>" onBlur="javascript:chkResnoObj(this);" class="input03" maxlength="14" size="14"></td>
<%
                if( d11TaxAdjustData.GUBUN.trim().substring(0,4).equals("부양가족") ){
%>
            <td class="td04">
              <select name="FASAR_<%=DataUtil.fixEndZero(inx,2)%>">
                <option value="">----------</option>
                <%= WebUtil.printOption((new A12FamilyScholarshipRFC()).getFamilyScholarship(), d11TaxAdjustData.FASAR) %>
              </select>
            </td>
<%
                }else{
%>
            <td class="td04" style="text-align:center">&nbsp;</td>
<%              }%>
            <td class="td04">
              <input type="text" name="ADD_AMT_<%=DataUtil.fixEndZero(inx,2)%>" onKeyUp="javascript:moneyChkEventForWon(this);" value="<%= d11TaxAdjustData.ADD_AMT.trim() %>" maxlength="13" style="text-align:right" class="input03" size="10" maxlength="11"></td>
<%        }         %>
            <td class="td04" style="text-align:right"><%= d11TaxAdjustData.AUTO_AMT.trim() %>&nbsp;</td>
              <input type="hidden" name="AUTO_AMT_<%=DataUtil.fixEndZero(inx,2)%>" value="<%= d11TaxAdjustData.AUTO_AMT.trim() %>">
            <td class="td04"><%= d11TaxAdjustData.AUTO_AMT.equals("")? "" : d11TaxAdjustData.AUTO_TEXT.trim() %>&nbsp;</td>
          </tr>
<%    }%>
        </table>
        <!--특별공제 테이블 끝-->
      </td>
    </tr>
    <tr>
      <td width="15">&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td width="15">&nbsp;</td>
      <td class="font01"><font color="#6699FF">■</font> <spring:message code="LABEL.D.D11.0022" /><!-- 기타/세액공제 --></td>
    </tr>
    <tr>
      <td width="15">&nbsp;</td>
      <td>
        <!--기타/세액공제 테이블 시작-->
        <table width="790" border="0" cellspacing="1" cellpadding="2" class="table02" bordercolor="#999999">
          <tr>
            <td class="td03" width="200"><spring:message code="LABEL.D.D11.0017" /><!-- 구분 --></td>
            <td class="td03" width="55" ><spring:message code="LABEL.D.D11.0009" /><!-- 관계 --></td>
            <td class="td03" width="70" ><spring:message code="LABEL.D.D11.0005" /><!-- 성명 --></td>
            <td class="td03" width="120"><spring:message code="LABEL.D.D11.0010" /><!-- 주민번호 --></td>
            <td class="td03" width="90" ><spring:message code="LABEL.D.D11.0019" /><!-- 개인추가 --></td>
            <td class="td03" width="95" ><spring:message code="LABEL.D.D11.0020" /><!-- 자동반영분금액 --></td>
            <td class="td03" width="160"><spring:message code="LABEL.D.D11.0021" /><!-- 자동반영분내용 --></td>
          </tr>
<%
        for( int i = 0 ; i < etcRed_vt.size() ; i++ ){
          D11TaxAdjustData d11TaxAdjustData = (D11TaxAdjustData)etcRed_vt.get(i);
          String inx = Integer.toString(i+1);
%>
          <tr>
            <td class="td04" style="text-align:left"><%=d11TaxAdjustData.GUBUN.trim().substring(0,1).equals("(") ? spaceArea : "" %><%=d11TaxAdjustData.GUBUN.trim().substring(0,1).equals("부") ? spaceArea : "" %><%= WebUtil.printString(d11TaxAdjustData.GUBUN.trim())%></td>
            <td class="td04" style="text-align:center"><%= d11TaxAdjustData.RELA.trim() %>&nbsp;</td>
            <td class="td04" style="text-align:center"><%= d11TaxAdjustData.ENAME.trim() %>&nbsp;</td>
            <td class="td04" style="text-align:center"><%= d11TaxAdjustData.REGNO.trim() %>&nbsp;</td>
<%
          if(  d11TaxAdjustData.GUBUN.trim().equals("(국민연금)") ||
               d11TaxAdjustData.GUBUN.trim().equals("(해외원천소득)") ||
               d11TaxAdjustData.GUBUN.trim().equals("(외국납부세[당년])") ||
               d11TaxAdjustData.GUBUN.trim().equals("(외국납부세[이월분])") ){
%>
            <td class="td04" style="text-align:right"><%= d11TaxAdjustData.ADD_AMT.trim() %>&nbsp;</td>
            <input type="hidden" name="ADD_AMT_<%=DataUtil.fixEndZero(inx,2)%>_ETC" value="<%= d11TaxAdjustData.ADD_AMT.trim() %>">
<%
          } else {
%>
            <td class="td04">
              <input type="text" name="ADD_AMT_<%=DataUtil.fixEndZero(inx,2)%>_ETC" value="<%= d11TaxAdjustData.ADD_AMT.trim() %>" onKeyUp="javascript:moneyChkEventForWon(this);" maxlength="13" style="text-align:right" class="input03" size="10" maxlength="11"></td>
<%        }         %>
            <td class="td04" style="text-align:right"><%= d11TaxAdjustData.AUTO_AMT.trim() %>&nbsp;</td>
            <td class="td04"><%= d11TaxAdjustData.AUTO_AMT.equals("")? "" : d11TaxAdjustData.AUTO_TEXT.trim() %>&nbsp;</td>
          </tr>
<%    }%>
        </table>
        <!--기타/세액공제 테이블 끝-->
      </td>
    </tr>
    <tr>
      <td width="15">&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td width="15">&nbsp;</td>
      <td>
        <table width="790" border="0" cellspacing="1" cellpadding="0">
          <tr>
            <td align="center">
              <a href="javascript:do_build();">
              <img src="<%= WebUtil.ImageURL %>btn_input.gif" width="49" height="20" border="0" align="absmiddle"></a>
              <a href="javascript:history.back();">
              <img src="<%= WebUtil.ImageURL %>btn_prevview.gif" width="59" height="20" border="0" align="absmiddle"></a>
              <a href="<%= WebUtil.ServletURL %>hris.A.A13Address.A13AddressListSV">
              <img src="<%= WebUtil.ImageURL %>btn_addrCh.gif" width="74" height="20" align="absmiddle" border="0"></a>
              <a href="<%= WebUtil.ServletURL %>hris.A.A12Family.A12FamilyBuildSV">
              <img src="<%= WebUtil.ImageURL %>btn_Family.gif" width="93" height="20" align="absmiddle" border="0"></a></td>
          </tr>
        </table>
      </td>
   </tr>
  </table>
<!-- 숨겨진 필드 -->
    <input type="hidden" name="jobid"      value="build">
    <input type="hidden" name="targetYear" value="<%=targetYear%>">
<!-- 숨겨진 필드 -->
</form>
     -->
<jsp:include page="/include/body-footer.jsp" /> <!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/>       <!-- html footer 부분 -->
