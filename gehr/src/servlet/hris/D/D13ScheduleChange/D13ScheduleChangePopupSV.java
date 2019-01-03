/*
 * @(#)D13ScheduleChangeSV.java    2009. 03. 20
 *
 * Copyright 2007 Hyundai Marine, Inc. All rights reserved
 * Hyundai Marine PROPRIETARY/CONFIDENTIAL
 */
package servlet.hris.D.D13ScheduleChange;

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

import hris.D.D13ScheduleChange.rfc.D13DayScheduleRFC;
import hris.D.D13ScheduleChange.rfc.D13DayWorkScheduleRFC;
import hris.common.WebUserData;

/**
 * D13ScheduleChangeSV.java
 * ���ϱٹ���������
 *
 * @author ������   
 * @version 1.0, 2009/03/20
 */
public class D13ScheduleChangePopupSV extends EHRBaseServlet {

	private static final long serialVersionUID = 754780027723196359L;

	//@SuppressWarnings("deprecation")
	protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {
		
		try{
			HttpSession session = req.getSession(false);
			WebUserData user = WebUtil.getSessionUser(req);
			String dest = "";//����θ�
			
			Box box = WebUtil.getBox(req);
			String i_pernr = box.get("PERNR"); //user.empNo;
            String i_date   = box.get("I_DATE");
            String i_endda   = box.get("I_ENDDA");
            String jobid   = box.get("jobid", "code");
            String rowNum  =  box.get("rowNum");

            
            //��ȸ�������ڰ� ������� �������ڸ� default���Ѵ�.
            if( i_date == null || i_date.equals("") ) {
                i_date = DataUtil.getCurrentDate();
            }
        	
            if(jobid.equals("code")){
	        	D13DayWorkScheduleRFC scheduleTypeRfc = new D13DayWorkScheduleRFC();
	        	Vector ret = scheduleTypeRfc.getScheduleType(i_date,i_pernr);
	        	
	        	Vector scheduleType_vt = (Vector)ret.get(0);
	        	
	        	Logger.debug.println("\n--------------scheduleType_vt : "+scheduleType_vt.size());
	    		Logger.debug.println("\n--------------scheduleType_vt : "+scheduleType_vt);
	
	    		req.setAttribute("scheduleType_vt", scheduleType_vt);
	
	    		req.setAttribute("rowNum", rowNum);
	    		
	    		dest = WebUtil.JspURL+"D/D13ScheduleChange/D13ScheduleChangePopup.jsp";
	    		
            }else if(jobid.equals("schedule")){ // ���ϱٹ����� ��ȸ

            	D13DayScheduleRFC rfc = new D13DayScheduleRFC();
	        	Vector ret = rfc.getScheduleType(i_date, i_endda, i_pernr);
	        	
	        	Vector dayschedule_vt = (Vector)ret.get(0);
	        	
	        	Logger.debug.println("\n------schedule--------dayschedule_vt : "+dayschedule_vt.size());
	    		Logger.debug.println("\n------schedule--------dayschedule_vt : "+dayschedule_vt);
	
	    		req.setAttribute("dayschedule_vt", dayschedule_vt);
	    		req.setAttribute("rowNum", rowNum);
	    		
	    		dest = WebUtil.JspURL+"D/D13ScheduleChange/D13ScheduleChangeDayPopup.jsp";
	    		
            }
            
            
            printJspPage(req, res, dest);
		}catch(Exception e) {
            throw new GeneralException(e);
        }

	}

}
