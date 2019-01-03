/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR ����                                                  */
/*   1Depth Name  : MY HR ����                                                  */
/*   2Depth Name  : �������� �߰��Է�                                           */
/*   Program Name : �ξ簡�� ��û ����                                          */
/*   Program ID   : A12SupportChangeSV                                          */
/*   Description  : �ξ簡���� ��û�� ������ �� �ֵ��� �ϴ� Class               */
/*   Note         :                                                             */
/*   Creation     : 2002-01-03  �赵��                                          */
/*   Update       : 2005-03-07  ������                                          */
/*                                                                              */
/********************************************************************************/

package servlet.hris.A.A12Family;

import com.common.Utils;
import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.WebUtil;
import hris.A.A12Family.A12FamilyBuyangData;
import hris.A.A12Family.A12FamilyListData;
import hris.A.A12Family.rfc.A12FamilyBuyangRFC;
import hris.A.A12Family.rfc.A12FamilyListRFC;
import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalHeader;
import hris.common.approval.ApprovalLineData;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Vector;

public class A12SupportChangeSV extends ApprovalBaseServlet {

    private String UPMU_TYPE = "07";   // ���� ����Ÿ��(�ξ簡��)
    private String UPMU_NAME = "�ξ簡��";

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

            String I_APGUB = (String) req.getAttribute("I_APGUB");  //��� ���������� �Գ�? '1' : ������ ���� , '2' : ������ ���� , '3' : ����Ϸ� ����

            /* �ξ� ���� ��ȸ */
            final A12FamilyBuyangRFC a12FamilyBuyangRFC = new A12FamilyBuyangRFC();
            a12FamilyBuyangRFC.setDetailInput(user.empNo, I_APGUB, AINF_SEQN);

            Vector<A12FamilyBuyangData> resultList = a12FamilyBuyangRFC.getFamilyBuyang(); //��� ����Ÿ
            A12FamilyBuyangData resultData = Utils.indexOf(resultList, 0);


            if (jobid.equals("first")) {  //����ó�� ���� ȭ�鿡 ���°��.
                // �ξ簡�� ��û�� ����
                req.setAttribute("resultData", resultData);

                A12FamilyListRFC rfc_list             = new A12FamilyListRFC();
                Vector<A12FamilyListData> a12FamilyListData_vt = rfc_list.getFamilyList(resultData.PERNR, resultData.SUBTY, resultData.OBJPS);
                req.setAttribute("familyData", Utils.indexOf(a12FamilyListData_vt, 0));

                req.setAttribute("isUpdate", true); //��� ���� ����

                detailApporval(req, res, a12FamilyBuyangRFC);

                printJspPage(req, res, WebUtil.JspURL + "A/A12Family/A12SupportBuild.jsp");

            } else if (jobid.equals("change")) {

                /* ���� ��û �κ� */
                dest = changeApproval(req, box, A12FamilyBuyangData.class, a12FamilyBuyangRFC, new ApprovalBaseServlet.ChangeFunction<A12FamilyBuyangData>() {

                    public String porcess(A12FamilyBuyangData inputData, ApprovalHeader approvalHeader, Vector<ApprovalLineData> approvalLineDatas) throws GeneralException {

                        /* ���� ��û RFC ȣ�� */
                        A12FamilyBuyangRFC changeRFC = new A12FamilyBuyangRFC();
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
            Logger.error(e);
            throw new GeneralException(e);
        }
    }
}
