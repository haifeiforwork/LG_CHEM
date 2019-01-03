/********************************************************************************/
/*	  System Name  	: g-HR
/*   1Depth Name		: Application
/*   2Depth Name  	: Time Management
/*   Program Name 	: Overtime
/*   Program ID   		: D01OTDetailSV
/*   Description  		: 초과근무 조회 및 삭제를 할 수 있도록 하는 Class
/*   Note         		:
/*   Creation     		: 2002-01-15  박영락
/*   Update       		: 2005-03-03  윤정현
/*   Update       		: 2007-09-12  huang peng xiao
 /*					    : 2017-04-03  김은하  [CSR ID:3340999]  대만 당월근태기간동안 46시간 제한*/
/*					        : 2017-04-19  김은하  [CSR ID:3359686]   남경 결재 5일제어*/
/*					        : 2018-03-19  강동민  @PJ.광저우 법인(G570) Roll-Out       */
/*					        : 2018-08-01  변지현  @PJ.우시법인(G620) Roll-out       */
/********************************************************************************/

package servlet.hris.D.D01OT;

import java.sql.Connection;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.common.RFCReturnEntity;
import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.WebUtil;

import hris.D.D01OT.D01OTData;
import hris.D.D01OT.rfc.D01OTCheckGlobalRFC;
import hris.D.D01OT.rfc.D01OTRFC;
import hris.D.D01OT.rfc.D01OTReasonRFC;
import hris.D.rfc.D20ActTimeCardRFC;
import hris.common.PersonData;
import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.rfc.PersonInfoRFC;

public class D01OTDetailGlobalSV extends ApprovalBaseServlet {

	private String UPMU_TYPE = "01";		// 결재 업무타입(초과근무)

    private String UPMU_NAME = "OverTime";

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

			String dest	= "";
			String jobid	= "";

			Box box = WebUtil.getBox(req);

			jobid = box.get("jobid", "first");

			//Logger.debug.println(this, "#####	box	:	[ " + box.toString() + " ]");
			//Logger.debug.println(this, "#####	user	:	[ " + user.toString() + " ]");
			//Logger.debug.println(this, "#####	jobid	:	[ " + jobid + " ]	/	PERNR :	[ " + PERNR + " ]");

			final String ainf_seqn = box.get("AINF_SEQN");

			Vector D01OTData_vt = null;

			final D01OTRFC rfc = new D01OTRFC();


            String I_APGUB = (String) req.getAttribute("I_APGUB");  //어느 페이지에서 왔나? '1' : 결재할 문서 , '2' : 결재중 문서 , '3' : 결재완료 문서

            rfc.setDetailInput(user.empNo, I_APGUB, ainf_seqn);
			D01OTData_vt = rfc.getDetail(ainf_seqn, "");
			String PERNR = 			rfc.getApprovalHeader().PERNR;// box.get("PERNR", user.empNo); //
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


//			 2016-05-19 pangxiaolin C20160505_56532 @v2.2 G170法人增加申请加班可以选择加班理由修改 start
			D01OTReasonRFC rfc_reasontype = new D01OTReasonRFC();
			Vector d01OTReasonData_vt = rfc_reasontype.getTypeCode(PERNR);
			Logger.debug.println(this, "d01OTReasonData_vt" + d01OTReasonData_vt.toString());
			req.setAttribute("reasonCode", d01OTReasonData_vt);
//			2016-05-19 pangxiaolin C20160505_56532 @v2.2 G170法人增加申请加班可以选择加班理由修改 end

