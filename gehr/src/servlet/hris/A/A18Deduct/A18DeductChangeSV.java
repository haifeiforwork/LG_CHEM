/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : ��û                                                        */
/*   2Depth Name  : �������û                                                  */
/*   Program Name : ��õ¡�������� ����                                         */
/*   Program ID   : A18DeductChangeSV                                           */
/*   Description  : ��õ¡���������� ���� �Ҽ� �ֵ��� �ϴ� Class                */
/*   Note         :                                                             */
/*   Creation     : 2002-10-22  �赵��                                          */
/*   Update       : 2005-03-04  �����                                          */
/*                                                                              */
/********************************************************************************/
package	servlet.hris.A.A18Deduct;

import com.common.Utils;
import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;
import hris.A.A18Deduct.A18DeductData;
import hris.A.A18Deduct.rfc.A18DeductRFC;
import hris.A.A18Deduct.rfc.A18GuenTypeRFC;
import hris.D.D00TaxAdjustPeriodData;
import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalHeader;
import hris.common.approval.ApprovalLineData;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Vector;

public class A18DeductChangeSV extends ApprovalBaseServlet {

    private String UPMU_TYPE ="28";
    private String UPMU_NAME = "��õ¡��������";

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
            final A18DeductRFC a18DeductRFC = new A18DeductRFC();
            a18DeductRFC.setDetailInput(user.empNo, I_APGUB, AINF_SEQN);

            Vector<A18DeductData> resultList = a18DeductRFC.getDetail(); //��� ����Ÿ
            A18DeductData resultData = Utils.indexOf(resultList, 0);


            if (jobid.equals("first")) {  //����ó�� ���� ȭ�鿡 ���°��.
                req.setAttribute("resultData", resultData);

                req.setAttribute("isUpdate", true); //��� ���� ����

                detailApporval(req, res, a18DeductRFC);

                hris.D.rfc.D00TaxAdjustPeriodRFC periodRFC           = new hris.D.rfc.D00TaxAdjustPeriodRFC();
                D00TaxAdjustPeriodData taxAdjustPeriodData = (hris.D.D00TaxAdjustPeriodData) periodRFC.getPeriod(user.companyCode, resultData.PERNR);

                String openDate = DataUtil.removeSeparate(taxAdjustPeriodData.YEAR_OPEN); //��������Ⱓ���� ��õ¡��������
                String currDate = DataUtil.removeSeparate(DataUtil.getCurrentDate());

                //��õ¡�������� ���� ���� ��û����  C20140106_63914
                if (Long.parseLong(currDate) >= Long.parseLong(openDate)) {
                    req.setAttribute("openDYear", Integer.parseInt(taxAdjustPeriodData.YEA_YEAR));
                } else {
                    req.setAttribute("openDYear", Integer.parseInt(taxAdjustPeriodData.YEA_YEAR) - 1);
                }

                req.setAttribute("gubunList", (new A18GuenTypeRFC()).getGuenType());

                printJspPage(req, res, WebUtil.JspURL + "A/A18Deduct/A18DeductBuild.jsp");

            } else if (jobid.equals("change")) {

                /* ���� ��û �κ� */
                dest = changeApproval(req, box, A18DeductData.class, a18DeductRFC, new ChangeFunction<A18DeductData>() {

                    public String porcess(A18DeductData inputData, ApprovalHeader approvalHeader, Vector<ApprovalLineData> approvalLineDatas) throws GeneralException {

                        /* ���� ��û RFC ȣ�� */
                        A18DeductRFC changeRFC = new A18DeductRFC();
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
