<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 건강보험 피부양자 신청                                      */
/*   Program Name : 건강보험 피부양자 취득/상실 신청                            */
/*   Program ID   : E01MedicareBuild.jsp                                        */
/*   Description  : 건강보험 피부양자 자격(취득/상실)신청 하는 화면             */
/*   Note         :                                                             */
/*   Creation     : 2002-01-03  김도신                                          */
/*   Update       : 2005-02-17  윤정현                                          */
/*                  2006-11-13  @v1.0 lsa 관계추가                              */
/*                  2016.05.19 [CSR ID:3059290] HR제도 팝업 관련 개선 요청의 건                                                            */
/*                  2016.10.18 [CSR ID:3194400] HR제도안내 및 신청화면 수정 건 김불휘S                                      */
/*                  2017.07.11 [CSR ID:3430058] HR제도안내 수정 건 eunha                                      */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.E.E01Medicare.*" %>
<%@ page import="hris.E.E01Medicare.rfc.*" %>
<%@ page import="hris.A.rfc.*" %>
<%@ page import="hris.A.*" %>
<%@ page import="com.sns.jdf.servlet.Box" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tags-approval" tagdir="/WEB-INF/tags/approval" %>
<c:set var="user" value="<%=WebUtil.getSessionUser(request) %>"/>
<c:set var="buttonBody" value="${g.bodyContainer}" />

<tags:body-container bodyContainer="${buttonBody}">

	<c:if test ="${ThisJspName eq 'A04FamilyDetail_KR.jsp'}">
        <li><a href="javascript:do_preview();"><span><spring:message code='BUTTON.COMMON.BACK.PREVIOUS' /><!-- 이전화면 --></span></a></li>
	</c:if>
</tags:body-container>
<%
    WebUserData user = WebUtil.getSessionUser(request);

    /* 가족리스트, 취득사유, 상실사유, 장애인 종별부호를 vector로 받는다*/
    Vector  e01TargetNameData_vt       = (Vector)request.getAttribute("e01TargetNameData_vt");
    Vector  e01HealthGuarAccqData_vt   = (Vector)request.getAttribute("e01HealthGuarAccqData_vt");
    Vector  e01HealthGuarLossData_vt   = (Vector)request.getAttribute("e01HealthGuarLossData_vt");
    Vector  e01HealthGuarHintchData_vt = (Vector)request.getAttribute("e01HealthGuarHintchData_vt");

    /*--------------- 2002.06.05. 여러건을 한번에 신청하도록 수정 ---------------*/
    /* 현재 레코드를 vector로 받는다*/
    String jobid                     = (String)request.getAttribute("jobid");
    Vector e01HealthGuaranteeData_vt = new Vector();
     e01HealthGuaranteeData_vt      = (Vector)request.getAttribute("e01HealthGuaranteeData_vt");
    /*--------------- 2002.06.05. 여러건을 한번에 신청하도록 수정 ---------------*/

    /* 결제정보를 vector로 받는다*/
    /* 신청화면에 들어온 경로를 체크한다 */
    String ThisJspName = (String)request.getAttribute("ThisJspName");

    String subty = "";
    String objps = "";

    if( ThisJspName.equals("A04FamilyDetail_KR.jsp") ) {    // 가족사항 신규입력 확인에서 신청할경우..
      subty = (String)request.getAttribute("subty");
      objps = (String)request.getAttribute("objps");
    }
    E01HealthGuaranteeData edata = (E01HealthGuaranteeData)request.getAttribute("e01HealthGuaranteeData");
    DataUtil.fixNull(edata);

    A04FamilyDetailRFC   rfcF   = new A04FamilyDetailRFC();
    Vector family_vt = new Vector();
    Box fbox = WebUtil.getBox(request);
    fbox.put("I_PERNR",edata.PERNR);
    fbox.put("I_MOLGA", "41");


    family_vt = rfcF.getFamilyDetail(fbox);

%>
<c:set var="e01HealthGuaranteeData_vt_size" value="<%=e01HealthGuaranteeData_vt.size() %>"/>
<c:set var="ThisJspName" value="<%=ThisJspName %>"/>
<c:set var="subty" value="<%=subty %>"/>
<c:set var="objps" value="<%=objps %>"/>
<c:set var="family_vt_size" value="<%=family_vt.size() %>"/>
<c:set var="family_vt" value="<%=family_vt %>"/>
<c:set var="actionUrl" value= "${g.servlet}hris.E.E01Medicare.${isUpdate ? 'E01MedicareChangeSV' : 'E01MedicareBuildSV'}"/>





<tags:layout css="ui_library_approval.css">

    <tags-approval:request-layout titlePrefix="TAB.COMMON.0051"   subtitleCode = "${ThisJspName eq 'A04FamilyDetail_KR.jsp'? 'TAB.COMMON.0051':''  }"  button="${buttonBody}"  requestURL =  "${g.servlet}hris.E.E01Medicare.${isUpdate ? 'E01MedicareChangeSV' : 'E01MedicareBuildSV'}">
                <tags:script>
                    <script>


