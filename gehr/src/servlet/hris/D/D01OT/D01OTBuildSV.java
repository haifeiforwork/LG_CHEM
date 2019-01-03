/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 초과근무                                                    */
/*   Program Name : 초과근무 신청                                               */
/*   Program ID   : D01OTBuildSV                                                */
/*   Description  : 초과근무(OT/특근)신청을 하는 Class                          */
/*   Note         :                                                             */
/*   Creation     : 2002-01-15  박영락                                          */
/*   Update       : 2005-03-07  윤정현                                          */
/*                 	2014-05-13  C20140515_40601  사무직시간선택제(6H,4H )  휴일,공휴일이면서 4,6시간 만 가능하게 체크로직추가*/
/*						E_PERSK - 27  : 사무직시간선택제(4H)  28 :  사무직(6H)  */
/*             		2014-08-24   [CSR ID:2595636] 동일일에 휴가&대근 차단 요청 건                                                                 */
/*                 	2015-03-13 [CSR ID:2727336] HR-근태신청 오류 수정요청의 건   */
/*             		2015-06-18  [CSR ID:2803878] 초과근무 신청 Process 변경 요청     */
/*                 	2016-09-21 통합구축 - 김승철                      */
/*						2018-02-12 rdcamel [CSR ID:3608185] e-HR 초과근무 사후신청 관련 시스템 개선 요청 */
/*						2015-05-23 [WorkTime52] 주52시간 근로시간 대응 PJT	*/
/*						2015-06-25 [WorkTime52] ZGHR_RFC_IS_AVAIL_OVERTIME 파라미터 추가(I_NTM = X)
/********************************************************************************/

package servlet.hris.D.D01OT;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.ObjectUtils;

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

import hris.D.D16OTHDDupCheckData;
import hris.D.D01OT.D01OTCheckData;
/*[WorkTime52] start */
import hris.D.D01OT.D01OTCheckDataAdd;
import hris.D.D01OT.D01OTData;
import hris.D.D01OT.D01OTHolidayCheckData;
import hris.D.D01OT.D01OTRealWorkDATA;
import hris.D.D01OT.rfc.D01OTCheckAddRFC;
import hris.D.D01OT.rfc.D01OTCheckRFC;
import hris.D.D01OT.rfc.D01OTHolidayCheckRFC;
import hris.D.D01OT.rfc.D01OTRFC;
import hris.D.D01OT.rfc.D01OTRealWrokListRFC;
import hris.D.D03Vocation.rfc.D03ShiftCheckRFC;
/*[WorkTime52] end*/
import hris.D.rfc.D02KongsuHourRFC;
import hris.D.rfc.D16OTHDDupCheckRFC;
import hris.D.rfc.D16OTHDDupCheckRFC2;
import hris.common.PersonData;
import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalLineData;
import hris.common.rfc.PersonInfoRFC;

@SuppressWarnings({ "rawtypes", "serial" })
public class D01OTBuildSV extends ApprovalBaseServlet {

    private String UPMU_TYPE = "17";
    private String UPMU_NAME = "초과근무";
    private String OT_AFTER = "";// [CSR ID:3608185]사후신청 문구 추가

    protected String getUPMU_TYPE() {
        return UPMU_TYPE;
    }

    protected String getUPMU_NAME() {
        return UPMU_NAME + OT_AFTER;// [CSR ID:3608185]사후신청 문구 추가
    }

