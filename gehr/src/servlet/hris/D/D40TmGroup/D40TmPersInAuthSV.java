/******************************************************************************/
/*																							*/
/*   System Name	:  MSS														*/
/*   1Depth Name		:   ��������													*/
/*   2Depth Name		:   ����/�ο���Ȳ - ������Ȳ								*/
/*   Program Name	:   �μ����´����											*/
/*   Program ID		: D40TmPersInAuthSV.java								*/
/*   Description		: �μ����´����											*/
/*   Note				: 																*/
/*   Creation			: 2017-12-08  ������                                          	*/
/*   Update				: 2017-12-08  ������                                          	*/
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

			String deptId		= WebUtil.nvl(req.getParameter("hdn_deptId"),""); 			//�μ��ڵ�...
	        String deptName	= WebUtil.nvl(req.getParameter("hdn_deptNm"),""); 			//�μ��ڵ�...
	        String checkYN	= WebUtil.nvl(req.getParameter("chck_yeno"), "N"); 		//�����μ�����.
	        String I_DATUM	= WebUtil.nvl(req.getParameter("I_DATUM"), DataUtil.getCurrentDate());

	        //�ʱ�ȭ�� ���½� �α��� ������� �����͸� �����ش�.
	        if("".equals(deptId)){
            	deptId = user.e_objid;
            }
            /**
           	 * @$ ���������� rdcamel
           	 * �ش� ����� ������ ��ȸ �Ҽ� �ִ��� üũ
           	 */
            if(!checkBelongGroup(req, res, deptId, "")){ return;}
        	// @����༺ �߰�
            if(!checkAuthorization(req, res)){ return;}

	    	D40TmPersInAuthRFC fnc = new D40TmPersInAuthRFC();

			Vector vec = fnc.getTmPersInAuth(deptId, I_DATUM);
//
			String E_RETURN = (String)vec.get(0);			//return message code
			String E_MESSAGE = (String)vec.get(1);		//return message
			Vector T_EXLIST = (Vector)vec.get(2);		//�Է���Ȳ��ȸ

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
