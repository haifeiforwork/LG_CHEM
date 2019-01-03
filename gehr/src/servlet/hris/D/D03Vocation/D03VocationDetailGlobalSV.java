/********************************************************************************/
/*                                                                              */
/*   System Name  	: MSS                                                         */
/*   1Depth Name  	: 신청                                                        */
/*   2Depth Name  	: 근태                                                        */
/*   Program Name 	: 휴가 상세                                                   */
/*   Program ID   		: D03VocationDetailSV                                         */
/*   Description  		: 휴가 조회/삭제 할수 있도록 하는 Class                       */
/*   Note         		:                                                             */
/*   Creation     		: 2002-01-04  김도신                                          */
/*   Update       		: 2005-03-04  유용원                                          */
/*   Update       		: 2008-01-11  김정인                                          							*/
/*                           경조휴가 타입이 혼가,상가일 경우 신청대상자를 저장.                       */
/*   Update       		: 2008-02-20  김정인                                          							*/
/*                      	   휴가유형에 따른 selectbox 업무코드를 가져온다.                        	*/
/*                          : 2017-04-17 김은하 [CSR ID:3359686]   남경 결재 5일제어        */
/********************************************************************************/
package servlet.hris.D.D03Vocation;

import java.sql.Connection;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.common.RFCReturnEntity;
import com.common.Utils;
import com.common.constant.Area;
import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.db.DBUtil;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.CodeEntity;
import com.sns.jdf.util.WebUtil;

import hris.D.D01OT.rfc.D01OTCheckGlobalRFC;
import hris.D.D03Vocation.D03RemainVocationData;
import hris.D.D03Vocation.D03VocationData;
import hris.D.D03Vocation.rfc.D03RemainVocationGlobalRFC;
import hris.D.D03Vocation.rfc.D03VocationGlobalRFC;
import hris.D.rfc.D17HolidayTypeRFC;
import hris.common.PersonData;
import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.rfc.PersonInfoRFC;

public class D03VocationDetailGlobalSV extends ApprovalBaseServlet {

	private String UPMU_TYPE = "02"; // 결재 업무타입(휴가신청)

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
			HttpSession session = req.getSession(false);

			final WebUserData user = (WebUserData) session.getAttribute("user");

			String dest 	  			= "";
			String jobid   			= "";
			String UPMU_CODE 	= "";

            /**         * Start: 국가별 분기처리 */
            String fdUrl = ".";
            if (user.area.equals(Area.PL) || user.area.equals(Area.DE)) { // PL 폴랜드, DE 독일 은 유럽화면으로
        	   fdUrl = "hris.D.D03Vocation.D03VocationDetailEurpSV";
			}

           Logger.debug.println(this, "-------------[user.area] = "+user.area + " fdUrl: " + fdUrl );

            if( !".".equals(fdUrl )){
            	printJspPage(req, res, WebUtil.ServletURL+fdUrl );
		       	return;
           }
            /**             * END: 국가별 분기처리             */

			final Box box = WebUtil.getBox(req);

			jobid = box.get("jobid", "first");


			//********************************************
			//휴가유형에 따른 selectbox 업무코드.(value1)		2008-02-20.
			UPMU_CODE =  box.get("TMP_UPMU_CODE", UPMU_TYPE);
			//********************************************

			final String AINF_SEQN = box.get("AINF_SEQN");

            String I_APGUB = (String) req.getAttribute("I_APGUB");  //어느 페이지에서 왔나? '1' : 결재할 문서 , '2' : 결재중 문서 , '3' : 결재완료 문서


			Logger.debug.println(this, "USER	 :	[ " + user.toString() + " ]");
			Logger.debug.println(this, "	UPMU_TYPE	 :	[ " + UPMU_TYPE + " ]");
			Logger.debug.println(this, "	I_APGUB	 :	[ " + I_APGUB + " ]");

			//*********수정 시작 (20050304:유용원)**********
			final D03VocationGlobalRFC rfc = new D03VocationGlobalRFC();
			// D03VocationData d03VocationData = new D03VocationData();

			Vector d03VocationData_vt = null;
			// final String PERNR =  box.get("PERNR", user.empNo); // 2016/11/30 작성자로 나와서 처리안됨.


            rfc.setDetailInput(user.empNo, I_APGUB, AINF_SEQN);

