/********************************************************************************/
/*                                                                              */
/*   System Name  :  e-HR                                                        */
/*   1Depth Name  : HR 결재함                                                   */
/*   2Depth Name  : 결재 해야할 문서                                            */
/*   Program Name : 재해 신청                                                   */
/*   Program ID   : G020ApprovalDisasterSV                                      */
/*   Description  : 재해 신청 부서장 결재/반려                                  */
/*   Note         : 없음                                                        */
/*   Creation     : 2005-03-14  이승희                                          */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/

package servlet.hris.G;

import hris.E.E19Disaster.E19CongcondData;
import hris.E.E19Disaster.rfc.E19CongraRequestRFC;
import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalHeader;
import hris.common.approval.ApprovalLineData;

import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;


public class G020ApprovalDisasterSV extends ApprovalBaseServlet
{
    private String UPMU_TYPE ="09";  // 결재 업무타입(재해)
    private String UPMU_NAME = "재해";

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

            final E19CongraRequestRFC e19CongraRequestRFC = new E19CongraRequestRFC();
            e19CongraRequestRFC.setDetailInput(user.empNo, "1", AINF_SEQN);

            Vector resultList = e19CongraRequestRFC.getDetail(); //결과 데이타

            Vector E19CongcondData_vt = (Vector)resultList.get(0);

            final E19CongcondData e19CongcondData = (E19CongcondData)E19CongcondData_vt.get(0);//결과 데이타
            /* 승인 반려 시 */

            /* 승인 시 */
            if("A".equals(jobid)) {
                /* 개발자 영역 끝 */
                dest = accept(req, box, "T_ZHRA002T", e19CongcondData, e19CongraRequestRFC, new ApprovalFunction<E19CongcondData>() {
                    public boolean porcess(E19CongcondData inputData, ApprovalHeader approvalHeader, Vector<ApprovalLineData> approvalLineDatas) throws GeneralException {

                        /* 개발자 영역 시작 */

                            inputData.PROOF = box.get("PROOF");
                            inputData.UNAME     = user.empNo;
                            inputData.AEDTM     = DataUtil.getCurrentDate();

                        return true;
                    }
                });

            /* 반려시 */
            } else if("R".equals(jobid)) {
                dest = reject(req, box, null, e19CongcondData, e19CongraRequestRFC, null);
            } else if("C".equals(jobid)) {
                dest = cancel(req, box, null, e19CongcondData, e19CongraRequestRFC, null);
            }else {
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

