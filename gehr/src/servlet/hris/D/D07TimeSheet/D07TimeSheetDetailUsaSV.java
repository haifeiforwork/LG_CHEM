/********************************************************************************/
/*	  System Name  	: g-HR
/*   1Depth Name		: Personal HR Info
/*   2Depth Name  	: Time Management
/*   Program Name 	: Time Sheet
/*   Program ID   		: D07TimeSheetDetailUsaSV.java
/*   Description  		: Time Sheet 상세 조회 하는 Class (USA - LG CPI(G400))
/*   Note         		:
/*   Creation     		: 2010-10-12 jungin @v1.0 LGCPI 법인 Time Sheet 신규 개발
/********************************************************************************/

package servlet.hris.D.D07TimeSheet;

import hris.D.D07TimeSheet.D07TimeSheetApproverDataUsa;
import hris.D.D07TimeSheet.rfc.D07TimeSheetRFCUsa;
import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalHeader;
import hris.common.approval.ApprovalInput;

import java.sql.Connection;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang.StringUtils;

import com.common.RFCReturnEntity;
import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;

public class D07TimeSheetDetailUsaSV extends ApprovalBaseServlet {

	private String UPMU_TYPE = "15";		// 결재 업무타입(TimeSheet)

	private String UPMU_NAME = "TimeSheet";

    protected String getUPMU_TYPE() {
        return UPMU_TYPE;
    }

    protected String getUPMU_NAME() {
        return UPMU_NAME;
    }


	protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {

		Connection con = null;

		try {
			HttpSession session = req.getSession(false);

			final WebUserData user = (WebUserData) session.getAttribute("user");

			Box box = WebUtil.getBox(req);

			String jobid = box.get("jobid", "first");
			String I_DATLO = DataUtil.getCurrentDate();
			String I_PAYDR = box.get("I_PAYDR","CW");
			String iframeYn = box.get("iframeYn","false");
			String I_LCLDT = box.get("I_LCLDT",box.get("TBEGDA",I_DATLO));
			String APPR_STAT = box.get("APPR_STAT","");
			String AINF_SEQN = box.get("AINF_SEQN");
			String I_APGUB = StringUtils.defaultString((String)req.getAttribute("I_APGUB"),"2");  //어느 페이지에서 왔나? '1' : 결재할 문서 , '2' : 결재중 문서 , '3' : 결재완료 문서

			String PERNR1 = box.get("PERNR",user.empNo);
			Logger.debug.println(this, "#####	box	:	[ " + box.toString() + " ]");


			final D07TimeSheetRFCUsa d07TimeSheetRFCUsa = new D07TimeSheetRFCUsa();

            Vector D07TimeSheetDeatilDataUsa_vt = null;
            Vector D07TimeSheetSummaryDataUsa_vt = null;
            Vector D07TimeSheetDataUsa_vt0 =null;
            Vector D07TimeSheetDataUsa_vt = null;
            ApprovalHeader approvalHeader ;
            if (I_PAYDR.equals("CW")) {
            	d07TimeSheetRFCUsa.setDetailInput(user.empNo, I_APGUB, AINF_SEQN);
            }else{
            	I_APGUB = box.get("I_APGUB");
                req.setAttribute("RequestPageName",  box.get("RequestPageName"));
            	req.setAttribute("I_APGUB", I_APGUB);
            	d07TimeSheetRFCUsa.setDetailInput(user.empNo, I_APGUB, "");
            }

            if (I_PAYDR.equals("CW")) {
            	D07TimeSheetDataUsa_vt0 = d07TimeSheetRFCUsa.getTimeSheetDetail(PERNR1, I_PAYDR, I_LCLDT, APPR_STAT);
            	approvalHeader  = d07TimeSheetRFCUsa.getApprovalHeader();
            	if (!approvalHeader.PERNR.equals("00000000")) PERNR1 = approvalHeader.PERNR;
            	d07TimeSheetRFCUsa.getApprovalInput().setI_PERNR( PERNR1);
            	D07TimeSheetDataUsa_vt = d07TimeSheetRFCUsa.getTimeSheetDetail(approvalHeader.PERNR, I_PAYDR, I_LCLDT, APPR_STAT);
            }else{
            	getApprovalInfo(req, PERNR1);
            	d07TimeSheetRFCUsa.getApprovalInput().setI_PERNR( PERNR1);
            	D07TimeSheetDataUsa_vt = d07TimeSheetRFCUsa.getTimeSheetDetail(PERNR1, I_PAYDR, I_LCLDT, APPR_STAT);
            }

			final String PERNR = PERNR1;

			req.setAttribute("iframeYn", iframeYn);



          if (jobid.equals("first")) {           //제일처음 신청 화면에 들어온경우.

				 if ("X".equals(d07TimeSheetRFCUsa.getApprovalHeader().DISPFL)){

					 if (!detailApporval(req, res, d07TimeSheetRFCUsa))      return;
	             }

			D07TimeSheetDeatilDataUsa_vt = (Vector)D07TimeSheetDataUsa_vt.get(0);
            D07TimeSheetSummaryDataUsa_vt = (Vector)D07TimeSheetDataUsa_vt.get(1);
			String E_MESSAGE = (String)D07TimeSheetDataUsa_vt.get(2);
			String E_BEGDA = (String)D07TimeSheetDataUsa_vt.get(3);
			String E_ENDDA = (String)D07TimeSheetDataUsa_vt.get(4);
			String E_PAYDRX = (String)D07TimeSheetDataUsa_vt.get(5);
			D07TimeSheetApproverDataUsa E_APPROVER = (D07TimeSheetApproverDataUsa)D07TimeSheetDataUsa_vt.get(6);

			req.setAttribute("D07TimeSheetDeatilDataUsa_vt", D07TimeSheetDeatilDataUsa_vt);
			req.setAttribute("D07TimeSheetSummaryDataUsa_vt", D07TimeSheetSummaryDataUsa_vt);
			req.setAttribute("E_MESSAGE", E_MESSAGE);
			req.setAttribute("E_BEGDA", E_BEGDA);
			req.setAttribute("E_ENDDA", E_ENDDA);
			req.setAttribute("E_PAYDRX", E_PAYDRX);
			req.setAttribute("PERNR", PERNR);
			req.setAttribute("jobid", jobid);


			req.setAttribute("approverData", E_APPROVER);
			Logger.debug.println(this,E_APPROVER );

		    printJspPage(req, res, WebUtil.JspURL + "D/D07TimeSheet/D07TimeSheetDetailUsa.jsp");

			 } else if (jobid.equals("delete")) {           //삭제

	                String dest = deleteApproval(req, box, d07TimeSheetRFCUsa, new DeleteFunction() {
	                    public boolean porcess() throws GeneralException {

				    D07TimeSheetRFCUsa deleteRFC = new D07TimeSheetRFCUsa();
				    deleteRFC.setDeleteInput(user.empNo, UPMU_TYPE, d07TimeSheetRFCUsa.getApprovalHeader().AINF_SEQN);
				    ApprovalInput approvalInput  = deleteRFC.getApprovalInput();
					approvalInput.setI_PERNR( PERNR);

                    RFCReturnEntity returnEntity = deleteRFC.delete();

                    if(!returnEntity.isSuccess()) {
                        throw new GeneralException(returnEntity.MSGTX);
                    }

                    return true;
             }
         });

         printJspPage(req, res, dest);

     } else {
         throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
     }


 } catch (Exception e) {
     Logger.error(e);
     throw new GeneralException(e);
 }
}


}
