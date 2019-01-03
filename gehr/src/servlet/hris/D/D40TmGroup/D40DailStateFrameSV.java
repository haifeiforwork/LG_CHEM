/******************************************************************************/
/*																							*/
/*   System Name	:  MSS														*/
/*   1Depth Name		:   �μ�����													*/
/*   2Depth Name		:   ��������													*/
/*   Program Name	:   �������� - Frame										*/
/*   Program ID		: D40DailStateFrameSV.java							*/
/*   Description		: �������� - Frame											*/
/*   Note				: 																*/
/*   Creation			: 2017-12-08  ������                                          	*/
/*   Update				: 2017-12-08  ������                                          	*/
/*                                                                              			*/
/********************************************************************************/
package servlet.hris.D.D40TmGroup;

import hris.D.D40TmGroup.D40TmGroupData;
import hris.D.D40TmGroup.rfc.D40DailStateRFC;
import hris.D.D40TmGroup.rfc.D40TmGroupFrameRFC;
import hris.common.WebUserData;

import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.sns.jdf.GeneralException;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.WebUtil;

public class D40DailStateFrameSV extends EHRBaseServlet {

	protected void performTask( HttpServletRequest req, HttpServletResponse res ) throws GeneralException {

		try{

			WebUserData user    = WebUtil.getSessionUser(req);
			String I_ACTTY       = WebUtil.nvl(req.getParameter("I_ACTTY"));

			String I_SELTAB = WebUtil.nvl(req.getParameter("I_SELTAB"));

			String I_BEGDA = WebUtil.nvl(req.getParameter("I_BEGDA"));
			String I_ENDDA = WebUtil.nvl(req.getParameter("I_ENDDA"));

			if("".equals(I_ACTTY)){
				I_ACTTY = "T";			//T:�ϰ��ʱ���ȸ
			}
			String I_DATUM = "";
			String I_SCHKZ = "";
			Vector T_IMPERS = new Vector();
			Vector OBJID = new Vector();

	    	D40TmGroupFrameRFC func = new D40TmGroupFrameRFC();
	    	String I_PABRJ = "";
	    	String I_PABRP = "";
	    	String I_GUBUN = "";	//1:����,2:����, "": �⺻��ȸ

			Vector ret = func.getTmYyyyMmList(user.empNo, "1", I_PABRJ, I_PABRP, "");
			Vector<D40TmGroupData> resultList = (Vector)ret.get(1);	//��ȸ selectbox
			req.setAttribute("resultList", resultList);

			Vector vec = (new D40DailStateRFC()).getDailState(user.empNo, I_ACTTY, I_DATUM, I_BEGDA, I_ENDDA, I_SCHKZ, I_GUBUN, T_IMPERS, I_SELTAB, OBJID);

			String E_BEGDA = (String)vec.get(2);		//��ȸ������
			String E_ENDDA = (String)vec.get(3);		//��ȸ������
			String E_DAY_CNT = (String)vec.get(4);	//���ڼ�
			String E_INFO = (String)vec.get(5);			//�ȳ�����
//			Vector T_EXPORTA = (Vector)vec.get(6);	//�ϰ�����ǥ TITLE
//			Vector T_EXPORTB = (Vector)vec.get(7);	//�ϰ�����ǥ DATA
			Vector T_SCHKZ = (Vector)vec.get(10);	//��ȹ�ٹ� �ڵ�-�ؽ�Ʈ


			req.setAttribute("I_BEGDA", I_BEGDA);
            req.setAttribute("I_ENDDA", I_ENDDA);

            req.setAttribute("E_BEGDA", E_BEGDA);
            req.setAttribute("E_ENDDA", E_ENDDA);
            req.setAttribute("E_DAY_CNT", E_DAY_CNT);
            req.setAttribute("E_INFO", E_INFO);
            req.setAttribute("T_SCHKZ", T_SCHKZ);


			String dest = WebUtil.JspURL + "D/D40TmGroup/D40StateFrame.jsp" ;

			printJspPage(req, res, dest);

		} catch (Exception e) {
			throw new GeneralException(e);
		}
	}

}
