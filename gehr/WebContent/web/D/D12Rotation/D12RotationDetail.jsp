<%/******************************************************************************/
/*										*/
/*   System Name  : MSS								*/
/*   1Depth Name  : 신청							*/
/*   2Depth Name  : 부서근태							*/
/*   Program Name : 부서일일근태관리						*/
/*   Program ID   : D12Rotation|D12RotationDetail.jsp			        */
/*   Description  : 부서일일근태관리 화면					*/
/*   Note         : 								*/
/*   Creation     : 2009-02-10  LSA						*/
/*   Update       : 2009-10-26  CSR ID:1546748 여수공장 사유 목록화처리         */
/*   Update       : 2013-05-23  CSRID: Q20130422_76414                          */
/*                              경조휴가: 0130 자녀출산(무급) =>0370:임금유형변경*/
/*                              경조휴가: 자녀출산(유급)  =>0130                 */
/*		    2013-07-19  C20130717_71112 HR Center 부서근태 입력시 추가입력 기능 요청*/
/*         2014-10-07  [CSR ID:2620313] 부서근태 입력 무급자녀출산휴가 관련 수정 요청의 건  */
/********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ page import="java.util.Vector" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="hris.D.D12Rotation.*" %>
<%@ page import="hris.D.D12Rotation.rfc.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="hris.common.WebUserData" %>
<%@ page import="hris.E.E19Congra.rfc.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%@ page import="hris.D.D03Vocation.*" %>
<%@ page import="hris.D.D03Vocation.rfc.*" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="tags-common" tagdir="/WEB-INF/tags/common" %>



<%
    String jobid      = (String)request.getAttribute("jobid");
    String e_rtn = (String)request.getAttribute("E_RETURN");
    String e_msg = (String)request.getAttribute("E_MESSAGE");
    String E_OTEXT = (String)request.getAttribute("E_OTEXT");
    String t_deptNm = (String)request.getAttribute("deptNm");
    if(t_deptNm == null)
	 t_deptNm = "";
    Vector main_vt    = (Vector)request.getAttribute("main_vt");
    String deptId       = WebUtil.nvl(request.getParameter("hdn_deptId"));          //부서
    String deptNm       = WebUtil.nvl(request.getParameter("hdn_deptNm"));          //부서명
    String I_DATE  = WebUtil.nvl(request.getParameter("I_DATE"));          //기간
    String E_STATUS  = WebUtil.nvl(request.getParameter("E_STATUS"));          //승인완료=A 은, 수정 및 저장 불가

    String I_GBN  = WebUtil.nvl(request.getParameter("I_GBN"));
    String I_SEARCHDATA  = WebUtil.nvl(request.getParameter("I_SEARCHDATA"));
    if( I_DATE == null|| I_DATE.equals("")) {
        I_DATE = DataUtil.getCurrentDate();           //1번째 조회시
    }
    String rowCount   = (String)request.getAttribute("rowCount" );

    WebUserData user = WebUtil.getSessionUser(request);
    if(deptId == null || deptId.equals("")){
    	deptId = user.e_orgeh;
    }
    int  main_count = main_vt.size();
    String isPop = WebUtil.nvl(request.getParameter("hdn_isPop"));
    //out.println("hdn_deptId:"+deptId);
    //out.println("hdn_deptId:"+deptNm);
    //out.println("E_OTEXT:"+E_OTEXT);
   //  out.println("I_GBN:"+I_GBN);
   //  out.println("I_SEARCHDATA:"+I_SEARCHDATA);

%>
<c:set var="deptId" value="<%=deptId%>" />
<c:set var="deptNm" value="<%=deptNm%>" />
<c:set var="disabledSubOrg" value="true" />
<c:set var="deptTimelink" value="true" />


<jsp:include page="/include/header.jsp" />
<script language="JavaScript">
<!--
function init(){
	//alert("파라미터 : <%=deptNm %> \n Attribute : <%=t_deptNm %>");
	<% if (e_rtn != null && e_rtn.equals("I")) {%>
        if(confirm('<%= e_msg %>')){
        	doSaveData();
        }
    <% } // end if %>


}

function handleError (err, url, line) {
   alert('오류 : '+err + '\nURL : ' + url + '\n줄 : '+line);
   return true;
}

function EnterCheck(){
    if (event.keyCode == 13)  {
        pop_search();
    }
}




//조회에 의한 부서ID와 그에 따른 조회.
function setDeptID(deptId, deptNm){
    frm = document.form1;

    frm.hdn_deptId.value = deptId;
    frm.txt_deptNm.value = deptNm;
    frm.hdn_deptNm.value = deptNm;
    frm.hdn_excel.value = "";
    document.form1.I_SEARCHDATA.value = deptId;
    frm.action = "<%= WebUtil.ServletURL %>hris.D.D12Rotation.D12RotationSV";
    frm.target = "_self";
    frm.submit();
}



function setPersInfo( obj ){


    document.form1.hdn_deptId.value = obj.OBJID;

    if (document.form1.I_GBN.value !="PERNR"){
	    document.form1.I_SEARCHDATA.value = obj.OBJID;
	    document.form1.txt_deptNm.value = obj.STEXT;
	    document.form1.hdn_deptNm.value = obj.STEXT;
	    document.form1.hdn_excel.value = "";
   }else {
	    document.form1.I_SEARCHDATA.value = obj.EPERNR;

   }

    document.form1.I_DATE.value  = removePoint(document.form1.I_DATE.value);
    document.form1.jobid.value = "";
    document.form1.target= "_self";
    document.form1.action = "<%= WebUtil.ServletURL %>hris.D.D12Rotation.D12RotationSV";
    document.form1.submit();
}

// 달력 사용
function fn_openCal(Objectname){
  var lastDate;
  lastDate = eval("document.form1." + Objectname + ".value");
  small_window=window.open("<%=WebUtil.JspPath%>common/calendar.jsp?formname=form1&fieldname="+Objectname+"&curDate="+lastDate+"&iflag=0","essCalendar","toolbar=0,location=0,directories=0,status=0,menubar=0,resizable=0,width=300,height=300");
  small_window.focus();
}

function fn_openCal(Objectname, moreScriptFunction){
  var lastDate;
  lastDate = eval("document.form1." + Objectname + ".value");
  small_window=window.open("<%=WebUtil.JspPath%>common/calendar.jsp?moreScriptFunction="+moreScriptFunction+"&formname=form1&fieldname="+Objectname+"&curDate="+lastDate+"&iflag=0","essCal","toolbar=0,location=0,directories=0,status=0,menubar=0,resizable=0,width=300,height=300");
  small_window.focus();
}
//달력 사용
function goCongraBuild() {

	moveMenu("ESS_BE_CONG_COND","${g.servlet}hris.E.E19Congra.E19CongraBuildSV");
	  //운영

}
// 시작 시간이 "2400"로 입력된 경우 "0000"으로 변경한다.
function timeChange(obj) {
    //if( obj.value == "24:00" ){
    //    obj.value = "00:00" ;
    //}
}

// 저장
function doSaveData() {
<%
    if( main_vt.size() == 0 ) {
%>
    //alert('작업할 DATA가 존재하지 않습니다.');
    alert('<%=g.getMessage("MSG.D.D12.0006")%>');
<%
    } else {
%>

	if( check_data() ) {
		blockFrame();

		document.form1.I_DATE.value  = removePoint(document.form1.S_DATE.value);
		for( index = 0 ; index < <%= main_vt.size() %> ; index++ ) {

			eval("document.form1.BEGUZ" + index + ".disabled=0");
			eval("document.form1.ENDUZ" + index + ".disabled=0");
			eval("document.form1.PBEG1" + index + ".disabled=0");
			eval("document.form1.PEND1" + index + ".disabled=0");
			eval("document.form1.REASON"+ index + ".disabled=0");
			eval("document.form1.PERNR" + index + ".disabled=0");
			eval("document.form1.ENAME" + index + ".disabled=0");
			eval("document.form1.VTKEN" + index + ".disabled=0");
			eval("document.form1.CONG_DATE"+index+".value=removePoint(document.form1.CONG_DATE"+index+".value)");

                        eval("document.form1.BEGUZ" + index + ".value = document.form1.BEGUZ" + index + ".value.substring(0,2)+document.form1.BEGUZ" + index + ".value.substring(3,5);");
                        eval("document.form1.ENDUZ" + index + ".value = document.form1.ENDUZ" + index + ".value.substring(0,2)+document.form1.ENDUZ" + index + ".value.substring(3,5);");
                        eval("document.form1.PBEG1" + index + ".value = document.form1.PBEG1" + index + ".value.substring(0,2)+document.form1.PBEG1" + index + ".value.substring(3,5);");
                        eval("document.form1.PEND1" + index + ".value = document.form1.PEND1" + index + ".value.substring(0,2)+document.form1.PEND1" + index + ".value.substring(3,5);");
                        eval("document.form1.ATEXT" + index + ".value = document.form1.SUBTY1_" + index + "[document.form1.SUBTY1_" + index + ".selectedIndex].text;");

   			eval("document.form1.SUBTY"+index+".value   = document.form1.SUBTY1_"+index+".value");

                        //※CSRID: Q20130422_76414 경조휴가:0130 ,  자녀출산(무급) 9002  => 0370
                        if ( eval("document.form1.SUBTY1_"+index+".value")=="0130" && eval("document.form1.CONG_CODE" + index + ".value")=="9002" ) {

            		     eval("document.form1.SUBTY"+ index + ".value ='0370';");
                        }




		}

		document.form1.jobid.value = "saveData";
		document.form1.action = "<%= WebUtil.ServletURL %>hris.D.D12Rotation.D12RotationSV";
		document.form1.target = "_self";
		document.form1.method = "post";
		document.form1.submit();

	}else{
		return;
	}
<%
    }
%>
}
// data check..
function check_data(){
  var l_subtyObj  = "", l_reasonObj   = "";
  var l_beguzObj   = "", l_enduzObj   = "", l_pbeg1Obj  = "", l_pend1Obj  = "";

  var changeFlag   = "N";

  var rowCount     = document.form1.rowCount.value;

  for( index = 0 ; index < <%= main_count %> ; index++ ) {
      l_subtyObj      = eval("document.form1.SUBTY1_"+index);
      l_beguzObj      = eval("document.form1.BEGUZ"+index);
      l_enduzObj      = eval("document.form1.ENDUZ"+index);
      l_pbeg1Obj      = eval("document.form1.PBEG1"+index);
      l_pend1Obj      = eval("document.form1.PEND1"+index);
      l_reasonObj     = eval("document.form1.REASON"+index);
      l_congCode      = eval("document.form1.CONG_CODE"+index);
      var msg = validCheck(l_beguzObj.value);
      if (msg != "" ){
        alert(msg);
        l_beguzObj.focus();
        return false;
      }
      msg = validCheck(l_enduzObj.value);
      if (msg != "" ){
        alert(msg);
        l_enduzObj.focus();
        return false;
      }
      msg = validCheck(l_pbeg1Obj.value);
      if (msg != "" ){
        alert(msg);
        l_pbeg1Obj.focus();
        return false;
      }
      msg = validCheck(l_pend1Obj.value);
      if (msg != "" ){
        alert(msg);
        l_pend1Obj.focus();
        return false;
      }

      var t_subty = l_subtyObj.value.split("▦");
      l_subtyObj.value = t_subty[0];
      eval("document.form1.SUBTY1_"+index+".value=t_subty[0]");
      //CSR ID:1546748
      l_ovtmCodeObj      = eval("document.form1.OVTM_CODE"+index);
      if(l_subtyObj.value!=""  &&  l_ovtmCodeObj.length >1 && l_ovtmCodeObj.value == "" ){//신청사유항목
          //alert("신청사유항목은 필수 입력사항입니다.");
    	  alert("<%=g.getMessage("MSG.D.D12.0007")%>");
          l_ovtmCodeObj.focus();
          return;
      }
      if( l_subtyObj.value!=""  &&  l_reasonObj.value == "" ) {

          //alert("신청사유를 입력하세요");
          alert("<%=g.getMessage("MSG.D.D12.0008")%>");
          if  (l_subtyObj.value =="0130" ) {//경조휴가
              if  (l_congCode.value == "9000" ||l_congCode.value == "9001"||l_congCode.value == "9002" )  { //경조휴가:탈상,자녀출산
                  l_reasonObj.focus();
              }else null;
          }else {
              l_reasonObj.focus();
          }
          return false;
      }
      if( l_subtyObj.value!=""  &&  l_reasonObj.value != "" )
         eval("document.form1.changeFlag"+index+".value='Y'");
      else
         eval("document.form1.changeFlag"+index+".value='N'");
      changeFlag = "Y";

      if( l_subtyObj =="0120"|| l_subtyObj =="0121" || l_subtyObj =="0180"   ){ // 반일휴가(전반), 반일휴가(후반), 시간공가
        eval("document.form1.BEGUZ"+index+".readOnly=0");
        eval("document.form1.ENDUZ"+index+".readOnly=0");
        eval("document.form1.timeopen"+index+".value='T'");
      } else {       // 나머지 휴가구분의 경우
        eval("document.form1.BEGUZ"+index+".readOnly=1");
        eval("document.form1.ENDUZ"+index+".readOnly=1");
        eval("document.form1.timeopen"+index+".value='F'");
      }

      // 공제일수
      if( l_subtyObj =="0110" ) {   // 전일휴가
        eval("document.form1.DEDUCT_DATE"+index+".value='1'");
        document.form1.DEDUCT_DATE.value = '1';
      } else if(l_subtyObj =="0120"|| l_subtyObj =="0121"  ){ // 반일(전/후)
        eval("document.form1.DEDUCT_DATE"+index+".value='0.5'");
      } else {
        eval("document.form1.DEDUCT_DATE"+index+".value='0'");
      }


  }

  return true;
}
function validCheck(target){

 target = target.replace(":","");
 var msg = "";
 if (Number(target.substring(0,2)) > 24)
     //msg = "시간은 24이하로 입력하세요.!";
	 msg ="<%=g.getMessage("MSG.D.D12.0009")%>";

 if (Number(target.substring(2,4)) > 59)
    // msg = "분은 60미만으로 입력하세요.!";
	 msg ="<%=g.getMessage("MSG.D.D12.0010")%>" ;
 if (Number(target.substring(0,4)) > 2400)
    // msg = "24:00 이하로 입력하세요.!";
	 msg ="<%=g.getMessage("MSG.D.D12.0011")%>" ;

 if ( msg !="")
    return msg;
 var number = "0123456789";
 var alphabet = "abcdefghijklmnopqrstuvwxyz";
 var check = 0; //문자일경우 증가 숫자일경우 감소
 for (var j=0; j<target.length; j++) {
    temp = "" + target.substring(j, j+1);
    if (number.indexOf(temp)!=-1) {
       check++;
    }
 }
 if (check == 4 )
     msg = "";
 else  //msg = "FORMAT은 09:00와 같은 숫자 형태로 입력하세요!";
	 msg = "<%=g.getMessage("MSG.D.D12.0012")%>" ;
 return msg;

}


function f_onLoad() {
<%
    for( int i = 0 ; i < main_vt.size() ; i++ ) {
        D12RotationData data = (D12RotationData)main_vt.get(i);
%>
  //disableType('1', '<%= i %>');
  disableType('1', '<%= i %>');

<%
    }
%>
}
function disableType(gubun, index) {
  eval("document.form1.MINTG"+index+".value=document.form1.SUBTY1_"+index+".value");
  var SUBTY = eval("document.form1.SUBTY1_"+index+".value");
  var OVTM_CODE = eval("document.form1.OVTM_CODE"+index+".value"); //CSR ID:1546748
  var MINTG = eval("document.form1.MINTG"+index+".options[document.form1.MINTG"+index+".options.selectedIndex].text");


//Type ① : HFLAG = "X"인경우 모든 Filed는 입력불가능
  if( gubun == "1" ) {

  }
//Type ② : 휴가유형 선택시 전일(0110),경조(0130),하계(0140),보건(0150),전일공가(0170),유급결근(0200), 유휴(휴일비근무)(0340)일 경우 모든 Field는 입력불가능
  if( gubun == "2" ||gubun == "1") {
    if(MINTG=="1"){
    	if(SUBTY=="0110"){//전일휴가  사유필드 활성화
    		objDisplay(gubun,index, false, false, false, false, true);
    	}else if(SUBTY=="0130"){//경조휴가시 사유필드 비활성화
    		objDisplay(gubun,index, false, false, false, false, false);
    	}else{
    		objDisplay(gubun,index, false, false, false, false, true);
    	}

    }else if(MINTG==""){
    	objDisplay(gubun,index, false, false, false, false, false);
    }else{
    	if(SUBTY=="2005"){//초과근로일 경우에만 시작시간,종료시간,휴게시작시간,휴게종료시간, 사유 필드OPEN
    		objDisplay(gubun,index, true, true, true, true, true);
    	}else if(SUBTY=="0130"){//경조휴가시 사유필드 비활성화
    		objDisplay(gubun,index, false, false, false, false, false);
    	}else{//시작시간 종료시간 사유 필드OPEN
    		objDisplay(gubun,index, true, true, false, false, true);
    	}
    }
    //경조휴가
    if (SUBTY == "0130" ) {
      eval("Congjo1_"+index+".style.display='block'");
      eval("Congjo2_"+index+".style.display='block'");
      eval("document.form1.REASON"+index+".style.witdh='100px'");
      eval("document.form1.REASON"+index+".style.length='50px'");
    } else {
      eval("Congjo1_"+index+".style.display='none'");
      eval("Congjo2_"+index+".style.display='none'");
    }

    if( gubun != "1") {
         if(SUBTY == "" || "<%=E_STATUS%>" =="A"){
         	eval("document.form1.VTKEN"+index+".disabled=1");
         	eval("document.form1.VTKEN"+index+".checked=false");
         }else{
         	eval("document.form1.VTKEN"+index+".disabled=0");
         	eval("document.form1.VTKEN"+index+".checked=false");
         }
    }

  }

}

function objDisplay(gubun,index, BEGUZ, ENDUZ, PBEG1, PEND1,REASON){

	//value를 빈문자열로 초기화
	if (gubun !="1") {
	    eval("document.form1.BEGUZ"+index+".value='00:00'");
	    eval("document.form1.ENDUZ"+index+".value='00:00'");
	    eval("document.form1.PBEG1"+index+".value='00:00'");
	    eval("document.form1.PEND1"+index+".value='00:00'");
	    eval("document.form1.REASON"+index+".value=''");
	}
	if(BEGUZ==true){
		eval("document.form1.BEGUZ"+index+".disabled=0");
		eval("document.form1.BEGUZ"+index+".style.backgroundColor='#FFFFFF'");
	}else{
		eval("document.form1.BEGUZ"+index+".disabled=1");
		eval("document.form1.BEGUZ"+index+".style.backgroundColor='#F5F5F5'");
	}

	if(ENDUZ==true){
		eval("document.form1.ENDUZ"+index+".disabled=0");
		eval("document.form1.ENDUZ"+index+".style.backgroundColor='#FFFFFF'");
	}else{
		eval("document.form1.ENDUZ"+index+".disabled=1");
		eval("document.form1.ENDUZ"+index+".style.backgroundColor='#F5F5F5'");
	}

	if(PBEG1==true){
		eval("document.form1.PBEG1"+index+".disabled=0");
		eval("document.form1.PBEG1"+index+".style.backgroundColor='#FFFFFF'");
	}else{
		eval("document.form1.PBEG1"+index+".disabled=1");
		eval("document.form1.PBEG1"+index+".style.backgroundColor='#F5F5F5'");
	}

	if(PEND1==true){
		eval("document.form1.PEND1"+index+".disabled=0");
		eval("document.form1.PEND1"+index+".style.backgroundColor='#FFFFFF'");
	}else{
		eval("document.form1.PEND1"+index+".disabled=1");
		eval("document.form1.PEND1"+index+".style.backgroundColor='#F5F5F5'");
	}

	if(REASON==true){
		eval("document.form1.REASON"+index+".disabled=0");
		eval("document.form1.REASON"+index+".style.backgroundColor='#FFFFFF'");
                eval("Reason_"+index+".style.display = 'block'");
	}else{
		eval("document.form1.REASON"+index+".disabled=1");
		eval("document.form1.REASON"+index+".style.backgroundColor='#F5F5F5'");
                eval("Reason_"+index+".style.display = 'none'");
	}
}

//사유의 byte수를 체크한다.
function Check_Length(index) {
  var text = "";
  var leng = 0;
  var codeChr = "", codeChr1 = "";

  if( eval("document.form1.REASON"+index+".value") != "" ) {
    text = eval("document.form1.REASON"+index+".value");
    for( i = 0 ; i < text.length ; i++ ){
      codeChr  = text.charCodeAt(i);
      if( codeChr>255 ){
        leng = leng+2;
      } else {
        leng = leng+1;
      }
      if( leng > 80 ) {
        //alert("사유는 80byte까지만 입력가능합니다.");
        alert("<%=g.getMessage("MSG.D.D12.0013")%>");
        eval("document.form1.REASON"+index+".value = codeChr1");
        eval("document.form1.REASON"+index+".focus()");
        return false;
      }
      codeChr1 += text.charAt(i);
    }
  }
}

function isNumber2(obj, index) {
	Digit = "0123456789.";
	if( fCheckDigit(obj, Digit) == false) {
		//alert("교육은 숫자만 사용 가능합니다.");
		alert("<%=g.getMessage("MSG.D.D12.0014")%>");
		obj.focus();
		obj.select();
		return false;
	} else {
	  disableType('3', index);
	  return true;
	}
}

//휴가신청시 잔여휴가 check
function checkRemain(obj, pernr, index) {
    //CSR ID:1546748 여수공장 사유 목록화처리
    var SUBTY = eval("document.form1.SUBTY1_"+index+".value");
    var PERNR = eval("document.form1.PERNR"+index+".value");
    //alert("pernr:"+pernr+"PERNR:"+PERNR);
    if  (SUBTY !="0130") { //경조휴가
        eval("document.form1.REASON"+index+".value=''");
        document.form1.INDEX.value = index;
        document.form1.PERNR.value = PERNR;
        document.form1.AWART.value = obj.value;
        document.form1.target = "ifHidden";
        document.form1.action = "<%=WebUtil.JspURL%>D/D03Vocation/D03HiddenReason.jsp";
        document.form1.submit();
    }

    return;
  if( obj.value != "" ) {
    document.form3.i_stdDate.value = removePoint(document.form1.S_DATE.value);
    document.form3.i_subty.value   = obj.value;
    document.form3.i_pernr.value   = pernr;
    document.form3.i_index.value   = index;

    document.form3.action          = "<%= WebUtil.JspPath %>D/D12Rotation/D12RotationHidden.jsp";
    document.form3.target          = "hidden";
    document.form3.submit();
  }


}
//-->

//기준일자 변경시 교대조 리스트를 다시 조회한다.
function after_listSetting(){
    listSetting(document.form1.S_DATE);
}

function listSetting(obj) {
  if( obj.value != "" && dateFormat(obj) ) {
    l_date = removePoint(obj.value);

      if( document.form1.I_DATE.value != removePoint(obj.value) ) {
          document.form1.I_DATE.value  = removePoint(obj.value);
  	  document.form1.jobid.value   = "first";
  	  //document.form1.action        = "<%= WebUtil.JspPath %>D/D12Rotation/D12RotationDetailWait.jsp";

          document.form1.jobid.value = "";
          document.form1.action = "<%= WebUtil.ServletURL %>hris.D.D12Rotation.D12RotationSV";
  	  document.form1.method        = "post";
          document.form1.target = "_self";
  	  document.form1.submit();
      }
 }
}
function f_search() {
	_showLoading();
      document.form1.I_DATE.value  = removePoint(document.form1.S_DATE.value);
      document.form1.jobid.value = "";
      document.form1.action = "<%= WebUtil.ServletURL %>hris.D.D12Rotation.D12RotationSV";
  	  document.form1.method        = "post";
      document.form1.target = "_self";
  	  document.form1.submit();
}
//경조내역선택팝업
function doSearch(inx,PERNR){
  //alert("<%= WebUtil.ServletURL %>hris.D.D03Vocation.D03CongraListPopLotationSV?PERNR="+PERNR+"&INX="+inx);
  small_window=window.open("<%= WebUtil.ServletURL %>hris.D.D03Vocation.D03CongraListPopLotationSV?PERNR="+PERNR+"&INX="+inx,"essCalendar","toolbar=0,location=0,directories=0,status=0,menubar=0,resizable=0,width=600,height=400");
  small_window.focus();
}
 //경조내역선택시 CSR ID:1225704
function Cong_Sel(index,obj) {

    var SUBTY = eval("document.form1.SUBTY1_"+index+".value");

    if  (SUBTY =="0130" && (obj.value == "9000" ||obj.value == "9001"||obj.value == "9002" )) { //경조휴가:탈상,자녀출산
         eval("document.form1.CONG_CODE"+index+".disabled=0");
         eval("document.form1.REASON"+index+".disabled=0");
         eval("document.form1.REASON"+index+".value=  document.form1.CONG_CODE"+index+"[obj.selectedIndex].text");
    }
    else if (SUBTY =="0130" ) {
         eval("document.form1.REASON"+index+".disabled=1");
         eval("document.form1.REASON"+index+".value=  ''");
    }
}


/*   입력항목 1개 추가 */
function add_field(){
    document.form1.rowCount.value = document.form1.main_count.value = parseInt(document.form1.main_count.value) + 1;

    for( var index = 0 ; index < <%= main_count %> ; index++ ) {
        //C20130717_71112 HR Center 부서근태 입력시 추가입력 기능 요청
	eval("document.form1.BEGUZ" + index + ".disabled=0");
	eval("document.form1.ENDUZ" + index + ".disabled=0");
	eval("document.form1.PBEG1" + index + ".disabled=0");
	eval("document.form1.PEND1" + index + ".disabled=0");
	eval("document.form1.REASON"+ index + ".disabled=0");
	eval("document.form1.PERNR" + index + ".disabled=0");
	eval("document.form1.ENAME" + index + ".disabled=0");
	eval("document.form1.VTKEN" + index + ".disabled=0");
	eval("document.form1.CONG_DATE"+index+".value=removePoint(document.form1.CONG_DATE"+index+".value)");
        eval("document.form1.BEGUZ" + index + ".value = document.form1.BEGUZ" + index + ".value.substring(0,2)+document.form1.BEGUZ" + index + ".value.substring(3,5);");
        eval("document.form1.ENDUZ" + index + ".value = document.form1.ENDUZ" + index + ".value.substring(0,2)+document.form1.ENDUZ" + index + ".value.substring(3,5);");
        eval("document.form1.PBEG1" + index + ".value = document.form1.PBEG1" + index + ".value.substring(0,2)+document.form1.PBEG1" + index + ".value.substring(3,5);");
        eval("document.form1.PEND1" + index + ".value = document.form1.PEND1" + index + ".value.substring(0,2)+document.form1.PEND1" + index + ".value.substring(3,5);");
        eval("document.form1.ATEXT" + index + ".value = document.form1.SUBTY1_" + index + "[document.form1.SUBTY1_" + index + ".selectedIndex].text;");

   	eval("document.form1.SUBTY"+index+".value   = document.form1.SUBTY1_"+index+".value");

        //※CSRID: Q20130422_76414 경조휴가:0130 ,  자녀출산(무급) 9002  => 0370
        if ( eval("document.form1.SUBTY1_"+index+".value")=="0130" && eval("document.form1.CONG_CODE" + index + ".value")=="9002" ) {

             eval("document.form1.SUBTY"+ index + ".value ='0370';");
        }


    }

    document.form1.jobid.value = "AddorDel";
    document.form1.action = "<%= WebUtil.ServletURL %>hris.D.D12Rotation.D12RotationSV";
    document.form1.method = "post";
    document.form1.target = "listFrame";
    document.form1.submit();
}

