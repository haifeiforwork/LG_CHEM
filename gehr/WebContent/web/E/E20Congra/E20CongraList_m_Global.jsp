<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : 경조금지원내역                                              */
/*   Program Name : 경조금지원내역                                              */
/*   Program ID   : E20CongraList_m.jsp                                         */
/*   Description  : 경조금 리스트를 조회 및 상세 조회                           */
/*   Note         :                                                             */
/*   Creation     : 2001-12-19  박영락                                          */
/*   Update       : 2005-01-24  윤정현                                          */
/*                                                                              */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="../../common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.E.E20Congra.Global.*" %>

<%
//  defult 정렬값 18번 field 신청일 역정렬
    WebUserData user_m = (WebUserData)session.getAttribute("user_m");
    WebUserData user   = (WebUserData)session.getAttribute("user");

    Vector E20CongcondData_dis = (Vector)request.getAttribute("E20CongcondData_dis");
    String paging_m  = (String)request.getAttribute("page_m");
    String sortField = (String)request.getAttribute("sortField");
    String sortValue = (String)request.getAttribute("sortValue");

//  PageUtil 관련 - Page 사용시 반드시 써줄것.
    PageUtil pu_m = null;
    if ( E20CongcondData_dis != null && E20CongcondData_dis.size() != 0 ) {
        try {
            pu_m = new PageUtil(E20CongcondData_dis.size(), paging_m , 10, 10 );//Page 관련사항
        } catch (Exception ex) {
            Logger.debug.println(DataUtil.getStackTrace(ex));
        }
    }
%>
<jsp:include page="/include/header.jsp" />
<SCRIPT LANGUAGE="JavaScript">
<!--
// NewSession.jsp에서 이 function 호출함
function  doSearchDetail() {
    document.form1.action = "<%= WebUtil.ServletURL %>hris.E.E20Congra.E20CongraListSV_m";
    document.form1.method = "post";
    document.form1.target = "main_ess";
    document.form1.submit();
}

/*function doSubmit() {//경조금 상세조회 페이지로
    trans_form();
    document.form2.jobid_m.value = "detail";
    document.form2.action = '<%= WebUtil.JspURL %>E/E20Congra/E20CongraDetail_m.jsp';
    document.form2.method = "get";
    document.form2.submit();
}*/
function doSubmit() {//경조금 상세조회 페이지로
    trans_form();
    document.form2.jobid.value = "detail";
    document.form2.action = '<%= WebUtil.JspURL %>E/E20Congra/E20CongraDetail.jsp';
    document.form2.method = "get";
    document.form2.submit();
}


