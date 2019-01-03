<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page import="java.util.Vector" %>
<%@ page import="com.sns.jdf.util.*" %>
<%@ page import="com.sns.jdf.servlet.*" %>
<%@ page import="hris.D.D11TaxAdjust.*" %>
<%@ page import="hris.D.D11TaxAdjust.rfc.*" %>

<%
    PageUtil pu = null;
    Vector   code_vt = null;
    //PageUtil 관련 - Page 사용시 반드시 써줄것.
    Box box = WebUtil.getBox(request);

    String paging = box.get("page");
    String jobid  = box.get("jobid");
    String COMNM  = box.get("COMNM");
    String row    = box.get("row");

    if( jobid.equals("search") ) {
        try {
            D11TaxAdjustPreWorkSearchRFC func = new D11TaxAdjustPreWorkSearchRFC();
            code_vt = func.getSearch(COMNM);
        } catch (Exception ex) {
            Logger.debug.println(DataUtil.getStackTrace(ex));
        }
    }
%>

<jsp:include page="/include/header.jsp" />
<SCRIPT LANGUAGE="JavaScript">
<!--
function EnterCheck(){
	if (event.keyCode == 13)  {
		doSubmit();
	}
}

function doSubmit(){
	if( check_data() ) {
		document.form1.jobid.value = "search";
		document.form1.action = '<%= WebUtil.JspURL %>D/D11TaxAdjust/D11TaxAdjustPreWorkSearch.jsp';
		document.form1.submit();
	}
}

function check_data() {
  val = document.form1.COMNM.value;
  val = rtrim(ltrim(val));
	if( val == "" ) {
		alert("<spring:message code='MSG.D.D11.0087' />"); //검색어를 입력하세요
    document.form1.COMNM.focus();
		return false;
	}
	return true;
}

// PageUtil 관련 script - page처리시 반드시 써준다...
function pageChange(page){
  document.form1.page.value = page;
  doSubmit();
}

function preWorkSearchData(idx){
    bus01 = eval("document.form1.BUS01"+idx+".value");
    COMNM = eval("document.form1.COMNM"+idx+".value");

//  opener의 전근무지 라인
    row   = document.form1.row.value;

    opener.preWorkSearchData(bus01, COMNM, row);
    self.close();
}

function MM_swapImgRestore() { //v3.0
  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
}

function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}

function MM_findObj(n, d) { //v4.0
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && document.getElementById) x=document.getElementById(n); return x;
}

function MM_swapImage() { //v3.0
  var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
   if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
}

$(function() {
	MM_preloadImages('<%= WebUtil.ImageURL %>icon_Darrow_prev_o.gif','<%= WebUtil.ImageURL %>icon_arrow_prev_o.gif','<%= WebUtil.ImageURL %>icon_arrow_next_o.gif','<%= WebUtil.ImageURL %>icon_Darrow_next_o.gif');
	document.form1.COMNM.focus();
});

//-->

</script>
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" >

<div class="winPop">
    <div class="header">
        <span><spring:message code="LABEL.D.D11.0248" /><!-- 전근무지 검색 --></span>
        <a href="javascript:self.close()"><img src="<%= WebUtil.ImageURL %>sshr/btn_popup_close.png" border="0" /></a>
    </div>

    <div class="body">
     <form name="form1" method="post" action="" onsubmit="return false">
       <input type="hidden" name="jobid" value="">
       <input type="hidden" name="row" value="<%= row %>">
              <div class="tableInquiry">
              <spring:message code="LABEL.D.D11.0249" /><!-- 관련된 검색어를 입력하세요. -->
             <table>
               <tr>
                 <th width="139"><spring:message code="LABEL.D.D11.0250" /><!-- 검색어 --></th>
                 <td width="221">
                   <input type="text" name="COMNM" size="15" class="input03" value="<%= COMNM %>" onKeyDown="EnterCheck()" onFocus="this.select();" style="ime-mode:active">
                   <a href="javascript:doSubmit();" ><img src="<%= WebUtil.ImageURL %>sshr/ico_magnify.png" border="0"></a>
                 </td>
               </tr>
             </table>
		</div>
		</Form>


<%
    if ( code_vt == null || code_vt.size() == 0 ) {
        if( jobid.equals("search") ) {
%>
		<div class="listArea">
			<div class="table">
			 <table class="listTable" id="table">
			<thead>
              <tr>
                        <th><spring:message code="LABEL.D.D11.0139" /><!-- 사업자번호 --></th>
                        <th class="lastCol"><spring:message code="LABEL.D.D11.0221" /><!-- 회사이름 --></th>
              </tr>
              </thead>
                  <tr ><td colspan="2" class="lastCol"><spring:message code="LABEL.D.D11.0251" /><!-- 검색된 데이타가 없습니다. --></td></tr>
<%
        }
    } else {
%>
		<div class="listArea">
			<div class="table">
			 <table class="listTable">
			 <thead>
              <tr class="lastCol">
                        <th><spring:message code="LABEL.D.D11.0139" /><!-- 사업자번호 --></th>
                        <th><spring:message code="LABEL.D.D11.0221" /><!-- 회사이름 --></th>
              </tr>
              </thead>

<%
        pu = new PageUtil(code_vt.size(), paging , 10, 10);
        for( int i = pu.formRow() ; i < pu.toRow(); i++ ) {
            D11TaxAdjustPreWorkSearchData data = (D11TaxAdjustPreWorkSearchData)code_vt.get(i);
%>
                      <tr class="<%=WebUtil.printOddRow(i) %>">
                        <td ><a href="javascript:preWorkSearchData(<%= i %>)"><%= data.BIZNO %></a></td>
                        <td class="lastCol"  style="text-align:left"><a href="javascript:preWorkSearchData(<%= i %>)">&nbsp;<%= data.COMNM %></a>
                        <input type="hidden" name="BUS01<%= i %>" value="<%= data.BIZNO %>">
                        <input type="hidden" name="COMNM<%= i %>" value="<%= data.COMNM %>">
                        </td>

                      </tr>
<%
        }
%>

                     <!--주소 리스트 테이블 끝-->
            <p>
            <!-- PageUtil 관련 - 반드시 써준다. -->
              <input type="hidden" name="page" value="">
              <%= pu.pageControl() %>
            <!-- PageUtil 관련 - 반드시 써준다. -->
            </p>
<%
    }
%>


	      </table>
		</div>

	</div>


		<%
        if( jobid.equals("search") ) {
%>
	<div class="buttonArea" style="margin-top:20px;" >
		<ul class="btn_crud">
         	<li><a href="javascript:self.close()"><span><spring:message code="BUTTON.COMMON.CLOSE"/><%--닫기--%></span></a></li>
         </ul>
		 <div class="clear"></div>
	</div>
<%
      }
%>
</div>
</div>
<%@ include file="/web/common/commonEnd.jsp" %>

