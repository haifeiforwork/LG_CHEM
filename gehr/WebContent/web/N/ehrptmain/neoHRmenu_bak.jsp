<!DOCTYPE HTML PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "html://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html; charset=euc-kr" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ page errorPage="/err/error.jsp"%>
<%@ page import="java.util.*" %>
<%@ page import = "com.sns.jdf.util.*"%>
<%@ page import="hris.N.EHRCommonUtil" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.MenuIC" %>
<%@ page import="hris.common.MenuICb" %>

<%
    WebUserData user = (WebUserData)session.getValue("user");

    Vector vcOMenuCodeData = (Vector)request.getAttribute("vcMeneCodeData");
    //
    String potalPage =   WebUtil.ServletURL+"hris.N.ehrptmain.EHRPortalMainSV?popUP=N";
    String potalYN =  request.getParameter("potalYN");
    //
    String menuCode = EHRCommonUtil.nullToEmpty((request.getParameter("menuCode")) );
    String AINF_SEQN = EHRCommonUtil.nullToEmpty(request.getParameter("AINF_SEQN"));
    String year = EHRCommonUtil.nullToEmpty((String) request.getParameter("year"));
    String month = EHRCommonUtil.nullToEmpty((String) request.getParameter("month"));
    
%>
<jsp:include page="/include/header.jsp" />

