<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page import="java.util.Vector" %>
<%@ page import="hris.D.*" %>
<%@ page import="hris.D.rfc.*" %>
<%@ page import="hris.D.D11TaxAdjust.*" %>
<%@ page import="hris.D.D11TaxAdjust.rfc.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%@ page import="hris.common.*" %>

<!-- /* 					2018.01.04 cykim   [CSR ID:3569665] 2017년 연말정산 웹화면 수정 요청의 건  */ -->

<%
    WebUserData  user = (WebUserData)session.getAttribute("user");
    D00TaxAdjustPeriodRFC  periodRFC           = new D00TaxAdjustPeriodRFC();
    D00TaxAdjustPeriodData taxAdjustPeriodData = new D00TaxAdjustPeriodData();
    taxAdjustPeriodData = (D00TaxAdjustPeriodData)periodRFC.getPeriod(((WebUserData)session.getAttribute("user")).companyCode,((WebUserData)session.getAttribute("user")).empNo);

    String targetYear = ((TaxAdjustFlagData)session.getAttribute("taxAdjust")).targetYear;

    application.setAttribute("targetYear", targetYear);
    application.setAttribute("empNo", user.empNo);

    //2002.12.04. 연말정산 확정여부 조회
    String o_flag = "";
    D11TaxAdjustYearCheckRFC rfc_o = new D11TaxAdjustYearCheckRFC();
    o_flag = rfc_o.getO_FLAG( user.empNo, targetYear );

    //2002.12.03 내역조회가 가능한지 날짜를 체크한다.
    String currentDate = DataUtil.getCurrentDate();
    int appl_from = DataUtil.getBetween(currentDate, DataUtil.removeStructur(taxAdjustPeriodData.APPL_FROM,"-"));
    int appl_toxx = DataUtil.getBetween(currentDate, DataUtil.removeStructur(taxAdjustPeriodData.APPL_TOXX,"-"));
    int disp_from = DataUtil.getBetween(currentDate, DataUtil.removeStructur(taxAdjustPeriodData.DISP_FROM,"-"));
    int disp_toxx = DataUtil.getBetween(currentDate, DataUtil.removeStructur(taxAdjustPeriodData.DISP_TOXX,"-"));
    String Gubn = "PDF";
    //세대주여부
    //D11TaxAdjustHouseEssentialChkRFC HouseEChkRFC           = new D11TaxAdjustHouseEssentialChkRFC();
    //String E_CHECK = HouseEChkRFC.getYn( user.empNo,targetYear);

    //PDF 데이터를 지워줘야함
    application.removeAttribute(session.getId());
    application.removeAttribute("msg");
%>

<jsp:include page="/include/header.jsp" />
<script language="JavaScript" src="uploadFile.js"></script>

<script language="JavaScript">
<!--
    function checkForm(){
        var objectTags = document.getElementsByTagName('object');
        var movie;

        //global hr portal 통해서 접속 시 id 충돌 발생으로 인해 소스 수정
        //document.getElementById(objectTags[0].getAttribute("id")) => document.getElementById("smu03")
        if(document.getElementById("smu03")) {
            movie = document.getElementById("smu03");
        }else{
            movie = document.getElementById("smu03");
        }

        if(movie.GetVariable("totalSize")==0){
            alert("<spring:message code='MSG.D.D11.0101' />"); //[파일선택] 버튼을 클릭하시고 업로드할 파일을 선택하세요.
            return;
        }

        //이미 체크되어 있을 경우 체크 해제할 수 없다.

        //if (document.form1.FSTID.value=="X" && document.form1.FSTID.checked != true) {
            // alert("다른 화면에서 입력한 주택자금 관련 공제항목이 있으니 세대주가 맞는지 확인 후 [세대주 여부]에 체크하시기 바랍니다.");
            // return;
            //}

        if(document.form1.FSTID.checked){
            document.form1.FSTID.value = "X";
        } /*else {
            if(confirm("세대주가 아니면 공제대상에서 제외되는 항목이 있습니다.\n세대주가 맞는지 확인 후 세대주일 경우 [확인]을 클릭하시고 세대주가 아닐 경우 [취소]를 클릭하세요.\n[취소]를 클릭하실 경우 일부 항목이 연말정산 공제대상에 포함되지 않을 수 있습니다.")){
                document.form1.FSTID.checked = true;
                document.form1.FSTID.value = "X";

            } else {
                document.form1.FSTID.checked = false;
                document.form1.FSTID.value = "";

            }
        }@2015 연말정산 사용자들 혼동에 의해 오입력이 많아 빼버림*/

            document.form1.target = "hiddenFrame";
            window.onbeforeunload = null;
            setTimeout(setBeforeUnload, 1000);
            callSwfUpload('form1');
            toggleAnchor();//[CSR ID:3569665]
    }