/* 의료비 입력항목 아래항목 지우기 */
function remove_field(){


    var DelSel="";
    for( var i = 0 ; i < "<%= main_count %>" ; i++ ) {
        if( isNaN( document.form1.radiobutton.length ) ){
            eval("document.form1.use_flag0.value = 'N'");
        } else {
            if ( document.form1.radiobutton[i].checked == true ) {
                eval("document.form1.use_flag"+ i +".value = 'N'");
                eval("document.form1.ADDYN"+ i +".value = 'D'");
                DelSel="Y";
            }
        }
    }
    if ( document.form1.main_count.value == 0 ) {
        //alert("입력항목을 더이상 줄일수 없습니다. ");
        alert("<%=g.getMessage("MSG.D.D12.0015")%> ");
        return;
    }
    if ( DelSel != "Y" ) {
       // alert("삭제할 DATA를 선택하세요");
       alert("<%=g.getMessage("MSG.D.D12.0016")%> ");
        return;
    }

    for( var i = 0 ; i < "<%= main_count %>" ; i++ ) {
        eval("document.form1.BEGUZ" + i + ".disabled=0");
        eval("document.form1.ENDUZ" + i + ".disabled=0");
        eval("document.form1.PBEG1" + i + ".disabled=0");
        eval("document.form1.PEND1" + i + ".disabled=0");
        eval("document.form1.REASON"+ i + ".disabled=0");
        eval("document.form1.PERNR"+ i + ".disabled=0");
        eval("document.form1.ENAME"+ i + ".disabled=0");
    }
    //선택 삭제 추가
    document.form1.rowCount.value = parseInt(document.form1.main_count.value) - 1;

    document.form1.jobid.value = "AddorDel";
    document.form1.action = "<%= WebUtil.ServletURL %>hris.D.D12Rotation.D12RotationSV";
    document.form1.method = "post";
    document.form1.target = "listFrame";
    document.form1.submit();
}
//@v1.1 성명,사번 검색
function name_search(obj,gubn,inx)
{
    val1 = obj.value;
    val1 = rtrim(ltrim(val1));
    //if ( val1 == "" ) {
    //    alert("검색할 성명 또는 사번을 입력하세요!");
    //    obj.focus();
    //    return;
    //} else {
        if( val1.length == 1 ) {

            //alert("검색할 성명을 한 글자 이상 입력하세요!")
            alert("<%=g.getMessage("MSG.D.D12.0017")%> ");
            obj.focus();
            return;
        } // end if
    //} // end if

    if(gubn=='2'){
    	eval("document.form1.PERNR"+inx).value = "";
    }

    var s_date = document.form1.I_DATE.value;


	document.form2.hdn_deptId.value = document.form1.hdn_deptId.value; //부서코드
	document.form2.i_datum.value = s_date; //날짜
    document.form2.i_ename.value = eval("document.form1.ENAME"+inx).value; //성명
    document.form2.i_pernr.value = eval("document.form1.PERNR"+inx).value; //사번
    document.form2.i_index.value = inx;
    document.form2.target = "ifHidden";
    document.form2.action = "<%=WebUtil.JspURL%>D/D12Rotation/D12RotationHiddenPernr.jsp";
    document.form2.submit();
} // @v1.1 end function

