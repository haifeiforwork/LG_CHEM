/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 초과근무                                                    */
/*   Program Name : 초과근무 조회                                               */
/*   Program ID   : D01OTDetailSV                                               */
/*   Description  : 초과근무 조회 및 삭제를 할 수 있도록 하는 Class             */
/*   Note         :                                                             */
/*   Creation     : 2002-01-15  박영락                                          */
/*   Update       : 2005-03-03  윤정현                                          */
/*                  2007-10-09  huang peng xiao                          */
/********************************************************************************/

package servlet.hris.D.D19Duty;

import hris.D.D01OT.rfc.D01OTCheckGlobalRFC;
import hris.D.D19Duty.D19DutyData;
import hris.D.D19Duty.D19DutyDetailData;
import hris.D.D19Duty.rfc.D19DutyEntryRFC;
import hris.D.D19Duty.rfc.D19DutyRFC;
import hris.D.rfc.D20ActTimeCardRFC;
import hris.common.PersonData;
import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalHeader;
import hris.common.approval.ApprovalLineData;
import hris.common.rfc.PersonInfoRFC;

import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.common.RFCReturnEntity;
import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.CodeEntity;
import com.sns.jdf.util.WebUtil;

public class D19DutyDetailSV extends ApprovalBaseServlet {

	private String UPMU_TYPE = "07";
	private String UPMU_NAME = "Duty";

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

			UPMU_TYPE = box.get("UPMU");

			//Logger.debug.println(this, "[jobid] = " + jobid + " [user] : " + user.toString());

			final D19DutyRFC d19Rfc = new D19DutyRFC();
			d19Rfc.setDetailInput(user.empNo, I_APGUB, AINF_SEQN); // set DetailInput

			Logger.debug.println(this, "[user.empNo] = " +  user.empNo );
			//Logger.debug.println(this, "[PERNR222] = " + PERNR );

			D19DutyData firstData = new D19DutyData();
			Vector D01OTData_vt = null;

			 //String appytype = ((ApprovalLineData)approvalLine.get(0)).APPR_TYPE;

			D01OTData_vt = d19Rfc.getDetail(AINF_SEQN, PERNR);
			firstData = (D19DutyData) D01OTData_vt.get(0);

			Logger.debug.println(this, "[D01OTData_vt] = " + D01OTData_vt.toString());
			Logger.debug.println(this, "[firstData.PERNR] = " +  firstData.PERNR );

			// 대리 신청 추가
            PersonInfoRFC numfunc = new PersonInfoRFC();
            PersonData phonenumdata;
            phonenumdata = (PersonData)numfunc.getPersonInfo(firstData.PERNR);
            req.setAttribute("PersonData" , phonenumdata );