			// 휴가신청 조회
			d03VocationData_vt = rfc.getVocation(user.empNo, AINF_SEQN);
			final String PERNR =  rfc.getApprovalHeader().PERNR; //getPERNR(box, user); //
			final D03VocationData firstData = (D03VocationData) d03VocationData_vt.get(0);
			Logger.debug.println(this, "JOBID	 :	[ " + jobid + " ]	/	PERNR	 :	[ " + PERNR + " ]");
			Logger.debug.println(this, "JOBID	 :	[ " + jobid + " ]	d03VocationData_vt	 :	[ " + d03VocationData_vt.toString() + " ]");

			// 대리 신청 추가
//			PhoneNumRFC numfunc = new PhoneNumRFC();
//			PhoneNumData phonenumdata = null;
//			phonenumdata = (PhoneNumData) numfunc.getPhoneNum(firstData.PERNR);
//			req.setAttribute("PhoneNumData", phonenumdata);

            PersonInfoRFC numfunc = new PersonInfoRFC();
            final PersonData phonenumdata    = (PersonData)numfunc.getPersonInfo(firstData.PERNR);
            req.setAttribute("PersonData" , phonenumdata );

			String P_STDAZ = box.get("P_STDAZ");
			String I_STDAZ = box.get("I_STDAZ");

			// **********수정 끝.****************************

