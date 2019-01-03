/********************************************************************************/
/*                                                                              */
/*   System Name  : e-HR                                                        */
/*   1Depth Name  : HR 결재함                                                   */
/*   2Depth Name  : 결재 해야할 문서                                            */
/*   Program Name : 건강보험 피부양자 신청                                      */
/*   Program ID   : G037ApprovalMedicareSV                                      */
/*   Description  : 건강보험 피부양자 신청 담당자 결재/반려                     */
/*   Note         : 없음                                                        */
/*   Creation     : 2005-03-14  이승희                                          */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/

package servlet.hris.G;

import hris.E.E01Medicare.E01HealthGuaranteeData;
import hris.E.E01Medicare.rfc.E01HealthGuaranteeRFC;
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


public class G037ApprovalMedicareSV extends ApprovalBaseServlet
{
    private String UPMU_TYPE ="20";   // 결재 업무타입(자격변경)
    private String UPMU_NAME = "건강보험 피부양자";

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

                final E01HealthGuaranteeRFC e01HealthGuaranteeRFC = new E01HealthGuaranteeRFC();
                e01HealthGuaranteeRFC.setDetailInput(user.empNo, "1", AINF_SEQN);
                Vector<E01HealthGuaranteeData> e01HealthGuaranteeData_vt = e01HealthGuaranteeRFC.getDetail(); //결과 데이타
                E01HealthGuaranteeData firstData = Utils.indexOf(e01HealthGuaranteeData_vt, 0);
                /* 승인 시 */
                if("A".equals(jobid)) {
                    /* 개발자 영역 끝 */
                    dest = accept(req, box, null, firstData, e01HealthGuaranteeRFC, new ApprovalFunction<E01HealthGuaranteeData>() {
                        public boolean porcess(E01HealthGuaranteeData inputData, ApprovalHeader approvalHeader, Vector<ApprovalLineData> approvalLineDatas) throws GeneralException {


                            return true;
                        }
                    });
                    /* 반려시 */
                } else if("R".equals(jobid)) {

                    dest = reject(req, box, null, firstData, e01HealthGuaranteeRFC, null);
                } else if("C".equals(jobid)) {
                    dest = cancel(req, box, null, firstData, e01HealthGuaranteeRFC, null);
                }  else {
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


