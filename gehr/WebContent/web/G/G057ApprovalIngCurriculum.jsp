<%/******************************************************************************/
/*                                                                              */
/*   System Name  : e-HR                                                        */
/*   1Depth Name  : HR 결재                                                     */
/*   2Depth Name  : 결재 진행 중 문서                                           */
/*   Program Name : 교육 결재 진행중/취소                                       */
/*   Program ID   : G057ApprovalIngCurriculum.jsp                               */
/*   Description  : 교육 결재 진행중/취소                                       */
/*   Note         : 없음                                                        */
/*   Creation     : 2003-03-28 이승희                                           */
/*   Update       : 2003-03-28 이승희                                           */
/*                  2008-08-11 @v1.2 CSR ID:1316249 과정상세정보 링크수정       */
/*                                                                              */
/*                                                                              */
/********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ page errorPage="/web/err/error.jsp"%>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.C.C02Curri.C02CurriApplData" %>
<%@ page import="hris.C.C02Curri.C02CurriInfoData" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="hris.common.util.*" %>
<%@ page import="hris.common.*" %>
<%@ page import="com.sns.jdf.util.*" %> 

<%
    WebUserData      user    = (WebUserData)session.getAttribute("user");
    C02CurriApplData c02CurriApplData = (C02CurriApplData)request.getAttribute("c02CurriApplData");
    
    C02CurriInfoData c02CurriInfoData = (C02CurriInfoData)request.getAttribute("c02CurriInfoData");
    String isDuplication = (String) request.getAttribute("isDuplication");
    
    Vector      vcAppLineData   = (Vector)request.getAttribute("vcAppLineData");
    String      RequestPageName = (String)request.getAttribute("RequestPageName");
   
    boolean isCanGoList ; 
    if (RequestPageName == null || RequestPageName.equals("")) {
        isCanGoList = false;
    } else {
        isCanGoList = true;
    } // end if
   
    // 현재 결재자 구분
    DocumentInfo docinfo = new DocumentInfo(c02CurriApplData.AINF_SEQN ,user.empNo);
    int approvalStep = docinfo.getApprovalStep();
 
   
%>
<html>
<head>
<title>ESS</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr.css" type="text/css">

<script language="javascript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>
<script language="javascript" src="<%= WebUtil.ImageURL %>js/object.js"></script>

<script language="JavaScript">
<!--

  
    //달력 사용 시작
    function fn_openCal(Objectname)
    {
       var lastDate;
       lastDate = eval("document.form1." + Objectname + ".value");
       small_window=window.open("/web/common/calendar.jsp?formname=form1&fieldname="+Objectname+"&curDate="+lastDate+"&iflag=0","essCal","toolbar=0,location=0,directories=0,status=0,menubar=0,resizable=0,width=300,height=300");
    }
   
    function detail_BAK(GWAID ,CHAID)
    {
        var frm = document.form1;
        frm.jobid.value = "detail";
        frm.action = "<%= WebUtil.ServletURL %>hris.C.C06Take.C06TakeListSV";
        frm.submit();
	}
    //@v1.2 링크정보수정
    function detail(GWAID,CHAID,RECN)
    {
        if (RECN == "00000000" || RECN == "") {
           f_detail_view_hrd(CHAID);
        }else {
           f_detail_view_in(CHAID,RECN );
        }
    }
    function f_detail_view_in(hrdobjid, objid ) {
    	var vObj = document.formLink;
    	vObj.CRS_MGM_SCH_N.value = objid;
    	vObj.HRD_OBJID.value = hrdobjid;
    	vObj.HRD_APPYN.value = "N";
        
        vObj.action="<%=WebUtil.JspURL%>G/G057Encrypt.jsp";
        vObj.target="ifHidden";
        vObj.submit();
    }

    // @v1.2 HRD course detail
    function f_detail_view_hrd(objid) {
    	var vObj = document.formLink;
    	vObj.PA_OBJID_1.value=objid; //차수
    	//vObj.PA_OBJID_1.value="50018251"; //차수
    	
    	vObj.PA_PERNR_1.value="<%= DataUtil.encodeEmpNo(c02CurriApplData.PERNR) %>";
    	vObj.goPageP.value="1";
    
        small_window=window.open("","Curriculum","toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=no,scrollbars=auto,width=800,height=500,left=450,top=0");
        small_window.focus();
    
        vObj.target = "Curriculum";        
        vObj.action = "http://hrd.lgchem.com/jsp/popuplogin.jsp";
        //vObj.action = "https://165.243.11.214:9443/jsp/popuplogin.jsp";
        vObj.submit();
    }
    function cancel()
    {
        if(!confirm("취소 하시겠습니까.")) {
            return;
        } // end if
        var frm = document.form1;
        frm.APPR_STAT.value = "";
        frm.submit();
    }
    
    function goToList() 
    {
        var frm = document.form1;
    <% if (isCanGoList) { %>
        frm.action = "<%=RequestPageName.replace('|' ,'&')%>";
    <% } // end if %>
        frm.jobid.value ="";
        frm.submit();
    }


//-->
</script>
</head>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('<%= WebUtil.ImageURL %>btn_help_on.gif');">
<form name="formLink" method="post" action="">
<input type="hidden" name="PA_OBJID_1"  value=""><!--차수 ID-->
<input type="hidden" name="PA_PERNR_1"  value=""><!--암호화 된 사번-->
<input type="hidden" name="goPageP"     value=""><!--페이지 구분-->

<input type="hidden" name="CRS_MGM_SCH_N" value=""><!--인화원 -->
<input type="hidden" name="HRD_OBJID"     value="">
<input type="hidden" name="HRD_APPYN"     value=""><!--인화원 신청버튼유무 --> 
<input type="hidden" name="pageGubun"     value=""><!--인화원 신청버튼유무 --> 
<input type="hidden" name="SEC_RES_RG_N"  value=""><!--인화원 신청버튼유무 --> 

<input type="hidden" name="PERNR"  value="<%=c02CurriApplData.PERNR%>"><!--인화원 신청버튼유무 --> 
</form>
<form name="form1" method="post" action="">
<input type="hidden" name="jobid" value="save">
<input type="hidden" name="APPU_TYPE" value="<%=docinfo.getAPPU_TYPE()%>">
<input type="hidden" name="APPR_SEQN" value="<%=docinfo.getAPPR_SEQN()%>">
<input type="hidden" name="BUKRS" value="<%=user.companyCode%>">

<input type="hidden" name="PERNR"        value="<%=c02CurriApplData.PERNR%>">
<input type="hidden" name="BEGDA1"        value="<%=c02CurriApplData.BEGDA%>">
<input type="hidden" name="AINF_SEQN"    value="<%=c02CurriApplData.AINF_SEQN%>">

    <input type="hidden" name="GWAJUNG" value="<%=c02CurriInfoData.GWAJUNG%>">
    <input type="hidden" name="GWAID"   value="<%=c02CurriInfoData.GWAID%>">
    <input type="hidden" name="CHASU"   value="<%=c02CurriInfoData.CHASU%>">
    <input type="hidden" name="CHAID"   value="<%=c02CurriInfoData.CHAID%>">
    <input type="hidden" name="SHORT"   value="<%=c02CurriInfoData.SHORT%>">
    <input type="hidden" name="BEGDA"   value="<%=c02CurriInfoData.BEGDA%>">
    <input type="hidden" name="ENDDA"   value="<%=c02CurriInfoData.ENDDA%>">
    <input type="hidden" name="EXTRN"   value="<%=c02CurriInfoData.EXTRN%>">
    <input type="hidden" name="KAPZ2"   value="<%=c02CurriInfoData.KAPZ2%>">
    <input type="hidden" name="RESRV"   value="<%=c02CurriInfoData.RESRV%>">
    <input type="hidden" name="LOCATE"  value="<%=c02CurriInfoData.LOCATE%>">
    <input type="hidden" name="BUSEO"   value="<%=c02CurriInfoData.BUSEO%>">
    <input type="hidden" name="SDATE"   value="<%=c02CurriInfoData.SDATE%>">
    <input type="hidden" name="EDATE"   value="<%=c02CurriInfoData.EDATE%>">
    <input type="hidden" name="DELET"   value="<%=c02CurriInfoData.DELET%>">
    <input type="hidden" name="PELSU"   value="<%=c02CurriInfoData.PELSU%>">
    <input type="hidden" name="GIGWAN"  value="<%=c02CurriInfoData.GIGWAN%>">
    <input type="hidden" name="IKOST"   value="<%=c02CurriInfoData.IKOST%>">

<input type="hidden" name="BIGO_TEXT" value="">                        
<input type="hidden" name="APPR_STAT">
<input type="hidden" name="RequestPageName"   value="<%=RequestPageName%>">
<input type="hidden" name="approvalStep" value="<%=approvalStep%>">
  <table width="796" border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td width="16">&nbsp;</td>
      <td><table width="780" border="0" cellspacing="0" cellpadding="0">
          <tr> 
            <td><table width="780" border="0" cellpadding="0" cellspacing="0">
                <tr> 
                  <td height="5" colspan="2"></td>
                </tr>
                <tr> 
                  <td width="624" class="title02">
                    <img src="<%= WebUtil.ImageURL %>ehr/title01.gif"> 교육 신청 결재해야 할 문서 
                  </td>
                  <td align="right" style="padding-bottom:4px">&nbsp;</td>
                </tr>
              </table></td>
          </tr>
          <tr> 
            <td height="10">&nbsp;</td>
          </tr>
          <tr> 
            <td height="10">
             <!-- 신청자 기본 정보 시작 -->
             <%@ include file="/web/common/ApprovalIncludePersInfo.jsp" %>
             <!--  신청자 기본 정보 끝-->
            </td>
          </tr>
          <tr> 
            <td height="10">&nbsp;</td>
          </tr>
          <tr> 
            <td> 
              <table width="780" border="0" cellpadding="0" cellspacing="0">
                <tr> 
                  <td class="font01" style="padding-bottom:2px"> <img src="<%= WebUtil.ImageURL %>ehr/icon_o.gif"> 
                    신청정보</td>
                  <!--과정정보 버튼시작-->
                  <td class="td02">
                    <a href="javascript:detail('<%=c02CurriApplData.GWAID%>' ,'<%=c02CurriApplData.CHAID%>','<%=c02CurriInfoData.LERN_CODE%>'  )">
                        <img src="<%= WebUtil.ImageURL %>btn_course.gif" border="0">
                    </a> 
                  </td>
                  <!--과정정보 버튼 끝-->
              </table>
            </td>
          </tr>
          <tr> 
            <td> 
              <!--신청정보 테이블 시작-->
              <table width="780" border="0" cellspacing="1" cellpadding="5" class="table02">
                <tr> 
                  <td class="tr01"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                      <tr> 
                        <td><table width="100%" border="0" cellpadding="0" cellspacing="1">
                            <tr> 
                              <td width="100" class="td01">과정명</td>
                              <td colspan="3" class="td09"> <%= c02CurriApplData.GWAJUNG %></td>
                            </tr>
                            <tr> 
                              <td class="td01" width="104">교육기간<font color="#006699"><b></b></font></td>
                              <td colspan="3" class="td09">
								<%= WebUtil.printDate(c02CurriApplData.GBEGDA,".").equals("0000.00.00") ? "" : WebUtil.printDate(c02CurriApplData.GBEGDA) + " ~ " %><%= WebUtil.printDate(c02CurriApplData.GENDDA,".").equals("0000.00.00") ? "" : WebUtil.printDate(c02CurriApplData.GENDDA) %>
                              </td>
                            </tr>
                            <tr> 
                              <td class="td01">신청차수</td>
                              <td width="200" class="td09"><%= c02CurriApplData.CHASU %></td>
                              <td width="100" class="td01">차수ID</td>
                              <td class="td09"><%= c02CurriApplData.CHAID %></td>
                            </tr>
                            <tr> 
                              <td class="td01">신청사유</td>
                              <td colspan="3" class="td09"><%= c02CurriApplData.TEXT %></td>
                            </tr>
                          </table></td>
                      </tr>
                    </table></td>
                </tr>
              </table>
              <!--신청정보 테이블 끝-->
            </td>
          </tr>
          <tr>
            <td>&nbsp;</td>
          </tr>
        <% 
            boolean visible = false;
            for (int i = 0; i < vcAppLineData.size(); i++) {
                AppLineData ald = (AppLineData) vcAppLineData.get(i);
                if (ald.APPL_BIGO_TEXT != null && !ald.APPL_BIGO_TEXT.equals("")) { 
                    visible = true;
                    break;
                } // end if 
            } // end for 
        %>
        <%   if (visible) { %>
          <tr> 
            <td class="font01" style="padding-bottom:2px"><img src="<%= WebUtil.ImageURL %>ehr/icon_o.gif"> 적요</td>
          </tr>  
          <tr>
            <td>
                <table width="780" border="0" cellpadding="0" cellspacing="1" class="table03">
                <% for (int i = 0; i < vcAppLineData.size(); i++) { %>
                    <% AppLineData ald = (AppLineData) vcAppLineData.get(i); %>
                    <% if (ald.APPL_BIGO_TEXT != null && !ald.APPL_BIGO_TEXT.equals("")) { %>
                    <tr> 
                       <td width="80" class="td03"><%=ald.APPL_ENAME%></td>
                       <td class="td09"><%=ald.APPL_BIGO_TEXT%></td>
                    </tr>
                    <% } // end if %>
                <% } // end for %>
                </table>
            </td>
          </tr>
        <% } // end if %>
          <tr> 
            <td> 
              <table width="780" border="0" cellspacing="0" cellpadding="0">
                <tr> 
                  <td>&nbsp;</td>
                </tr>
                <tr> 
                  <td class="font01" style="padding-bottom:2px"><img src="<%= WebUtil.ImageURL %>ehr/icon_o.gif"> 결재정보</td>
                </tr>
                <tr> 
                  <td>
                    <table width="780" border="0" cellspacing="0" cellpadding="0">
                      <tr> 
                        <td> 
                          <!--결재정보 테이블 시작-->
                          <%= AppUtil.getAppDetail(vcAppLineData) %>
                          <!--결재정보 테이블 끝-->
                        </td>
                      </tr>
                    </table></td>
                </tr>
                <tr> 
                  <td>&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center">
                  <!--버튼 들어가는 테이블 시작 -->
                      <table width="780" border="0" cellpadding="0" cellspacing="0">
                        <tr> 
                          <td class="td04">
                          <% if (isCanGoList) {  %>
                            <a href="javascript:goToList()"><img src="<%= WebUtil.ImageURL %>btn_list.gif" border="0"></a>&nbsp;&nbsp;&nbsp;
                          <% } // end if %>
                          <% if (docinfo.isHasCancel()) {  %>
                            <a href="javascript:cancel()"><img src="<%= WebUtil.ImageURL %>btn_cancel01.gif" border="0" /></a>&nbsp;&nbsp;&nbsp;
                          <% } // end if %>
                          </td>
                        </tr>
                      </table>
                  <!--버튼 들어가는 테이블 끝 -->
                  </td>
                </tr>
                <tr> 
                  <td>&nbsp;</td>
                </tr>
              </table>
            </td>
          </tr>
        </table>
      </td>
    </tr>
  </table>
</form>

<iframe name="ifHidden" width="0" height="0" />
<%@ include file="/web/common/commonEnd.jsp" %>