			if (jobid.equals("first")) {

				// 개인의 잔여휴가일수 조회
				D03RemainVocationGlobalRFC rfcRemain = new D03RemainVocationGlobalRFC();
				Vector D03RemainVocationData_vt = null;
//				D03RemainVocationData_vt = rfcRemain.getRemainVocation(firstData.PERNR, firstData.BEGDA, firstData.AWART);
				D03RemainVocationData_vt = rfcRemain.getRemainVocation(firstData.PERNR, firstData.APPL_TO, firstData.AWART);
				firstData.ANZHL_BAL = ((D03RemainVocationData) D03RemainVocationData_vt.get(0)).ANZHL_BAL;
				D03RemainVocationData d03RemainVocationData  =((D03RemainVocationData) D03RemainVocationData_vt.get(0));

				req.setAttribute("d03VocationData_vt", d03VocationData_vt);
				req.setAttribute("d03RemainVocationData", d03RemainVocationData);



                //-------- 근태기간완료된것을  check (li hui)----------------------
				D01OTCheckGlobalRFC rfc2 = new D01OTCheckGlobalRFC();
				String upmu_type = "02";		//---휴가 업무타입 -- D03VocationBuild 에는 휴가업무타입별로 다름
				Vector holidayVT = new D17HolidayTypeRFC().getHolidayType(firstData.PERNR);

			        for (int i = 0; i < Utils.getSize(holidayVT); i++) {
			            com.sns.jdf.util.CodeEntity ck = (com.sns.jdf.util.CodeEntity) holidayVT.get(i);
			            if (firstData.AWART.equals(ck.code)) {
			            	upmu_type = ck.value1;
			            }
			        }

	                //[CSR ID:3359686]   남경 결재 5일제어 START
	                rfc2.checkApprovalPeriod(req,firstData.PERNR,"A", firstData.APPL_FROM,   upmu_type,  firstData.AWART );
	                req.setAttribute("E_7OVER_NOT_APPROVAL", rfc2.getReturn().MSGTY);
	                //[CSR ID:3359686]   남경 결재 5일제어  END


				String flag = rfc2.check1(firstData.PERNR, firstData.APPL_FROM,upmu_type);

				Logger.debug.println(this, "[#####]	JOBID	 :	[ " + jobid + " ]	flag	 :	[ " + flag + " ]  upmu_type: "+ upmu_type);

				req.setAttribute("flag" ,flag );

                if (!detailApporval(req, res, rfc))                    return;
				dest = WebUtil.JspURL
						+ "D/D03Vocation/D03VocationDetail_Global.jsp?I_STDAZ=" + I_STDAZ + "&P_STDAZ=" + P_STDAZ + "";

			} else if (jobid.equals("delete")) {

                dest = deleteApproval(req, box, rfc, new DeleteFunction() {
                    public boolean porcess() throws GeneralException {

                    	//D01OTRFC deleteRFC = new D01OTRFC();
                        rfc.setDeleteInput(user.empNo, UPMU_TYPE, rfc.getApprovalHeader().AINF_SEQN);

                        RFCReturnEntity returnEntity = rfc.delete(  firstData.PERNR, AINF_SEQN );

                        if(!returnEntity.isSuccess()) {
                            throw new GeneralException(returnEntity.MSGTX);
                        }

                        return true;
                    }
                });

				// 휴가신청 삭제
				//rfc = new D03VocationGlobalRFC();

				// 신청건 삭제시 메일 보내기 위해 필요한 결재자 정보를 가져온다.
				// 2002.07.25.---------------------------------------------------------------------------
/*
				con = DBUtil.getTransaction();

				AppLineDB appDB = new AppLineDB(con);

				if (appDB.canUpdate(appLine)) {

					appDB.delete(appLine);

					rfc.delete(firstData.PERNR, AINF_SEQN);
					con.commit();

					// **********수정 시작 (20050223:유용원)**********
					// 신청건 삭제시 메일 보내기.
					appLine = (AppLineData) AppLineData_vt.get(0);

					// 결재자 변경시 멜 보내기 ,ElOffice 인터 페이스
					phonenumdata = (PhoneNumData) numfunc.getPhoneNum(firstData.PERNR);
					Properties ptMailBody = new Properties();

					ptMailBody.setProperty("SServer", user.SServer); 							// ElOffice 접속 서버
					ptMailBody.setProperty("from_empNo", user.empNo); 						// 멜 발송자 사번
					ptMailBody.setProperty("to_empNo", appLine.APPL_APPU_NUMB); 		// 멜 수신자 사번
					ptMailBody.setProperty("ename", phonenumdata.E_ENAME); 			// (피)신청자명
					ptMailBody.setProperty("empno", phonenumdata.E_PERNR); 				// (피)신청자 사번
					ptMailBody.setProperty("UPMU_NAME", "Leave"); 							// 문서 이름
					ptMailBody.setProperty("AINF_SEQN", AINF_SEQN); 						// 신청서 순번

					// 멜 제목
					StringBuffer sbSubject = new StringBuffer(512);

					sbSubject.append("[" + ptMailBody.getProperty("UPMU_NAME") + "] ");
					sbSubject.append(ptMailBody.getProperty("ename")
											+ " deleted an application of "
											+ ptMailBody.getProperty("UPMU_NAME") + ".");


					ptMailBody.setProperty("subject", sbSubject.toString());
					ptMailBody.setProperty("FileName", "NoticeMail5.html");

					String msg2 = null;


					try {
						DraftDocForEloffice ddfe = new DraftDocForEloffice();
						ElofficInterfaceData eof = ddfe.makeDocForRemove(
								AINF_SEQN, user.SServer, ptMailBody
										.getProperty("UPMU_NAME"),
								firstData.PERNR, appLine.APPL_APPU_NUMB);

						Vector vcElofficInterfaceData = new Vector();
						vcElofficInterfaceData.add(eof);
						req.setAttribute("vcElofficInterfaceData",
								vcElofficInterfaceData);
						dest = WebUtil.JspURL + "common/ElOfficeInterface.jsp";
					} catch (Exception e) {
						dest = WebUtil.JspURL + "common/msg.jsp";
						msg2 = msg2 + "\\n" + " Eloffic Connection Failed.";
					} // end try

					String msg = "msg003";
					String url;

					// 삭제 실행후 삭제전 페이지로 이동하기 위한 구분
					if (RequestPageName != null && !RequestPageName.equals("")) {
						url = "location.href = '"
								+ RequestPageName.replace('|', '&') + "';";
					} else {
						url = "location.href = '" + WebUtil.ServletURL
								+ "hris.D.D03Vocation.D03VocationBuildSV';";
					} // end if
					// **********수정 끝.****************************

					req.setAttribute("msg", msg);
					req.setAttribute("url", url);

				} else {
					String msg = "msg005";
					String url = "location.href = '"
							+ WebUtil.ServletURL
							+ "hris.D.D03Vocation.D03VocationDetailSV?AINF_SEQN="
							+ AINF_SEQN + "&PERNR=" + PERNR + "';";
					req.setAttribute("msg", msg);
					req.setAttribute("url", url);
					dest = WebUtil.JspURL + "common/msg.jsp";
				}
				*/

			} else {
                throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
			}

			Logger.debug.println(this, "JOBID	 :	[ " + jobid + " ]	destributed = " + dest);
			printJspPage(req, res, dest);

		} catch (Exception e) {
			throw new GeneralException(e);
		} finally {
			DBUtil.close(con);
		}
	}
}