// 달력 사용
function changeCal(obj){
    if( document.form1.gubun.value == 1 ) {                  // 자격취득
      field_name = "ACCQ_DATE";
    } else if( document.form1.gubun.value == 2 ) {           // 자격상실
      field_name = "LOSS_DATE";
    } else {
      alert("<spring:message code='MSG.E.E01.0001' />"); //신청구분을 확인하세요.
      return;
    }

    if( obj.name != field_name) {
      alert("<spring:message code='MSG.E.E01.0001' />"); //신청구분을 확인하세요.
      obj.value="";
    }
}

function change_type(obj) {
    var p_idx = obj.selectedIndex;

    if( p_idx == 0 ) {
        document.form1.ACCQ_DATE.value = ""
        document.form1.LOSS_DATE.value = ""
        document.form1.ACCQ_TYPE.value = ""
        document.form1.LOSS_TYPE.value = ""

        document.form1.ACCQ_DATE.readOnly = 1;
        document.form1.LOSS_DATE.readOnly = 1;
        document.form1.ACCQ_TYPE.disabled = 1;
        document.form1.LOSS_TYPE.disabled = 1;

        document.form1.gubun.value = "0";
    } else if( p_idx == 1 ) {           // 자격취득
        document.form1.LOSS_DATE.value = ""
        document.form1.LOSS_TYPE.value = ""

        document.form1.ACCQ_DATE.readOnly = 0;
        document.form1.LOSS_DATE.readOnly = 1;
        document.form1.ACCQ_TYPE.disabled = 0;
        document.form1.LOSS_TYPE.disabled = 1;

        document.form1.gubun.value = "1";
    } else if( p_idx == 2 ) {           // 자격상실
        document.form1.ACCQ_DATE.value = ""
        document.form1.ACCQ_TYPE.value = ""

        document.form1.ACCQ_DATE.readOnly = 1;
        document.form1.LOSS_DATE.readOnly = 0;
        document.form1.ACCQ_TYPE.disabled = 1;
        document.form1.LOSS_TYPE.disabled = 0;

        document.form1.gubun.value = "2";
    }
}

function change_name(obj) {
    var p_idx = obj.selectedIndex - 1;

    if( p_idx >= 0 ) {
        eval("document.form1.SUBTY.value = document.form1.SUBTY_name" + p_idx + ".value");
        eval("document.form1.OBJPS.value = document.form1.OBJPS_name" + p_idx + ".value");
        //alert("선택한 subty : " +eval("document.form1.SUBTY_name" + p_idx + ".value"));
    } else {
        document.form1.SUBTY.value = "";
        document.form1.OBJPS.value = "";
    }
    change_subtyname(obj.value, eval("document.form1.SUBTY_name" + p_idx + ".value") );//어머니, 처 동명이인 발생
}
//@v1.0 관계추가
function change_subtyname(val, val2) {
    document.form1.SUBTY_INAME.value = "";
    for ( r=0; r<${family_vt_size}; r++) {
        if (val==eval("document.form1.SUBTY_INM"+r+".value") && val2==eval("document.form1.SUBTY_INDEX"+r+".value") ){
             eval("document.form1.SUBTY_INAME.value = document.form1.SUBTY_IATEXT" + r + ".value");
        }
    }

}

function change_hitch(obj) {
    var p_idx = obj.selectedIndex;

    if( p_idx == 0 ) {
        document.form1.HITCH_TYPE.value  = "";
        document.form1.HITCH_TEXT.value  = "";
        document.form1.HITCH_GRADE.value = "";
        document.form1.HITCH_DATE.value  = "";
    }
}


function doSubmit() {
	 if( ${e01HealthGuaranteeData_vt_size} < 1 ) {
        alert("<spring:message code='MSG.E.E01.0002' />"); //신청할 데이터가 저장되지 않았습니다.
        return;
    }
    document.form1.BEGDA.value = removePoint(document.form1.BEGDA.value);
    document.form1.jobid.value = "create";
    alert("<spring:message code='MSG.E.E01.0003' />"); //주민등록 등본이나 가족관계증명서등의 관련 서류를 주관부서로 보내주셔야만 승인이 이루어 집니다.
	return true;
}
function beforeSubmit() {
	if ( doSubmit()) 	{
		return true;
	}
}


/*--------------- 2002.06.05. 여러건을 한번에 신청하도록 수정 ---------------*/
// 저장버튼 클릭시.. 추가인지 수정에 대한 저장인지 구분 실행한다.
function click_save_btn(){
    val = document.form1.addOrChangeFlag.value ;
    if( val == 'add' ){
        doAdd();
    }else if( val == 'change' ){
        if( check_data() ) {
            doChange();
            document.form1.addOrChangeFlag.value = 'add';
        } else {
            document.form1.addOrChangeFlag.value = 'change';
        }
    }
}

