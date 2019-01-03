<%@ page import="hris.common.*" %>

<%@ page import="hris.J.J01JobMatrix.*" %>
<%@ page import="hris.J.J01JobMatrix.rfc.*" %>
<%@ page import="hris.J.J03JobCreate.*" %>
<%@ page import="hris.J.J03JobCreate.rfc.*" %>
<%@ page import="hris.J.J05JobMove.*" %>
<%@ page import="hris.J.J05JobMove.rfc.*" %>
<%@ page import="java.util.*" %>
  
<%
    WebUserData user                 = (WebUserData)session.getAttribute("user");

//  Objective ID, Job ID
    String i_objid                   = (String)request.getAttribute("i_objid");
    String i_sobid                   = (String)request.getAttribute("i_sobid");

//  ����ȣ(����), image index
    String i_pernr                   = (String)request.getAttribute("i_pernr"); 
    String i_begda                   = (String)request.getAttribute("i_begda");   

//  Header Stext - Function Name, Objective Name, Job Name
    J01HeaderStextData dStext        = new J01HeaderStextData();
    J01HeaderStextRFC  rfc_Stext     = new J01HeaderStextRFC();

    Vector             j01Stext_vt   = rfc_Stext.getDetail( i_objid, i_sobid, i_pernr, i_begda );
    if( j01Stext_vt.size() > 0 ) {
        dStext = (J01HeaderStextData)j01Stext_vt.get(0);
    }

//  error message Vector �ޱ�
    int count_E = 0;
    Vector j03Message_vt = (Vector)request.getAttribute("j03Message_vt");
    if( j03Message_vt != null ) { count_E = j03Message_vt.size(); }

//////////////////////////////////////////////////////////////////////////////////////
//  ��з� ��, Function ID, Objectives ID
    String SOBID_F = (String)request.getAttribute("SOBID_F");
    String SOBID_O = (String)request.getAttribute("SOBID_O");

    if( SOBID_F == null ) { SOBID_F = dStext.OBJID_FUNC; }
    if( SOBID_O == null ) { SOBID_O = dStext.OBJID_OBJ; }

//  Function, Objectives, ��з� List�� ��ȸ�Ѵ�.
    J03ObjectPEntryRFC rfc_List         = new J03ObjectPEntryRFC();
    Vector             j03PEntryList_vt = rfc_List.getPEntry("1", "", user.empNo);
    String             Objec_ID         = "";
    String             Dsort_ID         = "";

    if( SOBID_F.equals("") && !SOBID_O.equals("") ) {
        for( int i = 0 ; i < j03PEntryList_vt.size() ; i++ ) {
            J03PEntryListData data_List = (J03PEntryListData)j03PEntryList_vt.get(i);
            if( data_List.OBJID_O.equals(SOBID_O) ) {
                SOBID_F = data_List.OBJID_F;
            }
        }
    }

//  Page �̵��� �� �������� ��������� ������ �ٴѴ�.
    String inputCheck = (String)request.getAttribute("inputCheck");
%>

<script language="JavaScript">
<!--
function onLoad() {
//�� ����� �޽��� ó��
  if( "<%= (String)request.getAttribute("i_error") %>" == "Y" ) {
//  Error�߻�������� �Է»��¸� �������ش�.
    document.form0.inputCheck.value = "Y";

    error_window=window.open("","errorWindow","toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=no,scrollbars=yes,width=480,height=380,left=100,top=100");
    error_window.focus();

    document.form0.action = "<%= WebUtil.JspURL %>J/J03JobCreate/J03ErrorWindow.jsp";
    document.form0.target = "errorWindow";
    document.form0.submit();
  }
}

//Job Matrix
function goMatrix(pernr, objid) {
///////////////////////////////////////////////////////////////////////////////
    if( document.form0.inputCheck.value == "Y" ) {
        if( confirm( "����� ������ �����մϴ�.\n�����Ͻðڽ��ϱ�?") ){
            saveObject();
            return;
        }
    }
///////////////////////////////////////////////////////////////////////////////

//    document.form0.i_pernr.value = pernr;         //����ȣ
//    document.form0.i_sobid.value = objid;         //Objectives ID

//  Objective ID�� �������� ���Ʈ���� �ٽ� ��ȸ�Ѵ�.
    document.form0.action        = "<%= WebUtil.ServletURL %>hris.J.J01JobMatrix.J01GetPersonsSV?i_objid=<%= i_objid %>&gubun=C";
    document.form0.method        = "post";
    document.form0.target        = "J_leftDown";
//    document.form0.target        = "J_right";
    document.form0.submit();
}