//인쇄
function go_Rotationprint(){


    window.open('', 'essPrintWindow', "toolbar=yes,location=no, directories=no,status=yes,menubar=yes,resizable=no,width=780,height=662,left=0,top=2");

    document.form1.target = "essPrintWindow";
    document.form1.action = "<%= WebUtil.JspURL %>common/printFrame_Day_rotation.jsp?jobid=print&I_DATE=<%=I_DATE %>&I_GBN=<%=I_GBN %>&I_SEARCHDATA=<%=I_SEARCHDATA %>";
    document.form1.method = "post";
    document.form1.submit();
}

function vtken_check(obj){
	if(obj.checked==true){
		obj.value = "Y";
	}else{
		obj.value = "N";
	}

}
function reason_show( cnt,index ) {   //CSR ID:1546748

    if (cnt >0) {
        eval("Reason_"+index+".style.display = 'block'");
        //eval("document.form1.REASON"+index+".disabled=1");
	//eval("document.form1.REASON"+index+".style.backgroundColor='#F5F5F5'");
    } else {
        eval("Reason_"+index+".style.display = 'none'");
       // eval("document.form1.REASON"+index+".disabled=0");
	//eval("document.form1.REASON"+index+".style.backgroundColor='#FFFFFF'");
    }
}
$(document).ready(function(){
	init();
	f_onLoad();
	MM_preloadImages('<%= WebUtil.ImageURL %>btn_help_on.gif');
	if(parent.resizeIframe) parent.resizeIframe(document.body.scrollHeight);
 });
