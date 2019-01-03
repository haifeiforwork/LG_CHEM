<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page import="java.util.Vector" %>
<%@ page import="com.sns.jdf.util.*"%>
<%@ page import="com.sns.jdf.servlet.*"%>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="hris.F.*" %>
<%@ page import="hris.F.rfc.*" %>
<%@ page import="hris.N.EHRComCRUDInterfaceRFC" %>
<%@ page import="hris.N.EHRCommonUtil" %>

<%

    WebUserData user    = (WebUserData)session.getAttribute("user");                                        //세션.

	//특정사번은 현재 조직이 아닌 ZHRH130T테이블을 읽어 조직을 셋팅함. 2015-11-23
	Box sbox = new Box("orgview");
	sbox.put("I_PERNR", user.empNo);
	sbox.put("I_AUTHOR", "M");
	sbox.put("I_DATUM", DataUtil.getCurrentDate());
	//String sfunctionName = "ZHRC_RFC_CHECK_EXORG";
	String sfunctionName = "ZGHR_RFC_CHECK_EXORG";
	EHRComCRUDInterfaceRFC tcomRFC = new EHRComCRUDInterfaceRFC();
	HashMap orgHM = tcomRFC.getExecutAll(sbox, sfunctionName);
	HashMap<String, String> exportField = new HashMap<String, String>();
	exportField = (HashMap)orgHM.get("EXPORT_FIELD");
	String sRETURN =tcomRFC.getReturn().MSGTY;

    String deptId       = WebUtil.nvl(request.getParameter("hdn_deptId"));                //부서코드
    if(deptId.equals("")){
    	if(!sRETURN.equals("S")){
    		deptId = user.e_objid;
    	}else{
    		deptId = exportField.get("E_ORGEH");

    	}
    }
    String deptNm       = WebUtil.nvl(request.getParameter("hdn_deptNm"));                              //부서명

    if(deptNm.equals("")){
    	if(!sRETURN.equals("S")){
    		deptNm = user.e_obtxt;
    	}else{
    		deptNm = exportField.get("E_ORGTX");
    	}

    }

    // 웹로그 메뉴 코드명 2015-09-08
    String sMenuCode = WebUtil.nvl(request.getParameter("sMenuCode"));
    // 제목 텍스트 추가  2015-10-26
	String sMenuText =  WebUtil.nvl(request.getParameter("sMenuText"));
    String sCommand = WebUtil.nvl(request.getParameter("command"));
    if(sCommand.equals("")){
    	sCommand ="G1";
    }



    String stabNo = WebUtil.nvl((String)request.getAttribute("tabNo"));
    String tabNo =  "0";
    if(sCommand.equals("E")){
    	tabNo =  "1";
    }else if(sCommand.equals("0002")){
    	tabNo =  "2";

    }

    String chck_yeno = WebUtil.nvl(request.getParameter("chck_yeno"));
    if(chck_yeno.equals("")){
    	chck_yeno = "Y";
    }
    String searchRegion = WebUtil.nvl((String)request.getAttribute("I_AREA"));




	EHRComCRUDInterfaceRFC comRFC = new EHRComCRUDInterfaceRFC();
	//String functionName = "ZHRC_RFC_GET_GLOBAL_CONDITION";
	String functionName = "ZGHR_RFC_GET_GLOBAL_CONDITION";
	Box box = new Box("region");
    box.put("I_ORGEH", deptId);
    box.put("I_AREA",searchRegion);
    HashMap resultVT = comRFC.getExecutAllTable(box, functionName,"E_RETURN");

    Vector areaVT = (Vector)resultVT.get("T_AREA");
    Vector landVT = (Vector)resultVT.get("T_LAND");
    Vector areaEntity_vt = new Vector();
    HashMap<String, String> areaHM = new HashMap<String, String>();
    HashMap<String, String> landHM = new HashMap<String, String>();

    Vector area_vt = new Vector();
    for(int i=0; i< areaVT.size(); i++){
    	 CodeEntity entity = new CodeEntity();
    	 areaHM = (HashMap)areaVT.get(i);
    	 entity.code = areaHM.get("ZCODE");
    	 entity.value = areaHM.get("CODTX");
    	 area_vt.addElement(entity);
    }

    Vector land_vt = new Vector();
    for(int i=0; i< landVT.size(); i++){
    	 CodeEntity entity = new CodeEntity();
    	 landHM = (HashMap)landVT.get(i);
    	 entity.code = landHM.get("ZCODE");
    	 entity.value = landHM.get("CODTX");
    	 land_vt.addElement(entity);
    }

    String searchNation = WebUtil.nvl(request.getParameter("searchNation"));

	String selectRegTxt = EHRCommonUtil.nullToEmpty((String)request.getParameter("selectRegTxt"));
	 if(selectRegTxt.equals("")){
		 selectRegTxt=g.getMessage("LABEL.N.N02.0012");  //전체
	}
	box = WebUtil.getBox(request);
    Vector cb = box.getVector("checkBox");
