<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="hris.D.D03Vocation.*" %>
<%@ page import="hris.D.D03Vocation.rfc.*" %>

<%
    String i_stdDate = request.getParameter("i_stdDate");
    String i_awart   = request.getParameter("i_awart");
    String i_pernr   = request.getParameter("i_pernr");
    String i_index   = request.getParameter("i_index");
Logger.debug.println(this, "##################### i_stdDate : " + i_stdDate);
Logger.debug.println(this, "##################### i_awart : " + i_awart);
Logger.debug.println(this, "##################### i_pernr : " + i_pernr);
    D03WorkPeriodRFC  rfcWork      = new D03WorkPeriodRFC();
    Vector            d03WPData_vt = rfcWork.getWorkPeriod( i_pernr, i_stdDate, i_stdDate );
    D03WorkPeriodData d03WPData    = new D03WorkPeriodData();
    if( d03WPData_vt.size() > 0 ) {
        d03WPData = (D03WorkPeriodData)d03WPData_vt.get(0);
    }
    
    D03RemainVocationRFC  rfc  = new D03RemainVocationRFC();
    D03RemainVocationData data = (D03RemainVocationData)rfc.getRemainVocation(i_pernr, i_stdDate);
//    double p_remain            = Double.parseDouble(data.P_REMAIN);
    double p_remain            = Double.parseDouble(data.P_REMAIN)
                               + Double.parseDouble(data.P_BE_ALLO)       // 사전부여휴가 잔여일수 합산
                               + Double.parseDouble(data.P_SELECT_C);     // 선택적보상휴가 잔여일수 합산
    double p_vacation          = Double.parseDouble(data.P_VACATION);

    String message             = "";    
    int    day_count           = 1;       // 신청기간은 1일로한다.
    int    count               = 0;       // 근무일정이 있는 날 count
    long   beg_time            = 0;
    long   end_time            = 0;
    long   work_time           = 0;

    if( i_awart.equals("0110") ) {        // 전일휴가..
//      신청기간 일자수를 구한다.
        // 근무시간 계산
        beg_time                    = Long.parseLong(d03WPData.BEGUZ);
        end_time                    = Long.parseLong(d03WPData.ENDUZ);
        
        work_time                   = end_time - beg_time;
        if( work_time > 40000 ) {
            count++;
        }
        
        if( count == day_count ) {
            if( count > p_remain ) {
                message = "휴가신청일수가 잔여휴가일수보다 많습니다.";
            } else if( count == 0 ) {
                message = "신청기간에 근무일정이 존재하지 않습니다.";
            }
        } else {
            message = "전일휴가는 근무일정이 있는 평일에만 신청가능합니다.";
        }

    } else if( i_awart.equals("0120") ) { // 반일휴가..
        // 근무시간 계산
        beg_time                    = Long.parseLong(d03WPData.BEGUZ);
        end_time                    = Long.parseLong(d03WPData.ENDUZ);
            
        work_time                   = end_time - beg_time;
        if( work_time > 40000 ) {
            count++;
            if( count > p_remain ) {
               message = "휴가신청일수가 잔여휴가일수보다 많습니다.";
            }
        } else {
            message = "반일휴가는 근무일정이 있는 평일에만 신청가능합니다.";
        }

    } else if( i_awart.equals("0122") ) {     // 토요휴가..
        // 근무시간 계산
        beg_time                    = Long.parseLong(d03WPData.BEGUZ);
        end_time                    = Long.parseLong(d03WPData.ENDUZ);
            
        work_time                   = end_time - beg_time;

//------장치교대근무자인지 체크하고 장치교대근무자이면 신청을 막는다.(2002.05.29)
        D03ShiftCheckRFC func_shift = new D03ShiftCheckRFC();
        String           shiftCheck = func_shift.check(i_pernr, i_stdDate);
        if( shiftCheck.equals("1") ) {
            message = "휴가 신청일은 일일근무일정이 장치교대조로 토요휴가를 신청할수 없습니다.";
        } else {
//------장치교대근무자인지 체크하고 장치교대근무자이면 신청을 막는다.
            if( work_time >= 40000 ) {
                count++;

                if( count > p_remain ) {
                    message = "휴가신청일수가 잔여휴가일수보다 많습니다.";
                }
            } else {
                message = "토요휴가는 근무일정이 있는 토요일에만 신청가능합니다.";
            }
        }        

    } else if( i_awart.equals("0130") ) { // 경조휴가
        // 근무시간 계산
        beg_time                    = Long.parseLong(d03WPData.BEGUZ);
        end_time                    = Long.parseLong(d03WPData.ENDUZ);
            
        work_time                   = end_time - beg_time;
        if( work_time >= 40000 ) {
            count++;
        }
        
        if( count == 0 ) {
            message = "신청기간에 근무일정이 존재하지 않습니다.";
        }
        
    } else if( i_awart.equals("0140") ) { // 하계휴가..
//      신청가능한 하계휴가일수가 존재하는지 check한다.
        if( p_vacation < 1 ) {
            message = "하계휴가 잔여일수가 존재하지 않습니다.";
        } else {
        
//          하계휴가 사용일수를 가져간다.
            D03VacationUsedRFC    rfcVacation           = new D03VacationUsedRFC();
            double                E_ABRTG               = Double.parseDouble( rfcVacation.getE_ABRTG(i_pernr) );
//----------------------------------------------------------------------------------------------------

            // 근무시간 계산
            beg_time                    = Long.parseLong(d03WPData.BEGUZ);
            end_time                    = Long.parseLong(d03WPData.ENDUZ);
                
            work_time                   = end_time - beg_time;
            if( work_time >= 40000 ) {
                count++;
            }
    
            if( (count + E_ABRTG) > 5 ) {
                message = "하계휴가는 5일 이하로 신청 가능합니다. 현재 사용한 하계휴가 일수는 " + WebUtil.printNumFormat(E_ABRTG) + "일 입니다.";
            } else if( count == 0 ) {
                message = "신청기간에 근무일정이 존재하지 않습니다.";
            }
        }

    } else if( i_awart.equals("0170") ) { // 전일공가..
        // 근무시간 계산
        beg_time                    = Long.parseLong(d03WPData.BEGUZ);
        end_time                    = Long.parseLong(d03WPData.ENDUZ);
            
        work_time                   = end_time - beg_time;
        if( work_time >= 40000 ) {
            count++;
        }
        
        if( count == 0 ) {
            message = "신청기간에 근무일정이 존재하지 않습니다.";
        }

    } else if( i_awart.equals("0150") ) { // 보건휴가..
//      결근한도에 보건휴가 쿼터가 존재할때만 신청가능하도록 체크한다.
        D03MinusRestRFC func_0150 = new D03MinusRestRFC();
        String          e_anzhl   = func_0150.getE_ANZHL(i_pernr, i_stdDate);
        double          d_anzhl   = Double.parseDouble(e_anzhl);
        
        if( d_anzhl > 0.0 ) {
            // 근무시간 계산
            beg_time                    = Long.parseLong(d03WPData.BEGUZ);
            end_time                    = Long.parseLong(d03WPData.ENDUZ);
                    
            work_time                   = end_time - beg_time;
            if( work_time < 40000 ) {
                message = "신청기간에 근무일정이 존재하지 않습니다.";
            }
                
            // 휴무일수 계산
            if( work_time >= 40000 ) {
                count++;
            }
        } else {
            message = "잔여(보건) 휴가가 없습니다.";
        }

    } else if( i_awart.equals("0340") ) {        // 휴일비근무..
        String chk_0340 = "";
//      휴일이면서 근무일정이 있을때만 휴일비근무 신청 가능하다. CHK_0340 = 'Y'인 경우
        chk_0340 = d03WPData.CHK_0340;
            
        if( !chk_0340.equals("Y") ) {
            message = "휴일비근무는 근무일정이 있는 휴일에만 신청가능합니다.";
        }
    }

