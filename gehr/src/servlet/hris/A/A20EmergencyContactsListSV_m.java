/********************************************************************************/
/*	  System Name  	: g-HR                                                														
/*   1Depth Name  	: Employee Data                                                  														
/*   2Depth Name  	: Personal Data                                                    																                                                 
/*   Program Name 	: Emergency Contacts                                              
/*   Program ID   		: A20EmergencyContactsListSV_m.java
/*   Description  		: 부서원의 비상연락망을 조회 할 수 있도록 하는 Class [USA]                         
/*   Note         		:                                                            
/*   Creation     		: 2010-09-30 jungin                                      
/********************************************************************************/

package servlet.hris.A;

import com.sns.jdf.GeneralException;
import com.sns.jdf.util.WebUtil;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class A20EmergencyContactsListSV_m extends A20EmergencyContactsListSV {

	protected void performTask(HttpServletRequest req, HttpServletResponse res)
			throws GeneralException {

		if(!checkAuthorization(req, res)) return;

		if (process(req, res, WebUtil.getSessionMSSUser(req), "M"))
			printJspPage(req, res, WebUtil.JspURL + "A/A20EmergencyContactsList.jsp");
		
	}
	
}
