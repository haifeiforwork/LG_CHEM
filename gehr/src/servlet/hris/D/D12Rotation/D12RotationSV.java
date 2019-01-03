package  servlet.hris.D.D12Rotation;

import java.sql.Connection;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;

import hris.D.D12Rotation.D12RotationData;
import hris.D.D12Rotation.D12RotationSearchData;
import hris.D.D12Rotation.rfc.D12OrgehRFC;
import hris.D.D12Rotation.rfc.D12RotationCnRFC;
import hris.D.D12Rotation.rfc.D12RotationRFC;
import hris.D.D12Rotation.rfc.D12RotationSimulationRFC;
import hris.D.D12Rotation.rfc.SearchDeptNameRotRFC;
import hris.D.D12Rotation.rfc.SearchDeptNameRotDeptTimeRFC;
import hris.common.WebUserData;

/**
 * D12RotationSV.java
 * 계장이 교대조 사원의 근태를 입력할 수 있도록 하는 Class
 *
 * @author 김도신
 * @version 1.0, 2004/02/24
 */

public class D12RotationSV extends EHRBaseServlet {

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        Connection con = null;
        String dest    = "";
        try{
        	WebUserData user = WebUtil.getSessionUser(req);
        	/* 2018-03-12  @PJ.광정우 법인(G570) Roll-Out Start */
        	//if( !user.companyCode.equals("G180") ){
        	// 2018-08-01 변지현 @PJ.우시법인(G620) Roll-out
        	if( !user.companyCode.equals("G180") && !user.companyCode.equals("G570") && !user.companyCode.equals("G620") ){
        	/* 2018-03-12  @PJ.광정우 법인(G570) Roll-Out End  */
	            String jobid     = "";
	            String i_date   = "";         //정보를 조회할 기준일자
	            String i_orgeh  = "";        //정보를 조회할 부서코드

	            Box box = WebUtil.getBox(req);
	            jobid   = box.get("jobid");
	            i_date = box.get("I_DATE");
	            i_orgeh = box.get("hdn_deptId");
	            String deptNm = box.get("hdn_deptNm");
	            String isPop = req.getParameter("hdn_isPop");
	            String i_gbn = box.get("I_GBN");
	            String i_searchdata   = box.get("I_SEARCHDATA");
	            String i_OTEXT   = box.get("E_OTEXT");  //선택한 조직명
	            String i_pernr = "";

	            Logger.debug.println(this, "\n   user.companyCode[0] : " + user.companyCode);
	            Logger.debug.println(this, "\n   i_gbn : " + i_gbn +"i_searchdata:"+i_searchdata +"jobid:"+jobid  +"i_orgeh:"+i_orgeh+"deptNm:"+deptNm);

	            if(i_gbn == null || i_gbn.equals("")){
	            	i_gbn = "ORGEH";
	            }
	             if(i_gbn.equals("PERNR")){
	            	i_pernr = i_searchdata;
	            }

	            if( jobid.equals("") ){
	                jobid = "first";
	            }
	            //기준일자가 없을경우 현재일자를 default로한다.
	            if( i_date == null || i_date.equals("") ) {
	                i_date = DataUtil.getCurrentDate();
	            }
	            if( i_orgeh == null || i_orgeh.equals("") ) {
	            	i_orgeh = user.e_orgeh;
	            }
	            if (i_pernr == null || i_pernr.equals("")) {
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
		        if(sMenuCode.equals("ESS_HRA_TIME_MAIN")){         //개인인사정보 > 신청 > 부서근태
		        	if(!checkTimeAuthorization(req, res)) return;
		        }else{                                                               //부서인사정보
//		    	 @웹취약성 추가
		        	if ( user.e_authorization.equals("E")) {
		        		if(!checkTimeAuthorization(req, res)) return;
		        	}
		        }

	            D12OrgehRFC     rfcOrgeh    = new D12OrgehRFC();

	            Vector          main_vt      = new Vector();
	            Vector          ret             = new Vector();
	            Vector          orgeh_vt     = new Vector();
	            int rowcount = box.getInt("rowCount");

	            Logger.debug.println(this, "\n------------- jobid : " + jobid +"i_orgeh:"+i_orgeh);
	            req.setAttribute("viewSource", "true"); //우클릭을 풀어야 함
	            if( jobid.equals("first") ) {                 //제일처음 저장 화면에 들어온경우.
	            	//대근가능한 조의 리스트를 읽어 전체 사원 리스트를 jsp로 전송한다.
	            	if(i_gbn.equals("ORGEH")||i_gbn.equals("RECENT")){
	            		ret = rfcOrgeh.getDetailForOrgeh(i_date, i_orgeh);
	            	}else if(i_gbn.equals("PERNR")){
	            		ret = rfcOrgeh.getDetailForPernr(i_date, i_pernr);
	            	}



	                orgeh_vt = (Vector)ret.get(0);
	                String E_RETURN    = (String)ret.get(1);
	                String E_MESSAGE = (String)ret.get(2);
	                String E_STATUS = (String)ret.get(3);
	                String E_OTEXT = (String)ret.get(4);
	                i_orgeh = (String)ret.get(5);

	                Logger.debug.println(this, "\n------------- ret : " + ret.toString() );

	                if (! E_RETURN.equals("E") ) {


	                	//최근검색기능위해 저장함
	                	D12RotationSearchData d12SearchData = new D12RotationSearchData();
	                	SearchDeptNameRotDeptTimeRFC func = null;
	        	        Vector DeptName_vt  = null;
	                    Vector search_vt    = new Vector();

	    	        	func       		= new SearchDeptNameRotDeptTimeRFC();
	    	        	DeptName_vt  	= new Vector();

	    	            d12SearchData.SPERNR = user.empNo  ;    //사원 번호
	    	            d12SearchData.OBJID = i_orgeh  ;    //오브젝트 ID
	    	            d12SearchData.STEXT =E_OTEXT  ;    //오브젝트 이름
	    	            d12SearchData.EPERNR = i_pernr  ;    //사원 번호
	    	            d12SearchData.ENAME = ""  ;    //사원명
	    	            d12SearchData.OBJTXT = deptNm  ;     //사원 또는 지원자의 포맷된 이름
	    	            search_vt.addElement(d12SearchData);
	    	            Vector Searchret 		= func.setDept(user.empNo, "","",search_vt); //권한 Set!!!
	    	            //최근검색기능

	                    Logger.debug.println("\n===SAVE=====search_vt "+search_vt.toString() );

		                for( int i = 0 ; i < orgeh_vt.size() ; i++ ) {
		                	D12RotationData dataOrgeh = (D12RotationData)orgeh_vt.get(i);
		                	dataOrgeh.ADDYN = "N";
		                    main_vt.addElement(dataOrgeh);
		                }
		                req.setAttribute("deptNm",            deptNm);
		                req.setAttribute("E_OTEXT",            E_OTEXT);
		                req.setAttribute("jobid",            jobid);
		                req.setAttribute("main_vt",       main_vt);
		                req.setAttribute("rowCount"  ,   Integer.toString(orgeh_vt.size())   );
		                if(isPop==null||isPop.equals("")){
		                	dest = WebUtil.JspURL+"D/D12Rotation/D12RotationDetail.jsp?hdn_deptId="+i_orgeh+"&hdn_deptNm="+deptNm+"&I_DATE="+i_date+"&E_STATUS="+E_STATUS+"&I_SEARCHDATA="+i_searchdata;
		                }else{
		                	dest = WebUtil.JspURL+"D/D12Rotation/D12RotationDetail.jsp?hdn_isPop="+isPop+"&hdn_deptId="+i_orgeh+"&hdn_deptNm="+deptNm+"&I_DATE="+i_date+"&E_STATUS="+E_STATUS;
		                }
	                } else {
	                    String msg = E_MESSAGE;
	                    req.setAttribute("msg", msg);
	                    dest = WebUtil.JspURL+"common/msg.jsp";
	                }

	                Logger.debug.println("\n====================dest "+dest);
	            } else if( jobid.equals("saveData") ) {       //결과를 저장한다.


	                for( int i = 0 ; i < rowcount ; i++ ) {
	                    D12RotationData data_main = new D12RotationData();
	                    String          idx       = Integer.toString(i);

	                    String l_changeFlag = box.get("changeFlag"+idx);
	                    String SUBTY = box.get("SUBTY"+idx);

	                    if( l_changeFlag.equals("Y") ) {
	                    	data_main.BEGDA      = i_date;
	                        data_main.PERNR      = box.get("PERNR" +idx);
	                        data_main.SUBTY     = box.get("SUBTY" +idx);
	                        data_main.BEGUZ      = box.get("BEGUZ"+idx);
	                        if( !data_main.BEGUZ.equals("") ) {
	                            data_main.BEGUZ += "00";
	                        } else {
	                            data_main.BEGUZ = "000000";
	                        }
	                        data_main.ENDUZ      = box.get("ENDUZ"+idx);
	                        if( !data_main.ENDUZ.equals("") ) {
	                            data_main.ENDUZ += "00";
	                        } else {
	                        	data_main.ENDUZ = "000000";
	                        }
	                        data_main.PBEG1      = box.get("PBEG1"+idx);
	                        if( !data_main.PBEG1.equals("") ) {
	                            data_main.PBEG1 += "00";
	                        }else {
	                        	data_main.PBEG1 = "000000";
	                        }
	                        data_main.PEND1      = box.get("PEND1"+idx);
	                        if( !data_main.PEND1.equals("") ) {
	                            data_main.PEND1 += "00";
	                        }else {
	                        	data_main.PEND1 = "000000";
	                        }
	                        data_main.ENAME     = box.get("ENAME" +idx);
	                        data_main.VTKEN = box.get("VTKEN"+idx).equals("Y")? "X":"";
	                        data_main.REASON        = box.get("REASON"+idx);
	                        data_main.CONG_CODE  = box.get("CONG_CODE" +idx);
	                        data_main.CONG_DATE  = box.get("CONG_DATE" +idx);
	                        data_main.HOLI_CONT   = box.get("HOLI_CONT" +idx);
	                        data_main.A002_SEQN   = box.get("P_A024_SEQN" +idx);
	                        data_main.ADDYN         = box.get("ADDYN" +idx);
	                        data_main.ATEXT         = box.get("ATEXT" +idx);
	                        data_main.OVTM_CODE = box.get("OVTM_CODE" +idx);  // CSR ID:1546748

	                        data_main.AEDTM = DataUtil.getCurrentDate();
	                        data_main.UNAME = user.webUserId;
	                        data_main.ZPERNR        = user.empNo;
	                        Logger.debug.println(this, "\n###################### data_main : " + data_main.toString() );
	                        main_vt.addElement(data_main);
	                    }
	                }

	                D12RotationSimulationRFC  rfcCheck         = new D12RotationSimulationRFC();
	                // 작업한 사원의 근태 입력 정보 의 오류사항을 체크한다.
	                Vector ret1 		= rfcCheck.CheckData(main_vt);

	                String E_RETURN 	= (String)ret1.get(0);
	                String E_MESSAGE 	= (String)ret1.get(1);
	                Logger.debug.println(this, "\n------------- E_RETURN : " + E_RETURN );
	                Logger.debug.println(this, "\n------------- E_MESSAGE : " + E_MESSAGE );

	                if(  E_RETURN.equals("E")){
	        	        String msg = E_MESSAGE;
	        	        //String url = "parent.close(); ";
	        	        //String url = "history.back(); ";
	                    String url = "location.href = '" + WebUtil.JspPath+"D/D12Rotation/D12RotationDetailWait.jsp?I_DATE="+i_date+"&hdn_deptId="+i_orgeh+"&hdn_isPop="+isPop+"&I_SEARCHDATA="+i_searchdata+"&I_GBN="+i_gbn+"';";

		                req.setAttribute("main_vt",     main_vt);
	        	        req.setAttribute("msg", msg);
	        	        req.setAttribute("url", url);
	        	        dest = WebUtil.JspURL+"common/msg.jsp";
	                }else{

		                D12RotationRFC  rfc         = new D12RotationRFC();
		                Logger.debug.println(this, "\n---SAVE---------- main_vt : " + main_vt.toString() );
		                Logger.debug.println(this, "\n------------- i_orgeh : " + i_orgeh );
		                Logger.debug.println(this, "\n------------- i_date : " + i_date );
		                // 작업한 교대조 사원의 근태 입력 정보를 저장한다.
		                Vector ret2 		= rfc.saveData(main_vt,i_orgeh,i_date);

		                E_RETURN 	= (String)ret2.get(0);
		                E_MESSAGE 	= (String)ret2.get(1);

		                Logger.debug.println(this, "\n------------- E_RETURN_SAVE : " + E_RETURN );
		                Logger.debug.println(this, "\n------------- E_MESSAGE_SAVE : " + E_MESSAGE );
		                if(! E_RETURN.equals("E") ){
		                	if(E_RETURN.equals("I")){//어떨떄 I 일까????? EUNHA

				                req.setAttribute("hdn_deptId",  i_orgeh);
				                req.setAttribute("deptNm",            deptNm);
				                req.setAttribute("hdn_deptNm",            deptNm);
				                req.setAttribute("I_DATE",       i_date);

				                req.setAttribute("E_OTEXT",            i_OTEXT);
				                req.setAttribute("main_vt",     main_vt);
			                    String url = "location.href = '" + WebUtil.JspPath+"D/D12Rotation/D12RotationDetailWait.jsp?I_DATE="+i_date+"&hdn_deptId="+i_orgeh+"&hdn_isPop="+isPop+"&I_SEARCHDATA="+i_searchdata+"&I_GBN="+i_gbn+"&E_OTEXT="+i_OTEXT+"';";
			                    req.setAttribute("E_RETURN", E_RETURN);
			                    req.setAttribute("E_MESSAGE", E_MESSAGE);
			                    req.setAttribute("url", url);

			                    dest = WebUtil.JspURL+"D/D12Rotation/D12RotationDetail.jsp?hdn_deptId="+i_orgeh+"&hdn_deptNm="+deptNm+"&I_DATE="+i_date+"&I_SEARCHDATA="+i_searchdata+"&I_GBN="+i_gbn+"&E_OTEXT="+i_OTEXT;
		                	}else{

			                	String msg = "msg008";
			                	req.setAttribute("jobid",  i_orgeh);
				                req.setAttribute("deptNm",            deptNm);
				                req.setAttribute("hdn_deptNm",            deptNm);
			                	req.setAttribute("hdn_deptId",  i_orgeh);
				                req.setAttribute("I_DATE",       i_date);
				                req.setAttribute("E_OTEXT",            i_OTEXT);

				                req.setAttribute("main_vt",     main_vt);
			                    String url = "location.href = '" + WebUtil.JspPath+"D/D12Rotation/D12RotationDetailWait.jsp?hdn_deptId="+i_orgeh+"&hdn_deptNm="+deptNm+"&I_DATE="+i_date+"&I_SEARCHDATA="+i_searchdata+"&hdn_isPop="+isPop+"&I_GBN="+i_gbn+"&E_OTEXT="+i_OTEXT+"';";
			                    req.setAttribute("msg", msg);
			                    req.setAttribute("url", url);

			                    dest = WebUtil.JspURL+"common/msg.jsp";
		                	}
		                }else{

		                    String msg = E_MESSAGE;
		        	        //String url = "parent.close(); ";
		        	        String url = "history.back(); ";

			                req.setAttribute("main_vt",     main_vt);
		        	        req.setAttribute("msg", msg);
		        	        req.setAttribute("url", url);
		        	        dest = WebUtil.JspURL+"common/msg.jsp";
		                }
	                }
	                Logger.debug.println(this, "\n------------- dest : " + dest );

	            } else if( jobid.equals("AddorDel") ) {       //추가 ,삭제

	                for( int i = 0 ; i < rowcount ; i++ ) {
	                    D12RotationData data_main = new D12RotationData();
	                    String          idx       = Integer.toString(i);


	                    	data_main.BEGDA      = i_date;
	                        data_main.PERNR      = box.get("PERNR" +idx);
	                        data_main.ENAME     = box.get("ENAME" +idx);
	                        data_main.SUBTY     = box.get("SUBTY" +idx);

	                        data_main.BEGUZ      = box.get("BEGUZ"+idx);
	                        if( !data_main.BEGUZ.equals("") ) {
	                            data_main.BEGUZ += "00";
	                        } else {
	                            data_main.BEGUZ = "000000";
	                        }
	                        data_main.ENDUZ      = box.get("ENDUZ"+idx);
	                        if( !data_main.ENDUZ.equals("") ) {
	                            data_main.ENDUZ += "00";
	                        } else {
	                        	data_main.ENDUZ = "000000";
	                        }
	                        data_main.PBEG1      = box.get("PBEG1"+idx);
	                        if( !data_main.PBEG1.equals("") ) {
	                            data_main.PBEG1 += "00";
	                        }else {
	                        	data_main.PBEG1 = "000000";
	                        }
	                        data_main.PEND1      = box.get("PEND1"+idx);
	                        if( !data_main.PEND1.equals("") ) {
	                            data_main.PEND1 += "00";
	                        }else {
	                        	data_main.PEND1 = "000000";
	                        }
	                        data_main.VTKEN = box.get("VTKEN"+idx).equals("Y")? "X":"";
	                        data_main.REASON        = box.get("REASON"+idx);
	                        data_main.CONG_CODE  = box.get("CONG_CODE" +idx);
	                        data_main.CONG_DATE  = box.get("CONG_DATE" +idx);
	                        data_main.HOLI_CONT   = box.get("HOLI_CONT" +idx);
	                        data_main.A002_SEQN   = box.get("P_A024_SEQN" +idx);
	                        data_main.ADDYN         = box.get("ADDYN" +idx);
	                        data_main.ATEXT         = box.get("ATEXT" +idx);
	                        data_main.OVTM_CODE = box.get("OVTM_CODE" +idx);  // CSR ID:1546748

		                	if (!data_main.ADDYN.equals("D"))
	                             main_vt.addElement(data_main);
	                }

	                req.setAttribute( "main_vt"   , main_vt    );
	                req.setAttribute("deptNm",            deptNm);
	                req.setAttribute("hdn_deptNm",            deptNm);
	                req.setAttribute( "rowCount"  ,Integer.toString(rowcount)   );
	                req.setAttribute( "E_OTEXT"  ,i_OTEXT  );
	                //dest = WebUtil.JspURL+"D/D12Rotation/D12RotationDetail.jsp?I_SEARCHDATA="+i_searchdata;
	            	dest = WebUtil.JspURL+"D/D12Rotation/D12RotationDetail.jsp?I_SEARCHDATA="+i_searchdata+"&hdn_isPop="+isPop+"&hdn_deptId="+i_orgeh+"&hdn_deptNm="+deptNm+"&I_DATE="+i_date;

	            } else if( jobid.equals("print") ) {
	            	if(i_gbn.equals("ORGEH")||i_gbn.equals("RECENT")){
	            		ret = rfcOrgeh.getDetailForOrgeh(i_date, i_orgeh);
	            	}else if(i_gbn.equals("PERNR")){
	            		ret = rfcOrgeh.getDetailForPernr(i_date, i_pernr);
	            	}

	                orgeh_vt = (Vector)ret.get(0);
	                String E_RETURN    = (String)ret.get(1);
	                String E_MESSAGE = (String)ret.get(2);
	                String E_STATUS = (String)ret.get(3);
	                String E_OTEXT = (String)ret.get(4);
	                i_orgeh = (String)ret.get(5);

	                if (! E_RETURN.equals("E") ) {
		                for( int i = 0 ; i < orgeh_vt.size() ; i++ ) {
		                	D12RotationData dataOrgeh = (D12RotationData)orgeh_vt.get(i);
		                	dataOrgeh.ADDYN = "N";
		                    main_vt.addElement(dataOrgeh);
		                }
		                req.setAttribute("deptNm",        deptNm);
		                req.setAttribute("hdn_deptNm",  deptNm);
		                req.setAttribute("jobid",            jobid);
		                req.setAttribute("main_vt",        main_vt);
		                req.setAttribute("rowCount"  ,    Integer.toString(orgeh_vt.size())   );

		                dest = WebUtil.JspURL+"D/D12Rotation/D12RotationDetail_print.jsp?hdn_deptId="+i_orgeh+"&hdn_deptNm="+deptNm+"&I_DATE="+i_date+"&E_STATUS="+E_STATUS;

	                } else {
	                    String msg = E_MESSAGE;
	                    req.setAttribute("msg", msg);
	                    dest = WebUtil.JspURL+"common/msg.jsp";
	                }
	            }else {
	                throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
	            }
	        //
        	}else{
        		String deptId 		= WebUtil.nvl(req.getParameter("hdn_deptId"), user.e_objid); 	// 부서코드
        		String i_date 		= WebUtil.nvl(req.getParameter("I_DATE"));
        		String checkYN 	= WebUtil.nvl(req.getParameter("chck_yeno"), "N");				// 하위부서여부
        		String excelDown = WebUtil.nvl(req.getParameter("hdn_excel"));  						// excelDown

        		boolean E_RETURN = false;
			    // 웹취약성 추가
	            if(!checkAuthorization(req, res)) return;

				if (i_date.equals("")) {
					i_date = DataUtil.getCurrentDate();
				}
				Vector <D12RotationData> D12RotationData_vt = null;
	            D12RotationCnRFC d12Rfc = null;
	            d12Rfc = new D12RotationCnRFC();
	            D12RotationData_vt = d12Rfc.getRotation(deptId, checkYN, i_date);

	            E_RETURN = d12Rfc.getReturn().isSuccess();

	            if( E_RETURN ){
					req.setAttribute("D12RotationData_vt", D12RotationData_vt);
					req.setAttribute("I_DATE", i_date);
					req.setAttribute("checkYn", checkYN);
	            }
		        if( excelDown.equals("ED") ) //엑셀저장일 경우.
		        	dest = WebUtil.JspURL+"D/D12Rotation/D12RotationDetailExcel_CN.jsp";
		        else
		        	dest = WebUtil.JspURL+"D/D12Rotation/D12RotationDetail_CN.jsp";
        	}
            printJspPage(req, res, dest);

        } catch(Exception e) {
            throw new GeneralException(e);
        }
	}
}