//�׸���� ���� ����Ǿ���� check�Ѵ�. - �ٸ��޴��� �̵��� �޽����� �����ֵ����Ѵ�.
function fn_inputCheck() {
    document.form0.inputCheck.value = "Y";
}

//Function List ����� Objectives�� �����Ѵ�.
function changeFunc(obj) {
  var val = obj[obj.selectedIndex].value;
  var inx = 1, index = 0;

  if( val == "" ) {
    document.form0.SOBID_O.length = 1;
  } else {
<%
    Objec_ID = "";
    for( int i = 0 ; i < j03PEntryList_vt.size() ; i++ ) {
        J03PEntryListData data_List = (J03PEntryListData)j03PEntryList_vt.get(i);
%>
    if( val == '<%= data_List.OBJID_F %>' ) {
<%
        if( !data_List.OBJID_O.equals(Objec_ID) ) {
            Objec_ID = data_List.OBJID_O;
%>
      inx++;

      index = inx - 1;

      document.form0.SOBID_O.length = inx;
      eval("document.form0.SOBID_O["+index+"].value = '<%= data_List.OBJID_O %>';");
      eval("document.form0.SOBID_O["+index+"].text  = '<%= data_List.STEXT_O %>';");
<%
        }
%>
    }
<%
    }
%>
  }
  document.form0.SOBID_O[0].selected = true;
}

//Objectives�� ����Ǹ� Job Move List�� ���� ��ȸ�Ѵ�.
function getJobMove(obj) {
  var val = obj[obj.selectedIndex].value;

  if( val != "" ) {
    if( val != "<%= i_objid %>" ) {
      document.form0.OBJID.value  = val;

      document.form0.action       = "<%= WebUtil.ServletURL %>hris.J.J05JobMove.J05JobMoveSV";
      document.form0.method       = "post";
      document.form0.submit();
    }
  }
}
//-->
</script>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0"  bottommargin="20" marginwidth="0" marginheight="0" onLoad="javascript:onLoad();">   
<form name="form0" method="post" action="">
  <input type="hidden" name="OBJID"   value="<%= i_objid %>">        <!-- Objective ID -->
  <input type="hidden" name="SOBID"   value="">                      <!-- Job ID -->
  <input type="hidden" name="PERNR"   value="<%= i_pernr %>">
  <input type="hidden" name="BEGDA"   value="<%= i_begda %>">        <!-- Job ������ -->

  <input type="hidden" name="i_pernr" value="">                      <!-- Matrix Go -->
  <input type="hidden" name="i_sobid" value="">                      <!-- Matrix Go -->

<!-- �� Error�� �޽��� �޾Ƽ� �����ֱ� -->
  <input type="hidden" name="count_E" value="<%= count_E %>">     <!-- BDC MESSAGE TEXT        -->
<%
    for( int i = 0 ; i < count_E ; i++ ) {
        J03MessageData errData = (J03MessageData)j03Message_vt.get(i);
%>
  <input type="hidden" name="MSGSPRA<%= i %>" value="<%= errData.MSGSPRA %>">     <!-- �޼��� ��� ID          -->
  <input type="hidden" name="MSGID<%= i %>"   value="<%= errData.MSGID   %>">     <!-- Batch �Է� �޼��� ID    -->
  <input type="hidden" name="MSGNR<%= i %>"   value="<%= errData.MSGNR   %>">     <!-- Batch �Է� �޼�����ȣ   -->
  <input type="hidden" name="MSGTEXT<%= i %>" value="<%= errData.MSGTEXT %>">     <!-- BDC MESSAGE TEXT        -->
<%
    }
