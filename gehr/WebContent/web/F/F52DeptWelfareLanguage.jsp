<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  :                                                     */
/*   Program Name :                                        */
/*   Program ID   : F52DeptWelfareLanguage.jsp                                          */
/*   Description  :                        */
/*   Note         :                                                         */
/*   Creation     : 2007-10-31 zgw                                           */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="hris.F.*" %>
<%@ page import="hris.F.rfc.*" %>
<%@ page import="hris.common.util.*" %>
<%
    request.setCharacterEncoding("utf-8");
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

    String deptNm       = WebUtil.nvl(request.getParameter("hdn_deptNm"));
    String startDay     = WebUtil.nvl(request.getParameter("txt_startDay"), preDate);   //검색시작일
    String endDay       = WebUtil.nvl(request.getParameter("txt_endDay"), toDate);      //검색종료일


    String E_RETURN3     = WebUtil.nvl((String)request.getAttribute("E_RETURN3"));
    String E_MESSAGE3    = WebUtil.nvl((String)request.getAttribute("E_MESSAGE3"));

    Vector DeptWelfareLanguage_vt = (Vector)request.getAttribute("DeptWelfareLanguage_vt");
    String chck_yeno = WebUtil.nvl((String)request.getParameter("chck_yeno"),(String)request.getAttribute("checkYn"));     //하위부서여부.

%>

<jsp:include page="/include/header.jsp" />

<SCRIPT LANGUAGE="JavaScript">

function doSubmit(obj) {

    document.form1.action = "<%= WebUtil.ServletURL %>hris.F.F52DeptWelfareLanguageEXPSV";
    document.form1.method = "post";
    document.form1.submit();

}

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
        frm.action = "<%= WebUtil.ServletURL %>hris.F.F52DeptWelfareLanguageEXPSV";
        frm.target = "_self";
        frm.submit();
    }
}

//Execl Down 하기.
function excelDown(selectType) {
    var frm = document.form1;

    frm.hdn_excel.value = "ED" + selectType;
    frm.action = "<%= WebUtil.ServletURL %>hris.F.F52DeptWelfareLanguageEXPSV";
    frm.target = "hidden";
    frm.submit();
}


function fn_openCal(Objectname){
        var lastDate;
        lastDate = eval("document.form1." + Objectname + ".value");
        small_window=window.open("<%=WebUtil.JspURL%>common/calendar.jsp?formname=form1&fieldname="+Objectname+"&curDate="+lastDate+"&iflag=0&optionvalue=","essCal","toolbar=0,location=0,directories=0,status=0,menubar=0,resizable=0,width=270,height=285");
        small_window.focus();
    }
//-->
</SCRIPT>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<form name="form1" method="post" onsubmit="return false">
<input type="hidden" name="hdn_deptId"  value="<%=deptId%>">
<input type="hidden" name="hdn_deptNm"  value="<%=deptNm%>">
<input type="hidden" name="hdn_excel"   value="">
<input type="hidden" name="chck_yeno"  value="<%=chck_yeno%>">

<div class="subWrapper">

    <!--  검색테이블 시작 -->
    <div class="tableInquiry">
        <table>
            <colgroup>
                <col width="30%" />
                <col />
            </colgroup>
            <tr>
              <th>
                 <input type="text" class="date" id="txt_startDay" name="txt_startDay" size="10" value="<%=WebUtil.printDate(startDay)%>">
                 ~
                 <input type="text" class="date" id="txt_endDay" name="txt_endDay" size="10" value="<%=WebUtil.printDate(endDay)%>">
              </th>

              <td>
                <div class="tableBtnSearch tableBtnSearch2">
                    <a class="search" href="javascript:searchWelfare()"><span><!--조회--><%=g.getMessage("BUTTON.COMMON.SEARCH")%></span></a>
                </div>
              </td>
            </tr>
        </table>
    </div>

    <h2 class="subtitle"><%=g.getMessage("LABEL.F.FCOMMON.0001")%> :<%=WebUtil.nvl(deptNm, user.e_obtxt)%></h2>






    <div class="listArea">
        <div class="listTop">
