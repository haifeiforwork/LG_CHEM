/******************************************************************************/
/*																							*/
/*   System Name	:  MSS														*/
/*   1Depth Name		:  �μ�����													*/
/*   2Depth Name		:  ���ϱٹ�����												*/
/*   Program Name	:  ���ϱٹ�����												*/
/*   Program ID		:  D40DailScheFileUploadSV.java						*/
/*   Description		:  ���ϱٹ�����												*/
/*   Note				:  																*/
/*   Creation			:  2017-12-08  ������                                          	*/
/*   Update				:  2017-12-08  ������                                          	*/
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

public class D40DailScheFrameSV extends EHRBaseServlet {

	protected void performTask( HttpServletRequest req, HttpServletResponse res ) throws GeneralException {

		try{

			WebUserData user    = WebUtil.getSessionUser(req);
			String I_ACTTY       = WebUtil.nvl(req.getParameter("I_ACTTY"));

			if("".equals(I_ACTTY)){
				I_ACTTY = "T";			//T:�ϰ��ʱ���ȸ
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
			Vector<D40TmGroupData> resultList = (Vector)ret.get(1);	//��ȸ selectbox
			req.setAttribute("resultList", resultList);

			String dest    = "" ;
			dest = WebUtil.JspURL + "D/D40TmGroup/D40DailScheFrame.jsp" ;

			printJspPage(req, res, dest);

		} catch (Exception e) {
			throw new GeneralException(e);
		}
	}

}