// 취소버튼 입력화면을 초기화해준다.
function click_cancel() {
    document.form1.addOrChangeFlag.value = 'add';

    document.form1.APPL_TYPE.value      = "";
    document.form1.SUBTY.value          = "";
    document.form1.OBJPS.value          = "";

    document.form1.gubun.value          = "0";

    document.form1.ACCQ_DATE.value      = "";
    document.form1.ACCQ_TYPE.value      = "";
    document.form1.LOSS_DATE.value      = "";
    document.form1.LOSS_TYPE.value      = "";
    document.form1.ACCQ_DATE.readOnly   = 0;
    document.form1.LOSS_DATE.readOnly   = 0;
    document.form1.ACCQ_TYPE.disabled   = 0;
    document.form1.LOSS_TYPE.disabled   = 0;

    document.form1.HITCH_TYPE.value     = "";
    document.form1.HITCH_TEXT.value     = "";
    document.form1.HITCH_GRADE.value    = "";
    document.form1.HITCH_DATE.value     = "";
    document.form1.APPL_TEXT.value      = "";
    document.form1.ACCQ_LOSS_TEXT.value = "";
    document.form1.ENAME.value          = "";

    document.form1.APRT_CODE.value      = "";
    document.form1.APRT_CODE.checked    = false;
}

// 추가
function doAdd() {
    document.form1.jobid.value = "add";
    if( check_data() ) {
        document.form1.RowCount_data.value = "${e01HealthGuaranteeData_vt_size+1}";

        document.form1.use_flag${e01HealthGuaranteeData_vt_size}.value       = "Y";
        document.form1.APPL_TYPE${e01HealthGuaranteeData_vt_size}.value      = document.form1.APPL_TYPE.value;
        document.form1.SUBTY${e01HealthGuaranteeData_vt_size}.value          = document.form1.SUBTY.value;
        document.form1.OBJPS${e01HealthGuaranteeData_vt_size}.value          = document.form1.OBJPS.value;
        document.form1.ACCQ_LOSS_DATE${e01HealthGuaranteeData_vt_size}.value = document.form1.ACCQ_LOSS_DATE.value;
        document.form1.ACCQ_LOSS_TYPE${e01HealthGuaranteeData_vt_size}.value = document.form1.ACCQ_LOSS_TYPE.value;
        document.form1.HITCH_TYPE${e01HealthGuaranteeData_vt_size}.value     = document.form1.HITCH_TYPE.value;
        document.form1.HITCH_GRADE${e01HealthGuaranteeData_vt_size}.value    = document.form1.HITCH_GRADE.value;
        document.form1.HITCH_DATE${e01HealthGuaranteeData_vt_size}.value     = document.form1.HITCH_DATE.value;
        document.form1.APPL_TEXT${e01HealthGuaranteeData_vt_size}.value      = document.form1.APPL_TEXT.value;
        document.form1.ACCQ_LOSS_TEXT${e01HealthGuaranteeData_vt_size}.value = document.form1.ACCQ_LOSS_TEXT.value;
        document.form1.HITCH_TEXT${e01HealthGuaranteeData_vt_size}.value     = document.form1.HITCH_TEXT.value;
        document.form1.ENAME${e01HealthGuaranteeData_vt_size}.value          = document.form1.ENAME.value;

        if( document.form1.APRT_CODE.checked ) {
          document.form1.APRT_CODE${e01HealthGuaranteeData_vt_size}.value    = "X";
        } else {
          document.form1.APRT_CODE${e01HealthGuaranteeData_vt_size}.value    = "";
        }

        document.form1.action ="${actionUrl}";
        document.form1.method = "post";
        document.form1.submit();
    }
}

// 수정
function doChange() {
    document.form1.jobid.value = "add";

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
            command = i+"";
        }
    }

    eval("document.form1.APPL_TYPE"      +command+".value = document.form1.APPL_TYPE.value");
    eval("document.form1.SUBTY"          +command+".value = document.form1.SUBTY.value");
    eval("document.form1.OBJPS"          +command+".value = document.form1.OBJPS.value");
    eval("document.form1.ACCQ_LOSS_DATE" +command+".value = document.form1.ACCQ_LOSS_DATE.value");
    eval("document.form1.ACCQ_LOSS_TYPE" +command+".value = document.form1.ACCQ_LOSS_TYPE.value");
    eval("document.form1.HITCH_TYPE"     +command+".value = document.form1.HITCH_TYPE.value");
    eval("document.form1.HITCH_TEXT"     +command+".value = document.form1.HITCH_TEXT.value");
    eval("document.form1.HITCH_GRADE"    +command+".value = document.form1.HITCH_GRADE.value");
    eval("document.form1.HITCH_DATE"     +command+".value = document.form1.HITCH_DATE.value");
    eval("document.form1.APPL_TEXT"      +command+".value = document.form1.APPL_TEXT.value");
    eval("document.form1.ACCQ_LOSS_TEXT" +command+".value = document.form1.ACCQ_LOSS_TEXT.value");
    eval("document.form1.ENAME"          +command+".value = document.form1.ENAME.value");

    if( document.form1.APRT_CODE.checked ) {
      eval("document.form1.APRT_CODE"    +command+".value = 'X'");
    } else {
      eval("document.form1.APRT_CODE"    +command+".value = ''");
    }

    document.form1.action = "${actionUrl}";
    document.form1.method = "post";
    document.form1.submit();
}

