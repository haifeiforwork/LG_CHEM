/********************************************************************************/
/*	  System Name  	: g-HR
/*   1Depth Name		: Personal HR Info
/*   2Depth Name  	: Time Management
/*   Program Name 	: Time Sheet
/*   Program ID   		: D07TimeSheetDetailPrintUsaSV.java
/*   Description  		: Time Sheet 상세 조회후, 출력하는 Class (USA - LGCPI(G400))
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

public class D07TimeSheetDetailPrintUsaSV extends EHRBaseServlet {

	private String UPMU_TYPE = "15";		// 결재 업무타입(TimeSheet)

	private String UPMU_NAME = "TimeSheet";

	protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {

		Connection con = null;

		try {
			HttpSession session = req.getSession(false);

			WebUserData user = (WebUserData) session.getAttribute("user");
			WebUserData user_m = (WebUserData) session.getAttribute("user_m");

			String dest = "";
			String jobid2 = "";
			String PERNR = "";

			String I_PAYDR = "";
			String I_LCLDT = "";

			Box box = WebUtil.getBox(req);

			jobid2 = box.get("jobid2", "printFirst");

			PERNR =  box.get("pernr");

			String I_DATLO = DataUtil.getCurrentDate();

			I_PAYDR = box.get("I_PAYDR","CW");

			I_LCLDT = box.get("I_LCLDT",I_DATLO);

			String AINF_SEQN = box.get("AINF_SEQN");


			String APPR_STAT = box.get("APPR_STAT");


			Logger.debug.println(this, "#####	box	:	[ " + box.toString() + " ]");
			Logger.debug.println(this, "#####	user	:	[ " + user.toString() + " ]");
			Logger.debug.println(this, "#####	user_m	:	[ " + user_m.toString() + " ]");
			Logger.debug.println(this, "#####	jobid	:	[ " + jobid2 + " ]	/	PERNR :	[ " + PERNR + " ]");
			String empNo = "";
			String empName = "";
			if (jobid2.equals("printFirst") || jobid2.equals("printGlobal")) { // 새창띠움(빈페이지)


				PersonInfoRFC numfunc = new PersonInfoRFC();
				PersonData phonenumdata;
				phonenumdata = (PersonData) numfunc.getPersonInfo(PERNR);

				if (jobid2.equals("printFirst")) {
					empNo = PERNR;
					empName = phonenumdata.E_ENAME;
				} else if (jobid2.equals("printGlobal")) {	// 조직통계,상세조회에서 연결
					empNo = user_m.empNo;
					empName = user_m.ename;
				}



				req.setAttribute("PersonData", phonenumdata);
				req.setAttribute("E_BUKRS", phonenumdata.E_BUKRS);

				D07TimeSheetRFCUsa rfc = new D07TimeSheetRFCUsa();

				D07TimeSheetDetailDataUsa ts_data = new D07TimeSheetDetailDataUsa();

	            Vector D07TimeSheetDataUsa_vt = null;
	            Vector D07TimeSheetDeatilDataUsa_vt = null;
	            Vector D07TimeSheetSummaryDataUsa_vt = null;

				box.copyToEntity(ts_data);

				ts_data.PERNR = empNo;

				DataUtil.fixNull(ts_data);
	            D07TimeSheetDataUsa_vt = rfc.getTimeSheet(empNo, I_PAYDR, I_LCLDT, APPR_STAT);

				D07TimeSheetDeatilDataUsa_vt = (Vector)D07TimeSheetDataUsa_vt.get(0);
	            D07TimeSheetSummaryDataUsa_vt = (Vector)D07TimeSheetDataUsa_vt.get(1);
				String E_MESSAGE = (String)D07TimeSheetDataUsa_vt.get(2);
				String E_BEGDA = (String)D07TimeSheetDataUsa_vt.get(3);
				String E_ENDDA = (String)D07TimeSheetDataUsa_vt.get(4);
				String E_PAYDRX = (String)D07TimeSheetDataUsa_vt.get(5);
				D07TimeSheetApproverDataUsa E_APPROVER = (D07TimeSheetApproverDataUsa)D07TimeSheetDataUsa_vt.get(6);

				req.setAttribute("D07TimeSheetDeatilDataUsa_vt", D07TimeSheetDeatilDataUsa_vt);
				req.setAttribute("D07TimeSheetSummaryDataUsa_vt", D07TimeSheetSummaryDataUsa_vt);
				req.setAttribute("approvalHeader", rfc.getApprovalHeader());
				req.setAttribute("E_MESSAGE", E_MESSAGE);
				req.setAttribute("E_BEGDA", E_BEGDA);
				req.setAttribute("E_ENDDA", E_ENDDA);
				req.setAttribute("E_PAYDRX", E_PAYDRX);
				req.setAttribute("E_APPROVER", E_APPROVER);
				req.setAttribute("empName", empName);
				req.setAttribute("pernr", empNo);
				req.setAttribute("jobid2", jobid2);

				dest = WebUtil.JspURL + "D/D07TimeSheet/D07TimeSheetDetailPrintUsa.jsp";

			} else {

				String url = "history.back();";

				req.setAttribute("msg", "jobid is error. [" + jobid2 + "]");
				req.setAttribute("url", url);

				dest = WebUtil.JspURL + "common/msg.jsp";
			}

			Logger.debug.println(this, "#####	dest = " + dest);

			printJspPage(req, res, dest);

		} catch (Exception e) {
			throw new GeneralException(e);
		} finally {
			DBUtil.close(con);
		}
	}

}
