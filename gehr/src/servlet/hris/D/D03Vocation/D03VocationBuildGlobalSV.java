/********************************************************************************/
/*                                                                              									*/
/*   System Name  	: MSS                                                         						*/
/*   1Depth Name  	: MY HR 정보                                                 								*/
/*   2Depth Name  	: 휴가                                                        									*/
/*   Program Name 	: 휴가 신청                                                  									*/
/*   Program ID   		: D03VocationBuildSV                                          					*/
/*   Description  		: 휴가를 신청할 수 있도록 하는 Class                          					*/
/*   Note         		:                                                             							*/
/*   Creation     		: 2002-01-03  김도신                                         							*/
/*   Update       		: 2005-02-16  윤정현                                          							*/
/*   Update       		: 2007-09-19  li hui                                         						*/
/*   Update       		: 2008-01-11  김정인                                          							*/
/*                           경조휴가 타입이 혼가,상가일 경우 신청대상자를 저장.                       */
/*   Update       		: 2008-02-20  김정인                                          							*/
/*                      	   휴가유형에 따른 selectbox 업무코드를 가져온다.                        	*/
/*                         : 2017-03-20 김은하  [CSR ID:3303691]  사후신청방지 로직추가          */
/*						    : 2017-04-20 김은하 [CSR ID:3359686]   남경 결재 5일제어       		 */
/*						    : 2017-05-10 김은하 [CSR ID:3374709] 해외 휴가 신청 관련 로직 수정  */
/* 						: 2018-02-20 cykim [CSR ID:3568065] 근태관리 로직 변경의 건          */
/*
	Sevlet				D03RemainVocationGlobalRFC	ZGHR_RFC_GET_REMAIN_HOLIDAY	중복체크를 위해 기존 내역
							D03CheckDataRFC				ZGHR_RFC_LEAVE_CHECK				mess check
							D16OTHDDupCheckRFC															중복체크를 위해 기존 내역
			check			D18HolidayCheckRFC				ZGHR_RFC_HOLIDAY_CHECK			날짜 체크.
							D01OTCheckGlobalRFC			ZGHR_WORK_END_DATE_CHECK		초과근무 해당여부를 첵크
			checkTime	D03CheckTimeRFC				ZHR_RFC_TIME_CHECK					반차시간정확성 검증
			checkDay	D01OTCheckGlobalRFC			ZGHR_WORK_END_DATE_CHECK		초과근무 해당여부를 첵크
																	ZGHR_RFC_OVERTIME_CHECK			해당일자테크
			create		D03VocationGlobalRFC			ZGHR_RFC_HOLIDAY_REQUEST		휴가 신청,수정,삭제,조회(해외)
	JSP	start			D17HolidayTypeRFC				ZGHR_RFC_HOLIDAY_ENTRY			휴가유형목록
							D03HolidayAbsenceRFC			ZGHR_RFC_GET_HOLIDAY_ABSENCE	개인의 잔여휴가일수 정보
*/
/********************************************************************************/

package servlet.hris.D.D03Vocation;

import java.io.PrintWriter;
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

import hris.D.D01OT.rfc.D01OTCheckGlobalRFC;
import hris.D.D03Vocation.D03RemainVocationData;
import hris.D.D03Vocation.D03VocationData;
import hris.D.D03Vocation.rfc.D03CheckDataRFC;
import hris.D.D03Vocation.rfc.D03CheckTimeRFC;
import hris.D.D03Vocation.rfc.D03RemainVocationGlobalRFC;
import hris.D.D03Vocation.rfc.D03VocationGlobalRFC;
import hris.D.rfc.D16OTHDDupCheckRFC;
import hris.D.rfc.D18HolidayCheckRFC;
import hris.common.PersonData;
import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalLineData;
import hris.common.rfc.PersonInfoRFC;
import hris.common.util.AppUtil;
import hris.common.util.AppUtilEurp;

public class D03VocationBuildGlobalSV extends ApprovalBaseServlet {

	private String UPMU_TYPE = "02"; // 결재 업무타입(휴가신청)

	private String UPMU_NAME = "Leave";

    protected String getUPMU_TYPE() {
        return UPMU_TYPE;
    }