// 수정될 항목들 화면에 뿌리기
function show_change() {
    document.form1.addOrChangeFlag.value = 'change';

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
            command = i+"";
        }
    }

    eval("document.form1.APPL_TYPE.value = document.form1.APPL_TYPE" +command+".value");
    eval("document.form1.SUBTY.value     = document.form1.SUBTY"     +command+".value");
    eval("document.form1.OBJPS.value     = document.form1.OBJPS"     +command+".value");

    if( document.form1.APPL_TYPE.value == "0001" ) {                  // 자격취득
        eval("document.form1.ACCQ_DATE.value = addPointAtDate(document.form1.ACCQ_LOSS_DATE" +command+".value)");
        eval("document.form1.ACCQ_TYPE.value = document.form1.ACCQ_LOSS_TYPE" +command+".value");

        document.form1.LOSS_DATE.value = "";
        document.form1.LOSS_TYPE.value = "";

        document.form1.ACCQ_DATE.readOnly = 0;
        document.form1.LOSS_DATE.readOnly = 1;
        document.form1.ACCQ_TYPE.disabled = 0;
        document.form1.LOSS_TYPE.disabled = 1;

        document.form1.gubun.value = "1";
    } else if( document.form1.APPL_TYPE.value == "0002" ) {           // 자격상실
        document.form1.ACCQ_DATE.value = "";
        document.form1.ACCQ_TYPE.value = "";

        eval("document.form1.LOSS_DATE.value = addPointAtDate(document.form1.ACCQ_LOSS_DATE" +command+".value)");
        eval("document.form1.LOSS_TYPE.value = document.form1.ACCQ_LOSS_TYPE" +command+".value");

        document.form1.ACCQ_DATE.readOnly = 1;
        document.form1.LOSS_DATE.readOnly = 0;
        document.form1.ACCQ_TYPE.disabled = 1;
        document.form1.LOSS_TYPE.disabled = 0;

        document.form1.gubun.value = "2";
    }

    eval("document.form1.HITCH_TYPE.value     = document.form1.HITCH_TYPE"     +command+".value");
    if( document.form1.HITCH_TYPE.value == "" ) {
        document.form1.HITCH_TYPE.value = "";
        document.form1.HITCH_TEXT.value = "";
    } else {
        eval("document.form1.HITCH_TEXT.value   = document.form1.HITCH_TEXT"     +command+".value");
    }
    eval("document.form1.HITCH_GRADE.value    = document.form1.HITCH_GRADE"    +command+".value");
    eval("document.form1.HITCH_DATE.value     = addPointAtDate(document.form1.HITCH_DATE"     +command+".value)");
    eval("document.form1.APPL_TEXT.value      = document.form1.APPL_TEXT"      +command+".value");
    eval("document.form1.ACCQ_LOSS_TEXT.value = document.form1.ACCQ_LOSS_TEXT" +command+".value");
    eval("document.form1.ENAME.value          = document.form1.ENAME"          +command+".value");

    //@v1.0 대상자관계
    change_subtyname(eval("document.form1.ENAME"+command+".value"), eval("document.form1.SUBTY"+command+".value"));

    if( eval("document.form1.APRT_CODE"+command+".value") == "X" ) {
        document.form1.APRT_CODE.checked = true;
    } else {
        document.form1.APRT_CODE.checked = false;
    }
}

// 삭제
function doDelete() {
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
          command = i+"";
      }
    }

    eval("document.form1.use_flag"+command+".value = 'N'");
    document.form1.jobid.value = "add";
    document.form1.action = "${actionUrl}";
    document.form1.method = "post";
    document.form1.submit();
}
/*--------------- 2002.06.05. 여러건을 한번에 신청하도록 수정 ---------------*/

