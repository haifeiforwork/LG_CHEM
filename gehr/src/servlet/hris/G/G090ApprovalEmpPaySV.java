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
import hris.D.D15EmpPayInfo.D15EmpPayData;
import hris.D.D15EmpPayInfo.rfc.D15EmpPayRFC;
import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalHeader;
import hris.common.approval.ApprovalLineData;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Vector;


public class G090ApprovalEmpPaySV extends ApprovalBaseServlet {

    private String UPMU_TYPE = "17";     // 결재 업무타입(자격면허등록)
    private String UPMU_NAME = "지급/공제";

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

            final D15EmpPayRFC d15EmpPayRFC = new D15EmpPayRFC();
            d15EmpPayRFC.setDetailInput(user.empNo, "1", AINF_SEQN);
            final Vector<D15EmpPayData> empPayList = d15EmpPayRFC.getDetail(); //결과 데이타

            final D15EmpPayData firstData = Utils.indexOf(empPayList, 0); //결과 데이타

            box.put("BEGDA", firstData.BEGDA);

            for(D15EmpPayData row : empPayList) {
                row.ZMONTH = row.YYYYMM;
            }

            /* 승인 시 */
            if("A".equals(jobid)) {
                /* 개발자 영역 끝 */
                dest = accept(req, box, "T_ZGHR3001T", empPayList, d15EmpPayRFC, new ApprovalFunction<Vector<D15EmpPayData>>() {
                    public boolean porcess(Vector<D15EmpPayData> inputData, ApprovalHeader approvalHeader, Vector<ApprovalLineData> approvalLineDatas) throws GeneralException {
                        return true;
                    }
                });

            /* 반려시 */
            } else if("R".equals(jobid)) {
                dest = reject(req, box, null, empPayList, d15EmpPayRFC, null);
            } else if("C".equals(jobid)) {
                dest = cancel(req, box, null, empPayList, d15EmpPayRFC, null);
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