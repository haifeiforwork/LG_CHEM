/********************************************************************************/
/*                                                                              */
/*   System Name  :  e-HR                                                        */
/*   1Depth Name  : HR 결재함                                                   */
/*   2Depth Name  : 결재 해야할 문서                                            */
/*   Program Name : 자격 면허등록  신청                                         */
/*   Program ID   : G024ApprovalLicenceSV                                       */
/*   Description  : 자격 면허등록 업무 담당자 결재/반려                         */
/*   Note         : 없음                                                        */
/*   Creation     : 2005-03-14  이승희                                          */
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

    private String UPMU_TYPE = "18";     // 결재 업무타입(자격면허등록)
    private String UPMU_NAME = "회비";

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
            /* 승인 반려 시 */

            final D30MembershipFeeRFC membershipFeeRFC = new D30MembershipFeeRFC();
            membershipFeeRFC.setDetailInput(user.empNo, "1", AINF_SEQN);
            final Vector<D30MembershipFeeData> empPayList = membershipFeeRFC.getDetail(); //결과 데이타

            final D30MembershipFeeData firstData = Utils.indexOf(empPayList, 0); //결과 데이타

            box.put("BEGDA", firstData.BEGDA);

            for(D30MembershipFeeData row : empPayList) {
                row.ZMONTH = row.YYYYMM;
            }

            /* 승인 시 */
            if("A".equals(jobid)) {
                /* 개발자 영역 끝 */
                dest = accept(req, box, "T_ZGHR3001T", empPayList, membershipFeeRFC, new ApprovalFunction<Vector<D30MembershipFeeData>>() {
                    public boolean porcess(Vector<D30MembershipFeeData> inputData, ApprovalHeader approvalHeader, Vector<ApprovalLineData> approvalLineDatas) throws GeneralException {

                        return true;
                    }
                });

            /* 반려시 */
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