/*function trans_form() {
    var command = "";
    var size = "";
    if( isNaN( document.form1.radiobutton.length ) ){
        size = 1;
    } else {
        size = document.form1.radiobutton.length;
    }
    for (var i = 0; i < size ; i++) {
        if ( size == 1 ){
            command = 0;
        } else if ( document.form1.radiobutton[i].checked == true ) {
            command = document.form1.radiobutton[i].value;
        }
    }
    eval("document.form2.CONG_CODE.value = document.form1.CONG_CODE"+command+".value");
    eval("document.form2.RELA_CODE.value = document.form1.RELA_CODE"+command+".value");
    eval("document.form2.HOLI_CONT.value = document.form1.HOLI_CONT"+command+".value");
    eval("document.form2.RELA_NAME.value = document.form1.RELA_NAME"+command+".value");
    eval("document.form2.EREL_NAME.value = document.form1.EREL_NAME"+command+".value");
    eval("document.form2.CONG_DATE.value = document.form1.CONG_DATE"+command+".value");
    eval("document.form2.WAGE_WONX.value = removeComma(document.form1.WAGE_WONX"+command+".value)");
    eval("document.form2.CONG_RATE.value = document.form1.CONG_RATE"+command+".value");
    eval("document.form2.CONG_WONX.value = removeComma(document.form1.CONG_WONX"+command+".value)");
    eval("document.form2.PROV_DATE.value = document.form1.PROV_DATE"+command+".value");
    eval("document.form2.BANK_NAME.value = document.form1.BANK_NAME"+command+".value");
    eval("document.form2.BANKN.value     = document.form1.BANKN"+command+".value");
    eval("document.form2.WORK_YEAR.value = document.form1.WORK_YEAR"+command+".value");
    eval("document.form2.WORK_MNTH.value = document.form1.WORK_MNTH"+command+".value");
    eval("document.form2.RTRO_MNTH.value = document.form1.RTRO_MNTH"+command+".value");
    eval("document.form2.RTRO_WONX.value = removeComma(document.form1.RTRO_WONX"+command+".value)");
    eval("document.form2.CONG_NAME.value = document.form1.CONG_NAME"+command+".value");
    eval("document.form2.BEGDA.value     = document.form1.BEGDA"+command+".value");
    eval("document.form2.POST_DATE.value = document.form1.POST_DATE"+command+".value");
}*/
function trans_form() {
    var command = "";
    var size = "";
    if( isNaN( document.form1.radiobutton.length ) ){
      size = 1;
    } else {
      size = document.form1.radiobutton.length;
    }
    for (var i = 0; i < size ; i++) {
        if ( size == 1 ){
            command = 0;
        } else if ( document.form1.radiobutton[i].checked == true ) {
            command = document.form1.radiobutton[i].value;
        }
    }
    eval("document.form2.BEGDA.value = document.form1.BEGDA"+command+".value");
    eval("document.form2.CELTX.value = document.form1.CELTX"+command+".value");
    eval("document.form2.FAMTXT.value = document.form1.FAMTXT"+command+".value");
    eval("document.form2.ENAME.value = document.form1.ENAME"+command+".value");
    eval("document.form2.CELDT.value = document.form1.CELDT"+command+".value");
     eval("document.form2.PAYM_AMNT.value = document.form1.PAYM_AMNT"+command+".value");
     eval("document.form2.SUBDT.value = document.form1.SUBDT"+command+".value");

    eval("document.form2.CELTY.value = document.form1.CELTY"+command+".value");
    eval("document.form2.FAMY_CODE.value = document.form1.FAMY_CODE"+command+".value");
    eval("document.form2.FAMSA.value = document.form1.FAMSA"+command+".value");
    eval("document.form2.SYEAR.value = document.form1.SYEAR"+command+".value");
    eval("document.form2.REMRA.value = document.form1.REMRA"+command+".value");
    eval("document.form2.BASE_FLAG.value = document.form1.BASE_FLAG"+command+".value");
    eval("document.form2.BASE_AMNT.value = removeComma(document.form1.BASE_AMNT"+command+".value)");
    eval("document.form2.PAYM_RATE.value = document.form1.PAYM_RATE"+command+".value");
    eval("document.form2.PAYM_DATE.value = removeComma(document.form1.PAYM_DATE"+command+".value)");
    eval("document.form2.CLAC_AMNT.value = document.form1.CLAC_AMNT"+command+".value");
    eval("document.form2.FIXD_PAY.value = document.form1.FIXD_PAY"+command+".value");
    eval("document.form2.ABSN_DATE.value     = document.form1.ABSN_DATE"+command+".value");
    eval("document.form2.AWART.value = document.form1.AWART"+command+".value");
    eval("document.form2.PAYM_BETG.value = document.form1.PAYM_BETG"+command+".value");
    eval("document.form2.ABSN_DAYS.value = document.form1.ABSN_DAYS"+command+".value");
    eval("document.form2.REFU_DATE.value = removeComma(document.form1.REFU_DATE"+command+".value)");
    eval("document.form2.REFU_RASN.value = document.form1.REFU_RASN"+command+".value");
    eval("document.form2.REFU_AMNT.value     = document.form1.REFU_AMNT"+command+".value");
    eval("document.form2.REFU_ACNO.value = document.form1.REFU_ACNO"+command+".value");
    //@v1.1
    eval("document.form2.CURRENCY.value = document.form1.CURRENCY"+command+".value");
    eval("document.form2.CERT_FLAG.value = document.form1.CERT_FLAG"+command+".value");
    eval("document.form2.CERT_DATE.value = removeComma(document.form1.CERT_DATE"+command+".value)");
    eval("document.form2.CERT_BETG.value    = document.form1.CERT_BETG"+command+".value");
    eval("document.form2.BELNR.value = removeComma(document.form1.BELNR"+command+".value)");
    eval("document.form2.FAMY_TEXT.value    = document.form1.FAMY_TEXT"+command+".value");

}
//PageUtil 관련 script - page처리시 반드시 써준다...
function pageChange(page_m){
    document.form3.page_m.value = page_m;
    get_Page2();
}

