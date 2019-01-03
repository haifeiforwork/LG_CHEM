/********************************************************************************/
/*   System Name  : MSS
/*   1Depth Name  : My HR
/*   2Depth Name  : �μ�����
/*   Program Name : �Ǳٹ� ������Ȳ
/*   Program ID   : D40WorkTimeReportFrameSV.java
/*   Description  : �Ǳٹ� ������Ȳ ����Ʈ frame ȣ�� Class
/*   Note         : 
/*   Creation     : 2018-06-04 [WorkTime52] ��ȯ��
/*   Update       : 
/********************************************************************************/
package servlet.hris.D.D40TmGroup;

import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.sns.jdf.GeneralException;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;

import hris.D.D40TmGroup.D40TmGroupData;
import hris.D.D40TmGroup.rfc.D40TmGroupFrameRFC;
import hris.common.WebUserData;

/**
 * D40WorkTimeReportFrameSV.java
 * �Ǳٹ� ������Ȳ frame ȣ�� Class
 *
 */
public class D40WorkTimeReportFrameSV extends EHRBaseServlet {
	
	protected void performTask(final HttpServletRequest req, HttpServletResponse res) throws GeneralException {
		
		try{
			
			String dest = "";

			WebUserData user    = WebUtil.getSessionUser(req);

			String deptId = WebUtil.nvl(req.getParameter("hdn_deptId"));
			String deptNm = WebUtil.nvl(req.getParameter("hdn_deptNm"));
			String sMenuCode = req.getParameter("sMenuCode");
			String E_INFO = req.getParameter("E_INFO");
			
			String SEARCH_GUBUN = WebUtil.nvl(req.getParameter("SEARCH_GUBUN"), "M");
			String SEARCH_DATE = WebUtil.nvl(req.getParameter("SEARCH_DATE"), DataUtil.getCurrentDate());

			D40TmGroupFrameRFC func = new D40TmGroupFrameRFC();
	    	String I_PABRJ = "";
	    	String I_PABRP = "";

			Vector ret = func.getTmYyyyMmList(user.empNo, "1", I_PABRJ, I_PABRP, "");
			Vector<D40TmGroupData> resultList = (Vector)ret.get(1);	//��ȸ selectbox
			
			req.setAttribute("deptId", deptId);
			req.setAttribute("deptNm", deptNm);
			req.setAttribute("sMenuCode", sMenuCode);
			req.setAttribute("E_INFO", E_INFO);

			req.setAttribute("resultList", resultList);

			req.setAttribute("SEARCH_GUBUN", SEARCH_GUBUN);
			req.setAttribute("SEARCH_DATE", SEARCH_DATE);
			
			dest = WebUtil.JspURL + "D/D40TmGroup/D40WorkTimeReportFrame.jsp" ;
			
			printJspPage(req, res, dest);

		} catch (Exception e) {
			throw new GeneralException(e);
		}
		
    }

}
