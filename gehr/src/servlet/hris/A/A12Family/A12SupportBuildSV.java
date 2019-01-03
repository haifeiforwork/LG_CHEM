/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR ����                                                  */
/*   2Depth Name  : �������� �߰��Է�                                           */
/*   Program Name : �ξ簡�� ��û                                               */
/*   Program ID   : A12SupportBuildSV                                           */
/*   Description  : �ξ簡���� ��û�� �� �ֵ��� �ϴ� Class                      */
/*   Note         :                                                             */
/*   Creation     : 2002-01-03  �赵��                                          */
/*   Update       : 2005-03-07  ������                                          */
/*                                                                              */
/********************************************************************************/

package	servlet.hris.A.A12Family;

import com.common.Utils;
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
import hris.common.approval.ApprovalLineData;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Vector;

public class A12SupportBuildSV extends ApprovalBaseServlet {

    private String UPMU_TYPE ="07";   // ���� ����Ÿ��(�ξ簡��)
    private String UPMU_NAME = "�ξ簡��";

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

            String dest;

            String jobid = box.get("jobid", "first");

            if (jobid.equals("first")) {   //����ó�� ��û ȭ�鿡 ���°��.
                String PERNR = getPERNR(box, user); //��û����� ���

                //�������, ���� ��� ���� ��ȸ
                getApprovalInfo(req, PERNR);
                A12FamilyListRFC  rfc_list             = new A12FamilyListRFC();

                // �ξ簡�� ��û�� ����
                Vector<A12FamilyListData> a12FamilyListData_vt = rfc_list.getFamilyList(PERNR, box.get("SUBTY"), box.get("OBJPS"));
                req.setAttribute("familyData", Utils.indexOf(a12FamilyListData_vt, 0));
                req.setAttribute("RequestPageName", g.getRequestPageName(req));

                dest = WebUtil.JspURL+"A/A12Family/A12SupportBuild.jsp";
            } else if (jobid.equals("create")) {

                /* ���� ��û �κ� */
                dest = requestApproval(req, box, A12FamilyBuyangData.class, new RequestFunction<A12FamilyBuyangData>() {
                    public String porcess(A12FamilyBuyangData inputData, Vector<ApprovalLineData> approvalLine) throws GeneralException {

                        /* ���� ��û RFC ȣ�� */
                        A12FamilyBuyangRFC  rfc = new A12FamilyBuyangRFC();

                        rfc.setRequestInput(user.empNo, UPMU_TYPE);
                        String AINF_SEQN = rfc.build(Utils.asVector(inputData), box, req);

                        if(!rfc.getReturn().isSuccess()) {
                            throw new GeneralException(rfc.getReturn().MSGTX);
                        };

                        return AINF_SEQN;
                        /* ������ �ۼ� �κ� �� */
                    }
                });
            } else {
                throw new GeneralException("���θ��(jobid)�� �ùٸ��� �ʽ��ϴ�. ");
            }
            Logger.debug.println(this, " destributed = " + dest);
            printJspPage(req, res, dest);

        } catch (Exception e) {
            Logger.error(e);
            throw new GeneralException(e);
        }
    }
}
