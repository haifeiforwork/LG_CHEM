/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : 결재완료 문서                                               */
/*   2Depth Name  :                                                             */
/*   Program Name : 휴가 결재완료                                               */
/*   Program ID   : F02DeptPositionDutySV                                       */
/*   Description  : 휴가 결재완료 조회를 위한 서블릿                            */
/*   Note         : 없음                                                        */
/*   Creation     : 2005-03-10 유용원                                           */
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

import com.common.RFCReturnEntity;
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
import hris.common.PersInfoData;
import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalHeader;
import hris.common.approval.ApprovalLineData;
import hris.common.rfc.PersInfoWithNoRFC;
import hris.common.util.AppUtil;

@SuppressWarnings({ "rawtypes", "serial" })
public class D01OTCancelChangeSV extends ApprovalBaseServlet {

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

            String dest = WebUtil.JspURL + "D/D01OT/D01OTCancelChange.jsp";

            final Box box = WebUtil.getBox(req);
            final String jobid = box.get("jobid", "first");
            final String AINF_SEQN = box.get("AINF_SEQN");
            final String I_APGUB = (String) req.getAttribute("I_APGUB") == null ? box.get("I_APGUB") : (String) req.getAttribute("I_APGUB");  // 어느 페이지에서 왔나? '1' : 결재할 문서 , '2' : 결재중 문서 , '3' : 결재완료 문서
            req.setAttribute("I_APGUB", I_APGUB);	//WorkTime52 추가

            // 초과근무결재취소조회
            final ApprovalCancelRFC appRfc = new ApprovalCancelRFC();
            appRfc.setDetailInput(user.empNo, I_APGUB, AINF_SEQN);
            Vector appCancelVt = appRfc.get(user.empNo, AINF_SEQN);
            final String PERNR = appRfc.getApprovalHeader().PERNR; // box.get("PERNR", user.empNo);

            req.setAttribute("isUpdate", false); // 조회상태

            if (jobid.equals("changeMode")) {
                req.setAttribute("isUpdate", true); // 수정상태
            }

