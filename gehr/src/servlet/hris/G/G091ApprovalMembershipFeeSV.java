/********************************************************************************/
/*                                                                              */
/*   System Name  :  e-HR                                                        */
/*   1Depth Name  : HR ������                                                   */
/*   2Depth Name  : ���� �ؾ��� ����                                            */
/*   Program Name : �ڰ� ������  ��û                                         */
/*   Program ID   : G024ApprovalLicenceSV                                       */
/*   Description  : �ڰ� ������ ���� ����� ����/�ݷ�                         */
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
import hris.D.D30MembershipFee.D30MembershipFeeData;
import hris.D.D30MembershipFee.rfc.D30MembershipFeeRFC;
import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalHeader;
import hris.common.approval.ApprovalLineData;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Vector;


public class G091ApprovalMembershipFeeSV extends ApprovalBaseServlet {

    private String UPMU_TYPE = "18";     // ���� ����Ÿ��(�ڰݸ�����)
    private String UPMU_NAME = "ȸ��";

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

            final D30MembershipFeeRFC membershipFeeRFC = new D30MembershipFeeRFC();
            membershipFeeRFC.setDetailInput(user.empNo, "1", AINF_SEQN);
            final Vector<D30MembershipFeeData> empPayList = membershipFeeRFC.getDetail(); //��� ����Ÿ

            final D30MembershipFeeData firstData = Utils.indexOf(empPayList, 0); //��� ����Ÿ

            box.put("BEGDA", firstData.BEGDA);

            for(D30MembershipFeeData row : empPayList) {
                row.ZMONTH = row.YYYYMM;
            }

            /* ���� �� */
            if("A".equals(jobid)) {
                /* ������ ���� �� */
                dest = accept(req, box, "T_ZGHR3001T", empPayList, membershipFeeRFC, new ApprovalFunction<Vector<D30MembershipFeeData>>() {
                    public boolean porcess(Vector<D30MembershipFeeData> inputData, ApprovalHeader approvalHeader, Vector<ApprovalLineData> approvalLineDatas) throws GeneralException {

                        return true;
                    }
                });

            /* �ݷ��� */
            } else if("R".equals(jobid)) {
                dest = reject(req, box, null, empPayList, membershipFeeRFC, null);
            } else if("C".equals(jobid)) {
                dest = cancel(req, box, null, empPayList, membershipFeeRFC, null);
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