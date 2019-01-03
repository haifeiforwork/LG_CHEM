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
package servlet.hris.D.D30MembershipFee;

import com.common.RFCReturnEntity;
import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.WebUtil;
import hris.D.D30MembershipFee.D30MembershipFeeData;
import hris.D.D30MembershipFee.rfc.D30MembershipFeeRFC;
import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Vector;

public class D30MembershipFeeDetailSV extends ApprovalBaseServlet {

    private String UPMU_TYPE = "18";     // ���� ����Ÿ��(�ڰݸ�����)
    private String UPMU_NAME = "ȸ��";

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

            /* �ڰ� ���� ��ȸ */
            final D30MembershipFeeRFC membershipFeeRFC = new D30MembershipFeeRFC();
            membershipFeeRFC.setDetailInput(user.empNo, I_APGUB, box.get("AINF_SEQN"));
            Vector<D30MembershipFeeData> resultList = membershipFeeRFC.getDetail(); //��� ����Ÿ

            if (jobid.equals("first")) {           //����ó�� ��û ȭ�鿡 ���°��.

//                req.setAttribute("resultData", Utils.indexOf(resultList, 0));
                req.setAttribute("resultList", resultList);

                if (!detailApporval(req, res, membershipFeeRFC))
                    return;

                printJspPage(req, res, WebUtil.JspURL + "D/D30MembershipFee/D30MembershipFeeDetail.jsp");

            } else if (jobid.equals("delete")) {           //����ó�� ��û ȭ�鿡 ���°��.

                String dest = deleteApproval(req, box, membershipFeeRFC, new DeleteFunction() {
                    public boolean porcess() throws GeneralException {

                        D30MembershipFeeRFC deleteRFC = new D30MembershipFeeRFC();
                        deleteRFC.setDeleteInput(user.empNo, UPMU_TYPE, membershipFeeRFC.getApprovalHeader().AINF_SEQN);

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
