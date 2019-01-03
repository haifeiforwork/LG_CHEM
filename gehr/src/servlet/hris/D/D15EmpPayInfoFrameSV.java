/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : ����/����                                                  */
/*   2Depth Name  : ����/���� ��û                                             */
/*   Program Name : ����/���� ��ȸ                                        */
/*   Program ID   : D15EmpPayInfoFrameSV                                            */
/*   Description  : ����/���� ȸ��  Class               */
/*   Note         :                                                             */
/*   Creation     : 2002-01-03  �ڿ���                                          */
/*   Update       : 2005-03-04  ������                                          */
/*                                                                              */
/********************************************************************************/

package servlet.hris.D;

import com.sns.jdf.GeneralException;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.WebUtil;
import hris.D.D15EmpPayInfo.rfc.D15EmpPayTypeGlobalRFC;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class D15EmpPayInfoFrameSV extends EHRBaseServlet {

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {

        D15EmpPayTypeGlobalRFC empPayTypeGlobalRFC = new D15EmpPayTypeGlobalRFC();
        req.setAttribute("enableMemberFee", empPayTypeGlobalRFC.enableMemberFee(WebUtil.getSessionUser(req).empNo));

        printJspPage(req, res, WebUtil.JspURL + "D/D15EmpPayInfoFrame.jsp");
    }
}
