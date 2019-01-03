/*                                                                              */
/*   System Name  : e-HR                                                        */
/*   1Depth Name  : HR 결재함                                                   */
/*   2Depth Name  : 결재 완료 문서                                              */
/*   Program Name : 초과 근무 신청                                              */
/*   Program ID   : G029ApprovalFinishOTSV                                      */
/*   Description  : 초과 근무 신청 결재 완료                                    */
/*   Note         : 없음                                                        */
/*   Creation     : 2005-03-14  이승희                                          */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/

package servlet.hris.D.D01OT;

import java.util.HashMap;
import java.util.Map;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.ObjectUtils;
import org.apache.commons.lang.StringUtils;

import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.RfcDataHandler;
import com.sns.jdf.sap.RfcHandler;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;

import hris.D.D01OT.D01OTData;
import hris.D.D01OT.rfc.D01OTRFC;
import hris.G.ApprovalCancelData;
import hris.G.rfc.ApprovalCancelRFC;
import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalHeader;
import hris.common.approval.ApprovalLineData;
import hris.common.rfc.PersInfoWithNoRFC;

@SuppressWarnings({ "rawtypes", "serial" })
public class D01OTCancelBuildSV extends ApprovalBaseServlet {

    private static String ORG_UPMU_TYPE = "17"; // 결재 업무타입(초과근무)
    private static String NEW_UPMU_TYPE = "40";

    private String UPMU_TYPE = "40";
    private String UPMU_NAME = "초과근무 결재취소";

    protected String getUPMU_TYPE() {
        return UPMU_TYPE;
    }

    protected String getUPMU_NAME() {
        return UPMU_NAME;
    }