$("#S_DATE").datepicker({ onSelect: function(dateText,inst) {
	after_listSetting();
}
});


</script>

 <jsp:include page="/include/body-header.jsp"/>
<!--  HIDDEN  처리해야할 부분 끝-->
<form name="form2" method="post">
    <input type="hidden" name="hdn_deptId" value="">
    <input type="hidden" name="i_datum" value="">
    <input type="hidden" name="i_ename" value="">
    <input type="hidden" name="i_pernr"   value="">
    <input type="hidden" name="i_index"   value="">
</form>
<form name="form3" method="post">
    <input type="hidden" name="i_stdDate" value="">
    <input type="hidden" name="i_subty"   value="">
    <input type="hidden" name="i_pernr"   value="">
    <input type="hidden" name="i_index"   value="">
</form>
<form name="form1" method="post" onsubmit="return false">
<input type="hidden" name="hdn_isPop"   value="<%=WebUtil.nvl(request.getParameter("hdn_isPop"))%>">
<input type="hidden" name="hdn_gubun"   value="">
<input type="hidden" name="hdn_deptId"  value="<%=deptId%>">
<input type="hidden" name="hdn_deptNm"  value="<%=deptNm%>">
<input type="hidden" name="hdn_excel"   value="">
<input type="hidden" name="I_SEARCHDATA"  value="<%=I_SEARCHDATA%>">
<input type="hidden" name="retir_chk"  value="">
<input type="hidden" name="I_GUBUN"  value="2">
<input type="hidden" name="I_VALUE1"  value="">
<input type="hidden" name="authClsf"  value="S">