<script language="javascript">

  var i;
  function hideIMG(docID)
  {
      /*결재 진행메일에서 바로오는 메뉴 코드 9999 처리*/
  	 if(docID != "" && docID != "9999"){
	      var obj2;
	      obj2 = document.all.length;
	      var textid = eval("document.all.mn" + docID);
	      if(textid != undefined){ 
		      for(i = 0; i < obj2; i++){
		        var aa;
		        aa = eval("document.all["+i+"]");
		       
		        if(aa.id.substring(0,3)=="doc" ){
		          aa.style.backgroundImage = "url('<%= WebUtil.ImageURL %>leftMenu/lb03.gif')";
		        }
		        
		        if(aa.id.substring(0,2)=="mn"){
		            aa.className="";
		       	 	
		        }
		      }
		      var lDoc = eval("document.all.doc" + docID);
		      lDoc.style.backgroundImage = "url('<%= WebUtil.ImageURL %>leftMenu/lb04.gif')";
		      textid.className="lMenu_4th_on";
	      }
      }
  }

     function isParent(theObj ,subMenu)
    {

       if(theObj.parent == subMenu)
       {
           return true;
       } else {
           var obj = eval(theObj.parent);
           // if (theObj.parent != "" && obj.parent != "" ) {
           if (!_.isEmpty(theObj.parent) && !_.isEmpty(obj.parent) ) {
               return isParent(obj ,subMenu);
           } // end if
       } // end if
       return false;
    }

    function showhide(thisObj , theObj)
    {
   // alert(thisObj);
   // alert(theObj);
        var menuCount = tssform.menuCount.value;
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
    
    
     function showhideEx(theObj)
    {
    	alert(theObj);
        var menuCount = tssform.menuCount.value;
        var obj = "";
        
        for (var  d=0;d < menuCount ;d++){
	        obj = eval("document.all.submenu"+d);
	        if(!isParent(theObj,("submenu"+d)) ) {
	            obj.style.display = "none";
	        } //end if
    	}
    	theObj.style.display = "block";
    }
    
    
    function openParent(theObj)
    {
       //alert("openParent");
       if(theObj.style.display == "none") {
           var lParent = eval(theObj.parent);
           if (theObj.parent != "") {
               openParent(lParent);
           } // end if
           showhide("",theObj);
       } // end if
    } // end function

    function clickDoc(docID, docTxt)
    {
       frm = document.tssform;
       var lDoc = eval("doc" + docID);
       
       //frm.target = "main_ess";
       <%
       //"/servlet/servlet.hris.G.G000ApprovalDocMapSV?isEditAble=false&AINF_SEQN="+ AINF_SEQN;
       //메일에서 결재자가 들어온 경우 처리 한다.
        %>
       		frm.action = lDoc.href;
       <%
       	if(!AINF_SEQN.equals("") ){
       %> 
         if(docID =="9999"){
    	   
    		frm.action = "/servlet/servlet.hris.G.G000ApprovalDocMapSV?isEditAble=false&AINF_SEQN=<%=AINF_SEQN%>";
    	   
	       //parent.menuContentIframe.switchScreen();
       }
       
      	 
       <% }%>
       if(docID =="1320"){
    	   
    		frm.action = "/servlet/servlet.hris.F.F46OverTimeSV?year=<%=year %>&month=<%=month%>";
    	   
	       //parent.menuContentIframe.switchScreen();
       }
       
        if(docID =="1184"){
    	   
    		frm.action = "/servlet/servlet.hris.F.F42DeptMonthWorkConditionSV?year1=<%=year %>&month1=<%=month%>";
    	   
	       //parent.menuContentIframe.switchScreen();
       }
      
      
       
       frm.sMenuCode.value = docID;
       frm.sMenuText.value = docTxt;
       frm.target = "menuContentIframe";
       frm.submit();

    } // end function

    function clickDoc2(docID)
    {
       frm = document.tssform;
       var lDoc = "";
       <%if(!user.e_mail.equals("")){%>
    	   lDoc ='<%=user.e_mail.substring(0,user.e_mail.lastIndexOf("@"))%>'; 
       <%}%>       
     <% if (user.SServer != "") { %>
       var SServer = '<%=user.SServer%>';
     <% } else { %>
       var SServer = 'mail2.lgchem.com';
     <% } %>
      
      
       
       var url ="http://eloffice.lgchem.com:8002/intra/owa/neloinit.quick?p_user="+lDoc+"&p_port=8002&p_svr_name="+SServer+"&p_curr_urlx=nelomenu_treelink?p_seq=20050329111111";
       parent.menuContentIframe.location.href =url;
       

    } // end function

    function openDoc(docID)
    {
    
     <%
     	//결재 진행메일에서 바로오는 메뉴 코드 9999 처리
     %>
      if(docID != "" && docID != "9999" ){
	       var lDoc = eval("doc" + docID);
	       if( lDoc.parent != "" ) {
	           var lParent = eval(lDoc.parent);
	           openParent(lParent);
	       } // end if
	       clickDoc(docID, "")
       }
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
	
	function menuSet(){
		<%
		
		
		if(!menuCode.equals("") && menuCode != null){
		%>	
			openDoc("<%=menuCode%>");
			hideIMG("<%=menuCode%>");
			//alert(<%=menuCode%>);
		<%	
		}
		%>
	}
</script>
<link rel="stylesheet" type="text/css" href="<%=WebUtil.ImageURL%>/css/ehr_style.css" media="screen" />
</head>
<body id="leftBody" onload="menuSet()" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0"  style="overflow-x: hidden">
<% 
  MenuICb Menub = new MenuICb();
  MenuIC Menu = new MenuIC(); 
%>

<h2><a href="<%=potalPage %>" target = "menuContentIframe"><span>hr</span></a></h2>
<table width="<%=Menu.masterTableWidth%>"  border="0" cellspacing="0" cellpadding="0"> 
  <tr>
    <td>
        <table width="<%=Menu.masterTableWidth%>" border="0" cellspacing="0" cellpadding="0">
        	
           <%=Menu.writeMenu(vcOMenuCodeData ,"1000" ,"")%>
           	
           <tr><td colspan="2" height="30" background="<%= WebUtil.ImageURL %>leftMenu/.gif" clickedImg="<%= WebUtil.ImageURL %>null" >&nbsp;&nbsp;&nbsp;&nbsp;<b></b></td></tr>
           <tr><td width="0"></td>
           <td>
 <%
 
 //테스트를 위해 potalYN = Y 로 셋팅!! 테스트후 potalYN = N 로 셋팅...........................
 if(potalYN.equals("N")){ %>          
           <table width="161" cellspacing="0" cellpadding="0"><!-- background="<%= WebUtil.ImageURL %>leftMenu/lb03.gif" clickedImg="<%= WebUtil.ImageURL %>leftMenu/lb04.gif"-->
           <!--doc9997--> <tr><td class="lMenu_etc" colspan="2"><a href="#" onClick="open_charge();this.blur();">인사담당자 연락처</a></td></tr>
           
           <!--doc9996--><tr><td class="lMenu_etc" colspan="2"><a href="<%= WebUtil.JspURL %>ruleLink.jsp" target="hidden" onClick="this.blur();">제도안내</a></td></tr>
           <!--doc9999--><tr><td class="lMenu_etc" colspan="2"><a href="<%= WebUtil.JspURL %>helpLink.jsp" target="hidden" onClick="this.blur();">사용방법안내</a></td></tr>
           <!-- doc9995 --><tr><td class="lMenu_etc" colspan="2"><a href="javascript:openFaq()" onClick="this.blur();">FAQ</a></td></tr>
     			 <% if( (user.e_persk).equals("11") || (user.e_persk).equals("12") || (user.e_persk).equals("13") || (user.empNo).equals("00200482") ){ 
								    String elurl = "http://eloffice.lgchem.com:8001/intra/owa/insarule?p_user="+user.empNo; %>
			<tr><td class="lMenu_etcStr" colspan="2" clickedImg="<%= WebUtil.ImageURL %>leftMenu/lb04.gif"><a href="<%=elurl%>" target="hidden" onClick="this.blur();">집행임원인사관리규정</a></td></tr>
					 <% } %>
           </table>
           
           </td></tr>
          
           <tr><td class="lMenu_logout" colspan="2"><a href="/servlet/servlet.hris.LogoutSV" target = "menuContentIframe">로그아웃</a></td></tr>
           <tr><td class="lMenu_logout" colspan="2"><a href="/web/logout2.jsp" target = "menuContentIframe">로그아웃2</a></td></tr>
<%} %>           
            <tr><td colspan="2" id="" class="lmSitemap"><a href="<%= WebUtil.ServletURL %>hris.common.SiteMapSV" target="menuContentIframe" >사이트맵</a></td></tr><!-- 문종민 -->
            <tr><td colspan="2" id="" class="lmSitemap"><a href="<%= WebUtil.ServletURL %>hris.A.A22ExecutiveProfile.A22ExecutiveProfileSV_m" target="menuContentIframe" >임원 profile(임시)</a></td></tr>
        </table>
    </td>
  </tr>
  <tr>
    <td></td>
  </tr>
</table>
<form name="tssform" method="post">
<input type="hidden" name="sMenuCode" value="">
<input type="hidden" name="sMenuText" value="">
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
