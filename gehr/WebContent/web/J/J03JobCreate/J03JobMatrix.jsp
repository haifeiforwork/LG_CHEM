<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/popupPorcess.jsp" %>

<%@ page import="hris.J.J01JobMatrix.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%@ page import="java.util.*" %>
<%
    WebUserData        user             = (WebUserData)session.getAttribute("user");

//  Job Matrix 정보
    Vector             j01LevelList_vt  = (Vector)request.getAttribute("j01LevelList_vt");
    Vector             j01DgubunList_vt = (Vector)request.getAttribute("j01DgubunList_vt");
    Vector             j01JobProfile_vt = (Vector)request.getAttribute("j01JobProfile_vt");
//  Header Stext
    Vector             j01Stext_vt      = (Vector)request.getAttribute("j01Stext_vt");
    J01HeaderStextData dStext           = new J01HeaderStextData();
    if( j01Stext_vt.size() > 0 ) {
        dStext = (J01HeaderStextData)j01Stext_vt.get(0);
    }
//  사원 성명, 직위
    String E_PER_INFO = (String)request.getAttribute("E_PER_INFO");
//  사원번호, Objective ID
    String i_sobid    = (String)request.getAttribute("i_sobid");
    String i_pernr    = (String)request.getAttribute("i_pernr");
    
//  Job Name이 들어가는 box의 크기를 모두 동일하게 맞추기위해서 max값을 구한다.
    int i_count = 0;
    int i_max   = 0;
    for( int i = 0 ; i < j01LevelList_vt.size() ; i++ ) {
        J01LevelListData data_lev = (J01LevelListData)j01LevelList_vt.get(i);
        for( int j = 0 ; j < j01DgubunList_vt.size() ; j++ ) {
            J01JobMatrixData data_D = (J01JobMatrixData)j01DgubunList_vt.get(j);

            i_count = 0;
            for( int k = 0 ; k < j01JobProfile_vt.size() ; k++ ) {
                J01JobMatrixData data = (J01JobMatrixData)j01JobProfile_vt.get(k);

                if( data_lev.OBJID.equals(data.SOBID_LEV) && data_D.OBJID.equals(data.OBJID) ) {
                    i_count += 1;
                }
            }
            if( i_count > i_max ) {  
                i_max = i_count;
            }
        }
    }
    if( i_max < 4 ) {
        i_max = 4;        //default row 4개로 설정
    }

//  matrix width를 구한다.
    double d_width = 0.0;
    if( j01DgubunList_vt.size() > 0 ) {
        d_width = (760 - 47 - 10) / j01DgubunList_vt.size();
    }
%>

<html>
<head>
<title>ESS</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/jms_style.css" type="text/css">

<script language="JavaScript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>
<script language="JavaScript">
<!--
// 달력 사용
function fn_openCal(obj){
    var lastDate;
    lastDate = eval("document.form1." + obj + ".value");
    small_window=window.open("<%=WebUtil.JspURL%>common/calendar.jsp?formname=form1&fieldname="+obj+"&curDate="+lastDate+"&iflag=0","essCalendar","toolbar=0,location=0,directories=0,status=0,menubar=0,resizable=0,width=300,height=300,left=100,top=100");
    small_window.focus();
}

//Job Profile 조회,수정
function goJobProfile(sobid,pernr,link_chk) {
    document.form1.jobid.value      = "first";
    document.form1.SOBID.value      = sobid;                                          // Job ID
    document.form1.PERNR.value      = pernr;
    document.form1.i_link_chk.value = link_chk;
    document.form1.i_Create.value   = "";

    document.form1.action           = "<%= WebUtil.ServletURL %>hris.J.J03JobCreate.J03JobProfileDetailSV";    
    document.form1.method           = "post";
    document.form1.submit();
}

//Job Profile 생성
function JobProfileCre() {
    document.form1.jobid.value      = "first";
    document.form1.SOBID.value      = "";                                             // Job ID
    document.form1.PERNR.value      = "<%= i_pernr %>";
    document.form1.i_link_chk.value = "";
    document.form1.i_Create.value   = "Y";

    document.form1.action           = "<%= WebUtil.ServletURL %>hris.J.J03JobCreate.J03JobProfileBuildSV";    
    document.form1.method           = "post";
    document.form1.submit();
}

//대분류 조회,수정
function goDsort(sobid) {
    document.form1.jobid.value      = "first";
    document.form1.SOBID.value      = sobid;                                          // Objective
    document.form1.PERNR.value      = "<%= i_pernr %>";

    document.form1.action           = "<%= WebUtil.ServletURL %>hris.J.J04DsortCreate.J04DsortDetailSV";    
    document.form1.method           = "post";
    document.form1.submit();
}

