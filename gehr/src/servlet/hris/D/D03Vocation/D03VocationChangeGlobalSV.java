/********************************************************************************/
/*                                                                              									*/
/*   System Name  	: MSS                                                         						*/
/*   1Depth Name  	: 신청                                                        									*/
/*   2Depth Name  	: 근태                                                        									*/
/*   Program Name 	: 휴가 수정                                                   									*/
/*   Program ID   		: D03VocationChangeSV                                         				*/
/*   Description  		: 휴가 수정 할수 있도록 하는 Class                            					*/
/*   Note         		:                                                             							*/
/*   Creation     		: 2002-01-04  김도신                                         							*/
/*   Update       		: 2005-03-04  유용원                                          							*/
/*   Update       		: 2008-01-11  김정인                                          							*/
/*                           경조휴가 타입이 혼가,상가일 경우 신청대상자를 저장.                       */
/*   Update       		: 2008-02-20  김정인                                          							*/
/*                      	   휴가유형에 따른 selectbox 업무코드를 가져온다.                        	*/
/*                                                                              									*/
/*					        : 2017-04-19 김은하  [CSR ID:3359686]   남경 결재 5일제어*/
/*							//@PJ.멕시코 법인 Rollout 프로젝트 추가 관련(Area = MX("32")) 2018/02/09 rdcamel */
/********************************************************************************/

package servlet.hris.D.D03Vocation;

import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.common.Utils;
import com.common.constant.Area;
import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;

import hris.D.D01OT.rfc.D01OTCheckGlobalRFC;
import hris.D.D03Vocation.D03RemainVocationData;
import hris.D.D03Vocation.D03VocationData;
import hris.D.D03Vocation.rfc.D03CheckDataRFC;
import hris.D.D03Vocation.rfc.D03RemainVocationGlobalRFC;
import hris.D.D03Vocation.rfc.D03VocationGlobalRFC;
import hris.D.rfc.D16OTHDDupCheckRFC;
import hris.common.PersonData;
import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalHeader;
import hris.common.approval.ApprovalLineData;
import hris.common.rfc.PersonInfoRFC;

public class D03VocationChangeGlobalSV extends ApprovalBaseServlet {

    private String UPMU_TYPE ="02";            // 결재 업무타입(휴가신청)
	private String UPMU_NAME = "Leave";

    protected String getUPMU_TYPE() {
        return UPMU_TYPE;
    }

