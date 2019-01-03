<%/******************************************************************************/
/*                                      */
/*   System Name  : MSS                             */
/*   1Depth Name  : 신청                          */
/*   2Depth Name  : 식대신청                            */
/*   Program Name : 식대신청                                    */
/*   Program ID   : E37Meal|E37MealBuild.jsp                            */
/*   Description  : 식대신청 화면                         */
/*   Note         :                                 */
/*   Creation     : 2009-11-26  LSA                     */
/*   Update       :                                                             */
/*                                      */
/********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ page import="java.util.Vector" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="hris.E.E37Meal.*" %>
<%@ page import="hris.E.E37Meal.rfc.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="hris.common.WebUserData" %>
<%@ page import="com.sns.jdf.util.*" %>
<%
    String jobid      = (String)request.getAttribute("jobid");
    String e_rtn = WebUtil.nvl((String)request.getAttribute("E_RETURN"));
    String e_msg = WebUtil.nvl((String)request.getAttribute("E_MESSAGE"));
    String I_APLY_FLAG = WebUtil.nvl((String)request.getAttribute("I_APLY_FLAG"));
    Vector      AppLineData_vt     = (Vector)request.getAttribute("AppLineData_vt");

    Vector meal_vt    = (Vector)request.getAttribute("meal_vt");
    Vector mealAppr_vt    = (Vector)request.getAttribute("mealAppr_vt");
    String deptId = WebUtil.nvl((String)request.getAttribute("hdn_deptId"));
    String deptNm = WebUtil.nvl((String)request.getAttribute("hdn_deptNm"));
    String t_month = WebUtil.nvl((String)request.getAttribute("t_month"));
    String t_year = WebUtil.nvl((String)request.getAttribute("t_year"));

    WebUserData user = WebUtil.getSessionUser(request);
    if(deptId == null || deptId.equals("")){
        deptId = user.e_orgeh;
    }
    int  main_count = meal_vt.size();


%>
<html>
<head>
<title>ESS</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr.css" type="text/css">
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr_style.css" type="text/css">
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr_wsg.css" type="text/css">

<script language="javascript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>
<script language="JavaScript">
function init(){
    <% if (e_rtn != null && e_rtn.equals("I")) {%>
        alert('<%= e_msg %>');
            return;

    <% } // end if %>
}

function handleError (err, url, line) {
   alert('오류 : '+err + '\nURL : ' + url + '\n줄 : '+line);
   return true;
}

function EnterCheck(){
    if (event.keyCode == 13)  {
        pop_search();
    }
}
function pop_search(){
        dept_search();
}

// 부서 검색
function dept_search()
{
    var frm = document.form1;
    document.form1.txt_deptNm.value = document.form1.txt_searchNm.value;

    if (  frm.txt_searchNm.value == "" ) {
        alert("검색할 부서명을 입력하세요!")
        frm.txt_searchNm.focus();
        return;
    }

    small_window=window.open("","DeptNm","toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=no,scrollbars=no,width=320,height=420,left=100,top=100");
    small_window.focus();

    var oldTarget = frm.target;
    var oldAction = frm.action;

    frm.target = "DeptNm";

    frm.action = "/web/D/D12Rotation/SearchDeptNamePop_Rot.jsp";
    frm.submit();
    frm.target = oldTarget;
        frm.action = oldAction;

}

//조회에 의한 부서ID와 그에 따른 조회.
function setDeptID(deptId, deptNm){
    frm = document.form1;
    frm.hdn_deptId.value = deptId;
    frm.txt_searchNm.value = deptNm;
    frm.hdn_deptNm.value = deptNm;
    frm.hdn_excel.value = "";
    document.form1.I_SEARCHDATA.value = deptId;
    frm.action = "<%= WebUtil.ServletURL %>hris.E.E37Meal.E37MealDetailSV";
    frm.target = "_self";
    frm.submit();
}
 /* 신청 */
