/*
 * @(#)D13ScheduleChangeSV.java    2009. 03. 20
 *
 * 
 */
package servlet.hris.D.D14PlanWorkTime;

import hris.D.D14PlanWorkTime.rfc.D14WorkScheduleRuleRFC;

import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;

/**
 * D14WorkScheduleRulePopupSV.java
 * 근무일정규칙변경
 *
 * @author 김종서   
 * @version 1.0, 2009/03/25
 */
public class D14WorkScheduleRulePopupSV extends EHRBaseServlet {

	private static final long serialVersionUID = 754780027723196359L;

	 
	protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {
		
		try{
			HttpSession session = req.getSession(false);
			
			String dest = "";//대상경로명
			
			Box box = WebUtil.getBox(req);
            String i_date   = box.get("I_DATE");
            String i_pernr   = box.get("I_PERNR");
            
            //조회기준일자가 없을경우 현재일자를 default로한다.
            if( i_date == null || i_date.equals("") ) {
                i_date = DataUtil.getCurrentDate();
            }
        	
            D14WorkScheduleRuleRFC scheduleRuleRfc = new D14WorkScheduleRuleRFC();
        	Vector ret = scheduleRuleRfc.getScheduleRuleType(i_date, i_pernr);
        	
        	Vector scheduleRuleType_vt = (Vector)ret.get(0);
        	
        	Logger.debug.println("\n--------------scheduleRuleType_vt : "+scheduleRuleType_vt.size());
    		Logger.debug.println("\n--------------scheduleRuleType_vt : "+scheduleRuleType_vt);
    		
    		req.setAttribute("scheduleRuleType_vt", scheduleRuleType_vt);
    		
    		dest = WebUtil.JspURL+"D/D14PlanWorkTime/D14WorkScheduleRulePopup.jsp";
        	
            
            
            printJspPage(req, res, dest);
		}catch(Exception e) {
            throw new GeneralException(e);
        }

	}

}
