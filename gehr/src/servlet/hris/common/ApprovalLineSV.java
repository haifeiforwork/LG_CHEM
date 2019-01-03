/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR ����                                                  */
/*   2Depth Name  : �ڰݸ�����                                                */
/*   Program Name : �ڰݸ����� ��û                                           */
/*   Program ID   : D30MembershipFeeBuildSV                                           */
/*   Description  : �ڰ������㸦 ��û�� �� �ֵ��� �ϴ� Class                    */
/*   Note         :                                                             */
/*   Creation     : 2002-01-11  �ֿ�ȣ                                          */
/*   Update       : 2005-02-15  ������                                          */
/*   Update       : 2005-02-23  �����                                          */
/*                                                                              */
/********************************************************************************/

package servlet.hris.common;

import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.WebUtil;
import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalLineInput;
import org.apache.commons.lang.StringUtils;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class ApprovalLineSV extends ApprovalBaseServlet {

    private String UPMU_TYPE = "";     // ���� ����Ÿ��(�ڰݸ�����)
    private String UPMU_NAME = "";

    protected String getUPMU_TYPE() {
        return UPMU_TYPE;
    }

    protected String getUPMU_NAME() {
        return UPMU_NAME;
    }

    protected void performTask(final HttpServletRequest req, HttpServletResponse res) throws GeneralException {
        try {
            WebUserData user = WebUtil.getSessionUser(req);

            Box box = WebUtil.getBox(req);
            if(StringUtils.isNotBlank(box.get("PERNR"))) box.put("I_PERNR", box.get("PERNR"));
            if(StringUtils.isNotBlank(box.get("UPMU_TYPE"))) box.put("I_UPMU_TYPE", box.get("UPMU_TYPE"));

            ApprovalLineInput approvalLineInput = box.createEntity(ApprovalLineInput.class);

            req.setAttribute("approvalLine", getApprovalLine(approvalLineInput));

            printJspPage(req, res, WebUtil.JspURL + "common/ApprovalLine.jsp");
        } catch (GeneralException e) {
            Logger.error(e);
        }
    }
}