//PageUtil 관련 script - page처리시 반드시 써준다...
function get_Page(){
    document.form3.action = '<%= WebUtil.ServletURL %>hris.E.E20Congra.E20CongraListSV_m';
    document.form3.method = "get";
    document.form3.submit();
}

/*function sortPage( FieldName, FieldValue ){
    if(document.form3.sortField.value==FieldName){
        if(FieldName == 'BEGDA,POST_DATE,CONG_NAME,RELA_NAME,EREL_NAME,CONG_DATE') {   //신청일 sort시
            if(document.form3.sortValue.value == 'desc,desc,asc,asc,asc,desc') {
                document.form3.sortValue.value = 'asc,desc,asc,asc,asc,desc';
            } else {
                document.form3.sortValue.value = 'desc,desc,asc,asc,asc,desc';
            }
        } else if(FieldName == 'CONG_NAME,RELA_NAME,EREL_NAME,CONG_DATE') {
            if(document.form3.sortValue.value == 'asc,asc,asc,desc') {                 //경조내역 sort시
                document.form3.sortValue.value = 'desc,asc,asc,desc';
            } else {
                document.form3.sortValue.value = 'asc,asc,asc,desc';
            }
        } else if(FieldName == 'RELA_NAME,CONG_NAME,EREL_NAME,CONG_DATE') {            //경조대상자 관계 sort시
            if(document.form3.sortValue.value == 'asc,asc,asc,desc') {
                document.form3.sortValue.value = 'desc,asc,asc,desc';
            } else {
                document.form3.sortValue.value = 'asc,asc,asc,desc';
            }
        } else if(FieldName == 'EREL_NAME,CONG_NAME,RELA_NAME,CONG_DATE') {            //대상자 sort시
            if(document.form3.sortValue.value == 'asc,asc,asc,desc') {
                document.form3.sortValue.value = 'desc,asc,asc,desc';
            } else {
                document.form3.sortValue.value = 'asc,asc,asc,desc';
            }
        } else if(FieldName == 'CONG_DATE') {                                          //경조발생일 sort시
            if(document.form3.sortValue.value == 'desc') {
                document.form3.sortValue.value = 'asc';
            } else {
                document.form3.sortValue.value = 'desc';
            }
        } else if(FieldName == 'CONG_WONX') {                                          //경조금액 sort시
            if(document.form3.sortValue.value == 'desc') {
                document.form3.sortValue.value = 'asc';
            } else {
                document.form3.sortValue.value = 'desc';
            }
        } else if(FieldName == 'POST_DATE,CONG_NAME,RELA_NAME,EREL_NAME,CONG_DATE') {  //최종결재일 sort시
            if(document.form3.sortValue.value == 'desc,asc,asc,asc,desc') {
                document.form3.sortValue.value = 'asc,asc,asc,asc,desc';
            } else {
                document.form3.sortValue.value = 'desc,asc,asc,asc,desc';
            }
        }
    } else {
        document.form3.sortField.value = FieldName;
        document.form3.sortValue.value = FieldValue;
    }
    get_Page2();
}*/
function sortPage( FieldName, FieldValue ){
  if(document.form3.sortField.value==FieldName){
    if(FieldName == 'PAYM_DATE,CELDT,FAMTXT,ENAME,CELDT,BEGDA') {      //신청일 sort시
      if(document.form3.sortValue.value == 'desc,desc,asc,asc,asc,desc') {
        document.form3.sortValue.value = 'asc,desc,asc,asc,asc,desc';
      } else {
        document.form3.sortValue.value = 'desc,desc,asc,asc,asc,desc';
      }
    } else if(FieldName == 'CELTX,ENAME,CELDT,PAYM_DATE') {
      if(document.form3.sortValue.value == 'asc,asc,asc,desc') {                      //경조내역 sort시
        document.form3.sortValue.value = 'desc,asc,asc,desc';
      } else {
        document.form3.sortValue.value = 'asc,asc,asc,desc';
      }
    } else if(FieldName == 'FAMTXT,ENAME,CELDT,PAYM_DATE') {               //경조대상자 관계 sort시
      if(document.form3.sortValue.value == 'asc,asc,asc,desc') {
        document.form3.sortValue.value = 'desc,asc,asc,desc';
      } else {
        document.form3.sortValue.value = 'asc,asc,asc,desc';
      }
    } else if(FieldName == 'ENAME,FAMTXT,CELDT,PAYM_DATE') {                //대상자 sort시
      if(document.form3.sortValue.value == 'asc,asc,asc,desc') {
        document.form3.sortValue.value = 'desc,asc,asc,desc';
      } else {
        document.form3.sortValue.value = 'asc,asc,asc,desc';
      }
    } else if(FieldName == 'CELDT') {                                             //경조발생일 sort시
      if(document.form3.sortValue.value == 'desc') {
        document.form3.sortValue.value = 'asc';
      } else {
        document.form3.sortValue.value = 'desc';
      }
    } else if(FieldName == 'PAYM_AMNT') {                                             //경조금액 sort시
      if(document.form3.sortValue.value == 'desc') {
        document.form3.sortValue.value = 'asc';
      } else {
        document.form3.sortValue.value = 'desc';
      }
    } else if(FieldName == 'BEGDA,ENAME,FAMTXT,CELDT,PAYM_DATE') {          //최종결재일 sort시
      if(document.form3.sortValue.value == 'desc,asc,asc,asc,desc') {
        document.form3.sortValue.value = 'asc,asc,asc,asc,desc';
      } else {
        document.form3.sortValue.value = 'desc,asc,asc,asc,desc';
      }
    }else if(FieldName == 'REFU_AMNT'){
      if(document.form3.sortValue.value == 'desc') {
        document.form3.sortValue.value = 'asc';
      } else {
        document.form3.sortValue.value = 'desc';
      }
    }
  } else {
    document.form3.sortField.value = FieldName;
    document.form3.sortValue.value = FieldValue;
  }
  get_Page();
}

