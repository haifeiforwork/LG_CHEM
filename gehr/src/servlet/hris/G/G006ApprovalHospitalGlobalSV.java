/********************************************************************************/
/*	  System Name  	: g-HR
/*   1Depth Name		: HR Approval Box
/*   2Depth Name  	: Requested Document
/*   Program Name 	: Medical Fee Approval
/*   Program ID   		: G006ApprovalHospitalSV
/*   Description  		: 의료비 신청 부서장, 담당자, 담당부서장 결재/반려 Class
/*   Note         		:
/*   Creation    		: 2005-03-14 이승희
/*   Update       		: 2005-10-28 LSA	 @v1.1 [C2005102601000000764] 자녀인 경우에 300만원한도체크로직이 빠져 있어 추가함
/*   Update				: 2009-05-22 jungin @v1.2 [C20090514_56175] 보험가입 여부 'ZINSU' 필드 추가.
/********************************************************************************/

package servlet.hris.G;

import hris.E.Global.E17Hospital.E17HospitalDetailData1;
import hris.E.Global.E17Hospital.rfc.E17HospitalDetailRFC;

import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalHeader;
import hris.common.approval.ApprovalLineData;
import hris.common.rfc.CurrencyChangeRFC;

import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.common.Utils;
import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;

public class G006ApprovalHospitalGlobalSV extends ApprovalBaseServlet {

	private String UPMU_TYPE = "11"; // 결재 업무타입(의료비)
	private String UPMU_NAME = "Medical Fee";

    protected String getUPMU_TYPE() {
        return UPMU_TYPE;
    }
    protected String getUPMU_NAME() {
        return UPMU_NAME;
    }

	protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        try{
            HttpSession session = req.getSession(false);

            final WebUserData user  = (WebUserData)session.getAttribute("user");
            final Box box = WebUtil.getBox(req);

            String dest	= "";
            String ZINSU = "";

            String jobid	= box.get("jobid");
            String PERNR = box.get("PERNR", user.empNo);// getPERNR(box, user); //신청대상자 사번
			//box.put("PERNR", PERNR);
            //Logger.debug.println(this, "#####	PERNR222**===" + PERNR );
            String AINF_SEQN  = box.get("AINF_SEQN");

            final E17HospitalDetailRFC e17Rfc = new E17HospitalDetailRFC();
			E17HospitalDetailData1 e17SickData = null;
			Vector vcResult = null;

			e17Rfc.setDetailInput(user.empNo, "1", AINF_SEQN);
			vcResult = e17Rfc.getMediDetail(PERNR, ZINSU, AINF_SEQN, "1");

			 //Logger.debug.println(this, "#####	vcResult**===" + vcResult );

			e17SickData = (E17HospitalDetailData1) vcResult.get(0);

			/* 승인 시 */
            if("A".equals(jobid)) {

                /* 개발자 영역 끝 */
                dest = accept(req, box, "T_ZHR0038T", e17SickData, e17Rfc, new ApprovalFunction<E17HospitalDetailData1>() {
                    public boolean porcess(E17HospitalDetailData1 inputData, ApprovalHeader approvalHeader, Vector<ApprovalLineData> approvalLineDatas) throws GeneralException {

                        /* 개발자 영역 시작 */
                        //if(approvalHeader.isEditManagerArea()) {

                            box.copyToEntity(inputData);  //사용자가 입력한 데이타로 업데이트
                            inputData.UNAME			= user.empNo;
                            inputData.AEDTM   		= DataUtil.getCurrentDate();

                            CurrencyChangeRFC rfc2 = new CurrencyChangeRFC();

                            inputData.CERT_BETG_C = rfc2.getCurrencyChange(inputData.WAERS, inputData.WAERS1, inputData.CERT_BETG);
                            inputData.PAMT	= Double.toString(Double.parseDouble(inputData.PAMT) + Double.parseDouble(inputData.CERT_BETG_C));

                            //Logger.debug.println(this, "#####	inputData PERNR**===" + inputData.PERNR );
                            //Logger.debug.println(this, "#####	inputData**===" + inputData );

                        //}

                        return true;
                    }
                });
            /* 반려시 */
            } else if("R".equals(jobid)) {

            	dest = reject(req, box, null, e17SickData, e17Rfc, null);

            } else if("C".equals(jobid)) {

            	dest = cancel(req, box, null, e17SickData, e17Rfc, null);
            } else {
                throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
            }

            //Logger.debug.println(this, " destributed = " + dest);
            printJspPage(req, res, dest);

        } catch(Exception e) {
            //Logger.err.println(DataUtil.getStackTrace(e));
            throw new GeneralException(e);
        }

	}
}