function goBuild() {
    document.form1.jobid.value = "";
    document.form1.action = "<%= WebUtil.ServletURL %>hris.E.E37Meal.E37MealBuildSV";
    document.form1.method = "post";
    document.form1.target = "menuContentIframe";
    document.form1.submit();
}
function isNumber2(obj, index) {
    Digit = "0123456789.";
    if( fCheckDigit(obj, Digit) == false) {
        alert("교육은 숫자만 사용 가능합니다.");
        obj.focus();
        obj.select();
        return false;
    } else {
      disableType('3', index);
      return true;
    }
}
function f_search() {
          document.form1.jobid.value = "";
          document.form1.action = "<%= WebUtil.ServletURL %>hris.E.E37Meal.E37MealDetailSV";
      document.form1.method        = "post";
          document.form1.target = "menuContentIframe";
      document.form1.submit();
}
 /* 신청 */
function doDelete() {
<%
    if( meal_vt.size() == 0 ) {
%>
    alert('작업할 DATA가 존재하지 않습니다.');
<%
    } else {
%>
        if ( confirm("선택한 신청Data를 삭제하시겠습니까?")) {
             var count=0;
         for( index = 0 ; index < <%= meal_vt.size() %> ; index++ ) {
             if (eval("document.form1.SEL_GUBN" + index + ".checked")==true){
                 eval("document.form1.use_flag" + index+".value='Y'");
                 count++;
             }else
                 eval("document.form1.use_flag" + index+".value='N'");
         }
         if (count> 0){
             buttonDisabled();
             document.form1.jobid.value = "delete";
             document.form1.action = "<%= WebUtil.ServletURL %>hris.E.E37Meal.E37MealDetailSV";
             document.form1.method = "post";
                 document.form1.target = "menuContentIframe";
             document.form1.submit();
         }else{
             alert('삭제할 DATA를 선택하세요.');
             return;
         }

    }
<%
    }
%>
}

function allSetValue(value)
{
       frm  = document.form1;
       var i = 0;
       for (i = 0 ; i < parseInt(frm.RowCount_meal.value ,10) ; i ++ ) {
            if ( eval("frm.POST_DATE" +i+".value") == "0000-00-00") {
               Obj = eval("frm.SEL_GUBN" +i);
               Obj.checked = value;
            }
       } // end for
}
</script>

</head>
<body  leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="javascript:init();">
<!--  HIDDEN  처리해야할 부분 끝-->
<form name="form1" method="post" onsubmit="return false">
<input type="hidden" name="hdn_isPop"   value="<%=WebUtil.nvl(request.getParameter("hdn_isPop"))%>">
<input type="hidden" name="hdn_gubun"   value="">
<input type="hidden" name="hdn_deptId"  value="<%=deptId%>">
<input type="hidden" name="hdn_deptNm"  value="<%=deptNm%>">
<input type="hidden" name="hdn_excel"   value="">
<input type="hidden" name="I_SEARCHDATA"  value="">
<input type="hidden" name="retir_chk"  value="">
<input type="hidden" name="I_GUBUN"  value="2">
<input type="hidden" name="I_GBN"  value="ORGEH">
<input type="hidden" name="I_VALUE1"  value="">
<input type="hidden" name="txt_deptNm"  value="">

<input type="hidden" name="authClsf"  value="S">

<div class="subWrapper">

    <div class="title"><h1>식대 신청</h1></div>

    <!--   부서검색 보여주는 부분 시작   -->

    <div class="tableInquiry">
        <table>
            <tr>
                <th>부서명</th>
                <td>
                    <input type="text" name="txt_searchNm" value="<%=deptNm%>" size="25" maxlength="30" value="" onKeyDown="javascript:EnterCheck();" style="ime-mode:active" >
                    <div class="tableBtnSearch tableBtnSearch2">
                        <a href="javascript:pop_search();" class="search"><span>조회</span></a>
                    </div>
                </td>
            </tr>
        </table>
    </div>

