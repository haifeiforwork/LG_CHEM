/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : ��û                                                        */
/*   2Depth Name  : ���λ���                                                    */
/*   Program Name : �ڰݸ���                                                    */
/*   Program ID   : A17LicenceDetailSV                                          */
/*   Description  : �ڰݸ��㸦 ��ȸ/���� �Ҽ� �ֵ��� �ϴ� Class                 */
/*   Note         :                                                             */
/*   Creation     : 2002-01-14  �ֿ�ȣ                                          */
/*   Update       : 2005-02-25  �����                                          */
/*                                                                              */
/********************************************************************************/
package servlet.hris.D.D15EmpPayInfo;

import com.common.RFCReturnEntity;
import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.WebUtil;
import hris.D.D15EmpPayInfo.D15EmpPayData;
import hris.D.D15EmpPayInfo.rfc.D15EmpPayRFC;
import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Vector;

public class D15EmpPayDetailSV extends ApprovalBaseServlet {

    private String UPMU_TYPE = "17";     // ���� ����Ÿ��(�ڰݸ�����)
    private String UPMU_NAME = "����/����";

    protected String getUPMU_TYPE() {
        return UPMU_TYPE;
    }

    protected String getUPMU_NAME() {
        return UPMU_NAME;
    }

    protected void performTask(final HttpServletRequest req, HttpServletResponse res) throws GeneralException {
        try {

            final WebUserData user = WebUtil.getSessionUser(req);
            Box box = WebUtil.getBox(req);

            String jobid = box.get("jobid", "first");

            String I_APGUB = (String) req.getAttribute("I_APGUB");  //��� ���������� �Գ�? '1' : ������ ���� , '2' : ������ ���� , '3' : ����Ϸ� ����

            final D15EmpPayRFC d15EmpPayRFC = new D15EmpPayRFC();
            d15EmpPayRFC.setDetailInput(user.empNo, I_APGUB, box.get("AINF_SEQN"));
            Vector<D15EmpPayData> resultList = d15EmpPayRFC.getDetail(); //��� ����Ÿ

            if (jobid.equals("first")) {           //����ó�� ��û ȭ�鿡 ���°��.

                req.setAttribute("resultList", resultList);

                if (!detailApporval(req, res, d15EmpPayRFC))
                    return;

                printJspPage(req, res, WebUtil.JspURL + "D/D15EmpPayInfo/D15EmpPayDetail.jsp");

            } else if (jobid.equals("delete")) {           //����ó�� ��û ȭ�鿡 ���°��.

                String dest = deleteApproval(req, box, d15EmpPayRFC, new DeleteFunction() {
                    public boolean porcess() throws GeneralException {

                        D15EmpPayRFC deleteRFC = new D15EmpPayRFC();
                        deleteRFC.setDeleteInput(user.empNo, UPMU_TYPE, d15EmpPayRFC.getApprovalHeader().AINF_SEQN);

                        RFCReturnEntity returnEntity = deleteRFC.delete();

                        if(!returnEntity.isSuccess()) {
                            throw new GeneralException(returnEntity.MSGTX);
                        }

                        return true;
                    }
                });

                printJspPage(req, res, dest);

            } else {
                throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
            }


        } catch (Exception e) {
            Logger.error(e);
            throw new GeneralException(e);
        }
    }

}