<%
	if(!isPop.equals("POP")&&!isPop.equals("APPROVAL") &&!isPop.equals("DETAIL")){
%>
<!--   부서검색 보여주는 부분 시작   -->


<%@ include file="/web/common/SearchDeptInfoPernr.jsp" %>
<!--   부서검색 보여주는 부분  끝    -->
<%
	}
%>

    <!-- 근태일자 Field Table Header 시작 -->
	<div class="tableArea">
		<div class="table">
			<table  class="tableGeneral">
            		<colgroup>
                		<col width="15%">
                		<col width="25%">
                		<col width="40%">
                		<col width="20%">
            		</colgroup>
				<tr>
                  <th><!-- 기간 --><%=g.getMessage("LABEL.D.D12.0013")%></th>
                  <td>
                    <%
                    if(isPop!=null&&!isPop.equals("")){
                    %>
                    <%= WebUtil.printDate(I_DATE) %>
                    <input type="hidden" name="S_DATE" value="<%= WebUtil.printDate(I_DATE) %>" size="15" onChange="javascript:listSetting(this);">
                    <%
                    }else{
                    %>
                    <input type="text"  id = "S_DATE"   class = "date" name="S_DATE" value="<%= WebUtil.printDate(I_DATE) %>" size="15" onChange="javascript:listSetting(this);">

                    <%
                    }
                    %>
                    <input type="hidden" name="I_DATE" value="<%= I_DATE %>">
                  </td>
                   <td style="border-left:1px solid #ddd; border-right:1px solid #ddd;"><input readonly type=text size=50 name="E_OTEXT" value="<%=E_OTEXT%>"></td>
                  <td>
                  	<ul class="btn_mdl">
                  		<li><a href="javascript:f_search();"><span><!-- 조회 --><%=g.getMessage("BUTTON.COMMON.SEARCH")%></span></a></li>
