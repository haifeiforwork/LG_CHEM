<%@ page import="com.sns.jdf.Logger" %>
<%@ page import="hris.A.A18Deduct.rfc.A18DeductPrintGunroSodukBinaryRFC" %>
<%@ page import="java.io.BufferedOutputStream" %>
<%@ page import="java.util.Hashtable" %>
<%@ page import="java.util.Vector" %>
<%@ page contentType="text/html; charset=utf-8" %>

<!-- ************************** 원천징수영수증PDF. jsp  ************************-->
<!------------------------------------------------------------------------------>
<!-- System Name  : ESS                                                       -->
<!-- 1Depth Name  : 제증명서                                                                                                       -->
<!-- 2Depth Name  : 제증명서 신청                                                                                                -->
<!-- Program Name : 제증명서 신청                                                                                                -->
<!-- Program ID   : A18DeductPrintFormEmbedGunrosoduk.jsp                     -->
<!-- Description  : 원천징수 영수증 출력화면 RFC 직접호출                                                        -->
<!-- Note         : 없음                                                                                                             -->
<!-- Creation     :                                                           -->
<!-- Update       : 2010-04-09  지민재                                                                                  -->
<!-- --------------------------------------------------------------------------->
<!-- DATE      AUTHOR                 DESCRIPTION                             -->
<!-- ------------------------------------------------------------------------ -->   
<!-- 2010.04.09 지민재  [CSR ID:1639484] ESS 원천징수 영수증 출력 PDF 변환                        -->                      
<!------------------------------------------------------------------------------>
<%
     // Get Parameter from Request
     String sPerNR      = (String) request.getParameter("sPerNR");
     String sTargetYear = (String) request.getParameter("sTargetYear");
     String sAinfSeqn   = (String) request.getParameter("sAinfSeqn");

     try {
         // Call RFC
         A18DeductPrintGunroSodukBinaryRFC  rfc = new A18DeductPrintGunroSodukBinaryRFC();
         Vector result = new Vector();
         result = rfc.getData(sPerNR, sAinfSeqn);

          
         BufferedOutputStream outs = new BufferedOutputStream(response.getOutputStream());
         response.setHeader("Content-Type", "application/pdf");
         response.setHeader("Content-Transfer-Encoding", "binary");
         response.setHeader("Pragma","no-cache");
         response.setDateHeader("Expires",0);

         for(int i = 0; i < result.size(); i++) {
         	 Hashtable data = new Hashtable();
         	 byte[] buffer = new byte[255];
         	 data = (Hashtable) result.get(i);
         	 buffer = (byte[]) data.get("LINE");
         	 outs.write(buffer);
         }
         outs.close();


      } catch(Exception ex) {
         Logger.error(ex);

      }
%>