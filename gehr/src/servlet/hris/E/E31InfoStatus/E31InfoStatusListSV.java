package servlet.hris.E.E31InfoStatus;

import java.io.*;
import java.sql.*;
import java.util.Vector;
import javax.servlet.*;
import javax.servlet.http.*;

import com.sns.jdf.*;
import com.sns.jdf.util.*;
import com.sns.jdf.servlet.*;

import hris.common.*;
import hris.common.util.*;
import hris.common.rfc.*;
import hris.E.E31InfoStatus.*;
import hris.E.E31InfoStatus.rfc.*;

/**
 * E31InfoStatusListSV.java
 *  인포멀 가입 현황과 상태를 알 수 있도록 하는 Class
 *
 * @author 윤정현
 * @version 1.0, 2004/10/22
 */
public class E31InfoStatusListSV extends EHRBaseServlet {

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        try{
            HttpSession session = req.getSession(false);
            WebUserData user = WebUtil.getSessionUser(req);
            String dest  = "";
            String jobid = "";
            Box box = WebUtil.getBox(req);
            jobid = box.get("jobid","first");
            Logger.debug.println(this, "[jobid] = "+jobid + " [user] : "+user.toString());

            E31InfoStatusRFC  rfc               = new E31InfoStatusRFC();
            E31InfoNameData   e31InfoNameData   = null;
            E31InfoMemberData e31InfoMemberData = null;

            Vector returnAll_vt         = null;
            Vector E31InfoNameData_vt   = null;
            Vector E31InfoMemberData_vt = null;

            if( jobid.equals("first") ) {

                returnAll_vt = rfc.detail(user.empNo, "", "2", DataUtil.getCurrentYear());

                E31InfoNameData_vt  = (Vector)returnAll_vt.get(0);

                req.setAttribute("E31InfoNameData_vt",   E31InfoNameData_vt);

                dest = WebUtil.JspURL+"E/E31InfoStatus/E31InfoStatus.jsp";

            } else if( jobid.equals("hidden") ) {

                String s_year  = box.get("YEAR");
                String s_month = box.get("MONTH");
                String s_mgart = box.get("MGART");
                String s_infty = box.get("INFTY");
                if (s_month.equals("전체") ) {
                    s_month = "";
                } else {
                    s_month = DataUtil.fixEndZero(s_month,2);
                }

                String s_yearMonth = s_year + s_month;

                if (s_mgart.equals("ALL") ) {  // 인포멀 전체 선택시
                    s_mgart = "";
                }

                returnAll_vt = rfc.detail(user.empNo, "", s_infty,s_yearMonth);

                E31InfoNameData_vt   = (Vector)returnAll_vt.get(0);

                req.setAttribute("MGART",   s_mgart);
                req.setAttribute("E31InfoNameData_vt",   E31InfoNameData_vt);

                dest = WebUtil.JspURL+"E/E31InfoStatus/E31Hidden.jsp";

            } else if( jobid.equals("search") ) {

                String s_year  = box.get("YEAR");   // 년
                String s_month = box.get("MONTH");  // 월
                String s_mgart = box.get("MGART");  // 인포멀코드
                String s_stext = box.get("STEXT");  // 인포멀명
                String s_infty = box.get("INFTY");  // 전체(2), 가입자(0), 탈퇴자(1)
                if (s_month.equals("전체")  || s_month.equals("") ) {
                    s_month = "";
                } else {
                    s_month = DataUtil.fixEndZero(s_month,2);
                }

                if (s_mgart.equals("ALL") ) {
                    s_mgart = "";
                }

                String s_yearMonth = s_year + s_month;
                returnAll_vt = rfc.detail(user.empNo, s_mgart, s_infty,s_yearMonth);

                E31InfoMemberData_vt   = (Vector)returnAll_vt.get(1);

                req.setAttribute("E31InfoMemberData_vt",  E31InfoMemberData_vt);
                req.setAttribute("YEAR",  s_year );  // 년
                req.setAttribute("MONTH", s_month);  // 월
                req.setAttribute("MGART", s_mgart);  // 인포멀코드
                req.setAttribute("STEXT", s_stext);  // 인포멀명
                req.setAttribute("INFTY", s_infty);  // 전체(2), 가입자(0), 탈퇴자(1)

                if ( s_infty.equals("2") ) {   //전체
                    dest = WebUtil.JspURL+"E/E31InfoStatus/E31InfoStatusAll.jsp";
                } else if ( s_infty.equals("0") || s_infty.equals("1") ) {   // 가입자 or 탈퇴자
                    dest = WebUtil.JspURL+"E/E31InfoStatus/E31InfoStatusPart.jsp";
                }

            } else if( jobid.equals("exceldown1") ) {  // 전체 선택시 Excel Download

                String s_year  = box.get("YEAR");   // 년
                String s_month = box.get("MONTH");  // 월
                String s_mgart = box.get("MGART");  // 인포멀코드
                String s_stext = box.get("STEXT");  // 인포멀명
                String s_infty = box.get("INFTY");  // 전체(2), 가입자(0), 탈퇴자(1)
                if (s_month.equals("전체") || s_month.equals("") ) {
                    s_month = "";
                } else {
                    s_month = DataUtil.fixEndZero(s_month,2);
                }

                if (s_mgart.equals("ALL") ) {
                    s_mgart = "";
                }

                String s_yearMonth = s_year + s_month;

                returnAll_vt = rfc.detail(user.empNo, s_mgart, s_infty, s_yearMonth);

                E31InfoMemberData_vt   = (Vector)returnAll_vt.get(1);

                req.setAttribute("S_STEXT", s_stext);
                req.setAttribute("S_MGART", s_mgart);  // 인포멀코드
                req.setAttribute("E31InfoMemberData_vt",  E31InfoMemberData_vt);

                dest = WebUtil.JspURL+"E/E31InfoStatus/E31InfoStatusAllExcel.jsp";

            } else if( jobid.equals("exceldown2") ) {  // 가입자 or 탈퇴자 선택시 Excel Download

                String s_year  = box.get("YEAR");   // 년
                String s_month = box.get("MONTH");  // 월
                String s_mgart = box.get("MGART");  // 인포멀코드
                String s_stext = box.get("STEXT");  // 인포멀명
                String s_infty = box.get("INFTY");  // 전체(2), 가입자(0), 탈퇴자(1)
                if (s_month.equals("전체") || s_month.equals("") ) {
                    s_month = "";
                } else {
                    s_month = DataUtil.fixEndZero(s_month,2);
                }

                if (s_mgart.equals("ALL") ) {
                    s_mgart = "";
                }

                String s_yearMonth = s_year + s_month;

                returnAll_vt = rfc.detail(user.empNo, s_mgart, s_infty, s_yearMonth);

                E31InfoMemberData_vt   = (Vector)returnAll_vt.get(1);

                req.setAttribute("S_STEXT", s_stext);
                req.setAttribute("S_MGART", s_mgart);  // 인포멀코드
                req.setAttribute("S_INFTY", s_infty);  // 인포멀코드
                req.setAttribute("E31InfoMemberData_vt",  E31InfoMemberData_vt);

                dest = WebUtil.JspURL+"E/E31InfoStatus/E31InfoStatusPartExcel.jsp";

            }

            Logger.debug.println(this, " destributed = " + dest);
            printJspPage(req, res, dest);

        } catch(Exception e) {
            throw new GeneralException(e);
        }
    }
}
