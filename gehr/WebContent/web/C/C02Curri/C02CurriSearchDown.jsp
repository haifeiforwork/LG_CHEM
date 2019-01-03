<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 교육과정 안내/신청                                          */
/*   Program Name : 교육과정 안내/신청                                          */
/*   Program ID   : C02CurriSearchDown.jsp                                      */
/*   Description  : 교육과정 정보를 가져오는 화면                               */
/*   Note         :                                                             */
/*   Creation     : 2002-01-14  박영락                                          */
/*   Update       : 2005-02-21  윤정현                                          */
/*                                                                              */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.C.C02Curri.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%
    WebUserData user = WebUtil.getSessionUser(request);

    String jobid   = (String)request.getAttribute("jobid");
    String paging  = (String)request.getAttribute("page");
    String tmpYear = (DataUtil.getCurrentDate()).substring(0,4);

    C02CurriInfoData key                 = (C02CurriInfoData)request.getAttribute("C02CurriInfoData");
    Vector           C02CurriInfoData_vt = (Vector)request.getAttribute("C02CurriInfoData_vt");

    int    year       = Integer.parseInt((key.I_FDATE).substring(0,4));
    String startMonth = (key.I_FDATE).substring(4,6);
    String endMonth   = (key.I_TDATE).substring(4,6);

    //PageUtil 관련 - Page 사용시 반드시 써줄것.
    PageUtil pu = null;
    if ( C02CurriInfoData_vt != null && C02CurriInfoData_vt.size() != 0 ) {
      try {
          pu = new PageUtil(C02CurriInfoData_vt.size(), paging , 20, 10);
          Logger.debug.println(this, "page : "+paging);
      } catch (Exception ex) {
          Logger.debug.println(DataUtil.getStackTrace(ex));
      }
    }

    int startYear    = 1999;  //시작년도
    int endYear      = Integer.parseInt( DataUtil.getCurrentYear() );

    Vector CodeEntity_vt = new Vector();
    for( int i = startYear ; i <= endYear ; i++ ){
        CodeEntity entity = new CodeEntity();
        entity.code  = Integer.toString(i);
        entity.value = Integer.toString(i);
        CodeEntity_vt.addElement(entity);
    }
    String PERNR = (String)request.getAttribute("PERNR");
    String RequestPageName = (String)request.getAttribute("RequestPageName");
%>

<html>
<head>
<title>ESS</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr.css" type="text/css">
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr_wsg.css" type="text/css">

<script language="javascript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>
<script language="javascript">
<!--
function doSubmit(){
    document.form1.jobid.value = "search";
    document.form1.action = '<%= WebUtil.ServletURL %>hris.C.C02Curri.C02CurriInfoListSV';
    document.form1.submit();
}

function pageChange(page){
    document.form1.page.value = page;
    doSubmit();
}

function goDetail(index){
    var command = index;
    eval("document.form2.GWAJUNG.value = document.form1.GWAJUNG"+command+".value");
    eval("document.form2.GWAID.value   = document.form1.GWAID"+command+".value");
    eval("document.form2.CHASU.value   = document.form1.CHASU"+command+".value");
    eval("document.form2.CHAID.value   = document.form1.CHAID"+command+".value");
    eval("document.form2.SHORT.value   = document.form1.SHORT"+command+".value");
    eval("document.form2.BEGDA.value   = document.form1.BEGDA"+command+".value");
    eval("document.form2.ENDDA.value   = document.form1.ENDDA"+command+".value");
    eval("document.form2.EXTRN.value   = document.form1.EXTRN"+command+".value");
    eval("document.form2.KAPZ2.value   = document.form1.KAPZ2"+command+".value");
    eval("document.form2.RESRV.value   = document.form1.RESRV"+command+".value");
    eval("document.form2.LOCATE.value  = document.form1.LOCATE"+command+".value");
    eval("document.form2.BUSEO.value   = document.form1.BUSEO"+command+".value");
    eval("document.form2.SDATE.value   = document.form1.SDATE"+command+".value");
    eval("document.form2.EDATE.value   = document.form1.EDATE"+command+".value");
    eval("document.form2.DELET.value   = document.form1.DELET"+command+".value");
    eval("document.form2.PELSU.value   = document.form1.PELSU"+command+".value");
    eval("document.form2.GIGWAN.value  = document.form1.GIGWAN"+command+".value");
    eval("document.form2.IKOST.value   = document.form1.IKOST"+command+".value");
    eval("document.form2.STATE.value   = document.form1.STATE"+command+".value");
    document.form2.jobid.value = "detail";
    document.form2.action = "<%= WebUtil.ServletURL %>hris.C.C02Curri.C02CurriInfoSV";
    document.form2.target = "menuContentIframe";
    document.form2.method = "post";
    document.form2.submit();
}
//-->
</script>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onSubmit="return;">
<form name="form1" method="post" action="" onsubmit="return false">
<input type="hidden" name="PERNR"  value="<%= PERNR %>">

