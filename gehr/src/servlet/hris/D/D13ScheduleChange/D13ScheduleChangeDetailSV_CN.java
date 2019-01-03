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

import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;

import hris.D.D13ScheduleChange.D13ScheduleChangeData;
import hris.D.D13ScheduleChange.rfc.D13ScheduleChangeRFC;
import hris.common.PersonData;
import hris.common.WebUserData;
import hris.common.rfc.PersonInfoRFC;

/**
 * D13ScheduleChangeSV.java
 * 일일근무일정변경
 *
 * @author 김종서   
 * @version 1.0, 2009/03/20
 */
public class D13ScheduleChangeDetailSV_CN extends EHRBaseServlet {

	//@SuppressWarnings("deprecation")
	protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {
		
		try{
			HttpSession session = req.getSession(false);
			WebUserData user = WebUtil.getSessionUser(req);

//	        if(user.area == Area.KR) {
//	        } else {
//	            printJspPage(req, res, WebUtil.ServletURL + "hris.D.D13ScheduleChangeSV_CN");
//	        }
	
			String dest = "";//대상경로명
			
			Box box = WebUtil.getBox(req);
            String jobid   = box.get("jobid", "search");		// 초기엔 rfc 호출불필요
            
            String i_begda   = box.get("I_BEGDA");
            String i_endda  = box.get("I_ENDDA");
            String i_orgeh   = box.get("hdn_deptId");
            String i_gbn   = box.get("I_GBN", "ORGEH");
            String i_searchdata   = box.get("I_SEARCHDATA");
            String deptNm   = box.get("txt_deptNm");
            String i_pernr = "";
            String i_check_yn = box.get("chck_yeno", "N"); //하위조직포함여부
            String i_txt_pernr = box.get("txt_pernr", ""); //사번필터

			Logger.debug.println(this, ">>>>>>>>>>>>>	jobid = " + jobid);
			
            
//            if(i_gbn.equals("ORGEH")||i_gbn.equals("RECENT")){
//            	i_orgeh = i_searchdata;
//            }else if(i_gbn.equals("PERNR")){
//            	i_pernr = i_searchdata;
//            }

            Logger.debug.println("\n=== =====deptNm "+deptNm+"i_orgeh:"+i_orgeh );      
            //조회기준일자가 없을경우 현재일자를 default로한다.
            if( i_begda == null || i_begda.equals("") ) {
            	i_begda =  DataUtil.getAfterDate(DataUtil.getCurrentDate(), -1);
                i_endda = DataUtil.getCurrentDate();
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
	        /*
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
	        */

//          @웹보안진단 20151124--start
            String reSabunCk = user.e_representative;
            final String PERNR = (!reSabunCk.equals("Y")) ? user.empNo:  getPERNR(box, user); //box.get("PERNR",  user.empNo);
            // 대리 신청 추가
            PersonInfoRFC numfunc = new PersonInfoRFC();
            final PersonData phonenumdata    = (PersonData)numfunc.getPersonInfo(PERNR);
            req.setAttribute("PersonData" , phonenumdata );
            req.setAttribute("PERNR" , PERNR);
//          @웹보안진단 20151124---end

    		req.setAttribute("I_BEGDA", i_begda);
    		req.setAttribute("I_ENDDA", i_endda);
    		req.setAttribute("deptNm", deptNm);
    		req.setAttribute("I_ORGEH", i_orgeh);
    		req.setAttribute("txt_pernr", i_txt_pernr);
        	req.setAttribute("checkYn",  WebUtil.nvl(req.getParameter("chck_yeno"), "N"));
    		
            if( jobid.equals("search") ) {
            	
            	D13ScheduleChangeRFC rfc = new D13ScheduleChangeRFC();
            	Vector ret = null;
            	if(i_gbn.equals("ORGEH")||i_gbn.equals("RECENT")){
            		ret = rfc.getScheduleForOrgeh( i_orgeh, i_check_yn, i_begda, i_endda);
            	}else if(i_gbn.equals("PERNR")){
            		i_pernr = i_searchdata;
            		ret = rfc.getScheduleForPernr(i_begda, i_pernr);
            	}
            	
            	
            	String E_RETURN = rfc.getReturn().MSGTY;
            	String E_MESSAGE = rfc.getReturn().MSGTX;
            	
            	Vector result_vt= new Vector();
            	if(rfc.getReturn().isSuccess()){

                	Vector scheduleChangeData_vt = (Vector)ret.get(0);
                	/** 사번으로 필터링 */
                	if(i_txt_pernr.equals("")){
                		result_vt = scheduleChangeData_vt;
                	}else{
                		
	    				for( int i = 0; i < scheduleChangeData_vt.size(); i++ ){
	    					D13ScheduleChangeData data  = (D13ScheduleChangeData)scheduleChangeData_vt.get(i);
	    					if( data.getPERNR().equals(i_txt_pernr) ){
	    						result_vt.addElement(data);
	    					}
	    				}
                	}
            	
            		req.setAttribute("resultList", result_vt);
            		req.setAttribute("E_RETURN", E_RETURN);
            		req.setAttribute("E_MESSAGE", E_MESSAGE);

//       	        	dest = WebUtil.JspURL+"D/D13ScheduleChange/D13ScheduleChangeDetail_CN.jsp?I_SEARCHDATA="+i_searchdata+"&I_BEGDA="+i_begda+"&I_ENDDA="+i_endda+"&I_ORGEH="+i_orgeh;
            		dest = WebUtil.JspURL+"D/D13ScheduleChange/D13ScheduleChangeDetail_CN.jsp?I_SEARCHDATA="+i_searchdata+"&I_BEGDA="+i_begda+"&I_ENDDA="+i_endda+"&I_ORGEH="+i_orgeh;
            	}else{
            		String msg = E_MESSAGE;
                    req.setAttribute("msg", msg); 
                    dest = WebUtil.JspURL+"common/msg.jsp";
            	}
            	
            	
            }else if( jobid.equals("save") ) {
         		int rowCount   = box.getInt("row_count");
        		
        		Vector<D13ScheduleChangeData> scheduleChangeData_vt = box.getVector(D13ScheduleChangeData.class, "LIST_");
        		
        		Logger.debug.println("\n=============저장 scheduleChangeData_vt : "+scheduleChangeData_vt);
        		D13ScheduleChangeRFC rfc = new D13ScheduleChangeRFC();
        		Vector ret = null;

				int totalSize = 0;
				for( int i = 0; i < scheduleChangeData_vt.size(); i++ ){
					if( scheduleChangeData_vt.get(i).getZCHECK().equals("X") ){
						totalSize ++;
					}
				}
        		if(i_gbn.equals("ORGEH")||i_gbn.equals("RECENT")){
            		ret = rfc.setScheduleForOrgeh(i_begda, i_orgeh, i_pernr, scheduleChangeData_vt,  i_check_yn);
            	}else if(i_gbn.equals("PERNR")){
            		ret = rfc.setScheduleForPernr(i_begda, i_pernr, scheduleChangeData_vt);
            	}
        		
        		int failSize = 0;
//        		Vector v = ret.get(0);
//        		D13ScheduleChangeData d13data  = ret.get(0);
        		scheduleChangeData_vt = (Vector<D13ScheduleChangeData>)ret.get(0);
				for( int i = 0; i < scheduleChangeData_vt.size(); i++ ){
					if( !scheduleChangeData_vt.get(i).getZBIGO().equals("") ){
						failSize ++;
					}
				}
//            	String E_RETURN = (String)ret.get(1);
//            	String E_MESSAGE = (String)ret.get(2);
        		
//            	if(rfc.getReturn().isSuccess()){
//            		String msg = "msg008";
//            		String url = "location.href = '" + WebUtil.ServletURL+"hris.D.D13ScheduleChange.D13ScheduleChangeDetailSV_CN?I_BEGDA="+i_begda+"&I_ENDDA="+i_endda+"&I_SEARCHDATA="+i_orgeh+"';";
//            		req.setAttribute("msg", msg);
//                    req.setAttribute("url", url);
//                	req.setAttribute("saveAfter", "Y");
//            		dest = WebUtil.JspURL+"common/msg.jsp";  
//            	}else{
            		String msg = rfc.getReturn().MSGTX;
//            		String url = "location.href = '" + WebUtil.ServletURL+"hris.D.D13ScheduleChange.D13ScheduleChangeDetailSV_CN?I_BEGDA="+i_begda+"&I_ENDDA="+i_endda+"&I_SEARCHDATA="+i_orgeh+"';";
            		String url = "location.href = '" + WebUtil.JspURL+"D/D13ScheduleChange/D13ScheduleChangeDetail_CN.jsp";

            		req.setAttribute("resultList", ret.get(0));
             		req.setAttribute("msg", g.getMessage("LABEL.D.D12.0081")+" "+totalSize+g.getMessage("LABEL.D.D12.0083")+"  "+
             					g.getMessage("LABEL.D.D12.0082")+" "+failSize+g.getMessage("LABEL.D.D12.0083") );
                    req.setAttribute("url", url);
                    dest = WebUtil.JspURL+"D/D13ScheduleChange/D13ScheduleChangeDetail_CN.jsp";
//            	}

             } else if ( jobid.equals("excel") ) {   //excel 다운로드
            	Vector <D13ScheduleChangeData> resultList = box.getVector(D13ScheduleChangeData.class, "LIST_");
                req.setAttribute( "resultList", resultList ) ;
                req.setAttribute( "BEGDA", i_begda) ;
                req.setAttribute( "ENDDA", i_endda ) ;
                req.setAttribute( "pernr", i_pernr ) ;
                dest = WebUtil.JspURL + "D/D13ScheduleChange/D13ScheduleExcel.jsp" ;

                /*
                 * 사번으로 조직코드찾기
                 */
             } else if (jobid.equals("findORGEH")) {
            	String i_PERNR = box.get("i_PERNR");		// 초기엔 rfc 호출불필요
                PersonInfoRFC rfc = new PersonInfoRFC();
                final PersonData data    = (PersonData)rfc.getPersonInfo(i_PERNR);
                if(rfc.getReturn().isSuccess()){
//                	String e_ORGEH = data.gete_ORGEH();
                	String e_ORGEH = data.getE_ORGTX() + "|" + data.gete_ORGEH();
            	   res.getWriter().print(e_ORGEH);
                } else{
             	   res.getWriter().print("N");
                }
                return;
                
            } else if (jobid.equals("deleteRow")) {

				int totalSize = 0;
            	dest = WebUtil.JspURL +"D/D13ScheduleChange/D13ScheduleChangeDetail_CN.jsp";
				Vector<D13ScheduleChangeData> RotationBuildData_vt =  box.getVector(D13ScheduleChangeData.class, "LIST_");
				Vector<D13ScheduleChangeData> deleteList = new Vector<D13ScheduleChangeData>();
				Logger.debug.println(this, "#####	RotationBuildData_vt.size = " + RotationBuildData_vt.size());
				Logger.debug.println(this, "#####	RotationBuildData_vt.size = " + RotationBuildData_vt);
				for( int i = 0; i < RotationBuildData_vt.size(); i++ ){
					if(    (RotationBuildData_vt.get(i).getZCHECK().equals("X") &&	!deleteBEGDACheck( RotationBuildData_vt.get(i).getBEGDA()))
						|| (RotationBuildData_vt.get(i).getZCHECK().equals("") )){
						deleteList.add(RotationBuildData_vt.get(i));
						if(    (RotationBuildData_vt.get(i).getZCHECK().equals("X") )){
								totalSize ++;
						}
					}
				}

				D13ScheduleChangeRFC d13Rfc = new D13ScheduleChangeRFC();
				Vector <D13ScheduleChangeData> D13ScheduleChangeData_vt = d13Rfc.delete(i_orgeh, PERNR, i_check_yn, deleteList);
				
				Logger.debug.println(this, "#####	deleteList.size = " + deleteList.size());
				Logger.debug.println(this, "#####	D13ScheduleChangeData_vt.size = " + D13ScheduleChangeData_vt.size());
				
        		req.setAttribute("resultList", D13ScheduleChangeData_vt);
            	req.setAttribute("I_BEGDA",  box.getString("I_BEGDA"));
            	req.setAttribute("I_ENDDA", box.getString("I_ENDDA"));
            	
            	int failSize=0;
				for( int i = 0; i < D13ScheduleChangeData_vt.size(); i++ ){
					if( !D13ScheduleChangeData_vt.get(i).getZBIGO().equals("") ){
						failSize ++;
					}
				}
         		req.setAttribute("msg", g.getMessage("LABEL.D.D12.0081")+totalSize+g.getMessage("LABEL.D.D12.0083")+" "+
     					g.getMessage("LABEL.D.D12.0082")+failSize+g.getMessage("LABEL.D.D12.0083") );
         		
//            	if(d13Rfc.getReturn().isSuccess()==false){
//            		req.setAttribute("msg", d13Rfc.getReturn().MSGTX);
//            		req.setAttribute("msg2", d13Rfc.getReturn().MSGTX);
//                    req.setAttribute("url",  "location.href = '" +dest+"\'");
//            		dest = WebUtil.JspURL+"common/msg.jsp";  
//            	}
/*        		
			} else if (jobid.equals("delete")) {
				dest = WebUtil.JspURL + "D/D12Rotation/D12RotationBuildDetail_CN.jsp";
				String paramString =  req.getParameter("paramArr");

				List<Map<String,Object>> resultMap = new ArrayList<Map<String, Object>>();
				resultMap = JSONArray.fromObject(paramString);

				Vector<D13ScheduleChangeData> deleteList = new Vector<D13ScheduleChangeData>();
				for (Map<String, Object> map : resultMap) {
					D13ScheduleChangeData data = new D13ScheduleChangeData();
					data.ZCHECK = "X";
					data.PERNR = (String) map.get("PERNR");
					data.SUBTY = (String) map.get("SUBTY");
					data.OBJPS = (String) map.get("OBJPS");
					data.SPRPS = (String) map.get("SPRPS");
					data.BEGDA = (String) map.get("BEGDA");
					data.ENDDA = (String) map.get("ENDDA");
					data.SEQNR = (String) map.get("SEQNR");

					if(StringUtils.isNotBlank((String) map.get("BEGDA"))){
						deleteList.add(data);
					}
				}
				D13ScheduleChangeRFC d13Rfc = new D13ScheduleChangeRFC();
				d13Rfc.delete(deleteList);
				String msg = d13Rfc.getReturn().isSuccess() == true ? "S" : "E";
				res.getWriter().print( msg );
				return;
 */

        	}else{
            	throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
            }

			Logger.debug.println(this, "#####	dest = " + dest);
			
            printJspPage(req, res, dest);
            
		}catch(Exception e) {
			Logger.error(e);
            throw new GeneralException(e);
        }

	}

    private boolean deleteBEGDACheck(String begda){
    	boolean returnCheck = false;
    	if( begda.equals("") || begda == null || begda.equals("0000-00-00")){
    		returnCheck = true;
    	}
    	return returnCheck;
    }
    
}
