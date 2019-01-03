/******************************************************************************/
/*																							*/
/*   System Name	:  MSS														*/
/*   1Depth Name		:   부서근태													*/
/*   2Depth Name		:   계획근무일정 											*/
/*   Program Name	:   계획근무일정 											*/
/*   Program ID		: D40TmSchkzFrameSV.java							*/
/*   Description		: 계획근무일정												*/
/*   Note				: 																*/
/*   Creation			: 2017-12-08  정준현                                          	*/
/*   Update				: 2017-12-08  정준현                                          	*/
/*                                                                              			*/
/********************************************************************************/
package servlet.hris.D.D40TmGroup;

import hris.D.D40TmGroup.D40TmGroupData;
import hris.D.D40TmGroup.rfc.D40TmGroupFrameRFC;
import hris.D.D40TmGroup.rfc.D40TmSchkzFrameRFC;
import hris.common.WebUserData;

import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.sns.jdf.GeneralException;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.WebUtil;

public class D40TmSchkzFrameSV extends EHRBaseServlet {

	protected void performTask( HttpServletRequest req, HttpServletResponse res ) throws GeneralException {

		try{

			WebUserData user    = WebUtil.getSessionUser(req);
			String I_ACTTY       = WebUtil.nvl(req.getParameter("I_ACTTY"));

			if("".equals(I_ACTTY)){
				I_ACTTY = "T";			//T:일괄초기조회
			}
			String I_DATUM = "";
			String I_SCHKZ = "";
			String I_SELTAB = "";
			Vector T_IMPERS = new Vector();
			Vector OBJID = new Vector();

			Vector vec = (new D40TmSchkzFrameRFC()).getTmSchkzFrame(user.empNo, I_ACTTY, I_DATUM, I_SCHKZ, T_IMPERS, I_SELTAB, OBJID);
			String E_RETURN    = (String)vec.get(0);
            String E_MESSAGE = (String)vec.get(1);
            String E_INFO = (String)vec.get(2);	//안내문구

			req.setAttribute("E_RETURN", E_RETURN);
	    	req.setAttribute("E_MESSAGE", E_MESSAGE);
	    	req.setAttribute("E_INFO", E_INFO);

	    	D40TmGroupFrameRFC func = new D40TmGroupFrameRFC();
//	    	String I_PABRJ = DataUtil.getCurrentYear();
//	    	String I_PABRP = DataUtil.getCurrentMonth();
	    	String I_PABRJ = "";
	    	String I_PABRP = "";

			Vector ret = func.getTmYyyyMmList(user.empNo, "1", I_PABRJ, I_PABRP, "");
			Vector<D40TmGroupData> resultList = (Vector)ret.get(1);	//조회 selectbox
			req.setAttribute("resultList", resultList);

			String dest    = "" ;
			dest = WebUtil.JspURL + "D/D40TmGroup/D40TmSchkzFrame.jsp" ;

			printJspPage(req, res, dest);

		} catch (Exception e) {
			throw new GeneralException(e);
		}
	}

}