			if (jobid.equals("first")) {

				D01OTData data = (D01OTData)D01OTData_vt.get(0);

				if(data.AINF_SEQN.equals("")){
					data.AINF_SEQN = ainf_seqn;
				}

				D01OTData_vt = new Vector();
				D01OTData_vt.addElement(data);

                if (!detailApporval(req, res, rfc))                    return;
				req.setAttribute("D01OTData_vt", D01OTData_vt);

				//*******************************************************************************
				// BOHAI踰뺤씤 �넻臾몄떆媛� 泥댄겕.		2009-12-23		jungin		@v1.1 [C20091222_81370]
                // DAGU踰뺤씤 �넻臾몄떆媛� 泥댄겕.  	2010-04-28		jungin		@v1.2 [C20100427_55533]
                //BOTIAN踰뺤씤 �넻臾몄떆媛� 泥댄겕.  	2011-01-19		liukuo		@v1.3 [C20110118_09919]
				// �뜔雅촊V力뺜볶訝딁봇
				//2014-10-09 pangxiaolin	@v1.5 [C20141009_22070] �뜔雅ф퀡雅뷴뒥�룺若→돶�븣�씊若욅렟�돀�뜞�뿶�뿴��瑥� start
				//2018-03-12 KDM  @PJ.광정우 법인(G570) Roll-Out Start
				//2018-08-01 변지현 @PJ.우시법인(G620) Roll-out
				if ( (phonenumdata.E_BUKRS.equals("G110") || phonenumdata.E_BUKRS == "G110")
					|| (phonenumdata.E_BUKRS.equals("G280") || phonenumdata.E_BUKRS == "G280")
					|| (phonenumdata.E_BUKRS.equals("G370") || phonenumdata.E_BUKRS == "G370")
					|| (phonenumdata.E_BUKRS.equals("G180") || phonenumdata.E_BUKRS == "G180")
					|| (phonenumdata.E_BUKRS.equals("G450") || phonenumdata.E_BUKRS == "G450")
					|| (phonenumdata.E_BUKRS.equals("G570") || phonenumdata.E_BUKRS == "G570")
					|| (phonenumdata.E_BUKRS.equals("G620") || phonenumdata.E_BUKRS == "G620")) {
				//2018-03-12 KDM @PJ.광정우 법인(G570) Roll-Out End
				//2014-10-09 pangxiaolin	@v1.5 [C20141009_22070] �뜔雅ф퀡雅뷴뒥�룺若→돶�븣�씊若욅렟�돀�뜞�뿶�뿴��瑥� end

				Vector vc20ActTimeCardData = null;
				String I_TYPE = "O";
				D20ActTimeCardRFC rfc3 = new D20ActTimeCardRFC();
				vc20ActTimeCardData = rfc3.getActTimeCard(data.PERNR, data.WORK_DATE, data.BEGUZ, data.ENDUZ, I_TYPE);

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

                D01OTCheckGlobalRFC  d01OTCheckGlobalRFC           = new D01OTCheckGlobalRFC();
                //[CSR ID:3359686]   남경 결재 5일제어 START
                d01OTCheckGlobalRFC.checkApprovalPeriod(req,data.PERNR,"A", data.WORK_DATE,   UPMU_TYPE,  "" );
                req.setAttribute("E_7OVER_NOT_APPROVAL", d01OTCheckGlobalRFC.getReturn().MSGTY);
                //[CSR ID:3359686]   남경 결재 5일제어 END

				//2017-04-03 김은하  [CSR ID:3340999]  대만 당월근태기간동안 46시간 제한 START
                String E_ANZHL = d01OTCheckGlobalRFC.checkOvertimeTp46Hours(req, PERNR,  "A",  data.AINF_SEQN, data.WORK_DATE,  data.STDAZ );
                req.setAttribute("E_ANZHL", E_ANZHL);
                req.setAttribute("E_46OVER_NOT_APPROVAL", d01OTCheckGlobalRFC.getReturn().MSGTY);
				//2017-04-03 김은하  [CSR ID:3340999]  대만 당월근태기간동안 46시간 제한 END

				dest = WebUtil.JspURL + "D/D01OT/D01OTDetail_Global.jsp";

			} else if (jobid.equals("delete")) {

                dest = deleteApproval(req, box, rfc, new DeleteFunction() {
                    public boolean porcess() throws GeneralException {

                    	//D01OTRFC deleteRFC = new D01OTRFC();
                        rfc.setDeleteInput(user.empNo, UPMU_TYPE, rfc.getApprovalHeader().AINF_SEQN);

                        RFCReturnEntity returnEntity = rfc.delete( ainf_seqn, firstData.PERNR );

                        if(!returnEntity.isSuccess()) {
                            throw new GeneralException(returnEntity.MSGTX);
                        }

                        return true;
                    }
                });
/*
				Vector AppLineData_vt = new Vector();

				AppLineData appLine = new AppLineData();
				appLine.APPL_MANDT		= user.clientNo;
				appLine.APPL_BUKRS			= user.companyCode;
				appLine.APPL_PERNR			= firstData.PERNR;
				appLine.APPL_UPMU_TYPE	= UPMU_TYPE;
				appLine.APPL_AINF_SEQN	= ainf_seqn;

				// 2002.07.25.---------------------------------------------------------------
				// 신청건 삭제시 메일 보내기 위해 필요한 결재자 정보를 가져온다.
				// 결재
				int rowcount = box.getInt("RowCount");
				for (int i = 0; i < rowcount; i++) {
					AppLineData app = new AppLineData();
					String idx = Integer.toString(i);

					// 같은 이름으로 여러행 받을때
					box.copyToEntity(app, i);

					AppLineData_vt.addElement(app);
				}
				Logger.debug.println(this, "AppLineData : " + AppLineData_vt.toString());
				// 신청건 삭제시 메일 보내기 위해 필요한 결재자 정보를 가져온다.
				// 2002.07.25.---------------------------------------------------------------

				con = DBUtil.getTransaction();
				AppLineDB appDB = new AppLineDB(con);

				if (appDB.canUpdate(appLine)) {

					appDB.delete(appLine);
					rfc.delete(ainf_seqn, firstData.PERNR);
					con.commit();

					appLine = (AppLineData) AppLineData_vt.get(0);

					Properties ptMailBody = new Properties();
					ptMailBody.setProperty("SServer", user.SServer); 							// ElOffice 접속 서버
					ptMailBody.setProperty("from_empNo", user.empNo); 						// 멜 발송자 사번
					ptMailBody.setProperty("to_empNo", appLine.APPL_APPU_NUMB); 		// 멜 수신자 사번
					ptMailBody.setProperty("ename", phonenumdata.E_ENAME); 			// (피)신청자명
					ptMailBody.setProperty("empno", phonenumdata.E_PERNR); 				// (피)신청자 사번
					ptMailBody.setProperty("UPMU_NAME", "Overtime"); 						// 문서 이름
					ptMailBody.setProperty("AINF_SEQN", ainf_seqn); 							// 신청서 순번

					// 멜 제목
					StringBuffer sbSubject = new StringBuffer(512);

					sbSubject.append("[" + ptMailBody.getProperty("UPMU_NAME") + "] ");
					sbSubject.append(ptMailBody.getProperty("ename")
							+ " deleted an application of " + ptMailBody.getProperty("UPMU_NAME") + ".");

					ptMailBody.setProperty("subject", sbSubject.toString()); 				// 멜 제목 설정
					ptMailBody.setProperty("FileName", "NoticeMail5.html");

					String msg2 = null;
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
						ElofficInterfaceData eof = ddfe.makeDocForRemove(
								ainf_seqn, user.SServer, ptMailBody
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

					req.setAttribute("msg", msg);

				} else {
					String msg = "msg005";
					String url = "location.href = '" + WebUtil.ServletURL
							+ "hris.D.D01OT.D01OTDetailSV?AINF_SEQN="
							+ ainf_seqn + "&PERNR=" + PERNR + "';";
					req.setAttribute("msg", msg);
					req.setAttribute("url", url);
					dest = WebUtil.JspURL + "common/msg.jsp";
				}
*/
			} else {
				throw new BusinessException("내부명령(jobid)이 올바르지 않습니다.");
			}

			Logger.debug.println(this, "#####	destributed = " + dest);
			printJspPage(req, res, dest);

		} catch (Exception e) {
			throw new GeneralException(e);
		} finally {
//			DBUtil.close(con);
		}
	}
}
