/********************************************************************************/
/*   System Name  	: g-HR                                                         						
/*   1Depth Name  	: Application                                                 								
/*   2Depth Name  	: Time Management                                                        									
/*   Program Name 	: Leave                                                   									
/*   Program ID   		: D03VocationChangeEurpSV.java                                          					
/*   Description  		: 휴가 수정 할수 있도록 하는 Class [유럽용]                         					
/*   Note         		:                                                             							
/*   Creation     		: 2010-07-26 yji         
/*   Update				: 2010-10-08 jungin	@v1.0 미국법인 리턴페이지 추가. (자바스크립트를 위한 페이지 분리) 		
 * 							@PJ.멕시코 법인 Rollout 프로젝트 추가 관련(Area = MX("32")) 2018/02/09 rdcamel
 */
/********************************************************************************/

package servlet.hris.D.D03Vocation;

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
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;

import hris.D.D03Vocation.D03RemainVocationData;
import hris.D.D03Vocation.D03VocationData;
import hris.D.D03Vocation.rfc.D03CheckDataRFC;
import hris.D.D03Vocation.rfc.D03RemainVocationGlobalRFC;
import hris.D.D03Vocation.rfc.D03VocationGlobalRFC;
import hris.D.rfc.D16OTHDDupCheckRFC;
import hris.common.PersonData;
import hris.common.PhoneNumData;
import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalHeader;
import hris.common.approval.ApprovalLineData;
import hris.common.rfc.PersonInfoRFC;
import hris.common.rfc.PhoneNumRFC;
import hris.common.util.AppUtilEurp;

public class D03VocationChangeEurpSV extends ApprovalBaseServlet {

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
		
		Connection con = null;