    protected String getUPMU_NAME() {
        return UPMU_NAME;
    }
	protected void performTask(final HttpServletRequest req, final HttpServletResponse res)
			throws GeneralException {
//		Connection con = null;

		try {
			req.setCharacterEncoding("utf-8");

			HttpSession session = req.getSession(false);

			final WebUserData user = (WebUserData) session.getAttribute("user");

			String dest 	  			= "";

			final Box box = WebUtil.getBox(req);

			final String jobid = box.get("jobid", "first");

			final String PERNR = getPERNR(box, user); // box.get("PERNR", user.empNo);
			Logger.debug.println(this, "[#####]	BOX		:	[ " + box.toString() + " ]");
			//Logger.debug.println(this, "[#####]	USER		:	[ " + user.toString() + " ]");
			Logger.debug.println(this, "[#####]	JOBID		:	[ " + jobid + " ]	/	PERNR	:	[ " + PERNR + " ]");

			//**********************************************************
			//휴가유형에 따른 selectbox 업무코드.(value1)		2008-02-20.
			final String UPMU_CODE = box.get("TMP_UPMU_CODE", UPMU_TYPE);

			if(!jobid.equals("first")){
				UPMU_TYPE = UPMU_CODE;
				Logger.debug.println(this, "[#####]	JOBID	 :	[ " + jobid + " ]	UPMU_TYPE	 :	[ " + UPMU_TYPE + " ]");
			}
			//**********************************************************

			// 대리 신청 추가
//			PhoneNumRFC numfunc = new PhoneNumRFC();
//			PhoneNumData phonenumdata;
//			phonenumdata = (PhoneNumData) numfunc.getPhoneNum(PERNR);
//			req.setAttribute("PhoneNumData", phonenumdata);

            PersonInfoRFC numfunc = new PersonInfoRFC();
            final PersonData phonenumdata    = (PersonData)numfunc.getPersonInfo(PERNR);
            req.setAttribute("PersonData" , phonenumdata );

			final Vector d03VocationData_vt = new Vector();
			D03VocationData d03VocationData = new D03VocationData();

			d03VocationData.AWART 				= "0110";	// default 전일휴가
			d03VocationData.DEDUCT_DATE 		= "1";
			d03VocationData.PERNR 				= PERNR;
			DataUtil.fixNull(d03VocationData);

			// 개인의 잔여휴가일수 조회
			D03RemainVocationGlobalRFC rfcRemain = new D03RemainVocationGlobalRFC();
			Vector D03RemainVocationData_vt = null;
			D03RemainVocationData_vt = rfcRemain.getRemainVocation(PERNR, "", "");
			d03VocationData.ANZHL_BAL = ((D03RemainVocationData) D03RemainVocationData_vt.get(0)).ANZHL_BAL;
			D03RemainVocationData d03RemainVocationData  =((D03RemainVocationData) D03RemainVocationData_vt.get(0));

			Logger.debug.println(this, "[#####]	JOBID	 :	[ " + jobid + " ]	d03RemainVocationData	 :	[ " + d03RemainVocationData + " ]");

			d03VocationData_vt.addElement(d03VocationData);
			req.setAttribute("d03VocationData_vt", d03VocationData_vt);

			//checkData
			D03CheckDataRFC crfc=  new D03CheckDataRFC();

//			String checkmess		=	"";//crfc.checks(PERNR);	// 사용하지않음. v.1.3
			String E_BUKRS 		=	user.companyCode;

			//Logger.debug.println(this, "[#####]	JOBID	 :	[ " + jobid + " ]	checkmess	:	[ " + checkmess + " ]");

//			req.setAttribute("checkmess", checkmess);
			req.setAttribute("E_BUKRS", E_BUKRS);

			final D01OTCheckGlobalRFC d01OTCheckGlobalRFC = new D01OTCheckGlobalRFC();

			// ******************************************************************************************

			if (jobid.equals("first")) {

                //결재라인, 결재 헤더 정보 조회
                getApprovalInfo(req, PERNR);    //<-- 반드시 추가
				req.setAttribute("jobid", jobid);
				req.setAttribute("PERNR", PERNR);

				// 기존 신청되어있는 휴가건 조회
				// ******************************************************************************************
				D16OTHDDupCheckRFC d16OTHDDupCheckRFC = new D16OTHDDupCheckRFC();
				Vector OTHDDupCheckData_vt = null;
				OTHDDupCheckData_vt = d16OTHDDupCheckRFC.getCheckList(PERNR, UPMU_TYPE, user.area);

				req.setAttribute("OTHDDupCheckData_vt", OTHDDupCheckData_vt);
				Logger.debug.println(this, "OTHDDupCheckData_vt : " + OTHDDupCheckData_vt.toString());
				// ******************************************************************************************

                req.setAttribute("jobid",                 jobid);
                req.setAttribute("d03RemainVocationData",  d03RemainVocationData);

				dest = WebUtil.JspURL + "D/D03Vocation/D03VocationBuild_Global.jsp";


				// ******************************************************************************************

			} else if (jobid.equals("check")) {	//날짜 체크.

				String AWART			= req.getParameter("AWART");				//휴가유형
				String APPL_FROM 	= req.getParameter("APPL_FROM");			//시작일
				String APPL_TO 		= req.getParameter("APPL_TO");				//종료일
				String BEGUZ 			= req.getParameter("BEGUZ") + "00";		//시작시간
				String ENDUZ 			= req.getParameter("ENDUZ") + "00";		//종료시간
				//String BEGDA	         = req.getParameter("APPL_FROM");       //[CSR ID:3303691]  사후신청금지
				String BEGDA	         = req.getParameter("APPL_TO");			//[CSR ID:3568065] 근태관리 로직 변경의 건: 사후신청금지 휴가시작일자 기준에서 휴가종료일자 기준으로 변경 요청

				D18HolidayCheckRFC rfcCheck = new D18HolidayCheckRFC();
				Vector checkData = rfcCheck.getRemainVocation(PERNR, AWART, APPL_FROM, APPL_TO, BEGUZ, ENDUZ);
				String function	  = (String) checkData.get(0);
				String function1 = (String) checkData.get(1);
				String function2 = (String) checkData.get(2);
				String function3 = (String) checkData.get(3);
				String flag = "";
				//[CSR ID:3303691]  사후신청금지START
				String dateCheckFlag = "";
				String dateCheckMsg = "";
				//[CSR ID:3303691]  사후신청금지 END


				if (!rfcCheck.getReturn().isSuccess()) 					{
					flag = rfcCheck.getReturn().MSGTY ;
					function1 = rfcCheck.getReturn().MSGTX ;
				}else{

					//String UPMU_TYPE = "02";


					flag = d01OTCheckGlobalRFC.check1(PERNR, APPL_FROM, UPMU_TYPE);

					//[CSR ID:3303691]  사후신청금지START
					d01OTCheckGlobalRFC.check2(req, PERNR,  BEGDA,  BEGUZ,  UPMU_TYPE,  AWART );
					dateCheckFlag = d01OTCheckGlobalRFC.getReturn().MSGTY;

				}
				PrintWriter out = res.getWriter();
				out.println(function + "," + function1 + "," + function2 + "," + function3 + "," + flag+","+dateCheckFlag);
				//[CSR ID:3303691]  사후신청금지 END


				Logger.debug.println("[#####]	JOBID	 :	[ " + jobid + " ]	1) UPMU_TYPE		 :	[ " + UPMU_TYPE + " ]");
				Logger.debug.println("[#####]	JOBID	 :	[ " + jobid + " ]	2) checkData	 :	[ " + function + " ]	/ " + " [ " + function1 + " ] 	/ " +
																																	  " [ " + function2 + " ]	/ " +  " [ " + function3 + " ]");
				Logger.debug.println("[#####]	JOBID	 :	[ " + jobid + " ]	3) flag	 :	[ " + flag + " ]");

				return;

			} else if (jobid.equals("getApp")) {		//결제자 변경.

				String E_ABRTG	= req.getParameter("E_ABRTG");
				String AWART		= req.getParameter("AWART");
				String sPERNR 		= req.getParameter("PERNR");

				Vector AppLineData_vt = null;
				AppLineData_vt = AppUtilEurp.getAppVector1(sPERNR, UPMU_TYPE,E_ABRTG,AWART);
//				AppLineData_vt = AppUtil.getAppVector(sPERNR, UPMU_TYPE,E_ABRTG,AWART);


//				String app = hris.common.util.AppUtilEurp.getAppBuild((Vector) AppLineData_vt);
				String app = hris.common.util.AppUtil.getAppBuild((Vector) AppLineData_vt);

//				app = AppUtilEurp.escape(app);
				app = AppUtil.escape(app);
				res.getWriter().print(app);
				return;


				// ******************************************************************************************

			} else if (jobid.equals("checkTime")) {

				String BEGUZ = req.getParameter("BEGUZ");
				String ENDUZ = req.getParameter("ENDUZ");

				D03CheckTimeRFC rfc = new D03CheckTimeRFC();

				String E_FLAG = rfc.check(BEGUZ, ENDUZ);

//				if (!rfc.getReturn().isSuccess()) 					E_FLAG = rfc.getReturn().MSGTX ;

				E_FLAG = AppUtilEurp.escape(E_FLAG);

				Logger.debug.println("[#####]	JOBID	 :	[ " + jobid + " ]	1) E_FLAG	 :	[ " + E_FLAG + " ]");

				res.getWriter().print(E_FLAG);
				return;



				// ******************************************************************************************


			} else if (jobid.equals("checkDay")) {  //------------근태기간완료된것을 신청하는  check (li hui)-------------

				String sPERNR 			= req.getParameter("PERNR");
				String BEGDA	= req.getParameter("APPL_FROM");
				//String UPMU_TYPE = "02";

				//String flag = rfc.check(PERNR, BEGDA);
				String flag = d01OTCheckGlobalRFC.check1(sPERNR, BEGDA, UPMU_TYPE);

				Logger.debug.println("[#####]	JOBID	 :	[ " + jobid + " ]	1) flag	 :	[ " + flag + " ]");

				res.getWriter().print(flag);
				return;



				// ******************************************************************************************


			} else if (jobid.equals("create")) {

        	    dest = requestApproval(req, box,  D03VocationData.class, new RequestFunction<D03VocationData>() {
	                        public String porcess(D03VocationData d03VocationData, Vector<ApprovalLineData> approvalLine)
                    		throws GeneralException {

				D03VocationGlobalRFC rfc = new D03VocationGlobalRFC();
				//d03VocationData = new D03VocationData();

				// D03WorkPeriodRFC rfcWork = new D03WorkPeriodRFC();
				// D03WorkPeriodData d03WorkPeriodData = new D03WorkPeriodData();
				// 잔여휴가일수, 장치교대근무조 체크
				// D03RemainVocationGlobalRFC rfcRemain = null;
				// D03RemainVocationData d03RemainVocationData = new D03RemainVocationData();

				//d03VocationData_vt = new Vector();
				String AINF_SEQN = "";
				String message = "";

				// String dateFrom = "";
				// String dateTo = "";
				// double remain_date = 0.0;
				// double vacation_day = 0.0; // 휴무일수
				// long beg_time = 0;
				// long end_time = 0;
				// long work_time = 0;

				// 휴가신청 저장..
				box.copyToEntity(d03VocationData);
				d03VocationData.PERNR = PERNR; 										// 사원번호
				d03VocationData.AWART 			= box.get("AWART1"); 			// 근무/휴무 유형
				d03VocationData.ABSN_DATE 	= box.get("P_STDAZ2");
				d03VocationData.ABRTG 			= box.get("E_ABRTG");
				d03VocationData.STDAZ 			= box.get("I_STDAZ");
				d03VocationData.ZPERNR 			= user.empNo; 					// 신청자
				d03VocationData.UNAME 			= user.empNo; 					// 신청자
				d03VocationData.AEDTM 			= DataUtil.getCurrentDate(); // 변경일(현재날짜)

				//****************************************************************
				//경조휴가 타입이 혼가,상가일 경우 신청대상자를 저장.	2008-01-11.
				if(box.get("AWART").equals("0120") || box.get("AWART").equals("0121")){
					d03VocationData.CELTY 			= box.get("AWART");					//경조휴가 코드
					d03VocationData.CELTX 			= box.get("ATEXT");						//경조휴가 TEXT
					d03VocationData.FAMY_CODE 	= box.get("FAMY_CODE");				//가족유형 코드
					d03VocationData.FAMY_TEXT 	= box.get("FAMY_TEXT");				//가족유형 TEXT
				}
				//****************************************************************

				//Vector D03VocationData_vt = new Vector();
				D03VocationData data = new D03VocationData();

				box.copyToEntity(data);
				data.PERNR = PERNR;

				DataUtil.fixNull(data);

				// check whether overtime overlaps leave time
				doWithData(data);
				{
			/*
				D01OTCheck1RFC chk = new D01OTCheck1RFC();
				chk.check(PERNR, box.get("APPL_FROM"), box.get("BEGUZ"),box.get("ENDUZ"));
				String msg2 = chk.getReturn().MSGTX;
				Logger.debug.println("여기에서 받고 나오는 값은  ?    " + msg2);

				String msg = "";
				String url = "";

				if (!chk.getReturn().isSuccess()) {
					url = "location.href = 'javascript:history.go(-1)';";
					//getApp();
					req.setAttribute("msg", msg);
					req.setAttribute("msg2", msg2);
					req.setAttribute("url", url);

					printJspPage(req, res, WebUtil.JspURL + "common/msg.jsp");
					return null;
				}*/

					//[CSR ID:3374709] 해외 휴가 신청 관련 로직 수정 START
					//[CSR ID:3303691] 사후신청금지 START
					//d01OTCheckGlobalRFC.check2(req, PERNR,  box.get("APPL_FROM"),  data.BEGUZ,  UPMU_TYPE,  data.AWART );
					//doWithData 는 로직 오류가 있음.. data 는 사용하면 안됨
					//[CSR ID:3568065] 근태관리 로직 변경의 건 start
					d01OTCheckGlobalRFC.check2(req, PERNR,  box.get("APPL_TO"),  box.get("BEGUZ"),  UPMU_TYPE,  data.AWART );
					//d01OTCheckGlobalRFC.check2(req, PERNR,  box.get("APPL_FROM"),  box.get("BEGUZ"),  UPMU_TYPE,  data.AWART );
					//[CSR ID:3568065] 근태관리 로직 변경의 건 end
					//[CSR ID:3374709] 해외 휴가 신청 관련 로직 수정 END
					if (d01OTCheckGlobalRFC.getReturn().MSGTY.equals("E")) {
						throw new GeneralException(g.getMessage("MSG.D.D01.0106"));//어제 일자부터 신청가능합니다.
					}
					//[CSR ID:3303691] 사후신청금지 END

					//[CSR ID:3359686]   남경 결재 5일제어 START
					d01OTCheckGlobalRFC.checkApprovalPeriod(req, PERNR, "R",box.get("APPL_FROM"),  UPMU_TYPE, data.AWART );
	                if ("E".equals(d01OTCheckGlobalRFC.getReturn().MSGTY)) {
	                	req.setAttribute("alertMsg2",  g.getMessage("MSG.D.D01.0107"));

					}
	                 //[CSR ID:3359686]   남경 결재 5일제어 END

				}
				d03VocationData_vt.addElement(data);
				Logger.debug.println(this, data.toString());

				// ******************************************************************************************

				if (!message.equals("")) { // 메세지가 있는경우
					d03VocationData_vt.addElement(d03VocationData);

					D16OTHDDupCheckRFC func2 = new D16OTHDDupCheckRFC();
					Vector OTHDDupCheckData_vt = func2.getCheckList(PERNR, UPMU_TYPE, user.area);

					Logger.debug.println(this, "원래패이지로");
					req.setAttribute("jobid", jobid);
					req.setAttribute("message", message);
					req.setAttribute("d03VocationData_vt", d03VocationData_vt);
					req.setAttribute("OTHDDupCheckData_vt", OTHDDupCheckData_vt);
                    getApprovalInfo(req, PERNR);    //<-- 반드시 추가

                    req.setAttribute("approvalLine", approvalLine); //변경된 결재라인

					// req.setAttribute("d03WorkPeriodData_vt", d03WorkPeriodData_vt);
					// req.setAttribute("d03RemainVocationData", d03RemainVocationData);
					return null;

				} else { // 저장


					d03VocationData.AINF_SEQN		= AINF_SEQN;		// 결재정보 일련번호
					d03VocationData.AINF_SEQN2	= box.get("AINF_SEQN2");
					d03VocationData.STDAZ			= box.get("I_STDAZ");
					Logger.debug.println(this, "저장으로");

                    rfc.setRequestInput(user.empNo, UPMU_TYPE);
					AINF_SEQN = rfc.build(PERNR,  d03VocationData, box, req);

                    if(!rfc.getReturn().isSuccess()) {
                        throw new GeneralException(rfc.getReturn().MSGTX);
                    }
				}
				return AINF_SEQN;
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

		}
	}




	private void doWithData(D03VocationData data) {
		if (!data.BEGDA.equals(""))
			data.BEGDA = data.BEGDA.substring(0, 4)
					+ data.BEGDA.substring(5, 7) + data.BEGDA.substring(8);
		if (!data.APPL_FROM.equals(""))
			data.APPL_FROM = data.APPL_FROM.substring(0, 4)
					+ data.APPL_FROM.substring(5, 7)
					+ data.APPL_FROM.substring(8);
		if (!data.APPL_TO.equals(""))
			data.APPL_TO = data.APPL_TO.substring(0, 4)
					+ data.APPL_TO.substring(5, 7)
					+ data.APPL_TO.substring(8);
		if (!data.BEGUZ.equals(""))
			data.BEGUZ = data.BEGUZ.substring(0, 2) + data.BEGUZ.substring(3)
					+ "00";
		if (!data.ENDUZ.equals(""))
			data.ENDUZ = data.ENDUZ.substring(0, 2) + data.ENDUZ.substring(3)
					+ "00";

	}


}


