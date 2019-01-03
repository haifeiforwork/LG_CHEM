<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="hris.D.D03Vocation.*" %>
<%@ page import="hris.D.D03Vocation.rfc.*" %>

<%
    WebUserData           user          = (WebUserData)session.getAttribute("user");
    
    D03WorkPeriodRFC      rfcWork       = new D03WorkPeriodRFC();
                
    String                APPL_FROM     = request.getParameter("APPL_FROM");
    String                APPL_TO       = request.getParameter("APPL_TO");
    
    Vector                WorkPeriod_vt = rfcWork.getWorkPeriod( user.empNo, APPL_FROM, APPL_TO );

    long                  beg_time      = 0;
    long                  end_time      = 0;
    long                  work_time     = 0;
    int                   count         = 0;

    for( int i = 0 ; i < WorkPeriod_vt.size() ; i++ ) {
        D03WorkPeriodData d03WorkPeriodData = (D03WorkPeriodData)WorkPeriod_vt.get(i);
                        
//      근무시간 계산
        beg_time                    = Long.parseLong(d03WorkPeriodData.BEGUZ);
        end_time                    = Long.parseLong(d03WorkPeriodData.ENDUZ);
                    
        work_time                   = end_time - beg_time;
        if( work_time >= 40000 ) {
            count++;
        }
    }
%>

<SCRIPT>
    parent.main_ess.document.form1.DEDUCT_DATE.value    = "<%= count + " " %>";     
</SCRIPT>