		try {
			req.setCharacterEncoding("utf-8");
			
			HttpSession session = req.getSession(false);

			String dest 	  			= "";
			String UPMU_CODE 	= "";
			
			final WebUserData user = (WebUserData) session.getAttribute("user");			
			final Box box = WebUtil.getBox(req);
            final String jobid = box.get("jobid", "first");

			//**********************************************************
			//휴가유형에 따른 selectbox 업무코드.(value1)		2008-02-20.		
			UPMU_CODE =  box.get("TMP_UPMU_CODE", UPMU_TYPE);
			UPMU_TYPE = UPMU_CODE;
			//**********************************************************
			
			final String AINF_SEQN = box.get("AINF_SEQN");
            String I_APGUB = (String) req.getAttribute("I_APGUB");  //+어느 페이지에서 왔나? '1' : 결재할 문서 , '2' : 결재중 문서 , '3' : 결재완료 문서

			
			Logger.debug.println(this, "#####	JOBID		:	[" + jobid + "] / user.empNo	:	[" + user.empNo + "]");
			Logger.debug.println(this, "#####	UPMU_TYPE		:	[" + UPMU_TYPE + "]");
			Logger.debug.println(this, "#####	AINF_SEQN		:	[" + AINF_SEQN + "]");
			
			final D03VocationGlobalRFC rfc = new D03VocationGlobalRFC();
			D03VocationData d03VocationData = new D03VocationData();
			
			Vector d03VocationData_vt = null;

            rfc.setDetailInput(user.empNo, I_APGUB, AINF_SEQN); // 결재란설정
            
			// 휴가신청 조회
			d03VocationData_vt = rfc.getVocation(user.empNo, AINF_SEQN);
			final String PERNR = rfc.getApprovalHeader().PERNR; //box.get("PERNR", user.empNo);
			final D03VocationData firstData = (D03VocationData) Utils.indexOf(d03VocationData_vt, 0);
			//Logger.debug.println(this, "#####	d03VocationData_vt	 :	[" + d03VocationData_vt.toString() + ""]");

			// 대리 신청 추가
//			PhoneNumRFC numfunc = new PhoneNumRFC();
//			PhoneNumData phonenumdata = null;
//			phonenumdata = (PhoneNumData)numfunc.getPhoneNum(firstData.PERNR);
//			req.setAttribute("PhoneNumData", phonenumdata);
			
            PersonInfoRFC numfunc = new PersonInfoRFC();
            final PersonData phonenumdata    = (PersonData)numfunc.getPersonInfo(PERNR);
            req.setAttribute("PersonData" , phonenumdata );

			// checkData
			D03CheckDataRFC crfc=  new D03CheckDataRFC();
			
			String checkmess	= crfc.checks(PERNR);
			String E_BUKRS = user.companyCode;
			
			req.setAttribute("checkmess", checkmess);
			req.setAttribute("E_BUKRS", E_BUKRS);
			
			if (jobid.equals("first")) {

                req.setAttribute("isUpdate", true); //[결재]등록 수정 여부   <- 수정쪽에는 반드시 필요함

				// 휴가신청 조회
				d03VocationData = (D03VocationData) d03VocationData_vt.get(0);

				D03RemainVocationGlobalRFC rfcRemain = new D03RemainVocationGlobalRFC();
				Vector D03RemainVocationData_vt = null;
				
				D03RemainVocationData_vt = rfcRemain.getRemainVocation(firstData.PERNR, firstData.APPL_TO, d03VocationData.AWART);
				d03VocationData.ANZHL_BAL = ((D03RemainVocationData) D03RemainVocationData_vt.get(0)).ANZHL_BAL;
				D03RemainVocationData d03RemainVocationData  =((D03RemainVocationData) D03RemainVocationData_vt.get(0));

				Logger.debug.println(this, "#####	AWART	:	[" + d03VocationData.AWART + "]");
				Logger.debug.println(this, "#####	ANZHL_BAL	:	[" + d03VocationData.ANZHL_BAL + "]");
				
				d03VocationData_vt.addElement(d03VocationData);

				String I_STDAZ = box.get("I_STDAZ");
				String ABRTG = box.get("ABRTG");

				req.setAttribute("g_ABRTG", ABRTG);
				req.setAttribute("d03VocationData_vt", d03VocationData_vt);
                req.setAttribute("d03RemainVocationData",  d03RemainVocationData);

    	        //Case of Europe(Poland, Germany) and USA
                /*
                 * e_area :	46 (Poland)
                 *         		01 (Germany) 
                 *				10 (USA) 
                */
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
                detailApporval(req, res, rfc);
                

			} else if (jobid.equals("change")) {	// 수정

                // 실제 수정 부분 /
                dest = changeApproval(req, box, D03VocationData.class, rfc, new ChangeFunction<D03VocationData>(){
                    public String porcess(D03VocationData d03VocationData, ApprovalHeader approvalHeader, Vector<ApprovalLineData> approvalLine)
                			throws GeneralException {
                    	
				//rfc = new D03VocationGlobalRFC();
				//d03VocationData = new D03VocationData();

				Vector d03VocationData_vt = new Vector();

				String message = "";
				String P_STDAZ = box.get("P_STDAZ");
				String I_STDAZ = "";
		
    	        //Case of Europe(Poland, Germany) and USA
                /*
                 * e_area :	46 (Poland)
                 *         		01 (Germany) 
                 *				10 (USA) 
                */
				if (user.e_area.equals("01") || user.e_area.equals("10")||user.e_area.equals("32")) {	//@PJ.멕시코 법인 Rollout 프로젝트 추가 관련(Area = MX("32")) 2018/02/09 rdcamel
					I_STDAZ = box.get("I_STDAZ");
				}

				if (user.e_area.equals("46")) {	
					// 휴가신청 저장..
					d03VocationData.AINF_SEQN 		= AINF_SEQN; 							// 결재정보 일련번호
					d03VocationData.BEGDA 			= box.get("BEGDA"); 					// 신청일
					d03VocationData.AWART 			= box.get("AWART1");					// 근무/휴무 유형
					d03VocationData.APPL_REAS 		= box.get("APPL_REAS"); 				// 신청 사유
					d03VocationData.APPL_FROM 	= box.get("APPL_FROM"); 				// 신청시작일
					d03VocationData.APPL_TO 		= box.get("APPL_TO"); 					// 신청종료일
					d03VocationData.PERNR 			= firstData.PERNR; 						// 사원번호
					d03VocationData.ZPERNR 			= user.empNo; 							// 사원번호
					d03VocationData.UNAME 			= user.empNo; 							// 신청자 사번 설정(대리신청 ,본인 신청)
					d03VocationData.AEDTM 			= DataUtil.getCurrentDate();			// 변경일(현재날짜)
					d03VocationData.ANZHL_BAL 		= box.get("ANZHL_BAL");
					d03VocationData.ABSN_DATE 	= box.get("P_STDAZ2");
					d03VocationData.ABRTG 			= box.get("E_ABRTG");
					d03VocationData.STDAZ 			= box.get("I_STDAZ");
				
				} else if (user.e_area.equals("01") || user.e_area.equals("10")||user.e_area.equals("32")) {	 //@PJ.멕시코 법인 Rollout 프로젝트 추가 관련(Area = MX("32")) 2018/02/09 rdcamel
					
					d03VocationData.AINF_SEQN 		= AINF_SEQN; 							// 결재정보 일련번호
					d03VocationData.BEGDA 			= box.get("BEGDA"); 					// 신청일
					d03VocationData.AWART 			= box.get("AWART1");					// 근무/휴무 유형
					d03VocationData.APPL_REAS 		= box.get("APPL_REAS"); 				// 신청 사유
					d03VocationData.APPL_FROM 	= box.get("APPL_FROM"); 				// 신청시작일
					d03VocationData.APPL_TO 		= box.get("APPL_TO"); 					// 신청종료일
					d03VocationData.BEGUZ 			= box.get("BEGUZ"); 					// 시작시간
					d03VocationData.ENDUZ 			= box.get("ENDUZ"); 					// 종료시간
					d03VocationData.PERNR 			= firstData.PERNR; 						// 사원번호
					d03VocationData.ZPERNR 			= user.empNo; 							// 사원번호
					d03VocationData.UNAME 			= user.empNo; 							// 신청자 사번 설정(대리신청 ,본인 신청)
					d03VocationData.AEDTM 			= DataUtil.getCurrentDate();			// 변경일(현재날짜)
					d03VocationData.ANZHL_BAL 		= box.get("ANZHL_BAL");
					d03VocationData.ABSN_DATE 	= box.get("P_STDAZ2");
					d03VocationData.ABRTG 			= box.get("E_ABRTG");
					d03VocationData.STDAZ 			= box.get("I_STDAZ");
					
				}
				
				if (!message.equals("")) { // 메세지가 있는경우
					d03VocationData_vt.addElement(d03VocationData);

					Logger.debug.println(this, "#####	원래패이지로");
					
					req.setAttribute("jobid", jobid);
					req.setAttribute("message", message);
					req.setAttribute("d03VocationData_vt", d03VocationData_vt);
					//req.setAttribute("d03RemainVocationData", d03RemainVocationData);
//					req.setAttribute("AppLineData_vt", AppLineData_vt);
                    getApprovalInfo(req, PERNR);    //<-- 반드시 추가

                    req.setAttribute("approvalLine", approvalLine); //변경된 결재라인

					D16OTHDDupCheckRFC func2 = new D16OTHDDupCheckRFC();
					
					//Vector OTHDDupCheckData_vt = func2.getCheckList(user.empNo, UPMU_TYPE );
					//req.setAttribute("OTHDDupCheckData_vt",OTHDDupCheckData_vt);
					
	    	        //Case of Europe(Poland, Germany) and USA
	                /*
	                 * e_area :	46 (Poland)
	                 *         		01 (Germany) 
	                 *				10 (USA) 
	                */
//					if (user.e_area.equals("46")) {
//					dest = WebUtil.JspURL
//							+ "D/D03Vocation/D03VocationChangePl.jsp";
//					
//					} else if (user.e_area.equals("01")) {
//						dest = WebUtil.JspURL
//							+ "D/D03Vocation/D03VocationChangeDe.jsp";
//					
//					} else if (user.e_area.equals("10")) {
//						dest = WebUtil.JspURL
//							+ "D/D03Vocation/D03VocationChangeUsa.jsp";
//					}
					return null;
					
				} else { // 저장
					
					int rowcount = box.getInt("RowCount");
				 
					d03VocationData.AINF_SEQN2 = box.get("AINF_SEQN2");
					
					if (user.e_area.equals("01") || user.e_area.equals("10")||user.e_area.equals("32")) {//@PJ.멕시코 법인 Rollout 프로젝트 추가 관련(Area = MX("32")) 2018/02/09 rdcamel
						d03VocationData.STDAZ = box.get("I_STDAZ");
					}
					
					// 수정 저장시, 변경전 UPMU_TYPE 값.	 
					String UPMU_CODE1 = req.getParameter("UPMU_CODE1");

	                // * 결재 신청 RFC 호출 * /
	                rfc.setChangeInput(user.empNo, UPMU_TYPE, approvalHeader.AINF_SEQN);

					rfc.change(firstData.PERNR, AINF_SEQN, d03VocationData, box, req);
					return d03VocationData.AINF_SEQN;
				}
			}});
//					for (int i = 0; i < rowcount; i++) {
//						AppLineData appLine = new AppLineData();
//						String idx = Integer.toString(i);
//
//						appLine.APPL_MANDT 			= user.clientNo;
//						appLine.APPL_BUKRS 			= user.companyCode;
//						appLine.APPL_AINF_SEQN 		= AINF_SEQN;
//						appLine.APPL_UPMU_FLAG 		= box.get("APPL_UPMU_FLAG" + idx);
//						appLine.APPL_UPMU_TYPE 		= UPMU_TYPE;
//						
//						// 수정 저장시, 변경전 UPMU_TYPE 값.	 
//						appLine.APPL_UPMU_TYPE1 	= UPMU_CODE1;
//						appLine.APPL_APPR_TYPE		= box.get("APPL_APPR_TYPE" + idx);
//						appLine.APPL_APPU_TYPE 		= box.get("APPL_APPU_TYPE" + idx);
//						appLine.APPL_APPR_SEQN 		= box.get("APPL_APPR_SEQN" + idx);
//						appLine.APPL_OTYPE 			= box.get("APPL_OTYPE" + idx);
//						appLine.APPL_OBJID 				= box.get("APPL_OBJID" + idx);
//						appLine.APPL_APPU_NUMB 		= box.get("APPL_APPU_NUMB" + idx);
//						appLine.APPL_PERNR 			= firstData.PERNR;
//						appLine.APPL_BEGDA 			= d03VocationData.BEGDA;
//
//						AppLineData_vt.addElement(appLine);
//					}
//
//					Logger.debug.println(this, "#####	결제라인	:	" + AppLineData_vt.toString());

//					con = DBUtil.getTransaction();
//					AppLineDB appDB = new AppLineDB(con);
//					
//					// 결재정보 삭제를 위한 Data를 가져옴.
//					AppLineData appLine1 = new AppLineData();
//					appLine1.APPL_MANDT		= user.clientNo;
//					appLine1.APPL_BUKRS 		= user.companyCode;
//					appLine1.APPL_PERNR 		= firstData.PERNR;
//					appLine1.APPL_AINF_SEQN	= box.get("AINF_SEQN");

//					String msg	= null;
//					String msg2	= null;

//					if (appDB.canUpdate((AppLineData) AppLineData_vt.get(0))) {
//
//						// 기존 결재자 리스트
//						Vector orgAppLineData_vt = AppUtilEurp.getAppChangeVt(AINF_SEQN);						
//						appDB.change_vo(AppLineData_vt);

//						con.commit();
						
						//************************************************

//						msg = "msg002";
//
//						AppLineData oldAppLine	= (AppLineData) orgAppLineData_vt.get(0);
//						AppLineData newAppLine = (AppLineData) AppLineData_vt.get(0);
//						Logger.debug.println(this, oldAppLine);
//						Logger.debug.println(this, newAppLine);
//
//						if (!newAppLine.APPL_APPU_NUMB.equals(oldAppLine.APPL_PERNR)) {
//
//							// 결재자 변경시 멜 보내기 ,ElOffice 인터 페이스
//							phonenumdata = (PhoneNumData) numfunc.getPhoneNum(firstData.PERNR);
//
//							// 이메일 보내기
//							Properties ptMailBody = new Properties();
//							ptMailBody.setProperty("SServer", user.SServer); 						// ElOffice 접속서버
//							ptMailBody.setProperty("from_empNo", user.empNo); 					// 멜 발송자 사번
//							ptMailBody.setProperty("to_empNo", oldAppLine.APPL_PERNR); 		// 멜 수신자 사번
//							ptMailBody.setProperty("ename", phonenumdata.E_ENAME); 		// (피)신청자명
//							ptMailBody.setProperty("empno", phonenumdata.E_PERNR); 			// (피)신청자 사번
//							ptMailBody.setProperty("UPMU_NAME", "Leave"); 						// 문서 이름
//							ptMailBody.setProperty("AINF_SEQN", AINF_SEQN); 					// 신청서 순번
//
//							// 멜 제목
//							StringBuffer sbSubject = new StringBuffer(512);
//
//							sbSubject.append("[" + ptMailBody.getProperty("UPMU_NAME") + "] ");
//							sbSubject.append(ptMailBody.getProperty("ename")
//													+ " deleted an application of " 
//													+ ptMailBody.getProperty("UPMU_NAME") + ".");
//							
//							ptMailBody.setProperty("subject", sbSubject.toString());
//							ptMailBody.setProperty("FileName", "NoticeMail5.html");
//
//							// 멜 제목
//							sbSubject = new StringBuffer(512);
//							
//							sbSubject.append("[" + ptMailBody.getProperty("UPMU_NAME") + "] ");
//							sbSubject.append(ptMailBody.getProperty("ename") + " applied.");
//							
//							ptMailBody.setProperty("subject", sbSubject.toString());
//							ptMailBody.remove("FileName");
//							ptMailBody.setProperty("to_empNo", newAppLine.APPL_APPU_NUMB);
//
//							// ElOffice 인터페이스
//							try {
//								DraftDocForEloffice ddfe = new DraftDocForEloffice();
//								ElofficInterfaceData eof = ddfe.makeDocForChange(
//												AINF_SEQN, user.SServer, ptMailBody.getProperty("UPMU_NAME"), oldAppLine.APPL_PERNR);
//								
//								Vector vcElofficInterfaceData = new Vector();
//								vcElofficInterfaceData.add(eof);
//								
//								req.setAttribute("vcElofficInterfaceData", vcElofficInterfaceData);
//								
//								dest = WebUtil.JspURL + "common/ElOfficeInterface.jsp";
//								
//							} catch (Exception e) {
//								dest = WebUtil.JspURL + "common/msg.jsp";
//								msg2 = msg2 + "\\n" + " Eloffic Connection Failed.";
//							} // end try
//							
//						} else {
//							msg = "msg002";
//							dest = WebUtil.JspURL + "common/msg.jsp";
//						} // end if
//						
//					} else {
//						msg = "msg005";
//						dest = WebUtil.JspURL + "common/msg.jsp";
//					} // end if
//
//					String url ="";
					
	    	        //Case of Europe(Poland, Germany) and USA
	                /*
	                 * e_area :	46 (Poland)
	                 *         		01 (Germany) 
	                 *				10 (USA) 
	                */
//					if (user.e_area.equals("46")) {
//						url = "location.href = '"
//							+ WebUtil.ServletURL
//							+ "hris.D.D03Vocation.D03VocationDetailEurpSV?AINF_SEQN="
//							+ AINF_SEQN + "" + "&RequestPageName="
//							+ RequestPageName
//							+ "&P_STDAZ=" + P_STDAZ + "&PERNR=" + PERNR + "';";
//					
//					} else if (user.e_area.equals("01") || user.e_area.equals("10")) {
//						 url = "location.href = '"
//							+ WebUtil.ServletURL
//							+ "hris.D.D03Vocation.D03VocationDetailEurpSV?AINF_SEQN="
//							+ AINF_SEQN + "" + "&RequestPageName="
//							+ RequestPageName + "&I_STDAZ=" + I_STDAZ
//							+ "&P_STDAZ=" + P_STDAZ + "&PERNR=" + PERNR + "';";						
//					}
//					
//					req.setAttribute("msg", msg);
//					req.setAttribute("msg2", msg2);
//					req.setAttribute("url", url);
					// **********수정 시작 (20050223:유용원)**********

				
			} else if (jobid.equals("getQuotaBalance")) {	//Quota Balance 변경.
				
				Vector D03RemainVocationData_vt = null;
				
				String AWART = req.getParameter("AWART"); 
//				PERNR = req.getParameter("PERNR");
				
				req.setCharacterEncoding("utf-8");
				
				//AbsenceType을 조회할 때 Quota를 재 조회한다. 개인의 잔여휴가일수 조회 RFC 호출
				D03RemainVocationGlobalRFC rfcRemain2 = new D03RemainVocationGlobalRFC();
					
				D03RemainVocationData_vt = rfcRemain2.getRemainVocation(PERNR, "", AWART);
				String ANZHL_BAL = ((D03RemainVocationData) D03RemainVocationData_vt.get(0)).ANZHL_BAL;
				
				ANZHL_BAL = AppUtilEurp.escape(ANZHL_BAL);
				Logger.debug.println(this, "#####	ANZHL_BAL	:	[" + ANZHL_BAL + "]");
				
				res.setCharacterEncoding("utf-8");
				res.getWriter().print(ANZHL_BAL);
				
				return;
				
			} else {
				throw new BusinessException("#####	내부명령(jobid)이 올바르지 않습니다.");
			}
			
			Logger.debug.println(this, "#####	dest = " + dest);
			
			printJspPage(req, res, dest);

		} catch (Exception e) {
			throw new GeneralException(e);
		} finally {
			DBUtil.close(con);
		}
	}
	
}
