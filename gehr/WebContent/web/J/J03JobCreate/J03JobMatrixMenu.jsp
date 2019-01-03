<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.J.J01JobMatrix.*" %>
<%@ page import="hris.J.J01JobMatrix.rfc.*" %>
<%@ page import="hris.J.J03JobCreate.*" %>
<%@ page import="hris.J.J03JobCreate.rfc.*" %>
 <%@ page import="com.sns.jdf.util.*" %> 
 <%@ page import="java.util.*" %>
<%
//  Job Holder의 성명을 click시 사원인사정보를 띄워준다. - Job Profile
    WebUserData user                 = (WebUserData)session.getAttribute("user");

//  Objective ID, Job ID
    String i_objid                   = (String)request.getAttribute("i_objid");
    String i_sobid                   = (String)request.getAttribute("i_sobid");

//  사원번호(팀원), image index
    String i_pernr                   = (String)request.getAttribute("i_pernr"); 
    String i_begda                   = (String)request.getAttribute("i_begda");   
    String i_link_chk                = (String)request.getAttribute("i_link_chk");
    String i_imgidx                  = (String)request.getAttribute("i_imgidx");

//  Job Profile, Competency Requirements, Job Leveling Sheet가 입력되기 전에는 다른 메뉴로 이동가능하지 않도록한다.
//  "Y"이면 입력할 사항이 있으므로 다른 메뉴로의 이동이 불가능하다.
    String i_Create                  = (String)request.getAttribute("i_Create");

//  Header Stext - Function Name, Objective Name, Job Name
    J01HeaderStextData dStext        = new J01HeaderStextData();
    J01HeaderStextRFC  rfc_Stext     = new J01HeaderStextRFC();
    Vector             j01Stext_vt   = rfc_Stext.getDetail( i_objid, i_sobid, i_pernr, i_begda );
    if( j01Stext_vt.size() > 0 ) {
        dStext = (J01HeaderStextData)j01Stext_vt.get(0);
    }

//  팀원의 해당 Job List 조회
    J01GetObjectiveRFC rfc           = new J01GetObjectiveRFC();
    Vector             j01JobList_vt = new Vector();    

    if( i_link_chk.equals("Y") ) {
        j01JobList_vt = rfc.getDetail( i_pernr, "99991231");                //i_begda );
    }

//  default메뉴를 설정한다.
    if( i_imgidx.equals("") ) {
        i_imgidx = "1";
    }

//  현재 페이지 이름을 읽어서 Build.jsp와 다른 메뉴를 구분하여 HelpFile명을 결정한다.
    String pageURI   = request.getRequestURI();
    String ImgMenu   = "";                 //Menu Image 이름
    String ImgTitle  = "";                 //Title Image 이름
    String mPageName = "";                 //Help File 이름

    if ( i_imgidx.equals("1") ) {
        ImgMenu  = "mnavJobProfile_on";
        ImgTitle = "ProfileTptitle";

        if( pageURI.indexOf("Build.jsp") > 0 ) {
            mPageName = "J03JobProfile_B.html";
        } else if( pageURI.indexOf("Change.jsp") > 0 ) {
            mPageName = "J03JobProfile_C.html";
        } else {
            mPageName = "J03JobProfile_R.html";
        }
    } else if ( i_imgidx.equals("2") ) {
        ImgMenu  = "mnavCRequirements_on";
        ImgTitle = "CompetencyTptitle";

        if( pageURI.indexOf("Build.jsp") > 0 ) {
            mPageName = "J03CompetencyReq_B.html";
        } else {
            mPageName = "J03CompetencyReq_C.html";
        }
    } else if ( i_imgidx.equals("3") ) {
        ImgMenu  = "mnavJobUnitKSEA_on";
        ImgTitle = "JobUnitTptitle";

        if( pageURI.indexOf("Build.jsp") > 0 ) {
            mPageName = "J03JobUnitKSEA_B.html";
        } else {
            mPageName = "J03JobUnitKSEA_C.html";
        }
    } else if ( i_imgidx.equals("4") ) {
        ImgMenu  = "mnavJobProcess_on";
        ImgTitle = "ProcessTptitle";

        if( pageURI.indexOf("Build.jsp") > 0 ) {
            mPageName = "J03JobProcess_B.html";
        } else {
            mPageName = "J03JobProcess_C.html";
        }
    } else if ( i_imgidx.equals("5") ) {
        ImgMenu  = "mnavJobLevelingSheet_on";
        ImgTitle = "LevelingTptitle";

        if( pageURI.indexOf("Build.jsp") > 0 ) {
            mPageName = "J03LevelingSheet_B.html";
        } else {
            mPageName = "J03LevelingSheet_C.html";
        }
    }

