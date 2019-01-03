/********************************************************************************/
/*                                                                              */
/*   System Name      : MSS                                                     */
/*   1Depth Name      : MY HR 정보                                              */
/*   2Depth Name      : 초과근무  사후신청                                      */
/*   Program Name     : 초과근무  사후신청                                      */
/*   Program ID       : D01OTAfterWprlBuildSV                                   */
/*   Description      : 초과근무(OT/특근)신청을 하는 Class                      */
/*   Note             :                                                         */
/*   Creation         : 2018-06-12  강동민 [worktime52 PJT]                     */
/*   Update           :                                                         */
/*                                                                              */
/********************************************************************************/
package servlet.hris.D.D01OT;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.ObjectUtils;
import org.apache.commons.lang.StringUtils;

import com.common.AjaxResultMap;
import com.common.constant.Area;
import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.RfcDataHandler;
import com.sns.jdf.sap.RfcHandler;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;

import hris.D.D01OT.D01OTAfterWorkTimeDATA;
import hris.D.D01OT.D01OTData;
import hris.D.D01OT.D01OTRealWorkDATA;
import hris.D.D01OT.rfc.D01OTAFCheckRFC;
import hris.D.D01OT.rfc.D01OTAFRFC;
import hris.D.D01OT.rfc.D01OTAfterWorkPercheckRFC;
import hris.D.D01OT.rfc.D01OTAfterWorkTimeListRFC;
import hris.D.D01OT.rfc.D01OTRealWrokListRFC;
import hris.D.D03Vocation.rfc.D03ShiftCheckRFC;
import hris.D.rfc.D02KongsuHourRFC;
import hris.D.rfc.D16OTHDDupCheckRFC2;
import hris.common.EmpGubunData;
import hris.common.PersonData;
import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalLineData;
import hris.common.rfc.GetEmpGubunRFC;
import hris.common.rfc.PersonInfoRFC;

@SuppressWarnings({ "rawtypes", "serial" })
public class D01OTAfterWorkBuildSV extends ApprovalBaseServlet {

    private String UPMU_TYPE = "44";
    private String UPMU_NAME = "초과근무 사후신청";

    protected String getUPMU_TYPE() {
        return UPMU_TYPE;
    }

    protected String getUPMU_NAME() {
        return UPMU_NAME;
    }