			if (jobid.equals("first")) {

				D19DutyData d19Data  = ( D19DutyData )D01OTData_vt.get(0);

				//req.setAttribute("D01OTData_vt", D01OTData_vt);
				//req.setAttribute("resultData", d19Data);

				if (!detailApporval(req, res, d19Rfc))
	                   return;

				ApprovalHeader approvalHeader = (ApprovalHeader) req.getAttribute("approvalHeader");

				Vector vcAppLineData   = (Vector)req.getAttribute("approvalLine");

				//Logger.debug.println(this, "*****vcAppLineData= " + vcAppLineData  );
				//Logger.debug.println(this, "*****user.empNo.= " + user.empNo  );

				if("X".equals(approvalHeader.ACCPFL)) {  // 승인자..

					String  no ="";
					String APPU_TYPE = "";

					for (int i = 0; i < vcAppLineData.size(); i++) {
						ApprovalLineData appLineData = (ApprovalLineData) vcAppLineData.get(i);
						Logger.debug.println(this, "*****appLineData.APPU_NUMB.= " + appLineData.APPU_NUMB  );
						if(user.empNo.equals(appLineData.APPU_NUMB)){
							 no = "1";
							 APPU_TYPE = appLineData.APPU_TYPE;
							 Logger.debug.println(this, "appLineData.APPU_TYPE ================= " + appLineData.APPU_TYPE  );
						}else{
							 no = "2";
						}

						Logger.debug.println(this, "no ================= " + no  );
						Logger.debug.println(this, "appLineData.APPU_TYPE ================= " + APPU_TYPE  );

					 }

					 req.setAttribute("APPU_TYPE", APPU_TYPE);
					 //Logger.debug.println(this, "final no ================= " + no );
					 //Logger.debug.println(this, "finla appLineData.APPU_TYPE ================= " + APPU_TYPE );

					 D19DutyData d19DutyData;
					 D01OTData_vt = d19Rfc.getDetail1(AINF_SEQN, firstData.PERNR , no);
					 d19DutyData = (D19DutyData) D01OTData_vt.get(0);

	 				D19DutyEntryRFC rfc2 = new D19DutyEntryRFC();

	 				Vector ret = rfc2.getDutyEntry(d19DutyData.PERNR, d19DutyData.DUTY_DATE);
	 				Vector d19Duty = (Vector) ret.get(1);
	 				Vector duty = new Vector();

	 		        for(int i=0; i<d19Duty.size(); i++){
	 		        	D19DutyDetailData data = (D19DutyDetailData)d19Duty.get(i);

	 		        	CodeEntity codeEntity = new CodeEntity();
	 		        	codeEntity.code = data.DUTY;
	 		        	codeEntity.value = data.DUTY_TXT;
	 		        	duty.addElement(codeEntity);
	 		        }

	 		       //-------- 근태기간완료된것을  check (li hui)----------------------
	 		        D01OTCheckGlobalRFC rfc3 = new D01OTCheckGlobalRFC(); // D01OTCheckGlobalRFC
	                //2012-12-07 dongxiaomian	@v1.4 [C20121206_30728] 增加duty begin
	                String upmu_type = "07";
	                String flag = rfc3.check1(d19DutyData.PERNR, d19DutyData.DUTY_DATE, upmu_type);
	               //2012-12-07 dongxiaomian   	@v1.4 [C20121206_30728] 增加duty  end

					Logger.debug.println(this, "[#####]	d19DutyData	 :	[ " + d19DutyData + " ]	");
					//String flag = rfc3.check1(d19DutyData.PERNR, d19DutyData.DUTY_DATE, d19DutyData.UPMU);
					//Logger.debug.println(this, "[#####]	JOBID	 :	[ " + jobid + " ]	flag	 :	[ " + flag + " ]");


					//*******************************************************************************
					// BOHAI법인 통문시간 체크.		2009-12-23		jungin		@v1.0 [C20091222_81370]
	                // DAGU법인 통문시간 체크.  	2010-04-28		jungin		@v1.1 [C20100427_55533]
	                // BOTIAN법인 통문시간 체크.  	2011-01-19		liukuo		@v1.2 [C20110118_09919]
					if ( (phonenumdata.E_BUKRS.equals("G110") || phonenumdata.E_BUKRS == "G110")
	    					|| (phonenumdata.E_BUKRS.equals("G280") || phonenumdata.E_BUKRS == "G280")
	    					|| (phonenumdata.E_BUKRS.equals("G370") || phonenumdata.E_BUKRS == "G370")) {
	    				String I_TYPE = "D";

	    				Vector vc20ActTimeCardData = null;

	    				D20ActTimeCardRFC rfc4 = new D20ActTimeCardRFC();
	    				vc20ActTimeCardData = rfc4.getActTimeCard(d19DutyData.PERNR, d19DutyData.DUTY_DATE, d19DutyData.BEGUZ, d19DutyData.ENDUZ, I_TYPE);

	    				String E_BEGTIME	 = (String)vc20ActTimeCardData.get(0);
	    				String E_ENDTIME = (String)vc20ActTimeCardData.get(1);
	    				String E_BEGDATE = (String)vc20ActTimeCardData.get(2);
	    				String E_ENDDATE = (String)vc20ActTimeCardData.get(3);

	                    req.setAttribute("E_BEGTIME", E_BEGTIME);
	                    req.setAttribute("E_ENDTIME", E_ENDTIME);
	                    req.setAttribute("E_BEGDATE", E_BEGDATE);
	                    req.setAttribute("E_ENDDATE", E_ENDDATE);
					}
					//*******************************************************************************

					req.setAttribute("flag", flag );
	                req.setAttribute("duty", duty );
	                req.setAttribute("resultData", d19DutyData);
	                printJspPage(req, res, WebUtil.JspURL + "G/G067ApprovalDuty.jsp");
				}else {
					req.setAttribute("resultData", d19Data);
					printJspPage(req, res, WebUtil.JspURL + "D/D19Duty/D19DutyDetail.jsp");
				}


			} else if (jobid.equals("delete")) {

				String dest = deleteApproval(req, box, d19Rfc, new DeleteFunction() {
                    public boolean porcess() throws GeneralException {

                    	D19DutyRFC deleteRFC = new D19DutyRFC();
                        deleteRFC.setDeleteInput(user.empNo, UPMU_TYPE, d19Rfc.getApprovalHeader().AINF_SEQN);
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
