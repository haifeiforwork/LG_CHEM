<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.J.J01JobMatrix.rfc.*" %>
<%@ page import="hris.J.J01JobMatrix.*" %>
<%@ page import="com.sns.jdf.util.*" %> 
<%@ page import="java.util.*" %> 
<%
//  Job Holder의 성명을 click시 사원인사정보를 띄워준다. - Job Profile
    WebUserData user                 = (WebUserData)session.getAttribute("user");

//  사원번호(팀원), image index
    String i_pernr                   = (String)request.getAttribute("i_pernr"); 
    String i_begda                   = (String)request.getAttribute("i_begda");   
    String i_link_chk                = (String)request.getAttribute("i_link_chk");        
    String i_imgidx                  = (String)request.getAttribute("i_imgidx");

//  Objective ID, Job ID
    String i_objid                   = (String)request.getAttribute("i_objid");
    String i_sobid                   = (String)request.getAttribute("i_sobid");

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
        j01JobList_vt = rfc.getDetail( i_pernr, i_begda );
    }

//  default메뉴를 설정한다.
    if( i_imgidx.equals("") ) {
        i_imgidx = "1";
    }

    String ImgMenu   = "";                 //Menu Image 이름
    String ImgTitle  = "";                 //Title Image 이름
    String mPageName = "";                 //Help File 이름
    if ( i_imgidx.equals("1") ) {
        ImgMenu  = "mnavJobProfile_on";
        ImgTitle = "ProfileTptitle";

        if( i_objid.equals("") ) {         // 개인 Job Matrix 조회
            mPageName = "J01JobProfile_m.html";
        } else {                           // 팀원 Job Matrix 조회
            mPageName = "J01JobProfile.html";
        }
    } else if ( i_imgidx.equals("2") ) {
        ImgMenu  = "mnavCRequirements_on";
        ImgTitle = "CompetencyTptitle";

        if( i_objid.equals("") ) {         // 개인 Job Matrix 조회
            mPageName = "J01CompetencyReq_m.html";
        } else {                           // 팀원 Job Matrix 조회
            mPageName = "J01CompetencyReq.html";
        }
    } else if ( i_imgidx.equals("3") ) {
        ImgMenu  = "mnavJobUnitKSEA_on";
        ImgTitle = "JobUnitTptitle";

        if( i_objid.equals("") ) {         // 개인 Job Matrix 조회
            mPageName = "J01JobUnitKSEA_m.html";
        } else {                           // 팀원 Job Matrix 조회
            mPageName = "J01JobUnitKSEA.html";
        }
    } else if ( i_imgidx.equals("4") ) {
        ImgMenu  = "mnavJobProcess_on";
        ImgTitle = "ProcessTptitle";

        if( i_objid.equals("") ) {         // 개인 Job Matrix 조회
            mPageName = "J01JobProcess_m.html";
        } else {                           // 팀원 Job Matrix 조회
            mPageName = "J01JobProcess.html";
        }
    } else if ( i_imgidx.equals("5") ) {
        ImgMenu  = "mnavJobLevelingSheet_on";
        ImgTitle = "LevelingTptitle";

        if( i_objid.equals("") ) {         // 개인 Job Matrix 조회
            mPageName = "J01LevelingSheet_m.html";
        } else {                           // 팀원 Job Matrix 조회
            mPageName = "J01LevelingSheet.html";
        }
    }
%>

<script language="JavaScript">
<!--
function onLoad() {
    MM_swapImage('img0<%= Integer.parseInt(i_imgidx) + 1 %>','','<%= WebUtil.ImageURL %>jms/<%= ImgMenu %>.gif',1);
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
    document.form0.i_pernr.value = pernr;
    document.form0.i_sobid.value = objid;

    document.form0.action        = "<%= WebUtil.ServletURL %>hris.J.J01JobMatrix.J01JobMatrixSV";
    document.form0.method        = "post";    
    document.form0.submit();
}

//goMenu - index에 따라서 해당하는 Menu로 링크된다.
function goMenu(sobid, idx) {
    document.form0.SOBID.value  = sobid;
    document.form0.IMGIDX.value = idx;

    if( idx == 1 ) {
        document.form0.action   = "<%= WebUtil.ServletURL %>hris.J.J01JobMatrix.J01JobProfileSV";    
    } else if( idx == 2 ) {
        document.form0.action   = "<%= WebUtil.ServletURL %>hris.J.J01JobMatrix.J01CompetencyReqSV";
    } else if( idx == 3 || idx == 4 ) {
        document.form0.action   = "<%= WebUtil.ServletURL %>hris.J.J01JobMatrix.J01ImageFileNameSV";
    } else if( idx == 5 ) {
        document.form0.action   = "<%= WebUtil.ServletURL %>hris.J.J01JobMatrix.J01LevelingSheetSV";
    }
    document.form0.method       = "post";
    document.form0.submit();
}

