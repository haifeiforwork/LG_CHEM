/********************************************************************************/
/*                                                                              */
/*   System Name  : e-HR                                                        */
/*   1Depth Name  : HR 결재함                                                   */
/*   2Depth Name  : 결재 해야할 문서                                            */
/*   Program Name : 건강보험 재발급  신청                                       */
/*   Program ID   : G039ApprovalMedicareSV                                      */
/*   Description  : 건강보험 재발급 담당자 결재/반려                            */
/*   Note         : 없음                                                        */
/*   Creation     : 2005-03-14  이승희                                          */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/

package servlet.hris.G;

import hris.E.E02Medicare.E02MedicareData;
import hris.E.E02Medicare.rfc.E02MedicareRFC;
import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalHeader;
import hris.common.approval.ApprovalLineData;

import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.common.Utils;
import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;


public class G039ApprovalMedicareSV extends ApprovalBaseServlet
{
    private String UPMU_TYPE ="21";
    private String UPMU_NAME = "건강보험 재발급";

    protected String getUPMU_TYPE() {
        return UPMU_TYPE;
    }

    protected String getUPMU_NAME() {
        return UPMU_NAME;
    }

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        try{
        	final WebUserData user = WebUtil.getSessionUser(req);

            String dest  = "";

            final Box box = WebUtil.getBox(req);

            String  AINF_SEQN  = box.get("AINF_SEQN");

            String jobid = box.get("jobid");
            /* 승인 반려 시 */

            final E02MedicareRFC e02MedicareRFC = new E02MedicareRFC();
            e02MedicareRFC.setDetailInput(user.empNo, "1", AINF_SEQN);
            final E02MedicareData e02MedicareData = Utils.indexOf(e02MedicareRFC.getDetail(), 0); //결과 데이타

            /* 승인 시 */
            if("A".equals(jobid)) {
                /* 개발자 영역 끝 */
                dest = accept(req, box, null, e02MedicareData, e02MedicareRFC, new ApprovalFunction<E02MedicareData>() {
                    public boolean porcess(E02MedicareData inputData, ApprovalHeader approvalHeader, Vector<ApprovalLineData> approvalLineDatas) throws GeneralException {
                        return true;
                    }
                });

            /* 반려시 */
            } else if("R".equals(jobid)) {
                dest = reject(req, box, null, e02MedicareData, e02MedicareRFC, null);
            } else if("C".equals(jobid)) {
                dest = cancel(req, box, null, e02MedicareData, e02MedicareRFC, null);
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
