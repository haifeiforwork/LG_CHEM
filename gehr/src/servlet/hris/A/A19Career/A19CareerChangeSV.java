/********************************************************************************/
/*                                                                                                                                                            */
/*   System Name   : MSS                                                                                                                       */
/*   1Depth Name   : MY HR ����                                                                                      */
/*   2Depth Name   : �������� ��û                                                                                */
/*   Program Name : ������� ��û ����                                                                          */
/*   Program ID   : A19CareerChangeSV                                                                                                */
/*   Description  : ������� ��û�� ���� �Ҽ� �ֵ��� �ϴ� Class                                                       */
/*   Note         :                                                                                                                                       */
/*   Creation     : 2002-04-11  ��뿵                                                                                */
/*   Update       :                                                                                                                                     */
/*                                                                                                                                                            */
/********************************************************************************/

package	servlet.hris.A.A19Career;

import com.common.Utils;
import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.WebUtil;
import hris.A.A19Career.A19CareerData;
import hris.A.A19Career.rfc.A19CareerRFC;
import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalHeader;
import hris.common.approval.ApprovalLineData;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Vector;

public class A19CareerChangeSV extends ApprovalBaseServlet {

    private String UPMU_TYPE ="34";
    private String UPMU_NAME = "�������";

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
            String AINF_SEQN = box.get("AINF_SEQN");

            //**********���� ��.****************************

            String I_APGUB = (String) req.getAttribute("I_APGUB");  //��� ���������� �Գ�? '1' : ������ ���� , '2' : ������ ���� , '3' : ����Ϸ� ����

            /* �ڰ� ���� ��ȸ */
            final A19CareerRFC a19CareerRFC = new A19CareerRFC();
            a19CareerRFC.setDetailInput(user.empNo, I_APGUB, AINF_SEQN);

            Vector<A19CareerData> resultList = a19CareerRFC.getDetail(); //��� ����Ÿ
            A19CareerData resultData = Utils.indexOf(resultList, 0);


            if (jobid.equals("first")) {  //����ó�� ���� ȭ�鿡 ���°��.
                req.setAttribute("resultData", resultData);

                req.setAttribute("isUpdate", true); //��� ���� ����

                detailApporval(req, res, a19CareerRFC);

                printJspPage(req, res, WebUtil.JspURL + "A/A19Career/A19CareerBuild.jsp");

            } else if (jobid.equals("change")) {

                /* ���� ��û �κ� */
                dest = changeApproval(req, box, A19CareerData.class, a19CareerRFC, new ChangeFunction<A19CareerData>() {

                    public String porcess(A19CareerData inputData, ApprovalHeader approvalHeader, Vector<ApprovalLineData> approvalLineDatas) throws GeneralException {

                        /* ���� ��û RFC ȣ�� */
                        A19CareerRFC changeRFC = new A19CareerRFC();
                        changeRFC.setChangeInput(user.empNo, UPMU_TYPE, approvalHeader.AINF_SEQN);

                        Logger.debug("-------- AINF_SEQN " + inputData.AINF_SEQN);

                        changeRFC.build(Utils.asVector(inputData), box, req);

                        if (!changeRFC.getReturn().isSuccess()) {
                            throw new GeneralException(changeRFC.getReturn().MSGTX);
                        }

                        return inputData.AINF_SEQN;
                        /* ������ �ۼ� �κ� �� */
                    }
                });

                printJspPage(req, res, dest);
            } else {
                throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
            }

        } catch (Exception e) {
            throw new GeneralException(e);
        }
    }
}
