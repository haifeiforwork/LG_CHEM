<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : 신청                                                          */
/*   2Depth Name  : 부서근태                                                        */
/*   Program Name : 부서근태마감                                                  */
/*   Program ID   : D12RotationBuild|D12RotationBuild.jsp                       */
/*   Description  : 부서근태마감 화면                                               */
/*   Note         :                                                             */
/*   Creation     : 2009-02-10  김종서                                             */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ page import="java.util.Vector" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Date" %>
<%@ page import="hris.D.D12Rotation.*" %>
<%@ page import="hris.D.D12Rotation.rfc.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="hris.common.WebUserData" %>
<%@ page import="hris.E.E19Congra.rfc.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="tags-approval" tagdir="/WEB-INF/tags/approval" %>

<%
    String jobid      = (String)request.getAttribute("jobid");
    String message = (String)request.getAttribute("message");

    Vector main_vt1    = (Vector)request.getAttribute("main_vt1");
    Vector main_vt2    = (Vector)request.getAttribute("main_vt2");
    Vector main_vt3    = (Vector)request.getAttribute("main_vt3");
    String deptId       = WebUtil.nvl(request.getParameter("hdn_deptId"));          //부서코드
    String deptNm       = WebUtil.nvl(request.getParameter("hdn_deptNm"));          //부서명
    String S_DATE  = WebUtil.nvl(request.getParameter("S_DATE"));          //기간
    String E_DATE  = WebUtil.nvl(request.getParameter("E_DATE"));          //기간
    String I_GBN  = WebUtil.nvl(request.getParameter("I_GBN"));
    String I_SEARCHDATA  = WebUtil.nvl(request.getParameter("I_SEARCHDATA"));
    String E_OTEXT = (String)request.getAttribute("E_OTEXT");

    String t_year = (String)request.getAttribute("t_year");
    String t_month = (String)request.getAttribute("t_month");
    int mainCount = main_vt3.size();

    if( S_DATE == null|| S_DATE.equals("")) {
        S_DATE = DataUtil.getCurrentDate();           //1번째 조회시
    }
    if( E_DATE == null|| E_DATE.equals("")) {
        E_DATE = DataUtil.getCurrentDate();           //1번째 조회시
    }
    String rowCount   = (String)request.getAttribute("rowCount" );

    WebUserData user = WebUtil.getSessionUser(request);
    if(deptId == null || deptId.equals("")){
        deptId = user.e_orgeh;
    }

    int  main_count = main_vt1.size();

    if( message == null ){
        message = "";
    }

    int dateSize = 40;
    int tableSize = 215+(main_vt3.size()*dateSize);

    D12RotationBuild2Data first_data = (D12RotationBuild2Data)main_vt3.get(0);
    D12RotationBuild2Data last_data = (D12RotationBuild2Data)main_vt3.get(main_vt3.size()-1);

    String first_date = first_data.BEGDA;
    String last_date = last_data.BEGDA;
    int toYear = DateTime.getYear();
%>
<c:set var="user" value="<%=WebUtil.getSessionUser(request) %>"/>
<c:set var="toYear" value="<%=toYear %>"/>
<c:set var="first_date" value="<%=first_date %>"/>
<c:set var="last_date" value="<%=last_date %>"/>
<c:set var="dateSize" value="<%=dateSize %>"/>
<c:set var="tableSize" value="<%=tableSize %>"/>
<c:set var="t_month" value="<%=t_month %>"/>
<c:set var="S_DATE" value="<%=S_DATE %>"/>
<c:set var="E_DATE" value="<%=E_DATE %>"/>
<c:set var="deptId" value="<%=deptId %>"/>
<c:set var="deptNm" value="<%=deptNm %>"/>
<c:set var="mainCount" value="<%=mainCount %>"/>
<c:set var="message" value="<%=message %>"/>

<c:set var="I_GBN" value = "<%=I_GBN%>"/>
<c:set var="title"  value="<%=g.getMessage("COMMON.MENU.ESS_HRA_TIME_CLOS")%>"/>

