/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 급여계좌정보                                                */
/*   Program Name : 급여계좌 수정                                               */
/*   Program ID   : A14BankChangeSV                                             */
/*   Description  : 급여계좌를 수정할 수 있도록 하는 Class                      */
/*   Note         :                                                             */
/*   Creation     : 2002-01-08  김도신                                          */
/*   Update       : 2005-03-03  윤정현                                          */
/*                                                                              */
/********************************************************************************/

package servlet.hris.A.A14Bank;

import java.sql.Connection;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.common.Utils;
import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.db.DBUtil;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.WebUtil;

import hris.A.A14Bank.A14BankCodeData;
import hris.A.A14Bank.A14BankStockFeeData;
import hris.A.A14Bank.rfc.A14BankCodeRFC;
import hris.A.A14Bank.rfc.A14BankStockFeeRFC;
import hris.A.A14Bank.rfc.A14BankTypeRFC;
import hris.common.PersonData;
import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalHeader;
import hris.common.approval.ApprovalLineData;
import hris.common.rfc.PersonInfoRFC;
import hris.common.util.AppUtil;

public class A14BankChangeGlobalSV extends ApprovalBaseServlet {

	private String UPMU_TYPE = "03"; // 결재 업무타입(급여계좌)
    private static String UPMU_NAME = "급여계좌 ";

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
			req.setCharacterEncoding("utf-8");
			HttpSession session = req.getSession(false);

			final WebUserData user = (WebUserData) session.getAttribute("user");

			String dest = "";
			String jobid = "";

			String PERNR ="";
			final Box box = WebUtil.getBox(req);
			jobid = box.get("jobid");
			if (jobid.equals("")) {
				jobid = "first";
			}

            PERNR =  getPERNR(box, user); //box.get("PERNR");		//-- 아래 가져오는부분 또 있음.
            if( PERNR.equals("") ){
            	PERNR = user.empNo;
            }

            final String bankflag = box.get("BNKSA","01");
			Logger.debug.println(this, "[jobid] = " + jobid + " [user] : "
					+ user.toString());

			A14BankStockFeeRFC rfc = new A14BankStockFeeRFC();


            String I_APGUB = (String) req.getAttribute("I_APGUB");  //어느 페이지에서 왔나? '1' : 결재할 문서 , '2' : 결재중 문서 , '3' : 결재완료 문서

            A14BankCodeRFC rfc_bank1 = new A14BankCodeRFC();
            Vector a14BankValueData_vt = rfc_bank1.getBankValue(PERNR);

			Vector a14BankStockFeeData_vt = null;
			String ainf_seqn = box.get("AINF_SEQN");

			// 현재 수정할 레코드..
			 rfc.setDetailInput(user.empNo, I_APGUB, ainf_seqn);
			a14BankStockFeeData_vt = rfc.getBankStockFee(PERNR, ainf_seqn, bankflag);
			PERNR = rfc.getApprovalHeader().PERNR; //box.get("PERNR");

			Logger.debug.println(this, "급여계좌 상세조회 : "		+ a14BankStockFeeData_vt.toString());

			req.setAttribute("a14BankStockFeeData_vt", a14BankStockFeeData_vt);

			final A14BankStockFeeData firstData = (A14BankStockFeeData) a14BankStockFeeData_vt.get(0);

			// 대리 신청 추가
//			PhoneNumRFC numfunc = new PhoneNumRFC();
//			PhoneNumData phonenumdata;
//			phonenumdata = (PhoneNumData) numfunc.getPhoneNum(firstData.PERNR);
//			req.setAttribute("PhoneNumData", phonenumdata);

            PersonInfoRFC numfunc = new PersonInfoRFC();
            final PersonData phonenumdata    = (PersonData)numfunc.getPersonInfo(PERNR);
            req.setAttribute("PersonData" , phonenumdata );

            req.setAttribute("isUpdate", true); //[결재]등록 수정 여부   <- 수정쪽에는 반드시 필요함