%>

<jsp:include page="/include/header.jsp" />
<SCRIPT LANGUAGE="JavaScript">
<!--

	//조회에 의한 부서ID와 그에 따른 조회.
	function setDeptID(deptId, deptNm){
		switchScreen();
	    frm = document.form1;
	    frm.hdn_deptId.value = deptId;
	    frm.hdn_deptNm.value = deptNm;
   	    frm.command.value= listFrame.document.form1.command.value;
   	    //alert(listFrame.document.form1.command.value);
	    frm.targetpage.value ="main";
	    frm.action = "<%= WebUtil.ServletURL %>hris.N.orgstats.globalprsn.GlobalPrsnSV";
        frm.target = "_self";
	    frm.submit();
	}

	//Execl Down 하기.
	function excelDown(gubun) {
		alert("excel");
	    frm = document.form1;
	    frm.command.value = gubun;
	    frm.targetpage.value ="excel";
	    frm.target = "hidden";
	    frm.action = "<%= WebUtil.ServletURL %>hris.N.orgstats.globalprsn.GlobalPrsnSV";
	    frm.submit();
	}
	function switchScreen() {

	    document.getElementById("divLoading").style.display = "";
	    document.getElementById("divBody").style.display = "none";
	}

	function switchScreen1() {

	    document.getElementById("divLoading").style.display = "none";
	    document.getElementById("divBody").style.display = "";

	}

    function change_region(sID) {
      frm = document.form1;
      var sText = sID.options[sID.selectedIndex].text;
      frm.selectRegTxt.value = sText;
      frm.searchRegion.value = frm.selectRegion.value;
      frm.command.value= listFrame.document.form1.command.value;
      frm.tabSet.value= listFrame.document.form1.tabSet.value;
      frm.searchNation.value = "";

      chkBoxClear();
      //alert("change_region");
      //alert( frm.searchRegion.value);
      frm.targetpage.value ="main";

      frm.action = "<%= WebUtil.ServletURL %>hris.N.orgstats.globalprsn.GlobalPrsnSV";
      frm.target = "_self";
	  frm.submit();
   }

function controlNationBox() {
 if( Div4.style.visibility == 'visible' ){
 		 Div4.style.visibility = 'hidden';
	} else  {
			Div4.style.visibility = 'visible';
	}
}

function searchNationDetail(){
	 //switchScreen();
	  chkBoxText()

      frm = document.form1;
      Div4.style.visibility = 'hidden';
      frm.command.value= listFrame.document.form1.command.value;
      frm.tabSet.value= listFrame.document.form1.tabSet.value;

	  //frm.targetpage.value ="main";
      frm.action = "<%= WebUtil.ServletURL %>hris.N.orgstats.globalprsn.GlobalPrsnSV";
      frm.target = "listFrame";
	  frm.submit();


}
  	function searchText(stext){
  	 frm = document.form1;
	 frm.searchNation.value = stext;
	}

function chkBoxClear(){
	frm = document.form1;

	if(frm.chkbox != undefined){
		var chkLeng = frm.chkbox.length;
		//var nation = "";

		for(i=0; i<chkLeng; i++){
			 if( frm.chkbox[i].checked ==true){
			 	 frm.chkbox[i].checked = false;
			}
		}

	}
}



function chkBoxText(){
	frm = document.form1;

	if(frm.chkbox != undefined){
	var chkLeng = frm.chkbox.length;
	var nation = "";
	var j=0;
	for(i=0; i<chkLeng; i++){
		 if( frm.chkbox[i].checked ==true){
		 	  var checkCode = frm.chkbox[i].value;

		 	 if(j==0){
		 	 		nation =  frm.hidden_nation[i].value;
		 	 }else{
		 	 		 nation = nation + ", " +  frm.hidden_nation[i].value;
		 	 }
			j++;
		}
	}
	frm.searchNation.value = nation;
	return true;
	}
}


	function keyCodeprint() {

	 var keyCode = window.event.keyCode;

	 if(keyCode == "8"){
	 	return false;
	 }

	 }
	 document.onkeydown = keyCodeprint	;
//-->
</SCRIPT>



<jsp:include page="/include/body-header.jsp">
    <jsp:param name="title" value="COMMON.MENU.MSS_TALE_OVER_SEAS"/>
    <jsp:param name="click" value="Y"/>