%>

  <input type="hidden" name="inputCheck" value="<%= inputCheck %>">     <!-- ȭ���� �� �Է� check -->

  <table border="0" cellspacing="0" cellpadding="0" width=760>
    <tr> 
      <td><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width="6" height="6"></td>    
      <td><a href="javascript:goMatrix('<%= i_pernr %>', '<%= i_objid %>');" onMouseOver="MM_swapImage('img01','','<%= WebUtil.ImageURL %>jms/mnavJobMatrix_on.gif',1);" onMouseOut="MM_swapImgRestore();"><img name="img01" src="<%= WebUtil.ImageURL %>jms/mnavJobMatrix_off.gif" width="60" height="24" border="0"></a></td>
    </tr>
    <tr height=6>
      <td><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=10 height=6></td>
      <td><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=750 height=6></td>
    </tr>
  </table>

  <table width="100%" cellspacing="0" cellpadding="0" border="0">
    <tr>
      <td>
<!--Ÿ��Ʋ ���̺� ����-->
        <table width="760" border="0" cellspacing="0" cellpadding="0" background="<%= WebUtil.ImageURL %>jms/MatrixTpbg.gif">
          <tr>
            <td><img src="<%= WebUtil.ImageURL %>jms/MoveTptitle.gif"></td>
            <td align="right" valign=bottom><a href="javascript:open_help('J05JobMove.html');" onMouseOver="MM_swapImage('img07','','<%= WebUtil.ImageURL %>btn_help_on.gif',1);" onMouseOut="MM_swapImgRestore();"><img name="img07" border="0" src="<%= WebUtil.ImageURL %>btn_help_off.gif" width="90" height="15" alt="�����ȳ�"></a><a href="javascript:parent.window.close();" onMouseOver="MM_swapImage('img08','','<%= WebUtil.ImageURL %>jms/btn_logout_on.gif',1);" onMouseOut="MM_swapImgRestore();"><img name="img08" border="0" src="<%= WebUtil.ImageURL %>jms/btn_logout.gif" width="73" height="15" alt="�α׾ƿ�"></a><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=5 height=5><br><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=70 height=5><br></td>
            <td width="1" bgcolor="#cccccc"><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width="1" height="46"></td>
          </tr>
          <tr>
            <td bgcolor="#cccccc"><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width="561" height="1"></td>
            <td bgcolor="#cccccc"><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width="198" height="1"></td>
            <td bgcolor="#cccccc"><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width="1" height="1"></td>
          </tr>
        </table>
<!--Ÿ��Ʋ ���̺� ��-->
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
                  <td><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=10 height=5><b>Function</b> : </td>
                  <td width=3><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=3 height=5></td>
                  <td>
                    <select name="SOBID_F" class=formset1 onChange="javascript:changeFunc(this);">
                      <option value="">----------------------------</option>
<%
    String Func_ID = "";
    for( int i = 0 ; i < j03PEntryList_vt.size() ; i++ ) {
        J03PEntryListData data_List = (J03PEntryListData)j03PEntryList_vt.get(i);
        if( !data_List.OBJID_F.equals(Func_ID) ) {
            Func_ID = data_List.OBJID_F;
%>
                      <option value="<%= data_List.OBJID_F %>" <%= data_List.OBJID_F.equals(SOBID_F) ? "selected" : "" %>><%= data_List.STEXT_F %></option>
<%
        }
    }
%>
                    </select>
                  </td>
                  <td><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=10 height=5><b>Objective</b> : </td>
                  <td width=3><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=3 height=5></td>
                  <td class=cc> 
                    <select name="SOBID_O" class=formset1 onChange="javascript:getJobMove(this);">
                      <option value="">----------------------------</option>
<%
    Objec_ID = "";
    for( int i = 0 ; i < j03PEntryList_vt.size() ; i++ ) {
        J03PEntryListData data_List = (J03PEntryListData)j03PEntryList_vt.get(i);
        if( data_List.OBJID_F.equals(SOBID_F) && !data_List.OBJID_O.equals(Objec_ID) ) {
            Objec_ID = data_List.OBJID_O;
%>
                      <option value="<%= data_List.OBJID_O %>" <%= data_List.OBJID_O.equals(SOBID_O) ? "selected" : "" %>><%= data_List.STEXT_O %></option>
<%
        }
    }
%>
                    </select>
                  </td>
                  <td width=1 bgcolor=#cccccc></td>
                </tr>
                <tr height=1>
                  <td colspan=8 bgcolor=#cccccc></td>
                </tr>
              </table>
            </td>
          </tr>
        </table>
      </td>
    </tr>
  </table>
</form>