//대분류 생성
function DsortCre() {
    document.form1.jobid.value      = "first";
    document.form1.PERNR.value      = "<%= i_pernr %>";

    document.form1.action           = "<%= WebUtil.ServletURL %>hris.J.J04DsortCreate.J04DsortBuildSV";    
    document.form1.method           = "post";
    document.form1.submit();
}

//Job 이동
function JobMove() {
    document.form1.jobid.value      = "first";
    document.form1.PERNR.value      = "<%= i_pernr %>";

    document.form1.action           = "<%= WebUtil.ServletURL %>hris.J.J05JobMove.J05JobMoveSV";    
    document.form1.method           = "post";
    document.form1.submit();
}
//-->
</script>
</head>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" bottommargin="0" marginwidth="0" marginheight="0" background="<%= WebUtil.ImageURL %>left/bg_gray.gif">
<form name="form1" method="post" action="" onsubmit="return false">
  <input type="hidden" name="jobid"      value="">
  <input type="hidden" name="OBJID"      value="<%= i_sobid %>">   <!-- Objective ID -->
  <input type="hidden" name="SOBID"      value="">
  <input type="hidden" name="PERNR"      value="">
  <input type="hidden" name="BEGDA"      value="<%= DataUtil.getCurrentDate() %>">     <!-- 적용일자 -->  
  <input type="hidden" name="i_link_chk" value="">

  <input type="hidden" name="i_pernr"    value="">                 <!-- Matrix Go -->
  <input type="hidden" name="i_objid"    value="">                 <!-- Matrix Go -->  

  <input type="hidden" name="i_Create"   value="">                 <!-- 생성화면으로 이동인지 조회화면으로 이동인지 구분한다. -->  

  <table width="746" cellspacing="0" cellpadding="0" border="0">
    <tr>
      <td align="right" colspan="2">&nbsp;</td>
    </tr>
    <tr>
      <td colspan="2">
<!--타이틀 테이블 시작-->
        <table width="735" border="0" cellspacing="0" cellpadding="0" background="<%= WebUtil.ImageURL %>jms/MatrixTpbg.gif">
          <tr>
            <td><img src="<%= WebUtil.ImageURL %>jms/MatrixTptitle.gif"></td>
            <td align="right"><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width="98" height="20"><br><a href="javascript:open_help('J03JobMatrix_B.html');" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('img07','','/web/images/btn_help_on.gif',1)"><img name="img07" border="0" src="<%= WebUtil.ImageURL %>btn_help_off.gif" width="90" height="15" alt="사용방법안내"></a><a href="javascript:parent.window.close();" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('img08','','<%= WebUtil.ImageURL %>jms/btn_logout_on.gif',1)"><img name="img08" border="0" src="<%= WebUtil.ImageURL %>jms/btn_logout.gif" width="73" height="15" alt="로그아웃"></a><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=6 height=1></td>
            <td width="1" bgcolor="#cccccc"><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width="1" height="46"></td>
          </tr>
          <tr>
            <td bgcolor="#cccccc"><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width="461" height="1"></td>
            <td bgcolor="#cccccc"><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width="298" height="1"></td>
            <td bgcolor="#cccccc"><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width="1" height="1"></td>
          </tr>
        </table>
<!--타이틀 테이블 끝--> 
      </td>
    </tr>
    <tr>
      <td colspan="2">
        <table width="760" cellspacing="0" cellpadding="0" border="0">
          <tr>
            <td align="right">
              <table cellspacing="0" cellpadding="0" border="0">
                <tr height="25">
                  <td width=1 bgcolor=#cccccc></td>
                  <td><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=10 height=5><img src="<%= WebUtil.ImageURL %>jms/bullet_rectangle.gif" align=absmiddle><%= E_PER_INFO.equals("") ? "" : E_PER_INFO + "<img src=" + WebUtil.ImageURL + "jms/spacer.gif width=10 height=5>" %><b>Function</b> : <%= dStext.STEXT_FUNC == null ? "" : dStext.STEXT_FUNC %><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=10 height=5><b>Objective</b> : <%= dStext.STEXT_OBJ == null ? "" : dStext.STEXT_OBJ %><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=5 height=5></td>
                  <td width=1 bgcolor=#cccccc></td>
                </tr>
                <tr height=1>
                  <td colspan=3 bgcolor=#cccccc></td>
                </tr>
              </table>
            </td>
          </tr>
        </table>
      </td>
    </tr>
    <tr>
      <td align="right" colspan="2">&nbsp;</td>
    </tr>
    <tr>
      <td width="15">&nbsp;</td>
      <td bgcolor="#efefef">
        <table cellspacing=0 cellpadding=0 border=0 width=100%>
          <tr>
            <td bgcolor=#999999><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=2 height=2></td>
          </tr>
        </table>
