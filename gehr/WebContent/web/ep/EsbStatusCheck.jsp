<%
    /******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  :                                                             */
/*   2Depth Name  :                                                             */
/*   Program Name :                                                             */
/*   Program ID   : EsbStatusCheck.jsp                                          */
/*   Description  : ESB전자결재와 연동시 오류건에 대하여 전자결재시스템에서     */
/*                수작업모니터링확인후 UPDATE처리하기 위해 현상태값을 RETURN한다*/
/*   Note         : 없음                                                        */
/*   Creation     : 2009-07-23 LSA                                              */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/
%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.lang.*" %>
<%@ page import="com.sns.jdf.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%@ page import="hris.common.util.AppUtil.*" %>
<%@ page import="hris.common.AppLineData" %>
<%@ page import="com.sns.jdf.util.WebUtil" %>
<%@ page import="com.sns.jdf.sap.SAPType" %>

<%

    Logger.debug("--------------------------- EsbStatusCheck.jsp start --------------------------- ");

    String app_id = WebUtil.nvl(request.getParameter("app_id"), ""); //결재문서번호
    String a_empno = WebUtil.nvl(request.getParameter("a_empno"), "");//현재결재대기자사번

    Logger.debug("app_id : " + app_id + " , a_empno : " + a_empno);


    Vector vcAppLineData;
    try {

        SAPType sapType = WebUtil.getSAPTypeFormApproval(app_id);
        vcAppLineData = hris.common.util.AppUtil.getAppChangeVt(app_id);
        String CURR_YN = ""; //현재결재자 여부
        boolean FLAG = false;
        for (int i = 0; i < vcAppLineData.size(); i++) {

            AppLineData apl = (AppLineData) vcAppLineData.get(i);

            if (apl.APPL_PERNR.equals(a_empno) && apl.APPL_APPR_STAT.equals("") && FLAG == false) {
                CURR_YN = "Y"; //현재결재자가 맞으면 TRUE면 Y

                Logger.debug("CURR_YN : " + CURR_YN);
%>
<%=CURR_YN%>
<%
                FLAG = true;
            } else {
                /* 해외 일경우 주재원일 경우 국내 사번이 넘어옴*/
                if (!sapType.isLocal()) {
                    EmpListRFC empListRFC = new EmpListRFC(sapType);
                    Vector<EmpData> empList = empListRFC.getEmpList(a_empno); // 해외 사번을 찾아온다

                    EmpData empData = empListRFC.findEmpData(empList, apl.APPL_PERNR);  //결재라인과 동일 대상자 정보

                    //해당 사번에 결재 상태 다시 확인
                    if (empData != null && apl.APPL_PERNR.equals(empData.PERNR) && apl.APPL_APPR_STAT.equals("") && FLAG == false) {
                        CURR_YN = "Y"; //현재결재자가 맞으면 TRUE면 Y
                        FLAG = true;
                        Logger.debug("global CURR_YN : " + CURR_YN);
%>
<%=CURR_YN%>
<%
                    }
                }
            }
        }
    } catch (Exception ex) {
        Logger.error(ex);
        //Logger.debug.println("Config에러 : "+ex.toString());
    }
    Logger.debug("--------------------------- EsbStatusCheck.jsp end --------------------------- ");
%>