<c:set var="buttonBody" value="${g.bodyContainer}" />

<tags:body-container bodyContainer="${buttonBody}">
    <li><a href="javascript:;" onclick="go_Rotationprint();" ><span><spring:message code="BUTTON.COMMON.PRINT"/></span></a></li>
</tags:body-container>

<tags:layout css="ui_library_approval.css">

    <tags-approval:request-layout titlePrefix="COMMON.MENU.ESS_HRA_TIME_CLOS" title="${title}" representative="false" button="${buttonBody}" >
                    <tags:script>
                    <script>
                    function beforeSubmit() {
                    	if( check_data() ) {
                            document.form1.S_DATE.value  = removePoint(document.form1.S_DATE.value);
                            document.form1.E_DATE.value  = removePoint(document.form1.E_DATE.value);
                       		return true;
                    	}else{
                    		return false;
                    	}
                    }


function handleError (err, url, line) {
   //alert('오류 : '+err + '\nURL : ' + url + '\n줄 : '+line);
   alert('<spring:message code='MSG.D.D12.0018'/> : '+err + '\nURL : ' + url + '\n<spring:message code='MSG.D.D12.0019'/>  : '+line);
   return true;
}

function EnterCheck(){
    if (event.keyCode == 13)  {
        pop_search();
    }
}

function pop_search(){

    if(document.form1.I_GBN.value == "ORGEH"||document.form1.I_GBN.value=="RECENT"){
        dept_search();
    }else if(document.form1.I_GBN.value == "PERNR"){
        pers_search();
    }
}

// 부서 검색
function dept_search()
{
    var frm = document.form1;
    document.form1.txt_deptNm.value = document.form1.txt_searchNm.value;
    document.form1.I_VALUE1.value = document.form1.txt_deptNm.value;

    if ( document.form1.I_GBN.value == "ORGEH"&&  frm.txt_searchNm.value == "" ) {
        //alert("검색할 부서명을 입력하세요!");
        alert("<spring:message code='MSG.D.D12.0001'/>");
        frm.txt_searchNm.focus();
        return;
    }else if (document.form1.I_GBN.value=="RECENT"){
       document.form1.txt_deptNm.value = "";
    }
    small_window=window.open("","DeptNm","toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=no,scrollbars=no,width=500,height=550,left=100,top=100");
    small_window.focus();

    var oldTarget = frm.target;
    var oldAction = frm.action;

    frm.target = "DeptNm";

    //frm.action = "/web/common/SearchDeptNamePop.jsp";
    document.form1.action = "${g.jsp}D/D12Rotation/SearchDeptPersonsWait_Rot.jsp";
    frm.submit();
    frm.target = oldTarget;
    frm.action = oldAction;

}


function pers_search(){
    var val = document.form1.txt_searchNm.value;
    document.form1.I_VALUE1.value = document.form1.txt_searchNm.value;

    val = rtrim(ltrim(val));

    if ( val == "" ) {
        //alert("검색할 부서원 성명을 입력하세요!")
        alert("<spring:message code='MSG.D.D12.0001'/>");
        document.form1.txt_searchNm.focus();

        return;
    } else {
        if( val.length < 2 ) {
            //alert("검색할 성명을 한 글자 이상 입력하세요!");
            alert("<spring:message code='MSG.D.D12.0002'/>");
            document.form1.txt_searchNm.focus();

            return;
        } else {
            document.form1.jobid.value = "ename";
        }
    }
    document.form1.retir_chk.value = "";

    small_window=window.open("","DeptPers","toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=no,scrollbars=no,width=500,height=550,left=100,top=100");
    small_window.focus();

    var oldTarget = document.form1.target;
    var oldAction = document.form1.action;

    document.form1.target = "DeptPers";
    //document.form1.action = "${g.jsp}common/SearchDeptPersonsWait_T.jsp";
    document.form1.action = "${g.jsp}D/D12Rotation/SearchDeptPersonsWait_Rot.jsp";
    document.form1.submit();

    document.form1.target = oldTarget;
    document.form1.action = oldAction;
}

