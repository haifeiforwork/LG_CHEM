<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 건강보험 재발급                                             */
/*   Program Name : 건강보험 재발급/추가발급/기재사항변경 신청                  */
/*   Program ID   : E02MedicareBuild.jsp                                        */
/*   Description  : 건강보험증 변경/재발급 신청을 할수 있도록 하는 화면         */
/*   Note         :                                                             */
/*   Creation     : 2002-01-03  박영락                                          */
/*   Update       : 2005-02-28  윤정현                                          */
/*               2015-05-08  이지은D  [CSR ID:2766987] 학자금 및 주택자금 담당자 결재 화면 수정요청   */
/*                                                                              */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.E.E02Medicare.*" %>
<%@ page import="hris.E.E02Medicare.rfc.*" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tags-approval" tagdir="/WEB-INF/tags/approval" %>

<c:set var="user" value="<%=WebUtil.getSessionUser(request) %>"/>
<tags:layout css="ui_library_approval.css">
    <tags-approval:request-layout titlePrefix="TAB.COMMON.0052"  >
                <tags:script>
                    <script>

function doSubmit() {
    if( check_data() ) {
        buttonDisabled();
        document.form1.jobid.value = "create";
        document.form1.action = "${g.servlet}hris.E.E02Medicare.E02MedicareBuildSV";
        document.form1.method = "post";
        document.form1.submit();
    }
}

function beforeSubmit() {
	if ( check_data()) 	{
		return true;
	}
}
function check_data(){

    var idx = document.form1.APPL_TYPE2.selectedIndex;
    if( idx==0 ){
        alert('<spring:message code="MSG.E.E01.0004" />'); //신청구분을 선택하세요
        document.form1.APPL_TYPE2.focus();
        return false;
    }

    if( document.form1.ENAME.selectedIndex == 0 ){
        alert('<spring:message code="MSG.E.E01.0006" />'); //대상자 성명을 선택하세요
        document.form1.ENAME.focus();
        return false;
    }

    if( idx == 1 ){
        if( document.form1.APPL_TYPE3.selectedIndex==0 ){
            alert('<spring:message code="MSG.E.E02.0001" />'); //변경항목을 선택하세요
            document.form1.APPL_TYPE3.focus();
            return false;
        }
        if( document.form1.CHNG_BEFORE.value == "" ){
            alert('<spring:message code="MSG.E.E02.0002" />'); //변경전 Data를 입력하세요
            document.form1.CHNG_BEFORE.focus();
            return false;
        }
        if( document.form1.CHNG_AFTER.value == "" ){
            alert('<spring:message code="MSG.E.E02.0003" />'); //변경후 Data를 입력하세요
            document.form1.CHNG_AFTER.focus();
            return false;
        }
        //주민등록번호일때 유효성 체크
        appl_type = document.form1.APPL_TYPE3[document.form1.APPL_TYPE3.selectedIndex].value;
        if(appl_type == "02" ){//주민등록번호
            if( ! chkResnoObj_1(document.form1.CHNG_AFTER)){
                return false;
            }
        }

        if( document.form1.APPL_TYPE3.selectedIndex == 4 ){
            if( document.form1.ETC_TEXT3.value == "" ){
                alert('<spring:message code="MSG.E.E02.0004" />'); //변경항목이 기타입니다. 내용을 입력하세요
                document.form1.ETC_TEXT3.focus();
                return false;
            }
        }
    } else if( idx == 2 ){
        if( document.form1.APPL_TYPE4.selectedIndex==0 ){
            alert('<spring:message code="MSG.E.E02.0005" />'); //발급사유항목 선택하세요
            document.form1.APPL_TYPE4.focus();
            return false;
        }
        if( document.form1.APPL_TYPE4.selectedIndex == 5 ){
            if( document.form1.ETC_TEXT4.value == "" ){
                alert('<spring:message code="MSG.E.E02.0006" />'); //발급사유가 기타입니다. 내용을 입력하세요
                document.form1.ETC_TEXT4.focus();
                return false;
            }
        }
    } else if( idx == 3 ){
        if( document.form1.APPL_TYPE5.selectedIndex==0 ){
            alert('<spring:message code="MSG.E.E02.0007" />'); //재발급 신청항목을 선택하세요
            document.form1.APPL_TYPE5.focus();
            return false;
        }
        if( document.form1.APPL_TYPE5.selectedIndex == 4 ){
            if( document.form1.ETC_TEXT5.value == "" ){
                alert('<spring:message code="MSG.E.E02.0008" />'); //신청항목이 기타입니다. 내용을 입력하세요
                document.form1.ETC_TEXT5.focus();
                return false;
            }
        }
    }

/*    if ( check_empNo() ){
        return false;
    }
*/

    begdate = removePoint(document.form1.BEGDA.value);
    document.form1.BEGDA.value = begdate;
    return true;
}

