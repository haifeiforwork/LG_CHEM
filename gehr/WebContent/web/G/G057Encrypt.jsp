<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : 인화원암호화                                                */
/*   2Depth Name  : 교육과정조회                                                */
/*   Program Name : 교육과정조회                                                */
/*   Program ID   : G057Encrypt                                                 */
/*   Description  :                                                             */
/*   Note         : 없음                                                        */
/*   Creation     : 2008-08-28  LSA                                             */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %> 
<%@ page import="java.net.*" %>
<%@ page import="hris.common.util.*" %>
<%@ page import="hris.common.*" %>
<%@ page import="com.sns.jdf.util.*" %> 
<%@ page import="hris.common.rfc.*" %>
<%
    String CRS_MGM_SCH_N = request.getParameter("CRS_MGM_SCH_N");
    String HRD_OBJID     = request.getParameter("HRD_OBJID");
    String HRD_APPYN     = request.getParameter("HRD_APPYN");  
    String PERNR         = request.getParameter("PERNR");  

    PersonInfoRFC numfunc        = new PersonInfoRFC();
    PersonData phonenumdataT;
    phonenumdataT = (PersonData)numfunc.getPersonInfo(PERNR);
    String EncryptREGNO = WebUtil.encode(phonenumdataT.E_REGNO);
      
%>

<script language="javascript" src="<%= WebUtil.ImageURL %>js/object.js"></script>
<script language="JavaScript" runat=server>
    function f_detail_view_in(hrdobjid, objid ) {

    	parent.document.formLink.CRS_MGM_SCH_N.value = objid;
    	parent.document.formLink.HRD_OBJID.value = hrdobjid;
    	parent.document.formLink.HRD_APPYN.value = "N";
    	parent.document.formLink.SEC_RES_RG_N.value = encrypt("<%=EncryptREGNO%>");
        small_window=window.open("","InHwaWon1","toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=yes,scrollbars=yes,width=800,height=600,left=0,top=0");
        small_window.focus();
    
        // parent.document.formLink.action = "http://lms.lgacademy.com/user/aspsub/enroll/UECCRX02I_lgchem_sec.asp?CRS_MGM_SCH_N"+objid+"&HRD_OBJID="+hrdobjid+"&HRD_APPYN=N&SEC_RES_RG_N="+encrypt("<%=EncryptREGNO%>");
         parent.document.formLink.action = "http://lms.lgacademy.com/user/aspsub/enroll/UECCRX02I_lgchem_sec.asp";
        //vObj.action = "http://lms.lgacademy.com/user/aspsub/enroll/UECCRX02I_lgchem.asp";  
          
        parent.document.formLink.target = "InHwaWon1";
        parent.document.formLink.submit();
        
    }
    f_detail_view_in("<%=HRD_OBJID%>","<%=CRS_MGM_SCH_N%>");
 </SCRIPT>
<form name="formLink" method="post" action=""> 
<input type="hidden" name="CRS_MGM_SCH_N" value=""><!--인화원 -->
<input type="hidden" name="HRD_OBJID"     value="">
<input type="hidden" name="HRD_APPYN"     value=""><!--인화원 신청버튼유무 --> 
<input type="hidden" name="pageGubun"     value=""><!--인화원 신청버튼유무 --> 
<input type="hidden" name="SEC_RES_RG_N"  value=""><!--인화원 신청버튼유무 --> 
</form>