function setPersInfo( obj ){

    document.form1.hdn_deptId.value = obj.OBJID;
 if (document.form1.I_GBN.value !="PERNR"){
	    document.form1.I_SEARCHDATA.value = obj.OBJID;
	    document.form1.txt_searchNm.value = obj.STEXT;
 }else {
	    document.form1.I_SEARCHDATA.value = obj.EPERNR;
	    document.form1.txt_searchNm.value = obj.ENAME;

 }
    // document.form1.txt_searchNm.value = obj.STEXT;
    document.form1.hdn_deptNm.value = obj.STEXT;


    document.form1.S_DATE.value  = removePoint(document.form1.S_DATE.value);
    document.form1.E_DATE.value  = removePoint(document.form1.E_DATE.value);
    document.form1.jobid.value = "";
    document.form1.action = "${g.servlet}hris.D.D12Rotation.D12RotationBuildSV";
    document.form1.submit();
}


//조회에 의한 부서ID와 그에 따른 조회.
function setDeptID(deptId, deptNm){
    frm = document.form1;

    frm.hdn_deptId.value = deptId;

    frm.hdn_deptNm.value = deptNm;
    frm.hdn_excel.value = "";

    document.form1.I_SEARCHDATA.value = deptId;
    document.form1.txt_searchNm.value = deptNm;

    frm.action = "${g.servlet}hris.D.D12Rotation.D12RotationBuildSV";
    frm.target = "_self";
    frm.submit();
}

function check_data(){

    if(removePoint(document.form1.S_DATE.value) == "" || removePoint(document.form1.E_DATE.value) == ""){
        //alert("신청기간을 입력해주세요");
        alert("<spring:message code='MSG.D.D12.0003'/>");
        return;
    }
  /*  var app_size = parseInt(document.form1.app_size.value);
    var chk_val = "";
    for(var i=0; i<app_size; i++){
        chk_val = eval("document.form1.APPL_PERNR"+i+".value");
        if(chk_val == "00000000" || chk_val =="" || chk_val == null ){
            //alert("결재자 정보를 입력하세요");
            alert("<spring:message code='MSG.D.D12.0004'/>");
            return;
        }
    }*/
        var v_sdate=document.form1.S_DATE.value ;
        var v_edate =document.form1.E_DATE.value;
       //if(!confirm( document.form1.S_DATE.value+" ~ "+document.form1.E_DATE.value+" 까지의 근태를 마감신청하시겠습니까? ")){
        if(!confirm( document.form1.S_DATE.value+" ~ "+document.form1.E_DATE.value+" <spring:message code='MSG.D.D12.0005'/>")){
        return false;
    }
    var t_first = document.form1.first_date.value;
    var i_first = parseInt(t_first);
    var s_date = parseInt(removePoint(document.form1.S_DATE.value));
    var e_date = parseInt(removePoint(document.form1.E_DATE.value));

    var t_ainf = "";
    var t_stat = "";
    //while(i_first<s_date){

    //  t_ainf = document.getElementById(t_first).value;
    //  t_stat = document.getElementById(t_first).value2;

        //결재신청번호가 없거나 신청했으나 반려된 날이 있을경우 false 리턴
    //  if(t_ainf==""){
    //      alert("이전일 결재요청 안됨\n\n순차적으로 결재요청 바람");
    //      return false;
    //  }else{
    //      if(t_stat=="R"){
    //          alert("이전일 결재요청 승인안됨\n\n순차적으로 결재요청 바람");
    //          return false;
    //      }
    //  }

    //  t_first = getAfterDate(t_first,"1");
    //  i_first = parseInt(t_first);
    //}
  // 신청관련 단위 모듈에서 필히 넣어야?l 항목...
//  if ( check_empNo() ){
 //   return false;
 // }
    return true;
}