//Competency Requirements(상세조회)
function goCompetencyDetail(sobid,idx) {
    document.form0.SOBID.value   = "<%= i_sobid %>";
    document.form0.C_SOBID.value = sobid;
    document.form0.IMGIDX.value  = idx;
    
    document.form0.action        = "<%= WebUtil.ServletURL %>hris.J.J01JobMatrix.J01CompetencyDetailSV";
    document.form0.method        = "post";
    document.form0.submit();
}
//-->
</script>

<%
    if ( i_objid.equals("") ) {
%>
<body bgcolor="#FFFFFF" text="#000000" leftmargin="16" topmargin="5" rightmargin="0" bottommargin="20" marginwidth="0" marginheight="0" onLoad="javascript:onLoad();">
<%  
    } else {
%>
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0"  bottommargin="20" marginwidth="0" marginheight="0" onLoad="javascript:onLoad();">   
<%      
    }
%>

<form name="form0" method="post" action="">
  <input type="hidden" name="OBJID"      value="<%= i_objid %>">        <!-- Objective ID -->
  <input type="hidden" name="SOBID"      value="">                      <!-- Job ID -->
  <input type="hidden" name="PERNR"      value="<%= i_pernr %>">
  <input type="hidden" name="BEGDA"      value="<%= i_begda %>">        <!-- 적용일자 -->
  <input type="hidden" name="i_link_chk" value="<%= i_link_chk %>">  
  <input type="hidden" name="IMGIDX"     value="">

  <input type="hidden" name="C_SOBID"    value="">                      <!-- Competency Requierment 상세조회 Link시 -->

  <input type="hidden" name="i_pernr"    value="">                      <!-- Matrix Go -->
  <input type="hidden" name="i_sobid"    value="">                      <!-- Matrix Go -->

<%
    if ( i_objid.equals("") ) {        //개인 Job Description 조회시..
%>
  <table cellspacing=1 cellpadding=0 border=0 bgcolor=#999999 width=760 height=38>
    <tr>
      <td bgcolor=#ffffff>
        <table cellspacing=0 cellpadding=0 border=0 width=100%>
          <tr>
            <td class=title01>&nbsp;&nbsp;&nbsp;Job Description</td>
            <td align=right><img src="<%= WebUtil.ImageURL %>jms/mvbg.jpg"></td>
          </tr>
        </table>
      </td>
    </tr>
  </table>
  <table border="0" cellspacing="0" cellpadding="0" width=760>
    <tr height=6>
      <td><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=10 height=6></td>
      <td><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=750 height=6></td>
    </tr>
<%
    } else {
%>
  <table border="0" cellspacing="0" cellpadding="0" width=760>
<%
    }
%>
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

//      개인 Job Description 조회시 body의 leftmargin를 더한다.
        if( i_objid.equals("") ) {
            i_left = i_left + 16;
            i_top = 73;
        } else {
            i_top = 21;
        }
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
            <td align="right" valign=bottom><a href="javascript:open_help('<%= mPageName %>');" onMouseOver="MM_swapImage('img07','','<%= WebUtil.ImageURL %>btn_help_on.gif',1);" onMouseOut="MM_swapImgRestore();"><img name="img07" border="0" src="<%= WebUtil.ImageURL %>btn_help_off.gif" width="90" height="15" alt="사용방법안내"></a><% if( !i_objid.equals("") ) { %><a href="javascript:parent.window.close();" onMouseOver="MM_swapImage('img08','','<%= WebUtil.ImageURL %>jms/btn_logout_on.gif',1);" onMouseOut="MM_swapImgRestore();"><img name="img08" border="0" src="<%= WebUtil.ImageURL %>jms/btn_logout.gif" width="73" height="15" alt="로그아웃"></a><% } %><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=5 height=5><br><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=70 height=5><br></td>
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
                  <td width=1 background="<%= WebUtil.ImageURL %>jms/J02bg.gif"></td>
                  <td width=5 bgcolor=#f5f5f5></td>
                  <td width=127 bgcolor=#f5f5f5>적용일자 : <%= WebUtil.printDate(i_begda) %></td>
                  <td width=1 bgcolor=#cccccc></td>
                </tr>
                <tr height=1>
                  <td colspan=6 bgcolor=#cccccc></td>
                </tr>
              </table>
            </td>
          </tr>
        </table>
      </td>
    </tr>
  </table>
</form>
