/********************************************************************************/
/*	  System Name  	: g-HR
/*   1Depth Name		: Application
/*   2Depth Name  	: Time Management
/*   Program Name 	: Overtime
/*   Program ID   		: D01OTChangeSV
/*   Description  		: 초과근무를 수정 할 수 있도록 하는 Class
/*   Note         		:
/*   Creation     		: 2002-01-21 박영락
/*   Update       		: 2005-03-07 윤정현
/*   Update       		: 2007-09-12 huang peng xiao
 * 							: 2008-05-27 김정인 [C20080514_66017] @v1.0 PhoneNumData
 * 							: 2008-11-26 김정인 [C20081125_62978] @v1.1 DAGU법인 OT신청 누적시간 체크
 * 							: 2016-05-19 pangxiaolin C20160505_56532 @v1.2 G170法人增加申请加班可以选择加班理由修改
 *					        : 2017-04-03 김은하  [CSR ID:3340999]  대만 당월근태기간동안 46시간 제한*/
/*					        : 2017-04-19 김은하  [CSR ID:3359686]   남경 결재 5일제어*/
/********************************************************************************/

package servlet.hris.D.D01OT;

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
import hris.D.D01OT.rfc.D01OTCheck1RFC;
import hris.D.D01OT.rfc.D01OTCheckGlobalRFC;
import hris.D.D01OT.rfc.D01OTRFC;
import hris.D.D01OT.rfc.D01OTReasonRFC;
import hris.D.rfc.D16OTHDDupCheckRFC;
import hris.common.AppLineData;
import hris.common.PersonData;
import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalHeader;
import hris.common.approval.ApprovalLineData;
import hris.common.rfc.PersonInfoRFC;

public class D01OTChangeGlobalSV extends ApprovalBaseServlet {

	private String UPMU_TYPE = "01";		// 결재 업무타입(초과근무)

	private String UPMU_NAME = "Overtime";

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
			HttpSession session = req.getSession(false);

			final WebUserData user = (WebUserData) session.getAttribute("user");

			String dest	= "";
			String jobid	= "";

			final Box box = WebUtil.getBox(req);
			jobid = box.get("jobid", "first");
            String I_APGUB = (String) req.getAttribute("I_APGUB");  //어느 페이지에서 왔나? '1' : 결재할 문서 , '2' : 결재중 문서 , '3' : 결재완료 문서


			//Logger.debug.println(this, "#####	box	:	[ " + box.toString() + " ]");
			//Logger.debug.println(this, "#####	user	:	[ " + user.toString() + " ]");
			//Logger.debug.println(this, "#####	jobid	:	[ " + jobid + " ]	/	PERNR :	[ " + PERNR + " ]");

			Vector D01OTData_vt = null;

			final D01OTRFC rfc = new D01OTRFC();
			final String ainf_seqn = box.get("AINF_SEQN");
            // 현재 수정할 레코드..
            rfc.setDetailInput(user.empNo, I_APGUB, ainf_seqn); // 결재란설정

			D01OTData_vt = rfc.getDetail(ainf_seqn, user.empNo);
			final String PERNR = rfc.getApprovalHeader().PERNR; //box.get("PERNR", user.empNo);
 			final D01OTData firstData = (D01OTData) D01OTData_vt.get(0);



			// 대리 신청 추가
//			PhoneNumRFC numfunc = new PhoneNumRFC();
//			PhoneNumData phonenumdata;
//			phonenumdata = (PhoneNumData) numfunc.getPhoneNum(firstData.PERNR);
//			req.setAttribute("PhoneNumData", phonenumdata);

            PersonInfoRFC numfunc = new PersonInfoRFC();
            final PersonData phonenumdata    = (PersonData)numfunc.getPersonInfo(firstData.PERNR);
            req.setAttribute("PersonData" , phonenumdata );

			req.setAttribute("E_BUKRS", phonenumdata.E_BUKRS);
//			 2016-05-19 pangxiaolin C20160505_56532 @v1.9 G170法人增加申请加班可以选择加班理由修改 start

			D01OTReasonRFC rfc_reasontype = new D01OTReasonRFC();
			Vector d01OTReasonData_vt = rfc_reasontype.getTypeCode(PERNR);
			req.setAttribute("reasonCode", d01OTReasonData_vt);

//			 2016-05-19 pangxiaolin C20160505_56532 @v1.9 G170法人增加申请加班可以选择加班理由修改 end
			Logger.debug.println(this, "d01OTReasonData_vt" + d01OTReasonData_vt.toString());