function check_data(){
    if( document.form1.APPL_TYPE.selectedIndex == 0 ) {
      alert("<spring:message code='MSG.E.E01.0004' />"); //신청구분을 선택하세요.
      document.form1.APPL_TYPE.focus();
      return false;
    }

    //자격취득, 자격상실을 구분해서 신청하도록 체크해준다.
    if( document.form1.RowCount_data.value == "0" ) {
      //
    } else {
        if( document.form1.APPL_TYPE.value != document.form1.APPL_TYPE0.value ) {
          alert("<spring:message code='MSG.E.E01.0005' />"); //자격취득, 자격상실을 구분해서 신청해주세요.\n\n동일한 신청구분만 저장 가능합니다.
          document.form1.APPL_TYPE.focus();
          return false;
        }
    }
    //자격취득, 자격상실을 구분해서 신청하도록 체크해준다.

    if( document.form1.ENAME.selectedIndex == 0 ) {
      alert("<spring:message code='MSG.E.E01.0006' />"); //대상자 성명을 선택하세요.
      document.form1.ENAME.focus();
      return false;
    }

    if( document.form1.gubun.value == "1" ) {
      if( checkNull(document.form1.ACCQ_DATE, "<spring:message code='MSG.E.E01.0010' />") == false ) {  //취득일자를
        document.form1.ACCQ_DATE.focus();
        return false;
      }

      if( document.form1.ACCQ_TYPE.selectedIndex == 0 ) {
        alert("<spring:message code='MSG.E.E01.0007' />");//취득사유을 선택하세요.
        document.form1.ACCQ_TYPE.focus();
        return false;
      }
    } else if( document.form1.gubun.value == "2" ) {
      if( checkNull(document.form1.LOSS_DATE, "<spring:message code='MSG.E.E01.0011' />") == false ) { //상실일자를
        document.form1.LOSS_DATE.focus();
        return false;
      }

      if( document.form1.LOSS_TYPE.selectedIndex == 0 ) {
        alert("<spring:message code='MSG.E.E01.0008' />"); //상실사유을 선택하세요.
        document.form1.LOSS_TYPE.focus();
        return false;
      }
    }

    if( document.form1.HITCH_TYPE.selectedIndex == 0 ) {
      if( document.form1.HITCH_DATE.value != "" || document.form1.HITCH_GRADE.value != "" ) {
        alert("<spring:message code='MSG.E.E01.0009' />"); //장애 종별부호를 선택하세요.
        document.form1.HITCH_TYPE.focus();
        return false;
      }
    }

    if( document.form1.gubun.value == "1" ) {            // 취득
      document.form1.ACCQ_LOSS_DATE.value = removePoint(document.form1.ACCQ_DATE.value);
      document.form1.ACCQ_LOSS_TYPE.value =             document.form1.ACCQ_TYPE.value;

      document.form1.ACCQ_LOSS_TEXT.value = document.form1.ACCQ_TYPE.options[document.form1.ACCQ_TYPE.selectedIndex].text;
    } else if( document.form1.gubun.value == "2" ) {     // 상실
      document.form1.ACCQ_LOSS_DATE.value = removePoint(document.form1.LOSS_DATE.value);
      document.form1.ACCQ_LOSS_TYPE.value =             document.form1.LOSS_TYPE.value;

      document.form1.ACCQ_LOSS_TEXT.value = document.form1.LOSS_TYPE.options[document.form1.LOSS_TYPE.selectedIndex].text;
    }

    document.form1.APPL_TEXT.value  = document.form1.APPL_TYPE.options[document.form1.APPL_TYPE.selectedIndex].text;

    if( document.form1.HITCH_TYPE.selectedIndex != 0 ) {
      if( checkNull(document.form1.HITCH_GRADE, "<spring:message code='MSG.E.E01.0012' />") == false ) { //장애 등급을
        return false;
      }

      if( checkNull(document.form1.HITCH_DATE, "<spring:message code='MSG.E.E01.0013' />") == false ) { //장애 등록일을
        return false;
      }

      document.form1.HITCH_TEXT.value = document.form1.HITCH_TYPE.options[document.form1.HITCH_TYPE.selectedIndex].text;
      document.form1.HITCH_DATE.value = removePoint(document.form1.HITCH_DATE.value);
    }

  return true;
}

function do_preview(){
    document.form1.jobid.value = "first";

    document.form1.action = "${g.servlet}hris.A.A04FamilyDetailSV";
    document.form1.method = "post";
    document.form1.submit();
}