</jsp:include>
<form name="form1" method="post" >
<input type="hidden" name="hdn_deptId"  value="<%=deptId%>">
<input type="hidden" name="hdn_deptNm"  value="<%=deptNm%>">
<input type="hidden" name="I_ORGEH"  value="<%=deptId%>">
<input type="hidden" name="sMenuCode"  value="<%=sMenuCode%>">
<input type="hidden" name="sMenuText"   value="<%=sMenuText %>">
<input type="hidden" name="command"   value="<%= sCommand%>">
<input type="hidden" name="targetpage"   value="">
<input type="hidden" name="chck_sub"   value="<%=chck_yeno %>">
<input type="hidden" name="viewGubun"   value="GP">
<input type="hidden" name="searchRegion"   value="<%=searchRegion %>">
<input type="hidden" name="tabSet"  value="<%= tabNo%>">
<input type="hidden" name="I_INOUT"   value="2">

<input type="hidden" name="selectRegTxt"   value="<%=selectRegTxt %>">

<%

	  Vector vcheckBox = cb;
	  int bsize = vcheckBox.size();
	  StringBuffer argBuf = new StringBuffer();
	  for(int i=0; i<bsize; i++){
		  argBuf.append("&checkBox="+ vcheckBox.get(i));
	  }
%>
	<!--   부서검색 보여주는 부분 시작   -->
	<%@ include file="/web/common/SearchDeptInfo.jsp" %>
	<!--   부서검색 보여주는 부분  끝    -->

	<!--   지역국가선택 -->
	<div class="tableInquiry">
		<table>
			<tr>
				<th><spring:message code="LABEL.N.N02.0014" /><!-- 지역 --></th>
				<td>
					<select name="selectRegion" onChange="javascript:change_region(this);" style="width:155px;font-size: 12px" >
						<option value=""><spring:message code="LABEL.N.N02.0012" /><!-- 전체 --></option>
						<%= WebUtil.printOption(area_vt, searchRegion ) %>
					</select>
          		</td>
          		<th><spring:message code="LABEL.N.N02.0015" /><!-- 국가 --></th>
          		<td>
          			<table cellpadding='0' cellspacing='0' style='cursor:hand'>
						<tr>
							<td  width='160' height='20'>
								<input type="text" name="searchNation" style="width:140;height:20px" value="<%= searchNation%>" readonly>
                	        	<input type="button" value="" onClick="controlNationBox()"  style="background:url(<%= WebUtil.ImageURL %>/ehr_common/select_btbg.gif);width:18px;margin-left:-5px;height:23px;border:0;cursor:hand">
                          	</td>
                         </tr>
					</table>
					<div id='Div4'  style=' width:140px; position:absolute;visibility:hidden;border:1px solid #DBDBDB; background-color:#FFFFFF' >
							<% for(int i=0; i<land_vt.size(); i++){
								 landHM = (HashMap)landVT.get(i);
								 String NationName = landHM.get("CODTX");
								 String NationCode =  landHM.get("ZCODE");
									 Vector checkBox = (Vector)request.getAttribute("checkBox");
									 String checkedVal ="";
									 if(checkBox != null){
										 int size = checkBox.size();
										 for(int gg=0; gg<size; gg++){
											 String pcode = (String)checkBox.get(gg);
											 if(NationCode.equals(pcode)){
												 checkedVal ="checked";
											 }
										 }
									 }
								 %>

							    <input type='checkbox' id= "chkbox" name='checkBox' value='<%=NationCode %>'  <%=checkedVal %>><%=NationName %><BR>

							    <input type='hidden' name="hidden_nation" value='<%=NationName %>' >
							<% } %>
					</div>
		    	</td>
				<td>
					<div class="tableBtnSearch tableBtnSearch2">
						<a class="search" href="javascript:searchNationDetail();"><span><spring:message code="LABEL.N.N02.0016" /><!-- 조회 --></span></a>
					</div>
				</td>
        	</tr>
     	 </table>
	</div>
	<!--   지역국가선택 -->
	<div id="divLoading" style="position:absolute; top:250px; left:0; width:100%; text-align:center; margin:0 auto;">
    	 <script>
    	 blockFrame();
        </script>
	</div>
	<div id="divBody">
		<div>
		<!-- TAB 프레임  -->
		<iframe id="listFrame" name="listFrame" src="<%= WebUtil.ServletURL %>hris.N.orgstats.globalprsn.GlobalPrsnSV?command=<%= sCommand%>&tabSet=<%= tabNo%>&viewGubun=GP&sMenuCode=<%=sMenuCode %>&sMenuText=<%=sMenuText%>&chck_sub=<%= chck_yeno%>&chck_yeno=<%=chck_yeno %>&hdn_deptId=<%=deptId%>&hdn_deptNm=<%=deptNm %>&searchRegion=<%=searchRegion %><%=argBuf %>" width="100%" height="1224" marginwidth="0" marginheight="0" scrolling="auto"  frameborder=0 ></iframe>
		</div>
	</div>
</form>

<jsp:include page="/include/body-footer.jsp" />
<jsp:include page="/include/footer.jsp" />