    protected void performTask(final HttpServletRequest req, final HttpServletResponse res) throws GeneralException {

        try {
            final WebUserData user = WebUtil.getSessionUser(req);
            final Box box = WebUtil.getBox(req);

            /************** Start: 국가별 분기처리 **********************************************************/
            if (!user.area.equals(Area.KR)) {     // 해외화면으로
                printJspPage(req, res, WebUtil.ServletURL + "hris.D.D01OT.D01OTBuildGlobalSV");
                return;
            }
            /************** END: 국가별 분기처리 **********************************************************/

            String dest = "";
            String jobid = box.get("jobid", "first");
            boolean isUpdate = box.getBoolean("isUpdate");

            // WorkTime52 Start
            String GTYPE = "";
            String EMPGUB = "";
            String TPGUB = "";
            // WorkTime52 End

            Logger.debug.println(this, "[isUpdate] = " + isUpdate);
            Logger.debug.println(this, "[jobid] = " + jobid + " [user] : " + user.toString());

            final String PERNR = getPERNR(box, user); // 신청대상자 사번

            // 대리 신청 추가
            final PersonData phonenumdata = new PersonInfoRFC().getPersonInfo(PERNR);
            req.setAttribute("PersonData", phonenumdata);
            req.setAttribute("isUpdate", isUpdate); // [결재]등록 수정 여부 <- 수정쪽에는 반드시 필요함
            req.setAttribute("PERNR", PERNR);
            req.setAttribute("committed", "N");     // check already response 2017/1/3 ksc

            final String curdate = DataUtil.getCurrentDate();

            /*************************************************************************************/
            if (jobid.equals("first")) {

                // 결재라인, 결재 헤더 정보 조회
                getApprovalInfo(req, PERNR);    // <-- 반드시 추가

                Vector D01OTData_vt = new Vector();
                D01OTData data = new D01OTData();

                box.copyToEntity(data);
                data.PERNR = PERNR;
                DataUtil.fixNull(data);

                D01OTData_vt.addElement(data);  // 정보를 클라이언트로 되돌린다.
                req.setAttribute("D01OTData_vt", D01OTData_vt);

                req.setAttribute("jobid", jobid);

                /*************************************************************************************/

                // 사원 구분 조회(사무직:S / 현장직:H) => [변경 :2018-06-07 : A(사무직-일반), B(현장직-일반), C(사무직-선택근로제), D(현장직-탄력근로제)
                GetEmpGubunRFC empGubunRFC = new GetEmpGubunRFC();
                Vector<EmpGubunData> tpInfo = empGubunRFC.getEmpGubunData(PERNR);
                if (empGubunRFC.getReturn().isSuccess()) EMPGUB = tpInfo.get(0).getEMPGUB();
                if (empGubunRFC.getReturn().isSuccess()) TPGUB = tpInfo.get(0).getTPGUB();

                final String I_DATE = (req.getParameter("DATUM") == null || req.getParameter("DATUM").equals("")) ? curdate : req.getParameter("DATUM");
                final String I_VTKEN = ObjectUtils.toString(req.getAttribute("VTKEN"));

                // 실근무시간 조회[info Table]
                D01OTRealWrokListRFC realworkfunc = new D01OTRealWrokListRFC();
                // 실근무/신청가능...
                D01OTAfterWorkTimeListRFC rfcaf = new D01OTAfterWorkTimeListRFC();
                String MODE = "";
                GTYPE = "1";    // 처리구분( 1 =상세 , 2 =결재의뢰, 3 =수정, 4 = 삭제 )

                if (EMPGUB.equals("S")) {    // 사무직-일반
                    MODE = "";
                    final D01OTRealWorkDATA WorkData = realworkfunc.getResult(EMPGUB, PERNR, I_DATE, I_VTKEN, data.AINF_SEQN, MODE);
                    final D01OTAfterWorkTimeDATA AfterData = rfcaf.getResult(GTYPE, PERNR, I_DATE, I_VTKEN, data.AINF_SEQN, curdate, "");

                    if (realworkfunc.getReturn().isSuccess()) {
                        req.setAttribute("WorkData", WorkData); // 나중에
                    } else {
                        Logger.debug.println(this, "실근무시간 조회 에러!!");
                    }

                    if (rfcaf.getReturn().isSuccess()) {
                        req.setAttribute("AfterData", AfterData); // 나중에
                    } else {
                        Logger.debug.println(this, "AF 실근무시간 조회 에러!!");
                    }

                    Logger.debug.println(this, "WorkData[사무직] : " + WorkData.toString());
                    Logger.debug.println(this, "AfterData[사무직 사후근로신청 실근무정보] : " + AfterData.toString());

                    req.setAttribute("EMPGUB", EMPGUB);
                    req.setAttribute("TPGUB", TPGUB);
                    req.setAttribute("DATUM", I_DATE);

                }

                Logger.debug.println(this, "[first] EMPGUB        : " + EMPGUB);
                Logger.debug.println(this, "[first] TGUB         : " + TPGUB);
                Logger.debug.println(this, "[first] MODE        : " + MODE);
                Logger.debug.println(this, "[first] DATUM        : " + I_DATE);

                dest = WebUtil.JspURL + "D/D01OT/D01OTAfterWorkBuild_KR.jsp";

                /*************************************************************************************/
            } else if (jobid.equals("ajax")) {

                String I_TPGUB = "";
                GetEmpGubunRFC empGubunRFC = new GetEmpGubunRFC();
                Vector<EmpGubunData> tpInfo = empGubunRFC.getEmpGubunData(PERNR);

                // 실근무시간 조회
                if (empGubunRFC.getReturn().isSuccess()) {
                    I_TPGUB = tpInfo.get(0).getTPGUB();
                }

                final String I_EMPGUB = req.getParameter("I_EMPGUB");
                final String I_GTYPE = StringUtils.defaultIfEmpty(req.getParameter("GTYPE"), "1"); // 처리구분( 1 =상세 , 2 =결재의뢰, 3 =수정, 4 = 삭제 )
                final String I_DATUM = StringUtils.defaultIfEmpty(req.getParameter("DATUM"), curdate);
                final String AINF_SEQN = req.getParameter("AINF_SEQN");

                Logger.debug.println(this, "ajax-DATE : " + I_DATUM);

                // 실근로시간 조회 - info
                D01OTRealWrokListRFC realworkfunc01 = new D01OTRealWrokListRFC();
                // 실근무/신청가능시간.
                final D01OTAfterWorkTimeListRFC rfcaf = new D01OTAfterWorkTimeListRFC();

                if (I_EMPGUB.equals("S")) { // 사무직
                    final D01OTRealWorkDATA worklistdata = realworkfunc01.getResult(I_EMPGUB, PERNR, I_DATUM, "", AINF_SEQN, "");
                    final D01OTAfterWorkTimeDATA AfterData = rfcaf.getResult(I_GTYPE, PERNR, I_DATUM, "", AINF_SEQN, curdate, "");

                    Logger.debug.println(this, "worklistdata[사무직-ajax] : " + worklistdata.toString());
                    Logger.debug.println(this, "AfterData[사무직-ajax] : " + AfterData.toString());

                    // 평일/휴일/공휴일 조회
                    Map<String, Object> rfcResultData = RfcHandler.execute("ZGHR_RFC_NTM_WORKDAY_LIST", new HashMap<String, Object>() {
                        {
                            put("I_EMPGUB", I_EMPGUB);
                            put("I_PERNR", PERNR);
                            put("I_BEGDA", I_DATUM);
                            put("I_ENDDA", I_DATUM);
                        }
                    });

                    req.setAttribute("EMPGUB", I_EMPGUB);
                    req.setAttribute("TPGUB", I_TPGUB);
                    req.setAttribute("DATUM", I_DATUM);

                    List HolidayList = (List) getData(rfcResultData, "TABLES", g.getMessage("MSG.D.D01.0063")).get("T_WLIST");
                    final String Holidaycheck01 = (String) ((Map) HolidayList.get(0)).get("HOLID");    // 공휴일 X
                    final String Holidaycheck02 = (String) ((Map) HolidayList.get(0)).get("SOLLZ");    // 비근무일 0

                    // 일근직체크
                    D03ShiftCheckRFC func_shift = new D03ShiftCheckRFC();
                    final String shiftCheck = func_shift.check(PERNR, I_DATUM);    // D:일근직,1:장치교대조
                    Logger.debug.println(this, "[ajax] shiftCheck ::  " + shiftCheck);

                    new AjaxResultMap().addResult(new HashMap<String, Object>() {
                        {
                            put("MSGTY", rfcaf.getReturn().MSGTY);
                            put("MSGTX", rfcaf.getReturn().MSGTX);

                            // 근무시간 현황표
                            put("E_BASTM", worklistdata.BASTM);    // 기본근무
                            put("E_MAXTM", worklistdata.MAXTM);    // 법정최대한도
                            put("E_PWDWK", worklistdata.PWDWK);    // 평일근로시간-개인입력
                            put("E_PWEWK", worklistdata.PWEWK);    // 평일근로시간-회사인정
                            put("E_CWDWK", worklistdata.CWDWK);    // 주말휴일근무시간-개인
                            put("E_CWEWK", worklistdata.CWEWK);    // 주말휴일근무시간-회사인정
                            put("E_PWTOT", worklistdata.PWTOT);    // 계-개인
                            put("E_CWTOT", worklistdata.CWTOT);    // 계-회사
                            put("E_RWKTM", worklistdata.RWKTM);    // 실근무시간

                            // 실근무시간
                            put("E_CSTDAZ", AfterData.CSTDAZ);        // 업무
                            put("E_CAREWK", AfterData.CAREWK);        // 업무재개
                            put("E_CTOTAL", AfterData.CTOTAL);        // 합계

                            // 사후신청가능시간
                            put("E_CRQPST", AfterData.CRQPST);

                            // 신청유형
                            put("E_NRFLGG", AfterData.NRFLGG);        // 정상초과 신청가능 flag
                            put("E_R01FLG", AfterData.R01FLG);        // 업무재개1 신청가능 flag
                            put("E_R02FLG", AfterData.R02FLG);        // 업무재개2 신청가능 flag

                            // 정상초과 신청가능시
                            put("E_STDAZ", AfterData.STDAZ);          // 근무시간
                            put("E_NRQPST", AfterData.NRQPST);        // 근무시간 신청가능시간
                            put("E_CPDABS", AfterData.CPDABS);        // 휴게/비근무시간 Text
                            put("E_PDABS", AfterData.PDABS);          // 휴게/비근무시간

                            // 업무재개1 또는 업무재개2 신청가능시
                            put("E_AREWK01", AfterData.AREWK01);      // 업무재개시간1
                            put("E_AREWK02", AfterData.AREWK02);      // 업무재개시간2
                            put("E_RRQPST", AfterData.RRQPST);        // 업무재개시간 신청가능시간

                            // 정상초과 선택시
                            put("E_BEGUZ", AfterData.BEGUZ);          // 시간 - 시작
                            put("E_ENDUZ", AfterData.ENDUZ);          // 시간 - 종료
                            // 업무재개1 선택시
                            put("E_ABEGUZ01", AfterData.ABEGUZ01);    // 업무재개시간1 - 시작
                            put("E_AENDUZ01", AfterData.AENDUZ01);    // 업무재개시간1 - 종료
                            // 업무재개2 선택시
                            put("E_ABEGUZ02", AfterData.ABEGUZ02);    // 업무재개시간2 - 시작
                            put("E_AENDUZ02", AfterData.AENDUZ02);    // 업무재개시간2 - 종료

                            put("E_HOLID", Holidaycheck01);        // 공휴일
                            put("E_SOLLZ", Holidaycheck02);        // 비근무일
                            put("E_SHIFT", shiftCheck);            // 일근직/4조3교대

                        }
                    }).writeJson(res);
                }

                return;

                /*************************************************************************************/
            } else if (jobid.equals("check")) {
                checkCommon(box, PERNR, user, req);
                req.setAttribute("jobid", jobid);

                // 사원 구분 조회
                // Map<String, Object> rfcResultData = RfcHandler.execute("ZGHR_RFC_NTM_GET_EMPGUB", new HashMap<String, Object>() {
                // {
                // put("I_PERNR" , PERNR);
                // }
                // });
                // final String EMPGUB = ObjectUtils.toString(getData(rfcResultData, "EXPORT", g.getMessage("MSG.D.D01.0063")).get("E_EMPGUB")); //(사무직:S / 현장직:H)
                // final String TPGUB = ObjectUtils.toString(getData(rfcResultData, "EXPORT", g.getMessage("MSG.D.D01.0063")).get("E_TPGUB")); //A(사무직-일반), B(현장직-일반), C(사무직-선택근로제), D(현장직-탄력근로제)

                GetEmpGubunRFC empGubunRFC = new GetEmpGubunRFC();
                Vector<EmpGubunData> tpInfo = empGubunRFC.getEmpGubunData(PERNR);
                if (empGubunRFC.getReturn().isSuccess())
                    EMPGUB = tpInfo.get(0).getEMPGUB();
                if (empGubunRFC.getReturn().isSuccess())
                    TPGUB = tpInfo.get(0).getTPGUB();

                final String I_DATE = ObjectUtils.toString(req.getAttribute("WORK_DATE"));    // req.getParameter("DATUM");
                final String I_VTKEN = ObjectUtils.toString(req.getAttribute("VTKEN"));
                final String I_AINF_SEQN = ObjectUtils.toString(req.getAttribute("AINF_SEQN"));

                Logger.debug.println(this, "EMPGUB >> " + EMPGUB);
                Logger.debug.println(this, "TPGUB >> " + TPGUB);
                Logger.debug.println(this, "I_DATE >> " + I_DATE);

                D01OTRealWrokListRFC realworkfunc = new D01OTRealWrokListRFC();

                if (EMPGUB.equals("S")) {    // 사무직
                    String MODE = "";

                    final D01OTRealWorkDATA WorkData = realworkfunc.getResult(EMPGUB, PERNR, I_DATE, I_VTKEN, I_AINF_SEQN, MODE);
                    if (realworkfunc.getReturn().isSuccess()) {
                        req.setAttribute("WorkData", WorkData); // 나중에
                    } else {
                        req.setAttribute("WorkData", "");
                        Logger.debug.println(this, "실근무시간 조회 에러!!");
                    }
                }

                req.setAttribute("DATUM", I_DATE);
                req.setAttribute("EMPGUB", EMPGUB);
                req.setAttribute("TPGUB", TPGUB);

                dest = WebUtil.JspURL + "D/D01OT/D01OTAfterWorkBuild_KR.jsp";

                /*************************************************************************************/
            } else if (jobid.equals("create")) {    // 결재의뢰
                // @웹취약성 결재자 인위적 변경 체크 2015-08-25-------------------------------------------------------

                dest = requestApproval(req, box, D01OTData.class, new RequestFunction<D01OTData>() {
                    public String porcess(D01OTData inputData, Vector<ApprovalLineData> approvalLine) throws GeneralException {

                        box.copyToEntity(inputData);
                        inputData.PERNR = PERNR;
                        inputData.ZPERNR = user.empNo;               // 신청자 사번(대리신청, 본인 신청)
                        inputData.UNAME = user.empNo;                // 신청자 사번(대리신청, 본인 신청)
                        inputData.AEDTM = curdate; // 변경일(현재날짜)

                        DataUtil.fixNull(inputData);

                        String PRECHECK = new D01OTAfterWorkPercheckRFC().getPRECHECK(PERNR, inputData.WORK_DATE, "").E_PRECHECK;
                        Logger.debug.println(this, "[create] PRECHECK >> " + PRECHECK);

                        /* 체크 로직 필요한 경우 */
                        String message = checkData(inputData);
                        Logger.debug.println(this, "checkData() After ....message >> [ " + message + " ]");

                        // [WorkTime52] START---------------------------------------------------------------------
                        // [CSR ID:2803878] 요청 초과근무 신청화면 1주 12시간 체크
                        String yymm = DataUtil.getCurrentYear() + DataUtil.getCurrentMonth();
                        Vector submitData_vt = new D02KongsuHourRFC().getOvtmHour(PERNR, yymm, "R", inputData); // 'C' = 현황, 'R' = 신청,'M' = 수정, 'G' = 결재

                        String EMPGUB = "";
                        String TPGUB = "";
                        GetEmpGubunRFC empGubunRFC = new GetEmpGubunRFC();
                        Vector<EmpGubunData> tpInfo = empGubunRFC.getEmpGubunData(PERNR);
                        if (empGubunRFC.getReturn().isSuccess()) {
                            EmpGubunData empGubunData = tpInfo.get(0);
                            EMPGUB = empGubunData.getEMPGUB();
                            TPGUB = empGubunData.getTPGUB();
                        }

                        // [WorkTime52] 실근무시간조회
                        D01OTRealWrokListRFC realworkfunc = new D01OTRealWrokListRFC();
                        D01OTAfterWorkTimeListRFC rfcaf = new D01OTAfterWorkTimeListRFC();

                        if (EMPGUB.equals("S")) {
                            String MODE = "";
                            final D01OTRealWorkDATA WorkData = realworkfunc.getResult(EMPGUB, PERNR, inputData.WORK_DATE, inputData.VTKEN, inputData.AINF_SEQN, MODE);
                            final D01OTAfterWorkTimeDATA AfterData = rfcaf.getResult("2", PERNR, inputData.WORK_DATE, "", "", curdate, "");

                            if (realworkfunc.getReturn().isSuccess()) {
                                req.setAttribute("WorkData", WorkData);
                            } else {
                                Logger.debug.println(this, "실근무시간 조회 에러!!");
                            }

                            if (rfcaf.getReturn().isSuccess()) {
                                req.setAttribute("AfterData", AfterData);
                            } else {
                                Logger.debug.println(this, "AF 실근무시간 조회 에러!!");
                            }
                        }

                        Vector D01OTData_vt = new Vector();
                        D01OTData_vt.addElement(inputData);

                        // 메세지가 있는경우
                        if (!message.equals("")) {

                            Logger.debug.println(this, "[AF]원래패이지로:메세지가 있는경우");
                            Logger.debug.println(this, "[AF]원래패이지로:메세지가 있는경우 message : " + message);
                            Logger.debug.println(this, "[AF]원래패이지로:EMPGUB : " + EMPGUB);
                            Logger.debug.println(this, "[AF]원래패이지로:DATUM  : " + inputData.WORK_DATE);

                            req.setAttribute("msg2", message);
                            req.setAttribute("message", message);
                            req.setAttribute("D01OTData_vt", D01OTData_vt);
                            req.setAttribute("submitData_vt", submitData_vt);
                            getApprovalInfo(req, PERNR);                            // <-- 반드시 추가
                            req.setAttribute("approvalLine", approvalLine);     // 변경된 결재라인
                            req.setAttribute("committed", "Y");                     // 이중분기(페이지포워딩)를 막기위한 속성추가

                            req.setAttribute("EMPGUB", EMPGUB);
                            req.setAttribute("TPGUB", TPGUB);
                            req.setAttribute("DATUM", inputData.WORK_DATE);

                            printJspPage(req, res, WebUtil.JspURL + "D/D01OT/D01OTAfterWorkBuild_KR.jsp");

                            return null;// WebUtil.JspURL+"D/D01OT/D01OTBuild_KR.jsp";

                            // [CSR ID:2803878] 요청 건 초과근무 신청내역 alert ## 현황안내메시지후 확인하면 저장함.(KSC)
                        } else if (!inputData.OVTM12YN.equals("N") || (PRECHECK.equals("N") && inputData.VTKEN.equals("X"))) { // confirm 용 message 추가

                            Logger.debug.println(this, "[AF]원래패이지로:신청내역 Alert ");
                            Logger.debug.println(this, "[AF]원래패이지로:신청내역 Alert : message : " + message);

                            // 실근무시간 조회
                            String MODE = "";

                            if (EMPGUB.equals("S")) {    // 사무직
                                MODE = "";
                                final D01OTRealWorkDATA WorkData = realworkfunc.getResult(EMPGUB, PERNR, inputData.WORK_DATE, inputData.VTKEN, inputData.AINF_SEQN, MODE);

                                if (realworkfunc.getReturn().isSuccess()) {
                                    req.setAttribute("WorkData", WorkData); // 나중에
                                } else {
                                    // req.setAttribute("WorkData" , "" );
                                    Logger.debug.println(this, "실근무시간 조회 에러!!");
                                }

                            }

                            req.setAttribute("D01OTData_vt", D01OTData_vt);
                            req.setAttribute("submitData_vt", submitData_vt);
                            req.setAttribute("PRECHECK", PRECHECK);
                            getApprovalInfo(req, PERNR);    // <-- 반드시 추가
                            req.setAttribute("approvalLine", approvalLine); // 변경된 결재라인
                            req.setAttribute("committed", "Y");

                            req.setAttribute("EMPGUB", EMPGUB);
                            req.setAttribute("TPGUB", TPGUB);
                            req.setAttribute("DATUM", inputData.WORK_DATE);

                            printJspPage(req, res, WebUtil.JspURL + "D/D01OT/D01OTAfterWorkBuild_KR.jsp");

                            return null;

                        } else { // 저장
                            D01OTAFRFC rfc = new D01OTAFRFC();
                            rfc.setRequestInput(user.empNo, UPMU_TYPE);
                            String ainf_seqn = rfc.build(PERNR, D01OTData_vt, box, req);

                            Logger.debug.println(this, "결재번호  ainf_seqn=" + ainf_seqn.toString());

                            if (!rfc.getReturn().isSuccess() || ainf_seqn == null) {
                                throw new GeneralException(rfc.getReturn().MSGTX);
                            }

                            return ainf_seqn;
                        }
                        /* 신청 후 msg 처리 후 이동 페이지 지정 */

                        /* 개발자 작성 부분 끝 */
                    }
                });

                // @웹취약성 결재자 인위적 변경 체크 끝-------------------------------------------------------

            } else {
                throw new BusinessException(g.getMessage("MSG.COMMON.0016")); // 내부명령(jobid)이 올바르지 않습니다.
            }

            Logger.debug.println(this, " destributed = " + dest);

            if (req.getAttribute("committed").equals("N")) {
                printJspPage(req, res, dest);
            }

        } catch (Exception e) {
            throw new GeneralException(e);
        }
    }