<!--  span 시작  -->
        <span style="height: 505px; width: 746px; overflow:auto;">
          <html>
            <table cellspacing=0 cellpadding=0 border=0 width=100%>
              <tr>
                <td><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=2 height=15></td>
              </tr>
            </table>
            <table cellspacing=0 cellpadding=0 border=0 width=100%>
              <tr>
                <td align=center>
                <!-- matrix가 시작됩니다 -->
                  <table cellspacing=0 cellpadding=0 border=0>
<%
    if( j01LevelList_vt.size() > 0 && j01DgubunList_vt.size() > 0 ) {
//      image를 index를 추가하여 이름을 준다.
        int img_inx = 0;
        for( int i = 0 ; i < j01LevelList_vt.size() ; i++ ) {
            J01LevelListData data_lev = (J01LevelListData)j01LevelList_vt.get(i);
%>
                    <tr valign=top height=89 align=center>
                      <!-- matrix left sub title을 위한 td -->
                      <td width=44 background="<%= WebUtil.ImageURL %>jms/MatrixLeftbg01.gif">
                        <table cellspacing=0 cellpadding=0 border=0 height=100%>
                          <tr height=1%>
                            <td width=41 valign=top><img src="<%= WebUtil.ImageURL %>jms/MatrixLeftbg02.gif" border="0"></td>
                            <td width=3 rowspan=3 bgcolor=#efefef><img src="<%= WebUtil.ImageURL %>space.gif" width=3 height=3></td>
                          </tr>
                          <tr height=98%>
                            <td background="<%= WebUtil.ImageURL %>jms/MatrixDecoBg.gif">
<%
            if( i == 0 ) {
%>
                              <img src="<%= WebUtil.ImageURL %>jms/leader.gif" alt="Leader" border="0">
<%
            } else if( i == 1 ) {
%>
                              <img src="<%= WebUtil.ImageURL %>jms/expander.gif" alt="Expander" border="0">
<%
            } else if( i == 2 ) {
%>
                              <img src="<%= WebUtil.ImageURL %>jms/applier.gif" alt="Applier" border="0">
<%
            } else if( i == 3 ) {
%>
                              <img src="<%= WebUtil.ImageURL %>jms/developer.gif" alt="Developer" border="0">
<%
            }
%>
                            </td>
                          </tr>
                          <tr height=1%>
                            <td valign=bottom><img src="<%= WebUtil.ImageURL %>jms/MatrixLeftbg02.gif" border="0"></td>
                          </tr>
                        </table>
                      </td>
<%
            if( j01DgubunList_vt.size() > 0 ) {
                for( int j = 0 ; j < j01DgubunList_vt.size() ; j++ ) {
                    J01JobMatrixData data_D = (J01JobMatrixData)j01DgubunList_vt.get(j);
%>
                      <!-- matrix small table을 포함한 td open -->
                      <td width=134>
                        <table cellspacing=0 cellpadding=0 border=0 width=134 height=100%>
                          <tr height=1%>
                            <td width=5><img src="<%= WebUtil.ImageURL %>jms/M0<%= i + 1 %>TL.gif"></td>
                            <td width=125 background="<%= WebUtil.ImageURL %>jms/M0<%= i + 1 %>TC.gif"><img src="<%= WebUtil.ImageURL %>jms/space.gif" width=1 height=11></td>
                            <td width=8 align=right><img src="<%= WebUtil.ImageURL %>jms/M0<%= i + 1 %>TR.gif"></td>
                          </tr>
                          <tr height=98%>
                            <td background="<%= WebUtil.ImageURL %>jms/M0<%= i + 1 %>ML.gif"></td>
                            <td background="<%= WebUtil.ImageURL %>jms/M0<%= i + 1 %>MC.gif" valign=top>
                              <!-- 내용물 구분때문에 새로 테이블이 들어갔네요... -->
                              <table cellpadding=0 cellspacing=0 border=0 width=125>
<%
                    i_count = 0;
                    for( int k = 0 ; k < j01JobProfile_vt.size() ; k++ ) {
                        J01JobMatrixData data = (J01JobMatrixData)j01JobProfile_vt.get(k);
      
                        if( data_lev.OBJID.equals(data.SOBID_LEV) && data_D.OBJID.equals(data.OBJID) ) {
                            i_count += 1;
                            img_inx += 1;
                            if( data.LINK_CHK.equals("Y") ) {
%>
                                <tr valign=top>
                                  <td width=13><img src="<%= WebUtil.ImageURL %>jms/bullet_arrow.gif" border=0 name="arrow<%= img_inx %>"></td>
                                  <td width=112><a href="javascript:goJobProfile('<%= data.SOBID %>','<%= i_pernr %>','<%= data.LINK_CHK %>');" class=ms><%= data.STEXT_OBJ %></a></td>
                                </tr>
<%
                            } else {
%>
                                <tr valign=top>
                                  <td width=13><img src="<%= WebUtil.ImageURL %>jms/bullet_arrownull.gif" border=0 name="arrow<%= img_inx %>"></td>
                                  <td width=112><a href="javascript:goJobProfile('<%= data.SOBID %>','<%= i_pernr %>','<%= data.LINK_CHK %>');" class=m1><%= data.STEXT_OBJ %></a></td>
                                </tr>
<%
                            }
                            if( i_count != i_max ) {
%>
                                <tr>
                                  <td colspan=2><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=1 height=5></td>
                                </tr>
<%
                            }
                        }
                    }
                    if( i_count < 4 ) {    //i_max ) {
                        for( int k = i_count ; k < 4 ; k++ ) {    //i_max ; k++ ) {
%>
<%
                            if( i_count != i_max ) {
%>
<%
                            }
                        }
                    }
%>
                              </table>
                            </td>
                            <td background="<%= WebUtil.ImageURL %>jms/M0<%= i + 1 %>MR.gif"></td>
                          </tr>
                          <tr height=1%>
                            <td><img src="<%= WebUtil.ImageURL %>jms/M0<%= i + 1 %>BL.gif"></td>
                            <td background="<%= WebUtil.ImageURL %>jms/M0<%= i + 1 %>BC.gif"><img src="<%= WebUtil.ImageURL %>jms/space.gif" width=1 height=10></td>
                            <td align=right><img src="<%= WebUtil.ImageURL %>jms/M0<%= i + 1 %>BR.gif"></td>
                          </tr>
                        </table>
                      </td>
                      <!-- matrix small table을 포함한 td close -->
<%
                }
            }
%>
                    </tr>
<%
            if( i != (j01LevelList_vt.size() - 1) ) {
%>
<%
            }
        }
    } 