            if (jobid.equals("first") || jobid.equals("changeMode")) {

                if (appCancelVt.size() > 0) {
                    ApprovalCancelData appData = (ApprovalCancelData) appCancelVt.get(0);
                    // 결재한 초과근무조회
                    String ORG_AINF_SEQN = appData.ORG_AINF_SEQN;
                    // 초과근무
                    D01OTRFC otRfc = new D01OTRFC();
                    otRfc.setDetailInput(user.empNo, I_APGUB, ORG_AINF_SEQN);
                    Vector d01OTData_vt = otRfc.getDetail(ORG_AINF_SEQN, PERNR);

                    if (!detailApporval(req, res, appRfc))
                        return; // ** 주의: 반드시 취소결재번호의 결재상태 **/

                    if (d01OTData_vt.size() < 1) {
                        String msg = "System Error! \n\n 조회할 항목이 없습니다.";
                        req.setAttribute("msg", msg);
                        dest = WebUtil.JspURL + "common/caution.jsp";
                    } else {

                        // ORG결재자 정보
                        Vector orgVcAppLineData = AppUtil.getAppChangeVt(ORG_AINF_SEQN);
                        // 결재 정보.
                        PersInfoWithNoRFC piRfc = new PersInfoWithNoRFC();
                        PersInfoData pid = (PersInfoData) piRfc.getApproval(PERNR).get(0);

                        // 원결재정보
                        final D01OTData d01OTData = (D01OTData) d01OTData_vt.get(0);

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

                        req.setAttribute("d01OTData", d01OTData);
                        req.setAttribute("PersInfoData", pid);
                        req.setAttribute("orgVcAppLineData", orgVcAppLineData);
                        req.setAttribute("appCancelVt", appCancelVt);
                    } // end if

                }

            } else if (jobid.equals("change")) {

                dest = changeApproval(req, box, ApprovalCancelData.class, appRfc, new ChangeFunction<ApprovalCancelData>() {
                    public String porcess(ApprovalCancelData cngData, ApprovalHeader approvalHeader, Vector<ApprovalLineData> approvalLineDatas) throws GeneralException {

                        // 수정
                        box.copyToEntity(cngData);
                        cngData.AINF_SEQN = AINF_SEQN;
                        cngData.PERNR = PERNR;
                        cngData.BEGDA = box.get("BEGDA");
                        cngData.ORG_AINF_SEQN = box.get("ORG_AINF_SEQN");
                        cngData.ORG_BEGDA = box.get("ORG_BEGDA");
                        cngData.ORG_UPMU_TYPE = box.get("ORG_UPMU_TYPE");
                        cngData.AEDTM = DataUtil.getCurrentDate();
                        cngData.ZPERNR = PERNR;
                        cngData.UNAME = PERNR;
                        // 결재프로세스에 맞춰 추가라인
                        cngData.APPL_TO = box.get("ORG_BEGDA");
                        cngData.APPL_FROM = box.get("ORG_BEGDA");
                        cngData.APPL_REAS = box.get("CANC_REASON");

                        cngData.CANC_REASON = box.get("CANC_REASON");
                        Vector changeVt = new Vector();
                        changeVt.add(cngData);
                        appRfc.setChangeInput(user.empNo, UPMU_TYPE, approvalHeader.AINF_SEQN);
                        appRfc.change(PERNR, AINF_SEQN, changeVt, box, req);

                        if (!appRfc.getReturn().isSuccess()) {
                            req.setAttribute("msg", appRfc.getReturn().MSGTX);   // 실패 메세지 처리 - 임시
                            return null;
                        }
                        return AINF_SEQN;

                    }
                });
                /*
                  	//수정
                  	ApprovalCancelData cngData = new ApprovalCancelData();
                  	cngData.AINF_SEQN = AINF_SEQN;
                  	cngData.PERNR = PERNR;
                  	cngData.BEGDA = box.get("BEGDA");
                  	cngData.ORG_AINF_SEQN = box.get("ORG_AINF_SEQN");
                  	cngData.ORG_BEGDA = box.get("ORG_BEGDA");
                  	cngData.ORG_UPMU_TYPE = box.get("ORG_UPMU_TYPE");
                  	cngData.AEDTM = DataUtil.getCurrentDate();
                  	cngData.ZPERNR = PERNR;
                  	cngData.UNAME = PERNR;

                  	cngData.CANC_REASON = box.get("CANC_REASON");
                  	Vector changeVt = new Vector();
                  	changeVt.add(cngData);

                  	int rowcount = box.getInt("RowCount");
                for( int i = 0; i < rowcount; i++) {
                    AppLineData appLine = new AppLineData();
                    String      idx     = Integer.toString(i);
                    appLine.APPL_MANDT     = user.clientNo;
                    appLine.APPL_BUKRS     = user.companyCode;
                    appLine.APPL_AINF_SEQN = AINF_SEQN;
                    appLine.APPL_UPMU_FLAG = box.get("APPL_UPMU_FLAG"+idx);
                    appLine.APPL_UPMU_TYPE = UPMU_TYPE;
                    appLine.APPL_APPR_TYPE = box.get("APPL_APPR_TYPE"+idx);
                    appLine.APPL_APPU_TYPE = box.get("APPL_APPU_TYPE"+idx);
                    appLine.APPL_APPR_SEQN = box.get("APPL_APPR_SEQN"+idx);
                    appLine.APPL_OTYPE     = box.get("APPL_OTYPE"+idx);
                    appLine.APPL_OBJID     = box.get("APPL_OBJID"+idx);
                    appLine.APPL_APPU_NUMB = box.get("APPL_APPU_NUMB"+idx);
                    //**********수정 시작 (20050223:유용원)**********
                    appLine.APPL_PERNR     = PERNR;
                    appLine.APPL_BEGDA     = cngData.BEGDA;
                    //**********수정 끝.****************************
                    appLine.APPL_BEGDA = appLine.APPL_BEGDA.replaceAll("-","");
                    appLineVt.addElement(appLine);
                }
                Logger.debug.println( this, cngData.toString() );
                Logger.debug.println( this, "결제라인 : "+appLineVt.toString() );

                con = DBUtil.getTransaction();
                AppLineDB appDB    = new AppLineDB(con);
                String msg  = null;
                String msg2 = null;
                if( appDB.canUpdate((AppLineData)appLineVt.get(0)) ) {
                	Logger.debug.println( this, " D03VocationCancel appDB.change :appLineVt "+appLineVt.toString() );
                    // 기존 결재자 리스트
                    Vector orgAppLineData_vt = AppUtil.getAppChangeVt(AINF_SEQN);
                    appDB.change(appLineVt);
                    Vector          ret             = new Vector();
                   appRfc.change(PERNR, AINF_SEQN, changeVt, box, req);
                    Logger.debug.println( this, " D03VocationCancel appRfc.change :changeVt "+changeVt.toString() );
                    //C20111025_86242 체크메세지 추가
                    String E_RETURN    = (String)ret.get(0);
                    String E_MESSAGE = (String)ret.get(1);

                    Logger.debug.println(this, "E_RETURN : " +E_RETURN );
                    Logger.debug.println(this, "E_MESSAGE : " +E_MESSAGE );

                    if ( E_RETURN.equals("") ) {
                        con.commit();
                        msg = "msg002";
                        AppLineData oldAppLine = (AppLineData) orgAppLineData_vt.get(0);
                        AppLineData newAppLine = (AppLineData) appLineVt.get(0);
                       Logger.debug.println(this ,oldAppLine);
                        Logger.debug.println(this ,newAppLine);

                        if (!newAppLine.APPL_APPU_NUMB.equals(oldAppLine.APPL_PERNR)) {
                            // 이메일 보내기
                            Properties ptMailBody = new Properties();
                            ptMailBody.setProperty("SServer",user.SServer);                 // ElOffice 접속 서버
                            ptMailBody.setProperty("from_empNo" ,user.empNo);               // 멜 발송자 사번
                            ptMailBody.setProperty("to_empNo" ,oldAppLine.APPL_PERNR);      // 멜 수신자 사번
                            ptMailBody.setProperty("ename" ,user.ename);          // (피)신청자명
                            ptMailBody.setProperty("empno" ,user.empNo);          // (피)신청자 사번
                            ptMailBody.setProperty("UPMU_NAME" , UPMU_NAME);                    // 문서 이름
                            ptMailBody.setProperty("AINF_SEQN" ,AINF_SEQN);                 // 신청서 순번

                            //                          멜 제목
                            StringBuffer sbSubject = new StringBuffer(512);

                            sbSubject.append("[" + ptMailBody.getProperty("UPMU_NAME") + "] ");
                            sbSubject.append( ptMailBody.getProperty("ename") + "님이 신청을 삭제하셨습니다.");
                            ptMailBody.setProperty("subject" ,sbSubject.toString());

                            ptMailBody.setProperty("FileName" ,"NoticeMail5.html");

                            MailSendToEloffic   maTe = new MailSendToEloffic(ptMailBody);
                            // 기존 결재자 멜 전송
                            if (!maTe.process()) {
                                msg2 = msg2 + " 삭제 " + maTe.getMessage();
                            } // end if

                            // 멜 제목
                            sbSubject = new StringBuffer(512);
                            sbSubject.append("[" + ptMailBody.getProperty("UPMU_NAME") + "] ");
                            sbSubject.append(ptMailBody.getProperty("ename") +"님이 신청하셨습니다.");

                            ptMailBody.setProperty("subject" ,sbSubject.toString());
                            ptMailBody.remove("FileName");
                            ptMailBody.setProperty("to_empNo" ,newAppLine.APPL_APPU_NUMB);

                            maTe = new MailSendToEloffic(ptMailBody);
                            // 신규 결재자 멜 전송
                            if (!maTe.process()) {
                                msg2 = msg2 +" \\n 신청 " + maTe.getMessage();
                            } // end if

                            // ElOffice 인터페이스
                            try {
                                DraftDocForEloffice ddfe = new DraftDocForEloffice();
                                ElofficInterfaceData eof = ddfe.makeDocForChange(AINF_SEQN ,user.SServer , PERNR, ptMailBody.getProperty("UPMU_NAME") , oldAppLine.APPL_PERNR);

                                Logger.debug.println(this, "makeDocForChange AINF_SEQN:"+AINF_SEQN+"oldAppLine.APPL_PERNR = " + oldAppLine.APPL_PERNR);
                                Vector vcElofficInterfaceData = new Vector();
                                vcElofficInterfaceData.add(eof);

                                ElofficInterfaceData eofD = ddfe.makeDocContents(AINF_SEQN ,user.SServer,ptMailBody.getProperty("UPMU_NAME"));
                                vcElofficInterfaceData.add(eofD);
                //                              통합결재 잦은오류로 인해 서버실행으로 변경함  2012.11.07
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
                                msg2 = msg2 + "\\n" + " Eloffic 연동 실패" ;
                            } // end try
                        } else {
                            msg = "msg002";
                            dest = WebUtil.JspURL+"common/msg.jsp";
                        } // end if

                    } else {
                    	con.rollback();
                        msg = E_MESSAGE;
                        dest = WebUtil.ServletURL+"hris.D.D01OT.D01OTCancelChangeSV?AINF_SEQN="+AINF_SEQN+"&msg="+msg+"&RequestPageName=" + RequestPageName + "';";
                 }
                } else {
                    msg = "msg005";
                    dest = WebUtil.JspURL+"common/msg.jsp";
                } // end if

                String url = "location.href = '" + WebUtil.ServletURL+"hris.D.D01OT.D01OTCancelChangeSV?AINF_SEQN="+AINF_SEQN+
                "&RequestPageName=" + RequestPageName + "';";
                req.setAttribute("msg", msg);
                req.setAttribute("msg2", msg2);
                req.setAttribute("url", url);
                */
            } else if (jobid.equals("delete")) {

                dest = deleteApproval(req, box, appRfc, new DeleteFunction() {
                    public boolean porcess() throws GeneralException {

                        // D01OTRFC deleteRFC = new D01OTRFC();
                        appRfc.setDeleteInput(user.empNo, UPMU_TYPE, appRfc.getApprovalHeader().AINF_SEQN);

                        RFCReturnEntity returnEntity = appRfc.delete(PERNR, AINF_SEQN);

                        if (!returnEntity.isSuccess()) {
                            throw new GeneralException(returnEntity.MSGTX);
                        }

                        return true;
                    }
                });
                /*
                //              신청건 삭제시 메일 보내기 위해 필요한 결재자 정보를 가져온다.
                //              결재
                int rowcount = box.getInt("RowCount");
                for( int i = 0; i < rowcount; i++) {
                    AppLineData app = new AppLineData();
                    String      idx     = Integer.toString(i);

                    app.APPL_APPR_SEQN = box.get("APPL_APPR_SEQN"+idx);
                    app.APPL_APPU_TYPE = box.get("APPL_APPU_TYPE"+idx);
                    app.APPL_APPU_NUMB = box.get("APPL_APPU_NUMB"+idx);

                    appLineVt.addElement(app);
                }
                Logger.debug.println(this, "AppLineData : " + appLineVt.toString());
                //              신청건 삭제시 메일 보내기 위해 필요한 결재자 정보를 가져온다.
                con             = DBUtil.getTransaction();
                AppLineDB appDB = new AppLineDB(con);
                //              결재정보 삭제..
                AppLineData  appLine = new AppLineData();
                appLine.APPL_MANDT     = user.clientNo;
                appLine.APPL_BUKRS     = user.companyCode;
                appLine.APPL_PERNR     = PERNR;
                appLine.APPL_UPMU_TYPE = UPMU_TYPE;
                appLine.APPL_AINF_SEQN = box.get("AINF_SEQN");

                if( appDB.canUpdate(appLine) ) {
                    appDB.delete(appLine);
                //                  삭제
                            		appRfc.delete(PERNR, AINF_SEQN);
                    con.commit();

                    //**********수정 시작 (20050223:유용원)**********
                    // 신청건 삭제시 메일 보내기.
                    appLine = (AppLineData)appLineVt.get(0);

                    //결재자 변경시 멜 보내기 ,ElOffice 인터 페이스
                    Properties ptMailBody = new Properties();

                    ptMailBody.setProperty("SServer",user.SServer);                 // ElOffice 접속 서버
                    ptMailBody.setProperty("from_empNo" ,user.empNo);               // 멜 발송자 사번
                    ptMailBody.setProperty("to_empNo" ,appLine.APPL_APPU_NUMB);     // 멜 수신자 사번
                    ptMailBody.setProperty("ename" ,user.ename);          // (피)신청자명
                    ptMailBody.setProperty("empno" ,user.empNo);          // (피)신청자 사번
                    ptMailBody.setProperty("UPMU_NAME" , UPMU_NAME);                    // 문서 이름
                    ptMailBody.setProperty("AINF_SEQN" ,AINF_SEQN);                 // 신청서 순번

                    //멜 제목
                    StringBuffer sbSubject = new StringBuffer(512);

                    sbSubject.append("[" + ptMailBody.getProperty("UPMU_NAME") + "] ");
                    sbSubject.append( ptMailBody.getProperty("ename") + "님이 신청을 삭제하셨습니다.");
                    ptMailBody.setProperty("subject" ,sbSubject.toString());    // 멜 제목 설정

                    ptMailBody.setProperty("FileName" ,"NoticeMail5.html");

                    MailSendToEloffic   maTe = new MailSendToEloffic(ptMailBody);

                    String msg2 = null;
                    if (!maTe.process()) {
                        msg2 = maTe.getMessage();
                    } // end if

                    try {
                        DraftDocForEloffice ddfe = new DraftDocForEloffice();
                        ElofficInterfaceData eof = ddfe.makeDocForRemove(AINF_SEQN ,user.SServer ,ptMailBody.getProperty("UPMU_NAME")
                                ,PERNR ,appLine.APPL_APPU_NUMB);

                        Vector vcElofficInterfaceData = new Vector();
                        vcElofficInterfaceData.add(eof);
                //                      통합결재 잦은오류로 인해 서버실행으로 변경함  2012.11.07
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
                        msg2 = msg2 + "\\n" + " Eloffic 연동 실패" ;
                    } // end try

                    String msg = "msg003";
                    String url ;

                    //  삭제 실행후 삭제전 페이지로 이동하기 위한 구분
                    if(RequestPageName != null &&  !RequestPageName.equals("") ){
                        url = "location.href = '" + RequestPageName.replace('|','&') + "';";
                    } else {
                        url = "location.href = '" + WebUtil.ServletURL+"hris.D.D01OT.D01OTCancelChangeSV?AINF_SEQN="+AINF_SEQN+"&RequestPageName=" + RequestPageName + "';";
                    } // end if
                    //**********수정 끝.****************************

                    req.setAttribute("msg", msg);
                    req.setAttribute("url", url);
                } else {
                    String msg = "msg005";
                    String url = "location.href = '" + WebUtil.ServletURL+"hris.D.D01OT.D01OTCancelChangeSV?AINF_SEQN="+AINF_SEQN+"&RequestPageName=" + RequestPageName + "';";
                    req.setAttribute("msg", msg);
                    req.setAttribute("url", url);
                    dest = WebUtil.JspURL+"common/msg.jsp";
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
        } finally {

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