//[CSR ID:3569665]
function toggleAnchor() {
    var o = document.getElementById("saveBtn");
    // disabled 상태 변경
    o.disabled = !o.disabled;
    if (o.disabled) {
        // 링크 제거(텍스트만 남김), o.innerText 대신 "" 를 대입하면 텍스트도 표시안됨
        o.innerHTML = "";
    } else {
        // 링크 복원
        o.innerHTML = o.getAttribute("sLink");
    }
}


    function resetAll(){
         location.href = "<%= WebUtil.JspPath %>upload/D11TaxAdjust/upload.jsp";
    }

    function batchGo(){
        location.href = "<%= WebUtil.JspPath %>upload/D11TaxAdjust/upload_new.jsp";

    }


//-->
</script>

 <jsp:include page="/include/body-header.jsp">
        <jsp:param name="click" value="Y"/>
 </jsp:include>
<form name="form1" method="post" action="pro.jsp" >
<input type="hidden" name="unblock"  value="true">


<input type="hidden" name="jobid"  value="">
<!-- <pre>  -->
    <%@ include file="../../D/D11TaxAdjust/D11TaxAdjustButton.jsp" %>
<input type="hidden" name="E_HOLD"  value="<%=E_HOLD%>">
    <div class="commentsMoreThan2">
    	<!-- @2016연말정산 -->
        <div><span class="textPink"><spring:message code="LABEL.D.D11.0282" /><!-- PDF 업로드를 하게 되면 기존에 PDF업로드로 반영한 모든 데이타가 삭제  되오니 이점 주의  하시기 바랍니다. --></span></div>
		<!-- [CSR ID:3569665] @2017 연말정산 문구 추가 -->
		<div><span class="textPink">연금/저축공제 신청자가 세대주 이신 경우, [인적공제] 탭에서 세대주 여부 저장 하신 뒤, PDF 업로드를 진행해 주시기 바랍니다. 미체크시 미반영됩니다.</span></div>
    </div>
    <div class="tableArea">
        <div class="table">
            <table class="tableGeneral">
                <tr>
                    <th><spring:message code="LABEL.D.D11.0263" /><!-- 파일 업로드 --></th>
                    <td>
                        <script language="javascript">
                            makeSwfMultiUpload(
                                movie_id='smu03', //파일폼 고유ID
                                flash_width='500', //파일폼 너비 (기본값 400, 권장최소 300)
                                list_rows='10', // 파일목록 행 (기본값:3)
                                limit_size='30', // 업로드 제한용량 (기본값 10)
                                file_type_name='PDF 파일', // 파일선택창 파일형식명 (예: 그림파일, 엑셀파일, 모든파일 등)
                                allow_filetype='*.pdf', // 파일선택창 파일형식 (예: *.jpg *.jpeg *.gif *.png)
                                deny_filetype='*.cgi *.pl', // 업로드 불가형식
                                upload_exe='up.jsp', // 업로드 담당프로그램
                                browser_id='<%=session.getId()%>'
                            );
                        </script>
                    </td>
                    <td valign="top" style="width:320px;">

                        <table class="innerTable" cellspacing="0">
                            <tr>
                                <th class="noRtBorder"><span class="textPink"><spring:message code="LABEL.D.D11.0264" /><!-- [파일 업로드 시 주의사항] --></span></th>
                            </tr>
                            <tr>
                                <td   style="text-align:left;border-bottom: 0px">
                                <spring:message code="LABEL.D.D11.0265" /><!-- 1. 국세청 PDF 파일만 업로드하실 수 있습니다. --><br/>&nbsp;&nbsp;&nbsp;
                                <spring:message code="LABEL.D.D11.0266" arguments="<%=targetYear %>" /><%-- (ex. 홍길동(700101)-<%=targetYear %>년자료(신용카드).pdf) --%><!-- @2015 연말정산 -->
                                </td>
                            </tr>
                            <tr>
                                <td style="text-align:left;border-bottom: 0px">
                                <spring:message code="LABEL.D.D11.0267" /><!-- 2. 파일에 비밀번호가 설정된 경우 업로드가 불가능 --><br/>&nbsp;&nbsp;&nbsp;
                                <spring:message code="LABEL.D.D11.0268" /><!-- 하니 국세청에서 <span class="textPink">비밀번호 설정을 해제</span>한 후 파일 --><br/>&nbsp;&nbsp;&nbsp;
                                <spring:message code="LABEL.D.D11.0269" /><!-- 을 다시 다운로드하셔야 합니다. -->
                                </td>
                            </tr>
                            <tr>
                                <td class="noRtBorder" style="text-align:left;border-bottom: 0px">
								<spring:message code="LABEL.D.D11.0270" /><!-- 3. 파일 업로드 시 연말정산 공제에 반영 처리되며 --><br/>&nbsp;&nbsp;&nbsp;
                                <spring:message code="LABEL.D.D11.0271" /><!-- 연말정산 기간 내에 파일을 다시 업로드 하게 되면 --><br/>&nbsp;&nbsp;&nbsp;
                                <spring:message code="LABEL.D.D11.0272" /><!-- <span class="textPink">이전 자료는 삭제</span>되고 업로드한 파일로 반영됩니다. -->
                                </td>
                            </tr>
                            <tr>
                                <td class="noRtBorder" style="text-align:left;border-bottom: 0px">
                                <spring:message code="LABEL.D.D11.0273" /><!-- 4. 파일 업로드 후 아래의 [처리결과]에서 연말정산 --><br/>&nbsp;&nbsp;&nbsp;
                               <spring:message code="LABEL.D.D11.0274" /><!--  반영내역을 확인하실 수 있습니다. -->
                                </td>
                            </tr>
                            <tr>
                                <td class="noRtBorder noBtBorder" style="text-align:left">
                                <spring:message code="LABEL.D.D11.0275" /><!-- 5. 파일을 다시 업로드해야 할 경우 아래의 [새로고침] --><br/>&nbsp;&nbsp;&nbsp;
                               <spring:message code="LABEL.D.D11.0276" /><!--  버튼을 클릭하세요. --><br/>&nbsp;&nbsp;&nbsp;
                                <spring:message code="LABEL.D.D11.0277" /><!-- 단, 클릭시 이전 [처리결과]는 보이지 않게 됩니다. -->
                                </td>
                            </tr>
                        </table>

                    </td>
                </tr>

                <tr>
                    <th><spring:message code="LABEL.D.D11.0278" /><!-- 처리결과 --></th>
                    <td id="resultTd" style="text-align:left;height:40px" colspan="2"></td>
                </tr>