function change_select(obj){
    inx = obj[obj.selectedIndex].value;

    if( inx == 1 ){
      //활성창 변경
      document.form1.APPL_TYPE3.disabled  =0;
      document.form1.ETC_TEXT3.disabled   =0;
      document.form1.CHNG_BEFORE.disabled =0;
      document.form1.CHNG_AFTER.disabled  =0;
      document.form1.ENAME.disabled       =0;
      document.form1.ADD_NUM.disabled     =1;
      document.form1.ADD_NUM1.disabled    =1;

      document.form1.APPL_TYPE4.disabled  =1;
      document.form1.ETC_TEXT4.disabled   =1;

      document.form1.APPL_TYPE5.disabled  =1;
      document.form1.ETC_TEXT5.disabled   =1;

      document.all.ETC_TEXT3.style.visibility="hidden";
      document.all.ETC_TEXT4.style.visibility="hidden";
      document.all.ETC_TEXT5.style.visibility="hidden";
      //초기화
      document.form1.APPL_TYPE3.selectedIndex = 0;
      document.form1.ETC_TEXT3.value     = "";
      document.form1.CHNG_BEFORE.value   = "";
      document.form1.CHNG_AFTER.value    = "";
      document.form1.ENAME.selectedIndex = 0;

      document.form1.APPL_TYPE4.selectedIndex = 0;
      document.form1.ETC_TEXT4.value     = "";
      document.form1.ADD_NUM.value       = "";
      document.form1.APPL_TYPE5.selectedIndex = 0;
      document.form1.ETC_TEXT5.value     = "";
      document.form1.ADD_NUM1.value      = "";
    } else if( inx == 2 ){
      document.form1.APPL_TYPE3.disabled  =1;
      document.form1.ETC_TEXT3.disabled   =1;
      document.form1.CHNG_BEFORE.disabled =1;
      document.form1.CHNG_AFTER.disabled  =1;
      document.form1.ENAME.disabled       =0;
      document.form1.ADD_NUM.disabled     =0;
      document.form1.ADD_NUM1.disabled    =1;

      document.form1.APPL_TYPE4.disabled = 0;
      document.form1.ETC_TEXT4.disabled  = 0;

      document.form1.APPL_TYPE5.disabled = 1;
      document.form1.ETC_TEXT5.disabled  = 1;

      document.all.ETC_TEXT3.style.visibility = "hidden";
      document.all.ETC_TEXT4.style.visibility = "hidden";
      document.all.ETC_TEXT5.style.visibility = "hidden";
      //초기화
      document.form1.APPL_TYPE3.selectedIndex = 0;
      document.form1.ETC_TEXT3.value          = "";
      document.form1.CHNG_BEFORE.value        = "";
      document.form1.CHNG_AFTER.value         = "";
      document.form1.ENAME.selectedIndex      = 0;

      document.form1.APPL_TYPE4.selectedIndex = 0;
      document.form1.ETC_TEXT4.value     = "";
      document.form1.ADD_NUM.value       = "";
      document.form1.APPL_TYPE5.selectedIndex = 0;
      document.form1.ETC_TEXT5.value     = "";
      document.form1.ADD_NUM1.value      = "";
    } else if( inx == 3 ){
      document.form1.APPL_TYPE3.disabled  = 1;
      document.form1.ETC_TEXT3.disabled   = 1;
      document.form1.CHNG_BEFORE.disabled = 1;
      document.form1.CHNG_AFTER.disabled  = 1;
      document.form1.ENAME.disabled       = 0;
      document.form1.ADD_NUM.disabled     = 1;
      document.form1.ADD_NUM1.disabled    = 0;

      document.form1.APPL_TYPE4.disabled  = 1;
      document.form1.ETC_TEXT4.disabled   = 1;

      document.form1.APPL_TYPE5.disabled  = 0;
      document.form1.ETC_TEXT5.disabled   = 0;

      document.all.ETC_TEXT3.style.visibility = "hidden";
      document.all.ETC_TEXT4.style.visibility = "hidden";
      document.all.ETC_TEXT5.style.visibility = "hidden";
      //초기화
      document.form1.APPL_TYPE3.selectedIndex = 0;
      document.form1.ETC_TEXT3.value          = "";
      document.form1.CHNG_BEFORE.value        = "";
      document.form1.CHNG_AFTER.value         = "";
      document.form1.ENAME.selectedIndex      = 0;

      document.form1.APPL_TYPE4.selectedIndex = 0;
      document.form1.ETC_TEXT4.value     = "";
      document.form1.ADD_NUM.value       = "";
      document.form1.APPL_TYPE5.selectedIndex = 0;
      document.form1.ETC_TEXT5.value     = "";
      document.form1.ADD_NUM1.value      = "";
    } else {
      document.form1.APPL_TYPE3.disabled  =1;
      document.form1.ETC_TEXT3.disabled   =1;
      document.form1.CHNG_BEFORE.disabled =1;
      document.form1.CHNG_AFTER.disabled  =1;
      document.form1.ENAME.disabled       =0;

      document.form1.APPL_TYPE4.disabled  =1;
      document.form1.ETC_TEXT4.disabled   =1;

      document.form1.APPL_TYPE5.disabled  =1;
      document.form1.ETC_TEXT5.disabled   =1;

      document.all.ETC_TEXT3.style.visibility = "hidden";
      document.all.ETC_TEXT4.style.visibility = "hidden";
      document.all.ETC_TEXT5.style.visibility = "hidden";
      //초기화
      document.form1.APPL_TYPE3.selectedIndex = 0;
      document.form1.ETC_TEXT3.value          = "";
      document.form1.CHNG_BEFORE.value        = "";
      document.form1.CHNG_AFTER.value         = "";
      document.form1.ENAME.selectedIndex      = 0;

      document.form1.APPL_TYPE4.selectedIndex = 0;
      document.form1.ETC_TEXT4.value     = "";
      document.form1.ADD_NUM.value       = "";
      document.form1.APPL_TYPE5.selectedIndex = 0;
      document.form1.ETC_TEXT5.value     = "";
      document.form1.ADD_NUM1.value      = "";
    }
}