			// 2016.09.26 pangmin G180节假日加班申请 add begin
			final D01OTCheckGlobalRFC checkrfc = new D01OTCheckGlobalRFC();
			Vector check_vt = checkrfc.check(PERNR, box.getString("WORK_DATE"));

			String ENDZT	= WebUtil.printTime(((D01OTCheckData) check_vt.get(0)).ENDZT);
			String BEGZT	= WebUtil.printTime(((D01OTCheckData) check_vt.get(0)).BEGZT);
			String ZMODN	= ((D01OTCheckData) check_vt.get(0)).ZMODN;
			String FTKLA	= ((D01OTCheckData) check_vt.get(0)).FTKLA;

			//-------- 근태기간완료된것을 신청하는  check (li hui)----------------------
			String upmu_type = "01";	//---초과근무 업무타입
			String flag = checkrfc.check1(PERNR, box.getString("WORK_DATE"),upmu_type);

			Logger.debug.println("#####	flag	:	[ " + flag + " ]");
			String msg = ENDZT + "," + BEGZT + "," + ZMODN + "," + FTKLA + "," + flag;
			res.getWriter().print(msg);
			req.setAttribute("ENDZT", ENDZT);
			req.setAttribute("BEGZT", BEGZT);
			req.setAttribute("ZMODN", ZMODN);
			req.setAttribute("FTKLA", FTKLA);
			req.setAttribute("flag", flag);