function reload() {
    frm =  document.form1;
    frm.jobid.value = "first";
    frm.action = "${actionUrl}"
    frm.target = "";
    frm.submit();
}
$(function() {
	 if(parent.resizeIframe) parent.resizeIframe(document.body.scrollHeight);
});
                    </script>
                </tags:script>

    <!-- 상단 입력 테이블 시작-->
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
                    <th ><span class="textPink">*</span><spring:message code='LABEL.E.E22.0042' /><!-- 신청구분 --></th>
                    <td >
                    	<input type="hidden" name="BEGDA" value="${f:printDate(approvalHeader.RQDAT)}">
                        <select name="APPL_TYPE" onChange="javascript:change_type(this);">
                            <option value="">-------------</option>
                              ${ f:printCodeOption( e01HealthGuarReqsData_vt , '') }
                            </select>
                     </td>
                    <th class="th02"><span class="textPink">*</span><spring:message code='LABEL.E.E01.0002' /><!-- 대상자 성명 --></th>
                    <td>
                    <select name="ENAME" onChange="javascript:change_name(this);" style="width:100px">
                        <option value="">--------------</option>
                        <c:forEach var="row" items="${e01TargetNameData_vt}" varStatus="status">
                        <c:set var="name" value="${row.LNMHG} ${row.FNMHG}"/>
                        <option value="${name }" ${row.SUBTY eq subty and row.OBJPS eq objps ? 'selected' :  '' }>${name}</option>
   						</c:forEach>
                   </select>
                  		<input type="text" name="SUBTY_INAME" size=10 readonly>
                  		<a href="javascript:open_rule('Rule02Benefits01.html');" class="inlineBtn unloading" style="float:right"><span><spring:message code='LABEL.E.E01.0001' /><!-- 피부양자 자격요건 --></span></a>
							<c:forEach var="row" items="${family_vt}" varStatus="status">
								<c:set var="fname" value="${row.LNMHG} ${row.FNMHG}"/>
								<input type="hidden" name="SUBTY_INM${status.index}" value="${fname}" size="14" readonly>
								<input type="hidden" name="SUBTY_IATEXT${status.index}" value="${row.ATEXT}" size="14" readonly>
								<input type="hidden" name="SUBTY_INDEX${status.index}" value="${row.SUBTY}"  size="14" readonly>
							</c:forEach>
                  		<input type="hidden" name="APRT_CODE" value="" size="14" class="input03">
            			</td>
                  </tr>
          <tr>
            <th><span class="textPink">*</span><spring:message code='LABEL.E.E01.0003' /><!-- 취득일자 --></th>
            <td>
                <input type="text" name="ACCQ_DATE" size="14" readonly class="date" onChange="javascript:changeCal(this)">

            </td>
            <th class="th02"><span class="textPink">*</span><spring:message code='LABEL.E.E01.0004' /><!-- 취득사유 --></th>
            <td> <select name="ACCQ_TYPE" disabled style="width:240px">
                <option value="">-----------------------</option>
                ${ f:printCodeOption( e01HealthGuarAccqData_vt , '') } </select>
             </td>
          </tr>
          <tr>
            <th><span class="textPink">*</span><spring:message code='LABEL.E.E01.0005' /><!-- 상실일자 --></th>
            <td>
                <input type="text" name="LOSS_DATE" size="14" class="date" readonly onChange="javascript:changeCal(this)">

            </td>
            <th class="th02"><span class="textPink">*</span><spring:message code='LABEL.E.E01.0006' /><!-- 상실사유 --></th>
            <td> <select name="LOSS_TYPE" disabled style="width:240px">
                <option value="">-----------------------</option>
                ${ f:printCodeOption( e01HealthGuarLossData_vt , '') }</select>
             </td>
          </tr>
          <tr>
            <th><spring:message code='LABEL.E.E01.0007' /><!-- 장애인 --></th>
            <td colspan="3">
                <table class="innerTable" border="0" cellspacing="0" cellpadding="0" width="89%">
                  <colgroup>
            		<col width="10%" />
            		<col width="20%" />
            		<col width="10%" />
            		<col width="20%" />
            		<col width="10%" />
            		<col width="20%" />
            	</colgroup>
                    <tr>
                      <th class="noBtBorder" ><spring:message code='LABEL.E.E01.0008' /><!-- 종별부호 --></th>
                      <td class="noBtBorder" ><select name="HITCH_TYPE" onChange="javascript:change_hitch(this);" style="width:100px">
                          <option value="">----------</option>
                          ${ f:printCodeOption( e01HealthGuarHintchData_vt , '') } </select>
                      </td>
                      <th class="noBtBorder"><spring:message code='LABEL.E.E21.0007' /><!-- 등급 --></th>
                      <td class="noBtBorder" >
                        <input type="text" name="HITCH_GRADE" size="5" maxlength="2" onBlur="onlyNumber(this, '등급');">
                      </td>
                      <th class="noBtBorder" ><spring:message code='LABEL.E.E01.0009' /><!-- 등록일 --></th>
                      <td class="noBtBorder noRtBorder" >
                        <input type="text" name="HITCH_DATE" size="14" class="date">
                      </td>
                      </td>
                    </tr>
                </table>
             </td>
          </tr>
        </table>
        </div>
        <div class="buttonArea">
            <ul class="btn_crud">
                <li><a href="javascript:click_save_btn();"><span><spring:message code='BUTTON.COMMON.SAVE' /><!-- 저장 --></span></a></li>
                <li><a href="javascript:click_cancel();"><span><spring:message code='BUTTON.COMMON.CANCEL' /><!-- 취소 --></span></a></li>
            </ul>
        </div>
        <%-- [CSR ID:3430058] HR제도안내 수정 건 start--%>
        <div class="commentImportant" style="width:640px;">
             <!--[CSR ID:3194400] HR제도안내 및 신청화면 수정 건 <p><strong>※ 제출서류 : 가족관계증명서 또는 주민등록등본</strong></p> -->
            <%--
            <p><strong><spring:message code='LABEL.E.E01.0010' /><!-- ※ 제출서류 : 화면 상단의 피부양자 자격요건 메뉴 참고 --></strong></p>
            <p><spring:message code='LABEL.E.E01.0011' /><!-- (단, 사망의 경우 건강보험증, 사망진단서 또는 가족관계증명서 1부) --></p>
            --%>
            <p><strong><spring:message code='LABEL.E.E01.0015' /><!-- ※ 제출서류 --></strong></p>
            <p><spring:message code='LABEL.E.E01.0016' /><!-- . 동거시 : 구비서류 생략 가능 --></p>
            <p><spring:message code='LABEL.E.E01.0017' /><!-- . 비동거시 : <u>신청대상 가족 명의</u> 가족관계증명서 1부--></p>
            <p><spring:message code='LABEL.E.E01.0018' /><!-- ※ 배우자 최초 등재시 : 혼인관계증명서'(상세)'본 제출必 --></p>
            <p><spring:message code='LABEL.E.E01.0019' /><!-- ※ 상세사항은 화면 우측상단의 피부양자 자격요건 메뉴 참고 --></p>
            <%-- [CSR ID:3430058] HR제도안내 수정 건 end --%>
        </div>
    <p class="commentOne"><span class="textPink">*</span><spring:message code='LABEL.E.E01.0012' /><!-- 는 필수 입력사항입니다(신청구분(취득/상실)에 따라 필수 입력사항이 변동됩니다). --></p>
    </div>
    <!--상단 입력 테이블 끝-->