function check_type1(obj){
    inx = obj[obj.selectedIndex].value;
    if( inx == 4 ){
        document.all.ETC_TEXT3.style.visibility = "visible";
    } else {
        document.all.ETC_TEXT3.style.visibility = "hidden";
        document.form1.ETC_TEXT3.value = "";
    }
}

function check_type2(obj){
    inx = obj[obj.selectedIndex].value;
    if( inx == 5 ){
        document.all.ETC_TEXT4.style.visibility = "visible";
    } else {
        document.all.ETC_TEXT4.style.visibility = "hidden";
        document.form1.ETC_TEXT4.value = "";
    }
}

function check_type3(obj){
    inx = obj[obj.selectedIndex].value;
    if( inx == 4 ){
        document.all.ETC_TEXT5.style.visibility = "visible";
    } else {
        document.all.ETC_TEXT5.style.visibility = "hidden";
        document.form1.ETC_TEXT5.value = "";
    }
}

function check_length(obj,leng) {
    val = obj.value;
    nam = obj.name;
    len = checkLength(obj.value);
    if( len > leng ) {
        vala = limitKoText(val,leng);
        obj.blur();
        obj.value = vala;
        obj.focus();
    }
}

function change_name(obj) {
  var p_idx = obj.selectedIndex - 1;

  if( p_idx >= 0 ) {
      eval("document.form1.SUBTY.value = document.form1.SUBTY_name" + p_idx + ".value");
      eval("document.form1.OBJPS.value = document.form1.OBJPS_name" + p_idx + ".value");
  } else {
      document.form1.SUBTY.value = "";
      document.form1.OBJPS.value = "";
  }
}