<div class="subWrapper">

    <div class="listArea">
        <div class="listTop">
            <span class="listCnt"><%= pu == null ?  "" : pu.pageInfo() %></span>
        </div>
        <div class="table">
            <table class="listTable">
                <tr>
                    <th>No</th>
                    <th>과정명</th>
                    <th>차수</th>
                    <th>교육기간</th>
                    <th>신청기간</th>
                    <th>상태</th>
                    <th>정원/예약</th>
                    <th>장소</th>
                    <th class="lastCol">주관부서</th>
                </tr>
<%
    if( C02CurriInfoData_vt.size() > 0 ) {
        int j = 0;// 내부 카운터용
        for( int i = pu.formRow() ; i < pu.toRow(); i++ ) {
            C02CurriInfoData data = (C02CurriInfoData)C02CurriInfoData_vt.get(i);

            String tr_class = "";

            if(i%2 == 0){
                tr_class="oddRow";
            }else{
                tr_class="";
            }
%>
                <tr class="<%=tr_class%>">
                    <td><%= i+1 %></td>
                    <td><a href="javascript:goDetail(<%= j %>);" ><%= data.GWAJUNG %></a></td>
                    <td><%= data.SHORT %></td>
                    <td><%= WebUtil.printDate(data.BEGDA,".").equals("0000.00.00") ? "" : WebUtil.printDate(data.BEGDA,".") + " ~" %><br><%= WebUtil.printDate(data.ENDDA,".").equals("0000.00.00") ? "" : "　　" + WebUtil.printDate(data.ENDDA,".") %></td>
                    <td><%= WebUtil.printDate(data.SDATE,".").equals("0000.00.00") ? "" : WebUtil.printDate(data.SDATE,".") + " ~" %><br><%= WebUtil.printDate(data.EDATE,".").equals("0000.00.00") ? "" : "　　" + WebUtil.printDate(data.EDATE,".") %></td>
                    <td>
                      <%= data.DELET.equals("X") ? "취소" : data.PELSU.equals("C") ? "진급필수" : data.PELSU.equals("N") ? "PC진급필수" : data.STATE.equals("접수중") ? "<font color=blue>접수중</font>" : data.STATE %>
                    </td>
                    <td><%= data.KAPZ2 + "/" + data.RESRV %></td>
                    <td><%= data.LOCATE %></td>
                    <td class="lastCol"><%= data.BUSEO %></td>
                    <input type="hidden" name="GWAJUNG<%= j %>" value="<%= data.GWAJUNG %>">
                    <input type="hidden" name="GWAID<%= j %>"   value="<%= data.GWAID %>"  >
                    <input type="hidden" name="CHASU<%= j %>"   value="<%= data.CHASU %>"  >
                    <input type="hidden" name="CHAID<%= j %>"   value="<%= data.CHAID %>"  >
                    <input type="hidden" name="SHORT<%= j %>"   value="<%= data.SHORT %>"  >
                    <input type="hidden" name="BEGDA<%= j %>"   value="<%= data.BEGDA %>"  >
                    <input type="hidden" name="ENDDA<%= j %>"   value="<%= data.ENDDA %>"  >
                    <input type="hidden" name="EXTRN<%= j %>"   value="<%= data.EXTRN %>"  >
                    <input type="hidden" name="KAPZ2<%= j %>"   value="<%= data.KAPZ2 %>"  >
                    <input type="hidden" name="RESRV<%= j %>"   value="<%= data.RESRV %>"  >
                    <input type="hidden" name="LOCATE<%= j %>"  value="<%= data.LOCATE %>" >
                    <input type="hidden" name="BUSEO<%= j %>"   value="<%= data.BUSEO %>"  >
                    <input type="hidden" name="SDATE<%= j %>"   value="<%= data.SDATE %>"  >
                    <input type="hidden" name="EDATE<%= j %>"   value="<%= data.EDATE %>"  >
                    <input type="hidden" name="DELET<%= j %>"   value="<%= data.DELET %>"  >
                    <input type="hidden" name="PELSU<%= j %>"   value="<%= data.PELSU %>"  >
                    <input type="hidden" name="GIGWAN<%= j %>"  value="<%= data.GIGWAN %>" >
                    <input type="hidden" name="IKOST<%= j %>"   value="<%= data.IKOST %>"  >
                    <input type="hidden" name="STATE<%= j %>"   value="<%= data.STATE %>"  >
                </tr>
<%
        j++;
        }
%>
            </table>
        </div>
    </div>
    <!-- 조회리스트 테이블 시작-->

</div>
                  <!---- 페이지 유틸 --->
                  <%= pu == null ? "" : pu.pageControl() %>
                  </td>
                </tr>
<%
    } else {
        if( jobid.equals("search") ){
%>
                <tr align="center">
                  <td class="td04" colspan="9">해당하는 데이터가 존재하지 않습니다.</td>
                </tr>
<%
        }
    }
