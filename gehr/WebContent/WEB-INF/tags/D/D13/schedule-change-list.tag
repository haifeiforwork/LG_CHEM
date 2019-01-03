<%@ tag language="java" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="language" tagdir="/WEB-INF/tags/C/C05" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>


<c:set var="PERNR" value="<%= (String)request.getAttribute("PERNR") %>"/>

<tags:script>
    <script>
        $(function() {
            $("#-schedule-change-table").tablesorter();

            $("#-schedule-change-table").bind("sortEnd",function() {

                var $tr = $("#-schedule-change-table tbody tr");

                $("#-schedule-change-table .oddRow").removeClass("oddRow");
                $tr.each(function(idx) {
                    if(idx % 2 == 0) $(this).addClass("oddRow");
                });
            });
        });

        	var lastIndex = ${fn:length(resultList)};
            $(function() {
//                 $("#-schedule-change-table").tablesorter();
            });
            

            /**
             * row 추가 시 해당 로우에 값 검증
             */
            function checkRow($row, isSelectPayType) {

                var $payType = $row.find(".-pay-type");

                if(_.isEmpty($row.find("input[name=LIST_PERNR]").val()) ||
                        _.isEmpty($payType.val())) return true;

                var YYYYMM = $("#applyYear").val() +  $("#applyMonth").val();

                $("#validateForm").empty()
                        .append($row.find("input").clone())
//                         .append($("<input/>").prop("name", "I_YYYYMM").val(YYYYMM))
//                         .append($("<input/>").prop("name", "LIST_${payTypeItem}").val($payType.val()));

//                 ajaxPost("${g.servlet}hris.D.D15EmpPayInfo.D15EmpPayValidateAjax", "validateForm", function(data) {
//                     console.log(data.resultList);
//                     _.each(data.resultList, function(row) {
//                         console.log(row);

//                         setRow($row, row, isSelectPayType);
//                     });
//                 }, function() {

//                 });
            }

            /**
             * key 값이 중복되는 로우가 존재하는지 확인
             * 중복되는 로우 리턴
             */
            function checkDuplicate(obj) {
                var $rows = $("#-listTable-body tr");

                var result = null;

                $rows.each(function() {
                    var $this = $(this);

                    if($this.find("[name=LIST_PERNR]").val() == obj.PERNR) {

//                         var _payType = $this.find(".-pay-type").val() || obj.${payTypeItem};
//                         if(_payType == obj.${payTypeItem}) {
//                             result = $this;
//                             return false;
//                         }
                    }
                });

                return result;
            }

            /**
             * 해당 로우에 데이타 셋팅
             */
            function setRow($row, obj, isSelectPayType) {
                var payType;

                if(obj) {
                    /* input box set */
                    $row.find("input").each(function() {
                        var $this = $(this);

                        $this.formatVal(obj[$this.prop("name").replace("LIST_", "")]);
                    });

//                     payType = obj.${payTypeItem};

//                     /* LGART set*/
//                     if(isSelectPayType) getPayTypeOption($row, payType);
//                     else $row.find("select[name=LIST_${payTypeItem}]").val(payType)
                }
            }

            /**
             * 로우추가
             */
            function addRow(obj) {
                console.log("--- addROw -- ");
                var $row;

                if(obj) {
                    $row = checkDuplicate(obj);
                }

                if(!$row) {
                    var templateText = $("#template").text();
                    templateText = templateText.replace(/#idx#/g, ++lastIndex);
                    $row = $(templateText);
                }

                setRow($row, obj, true);

                addMaskFilter($row);

                $("#-listTable-body").append($row);

            }


            /**
             * 로우 삭제
             */
            function deleteRow() {
                $(".-row-check:checked").parents("tr").remove();
                lastIndex--;
                
                if($("#-listTable-body tr").length == 0) {
                    addRow();
                    $("#checkAll").prop("checked", false);
                    /*$("#-listTable-body").append($("<tr/>").append($("<td colspan='7'/>").text("<spring:message code="MSG.COMMON.0004" />")));*/
                }
            }

            /**
             * 전체 체크
             */
            function checkAllChange() {
                if($("#checkAll").is(":checked")) {
                    $(".-row-check").prop("checked", true);
                } else {
                    $(".-row-check").prop("checked", false);
                }
            }

            function selectPayType() {
                var $select = $(event.target);
                var $row = $select.parents("tr");
                var $option = $select.find("option:selected");

                <c:if test="${pageGubun == 'empPay'}">
                $row.find("input[name=LIST_INFTY]").val($option.data("infty"));
                </c:if>
                <c:if test="${pageGubun == 'member'}">
                $row.find("input[name=LIST_LGART]").val($option.data("lgart"));
                $row.find("input[name=LIST_BETRG]").val($option.data("betrg"));
                </c:if>

                checkRow($row);
            }

            function afterUploadProcess(data) {
                console.log("---- add row -- start=---- ");
                console.log(data.resultList);
                if(data.resultList) {
                    var isError = false;
                    
//                  if(data.resultList.length > 0 && $(".-search-person").length == 1 &&  _.isEmpty($(".-search-person:first").val())) {
                    if(data.resultList.length > 0) {
                        $("#-listTable-body").empty();
                    }

                    $("#-excel-result-tbody").empty();

                    _.each(data.resultList, function(row) {
                        addRow(row);

                        if(!_.isEmpty(row.ZBIGO)) {
                            $("<tr/>")
                                    .append($("<td/>").text(row.PERNR))
                                    .append($("<td/>").text(row.ENAME))
                                    .append($("<td/>").text(row.BEGDA).css("text-align", "center"))
                                    .append($("<td/>").text(row.ENDDA).css("text-align", "center"))
                                    .append($("<td/>").text(row.RTEXT))
                                    .append($("<td/>").text(row.VTART))
                                    .append($("<td/>").text(row.ZBIGO).addClass("result-msg"))
                                    .appendTo("#-excel-result-tbody");

                            isError = true;
                        }
                    });

                    $("#-accept-dialog").openDialog();
                    $("#-excel-result-dialog").openDialog();

//                     if(isError) $("#-excel-result-dialog").openDialog();

//                     parent.resizeIframe(document.body.scrollHeight);

                }
            }

            $(function() {
                if($(".-pay-type").length == 0) {
                    $("#-listTable-body").empty();
                    addRow();
                    $('.date').datepicker();
                }

                /*파일업로드 추가 파라메터 */
                $('.file-input').bind('fileuploadsubmit', function (e, data) {
                    data.formData = {I_YYYYMM: $("#applyYear").val() +  $("#applyMonth").val()};
                });

                /* 반영년월 변경시 모든 데이타 다시 체크 */
                $(".-yyyymm").change(function() {
                    $("#-listTable-body tr").each(function() {
                        checkRow($(this), true);
                    })

                });

            });


            var _searchPersonIdx = null;

            function beforeSubmit() {
                var _isProcess = true;

                var $msg = $("input[name=LIST_ZMSG]");

                $msg.each(function() {
                    var $this = $(this);
                    if(!_.isEmpty($this.val())) {
                        alert("<spring:message code='MSG.D.D13.0004'/>"); //메세지를 확인 후 데이타를 수정하십시오
                        $this.focus();
                        _isProcess = false;
                        return false;
                    }
                });

                return _isProcess;
            }


            function removeSearchPerson(idx) {
                $("#APPR_SEARCH_VALUE" + idx).val('');
            }


            /**
             * 사원 검색 팝업
             */
            function searchPerson(idx) {
                _searchPersonIdx = idx;

                if(event.keyCode && event.keyCode != 13) return;

                var type = $("#APPR_SEARCH_GUBUN" + idx).val();
                var _jobid = type == "1" ? "pernr" : "ename";

                var _value = $("#APPR_SEARCH_VALUE" + idx).val();

                if ( _.isEmpty(_value)) {
                    if(type == "1")
                        alert("<spring:message code='MSG.APPROVAL.SEARCH.PERNR.REQUIRED'/>");//검색할 부서원 사번을 입력하세요
                    if(type == "2")
                        alert("<spring:message code='MSG.APPROVAL.SEARCH.NAME.REQUIRED'/>");//검색할 부서원 성명을 입력하세요

                    $("#APPR_SEARCH_VALUE" + idx).focus();
                    return;
                }

                var url = "${g.jsp}common/SearchDeptPersonsWait_T.jsp?I_GUBUN=" + type + "&I_VALUE1=" + encodeURIComponent(_value) + "&jobid=" + _jobid;

                var searchApprovalHeaderPop = window.open(url,"DeptPers","toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=no,scrollbars=yes,width=680,height=460,left=450,top=00");
                //$(searchFrom).unloadingSubmit();

                <%--var searchApprovalHeaderPop = window.open("${g.jsp}common/ApprovalOrganListFramePop.jsp","Organ","toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=no,scrollbars=no,width=960,height=480,left=450,top=0");--%>
                <%--searchApprovalHeaderPop.focus();--%>
            }

            function setPersInfo(obj) {
                $("#PERNR" + _searchPersonIdx).val(obj.PERNR);
                $("#ENAME" + _searchPersonIdx).val(obj.ENAME);

                checkRow($("#-pay-row-" + _searchPersonIdx));
            }

            function doSearchTprog( idx){
            	$('#ifpopup').attr("src","${g.servlet}hris.D.D13ScheduleChange.D13ScheduleChangePopupSV?I_DATE=" +
            			"&rowNum="+idx);
            	showPop();
            }
            function tprog2Change(idx, data){
                $("#TPROG" + idx).val(data);
                $("#TTEXT" + idx).val($('#TTEXT2_'+idx).val());
            }
            
              
    </script>
</tags:script>
    
<!--일일근태현황 리스트 테이블 시작-->

    
   	<input type="hidden" name="jobid"  value="search" />
   	<input type="hidden" name="PERNR"  value="${PERNR })" />
   	<input type="hidden" name="row_count"  value="" />
	<input type="hidden" name="hdn_deptId"  value="${deptId}">
	<input type="hidden" name="hdn_deptNm"  value="${deptNm}">
     <input type="hidden" name="subView" value="Y">
     <input type="hidden" name="urlName" value="">
     <input type="hidden" name="I_VALUE1"  value="">
    <input type="hidden" name="sMenuCode"  value="${sMenuCode}">
    <input type="hidden" name="retir_chk"  value="">

	<div class="listArea" style="text-align:right">
	    <div class="table" style="text-align:left">
	        <table id="-schedule-change-table" class="listTable tablesorter" >
	            <colgroup>
                <col width="3%"/>
                <col width="6%;"/>
                <col width="5%;"/>
                <col width="6%;"/>
                <col width="6%;"/>
                <col width="6%;"/>
                <col width="6%;"/>
                <col width="6%;"/>
                <col width="12%;"/><!-- 근무일정명-->
                <col width="6%;"/>
                <col width="9%;"/>
                <col width="9%;"/>
                <col />
            </colgroup>
            <thead>
            <tr>
            	<th><input type="checkbox" id="checkAll" name="checkAll" onclick="checkAllChange()"/></th>
                <th><spring:message code="LABEL.D.D12.0017"/> <!-- 사원번호--></th>
                <th><spring:message code="LABEL.D.D12.0018"/> <!-- 이름--></th>
                <th><spring:message code="LABEL.D.D15.0152"/> <!-- 시작일--></th>
                <th><spring:message code="LABEL.D.D15.0153"/> <!-- 종료일--></th>
                <th><spring:message code="LABEL.D.D13.0014"/> <!-- 대체유형--></th>
                <th><spring:message code="LABEL.D.D13.0015"/> <!-- 일일근무일정--></th>
                <th><spring:message code="LABEL.D.D14.0001"/> <!-- 근무일정규칙--></th>
                <th><spring:message code="LABEL.D.D13.0016"/> <!-- 근무일정명--></th>
                <th><spring:message code="LABEL.D.D12.0020"/> <!-- 시작시간--></th>
                <th><spring:message code="LABEL.D.D12.0021"/> <!-- 종료시간--></th>
                <th><spring:message code="LABEL.D.D13.0017"/> <!-- 근무시간--></th>
                <th class="lastCol"><spring:message code="LABEL.COMMON.0015"/> <!-- 비고--></th>
            </tr>
            </thead>
           <tbody id="-listTable-body">
        <%--@elvariable id="resultList" type="java.util.Vector<hris.D.D15EmpPayInfo.D15EmpPayData>"--%>        
        <%--@elvariable id="payTypeMap" type="Map<String, Vector<hris.D.D15EmpPayInfo.D15EmpPayTypeData>>"--%>
        

            <c:forEach var="row" items="${resultList}" varStatus="status">
                <tr  id="-pay-row-${status.index}" class="${f:printOddRow(status.index)}">
                    <td> <input type="checkbox" id="checkRow${status.index}" name="checkRow" class="-row-check" value="X"/></td>
                    <td >						<input type="text" id="PERNR${status.index}" 	name="LIST_PERNR" 		value="${row.PERNR		}" size="25"  class="required" placeholder="<spring:message code='LABEL.D.D12.0017'		/>"><%-- 사번 --%> 	</td>
                    <td >						<input type="text" id="ENAME${status.index}" 	name="LIST_ENAME" 	value="${row.ENAME	}" size="25"  class="required" placeholder="<spring:message code='LABEL.D.D12.0018'		/>"><%-- 이름--%>	</td>
                    <td >						<input type="text" id="KURZT${status.index}" 	name="LIST_KURZT" 	value="${row.KURZT 	}" size="25"  class="required" placeholder="<spring:message code='LABEL.D.D15.0152'		/>"><%-- 시작일--%>	</td>
                    <td >						<input type="text" id="ENDDA${status.index}" 	name="LIST_ENDDA" 	value="${row.ENDDA		}" size="25"  class="required" placeholder="<spring:message code='LABEL.D.D15.0153'		/>"><%-- 종료일--%> </td>         
                    <td >						<input type="text" id="VTART${status.index}" 	name="LIST_VTART" 	value="${row.VTART		}" size="25"  class="required" placeholder="<spring:message code='LABEL.D.D13.0014'		/>"><%--- 대체유형--%></td> 
                    <td >						<input type="text" id="TPROG${status.index}" 	name="LIST_TPROG" 	value="${row.TPROG		}" size="25"  class="required" placeholder="<spring:message code='LABEL.D.D13.0015'		/>"><%--- 일일근무일정--%> </td>                    
                    <td >						<input type="text" id="TTEXT2${status.index}"	name="LIST_TTEXT2" 	value="${row.TTEXT2	}" size="25"  class="required" placeholder="<spring:message code='LABEL.D.D14.0001'		/>"><%-- 근무일정규칙--%></td>
                    <td >						<input type="text" id="TTEXT${status.index}" 	name="LIST_TTEXT" 	value="${row.TTEXT		}" size="25"  class="required" placeholder="<spring:message code='LABEL.D.D13.0016'		/>"><%-- 근무일정명--%></td>
                    <td >						<input type="text" id="STDAZ${status.index}" 	name="LIST_STDAZ" 	value="${row.STDAZ	}" size="25"  class="required" placeholder="<spring:message code='LABEL.D.D12.0020'		/>"><%-- 시작시간--%></td>
                    <td >						<input type="text" id="ZMODN${status.index}" name="LIST_ZMODN" 	value="${row.ZMODN	}" size="25"  class="required" placeholder="<spring:message code='LABEL.D.D12.0021'		/>"><%-- 종료시간--%></td>
                    <td >						<input type="text" id="ZMODN${status.index}" name="LIST_ZMODN" 	value="${row.ZMODN	}" size="25"   	/>"><%-- 근무시간--%></td>
                    <td class="lastCol">	<input type="text" id="MOFID${status.index}" 	name="LIST_MOFID" 	value="${row.MOFID		}" size="25" />"><%-- 비고--%></td>
                </tr>
            </c:forEach>
            <tags:table-row-nodata list="${resultList}" col="13" />
            </tbody>
        </table>
        <span class="textPink">*</span><spring:message code="MSG.D.D13.0002"/><!--업로드시 바로 저장처리되며, 에러발생된 내역만 표시 됩니다.  -->
        
        
        
    <textarea id="template" style="display: none; top: -99999px; height: 0px; ">
        <tr id="-pay-row-#idx#" >
            <td>
                <input type="checkbox" id="checkRow#idx#" name="checkRow" class="-row-check" value="X"/>
            </td>
            <td>
                 <select id="APPR_SEARCH_GUBUN#idx#" name="LIST_SEARCH_GUBUN" onChange="removeSearchPerson(#idx#)">
                    <option value="2"><!--성명별--><spring:message code="LABEL.COMMON.0004" /></option>
                    <option value="1"><!--사번별--><spring:message code="LABEL.COMMON.0005" /></option>
                </select>
                <input type="text"  id="APPR_SEARCH_VALUE#idx#" name="I_VALUE1" size="10"  maxlength="10"  onkeydown="searchPerson(#idx#);" style="ime-mode:active" >
                <a onclick="searchPerson(#idx#);" ><img src="${g.image}sshr/ico_magnify.png" /></a>
            </td>
            <td>
                <input type="text" id="PERNR#idx#" name="LIST_PERNR" class="-search-person required" readonly value="" style="width: 80px;" />
                <input type="text" id="ENAME#idx#" name="LIST_ENAME" readonly value="" style="width: 60px;"/>
            </td>
         	<td >		       			<input type="text" id="KURZT#idx#" 	name="LIST_KURZT" 	value="${row.KURZT 	}" size="4"  class="date required" placeholder="<spring:message code='LABEL.D.D15.0152'		/>"><%-- 시작일--%>	</td>
            <td >						<input type="text" id="ENDDA#idx#" 	name="LIST_ENDDA" 	value="${row.ENDDA		}" size="4"  class="date required" placeholder="<spring:message code='LABEL.D.D15.0153'		/>"><%-- 종료일--%> </td>         
            <td>
                <select id="VTART#idx#" name="LIST_VTART" class="required -pay-type" onchange="selectPayType('LGART#idx#');" placeholder="<spring:message code="LABEL.D.D08.0004" /><%-- 임금유형 --%>">
                    <option value="">-----------------</option>
                 <c:forEach var="payType" items="${payTypeList}">
                    <option value="${payType.LGART}" data-infty="${payType.INFTY}"
                        ${row.LGART == payType.LGART ? "selected" : ""}>[${payType.LGART}]${payType.LGTXT}</option>
                 </c:forEach>
                </select>
			</td>

            <td >	<input type="text" id="TPROG#idx#" 	name="LIST_TPROG#" 	value="${row.TPROG		}" size="10"  class="required" placeholder="<spring:message code='LABEL.D.D13.0015'		/>"><%--- 일일근무일정--%> 
                      <a href="javascript:doSearchTprog('#idx#' );">
			            <img src="${g.image}sshr/ico_magnify.png"  name="image" align="absmiddle" border="0">
			          </a>
            </td>                    
            <td >						<input type="text" id="TTEXT2#idx#"   name="LIST_TTEXT2" 	value="${row.TTEXT2	}" size="10"  class="required" placeholder="<spring:message code='LABEL.D.D14.0001'		/>"><%-- 근무일정규칙--%>
                      <a href="javascript:doSearchTprog('#idx#' );">
			            <img src="${g.image}sshr/ico_magnify.png"  name="image" align="absmiddle" border="0">
			          </a>
            	
            </td>
            <td >						<input type="text" id="TTEXT#idx#" 	name="LIST_TTEXT" 	value="${row.TTEXT		}" size="10"  class="required" placeholder="<spring:message code='LABEL.D.D13.0016'		/>"><%-- 근무일정명--%></td>
            <td >						<input type="text" id="STDAZ#idx#" 	name="LIST_STDAZ" 	value="${row.STDAZ	}" size="5"  class="required" placeholder="<spring:message code='LABEL.D.D12.0020'		/>"><%-- 시작시간--%></td>
            <td >						<input type="text" id="ZMODN#idx#" 	name="LIST_ZMODN" 	value="${row.ZMODN	}" size="5"  class="required" placeholder="<spring:message code='LABEL.D.D12.0021'		/>"><%-- 종료시간--%></td>
            <td >						<input type="text" id="ZMODN#idx#" 	name="LIST_ZMODN" 	value="${row.ZMODN	}" size="5"   ><%-- 근무시간--%></td>
            <td class="lastCol">	<input type="text" id="MOFID#idx#" 	name="LIST_MOFID" 	value="${row.MOFID		}" size="25" ><%-- 비고--%></td>
            
			    	<input type="hidden" name="TPROG2_#idx#"    onchange="tprog2Change( #idx#, this.value );"   /><!-- popup에서 들어오는 값저장 -->
			    	<input type="hidden" name="VARIA2_#idx#"     />
			    	<input type="hidden" name="sTTEXT2_#idx#"  />
			    	<input type="hidden" id="TTEXT2_#idx#" name="TTEXT2_#idx#"    />
        </tr>
    </textarea>
    
    </div>
    
            <ul class="btn_mdl" style="display: inline;padding-left: 50px;" >
                <li><a href="javascript:;" onclick="addRow();"><span><spring:message code="BUTTON.COMMON.LINE.ADD"/></span></a></li>
                <li><a href="javascript:;" onclick="deleteRow();"><span><spring:message code="BUTTON.COMMON.LINE.DELETE"/></span></a></li>
            </ul>
            
</div>
<!--일일근태현황 리스트 테이블 끝-->
