<%/******************************************************************************/
/*   Update       : 2017-04-21  eunha    [CSR ID:3363700] 통합결재 오류 건 수정                                                 */
/********************************************************************************/%>


<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="commonProcess.jsp" %>
<%@ page import="hris.common.DraftDocForEloffice" %>
<%@ page import="hris.common.ElofficInterfaceData" %>
<%@ page import="java.util.Hashtable" %>
<%@ page import="com.lgchem.esb.adapter.ESBAdapter" %>
<%@ page import="com.lgchem.esb.adapter.LGChemESBService" %>
<%@ page import="com.lgchem.esb.exception.ESBTransferException" %>
<%@ page import="com.lgchem.esb.exception.ESBValidationException" %>
<%@ page import="org.apache.commons.lang.time.DateFormatUtils" %>
<%@ page import="hris.common.rfc.EmpListRFC" %>
<%@ page import="hris.common.rfc.PersonInfoRFC" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<%
    String msg = (String)request.getAttribute("msg");
    String msg2 = (String)request.getAttribute("msg2");
    String url = (String)request.getAttribute("url");
    String message = "";
    if (msg != null) {
        msg = msg.toLowerCase();
        if ( msg.substring(0,3).equals("msg") ) {
            if( msg.equals("msg001") ) {
                message = g.getMessage("MSG.COMMON.0001"); //신청 되었습니다.
            } else if( msg.equals("msg002") ) {
                message = g.getMessage("MSG.COMMON.0002"); //수정 되었습니다.
            } else if( msg.equals("msg003") ) {
                message = g.getMessage("MSG.COMMON.0003"); //삭제 되었습니다.
            } else if( msg.equals("msg004") ) {
                message = g.getMessage("MSG.COMMON.0004"); //해당하는 데이타가 존재하지 않습니다.
            } else if( msg.equals("msg005") ) {
                message = g.getMessage("MSG.COMMON.0005"); //결재가 진행중 입니다.
            } else if( msg.equals("msg006") ) {
                message = g.getMessage("MSG.COMMON.0006"); //계좌번호가 등록되지 있지 않습니다.
            } else if( msg.equals("msg007") ) {
                message = g.getMessage("MSG.COMMON.0007"); //입력 되었습니다.
            } else if( msg.equals("msg008") ) {
                message = g.getMessage("MSG.COMMON.0008"); //저장 되었습니다.
            } else if( msg.equals("msg009") ) {
                message = g.getMessage("MSG.COMMON.0009"); //결재 되었습니다.
            } else if( msg.equals("msg010") ) {
                message = g.getMessage("MSG.COMMON.0010"); //반려 되었습니다.
            } else if( msg.equals("msg011") ) {
                message = g.getMessage("MSG.COMMON.0011"); //결재 취소 되었습니다.
            } // end if
        } else {
            message = msg;
        } // end if
    } // end if

    if (msg2 != null && !msg2.equals("")) {
        message = message + "\\n" +msg2;
    } // end if

    WebUserData user = WebUtil.getSessionUser(request);
    Vector vcEof = (Vector) request.getAttribute("vcElofficInterfaceData");
    Configuration conf = new Configuration();
    boolean isDev = conf.getBoolean("com.sns.jdf.eloffice.ISDEVELOP");
    isDev=false;