$(document).ready(function(){
	if(parent.resizeIframe) parent.resizeIframe(document.body.scrollHeight);
 });
//-->
</SCRIPT>
    <jsp:include page="/include/body-header.jsp">
        <jsp:param name="click" value="Y"/>
        <jsp:param name="help" value="X03PersonInfo.html'"/>
    </jsp:include>
<form name="form1" method="post">

<%
// 사원 검색한 사람이 없을때
if ( user_m != null ) {
%>

<%
    if( E20CongcondData_dis.size() > 0 ) {
%>

    <h2 class="subtitle"><!-- Currency --><%=g.getMessage("LABEL.E.COMMON.0001")%>:<%=((hris.E.E20Congra.Global.E20CongcondData)E20CongcondData_dis.get(0)).CURRENCY %></h2>

    <!-- 조회 리스트 테이블 시작-->
    <div class="listArea">
        <div class="listTop">
            <span class="listCnt"><%= pu_m == null ?  "" : pu_m.pageInfo() %></span>
        </div>
        <div class="table">
            <table class="listTable">
            <thead>
                <tr>
                    <th onClick="javascript:sortPage('PAYM_DATE,CELDT,FAMTXT,ENAME,CELDT,BEGDA','desc,desc,asc,asc,asc,desc')" style="cursor:hand"><!-- Payment Date --><%=g.getMessage("LABEL.E.E20.0032")%> <%= sortField.equals("PAYM_DATE,CELDT,FAMTXT,ENAME,CELDT,BEGDA") ? ( sortValue.toLowerCase() ).equals("desc,desc,asc,asc,asc,desc") ? "<font color='#FF0000'><b>▼</b></font>" : "<font color='#FF0000'><b>▲</b></font>" : "<img src='" + WebUtil.ImageURL + "icon_arrow_top.gif'  border='0' align='absmiddle'>" %></th>
                    <th onClick="javascript:sortPage('CELTX,ENAME,CELDT,PAYM_DATE','asc,asc,asc,desc')"                style="cursor:hand"><!-- Cel/Con Type --><%=g.getMessage("LABEL.E.E20.0033")%><%= sortField.equals("CELTX,ENAME,CELDT,PAYM_DATE")            ? ( sortValue.toLowerCase() ).equals("desc,asc,asc,desc")     ? "<font color='#FF0000'><b>▼</b></font>" : "<font color='#FF0000'><b>▲</b></font>" : "<img src='" + WebUtil.ImageURL + "icon_arrow_top.gif'  border='0' align='absmiddle'>" %></th>
                    <th onClick="javascript:sortPage('FAMTXT,ENAME,CELDT,PAYM_DATE','asc,asc,asc,desc')"                style="cursor:hand"><!-- Family Type --><%=g.getMessage("LABEL.E.E20.0034")%><%= sortField.equals("FAMTXT,ENAME,CELDT,PAYM_DATE")           ? ( sortValue.toLowerCase() ).equals("desc,asc,asc,desc")     ? "<font color='#FF0000'><b>▼</b></font>" : "<font color='#FF0000'><b>▲</b></font>" : "<img src='" + WebUtil.ImageURL + "icon_arrow_top.gif'  border='0' align='absmiddle'>" %></th>
                    <th onClick="javascript:sortPage('ENAME,FAMTXT,CELDT,PAYM_DATE','asc,asc,asc,desc')"                style="cursor:hand"><!-- Name --><%=g.getMessage("LABEL.E.E20.0035")%><%= sortField.equals("ENAME,FAMTXT,CELDT,PAYM_DATE")            ? ( sortValue.toLowerCase() ).equals("desc,asc,asc,desc")     ? "<font color='#FF0000'><b>▼</b></font>" : "<font color='#FF0000'><b>▲</b></font>" : "<img src='" + WebUtil.ImageURL + "icon_arrow_top.gif'  border='0' align='absmiddle'>" %></th>
                    <th onClick="javascript:sortPage('CELDT','desc')"                                                          style="cursor:hand"><!-- Cel/Con Date --><%=g.getMessage("LABEL.E.E20.0036")%><%= sortField.equals("CELDT")                                         ? ( sortValue.toLowerCase() ).equals("desc")                  ? "<font color='#FF0000'><b>▼</b></font>" : "<font color='#FF0000'><b>▲</b></font>" : "<img src='" + WebUtil.ImageURL + "icon_arrow_top.gif'  border='0' align='absmiddle'>" %></th>
                    <th onClick="javascript:sortPage('PAYM_AMNT','desc')"                                                          style="cursor:hand"><!-- Payment Amount --><%=g.getMessage("LABEL.E.E21.0030")%><%= sortField.equals("PAYM_AMNT")                                         ? ( sortValue.toLowerCase() ).equals("desc")                  ? "<font color='#FF0000'><b>▼</b></font>" : "<font color='#FF0000'><b>▲</b></font>" : "<img src='" + WebUtil.ImageURL + "icon_arrow_top.gif'  border='0' align='absmiddle'>" %></th>
                    <th onClick="javascript:sortPage('BEGDA,ENAME,FAMTXT,CELDT,PAYM_DATE','desc,asc,asc,asc,desc')"  style="cursor:hand"><!-- Approved Date --><%=g.getMessage("LABEL.E.E20.0038")%><%= sortField.equals("BEGDA,ENAME,FAMTXT,CELDT,PAYM_DATE") ? ( sortValue.toLowerCase() ).equals("desc,asc,asc,asc,desc") ? "<font color='#FF0000'><b>▼</b></font>" : "<font color='#FF0000'><b>▲</b></font>" : "<img src='" + WebUtil.ImageURL + "icon_arrow_top.gif'  border='0' align='absmiddle'>" %></th>
                    <th class="lastCol" onClick="javascript:sortPage('REFU_AMNT','desc')"                                                          style="cursor:hand"><!-- Refund Amount --><%=g.getMessage("LABEL.E.E20.0040")%><%= sortField.equals("REFU_AMNT")                                         ? ( sortValue.toLowerCase() ).equals("desc")                  ? "<font color='#FF0000'><b>▼</b></font>" : "<font color='#FF0000'><b>▲</b></font>" : "<img src='" + WebUtil.ImageURL + "icon_arrow_top.gif'  border='0' align='absmiddle'>" %></th>
                </tr>
               </thead>
<%
        int j = 0;//내부 카운터용
        for( int i = pu_m.formRow() ; i < pu_m.toRow(); i++ ) {
            hris.E.E20Congra.Global.E20CongcondData data = (hris.E.E20Congra.Global.E20CongcondData)E20CongcondData_dis.get(i);

            String tr_class = "";

            if(i%2 == 0){
                tr_class="oddRow";
            }else{
                tr_class="";
            }

%>
          <tr class="<%=tr_class%>">
            <td><%=data.PAYM_DATE.equals("0000-00-00") ? "" : WebUtil.printDate(data.PAYM_DATE)%></td>
            <td><%=data.CELTX%></td>
            <td><%=data.FAMTXT%></td>
            <td><%=data.ENAME%></td>
            <td><%=data.CELDT.equals("0000-00-00") ? "" : WebUtil.printDate(data.CELDT)%></td>
            <td class="align_right"><%= data.PAYM_AMNT.equals("0")?"":WebUtil.printNumFormat(data.PAYM_AMNT) %></td>
            <td><%=data.BEGDA.equals("0000-00-00") ? "" : WebUtil.printDate(data.BEGDA)%></td>
            <td class="align_right lastCol"><%= data.REFU_AMNT.equals("0")?"":WebUtil.printNumFormat(data.REFU_AMNT) %>
              <input type="hidden" name="BEGDA<%= j %>" value="<%=data.BEGDA.equals("0000-00-00") ? "" : WebUtil.printDate(data.BEGDA)%>">
            <input type="hidden" name="CELTX<%= j %>" value="<%=data.CELTX%>">
            <input type="hidden" name="FAMTXT<%= j %>" value="<%=data.FAMTXT%>">
            <input type="hidden" name="ENAME<%= j %>" value="<%=data.ENAME%>">
            <input type="hidden" name="CELDT<%= j %>" value="<%=data.CELDT.equals("0000-00-00") ? "" : WebUtil.printDate(data.CELDT)%>">
            <input type="hidden" name="PAYM_AMNT<%= j %>" value="<%= WebUtil.printNumFormat(data.PAYM_AMNT) %>">
            <input type="hidden" name="SUBDT<%= j %>" value="<%=data.SUBDT.equals("0000-00-00") ? "" : WebUtil.printDate(data.SUBDT)%>">
            <input type="hidden" name="CELTY<%= j %>" value="<%= data.CELTY %>">
            <input type="hidden" name="FAMY_CODE<%= j %>" value="<%= data.FAMY_CODE %>">
            <input type="hidden" name="FAMSA<%= j %>" value="<%= data.FAMSA %>">
            <input type="hidden" name="SYEAR<%= j %>" value="<%= data.SYEAR %>">
            <input type="hidden" name="REMRA<%= j %>" value="<%= data.REMRA %>">
            <input type="hidden" name="BASE_FLAG<%= j %>" value="<%= data.BASE_FLAG  %>">
            <input type="hidden" name="BASE_AMNT<%= j %>" value="<%= data.BASE_AMNT %>">
            <input type="hidden" name="PAYM_RATE<%= j %>" value="<%= data.PAYM_RATE  %>">

            <input type="hidden" name="PAYM_DATE<%= j %>" value="<%= data.PAYM_DATE %>">
            <input type="hidden" name="CLAC_AMNT<%= j %>"     value="<%= data.CLAC_AMNT     %>">
            <input type="hidden" name="FIXD_PAY<%= j %>" value="<%= data.FIXD_PAY %>">
            <input type="hidden" name="ABSN_DATE<%= j %>" value="<%= data.ABSN_DATE %>">
            <input type="hidden" name="AWART<%= j %>" value="<%= data.AWART %>">
            <input type="hidden" name="PAYM_BETG<%= j %>" value="<%= data.PAYM_BETG  %>">
            <input type="hidden" name="ABSN_DAYS<%= j %>" value="<%= data.ABSN_DAYS %>">
            <input type="hidden" name="REFU_DATE<%= j %>"     value="<%= data.REFU_DATE     %>">
            <input type="hidden" name="REFU_RASN<%= j %>" value="<%= data.REFU_RASN     %>">

            <input type="hidden" name="REFU_AMNT<%= j %>" value="<%= data.REFU_AMNT %>">
            <input type="hidden" name="REFU_ACNO<%= j %>" value="<%= data.REFU_ACNO %>">
            <input type="hidden" name="CURRENCY<%= j %>" value="<%= data.CURRENCY  %>">
            <input type="hidden" name="CERT_FLAG<%= j %>"    value="<%= data.CERT_FLAG %>">
             <input type="hidden" name="CERT_DATE<%= j %>" value="<%= data.CERT_DATE %>">
            <input type="hidden" name="CERT_BETG<%= j %>" value="<%= data.CERT_BETG %>">
            <input type="hidden" name="BELNR<%= j %>" value="<%= data.BELNR %>">
            <input type="hidden" name="FAMY_TEXT<%= j %>"    value="<%= data.FAMY_TEXT %>">
            </td>
          </tr>

<%
        j++;
        }
%>
         </table>

        </div>
    </div>
  <%
    } else {
%>


    <!-- 조회 리스트 테이블 시작-->
    <div class="listArea">
        <div class="table">
            <table class="listTable">
            <thead>
              <tr>
                <th><!-- Payment Date --><%=g.getMessage("LABEL.E.E20.0032")%></th>
                <th><!-- Cel/Con Type --><%=g.getMessage("LABEL.E.E20.0033")%></th>
                <th><!-- Family Type --><%=g.getMessage("LABEL.E.E20.0034")%></th>
                <th><!-- Name --><%=g.getMessage("LABEL.E.E20.0035")%></th>
                <th><!-- Cel/Con Date --><%=g.getMessage("LABEL.E.E20.0036")%></th>
                <th><!-- Payment Amount --><%=g.getMessage("LABEL.E.E21.0030")%></th>
                <th class="lastCol"><!-- Approved Date --><%=g.getMessage("LABEL.E.E20.0038")%></th>
              </tr>
              </thead>
              <tr class="oddRow">
                <td class="lastCol" colspan="8"><!-- No data --><%=g.getMessage("MSG.E.ECOMMON.0001")%></td>
              </tr>

<%
    }
%>
            </table>
           </div>
          </div>
            <div class="align_center">
<% if( E20CongcondData_dis.size() == 0 ){%>

<% }  %>
                <%= pu_m == null ? "" : pu_m.pageControl() %>
            </div>

    <!-- 조회 리스트 테이블 끝-->


</form>
<form name="form2">
<!-----   hidden field --------
  <input type="hidden" name="jobid_m"     value="">
  <input type="hidden" name="CONG_CODE" value="">
  <input type="hidden" name="RELA_CODE" value="">
  <input type="hidden" name="HOLI_CONT" value="">
  <input type="hidden" name="RELA_NAME" value="">
  <input type="hidden" name="EREL_NAME" value="">
  <input type="hidden" name="CONG_DATE" value="">
  <input type="hidden" name="WAGE_WONX" value="">
  <input type="hidden" name="CONG_RATE" value="">
  <input type="hidden" name="CONG_WONX" value="">
  <input type="hidden" name="PROV_DATE" value="">
  <input type="hidden" name="BANK_NAME" value="">
  <input type="hidden" name="BANKN"     value="">
  <input type="hidden" name="WORK_YEAR" value="">
  <input type="hidden" name="WORK_MNTH" value="">
  <input type="hidden" name="RTRO_MNTH" value="">
  <input type="hidden" name="RTRO_WONX" value="">
  <input type="hidden" name="CONG_NAME" value="">
  <input type="hidden" name="BEGDA"     value="">
  <input type="hidden" name="POST_DATE" value="">-->
<!--  HIDDEN  처리해야할 부분 끝-->
        <input type="hidden" name="jobid"     value="">
             <input type="hidden" name="BEGDA" value="">
            <input type="hidden" name="CELTX" value="">
            <input type="hidden" name="FAMTXT" value="">
            <input type="hidden" name="ENAME" value="">
            <input type="hidden" name="CELDT" value="">
            <input type="hidden" name="PAYM_AMNT" value="">
            <input type="hidden" name="SUBDT" value="">


            <input type="hidden" name="CELTY" value="">
            <input type="hidden" name="FAMY_CODE" value="">
            <input type="hidden" name="FAMSA" value="">

            <input type="hidden" name="SYEAR" value="">
            <input type="hidden" name="REMRA" value="">
            <input type="hidden" name="BASE_FLAG" value="">
            <input type="hidden" name="BASE_AMNT" value="">
            <input type="hidden" name="PAYM_RATE" value="">

            <input type="hidden" name="PAYM_DATE" value="">
            <input type="hidden" name="CLAC_AMNT"     value="">
            <input type="hidden" name="FIXD_PAY" value="">
            <input type="hidden" name="ABSN_DATE" value="">
            <input type="hidden" name="AWART" value="">
            <input type="hidden" name="PAYM_BETG" value="">
            <input type="hidden" name="ABSN_DAYS" value="">
            <input type="hidden" name="REFU_DATE"     value="">
            <input type="hidden" name="REFU_RASN" value="">

            <input type="hidden" name="REFU_AMNT" value="">  <!--반납일자     v1.1-->
            <input type="hidden" name="REFU_ACNO" value="">  <!--반납사유     v1.1-->
            <input type="hidden" name="CURRENCY" value="">  <!--지급액       v1.1-->
            <input type="hidden" name="CERT_FLAG"    value="">     <!--회계전표번호 v1.1-->
             <input type="hidden" name="CERT_DATE" value="">  <!--반납일자     v1.1-->
            <input type="hidden" name="CERT_BETG" value="">  <!--반납사유     v1.1-->
            <input type="hidden" name="BELNR" value="">  <!--지급액       v1.1-->
            <input type="hidden" name="FAMY_TEXT"    value="">
<%
}
%>
</form>
<!-----   hidden field ---------->



<!--  HIDDEN  처리해야할 부분 끝-->
<!-- 페이지 처리를 위한 FORM -->
<form name="form3">
  <input type="hidden" name="page_m"    value="<%= paging_m %>">
  <input type="hidden" name="sortField" value="<%= sortField %>">
  <input type="hidden" name="sortValue" value="<%= sortValue %>">
</form>
<%@ include file="../../common/commonEnd.jsp" %>