%>

<SCRIPT>
  if( "<%= message %>" != "" ) {
    alert("<%= message %>");
    parent.menuContentIframe.endPage.document.form1.AWART1<%= i_index %>.value = "";
    parent.menuContentIframe.endPage.document.form1.BEGUZ1<%= i_index %>.disabled=0;
    parent.menuContentIframe.endPage.document.form1.ENDUZ1<%= i_index %>.disabled=0;
    parent.menuContentIframe.endPage.document.form1.BEGUZ2<%= i_index %>.disabled=0;
    parent.menuContentIframe.endPage.document.form1.ENDUZ2<%= i_index %>.disabled=0;
    parent.menuContentIframe.endPage.document.form1.BEGUZ3<%= i_index %>.disabled=0;
    parent.menuContentIframe.endPage.document.form1.ENDUZ3<%= i_index %>.disabled=0;
    parent.menuContentIframe.endPage.document.form1.ENDUZ2_IKIL<%= i_index %>.disabled=0;
    parent.menuContentIframe.endPage.document.form1.BEGUZ3_IKIL<%= i_index %>.disabled=0;
    parent.menuContentIframe.endPage.document.form1.ENDUZ3_IKIL<%= i_index %>.disabled=0;
    parent.menuContentIframe.endPage.document.form1.STDAZ<%= i_index %>.disabled=0;
    parent.menuContentIframe.endPage.document.form1.BEGUZ1<%= i_index %>.style.backgroundColor='#FFFFFF';
    parent.menuContentIframe.endPage.document.form1.ENDUZ1<%= i_index %>.style.backgroundColor='#FFFFFF';
    parent.menuContentIframe.endPage.document.form1.BEGUZ2<%= i_index %>.style.backgroundColor='#FFFFFF';
    parent.menuContentIframe.endPage.document.form1.ENDUZ2<%= i_index %>.style.backgroundColor='#FFFFFF';
    parent.menuContentIframe.endPage.document.form1.BEGUZ3<%= i_index %>.style.backgroundColor='#FFFFFF';
    parent.menuContentIframe.endPage.document.form1.ENDUZ3<%= i_index %>.style.backgroundColor='#FFFFFF';
    parent.menuContentIframe.endPage.document.form1.STDAZ<%= i_index %>.style.backgroundColor='#FFFFFF';
  }
</SCRIPT>
