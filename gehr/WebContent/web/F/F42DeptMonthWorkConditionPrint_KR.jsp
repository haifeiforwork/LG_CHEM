<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : 근태                                                        */
/*   Program Name : 월간 근태 집계표 출력                                       */
/*   Program ID   : F42DeptMonthWorkConditionPrint.jsp                          */
/*   Description  : 부서별 월간 근태 집계표 출력을 위한 jsp 파일                */
/*   Note         : 없음                                                        */
/*   Creation     : 2009-03-01 김종서                                           */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="com.sns.jdf.util.WebUtil" %>
<%@ page import="hris.F.*" %>
<%@ page import="hris.F.rfc.*" %>

<%
  String deptId       = WebUtil.nvl(request.getParameter("hdn_deptId"));          //부서코드
  String deptNm       = WebUtil.nvl(request.getParameter("hdn_deptNm"));          //부서명
  String searchDay    = WebUtil.nvl((String)request.getAttribute("E_YYYYMON"));   //대상년월
  String year      = "";
  String month     = "";
  Vector F42DeptMonthWorkCondition_vt = (Vector)request.getAttribute("F42DeptMonthWorkCondition_vt");
%>

<jsp:include page="/include/header.jsp" />
<!-- Page Skip 해서 프린트 하기 -->
<style type = "text/css">
P.breakhere {page-break-before: always}
</style>
<SCRIPT LANGUAGE="JavaScript">
<!--
function prevDetail() {
  switch (location.hash)  {
    case "#page2":
      location.hash ="#page1";
    break;
  } // end switch
}

function nextDetail() {
  switch (location.hash)  {
    case "":
    case "#page1":
      location.hash ="#page2";
    break;
  } // end switch
}

function click() {
    if (event.button==2) {
      //alert('마우스 오른쪽 버튼은 사용할수 없습니다.');
      //alert('오른쪽 버튼은 사용할수 없습니다.');
      alert('<%=g.getMessage("MSG.F.F41.0006")%>');

   return false;
    }
  }

 function keypressed() {
      //alert('키를 사용할 수 없습니다.');
       return false;
  }

  document.onmousedown=click;
  document.onkeydown=keypressed;


//-->
</SCRIPT>

    <jsp:include page="/include/body-header.jsp">
        <jsp:param name="click" value="Y"/>
    </jsp:include>
<form name="form1" method="post">

<div class="winPop">

  <div class="header">
    <span><!-- 월간 근태 집계표 --><%=g.getMessage("TAB.COMMON.0044")%></span>
    <a href="" onclick="top.close();"><img src="<%=WebUtil.ImageURL%>sshr/btn_popup_close.png" /></a>
  </div>