%>
<%    
    if( j01DgubunList_vt.size() > 0 ) {
%>
                    <tr align=center valign=top>
                      <td>&nbsp;</td>
<%
        for( int j = 0 ; j < j01DgubunList_vt.size() ; j++ ) {
            J01JobMatrixData data_D = (J01JobMatrixData)j01DgubunList_vt.get(j);
%>
                      <td align=right>
                        <table cellspacing=0 cellpadding=0 border=0 width=100%>
                    		  <tr height=3>
                    		    <td colspan=3></td>
            		          </tr>
                          <tr height=36>
            		            <td width=1%><img src="<%= WebUtil.ImageURL %>jms/MatrixDecoBgB.gif"></td>
                            <td width=98% align=center class=bot01 background="<%= WebUtil.ImageURL %>jms/MatrixDecoBg.gif">
                              <a href="javascript:goDsort('<%= data_D.OBJID %>');" class=m2><%= data_D.STEXT %></a>
                            </td>
            		            <td width=1% align=right><img src="<%= WebUtil.ImageURL %>jms/MatrixDecoBgB.gif"></td>
                          </tr>
                        </table>
                      </td>
<%
        }
    } else {
%>
                    <tr>
                      <td><img src="<%= WebUtil.ImageURL %>jms/icon_Error.gif" align=absmiddle hspace=2> 해당하는 Job이 존재하지 않습니다.</td>
<%
    } 
%>
                    </tr>
                  </table>
                </td>
              </tr>
            </table>
            <table cellspacing=0 cellpadding=0 border=0 width=100%>
              <tr height=20> 
                <td align="center"><br>
                  <a href="javascript:JobProfileCre();"><img src="<%= WebUtil.ImageURL %>jms/btn_creJob.gif" border=0 alt="Job 생성" hspace=5></a> 
                  <a href="javascript:DsortCre();"><img src="<%= WebUtil.ImageURL %>jms/btn_creCat.gif" border=0 alt="대분류 생성" hspace=5></a> 
                  <a href="javascript:JobMove();"><img src="<%= WebUtil.ImageURL %>jms/btn_moveJob.gif" border=0 alt="Job 이동" hspace=5></a> 
                </td>
              </tr>
            </table>
            <table cellspacing=0 cellpadding=0 border=0 width=100%>
              <tr height="56"> 
                <td width="40">&nbsp;</td>
<%
    if( j01LevelList_vt.size() > 0 && j01DgubunList_vt.size() > 0 ) {
%>
                <td><font color="#0000FF">※ Job을 조회/수정/삭제하시려면 해당 Job을 Click 해 주세요.<br>
                  ※ 대분류를 조회/수정/삭제하시려면 해당 대분류를 Click 해 주세요.</font></td>
<%
    } else {
%>
                <td>&nbsp;<br>&nbsp;</td>
<%
    } 
%>
              </tr>
            </table>
          </html>
        </span>
      </td>
    </tr>
  </table>
<!--  span 끝  -->
</form>
<%@ include file="/web/common/commonEnd.jsp" %>