<%
	if(!E_STATUS.equals("A") &&( !isPop.equals("APPROVAL") && !isPop.equals("DETAIL")) ){
		if( !isPop.equals("APPROVAL")&&!isPop.equals("DETAIL")  ){
%>

						<li><a href="javascript:go_Rotationprint();"><span><!-- 인쇄하기 --><%=g.getMessage("BUTTON.COMMON.PRINT")%></span></a></li>
<%
		}
	}
%>
						</ul>
					</td>
				</tr>
			</table>
		</div>
	</div>
	<!-- 근태일자 Field Table Header 끝 -->

	<!-- 상단 입력 테이블 시작-->
  	<div class="buttonArea underList">
  		<ul class="btn_crud">
    <%
    if(!E_STATUS.equals("A") &&( !isPop.equals("APPROVAL") && !isPop.equals("DETAIL")) ){
    %>
  			<li id="sc_button"><a class="darken" href="javascript:doSaveData();"><span><!-- 저장 --><%=g.getMessage("BUTTON.COMMON.SAVE")%></span></a></li>
  <%
    }
	%>
  		</ul>
  	</div>
	<div class="tableArea">
    	<div class="listTop">
    		<div class="buttonArea">
    			<ul class="btn_mdl">
  <%
  if(!E_STATUS.equals("A") &&( !isPop.equals("APPROVAL") && !isPop.equals("DETAIL")) ){
  	if(!isPop.equals("POP")&&!isPop.equals("APPROVAL") &&!isPop.equals("DETAIL")){
	%>
  			<li><a href="javascript:add_field();"><span><!-- 추가 --><%=g.getMessage("BUTTON.COMMON.LINE.ADD")%></span></a></li>
  			<li><a href="javascript:remove_field();"><span><!-- 삭제 --><%=g.getMessage("BUTTON.COMMON.LINE.DELETE")%></span></a></li>
	<%
		}
  }
    %>
   				</ul>
    		</div>
    		<div class="clear"></div>
    	</div>
		<div class="table">
			<table class="listTable">
			       	<colgroup>
       				<col width="8%" />
       				<col width="10%" />
       				<col width="10%" />
       				<col width="12%" />
       				<col width="6%" />
       				<col width="6%" />
       				<col width="6%" />
       				<col width="6%" />
       				<col width="6%" />
       				<col />
       				</colgroup>
       				<thead>
                    <tr>
                      <th rowspan="2"><!-- 삭제 --><%=g.getMessage("LABEL.D.D12.0016")%></th>
                      <th rowspan="2"><!-- 사원번호 --><%=g.getMessage("LABEL.D.D12.0017")%></th>
                      <th rowspan="2"><!-- 성명 --><%=g.getMessage("LABEL.D.D12.0018")%></th>
                      <th rowspan="2"><!-- 유형선택 --><%=g.getMessage("LABEL.D.D12.0019")%></th>
                      <th rowspan="2"><!-- 시작시간 --><%=g.getMessage("LABEL.D.D12.0020")%></th>
                      <th rowspan="2"><!-- 종료시간 --><%=g.getMessage("LABEL.D.D12.0021")%></th>
                      <th colspan="2"><!-- 휴게시간 --><%=g.getMessage("LABEL.D.D12.0022")%></th>
                      <th rowspan="2"><!-- 이전일 --><%=g.getMessage("LABEL.D.D12.0023")%></th>
                      <th class="lastCol"  rowspan="2"><!-- 사유 --><%=g.getMessage("LABEL.D.D12.0024")%></th>
                    </tr>
                    <tr>
                      <th><!-- 시작시간 --><%=g.getMessage("LABEL.D.D12.0020")%></th>
                      <th ><!-- 종료시간 --><%=g.getMessage("LABEL.D.D12.0021")%></th>
                    </tr>
                    </thead>