//  error message Vector 받기
    int count_E = 0;
    Vector j03Message_vt = (Vector)request.getAttribute("j03Message_vt");
    if( j03Message_vt != null ) { count_E = j03Message_vt.size(); }

//  Job 최초 시작일
    J03JobBegdaRFC  rfc_Begda = new J03JobBegdaRFC();
    String          E_BEGDA   = rfc_Begda.getBegda( "T", i_sobid );

//  Leveling 수정으로 이동시 전 페이지를 check하기위해서 필요
    String backFromJSP = (String)request.getAttribute("backFromJSP");
%>

<script language="JavaScript">
<!--
function onLoad() {
  MM_swapImage('img0<%= Integer.parseInt(i_imgidx) + 1 %>','','<%= WebUtil.ImageURL %>jms/<%= ImgMenu %>.gif',1);

//생성 오류시 메시지 처리
  if( "<%= (String)request.getAttribute("i_error") %>" == "Y" ) {
//  Error발생했을경우 입력상태를 유지해준다.
    document.form0.inputCheck.value = "Y";

    error_window=window.open("","errorWindow","toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=no,scrollbars=yes,width=480,height=380,left=100,top=100");
    error_window.focus();

    document.form0.action = "<%= WebUtil.JspURL %>J/J03JobCreate/J03ErrorWindow.jsp";
    document.form0.target = "errorWindow";
    document.form0.submit();
  }
}
    
//Job 삭제
function goDelete(sobid) {
    job_window=window.open("","deleteWindow","toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=no,scrollbars=no,width=500,height=280,left=100,top=100");
    job_window.focus();

    document.form0.SOBID.value  = sobid;
    document.form0.BEGDA.value  = "<%= DataUtil.getCurrentDate() %>";

    document.form0.action = "<%= WebUtil.JspURL %>J/J03JobCreate/J03JobProfileDelete.jsp";
    document.form0.target = "deleteWindow";
    document.form0.submit();
}

// 달력 사용
function fn_openCal(obj){
    var lastDate;
    lastDate = eval("document.form1." + obj + ".value");
    small_window=window.open("<%=WebUtil.JspURL%>common/calendar.jsp?formname=form1&fieldname="+obj+"&curDate="+lastDate+"&iflag=0","essCalendar","toolbar=0,location=0,directories=0,status=0,menubar=0,resizable=0,width=300,height=300,left=100,top=100");
    small_window.focus();
}

//Layer show, hide 시키기
function show_hide_layer(lname, act) {
    if (lname == '') return;
    
    if(document.all) {
      document.all(lname).style.visibility = act;
    }
  
    return;
}

//Job Matrix
function goMatrix(pernr, objid) {
///////////////////////////////////////////////////////////////////////////////
    if( document.form0.inputCheck.value == "Y" ) {
        if( confirm( "변경된 내용이 존재합니다.\n저장하시겠습니까?") ){
            saveObject();
            return;
        }
    }
///////////////////////////////////////////////////////////////////////////////

    document.form0.i_pernr.value = pernr;         //사원번호
    document.form0.i_sobid.value = objid;         //Objectives ID

    document.form0.action        = "<%= WebUtil.ServletURL %>hris.J.J03JobCreate.J03JobMatrixSV";
    document.form0.method        = "post";
    document.form0.target        = "J_right";
    document.form0.submit();
}

