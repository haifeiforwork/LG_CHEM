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
import hris.A.A17Licence.A17LicenceData;
import hris.A.A17Licence.rfc.A17LicenceRFC;
import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalHeader;
import hris.common.approval.ApprovalLineData;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Vector;


public class G024ApprovalLicenceSV extends ApprovalBaseServlet {

//    private String UPMU_TYPE = "14";     // 결재 업무타입(자격면허등록)
//    private String UPMU_NAME = "자격증면허";

    protected String getUPMU_TYPE() {
        if(g.getSapType().isLocal())  return "14";
        else return  "04"; // 결재 업무타입(자격면허등록)
    }

    protected String getUPMU_NAME() {

        if(g.getSapType().isLocal())  return "자격증면허";
        else return  "Register License & Certificate"; // 결재 업무타입(자격면허등록)
    }

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {
        try{
            final WebUserData user = WebUtil.getSessionUser(req);


            String dest  = "";

            final Box box = WebUtil.getBox(req);

            String  AINF_SEQN  = box.get("AINF_SEQN");

            String jobid = box.get("jobid");
            /* 승인 반려 시 */

            final A17LicenceRFC a17LicenceRFC = new A17LicenceRFC();
            a17LicenceRFC.setDetailInput(user.empNo, "1", AINF_SEQN);
            final A17LicenceData licenceData = Utils.indexOf(a17LicenceRFC.getLicence(), 0); //결과 데이타

            /* 승인 시 */
            if("A".equals(jobid)) {
                /* 개발자 영역 끝 */
                dest = accept(req, box, g.getSapType().isLocal() ? "T_ZHRA018T" : "T_ZHR0043T", licenceData, a17LicenceRFC, new ApprovalFunction<A17LicenceData>() {
                    public boolean porcess(A17LicenceData inputData, ApprovalHeader approvalHeader, Vector<ApprovalLineData> approvalLineDatas) throws GeneralException {

                        /* 국내일 경우  개발자 영역 시작 */
                        if(g.getSapType().isLocal() && approvalHeader.isEditManagerArea()) {
                            box.copyToEntity(inputData);  //사용자가 입력한 데이타로 업데이트
                            if (inputData.WAERS.equals("KRW")) {
                                inputData.LICN_AMNT = DataUtil.changeGlobalAmount(inputData.LICN_AMNT, "KRW") ;  // 자격 수당 sap에 저장될 데이타 /100 부분
                            } // end if

                            inputData.UNAME     = user.empNo;
                            inputData.AEDTM     = DataUtil.getCurrentDate();
                        }

                        if(!g.getSapType().isLocal()) {
                            inputData.CERT_FLAG = box.get("CERT_FLAG");
                            inputData.CERT_DATE = box.get("CERT_DATE");
                        }

                        return true;
                    }
                });

            /* 반려시 */
            } else if("R".equals(jobid)) {
                dest = reject(req, box, null, licenceData, a17LicenceRFC, null);
            } else if("C".equals(jobid)) {
                dest = cancel(req, box, null, licenceData, a17LicenceRFC, null);
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