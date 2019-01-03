/********************************************************************************/
/*	  System Name  	: g-HR
/*   1Depth Name		: Application
/*   2Depth Name  	: Time Management
/*   Program Name 	: Overtime
/*   Program ID   		: D01OTBuildSV
/*   Description  		: 초과근무(OT/특근)신청을 하는 Class
/*   Note         		:
/*   Creation     		: 2002-01-15 박영락
/*   Update       		: 2005-03-07 윤정현
/*   Update       		: 2007-09-12 huang peng xiao
 * 							: 2008-05-27 김정인 [C20080514_66017] @v1.0 PhoneNumData
 * 							: 2008-11-26 김정인 [C20081125_62978] @v1.1 DAGU법인 OT신청 누적시간 체크
 *							: 2011-02-24 liukuo @v2.1 [C20110221_28931] LGCC NJ
 *							: 2016-05-19 pangxiaolin C20160505_56532 @v2.2 G170*/
/*                         : 2016-09-21 통합구축 - 김승철                      */
/*                         : 2017-03-20 김은하  [CSR ID:3303691]  사후신청방지 로직추가                      */
/*					        : 2017-04-03 김은하  [CSR ID:3340999]  대만 당월근태기간동안 46시간 제한*/
/*					        : 2017-04-19 김은하  [CSR ID:3359686]   남경 결재 5일제어*/
/*					        : 2017-08-24 김은하  근태년월 오류수정							*/
/********************************************************************************/

package servlet.hris.D.D01OT;

import java.sql.Connection;
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

import hris.D.D01OT.D01OTCheckData;
import hris.D.D01OT.D01OTData;
import hris.D.D01OT.rfc.D010TOvertimeGlobalRFC;
import hris.D.D01OT.rfc.D01OTCheck1RFC;
import hris.D.D01OT.rfc.D01OTCheckGlobalRFC;
import hris.D.D01OT.rfc.D01OTGetMonthRFC;
import hris.D.D01OT.rfc.D01OTRFC;
import hris.D.D01OT.rfc.D01OTReasonRFC;
import hris.D.Global.D02ConductDisplayMonthData;
import hris.D.rfc.D16OTHDDupCheckRFC;
import hris.D.rfc.Global.D02ConductDisplayMonthRFC;
import hris.common.PersonData;
import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalLineData;
import hris.common.rfc.PersonInfoRFC;
import hris.common.util.AppUtil;

public class D01OTBuildGlobalSV extends ApprovalBaseServlet {

    private String UPMU_TYPE ="01";
    private String UPMU_NAME = "OverTime";

    protected String getUPMU_TYPE() {
        return UPMU_TYPE;
    }

