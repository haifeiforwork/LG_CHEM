/********************************************************************************/
/*	  System Name  	: g-HR                                                														
/*   1Depth Name  	: Personal HR Info                                                  														
/*   2Depth Name  	: Personal Info                                                    																                                                  
/*   Program Name 	: Emergency Contacts                                              
/*   Program ID   		: A20EmergencyContactsListSV.java
/*   Description  		: 비상연락망을 조회하는 Class [USA]                         
/*   Note         		:                                                            
/*   Creation     		: 2010-09-30 jungin                                      
/********************************************************************************/

package servlet.hris.A;

import com.sns.jdf.GeneralException;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.WebUtil;
import hris.A.A20EmergencyContactsData;
import hris.A.rfc.A20EmergencyContactsRFC;
import hris.common.WebUserData;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Vector;

public class A20EmergencyContactsListSV extends EHRBaseServlet {

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {

        if (process(req, res, WebUtil.getSessionUser(req), "E"))
            printJspPage(req, res, WebUtil.JspURL + "A/A20EmergencyContactsList.jsp");
    }

    public boolean process(HttpServletRequest req, HttpServletResponse res, WebUserData user_m, String pageType) throws GeneralException {

        try {

            String I_CFORM = (String) req.getAttribute("I_CFORM");

            A20EmergencyContactsRFC func1 = new A20EmergencyContactsRFC();
            Vector<A20EmergencyContactsData> resultList = func1.getEmergencyContactList(user_m.empNo);

            req.setAttribute("emergencyList", resultList);

            req.setAttribute("pageType", pageType);
            req.setAttribute("user", user_m);

            return true;
        } catch (Exception e) {
            throw new GeneralException(e);
        }
    }
}