<c:if test ="${e01HealthGuaranteeData_vt_size>0}">
    <div class="listArea">
        <div class="table">
            <table class="listTable">
               <thead>
                <tr>
                  <th><spring:message code='LABEL.COMMON.0014' /><!-- 선택 --></th>
                  <th><spring:message code='LABEL.E.E18.0034' /><!-- No. --></th>
                  <th><spring:message code='LABEL.E.E22.0042' /><!-- 신청구분 --></th>
                  <th><spring:message code='LABEL.E.E20.0004' /><!-- 대상자 --><br><spring:message code='MSG.APPROVAL.0013' /><!-- 성명 --></th>
                  <th><spring:message code='LABEL.E.E19.0053' /><!-- 관계 --></th>
                  <th><spring:message code='LABEL.E.E01.0003' /><!-- 취득일자 -->/<br><spring:message code='LABEL.E.E01.0005' /><!-- 상실일자 --></th>
                  <th><spring:message code='LABEL.E.E01.0004' /><!-- 취득사유 -->/<spring:message code='LABEL.E.E01.0006' /><!-- 상실사유 --></th>
                  <!-- [CSR ID:3194400] HR제도안내 및 신청화면 수정 건
                  <th>원격지<br>발급여부</th>-->
                  <th><spring:message code='LABEL.E.E01.0007' /><!-- 장애인 --><br><spring:message code='LABEL.E.E01.0008' /><!-- 종별부호 --></th>
                  <th><spring:message code='LABEL.E.E01.0007' /><!-- 장애인 --><br><spring:message code='LABEL.E.E21.0007' /><!-- 등급 --></th>
                  <th class="lastCol"><spring:message code='LABEL.E.E01.0007' /><!-- 장애인 --><br><spring:message code='LABEL.E.E01.0009' /><!-- 등록일 --></th>
                </tr>
                </thead>
				<c:forEach var="row1" items="${e01HealthGuaranteeData_vt}" varStatus="status1">
                <tr class="${f:printOddRow(status1.index)}">
                  <td><input type="radio" name="radiobutton" value="" ${status1.index} eq  '0' ? 'checked' : ''></td>
                  <td>${status1.count}</td>
                  <td>${row1.APPL_TEXT }</td>
                  <td>${row1.ENAME }</td>
                  <td>
             <c:forEach var="row" items="${family_vt}" varStatus="status">
             	<c:set var="fname" value="${row.LNMHG} ${row.FNMHG}"/>
             <c:if test ="${row.SUBTY eq row1.SUBTY and row1.ENAME eq fname }" >
             ${row.ATEXT }
             </c:if>

             </c:forEach>
                  </td>
                  <td>${f:printDate(row1.ACCQ_LOSS_DATE)}</td>
                  <td>${row1.ACCQ_LOSS_TEXT}</td>
                  <!-- [CSR ID:3194400] HR제도안내 및 신청화면 수정 건
                  <td>${row1.APRT_CODE eq 'X' ? 'Y' : ''}</td>-->
                  <td>${row1.HITCH_TEXT}</td>
                  <td>${row1.HITCH_GRADE eq '00' ? '' : row1.HITCH_GRADE}</td>
                  <td class="lastCol">${row1.HITCH_DATE eq '0000-00-00' ? '' : f:printDate(row1.HITCH_DATE)}
                  <input type="hidden" name="use_flag${status1.index}"      value="Y">
                  <input type="hidden" name="APPL_TYPE${status1.index}"     value="${row1.APPL_TYPE}">
                  <input type="hidden" name="SUBTY${status1.index}"          value="${row1.SUBTY}">
                  <input type="hidden" name="OBJPS${status1.index}"       value="${row1.OBJPS}">
                  <input type="hidden" name="ACCQ_LOSS_DATE${status1.index}" value="${f:printDate(row1.ACCQ_LOSS_DATE)}">
                  <input type="hidden" name="ACCQ_LOSS_TYPE${status1.index}" value="${row1.ACCQ_LOSS_TYPE}">
                  <input type="hidden" name="HITCH_TYPE${status1.index}"     value="${row1.HITCH_TYPE}">
                  <input type="hidden" name="HITCH_GRADE${status1.index}"    value="${row1.HITCH_GRADE eq '00' ? '' : row1.HITCH_GRADE}">
                  <input type="hidden" name="HITCH_DATE${status1.index}"     value="${row1.HITCH_DATE eq '0000-00-00' ? '' : f:printDate(row1.HITCH_DATE)}">
                  <input type="hidden" name="APPL_TEXT${status1.index}"      value="${row1.APPL_TEXT}">
                  <input type="hidden" name="ACCQ_LOSS_TEXT${status1.index}" value="${row1.ACCQ_LOSS_TEXT}">
                  <input type="hidden" name="HITCH_TEXT${status1.index}"     value="${row1.HITCH_TEXT}">
                  <input type="hidden" name="ENAME${status1.index}"          value="${row1.ENAME}">
                  <input type="hidden" name="APRT_CODE${status1.index}"      value="${row1.APRT_CODE}">
                  </td>
                </tr>