%>
              </table>
            </td>
          </tr>
        </table>
      </td>
    </tr>
  </table>

<!--  HIDDEN  처리해야할 부분 시작-->
  <input type="hidden" name="jobid"         value="">
  <input type="hidden" name="page"          value="<%= paging %>">
  <input type="hidden" name="I_FDATE"       value="<%= key.I_FDATE %>">
  <input type="hidden" name="I_TDATE"       value="<%= key.I_TDATE %>">
  <input type="hidden" name="I_BUSEO"       value="<%= key.I_BUSEO %>">
  <input type="hidden" name="I_GROUP"       value="<%= key.I_GROUP %>">
  <input type="hidden" name="I_LOCATE"      value="<%= key.I_LOCATE %>">
  <input type="hidden" name="I_DESCRIPTION" value="<%= key.I_DESCRIPTION %>">
  <input type="hidden" name="RequestPageName"   value="<%=RequestPageName%>">
<!--  HIDDEN  처리해야할 부분 시작-->
</form>

<form name="form2" method="post">
  <input type="hidden" name="PERNR"   value="<%= PERNR %>">
  <input type="hidden" name="jobid"   value="">
  <input type="hidden" name="GWAJUNG" value="">
  <input type="hidden" name="GWAID"   value="">
  <input type="hidden" name="CHASU"   value="">
  <input type="hidden" name="CHAID"   value="">
  <input type="hidden" name="SHORT"   value="">
  <input type="hidden" name="BEGDA"   value="">
  <input type="hidden" name="ENDDA"   value="">
  <input type="hidden" name="EXTRN"   value="">
  <input type="hidden" name="KAPZ2"   value="">
  <input type="hidden" name="RESRV"   value="">
  <input type="hidden" name="LOCATE"  value="">
  <input type="hidden" name="BUSEO"   value="">
  <input type="hidden" name="SDATE"   value="">
  <input type="hidden" name="EDATE"   value="">
  <input type="hidden" name="DELET"   value="">
  <input type="hidden" name="PELSU"   value="">
  <input type="hidden" name="GIGWAN"  value="">
  <input type="hidden" name="IKOST"   value="">
  <input type="hidden" name="STATE"   value="">
  <!---------------------------------------------------------------------->
  <input type="hidden" name="I_FDATE" value="<%= key.I_FDATE %>">
  <input type="hidden" name="I_TDATE" value="<%= key.I_TDATE %>">
  <input type="hidden" name="I_BUSEO" value="<%= key.I_BUSEO %>">
  <input type="hidden" name="I_GROUP" value="<%= key.I_GROUP %>">
  <input type="hidden" name="I_LOCATE" value="<%= key.I_LOCATE %>">
  <input type="hidden" name="I_DESCRIPTION" value="<%= key.I_DESCRIPTION %>">
  <input type="hidden" name="RequestPageName"   value="<%=RequestPageName%>">
</form>
<%@ include file="/web/common/commonEnd.jsp" %>