//goMenu - index에 따라서 해당하는 Menu로 링크된다.
function goMenu(sobid, idx) {
<%
    if( i_Create.equals("Y") ) {
%>
    alert("Job Profile, Competency Requirements, Job Leveling Sheet가 모두 입력되어야만 이동이 가능합니다.");
    return;
<%
    }
%>

    document.form0.backFromJSP.value = "";

///////////////////////////////////////////////////////////////////////////////
    if( document.form0.inputCheck.value == "Y" ) {
        if( confirm( "변경된 내용이 존재합니다.\n저장하시겠습니까?") ){
            saveObject();
            return;
        }
    }
///////////////////////////////////////////////////////////////////////////////

    document.form0.SOBID.value  = sobid;
    document.form0.IMGIDX.value = idx;

    if( idx == 1 ) {
        document.form0.action   = "<%= WebUtil.ServletURL %>hris.J.J03JobCreate.J03JobProfileDetailSV";    
    } else if( idx == 2 ) {
        document.form0.action   = "<%= WebUtil.ServletURL %>hris.J.J03JobCreate.J03CompetencyReqDetailSV";
    } else if( idx == 3 || idx == 4 ) {
        document.form0.action   = "<%= WebUtil.ServletURL %>hris.J.J03JobCreate.J03FileUpDownLoadDetailSV";
    } else if( idx == 5 ) {
        document.form0.action   = "<%= WebUtil.ServletURL %>hris.J.J03JobCreate.J03LevelingSheetDetailSV";
    }
    document.form0.method       = "post";
    document.form0.target       = "J_right";
    document.form0.submit();
}

//goMenu - index에 따라서 해당하는 Menu로 링크된다.
function goLeveling(sobid, backFromJSP) {
    document.form0.backFromJSP.value = backFromJSP;
    document.form1.backFromJSP.value = backFromJSP;

///////////////////////////////////////////////////////////////////////////////
    if( document.form0.inputCheck.value == "Y" ) {
        if( confirm( "변경된 내용이 존재합니다.\n저장하시겠습니까?") ){
            saveObject();
            return;
        }
    }
///////////////////////////////////////////////////////////////////////////////

    document.form0.SOBID.value  = sobid;
    document.form0.IMGIDX.value = '5';

    document.form0.action       = "<%= WebUtil.ServletURL %>hris.J.J03JobCreate.J03LevelingSheetDetailSV";
    document.form0.method       = "post";
    document.form0.target       = "J_right";
    document.form0.submit();
}

//Competency Requirements(상세조회)
function goCompetencyDetail(sobid,idx) {
    document.form0.SOBID.value   = "<%= i_sobid %>";
    document.form0.C_SOBID.value = sobid;
    document.form0.IMGIDX.value  = idx;
    
    document.form0.action        = "<%= WebUtil.ServletURL %>hris.J.J03JobCreate.J03CompetencyDetailSV";
    document.form0.method        = "post";
    document.form0.target        = "J_right";
    document.form0.submit();
}

//goChange - index에 따라서 해당하는 Menu로 링크된다. - 수정화면으로 이동한다.
function goChange(sobid, idx) {
    document.form0.SOBID.value  = sobid;
    document.form0.IMGIDX.value = idx;
    document.form0.BEGDA.value  = "<%= DataUtil.getCurrentDate() %>";

    if( idx == 1 ) {
        document.form0.action   = "<%= WebUtil.ServletURL %>hris.J.J03JobCreate.J03JobProfileChangeSV";    
    } else if( idx == 2 ) {
        document.form0.action   = "<%= WebUtil.ServletURL %>hris.J.J03JobCreate.J03CompetencyReqChangeSV";
    } else if( idx == 3 || idx == 4 ) {
        document.form0.action   = "<%= WebUtil.ServletURL %>hris.J.J03JobCreate.J03FileUpDownLoadChangeSV";
    } else if( idx == 5 ) {
        document.form0.action   = "<%= WebUtil.ServletURL %>hris.J.J03JobCreate.J03LevelingSheetChangeSV";
    }
    document.form0.method       = "post";
    document.form0.target       = "J_right";
    document.form0.submit();
}