    protected void performTask(final HttpServletRequest req, HttpServletResponse res) throws GeneralException {

        try {
            final WebUserData user = WebUtil.getSessionUser(req);

            final Box box = WebUtil.getBox(req);
            final String jobid = box.get("jobid", "search");
            final String AINF_SEQN = box.get("AINF_SEQN");
            final String PERNR = getPERNR(box, user); // box.get("PERNR", user.empNo);

            String I_APGUB = (String) req.getAttribute("I_APGUB");  // 어느 페이지에서 왔나? '1' : 결재할 문서 , '2' : 결재중 문서 , '3' : 결재완료 문서

            String dest = WebUtil.JspURL + "D/D01OT/D01OTCancelBuild.jsp";

            if (jobid.equals("search") || jobid.equals("after")) {
                if (jobid.equals("after")) {
                    req.setAttribute("jobid", "create");
                }

                D01OTRFC rfc = new D01OTRFC(user.empNo, I_APGUB, AINF_SEQN);

                Vector vcD01OTData = rfc.getDetail(AINF_SEQN, "");
                Logger.debug.println(this, vcD01OTData);

                // 결재자리스트
                // Vector AppLineData_vt = AppUtil.getAppVector( PERNR, UPMU_TYPE );
                // Vector AppLineData_vt = AppUtil.getAppVector( PERNR, "17" );
                // Logger.debug.println(this, "AppLineData_vt : "+ AppLineData_vt.toString());

                // req.setAttribute("AppLineData_vt", AppLineData_vt);

                if (vcD01OTData.size() < 1) {
                    req.setAttribute("msg", "System Error! \n\n 조회할 항목이 없습니다.");
                    dest = WebUtil.JspURL + "common/caution.jsp";

                } else {
                    // OT(초과 근무)
                    final D01OTData d01OTData = (D01OTData) vcD01OTData.get(0);
                    req.setAttribute("d01OTData", d01OTData);

                    // 결재자 정보
                    req.setAttribute("PersInfoData", new PersInfoWithNoRFC().getApproval(d01OTData.PERNR).get(0));

                    // 결재라인, 결재 헤더 정보 조회
                    UPMU_TYPE = ORG_UPMU_TYPE;
                    getApprovalInfo(req, PERNR);    // <-- 반드시 추가
                    UPMU_TYPE = NEW_UPMU_TYPE;

                    ApprovalHeader approvalHeader = (ApprovalHeader) req.getAttribute("approvalHeader");
                    approvalHeader.setUPMU_TYPE(getUPMU_TYPE());
                    req.setAttribute("approvalHeader", approvalHeader);

                    if (!detailApporval(req, res, rfc)) return;

                    // 시작 : 2018.05.17 [WorkTime52] 유정우 - 실근무시간 현황표 추가
                    try {
                        /**
                         * 실근무시간 현황표 추가여부
                         *     S(사무직 현황표 추가)
                         *     H(현장직 현황표 추가)
                         *     -(기존 초과근무 현황표 유지)
                         *     X(해당 없음)
                         *
                         * -------------------------------------------------------------------------
                         *           문서 구분          | 결재할 문서 | 결재중 문서 | 결재완료 문서
                         *                              | I_APGUB = 1 | I_APGUB = 2 | I_APGUB = 3
                         * -------------------------------------------------------------------------
                         *         | 사무직(S) | 신청자 |  X          |  S          |  S
                         *         |-----------|        |-------------------------------------------
                         *  신청자 | 현장직(H) |  화면  |  X          |  -          |  -
                         *   사원  |----------------------------------------------------------------
                         *   구분  | 사무직(S) | 결재자 |  S          |  S          |  S
                         *         |-----------|        |-------------------------------------------
                         *         | 현장직(H) |  화면  |  H          |  H          |  H
                         * -------------------------------------------------------------------------
                         *
                         * 결재자 입장에서는 모든 문서 화면에 현황표 추가
                         * 신청자 입장에서는 결재중이거나 결재완료된 문서 화면에 현황표 추가
                         */
                        if (!"1".equals(I_APGUB) || !user.empNo.equals(d01OTData.PERNR)) {
                            final String WORK_DATE = StringUtils.defaultString(d01OTData.WORK_DATE).replaceAll("[^\\d]", "");
                            final String I_DATUM = "X".equals(d01OTData.VTKEN) ? DataUtil.addDays(WORK_DATE, -1, "yyyyMMdd") : WORK_DATE;

                            // 신청자 사원 구분 조회 : S(사무직) or H(현장직)
                            Map<String, Object> rfcResultData = RfcHandler.execute("ZGHR_RFC_NTM_GET_EMPGUB", new HashMap<String, Object>() {
                                {
                                    put("I_PERNR", d01OTData.PERNR);
                                    put("I_DATUM", I_DATUM);
                                }
                            });

                            Map<String, Object> EXPORT = getData(rfcResultData, "EXPORT", g.getMessage("MSG.D.D01.0063")); // 실근무시간 현황 조회에 필요한 사원 구분(사무직 or 현장직) 데이터를 조회하지 못하였습니다.
                            final String EMPGUB = ObjectUtils.toString(EXPORT.get("E_EMPGUB"));
                            final String TPGUB = ObjectUtils.toString(EXPORT.get("E_TPGUB"));
                            req.setAttribute("EMPGUB", EMPGUB);
                            req.setAttribute("TPGUB", TPGUB);

                            if ("S".equals(EMPGUB) || ("H".equals(EMPGUB) && !user.empNo.equals(d01OTData.PERNR))) {
                                // 신청자 실근무시간 현황 조회
                                rfcResultData = RfcHandler.execute("ZGHR_RFC_NTM_OT_REQ_RW_LIST", new HashMap<String, Object>() {
                                    {
                                        put("I_EMPGUB", EMPGUB);
                                        put("I_PERNR", d01OTData.PERNR);
                                        put("I_DATUM", WORK_DATE);
                                        if ("H".equals(EMPGUB)) put("I_VTKEN", d01OTData.VTKEN);
                                    }
                                });

                                WebUtil.setAttributes(req, (Map<String, Object>) getData(rfcResultData, "EXPORT", g.getMessage("MSG.D.D01.0064")).get("ES_EMPGUB_" + EMPGUB)); // 실근무시간 현황 데이터를 조회하지 못하였습니다.
                            }

                        }

                    } catch (Exception e) {
                        req.setAttribute("msg", e.getMessage());
                        req.setAttribute("url", "history.back()");

                        printJspPage(req, res, WebUtil.JspURL + "common/msg.jsp");
                        return;
                    }
                    // 종료 : 2018.05.17 [WorkTime52] 유정우 - 실근무시간 현황표 추가

                } // end if

                /***********************************************
                 * Create 취소요청처리
                 **************************************************/

            } else if (jobid.equals("create")) {

                UPMU_TYPE = NEW_UPMU_TYPE;
                dest = requestApproval(req, box, ApprovalCancelData.class, new RequestFunction<ApprovalCancelData>() {
                    public String porcess(ApprovalCancelData data, Vector<ApprovalLineData> approvalLine) throws GeneralException {

                        ApprovalCancelRFC rfc = new ApprovalCancelRFC();
                        Vector approvalCancelVt = new Vector();
                        box.copyToEntity(data);
                        data.PERNR = PERNR;
                        data.BEGDA = DataUtil.getCurrentDate();
                        data.CANC_REASON = box.get("CANC_REASON");
                        data.ORG_AINF_SEQN = AINF_SEQN;
                        data.ORG_UPMU_TYPE = ORG_UPMU_TYPE;
                        data.AEDTM = DataUtil.getCurrentDate();
                        data.ZPERNR = PERNR;
                        data.UNAME = PERNR;
                        data.I_NTM = "X";
                        approvalCancelVt.addElement(data);

                        // UPMU_TYPE = OLD_UPMU_TYPE;
                        rfc.setRequestInput(user.empNo, UPMU_TYPE);
                        String new_AINF_SEQN = rfc.build(data.PERNR, data.AINF_SEQN, approvalCancelVt, box, req);

                        if (!rfc.getReturn().isSuccess() || new_AINF_SEQN == null) {
                            throw new GeneralException(rfc.getReturn().MSGTX);
                        }
                        ;
                        Logger.debug.print("new_AINF_SEQN:" + new_AINF_SEQN);
                        return new_AINF_SEQN;
                    }
                });

                /*
                            } else if( jobid.equals("create") ) {
                            	NumberGetNextRFC  func              = new NumberGetNextRFC();
                            	ApprovalCancelRFC    rfc               = new ApprovalCancelRFC();
                            	Vector approvalCancelVt = new Vector();
                            	Vector appLineDataVt = new Vector();
                            	ApprovalCancelData data = new ApprovalCancelData();
                            	data.AINF_SEQN = func.getNumberGetNext();
                            	data.PERNR = PERNR;
                            	data.BEGDA = DataUtil.getCurrentDate();
                            	data.CANC_REASON = box.get("CANC_REASON");
                            	data.ORG_AINF_SEQN = AINF_SEQN;
                            	data.ORG_UPMU_TYPE = ORG_UPMU_TYPE;
                            	data.AEDTM = DataUtil.getCurrentDate();
                            	data.ZPERNR = PERNR;
                            	data.UNAME = PERNR;

                            	approvalCancelVt.addElement(data);
                            	int rowcount = box.getInt("RowCount");
                            	for( int i = 0; i < rowcount; i++) {
                            		AppLineData appLine = new AppLineData();
                    //String      idx     = Integer.toString(i);

                    // 여러행 자료 입력(Web)
                    box.copyToEntity(appLine ,i);

                    appLine.APPL_MANDT    = user.clientNo;
                    appLine.APPL_BUKRS     = user.companyCode;
                    appLine.APPL_PERNR     = PERNR;
                    appLine.APPL_BEGDA     = data.BEGDA;
                    appLine.APPL_AINF_SEQN = data.AINF_SEQN;
                    appLine.APPL_UPMU_TYPE = UPMU_TYPE;

                    appLineDataVt.addElement(appLine);
                            	}
                            	Logger.debug.println( this, approvalCancelVt.toString() );
                Logger.debug.println( this, "결제라인 : "+appLineDataVt.toString() );
                con = DBUtil.getTransaction();
                AppLineDB appDB    = new AppLineDB(con);
                appDB.create(appLineDataVt);

                Vector          vcRet             = new Vector();
                Logger.debug.println(this, "rfc.build before" );
                rfc.build(data.PERNR, data.AINF_SEQN,  approvalCancelVt, box, req);
                String E_RETURN    = (String)vcRet.get(0);
                String E_MESSAGE = (String)vcRet.get(1);

                Logger.debug.println(this, "E_RETURN : " +E_RETURN );
                Logger.debug.println(this, "E_MESSAGE : " +E_MESSAGE );
                if ( E_RETURN.equals("") ) {
                	con.commit();
                //                	 메일 수신자 사람 ,
                    AppLineData appLine = (AppLineData)appLineDataVt.get(0);

                    Properties ptMailBody = new Properties();
                    ptMailBody.setProperty("SServer",user.SServer);                 // ElOffice 접속 서버
                    ptMailBody.setProperty("from_empNo" ,user.empNo);               // 멜 발송자 사번
                    ptMailBody.setProperty("to_empNo", appLine.APPL_APPU_NUMB);     // 멜 수신자 사번

                    ptMailBody.setProperty("ename" ,user.ename);          // (피)신청자명
                    ptMailBody.setProperty("empno" ,user.empNo);          // (피)신청자 사번

                    ptMailBody.setProperty("UPMU_NAME" ,UPMU_NAME);                 // 문서 이름
                    ptMailBody.setProperty("AINF_SEQN", data.AINF_SEQN);
                    // 신청서 순번
                    // 멜 제목
                    StringBuffer sbSubject = new StringBuffer(512);

                    sbSubject.append("[" + ptMailBody.getProperty("UPMU_NAME") + "] ");
                    sbSubject.append(ptMailBody.getProperty("ename") +"님이 신청하셨습니다.");

                    ptMailBody.setProperty("subject" ,sbSubject.toString());
                    ptMailBody.setProperty("FileName" ,"MbNoticeMailBuild.html");

                    String msg = "msg001";
                    String msg2 = "";

                    MailSendToEloffic  maTe = new MailSendToEloffic(ptMailBody);

                    if (!maTe.process()) {
                        msg2 = maTe.getMessage();
                    } // end if

                    try {
                        DraftDocForEloffice ddfe = new DraftDocForEloffice();

                        ElofficInterfaceData eof = ddfe.makeDocContents(data.AINF_SEQN ,user.SServer,ptMailBody.getProperty("UPMU_NAME"));

                        Vector vcElofficInterfaceData = new Vector();
                        vcElofficInterfaceData.add(eof);
                        //req.setAttribute("vcElofficInterfaceData", vcElofficInterfaceData);
                        //dest = WebUtil.JspURL+"common/ElOfficeInterface.jsp";
                        //통합결재 잦은오류로 인해 서버실행으로 변경함  2012.11.07
                        try {
                        	SendToESB esb = new SendToESB();
                        	String esbmsg = esb.process(vcElofficInterfaceData );
                            Logger.debug.println(this ,"[esbmsg]  :"+esbmsg);
                        	req.setAttribute("message", esbmsg);
                        	dest = WebUtil.JspURL+"common/EsbResult.jsp";
                        } catch (Exception e) {
                        	e.printStackTrace();
                           dest = WebUtil.JspURL+"common/msg.jsp";
                           msg2 = msg2 + "\\n" + " Eloffic 연동 실패" ;
                       }
                    } catch (Exception e) {
                        dest = WebUtil.JspURL+"common/msg.jsp";
                        //msg2 = msg2 + "\\n" + " Eloffic 연동 실패" ;
                        msg = msg + "\\n" + " Eloffic 연동 실패" ;
                    } // end try

                    String url = "location.href = \'" + WebUtil.ServletURL+"hris.D.D01OT.D01OTCancelBuildSV?AINF_SEQN="+AINF_SEQN+"&jobid=after\'";
                    req.setAttribute("msg", msg);
                    req.setAttribute("msg2", msg2);
                    req.setAttribute("url", url);
                } else {
                	con.rollback();
                	String msg = E_MESSAGE;
                	req.setAttribute("", jobid);
                    req.setAttribute("message", msg);
                    dest = WebUtil.ServletURL+"hris.D.D01OT.D01OTCancelBuildSV?AINF_SEQN="+AINF_SEQN+"';";
                }
                */
            } else {
                throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
            } // end if

            Logger.debug.println(this, " destributed = " + dest);
            printJspPage(req, res, dest);

        } catch (Exception e) {
            Logger.err.println(DataUtil.getStackTrace(e));
            throw new GeneralException(e);

        }
    }

    /**
     * RFC 실행 결과로 얻어온 data에서 EXPORT 또는 TABLES data를 추출하여 반환
     *
     * @param rfcResultData
     * @param target
     * @param message
     * @return
     * @throws GeneralException
     */
    private Map<String, Object> getData(Map<String, Object> rfcResultData, String target, String message) throws GeneralException {

        if (!RfcDataHandler.isSuccess(rfcResultData)) {
            throw new GeneralException(message);
        }

        return (Map<String, Object>) rfcResultData.get(target);
    }

}