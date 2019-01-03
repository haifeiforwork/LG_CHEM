<%/******************************************************************************/
/*																				*/
/*   System Name  : MSS															*/
/*   1Depth Name  : 신청															*/
/*   2Depth Name  : 부서근태														*/
/*   Program Name : 사원지급정보 등록												*/
/*   Program ID   : D15EmpPayInfo|D15EmpPayInfo.jsp								*/
/*   Description  : 사원지급정보 등록 화면											*/
/*   Note         : 															*/
/*   Creation     : 2009-04-01 김종서												*/
/*   Update       : 															*/
/*																				*/
/********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="tags-common" tagdir="/WEB-INF/tags/common" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="user" value="<%=WebUtil.getSessionUser(request)%>"/>

<tags:layout title="COMMON.MENU.ESS_HRA_REME_INFO">
    <tags:script>
        <script language="JavaScript">
            <!--

            $(function() {
                $("select[name=LGART]").change();

            });

            function setDeptID(deptId, deptNm){
                frm = document.form1;

                $("#I_SEARCHDATA").val(deptId);
                $("#searchDeptNm").val(deptNm);
                search();
            }

            // 저장
            function doSaveData() {
                if(check_data()) {
                    document.form1.I_DATE.value  = removePoint(document.form1.I_DATE.value);
                    document.form1.jobid.value = "save";
                    document.form1.action = "${g.servlet}hris.D.D15EmpPayInfo.D15EmpPayInfoSV";
                    document.form1.method = "post";
                    document.form1.submit();
                }
            }

            function check_data(){

                if(!confirm('<spring:message code="MSG.D.D15.0017" />')){  //저장 하시겠습니까?
                    return false;
                }

                return true;
            }

            function search() {
                document.form1.jobid.value   = "search";

                document.form1.action = "${g.servlet}hris.D.D15EmpPayInfo.D15EmpPayInfoSV";
                document.form1.target = "";
                document.form1.submit();
            }

            function selectPayType(obj){
                var _$obj = $(obj)
                var _kombi = _$obj.data("kombi");

                if(_kombi == "1") { //금액
                    _$obj.siblings("input[name=ANZHL]").prop("disabled", true).val("").andSelf()
                        .siblings("input[name=BETRG]").prop("disabled", false);
                } else if(_kombi=="2") {//시간
                    _$obj.siblings("input[name=ANZHL]").prop("disabled", false).andSelf()
                            .siblings("input[name=BETRG]").prop("disabled", true).val("");
                } else if(_kombi=="3") {//시간,금액 disalbe
                    _$obj.siblings("input[name=ANZHL]").prop("disabled", true).val("").andSelf()
                            .siblings("input[name=BETRG]").prop("disabled", true).val("");
                }
            }

            function do_delete(){
                if($("input[name=deleteCheck]").length == 0){
                    alert('<spring:message code="MSG.D.D15.0018" />'); //삭제할 정보를 선택하세요.
                    return;
                }

                document.deleteForm.jobid.value   = "del";
                document.deleteForm.action = "${g.servlet}hris.D.D15EmpPayInfo.D15EmpPayInfoSV";
                document.deleteForm.method        = "post";
                document.deleteForm.submit();

            }

            function setPersInfo( obj ){
                frm = document.all.form1;
                var urlName = frm.urlName.value;
                frm.I_SEARCHDATA.value = obj.OBJID;
                // 하위조직포함이고 LG Chem(50000000) 은 데이타가 많아서 막음. - 2005.03.30 윤정현
                if ( obj.OBJID == "50000000" && frm.chk_organAll.checked == true ) {
                    //alert("선택하신 조직은 데이터가 너무 많습니다. \n\n하위조직을 선택하여 조회하시기 바랍니다.   ");
                    alert("<spring:message code="MSG.F.F41.0003"/>");
                    return;
                }
                document.form1.txt_deptNm.value = obj.STEXT;
                search();
            }

            $(function() {
                $(".money2").autoNumeric({vMin: '0', vMax: '999999'}).css('textAlign', 'right');
            });
            -->
        </script>
    </tags:script>
    <form id="form1" name="form1" method="post" onsubmit="return false">

    <%-- 부서찾기 공통 --%>
        <div>
    <tags-common:search-dept-layout deptId="${I_SEARCHDATA}" deptNm="${param.txt_deptNm}" disabledSubOrg="true"  deptTimelink="true"/>
        <div class="listTop">
            <h2 class="subtitle withButtons"><!--부서명--><spring:message code="LABEL.F.F41.0002"/> : ${empty param.txt_deptNm? user.e_obtxt : param.txt_deptNm}</h2>
            <div class="buttonArea">
                <input type="text" name="I_DATE" class="date" value="${f:printDate(I_DATE)}"  >
                <input type="hidden" id="I_SEARCHDATA" name="I_SEARCHDATA" value="${I_SEARCHDATA}"/>
                <input type="hidden" name="urlName" value="">
                <input type="hidden" name="I_VALUE1"  value="">
                <input type="hidden" name="retir_chk"  value="">
                <input type="hidden" id="jobid" name="jobid" />

                <ul class="btn_mdl displayInline" style="margin-left: 10px;">
                    <li onclick="search()"><a href="javascript:;" class="search"><span><spring:message code="BUTTON.COMMON.SEARCH"/><%-- 조회 --%></span></a></li>
                </ul>
            </div>
        </div>
        <div class="table">
            <table class="listTable">
                <thead>
                <tr>
                	<th><spring:message code="LABEL.D.D12.0017" /><%-- 사원번호 --%></th>
                    <th><spring:message code="MSG.APPROVAL.0013" /><%-- 성명 --%></th>
                    <th><spring:message code="LABEL.D.D15.0206" /><%-- 일자 --%></th>
                    <th><spring:message code="LABEL.D.D08.0004" /><%-- 임금유형 --%></th>
                    <th><spring:message code="LABEL.D.D19D.0004" /><%-- 시간 --%></th>
                    <th class="lastCol" width="*"><spring:message code="LABEL.D.D05.0015" /><%-- 금액 --%></th>
                </tr>
                </thead>
                <tbody>
                    <%--@elvariable id="payList" type="java.util.Vector<hris.D.D15EmpPayInfo.D15EmpPayInfoData>"--%>
                <%--@elvariable id="saveList" type="java.util.Vector<hris.D.D15EmpPayInfo.D15EmpPayInfoData>"--%>
                    <%--@elvariable id="payTypeMap" type="java.util.Map<String, java.util.Vector<hris.D.D15EmpPayInfo.D15EmpPayTypeData>>"--%>
                <c:forEach  var="row" items="${payList}" varStatus="status">
                    <c:set var="payTypeList" value="${payTypeMap[row.PERNR]}"/>
                    <tr id="-pay-row-${status.index}" class="${f:printOddRow(status.index)}">
                        <td>${row.PERNR }</td>
                        <td>${row.ENAME }</td>
                        <td>${row.BEGDA }</td>
                        <td>
                            <select name="LGART" onchange="selectPayType(this);">
                                <c:if test="${empty payTypeList}">
                                    <option value="">-----------</option>
                                </c:if>
                                <c:forEach var="payType" items="${payTypeList}">
                                    <option value="${payType.LGART}" data-kombi="${payType.KOMBI}"
                                        ${row.LGART == payType.LGART ? "selected" : ""}>${payType.LGTXT}</option>
                                </c:forEach>
                            </select>
                            <%--<select name="KOMBI" style="display:none">
                                <%
                                    for(int j=0; j<type_vt.size(); j++){
                                        D15EmpPayTypeData typeData = (D15EmpPayTypeData)type_vt.get(j);

                                %>
                                <option value="<%=typeData.LGART %>" ${row.LGART.equals(typeData.LGART)? "selected" : "" %>><%=typeData.KOMBI }</option>
                                <%
                                    }
                                    if (type_vt.size()==0) {
                                %>
                                <option value="">3</option>
                                <%}%>
                            </select>--%>
                            <input type="hidden" name="PERNR" value="${row.PERNR }">
                            <input type="hidden" name="ENAME" value="${row.ENAME }">
                            <input type="hidden" name="BEGDA" value="${row.BEGDA }">
                        </td>
                        <td>
                            <input type="text" id="ANZHL${status.index}" name="ANZHL" value="${f:convertCurrency(row.ANZHL, '') }" size="5" maxlength="3" class="number" placeholder="<spring:message code="LABEL.D.D19D.0004" /><%-- 시간 --%>">
                        </td>
                        <td class="lastCol">
                            <input type="text" id="BETRG${status.index}" name="BETRG" value="${f:convertCurrency(row.BETRG, '') }" size="25" maxlength="7" class="money2" placeholder="<spring:message code="LABEL.D.D05.0015" /><%-- 금액 --%>">
                        </td>
                    </tr>
                </c:forEach>
                    <tags:table-row-nodata list="${payList}" col="6"/>
                </tbody>
            </table>
        </div>
    </div>

    </form>

    <form id="deleteForm" name="deleteForm" method="post" onsubmit="return false">
        <input type="hidden" name="jobid" />
        <input type="hidden" name="I_DATE" value="${f:printDate(I_DATE)}"  >
        <input type="hidden" name="I_SEARCHDATA" value="${I_SEARCHDATA}"/>
        <h2 class="subtitle"><spring:message code="LABEL.D.D15.0207" /><%-- 저장된 지급정보 --%></h2>

        <div class="listArea">
            <div class="table">
                <table class="listTable" >
                    <thead>
                    <tr>
                        <th width="30"><spring:message code="LABEL.D.D19.0015" /><%-- 삭제 --%></th>
                        <th width="100"><spring:message code="LABEL.D.D12.0017" /><%-- 사원번호 --%></th>
                        <th width="100"><spring:message code="MSG.APPROVAL.0013" /><%-- 성명 --%></th>
                        <th width="100"><spring:message code="LABEL.D.D15.0206" /><%-- 일자 --%></th>
                        <th width="150"><spring:message code="LABEL.D.D08.0004" /><%-- 임금유형 --%></th>
                        <th width="*"><spring:message code="LABEL.D.D19D.0004" /><%-- 시간 --%></th>
                        <th class="lastCol" width="*"><spring:message code="LABEL.D.D05.0015" /><%-- 금액 --%></th>
                    </tr>
                    </thead>
                    <c:forEach var="row" items="${saveList}" varStatus="status">
                        <tr class="${f:printOddRow(status.index)}">
                            <td>
                                <input name="deleteCheck" type="checkbox" value="${status.index}">
                                <input type="hidden" name="PERNR_${status.index}" value="${row.PERNR }">
                                <input type="hidden" name="ENAME_${status.index}" value="${row.ENAME }">
                                <input type="hidden" name="BEGDA_${status.index}" value="${row.BEGDA }">
                                <input type="hidden" name="LGART_${status.index}" value="${row.LGART }">
                                <input type="hidden" name="ANZHL_${status.index}" value="${row.ANZHL }">
                                <input type="hidden" name="BETRG_${status.index}" value="${row.BETRG }">
                            </td>
                            <td>${row.PERNR }</td>
                            <td>${row.ENAME }</td>
                            <td>${row.BEGDA }</td>
                            <td>${row.LGTXT }</td>
                            <td>${f:convertCurrency(row.ANZHL, "") }</td>
                            <td class="lastCol">${f:convertCurrency(row.BETRG, "") }</td>
                        </tr>
                    </c:forEach>
                    <tags:table-row-nodata list="${saveList}" col="7"/>
                </table>
            </div>
        </div>

    </form>

    <div class="buttonArea">
        <ul class="btn_crud">
            <li id="sc_button"><a class="darken" href="javascript:doSaveData();"><span><spring:message code="BUTTON.COMMON.SAVE" /><%-- 저장 --%></span></a></li>
            <li><a href="javascript:do_delete();"><span><spring:message code="BUTTON.COMMON.DELETE" /><%-- 삭제 --%></span></a></li>
        </ul>
    </div>

    </div>
</tags:layout>