%>
<%  for (int i = 0; i < vcEof.size(); i++) { %>
<%  ElofficInterfaceData  eof = (ElofficInterfaceData)vcEof.get(i);

    try {
        Logger.debug("---------------- DraftDocForEloffice start ");
        DraftDocForEloffice ddfe = new DraftDocForEloffice();
        ESBAdapter esbAp = new LGChemESBService("APPINT_ESB" ,conf.getString("com.sns.jdf.eloffice.ESBInfo") );
        Hashtable appParam = new Hashtable();
        //if ( eof.SUBJECT.equals("의료비")||eof.SUBJECT.equals("부양가족")||eof.SUBJECT.equals("부양 가족 여부")||eof.SUBJECT.equals("장학금/학자금")||eof.SUBJECT.equals("장학금/학자금 신청"))  {

        //   Logger.info.println(this ,"^^^^^ ElOfficeInterface</b>[eof:]"+eof.toString());
        // }

        if(eof.APP_ID.length() > 0)
        {
            if(eof.APP_ID.indexOf("?eHR=") > 0)
                eof.APP_ID = eof.APP_ID.substring(0,10)  ;
        }
        if(eof.URL.length() > 0)
        {
            if(eof.URL.indexOf("?eHR=") > 0)
                eof.URL = eof.URL.replace("?eHR=","")   ;
        }

        Logger.debug("Eloffice add Param start ");
        appParam.put("CATEGORY"     ,eof.CATEGORY     );    //양식명
        appParam.put("MAIN_STATUS"  ,eof.MAIN_STATUS  );    //결재 Main상태
        appParam.put("P_MAIN_STATUS",eof.P_MAIN_STATUS);
        appParam.put("SUB_STATUS"   ,eof.SUB_STATUS   );    //결재 Sub상태
        //appParam.put("REQ_DATE"     ,eof.REQ_DATE     );      //요청일
        String reqDate = DateFormatUtils.format(DataUtil.getDate(request), "yyyyMMddHHmm");
        appParam.put("REQ_DATE"     ,reqDate     );      //요청일
//                appParam.put("REQ_DATE"     ,"9999999999999ddddddd"    );      //요청일
        appParam.put("EXPIRE_DATE"  ,eof.EXPIRE_DATE  );    //보존년한
        appParam.put("AUTH_DIV"     ,eof.AUTH_DIV     );    //공개할부서
        appParam.put("AUTH_EMP"     ,eof.AUTH_EMP     );    //공개할개인
        appParam.put("MODIFY"       ,eof.MODIFY       );    //삭제구분
        appParam.put("F_AGREE"      ,eof.F_AGREE      );    //자동합의

        /* 해외 주재원일 경우 국내 사번을 알아 오기위한 로직 추가 */
        EmpListRFC empListRFC = new EmpListRFC();
        PersonInfoRFC personInfoRFC = new PersonInfoRFC();
       //[CSR ID:3363700] 통합결재 오류 건 수정 START
        String R_EMP_NO = empListRFC.getElofficePERNR(eof.R_EMP_NO);//기안자사번
        String A_EMP_NO = empListRFC.getElofficePERNR(eof.A_EMP_NO);//결재자사번
        //String R_EMP_NO_Mail = personInfoRFC.getPersonInfo(eof.R_EMP_NO).E_MAIL;
        //String A_EMP_NO_Mail = personInfoRFC.getPersonInfo(eof.A_EMP_NO).E_MAIL;
        boolean isEloffice = true;
        if ((!R_EMP_NO.equals("") && R_EMP_NO.equals(eof.R_EMP_NO)&&personInfoRFC.getPersonInfo(R_EMP_NO).E_MAIL.replace("@lgchem.com","").equals(""))
        		||(!A_EMP_NO.equals("") &&A_EMP_NO.equals(eof.A_EMP_NO)&& personInfoRFC.getPersonInfo(A_EMP_NO).E_MAIL.replace("@lgchem.com","").equals(""))){
        	 isEloffice = false;
        }
		appParam.put("R_EMP_NO"     ,R_EMP_NO);    //기안자사번
        appParam.put("A_EMP_NO"     ,A_EMP_NO );    //결재자사번


       // appParam.put("R_EMP_NO"     ,empListRFC.getElofficePERNR(eof.R_EMP_NO)     );    //기안자사번
       // appParam.put("A_EMP_NO"     ,empListRFC.getElofficePERNR(eof.A_EMP_NO)     );    //결재자사번

      //[CSR ID:3363700] 통합결재 오류 건 수정 END
        appParam.put("SUBJECT"      ,eof.SUBJECT      );    //양식제목
        appParam.put("APP_ID"       ,eof.APP_ID       );    //결재문서ID
        appParam.put("URL"	    ,eof.URL          );
        appParam.put("DUMMY1"	    ,eof.DUMMY1       );    //※모바일결재추가 C20110620_07375
        Logger.debug("Eloffice add Param end " + appParam);

        String ret_msg = "";

      //[CSR ID:3363700] 통합결재 오류 건 수정 START
      if( isEloffice ){
      //[CSR ID:3363700] 통합결재 오류 건 수정 END
        if ("D".equals(eof.MODIFY))  {
            // out.println( ret_msg+"<br><b>삭제</b>[appParam:]"+appParam.toString());
            ret_msg = esbAp.modifyESB(appParam);
            Logger.debug("esbAp.modifyESB complete ret_msg : " + ret_msg);
        } else {
            //  out.println( ret_msg+"<br><b>생성</b>[appParam:]"+appParam.toString());
            //   Logger.info.println(this ,"^^^^^ ElOfficeInterface</b>[callESB:] before");
            ret_msg = esbAp.callESB(appParam);
            //    Logger.info.println(this ,"^^^^^ ElOfficeInterface</b>[callESB:] after");
            Logger.debug("esbAp.else complete ret_msg : " + ret_msg);
        }
        String esb_ret_code = ret_msg.substring(0,4);
        //        out.println("<br>[ret_msg:"+ret_msg);
        if (!esb_ret_code.equals("0000"))  {
            message = message+ret_msg + "\\n" + g.getMessage("COMMON.ELOFFICE.FAIL") ;
            //         out.println(ret_msg+"[appParam:]"+appParam.toString());
        }
      //[CSR ID:3363700] 통합결재 오류 건 수정 START
	 }else{

		 Logger.debug("skip esbAp-------------------통합결재연동안됨");
	 }
    //[CSR ID:3363700] 통합결재 오류 건 수정 END
    }catch (ESBValidationException eV){
        Logger.err.println("------ ESB ERROR ------------- ");
        Logger.error(eV);
    }catch (ESBTransferException eT){
        Logger.err.println("------ ESB ERROR ------------- ");
        Logger.error(eT);
    }catch (Exception e) {
        Logger.err.println("------ ESB ERROR ------------- ");
        Logger.error(e);
    }

} // end for
%>
<jsp:include page="/include/header.jsp"/>
<script language='javascript'>


    // 메시지
    function show_waiting_smessage(div_id ,message ,isVisible)
    {
        // alert(document.body.scrollLeft + "\t ," + document.body.scrollTop);
        var _x = document.body.clientWidth/2 + document.body.scrollLeft-120;
        var _y = document.body.clientHeight/2 + document.body.scrollTop+50;
        job_message.innerHTML = message;
        document.all[div_id].style.posLeft=_x;
        document.all[div_id].style.posTop=_y;
        document.all[div_id].style.visibility= isVisible ;
    } // end function

    function chkDone()
    {
        show_waiting_smessage("waiting" ,"" ,'hidden')
        alert('<%= message %>');
        <%= url %>;
    }

    function init()
    {
        //@v1.1 : 06.05.11 전자결재삭제하기로 함
        /*chkDone();*/

        setTimeout("chkDone()" ,1500);
    }

</script>
</HEAD>
<BODY  <%= isDev ? "" : "onload='init();'" %>>
<DIV id="waiting" style="Z-INDEX: 1; LEFT: 250px; VISIBILITY: visible; WIDTH: 250px; POSITION: absolute; TOP: 200px; HEIGHT: 45px">
    <TABLE cellSpacing=1 cellPadding=0 width="98%" bgColor=black border=0>
        <TBODY>
        <TR bgColor=white>
            <TD>
                <TABLE cellSpacing=0 cellPadding=0 width="100%" border=0>
                    <TBODY>
                    <TR>
                        <TD class=icms align=middle height=70 id = "job_message"><spring:message code='MSG.COMMON.0069' /><!-- 통합결재 연동중 ... <br>잠시만 기다려주십시요 --> </TD>
                    </TR>
                    </TBODY>
                </TABLE>
            </TD>
        </TR>
        </TBODY>
    </TABLE>
</DIV>
<% if (isDev) {%>
<a href="javascript:init()"> <spring:message code='MSG.COMMON.0068' /><!-- Eloffic 연동 --> </a>
<% } // end if %>

</body>
</html>
</BODY>
<jsp:include page="/include/footer.jsp"/>