//기준일자 변경시 교대조 리스트를 다시 조회한다.
function after_listSetting(){
    listSetting();
}

function listSetting() {

    document.form1.S_DATE.value = removePoint(document.form1.S_DATE.value);
    document.form1.E_DATE.value = removePoint(document.form1.E_DATE.value);


    document.form1.jobid.value   = "first";

    document.form1.jobid.value = "";
    document.form1.target="_self";
    document.form1.action = "${g.servlet}hris.D.D12Rotation.D12RotationBuildSV";
    document.form1.method        = "post";
    document.form1.submit();
}

function goRotationDetail(deptId, yyyymmdd){

    window.open("${g.servlet}hris.D.D12Rotation.D12RotationSV?hdn_isPop=POP&jobid=&hdn_deptId="+deptId+"&I_DATE="+yyyymmdd+"&I_SEARCHDATA="+deptId,"RotataionDetail","toolbar=0,location=0,directories=0,status=0,menubar=0,resizable=1,width=1200,height=662, scrollbars=1");
}

function popReload(){
    document.form1.S_DATE.value = removePoint(document.form1.S_DATE.value);
    document.form1.E_DATE.value = removePoint(document.form1.E_DATE.value);
    document.form1.jobid.value = "";
    document.form1.action   = "${g.servlet}hris.D.D12Rotation.D12RotationBuildSV";
    document.form1.method   = "post";
    document.form1.submit();
}

function go_Rotationprint(){

    var t_year = document.form1.t_year.value;
    var t_month = document.form1.t_month.value;

    window.open('', 'essPrintWindow', "toolbar=no,location=no, directories=no,status=no,menubar=yes,resizable=no,width=1200,height=662,left=0,top=2");
    document.form1.target = "essPrintWindow";
    document.form1.action = "${g.jsp}common/printFrame_rotation_build.jsp?jobid=print&t_year="+t_year+"&t_month="+t_month+"&hdn_deptId='${deptId}'&hdn_deptNm='${deptNm}'&I_GBN="+document.form1.I_GBN.value+"&I_SEARCHDATA="+document.form1.I_SEARCHDATA.value;
    document.form1.method = "post";
    document.form1.submit();
}
</script>
</tags:script>


    <div class="tableInquiry">
        <table>
            	<colgroup>
            		<col width="9%" />
            		<col width="30%" />
            		<col width="24%" />
            		<col width="9%" />
            		<col width="20%" />
            		<col />
            	</colgroup>
            <tr>
                <th><!--  신청기간--><spring:message code="LABEL.D.D12.0003"/></th>
                <td>
                 <input type="hidden" name = "I_DeptTime" value="Y">
                  <input type="text" name="S_DATE" value="${f:printDate(S_DATE) }" size="9" onBlur="" class="date">
                  ~&nbsp;
                  <input type="text" name="E_DATE" value="${f:printDate(E_DATE) }"size="9" onBlur="" class="date">
                  <font color="#0000FF"> </font>
                </td>
                <td>
                    <select name="I_GBN">
                      <option value="ORGEH" ${I_GBN=="ORGEH"? "selected" : "" }><!--  부서명--><spring:message code="LABEL.D.D12.0005"/></option>
                      <option value="PERNR" ${I_GBN=="PERNR"? "selected" : "" }><!--  사원명--><spring:message code="LABEL.D.D12.0006"/></option>
                      <option value="RECENT" ${I_GBN=="RECENT"? "selected" : "" }><!--  최근검색--><spring:message code="LABEL.D.D12.0007"/></option>
                    </select>
                    <input type="text" name="txt_searchNm" size="14" maxlength="30" value="${ txt_searchNm}" onKeyDown="javascript:EnterCheck();" style="ime-mode:active" >
                    <a href="javascript:pop_search();"><img src="${g.image}sshr/ico_magnify.png" border="0"></a>
                      </td>
                <th><!--  조회 기간--><spring:message code='LABEL.D.D12.0002'/></th>
                <td>
                  <select name="t_year">
                    <option value="${toYear}">${toYear}</option>
                    <option value="${toYear+1}">${toYear+1}</option>
                  </select><!--  년--><spring:message code='LABEL.D.D12.0042'/>&nbsp;
                  <select name="t_month">
				 <option value="01" ${t_month=="01" ? "selected":"" }>01</option>
				 <option value="02" ${t_month=="02" ? "selected":"" }>02</option>
				 <option value="03" ${t_month=="03" ? "selected":"" }>03</option>
				 <option value="04" ${t_month=="04" ? "selected":"" }>04</option>
				 <option value="05" ${t_month=="05" ? "selected":"" }>05</option>
				 <option value="06" ${t_month=="06" ? "selected":"" }>06</option>
				 <option value="07" ${t_month=="07" ? "selected":"" }>07</option>
				 <option value="08" ${t_month=="08" ? "selected":"" }>08</option>
				 <option value="09" ${t_month=="09" ? "selected":"" }>09</option>
				 <option value="10" ${t_month=="10" ? "selected":"" }>10</option>
				 <option value="11" ${t_month=="11" ? "selected":"" }>11</option>
				 <option value="12" ${t_month=="12" ? "selected":"" }>12</option>


                  </select><!--  월--><spring:message code='LABEL.D.D12.0028'/>
                </td>
                      <td>
                    <div class="tableBtnSearch tableBtnSearch2">
                        <a href="javascript:after_listSetting()" class="search"><span><!--  조회--><spring:message code="BUTTON.COMMON.SEARCH"/></span></a>
                    </div>
                </td>
            </tr>
        </table>
    </div>