    protected void performTask(final HttpServletRequest req, final HttpServletResponse res) throws GeneralException {

        try {

            final WebUserData user = WebUtil.getSessionUser(req);

            String dest = "";
            String jobid = "";

            final Box box = WebUtil.getBox(req);

            /*********** Start: 국가별 분기처리 **********************************************************/
            if (!user.area.equals(Area.KR)) { 	// 해외화면으로
                printJspPage(req, res, WebUtil.ServletURL + "hris.D.D01OT.D01OTBuildGlobalSV");
                return;
            }
            /************** END: 국가별 분기처리 *********************************************************/

            jobid = box.get("jobid", "first");
            boolean isUpdate = box.getBoolean("isUpdate");

            Logger.debug.println(this, "[isUpdate] = " + isUpdate);
            Logger.debug.println(this, "[jobid] = " + jobid + " [user] : " + user.toString());

            final String PERNR = getPERNR(box, user); // 신청대상자 사번

            // 대리 신청 추가
            PersonInfoRFC numfunc = new PersonInfoRFC();
            final PersonData phonenumdata;
            phonenumdata = (PersonData) numfunc.getPersonInfo(PERNR);
            req.setAttribute("PersonData", phonenumdata);
            req.setAttribute("isUpdate", isUpdate); 	// [결재]등록 수정 여부 <- 수정쪽에는 반드시 필요함
            req.setAttribute("PERNR", PERNR);
            req.setAttribute("committed", "N"); 			// check already response 2017/1/3 ksc

            /*************************************************************************************/

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

                D16OTHDDupCheckRFC d16OTHDDupCheckRFC = new D16OTHDDupCheckRFC();
                Vector OTHDDupCheckData_vt = null;
                OTHDDupCheckData_vt = d16OTHDDupCheckRFC.getCheckList(PERNR, UPMU_TYPE, user.area);

                req.setAttribute("OTHDDupCheckData_vt", OTHDDupCheckData_vt);
                // Logger.debug.println(this, "OTHDDupCheckData_vt : "+ OTHDDupCheckData_vt.toString());

                /*************************************************************************************/
                // [WorkTime52] 2018-05-18 Kang Start!!

                // 사원 구분 조회(사무직:S / 현장직:H) => [변경 :2018-06-07 : A(사무직-일반), B(현장직-일반), C(사무직-선택근로제), D(현장직-탄력근로제)
                Map<String, Object> rfcResultData = RfcHandler.execute("ZGHR_RFC_NTM_GET_EMPGUB", new HashMap<String, Object>() {
                    {
                        put("I_PERNR", PERNR);
                    }
                });

                final String EMPGUB = ObjectUtils.toString(getData(rfcResultData, "EXPORT", g.getMessage("MSG.D.D01.0063")).get("E_EMPGUB")); 	// (사무직:S / 현장직:H)
                final String TPGUB = ObjectUtils.toString(getData(rfcResultData, "EXPORT", g.getMessage("MSG.D.D01.0063")).get("E_TPGUB"));		// A(사무직-일반), B(현장직-일반), C(사무직-선택근로제), D(현장직-탄력근로제)
                String EMPTXT = "";
                if (TPGUB.equals("A")) {
                    EMPTXT = "사무직-일반";
                } else if (TPGUB.equals("B")) {
                    EMPTXT = "현장직-일반";
                } else if (TPGUB.equals("C")) {
                    EMPTXT = "사무직-선택근로제";
                } else {
                    EMPTXT = "현장직-선택근로제";
                }

                // String I_DATE = req.getParameter("DATUM");
                // I_DATE = (I_DATE == null || I_DATE.equals("")) ? DataUtil.getCurrentDate() : I_DATE;
                final String I_DATE = (req.getParameter("DATUM") == null || req.getParameter("DATUM").equals("")) ? DataUtil.getCurrentDate() : req.getParameter("DATUM");
                // String DATUM = DataUtil.getCurrentDate();

                // final String I_WORK_DATE = I_DATE;
                final String I_VTKEN = ObjectUtils.toString(req.getAttribute("VTKEN"));

                Logger.debug.println(this, "I_DATE :: " + I_DATE);
                Logger.debug.println(this, "I_VTKEN :: " + I_VTKEN);

                // 실근무시간 조회
                D01OTRealWrokListRFC realworkfunc = new D01OTRealWrokListRFC();
                String MODE = "";

                if (EMPGUB.equals("S")) {	// 사무직-일반
                    MODE = "";
                    final D01OTRealWorkDATA WorkData = realworkfunc.getResult(EMPGUB, PERNR, I_DATE, I_VTKEN,"", MODE);

                    if (realworkfunc.getReturn().isSuccess()) {
                        req.setAttribute("WorkData", WorkData); // 나중에
                    } else {
                        req.setAttribute("WorkData", "");
                        Logger.debug.println(this, "실근무시간 조회 에러!!");
                    }

                    Logger.debug.println(this, "WorkData[사무직] : " + WorkData.toString());

                    req.setAttribute("EMPGUB", EMPGUB);
                    req.setAttribute("TPGUB", TPGUB);
                    req.setAttribute("DATUM", I_DATE);

                } else {		// 현장직

                    // 월간 실근로시간 현황 조회
                    rfcResultData = RfcHandler.execute("ZGHR_RFC_NTM_OT_REQ_RW_LIST", new HashMap<String, Object>() { // ZGHR_RFC_NTM_REALWORK_LIST
                        {
                            put("I_EMPGUB", EMPGUB);
                            put("I_PERNR", PERNR);
                            put("I_DATUM", I_DATE);
                            put("I_VTKEN", "");

                        }
                    });

                    req.setAttribute("MM", Integer.parseInt(DataUtil.getCurrentMonth()));
                    req.setAttribute("EMPGUB", EMPGUB);
                    req.setAttribute("TPGUB", TPGUB);
                    req.setAttribute("DATUM", I_DATE);

                    WebUtil.setAttributes(req, getSummaryData(rfcResultData, EMPGUB, g.getMessage("MSG.D.D01.0064", EMPTXT))); // 사무직(월간)/현장직(주간) 실근로시간 현황 데이터를 조회하지 못하였습니다.

                }

                Logger.debug.println(this, "[first] EMPGUB >> " + EMPGUB);
                Logger.debug.println(this, "[first] TGUB >> " + TPGUB);
                Logger.debug.println(this, "[first] MODE >> " + MODE);
                Logger.debug.println(this, "[first] DATUM >> " + I_DATE);
                // [WorkTime52] 2018-05-18 Kang End!!
                /*************************************************************************************/

                dest = WebUtil.JspURL + "D/D01OT/D01OTBuild_KR.jsp";

                /*************************************************************************************/
            } else if (jobid.equals("ajax")) {

                Map<String, Object> rfcResultData = RfcHandler.execute("ZGHR_RFC_NTM_GET_EMPGUB", new HashMap<String, Object>() {
                    {
                        put("I_PERNR", PERNR);
                    }
                });

                // 실근무시간 조회
                final String I_EMPGUB = req.getParameter("I_EMPGUB");
                final String I_TPGUB = ObjectUtils.toString(getData(rfcResultData, "EXPORT", g.getMessage("MSG.D.D01.0063")).get("E_TPGUB"));		// A(사무직-일반), B(현장직-일반), C(사무직-선택근로제), D(현장직-탄력근로제)
                String DATE = (req.getParameter("DATUM") == null || req.getParameter("DATUM").equals("")) ? DataUtil.getCurrentDate() : req.getParameter("DATUM");
                final String A_DATE = DATE;

                String EMPTXT = "";
                if (I_EMPGUB.equals("S")) {
                    EMPTXT = "사무직";
                } else {
                    EMPTXT = "현장직";
                }

                Logger.debug.println(this, "ajax-DATE : " + DATE);
                // Logger.debug.println(this, "ajax-DATE.substring : "+ DATE.substring(5, 6));

                // 실근로시간 조회
                D01OTRealWrokListRFC realworkfunc01 = new D01OTRealWrokListRFC();

                if (I_EMPGUB.equals("S")) {		// 사무직

                    final D01OTRealWorkDATA worklistdata = realworkfunc01.getResult(I_EMPGUB, PERNR, DATE, "", "","");
                    Logger.debug.println(this, "worklistdata[사무직-ajax] : " + worklistdata.toString());

                    // 평일/휴일/공휴일 조회
                    rfcResultData = RfcHandler.execute("ZGHR_RFC_NTM_WORKDAY_LIST", new HashMap<String, Object>() {
                        {
                            put("I_EMPGUB", I_EMPGUB);
                            put("I_PERNR", PERNR);
                            put("I_BEGDA", A_DATE);
                            put("I_ENDDA", A_DATE);
                        }
                    });

                    req.setAttribute("EMPGUB", I_EMPGUB);
                    req.setAttribute("TPGUB" , I_TPGUB);
                    req.setAttribute("DATUM" , A_DATE);

                    List HolidayList = (List) getData(rfcResultData, "TABLES", g.getMessage("MSG.D.D01.0063")).get("T_WLIST");
                    final String Holidaycheck01 = (String) ((Map) HolidayList.get(0)).get("HOLID");	// 공휴일 X
                    final String Holidaycheck02 = (String) ((Map) HolidayList.get(0)).get("SOLLZ");	// 비근무일 0

                    // 일근직체크
                    D03ShiftCheckRFC func_shift = new D03ShiftCheckRFC();
                    final String	shiftCheck = func_shift.check(PERNR, A_DATE);    //D:일근직,1:장치교대조
                    Logger.debug.println(this, "[ajax] shiftCheck ::  " + shiftCheck);

                    new AjaxResultMap().addResult(new HashMap<String, Object>() {
                        {
                            put("E_BASTM", worklistdata.BASTM);	// 기본근무
                            put("E_MAXTM", worklistdata.MAXTM);	// 법정최대한도
                            put("E_PWDWK", worklistdata.PWDWK);	// 평일근로시간-개인입력
                            put("E_PWEWK", worklistdata.PWEWK);	// 평일근로시간-회사인정
                            put("E_CWDWK", worklistdata.CWDWK);	// 주말휴일근무시간-개인
                            put("E_CWEWK", worklistdata.CWEWK);	// 주말휴일근무시간-회사인정
                            put("E_PWTOT", worklistdata.PWTOT); //계-개인
                            put("E_CWTOT", worklistdata.CWTOT); //계-회사
                            put("E_RWKTM", worklistdata.RWKTM);	// 실근무시간

                            put("E_HOLID", Holidaycheck01);		// 공휴일
                            put("E_SOLLZ", Holidaycheck02);		// 비근무일
                            put("E_SHIFT", shiftCheck);			// 일근직/4조3교대

                        }
                    }).writeJson(res);

                } else {	// 현장직
                    try {
                        // 월간 실근로시간 현황 조회
                        rfcResultData = RfcHandler.execute("ZGHR_RFC_NTM_OT_REQ_RW_LIST", new HashMap<String, Object>() {
                            {
                                put("I_EMPGUB", I_EMPGUB);
                                put("I_PERNR" , PERNR);
                                put("I_DATUM" , A_DATE);
                                put("I_VTKEN" , "");
                            }
                        });

                        req.setAttribute("EMPGUB", I_EMPGUB);
                        req.setAttribute("TPGUB" , I_TPGUB);
                        req.setAttribute("DATUM" , A_DATE);

                        Map TimeTable = getSummaryData(rfcResultData, I_EMPGUB, g.getMessage("MSG.D.D01.0064", EMPTXT));

                        // 평일/휴일/공휴일 조회
                        rfcResultData = RfcHandler.execute("ZGHR_RFC_NTM_WORKDAY_LIST", new HashMap<String, Object>() {
                            {
                                put("I_EMPGUB", I_EMPGUB);
                                put("I_PERNR" , PERNR);
                                put("I_BEGDA" , A_DATE);
                                put("I_ENDDA" , A_DATE);
                            }
                        });

                        Logger.debug.println(this, "Holidaycheck value :: rfcResultData " + rfcResultData);
                        List HolidayList = (List) getData(rfcResultData, "TABLES", g.getMessage("MSG.D.D01.0063")).get("T_WLIST");
                        Logger.debug.println(this, "Holidaycheck value :: HolidayList " + HolidayList);
                        // if(CollectionUtils.isEmpty(Holiday)){
                        // 오류메세지
                        // }

                        TimeTable.put("Holidycheck01", (String) ((Map) HolidayList.get(0)).get("HOLID"));
                        TimeTable.put("Holidycheck02", (String) ((Map) HolidayList.get(0)).get("SOLLZ"));

                        Logger.debug.println(this, "Holidycheck01 ::  " + (String) ((Map) HolidayList.get(0)).get("HOLID"));
                        Logger.debug.println(this, "Holidycheck02 ::  " + (String) ((Map) HolidayList.get(0)).get("SOLLZ"));

                        new AjaxResultMap().addResult(TimeTable).writeJson(res);

                        return;

                    } catch (Exception e) {
                        Logger.error(e);
                    }
                }

                return;

                /*************************************************************************************/
            } else if (jobid.equals("check")) {
                checkCommon(box, PERNR, user, req);
                req.setAttribute("jobid", jobid);

                // [WorkTime52] START
                // 사원 구분 조회(사무직:S / 현장직:H)
                Map<String, Object> rfcResultData = RfcHandler.execute("ZGHR_RFC_NTM_GET_EMPGUB", new HashMap<String, Object>() {
                    {
                        put("I_PERNR", PERNR);
                    }
                });

                final String EMPGUB	= ObjectUtils.toString(getData(rfcResultData, "EXPORT", g.getMessage("MSG.D.D01.0063")).get("E_EMPGUB")); 	// (사무직:S / 현장직:H)
                final String TPGUB 	= ObjectUtils.toString(getData(rfcResultData, "EXPORT", g.getMessage("MSG.D.D01.0063")).get("E_TPGUB"));		// A(사무직-일반), B(현장직-일반), C(사무직-선택근로제), D(현장직-탄력근로제)
                final String I_DATE 	= req.getParameter("DATUM");
                final String I_VTKEN = ObjectUtils.toString(req.getAttribute("VTKEN"));
                final String I_AINF_SEQN = ObjectUtils.toString(req.getAttribute("AINF_SEQN"));

                Logger.debug.println(this, "[ I_DATE : " + I_DATE + "], [ I_VTKEN : " + I_VTKEN + "]");

                D01OTRealWrokListRFC realworkfunc = new D01OTRealWrokListRFC();
                // 사무직
                if (EMPGUB.equals("S")) {
                    String MODE = "";

                    final D01OTRealWorkDATA WorkData = realworkfunc.getResult(EMPGUB, PERNR, I_DATE, I_VTKEN, I_AINF_SEQN, MODE);
                    if (realworkfunc.getReturn().isSuccess()) {
                        req.setAttribute("WorkData", WorkData);
                    } else {
                        req.setAttribute("WorkData", "");
                        Logger.debug.println(this, "실근무시간 조회 에러!!");
                    }
                    // 현장직
                } else {
                    // 월간 실근로시간 현황 조회
                    rfcResultData = RfcHandler.execute("ZGHR_RFC_NTM_OT_REQ_RW_LIST", new HashMap<String, Object>() {
                        {
                            put("I_PERNR" , PERNR);
                            put("I_DATUM" , I_DATE);
                            put("I_EMPGUB", EMPGUB);
                        }
                    });
                    WebUtil.setAttributes(req, getSummaryData(rfcResultData, EMPGUB, g.getMessage("MSG.D.D01.0064", "1"))); // 사무직(월간)/현장직(주간) 실근로시간 현황 데이터를 조회하지 못하였습니다.
                }

                req.setAttribute("DATUM" , I_DATE);
                req.setAttribute("EMPGUB", EMPGUB);
                req.setAttribute("TPGUB" , TPGUB);

                // WebUtil.setAttributes(req, getSummaryData(rfcResultData, EMPGUB, g.getMessage("MSG.D.D01.0064","1"))); // 사무직(월간)/현장직(주간) 실근로시간 현황 데이터를 조회하지 못하였습니다.
                // [WorkTime52] END

                dest = WebUtil.JspURL + "D/D01OT/D01OTBuild_KR.jsp";

                /*************************************************************************************/
            } else if (jobid.equals("create")) {
                // @웹취약성 결재자 인위적 변경 체크 2015-08-25-------------------------------------------------------

                dest = requestApproval(req, box, D01OTData.class, new RequestFunction<D01OTData>() {
                    public String porcess(D01OTData inputData, Vector<ApprovalLineData> approvalLine) throws GeneralException {

                        D01OTRFC rfc = new D01OTRFC();
                        Vector D01OTData_vt = new Vector();
                        box.copyToEntity(inputData);
                        inputData.PERNR  = PERNR;
                        inputData.ZPERNR = user.empNo;	// 신청자 사번(대리신청, 본인 신청)
                        inputData.UNAME  = user.empNo;  // 신청자 사번(대리신청, 본인 신청)
                        inputData.AEDTM  = DataUtil.getCurrentDate();  // 변경일(현재날짜)

                        // [CSR ID:3608185] e-HR 초과근무 사후신청 관련 시스템 개선 요청
                        OTAfterCheck(inputData);
                        Logger.debug.println(this, getUPMU_NAME());
                        // [CSR ID:3608185] e-HR 초과근무 사후신청 관련 시스템 개선 요청

                        DataUtil.fixNull(inputData);

                        D01OTData_vt.addElement(inputData);
                        // Logger.debug.println(this, data.toString() );

                        String message = "";
                        // String message2 = "";

                        // [CSR ID:2803878] 요청 초과근무 신청화면 1주 12시간 체크
                        D02KongsuHourRFC rfcH = new D02KongsuHourRFC();
                        String yymm = DataUtil.getCurrentYear() + DataUtil.getCurrentMonth();
                        // 'C' = 현황, 'R' = 신청,'M' = 수정, 'G' = 결재
                        // 2015-10-21 @marco
                        // 초과근무 현황에서 대리신청 사번일 경우 처리

                        /* 체크 로직 필요한 경우 */
                        message = checkData(phonenumdata, inputData, PERNR, user);
                        // if (!message.equals("")) throw new GeneralException(message);

                        /* 결재 신청 RFC 호출 */
                        // 급여계좌 저장..

                        // [WorkTime52] START---------------------------------------------------------------------
                        //Vector submitData_vt = rfcH.getOvtmHour(PERNR, yymm, "R", inputData); //기존
                        Vector submitData_vt = rfcH.getOvtmHour52(PERNR, inputData.WORK_DATE, "R", inputData, "X");	// 신규

                        String PRECHECK = rfcH.getOvtmHour(PERNR, yymm, inputData.WORK_DATE, "");	// 전일근태 체크가 가능한지 여부 확인(N이면 체크하면 안됨)

                        // [WorkTime52]사원 구분 조회(사무직:S / 현장직:H)
                        Map<String, Object> rfcResultData = RfcHandler.execute("ZGHR_RFC_NTM_GET_EMPGUB", new HashMap<String, Object>() {
                            {
                                put("I_PERNR", PERNR);
                            }
                        });

                        final String EMPGUB = ObjectUtils.toString(getData(rfcResultData, "EXPORT", g.getMessage("MSG.D.D01.0063")).get("E_EMPGUB"));
                        final String TPGUB = ObjectUtils.toString(getData(rfcResultData, "EXPORT", g.getMessage("MSG.D.D01.0063")).get("E_TPGUB"));
                        String EMPTXT = "";
                        if (TPGUB.equals("A")) {
                            EMPTXT = "사무직-일반";
                        } else if (TPGUB.equals("B")) {
                            EMPTXT = "현장직-일반";
                        } else if (TPGUB.equals("C")) {
                            EMPTXT = "사무직-선택근로제";
                        } else {
                            EMPTXT = "현장직-선택근로제";
                        }

                        final String I_WORK_DATE = inputData.WORK_DATE;

                        Logger.debug.println(this, "checkData() After ....message >> [ " + message + " ]");

                        // [WorkTime52] 실근무시간조회
                        D01OTRealWrokListRFC realworkfunc = new D01OTRealWrokListRFC();

                        if (EMPGUB.equals("S")) {
                            String MODE = "";
                            final D01OTRealWorkDATA WorkData = realworkfunc.getResult(EMPGUB, PERNR, inputData.WORK_DATE, inputData.VTKEN, inputData.AINF_SEQN, MODE);
                            if (realworkfunc.getReturn().isSuccess()) {
                                req.setAttribute("WorkData", WorkData); // 나중에
                            } else {
                                req.setAttribute("WorkData", "");
                                Logger.debug.println(this, "실근무시간 조회 에러!!");
                            }
                        } else {
                            // 실근로시간 현황 조회
                            rfcResultData = RfcHandler.execute("ZGHR_RFC_NTM_OT_REQ_RW_LIST", new HashMap<String, Object>() {
                                {
                                    put("I_PERNR"		, PERNR);
                                    put("I_DATUM"		, I_WORK_DATE);
                                    put("I_EMPGUB"	, EMPGUB);
                                }
                            });
                            WebUtil.setAttributes(req, getSummaryData(rfcResultData, EMPGUB, g.getMessage("MSG.D.D01.0064", EMPTXT))); // 사무직(월간)/현장직(주간) 실근로시간 현황 데이터를 조회하지 못하였습니다.
                        }
                        // [WorkTime52] END ---------------------------------------------------------------------

                        if (!message.equals("")) { // 메세지가 있는경우
                            D16OTHDDupCheckRFC func2 = new D16OTHDDupCheckRFC();
                            Vector OTHDDupCheckData_vt = func2.getCheckList(PERNR, UPMU_TYPE, user.area);

                            Logger.debug.println(this, "원래패이지로:메세지가 있는경우");
                            Logger.debug.println(this, "원래패이지로:메세지가 있는경우 message : " + message);
                            Logger.debug.println(this, "원래패이지로:EMPGUB : " + EMPGUB);
                            Logger.debug.println(this, "원래패이지로:DATUM  : " + inputData.WORK_DATE);

                            req.setAttribute("msg2", message);
                            req.setAttribute("message", message);
                            req.setAttribute("D01OTData_vt", D01OTData_vt);
                            req.setAttribute("submitData_vt", submitData_vt);
                            req.setAttribute("OTHDDupCheckData_vt", OTHDDupCheckData_vt);
                            getApprovalInfo(req, PERNR);    // <-- 반드시 추가
                            req.setAttribute("approvalLine", approvalLine); // 변경된 결재라인
                            req.setAttribute("committed", "Y"); // 이중분기(페이지포워딩)를 막기위한 속성추가
                            // [WorkTime52]
                            req.setAttribute("EMPGUB", EMPGUB);
                            req.setAttribute("TPGUB"  , TPGUB);
                            req.setAttribute("DATUM" , inputData.WORK_DATE);


                            printJspPage(req, res, WebUtil.JspURL + "D/D01OT/D01OTBuild_KR.jsp");

                            return null;// WebUtil.JspURL+"D/D01OT/D01OTBuild_KR.jsp";

                            // [CSR ID:2803878] 요청 건 초과근무 신청내역 alert ## 현황안내메시지후 확인하면 저장함.(KSC)
                        } else if (!inputData.OVTM12YN.equals("N") || (PRECHECK.equals("N") && inputData.VTKEN.equals("X"))) { // confirm 용 message 추가
                            D16OTHDDupCheckRFC func2 = new D16OTHDDupCheckRFC();
                            Vector OTHDDupCheckData_vt = func2.getCheckList(PERNR, UPMU_TYPE, user.area);

                            Logger.debug.println(this, "원래패이지로:신청내역 Alert ");
                            Logger.debug.println(this, "원래패이지로:신청내역 Alert : message : " + message);

                            // [WorkTime52] START
                            // 실근무시간 조회
                            String MODE = "";

                            if (EMPGUB.equals("S")) {	// 사무직
                                MODE = "";
                                final D01OTRealWorkDATA WorkData = realworkfunc.getResult(EMPGUB, PERNR, inputData.WORK_DATE, inputData.VTKEN, inputData.AINF_SEQN, MODE);
                                if (realworkfunc.getReturn().isSuccess()) {
                                    req.setAttribute("WorkData", WorkData); // 나중에
                                } else {
                                    req.setAttribute("WorkData", "");
                                    Logger.debug.println(this, "실근무시간 조회 에러!!");
                                }

                                req.setAttribute("EMPGUB", EMPGUB);
                                req.setAttribute("TPGUB", TPGUB);
                                req.setAttribute("DATUM", inputData.WORK_DATE);

                            } else {		// 현장직
                                rfcResultData = RfcHandler.execute("ZGHR_RFC_NTM_OT_REQ_RW_LIST", new HashMap<String, Object>() {	// 실근로시간 현황 조회
                                    {
                                        put("I_PERNR", PERNR);
                                        put("I_DATUM", I_WORK_DATE);
                                        put("I_EMPGUB", EMPGUB);
                                    }
                                });

                                req.setAttribute("MM", Integer.parseInt(DataUtil.getCurrentMonth()));
                                req.setAttribute("EMPGUB", EMPGUB);
                                req.setAttribute("TPGUB", TPGUB);
                                req.setAttribute("DATUM", I_WORK_DATE);

                                WebUtil.setAttributes(req, getSummaryData(rfcResultData, EMPGUB, g.getMessage("MSG.D.D01.0064", EMPTXT))); // 사무직(월간)/현장직(주간) 실근로시간 현황 데이터를 조회하지 못하였습니다.
                            }
                            // [WorkTime52] END

                            req.setAttribute("D01OTData_vt", D01OTData_vt);
                            req.setAttribute("submitData_vt", submitData_vt);
                            req.setAttribute("PRECHECK", PRECHECK);
                            req.setAttribute("OTHDDupCheckData_vt", OTHDDupCheckData_vt);
                            getApprovalInfo(req, PERNR);    // <-- 반드시 추가
                            req.setAttribute("approvalLine", approvalLine); // 변경된 결재라인
                            req.setAttribute("committed", "Y");
                            // [WorkTime52]
                            req.setAttribute("EMPGUB", EMPGUB);
                            req.setAttribute("TPGUB", TPGUB);
                            req.setAttribute("DATUM", inputData.WORK_DATE);


                            printJspPage(req, res, WebUtil.JspURL + "D/D01OT/D01OTBuild_KR.jsp");

                            return null;

                        } else { // 저장

                            rfc.setRequestInput(user.empNo, UPMU_TYPE);
                            String ainf_seqn = rfc.build(PERNR, D01OTData_vt, box, req);
                            Logger.debug.println(this, "결재번호  ainf_seqn=" + ainf_seqn.toString());
                            if (!rfc.getReturn().isSuccess() || ainf_seqn == null) {
                                throw new GeneralException(rfc.getReturn().MSGTX);
                            };
                            // Logger.debug.println(this, "저장으로:date"+date);
                            //String date = box.get("BEGDA");        // 신청일: 2012.02.10 가끔 다음날 신청일이 같은결재건에 등록이되고 있어 수정함.
                            String url = "location.href = '" + WebUtil.ServletURL + "hris.D.D01OT.D01OTDetailSV?AINF_SEQN=" + ainf_seqn + "';";
                            req.setAttribute("url", url);
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
        } finally {

        }
    }

    /*
     * jobid = check 루틴; D01TOchange에서도 호출
     */

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

        if (e_flag.equals("Y")) {// Y면 중복, N은 OK
            message = e_message;
        } else {
            D01OTCheckRFC func = new D01OTCheckRFC();
            //[WorkTime52] ZGHR_RFC_IS_AVAIL_OVERTIME 파라미터 추가(I_NTM = X)
            Vector D01OTCheck_vt = func.check(PERNR, data.WORK_DATE, data.WORK_DATE, data.BEGUZ, data.ENDUZ, "X");

            // 2002.07.04. 신청시간이 근무일정과 중복되었을경우 R3에 초과근무 신청 로직을 적용하기위해서 수정함.

            D01OTCheckData checkData = (D01OTCheckData) D01OTCheck_vt.get(0);

            Logger.debug.println(this, "==checkData== : " + checkData.toString());

            if (!checkData.ERRORTEXTS.equals("") && checkData.STDAZ.equals("0")) {  // 에러메시지가 있고, 한계결정을 할 수 없는 경우
                message = "근무일정과 중복되었습니다.";
            } else if (checkData.ERRORTEXTS.equals("")) {                          // 에러메시지가 없고, 정상적이거나 한계결정을 한 경우.
                if (checkData.BEGUZ.equals(data.BEGUZ) && checkData.ENDUZ.equals(data.ENDUZ)) {
                    message = "";
                } else {
                    message = "근무일정과 중복되어 신청시간을 정정하였습니다.";
                    data.BEGUZ = checkData.BEGUZ;                                    // 한계결정한 시간정보로 재설정해준다.
                    data.ENDUZ = checkData.ENDUZ;
                    data.STDAZ = checkData.STDAZ;
                }
            }
            // 2002.07.04. 신청시간이 근무일정과 중복되었을경우 R3에 초과근무 신청 로직을 적용하기위해서 수정함.
        }

        // 결재정보를 되돌린다.
        // ********** 결재라인, 결재 헤더 정보 조회 ****************
        getApprovalInfo(req, PERNR);    // <-- 반드시 추가

        D16OTHDDupCheckRFC func2 = new D16OTHDDupCheckRFC();
        Vector OTHDDupCheckData_vt = func2.getCheckList(PERNR, UPMU_TYPE, user.area);
        req.setAttribute("message", message);
        req.setAttribute("D01OTData_vt", D01OTData_vt);
        req.setAttribute("OTHDDupCheckData_vt", OTHDDupCheckData_vt);

    }

    /*
     * 		자료추가 수정시 체크로직
     */
    protected String checkData(PersonData phonenumdata, D01OTData data, String PERNR, WebUserData user) throws GeneralException {

        String message = "";

        try {
            // C20140515_40601 인사하위영역 27,36: -사무직시간선택제(4H) 4시간체크 START
            // C20140515_40601 인사하위영역 28,37: -사무직시간선택제(6H) 6시간체크

            Logger.debug.println(this, "phonenumdata.E_PERSK : " + phonenumdata.E_PERSK);
            Logger.debug.println(this, "checkData.data : " + data.toString());

            if (phonenumdata.E_PERSK.equals("27") || phonenumdata.E_PERSK.equals("28") || phonenumdata.E_PERSK.equals("36") || phonenumdata.E_PERSK.equals("37")) { //
                // 공휴일, 토,일만 가능
                D01OTHolidayCheckRFC funHc = new D01OTHolidayCheckRFC();
                Vector D01OTHolidayCheck_vt = funHc.check("L1", data.WORK_DATE, data.WORK_DATE);
                D01OTHolidayCheckData HolidaycheckData = (D01OTHolidayCheckData) D01OTHolidayCheck_vt.get(0);

                if (HolidaycheckData.HOLIDAY.equals("X") || (HolidaycheckData.WEEKDAY.equals("6") || HolidaycheckData.WEEKDAY.equals("7"))) {
                    if ((phonenumdata.E_PERSK.equals("27") || phonenumdata.E_PERSK.equals("36")) && !data.STDAZ.equals("4")) {
                        message = "사무직 시간선택제(4H) 사원은 4시간만 신청가능합니다. ";
                    }
                    if ((phonenumdata.E_PERSK.equals("28") || phonenumdata.E_PERSK.equals("37")) && !data.STDAZ.equals("6")) {
                        message = "사무직 시간선택제(6H) 사원은 6시간만 신청가능합니다. ";
                    }
                } else { // 평일
                    if (phonenumdata.E_PERSK.equals("27") || phonenumdata.E_PERSK.equals("28")) { // 시간 선택제

                        message = message + "사무직 시간선택제 사원은  공휴일, 토요일, 일요일에만 초과근무 신청이 가능합니다";
                    }
                }

                Logger.debug.println(this, "HolidaycheckData : " + HolidaycheckData.toString());
                Logger.debug.println(this, "[message] : " + message);

            }

            if (phonenumdata.E_PERSK.equals("27") || phonenumdata.E_PERSK.equals("28") || phonenumdata.E_PERSK.equals("36") || phonenumdata.E_PERSK.equals("37")) { //
                if ((phonenumdata.E_PERSK.equals("27") || phonenumdata.E_PERSK.equals("36")) && !data.STDAZ.equals("4")) {
                    message = "사무직시간선택제(4H)로  4시간만 신청가능합니다.";
                }
                if ((phonenumdata.E_PERSK.equals("28") || phonenumdata.E_PERSK.equals("37")) && !data.STDAZ.equals("6")) {
                    message = "사무직시간선택제(6H)로  6시간만 신청가능합니다.";
                }
                Logger.debug.println(this, "[[message : " + message + "data.STDAZ:" + data.STDAZ);
                // 공휴일, 토,일만 가능
                D01OTHolidayCheckRFC funHc = new D01OTHolidayCheckRFC();
                Vector D01OTHolidayCheck_vt = funHc.check("L1", data.WORK_DATE, data.WORK_DATE);
                D01OTHolidayCheckData HolidaycheckData = (D01OTHolidayCheckData) D01OTHolidayCheck_vt.get(0);
                if (phonenumdata.E_PERSK.equals("27") || phonenumdata.E_PERSK.equals("28")) {
                    if (!HolidaycheckData.HOLIDAY.equals("X") && !HolidaycheckData.WEEKDAY.equals("6") && !HolidaycheckData.WEEKDAY.equals("7")) {
                        message = message + "사무직시간선택제로  공휴일,토요일,일요일만 신청가능합니다.";
                    }
                }
                Logger.debug.println(this, "HolidaycheckData : " + HolidaycheckData.toString());
                Logger.debug.println(this, "[message] : " + message);
            }

            // }
            // C20140515_40601 인사하위영역 27: -사무직시간선택제(6H) 공휴일 6시간체크 END

            // DUP CHECK START <<< 모바일에서 가져옴 2016/12/03 KSC

            D16OTHDDupCheckRFC d16OTHDDupCheckRFC = new D16OTHDDupCheckRFC();
            Vector OTHDDupCheckData_vt = null;
            OTHDDupCheckData_vt = d16OTHDDupCheckRFC.getCheckList(PERNR, UPMU_TYPE, user.area);
            String c_workDate = "";
            for (int i = 0; i < OTHDDupCheckData_vt.size(); i++) {
                D16OTHDDupCheckData c_Data = (D16OTHDDupCheckData) OTHDDupCheckData_vt.get(i);
                String s_BEGUZ1 = c_Data.BEGUZ.substring(0, 2) + c_Data.BEGUZ.substring(3, 5);
                String s_ENDUZ1 = c_Data.ENDUZ.substring(0, 2) + c_Data.ENDUZ.substring(3, 5);
                if (s_ENDUZ1.equals("0000")) {
                    s_ENDUZ1 = "2400";
                }
                int s_BEGUZ = Integer.parseInt(s_BEGUZ1 + "00");
                int s_ENDUZ = Integer.parseInt(s_ENDUZ1 + "00");
                // Logger.debug.println("<br>D01OTMbBuildSV c_Data +++ >"+c_Data.toString() );
                // Logger.debug.println("<br>D01OTMbBuildSV D01OTData ++++ >"+data.toString() );
                // Logger.debug.println("<br>D01OTMbBuildSV s_BEGUZ ++++ >"+s_BEGUZ+"Integer.parseInt(D01OTData.BEGUZ)" +Integer.parseInt(data.BEGUZ));
                // Logger.debug.println("<br>D01OTMbBuildSV s_ENDUZ ++++ >"+s_ENDUZ+"Integer.parseInt(D01OTData.ENDUZ)" +Integer.parseInt(data.ENDUZ));

                c_workDate = c_Data.WORK_DATE.replace("-", "");
                // Logger.debug.println("<br>c_workDate : "+c_workDate);

                if (c_workDate.equals(data.WORK_DATE)) {

                    /** start: 종료시간이 익일로 넘어가는경우의 오류수정(2016/12/12 ksc) */
                    int c_BEGUZ = Integer.parseInt(data.BEGUZ);
                    int c_ENDUZ = Integer.parseInt(data.ENDUZ);
                    if (c_BEGUZ > c_ENDUZ) {
                        c_ENDUZ = c_ENDUZ + 240000;
                    }

                    if (!"R".equals(c_Data.APPR_STAT) && s_BEGUZ == Integer.parseInt(data.BEGUZ) && s_ENDUZ == Integer.parseInt(data.ENDUZ)) {
                        message = "현재 결재신청이 되어 있으므로 결재진행현황에서 확인하시기 바랍니다.";
                        return message;
                    }
                    // ENDUZ가 다음날로 넘어가지 않을 경우.
                    else if (!"R".equals(c_Data.APPR_STAT) && s_BEGUZ < s_ENDUZ
                                    && ((s_BEGUZ <= c_BEGUZ && s_ENDUZ > c_BEGUZ) || (s_BEGUZ < c_ENDUZ && s_ENDUZ >= c_ENDUZ) || (s_BEGUZ >= c_BEGUZ && s_ENDUZ <= c_ENDUZ))) {
                        message = "현재 결재신청이 되어 있으므로 결재진행현황에서 확인하시기 바랍니다.";
                        return message;
                    }
                    /** end: 종료시간이 익일로 넘어가는경우의 오류수정(2016/12/12 ksc) */

                    // ENDUZ가 다음날로 넘어가는 경우.
                    // [CSR ID:2727336] 기 신청일이 현재 신청일보다 나중 날짜일 경우 조건이 추가되어야 함.
                    // else if(!c_Data.APPR_STAT.equals("R") && s_BEGUZ > s_ENDUZ && ((( s_BEGUZ<= Integer.parseInt(D01OTData.BEGUZ) && Integer.parseInt(D01OTData.BEGUZ) < 2400) ||
                    // (Integer.parseInt(D01OTData.BEGUZ) >= 0000 && s_ENDUZ > Integer.parseInt(D01OTData.BEGUZ))) || ((Integer.parseInt(D01OTData.ENDUZ) <= 2400 && s_BEGUZ <
                    // Integer.parseInt(D01OTData.ENDUZ)) || (Integer.parseInt(D01OTData.ENDUZ) > 0000 && s_ENDUZ >= Integer.parseInt(D01OTData.ENDUZ))) || (Integer.parseInt(D01OTData.BEGUZ)
                    // >Integer.parseInt(D01OTData.ENDUZ) && s_BEGUZ >= Integer.parseInt(D01OTData.BEGUZ) && s_ENDUZ <= Integer.parseInt(D01OTData.ENDUZ))) ) {
                    else if (!"R".equals(c_Data.APPR_STAT) && s_BEGUZ > s_ENDUZ && (((s_BEGUZ <= Integer.parseInt(data.BEGUZ) && Integer.parseInt(data.BEGUZ) < 2400)
                                    || (Integer.parseInt(data.BEGUZ) >= 0000 && s_ENDUZ > Integer.parseInt(data.BEGUZ) && s_BEGUZ < Integer.parseInt(data.ENDUZ))
                                    || (Integer.parseInt(data.BEGUZ) >= 0000 && s_BEGUZ < Integer.parseInt(data.ENDUZ) && s_BEGUZ > Integer.parseInt(data.ENDUZ)))
                                    || ((Integer.parseInt(data.ENDUZ) <= 2400 && s_BEGUZ < Integer.parseInt(data.ENDUZ))
                                    || (Integer.parseInt(data.ENDUZ) > 0000 && s_ENDUZ >= Integer.parseInt(data.ENDUZ)))
                                    || (Integer.parseInt(data.BEGUZ) > Integer.parseInt(data.ENDUZ) && s_BEGUZ >= Integer.parseInt(data.BEGUZ) && s_ENDUZ <= Integer.parseInt(data.ENDUZ)))) {
                        message = "이미 결재신청된 시간과 중복됩니다. 결재진행현황에서 확인하시기 바랍니다.";
                        return message;
                    }
                }
            }
            // DUP CHECK END


            // [CSR ID:2595636] 동일일에 휴가&대근 차단 요청 건 휴가와 초과근무는 같은날 신청할 수 없다.
            D16OTHDDupCheckRFC2 checkFunc = new D16OTHDDupCheckRFC2();
            Vector OTHDDupCheckData_new_vt = checkFunc.getChecResult(PERNR, UPMU_TYPE, data.WORK_DATE, data.WORK_DATE);
            String e_flag = OTHDDupCheckData_new_vt.get(0).toString();
            String e_message = OTHDDupCheckData_new_vt.get(1).toString();

            if (e_flag.equals("Y")) {// Y면 중복, N은 OK
                message = e_message;
                Logger.debug.println(this, "[중복검사 Y [message : " + message + "]");
            } else {
                Logger.debug.println(this, "[checkData 00001] ");

                // 2002.07.04. 신청시간이 근무일정과 중복되었을경우 R3에 초과근무 신청 로직을 적용하기위해서 수정함.
                D01OTCheckRFC func = new D01OTCheckRFC();
                //[WorkTime52] ZGHR_RFC_IS_AVAIL_OVERTIME 파라미터 추가(I_NTM = X)
                Vector D01OTCheck_vt = func.check(PERNR, data.WORK_DATE, data.WORK_DATE, data.BEGUZ, data.ENDUZ, "X");

                D01OTCheckData checkData = (D01OTCheckData) D01OTCheck_vt.get(0);

                if (!checkData.ERRORTEXTS.equals("") && checkData.STDAZ.equals("0")) {  // 에러메시지가 있고, 한계결정을 할 수 없는 경우
                    message = message + " 근무일정과 중복되었습니다. 다시 신청해주십시요.";
                } else if (checkData.ERRORTEXTS.equals("")) {                          				// 에러메시지가 없고, 정상적이거나 한계결정을 한 경우.
                    if (checkData.BEGUZ.equals(data.BEGUZ) && checkData.ENDUZ.equals(data.ENDUZ)) {
                        message = message + "";
                    } else {
                        message = message + " 근무일정과 중복되어 신청시간을 정정하였습니다.";
                        data.BEGUZ = checkData.BEGUZ;                                    				// 한계결정한 시간정보로 재설정해준다.
                        data.ENDUZ = checkData.ENDUZ;
                        data.STDAZ = checkData.STDAZ;
                        Logger.debug.println(this, "[message] :: " + message);
                    }
                }
                // 2002.07.04. 신청시간이 근무일정과 중복되었을경우 R3에 초과근무 신청 로직을 적용하기위해서 수정함.


                // [WorkTime52] Start
                final String I_PERNR = PERNR;
                Map<String, Object> rfcResultData = RfcHandler.execute("ZGHR_RFC_NTM_GET_EMPGUB", new HashMap<String, Object>() {
                    {
                        put("I_PERNR", I_PERNR);
                    }
                });
                // 사원구분
                final String I_EMPGUB = ObjectUtils.toString(getData(rfcResultData, "EXPORT", g.getMessage("MSG.D.D01.0063")).get("E_EMPGUB"));
                final String I_WORK = ObjectUtils.toString(getData(rfcResultData, "EXPORT", g.getMessage("MSG.D.D01.0063")).get("E_WORK"));
                /*
                             rfcResultData = RfcHandler.execute("ZGHR_RFC_NTM_WORKDAY_LIST", new HashMap<String, Object>() {
                 {
                     put("I_EMPGUB"	, I_EMPGUB);
                     put("I_PERNR"		, I_PERNR);
                     put("I_BEGDA"		, I_WORK_DATE);
                     put("I_ENDDA"	, I_WORK_DATE);
                 }
                             });

                             List Holiday = (List)getData(rfcResultData, "TABLES", g.getMessage("MSG.D.D01.0063")).get("T_WLIST");
                             //if(CollectionUtils.isEmpty(Holiday)){
                             	//오류메세지
                             //}

                             final String Holidaycheck01 =  (String)((Map)Holiday.get(0)).get("HOLID");	//공휴일 X
                             final String Holidaycheck02 =  (String)((Map)Holiday.get(0)).get("SOLLZ");	//비근무일 0
                */
                String HolidayYN = "";
                if (I_WORK == "X") {
                    HolidayYN = "Y";
                } else {
                    HolidayYN = "N";
                }

                Logger.debug.println(this, "Holidaycheck value :: [" + I_WORK + "]");
                Logger.debug.println(this, "BEGUZ :: [" + Integer.parseInt(data.BEGUZ) + "]");
                Logger.debug.println(this, "ENDUZ :: [" + Integer.parseInt(data.ENDUZ) + "]");

                if (I_EMPGUB.equals("S")) {
                    if (HolidayYN == "Y") {	// 휴일
                        if (Integer.parseInt(data.BEGUZ) < 070000 || Integer.parseInt(data.ENDUZ) > 190000) {
                            message = message + "휴일근로의 시작시간, 종료시간 인정 기준시간은 07:00 ~ 19:00 입니다.";
                        }
                        if (!data.BEGUZ.substring(2, 4).equals(data.ENDUZ.substring(2, 4))) {
                            message = message + "휴일근로의 시작 및 종료 시간은 한 시간 단위로 신청 가능 합니다.\n단, 입력 시각은 10분 단위로 입력하여 주시기를 바랍니다.\n예) 시작 09:30 ~ 종료 13:30 (○)\n     시작 09:31 ~ 종료 13:31 (Ｘ)";
                        }
                    } else {	// 평일
                        if (!data.BEGUZ.substring(2, 4).equals(data.ENDUZ.substring(2, 4))) {
                            message = message + "초과근로의 시작 및 종료 시간은 한 시간 단위로 신청 가능 합니다.\n단, 입력 시각은 10분 단위로 입력하여 주시기를 바랍니다.\n예) 시작 09:30 ~ 종료 13:30 (○)\n     시작 09:31 ~ 종료 13:31 (Ｘ)";
                        }
                    }

                } else {
                    if (HolidayYN == "Y") {
                        if (Integer.parseInt(data.BEGUZ) < 070000 || Integer.parseInt(data.ENDUZ) > 190000) {
                            message = message + "휴일근로의 시작시간, 종료시간 인정 기준시간은 07:00 ~ 19:00 입니다.";
                        }
                    }
                }

                // RFC : ZGHR_RFC_NTM_OT_AVAL_CHK_ADD
                Logger.debug.println(this, "check Add RFC 시작");
                D01OTCheckDataAdd ChkData = new D01OTCheckDataAdd();
                Vector ChkDataAdd_vt = new Vector();

                DataUtil.getCurrentDate();	// 신청일 = 현재일자
                ChkData.PERNR = PERNR;
                ChkData.BEGDA = data.WORK_DATE;
                ChkData.WORK_DATE = data.WORK_DATE;
                ChkData.VTKEN = "";
                ChkData.BEGUZ = data.BEGUZ;
                ChkData.ENDUZ = data.ENDUZ;
                ChkData.STDAZ = data.STDAZ;
                ChkData.ZPERNR = data.ZPERNR;

                ChkDataAdd_vt.addElement(ChkData);

                D01OTCheckAddRFC chkaddFunc = new D01OTCheckAddRFC();
                Vector ret = chkaddFunc.check(ChkDataAdd_vt);

                // message = message + chkaddFunc.getReturn().MSGTX;

                if ( chkaddFunc.getReturn().MSGTY.equals("W"))
                {
                	message = "";
                } else {
                	message = chkaddFunc.getReturn().MSGTX;
                }

                //message = chkaddFunc.getReturn().MSGTX;
                if ( message.equals("") || message == null) {
                	message = "";
                }

                Logger.debug.println(this, " Add Check chkaddFunc.getReturn().MSGTX >> " + chkaddFunc.getReturn().MSGTX);
                Logger.debug.println(this, " Add Check MESSAGE >> " + message);
                // [WorkTime52] End

            }

        } catch (Exception e) {
            throw new GeneralException(e);

        } finally {
        }
        return message;
    }

    // [CSR ID:3608185] e-HR 초과근무 사후신청 관련 시스템 개선 요청
    protected void OTAfterCheck(D01OTData data) {
        int dayCount = DataUtil.getBetween(data.BEGDA, data.WORK_DATE);
        if (dayCount < 0)
            OT_AFTER = "사후신청";
        else
            OT_AFTER = "";
    }

    // WorkTime52
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

    /**
     * RFC 실행 결과로 얻어온 data에서 사무직(월간)/현장직(주간) 실근로시간 현황표 data를 추출하여 반환
     *
     * @param rfcResultData
     * @param EMPGUB
     * @param message
     * @return
     * @throws GeneralException
     */
    private Map<String, Object> getSummaryData(Map<String, Object> rfcResultData, String EMPGUB, String message) throws GeneralException {
        /*
        if ("H".equals(EMPGUB)) {
            List<Map<String, Object>> T_HDATA = (List<Map<String, Object>>) getData(rfcResultData, "TABLES", message).get("T_HDATA");

            if (CollectionUtils.isEmpty(T_HDATA)) {
                throw new GeneralException(message);
            }

            Map<String, Object> data = T_HDATA.get(0);
            data.put("MAXTM", data.get("WKLMT"));
            return data;

        } else {
            return (Map<String, Object>) getData(rfcResultData, "EXPORT", message).get("E_SDATA");

        }
        */
        return (Map<String, Object>) getData(rfcResultData, "EXPORT", message).get("ES_EMPGUB_H");
    }

}
