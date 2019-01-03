<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : 복리후생                                                    */
/*   Program Name : 부서별 복리후생 현황                                        */
/*   Program ID   : F51DeptWelfare.jsp                                          */
/*   Description  : 부서별 복리후생 조회를 위한 jsp 파일                        */
/*   Note         : 없음                                                        */
/*   Creation     : 2005-02-21 유용원                                           */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="hris.F.Global.*" %>
<%@ page import="hris.F.rfc.*" %>
<%@ page import="hris.common.util.*" %>
<%
    //현재 일자 형식 'YYYYMMDD'
    String toDate = DataUtil.getCurrentDate();
    String preDate = null;
    String yearStr = toDate.substring(0, 4);
    int year = Integer.parseInt(yearStr);

    if(((year % 4 == 0 && year % 100 != 0) || year % 400 == 0)){

         preDate  = DataUtil.addDays(toDate, -366);
    }else{
         preDate      = DataUtil.addDays(toDate, -365);
    }

    WebUserData user    = (WebUserData)session.getAttribute("user");                        //세션.
    String deptId       = WebUtil.nvl(request.getParameter("hdn_deptId"), user.e_objid);
    String deptNm       = (WebUtil.nvl(request.getParameter("hdn_deptNm")));
    String selGubun     = WebUtil.nvl(request.getParameter("sel_gubun"), "99");         //구분
    String startDay     = WebUtil.nvl(request.getParameter("txt_startDay"), preDate);   //검색시작일
    String endDay       = WebUtil.nvl(request.getParameter("txt_endDay"), toDate);      //검색종료일
    String E_RETURN     = WebUtil.nvl((String)request.getAttribute("E_RETURN"));        //RFC 결과
    String E_MESSAGE    = WebUtil.nvl((String)request.getAttribute("E_MESSAGE"));       //RFC 결과 메시지
    Vector DeptWelfare_vt = (Vector)request.getAttribute("DeptWelfare_vt");
%>
<jsp:include page="/include/header.jsp" />
<SCRIPT LANGUAGE="JavaScript">
<!--

//조회에 의한 부서ID와 그에 따른 조회.
function setDeptID(deptId, deptNm){
    var frm = document.form1;

    frm.hdn_deptId.value = deptId;
    frm.hdn_deptNm.value = deptNm;
    searchWelfare();
}

//조회에 의한 부서ID와 그에 따른 조회.
function searchWelfare(){
    var frm = document.form1;
    var isValide = false;

    if ( dateFormat(frm.txt_startDay) ) {
        isValide = true;
    } else {
        frm.txt_startDay.focus();
        return;
    }

    if ( dateFormat(frm.txt_endDay) ) {
        isValide = true;
    } else {
        return;
    }

    if ( isValide ) {
        frm.hdn_excel.value = "";
        frm.action = "<%= WebUtil.ServletURL %>hris.F.F51DeptWelfareSV";
        frm.target = "_self";
        frm.submit();
    }
}

//Execl Down 하기.
function excelDown() {
    var frm = document.form1;

    frm.hdn_excel.value = "ED";
    frm.action = "<%= WebUtil.ServletURL %>hris.F.F51DeptWelfareSV";
    frm.target = "hidden";
    frm.submit();
}
//-->
</SCRIPT>



    <jsp:include page="/include/body-header.jsp">
        <jsp:param name="click" value="Y'"/>
        <jsp:param name="title" value="LABEL.F.F51.0016"/>
    </jsp:include>
<form name="form1" method="post" onsubmit="return false">
<input type="hidden" name="hdn_deptId"  value="<%=deptId%>">
<input type="hidden" name="hdn_deptNm"  value="<%=deptNm%>">
<input type="hidden" name="hdn_excel"   value="">

<!--   부서검색 보여주는 부분 시작   -->

  <%@ include file="../common/SearchDeptInfo.jsp" %>

<!--   부서검색 보여주는 부분  끝    -->

<!--  검색테이블 시작 -->
  <div class="tableInquiry" >
    <table>
    	<colgroup>
    		<col width="30%" />
    		<col />
    	</colgroup>
      <tr>
        <th>
          <input name="txt_startDay" type="text" class="date" size="10" maxlength="10" value="<%=WebUtil.printDate(startDay)%>">
          ~
          <input name="txt_endDay" type="text"  class="date" size="10" maxlength="10" value="<%=WebUtil.printDate(endDay)%>">
        </th>
        <td>
           <div class="tableBtnSearch tableBtnSearch2">
			<a class="search" href="javascript:searchWelfare()"><span><%=g.getMessage("BUTTON.COMMON.SEARCH")%></span></a>
			</div>
	     </td>
      </tr>
    </table>
  </div>