<%
    if( E_RETURN3.equals("S") && DeptWelfareLanguage_vt != null && DeptWelfareLanguage_vt.size() > 0  ){
%>

            <span class="listCnt"><!--Total Count--><%=g.getMessage("LABEL.F.FCOMMON.0008")%> : <%=DeptWelfareLanguage_vt.size()%></span>
<%
    }
%>
<%
    if( E_RETURN3.equals("S") && DeptWelfareLanguage_vt != null && DeptWelfareLanguage_vt.size() > 0  ){
%>

            <div class="buttonArea">
                <ul class="btn_mdl">
                    <li><a href="javascript:excelDown('language');"><span><spring:message code='LABEL.F.F31.0001'/><!-- Excel Download --></span></a></li>
                </ul>
            </div>
            <div class="clear"></div>
<%
    }
%>
        </div>
        <div class="table">
            <table class="listTable">
              <tr>

                <th><!--Corp.--><%=g.getMessage("LABEL.F.F52.0001")%></th>
                <th><!--Pers. No--><%=g.getMessage("LABEL.F.F52.0002")%></th>
                <th><!--Emp. Name--><%=g.getMessage("LABEL.F.F52.0003")%></th>
                <th><!--Org. Unit--><%=g.getMessage("LABEL.F.F52.0004")%></th>
    <!--
                <th>Res. of Office</th>
                <th>Title of Level</th>
                <th>Level/Annual</th>
     -->
                <th><!--Payment Date--><%=g.getMessage("LABEL.F.F52.0005")%></th>

                <th><!--Family Type--><%=g.getMessage("LABEL.F.F52.0022")%></th>
                <th><!--Name--><%=g.getMessage("LABEL.F.F52.0007")%></th>
                <th><!--Institute--><%=g.getMessage("LABEL.F.F52.0023")%></th>
                <th><!--Payment Period--><%=g.getMessage("LABEL.F.F52.0024")%></th>
                <th><!--Payment Amount--><%=g.getMessage("LABEL.F.F52.0010")%></th>
                <th class="lastCol"><!--Refund Amt.--><%=g.getMessage("LABEL.F.F52.0012")%></th>

              </tr>
<%
 if( E_RETURN3.equals("S") && DeptWelfareLanguage_vt != null && DeptWelfareLanguage_vt.size() > 0  ){

            for( int k = 0; k < DeptWelfareLanguage_vt.size(); k++ ){
                F52DeptWelfareLanguageData data = (F52DeptWelfareLanguageData)DeptWelfareLanguage_vt.get(k);

                String tr_class = "";

                if(k%2 == 0){
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
<%--
            <td><%= data.JIKKT %></td>
            <td><%= data.JIKWT %></td>
            <td><%= data.LEVAU %></td>
--%>
            <td><%= (data.DAT01).replace("-","").replace(".","").equals("00000000") ? "" : WebUtil.printDate(data.DAT01) %></td>

            <td><%= data.FAMI_TEXT %></td>
            <td><%= data.PNAME %></td>
            <td><%= data.SCHNM %></td>
            <td><%= data.PERIOD %></td>
            <td><%= data.REIM_CAL.equals("0")?"":WebUtil.printNumFormat(data.REIM_CAL, 2)  +" "+ data.WAERS %></td>
            <td class="lastCol"><%= data.REFU_AMNT.equals("0")?"":WebUtil.printNumFormat(data.REFU_AMNT, 2)  +" "+ data.WAERS %></td>

          </tr>
<%
            } //end for...

          }else{
%>

         <tr class="oddRow">
             <td  colspan="11" class="lastCol"><!--No data--><%=g.getMessage("MSG.F.FCOMMON.0002")%></td>
         </tr>

<%
      }
%>
            </table>
        </div>
    </div>

</table>

<%--

<%
    }else{
%>

    <div class="align_center">
        <p>No data</p>
    </div>

<%
    }
  }else{

%>
    <div class="align_center">
        <p>No data</p>
    </div>
<%
} //end if...
%>

--%>
</div>
</form>
</body>
<jsp:include page="/include/footer.jsp"/>       <!-- html footer 부분 -->