<% if ( e_rtn.equals("W") ) {  //해당 조직은 hr서비스팀에서 일괄 신청 대상 조직입니다. 확인해 보시기 바랍니다. %>

    <span class="commentOne"><%=e_msg%></span>

<% }else {%>

    <div class="buttonArea">
        <ul class="btn_crud">
            <li><a href="javascript:doDelete();"><span>삭제</span></a></li>
        </ul>
    </div>

    <div class="tableArea">
        <div class="table">
          <table class="tableGeneral tableApproval">
            <tr>
              <th>신청년월</th>
              <td>
                  <select name="t_year">
                    <option value="<%=DateTime.getYear() %>" <%= Integer.parseInt(t_year) ==DateTime.getYear() ? "selected":"" %>><%=DateTime.getYear() %></option>
                    <option value="<%=DateTime.getYear()+1 %>" <%=Integer.parseInt(t_year) ==(DateTime.getYear()+1)? "selected":"" %>><%=DateTime.getYear()+1 %></option>
                  </select> 년
                  <select name="t_month">
                    <option value="01" <%=t_month.equals("01")? "selected":"" %>>01</option>
                    <option value="02" <%=t_month.equals("02")? "selected":"" %>>02</option>
                    <option value="03" <%=t_month.equals("03")? "selected":"" %>>03</option>
                    <option value="04" <%=t_month.equals("04")? "selected":"" %>>04</option>
                    <option value="05" <%=t_month.equals("05")? "selected":"" %>>05</option>
                    <option value="06" <%=t_month.equals("06")? "selected":"" %>>06</option>
                    <option value="07" <%=t_month.equals("07")? "selected":"" %>>07</option>
                    <option value="08" <%=t_month.equals("08")? "selected":"" %>>08</option>
                    <option value="09" <%=t_month.equals("09")? "selected":"" %>>09</option>
                    <option value="10" <%=t_month.equals("10")? "selected":"" %>>10</option>
                    <option value="11" <%=t_month.equals("11")? "selected":"" %>>11</option>
                    <option value="12" <%=t_month.equals("12")? "selected":"" %>>12</option>
                  </select> 월
                </td>
              <th>신청구분</th>
              <td>
                <input type="radio" name="I_APLY_FLAG" value="X" <%= I_APLY_FLAG.equals("X")||I_APLY_FLAG.equals("") ? "checked":""%>>정기
                <input type="radio" name="I_APLY_FLAG" value="" <%= I_APLY_FLAG.equals("") ? "checked":""%>>수시
              </td>
              <td>
                <a class="inlineBtn" href="javascript:f_search();"><span>조회</span></a>
                <a class="inlineBtn" href="javascript:goBuild();"><span>신규신청</span></a>
              </td>
            </tr>
          </table>
        </div>
    </div>

    <div class="listArea">
        <div class="table">
            <table class="listTable">
                <colgroup>
                    <col width="60">
                    <col width="100">
                    <col width="100">
                    <col width="100">
                    <col width="100">
                    <col width="100">
                    <col width="100">
                    <col width="100">
                </colgroup>
                <tr>
                    <th><input type="checkbox" onClick = "allSetValue(this.checked)" align="absmiddle" ></th>
                    <th>신청일자</th>
                    <th>사원번호</th>
                    <th>성명</th>
                    <th>현물지급일수</th>
                    <th>카드충전액</th>
                    <th>현금보상일수</th>
                    <th class="lastCol">현금보상액</th>
                </tr>


<%
    int ttl_tkct_cont = 0;
    double ttl_tkct_wonx = 0;
    int ttl_cash_cont = 0;
    double ttl_cash_wonx = 0;
    for( int i = 0 ; i < meal_vt.size() ; i++ ) {
        E37MealData data = (E37MealData)meal_vt.get(i);
        ttl_tkct_cont += Integer.parseInt(data.TKCT_CONT);
        ttl_tkct_wonx += Double.parseDouble(data.TKCT_WONX);
        ttl_cash_cont += Integer.parseInt(data.CASH_CONT);
        ttl_cash_wonx += Double.parseDouble(data.CASH_WONX);

        String tr_class = "";

        if(i%2 == 0){
            tr_class="oddRow";
        }else{
            tr_class="";
        }
%>
                <tr class="<%=tr_class%>">
                      <input type="hidden" name="use_flag<%=i%>"  value="Y" ><!--@v1.4-->
                      <td>
                        <input type="checkbox" name="SEL_GUBN<%=i%>" value="<%=i%>" <%= data.POST_DATE.equals("0000-00-00") ? "" : "disabled" %>>
                      </td>
                      <td><%= data.BEGDA.equals("0000-00-00") ? "" : WebUtil.printDate(data.BEGDA) %></td>
                      <td><%= data.PERNR %></td>
                      <td><%= data.ENAME %></td>
                      <td class="align_right"><%=WebUtil.printNumFormat(data.TKCT_CONT)%></td>
                      <td class="align_right"><%=WebUtil.printNumFormat(data.TKCT_WONX)%></td>
                      <td class="align_right"><%=WebUtil.printNumFormat(data.CASH_CONT)%></td>
                      <td class="lastCol align_right"><%=WebUtil.printNumFormat(data.CASH_WONX)%></td>

                      <input type="hidden" name="AINF_SEQN<%=i%>" value="<%= data.AINF_SEQN %>">
                      <input type="hidden" name="BEGDA<%=i%>"     value="<%= data.BEGDA %>">
                      <input type="hidden" name="PERNR<%=i%>"     value="<%= data.PERNR %>">
                      <input type="hidden" name="ENAME<%=i%>"     value="<%= data.ENAME %>">
                      <input type="hidden" name="TKCT_WONX<%=i%>" value="<%= data.TKCT_WONX %>">
                      <input type="hidden" name="CASH_WONX<%=i%>" value="<%= data.CASH_WONX %>">

                      <input type="hidden" name="BANKS<%=i%>"     value="<%= data.BANKS %>">
                      <input type="hidden" name="BANKL<%=i%>"     value="<%= data.BANKL %>">
                      <input type="hidden" name="BANKN<%=i%>"     value="<%= data.BANKN %>">
                      <input type="hidden" name="BKONT<%=i%>"     value="<%= data.BKONT %>">
                      <input type="hidden" name="BVTYP<%=i%>"     value="<%= data.BVTYP %>">

                      <input type="hidden" name="POST_DATE<%=i%>" value="<%= data.POST_DATE %>">
                      <input type="hidden" name="BELNR<%=i%>"     value="<%= data.BELNR %>">
                      <input type="hidden" name="ZPERNR<%=i%>"    value="<%= data.ZPERNR %>">
                      <input type="hidden" name="ZUNAME<%=i%>"    value="<%= data.ZUNAME %>">
                      <input type="hidden" name="BIGO_TXT<%=i%>"  value="<%= data.BIGO_TXT %>">
                      <input type="hidden" name="APLY_FLAG<%=i%>" value="<%= data.APLY_FLAG %>">

                </tr>
<input type="hidden" name="changeFlag<%= i %>" value="">

<%
    }

%>
            </table>
        </div>
        <span class="commentOne"><span class="textPink">*</span>는 필수 입력사항입니다.</span>
    </div>

<!-----ADD ROW ---------------------------------->
<!---- ADD ROW ---------------------------------->


    <div class="listArea">
        <div class="table">
            <table class="listTable">
                <tr>
                    <th class="divide"></th>
                    <th>현급지급일수</th>
                    <th>카드신청액</th>
                     <th>현금보상일수</th>
                     <th class="lastCol">현금보상액</th>
                </tr>
                <tr class="oddRow">
                    <td class="divide">합계</td>
                    <td><%=WebUtil.printNumFormat(ttl_tkct_cont)%></td>
                    <td><%=WebUtil.printNumFormat(ttl_tkct_wonx)%></td>
                     <td><%=WebUtil.printNumFormat(ttl_cash_cont)%></td>
                     <td class="lastCol"><%=WebUtil.printNumFormat(ttl_cash_wonx)%></td>
                </tr>
            </table>
        </div>
    </div>

    <h2 class="subtitle">결재정보</h2>

    <!-- 결재자 입력 테이블 시작-->
    <%= hris.common.util.AppUtil.getAppDetail(AppLineData_vt) %>
    <!-- 결재자 입력 테이블 End-->

    <div class="buttonArea">
        <ul class="btn_crud">
            <li><a href="javascript:doDelete();"><span>삭제</span></a></li>
        </ul>
    </div>

<!-- Hidden Field -->

<% } %>
<!-- Hidden Field -->

  </div>
<!-- HIDDEN  처리해야할 부분 시작 -->

      <input type="hidden" name="INDEX"    value="">
      <input type="hidden" name="AWART"    value="">
      <input type="hidden" name="PERNR"    value="">
      <input type="hidden" name="jobid"    value="">
      <input type="hidden" name="rowCount" value="">
  <input type="hidden" name="RowCount_meal" value="<%= meal_vt.size() %>">
  <input type="hidden" name="RowCount" value="">
<!-- HIDDEN  처리해야할 부분 끝   -->
</form>
<iframe name="ifHidden" width="0" height="0" />
<!-------hidden------------>
<%@ include file="/web/common/commonEnd.jsp" %>