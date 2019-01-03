/********************************************************************************/
/*                                                                                                                                                            */
/*   System Name   : e-HR                                                                                                                         */
/*   1Depth Name   : HR 결재함                                                                                                                */
/*   2Depth Name   : 결재 해야할 문서                                                                                                    */
/*   Program Name : 경력 증명 신청                                                                                                       */
/*   Program ID      : G064ApprovalCareerSV                                                                                               */
/*   Description       : 경력증명 업무 담당자 결재/반려                                                                           */
/*   Note               : 없음                                                                                                                         */
/*   Creation          : 2006-04-17  김대영                                                                                                  */
/*   Update       :                                                                                                                                      */
/*                                                                                                                                                            */
/********************************************************************************/
package servlet.hris.G;

import com.common.Utils;
import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;
import hris.A.A19Career.A19CareerData;
import hris.A.A19Career.rfc.A19CareerRFC;
import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalHeader;
import hris.common.approval.ApprovalLineData;
import org.apache.commons.lang.StringUtils;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Vector;


public class G064ApprovalCareerSV extends ApprovalBaseServlet {

    private String UPMU_TYPE ="34";
    private String UPMU_NAME = "경력증명서";

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

            final A19CareerRFC a19CareerRFC = new A19CareerRFC();
            a19CareerRFC.setDetailInput(user.empNo, "1", AINF_SEQN);
            final A19CareerData careerData = Utils.indexOf(a19CareerRFC.getDetail(), 0); //결과 데이타

            /* 승인 시 */
            if("A".equals(jobid)) {
                /* 개발자 영역 끝 */
                dest = accept(req, box, "T_ZHRA036T", careerData, a19CareerRFC, new ApprovalFunction<A19CareerData>() {
                    public boolean porcess(A19CareerData inputData, ApprovalHeader approvalHeader, Vector<ApprovalLineData> approvalLineDatas) throws GeneralException {
                         /* 변경되는 가능 항목 */
                        careerData.PRINT_NUM = StringUtils.defaultIfEmpty(box.get("PRINT_NUM"), "1");
                        careerData.PRINT_CHK = box.get("PRINT_CHK");
                        careerData.ENTR_DATE = box.get("ENTR_DATE");
                        careerData.STELL = box.get("STELL");
                        careerData.STELLTX = box.get("STELLTX");
                        careerData.ORGEH = box.get("ORGEH");
                        careerData.ORGTX_E = box.get("ORGTX_E");
                        careerData.ORGTX_E2 = box.get("ORGTX_E2");
                        careerData.ADDRESS1 = box.get("ADDRESS1");
                        careerData.ADDRESS2 = box.get("ADDRESS2");

                        careerData.PHONE_NUM = box.get("PHONE_NUM");
                        careerData.SUBMIT_PLACE = box.get("SUBMIT_PLACE");
                        careerData.USE_PLACE = box.get("USE_PLACE");
                        careerData.JUSO_CODE = box.get("JUSO_CODE");
                        careerData.ORDER_TYPE = box.get("ORDER_TYPE");

                        return true;
                    }
                });

            /* 반려시 */
            } else if("R".equals(jobid)) {
                dest = reject(req, box, null, careerData, a19CareerRFC, null);
            } else if("C".equals(jobid)) {
                dest = cancel(req, box, null, careerData, a19CareerRFC, null);
            } else {
                throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
            }

            printJspPage(req, res, dest);

        } catch(Exception e) {
            Logger.err.println(DataUtil.getStackTrace(e));
            throw new GeneralException(e);
        }

    }


              

}