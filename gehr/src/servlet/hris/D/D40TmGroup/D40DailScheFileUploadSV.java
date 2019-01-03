/******************************************************************************/
/*																							*/
/*   System Name	:  MSS														*/
/*   1Depth Name		:  �μ�����													*/
/*   2Depth Name		:  ���ϱٹ�����												*/
/*   Program Name	:  ���ϱٹ�����(�ϰ�)										*/
/*   Program ID		:  D40DailScheFileUploadSV.java						*/
/*   Description		:  ���ϱٹ�����(�ϰ�)										*/
/*   Note				:  ���� ���� �˾�											*/
/*   Creation			:  2017-12-08  ������                                          	*/
/*   Update				:  2017-12-08  ������                                          	*/
/*                                                                              			*/
/********************************************************************************/
package servlet.hris.D.D40TmGroup;

import hris.common.WebUserData;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.sns.jdf.GeneralException;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.WebUtil;

public class D40DailScheFileUploadSV extends  EHRBaseServlet {


	private static final long serialVersionUID = 1L;

	protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        try{
            HttpSession session = req.getSession(false);
            WebUserData user = WebUtil.getSessionUser(req);

            String dest = WebUtil.JspURL+"D/D40TmGroup/D40DailScheExcelUpload.jsp";

            printJspPage(req, res, dest);

        } catch(Exception e) {
            throw new GeneralException(e);
        }

	}
}
