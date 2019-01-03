/********************************************************************************/
/*                                                                              */
/*   System Name  : e-HR                                                        */
/*   1Depth Name  : HR 결재함                                                   */
/*   2Depth Name  : 결재 해야할 문서                                            */
/*   Program Name : 교육 출장 신청                                              */
/*   Program ID   : G068ApprovalEduTripSV                                       */
/*   Description  : 초과 근무 신청부서장  결재/반려                             */
/*   Note         : 없음                                                        */
/*   Creation     : 2010-03-31  lsa                                             */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/
package servlet.hris.G;

import hris.D.D19EduTrip.D19EduTripData;
import hris.D.D19EduTrip.rfc.D19EduTripRFC;
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


public class G068ApprovalEduTripSV extends ApprovalBaseServlet
{
    private String UPMU_TYPE ="35";            // 결재 업무타입(교육, 출장신청)
	private String UPMU_NAME = "교육/출장 신청";

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
            final D19EduTripRFC d19EduTripRFC = new D19EduTripRFC();
            d19EduTripRFC.setDetailInput(user.empNo, "1", AINF_SEQN);
            D19EduTripData  eduTripData  = Utils.indexOf(d19EduTripRFC.getVocation(), 0); //결과 데이타

            /* 승인 시 */
            if("A".equals(jobid)) {
                /* 개발자 영역 끝 */
                dest = accept(req, box, "", eduTripData, d19EduTripRFC, new ApprovalFunction<D19EduTripData>() {
                    public boolean porcess(D19EduTripData inputData, ApprovalHeader approvalHeader, Vector<ApprovalLineData> approvalLineDatas) throws GeneralException {
                      return true;
                    }
                });

                /* 반려시 */
            } else if("R".equals(jobid)) {
                dest = reject(req, box, null, eduTripData, d19EduTripRFC, null);
            } else if("C".equals(jobid)) {
                dest = cancel(req, box, null, eduTripData, d19EduTripRFC, null);
            } else {
                throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
            }


            Logger.debug.println(this, " destributed = " + dest);
            printJspPage(req, res, dest);

        } catch(Exception e) {
            Logger.err.println(DataUtil.getStackTrace(e));
            throw new GeneralException(e);
        } finally {

        }
    }


}