    /***************************************************************************************
     * jobid = check 루틴; D01TOchange에서도 호출
     ***************************************************************************************/

    void checkCommon(Box box, String PERNR, WebUserData user, HttpServletRequest req) throws GeneralException {

        Vector D01OTData_vt = new Vector();
        D01OTData data = new D01OTData();

        box.copyToEntity(data);
        data.PERNR = PERNR;
        DataUtil.fixNull(data);

        D01OTData_vt.addElement(data);  // 정보를 클라이언트로 되돌린다.

        String message = "";

        // [CSR ID:2595636] 동일일에 휴가&대근 차단 요청 건
        D16OTHDDupCheckRFC2 checkFunc = new D16OTHDDupCheckRFC2();
        Vector OTHDDupCheckData_new_vt = checkFunc.getChecResult(PERNR, UPMU_TYPE, data.WORK_DATE, data.WORK_DATE);
        String e_flag = OTHDDupCheckData_new_vt.get(0).toString();
        String e_message = OTHDDupCheckData_new_vt.get(1).toString();

        Logger.debug.println(this, "e_flag > " + e_flag);
        Logger.debug.println(this, "e_message > " + e_message);

        // 결재정보를 되돌린다.
        // ********** 결재라인, 결재 헤더 정보 조회 ****************
        getApprovalInfo(req, PERNR);    // <-- 반드시 추가

        req.setAttribute("message", message);
        req.setAttribute("D01OTData_vt", D01OTData_vt);
    }

    /*
     *         자료추가 수정시 체크로직
     */
    protected String checkData(D01OTData data) throws GeneralException {

        // RFC : ZGHR_RFC_NTM_AFTOT_AVAIL_CHECK [초과근무 사후 신청- 체크 RFC]
        Logger.debug.println(this, "AF AVAIL CHECK RFC 시작");

        D01OTAFCheckRFC AFCheckFunc = new D01OTAFCheckRFC();

        Vector T_RESULT = new Vector();
        T_RESULT.addElement(data);

        // 실행
        AFCheckFunc.AFCheck(T_RESULT);

        String message = AFCheckFunc.getReturn().MSGTX;
        if (AFCheckFunc.getReturn().isSuccess()) {
            message = "";
        }

        Logger.debug.println(this, " AF Check chkaddFunc.getReturn().MSGTX >> " + AFCheckFunc.getReturn().MSGTX);
        Logger.debug.println(this, " AF Check MESSAGE >> " + message);

        return message;
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