<%
    if(  !o_flag.equals("X") ) {
%>
                <tr height = "40">
                    <td colspan="3">
                        <div class="buttonArea">
                            <ul class="btn_crud">
                                <li><a class="darken unloading" href="javascript:;" id="saveBtn" onclick="checkForm();" ><span><spring:message code="LABEL.D.D11.0279" /><!-- 파일저장 --></span></a></li>
                                <li><a href="javascript:resetAll();"><span><spring:message code="LABEL.D.D11.0280" /><!-- 새로고침 --></span></a></li>
<%
    if( "X00204304".equals( (String)user.empNo )){    // 연말정산 담당자. 홍이나 주임만 일괄업로드 버튼이 보임
%>
                                <li><a href="javascript:;"  onclick="batchGo();" ><span><spring:message code="LABEL.D.D11.0281" /><!-- 다음 --></span></a></li>
<% }  %>
                            </ul>
                        </div>
                    </td>
                </tr>
<%
    }
%>

            </table>
        </div>
    </div>

 <!-- </pre>  -->
 <!--업로드프로세스를 hiddenFrame에 호출  -->
 <iframe name="hiddenFrame" width="0" height="0"></iframe>

</form>
<jsp:include page="/include/body-footer.jsp" /> <!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/>       <!-- html footer 부분 -->