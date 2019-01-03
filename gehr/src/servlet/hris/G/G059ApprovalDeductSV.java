/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : 결재해야할 문서                                             */
/*   2Depth Name  :                                                             */
/*   Program Name : 근로소득/갑근세 결재                                        */
/*   Program ID   : G059ApprovalDeductSV                                        */
/*   Description  : 근로소득/갑근세 결재를 위한 서블릿                          */
/*   Note         : 없음                                                        */
/*   Creation     : 2005-03-11 유용원                                           */
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
import hris.A.A18Deduct.A18DeductData;
import hris.A.A18Deduct.rfc.A18DeductRFC;
import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalHeader;
import hris.common.approval.ApprovalLineData;
import org.apache.commons.lang.StringUtils;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Vector;

public class G059ApprovalDeductSV extends ApprovalBaseServlet {

    private String UPMU_TYPE ="28";
    private String UPMU_NAME = "원천징수영수증";

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

            final A18DeductRFC a18DeductRFC = new A18DeductRFC();
            a18DeductRFC.setDetailInput(user.empNo, "1", AINF_SEQN);
            final A18DeductData deductData = Utils.indexOf(a18DeductRFC.getDetail(), 0); //결과 데이타

            /* 승인 시 */
            if("A".equals(jobid)) {
                /* 개발자 영역 끝 */
                dest = accept(req, box, "T_ZHRA029T", deductData, a18DeductRFC, new ApprovalFunction<A18DeductData>() {
                    public boolean porcess(A18DeductData inputData, ApprovalHeader approvalHeader, Vector<ApprovalLineData> approvalLineDatas) throws GeneralException {

                         /* 변경되는 가능 항목 */
                        deductData.PRINT_NUM = StringUtils.defaultIfEmpty(box.get("PRINT_NUM"), "1");
                        deductData.PHONE_NUM = box.get("PHONE_NUM");
                        deductData.PRINT_CHK = box.get("PRINT_CHK");

                        deductData.SUBMIT_PLACE = box.get("SUBMIT_PLACE");
                        deductData.USE_PLACE = box.get("USE_PLACE");

                        deductData.EBEGDA = box.get("EBEGDA");
                        deductData.EENDDA = box.get("EENDDA");

                        deductData.SPEC_ENTRY1 = box.get("SPEC_ENTRY1");
                        deductData.SPEC_ENTRY2 = box.get("SPEC_ENTRY2");
                        deductData.SPEC_ENTRY3 = box.get("SPEC_ENTRY3");
                        deductData.SPEC_ENTRY4 = box.get("SPEC_ENTRY4");
                        deductData.SPEC_ENTRY5 = box.get("SPEC_ENTRY5");

                        return true;
                    }
                });

            /* 반려시 */
            } else if("R".equals(jobid)) {
                dest = reject(req, box, null, deductData, a18DeductRFC, null);
            } else if("C".equals(jobid)) {
                dest = cancel(req, box, null, deductData, a18DeductRFC, null);
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
