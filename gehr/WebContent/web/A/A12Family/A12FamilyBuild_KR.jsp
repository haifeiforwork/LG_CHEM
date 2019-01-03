<%--@elvariable id="personData2" type="hris.common.PersonData"--%>
<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 가족사항 추가입력                                           */
/*   Program Name : 가족사항 추가입력                                           */
/*   Program ID   : A12FamilyBuild.jsp                                          */
/*   Description  : 가족사항 신청을 수정할 수 있도록 하는 화면                  */
/*   Note         :                                                             */
/*   Creation     : 2002-01-28  김도신                                          */
/*   Update       : 2005-02-21  윤정현                                          */
/*                     2015-12-16  이지은 [CSR ID:2940514] 경조금 신청화면 안내팝업 등록요청       */
/*						2017-10-26  eunha [CSR ID:3514907] HR Portal 內 자녀 개명에 따른 ERP 반영 시스템 개선 요청
/*					    2017-10-31  eunha [CSR ID:3517738] 실명인증 버튼 위치 수정요청의 건
/*  					2018-01-03  cykim  [CSR ID:3569665] 2017년 연말정산 웹화면 수정 요청의 건*/
/*                     2018-05-14 rdcamel @console 삭제 */
/********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="com.sns.jdf.util.DataUtil" %>
<%@ page import="com.sns.jdf.util.SortUtil" %>
<%@ page import="com.sns.jdf.util.WebUtil" %>
<%@ page import="hris.A.A04FamilyDetailData" %>
<%@ page import="hris.A.A12Family.A12FamilyListData" %>
<%@ page import="hris.A.A12Family.rfc.A12FamilyNationRFC" %>
<%@ page import="hris.A.A12Family.rfc.A12FamilyRelationRFC" %>
<%@ page import="hris.A.A12Family.rfc.A12FamilyScholarshipRFC" %>
<%@ page import="hris.A.A12Family.rfc.A12FamilySubTypeRFC" %>
<%@ page import="hris.A.A12Family.rfc.A12FamilyAusprRFC"%>
<%@ page import="hris.common.PersonData" %>
<%@ page import="org.apache.commons.lang.StringUtils" %>
<%@ page import="java.util.Vector" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<%@ taglib prefix="tags-approval" tagdir="/WEB-INF/tags/approval" %>

<%
    WebUserData user = (WebUserData)session.getValue("user");

    Vector a04FamilyDetailData_vt = (Vector)request.getAttribute("a04FamilyDetailData_vt");
    String PERNR = (String)request.getAttribute("PERNR");
    String SCREEN = (String)request.getAttribute("SCREEN");
    PersonData PERNR_Data = (PersonData)request.getAttribute("personData2");

    A04FamilyDetailData a04FamilyDetailData = (A04FamilyDetailData) request.getAttribute("a04FamilyDetailData");
    if(a04FamilyDetailData == null) a04FamilyDetailData = new A12FamilyListData();
    DataUtil.fixNull(a04FamilyDetailData);

    Boolean isUpdate = (Boolean) request.getAttribute("isUpdate");
    isUpdate = isUpdate == null ? false : isUpdate;

    // 2015- 06-08 개인정보 통합시 subView ="Y";
    String subView = WebUtil.nvl(request.getParameter("subView"));
%>
<jsp:include page="/include/header.jsp" />
<script language="JavaScript">
    <!--
    function doBuild() {
        if( check_data() ) {
            document.form1.jobid.value = "create";

            // 관계, 학력, 출생국, 국적명을 가져간다.
            try {
                document.form1.STEXT.value = document.form1.SUBTY.options[document.form1.SUBTY.selectedIndex].text;
            } catch(e) {}
            document.form1.ATEXT.value  = document.form1.KDSVH.options[document.form1.KDSVH.selectedIndex].text;
            document.form1.STEXT1.value = document.form1.FASAR.options[document.form1.FASAR.selectedIndex].text;
            document.form1.LANDX.value  = document.form1.FGBLD.options[document.form1.FGBLD.selectedIndex].text;
            document.form1.NATIO.value  = document.form1.FANAT.options[document.form1.FANAT.selectedIndex].text;
            document.form1.REGNO.disabled = 0;
            document.form1.LNMHG.disabled = 0;
            document.form1.FNMHG.disabled = 0;
            document.form1.KDBSL.disabled = 0;

            document.form1.jobid.value = "${isUpdate ? 'change' : 'create'}";
            document.form1.action = '${g.servlet}hris.A.A12Family.${isUpdate ? 'A12FamilyChangeSV' : 'A12FamilyBuildSV'}';

            document.form1.target = "";
            document.form1.method = "post";
            document.form1.submit();
        }
    }

    function check_data(){
        //if( checkNull(document.form1.LNMHG, "성(한글)을") == false ) {
        if( checkNull(document.form1.LNMHG, "<%=g.getMessage("MSG.A.A12.0004")%>") == false ) {
            return false;
        }
        // 성(한글)-40 입력시 길이 제한
        x_obj = document.form1.LNMHG;
        xx_value = x_obj.value;
        if( xx_value != "" && checkLength(xx_value) > 40 ){
            x_obj.value = limitKoText(xx_value, 40);
            //alert("성은 한글 20자 이내여야 합니다.");
            alert("<spring:message code='MSG.A.A12.0001' />");
            x_obj.focus();
            x_obj.select();
            return false;
        }

        // if( checkNull(document.form1.FNMHG, "이름(한글)을") == false ) {
        if( checkNull(document.form1.FNMHG, "<spring:message code='MSG.A.A12.0001' />") == false ) {
            return false;
        }
        // 이름(한글)-40 입력시 길이 제한
        x_obj = document.form1.FNMHG;
        xx_value = x_obj.value;
        if( xx_value != "" && checkLength(xx_value) > 40 ){
            x_obj.value = limitKoText(xx_value, 40);
            //alert("이름은 한글 20자 이내여야 합니다.");
            alert("<spring:message code='MSG.A.A12.0002' />");
            x_obj.focus();
            x_obj.select();
            return false;
        }

        if( $("#SUBTY").val()=='' ) {
            //alert("가족유형을 선택하세요.");
            alert("<spring:message code='MSG.A.A12.0003' />");
            document.form1.SUBTY.focus();
            return false;
        }

        // if( checkNull(document.form1.REGNO, "주민등록번호를") == false ) {
        if( checkNull(document.form1.REGNO, "<spring:message code='MSG.A.A12.0006' />") == false ) {
            return false;
        }

        if( $("#SUBTY").val() != '') {   // 배우자일경우 현재 사원과 같은 성별이면 에러메시지..
            if( document.form1.SUBTY.value == "1" ) {
                chk_bit = "${fn:substring(personData2.e_REGNO, 6, 7)}";

                regno_bit = document.form1.REGNO.value;
                if( chk_bit == "1" || chk_bit == "3" || chk_bit == "5" || chk_bit == "7" || chk_bit == "9" ) {
                    if( regno_bit.substring(7, 8) == "1" || regno_bit.substring(7, 8) == "3" || regno_bit.substring(7, 8) == "5" || regno_bit.substring(7, 8) == "7" || regno_bit.substring(7, 8) == "9" ) {
                        //alert("배우자의 성별이 본인의 성별과 같아서는 안됩니다.");
                        alert("<spring:message code='MSG.A.A12.0008' />");

                        return false;
                    }
                } else if( chk_bit == "2" || chk_bit == "4" || chk_bit == "6" || chk_bit == "8" || chk_bit == "0" ) {
                    if( regno_bit.substring(7, 8) == "2" || regno_bit.substring(7, 8) == "4" || regno_bit.substring(7, 8) == "6" || regno_bit.substring(7, 8) == "8" || regno_bit.substring(7, 8) == "0" ) {
                        //alert("배우자의 성별이 본인의 성별과 같아서는 안됩니다.");
                        alert("<spring:message code='MSG.A.A12.0008' />");

                        return false;
                    }
                }
            }
        }

        if( document.form1.KDSVH.selectedIndex==0 ) {
            //alert("관계를 선택하세요.");
            alert("<spring:message code='MSG.A.A12.0010' />");
            document.form1.KDSVH.focus();
            return false;
        }

        //if( checkNull(document.form1.FGBDT, "생년월일을") == false ) {
        if( checkNull(document.form1.FGBDT, "<spring:message code='MSG.A.A12.0011' />") == false ) {
            return false;
        }

        // 출생지-40 입력시 길이 제한
        x_obj = document.form1.FGBOT;
        xx_value = x_obj.value;
        if( xx_value != "" && checkLength(xx_value) > 40 ){
            x_obj.value = limitKoText(xx_value, 40);
            //alert("출생지는 한글 20자, 영문 40자 이내여야 합니다.");
            alert("<spring:message code='MSG.A.A12.0012' />");
            x_obj.focus();
            x_obj.select();
            return false;
        }

        //if( document.form1.FASAR.selectedIndex==0 ) {
        //  alert("학력을 선택하세요.");
        //  document.form1.FASAR.focus();
        //  return false;
        //}

        if( document.form1.FGBLD.selectedIndex==0 ) {
            //alert("출생국을 선택하세요.");
            alert("<spring:message code='MSG.A.A12.0023' />");
            document.form1.FGBLD.focus();
            return false;
        }

        // 교육기관-20 입력시 길이 제한
        x_obj = document.form1.FASIN;
        xx_value = x_obj.value;
        if( xx_value != "" && checkLength(xx_value) > 20 ){
            x_obj.value = limitKoText(xx_value, 20);
            //alert("교육기관은 한글 10자, 영문 20자 이내여야 합니다.");
            alert("<spring:message code='MSG.A.A12.0013' />");
            x_obj.focus();
            x_obj.select();
            return false;
        }

        // 교육기관명 체크. 2005.3.25. mkbae.
        var val = document.form1.FASAR.options[document.form1.FASAR.selectedIndex].value;
        if(val=='B1'||val=='C1'){
            if(xx_value==""||xx_value == null){
                //alert("교육기관명을 입력해주십시오.");
                alert("<spring:message code='MSG.A.A12.0014' />");
                x_obj.focus();
                return false;
            }
        }

        if( document.form1.FANAT.selectedIndex==0 ) {
            //alert("국적을 선택하세요.");
            alert("<spring:message code='MSG.A.A12.0015' />");
            document.form1.FANAT.focus();
            return false;
        }

        // 직업-24 입력시 길이 제한
        x_obj = document.form1.FAJOB;
        xx_value = x_obj.value;
        if( xx_value != "" && checkLength(xx_value) > 24 ){
            x_obj.value = limitKoText(xx_value, 24);
            //alert("직업은 한글 12자, 영문 24자 이내여야 합니다.");
            alert("<spring:message code='MSG.A.A12.0016' />");
            x_obj.focus();
            x_obj.select();
            return false;
        }

        // 생년월일
        document.form1.FGBDT.value = removePoint(document.form1.FGBDT.value);
        // 성별..
        if( document.form1.FASEX1.checked == true ) {
            document.form1.FASEX.value = "1";
        } else if( document.form1.FASEX2.checked == true ) {
            document.form1.FASEX.value = "2";
        }


        return true;
    }

    function resno_chk(obj){
        if( chkResnoObj_1(obj) == false ) {
            obj.focus();
            return false;
        }
        <%
            for ( int i = 0 ; i < a04FamilyDetailData_vt.size() ; i++ ) {
                A04FamilyDetailData data = (A04FamilyDetailData)a04FamilyDetailData_vt.get(i);
        %>
        if( "<%= DataUtil.addSeparate(data.REGNO) %>" == obj.value ) {
            alert("<spring:message code='MSG.A.A12.0017'/>"); //주민번호가 이미 등록되어 있습니다.
            obj.value = "";
            //obj.focus();
            obj.select();
            return false;
        }
        <%
            }
        %>
//  -----------------------------------------------------------------------------------------------------------

        // 생년월일..
        if( obj.value != ""){
            birthday = getBirthday(document.form1.REGNO.value)
            document.form1.FGBDT.value = birthday.substring(0, 4) + "." + birthday.substring(4, 6) + "." + birthday.substring(6, 8);
        }

        // 성별..
        if( obj.value != "" ){
            regno_bit = document.form1.REGNO.value;
            if( regno_bit.substring(7, 8) == "1" || regno_bit.substring(7, 8) == "3" || regno_bit.substring(7, 8) == "5" || regno_bit.substring(7, 8) == "7"|| regno_bit.substring(7, 8) == "9" ) {
                document.form1.FASEX1.checked = true;
                document.form1.FASEX2.checked = false;
            } else if( regno_bit.substring(7, 8) == "2" || regno_bit.substring(7, 8) == "4" || regno_bit.substring(7, 8) == "6" || regno_bit.substring(7, 8) == "8"|| regno_bit.substring(7, 8) == "0" ) {
                document.form1.FASEX1.checked = false;
                document.form1.FASEX2.checked = true;
            }
        }

    }

    // 2005.3.25. mkbae.
    function scha_Check(obj){
        var val = obj[obj.selectedIndex].value;
        var doc = document.all;
        doc.FASIN.value = "";
        doc.FASIN.focus();
        if(val=='B1'||val=='C1'){
            //doc.scha.innerHTML='교육기관&nbsp;<font color=\"#0000FF\"><b>*</b></font>';
            doc.scha.innerHTML='<spring:message code="LABEL.A.A12.0014" />&nbsp;<font color=\"#0000FF\"><b>*</b></font>';
        } else {
            //doc.scha.innerHTML='교육기관';
            doc.scha.innerHTML='<spring:message code="LABEL.A.A12.0014" />';
        }
    }
    function reload() {
        frm =  document.form1;
        frm.jobid.value = "first";
        frm.action = "<%= WebUtil.ServletURL %>hris.A.A12Family.A12FamilyBuildSV";
        frm.target = "";
        frm.submit();
    }

    function subty_action(obj) {//[CSR ID:3569665]
        if ($("#SUBTY").val() =="2" ) {
            $("#form1 input[name=LNMHG], #form1 input[name=FNMHG], #form1 input[name=REGNO], #form1 select[name=KDBSL]").prop("disabled", false);
            $("#NameCheck").hide();
            //$("#children").show();
        } else {
            $("#form1 input[name=LNMHG], #form1 input[name=FNMHG], #form1 input[name=REGNO], #form1 select[name=KDBSL]").prop("disabled", true);
            $("#NameCheck").show();
            //$("#children").hide();
        }

        $("#KDSVH").empty()
                .append("<option value=''>---------------</option>");
        $("#KDBSL").empty()
        		.append("<option value=''>---------------</option>");


        ajaxPost("${g.servlet}hris.A.A12Family.A12FamilySubTypeAjax", {SUBTY : obj.value}, function(data) {
            _.each(data.resultList, function(row) {
                $("#KDSVH").append($("<option/>").val(row.code).text(row.value));
            })

        });
        
        //자녀 순위 조회
        ajaxPost("${g.servlet}hris.A.A12Family.A12FamilySubType2Ajax", {}, function(data) {
            _.each(data.resultList2, function(row) {
                $("#KDBSL").append($("<option/>").val(row.code).text(row.value));
            })

        });
    }

    function kdsvh_action(obj){//[CSR ID:3569665] 자녀 일 경우, 생년월일과 성별이 자동 세팅될 수 있도록 함.
    	if ($("#SUBTY").val() =="2" ) {
			if($("#KDSVH").val() == "05"){
				$("#FASEX1").checked = true;	
			}else if($("#KDSVH").val() == "06"){
				$("#FASEX2").checked = true;
			}
			resno_chk( document.form1.REGNO);
        }
    }

    function do_NameCheck() {

        var URL ="<%=WebUtil.JspURL%>A/A12Family/nc.jsp";
        var status = "toolbar=no,directories=no,scrollbars=no,resizable=no,status=no,menubar=no, width= 640, height= 530, top=0,left=20";
        //ret = window.showModalDialog(URL, window, status);
        window.open(URL,"",status);
    }
    //@csr 주민번호실명인증
    function JuminSetting(obj,name){
        //console.log(obj);//@console 삭제

        document.form1.REGNO.value = obj;
        document.form1.LNMHG.value = name.substring(0, 1);
        document.form1.FNMHG.value = name.substring(1, name.length);

        resno_chk( document.form1.REGNO);
    }

    //[CSR ID:2940514]
    function dontClick(type){

        if ($("#SUBTY").val() !="2" ) {
            if (type == "1") {
                //alert("성명은 주민등록번호 인증 이후 자동 입력됩니다.\n주민등록번호 옆 입력버튼을 누르시기 바랍니다.");
                alert("<spring:message code='MSG.A.A12.0019' />");
            } else if (type == "2") {
                //alert("주민등록번호는 우측 입력버튼을 통해 입력하시기 바랍니다.");
                alert("<spring:message code='MSG.A.A12.0020' />");
            }
        }
    }

    function do_preview(){
        document.form1.action = "<%= WebUtil.ServletURL %>hris.A.A04FamilyDetailSV";
        document.form1.method = "post";
        document.form1.submit();
    }



    $(function() {
        //document.scroll.top
    });


    //-->
</script>
<%-- html body 안 헤더부분 - 타이틀 등 --%>
<jsp:include page="/include/body-header.jsp">
    <jsp:param name="title" value="<%=isUpdate ? "LABEL.A.A12.0021" : "LABEL.A.A12.0011" %>"/>
</jsp:include>

<form id="form1" name="form1" method="post">
    <input type="hidden" id="PERNR" name="PERNR" value="<%=PERNR%>">

    <c:if test="${user.e_representative == 'Y'}">
        <jsp:include page="/web/common/includeSearchDeptPersons.jsp"/>
    </c:if>

    <!-- 상단 입력 테이블 시작-->
    <h2 class="subtitle"><!-- 대상자는 필수 입력사항입니다. --><spring:message code="MSG.A.A12.0021" /></h2>

    <div class="tableArea">
        <div class="table">
            <table class="tableGeneral">
                <colgroup>
                    <col width="15%"/>
                    <col width="35%"/>
                    <col width="15%"/>
                    <col width="35%"/>
                </colgroup>
<%  if(isUpdate != true)  { %>
                <tr>
                    <th width="100"><span class="textPink">*</span><!--성명(한글) --><spring:message code="LABEL.A.A12.0001" /></th>
                    <td>
                        <%--[CSR ID:3517738] 실명인증 버튼 위치 수정요청의 건 start --%>
                        <a href="javascript:dontClick('1');" style="padding:0px"><input type="text" name="LNMHG"  size="6"  maxlength="40" disabled style="ime-mode:active"></a>
                        <a href="javascript:dontClick('1');"><input type="text" name="FNMHG"  disabled size="12" maxlength="40" style="ime-mode:active"></a>
                        <a id="NameCheck" href="javascript:do_NameCheck();" class="inlineBtn"><span><spring:message code="BUTTON.COMMON.INSERT" /><!-- 입력 --></span></a>
                        <%--[CSR ID:3517738] 실명인증 버튼 위치 수정요청의 건 end --%>
                    </td>
                    <th class="th02" width="100"><span class="textPink">*</span><!-- 가족유형 --><spring:message code="LABEL.A.A12.0002" /></th>
                    <td>
                        <select id="SUBTY" name="SUBTY" onChange="subty_action(this);">
                            <option value="">-------------</option>
                            <%
                                A12FamilySubTypeRFC rfc_List         = new A12FamilySubTypeRFC();
                                Vector A12FamilySubType_vt = null;
                                A12FamilySubType_vt = rfc_List.getFamilySubType();
                                for ( int i=0 ; i < A12FamilySubType_vt.size() ; i++ )
                                {
                                    com.sns.jdf.util.CodeEntity ck = (com.sns.jdf.util.CodeEntity)A12FamilySubType_vt.get(i);
                                    if (!ck.code.equals("15")) {
                            %>
                            <option value="<%=ck.code%>" ><%=ck.value%></option>
                            <%     }
                            } %>
                            <!--%= WebUtil.printOption((new A12FamilySubTypeRFC()).getFamilySubType()) %-->
                        </select>
                        <input type="hidden" name="OBJPS"  value="">
                        <input type="hidden" name="BEGDA"  value="<%= DataUtil.getCurrentDate() %>">
                        <input type="hidden" name="ENDDA"  value="99991231">
                    </td>
                </tr>
<%  } else { %>
                <tr>
                    <th width="100"><span class="textPink">*</span><spring:message code="LABEL.A.A12.0001" /><%--성명(한글)--%></th>
                    <td>
                        <input type="text" name="LNMHG" value="<%= a04FamilyDetailData.LNMHG %>" <%=a04FamilyDetailData.SUBTY.equals("2")? "":"disabled"%> size="6"  maxlength="40" style="ime-mode:active">
                        <input type="text" name="FNMHG" value="<%= a04FamilyDetailData.FNMHG %>" <%=a04FamilyDetailData.SUBTY.equals("2")? "":"disabled"%> size="12" maxlength="40" style="ime-mode:active">
                    </td>
                    <th class="th02" width="100"><span class="textPink">*</span><spring:message code="LABEL.A.A12.0002" /><%--가족유형--%></th>
                    <td>
                        <input type="text" name="STEXT" value="<%= a04FamilyDetailData.STEXT %>" size="20" readonly>
                        <input type="hidden" id="SUBTY"  name="SUBTY" value="<%= a04FamilyDetailData.SUBTY %>" >
                        <input type="hidden" name="OBJPS"  value="<%= a04FamilyDetailData.OBJPS %>">
                        <input type="hidden" name="BEGDA"  value="<%= WebUtil.printDate(a04FamilyDetailData.BEGDA) %>">
                        <input type="hidden" name="ENDDA"  value="<%= WebUtil.printDate(a04FamilyDetailData.ENDDA) %>">
                    </td>
                </tr>

<%  } %>
                <tr>
                    <th><!-- 주민등록번호 --><span class="textPink">*</span><spring:message code="LABEL.A.A12.0003" /></th>
                    <td>
<%  if(isUpdate != true)  { %>
						<%--[CSR ID:3517738] 실명인증 버튼 위치 수정요청의 건 --%>
                        <input type="text" disabled name="REGNO" size="20" maxlength="14" onchange="javascript:resno_chk(this);">
                        <%--[CSR ID:3517738] 실명인증 버튼 위치 수정요청의 건
                        <a id="NameCheck" href="javascript:do_NameCheck();" class="inlineBtn"><span><spring:message code="BUTTON.COMMON.INSERT" /><!-- 입력 --></span></a>
                         --%>
<%  } else { %>
                        <input type="password" name="REGNO" size="20" <%=a04FamilyDetailData.SUBTY.equals("2")? "":"disabled"%> value="<%= DataUtil.addSeparate(a04FamilyDetailData.REGNO) %>" size="20" maxlength="14" onchange="javascript:resno_chk(this);"></td>

<%  } %>
                    </td>
                    <th class="th02"><!-- 관계 --><span class="textPink">*</span><spring:message code="LABEL.A.A12.0004" /></th>
                    <td> <select id="KDSVH" name="KDSVH" onChange="kdsvh_action(this);">
                        <option value="">---------------</option>
                        <%= WebUtil.printOption((new A12FamilyRelationRFC()).getFamilyRelation(a04FamilyDetailData.SUBTY ), a04FamilyDetailData.KDSVH) %> </select>
                    </td>
                </tr>
                <tr>
                    <th><!-- 생년월일 --><span class="textPink">*</span><spring:message code="LABEL.A.A12.0005" /></th>
                    <td>
                        <input type="text" name="FGBDT" size="20" value="<%= a04FamilyDetailData.FGBDT.equals("0000-00-00") ? "" : WebUtil.printDate(a04FamilyDetailData.FGBDT) %>" readonly>
                        <!--<a href="javascript:fn_openCal('FGBDT')">
            <img src="<%= WebUtil.ImageURL %>btn_serch.gif" width="31" height="21" align="absmiddle" border="0" alt="날짜검색"></a>-->
                    </td>
                    <th class="th02"><!-- 성별 --><spring:message code="LABEL.A.A12.0006" /></th>
                    <td>
                        <input type="radio" name="FASEX1" value="1" <%= a04FamilyDetailData.FASEX.equals("1") ? "checked" : "" %> disabled>
                        <!--남  --><spring:message code="LABEL.A.A12.0019" />
                        <input type="radio" name="FASEX2" value="2" <%= a04FamilyDetailData.FASEX.equals("2") ? "checked" : "" %> disabled>
                        <!--여  --><spring:message code="LABEL.A.A12.0020" />
                    </td>
                </tr>
                <tr>
                    <th><!-- 출생지 --><spring:message code="LABEL.A.A12.0007" /></th>
                    <td> <input type="text" name="FGBOT" size="20" value="<%=a04FamilyDetailData.FGBOT %>" maxlength="40" style="ime-mode:active"></td>
                    <th class="th02"><!-- 학 력 --><spring:message code="LABEL.A.A12.0013" />&nbsp;</font></th>
                    <td> <select name="FASAR" onChange="javascript:scha_Check(this);">
                        <option value="">-------------</option>
                        <%= WebUtil.printOption((new A12FamilyScholarshipRFC()).getFamilyScholarship(), a04FamilyDetailData.FASAR) %> </select>
                    </td>
                </tr>
                <tr>
                    <th><!-- 출생국 --><spring:message code="LABEL.A.A12.0008" /></th>
                    <td> <select name="FGBLD" >
                        <option value="">-------------</option>
                        <%= WebUtil.printOption( SortUtil.sort( (new A12FamilyNationRFC()).getFamilyNation(), "value", "asc" ), StringUtils.defaultIfEmpty(a04FamilyDetailData.FGBLD, "KR")) %> </select>
                    </td>
                    <th class="th02" id="scha"><!-- 교육기관 --><spring:message code="LABEL.A.A12.0014" /></th>
                    <td><input type="text" name="FASIN"size="20" maxlength="20" style="ime-mode:active" value="<%=a04FamilyDetailData.FASIN%>"></td>
                </tr>
                <tr>
                    <th><!-- 국적 --><spring:message code="LABEL.A.A12.0009" /></th>
                    <td> <select name="FANAT">
                        <option value="">-------------</option>
                        <%--2017-10-26  eunha [CSR ID:3514907] HR Portal 內 자녀 개명에 따른 ERP 반영 시스템 개선 요청 --%>
                        <%= WebUtil.printOption( SortUtil.sort( (new A12FamilyNationRFC()).getFamilyNation(), "value", "asc" ), StringUtils.defaultIfEmpty(a04FamilyDetailData.FANAT, "KR")) %> </select> </td>
                        <%--<%= WebUtil.printOption( SortUtil.sort( (new A12FamilyNationRFC()).getFamilyNation(), "value", "asc" ), StringUtils.defaultIfEmpty(a04FamilyDetailData.FGBLD, "KR")) %> </select> </td>--%>
                    <th class="th02"><!-- 직업 --><spring:message code="LABEL.A.A12.0010" /></th>
                    <td> <input type="text" name="FAJOB" size="20" maxlength="24" value="<%=a04FamilyDetailData.FAJOB %>" style="ime-mode:active"></td>
                </tr>
                <!-- [CSR ID:3569665] 2017년 연말정산 웹화면 수정 요청의 건 start -->
                
                <tr id="children" >
                    <th><!--자녀순위 --><spring:message code="LABEL.A.A12.0051" /></th>
                    <td>
                    	<select  id=KDBSL name="KDBSL" <%=a04FamilyDetailData.SUBTY.equals("2")? "":"disabled"%>>
                        <option value="">-------------</option>                            
                         <%= WebUtil.printOption((new A12FamilyAusprRFC()).getFamilyAuspr( ), a04FamilyDetailData.KDBSL) %>    
                    	</select>
                    </td>
                    <th class="th02"></th>
                    <td> </td>
                </tr>
                               
                <!-- [CSR ID:3569665] 2017년 연말정산 웹화면 수정 요청의 건 end -->
            </table>
            <div class="commentsMoreThan2">
                <div><%--* 는 필수입력사항입니다. --%><spring:message code="MSG.E.E26.0002"/></div>
                <div><%--<span class="textPink">등록하는 자녀가 총 자녀인원 기준으로 몇번째 자녀</span>인지를 선택하시기 바랍니다. --%><spring:message code="LABEL.A.A12.0052" /></div><!--  [CSR ID:3569665] -->
            </div>
        </div>
    </div>

    <!--상단 입력 테이블 끝-->
    <div class="buttonArea underList">
        <ul class="btn_crud">
            <li><a href="javascript:;" onclick="doBuild();"><span><spring:message code="BUTTON.COMMON.SAVE" /><%--저장--%></span></a></li>
            <c:if test="${SCREEN != 'E19'}">
            <li><a href="javascript:;" onclick="do_preview();"><span><spring:message code="BUTTON.COMMON.LIST" /><%--목록--%></span></a></li>
            </c:if>
        </ul>
    </div>

    <!-- HIDDEN으로 처리 -->
    <%--includeSearchDeptPersons 에 있음--%>
    <c:if test="${user.e_representative != 'Y'}">
        <input type="hidden" name="jobid"  value="">
    </c:if>
    <input type="hidden" name="FASEX"  value="">
    <input type="hidden" name="STEXT"  value="">
    <input type="hidden" name="ATEXT"  value="">
    <input type="hidden" name="STEXT1" value="">
    <input type="hidden" name="LANDX"  value="">
    <input type="hidden" name="LANDX"  value="">
    <input type="hidden" name="NATIO"  value="">
    <input type="hidden" name="SCREEN"  value="<%=SCREEN%>">
    <!-- HIDDEN으로 처리 -->
    </div>
</form>
<iframe name="ifHidden" width="0" height="0" />

<jsp:include page="/include/body-footer.jsp" />
<jsp:include page="/include/footer.jsp" />