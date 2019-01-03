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
package servlet.hris.A.A13Address;

import com.common.RFCReturnEntity;
import com.common.Utils;
import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.WebUtil;
import hris.A.A13Address.A13AddressApprovalData;
import hris.A.A13Address.rfc.A13AddressApprovalRFC;
import hris.A.A13Address.rfc.A13AddressTypeRFC;
import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Vector;

public class A13AddressApprovalDetailSV extends ApprovalBaseServlet {

    private String UPMU_TYPE = "14";     // ���� ����Ÿ��(�ڰݸ�����)
    private String UPMU_NAME = "address";

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
            final A13AddressApprovalRFC addressApprovalRFC = new A13AddressApprovalRFC();
            addressApprovalRFC.setDetailInput(user.empNo, I_APGUB, box.get("AINF_SEQN"));
            Vector<A13AddressApprovalData> resultList = addressApprovalRFC.getDetail(); //��� ����Ÿ

            if (jobid.equals("first")) {           //����ó�� ��û ȭ�鿡 ���°��.

                req.setAttribute("subTypeList", (new A13AddressTypeRFC()).getAddressType("01"));

                req.setAttribute("resultData", Utils.indexOf(resultList, 0));

                if (!detailApporval(req, res, addressApprovalRFC))
                    return;

                printJspPage(req, res, WebUtil.JspURL + "A/A13Address/A13AddressApprovalDetail_" + user.area + ".jsp");

            } else if (jobid.equals("delete")) {           //����ó�� ��û ȭ�鿡 ���°��.

                String dest = deleteApproval(req, box, addressApprovalRFC, new DeleteFunction() {
                    public boolean porcess() throws GeneralException {

                        A13AddressApprovalRFC deleteRFC = new A13AddressApprovalRFC();
                        deleteRFC.setDeleteInput(user.empNo, UPMU_TYPE, addressApprovalRFC.getApprovalHeader().AINF_SEQN);

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
