/******************************************************************************/
/*																							*/
/*   System Name	:  MSS														*/
/*   1Depth Name		:   부서근태													*/
/*   2Depth Name		:   사원지급 정보											*/
/*   Program Name	:   사원지급 정보											*/
/*   Program ID		: D40RemeInfoFrameSV.java							*/
/*   Description		: 사원지급 정보												*/
/*   Note				: 																*/
/*   Creation			: 2017-12-08  정준현                                          	*/
/*   Update				: 2017-12-08  정준현                                          	*/
/*                                                                              			*/
/********************************************************************************/
package servlet.hris.D.D40TmGroup;

import hris.D.D40TmGroup.D40TmGroupData;
import hris.D.D40TmGroup.rfc.D40TmGroupFrameRFC;
import hris.common.WebUserData;

import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.sns.jdf.GeneralException;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.WebUtil;

public class D40RemeInfoFrameSV extends EHRBaseServlet {

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

	    	D40TmGroupFrameRFC func = new D40TmGroupFrameRFC();
	    	String I_PABRJ = "";
	    	String I_PABRP = "";

			Vector ret = func.getTmYyyyMmList(user.empNo, "1", I_PABRJ, I_PABRP, "");
			Vector<D40TmGroupData> resultList = (Vector)ret.get(1);	//조회 selectbox
			req.setAttribute("resultList", resultList);

			String dest = WebUtil.JspURL + "D/D40TmGroup/D40RemeInfoFrame.jsp" ;

			printJspPage(req, res, dest);

		} catch (Exception e) {
			throw new GeneralException(e);
		}
	}

}
