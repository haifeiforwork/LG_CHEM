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

package servlet.hris.A.A13Address;

import com.common.Utils;
import com.common.constant.Area;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.WebUtil;
import hris.A.A13Address.A13AddressApprovalData;
import hris.A.A13Address.rfc.A13AddressApprovalRFC;
import hris.A.A13Address.rfc.A13AddressListRFC;
import hris.A.A13Address.rfc.A13AddressTypeRFC;
import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalLineData;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Vector;

public class A13AddressApprovalBuildSV extends ApprovalBaseServlet {

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

            final Box box = WebUtil.getBox(req);

            String dest;

            String jobid = box.get("jobid", "first");

            if(user.area != Area.DE) {
                moveMsgPage(req, res, g.getMessage("MSG.COMMON.0060"), "history.back();");
            }

            if (jobid.equals("first")) {   //����ó�� ��û ȭ�鿡 ���°��.

                Vector a13AddressListData_vt = (new A13AddressListRFC()).getAddressList(box);
                req.setAttribute("a13AddressListData_vt", a13AddressListData_vt);

                req.setAttribute("subTypeList", (new A13AddressTypeRFC()).getAddressType("01"));

                String PERNR = getPERNR(box, user); //��û����� ���

                //�������, ���� ��� ���� ��ȸ
                getApprovalInfo(req, PERNR);

                printJspPage(req, res, WebUtil.JspURL+"A/A13Address/A13AddressApprovalBuild_" + user.area +".jsp");
            } else if (jobid.equals("create")) {

                /* ���� ��û �κ� */
                dest = requestApproval(req, box, A13AddressApprovalData.class, new RequestFunction<A13AddressApprovalData>() {
                    public String porcess(A13AddressApprovalData inputData, Vector<ApprovalLineData> approvalLine) throws GeneralException {

                        /* ���� ��û RFC ȣ�� */
                        A13AddressApprovalRFC addressApprovalRFC = new A13AddressApprovalRFC();
                        addressApprovalRFC.setRequestInput(user.empNo, UPMU_TYPE);
                        String AINF_SEQN = addressApprovalRFC.build(Utils.asVector(inputData), box, req);

                        if(!addressApprovalRFC.getReturn().isSuccess()) {
                            throw new GeneralException(addressApprovalRFC.getReturn().MSGTX);
                        };

                        return AINF_SEQN;
                        /* ������ �ۼ� �κ� �� */
                    }
                });

                printJspPage(req, res, dest);
            } else {
                throw new GeneralException("MSG.COMMON.0016");
            }
        } catch (Exception e) {
            Logger.error(e);
            throw new GeneralException(e);
        }
    }

}
