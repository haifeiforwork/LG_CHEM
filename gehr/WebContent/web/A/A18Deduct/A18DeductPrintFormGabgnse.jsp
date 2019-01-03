<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="hris.A.A18Deduct.rfc.*" %>
<%@ page import="hris.A.A18Deduct.rfc.A18DeductPrintGabgnseBinaryRFC" %>
<%@ page contentType="text/html; charset=utf-8" %>

<!-- ************************** 갑근세PDF. jsp  ************************-->
<!------------------------------------------------------------------------------>
<!-- System Name  : ESS                                                       -->
<!-- 1Depth Name  : 원천징수영수증                                            -->
<!-- 2Depth Name  : 원천징수영수증 신청                                       -->
<!-- Program Name : 원천징수영수증 신청                                       -->
<!-- Program ID   : A18DeductPrintFormEmbedGabgnse.jsp                        -->
<!-- Description  : 갑근세 출력화면 RFC 직접호출                              -->
<!-- Note         : 없음                                                      -->
<!-- Creation     :                                                           -->
<!-- Update       : 2012-07-23  lsa                                           -->
<!-- --------------------------------------------------------------------------->
<!-- DATE      AUTHOR                 DESCRIPTION                             -->
<!-- --------------------------------------------------------------------------->
<!--    ESS 갑근세 출력 PDF 변환                                              -->
<!--  2017-05-25 eunha [CSR ID:3390354] 인사시스템 보안점검 미준수 사항 조치   -->
<!------------------------------------------------------------------------------>
<%
     // Get Parameter from Request
     String sPerNR      = (String) request.getParameter("sPerNR");
     String sTargetYear = (String) request.getParameter("sTargetYear");
     String sAinfSeqn   = (String) request.getParameter("sAinfSeqn");


     try {
         // Call RFC
          A18DeductPrintGabgnseBinaryRFC  rfc = new A18DeductPrintGabgnseBinaryRFC();
          Vector result = new Vector();
          result = rfc.getData(sPerNR, sAinfSeqn );
        //[CSR ID:3390354] 인사시스템 보안점검 미준수 사항 조치 start
          //System.out.println(result.size());
        //[CSR ID:3390354] 인사시스템 보안점검 미준수 사항 조치 end
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

      }

%>