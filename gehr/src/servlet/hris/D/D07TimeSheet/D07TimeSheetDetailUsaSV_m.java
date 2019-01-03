/********************************************************************************/
/*	  System Name  	: g-HR
/*   1Depth Name  	: Employee Data
/*   2Depth Name  	: Time management
/*   Program Name 	: Time Sheet
/*   Program ID   		: D07TimeSheetDetailUsaSV_m.java
/*   Description  		: 개인의 Time Sheet 상세 조회 하는 Class (USA - LGCPI(G400))
/*   Note         		:
/*   Creation     		: 2010-10-12 jungin @v1.0 LGCPI 법인 Time Sheet 신규 개발
/********************************************************************************/

package servlet.hris.D.D07TimeSheet;

import hris.D.D07TimeSheet.D07TimeSheetApproverDataUsa;
import hris.D.D07TimeSheet.D07TimeSheetDetailDataUsa;
import hris.D.D07TimeSheet.rfc.D07TimeSheetRFCUsa;
import hris.common.PersonData;
import hris.common.WebUserData;
import hris.common.approval.ApprovalInput;
import hris.common.rfc.PersonInfoRFC;
import hris.common.util.AppUtilEurp;

import java.sql.Connection;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.db.DBUtil;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;

public class D07TimeSheetDetailUsaSV_m extends EHRBaseServlet {

	private String UPMU_TYPE = "15";		// 결재 업무타입(TimeSheet)

	private String UPMU_NAME = "TimeSheet";

	protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {


		try {
			HttpSession session = req.getSession(false);

			WebUserData user_m = (WebUserData) WebUtil.getSessionMSSUser(req);

			String PERNR =user_m.empNo;
			String dest	= "";
			String jobid	= "";

			String I_PAYDR = "";
			String I_LCLDT = "";

			Box box = WebUtil.getBox(req);

			jobid = box.get("jobid","first");

			String I_DATLO = DataUtil.getCurrentDate();

			I_PAYDR = box.get("I_PAYDR","CW");

			I_LCLDT = box.get("I_LCLDT",I_DATLO);

			String AINF_SEQN = box.get("AINF_SEQN");
			if (AINF_SEQN == null || AINF_SEQN.equals("")) {
				AINF_SEQN = "";
			}

			String APPR_STAT = box.get("APPR_STAT");
			if (APPR_STAT == null || APPR_STAT.equals("")) {
				APPR_STAT = "";
			}

			String I_APGUB = (String) req.getAttribute("I_APGUB");

			//Logger.debug.println(this, "#####	box	:	[ " + box.toString() + " ]");
			//Logger.debug.println(this, "#####	user	:	[ " + user.toString() + " ]");
			//Logger.debug.println(this, "#####	jobid	:	[ " + jobid + " ]	/	PERNR :	[ " + PERNR + " ]");

			// 대리 신청 추가
			PersonInfoRFC numfunc = new PersonInfoRFC();
			PersonData phonenumdata;
			phonenumdata = (PersonData) numfunc.getPersonInfo(PERNR);

			req.setAttribute("PersonData", phonenumdata);
			req.setAttribute("E_BUKRS", phonenumdata.E_BUKRS);


			D07TimeSheetDetailDataUsa ts_data = new D07TimeSheetDetailDataUsa();

            Vector D07TimeSheetDataUsa_vt = null;
            Vector D07TimeSheetDeatilDataUsa_vt = null;
            Vector D07TimeSheetSummaryDataUsa_vt = null;

			box.copyToEntity(ts_data);
			ts_data.PERNR = PERNR;
			DataUtil.fixNull(ts_data);

			D07TimeSheetRFCUsa rfc = new D07TimeSheetRFCUsa();
			rfc.setDetailInput(user_m.empNo, I_APGUB, "");
            ApprovalInput approvalInput  = rfc.getApprovalInput();
			approvalInput.setI_PERNR( PERNR);
            D07TimeSheetDataUsa_vt = rfc.getTimeSheetDetail(PERNR, I_PAYDR, I_LCLDT, APPR_STAT);

			D07TimeSheetDeatilDataUsa_vt = (Vector)D07TimeSheetDataUsa_vt.get(0);
            D07TimeSheetSummaryDataUsa_vt = (Vector)D07TimeSheetDataUsa_vt.get(1);

			String E_MESSAGE = (String)D07TimeSheetDataUsa_vt.get(2);
			String E_BEGDA = (String)D07TimeSheetDataUsa_vt.get(3);
			String E_ENDDA = (String)D07TimeSheetDataUsa_vt.get(4);
			String E_PAYDRX = (String)D07TimeSheetDataUsa_vt.get(5);
			req.setAttribute("approvalHeaderStatus", rfc.getApprovalHeader());
			req.setAttribute("D07TimeSheetDeatilDataUsa_vt", D07TimeSheetDeatilDataUsa_vt);
			req.setAttribute("D07TimeSheetSummaryDataUsa_vt", D07TimeSheetSummaryDataUsa_vt);
			//req.setAttribute("D07TimeSheetAinfData_vt", D07TimeSheetAinfData_vt);
			//req.setAttribute("E_APPROVER", E_APPROVER);
			req.setAttribute("E_MESSAGE", E_MESSAGE);
			req.setAttribute("E_BEGDA", E_BEGDA);
			req.setAttribute("E_ENDDA", E_ENDDA);
			req.setAttribute("E_PAYDRX", E_PAYDRX);
			req.setAttribute("PERNR", PERNR);
			req.setAttribute("jobid", jobid);

			dest = WebUtil.JspURL + "D/D07TimeSheet/D07TimeSheetDetailUsa_m.jsp";

			Logger.debug.println(this, "#####	dest = " + dest);

			printJspPage(req, res, dest);

		} catch (Exception e) {
			throw new GeneralException(e);
		} finally {
		}
	}

}
