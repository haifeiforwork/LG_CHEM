package servlet.hris.E.Global.E23Language;

import hris.E.Global.E23Language.E23LanguageData;
import hris.E.Global.E23Language.rfc.E23LanguageRFC;
import hris.common.PersonData;
import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;

import hris.common.rfc.PersonInfoRFC;

import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.common.RFCReturnEntity;
import com.common.Utils;
import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.WebUtil;

public class E23LanguageDetailSV  extends ApprovalBaseServlet{

	private String UPMU_TYPE = "13";     //  결재 업무타입(어학비-주재원)
    private String UPMU_NAME = "Language Fee";

    protected String getUPMU_TYPE() {
        return UPMU_TYPE;
    }

    protected String getUPMU_NAME() {
        return UPMU_NAME;
    }

	protected void performTask(HttpServletRequest req, HttpServletResponse res)	throws GeneralException {

		try {
			HttpSession session = req.getSession(false);
			final WebUserData user = WebUtil.getSessionUser(req);

			String I_APGUB = (String) req.getAttribute("I_APGUB");  //어느 페이지에서 왔나? '1' : 결재할 문서 , '2' : 결재중 문서 , '3' : 결재완료 문서

			Box box = WebUtil.getBox(req);

			String jobid = box.get("jobid", "first");
			String PERNR =  box.get("PERNR", user.empNo); // getPERNR(box, user); //신청대상자 사번
			String AINF_SEQN = box.get("AINF_SEQN");

			Logger.debug.println(this, "[jobid] = " + jobid + " [user] : " + user.toString());

			// **********수정 시작 (20050223:유용원)**********
			final E23LanguageRFC e23Rfc = new E23LanguageRFC();
			e23Rfc.setDetailInput(user.empNo, I_APGUB, AINF_SEQN);

			Vector e23LanguageData_vt = null;
			E23LanguageData e23LanguageData;

			e23LanguageData_vt = e23Rfc.getLanguageDetail2(PERNR, "1", AINF_SEQN);
			e23LanguageData = (E23LanguageData) e23LanguageData_vt.get(0);

			// 대리 신청 추가
			PersonInfoRFC numfunc = new PersonInfoRFC();
            PersonData phonenumdata;
            phonenumdata    =   (PersonData)numfunc.getPersonInfo(e23LanguageData.PERNR);
			req.setAttribute("PersonData", phonenumdata);

			Vector           languageCode = e23Rfc.getLanguageDetail(e23LanguageData.PERNR, "5", "", "");

			//Logger.debug.println(this, "[e23LanguageData_vt] ============= " + e23LanguageData_vt.toString());

			// **********수정 끝.****************************

			if (jobid.equals("first")) { // 제일처음 신청 화면에 들어온경우.

				//req.setAttribute("e23LanguageData_vt", e23LanguageData_vt);  // 확인 후 삭제
				req.setAttribute("resultData", e23LanguageData);

				req.setAttribute("languageCode", languageCode);  // 확인 후 삭제
				req.setAttribute("perType",  (Vector)Utils.indexOf(languageCode, 0) );
				req.setAttribute("famiCode", (Vector)Utils.indexOf(languageCode, 1) );
				req.setAttribute("PERNR", PERNR);

				//Logger.debug.println(this, "상세조회 : "+ e23LanguageData_vt.toString());

				if (!detailApporval(req, res, e23Rfc))
	                   return;

					printJspPage(req, res, WebUtil.JspURL + "E/E23Language/E23LanguageDetail.jsp");

			} else if (jobid.equals("delete")) {

					//e23Rfc.delete(PERNR,"4",AINF_SEQN);

					String dest = deleteApproval(req, box, e23Rfc, new DeleteFunction() {
	                    public boolean porcess() throws GeneralException {

	                    	E23LanguageRFC deleteRFC = new E23LanguageRFC();
	                        deleteRFC.setDeleteInput(user.empNo, UPMU_TYPE, e23Rfc.getApprovalHeader().AINF_SEQN);
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
			throw new GeneralException(e);
		}
	}
}