<!--  검색테이블 끝-->

	<h2 class="subtitle"><!--Org.Unit--><%=g.getMessage("LABEL.F.F51.0030")%> :<%=WebUtil.nvl(deptNm, user.e_obtxt)%></h2>

  <div class="clear"></div>

  <div class="listArea">
  	<div class="listTop">
<%
    if ( E_RETURN.equals("S") ) {
       if ( DeptWelfare_vt != null && DeptWelfare_vt.size() > 0 ) {
 %>
    	<span class="listCnt"><!--Total Count --><%=g.getMessage("LABEL.F.F51.0017")%>: <%=DeptWelfare_vt.size()%></span>
         <%
                  }
               }
            %>

<%
     if ( E_RETURN.equals("S") ) {

        if ( DeptWelfare_vt != null && DeptWelfare_vt.size() > 0 ) {
  %>
  		<div class="buttonArea">
		      <ul class="btn_mdl">
		        <li><a href="javascript:excelDown();"><span><spring:message code='LABEL.F.F31.0001'/><!-- Excel Download --></span></a></li>
		      </ul>
      	</div>
      	<div class="clear"></div>
<%
      }
   }
%>
  	</div>
    <div class="table">
      <table class="listTable">
        <tr>
          <th><!--Corp. --><%=g.getMessage("LABEL.F.F51.0018")%></th>
          <th><!--Pers. No --><%=g.getMessage("LABEL.F.F51.0019")%></th>
          <th><!--Emp. Name --><%=g.getMessage("LABEL.F.F51.0020")%></th>
          <th><!--Org. Unit --><%=g.getMessage("LABEL.F.F51.0021")%></th>
          <th><!--Payment Date --><%=g.getMessage("LABEL.F.F51.0022")%></th>
          <th><!--Cel/Con Type --><%=g.getMessage("LABEL.F.F51.0023")%></th>
          <th><!--Family Type --><%=g.getMessage("LABEL.F.F51.0024")%></th>
          <th><!--Name --><%=g.getMessage("LABEL.F.F51.0025")%></th>
          <th><!--Payment Amount --><%=g.getMessage("LABEL.F.F51.0026")%></th>
          <th><!--Approved Date --><%=g.getMessage("LABEL.F.F51.0027")%></th>
          <th class="lastCol"><!--Refund Amt. --><%=g.getMessage("LABEL.F.F51.0028")%></th>
        </tr>
<%
    if ( E_RETURN.equals("S") && DeptWelfare_vt != null && DeptWelfare_vt.size() > 0  ) {

            for( int i = 0; i < DeptWelfare_vt.size(); i++ ){
                F51DeptWelfareData data = (F51DeptWelfareData)DeptWelfare_vt.get(i);

                String tr_class = "";

                if(i%2 == 0){
                    tr_class="oddRow";
                }else{
                    tr_class="";
                }
%>
        <tr class="<%=tr_class%>">
          <td><%= data.PBTXT %></td>
          <td><%= data.PERNR %></td>
          <td><%= data.ENAME %></td>
          <td><%= data.ORGTX %></td>
          <td><%= (data.DAT01).replace("-","").replace(".","").equals("00000000")  ? "" : WebUtil.printDate(data.DAT01) %></td>
          <td><%= data.CELTX %></td>
          <td><%= data.FAMY_TEXT %></td>
          <td><%= data.FNAME %></td>
          <td><%= data.PAYM_AMNT.equals("0")?"":WebUtil.printNumFormat(data.PAYM_AMNT,2) +" "+ data.WAERS %></td>
          <td><%= (data.APVDT).replace("-","").replace(".","").equals("00000000")  ? "" : WebUtil.printDate(data.APVDT) %></td>
          <td class="lastCol"><%= data.REFU_AMNT.equals("0")?"":WebUtil.printNumFormat(data.REFU_AMNT,2) +" "+ data.WAERS %></td>
        </tr>
<%
          } //end for...

   }else{

%>

        <tr align="center">
          <td class="lastCol" colspan="11" align="center" ><!--No data --><%=g.getMessage("LABEL.F.F51.0029")%></td>
        </tr>
<%
     }
%>
      </table>
    </div>
  </div>
</div>
</form>
<jsp:include page="/include/body-footer.jsp" />
<jsp:include page="/include/footer.jsp" />