    protected String getUPMU_NAME() {
        return UPMU_NAME;
    }
	protected void performTask(final HttpServletRequest req, final HttpServletResponse res)
			throws GeneralException {
		Connection con = null;

		try {
			HttpSession session = req.getSession(false);

			final WebUserData user = (WebUserData) session.getAttribute("user");

			String dest	= "";

			final Box box = WebUtil.getBox(req);

			final String jobid = box.get("jobid", "first");
            boolean isUpdate= box.getBoolean("isUpdate");
            if(isUpdate!=true)isUpdate=false;

			final String PERNR = getPERNR(box, user); //신청대상자 사번     <==box.get("PERNR", user.empNo);

			//Logger.debug.println(this, "#####	box	:	[ " + box.toString() + " ]");
			//Logger.debug.println(this, "#####	user	:	[ " + user.toString() + " ]");
			//Logger.debug.println(this, "#####	jobid	:	[ " + jobid + " ]	/	PERNR :	[ " + PERNR + " ]");

			// 대리 신청 추가
            PersonInfoRFC numfunc = new PersonInfoRFC();
            PersonData phonenumdata;
            phonenumdata = (PersonData)numfunc.getPersonInfo(PERNR);

            final D01OTCheckGlobalRFC checkGlobalRfc = new D01OTCheckGlobalRFC();

//			 2016-05-19 pangxiaolin C20160505_56532 @v2.2 G170 start
			D01OTReasonRFC rfc_reasontype = new D01OTReasonRFC();
			Vector d01OTReasonData_vt = rfc_reasontype.getTypeCode(PERNR);
			Logger.debug.println(this, "d01OTReasonData_vt" + d01OTReasonData_vt.toString());
			req.setAttribute("reasonCode", d01OTReasonData_vt);
//			2016-05-19 pangxiaolin C20160505_56532 @v2.2 G170 end

            req.setAttribute("PersonData" , phonenumdata );

			req.setAttribute("E_BUKRS", phonenumdata.E_BUKRS);

			req.setAttribute("E_JIKKB", phonenumdata.E_JIKKB);
            req.setAttribute("PERNR" , PERNR );
			req.setAttribute("ZMODN",PERNR);	//GHR에는 build.JSP단에 pernr를 넣어두어서 그냥 넣어둠
			req.setAttribute("FTKLA",PERNR);	// Change.jsp에는 servlet에서 넘겨받음.

            req.setAttribute("committed", "N"); // check already response 2017/1/3 ksc

			if (jobid.equals("first")) {

				Vector D01OTData_vt = new Vector();
				D01OTData data = new D01OTData();

				box.copyToEntity(data);
				data.PERNR = PERNR;
				DataUtil.fixNull(data);

				D01OTData_vt.addElement(data); // 정보를 클라이언트로 되돌린다.
				req.setAttribute("D01OTData_vt", D01OTData_vt);

                //결재라인, 결재 헤더 정보 조회
                getApprovalInfo(req, PERNR);    //<-- 반드시 추가

				req.setAttribute("jobid", jobid);

				D16OTHDDupCheckRFC d16OTHDDupCheckRFC = new D16OTHDDupCheckRFC();
				Vector OTHDDupCheckData_vt = null;
				OTHDDupCheckData_vt = d16OTHDDupCheckRFC.getCheckList(PERNR,UPMU_TYPE, user.area);

//				 2016-05-19 pangxiaolin C20160505_56532 @v2.2 G170 start
				req.setAttribute("d01OTReasonData_vt", d01OTReasonData_vt);
				// 2016-05-19 pangxiaolin C20160505_56532 @v2.2 G170 end

				req.setAttribute("OTHDDupCheckData_vt", OTHDDupCheckData_vt);
//				Logger.debug.println(this, "OTHDDupCheckData_vt : " + OTHDDupCheckData_vt.toString());

				dest = WebUtil.JspURL + "D/D01OT/D01OTBuild_Global.jsp";

			} else if (jobid.equals("getApp")) {

				String BEGDA	= req.getParameter("WORK_DATE");
				String STDAZ	= req.getParameter("STDAZ");
				String beforeSTDAZ	= req.getParameter("beforeSTDAZ");
				String BEGUZ	= req.getParameter("BEGDA");
				String PERNR1	= req.getParameter("PERNR");

				Logger.debug.println("#####	BEGDA		:	[ " + BEGDA	+ " ]");
				Logger.debug.println("#####	BEGUZ		:	[ " + BEGUZ	+ " ]");
				Logger.debug.println("#####	STDAZ		:	[ " + STDAZ	+ " ]");
				//*******************************************************************************
				// DAGU법인 누적 E_ANZHL 체크.	2008-11-26		김정인		[C20081125_62978] @v1.1
				String IFlag		= "N";		// 신청시는 'N', 결제시는 'Y'

				D010TOvertimeGlobalRFC rfc = new D010TOvertimeGlobalRFC();
				String E_ANZHL = rfc.check(PERNR, BEGDA, IFlag); // 총연장시간; SAP상에 G180, G450의 경우 휴일근로시간이 빠지게되어있음.(2017/1/12확인)

				Vector AppLineData_vt = null;
				String hours = String.valueOf(Double.parseDouble(E_ANZHL)
//						- (isUpdate ? Double.parseDouble(beforeSTDAZ) : 0) // 수정시 기존시간을 빼준다.2017/1/13 ksc // JSP에서 처리
						+ Double.parseDouble(STDAZ));

				//get work days -- liukuo add 2011.3.4
				//String workDays ="2";
//				String v_beguz = BEGUZ.substring(0,4)+BEGUZ.substring(5,7)+BEGUZ.substring(8,10);
				String v_beguz = BEGUZ;
				String ret_val = rfc.getWorkDays(PERNR, BEGDA,v_beguz);
				String workDays = String.valueOf(ret_val );
				//  get monthly overtime ours -- liukuo add 2011.3.4
				//--------------------start--------------------/
				Vector temp_vt = new Vector();   //temp Vector 1
//	          Vector detailData_vt = new Vector();  //temp Vector 2

	            Vector dayDetial_vt = new Vector();
			    Vector monthTotal_vt = new Vector();
			    String E_RETURN = "";
			    String E_MESSAGE = "";

			    //2017-08-24 김은하  근태년월 오류수정 start
			    D01OTGetMonthRFC d01OTGetMonthRFC = new D01OTGetMonthRFC();
			    String E_MONTH = d01OTGetMonthRFC.getMonth(PERNR,BEGDA);
			    D02ConductDisplayMonthRFC monthfunc= new D02ConductDisplayMonthRFC();
	            //temp_vt = monthfunc.getMonAndDay(user.empNo, BEGDA.substring(0,4), BEGDA.substring(4,6));
			    temp_vt = monthfunc.getMonAndDay(PERNR, E_MONTH.substring(0,4), E_MONTH.substring(4,6));
				//2017-08-24 김은하  근태년월 오류수정 end

			    E_RETURN  = temp_vt.get(0).toString();

	            D02ConductDisplayMonthData monthlyData = new D02ConductDisplayMonthData();

	            if(E_RETURN.trim().equals("S")){
	              E_MESSAGE = temp_vt.get(1).toString();
	              dayDetial_vt = (Vector)temp_vt.get(2);
	              monthTotal_vt = (Vector)temp_vt.get(3);
	              monthlyData = (D02ConductDisplayMonthData)monthTotal_vt.get(0);
	            }else{
	            	 dayDetial_vt = new Vector();
	    		     monthTotal_vt = new Vector();
	    		     monthlyData = new D02ConductDisplayMonthData();
	            }
	            String workHours = String.valueOf(Double.parseDouble(monthlyData.OT_WOR) +  Double.parseDouble(STDAZ));
	            String offHours = String.valueOf(Double.parseDouble(monthlyData.OT_OFF) +  Double.parseDouble(STDAZ));
	            String holHours = String.valueOf(Double.parseDouble(monthlyData.OT_HOL) +  Double.parseDouble(STDAZ));
               //--------------------end--------------------/

				Logger.debug.println("#####	E_ANZHL		:	[ " + E_ANZHL	+ " ]");
				Logger.debug.println("#####	hours			:	[ " + hours		+ " ]");
//				Logger.debug.println("#####	OT_WOR		:	[ " + monthlyData.OT_WOR	+ " ]");
//				Logger.debug.println("#####	OT_OFF		:	[ " + monthlyData.OT_OFF		+ " ]");
//				Logger.debug.println("#####	OT_HOL		:	[ " + monthlyData.OT_HOL		+ " ]");
				Logger.debug.println("#####	workHours	:	[ " + workHours	+ " ]");
				Logger.debug.println("#####	offHours		:	[ " + offHours		+ " ]");
				Logger.debug.println("#####	holHours		:	[ " + holHours		+ " ]");
				Logger.debug.println("#####	workDays	:	[ " + workDays		+ " ]");
				//*******************************************************************************
				//2017-04-03 김은하  [CSR ID:3340999]  대만 당월근태기간동안 46시간 제한 START
				Logger.debug.println("#####	isUpdate	:	[ " + box.getString("isUpdate")		+ " ]");
				if(box.getString("isUpdate").equals("true")){
				    checkGlobalRfc.checkOvertimeTp46Hours(req, PERNR,  "M" ,box.getString("AINF_SEQN"), box.getString("WORK_DATE"),  box.getString("STDAZ") );
				}else {
					checkGlobalRfc.checkOvertimeTp46Hours(req, PERNR,  "R", "",  box.getString("WORK_DATE"),  box.getString("STDAZ") );
				}
			    String dateTk46Flag = checkGlobalRfc.getReturn().MSGTY;
				//2017-04-03 김은하  [CSR ID:3340999]  대만 당월근태기간동안 46시간 제한 END


				AppLineData_vt = AppUtil.getAppVector(PERNR1, UPMU_TYPE, BEGDA,hours);
				String app = hris.common.util.AppUtil.getAppBuild((Vector) AppLineData_vt.get(0));
				app = AppUtil.escape(app);
				app += "||||";
				app += (String) AppLineData_vt.get(1);
				app += "||||";
				app += hours;
				app += "||||";
				app += workHours;
				app += "||||";
				app += offHours;
				app += "||||";
				app += holHours;
				app += "||||";
				app += workDays;
				app += "||||";
				app += dateTk46Flag;

				res.getWriter().print(app);
				return;


			} else if (jobid.equals("check")) {

				D01OTCheckGlobalRFC rfc = new D01OTCheckGlobalRFC();
				Vector check_vt = rfc.check(PERNR, box.getString("WORK_DATE"));

				String ENDZT	= WebUtil.printTime(((D01OTCheckData) check_vt.get(0)).ENDZT);
				String BEGZT	= WebUtil.printTime(((D01OTCheckData) check_vt.get(0)).BEGZT);
				String ZMODN	= ((D01OTCheckData) check_vt.get(0)).ZMODN;
				String FTKLA	= ((D01OTCheckData) check_vt.get(0)).FTKLA;

				//-------- 근태기간완료된것을 신청하는  check (li hui)-----------------------------
				String upmu_type = "01";
				String flag = rfc.check1(PERNR, box.getString("WORK_DATE"),upmu_type);

				//**********  결재라인, 결재 헤더 정보 조회 *******************
                getApprovalInfo(req, PERNR);
				//[CSR ID:3303691]  사후신청방지 로직추가 START
				checkGlobalRfc.check2(req, PERNR,  box.getString("WORK_DATE"),  box.getString("BEGUZ"),  UPMU_TYPE,  "" );
				String dateCheckFlag = checkGlobalRfc.getReturn().MSGTY;
				//[CSR ID:3303691]  사후신청방지 로직추가 END
				Logger.debug.println("#####	flag	:	[ " + flag + " ]");
				String msg = ENDZT + "," + BEGZT + "," + ZMODN + "," + FTKLA + "," + flag + "," + dateCheckFlag;
				res.getWriter().print(msg);
				return;


				/*
				 * Vector D01OTData_vt = new Vector(); D01OTData data = new
				 * D01OTData();
				 *
				 * box.copyToEntity(data); data.PERNR = PERNR;
				 * DataUtil.fixNull(data);
				 *
				 * D01OTData_vt.addElement(data); //정보를 클라이언트로 되돌린다.
				 *
				 * D01OTCheckRFC func = new D01OTCheckRFC(); Vector
				 * D01OTCheck_vt = func.check( PERNR, data.WORK_DATE,
				 * data.WORK_DATE, data.BEGUZ, data.ENDUZ );
				 * Logger.debug.println(this, "D01OTCheck_vt : " +
				 * D01OTCheck_vt); // 2002.07.04. 신청시간이 근무일정과 중복되었을경우 R3에 초과근무
				 * 신청 로직을 적용하기위해서 수정함. String message = "";
				 *
				 * D01OTCheckData checkData =
				 * (D01OTCheckData)D01OTCheck_vt.get(0);
				 *
				 * if( !checkData.ERRORTEXTS.equals("") &&
				 * checkData.STDAZ.equals("0") ) { //에러메시지가 있고, 한계결정을 할 수 없는 경우
				 * message = "근무일정과 중복되었습니다."; } else if(
				 * checkData.ERRORTEXTS.equals("") ) { //에러메시지가 없고, 정상적이거나 한계결정을
				 * 한 경우. if( checkData.BEGUZ.equals(data.BEGUZ) &&
				 * checkData.ENDUZ.equals(data.ENDUZ) ) { message = ""; } else {
				 * message = "근무일정과 중복되어 신청시간을 정정하였습니다."; data.BEGUZ =
				 * checkData.BEGUZ; //한계결정한 시간정보로 재설정해준다. data.ENDUZ =
				 * checkData.ENDUZ; data.STDAZ = checkData.STDAZ; } } //
				 * 2002.07.04. 신청시간이 근무일정과 중복되었을경우 R3에 초과근무 신청 로직을 적용하기위해서 수정함.
				 *
				 * //결재정보를 되돌린다. Vector AppLineData_vt = new Vector(); int
				 * rowcount = box.getInt("RowCount"); for( int i = 0; i <
				 * rowcount; i++) { AppLineData appLine = new AppLineData();
				 * String idx = Integer.toString(i); // 여러행 자료 입력(Web)
				 * box.copyToEntity(appLine ,i);
				 *
				 * AppLineData_vt.addElement(appLine); }
				 *
				 * D16OTHDDupCheckRFC func2 = new D16OTHDDupCheckRFC(); Vector
				 * OTHDDupCheckData_vt = func2.getCheckList( PERNR, UPMU_TYPE );
				 * req.setAttribute("message", message);
				 * req.setAttribute("jobid", jobid);
				 * req.setAttribute("D01OTData_vt", D01OTData_vt);
				 * req.setAttribute("AppLineData_vt", AppLineData_vt);
				 * req.setAttribute("OTHDDupCheckData_vt", OTHDDupCheckData_vt);
				 *
				 * dest = WebUtil.JspURL+"D/D01OT/D01OTBuild.jsp";
				 */


			} else if (jobid.equals("create")) {

			    dest = requestApproval(req, box,  D01OTData.class, new RequestFunction<D01OTData>() {
			                        public String porcess(D01OTData data, Vector<ApprovalLineData> approvalLine) throws GeneralException {

//				NumberGetNextRFC seqn = new NumberGetNextRFC();
				D01OTRFC rfc = new D01OTRFC();

//				Vector AppLineData_vt = new Vector();
				Vector D01OTData_vt = new Vector();

				box.copyToEntity(data);
				data.PERNR		= PERNR;
				data.ZPERNR	= user.empNo; 						// 신청자 사번(대리신청, 본인 신청)
				data.PERNR_D	= PERNR;
				if(data.ZREASON==null	|| data.ZREASON.equals("") ){
					data.ZREASON	= data.REASON;
				}
				data.UNAME	= user.empNo; 						// 신청자 사번(대리신청, 본인 신청)
				data.AEDTM	= DataUtil.getCurrentDate(); 		// 변경일(현재날짜)

				DataUtil.fixNull(data);

				// check whether overtime overlaps leave time
				doWithData(data);
				{
					D01OTCheck1RFC chk = new D01OTCheck1RFC();

					chk.check(PERNR, data.WORK_DATE, data.BEGUZ,data.ENDUZ);
					String msg2	= chk.getReturn().MSGTY;
					String msg	= "";
					String url	= "";

					if (!chk.getReturn().isSuccess()) {
						req.setAttribute("msg", msg);
						req.setAttribute("msg2", chk.getReturn().MSGTX);
//						req.setAttribute("url", url);

						//dest = WebUtil.JspURL + "common/msg.jsp";

						//printJspPage(req, res, dest);
						throw new GeneralException(rfc.getReturn().MSGTX);
					}
					//[CSR ID:3303691]  사후신청방지 로직추가 START

					checkGlobalRfc.check2(req, PERNR,   data.WORK_DATE,  data.BEGUZ,  UPMU_TYPE,  "" );
					if ("E".equals(checkGlobalRfc.getReturn().MSGTY)) {
						throw new GeneralException(g.getMessage("MSG.D.D01.0106"));//어제 일자부터 신청가능합니다.
					}
					//[CSR ID:3303691]  사후신청방지 로직추가 END

					//2017-04-03 김은하  [CSR ID:3340999]  대만 당월근태기간동안 46시간 제한 START
					checkGlobalRfc.checkOvertimeTp46Hours(req, PERNR,  "R","",  data.WORK_DATE,  data.STDAZ );
					if ("E".equals(checkGlobalRfc.getReturn().MSGTY)) {
						throw new GeneralException(g.getMessage("MSG.D.D01.0105"));//귀하는 규정된 근태기간 내 OT 누적 신청시수가  46시간 초과하였으니 확인하시기 바랍니다.
					}
					//2017-04-03 김은하  [CSR ID:3340999]  대만 당월근태기간동안 46시간 제한 END

				    //[CSR ID:3359686]   남경 결재 5일제어 START
	                checkGlobalRfc.checkApprovalPeriod(req, PERNR, "R",data.WORK_DATE,   UPMU_TYPE,  "" );
	                if ("E".equals(checkGlobalRfc.getReturn().MSGTY)) {
	                	req.setAttribute("alertMsg2",  g.getMessage("MSG.D.D01.0107"));

					}
	                 //[CSR ID:3359686]   남경 결재 5일제어 end



				}
				// check end

				D01OTData_vt.addElement(data);
				Logger.debug.println(this, data.toString());

				// D01OTCheckRFC func = new D01OTCheckRFC();
				// Vector D01OTCheck_vt = func.check(PERNR, data.WORK_DATE);

				// 2002.07.04. 신청시간이 근무일정과 중복되었을경우 R3에 초과근무 신청 로직을 적용하기위해서 수정함.
				String message = "";
				// D01OTCheckData checkData = (D01OTCheckData) D01OTCheck_vt
				// .get(0);

				// if (!checkData.ERRORTEXTS.equals("")
				// && checkData.STDAZ.equals("0")) { // 에러메시지가 있고, 한계결정을
				// // 할 수 없는 경우
				// message = "근무일정과 중복되었습니다. 다시 신청해주십시요.";
				// } else if (checkData.ERRORTEXTS.equals("")) { // 에러메시지가 없고,
				// // 정상적이거나 한계결정을
				// // 한 경우.
				// if (checkData.BEGUZ.equals(data.BEGUZ)
				// && checkData.ENDUZ.equals(data.ENDUZ)) {
				// message = "";
				// } else {
				// message = "근무일정과 중복되어 신청시간을 정정하였습니다.";
				// data.BEGUZ = checkData.BEGUZ; // 한계결정한 시간정보로 재설정해준다.
				// data.ENDUZ = checkData.ENDUZ;
				// data.STDAZ = checkData.STDAZ;
				// }
				// }
				// 2002.07.04. 신청시간이 근무일정과 중복되었을경우 R3에 초과근무 신청 로직을 적용하기위해서 수정함.

				if (!message.equals("")) { // 메세지가 있는경우

					D16OTHDDupCheckRFC func2 = new D16OTHDDupCheckRFC();
					Vector OTHDDupCheckData_vt = func2.getCheckList(PERNR,UPMU_TYPE, user.area);

					Logger.debug.println(this, "#####	원래패이지로");
					req.setAttribute("jobid", jobid);
					req.setAttribute("message", message);
					req.setAttribute("D01OTData_vt", D01OTData_vt);
					req.setAttribute("OTHDDupCheckData_vt", OTHDDupCheckData_vt);
//                    getApprovalInfo(req, PERNR);    //<-- 반드시 추가

                    req.setAttribute("approvalLine", approvalLine); //변경된 결재라인

					printJspPage(req, res, WebUtil.JspURL+"D/D01OT/D01OTBuild_Global.jsp");
                    req.setAttribute("committed", "Y");
					return null;

				} else { // 저장

					//String ainf_seqn = seqn.getNumberGetNext();
					String date = DataUtil.getCurrentDate();
					data.PERNR = PERNR;
					Logger.debug.println(this, "#####	저장으로");
                    rfc.setRequestInput(user.empNo, UPMU_TYPE);
					String ainf_seqn = rfc.build(PERNR, D01OTData_vt, box, req);
					 if(!rfc.getReturn().isSuccess() || ainf_seqn==null) {
                         throw new GeneralException(rfc.getReturn().MSGTX);
                     };

/*
					int rowcount = box.getInt("RowCount");
					for (int i = 0; i < rowcount; i++) {
						AppLineData appLine = new AppLineData();
						String idx = Integer.toString(i);

						// 여러행 자료 입력(Web)
						box.copyToEntity(appLine, i);
					}

					Logger.debug.println(this, "#####	결제로직끝");
					Logger.debug.println(this, D01OTData_vt.toString());
					Logger.debug.println(this, "#####	결제라인	:	" + AppLineData_vt.toString());

					con = DBUtil.getTransaction();

					AppLineDB appDB = new AppLineDB(con);
					appDB.create(AppLineData_vt);

					rfc.build(ainf_seqn, PERNR, D01OTData_vt);
					con.commit();

					// 메일 수신자 사람 ,
					AppLineData appLine = (AppLineData) AppLineData_vt.get(0);

					Properties ptMailBody = new Properties();
					ptMailBody.setProperty("SServer", user.SServer); 						// ElOffice 접속 서버
					ptMailBody.setProperty("from_empNo", user.empNo); 					// 멜 발송자 사번
					ptMailBody.setProperty("to_empNo", appLine.APPL_APPU_NUMB); 	// 멜수신자 사번
					ptMailBody.setProperty("ename", phonenumdata.E_ENAME); 		// (피)신청자명
					ptMailBody.setProperty("empno", phonenumdata.E_PERNR); 			// (피)신청자 사번
					ptMailBody.setProperty("UPMU_NAME", UPMU_NAME); 					// 문서 이름
					ptMailBody.setProperty("AINF_SEQN", ainf_seqn); 						// 신청서 순번

					// 멜 제목
					StringBuffer sbSubject = new StringBuffer(512);

					sbSubject.append("[" + ptMailBody.getProperty("UPMU_NAME") + "] ");
					sbSubject.append(ptMailBody.getProperty("ename") + " applied.");

					ptMailBody.setProperty("subject", sbSubject.toString());
					//Logger.debug.println(this, "D01OTBuildSV 메일 ptMailBody : " + ptMailBody.toString());

					String msg = "msg001";
					String msg2 = "";
*/
					/*
					MailSendToEloffic maTe = new MailSendToEloffic(ptMailBody);

					if (!maTe.process()) {
						msg2 = maTe.getMessage();
					} // end if
					*/
/*
					try {
						DraftDocForEloffice ddfe = new DraftDocForEloffice();

						ElofficInterfaceData eof = ddfe.makeDocContents(
								ainf_seqn, user.SServer, ptMailBody
										.getProperty("UPMU_NAME"));

						Vector vcElofficInterfaceData = new Vector();
						vcElofficInterfaceData.add(eof);
						req.setAttribute("vcElofficInterfaceData",
								vcElofficInterfaceData);
						dest = WebUtil.JspURL + "common/ElOfficeInterface.jsp";
					} catch (Exception e) {
						dest = WebUtil.JspURL + "common/msg.jsp";
						msg2 = msg2 + "\\n" + " Eloffic Connection Failed.";
					} // end try
					req.setAttribute("msg", msg);
					req.setAttribute("msg2", msg2);
					String url = "location.href = '" + WebUtil.ServletURL
							+ "hris.D.D01OT.D01OTDetailSV?AINF_SEQN="
							+ ainf_seqn + "&PERNR=" + PERNR + "';";
					req.setAttribute("url", url);
*/
					return ainf_seqn;
				}
		      }
            });
			  //[CSR ID:3359686]   남경 결재 5일제어 START
			    if(req.getAttribute("alertMsg2")!=null) req.setAttribute("msg2", req.getAttribute("msg2").equals("")  ? req.getAttribute("alertMsg2"): req.getAttribute("msg2")+ "\\n" +req.getAttribute("alertMsg2"));
			  //[CSR ID:3359686]   남경 결재 5일제어 END

			} else {
                throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
			}
			Logger.debug.println(this, "#####	destributed = " + dest);
            if (req.getAttribute("committed").equals("N")){
            	printJspPage(req, res, dest);
            }

		} catch (Exception e) {
			throw new GeneralException(e);
		} finally {
//			DBUtil.close(con);
		}
	}

