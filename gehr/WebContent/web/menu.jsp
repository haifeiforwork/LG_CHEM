<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ page errorPage="/web/err/error.jsp"%>
<%@ page import="java.util.*" %>
<%@ page import = "com.sns.jdf.util.*"%>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.MenuIC" %>
<%@ page import="hris.common.MenuICb" %>

<%
    WebUserData user = WebUtil.getSessionUser(request);
    Vector vcOMenuCodeData = (Vector)request.getAttribute("vcMeneCodeData");
%>
<html>
<head>
<title>e-HR</title>
<style type="text/css">
  /* 스크롤 바 */
body
     /*{scrollbar-3dlight-color:#B5B5B5;*/
       /*scrollbar-arrow-color:#848484;*/
       /*scrollbar-base-color:#EBF7FF;*/
       /*scrollbar-darkshadow-color:#B1B1B1;*/
       /*scrollbar-face-color:#F0F0F0;*/
       /*scrollbar-highlight-color:white;*/
       /*scrollbar-shadow-color:white;}*/

/* 텍스트 링크 */
  td {font-size:9pt; color:#000000; font-family:돋움,arial,vernada; line-height:18px}

  a:link      { font-family: "돋움"; font-size: 9pt; color: #000000; text-decoration: none; line-height:15px}
  a:active  { font-family: "돋움"; font-size: 9pt; color: #000000; text-decoration: none; line-height:15px}
  a:visited { font-family: "돋움"; font-size: 9pt; color: #000000; text-decoration: none; line-height:15px}
  a:hover  { font-family: "돋움"; font-size: 9pt; color: #000000; text-decoration: underline; line-height:15px}

/* 이미지 */
img
{border: none;}
</style>

<script language="javascript">

    var i;

  function hideIMG(docID)
  {
      var obj2;
      obj2 = document.all.length;
      for(i = 0; i < obj2; i++){
        var aa;
        aa = eval("document.all["+i+"]");
        if(aa.id.substring(0,3)=="doc"){
          aa.style.backgroundImage = "url('<%= WebUtil.ImageURL %>lb03.gif')";
        }
      }

      var lDoc = eval("document.all.doc" + docID);
      lDoc.style.backgroundImage = "url('<%= WebUtil.ImageURL %>lb04.gif')";
  }

    function isParent(theObj ,subMenu)
    {

       if(theObj.parent == subMenu)
       {
           return true;
       } else {
           var obj = eval(theObj.parent);
           if (theObj.parent != "" && obj.parent != "" ) {
               return isParent(obj ,subMenu);
           } // end if
       } // end if
       return false;
    }

    function showhide(thisObj ,theObj)
    {
        var menuCount = tssform.menuCount.value ;
        var obj = "";
        if(theObj.style.display == "none") {
            for (var  d=0;d < menuCount ;d++){
                    obj = eval("document.all.submenu"+d);
                    if(!isParent(theObj ,("submenu"+d)) ) {
                        obj.style.display = "none";
                    } //end if
            }
            theObj.style.display = "block";
        }else {
            theObj.style.display = "none";
        } // end if
    }

    function openParent(theObj)
    {
       if(theObj.style.display == "none") {
           var lParent = eval(theObj.parent);
           if (theObj.parent != "") {
               openParent(lParent);
           } // end if
           showhide("",theObj);
       } // end if
    } // end function

    function clickDoc(docID)
    {
       frm = document.tssform;
       var lDoc = eval("doc" + docID);
       frm.action = lDoc.href;
       //frm.target = "main_ess";
       frm.target = "menuContentIframe";
       frm.submit();

    } // end function

    function clickDoc2(docID)
    {
       frm = document.tssform;
       var lDoc ='<%=user.e_mail.substring(0,user.e_mail.lastIndexOf("@"))%>'; 
     <% if (user.SServer != "") { %>
       var SServer = '<%=user.SServer%>';
     <% } else { %>
       var SServer = 'mail2.lgchem.com';
     <% } %>
       frm.action ="http://" + SServer + "/portal.nsf/splitFrame?readform&expand=n&type=T&node=14&menu=업무지원&content=http://eloffice.lgchem.com:8002/intra/owa/neloinit.quick?p_user=" + lDoc + "&p_port=8002&p_svr_name=" + SServer + "&p_curr_urlx=nelomenu_treelink?p_seq=20050329111111";
       frm.target = "_parent";
       frm.submit();

    } // end function

    function openDoc(docID)
    {
       var lDoc = eval("doc" + docID);
       if( lDoc.parent != "" ) {
           var lParent = eval(lDoc.parent);
           openParent(lParent);
       } // end if
       clickDoc(docID)
    } // end function

    function open_charge()
    {
      small_window=window.open("<%= WebUtil.JspURL %>common/HRChargePop.jsp?I_BUKRS=<%= user.companyCode %>&I_GRUP_NUMB=<%= user.e_grup_numb %>","Charge","toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=no,scrollbars=yes,width=712,height=420,left=100,top=100");
      small_window.focus();
    }

    function message4MenuICb(docID)
    {
      alert('급여작업으로 급여지급일까지 system사용을 정지하오니, \n양해하여주시기 바랍니다.');
    }
    function openFaq(){
    	window.open('<%= WebUtil.ServletURL %>hris.J.J06Faq.J06FaqSV',"Charge","toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=no,scrollbars=yes,width=810,height=700,left=100,top=10");
	}
</script>
</head>
<body bgcolor="#E2DED1" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" style="overflow-y : scroll;">
<% 
  MenuICb Menub = new MenuICb();
  MenuIC Menu = new MenuIC(); 
%>
<table width="<%=Menu.masterTableWidth%>"  border="0" cellspacing="0" cellpadding="0">
  <tr height="5" >
    <td background="<%=WebUtil.ImageURL%>lmt_bg.gif"> </td>
  </tr>
  <tr>
    <td background="<%=WebUtil.ImageURL%>lmt_bg.gif">
        <table width="<%=Menu.masterTableWidth%>" border="0" cellspacing="0" cellpadding="0">
           <tr >
              <td width="50%" valign="middle" align="right">
                <a href="/web/view.jsp" target = "menuContentIframe">
                  <img src="<%=WebUtil.ImageURL%>btn_start.gif" border="0" valign="absmiddle">
                </a>
              </td>
              <td valign="middle" align="left">
                <a href="/servlet/servlet.hris.LogoutSV" target = "menuContentIframe">
                  <img src="<%=WebUtil.ImageURL%>btn_end.gif" border="0"valign="absmiddle">
                </a>
              </td>
           </tr>
        </table>
    </td>
  </tr>
  <tr>
    <td align="right" valign="top" aling="left" background="<%=WebUtil.ImageURL%>bg01.gif">
        <table width="<%=Menu.masterTableWidth%>" border="0" cellspacing="0" cellpadding="0">
           <%=Menu.writeMenu(vcOMenuCodeData ,"1000" ,"")%>
           <tr><td colspan="2" height="30" background="<%= WebUtil.ImageURL %>lmt02a.gif" clickedImg="<%= WebUtil.ImageURL %>null" >&nbsp;&nbsp;&nbsp;&nbsp;<b></b></td></tr>
           <tr><td width="13"></td>
           <td>
           <table width="161" cellspacing="0" cellpadding="0">
           <tr><td colspan="2" id="doc9997" height="f17" background="<%= WebUtil.ImageURL %>lb03.gif" clickedImg="<%= WebUtil.ImageURL %>lb04.gif" >&nbsp;&nbsp;<a href="#" onClick="open_charge();hideIMG('9997');this.blur();">인사담당자 연락처</a></td></tr>
           <tr><td colspan="2" id="doc9998" height="17" background="<%= WebUtil.ImageURL %>lb03.gif" clickedImg="<%= WebUtil.ImageURL %>lb04.gif" >&nbsp;&nbsp;<a href="<%= WebUtil.ServletURL %>hris.common.SiteMapSV" target="menuContentIframe" onClick="hideIMG('9998');this.blur();">사이트맵</a></td></tr>
           <tr><td colspan="2" id="doc9996" height="17" background="<%= WebUtil.ImageURL %>lb03.gif" clickedImg="<%= WebUtil.ImageURL %>lb04.gif" >&nbsp;&nbsp;<a href="<%= WebUtil.JspURL %>ruleLink.jsp" target="hidden" onClick="hideIMG('9996');this.blur();">제도안내</a></td></tr>
           <tr><td colspan="2" id="doc9999" height="17" background="<%= WebUtil.ImageURL %>lb03.gif" clickedImg="<%= WebUtil.ImageURL %>lb04.gif" >&nbsp;&nbsp;<a href="<%= WebUtil.JspURL %>helpLink.jsp" target="hidden" onClick="hideIMG('9999');this.blur();">사용방법안내</a></td></tr>
           <tr><td colspan="2" id="doc9995" height="17" background="<%= WebUtil.ImageURL %>lb03.gif" clickedImg="<%= WebUtil.ImageURL %>lb04.gif" >&nbsp;&nbsp;<a href="javascript:openFaq()" onClick="hideIMG('9995');this.blur();">FAQ</a></td></tr>
     			 <% if( (user.e_persk).equals("11") || (user.e_persk).equals("12") || (user.e_persk).equals("13") || (user.empNo).equals("00200482") ){ 
								    String elurl = "http://eloffice.lgchem.com:8001/intra/owa/insarule?p_user="+user.empNo; %>
								    <tr><td colspan="2" height="17" clickedImg="<%= WebUtil.ImageURL %>lb04.gif"><a href="<%=elurl%>" target="hidden" onClick="this.blur();"><font color=#1a96b8>▣ 집행임원인사관리규정</font></a></td></tr>
					 <% } %>
           </table>
           </td></tr>
        </table>
    </td>
  </tr>
  <tr>
    <td height="49" background="<%=WebUtil.ImageURL%>lmt03.gif">&nbsp;</td>
  </tr>
</table>
<form name="tssform" method="post">
<input type="hidden" name="menuCount" value="<%=Menu.menuCount%>">
<input type="hidden" name="docCount" value="<%=Menu.docCount%>">
<%
    Menu.docCount = 0;
    Menu.menuCount = 0;
    vcOMenuCodeData = null;
%>
</form>
</body>
</html>
