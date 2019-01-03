/********************************************************************************/
/*                                                                              */
/*   System Name  :  e-HR                                                        */
/*   1Depth Name  : HR 결재함                                                   */
/*   2Depth Name  : 결재 해야할 문서                                            */
/*   Program Name : 부양가족 신청                                               */
/*   Program ID   : G018ApprovalSupportSV                                       */
/*   Description  : 부양가족 업무 담당자 ,담당부서장 결재/반려                  */
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

    private String UPMU_TYPE ="07";   // 결재 업무타입(부양가족)
    private String UPMU_NAME = "부양가족";

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

            /* 승인 시 */
            if("A".equals(jobid)) {

                final A12FamilyBuyangRFC a12FamilyBuyangRFC = new A12FamilyBuyangRFC();
                a12FamilyBuyangRFC.setDetailInput(user.empNo, "1", AINF_SEQN);
                A12FamilyBuyangData familyBuyangData = Utils.indexOf(a12FamilyBuyangRFC.getFamilyBuyang(), 0); //결과 데이타

                /* 개발자 영역 끝 "T_ZHRA013T" */
                dest = accept(req, box, "T_ZHRA013T", familyBuyangData, a12FamilyBuyangRFC, new ApprovalFunction<A12FamilyBuyangData>() {
                    public boolean porcess(A12FamilyBuyangData inputData, ApprovalHeader approvalHeader, Vector<ApprovalLineData> approvalLineDatas) throws GeneralException {

                        return true;
                    }
                });

            /* 반려시 */
            } else if("R".equals(jobid)) {
                final A12FamilyBuyangRFC a12FamilyBuyangRFC = new A12FamilyBuyangRFC();
                a12FamilyBuyangRFC.setDetailInput(user.empNo, "1", AINF_SEQN);
                final A12FamilyBuyangData familyBuyangData = Utils.indexOf(a12FamilyBuyangRFC.getFamilyBuyang(), 0); //결과 데이타

                dest = reject(req, box, null, familyBuyangData, a12FamilyBuyangRFC, null);
            } else if("C".equals(jobid)) {
                final A12FamilyBuyangRFC a12FamilyBuyangRFC = new A12FamilyBuyangRFC();
                a12FamilyBuyangRFC.setDetailInput(user.empNo, "1", AINF_SEQN);
                final A12FamilyBuyangData familyBuyangData = Utils.indexOf(a12FamilyBuyangRFC.getFamilyBuyang(), 0); //결과 데이타

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