<!--  조회조건  끝  -->


      <!-- 근태일자 Field Table Header 시작 -->

      <!-- 근태일자 Field Table Header 끝 -->

      <!-- 상단입력 테이블 시작-->
    <div class="listArea">
        <div class="listTop">
            <div class="buttonArea">
                [<font color="#FFFACD">■</font> :<!--토,일요일--><spring:message code="LABEL.D.D12.0029"/> ,<font color="#FFB6C1">■</font>:<!--결재진행중--><spring:message code="LABEL.D.D12.0030"/> ,<font color="#EAEAEA">■</font>:<!--결재완료--><spring:message code="LABEL.D.D12.0031"/>]
            </div>
        </div>
        <div class="table">
           <div class="wideTable">
            <table  class="listTable" >
<!-- 아래, 위 프레임의 사이즈를 고정시킨다 -->
			<thead>
                <tr>
                  <th rowspan="2" nowrap><!--구분--><spring:message code="LABEL.D.D12.0032"/></th>
                  <th rowspan="2"><!--성명--><spring:message code="LABEL.D.D12.0018"/></th>
                  <th rowspan="2"><!-- 사번--><spring:message code="LABEL.D.D12.0033"/></th>
                  <th rowspan="2" nowrap><!--잔여휴가--><spring:message code="LABEL.D.D12.0034"/></th>
                  <th class="lastCol" colspan="${mainCount}">&nbsp;<!--근태내용--><spring:message code="LABEL.D.D12.0035"/>(${f:printDate(first_date) } ~ ${f:printDate(last_date)})</th>
                </tr>
                <tr>
                <c:forEach var="row" items="${main_vt3}" varStatus="status">
                <th id="${f:deleteStr(row.BEGDA,'-')}" value="${row. AINF_SEQN}" value2="${row. APPR_STAT}"  width="${dateSize}" title="${row. BEGDA}"><a href="javascript:goRotationDetail('${deptId}','${row.BEGDA}');">${fn:substring(row.BEGDA,8,10)}</a></th>

                <c:if  test="${ status.index  eq  '0'}" >
                <input type="hidden" name="first_date" value="${f:deleteStr(row.BEGDA,'-')}">
                </c:if>
                 </c:forEach>
                </tr>
              </thead>