//항목들의 값이 변경되었는지 check한다. - 다른메뉴로 이동시 메시지를 보여주도록한다.
function fn_inputCheck() {
    document.form0.inputCheck.value = "Y";
}
//-->
</script>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0"  bottommargin="20" marginwidth="0" marginheight="0" onLoad="javascript:onLoad();">   
<form name="form0" method="post" action="">
  <input type="hidden" name="OBJID"       value="<%= i_objid %>">        <!-- Objective ID -->
  <input type="hidden" name="SOBID"       value="">                      <!-- Job ID -->
  <input type="hidden" name="PERNR"       value="<%= i_pernr %>">
  <input type="hidden" name="BEGDA"       value="<%= i_begda %>">        <!-- Job 시작일 -->
  <input type="hidden" name="i_link_chk"  value="<%= i_link_chk %>">  
  <input type="hidden" name="IMGIDX"      value="">

<!-- Leveling 수정으로 이동시 전 페이지를 check하기위해서 필요 -->
  <input type="hidden" name="backFromJSP" value="<%= backFromJSP %>">

  <input type="hidden" name="C_SOBID"     value="">                      <!-- Competency Requierment 상세조회 Link시 -->

  <input type="hidden" name="i_pernr"     value="">                      <!-- Matrix Go -->
  <input type="hidden" name="i_sobid"     value="">                      <!-- Matrix Go -->

<!-- 생성 Error시 메시지 받아서 보여주기 -->
  <input type="hidden" name="count_E" value="<%= count_E %>">     <!-- BDC MESSAGE TEXT        -->
<%
    for( int i = 0 ; i < count_E ; i++ ) {
        J03MessageData errData = (J03MessageData)j03Message_vt.get(i);
%>
  <input type="hidden" name="MSGSPRA<%= i %>" value="<%= errData.MSGSPRA %>">     <!-- 메세지 언어 ID          -->
  <input type="hidden" name="MSGID<%= i %>"   value="<%= errData.MSGID   %>">     <!-- Batch 입력 메세지 ID    -->
  <input type="hidden" name="MSGNR<%= i %>"   value="<%= errData.MSGNR   %>">     <!-- Batch 입력 메세지번호   -->
  <input type="hidden" name="MSGTEXT<%= i %>" value="<%= errData.MSGTEXT %>">     <!-- BDC MESSAGE TEXT        -->
<%
    }
