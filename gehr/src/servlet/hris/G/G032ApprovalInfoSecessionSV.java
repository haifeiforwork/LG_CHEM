/********************************************************************************/
/*                                                                              */
/*   System Name  :  e-HR                                                        */
/*   1Depth Name  : HR 결재함                                                   */
/*   2Depth Name  : 결재 해야할 문서                                            */
/*   Program Name : 인포멀 탈퇴 신청                                            */
/*   Program ID   : G032ApprovalInfoSecessionSV                                 */
/*   Description  : 인포멀 탈퇴 간사 결재/반려                                  */
/*   Note         : 없음                                                        */
/*   Creation     : 2005-03-14  이승희                                          */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/

package servlet.hris.G;

import hris.E.E26InfoState.E26InfoStateData;
import hris.E.E26InfoState.rfc.E26InfosecessionRFC;
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


public class G032ApprovalInfoSecessionSV extends ApprovalBaseServlet
{
    private String UPMU_NAME = "인포멀 탈퇴";

    private String UPMU_TYPE = "27";     // 결재 업무타입(인포멀 가입)


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

        final E26InfosecessionRFC e26InfosecessionRFC = new E26InfosecessionRFC();
        e26InfosecessionRFC.setDetailInput(user.empNo, "1", AINF_SEQN);
        final E26InfoStateData e26InfoStateData = Utils.indexOf(e26InfosecessionRFC.getDetail(), 0); //결과 데이타

        /* 승인 시 */
        if("A".equals(jobid)) {
            /* 개발자 영역 끝 */
            dest = accept(req, box, "", e26InfoStateData, e26InfosecessionRFC, new ApprovalFunction<E26InfoStateData>() {
                public boolean porcess(E26InfoStateData inputData, ApprovalHeader approvalHeader, Vector<ApprovalLineData> approvalLineDatas) throws GeneralException {

                    /* 개발자 영역 시작 */


                    return true;
                }
            });

        /* 반려시 */
        } else if("R".equals(jobid)) {
            dest = reject(req, box, "", e26InfoStateData, e26InfosecessionRFC, null);
        } else if("C".equals(jobid)) {
            dest = cancel(req, box, "", e26InfoStateData, e26InfosecessionRFC, null);
        }else {
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
