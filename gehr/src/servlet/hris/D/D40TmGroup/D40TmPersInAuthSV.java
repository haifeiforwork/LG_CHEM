/******************************************************************************/
/*																							*/
/*   System Name	:  MSS														*/
/*   1Depth Name		:   조직관리													*/
/*   2Depth Name		:   조직/인원현황 - 근태현황								*/
/*   Program Name	:   부서근태담당자											*/
/*   Program ID		: D40TmPersInAuthSV.java								*/
/*   Description		: 부서근태담당자											*/
/*   Note				: 																*/
/*   Creation			: 2017-12-08  정준현                                          	*/
/*   Update				: 2017-12-08  정준현                                          	*/
/*                                                                              			*/
/********************************************************************************/
package servlet.hris.D.D40TmGroup;

import hris.D.D40TmGroup.rfc.D40TmPersInAuthRFC;
import hris.common.WebUserData;

import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.sns.jdf.GeneralException;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;

public class D40TmPersInAuthSV extends EHRBaseServlet {

	protected void performTask( HttpServletRequest req, HttpServletResponse res ) throws GeneralException {

		try{

			WebUserData user	= WebUtil.getSessionUser(req);

			String deptId		= WebUtil.nvl(req.getParameter("hdn_deptId"),""); 			//부서코드...
	        String deptName	= WebUtil.nvl(req.getParameter("hdn_deptNm"),""); 			//부서코드...
	        String checkYN	= WebUtil.nvl(req.getParameter("chck_yeno"), "N"); 		//하위부서여부.
	        String I_DATUM	= WebUtil.nvl(req.getParameter("I_DATUM"), DataUtil.getCurrentDate());

	        //초기화면 오픈시 로그인 사용자의 데이터를 보여준다.
	        if("".equals(deptId)){
            	deptId = user.e_objid;
            }
            /**
           	 * @$ 웹보안진단 rdcamel
           	 * 해당 사번이 조직을 조회 할수 있는지 체크
           	 */
            if(!checkBelongGroup(req, res, deptId, "")){ return;}
        	// @웹취약성 추가
            if(!checkAuthorization(req, res)){ return;}

	    	D40TmPersInAuthRFC fnc = new D40TmPersInAuthRFC();

			Vector vec = fnc.getTmPersInAuth(deptId, I_DATUM);
//
			String E_RETURN = (String)vec.get(0);			//return message code
			String E_MESSAGE = (String)vec.get(1);		//return message
			Vector T_EXLIST = (Vector)vec.get(2);		//입력현황조회

		    req.setAttribute("hdn_deptId", deptId);
		    req.setAttribute("hdn_deptNm", deptName);
		    req.setAttribute("chck_yeno", checkYN);
		    req.setAttribute("I_DATUM", I_DATUM);
		    req.setAttribute("T_EXLIST", T_EXLIST);

		    printJspPage(req, res, WebUtil.JspURL + "D/D40TmGroup/D40TmPersInAuth.jsp");


		} catch (Exception e) {
//			e.printStackTrace();
			throw new GeneralException(e);
		}
	}

}
