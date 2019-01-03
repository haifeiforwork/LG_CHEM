/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : ��û                                                        */
/*   2Depth Name  : ���λ���                                                    */
/*   Program Name : �ڰݸ���                                                    */
/*   Program ID   : A13AddressApprovalChangeSV                                          */
/*   Description  : �ڰݸ��㸦 ���� �Ҽ� �ֵ��� �ϴ� Class                      */
/*   Note         :                                                             */
/*   Creation     : 2002-01-14  �ֿ�ȣ                                          */
/*   Update       : 2005-02-25  �����                                          */
/*                                                                              */
/********************************************************************************/
package servlet.hris.A.A13Address;

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
import hris.common.approval.ApprovalHeader;
import hris.common.approval.ApprovalLineData;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Vector;

public class A13AddressApprovalChangeSV extends ApprovalBaseServlet {

    private String UPMU_TYPE = "14";     // ���� ����Ÿ��(�ڰݸ�����)
    private String UPMU_NAME = "address";

    protected String getUPMU_TYPE() {
        return UPMU_TYPE;
    }

    protected String getUPMU_NAME() {
        return UPMU_NAME;
    }

	protected void performTask(final HttpServletRequest req, HttpServletResponse res) throws GeneralException {

        try{
            final WebUserData user = WebUtil.getSessionUser(req);

            final Box box = WebUtil.getBox(req);

            String dest = null;

            String jobid = box.get("jobid", "first");
            String AINF_SEQN = box.get("AINF_SEQN");

            //**********���� ��.****************************

            String I_APGUB = (String) req.getAttribute("I_APGUB");  //��� ���������� �Գ�? '1' : ������ ���� , '2' : ������ ���� , '3' : ����Ϸ� ����

            /* �ڰ� ���� ��ȸ */
            final A13AddressApprovalRFC addressApprovalRFC = new A13AddressApprovalRFC();
            addressApprovalRFC.setDetailInput(user.empNo, I_APGUB, AINF_SEQN);

            Vector<A13AddressApprovalData> resultList = addressApprovalRFC.getDetail(); //��� ����Ÿ
            A13AddressApprovalData resultData = Utils.indexOf(resultList, 0);


            if( jobid.equals("first") ) {  //����ó�� ���� ȭ�鿡 ���°��.
                req.setAttribute("resultData", resultData);
                req.setAttribute("subTypeList", (new A13AddressTypeRFC()).getAddressType("01"));

                req.setAttribute("isUpdate", true); //��� ���� ����

                detailApporval(req, res, addressApprovalRFC);

                printJspPage(req, res, WebUtil.JspURL+"A/A13Address/A13AddressApprovalBuild_" + user.area +".jsp");

            } else if( jobid.equals("change") ) {

                /*���� ��û �κ�*/ 
                dest = changeApproval(req, box, A13AddressApprovalData.class, addressApprovalRFC, new ChangeFunction<A13AddressApprovalData>(){

                    public String porcess(A13AddressApprovalData inputData, ApprovalHeader approvalHeader, Vector<ApprovalLineData> approvalLineDatas) throws GeneralException {

                         /*���� ��û RFC ȣ��*/ 
                        A13AddressApprovalRFC changeRFC = new A13AddressApprovalRFC();
                        changeRFC.setChangeInput(user.empNo, UPMU_TYPE, approvalHeader.AINF_SEQN);

                        Logger.debug("-------- AINF_SEQN " + inputData.AINF_SEQN);

                        changeRFC.build(Utils.asVector(inputData), box, req);

                        if(!changeRFC.getReturn().isSuccess()) {
                            throw new GeneralException(changeRFC.getReturn().MSGTX);
                        }

                        return inputData.AINF_SEQN;
                         /*������ �ۼ� �κ� ��*/ 
                    }
                });

                printJspPage(req, res, dest);
            } else {
                throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
            }

        } catch(Exception e) {
            throw new GeneralException(e);
        }
	}
}