            // 현재 수정할 레코드..
			if (jobid.equals("first")) { // 제일처음 신청 화면에 들어온경우.

				Vector AppLineData_vt = null;

				// 급여계좌 리스트를 구성한다.
				A14BankCodeRFC rfc_bank = new A14BankCodeRFC();
				A14BankCodeData data = new A14BankCodeData();
				Vector a14BankCodeData_vt = rfc_bank.getBankCode(firstData.PERNR);
				//20151116 start
				A14BankTypeRFC rfc_type = new A14BankTypeRFC();
				Vector a14BankTypeData_vt = rfc_type.getTypeCode(firstData.PERNR);
				//20151116 end
				req.setAttribute("a14BankValueData_vt", a14BankValueData_vt);
				if (a14BankCodeData_vt.size() == 0) { // 수정이기때문에 이 조건을 만족하기는
														// 힘들겠다.
					String msg = "개인의 급여계좌 정보가 존재하지 않습니다.";
					String url = "history.back();";
					req.setAttribute("msg", msg);
					req.setAttribute("url", url);
					dest = WebUtil.JspURL + "common/msg.jsp";
				} else {
					// 급여계좌 리스트
					req.setAttribute("a14BankCodeData_vt", a14BankCodeData_vt);

					//20151116 start
					req.setAttribute("a14BankTypeData_vt", a14BankTypeData_vt);
					//20151116 end

					// 결재자리스트
//					AppLineData_vt = AppUtil.getAppChangeVt(ainf_seqn);
//					req.setAttribute("AppLineData_vt", AppLineData_vt);

//					dest = WebUtil.JspURL + "A/A14Bank/A14BankChange_Global.jsp";
                    detailApporval(req, res, rfc);
					dest = WebUtil.JspURL + "A/A14Bank/A14BankBuild_Global.jsp";
				}

			} else if (jobid.equals("change")) {

                /* 실제 수정 부분 */
                dest = changeApproval(req, box, A14BankStockFeeData.class, rfc, new ChangeFunction<A14BankStockFeeData>(){

                    public String porcess(A14BankStockFeeData inputData, ApprovalHeader approvalHeader, Vector<ApprovalLineData> approvalLineDatas)
                			throws GeneralException {
                        /* 결재 신청 RFC 호출 */
                    	A14BankStockFeeRFC changeRFC = new A14BankStockFeeRFC();
                        changeRFC.setChangeInput(user.empNo, UPMU_TYPE, approvalHeader.AINF_SEQN);

						box.copyToEntity(inputData);
                        Logger.debug("-------- AINF_SEQN " + inputData.AINF_SEQN);
						if (user.companyCode.equals("G100") && phonenumdata.E_PERSG.equals("A")) {
							if (box.get("STEXT").equals(g.getMessage("MSG.A.A03.0009"))) {
								inputData.BNKSA = "0";
								inputData.VORNA = box.get("VORNA1");// first
																	// name
								inputData.NACHN = box.get("NACHN1");// last name
							} else {
								inputData.BNKSA = "7";
								inputData.EMFTX = box.get("NACHN1");// full name
							}
						} else {
							inputData.BNKSA = box.get("BNKSA");
						}

                        changeRFC.changeGlobal(firstData.PERNR, inputData.AINF_SEQN, bankflag, (inputData));

                        if(!changeRFC.getReturn().isSuccess()) {
                            req.setAttribute("msg", "수정에 실패 하였습니다.\n" + changeRFC.getReturn().MSGTX);   //실패 메세지 처리 - 임시
                            return null;
                        }

                        return inputData.AINF_SEQN;
                        /* 개발자 작성 부분 끝 */
                    }
                });

				/*
				A14BankStockFeeData a14BankStockFeeData = new A14BankStockFeeData();
				Vector AppLineData_vt = new Vector();

				// 급여계좌 수정..
				a14BankStockFeeData.AINF_SEQN = ainf_seqn; // 결재정보 일련번호
				a14BankStockFeeData.PERNR = firstData.PERNR; // 사원번호
				a14BankStockFeeData.BEGDA = box.get("BEGDA"); // 신청일
				a14BankStockFeeData.AINF_SEQN = ainf_seqn; // 결재정보 일련번호

//				20151117
				if(user.companyCode.equals("G100")&&phonenumdata.E_PERSG.equals("A")){
					if(box.get("STEXT").equals("工资账号")||box.get("BNKSA").equals("工资账号")){
						a14BankStockFeeData.BNKSA = "0";
					}else{
						a14BankStockFeeData.BNKSA = "7";
					}
				}else{
					a14BankStockFeeData.BNKSA = box.get("BNKSA");
				}
//				a14BankStockFeeData.BNKSA = box.get("BNKSA"); // 은행/증권
//				20151117 end
				a14BankStockFeeData.ZBANKL = box.get("ZBANKL"); // 회사
				a14BankStockFeeData.ZBANKN = box.get("ZBANKN"); // 은행/증권 // 회사명
				a14BankStockFeeData.ZBKREF = box.get("ZBKREF"); // 은행/증권 // 회사명

				a14BankStockFeeData.STATE1 = box.get("STATE1"); // 회사
				a14BankStockFeeData.BRANCH = box.get("BRANCH"); // 은행/증권 // 회사명
				a14BankStockFeeData.ZBANKA = (box.get("ZBANKA")); // 은행/증권 계좌
				a14BankStockFeeData.ZPERNR = user.empNo; // 신청자 사번 설정(대리신청
				bankflag = box.get("BNKSA");
				//20151207 bankcard start
				a14BankStockFeeData.VORNA= box.get("VORNA");//first name
				a14BankStockFeeData.NACHN = box.get("NACHN");//last name
				a14BankStockFeeData.EMFTX = box.get("EMFTX");//full name
//				20151207 bankcard end
				Logger.debug.println(this, "급여계좌 수정 : "
						+ a14BankStockFeeData.toString());

				// 결재정보 저장..
				int rowcount = box.getInt("RowCount");
				for (int i = 0; i < rowcount; i++) {
					AppLineData appLine = new AppLineData();
					String idx = Integer.toString(i);

					// 같은 이름으로 여러행 받을때
					box.copyToEntity(appLine, i);

					appLine.APPL_MANDT = user.clientNo;
					appLine.APPL_BUKRS = user.companyCode;
					appLine.APPL_PERNR = firstData.PERNR;
					appLine.APPL_BEGDA = a14BankStockFeeData.BEGDA;
					appLine.APPL_AINF_SEQN = ainf_seqn;
					appLine.APPL_UPMU_TYPE = UPMU_TYPE;

					AppLineData_vt.addElement(appLine);
				}
				Logger.debug.println(this, AppLineData_vt.toString());

				con = DBUtil.getTransaction();
				AppLineDB appDB = new AppLineDB(con);

				String msg;
				String msg2 = null;

				if (appDB.canUpdate((AppLineData) AppLineData_vt.get(0))) {

					// 기존 결재자 리스트
					Vector orgAppLineData_vt = AppUtil
							.getAppChangeVt(ainf_seqn);

					appDB.change(AppLineData_vt);
					msg = rfc.changeGlobal(firstData.PERNR, ainf_seqn, bankflag,
							a14BankStockFeeData);
					con.commit();

					// msg = "msg002";

					AppLineData oldAppLine = (AppLineData) orgAppLineData_vt
							.get(0);
					AppLineData newAppLine = (AppLineData) AppLineData_vt
							.get(0);

					Logger.debug.println(this, oldAppLine);
					Logger.debug.println(this, newAppLine);

					if (!newAppLine.APPL_APPU_NUMB
							.equals(oldAppLine.APPL_PERNR)) {

						// 결재자 변경시 멜 보내기 ,ElOffice 인터 페이스
						phonenumdata = (PhoneNumData) numfunc.getPhoneNum(firstData.PERNR);

						// 이메일 보내기
						Properties ptMailBody = new Properties();
						ptMailBody.setProperty("SServer", user.SServer); // ElOffice
																			// 접속
																			// 서버
						ptMailBody.setProperty("from_empNo", user.empNo); // 멜
																			// 발송자
																			// 사번
						ptMailBody.setProperty("to_empNo",
								oldAppLine.APPL_PERNR); // 멜 수신자 사번

						ptMailBody.setProperty("ename", phonenumdata.E_ENAME); // (피)신청자명
						ptMailBody.setProperty("empno", phonenumdata.E_PERNR); // (피)신청자
																				// 사번

						ptMailBody.setProperty("UPMU_NAME", "Bank Account Change"); // 문서 이름
						ptMailBody.setProperty("AINF_SEQN", ainf_seqn); // 신청서
																		// 순번

						// 멜 제목
						StringBuffer sbSubject = new StringBuffer(512);

						sbSubject.append("["
								+ ptMailBody.getProperty("UPMU_NAME") + "] ");
						sbSubject.append(ptMailBody.getProperty("ename")
								+ " deleted an application of " + ptMailBody.getProperty("UPMU_NAME") + ".");
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
						sbSubject.append("["
								+ ptMailBody.getProperty("UPMU_NAME") + "] ");
						sbSubject.append(ptMailBody.getProperty("ename")
								+ " applied.");

						ptMailBody.setProperty("subject", sbSubject.toString());
						ptMailBody.remove("FileName");
						ptMailBody.setProperty("to_empNo",
								newAppLine.APPL_APPU_NUMB);

						/*
						maTe = new MailSendToEloffic(ptMailBody);

						// 신규 결재자 멜 전송
						if (!maTe.process()) {
							msg2 = msg2 + " \\n 신청 " + maTe.getMessage();
						} // end if
						*/
/*
						// ElOffice 인터페이스
						try {
							DraftDocForEloffice_Global ddfe = new DraftDocForEloffice_Global();
							ElofficInterfaceData_Global eof = ddfe.makeDocForChange(
									ainf_seqn, user.SServer, ptMailBody
											.getProperty("UPMU_NAME"),
									oldAppLine.APPL_PERNR);
							Vector vcElofficInterfaceData = new Vector();
							vcElofficInterfaceData.add(eof);
							req.setAttribute("vcElofficInterfaceData",
									vcElofficInterfaceData);
							dest = WebUtil.JspURL
									+ "common/ElOfficeInterface_Global.jsp";
						} catch (Exception e) {
							dest = WebUtil.JspURL + "common/msg.jsp";
							msg2 = msg2 + "\\n" + " Eloffic Connection Failed.";
						} // end try
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
 */

			} else {
                throw new BusinessException(g.getMessage("MSG.COMMON.0016"));//내부명령(jobid)이 올바르지 않습니다.
			}
			Logger.debug.println(this, "destributed = " + dest);
			printJspPage(req, res, dest);

		} catch (Exception e) {
			throw new GeneralException(e);
		} finally {
			DBUtil.close(con);
		}
	}
}