<%
    //부서명, 조회된 건수.
    if ( F42DeptMonthWorkCondition_vt != null && F42DeptMonthWorkCondition_vt.size() > 0 ) {
%>

    <div class="listArea">
<%
        String tempDept = "";
        for( int j = 0; j < F42DeptMonthWorkCondition_vt.size(); j++ ){
            F42DeptMonthWorkConditionData deptData = (F42DeptMonthWorkConditionData)F42DeptMonthWorkCondition_vt.get(j);

            //하위부서를 선택했을 경우 부서 비교.
            if( !deptData.ORGEH.equals(tempDept) ){
%>

  <div class="body">
    <h2 class="subtitle"><!-- 부서명--><%=g.getMessage("LABEL.F.F41.0002")%>  : <%=deptData.STEXT%></h2>


<%

        int year1 = Integer.parseInt(searchDay.substring(0, 4));
    	int mon = Integer.parseInt(searchDay.substring(4, 6));
%>



      <div class="listTop">
        <span class="listCnt">
          <%= year1 %><!-- 년 --><%=g.getMessage("LABEL.F.F42.0052")%> &nbsp;<%= mon %><!-- 월 --><%=g.getMessage("LABEL.F.F42.0053")%>
        </span>
      </div>
      <div class="table">
        <table class="listTable">
        <thead>
          <tr>
            <th rowspan="3" ><!-- 성명--><%=g.getMessage("LABEL.F.F42.0003")%></th>
            <th rowspan="3" ><!-- 사번--><%=g.getMessage("LABEL.F.F41.0004")%></th>
            <th rowspan="3" ><!-- 잔여휴가--><%=g.getMessage("LABEL.F.F42.0004")%></th>
            <th rowspan="3" ><!-- 잔여보상--><%=g.getMessage("LABEL.F.F42.0087")%><br/><!-- 휴가--><%=g.getMessage("LABEL.F.F42.0011")%></th>
            <th colspan="23" ><!-- 근태집계--><%=g.getMessage("LABEL.F.F42.0005")%></th>
            <th class="lastCol"  rowspan="3" ><!-- 서명--><%=g.getMessage("LABEL.F.F42.0054")%></th>
          </tr>
          <tr>
            <th colspan="11" ><!-- 비근무--><%=g.getMessage("LABEL.F.F42.0006")%></th>
            <th colspan="2" ><!-- 근무--><%=g.getMessage("LABEL.F.F42.0007")%></th>
            <th colspan="6" ><!-- 초과근무--><%=g.getMessage("LABEL.F.F42.0008")%></th>
            <th colspan="2" ><!-- 기타--><%=g.getMessage("LABEL.F.F42.0009")%></th>
            <th colspan="2" ><!-- 공수--><%=g.getMessage("LABEL.F.F42.0010")%></th>
          </tr>
            <th><!-- 연차--><%=g.getMessage("LABEL.F.F41.0011")%></th>
            <th><!-- 보상--><%=g.getMessage("LABEL.F.F42.0088")%><br/><!-- 휴가--><%=g.getMessage("LABEL.F.F42.0011")%></th>
            <th><!-- 경조--><%=g.getMessage("LABEL.F.F42.0012")%><br/><!-- 휴가--><%=g.getMessage("LABEL.F.F42.0011")%></th>
            <th><!-- 하계--><%=g.getMessage("LABEL.F.F42.0013")%><br/><!-- 휴가--><%=g.getMessage("LABEL.F.F42.0011")%></th>
            <th><!-- 보건--><%=g.getMessage("LABEL.F.F42.0014")%><br/><!-- 휴가--><%=g.getMessage("LABEL.F.F42.0011")%></th>
            <th><!-- 모성--><%=g.getMessage("LABEL.F.F42.0015")%><br/><!--보호--><%=g.getMessage("LABEL.F.F42.0017")%><br/><!-- 휴가--><%=g.getMessage("LABEL.F.F42.0011")%></th>
            <th><!-- 공가--><%=g.getMessage("LABEL.F.F42.0016")%></th>
            <th><!-- 결근--><%=g.getMessage("LABEL.F.F42.0018")%></th>
            <th><!-- 지각--><%=g.getMessage("LABEL.F.F42.0019")%></th>
            <th><!-- 조퇴--><%=g.getMessage("LABEL.F.F42.0020")%></th>
            <th><!-- 외출--><%=g.getMessage("LABEL.F.F42.0021")%></th>
            <%-- <th><!-- 무노동--><%=g.getMessage("LABEL.F.F42.0022")%><br/><!-- 무임금--><%=g.getMessage("LABEL.F.F42.0023")%> </th> --%>
            <th><!-- 교육--><%=g.getMessage("LABEL.F.F42.0024")%></th>
            <th><!-- 출장--><%=g.getMessage("LABEL.F.F42.0025")%></th>
            <th><!-- 휴일--><%=g.getMessage("LABEL.F.F42.0026")%><br><!-- 특근--><%=g.getMessage("LABEL.F.F42.0027")%></th>
            <th><!-- 명절--><%=g.getMessage("LABEL.F.F42.0029")%><br><!-- 특근--><%=g.getMessage("LABEL.F.F42.0027")%><br /> </th>
            <th> <!-- 휴일--><%=g.getMessage("LABEL.F.F42.0026")%><br><!-- 연장--><%=g.getMessage("LABEL.F.F42.0031")%></th>
            <th><!-- 연장--><%=g.getMessage("LABEL.F.F42.0031")%><br><!-- 근로--><%=g.getMessage("LABEL.F.F42.0032")%></th>
            <th><!--야간--><%=g.getMessage("LABEL.F.F42.0033")%><br><!-- 근로--><%=g.getMessage("LABEL.F.F42.0032")%></th>
            <th><!-- 당직--><%=g.getMessage("LABEL.F.F42.0034")%></th>
            <th><!-- 항군--><%=g.getMessage("LABEL.F.F42.0035")%><br><!-- (근무외)--><%=g.getMessage("LABEL.F.F42.0036")%></th>
            <th><!-- 교육--><%=g.getMessage("LABEL.F.F42.0024")%><br><!-- (근무외)--><%=g.getMessage("LABEL.F.F42.0036")%>  </th>
            <th><!-- 금액--><%=g.getMessage("LABEL.F.F42.0037")%></th>
            <th><!-- 시간--><%=g.getMessage("LABEL.F.F42.0038")%></th>
          </tr>
          </thead>

<%
                for( int i = j; i < F42DeptMonthWorkCondition_vt.size(); i++ ){
                    F42DeptMonthWorkConditionData data = (F42DeptMonthWorkConditionData)F42DeptMonthWorkCondition_vt.get(i);

                    String tr_class = "";

                    if(i%2 == 0){
                        tr_class="oddRow";
                    }else{
                        tr_class="";
                    }

                    //합계부분에 명수 보여주는 부분.
                    if (data.ENAME.equals("TOTAL")) {
                        for (int h = 0; h < 8; h++) {
                            if( !data.PERNR.substring(h, h+1).equals("0") ){
                                data.PERNR = "( "+ data.PERNR.substring(h, 8) + " )"+g.getMessage("LABEL.F.F42.0058");
                                break;
                            }
                        }
                    }
%>
          <tr class="<%=tr_class%>">
            <td nowrap><%=data.ENAME    %></td>
            <td ><%=data.PERNR    %></td>
            <td ><%=WebUtil.printNumFormat(data.REMA_HUGA,1)%></td>
            <td ><%=WebUtil.printNumFormat(data.REMA_RWHUGA,1)%></td>
            <td ><%=WebUtil.printNumFormat(data.HUGA     ,1)%></td>
            <td ><%=WebUtil.printNumFormat(data.RWHUGA     ,1)%></td>
            <td ><%=WebUtil.printNumFormat(data.KHUGA    ,1)%></td>
            <td ><%=WebUtil.printNumFormat(data.HHUGA    ,1)%></td>
            <td ><%=WebUtil.printNumFormat(data.BHUG     ,1)%></td>
            <td ><%=WebUtil.printNumFormat(data.MHUG     ,1)%></td>
            <td ><%=WebUtil.printNumFormat(data.GONGA    ,1)%></td>
            <td ><%=WebUtil.printNumFormat(data.KYULKN   ,1)%></td>
            <td ><%=WebUtil.printNumFormat(data.JIGAK    ,1)%></td>
            <td ><%=WebUtil.printNumFormat(data.JOTAE    ,1)%></td>
            <td ><%=WebUtil.printNumFormat(data.WECHUL   ,1)%></td>
            <%-- <td ><%=WebUtil.printNumFormat(data.MUNO     ,1)%></td> --%>
            <td ><%=WebUtil.printNumFormat(data.GOYUK    ,1)%></td>
            <td ><%=WebUtil.printNumFormat(data.CHULJANG ,1)%></td>
            <td ><%=WebUtil.printNumFormat(data.HTKGUN   ,1)%></td>

            <td ><%=WebUtil.printNumFormat(data.MTKGUN   ,1)%></td>

            <td ><%=WebUtil.printNumFormat(data.HYUNJANG ,1)%></td>
            <td ><%=WebUtil.printNumFormat(data.YUNJANG  ,1)%></td>
            <td ><%=WebUtil.printNumFormat(data.YAGAN    ,1)%></td>
            <td ><%=WebUtil.printNumFormat(data.DANGJIC  ,1)%></td>
            <td ><%=WebUtil.printNumFormat(data.HYANGUN  ,1)%></td>
            <td ><%=WebUtil.printNumFormat(data.KOYUK    ,1)%></td>
            <td ><%=WebUtil.printNumFormat(data.KONGSU   ,1)%></td>
            <td ><%=WebUtil.printNumFormat(data.KONGSU_HOUR,1)%></td>
            <td class="lastCol">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
          </tr>
<%                  //마자막 합계 데이터 일 경우.
                    if (data.ENAME.equals("TOTAL")) {
                        break;
                    }
                } //end for...
%>
        </table>
      </div>
    </div>

<%
                //부서코드 비교를 위한 값.
                tempDept = deptData.ORGEH;
            }//end if
        }//end for
%>

    <div class="commentImportant">
      <!-- ＊공수 = 실출근일수 + 유급휴일수 + (초과근로 + 기타) * 가중시수 반영<br/>
           ＊초과근로 + 기타 = (연장 + 야간 + 특근 + 근무시간외 교육, 향군)/ 8h-->
      <p><%=g.getMessage("LABEL.F.F42.0039")%></p>
    </div>

    <h2 class="subtitle"><!-- 근태유형 및 단위--><%=g.getMessage("LABEL.F.F42.0040")%></h2></td>

    <div class="listArea">
      <div class="table">
            <table class="listTable">
            <thead>
              <tr>
                <th colspan="2"><!-- 근태유형--><%=g.getMessage("LABEL.F.F42.0041")%> </th>
                <th><!-- 비근무--><%=g.getMessage("LABEL.F.F42.0084")%></th>
                <th><!-- 근무--><%=g.getMessage("LABEL.F.F42.0007")%> </th>
                <th><!-- 초과근무--><%=g.getMessage("LABEL.F.F42.0008")%> </th>
                <th class="lastCol"><!-- 기타--><%=g.getMessage("LABEL.F.F42.0009")%></th>
              </tr>
              </thead>
              <tr class="borderRow">
                <td rowspan="3"><!-- 단위--><%=g.getMessage("LABEL.F.F42.0042")%></td>
                <td><!-- 시간--><%=g.getMessage("LABEL.F.F42.0038")%></td>
                <td><!-- 시간공가, 휴일비근무, 비근무<br>모성보호휴가 --><%=g.getMessage("LABEL.F.F42.0043")%></td>
                <td rowspan="3"><!-- 교육, 출장 --><%=g.getMessage("LABEL.F.F42.0044")%></td>
                <td><!-- 휴일특근, 토요특근, 명절특근, 명절특근(토), <br>
                  휴일연장,연장근로, 야간근로, 야간근로(명절) --><%=g.getMessage("LABEL.F.F42.0045")%> </td>
                <td><!-- 향군(근무시간외),<br />
                  교육(근무시간외) --> <%=g.getMessage("LABEL.F.F42.0046")%></td>
              </tr>
              <tr class="borderRow">
                <td><!-- 일수 --><%=g.getMessage("LABEL.F.F42.0047")%></td>
                <td><!-- 반일휴가(전반/후반), 토요휴가, 전일휴가, 보상휴가,<br>
                  경조휴가, 하계휴가,보건휴가, 출산전후휴가,<br>전일공가, 유급결근, 무급결근, 전일공가 --><%=g.getMessage("LABEL.F.F42.0048")%></td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
              </tr>
              <tr class="borderRow">
                <td><!-- 횟수 --><%=g.getMessage("LABEL.F.F42.0049")%></td>
                <td><!-- 지각, 조퇴, 외출 --><%=g.getMessage("LABEL.F.F42.0050")%></td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
              </tr>
        </table>
      </div>
    </div>

  </div>

</div>
<%
    }else{
%>
<div class="align_center">
    <p><!-- 해당하는 데이터가 존재하지 않습니다. --><%=g.getMessage("MSG.COMMON.0004")%></p>
</div>
<%
    } //end if...
%>
</form>
<jsp:include page="/include/body-footer.jsp" /> <!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/>       <!-- html footer 부분 -->
