<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="com.sns.jdf.util.*" %>
<%@ page import="com.sns.jdf.servlet.*" %>
<%@ page import="hris.A.A17Licence.*" %>
<%@ page import="hris.A.A17Licence.rfc.*" %>

<%
  PageUtil pu = null;
  Vector A17LicenceSearchData_vt = null;
  //PageUtil 관련 - Page 사용시 반드시 써줄것.
  Box box = WebUtil.getBox(request);

  String paging            = box.get("page");
  String jobid             = box.get("jobid");
  String LICN_NAME         = box.get("LICN_NAME");

  Logger.debug.println(this, "this value : page"+paging+" jobid : "+ jobid+ " LICN_NAME : "+LICN_NAME);

    if( jobid.equals("search") ) {
        try {
            A17LicenceSearchRFC func = new A17LicenceSearchRFC();
            A17LicenceSearchData_vt = func.getLicenceSearch(LICN_NAME);
        } catch (Exception ex) { 
            Logger.debug.println(DataUtil.getStackTrace(ex));
        }
    }
%>

<jsp:include page="/include/header.jsp"/>
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
		document.form1.action = '<%= WebUtil.JspURL %>A/A17Licence/A17LicenceSearch.jsp';
		document.form1.submit();
	}
}

function check_data() {
  val = document.form1.LICN_NAME.value;
  val = rtrim(ltrim(val));
	if( val == "" ) {
		alert("자격증 이름을 입력하세요");
    document.form1.LICN_NAME.focus();
		return false;
	}
	return true;
}

// PageUtil 관련 script - page처리시 반드시 써준다...
function pageChange(page){
  document.form1.page.value = page;
  doSubmit();
}

function licenceSearchData(idx){
    licn_code = eval("document.form1.LICN_CODE"+idx+".value");
    licn_name = eval("document.form1.LICN_NAME"+idx+".value");
    opener.licenceSearchData(licn_code, licn_name);
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
//-->
</script>
</head>
<jsp:include page="/include/pop-body-header.jsp">
    <jsp:param name="title" value="LABEL.A.A17.001"/>
</jsp:include>



<form name="form1" method="post" action="" onsubmit="return false">
    <div class="tableInquiry">
        <table>
            <tr>
                <th width="20%">
                    <img class="searchTitle" src="<%= WebUtil.ImageURL %>sshr/top_box_search.gif" />
                    <%--<spring:message code="LABEL.SEARCH.POP.WORD"/> &lt;%&ndash;검색어&ndash;%&gt;--%>
                </th>
                <td>
                    <input type="text" name="LICN_NAME" size="15" class="input03" value="<%= LICN_NAME %>" onKeyDown="EnterCheck()" onFocus="this.select();" style="ime-mode:active">
                    <input type="hidden" name="jobid" value="">
                    <input type="hidden" name="page" value="">
                    <div class="tableBtnSearch tableBtnSearch2">
                        <a class="search" href="javascript:doSubmit();"><span><spring:message code="BUTTON.COMMON.SEARCH"/><%--조회--%></span></a>
                    </div>
                </td>
            </tr>
        </table>
    </div>

    <div class="tableArea">
        <div class="listTop">
            <span class="listCnt"><%=Utils.getSize(A17LicenceSearchData_vt) > 0 || pu == null ? "" : pu.pageInfo() %></span>
        </div>
        <div class="table">
            <table class="tableGeneral perInfo">
                <tr>
                    <th class="align_center"><spring:message code="LABEL.A.A17.002"/> <%--자격증 종류--%></th>
                </tr>
<%  if(!"search".equals(jobid)) {   %>
                <tr>
                    <td class="align_center"><spring:message code="LABEL.SEARCH.POP.WORD.REQUIRED"/> <%--관련된 검색어를 입력하세요.--%></td>
                </tr>
<%  } else {  %>
                <%
                    pu = new PageUtil(A17LicenceSearchData_vt.size(), paging , 10, 10);
                    Logger.debug.println(this, "this value : 4");
        for( int i = pu.formRow() ; i < pu.toRow(); i++ ) {
            A17LicenceSearchData data = (A17LicenceSearchData)A17LicenceSearchData_vt.get(i);
                %>
                <tr>
                    <input type="hidden" name="LICN_CODE<%= i %>" value="<%= data.LICN_CODE %>">
                    <input type="hidden" name="LICN_NAME<%= i %>" value="<%= data.LICN_NAME %>">
                    <td class="td04" style='text-align:left'>
                        <a href="javascript:licenceSearchData(<%= i %>)">
                            <%= data.LICN_NAME %></a></td>
                </tr>
                <%
        }

        if(Utils.getSize(A17LicenceSearchData_vt) == 0) {
            %>
                <tr>
                    <Td class="align_center"><spring:message code="MSG.COMMON.0004" /></Td>
                </tr>

                <%
        }
    }
                %>
            </table>
            <div class="align_center">
                <%= pu == null ? "" : pu.pageControl() %>
            </div>
        </div>
    </div>

</Form>
<jsp:include page="/include/body-footer.jsp"/>
<jsp:include page="/include/footer.jsp"/>