    protected String getUPMU_NAME() {
        return UPMU_NAME;
    }
	protected void performTask(final HttpServletRequest req, HttpServletResponse res)
			throws GeneralException {
//		Connection con = null;

		try {
			req.setCharacterEncoding("utf-8");

			HttpSession session = req.getSession(false);

			String dest 	  			= "";

			final WebUserData user = (WebUserData) session.getAttribute("user");
            /**         * Start: 국가별 분기처리
             * //@PJ.멕시코 법인 Rollout 프로젝트 추가 관련(Area = MX("32")) 2018/02/09 rdcamel  */
			if (user.area.equals(Area.PL) || user.area.equals(Area.DE)|| user.area.equals(Area.US)|| user.area.equals(Area.MX)) { // PL 폴랜드, DE 독일 은 유럽화면으로
        	   printJspPage(req, res, WebUtil.ServletURL+"hris.D.D03Vocation.D03VocationChangeEurpSV" );
		       	return;
			}
            /**             * END: 국가별 분기처리             */

			final Box box = WebUtil.getBox(req);
            final String jobid = box.get("jobid", "first");
			final String APPL_REAS = req.getParameter("APPL_REAS");

			//**********************************************************
			//휴가유형에 따른 selectbox 업무코드.(value1)		2008-02-20.
			final String UPMU_CODE =  box.get("TMP_UPMU_CODE", UPMU_TYPE);
			//UPMU_TYPE = UPMU_CODE;
			//**********************************************************

			final String AINF_SEQN = box.get("AINF_SEQN");
            String I_APGUB = (String) req.getAttribute("I_APGUB");  //+어느 페이지에서 왔나? '1' : 결재할 문서 , '2' : 결재중 문서 , '3' : 결재완료 문서

			Logger.debug.println(this, "[#####]	JOBID	 :	[ " + jobid + " ]	/	user.empNo	 :	[ " + user.empNo + " ]");
			//Logger.debug.println(this, "[#####]	USER  :	[ " + user.toString() + " ]");
			Logger.debug.println(this, "[#####]	JOBID	 :	[ " + jobid + " ]	UPMU_TYPE		 :	[ " + UPMU_TYPE + " ]");

			// **********수정 시작 (20050304:유용원)**********
			final D03VocationGlobalRFC rfc = new D03VocationGlobalRFC();
			D03VocationData d03VocationData = new D03VocationData();

			Vector d03VocationData_vt = null;

            rfc.setDetailInput(user.empNo, I_APGUB, AINF_SEQN); // 결재란설정

			// 휴가신청 조회
			d03VocationData_vt = rfc.getVocation(user.empNo, AINF_SEQN);
			final String PERNR = rfc.getApprovalHeader().PERNR; //box.get("PERNR", user.empNo);
			final D03VocationData firstData = (D03VocationData) Utils.indexOf(d03VocationData_vt,0);
			// 대리 신청 추가
//			PhoneNumRFC numfunc = new PhoneNumRFC();
//			PhoneNumData phonenumdata = null;
//			phonenumdata = (PhoneNumData) numfunc.getPhoneNum(firstData.PERNR);
//			req.setAttribute("PhoneNumData", phonenumdata);

            PersonInfoRFC numfunc = new PersonInfoRFC();
            final PersonData phonenumdata    = (PersonData)numfunc.getPersonInfo(PERNR);
            req.setAttribute("PersonData" , phonenumdata );

			Logger.debug.println(this, "[#####]	JOBID	 :	[ " + jobid + " ]	d03VocationData_vt	 :	[ " + d03VocationData_vt.toString() + " ]");
			// **********수정 끝.****************************

			//checkData
			D03CheckDataRFC crfc=  new D03CheckDataRFC();

			String checkmess		= crfc.checks(PERNR);
			String E_BUKRS 		= user.companyCode;

			//Logger.debug.println(this, "[#####]	JOBID	 :	[ " + jobid + " ]	checkmess	 :	[ " + checkmess + " ]");

			req.setAttribute("checkmess", checkmess);
			req.setAttribute("E_BUKRS", E_BUKRS);
			req.setAttribute("PERNR", PERNR);

			if (jobid.equals("first")) {

                req.setAttribute("isUpdate", true); //[결재]등록 수정 여부   <- 수정쪽에는 반드시 필요함

				// 휴가신청 조회
				d03VocationData = (D03VocationData) Utils.indexOf(d03VocationData_vt, 0);

				D03RemainVocationGlobalRFC rfcRemain = new D03RemainVocationGlobalRFC();
				Vector D03RemainVocationData_vt = null;

				D03RemainVocationData_vt = rfcRemain.getRemainVocation(firstData.PERNR, firstData.APPL_TO, "");
				d03VocationData.ANZHL_BAL = ((D03RemainVocationData) Utils.indexOf(D03RemainVocationData_vt,0)).ANZHL_BAL;
				D03RemainVocationData d03RemainVocationData  =((D03RemainVocationData) D03RemainVocationData_vt.get(0));
                req.setAttribute("d03RemainVocationData",  d03RemainVocationData);

				Logger.debug.println(this, "[#####]	JOBID	 :	[ " + jobid + " ]	ANZHL_BAL	 :	[ " + d03VocationData.ANZHL_BAL + " ]");

				d03VocationData_vt.addElement(d03VocationData);

				String ABRTG = box.get("ABRTG");
				String I_STDAZ = box.get("I_STDAZ");

				req.setAttribute("d03VocationData_vt", d03VocationData_vt);

//				 D16OTHDDupCheckRFC d16OTHDDupCheckRFC = new  D16OTHDDupCheckRFC();
//				 Vector OTHDDupCheckData_vt = null;
//				 OTHDDupCheckData_vt = d16OTHDDupCheckRFC.getCheckList(user.empNo, UPMU_TYPE , user.area);
//				 Logger.debug.println(this, "OTHDDupCheckData_vt : "+ OTHDDupCheckData_vt.toString());
//				 req.setAttribute("OTHDDupCheckData_vt", OTHDDupCheckData_vt);

                detailApporval(req, res, rfc);

    	        //Case of Europe(Poland, Germany) and USA
                /*
                 * e_area :	46 (Poland)
                 *         		01 (Germany)
                 *				10 (USA)
                */

				dest = WebUtil.JspURL
						+ "D/D03Vocation/D03VocationBuild_Global.jsp?I_STDAZ=" + I_STDAZ + "&ABRTG=" + ABRTG + "";

				if (user.e_area.equals("46")) {
					dest = WebUtil.JspURL
//							+ "D/D03Vocation/D03VocationChangePl.jsp?I_STDAZ" + I_STDAZ;
					+ "D/D03Vocation/D03VocationBuild_PL.jsp?I_STDAZ" + I_STDAZ;

				} else if (user.e_area.equals("01")) {
					dest = WebUtil.JspURL
//						+ "D/D03Vocation/D03VocationChangeDe.jsp?I_STDAZ=" + I_STDAZ + "&ABRTG=" + ABRTG + "";
					+ "D/D03Vocation/D03VocationBuild_DE.jsp?I_STDAZ=" + I_STDAZ + "&ABRTG=" + ABRTG + "";

				} else if (user.e_area.equals("10")||user.e_area.equals("32")) {//@PJ.멕시코 법인 Rollout 프로젝트 추가 관련(Area = MX("32")) 2018/02/09 rdcamel
					dest = WebUtil.JspURL
//						+ "D/D03Vocation/D03VocationChangeUsa.jsp?I_STDAZ=" + I_STDAZ + "&ABRTG=" + ABRTG + "";
					+ "D/D03Vocation/D03VocationBuild_US.jsp?I_STDAZ=" + I_STDAZ + "&ABRTG=" + ABRTG + "";
				}

			} else if (jobid.equals("change")) {		// 수정

                // 실제 수정 부분 /
                dest = changeApproval(req, box, D03VocationData.class, rfc, new ChangeFunction<D03VocationData>(){
                    public String porcess(D03VocationData d03VocationData, ApprovalHeader approvalHeader, Vector<ApprovalLineData> approvalLine)
                			throws GeneralException {

				//rfc = new D03VocationGlobalRFC();
				//d03VocationData = new D03VocationData();

				// D03WorkPeriodRFC rfcWork = new D03WorkPeriodRFC();
				// D03WorkPeriodData d03WorkPeriodData = new D03WorkPeriodData();
				// 잔여휴가일수, 장치교대근무조 체크
				// D03RemainVocationGlobalRFC rfcRemain = null;
				// D03RemainVocationData d03RemainVocationData = new
				// D03RemainVocationData();

				Vector d03VocationData_vt = new Vector();

				// String dateFrom		= "";
				// String dateTo 			= "";
				// long beg_time 			= 0;
				// long end_time 			= 0;
				// long work_time 		= 0;
				// double remain_date	= 0.0;
				// vacation_day 			= 0.0; // 휴무일수
				String message 	= "";
				String P_STDAZ	= box.get("P_STDAZ");
				String I_STDAZ	= box.get("I_STDAZ");

				// 휴가신청 저장..
				d03VocationData.AINF_SEQN 		= AINF_SEQN; 							// 결재정보 일련번호
				d03VocationData.BEGDA 			= box.get("BEGDA"); 					// 신청일
				d03VocationData.AWART 			= box.get("AWART1");					// 근무/휴무 유형
				d03VocationData.APPL_REAS 		= box.get("APPL_REAS"); 				// 신청 사유
				d03VocationData.APPL_FROM 	= box.get("APPL_FROM"); 				// 신청시작일
				d03VocationData.APPL_TO 		= box.get("APPL_TO"); 					// 신청종료일
				d03VocationData.BEGUZ 			= box.get("BEGUZ"); 					// 시작시간
				d03VocationData.ENDUZ 			= box.get("ENDUZ"); 					// 종료시간

				// **********수정 시작 (20050223:유용원)**********
				d03VocationData.PERNR 			= firstData.PERNR; 						// 사원번호
				d03VocationData.ZPERNR 			= user.empNo; 							// 사원번호
				d03VocationData.UNAME 			= user.empNo; 							// 신청자 사번 설정(대리신청 ,본인 신청)
				d03VocationData.AEDTM 			= DataUtil.getCurrentDate();			// 변경일(현재날짜)
				d03VocationData.ANZHL_BAL 		= box.get("ANZHL_BAL");
				d03VocationData.ABSN_DATE 	= box.get("P_STDAZ2");
				d03VocationData.ABRTG 			= box.get("E_ABRTG");
				d03VocationData.STDAZ 			= box.get("I_STDAZ");

				//****************************************************************
				//경조휴가 타입이 혼가,상가일 경우 신청대상자를 저장.	2008-01-11.
				if(box.get("AWART").equals("0120") || box.get("AWART").equals("0121")){
					d03VocationData.CELTY 			= box.get("AWART");					//경조휴가 코드
					d03VocationData.CELTX 			= box.get("ATEXT");						//경조휴가 TEXT
					d03VocationData.FAMY_CODE 	= box.get("FAMY_CODE");				//가족유형 코드
					d03VocationData.FAMY_TEXT 	= box.get("FAMY_TEXT");				//가족유형 TEXT
				}
				//****************************************************************
			    //[CSR ID:3359686]   남경 결재 5일제어 START
				D01OTCheckGlobalRFC checkrfc = new D01OTCheckGlobalRFC();
				checkrfc.checkApprovalPeriod(req, PERNR, "R", box.get("APPL_FROM"),   UPMU_CODE,  d03VocationData.AWART );
                if ("E".equals(checkrfc.getReturn().MSGTY)) {
                	req.setAttribute("alertMsg2",  g.getMessage("MSG.D.D01.0107"));
				}
                 //[CSR ID:3359686]   남경 결재 5일제어 end
				if (!message.equals("")) { // 메세지가 있는경우
					d03VocationData_vt.addElement(d03VocationData);

					Logger.debug.println(this, "원래패이지로");

					req.setAttribute("jobid", jobid);
					req.setAttribute("message", message);
					req.setAttribute("d03VocationData_vt", d03VocationData_vt);

					// req.setAttribute("d03RemainVocationData",
					// d03RemainVocationData);

					D16OTHDDupCheckRFC func2 = new D16OTHDDupCheckRFC();
                    getApprovalInfo(req, PERNR);    //<-- 반드시 추가

                    req.setAttribute("approvalLine", approvalLine); //변경된 결재라인

					// Vector OTHDDupCheckData_vt = func2.getCheckList(user.empNo, UPMU_TYPE );
					// req.setAttribute("OTHDDupCheckData_vt",OTHDDupCheckData_vt);
					return null;

				} else { // 저장

					Logger.debug.println(this, "저장으로");
					int rowcount = box.getInt("RowCount");

					d03VocationData.AINF_SEQN2 = box.get("AINF_SEQN2");
					d03VocationData.STDAZ = box.get("I_STDAZ");

					// 수정 저장시, 변경전 UPMU_TYPE 값.		2008-03-07.
					String UPMU_CODE1 = req.getParameter("UPMU_CODE1");

	                // * 결재 신청 RFC 호출 * /
	                rfc.setChangeInput(user.empNo, UPMU_TYPE, approvalHeader.AINF_SEQN);

					rfc.change(firstData.PERNR, AINF_SEQN, d03VocationData, box, req);

                    if(!rfc.getReturn().isSuccess()) {
                        req.setAttribute("msg", "수정에 실패 하였습니다.");   //실패 메세지 처리 - 임시
                        return null;
                    }
					return d03VocationData.AINF_SEQN;
				}
				}});

    		  //[CSR ID:3359686]   남경 결재 5일제어 START
                if(req.getAttribute("alertMsg2")!=null) req.setAttribute("msg2", req.getAttribute("msg2").equals("")  ? req.getAttribute("alertMsg2"): req.getAttribute("msg2")+ "\\n" +req.getAttribute("alertMsg2"));
			  //[CSR ID:3359686]   남경 결재 5일제어 END

			} else {
                throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
			}
			Logger.debug.println(this, "[#####]	JOBID	 :	[ " + jobid + " ]	destributed = " + dest);
			printJspPage(req, res, dest);

		} catch (Exception e) {
			throw new GeneralException(e);
		} finally {
			//DBUtil.close(con);
		}
	}
}
