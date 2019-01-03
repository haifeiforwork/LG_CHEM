/********************************************************************************/
/*                                                                              */
/*   System Name  :  e-HR                                                        */
/*   1Depth Name  : HR ������                                                   */
/*   2Depth Name  : ���� �ؾ��� ����                                            */
/*   Program Name : �ξ簡�� ��û                                               */
/*   Program ID   : G018ApprovalSupportSV                                       */
/*   Description  : �ξ簡�� ���� ����� ,���μ��� ����/�ݷ�                  */
/*   Note         : ����                                                        */
/*   Creation     : 2005-03-14  �̽���                                          */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/

package servlet.hris.G;

import com.common.Utils;
import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;
import hris.A.A12Family.A12FamilyBuyangData;
import hris.A.A12Family.rfc.A12FamilyBuyangRFC;
import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalHeader;
import hris.common.approval.ApprovalLineData;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Vector;


public class G018ApprovalSupportSV extends ApprovalBaseServlet {

    private String UPMU_TYPE ="07";   // ���� ����Ÿ��(�ξ簡��)
    private String UPMU_NAME = "�ξ簡��";

    protected String getUPMU_TYPE() {
        return UPMU_TYPE;
    }

    protected String getUPMU_NAME() {
        return UPMU_NAME;
    }

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {
        try{
            final WebUserData user = WebUtil.getSessionUser(req);

            String dest  = "";

            final Box box = WebUtil.getBox(req);

            String  AINF_SEQN  = box.get("AINF_SEQN");

            String jobid = box.get("jobid");
            /* ���� �ݷ� �� */

            /* ���� �� */
            if("A".equals(jobid)) {

                final A12FamilyBuyangRFC a12FamilyBuyangRFC = new A12FamilyBuyangRFC();
                a12FamilyBuyangRFC.setDetailInput(user.empNo, "1", AINF_SEQN);
                A12FamilyBuyangData familyBuyangData = Utils.indexOf(a12FamilyBuyangRFC.getFamilyBuyang(), 0); //��� ����Ÿ

                /* ������ ���� �� "T_ZHRA013T" */
                dest = accept(req, box, "T_ZHRA013T", familyBuyangData, a12FamilyBuyangRFC, new ApprovalFunction<A12FamilyBuyangData>() {
                    public boolean porcess(A12FamilyBuyangData inputData, ApprovalHeader approvalHeader, Vector<ApprovalLineData> approvalLineDatas) throws GeneralException {

                        return true;
                    }
                });

            /* �ݷ��� */
            } else if("R".equals(jobid)) {
                final A12FamilyBuyangRFC a12FamilyBuyangRFC = new A12FamilyBuyangRFC();
                a12FamilyBuyangRFC.setDetailInput(user.empNo, "1", AINF_SEQN);
                final A12FamilyBuyangData familyBuyangData = Utils.indexOf(a12FamilyBuyangRFC.getFamilyBuyang(), 0); //��� ����Ÿ

                dest = reject(req, box, null, familyBuyangData, a12FamilyBuyangRFC, null);
            } else if("C".equals(jobid)) {
                final A12FamilyBuyangRFC a12FamilyBuyangRFC = new A12FamilyBuyangRFC();
                a12FamilyBuyangRFC.setDetailInput(user.empNo, "1", AINF_SEQN);
                final A12FamilyBuyangData familyBuyangData = Utils.indexOf(a12FamilyBuyangRFC.getFamilyBuyang(), 0); //��� ����Ÿ

                dest = cancel(req, box, null, familyBuyangData, a12FamilyBuyangRFC, null);
            } else {
                throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
            }


            Logger.debug.println(this, " destributed = " + dest);
            printJspPage(req, res, dest);

        } catch(Exception e) {
            Logger.err.println(DataUtil.getStackTrace(e));
            throw new GeneralException(e);
        }
    }
}