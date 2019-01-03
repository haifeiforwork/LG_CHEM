package servlet.hris.E.Global.E23Language;

import hris.E.Global.E17Hospital.E17HospitalDetailData1;
import hris.E.Global.E17Hospital.rfc.E17HospitalDetailRFC;
import hris.E.Global.E23Language.E23LanguageData;
import hris.E.Global.E23Language.rfc.E23LanguageRFC;
import hris.common.PersonData;
import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalHeader;
import hris.common.approval.ApprovalLineData;
import hris.common.approval.ApprovalBaseServlet.ChangeFunction;
import hris.common.rfc.CurrencyChangeRFC;
import hris.common.rfc.PersonInfoRFC;

import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.common.Utils;
import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;

public class E23LanguageChangeSV extends ApprovalBaseServlet {
	private String UPMU_TYPE = "13";     // 결재 업무타입(어학비-주재원)
    private String UPMU_NAME = "Language Fee";

    protected String getUPMU_TYPE() {
        return UPMU_TYPE;
    }
    protected String getUPMU_NAME() {
        return UPMU_NAME;
    }

	protected void performTask(final HttpServletRequest req, HttpServletResponse res) 	throws GeneralException {

		try {
			HttpSession session = req.getSession(false);
			final WebUserData user = WebUtil.getSessionUser(req);
			final Box box = WebUtil.getBox(req);

			String dest = "";
			String jobid = box.get("jobid", "first");
			String PERNR =  box.get("PERNR", user.empNo);//getPERNR(box, user); //신청대상자 사번
			String AINF_SEQN = box.get("AINF_SEQN");

			String I_APGUB = (String) req.getAttribute("I_APGUB");  //어느 페이지에서 왔나? '1' : 결재할 문서 , '2' : 결재중 문서 , '3' : 결재완료 문서

			Vector e23LanguageData_vt = null;
			final E23LanguageRFC e23Rfc = new E23LanguageRFC();

			E23LanguageData e23LanguageData = null;

			Logger.debug.println(this, "[jobid] = " + jobid + " [user] : " + user.toString());

			e23Rfc.setDetailInput(user.empNo, I_APGUB, AINF_SEQN);

			e23LanguageData_vt = e23Rfc.getLanguageDetail2(PERNR, "1", AINF_SEQN);
			e23LanguageData = (E23LanguageData) e23LanguageData_vt.get(0);

			// 대리 신청 추가
			PersonInfoRFC numfunc = new PersonInfoRFC();
            PersonData phonenumdata;
            phonenumdata    =   (PersonData)numfunc.getPersonInfo(e23LanguageData.PERNR);
            req.setAttribute("PersonData", phonenumdata);

			//E23LanguageData tempData = (E23LanguageData) e23LanguageData_vt.get(0);
			Vector           languageCode = e23Rfc.getLanguageDetail(e23LanguageData.PERNR, "5", "", "");

			//Logger.debug.println(this, "[e23LanguageData_vt] = " + e23LanguageData_vt.toString());

			if (jobid.equals("first")) { // 제일처음 수정 화면에 들어온경우.

				req.setAttribute("isUpdate", true); //등록 수정 여부
				req.setAttribute("resultData", e23LanguageData);
				req.setAttribute("perType",  (Vector)Utils.indexOf(languageCode, 0) );
				req.setAttribute("famiCode", (Vector)Utils.indexOf(languageCode, 1) );
				req.setAttribute("PERNR", PERNR);

				detailApporval(req, res, e23Rfc);

				printJspPage(req, res, WebUtil.JspURL + "E/E23Language/E23LanguageChange.jsp");

			} else if (jobid.equals("change")) {

				/* 실제 신청 부분 */
				dest = changeApproval(req, box, E23LanguageData.class, e23Rfc, new ChangeFunction<E23LanguageData>(){

					public String porcess(E23LanguageData inputData, ApprovalHeader approvalHeader, Vector<ApprovalLineData> approvalLine) throws GeneralException {

						inputData.ZPERNR = user.empNo;
						inputData.AEDTM = DataUtil.getCurrentDate();
						if(inputData.PERS_GUBN.equals("02")){
							inputData.WAERS1 = box.get("WAERS9");
						}

                    	box.put("PERS_GUBN", inputData.PERS_GUBN);
                    	box.put("OBJPS", inputData.OBJPS);
                    	box.put("FAMI_CODE", inputData.FAMI_CODE);
                    	box.put("I_GTYPE", "3");

                    	/* 결재 신청 RFC 호출 */
                    	E23LanguageRFC changeRFC = new E23LanguageRFC();

                		changeRFC.setChangeInput(user.empNo, UPMU_TYPE, approvalHeader.AINF_SEQN);

                        changeRFC.build(Utils.asVector(inputData), box, req);
                        //e23Rfc.change(PERNR,"3",AINF_SEQN, e23LanguageData_vt);

                        //Logger.debug.println(this, "====changeRFC.getReturn().isSuccess()======== : " +  changeRFC.getReturn().isSuccess() );
                        //Logger.debug.println(this, "====changeRFC.getReturn().isSuccess()======== : " +  changeRFC.getReturn() );

                        if(!changeRFC.getReturn().isSuccess()) {
                            throw new GeneralException(changeRFC.getReturn().MSGTX);
                        }

                        return inputData.AINF_SEQN;
                        /* 개발자 작성 부분 끝 */
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