</c:forEach>
            </table>
        </div>

    <div class="buttonArea" style="margin-top:-10px">
        <ul class="btn_crud">
            <li><a href="javascript:show_change();"><span><spring:message code='BUTTON.COMMON.UPDATE' /><!-- 수정 --></span></a></li>
            <li><a href="javascript:doDelete();"><span><spring:message code='BUTTON.COMMON.DELETE' /><!-- 삭제 --></span></a></li>
        </ul>
    </div>
  </div>
</c:if>

          <input type="hidden" name="use_flag${e01HealthGuaranteeData_vt_size}"       value="N">
          <input type="hidden" name="APPL_TYPE${e01HealthGuaranteeData_vt_size}"      value="">
          <input type="hidden" name="SUBTY${e01HealthGuaranteeData_vt_size}"          value="">
          <input type="hidden" name="OBJPS${e01HealthGuaranteeData_vt_size}"          value="">
          <input type="hidden" name="ACCQ_LOSS_DATE${e01HealthGuaranteeData_vt_size}" value="">
          <input type="hidden" name="ACCQ_LOSS_TYPE${e01HealthGuaranteeData_vt_size}" value="">
          <input type="hidden" name="HITCH_TYPE${e01HealthGuaranteeData_vt_size}"     value="">
          <input type="hidden" name="HITCH_GRADE${e01HealthGuaranteeData_vt_size}"    value="">
          <input type="hidden" name="HITCH_DATE${e01HealthGuaranteeData_vt_size}"     value="">
          <input type="hidden" name="APPL_TEXT${e01HealthGuaranteeData_vt_size}"      value="">
          <input type="hidden" name="ACCQ_LOSS_TEXT${e01HealthGuaranteeData_vt_size}" value="">
          <input type="hidden" name="HITCH_TEXT${e01HealthGuaranteeData_vt_size}"     value="">
          <input type="hidden" name="ENAME${e01HealthGuaranteeData_vt_size}"          value="">
          <input type="hidden" name="APRT_CODE${e01HealthGuaranteeData_vt_size}"      value="">


    <!-- 결재자 입력 테이블 시작-->

    <!-- 결재자 입력 테이블 시작-->
<!--  HIDDEN  처리해야할 부분 시작-->
      <input type="hidden" name="gubun"           value="0">         <!--  신청구분 0:default, 1:취득, 2:상실 -->
      <input type="hidden" name="SUBTY"           value="${subty}">
      <input type="hidden" name="OBJPS"           value="${objps }">
      <input type="hidden" name="ACCQ_LOSS_DATE"  value="">
      <input type="hidden" name="ACCQ_LOSS_TYPE"  value="">
      <input type="hidden" name="ACCQ_LOSS_TEXT"  value="">
      <input type="hidden" name="APPL_TEXT"       value="">
      <input type="hidden" name="HITCH_TEXT"      value="">
      <input type="hidden" name="RowCount_data"   value="${e01HealthGuaranteeData_vt_size }">
      <input type="hidden" name="addOrChangeFlag" value="add">
      <input type="hidden" name="ThisJspName"     value="${ThisJspName }">
      <input type="hidden" name="isUpdate"     value="${isUpdate}">

      <c:forEach var="row" items="${e01TargetNameData_vt}" varStatus="status">
    	  <input type="hidden" name="SUBTY_name${status.index}" value="${row.SUBTY}" >
      	  <input type="hidden" name="OBJPS_name${status.index}"  value="${row.OBJPS}" >
	</c:forEach>
<!--  HIDDEN  처리해야할 부분 끝-->

    </tags-approval:request-layout>

</tags:layout>

