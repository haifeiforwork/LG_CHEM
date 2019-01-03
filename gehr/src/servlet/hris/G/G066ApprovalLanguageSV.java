package servlet.hris.G;

import hris.E.Global.E23Language.E23LanguageData;
import hris.E.Global.E23Language.rfc.E23LanguageRFC;
import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalHeader;
import hris.common.approval.ApprovalLineData;
import hris.common.rfc.CurrencyChangeRFC;

import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;


public class G066ApprovalLanguageSV  extends ApprovalBaseServlet {

	private String UPMU_TYPE = "13";     // 결재 업무타입(어학비-주재원)
    private String UPMU_NAME = "Language Fee";

    protected String getUPMU_TYPE() {
        return UPMU_TYPE;
    }

    protected String getUPMU_NAME() {
        return UPMU_NAME;
    }

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {
        try{
            HttpSession session = req.getSession(false);
            final WebUserData user  = (WebUserData)session.getAttribute("user");
            final Box box = WebUtil.getBox(req);

            //Vector  vcAppLineData;
            Vector  e23LanguageData_vt;

            E23LanguageData   e23LanguageData;

            String dest  = "";
            String jobid = box.get("jobid");

            String  AINF_SEQN  = box.get("AINF_SEQN");
            String  empNo  = req.getParameter("APPL_PERNR");

            final E23LanguageRFC  e23Rfc = new E23LanguageRFC();
            e23Rfc.setDetailInput(user.empNo, "1", AINF_SEQN);

        	e23LanguageData_vt = e23Rfc.getDetail(empNo,AINF_SEQN);

        	Logger.debug.println(this, "====empNo===="+empNo);
            //Logger.debug.println(this, "====e23LanguageData_vt===="+e23LanguageData_vt);
        	e23LanguageData      = (E23LanguageData)e23LanguageData_vt.get(0);

			/* 승인 시 */
            if("A".equals(jobid)) {

                /* 개발자 영역 끝 */
                dest = accept(req, box, "T_ZHR0040T", e23LanguageData, e23Rfc, new ApprovalFunction<E23LanguageData>() {
                    public boolean porcess(E23LanguageData inputData, ApprovalHeader approvalHeader, Vector<ApprovalLineData> approvalLineDatas) throws GeneralException {

                        /* 개발자 영역 시작 */
                        //if(approvalHeader.isEditManagerArea()) {

                            box.copyToEntity(inputData);  //사용자가 입력한 데이타로 업데이트

                            inputData.UNAME			= user.empNo;
                            inputData.AEDTM   		= DataUtil.getCurrentDate();
                            inputData.PDATE 			= inputData.CERT_DATE;

                            CurrencyChangeRFC rfc2 = new CurrencyChangeRFC();

                            Logger.debug.println(this, "#####	inputData CERT_FLAG 11111**===" + inputData.CERT_FLAG );
                            Logger.debug.println(this, "#####	inputData 11111**===" + inputData );

                            inputData.CERT_BETG_C = rfc2.getCurrencyChange(inputData.REIM_WAR, inputData.WAERS1, inputData.CERT_BETG);

                        //}

                        return true;
                    }
                });
            /* 반려시 */
            } else if("R".equals(jobid)) {

            	dest = reject(req, box, null, e23LanguageData, e23Rfc, null);

            } else if("C".equals(jobid)) {

            	dest = cancel(req, box, null, e23LanguageData, e23Rfc, null);
            } else {
                throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
            }

            Logger.debug.println(this, " destributed = " + dest);
            printJspPage(req, res, dest);

        } catch(Exception e) {
            //Logger.err.println(DataUtil.getStackTrace(e));
            throw new GeneralException(e);
        } finally {

        }
    }
}