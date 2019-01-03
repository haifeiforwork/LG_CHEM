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
 *  ������ ���� ��Ȳ�� ���¸� �� �� �ֵ��� �ϴ� Class
 *
 * @author ������
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
                if (s_month.equals("��ü") ) {
                    s_month = "";
                } else {
                    s_month = DataUtil.fixEndZero(s_month,2);
                }

                String s_yearMonth = s_year + s_month;

                if (s_mgart.equals("ALL") ) {  // ������ ��ü ���ý�
                    s_mgart = "";
                }

                returnAll_vt = rfc.detail(user.empNo, "", s_infty,s_yearMonth);

                E31InfoNameData_vt   = (Vector)returnAll_vt.get(0);

                req.setAttribute("MGART",   s_mgart);
                req.setAttribute("E31InfoNameData_vt",   E31InfoNameData_vt);

                dest = WebUtil.JspURL+"E/E31InfoStatus/E31Hidden.jsp";

            } else if( jobid.equals("search") ) {

                String s_year  = box.get("YEAR");   // ��
                String s_month = box.get("MONTH");  // ��
                String s_mgart = box.get("MGART");  // �������ڵ�
                String s_stext = box.get("STEXT");  // �����ָ�
                String s_infty = box.get("INFTY");  // ��ü(2), ������(0), Ż����(1)
                if (s_month.equals("��ü")  || s_month.equals("") ) {
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
                req.setAttribute("YEAR",  s_year );  // ��
                req.setAttribute("MONTH", s_month);  // ��
                req.setAttribute("MGART", s_mgart);  // �������ڵ�
                req.setAttribute("STEXT", s_stext);  // �����ָ�
                req.setAttribute("INFTY", s_infty);  // ��ü(2), ������(0), Ż����(1)

                if ( s_infty.equals("2") ) {   //��ü
                    dest = WebUtil.JspURL+"E/E31InfoStatus/E31InfoStatusAll.jsp";
                } else if ( s_infty.equals("0") || s_infty.equals("1") ) {   // ������ or Ż����
                    dest = WebUtil.JspURL+"E/E31InfoStatus/E31InfoStatusPart.jsp";
                }

            } else if( jobid.equals("exceldown1") ) {  // ��ü ���ý� Excel Download

                String s_year  = box.get("YEAR");   // ��
                String s_month = box.get("MONTH");  // ��
                String s_mgart = box.get("MGART");  // �������ڵ�
                String s_stext = box.get("STEXT");  // �����ָ�
                String s_infty = box.get("INFTY");  // ��ü(2), ������(0), Ż����(1)
                if (s_month.equals("��ü") || s_month.equals("") ) {
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
                req.setAttribute("S_MGART", s_mgart);  // �������ڵ�
                req.setAttribute("E31InfoMemberData_vt",  E31InfoMemberData_vt);

                dest = WebUtil.JspURL+"E/E31InfoStatus/E31InfoStatusAllExcel.jsp";

            } else if( jobid.equals("exceldown2") ) {  // ������ or Ż���� ���ý� Excel Download

                String s_year  = box.get("YEAR");   // ��
                String s_month = box.get("MONTH");  // ��
                String s_mgart = box.get("MGART");  // �������ڵ�
                String s_stext = box.get("STEXT");  // �����ָ�
                String s_infty = box.get("INFTY");  // ��ü(2), ������(0), Ż����(1)
                if (s_month.equals("��ü") || s_month.equals("") ) {
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
                req.setAttribute("S_MGART", s_mgart);  // �������ڵ�
                req.setAttribute("S_INFTY", s_infty);  // �������ڵ�
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