			// 2016.09.26 pangmin G180节假日加班申请 add end
			if (jobid.equals("first")) {


				req.setAttribute("jobid", jobid);
				req.setAttribute("D01OTData_vt", D01OTData_vt);
                req.setAttribute("isUpdate", true); //[결재]등록 수정 여부   <- 수정쪽에는 반드시 필요함

				D16OTHDDupCheckRFC d16OTHDDupCheckRFC = new D16OTHDDupCheckRFC();
				Vector OTHDDupCheckData_vt = null;
				OTHDDupCheckData_vt = d16OTHDDupCheckRFC.getCheckList(firstData.PERNR, UPMU_TYPE, user.area);

				req.setAttribute("OTHDDupCheckData_vt", OTHDDupCheckData_vt);
//				Logger.debug.println(this, "OTHDDupCheckData_vt : " + OTHDDupCheckData_vt.toString());
//				 2016-05-19 pangxiaolin C20160505_56532 @v2.2 G170法人增加申请加班可以选择加班理由修改 start
				req.setAttribute("d01OTReasonData_vt", d01OTReasonData_vt);
//				 2016-05-19 pangxiaolin C20160505_56532 @v2.2 G170法人增加申请加班可以选择加班理由修改 end

                detailApporval(req, res, rfc);
				dest = WebUtil.JspURL + "D/D01OT/D01OTBuild_Global.jsp";

			} else if (jobid.equals("check")) {

				D01OTData_vt = new Vector();
				D01OTData data = new D01OTData();

				box.copyToEntity(data);
				DataUtil.fixNull(data);

				D01OTData_vt.addElement(data); // 정보를 클라이언트로 되돌린다.
				String message = "";

				// D01OTCheckRFC func = new D01OTCheckRFC();
				// Vector D01OTCheck_vt = func.check( firstData.PERNR,
				// data.WORK_DATE );
				//
				// // 2002.07.04. 신청시간이 근무일정과 중복되었을경우 R3에 초과근무 신청 로직을 적용하기위해서
				// 수정함.
				// String message = "";
				//
				// D01OTCheckData checkData =
				// (D01OTCheckData)D01OTCheck_vt.get(0);
				//
				// if( !checkData.ERRORTEXTS.equals("") &&
				// checkData.STDAZ.equals("0") ) { //에러메시지가 있고, 한계결정을 할 수 없는 경우
				// message = "근무일정과 중복되었습니다. 다시 신청해주십시요.";
				// } else if( checkData.ERRORTEXTS.equals("") ) { //에러메시지가 없고,
				// 정상적이거나 한계결정을 한 경우.
				// if( checkData.BEGUZ.equals(data.BEGUZ) &&
				// checkData.ENDUZ.equals(data.ENDUZ) ) {
				// message = "";
				// } else {
				// message = "근무일정과 중복되어 신청시간을 정정하였습니다.";
				// data.BEGUZ = checkData.BEGUZ; //한계결정한 시간정보로 재설정해준다.
				// data.ENDUZ = checkData.ENDUZ;
				// data.STDAZ = checkData.STDAZ;
				// }
				// }
				// 2002.07.04. 신청시간이 근무일정과 중복되었을경우 R3에 초과근무 신청 로직을 적용하기위해서 수정함.

				// 결재정보를 되돌린다.
				Vector AppLineData_vt = new Vector();
				int rowcount = box.getInt("RowCount");
				for (int i = 0; i < rowcount; i++) {
					AppLineData appLine = new AppLineData();
					String idx = Integer.toString(i);

					// 같은 이름으로 여러행 받을때
					box.copyToEntity(appLine, i);

					AppLineData_vt.addElement(appLine);
				}

				D16OTHDDupCheckRFC func2 = new D16OTHDDupCheckRFC();
				Vector OTHDDupCheckData_vt = func2.getCheckList(firstData.PERNR, UPMU_TYPE, user.area);

				req.setAttribute("message", message);
				req.setAttribute("jobid", jobid);
				req.setAttribute("D01OTData_vt", D01OTData_vt);
				req.setAttribute("AppLineData_vt", AppLineData_vt);
				req.setAttribute("OTHDDupCheckData_vt", OTHDDupCheckData_vt);

				dest = WebUtil.JspURL + "D/D01OT/D01OTChange.jsp";

			} else if (jobid.equals("change")) {

	           	/**
	           	 * @$ 웹보안진단
	           	 * 해당 사번이 조직을 조회 할수 있는지 체크
	           	if(!checkBelongGroup( req, res, user.i_dept, "")){
	           		return;
	           	}
	           	 */

                // 실제 수정 부분 /
                dest = changeApproval(req, box, D01OTData.class, rfc, new ChangeFunction<D01OTData>(){

                    public String porcess(D01OTData inputData, ApprovalHeader approvalHeader,
                    		Vector<ApprovalLineData> approvalLineDatas)
                			throws GeneralException {

                        box.copyToEntity(inputData);
        				DataUtil.fixNull(inputData);

                        inputData.PERNR  = PERNR;
                        inputData.ZPERNR = user.empNo;              // 신청자 사번(대리신청, 본인 신청)
                        inputData.UNAME  = user.empNo;              // 신청자 사번(대리신청, 본인 신청)
                        if(inputData.REASON==null){
                        	inputData.REASON = inputData.ZREASON;
                        }
                        inputData.AEDTM  = DataUtil.getCurrentDate();  // 변경일(현재날짜)

        				//2016-05-19 pangxiaolin C20160505_56532 @v1.2 G170法人增加申请加班可以选择加班理由修改 start
        				if((user.companyCode.equals("G170") && inputData.REASON.equals("OTHERS"))||(user.companyCode.equals("G170") &&inputData.REASON.equals(""))){
        					inputData.ZREASON = box.getString("REASON1");
        				}else{
        					inputData.ZREASON	= inputData.REASON;
        				}
//        				data.ZREASON		= box.getString("REASON");
//        				2016-05-19 pangxiaolin C20160505_56532 @v1.2 G170法人增加申请加班可以选择加班理由修改 end
        				inputData.UNAME		= user.empNo; 						// 신청자 사번(대리신청, 본인 신청)
        				inputData.AEDTM		= DataUtil.getCurrentDate(); 		// 변경일(현재날짜)
                        detailApporval(req, res, rfc);
                        req.setAttribute("isUpdate", true); //[결재]등록 수정 여부   <- 수정쪽에는 반드시 필요함

        				// check whether overtime overlaps leave time
        				doWithData(inputData);
        				{
        					D01OTCheck1RFC chk = new D01OTCheck1RFC();
        					chk.check(PERNR, inputData.WORK_DATE, inputData.BEGUZ, inputData.ENDUZ);
        					String msg2	= chk.getReturn().MSGTX;

        					String msg	= "";
        					String url	= "";

        					if (msg2.equals("E")) {

        						req.setAttribute("msg", msg);
        						req.setAttribute("msg2", msg2.substring(9));
        						return null;
        					}

        					//2017-04-03 김은하  [CSR ID:3340999]  대만 당월근태기간동안 46시간 제한 START
        					checkrfc.checkOvertimeTp46Hours(req, PERNR,  "M",inputData.AINF_SEQN,  inputData.WORK_DATE,  inputData.STDAZ );
        					if ("E".equals(checkrfc.getReturn().MSGTY)) {
        						throw new GeneralException(g.getMessage("MSG.D.D01.0105"));//귀하는 규정된 근태기간 내 OT 누적 신청시수가  46시간 초과하였으니 확인하시기 바랍니다.
        					}
        					//2017-04-03 김은하  [CSR ID:3340999]  대만 당월근태기간동안 46시간 제한 END

        				    //[CSR ID:3359686]   남경 결재 5일제어 START
        	                checkrfc.checkApprovalPeriod(req, PERNR, "R", inputData.WORK_DATE,   UPMU_TYPE,  "" );
        	                if ("E".equals(checkrfc.getReturn().MSGTY)) {
        	                	req.setAttribute("alertMsg2",  g.getMessage("MSG.D.D01.0107"));
        					}
        	                 //[CSR ID:3359686]   남경 결재 5일제어 end
        				}
        				// check end

                        // * 결재 신청 RFC 호출 * /
                        rfc.setChangeInput(user.empNo, UPMU_TYPE, approvalHeader.AINF_SEQN);

                        Logger.debug("-------- AINF_SEQN " + inputData.AINF_SEQN);
                        Vector D01OTData_vt =  new Vector();
                        D01OTData_vt.addElement(inputData);
//                        rfc.build(firstData.PERNR, Utils.asVector(inputData), box, req);//ainf_seqn, bankflag,
                        rfc.change(ainf_seqn, inputData.PERNR, D01OTData_vt, box, req);

                        if(!rfc.getReturn().isSuccess()) {
                            req.setAttribute("msg", rfc.getReturn().MSGTX);   //실패 메세지 처리 - 임시
                            return null;
                        }

                        return inputData.AINF_SEQN;
                        // * 개발자 작성 부분 끝 */
                    }
                });

  			  //[CSR ID:3359686]   남경 결재 5일제어 START
                if(req.getAttribute("alertMsg2")!=null) req.setAttribute("msg2", req.getAttribute("msg2").equals("")  ? req.getAttribute("alertMsg2"): req.getAttribute("msg2")+ "\\n" +req.getAttribute("alertMsg2"));
			  //[CSR ID:3359686]   남경 결재 5일제어 END


/*
				Vector AppLineData_vt = new Vector();
				D01OTData data = new D01OTData();
				D01OTData_vt = new Vector();

				box.copyToEntity(data);
				DataUtil.fixNull(data);

				data.PERNR			= firstData.PERNR
				data.AINF_SEQN	= ainf_seqn;
				data.ZPERNR		= firstData.ZPERNR; 					// 신청자 사번(대리신청, 본인 신청)

				D01OTData_vt.addElement(data);
				String message = "";

				// D01OTCheckRFC func = new D01OTCheckRFC();
				// Vector D01OTCheck_vt = func.check( firstData.PERNR,
				// data.WORK_DATE );
				//
				// // 2002.07.04. 신청시간이 근무일정과 중복되었을경우 R3에 초과근무 신청 로직을 적용하기위해서
				// 수정함.
				// String message = "";
				//
				// D01OTCheckData checkData =
				// (D01OTCheckData)D01OTCheck_vt.get(0);
				//
				// if( !checkData.ERRORTEXTS.equals("") &&
				// checkData.STDAZ.equals("0") ) { //에러메시지가 있고, 한계결정을 할 수 없는 경우
				// message = "근무일정과 중복되었습니다. 다시 신청해주십시요.";
				// } else if( checkData.ERRORTEXTS.equals("") ) { //에러메시지가 없고,
				// 정상적이거나 한계결정을 한 경우.
				// if( checkData.BEGUZ.equals(data.BEGUZ) &&
				// checkData.ENDUZ.equals(data.ENDUZ) ) {
				// message = "";
				// } else {
				// message = "근무일정과 중복되어 신청시간을 정정하였습니다.";
				// data.BEGUZ = checkData.BEGUZ; //한계결정한 시간정보로 재설정해준다.
				// data.ENDUZ = checkData.ENDUZ;
				// data.STDAZ = checkData.STDAZ;
				// }
				// }
				// 2002.07.04. 신청시간이 근무일정과 중복되었을경우 R3에 초과근무 신청 로직을 적용하기위해서 수정함.

				if (!message.equals("")) { // 원페이지로

					int rowcount = box.getInt("RowCount");
					for (int i = 0; i < rowcount; i++) {
						AppLineData appLine = new AppLineData();
						String idx = Integer.toString(i);

						// 같은 이름으로 여러행 받을때
						box.copyToEntity(appLine, i);

						AppLineData_vt.addElement(appLine);

					}
					D16OTHDDupCheckRFC func2 = new D16OTHDDupCheckRFC();
					Vector OTHDDupCheckData_vt = func2.getCheckList(firstData.PERNR, UPMU_TYPE, user.area);

					Logger.debug.println(this, "#####	원래패이지로");
					req.setAttribute("jobid", jobid);
					req.setAttribute("message", message);
					req.setAttribute("D01OTData_vt", D01OTData_vt);
					req.setAttribute("AppLineData_vt", AppLineData_vt);
					req.setAttribute("OTHDDupCheckData_vt", OTHDDupCheckData_vt);

					dest = WebUtil.JspURL + "D/D01OT/D01OTChange.jsp";

				} else { // 수정

					Logger.debug.println(this, "#####	수정으로");
					int rowcount = box.getInt("RowCount");
					for (int i = 0; i < rowcount; i++) {
						AppLineData appLine = new AppLineData();
						String idx = Integer.toString(i);

						// 같은 이름으로 여러행 받을때
						box.copyToEntity(appLine, i);

						appLine.APPL_MANDT		= user.clientNo;
						appLine.APPL_BUKRS			= user.companyCode;
						appLine.APPL_PERNR			= firstData.PERNR;
						appLine.APPL_BEGDA			= data.BEGDA;
						appLine.APPL_AINF_SEQN	= ainf_seqn;
						appLine.APPL_UPMU_TYPE	= UPMU_TYPE;

						AppLineData_vt.addElement(appLine);
					}
					Logger.debug.println(this, AppLineData_vt.toString());

					con = DBUtil.getTransaction();
					AppLineDB appDB = new AppLineDB(con);

					String msg;
					String msg2 = null;

					if (appDB.canUpdate((AppLineData) AppLineData_vt.get(0))) {

						// 기존 결재자 리스트
						Vector orgAppLineData_vt = AppUtil.getAppChangeVt(ainf_seqn);

						appDB.change(AppLineData_vt);
						rfc.change(ainf_seqn, firstData.PERNR, D01OTData_vt);
						con.commit();

						msg = "msg002";

						AppLineData oldAppLine = (AppLineData) orgAppLineData_vt.get(0);
						AppLineData newAppLine = (AppLineData) AppLineData_vt.get(0);

						Logger.debug.println(this, oldAppLine);
						Logger.debug.println(this, newAppLine);

						if (!newAppLine.APPL_APPU_NUMB.equals(oldAppLine.APPL_PERNR)) {

							// 결재자 변경시 멜 보내기 ,ElOffice 인터 페이스
							phonenumdata = (PhoneNumData) numfunc.getPhoneNum(firstData.PERNR);

							// 이메일 보내기
							Properties ptMailBody = new Properties();
							ptMailBody.setProperty("SServer", user.SServer); 						// ElOffice 접속서버
							ptMailBody.setProperty("from_empNo", user.empNo); 					// 멜 발송자 사번
							ptMailBody.setProperty("to_empNo", oldAppLine.APPL_PERNR); 		// 멜 수신자 사번
							ptMailBody.setProperty("ename", phonenumdata.E_ENAME); 		// (피)신청자명
							ptMailBody.setProperty("empno", phonenumdata.E_PERNR); 			// (피)신청자 사번
							ptMailBody.setProperty("UPMU_NAME", "Overtime"); 					// 문서 이름
							ptMailBody.setProperty("AINF_SEQN", ainf_seqn); 						// 신청서순번

							// 멜 제목
							StringBuffer sbSubject = new StringBuffer(512);

							sbSubject.append("[" + ptMailBody.getProperty("UPMU_NAME") + "] ");
							sbSubject.append(ptMailBody.getProperty("ename")
											+ " deleted an application of "
											+ ptMailBody.getProperty("UPMU_NAME")
											+ ".");
							ptMailBody.setProperty("subject", sbSubject.toString());
							ptMailBody.setProperty("FileName", "NoticeMail5.html");
*/
							/*
							 MailSendToEloffic maTe = new MailSendToEloffic(ptMailBody);

							// 기존 결재자 멜 전송
							 if (!maTe.process()) {
								msg2 = msg2 + " 삭제 " + maTe.getMessage();
							} // end if
							*/
/*
							// 멜 제목
							sbSubject = new StringBuffer(512);

							sbSubject.append("[" + ptMailBody.getProperty("UPMU_NAME") + "] ");
							sbSubject.append(ptMailBody.getProperty("ename") + " applied.");

							ptMailBody.setProperty("subject", sbSubject.toString());
							ptMailBody.remove("FileName");
							ptMailBody.setProperty("to_empNo", newAppLine.APPL_APPU_NUMB);
*/
							/*
							maTe = new MailSendToEloffic(ptMailBody);

							// 신규 결재자 멜 전송
							if (!maTe.process()) {
								msg2 = msg2 + " \\n 신청 " + maTe.getMessage();
							} // end if
							*/

							// ElOffice 인터페이스
							/*
							try {
								DraftDocForEloffice ddfe = new DraftDocForEloffice();
								ElofficInterfaceData eof = ddfe
										.makeDocForChange(
												ainf_seqn,
												user.SServer,
												ptMailBody
														.getProperty("UPMU_NAME"),
												oldAppLine.APPL_PERNR);
								Vector vcElofficInterfaceData = new Vector();
								vcElofficInterfaceData.add(eof);
								req.setAttribute("vcElofficInterfaceData",
										vcElofficInterfaceData);
								dest = WebUtil.JspURL
										+ "common/ElOfficeInterface.jsp";
							} catch (Exception e) {
								dest = WebUtil.JspURL + "common/msg.jsp";
								msg2 = msg2 + "\\n"
										+ " Eloffic Connection Failed.";
							} // end try
							*/
                /*
						} else {
							msg = "msg002";
							dest = WebUtil.JspURL + "common/msg.jsp";
						} // end if
					} else {
						msg = "msg005";
						dest = WebUtil.JspURL + "common/msg.jsp";
					} // end if
					req.setAttribute("msg", msg);
					req.setAttribute("msg2", msg2);
				}
                 */
			} else {
				throw new BusinessException(g.getMessage("MSG.COMMON.0016"));//"내부명령(jobid)이 올바르지 않습니다.");
			}
			Logger.debug.println(this, "#####	destributed = " + dest);
			printJspPage(req, res, dest);

		} catch (Exception e) {
			throw new GeneralException(e);
		} finally {
//			DBUtil.close(con);
		}
	}

	private void doWithData(D01OTData data) {
		if (!data.BEGDA.equals("") && data.BEGDA.length()==10)
			data.BEGDA = data.BEGDA.substring(0, 4)
					+ data.BEGDA.substring(5, 7) + data.BEGDA.substring(8);
// 2016.09.26 pangmin G180节假日加班申请 add begin
		if (!data.WORK_DATE.equals("") && data.WORK_DATE.length()==10)
			data.WORK_DATE = data.WORK_DATE.substring(0, 4)
					+ data.WORK_DATE.substring(5, 7)
					+ data.WORK_DATE.substring(8);
// 2016.09.26 pangmin G180节假日加班申请 add begin
		if (!data.BEGUZ.equals("") && data.BEGUZ.length()==5)
			data.BEGUZ = data.BEGUZ.substring(0, 2) + data.BEGUZ.substring(3)					+ "00";
		if (!data.ENDUZ.equals("")&& data.ENDUZ.length()==5)
			data.ENDUZ = data.ENDUZ.substring(0, 2) + data.ENDUZ.substring(3)					+ "00";
		if (!data.PBEG1.equals("")&& data.PBEG1.length()==5)
			data.PBEG1 = data.PBEG1.substring(0, 2) + data.PBEG1.substring(3)					+ "00";
		if (!data.PEND1.equals("")&& data.PEND1.length()==5)
			data.PEND1 = data.PEND1.substring(0, 2) + data.PEND1.substring(3)					+ "00";
		if (!data.PBEG2.equals("")&& data.PBEG2.length()==5)
			data.PBEG2 = data.PBEG2.substring(0, 2) + data.PBEG2.substring(3)					+ "00";
		if (!data.PEND2.equals("")&& data.PEND2.length()==5)
			data.PEND2 = data.PEND2.substring(0, 2) + data.PEND2.substring(3)					+ "00";
	}
}
