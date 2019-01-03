/*
 * @(#)D13ScheduleChangeSV.java    2009. 03. 20
 *
 * Copyright 2007 Hyundai Marine, Inc. All rights reserved
 * Hyundai Marine PROPRIETARY/CONFIDENTIAL
 */
package servlet.hris.D.D14PlanWorkTime;

import hris.D.D12Rotation.D12RotationSearchData;
import hris.D.D12Rotation.rfc.SearchDeptNameRotDeptTimeRFC;
import hris.D.D12Rotation.rfc.SearchDeptNameRotRFC;
import hris.D.D14PlanWorkTime.D14PlanWorkTimeData;
import hris.D.D14PlanWorkTime.rfc.D14PlanWorkTimeRFC;
import hris.common.WebUserData;

import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;

/**
 * D14PlanWorkTimeSV.java
 * �ٹ�������Ģ����
 *
 * @author ������
 * @version 1.0, 2009/03/25
 */
public class D14PlanWorkTimeSV extends EHRBaseServlet {

	private static final long serialVersionUID = 754780027723196359L;

	protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {

		try{
			HttpSession session = req.getSession(false);
			WebUserData user = WebUtil.getSessionUser(req);

			String dest = "";//����θ�

			Box box = WebUtil.getBox(req);
            String jobid   = box.get("jobid");
            String i_date   = box.get("I_DATE");
            String i_orgeh   = box.get("I_ORGEH");
            String i_gbn   = "ORGEH";//box.get("I_GBN");
            String i_searchdata   = box.get("I_SEARCHDATA");
            String deptNm   = box.get("txt_deptNm");
            String checkYN      =  "Y";// ����ó�� ; WebUtil.nvl(req.getParameter("chck_yeno"), "N"); 		//�����μ�����.
            String i_pernr = "";

            if(i_gbn == null || i_gbn.equals("")){
            	i_gbn = "ORGEH";
            }
            if(i_gbn.equals("ORGEH")||i_gbn.equals("RECENT")){
            	i_orgeh = i_searchdata;
            }else if(i_gbn.equals("PERNR")){
            	i_pernr = i_searchdata;
            }

            //��ȸ�������ڰ� ������� �������ڸ� default���Ѵ�.
            if( i_date == null || i_date.equals("") ) {
                i_date = DataUtil.getCurrentDate();
            }
            if( jobid == null || jobid.equals("") ) {
            	jobid = "search";
            }
            if( i_orgeh == null || i_orgeh.equals("") ) {
            	i_orgeh = user.e_orgeh;
            }
            if( i_pernr == null || i_pernr.equals("") ) {
            	i_pernr = user.empNo;
            }

	        /*************************************************************
	         * @$ ���������� marco257
	         * ���ǿ� �ִ� e_timeadmin = Y �� ����� �μ� ���� ������ ����.
	         * user.e_authorization.equals("E") ���� !user.e_timeadmin.equals("Y")�� ����
	         *
	         * @ sMenuCode �ڵ� �߰�
	         * �μ����� ������ �ִ� ����� MSS������ �ִ� ����� üũ�ϱ� ���� �߰�
	         * 1406 : �μ����� ������ �ִ� �޴��ڵ�(e_timeadmin ���� üũ)
	         * 1184 : �μ��λ������� -> ������� -> ���� -> �������� ����ǥ�� ������ �ִ»��
	         * �߰�: �޴� �ڵ尡 ������� ���� ������ �켱�Ѵ�.
	         *  (e_timeadmin ���� üũ���� )
	         **************************************************************/

	        String sMenuCode = WebUtil.nvl(req.getParameter("sMenuCode"));


	        Logger.debug.println(sMenuCode + " >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> "+user.e_timeadmin);
	        if(sMenuCode.equals("1404")){                            //�����λ����� > ��û > �μ�����
		       if (!user.e_timeadmin.equals("Y")) {
	                String msg = "msg015";
	                req.setAttribute("msg", msg);
	                dest = WebUtil.JspURL+"common/caution.jsp";
	                printJspPage(req, res, dest);
	            }
	        }else{                                                               //�μ��λ�����
//	    	 @����༺ �߰�
		    	   if (user.e_authorization.equals("E") ) {
		    		   if(!user.e_timeadmin.equals("Y")){  //���� ������ �켱
			                Logger.debug.println(this, "E Authorization!!");
			                String msg = "msg015";
			                req.setAttribute("msg", msg);
			                dest = WebUtil.JspURL+"common/caution.jsp";
			                printJspPage(req, res, dest);
		    		   }
		            }
	        }

            if( jobid.equals("search") ) {
            	D14PlanWorkTimeRFC workScheduleRuleRfc = new D14PlanWorkTimeRFC();
            	Vector ret = null;
            	if(i_gbn.equals("ORGEH")||i_gbn.equals("RECENT")){
            		ret = workScheduleRuleRfc.getScheduleRuleForOrgeh(i_date, i_orgeh, checkYN);
            	}else if(i_gbn.equals("PERNR")){
            		ret = workScheduleRuleRfc.getScheduleRuleForPernr(i_date, i_pernr);
            	}

            	Vector workScheduleRule_vt = (Vector)ret.get(0);
//            	String E_RETURN = (String)ret.get(1);
//            	String E_MESSAGE = (String)ret.get(2);

            	//if(E_RETURN.equals("")){


            		if (!deptNm.equals("")&&!i_orgeh.equals("")){
                	//�ֱٰ˻�������� ������
		                	D12RotationSearchData d12SearchData = new D12RotationSearchData();
		                	SearchDeptNameRotDeptTimeRFC func = null;
		        	        Vector DeptName_vt  = null;
		                    Vector search_vt    = new Vector();

		    	        	func       		= new SearchDeptNameRotDeptTimeRFC();
		    	        	DeptName_vt  	= new Vector();

		    	            d12SearchData.SPERNR = user.empNo  ;    //��� ��ȣ
		    	            d12SearchData.OBJID = i_orgeh  ;    //������Ʈ ID
		    	            d12SearchData.STEXT =deptNm  ;    //������Ʈ �̸�
		    	            d12SearchData.EPERNR =user.empNo  ;    //��� ��ȣ
		    	            d12SearchData.ENAME = ""  ;    //�����
		    	            d12SearchData.OBJTXT = deptNm  ;     //��� �Ǵ� �������� ���˵� �̸�
		    	            search_vt.addElement(d12SearchData);
		    	            Vector Searchret 		= func.setDept(user.empNo, "","",search_vt); //���� Set!!!
		                    Logger.debug.println("\n===SAVE=====search_vt "+search_vt.toString() );
		    	            //�ֱٰ˻����
            		}


            		req.setAttribute("workScheduleRule_vt", workScheduleRule_vt);
            		req.setAttribute("deptNm", deptNm);
            		req.setAttribute("checkYN", checkYN);
//            		req.setAttribute("E_RETURN", E_RETURN);
//            		req.setAttribute("E_MESSAGE", E_MESSAGE);

            		dest = WebUtil.JspURL+"D/D14PlanWorkTime/D14WorkScheduleRule.jsp?I_SEARCHDATA="+i_searchdata+"&I_DATE="+i_date+"&I_ORGEH="+i_orgeh+"&checkYN="+checkYN;
//            	}else{
//            		String msg = E_MESSAGE;
//                    req.setAttribute("msg", msg);
//                    dest = WebUtil.JspURL+"common/msg.jsp";
//            	}

            }else if( jobid.equals("save") ) {
        		int rowCount   = box.getInt("row_count");

        		Vector workScheduleRule_vt = new Vector();
        		for(int i=0; i<rowCount; i++){
        			D14PlanWorkTimeData data = new D14PlanWorkTimeData();
        			data.PERNR = box.get("PERNR_"+i);
        			data.ENAME = box.get("ENAME_"+i);
        			data.BEGDA = i_date;
        			data.ENDDA = "9999-12-31";
        			data.SCHKZ = box.get("SCHKZ_"+i);
        			data.RTEXT = box.get("RTEXT_"+i);

        			workScheduleRule_vt.add(data);
        		}
        		Logger.debug.println("\n=============���� workScheduleRule_vt : "+workScheduleRule_vt);

        		D14PlanWorkTimeRFC workScheduleRuleRfc = new D14PlanWorkTimeRFC();
        		Vector ret = null;
        		if(i_gbn.equals("ORGEH")||i_gbn.equals("RECENT")){
        			ret = workScheduleRuleRfc.setScheduleRuleForOrgeh(i_date, i_orgeh, checkYN, workScheduleRule_vt);
            	}else if(i_gbn.equals("PERNR")){
            		ret = workScheduleRuleRfc.setScheduleRuleForPernr(i_date, i_pernr, checkYN, workScheduleRule_vt);
            	}

            	String E_RETURN = (String)ret.get(1);
            	String E_MESSAGE = (String)ret.get(2);

        		if(false){
	        		Logger.debug.println(this, "----------- running for Lock Test ");
	            	E_RETURN = "E";
	            	E_MESSAGE = "[Test Case]Lock��Ȳ test�� �ڵ��ư����մϴ�.";
        		}

            	if("E".equals(E_RETURN)){
            		String msg = E_MESSAGE;
            		String url = "history.back()"; //���н� �����ϴ� �ڷḦ �ٽ� �����ֱ� //"location.href = '" + WebUtil.ServletURL+"hris.D.D14PlanWorkTime.D14PlanWorkTimeSV?I_DATE="+i_date+"&I_ORGEH="+i_orgeh+ "&I_SEARCHDATA="+i_orgeh+"';";
                    req.setAttribute("msg", msg);
                    req.setAttribute("url", url);
                    dest = WebUtil.JspURL+"common/msg.jsp";
            	}else{
            		String msg = "msg008";
            		String url = "location.href = '" + WebUtil.ServletURL+"hris.D.D14PlanWorkTime.D14PlanWorkTimeSV?I_DATE="+i_date+"&I_ORGEH="+i_orgeh+ "&I_SEARCHDATA="+i_orgeh+"&checkYN="+checkYN+"';";
            		req.setAttribute("msg", msg);
                    req.setAttribute("url", url);
            		dest = WebUtil.JspURL+"common/msg.jsp";
            	}
        	}else{
            	throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
            }

            printJspPage(req, res, dest);
		}catch(Exception e) {
            throw new GeneralException(e);
        }

	}

}
