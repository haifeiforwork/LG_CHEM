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

import com.common.constant.Area;
import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;

import hris.D.D12Rotation.D12RotationSearchData;
import hris.D.D12Rotation.rfc.SearchDeptNameRotDeptTimeRFC;
import hris.D.D13ScheduleChange.D13ScheduleChangeData;
import hris.D.D13ScheduleChange.rfc.D13ScheduleChangeRFC;
import hris.common.WebUserData;

/**
 * D13ScheduleChangeSV.java
 * 일일근무일정변경
 *
 * @author 김종서
 * @version 1.0, 2009/03/20
 */
public class D13ScheduleChangeSV extends EHRBaseServlet {

	private static final long serialVersionUID = 754780027723196359L;

	//@SuppressWarnings("deprecation")
	protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {

		try{
			HttpSession session = req.getSession(false);
			WebUserData user = WebUtil.getSessionUser(req);

	        if(user.area != Area.KR) {

//	            printJspPage(req, res, WebUtil.ServletURL + "hris.D.D13ScheduleChange.D13ScheduleChangeBuildSV_CN");
	            printJspPage(req, res, WebUtil.JspURL + "D/D13ScheduleChange/D13ScheduleChange_CN.jsp");
	            return;
	        }

			String dest = "";//대상경로명

			Box box = WebUtil.getBox(req);
            String jobid   = box.get("jobid");
            String i_date   = box.get("I_DATE");
            String i_orgeh   = box.get("I_ORGEH");
            String i_gbn   = "ORGEH" ;//box.get("I_GBN");	/** 부서로만 관리됨. **/
            String i_searchdata   = box.get("I_SEARCHDATA");
            String deptNm   = box.get("txt_deptNm");
            String i_pernr = "";
            String i_loweryn = box.get("I_LOWERYN", "Y"); //하위조직포함여부

            if(i_gbn == null || i_gbn.equals("")){
            	i_gbn = "ORGEH";
            }
            if(i_gbn.equals("ORGEH")||i_gbn.equals("RECENT")){
            	i_orgeh = i_searchdata;
            }else if(i_gbn.equals("PERNR")){
            	i_pernr = i_searchdata;
            }

            Logger.debug.println("\n=== =====deptNm "+deptNm+"i_orgeh:"+i_orgeh );
            //조회기준일자가 없을경우 현재일자를 default로한다.
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
	         * @$ 웹보안진단 marco257
	         * 세션에 있는 e_timeadmin = Y 인 사번이 부서 근태 권한이 있음.
	         * user.e_authorization.equals("E") 에서 !user.e_timeadmin.equals("Y")로 수정
	         *
	         * @ sMenuCode 코드 추가
	         * 부서근태 권한이 있는 사번과 MSS권한이 있는 사번을 체크하기 위해 추가
	         * 1406 : 부서근태 권한이 있는 메뉴코드(e_timeadmin 으로 체크)
	         * 1184 : 부서인사정보에 -> 조직통계 -> 근태 -> 월간근태 집계표에 권한이 있는사번
	         * 추가: 메뉴 코드가 없을경우 근태 권한이 우선한다.
	         *  (e_timeadmin 으로 체크못함 )
	         **************************************************************/

	        String sMenuCode = WebUtil.nvl(req.getParameter("sMenuCode"));

	        Logger.debug(sMenuCode + " >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> "+user.e_timeadmin);
	        if(sMenuCode.equals("1403")){                            //개인인사정보 > 신청 > 부서근태
		       if (!user.e_timeadmin.equals("Y")) {
	                String msg = "msg015";
	                req.setAttribute("msg", msg);
	                dest = WebUtil.JspURL+"common/caution.jsp";
	                printJspPage(req, res, dest);
	            }
	        }else{                                                               //부서인사정보
//	    	 @웹취약성 추가
		    	   if (user.e_authorization.equals("E") ) {
		    		   if(!user.e_timeadmin.equals("Y")){  //근태 권한이 우선
			                Logger.debug.println(this, "E Authorization!!");
			                String msg = "msg015";
			                req.setAttribute("msg", msg);
			                dest = WebUtil.JspURL+"common/caution.jsp";
			                printJspPage(req, res, dest);
		    		   }
		            }
	        }

            if( jobid.equals("search") ) {
            	D13ScheduleChangeRFC scheduleChangeRfc = new D13ScheduleChangeRFC();
            	Vector ret = null;
            	if(i_gbn.equals("ORGEH")||i_gbn.equals("RECENT")){
            		ret = scheduleChangeRfc.getScheduleForOrgeh(i_orgeh, i_loweryn, i_date, i_date);
            	}else if(i_gbn.equals("PERNR")){
            		ret = scheduleChangeRfc.getScheduleForPernr(i_date, i_pernr);
            	}


            	Vector scheduleChangeData_vt = (Vector)ret.get(0);
            	String E_RETURN = scheduleChangeRfc.getReturn().MSGTY;
            	String E_MESSAGE = scheduleChangeRfc.getReturn().MSGTX;

            	if(scheduleChangeRfc.getReturn().isSuccess()){

            		if (!deptNm.equals("")&&!i_orgeh.equals("")){
                	//최근검색기능위해 저장함
		                	D12RotationSearchData d12SearchData = new D12RotationSearchData();
		                	SearchDeptNameRotDeptTimeRFC func = null;
		        	        Vector DeptName_vt  = null;
		                    Vector search_vt    = new Vector();

		    	        	func       		= new SearchDeptNameRotDeptTimeRFC();
		    	        	DeptName_vt  	= new Vector();

		    	            d12SearchData.SPERNR = user.empNo  ;    //사원 번호
		    	            d12SearchData.OBJID = i_orgeh  ;    //오브젝트 ID
		    	            d12SearchData.STEXT =deptNm  ;    //오브젝트 이름
		    	            d12SearchData.EPERNR =user.empNo  ;    //사원 번호
		    	            d12SearchData.ENAME = ""  ;    //사원명
		    	            d12SearchData.OBJTXT = deptNm  ;     //사원 또는 지원자의 포맷된 이름
		    	            search_vt.addElement(d12SearchData);
		    	            Vector Searchret 		= func.setDept(user.empNo, "","",search_vt); //권한 Set!!!
		                    Logger.debug.println("\n===SAVE=====search_vt "+search_vt.toString() );
		    	            //최근검색기능
            		}

            		req.setAttribute("scheduleChangeData_vt", scheduleChangeData_vt);
            		req.setAttribute("E_RETURN", E_RETURN);
            		req.setAttribute("deptNm", deptNm);
            		req.setAttribute("E_MESSAGE", E_MESSAGE);

       	        	dest = WebUtil.JspURL+"D/D13ScheduleChange/D13ScheduleChange.jsp?I_SEARCHDATA="+i_searchdata+"&I_DATE="+i_date+"&I_ORGEH="+i_orgeh;
            	}else{
            		String msg = E_MESSAGE;
                    req.setAttribute("msg", msg);
                    req.setAttribute("url", "history.back();");
                    dest = WebUtil.JspURL+"common/msg.jsp";
            	}


            }else if( jobid.equals("save") ) {
        		int rowCount   = box.getInt("row_count");

        		Vector scheduleChangeData_vt = new Vector();
        		for(int i=0; i<rowCount; i++){
        			D13ScheduleChangeData data = new D13ScheduleChangeData();
        			data.PERNR = box.get("PERNR_"+i);
        			data.ENAME = box.get("ENAME_"+i);
        			data.BEGDA = box.get("BEGDA_"+i);
        			data.TPROG = box.get("TPROG_"+i);
        			data.TTEXT = box.get("TTEXT_"+i);
        			data.VARIA = box.get("VARIA_"+i);
        			data.TPROG2 = box.get("TPROG2_"+i);
        			data.TTEXT2 = box.get("TTEXT2_"+i);
        			data.VARIA2 = box.get("VARIA2_"+i);

        			scheduleChangeData_vt.add(data);
        		}

        		Logger.debug.println("\n=============저장 scheduleChangeData_vt : "+scheduleChangeData_vt);
        		D13ScheduleChangeRFC scheduleChangeRfc = new D13ScheduleChangeRFC();
        		Vector ret = null;

        		if(i_gbn.equals("ORGEH")||i_gbn.equals("RECENT")){
            		ret = scheduleChangeRfc.setScheduleForOrgeh(i_date, i_orgeh, i_pernr, scheduleChangeData_vt,  i_loweryn);
            	}else if(i_gbn.equals("PERNR")){
            		ret = scheduleChangeRfc.setScheduleForPernr(i_date, i_pernr, scheduleChangeData_vt);
            	}

//            	String E_RETURN = (String)ret.get(1);
//            	String E_MESSAGE = (String)ret.get(2);

            	if(scheduleChangeRfc.getReturn().isSuccess()){
            		String msg = "msg008";
            		String url = "location.href = '" + WebUtil.ServletURL+"hris.D.D13ScheduleChange.D13ScheduleChangeSV?I_DATE="+i_date+"&I_SEARCHDATA="+i_orgeh+"';";
            		req.setAttribute("msg", msg);
                    req.setAttribute("url", url);
            		dest = WebUtil.JspURL+"common/msg.jsp";
            	}else{
            		String msg = scheduleChangeRfc.getReturn().MSGTX;
            		String url = "location.href = '" + WebUtil.ServletURL+"hris.D.D13ScheduleChange.D13ScheduleChangeSV?I_DATE="+i_date+"&I_SEARCHDATA="+i_orgeh+"';";

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
