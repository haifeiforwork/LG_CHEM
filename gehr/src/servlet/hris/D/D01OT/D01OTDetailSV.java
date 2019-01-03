/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS
/*   1Depth Name  : MY HR 정보
/*   2Depth Name  : 초과근무
/*   Program Name : 초과근무 조회
/*   Program ID   : D01OTDetailSV
/*   Description  : 초과근무 조회 및 삭제를 할 수 있도록 하는 Class
/*   Note         :
/*   Creation     : 2002-01-15 박영락
/*   Update       : 2005-03-03 윤정현
/*                  2018-05-17 [WorkTime52] 유정우
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
import com.common.Utils;
import com.common.constant.Area;
import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.RfcDataHandler;
import com.sns.jdf.sap.RfcHandler;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;

import hris.D.D01OT.D01OTData;
import hris.D.D01OT.D01OTRealWorkDATA;
import hris.D.D01OT.rfc.D01OTRFC;
import hris.D.D01OT.rfc.D01OTRealWrokListRFC;
import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.rfc.PersonInfoRFC;

@SuppressWarnings({ "rawtypes", "serial" })
public class D01OTDetailSV extends ApprovalBaseServlet {

    private String UPMU_TYPE = "17";

    private String UPMU_NAME = "초과근무";

    protected String getUPMU_TYPE() {
        return UPMU_TYPE;
    }

    protected String getUPMU_NAME() {
        return UPMU_NAME;
    }

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {

        try {
            final WebUserData user = WebUtil.getSessionUser(req);

            /* start : 국가별 분기처리 */
            if (!user.area.equals(Area.KR)) { // 해외화면으로
                printJspPage(req, res, WebUtil.ServletURL + "hris.D.D01OT.D01OTDetailGlobalSV");
                return;
            }
            /*   end : 국가별 분기처리 */

            Box box = WebUtil.getBox(req);

            final String AINF_SEQN = box.get("AINF_SEQN");
            final String I_APGUB = (String) req.getAttribute("I_APGUB");  // 어느 페이지에서 왔나? '1' : 결재할 문서 , '2' : 결재중 문서 , '3' : 결재완료 문서
            req.setAttribute("APGUB", I_APGUB);

            final D01OTRFC rfc = new D01OTRFC(user.empNo, I_APGUB, AINF_SEQN);

            Vector D01OTData_vt = rfc.getDetail(null, null);

            final D01OTData firstData = (D01OTData) Utils.indexOf(D01OTData_vt, 0);

            // 대리 신청 추가 and 실근무시간 현황표 추가
            if (firstData != null) {
                req.setAttribute("PersonData", new PersonInfoRFC().getPersonInfo(firstData.PERNR));

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
                    if (!"1".equals(I_APGUB) || !user.empNo.equals(firstData.PERNR)) {
                        final String WORK_DATE = StringUtils.defaultString(firstData.WORK_DATE).replaceAll("[^\\d]", "");
                        final String I_DATUM = "X".equals(firstData.VTKEN) ? DataUtil.addDays(WORK_DATE, -1, "yyyyMMdd") : WORK_DATE;

                        // 신청자 사원 구분 조회 : S(사무직) or H(현장직)
                        Map<String, Object> rfcResultData = RfcHandler.execute("ZGHR_RFC_NTM_GET_EMPGUB", new HashMap<String, Object>() {
                            {
                                put("I_PERNR", firstData.PERNR);
                                put("I_DATUM", I_DATUM);
                            }
                        });

                        Map<String, Object> EXPORT = getData(rfcResultData, "EXPORT", g.getMessage("MSG.D.D01.0063"));
                        final String EMPGUB = ObjectUtils.toString(EXPORT.get("E_EMPGUB")); // 실근무시간 현황 조회에 필요한 사원 구분(사무직 or 현장직) 데이터를 조회하지 못하였습니다.
                        req.setAttribute("EMPGUB", EMPGUB);
                        req.setAttribute("TPGUB", EXPORT.get("E_TPGUB"));
                        req.setAttribute("MM", Integer.parseInt(DataUtil.getCurrentMonth()));

                        if ("S".equals(EMPGUB) || ("H".equals(EMPGUB) && !user.empNo.equals(firstData.PERNR))) {
                            // 신청자 실근무시간 현황 조회
                            rfcResultData = RfcHandler.execute("ZGHR_RFC_NTM_OT_REQ_RW_LIST", new HashMap<String, Object>() {
                                {
                                    put("I_EMPGUB", EMPGUB);
                                    put("I_PERNR", firstData.PERNR);
                                    put("I_DATUM", WORK_DATE);
                                    put("I_AINF_SEQN", firstData.AINF_SEQN);
                                    if ("H".equals(EMPGUB)) put("I_VTKEN", firstData.VTKEN);
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
            }

            String dest = null;
            String jobid = box.get("jobid", "first");

            Logger.debug.println(this, "[jobid] = " + jobid + " [user] : " + user.toString());

            if ("first".equals(jobid)) {
                req.setAttribute("D01OTData_vt", D01OTData_vt);

                if (!detailApporval(req, res, rfc)) return;

                dest = WebUtil.JspURL + "D/D01OT/D01OTDetail.jsp";

            } else if ("delete".equals(jobid)) {
                dest = deleteApproval(req, box, rfc, new DeleteFunction() {
                    public boolean porcess() throws GeneralException {

                        // D01OTRFC deleteRFC = new D01OTRFC();
                        rfc.setDeleteInput(user.empNo, UPMU_TYPE, rfc.getApprovalHeader().AINF_SEQN);

                        RFCReturnEntity returnEntity = rfc.delete(AINF_SEQN, firstData.PERNR);

                        if (!returnEntity.isSuccess()) {
                            throw new GeneralException(returnEntity.MSGTX);
                        }

                        return true;
                    }
                });

                /*
                Vector   AppLineData_vt = new Vector();
                AppLineData  appLine = new AppLineData();
                appLine.APPL_MANDT     = user.clientNo;
                appLine.APPL_BUKRS     = user.companyCode;
                appLine.APPL_PERNR     = firstData.PERNR;
                appLine.APPL_UPMU_TYPE = UPMU_TYPE;
                appLine.APPL_AINF_SEQN = ainf_seqn;
                // 2002.07.25.---------------------------------------------------------------
                // 신청건 삭제시 메일 보내기 위해 필요한 결재자 정보를 가져온다.
                // 결재
                int rowcount = box.getInt("RowCount");
                for( int i = 0; i < rowcount; i++) {
                    AppLineData app = new AppLineData();
                    String      idx     = Integer.toString(i);

                    // 같은 이름으로 여러행 받을때
                    box.copyToEntity(app ,i);

                    AppLineData_vt.addElement(app);
                }
                Logger.debug.println(this, "AppLineData : " + AppLineData_vt.toString());
                 */
                // 신청건 삭제시 메일 보내기 위해 필요한 결재자 정보를 가져온다.
                // 2002.07.25.---------------------------------------------------------------

                /*
                con             = DBUtil.getTransaction();
                AppLineDB appDB = new AppLineDB(con);

                if( appDB.canUpdate(appLine) ) {
                    appDB.delete(appLine);
                    rfc.delete( ainf_seqn, firstData.PERNR );
                    con.commit();

                    // 신청건 삭제시 메일 보내기.
                    appLine = (AppLineData)AppLineData_vt.get(0);
                    Properties ptMailBody = new Properties();
                    ptMailBody.setProperty("SServer",user.SServer);              // ElOffice 접속 서버
                    ptMailBody.setProperty("from_empNo" ,user.empNo);            // 멜 발송자 사번
                    ptMailBody.setProperty("to_empNo" ,appLine.APPL_APPU_NUMB);  // 멜 수신자 사번

                    ptMailBody.setProperty("ename" ,phonenumdata.E_ENAME);       // (피)신청자명
                    ptMailBody.setProperty("empno" ,phonenumdata.E_PERNR);       // (피)신청자 사번

                    ptMailBody.setProperty("UPMU_NAME" ,"초과근무");             // 문서 이름
                    ptMailBody.setProperty("AINF_SEQN" ,ainf_seqn);              // 신청서 순번
                    // 신청건 삭제시 메일 보내기.

                    // 멜 제목
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
                        ElofficInterfaceData eof = ddfe.makeDocForRemove(ainf_seqn ,user.SServer ,ptMailBody.getProperty("UPMU_NAME")
                                ,firstData.PERNR ,appLine.APPL_APPU_NUMB);

                        Vector vcElofficInterfaceData = new Vector();
                        vcElofficInterfaceData.add(eof);
                        Logger.info.println(this ,"^^^^^ D01OTDetailSV Remove</b>[eof:]"+eof.toString());

                        req.setAttribute("vcElofficInterfaceData", vcElofficInterfaceData);
                        dest = WebUtil.JspURL+"common/ElOfficeInterface.jsp";
                    } catch (Exception e) {
                        dest = WebUtil.JspURL+"common/msg.jsp";
                        msg2 = msg2 + "\\n" + " Eloffic 연동 실패" ;
                    } // end try

                    String msg = "msg003";
                    String url ;

                    //  삭제 실행후 삭제전 페이지로 이동하기 위한 구분
                    //  삭제 실행후 삭제전 페이지로 이동하기 위한 구분
                    req.setAttribute("msg", msg);
                    req.setAttribute("url", url);
                } else {
                    String msg = "msg005";
                    String url = "location.href = '" + WebUtil.ServletURL+"hris.D.D01OT.D01OTDetailSV?AINF_SEQN="+ainf_seqn+"';";
                    req.setAttribute("msg", msg);
                    dest = WebUtil.JspURL+"common/msg.jsp";
                }
                */
            } else {
                throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
            }

            Logger.debug.println(this, " destributed = " + dest);
            printJspPage(req, res, dest);

        } catch (Exception e) {
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