<!-- 아래, 위 프레임의 사이즈를 고정시킨다 -->
	<c:forEach var="data" items="${main_vt1}" varStatus="status">
                   <tr class="${f:printOddRow(status.index)}">
                      <td>${status.index+1}
                      <input type="hidden" name="use_flag${status.index}"  value="Y" ><!--@v1.4-->
                      <input type="hidden" name="BEGDA${status.index}" value="${data.BEGDA }">
                      </td>
                      <td nowrap>${data. ENAME}</td>
                      <td>${data. PERNR}</td>
                      <td><fmt:formatNumber value="${data.QUATA}" pattern="0.0"/><%--<%= Math.abs(Double.parseDouble(data.QUATA)) --%></td>

                      <c:forEach var="data3" items="${main_vt3}" varStatus="status1">

                          <c:set var="cellData" value=""/>
                          <c:set var="title" value=""/>
                          <c:set var="map" value = "<%=new java.util.HashMap<String,String>()%>"/>
                          <c:forEach var="data2" items="${main_vt2}" varStatus="status2">
                        	  <c:if  test="${data.PERNR eq data2.PERNR and  data3.BEGDA eq data2.BEGDA}">
                          		<c:set var="cellData" value="${cellData}${ data2.ACODE}:${data2.ATIME }<br>"/>
                          		<c:set var="title" value="${title}${data2.ATEXT}:${data2.ATIME}시간&#10;"  />
                          		<c:set target="${map}" property="${data2.BEGDA}" value= "${data2.APPR_STAT}"/>
                              </c:if>
                          </c:forEach>
   						<c:choose>
   								<c:when  test="${(data3.APPR_STAT eq 'A' and  empty cellData ) or  (data3.APPR_STAT eq  'A' and  not empty cellData and  map[data3.BEGDA] eq  'A' )or( data3.APPR_STAT !=  'A'  and  not empty cellData  and map[data3.BEGDA] eq 'A')}">
    									<td class="td07" title="${title}"> ${cellData}</td>
   								</c:when>
      							<c:when  test="${data3.APPR_STAT eq 'I'}">
    									<td class="td11" title="${title}">${cellData}</td>
   								</c:when>
   								<c:otherwise>
          								<c:set var="dateNum" value="${f:getDay(f:deleteStr(data3.BEGDA,'-'))}"/>
          									<td class="${dateNum ==1 ?  'td10' :  dateNum ==7? 'td10' :''}"  title="${title}">${cellData}</td>
   								</c:otherwise>
   						</c:choose>
   					</c:forEach>
    			</tr>

	</c:forEach>
            </table>
           </div>
        </div>
    </div>

<!-----ADD ROW ---------------------------------->
<!---- ADD ROW ---------------------------------->

      <!-- 상단 입력 테이블 끝-->

    <h2 class="subtitle"><!-- 근태유형 및 단위--><spring:message code="LABEL.D.D12.0036"/></h2>

    <div class="listArea">
		<div class="table">
	        <table class="listTable">
	          <spring:message code="LABEL.D.D12.0052"/>
	        </table>
		</div>
    </div>
    <!-- <spring:message code="LABEL.D.D12.0037"/> -->
<!-- HIDDEN  처리해야할 부분 시작 -->
      <input type="hidden" name="rowCount" value="${ rowCount  }">
  <input type="hidden" name="main_count" value="${ maiCount  }">
  <input type="hidden" name="hdn_gubun"   value="">
<input type="hidden" name="hdn_deptId"  value="${deptId}">
<input type="hidden" name="hdn_deptNm"  value="${deptNm}">
<input type="hidden" name="hdn_excel"   value="">
<input type="hidden" name="I_SEARCHDATA"  value="${I_SEARCHDATA }">
<input type="hidden" name="retir_chk"  value="">
<input type="hidden" name="I_GUBUN"  value="2">
<input type="hidden" name="I_VALUE1"  value="">
<input type="hidden" name="txt_deptNm"  value="">

<!-- HIDDEN  처리해야할 부분 끝   -->

<!-------hidden------------>
    </tags-approval:request-layout>
</tags:layout>