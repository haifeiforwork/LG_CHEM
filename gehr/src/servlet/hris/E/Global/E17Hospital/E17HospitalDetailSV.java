/********************************************************************************/
/*	  System Name  	: g-HR
/*   1Depth Name		: Application
/*   2Depth Name  	: Benefit Management
/*   Program Name 	: Medical Fee
/*   Program ID   		: E17HospitalDetailSV
/*   Description  		: 의료비 신청 내용을 상세 조회하는 Class
/*   Note         		:
/*   Creation     		: 2002-01-08 김성일
/*   Update       		: 2005-02-16 윤정현
/*   Update				: 2009-05-21 jungin @v1.2 [C20090514_56175] 보험가입 여부 'ZINSU' 필드 추가.
/********************************************************************************/

package servlet.hris.E.Global.E17Hospital;

import hris.E.Global.E17Hospital.E17HospitalDetailData1;
import hris.E.Global.E17Hospital.rfc.E17HospitalCodeRFC;
import hris.E.Global.E17Hospital.rfc.E17HospitalDetailRFC;
import hris.E.Global.E17Hospital.rfc.E17HospitalDetailRFC01;
import hris.common.PersonData;
import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.rfc.PersonInfoRFC;

import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.common.RFCReturnEntity;
import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.WebUtil;

public class E17HospitalDetailSV extends ApprovalBaseServlet {

	private String UPMU_TYPE = "11"; // 결재 업무타입(의료비)

	private String UPMU_NAME = "Medical Fee";

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
			String PERNR =  box.get("PERNR", user.empNo);//getPERNR(box, user); //신청대상자 사번
			box.put("PERNR", PERNR);

			String ZINSU = box.get("ZINSU");
			String AINF_SEQN = box.get("AINF_SEQN");

			final E17HospitalDetailRFC e17Rfc = new E17HospitalDetailRFC();

			//--2016.11.18------start--
			E17HospitalDetailRFC01 rfc01=new E17HospitalDetailRFC01();
			//--2016.11.18--------end--

			E17HospitalCodeRFC e17Code = new E17HospitalCodeRFC();
			E17HospitalDetailData1 e17SickData = null;
			Vector vcResult = null;

			//Logger.debug.println(this, "[#####]	AINF_SEQN	:	[" + AINF_SEQN + "]");
			//Logger.debug.println(this, "[#####]	box	:	[" + box + "]");

			e17Rfc.setDetailInput(user.empNo, I_APGUB, AINF_SEQN);

			vcResult = e17Rfc.getMediDetail(PERNR, ZINSU, AINF_SEQN, "1");
			e17SickData = (E17HospitalDetailData1) vcResult.get(0);

			// 대리 신청 추가
			PersonInfoRFC numfunc = new PersonInfoRFC();
            PersonData phonenumdata;
            phonenumdata    =   (PersonData)numfunc.getPersonInfo(e17SickData.PERNR);
			req.setAttribute("PersonData", phonenumdata);

			if (jobid.equals("first")) {

				//--2016.11.18------start--
				Vector E17HdataFile_vt = rfc01.getMediDetail01(e17SickData.PERNR, AINF_SEQN, "M", "1");
				req.setAttribute("E17HdataFile_vt", E17HdataFile_vt);
				//--2016.11.18--------end--

				req.setAttribute("resultData", e17SickData);
				req.setAttribute("PERNR", PERNR);

				Vector mediCodeList = e17Code.getMediCode();
				req.setAttribute("mediCodeList", mediCodeList);

				/* 조회 권한 체크 및 결재 헤더 및 결재라인 */
				if (!detailApporval(req, res, e17Rfc))
                   return;

				printJspPage(req, res, WebUtil.JspURL + "E/E17Hospital/E17HospitalDetail_Global.jsp");

			} else if (jobid.equals("delete")) {

				String dest = deleteApproval(req, box, e17Rfc, new DeleteFunction() {
                    public boolean porcess() throws GeneralException {

                    	E17HospitalDetailRFC deleteRFC = new E17HospitalDetailRFC();
                        deleteRFC.setDeleteInput(user.empNo, UPMU_TYPE, e17Rfc.getApprovalHeader().AINF_SEQN);
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