<!-- 아래, 위 프레임의 사이즈를 고정시킨다 -->
<%
    String Disable = "";
	D12AwartCodeRFC rfc_List         = new D12AwartCodeRFC();
	Vector D12AwartCode_vt = rfc_List.getAwartCode();
    String DATUM     = DataUtil.getCurrentDate();
    //[CSR ID:2620313] 부서근태 입력 무급자녀출산휴가 관련 수정 요청의 건
    Vector D12CongCode_vt = (new E19CongCodeNewRFC()).getCongCodeForRotaion("C100","X");


    for( int i = 0 ; i < main_vt.size() ; i++ ) {
        D12RotationData data = (D12RotationData)main_vt.get(i);

        String tr_class = "";

        if(i%2 == 0){
            tr_class="oddRow";
        }else{
            tr_class="";
        }

        //CSR ID:1546748
        Vector D03VocationAReason_vt  = (new D03VocationAReasonRFC()).getSubtyCode(user.companyCode, data.PERNR, data.SUBTY,DATUM);
        Vector newOpt = new Vector();
        for( int j = 0 ; j < D03VocationAReason_vt.size() ; j++ ){
            D03VocationReasonData old_data = (D03VocationReasonData)D03VocationAReason_vt.get(j);
            CodeEntity code_data = new CodeEntity();
            code_data.code = old_data.SCODE ;
            code_data.value = old_data.STEXT ;
            newOpt.addElement(code_data);
        }

        //※CSRID: Q20130422_76414 경조휴가:0130 ,  자녀출산(무급) 9002  => 0370
        if( data.SUBTY.equals("0370") ) { //자녀출산(무급) 9002:0370 =>  경조휴가:0130
             data.SUBTY ="0130";
        }

        if( data.SUBTY.equals("0110")|| data.SUBTY.equals("0130") || data.SUBTY.equals("0140") ||
            data.SUBTY.equals("0150")|| data.SUBTY.equals("0170") || data.SUBTY.equals("0200") || data.SUBTY.equals("0340") ) {
            Disable ="disabled";
        }
        else{
            Disable ="";
        }
%>

                    <tr class="<%=tr_class%>">

                      <td>
                        <input type="radio" name="radiobutton" value="<%=i%>" <%=E_STATUS.equals("A")? "disabled" : "" %>>
                      </td>
                      <td><input type="text" name="PERNR<%=i%>" value="<%= data.PERNR %>" <%= data.ADDYN.equals("N") ?  "disabled" : "" %> onblur="javascript:name_search(this,'1','<%=i%>');" size="8" maxlength="8" style="ime-mode:active"></td>
                      <td><input type="text" name="ENAME<%=i%>" value="<%= data.ENAME %>" <%= data.ADDYN.equals("N") ?  "disabled" : "" %> onblur="javascript:name_search(this,'2','<%=i%>');" size="10"  maxlength="8" style="ime-mode:active"></td>
                     <td>
        				<select name="SUBTY1_<%= i %>" onChange="javascript:disableType('2', '<%= i %>');checkRemain(this, '<%= data.PERNR %>', '<%= i %>');" <%=E_STATUS.equals("A")? "disabled" : "" %>>
                          <option value ="">-----------</option>
                        <%
                         for( int j = 0 ; j < D12AwartCode_vt.size() ; j++ ) {
                             D12AwartData data1 = (D12AwartData)D12AwartCode_vt.get(j);

                        %>
                             <option value="<%=data1.SUBTY %>" <%= data.SUBTY.equals(data1.SUBTY) ? "selected" : "" %>><%=data1.ATEXT%></option>
                        <%
                         }
                        %>
                        </select>
                        <select name="MINTG<%=i %>" style="display:none;">
                          <option value =""></option>
                        <%
                         for( int j = 0 ; j < D12AwartCode_vt.size() ; j++ ) {
                             D12AwartData data1 = (D12AwartData)D12AwartCode_vt.get(j);
                        %>
                          <option value="<%=data1.SUBTY %>"><%=data1.MINTG%></option>
                        <%
                         }
                        %>
                        </select>
                      </td>
                      <td>
                        <input type=text name="BEGUZ<%= i %>" value="<%=  data.BEGUZ.equals("") ? "00:00" : !data.BEGUZ.substring(2,3).equals(":")||data.BEGUZ.length()!=8 ? data.BEGUZ.substring(0,2)+":"+data.BEGUZ.substring(3,5): data.BEGUZ.substring(0,5)  %>" size=5 maxlength=5 disabled>
                        </td>
                        <td>
                        <input type=text name="ENDUZ<%= i %>" value="<%=  data.ENDUZ.equals("") ? "00:00" : !data.ENDUZ.substring(2,3).equals(":")||data.ENDUZ.length()!=8 ? data.ENDUZ.substring(0,2)+":"+data.ENDUZ.substring(3,5) : data.ENDUZ.substring(0,5) %>" size=5 maxlength=5 disabled>
                      </td>
                      <td>
                        <input type=text name="PBEG1<%= i %>" value="<%=  data.PBEG1.equals("") ? "00:00" : !data.PBEG1.substring(2,3).equals(":")||data.PBEG1.length()!=8 ? data.PBEG1.substring(0,2)+":"+data.PBEG1.substring(3,5) : data.PBEG1.substring(0,5) %>" size=5 maxlength=5 disabled>
                      </td>
                        <td>
                        <input type=text name="PEND1<%= i %>" value="<%=  data.PEND1.equals("") ? "00:00" : !data.PEND1.substring(2,3).equals(":")||data.PEND1.length()!=8 ? data.PEND1.substring(0,2)+":"+data.PEND1.substring(3,5) : data.PEND1.substring(0,5) %>" size=5 maxlength=5 disabled>

                        </td>
                        <td>
                          <input type="checkbox" name="VTKEN<%= i %>" onclick="javascript:vtken_check(this);" value="<%=data.VTKEN.equals("X")? "Y":"N" %>" <%=data.VTKEN.equals("X")? "checked":"" %> <%=data.SUBTY.equals("") ? "disabled":E_STATUS.equals("A")?"disabled":"" %>>
                        </td>
                      <td class="lastCol" >
                        <table  border="0" width=100% height=100% cellspacing="0" cellpadding="0" topmargin="0">
			       	<colgroup>
       				<col width="25%" />
       				<col width="25%" />
       				<col width="25%" />
       				<col width="25%" />
       				</colgroup>
                          <tr>
                             <td valign=top class="lastCol" ><input type="text" name="REASON<%= i %>" value="<%=data.REASON%>" size="30" maxlength="80" style="ime-mode:active;float:left;" disabled>
                             </td>
                             <td class="lastCol"  id="Reason_<%= i %>"   >
                             <!-- CSR ID:1546748 -->
                             <div display:<%=data.OVTM_CODE.equals("")? "none":"block"%>>
                             <select  name="OVTM_CODE<%= i %>"  style="width:100px">
                              <option value="">------------------</option>
                              <%= WebUtil.printOption( newOpt, data.OVTM_CODE) %>
                             </select>
                             </div>
                             </td>
                             <td class="lastCol"  id="Congjo2_<%= i %>" >
                             <div display:<%=data.SUBTY.equals("0130")? "block":"none"%>>
                             <!-- CSR ID:1225704 -->
                             <select  name="CONG_CODE<%= i %>"  onChange="Cong_Sel(<%= i %>,this)"  style="width:100px">
                              <option value="">------------------</option>
							  <!-- [CSR ID:2620313] 부서근태 입력 무급자녀출산휴가 관련 수정 요청의 건 -->
                              <!-- < %= WebUtil.printOption((new E19CongCodeNewRFC()).getCongCodeForRotaion("C100","X") )  %>     -->
                              <%
			                         for( int j = 0 ; j < D12CongCode_vt.size() ; j++ ) {
			                        	 com.sns.jdf.util.CodeEntity ck = (com.sns.jdf.util.CodeEntity)D12CongCode_vt.get(j);
			                        %>
			                             <option value="<%=ck.code %>" <%= data.CONG_CODE.equals(ck.code) ? "selected" : "" %>><%=ck.value%></option>
			                        <%
			                         }
		                      %>
                             </select>
                             </div>
                             </td>
                             <td  class="lastCol"  id="Congjo1_<%= i %>"  >
                                <div display:<%=data.SUBTY.equals("0130")? "block":"none"%>>
                                <a href="javascript:doSearch('<%= i %>','<%=data.PERNR%>');"><img src="<%= WebUtil.ImageURL %>ico_magnify.png"  name="image" align="left" border="0"></a>
                             </div>
                             </td>

                          </tr>
                        </table>
                     <input type="hidden" name="use_flag<%=i%>"  value="Y"  size="0"><!--@v1.4-->
                     <input type="hidden" name="SUBTY<%= i %>" value="<%= data.SUBTY%>" size="0">
					<input type="hidden" name="ATEXT<%= i %>" value="" size="0">
					<input type="hidden" name="timeopen<%= i %>"   value="<%= data.SUBTY.equals("0120") || data.SUBTY.equals("0121") || data.SUBTY.equals("0180") ? "T" : "F" %>" size="0">
					<input type="hidden" name="DEDUCT_DATE<%= i %>" value="" size="0">
					<input type="hidden" name="BEGDA<%= i %>"      value="<%= data.BEGDA %>" size="0">
					<input type="hidden" name="ADDYN<%= i %>" value="<%= data.ADDYN.equals("N") ?  data.ADDYN : "Y" %>" size="0">
					<input type="hidden" name="changeFlag<%= i %>" value="" size="0">
					<!--경조내역팝업에서설정-->
					<input type="hidden" name="CONG_DATE<%= i %>"   value="" size="0">
					<input type="hidden" name="HOLI_CONT<%= i %>"   value="" size="0">
					<input type="hidden" name="P_A024_SEQN<%= i %>" value="" size="0">
                      </td>
                    </tr>

<%
    }