function reload() {
    frm =  document.form1;
    frm.jobid.value = "first";
    frm.action = "${g.servlet}hris.E.E02Medicare.E02MedicareBuildSV";
    frm.target = "";
    frm.submit();
}
$(function() {
     if(parent.resizeIframe) parent.resizeIframe(document.body.scrollHeight);

});
</script>
</tags:script>


    <div class="tableArea">
        <div class="table">
            <table class="tableGeneral tableApproval">
             	<colgroup>
					<col width="15%" />
					<col width="35%" />
					<col width="15%" />
					<col width="35%" />
				</colgroup>
              <tr>
                <th ><span class="textPink">*</span><spring:message code="LABEL.E.E22.0042" /><!-- 신청구분 --></th>
                <td>
                <input type="hidden" name="BEGDA" value="${f:printDate(approvalHeader.RQDAT)}" readonly size="16">
                  <select name="APPL_TYPE2" onChange="javascript:change_select(this);" style="width:200px">
                    <option>---------------------</option>
                     ${ f:printCodeOption( e02MedicareREQ_vt , resultData.APPL_TYPE2) }
                  </select>
                </td>
                <th  class="th02"><span class="textPink">*</span><spring:message code="LABEL.E.E01.0002" /><!-- 대상자 성명 --></th>
                <td >
                  <select name="ENAME" onChange="javascript:change_name(this);" style="width:200px">
                    <option>----------</option>
                    <option value="${approvalHeader.ENAME}"  ${approvalHeader.ENAME eq resultData.ENAME ? 'selected' : '' } >${approvalHeader.ENAME}</option>
					<c:forEach var="row" items="${targetName_vt}" varStatus="status">
					<c:set var="full_name" value="${row.LNMHG} ${row.FNMHG}"/>
                  		<option value ="${full_name}"  ${full_name eq resultData.ENAME ? 'selected' : '' }>${full_name}</option>
					</c:forEach>
                  </select>
                </td>
              </tr>
            </table>
        </div>
    </div>

    <h2 class="subtitle"><spring:message code="LABEL.E.E02.0001" /><!-- 기재사항변경 --></h2>
    <div class="tableArea">
        <div class="table">
            <table class="tableGeneral tableApproval">
               <colgroup>
					<col width="15%" />
					<col width="35%" />
					<col width="15%" />
					<col width="35%" />
				</colgroup>
                <tr>
                  <th><span class="textPink">*</span><spring:message code="LABEL.E.E02.0002" /><!-- 변경항목 --></th>
                  <td colspan="3">
                    <select name="APPL_TYPE3" onChange="javascript:check_type1(this);"  ${!empty resultData.APPL_TYPE3 ? '' : 'disabled'} style="width:200px">
                      <option>---------------------</option>
                      ${f:printCodeOption( e02MedicareEnroll_vt , resultData.APPL_TYPE3)}
                    </select>
                    <span style="visibility:${empty resultData.ETC_TEXT3  ? 'hidden' : 'visible'}"><input type="text" name="ETC_TEXT3"  value="${resultData.ETC_TEXT3}" size="60" onKeyUp="check_length(this,60)" value="${resultData.ETC_TEXT3}"  ${!empty resultData.ETC_TEXT3 ? '' : 'disabled'} ></span>
                  </td>
                </tr>
                <tr>
                  <th><span class="textPink">*</span><spring:message code="LABEL.E.E02.0003" /><!-- 변경전Data --></th>
                  <td>
                    <input type="text" name="CHNG_BEFORE" style="width:195px" onKeyUp="check_length(this,60)"  value="${resultData.CHNG_BEFORE}" ${!empty resultData.CHNG_BEFORE ? '' : 'disabled'}>
                  </td>
                  <th class="th02"><span class="textPink">*</span><spring:message code="LABEL.E.E02.0004" /><!-- 변경후Data --></th>
                  <td>
                    <input type="text" name="CHNG_AFTER" size="30" onKeyUp="check_length(this,60)" value="${resultData.CHNG_AFTER}" ${!empty resultData.CHNG_AFTER ? '' : 'disabled'}>
                  </td>
                </tr>
              </table>
        </div>
    </div>
    <h2 class="subtitle"><spring:message code="LABEL.E.E02.0005" /><!-- 추가발급 --></h2>
    <div class="tableArea">
        <div class="table">
              <table class="tableGeneral tableApproval">
              	<colgroup>
					<col width="15%" />
					<col  />
				</colgroup>
                <tr>
                  <th><span class="textPink">*</span><spring:message code="LABEL.E.E02.0006" /><!-- 발급사유 --></th>
                  <td>
                    <select name="APPL_TYPE4" onChange="javascript:check_type2(this);" ${!empty resultData.APPL_TYPE4 ? '' : 'disabled'}  style="width:200px">
                      <option>---------------------</option>
                      ${f:printCodeOption( e02MedicareIssue_vt ,resultData.APPL_TYPE4)}
                    </select>
                    <span style="visibility:${empty resultData.ETC_TEXT4  ? 'hidden' : 'visible'}"><input type="text" name="ETC_TEXT4" value="${resultData.ETC_TEXT4}" size="60" onKeyUp="check_length(this,60)" ${!empty resultData.ETC_TEXT4 ? '' : 'disabled'}></span>
                  </td>
                </tr>
                <tr>
                  <th ><spring:message code="LABEL.E.E02.0007" /><!-- 발행부수 --></th>
                  <td><input type="text" name="ADD_NUM" size="2" maxlength="3" style="text-align:right" value="${resultData.ADD_NUM eq '000'  ? ''  : f:printNum(resultData.ADD_NUM)}"  onBlur="onlyNumber(this,'<spring:message code="LABEL.E.E02.0007" />')" ${!empty resultData.ADD_NUM ? '' : 'disabled'}></td>
                  <%-- <td><input type="text" name="ADD_NUM" size="2" maxlength="3" style="text-align:right" value="${resultData.ADD_NUM eq '000'  ? ''  : f:printNum(resultData.ADD_NUM)}"  onBlur="onlyNumber(this,'발행부수')" ${!empty resultData.ADD_NUM ? '' : 'disabled'}></td> --%>
                </tr>
              </table>
        </div>
    </div>
    <h2 class="subtitle"><spring:message code="LABEL.E.E02.0008" /><!-- 재발급 --></h2>
    <div class="tableArea">
        <div class="table">
          <table class="tableGeneral tableApproval">
          	<colgroup>
					<col width="15%" />
					<col  />

			</colgroup>
            <tr>
              <th><span class="textPink">*</span><spring:message code="LABEL.E.E02.0009" /><!-- 신청사유 --></th>
              <td>
                <select name="APPL_TYPE5" onChange="javascript:check_type3(this);" ${!empty resultData.APPL_TYPE5 ? '' : 'disabled'} style="width:200px">
                  <option>---------------------</option>
                  ${f:printCodeOption( e02MedicareReIssue_vt ,resultData.APPL_TYPE5)}
                </select>
                <span style="visibility:${empty resultData.ETC_TEXT5 ? 'hidden' : 'visible'}"><input type="text" name="ETC_TEXT5" value="${resultData.ETC_TEXT5}" size="60" onKeyUp="check_length(this,60)" ${!empty resultData.ETC_TEXT5 ? '' : 'disabled'}></span>
              </td>
            </tr>
            <tr>
              <th><spring:message code="LABEL.E.E02.0007" /><!-- 발행부수 --></th>
              <td><input type="text" name="ADD_NUM1" size="2" maxlength="3" style="text-align:right"  value="${resultData.ADD_NUM1 eq '000'  ? ''  : f:printNum(resultData.ADD_NUM1)}"  onBlur="onlyNumber(this,'<spring:message code="LABEL.E.E02.0007" />')" ${!empty resultData.ADD_NUM1  ? '' : 'disabled'}></td>
              <%-- <td><input type="text" name="ADD_NUM1" size="2" maxlength="3" style="text-align:right"  value="${resultData.ADD_NUM1 eq '000'  ? ''  : f:printNum(resultData.ADD_NUM1)}"  onBlur="onlyNumber(this,'발행부수')" ${!empty resultData.ADD_NUM1  ? '' : 'disabled'}></td> --%>
            </tr>
          </table>
        </div>
        <div class="commentImportant" style="width:640px;">
            <p><spring:message code="LABEL.E.E02.0010" /><!-- ※ 제출서류 : 기재사항변경의 경우 주민등록등본, 건강보험증 각 1부 --></p>
        </div>
        <p class="commentOne"><span class="textPink">*</span><spring:message code="LABEL.E.E02.0011" /><!-- 는 필수 입력사항입니다(신청구분(기재사항변경/추가발급/재발급)에 따라 필수 입력사항이 변동됩니다). --></p>
    </div>
    <!--상단 입력 테이블 끝-->

<!---- hidden --------->
    <input type="hidden" name="SUBTY" value="">
    <input type="hidden" name="OBJPS" value="">

    <input type="hidden" name="SUBTY_name0" value="">
    <input type="hidden" name="OBJPS_name0" value="">
	<c:forEach var="row" items="${targetName_vt}" varStatus="status">
    	<input type="hidden" name="SUBTY_name${status.count}" value="${row.SUBTY}" >
    	<input type="hidden" name="OBJPS_name${status.count}"  value="${row.OBJPS}" >
	</c:forEach>
<!---- hidden --------->

    </tags-approval:request-layout>

</tags:layout>