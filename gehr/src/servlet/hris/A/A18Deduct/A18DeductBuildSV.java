/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR ����                                                  */
/*   2Depth Name  : ��õ¡�������� ��û                                         */
/*   Program Name : ��õ¡�������� ��û                                         */
/*   Program ID   : A18DeductBuildSV                                            */
/*   Description  : �ٷμҵ� ��õ¡�� ������, ���ټ� ��õ¡�� ���� ��û��     */
/*                  �Ҽ� �ֵ��� �ϴ� Class                                      */
/*   Note         :                                                             */
/*   Creation     : 2002-10-22  �赵��                                          */
/*   Update       : 2005-02-18  ������                                          */
/*                                                                              */
/********************************************************************************/

package	servlet.hris.A.A18Deduct;

import com.common.Utils;
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
import hris.common.approval.ApprovalLineData;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Vector;

public class A18DeductBuildSV extends ApprovalBaseServlet {

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

            if (jobid.equals("first")) {   //����ó�� ��û ȭ�鿡 ���°��.
                String PERNR = getPERNR(box, user); //��û����� ���

                /*PersonInfoRFC personInfoRFC = new PersonInfoRFC();
                req.setAttribute("personInfo", personInfoRFC.getPersonInfo(PERNR));*/

                //�������, ���� ��� ���� ��ȸ
                getApprovalInfo(req, PERNR);

                hris.D.rfc.D00TaxAdjustPeriodRFC periodRFC           = new hris.D.rfc.D00TaxAdjustPeriodRFC();
                D00TaxAdjustPeriodData taxAdjustPeriodData = (hris.D.D00TaxAdjustPeriodData) periodRFC.getPeriod(user.companyCode,PERNR);

                String openDate = DataUtil.removeSeparate(taxAdjustPeriodData.YEAR_OPEN); //��������Ⱓ���� ��õ¡��������
                String currDate = DataUtil.removeSeparate(DataUtil.getCurrentDate());

                //��õ¡�������� ���� ���� ��û����  C20140106_63914
                if (Long.parseLong(currDate) >= Long.parseLong(openDate)) {
                    req.setAttribute("openDYear", Integer.parseInt(taxAdjustPeriodData.YEA_YEAR));
                } else {
                    req.setAttribute("openDYear", Integer.parseInt(taxAdjustPeriodData.YEA_YEAR) - 1);
                }

                req.setAttribute("gubunList", (new A18GuenTypeRFC()).getGuenType());

                dest = WebUtil.JspURL + "A/A18Deduct/A18DeductBuild.jsp";
            } else if (jobid.equals("create")) {

                /* ���� ��û �κ� */
                dest = requestApproval(req, box, A18DeductData.class, new ApprovalBaseServlet.RequestFunction<A18DeductData>() {
                    public String porcess(A18DeductData inputData, Vector<ApprovalLineData> approvalLine) throws GeneralException {

                        /* ���� ��û RFC ȣ�� */
                        A18DeductRFC a18DeductRFC = new A18DeductRFC();
                        a18DeductRFC.setRequestInput(user.empNo, UPMU_TYPE);
                        String AINF_SEQN = a18DeductRFC.build(Utils.asVector(inputData), box, req);

                        if(!a18DeductRFC.getReturn().isSuccess()) {
                            throw new GeneralException(a18DeductRFC.getReturn().MSGTX);
                        }

                        return AINF_SEQN;
                        /* ������ �ۼ� �κ� �� */

                        /*
                        if (data.PRINT_CHK.equals("1")){ //���ι���
                            msg2 = "����� ���� �� HR��Ÿ - ������ - ����ϷṮ�� ���� ��°����մϴ�.";
                        }
                     */
                    }
                });

            } else {
                throw new GeneralException(g.getMessage("MSG.COMMON.0016"));
            }
            Logger.debug.println(this, " destributed = " + dest);
            printJspPage(req, res, dest);

        } catch (Exception e) {
            Logger.error(e);
            throw new GeneralException(e);
        }
    }
}
