/********************************************************************************/
/*                                                                                                                                                            */
/*   System Name   : MSS                                                                                                                       */
/*   1Depth Name   : MY HR ����                                                                                      */
/*   2Depth Name   : ������� ��û                                                                                */
/*   Program Name : ������� ��û                                                                                */
/*   Program ID      : A19CareerBuildSV                                                                                                 */
/*   Description      : ��������� ��û�� �� �ֵ��� �ϴ� Class                                                           */
/*   Note                :                                                                                                                                */
/*   Creation          : 2006-04-11  ��뿵                                                                            */
/*   Update            :                                                                                                                                */
/*                                                                                                                                                            */
/********************************************************************************/

package	servlet.hris.A.A19Career;

import com.common.Utils;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.WebUtil;
import hris.A.A19Career.A19CareerData;
import hris.A.A19Career.rfc.A19CareerRFC;
import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalLineData;
import hris.common.rfc.PersonInfoRFC;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Vector;

public class A19CareerBuildSV extends ApprovalBaseServlet {

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

            if (jobid.equals("first")) {   //����ó�� ��û ȭ�鿡 ���°��.
                String PERNR = getPERNR(box, user); //��û����� ���

                PersonInfoRFC personInfoRFC = new PersonInfoRFC();
                req.setAttribute("personInfo", personInfoRFC.getPersonInfo(PERNR, "X"));

                //�������, ���� ��� ���� ��ȸ
                getApprovalInfo(req, PERNR);

                dest = WebUtil.JspURL + "A/A19Career/A19CareerBuild.jsp";
            } else if (jobid.equals("create")) {

                /* ���� ��û �κ� */
                dest = requestApproval(req, box, A19CareerData.class, new ApprovalBaseServlet.RequestFunction<A19CareerData>() {
                    public String porcess(A19CareerData inputData, Vector<ApprovalLineData> approvalLine) throws GeneralException {

                        /* ���� ��û RFC ȣ�� */
                        A19CareerRFC a19CareerRFC = new A19CareerRFC();
                        a19CareerRFC.setRequestInput(user.empNo, UPMU_TYPE);
                        String AINF_SEQN = a19CareerRFC.build(Utils.asVector(inputData), box, req);

                        if(!a19CareerRFC.getReturn().isSuccess()) {
                            throw new GeneralException(a19CareerRFC.getReturn().MSGTX);
                        };

                        /*if (data.CAREER_TYPE.equals("4") ){//����
                            msg2 = "";
                        }else if (data.PRINT_CHK.equals("1")){ //���ι���
                            msg2 = "����� ���� �� HR��Ÿ - ������ - ����ϷṮ�� ���� ��°����մϴ�.";
                        }*/

                        return AINF_SEQN;
                        /* ������ �ۼ� �κ� �� */
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