	public D01OTData doWithData(D01OTData data) {
		if (!data.BEGDA.equals("") && data.BEGDA.length()==10)
			data.BEGDA = data.BEGDA.substring(0, 4)
					+ data.BEGDA.substring(5, 7) + data.BEGDA.substring(8);
// 2016.09.26 pangmin G180 add begin
		if (!data.WORK_DATE.equals("") && data.WORK_DATE.length()==10)
			data.WORK_DATE = data.WORK_DATE.substring(0, 4)
					+ data.WORK_DATE.substring(5, 7)
					+ data.WORK_DATE.substring(8);
// 2016.09.26 pangmin G180 add begin

		data.BEGUZ = toTimeFormat(data.BEGUZ);
		data.ENDUZ = toTimeFormat(data.ENDUZ);
		data.PBEG1 = toTimeFormat(data.PBEG1);
		data.PEND1 = toTimeFormat(data.PEND1);
		data.PBEG2 = toTimeFormat(data.PBEG2);
		data.PEND2 = toTimeFormat(data.PEND2);
		if (data.PBEG1.equals("000000") && data.PEND1.equals("000000") || data.PBEG1.equals("00:00") && data.PEND1.equals("00:00") ) {
			data.PBEG1=null;
			data.PEND1=null;
		}
		if (data.PBEG2.equals("000000") && data.PEND2.equals("000000") || data.PBEG2.equals("00:00") && data.PEND2.equals("00:00") ) {
			data.PBEG2=null;
			data.PEND2=null;
		}
		return data;
	}

	public String toTimeFormat(String timeString) {
		String result = timeString;
		if (timeString.equals("") || timeString==null) return "";

		if (!timeString.equals("")&& timeString.length()==4)
			result = timeString.substring(0, 2) +timeString.substring(2)					+ "00";

		if (!timeString.equals("")&& timeString.length()==5)
			result = timeString.substring(0, 2) +timeString.substring(3)					+ "00";

		if (!timeString.equals("") && timeString.length()==8)
			result = timeString.substring(0, 2) + timeString.substring(3,5) + timeString.substring(6,8);

		return result;
	}
}