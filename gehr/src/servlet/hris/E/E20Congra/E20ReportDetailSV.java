package servlet.hris.E.E20Congra;

import java.io.*;
import java.sql.*;
import java.util.Vector;
import javax.servlet.*;
import javax.servlet.http.*;

import com.sns.jdf.*;
import com.sns.jdf.db.*;
import com.sns.jdf.util.*;
import com.sns.jdf.servlet.*;

import hris.common.*;
import hris.E.E20Congra.*;
import hris.E.E20Congra.rfc.*;

/**
 * E20ReportDetailSV.java
 * 재해 피해 신고서 조회 하는 Class
 *
 * @author 박영락   
 * @version 1.0, 2001/12/20
 */
public class E20ReportDetailSV extends EHRBaseServlet {

    //private String UPMU_TYPE ="12";

	protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        //Connection con = null;

        try{
            HttpSession session = req.getSession(false);
            WebUserData user = WebUtil.getSessionUser(req);
            String dest  = "";
            Box box = WebUtil.getBox(req);
            String CONG_DATE = box.get("CONG_DATE");
            Logger.debug.println( this, "[user] : " + user.toString() + " CONG_DATE " + CONG_DATE );
            Vector E20DisasterData_vt = ( new E20DisaDisplayRFC() ).getDisaDisplay( user.empNo, CONG_DATE );
            req.setAttribute( "E20DisasterData_vt", E20DisasterData_vt );
            dest = WebUtil.JspURL+"E/E20Congra/E20ReportDetail.jsp";
            Logger.debug.println(this, " destributed = " + dest);
            printJspPage(req, res, dest);

        } catch(Exception e) {
            throw new GeneralException(e);
        } finally {
        }
	}
}