%>

  <input type="hidden" name="inputCheck" value="">     <!-- 화면의 값 입력 check -->

  <table border="0" cellspacing="0" cellpadding="0" width=760>
    <tr> 
      <td><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width="6" height="6"></td>    
      <td><a href="javascript:goMatrix('<%= i_pernr %>', '<%= i_objid %>');" onMouseOver="MM_swapImage('img01','','<%= WebUtil.ImageURL %>jms/mnavJobMatrix_on.gif',1);" onMouseOut="MM_swapImgRestore();"><img name="img01" src="<%= WebUtil.ImageURL %>jms/mnavJobMatrix_off.gif" width="60" height="24" border="0"></a><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width="20" height="6"><a href="javascript:goMenu('<%= i_sobid %>','1');" onMouseOver="MM_swapImage('img02','','<%= WebUtil.ImageURL %>jms/mnavJobProfile_on.gif',1);show_hide_layer('layer1','visible');" OnMouseOut="show_hide_layer('layer1','hidden');<%= i_imgidx.equals("1") ? "" : "MM_swapImgRestore();" %>"><img name="img02" src="<%= WebUtil.ImageURL %>jms/mnavJobProfile_off.gif" width="62" height="24" border="0"></a><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width="20" height="6"><a href="javascript:goMenu('<%= i_sobid %>','2');" onMouseOver="MM_swapImage('img03','','<%= WebUtil.ImageURL %>jms/mnavCRequirements_on.gif',1);show_hide_layer('layer2','visible');" OnMouseOut="show_hide_layer('layer2','hidden');<%= i_imgidx.equals("2") ? "" : "MM_swapImgRestore();" %>"><img name="img03" src="<%= WebUtil.ImageURL %>jms/mnavCRequirements_off.gif" width="147" height="24" border="0"></a><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width="20" height="6"><a href="javascript:goMenu('<%= i_sobid %>','3');" onMouseOver="MM_swapImage('img04','','<%= WebUtil.ImageURL %>jms/mnavJobUnitKSEA_on.gif',1);show_hide_layer('layer3','visible');" OnMouseOut="show_hide_layer('layer3','hidden');<%= i_imgidx.equals("3") ? "" : "MM_swapImgRestore();" %>"><img name="img04" src="<%= WebUtil.ImageURL %>jms/mnavJobUnitKSEA_off.gif" width="83" height="24" border="0"></a><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width="20" height="6"><a href="javascript:goMenu('<%= i_sobid %>','4');" onMouseOver="MM_swapImage('img05','','<%= WebUtil.ImageURL %>jms/mnavJobProcess_on.gif',1);show_hide_layer('layer4','visible');" OnMouseOut="show_hide_layer('layer4','hidden');<%= i_imgidx.equals("4") ? "" : "MM_swapImgRestore();" %>"><img name="img05" src="<%= WebUtil.ImageURL %>jms/mnavJobProcess_off.gif" width="70" height="24" border="0"></a><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width="20" height="6"><a href="javascript:goMenu('<%= i_sobid %>','5');" onMouseOver="MM_swapImage('img06','','<%= WebUtil.ImageURL %>jms/mnavJobLevelingSheet_on.gif',1);show_hide_layer('layer5','visible');" OnMouseOut="show_hide_layer('layer5','hidden');<%= i_imgidx.equals("5") ? "" : "MM_swapImgRestore();" %>"><img name="img06" src="<%= WebUtil.ImageURL %>jms/mnavJobLevelingSheet_off.gif" width="99" height="24" border="0"></a></td>
    </tr>
    <tr height=6>
      <td><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=10 height=6></td>
      <td><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=750 height=6></td>
    </tr>
  </table>

<!-- Layer 시작 -->
<%
    int i_left = 0;
    int i_top  = 0;
    for( int j = 1 ; j < 6 ; j++ ) {
        if( j == 1 ) {
            i_left = 94;
        } else if( j == 2 ) {
            i_left = 177;
        } else if( j == 3 ) {
            i_left = 344;
        } else if( j == 4 ) {
            i_left = 447;
        } else if( j == 5 ) {
            i_left = 535;
        }

        i_top = 21;
%>
  <div id="layer<%= j %>" style="position:absolute; left:<%= i_left %>px; top:<%= i_top %>px; z-index:1; visibility:hidden;" onMouseOver="show_hide_layer('layer<%= j %>','visible');" OnMouseOut="show_hide_layer('layer<%= j %>','hidden');">
    <table cellspacing=0 cellpadding=0 border=0 bgcolor=#ffffff>
<%
        if( j01JobList_vt.size() > 0 ) {
%>
      <tr>
        <td bgcolor=#D44C02><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=2 height=3></td>
      </tr>
<%    
            for( int i = 0 ; i < j01JobList_vt.size() ; i++ ) {            
                J01JobMatrixData data_Jp = (J01JobMatrixData)j01JobList_vt.get(i);
%>
      <tr height=20 onMouseOver="this.style.backgroundColor='#FBE1E7'" onMouseOut="this.style.backgroundColor='#ffffff'">
        <td class=sl>
          <a href="javascript:goMenu('<%= data_Jp.SOBID %>','<%= j %>');" class=l01>
<%
                if ( data_Jp.SOBID.equals(i_sobid) ) {    
%>
            <b><%= data_Jp.STEXT_OBJ %></b>
<%    
                } else {
%>
            <%= data_Jp.STEXT_OBJ %>
<%            
                }                                   
%>
          </a>
        </td>
      </tr>
      <tr>
        <td><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=2 height=2></td>
      </tr>
<%
            }
        }      
%>  
    </table>
  </div> 
<%
    }      
