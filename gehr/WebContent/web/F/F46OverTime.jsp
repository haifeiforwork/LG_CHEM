<%/******************************************************************************/
/*                                                                             */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : 근태                                                        */
/*   Program Name : 연장근로실적정보                                            */
/*   Program ID   : F46OverTime.jsp                               */
/*   Description  : 부서별 연장근로실적정보 조회를 위한 jsp 파일                */
/*   Note         : 없음                                                        */
/*   Creation     : 2013-09-30 손혜영                                           */
/*   Update       :   2017/08/28 eunha [CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건*/
/*   	          :   2018/05/28 성환희 [WorkTime52] 휴일근로포함 주당평균 연장근로 필드 삭제 건*/
/********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="com.sns.jdf.util.WebUtil" %>
<%@ page import="com.sns.jdf.util.DataUtil" %>
<%@ page import="hris.F.*" %>
<%@ page import="hris.F.rfc.*" %>
<%@ page import="hris.N.AES.AESgenerUtil"%>

<%
	// 웹로그 메뉴 코드명
	String sMenuCode = WebUtil.nvl(request.getParameter("sMenuCode"));
    String deptId       = WebUtil.nvl(request.getParameter("hdn_deptId"));          //부서코드
    String deptNm       = WebUtil.nvl(request.getParameter("hdn_deptNm"));          //부서명
    String searchDay    = WebUtil.nvl((String)request.getAttribute("E_YYYYMON"));   //대상년월
    F46OverTimeData searchData = (F46OverTimeData)request.getAttribute("searchData");   //대상년월
    Vector overTimeVt = (Vector)request.getAttribute("overTimeVt");
    String chck_yeno = WebUtil.nvl((String)request.getParameter("chck_yeno"),(String)request.getAttribute("checkYn"));     //하위부서여부.
	String subView       = WebUtil.nvl(request.getParameter("subView"));

    String searchD = searchData.yymmdd;
    if(searchData.yymmdd.equals("")){
    	searchD = searchData.I_TODAY;
    }
    String searchDto = DataUtil.addDays(DataUtil.delDateGubn(searchD),6) ;

%>
<jsp:include page="/include/header.jsp" />
<SCRIPT LANGUAGE="JavaScript">
<!--


//전체 공통 이벤트 적용
	$(document).ready(function(){
		//선택구분에 따른 날짜Change
		gbChange('<%=searchData.I_GUBUN%>');
		setTd();
		//select change
		$('select').change(function(){
			var nm = this.name;
			if(nm=="I_GBN") return;

			//성명 select
			if(nm=="gubun"){
				gbChange(this.value);
			}

			search();

		});

		$('#yymmdd').change(function(){
			daychange();
		});
	});

//선택구분에 따른 날짜Change
function gbChange(val){

	if(val=="1"){
		$('#gb1').show();
		$('#gb2').hide();
	} else {
		$('#gb1').hide();
		$('#gb2').show();
	}
}

//조회에 의한 부서ID와 그에 따른 조회.
function setDeptID(deptId, deptNm){
    frm = document.form1;

    // 하위조직포함이고 LG Chem(50000000) 은 데이타가 많아서 막음. - 2005.03.30 윤정현
    if ( deptId == "50000000" && frm.chk_organAll.checked == true ) {
       // alert("선택하신 조직은 데이터가 너무 많습니다. \n\n하위조직을 선택하여 조회하시기 바랍니다.   ");
       alert("<%=g.getMessage("MSG.F.F41.0003")%>");
        return;
    }

    frm.hdn_deptId.value = deptId;
    frm.hdn_deptNm.value = deptNm;

    search();
}


//Execl Down 하기.
function excelDown() {
    frm = document.form1;
    frm.hdn_excel.value = "ED";
    frm.action = "<%= WebUtil.ServletURL %>hris.F.F46OverTimeSV";
    frm.target = "hidden";
    frm.submit();
}
//조회
function search() {

    frm = document.form1;
    frm.sortField.value = "";
    frm.sortValue.value = "";
    frm.sortId.value = "";
    frm.hdn_excel.value = "";
    frm.action = "<%= WebUtil.ServletURL %>hris.F.F46OverTimeSV";
    frm.target = "_self";
    frm.method = "post";
    frm.submit();
}

// 달력 사용 시작
function fn_openCal(Objectname)
{
   var lastDate;

   lastDate = eval("document.form1." + Objectname + ".value");
   small_window  = window.open("/web/common/calendar.jsp?formname=form1&fieldname="+ Objectname + "&curDate=" + lastDate + "&iflag=0&afterAction=daychange()","essCal", "toolbar=0,location=0,directories=0,status=0,menubar=0,resizable=0,width=300,height=300");
   small_window.focus();
}



//날짜변경시 조회
function daychange(){
	frm = document.form1;
	var val = frm.yymmdd.value;

	var bfVal = frm.bfday.value;
	if(val.length<10||!isDate(val)){
		//alert("날짜 형식이 틀립니다.\n\'YYYY.MM.DD\' 형식으로 입력하세요.");
		alert("<%=g.getMessage("MSG.F.F46.0001")%>");
		frm.yymmdd.focus();
		return;
	}
	//if(val!=bfVal){
	//	frm.bfday.value = val;
	//	search();
	//}

	frm.toyymmdd.value = getAfterDate(val,6);
	search();
}
//테이블헤더정렬
function sortPage(FieldName, sortId){
return;
 frm = document.form1;
  if(frm.sortField.value==FieldName){
    if(frm.sortValue.value=='desc'){
      frm.sortValue.value = 'asc';
    } else {
      frm.sortValue.value = 'desc';
    }
  } else {
    frm.sortField.value = FieldName;
    frm.sortValue.value = 'desc';
  }

  frm.sortId.value = sortId;
  frm.hdn_excel.value = "";
  frm.action = "<%= WebUtil.ServletURL %>hris.F.F46OverTimeSV";
  frm.target = "_self";
  frm.method = "post";
  frm.submit();
}

//정렬시 리스트 헤더명에 정렬표시
function setTd(){
return;
	if(document.form1.sortField.value=="") return;

	var val = document.form1.sortId.value;
	var sVal = document.form1.sortValue.value;

	//th reset
	for(var i=1; i<12; i++){
		var r = i;
		var id = "td"+r;
		var record = document.getElementById(id).innerHTML.replace(/▼/gi,"");
		var record = document.getElementById(id).innerHTML.replace(/△/gi,"");
		document.getElementById(id).innerHTML = record;
	}

	var thNm = document.getElementById(val).innerHTML;
	if(sVal=="desc"){
		document.getElementById(val).innerHTML = thNm + "▼";
	} else {
		document.getElementById(val).innerHTML = thNm + "△";
	}
}

function popupView(winName, width, height, pernr) {
	var formN = document.form1;
	formN.viewEmpno.value = pernr;

	var screenwidth = (screen.width-width)/2;
    var screenheight = (screen.height-height)/2;
    var theURL = "<%= WebUtil.ServletURL %>hris.N.mssperson.A01SelfDetailNeoSV_m?sMenuCode=<%=sMenuCode%>&ViewOrg=Y&viewEmpno="+pernr;

	 var retData = showModalDialog(theURL,window, "location:no;scroll:yes;menubar:no;status:no;help:no;dialogwidth:"+width+"px;dialogHeight:"+height+"px");

}

//-->
</SCRIPT>

    <jsp:include page="/include/body-header.jsp">
        <jsp:param name="click" value="Y'"/>
    </jsp:include>



<form name="form1" method="post" onsubmit="return false">
<input type="hidden" name="hdn_deptId"  value="<%=deptId%>">
<input type="hidden" name="hdn_deptNm"  value="<%=deptNm%>">
<input type="hidden" name="I_VALUE1"  value="">
<input type="hidden" name="retir_chk"  value="">
<input type="hidden" name="hdn_excel"   value="">
<input type="hidden" name="bfday"   value="<%=WebUtil.printDate(searchData.yymmdd)%>">
<input type="hidden" name="viewEmpno" value="">
<input type="hidden" name="ViewOrg" value="Y">
<input type="hidden" name="subView" value="<%=subView%>">

<input type="hidden" name="chck_yeno"  value='<%=chck_yeno%>' >



          <div class="buttonArea"><!--선택구분--><%=g.getMessage("LABEL.F.F46.0002")%>

	         <select name="gubun">
	         	<option value="1" <%= searchData.I_GUBUN.equals("1")? " selected " : "" %>><!--월별--><%=g.getMessage("LABEL.F.F46.0003")%></option>
	         	<option value="2" <%= searchData.I_GUBUN.equals("2")? " selected " : "" %>><!--주간--><%=g.getMessage("LABEL.F.F46.0004")%></option>
	         </select>
		         <span id="gb1">
		         <select name="year">

<%
  int end_year= Integer.parseInt( DataUtil.getCurrentYear() );
  if (Integer.parseInt(DataUtil.getCurrentDate().substring(4,8)) >=1221){
	  end_year = end_year+1;
  }
    for( int i = 2001 ; i <= end_year ; i++ ) {
        if(searchData.year.equals("")){
        	searchData.year = searchDay.substring(0, 4);
        }
    	int year1 = Integer.parseInt(searchData.year);
%>
                      <option value="<%= i %>"<%= year1 == i ? " selected " : "" %>><%= i %></option>
<%
    }
%>
                    </select>
                    <select name="month">
<%
    for( int i = 1 ; i <= 12 ; i++ ) {
        String temp = Integer.toString(i);
        if(searchData.month.equals("")){
        	searchData.month = searchDay.substring(4, 6);
        }
        int mon = Integer.parseInt(searchData.month);
%>
                      <option value="<%= temp.length() == 1 ? '0' + temp : temp %>"<%= mon == i ? " selected " : "" %>><%= temp.length() == 1 ? '0' + temp : temp %></option>
<%
    }
%>
                    </select>
             	</span>
	             <span id="gb2" >
	             	<input class="date" name="yymmdd" id="yymmdd" type="text" size="10" maxlength="10" value="<%=WebUtil.printDate(searchD)%>" style="TEXT-ALIGN:center;" align="absmiddle">
	            -  <input name="toyymmdd" readonly id="toyymmdd" type="text" size="10" maxlength="10" value="<%=WebUtil.printDate(searchDto)%>" style="TEXT-ALIGN:center;" align="absmiddle">

             </span>

     	   <input type="checkbox" name="overYn" value="Y" <%= searchData.I_OVERYN.equals("Y")  ? "checked" : "" %> onclick="search();"><!--연장근로 해당인원--><%=g.getMessage("LABEL.F.F46.0006")%>

        	<ul class="btn_mdl displayInline">
        		<li><a class="unloading" href="javascript:excelDown();"><span><spring:message code='LABEL.F.F31.0001'/><!-- Excel Download --></span></a></li>
        	</ul>
</div>

<%
 		String tempDept = "";
 		for( int i = 0; i < overTimeVt.size(); i++ ){
 			F46OverTimeData tdata = (F46OverTimeData)overTimeVt.get(i);
			//하위부서를 선택했을 경우 부서 비교.
            if( !tdata.ORGEH.equals(tempDept) ){
%>

    <div class="listArea">
    <div calss="listTop">
    	<span class="listCnt">
  			<h2 class="subtitle"><!-- 부서명--><%=g.getMessage("LABEL.F.F41.0002")%> : <%=tdata.STEXT%></h2>
  		</span>
    </div>
    	<div class="table">
     		<table class="listTable">
     		<thead>
		        <tr>
		          <th rowspan="2" id="<%=i %>td1" onClick="sortPage('PTEXT','td1')"><!--신분--><%=g.getMessage("LABEL.F.F46.0007")%></th>
		          <th rowspan="2" id="<%=i %>td2" onClick="sortPage('PERNR','td2')"><!-- 사번--><%=g.getMessage("LABEL.F.F41.0004")%></th>
		          <th rowspan="2" id="<%=i %>td3" onClick="sortPage('ENAME','td3')"><!--성명--><%=g.getMessage("LABEL.F.F42.0003")%></th>
				  <%--CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 start--%>
    	          <%--<th rowspan="2" id="<%=i %>td4" onClick="sortPage('TITEL','td4')"><!--직위--><%=g.getMessage("LABEL.F.F41.0008")%></th> --%>
    	          <th rowspan="2" id="<%=i %>td4" onClick="sortPage('TITEL','td4')"><!-- 직위/직급호칭 --><%=g.getMessage("MSG.A.A01.0083")%></th>
                  <%--CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 end--%>
		          <th rowspan="2" id="<%=i %>td5" onClick="sortPage('TITL2','td5')"><!--직책--><%=g.getMessage("LABEL.F.F41.0007")%></th>
		          <th colspan="4"><!--연장근로--><%=g.getMessage("LABEL.F.F46.0017")%></th>
		          <th class="lastCol" rowspan="2" id=<%=i %>"td10" onClick="sortPage('HTKGUN','td10')"><!--휴일근로--><%=g.getMessage("LABEL.F.F46.0008")%></th>
		        </tr>
		        <tr>
		          <th id="<%=i %>td6" onClick="sortPage('YUNJANG','td6')"><!--평일연장--><%=g.getMessage("LABEL.F.F46.0010")%></th>
		          <th id="<%=i %>td7" onClick="sortPage('HYUNJANG','td7')"><!--휴일연장--><%=g.getMessage("LABEL.F.F46.0011")%></th>
		          <th id="<%=i %>td8" onClick="sortPage('SUB_TOTAL','td8')"><!--소계--><%=g.getMessage("LABEL.F.F46.0012")%></th>
		          <th id="<%=i %>td9" onClick="sortPage('WEEK_AVG','td9')"><!--주당평균<br/>연장근로--><%=g.getMessage("LABEL.F.F46.0013")%></th>
		        </tr>
		      </thead>
<%
		for(int j=i;j<overTimeVt.size();j++){
			F46OverTimeData data = (F46OverTimeData)overTimeVt.get(j);
            String PERNR =  AESgenerUtil.encryptAES(data.PERNR, request); //암호화를 위해

            String tr_class = "";

            if(j%2 == 0){
                tr_class="oddRow";
            }else{
                tr_class="";
            }

        	if(!data.ENAME.equals("TOTAL")){
%>
		        <tr class="<%=tr_class%>">
		          <td ><%=data.PTEXT    %></td>
		          <td ><a class="unloading"  href="javascript:popupView('orgView','1024','700','<%= PERNR %>')"><font color=blue><%=data.PERNR    %></td>
		          <td ><%=data.ENAME    %></td>
		          <td ><%=data.TITEL    %></td>
		          <td ><%=data.TITL2    %></td>
		          <td ><%=WebUtil.printNumFormat(data.YUNJANG,1)%></td>
		          <td ><%=WebUtil.printNumFormat(data.HYUNJANG     ,1)%></td>
		          <td ><%=WebUtil.printNumFormat(data.SUB_TOTAL    ,1)%></td>
		          <td ><%=WebUtil.printNumFormat(data.WEEK_AVG    ,1)%></td>
		          <td class="lastCol"><%=WebUtil.printNumFormat(data.HTKGUN     ,1)%></td>
		        </tr>
<%
        	} else {
%>
				<tr class="sumRow">
		          <td colspan="5"><%=tdata.STEXT%> <!--평균--><%=g.getMessage("LABEL.F.F46.0014")%></td>
		          <td ><%=WebUtil.printNumFormat(data.YUNJANG,1)%></td>
		          <td ><%=WebUtil.printNumFormat(data.HYUNJANG     ,1)%></td>
		          <td ><%=WebUtil.printNumFormat(data.SUB_TOTAL    ,1)%></td>
		          <td ><%=WebUtil.printNumFormat(data.WEEK_AVG    ,1)%></td>
		          <td class="lastCol"><%=WebUtil.printNumFormat(data.HTKGUN     ,1)%></td>
		        </tr>
<%
				break;
        	}

		}
%>
			</table>
		</div>
	</div>
<%

            }//end if
			//부서코드 비교를 위한 값.
            tempDept = tdata.ORGEH;
        }//end for
%>

  	<div class="commentImportant">
  		<p><!--＊주당평균 연장근로시간 = (평일연장+휴일연장시간)  / 근태일수 * 7일</p>
  		<p>＊휴일근로포함 주당평균 연장근로시간 = (평일연장+휴일연장시간 +휴일근로)  / 근태일수 * 7일</p>
  		<p>＊법정근로시간(주) : 기본근무(40hr)+연장근무(12hr)=52hr한도--><%=g.getMessage("LABEL.F.F46.0015")%>
  	</div>


</div>
  <input type="hidden" name="sortField" value="<%= searchData.sortField %>">
  <input type="hidden" name="sortValue" value="<%= searchData.sortValue %>">
    <input type="hidden" name="sortId" value="<%= searchData.sortId %>">
</form>
<jsp:include page="/include/body-footer.jsp" />
<jsp:include page="/include/footer.jsp" />