%>
			</table>
		</div>
	</div>

<!-----ADD ROW ---------------------------------->
<!---- ADD ROW ---------------------------------->

<!-- 상단 입력 테이블 끝-->



  	<div class="buttonArea underList">
  		<ul class="btn_crud">
    <%
    if(!E_STATUS.equals("A") &&( !isPop.equals("APPROVAL") && !isPop.equals("DETAIL")) ){
    %>
  			<li id="sc_button"><a class="darken" href="javascript:doSaveData();"><span><!-- 저장 --><%=g.getMessage("BUTTON.COMMON.SAVE")%></span></a></li>
  <%
    }
	%>
  		</ul>
  	</div>
<!-- HIDDEN  처리해야할 부분 시작 -->
      <input type="hidden" name="INDEX"    value="">
      <input type="hidden" name="AWART"    value="">
      <input type="hidden" name="PERNR"    value="">
      <input type="hidden" name="jobid"    value="">
      <input type="hidden" name="rowCount" value="<%= rowCount %>">
  <input type="hidden" name="main_count" value="<%= main_vt.size() %>">
<!-- HIDDEN  처리해야할 부분 끝   -->
</form>
<iframe name="ifHidden" width="0" height="0" /></iframe>
<!-------hidden------------>
<jsp:include page="/include/body-footer.jsp" />
<jsp:include page="/include/footer.jsp" />