%>  
<!-- Layer 끝 -->

  <table width="100%" cellspacing="0" cellpadding="0" border="0">       
    <tr>
      <td>
<!--타이틀 테이블 시작-->
        <table width="760" border="0" cellspacing="0" cellpadding="0" background="<%= WebUtil.ImageURL %>jms/MatrixTpbg.gif">
          <tr>
            <td><img src="<%= WebUtil.ImageURL %>jms/<%= ImgTitle %>.gif"></td>
            <td align="right" valign=bottom><a href="javascript:open_help('<%= mPageName %>');" onMouseOver="MM_swapImage('img07','','<%= WebUtil.ImageURL %>btn_help_on.gif',1);" onMouseOut="MM_swapImgRestore();"><img name="img07" border="0" src="<%= WebUtil.ImageURL %>btn_help_off.gif" width="90" height="15" alt="사용방법안내"></a><a href="javascript:parent.window.close();" onMouseOver="MM_swapImage('img08','','<%= WebUtil.ImageURL %>jms/btn_logout_on.gif',1);" onMouseOut="MM_swapImgRestore();"><img name="img08" border="0" src="<%= WebUtil.ImageURL %>jms/btn_logout.gif" width="73" height="15" alt="로그아웃"></a><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=5 height=5><br><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=70 height=5><br></td>
            <td width="1" bgcolor="#cccccc"><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width="1" height="46"></td>
          </tr>
          <tr>
            <td bgcolor="#cccccc"><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width="561" height="1"></td>
            <td bgcolor="#cccccc"><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width="198" height="1"></td>
            <td bgcolor="#cccccc"><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width="1" height="1"></td>
          </tr>
        </table>
<!--타이틀 테이블 끝-->
      </td>
    </tr>
    <tr>
      <td>
        <table width="760" cellspacing="0" cellpadding="0" border="0">
          <tr>
            <td align="right">
              <table cellspacing="0" cellpadding="0" border="0">
                <tr height=25>
                  <td width=1 bgcolor=#cccccc></td>
                  <td><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=10 height=5><img src="<%= WebUtil.ImageURL %>jms/bullet_rectangle.gif" align=absmiddle><b>Function</b> : <%= dStext.STEXT_FUNC == null ? "" : dStext.STEXT_FUNC %><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=10 height=5><b>Objective</b> : <%= dStext.STEXT_OBJ == null ? "" : dStext.STEXT_OBJ %><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=5 height=5></td>
<%
    if( i_sobid.equals("") ) {
%>
                  <td width=1 bgcolor=#cccccc></td>
                </tr>
                <tr height=1>
                  <td colspan=3 bgcolor=#cccccc></td>
                </tr>
<%
    } else {
%>
                  <td width=1 background="<%= WebUtil.ImageURL %>jms/J02bg.gif"></td>
                  <td width=5 bgcolor=#f5f5f5></td>
                  <td width=138 bgcolor=#f5f5f5>Job 시작일 : <%= WebUtil.printDate(E_BEGDA) %></td>
                  <td width=1 bgcolor=#cccccc></td>
                </tr>
                <tr height=1>      
                  <td colspan=6 bgcolor=#cccccc></td>
                </tr>
<%
    }
%>
              </table>
            </td>
          </tr>
        </table>
      </td>
    </tr>
  </table>
</form>
