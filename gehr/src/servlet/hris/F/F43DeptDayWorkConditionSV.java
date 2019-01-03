/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manager's Desc                                              */
/*   2Depth Name  : 근태                                                        */
/*   Program Name : 일간 근태 집계표                                            */
/*   Program ID   : F43DeptDayWorkConditionSV                                   */
/*   Description  : 부서별 일간 근태 집계표 조회를 위한 서블릿                  */
/*   Note         : 없음                                                        */
/*   Creation     : 2005-02-17 유용원                                           */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/

package servlet.hris.F;

import java.util.Vector;
import javax.servlet.http.*;

import com.sns.jdf.*;
import com.sns.jdf.util.*;
import com.sns.jdf.sap.SAPType;
import com.sns.jdf.servlet.*;

import hris.F.rfc.*;
import hris.common.WebUserData;

/**
 * F43DeptDayWorkConditionSV
 * 부서에 따른 전체 부서원의 일간 근태 집계표 정보를 가져오는
 * F42DeptMonthWorkConditionRFC 를 호출하는 서블릿 class
 *
 * @author  유용원
 * @version 1.0
 */
public class F43DeptDayWorkConditionSV extends EHRBaseServlet {

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
    	try{
	        HttpSession session = req.getSession(false);
	        String deptId       = WebUtil.nvl(req.getParameter("hdn_deptId")); 			//부서코드...
	        String checkYN      = WebUtil.nvl(req.getParameter("chck_yeno"), "N"); 		//하위부서여부.
	        String excelDown    = WebUtil.nvl(req.getParameter("hdn_excel"));  			//excelDown...
            String year   = WebUtil.nvl(req.getParameter("year1"));
            String month  = WebUtil.nvl(req.getParameter("month1"));
            String yymmdd   = "";
	        WebUserData user    = (WebUserData)session.getAttribute("user");				//세션.
	        String subView       = WebUtil.nvl(req.getParameter("subView"));				//tab에서 호출되는지 여부

            //초기화면 오픈시 로그인 사용자의 데이터를 보여준다.
            if( deptId.equals("") ){
            	deptId = user.e_objid;
            }
			if(year.equals("")||month.equals("")){
				yymmdd = DataUtil.getCurrentDate();
			} else {
				yymmdd = year + month + "20";
			}

	        String dest    		= "";
	        String E_RETURN  	= "";
	        //String E_MESSAGE 	= "부서 정보를 가져오는데 실패하였습니다.";
	        String E_MESSAGE 	= g.getMessage("MSG.F.F41.0007");
	        String E_YYYYMON 	= "";
	        String E_DAY_CNT 	= "";



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
	        //Logger.debug.println(this, sMenuCode + " >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> "+user.e_timeadmin+checkTimeAuthorization(req, res));

	        Logger.debug(sMenuCode + " >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> "+user.e_timeadmin);
	        if(sMenuCode.equals("ESS_HRA_DAIL_STATE")){                            //개인인사정보 > 신청 > 부서근태
	        	if(!checkTimeAuthorization(req, res)) return;
	        }else{                                                               //부서인사정보
//	    	 @웹취약성 추가
	        	if ( user.e_authorization.equals("E")) {
	        		if(!checkTimeAuthorization(req, res)) return;
	        	}
	        }



	        F42DeptMonthWorkConditionRFC func    = null;
	        Vector F43DeptDayTitle_vt  = null;
	        Vector F43DeptDayData_vt   = null;

	        if ( !deptId.equals("") ) {
	        	func       				= new F42DeptMonthWorkConditionRFC();
	        	F43DeptDayTitle_vt  	= new Vector();
	        	F43DeptDayData_vt  		= new Vector();
	            Vector ret 				= func.getDeptMonthWorkCondition(deptId, yymmdd, "","2", checkYN,user.sapType,user.area);	// 일간 '2' set!

	            E_RETURN   				= (String)ret.get(0);
	            E_MESSAGE  				= (String)ret.get(1);
	            E_YYYYMON  				= (String)ret.get(2);

	            F43DeptDayTitle_vt 		= (Vector)ret.get(3);
	            F43DeptDayData_vt 		= (Vector)ret.get(4);
            	E_DAY_CNT  				= (String)ret.get(5); // 일자수
	        }
	        Logger.debug.println(this, " E_RETURN = " + E_RETURN);

	        //RFC 호출 성공시.
	        if(func.getReturn().isSuccess()){
		        req.setAttribute("checkYn", checkYN);
		        req.setAttribute("E_YYYYMON", E_YYYYMON);
		        req.setAttribute("E_DAY_CNT", E_DAY_CNT);
		        req.setAttribute("F43DeptDayTitle_vt", F43DeptDayTitle_vt);
		        req.setAttribute("F43DeptDayData_vt", F43DeptDayData_vt);
		        req.setAttribute("subView", subView);
	        	Logger.debug.println(this, " subView = " + subView);
		        if( excelDown.equals("ED") ) //엑셀저장일 경우.
		            dest = WebUtil.JspURL+"F/F43DeptDayWorkConditionExcel_KR.jsp";
		        else if( excelDown.equals("print") ) //출력일 경우.
		            dest = WebUtil.JspURL+"F/F43DeptDayWorkConditionPrint_KR.jsp";
		        else
		        	dest = WebUtil.JspURL+"F/F43DeptDayWorkCondition_KR.jsp";

		        Logger.debug.println(this, "F43DeptDayTitle_vt : "+ F43DeptDayTitle_vt.toString());
		        Logger.debug.println(this, "F43DeptDayData_vt : "+ F43DeptDayData_vt.toString());
		    //RFC 호출 실패시.
	        }else{
		        String msg = E_MESSAGE;
                String url = "history.back();";
		        //String url = "location.href = '"+WebUtil.JspURL+"F/F43DeptDayWorkCondition.jsp?checkYn="+checkYN+"';";
		        req.setAttribute("msg", msg);
		        req.setAttribute("url", url);
		        dest = WebUtil.JspURL+"common/caution.jsp";
	        }

	        Logger.debug.println(this, " destributed = " + dest);
	        printJspPage(req, res, dest);
    	} catch(Exception e) {
            throw new GeneralException(e);
        }
    }
}