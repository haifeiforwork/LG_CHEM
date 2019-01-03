/******************************************************************************/
/*																							*/
/*   System Name	:  MSS														*/
/*   1Depth Name		:   부서근태													*/
/*   2Depth Name		:   근태집계표												*/
/*   Program Name	:   일간근태집계표 팝업									*/
/*   Program ID		: D40DailStatePopupSV.java							*/
/*   Description		: 일간근태집계표 팝업										*/
/*   Note				: 																*/
/*   Creation			: 2017-12-08  정준현                                          	*/
/*   Update				: 2017-12-08  정준현                                          	*/
/*                                                                              			*/
/********************************************************************************/
package servlet.hris.D.D40TmGroup;

import hris.D.D40TmGroup.rfc.D40DailStatePopupRFC;
import hris.N.AES.AESgenerUtil;
import hris.common.WebUserData;

import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.sns.jdf.GeneralException;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.WebUtil;

public class D40DailStatePopupSV extends EHRBaseServlet {

	protected void performTask( HttpServletRequest req, HttpServletResponse res ) throws GeneralException {

		try{

			WebUserData user	= WebUtil.getSessionUser(req);
			String I_PERNR 			= WebUtil.nvl(req.getParameter("I_PERNR"));
			String I_BEGDA 		= WebUtil.nvl(req.getParameter("I_BEGDA")).replace(".","");
			String I_ENDDA 		= WebUtil.nvl(req.getParameter("I_ENDDA")).replace(".","");

			I_PERNR = AESgenerUtil.decryptAES(I_PERNR, req); //복호화를 위해

			D40DailStatePopupRFC fnc = new D40DailStatePopupRFC();
			Vector vec = fnc.getDailState(I_PERNR, I_BEGDA, I_ENDDA);

			String E_RETURN = (String)vec.get(0);		//리턴코드
			String E_MESSAGE = (String)vec.get(1);		//리턴메세지
			String E_ENAME = (String)vec.get(2);		//성명
			Vector T_EXLIST = (Vector)vec.get(3);		//입력현황조회

			req.setAttribute("I_PERNR", I_PERNR);
			req.setAttribute("I_BEGDA", WebUtil.nvl(req.getParameter("I_BEGDA")));
			req.setAttribute("I_ENDDA", WebUtil.nvl(req.getParameter("I_ENDDA")));
			req.setAttribute("E_RETURN", E_RETURN);
			req.setAttribute("E_MESSAGE", E_MESSAGE);
			req.setAttribute("E_ENAME", E_ENAME);
			req.setAttribute("T_EXLIST", T_EXLIST);

		    printJspPage(req, res, WebUtil.JspURL + "D/D40TmGroup/D40DailStatePopup.jsp");


		} catch (Exception e) {
//			e.printStackTrace();
			throw new GeneralException(e);
		}
	}

}
