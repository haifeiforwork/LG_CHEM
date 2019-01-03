/********************************************************************************/
/*   System Name  : e-HR                                                        */
/*   1Depth Name  : HR 결재함                                                   */
/*   2Depth Name  : 결재 해야할 문서                                            */
/*   Program Name : 주소변경  신청                                         */
/*   Program ID   : G069ApprovalAddressDeSV                                       */
/*   Description  : 주소 업무 담당자 결재/반려[독일]                         */
/*   Note         : 없음                                                        */
/*   Creation     : 2010-07-29 yji                                          */
/********************************************************************************/

package servlet.hris.G;

import com.common.Utils;
import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;
import hris.A.A13Address.A13AddressApprovalData;
import hris.A.A13Address.rfc.A13AddressApprovalRFC;
import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalHeader;
import hris.common.approval.ApprovalLineData;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Vector;

/**
 * 
 * G069ApprovalAddressDeSV 
 * 
 * @author yji
 * @creation 2010 07 29
 */
public class G069ApprovalAddressSV extends ApprovalBaseServlet {

    private String UPMU_TYPE = "14";     // 결재 업무타입(자격면허등록)
    private String UPMU_NAME = "address";

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
            final A13AddressApprovalRFC addressApprovalRFC = new A13AddressApprovalRFC();
            addressApprovalRFC.setDetailInput(user.empNo, "1", AINF_SEQN);
            A13AddressApprovalData licenceData = Utils.indexOf(addressApprovalRFC.getDetail(), 0); //결과 데이타

            /* 승인 시 */
            if("A".equals(jobid)) {
                /* 개발자 영역 끝 */
                dest = accept(req, box, "T_ZHR0234T", licenceData, addressApprovalRFC, new ApprovalFunction<A13AddressApprovalData>() {
                    public boolean porcess(A13AddressApprovalData inputData, ApprovalHeader approvalHeader, Vector<ApprovalLineData> approvalLineDatas) throws GeneralException {

                        return true;
                    }
                });

            /* 반려시 */
            } else if("R".equals(jobid)) {
                dest = reject(req, box, null, licenceData, addressApprovalRFC, null);
            } else if("C".equals(jobid)) {
                dest = cancel(req, box, null, licenceData, addressApprovalRFC, null);
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