<%/******************************************************************************/
/*                                                                              */
/*   System Name  : e-HR	                                                 */
/*   1Depth Name  : HR 결재                                                     */
/*   2Depth Name  : 결재 해야할 문서 리스트                                     */
/*   Program Name : 결재 해야할 문서                                            */
/*   Program ID   : moble_EmpnoGet_imsi.jsp                                     */
/*   Description  : 문서 목록보기                                               */
/*   Note         : 없음                                                        */
/*   Creation     : 2003-03-26  이승희                                          */
/*   Update       : 2003-03-26  이승희                                          */
/*   Update       : 2007-10-17  @v1.0 석유화학이관사번만 결재할문서 11~5일까지막음*/
/*                              @v2.0 결재할문서 메뉴정리                       */
/*                                                                              */
/*   http://165.244.243.190:8081/web/MOBLE_EMPNOGET_IMSI.jsp?emp=00202350&id=0U9LXhDhjjg%2BTCqfFhl8EQ%3D%3D */
/*   http://devlocal.lgchem.com:8089/web/MOBLE_EMPNOGET_IMSI.jsp  */
/********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ page errorPage="/web/err/error.jsp"%>
<%@ page import="java.util.Vector" %>
<%@ page import="com.sns.jdf.util.*" %> 

<%@ page import="com.sns.jdf.mobile.EncryptionTool"%>

<%
        StringBuffer mangerMailTitle = new StringBuffer(512); 
       	mangerMailTitle.append("가나");
       	 out.println("   mangerMailTitle======>"+     mangerMailTitle.length() );  
		String id      = (String)request.getParameter("id");
		String emp      = (String)request.getParameter("emp");
	     out.println("   id======>"+     id);  
	     
	     String  empencrypt ="";
			String url = "";
    try {
     
         String iddecrypt = EncryptionTool.decrypt(id);
         
         out.println(" <br>  iddecrypt======>"+     iddecrypt);   
         
         out.println(" <br>  emp======>"+     emp); 

	  	 	  empencrypt =  EncryptionTool.encrypt(emp);

	 			out.println(" <br>  empencrypt :" +  empencrypt ); 
	  	 	  empencrypt = WebUtil.encode( empencrypt);
	 			out.println(" <br>  empencrypt :" +  empencrypt ); 

    } catch (Exception ex) {

    }
	 
// 	 String EncEmpId="93333";
	 String EncEmpId="00115712";
	 String strFromDate="20161101";
	 String strToDate="20161130";
	 //
// 	 String url="http://devlocal.lgchem.com:8089/servlet/servlet.hris.D.D01OT.D01OTMbReqListSV?empNo=" +  HttpUtility.UrlEncode(EncEmpId, UTF8Encoding.UTF8)  + "&fromDate=" + strFromDate + "&toDate=" + strToDate;
	 
// 	 String url="http://devlocal.lgchem.com:8089/servlet/servlet.hris.D.D01OT.D01OTMbReqListSV?empNo=" + WebUtil.encode(EncryptionTool.encrypt(EncEmpId)) + "&fromDate=" + strFromDate + "&toDate=" + strToDate;

		//-- Begin: 2016/11/18 test*ksc      
		// [휴가신청목록조회][URL]
//		 url = "http://devlocal.lgchem.com:8089/servlet/servlet.hris.D.D03Vocation.D03VocationMbReqListSV?empNo="+empencrypt+"&fromDate=20161101&toDate=20161130";
// 		 url = "http://devlocal.lgchem.com:8089/servlet/servlet.hris.D.D03Vocation.D03VocationMbReqListSV?empNo=RbKvSbMYS6M%2bTCqfFhl8EQ%3d%3d&fromDate=20161101&toDate=20161130";
//	   url="http://localhost:8089/servlet/servlet.hris.MobileApprovalSV?userID=bd6XwV7voGs%3d&mbCode=3lSz7unvyBeHsCnXQkSqCw%3d%3d&apprDocID=0003816549&apprIndex=null&apprType=01&apprComment=&empNo=ljuJo20crEc%2bTCqfFhl8EQ%3d%3d&mbLanguage=kr";
//	   url="http://localhost:8089/servlet/servlet.hris.MobileApprovalSV?userID=bd6XwV7voGs%3d&mbCode=3lSz7unvyBeHsCnXQkSqCw%3d%3d&apprDocID=0003816797&apprIndex=null&apprType=01&apprComment=&empNo=ljuJo20crEc%2bTCqfFhl8EQ%3d%3d&mbLanguage=kr";
	   url="http://devlocal.lgchem.com:8089/servlet/servlet.hris.MobileDetailSV?AINF_SEQN=0003978022&empNo="+WebUtil.encode(EncryptionTool.encrypt(EncEmpId))+"&apprDocID=0003978022][][]";
%>

<html>
<iframe name="ifHidden" width="600" height="500" src="<%=url%>"/>
</html>

