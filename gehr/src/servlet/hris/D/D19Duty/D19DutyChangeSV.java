/********************************************************************************/
/*	  System Name  	: g-HR
/*   1Depth Name		: Application
/*   2Depth Name  	: Time Management
/*   Program Name 	: Duty
/*   Program ID   		: D19DutyChangeSV
/*   Description 		: 직반(Duty)을 수정 할 수 있도록 하는 Class
/*   Note        		:
/*   Creation     		: 2002-01-21 박영락
/*   Update       		: 2005-03-07 윤정현
/*   Update				: 2007-10-09 huang peng xiao
/*                  		: 2008-06-18 김정인 @v1.0 신청시 직반금액(BETRG/WAERS/LGART) 필수 필드
/********************************************************************************/

package servlet.hris.D.D19Duty;

import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;

import hris.D.D19Duty.D19DutyData;
import hris.D.D19Duty.rfc.D19DutyRFC;
import hris.common.PersonData;
import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalHeader;
import hris.common.approval.ApprovalLineData;
import hris.common.rfc.PersonInfoRFC;

public class D19DutyChangeSV extends ApprovalBaseServlet {

	private String UPMU_TYPE = "07";
	private String UPMU_NAME = "Duty";

    protected String getUPMU_TYPE() {
        return UPMU_TYPE;
    }
    protected String getUPMU_NAME() {
        return UPMU_NAME;
    }

	protected void performTask(final HttpServletRequest req, HttpServletResponse res)	throws GeneralException {

		try {

			HttpSession session = req.getSession(false);
			final WebUserData user = (WebUserData) session.getAttribute("user");
			final Box box = WebUtil.getBox(req);

			String dest = "";
			String jobid = box.get("jobid", "first");
			String PERNR =  box.get("PERNR", user.empNo); //getPERNR(box, user); //신청대상자 사번

			String I_APGUB = (String) req.getAttribute("I_APGUB");  //어느 페이지에서 왔나? '1' : 결재할 문서 , '2' : 결재중 문서 , '3' : 결재완료 문서
			String AINF_SEQN = box.get("AINF_SEQN");

			D19DutyRFC d19Rfc = new D19DutyRFC();
			d19Rfc.setDetailInput(user.empNo, I_APGUB, AINF_SEQN); // set DetailInput
			D19DutyData firstData = new D19DutyData();

			Vector D01OTData_vt = null;
			UPMU_TYPE = box.get("UPMU");

			Logger.debug.println(this, "#####	UPMU_TYPE	:	[ " + UPMU_TYPE + " ]");

			D01OTData_vt = d19Rfc.getDetail(AINF_SEQN, PERNR);
			firstData = (D19DutyData) D01OTData_vt.get(0);

			// 대리 신청 추가
            PersonInfoRFC numfunc = new PersonInfoRFC();
            PersonData phonenumdata;
            phonenumdata = (PersonData)numfunc.getPersonInfo(firstData.PERNR);
            req.setAttribute("PersonData" , phonenumdata );

			if (jobid.equals("first")) {
				D19DutyData d19Data  = ( D19DutyData )D01OTData_vt.get(0);

				req.setAttribute("isUpdate", true); //등록 수정 여부
				req.setAttribute("resultData", d19Data);

				detailApporval(req, res, d19Rfc);

				printJspPage(req, res, WebUtil.JspURL + "D/D19Duty/D19DutyChange.jsp");

			} else if (jobid.equals("change")) {

				/* 실제 신청 부분 */
				dest = changeApproval(req, box, D19DutyData.class, d19Rfc, new ChangeFunction<D19DutyData>(){

					public String porcess(D19DutyData inputData, ApprovalHeader approvalHeader, Vector<ApprovalLineData> approvalLine) throws GeneralException {

						inputData.PERNR  = inputData.PERNR;
        				inputData.ZPERNR = inputData.ZPERNR;    // 신청자 사번(대리신청, 본인 신청)
        				inputData.UNAME  = user.empNo;          // 수정자 사번(대리신청, 본인 신청)
    	                inputData.AEDTM  = DataUtil.getCurrentDate();  // 변경일(현재날짜)

    	              //**************************************************************************************
    					//신청시 직반금액(BETRG/WAERS/LGART) 필수 필드.		2008-06-18		김정인
    					Logger.debug.println("#####	BETRG	:	[ "	+	box.getString("BETRG")  + " ]");
    					Logger.debug.println("#####	WAERS	:	[ "	+	box.getString("WAERS") + " ]");

    					inputData.BETRG 	= box.getString("BETRG");
    					inputData.WAERS 	= box.getString("WAERS");
    					//**************************************************************************************

                    	box.put("I_GTYPE", "3");

                    	/* 결재 신청 RFC 호출 */
                    	D19DutyRFC changeRFC = new D19DutyRFC();
                		changeRFC.setChangeInput(user.empNo, UPMU_TYPE, approvalHeader.AINF_SEQN);

                        changeRFC.build(inputData, box, req);
                        //rfc.change(ainf_seqn, firstData.PERNR, D01OTData_vt);

                    	Logger.debug.println(this, "====changeRFC.getReturn().isSuccess()======== : " +  changeRFC.getReturn().isSuccess() );
                        Logger.debug.println(this, "====changeRFC.getReturn().isSuccess()======== : " +  changeRFC.getReturn() );

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
