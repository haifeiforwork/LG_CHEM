/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 초과근무                                                    */
/*   Program Name : 초과근무 수정                                               */
/*   Program ID   : D01OTChangeSV                                               */
/*   Description  : 초과근무를 수정 할 수 있도록 하는 Class                     */
/*   Note         :                                                             */
/*   Creation     : 2002-01-21  박영락                                          */
/*   Update       : 2005-03-07  윤정현                                          */
/*                  2014-05-13  C20140515_40601  사무직시간선택제(6H,4H )  휴일,공휴일이면서 4,6시간 만 가능하게 체크로직추가*/
/*				E_PERSK - 27  : 사무직시간선택제(4H)  28 :  사무직(6H)  */
/*             2014-08-24   [CSR ID:2595636] 동일일에 휴가&대근 차단 요청 건    */
/*             2015-06-18   [CSR ID:2803878] 초과근무 신청 Process 변경 요청    */
/*             2018-06-05   [WorkTime52] 주52시간 근무시간 대응    				*/
/********************************************************************************/

package servlet.hris.D.D01OT;

import java.util.HashMap;
import java.util.Map;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.ObjectUtils;
import org.apache.commons.lang.StringUtils;

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

import hris.D.D01OT.D01OTCheckData;
import hris.D.D01OT.D01OTCheckDataAdd;
import hris.D.D01OT.D01OTData;
import hris.D.D01OT.D01OTHolidayCheckData;
import hris.D.D01OT.D01OTRealWorkDATA;
import hris.D.D01OT.rfc.D01OTCheckAddRFC;
import hris.D.D01OT.rfc.D01OTCheckRFC;
import hris.D.D01OT.rfc.D01OTHolidayCheckRFC;
import hris.D.D01OT.rfc.D01OTRFC;
import hris.D.D01OT.rfc.D01OTRealWrokListRFC;
import hris.D.rfc.D02KongsuHourRFC;
import hris.D.rfc.D16OTHDDupCheckRFC;
import hris.D.rfc.D16OTHDDupCheckRFC2;
import hris.common.PersonData;
import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalHeader;
import hris.common.approval.ApprovalLineData;
import hris.common.rfc.PersonInfoRFC;
/*[WorkTime52] end*/

@SuppressWarnings({ "rawtypes", "serial" })
public class D01OTChangeSV extends ApprovalBaseServlet {

    private String UPMU_TYPE = "17";      // 결재 업무타입(초과근무)
    private String UPMU_NAME = "초과근무";

    protected String getUPMU_TYPE() {
        return UPMU_TYPE;
    }

    protected String getUPMU_NAME() {
        return UPMU_NAME;
    }

    protected void performTask(final HttpServletRequest req, final HttpServletResponse res) throws GeneralException {
        try {

            final WebUserData user = WebUtil.getSessionUser(req);
            /************** Start: 국가별 분기처리 **********************************************************/
            if (!user.area.equals(Area.KR)) { 	// 해외화면으로
                printJspPage(req, res, WebUtil.ServletURL + "hris.D.D01OT.D01OTChangeGlobalSV");
                return;
            }

            /************** END: 국가별 분기처리 *********************************************************/

            String dest = "";

            final Box box = WebUtil.getBox(req);
            final String jobid = box.get("jobid", "first");
            Logger.debug.println(this, "[jobid] = " + jobid + " [user] : " + user.toString());

            final D01OTRFC rfc = new D01OTRFC();

            String I_APGUB = (String) req.getAttribute("I_APGUB");  // 어느 페이지에서 왔나? '1' : 결재할 문서 , '2' : 결재중 문서 , '3' : 결재완료 문서
            Logger.debug.println(this, "[I_APGUB] = " + I_APGUB);

            final String ainf_seqn = box.get("AINF_SEQN");
            // 현재 수정할 레코드..
            rfc.setDetailInput(user.empNo, I_APGUB, ainf_seqn); // 결재란설정
            Vector D01OTData_vt = null;

            D01OTData_vt = rfc.getDetail(ainf_seqn, "");

            // final String PERNR = getPERNR(box, user); //신청대상자 사번
            final String PERNR = rfc.getApprovalHeader().PERNR;
            final D01OTData firstData = (D01OTData) Utils.indexOf(D01OTData_vt, 0);

            // 대리 신청 추가
            PersonInfoRFC numfunc = new PersonInfoRFC();
            final PersonData phonenumdata = (PersonData) numfunc.getPersonInfo(firstData.PERNR);
            req.setAttribute("PersonData", phonenumdata);

            req.setAttribute("committed", "N"); // check already response 2017/1/3 ksc

            /*************************************************************************************/
            if (jobid.equals("first")) {

                req.setAttribute("jobid", jobid);
                req.setAttribute("D01OTData_vt", D01OTData_vt);
                req.setAttribute("isUpdate", true); // [결재]등록 수정 여부 <- 수정쪽에는 반드시 필요함

                D16OTHDDupCheckRFC d16OTHDDupCheckRFC = new D16OTHDDupCheckRFC();
                Vector OTHDDupCheckData_vt = null;
                OTHDDupCheckData_vt = d16OTHDDupCheckRFC.getCheckList(firstData.PERNR, UPMU_TYPE, user.area);
                Logger.debug.println(this, "OTHDDupCheckData_vt : " + OTHDDupCheckData_vt.toString());

                req.setAttribute("OTHDDupCheckData_vt", OTHDDupCheckData_vt);

                // [WorkTime52]
                // 사원 구분 조회(사무직:A,C / 현장직:B,D)
                Map<String, Object> rfcResultData = RfcHandler.execute("ZGHR_RFC_NTM_GET_EMPGUB", new HashMap<String, Object>() {
                    {
                        put("I_PERNR", PERNR);
                    }
                });

                Map<String, Object> EXPORT = getData(rfcResultData, "EXPORT", g.getMessage("MSG.D.D01.0063"));
                final String EMPGUB = ObjectUtils.toString(EXPORT.get("E_EMPGUB"));
                final String TPGUB 	= ObjectUtils.toString(EXPORT.get("E_TPGUB"));		// A(사무직-일반), B(현장직-일반), C(사무직-선택근로제), D(현장직-탄력근로제)
                final String I_DATE = firstData.WORK_DATE.replaceAll("[^\\d]", "");
                final String I_VTKEN = firstData.VTKEN;
                final String I_AINF_SEQN = firstData.AINF_SEQN;

                D01OTRealWrokListRFC realworkfunc = new D01OTRealWrokListRFC();
                if (EMPGUB.equals("S")) {
                    String MODE = "";

                    final D01OTRealWorkDATA WorkData = realworkfunc.getResult(EMPGUB, PERNR, I_DATE, I_VTKEN, I_AINF_SEQN, MODE);
                    if (realworkfunc.getReturn().isSuccess()) {
                        req.setAttribute("WorkData", WorkData); // 나중에
                    } else {
                        req.setAttribute("WorkData", "");
                        Logger.debug.println(this, "실근무시간 조회 에러!!");
                    }
                } else {
                    // 월간 실근로시간 현황 조회
                    rfcResultData = RfcHandler.execute("ZGHR_RFC_NTM_OT_REQ_RW_LIST", new HashMap<String, Object>() {
                        {
                            put("I_PERNR", PERNR);
                            put("I_DATUM", I_DATE);
                            put("I_EMPGUB", EMPGUB);
                        }
                    });
                    WebUtil.setAttributes(req, getSummaryData(rfcResultData, EMPGUB, g.getMessage("MSG.D.D01.0064", "1"))); // 사무직(월간)/현장직(주간) 실근로시간 현황 데이터를 조회하지 못하였습니다.
                }

                req.setAttribute("EMPGUB", EMPGUB);
                req.setAttribute("TPGUB" , TPGUB);
                req.setAttribute("DATUM" , I_DATE);

                Logger.debug.println(this, "[first] EMPGUB :: " + EMPGUB);
                Logger.debug.println(this, "[first] TPGUB  :: " + TPGUB);
                Logger.debug.println(this, "[first] DATUM  :: " + I_DATE);
                // [WorkTime52]

                detailApporval(req, res, rfc);

                dest = WebUtil.JspURL + "D/D01OT/D01OTBuild_KR.jsp";// "D/D01OT/D01OTChange.jsp";

            /*************************************************************************************/
            } else if (jobid.equals("check")) {
                final D01OTBuildSV sv = new D01OTBuildSV();
                sv.checkCommon(box, PERNR, user, req);
                req.setAttribute("isUpdate", true); // [결재]등록 수정 여부 <- 수정쪽에는 반드시 필요함
                req.setAttribute("jobid", jobid);
                detailApporval(req, res, rfc);

                // [WorkTime52]
                // 사원 구분 조회(사무직:A,C / 현장직:B,D)
                Map<String, Object> rfcResultData = RfcHandler.execute("ZGHR_RFC_NTM_GET_EMPGUB", new HashMap<String, Object>() {
                    {
                        put("I_PERNR", PERNR);
                    }
                });

                Map<String, Object> EXPORT = getData(rfcResultData, "EXPORT", g.getMessage("MSG.D.D01.0063"));
                final String EMPGUB = ObjectUtils.toString(EXPORT.get("E_EMPGUB"));
                final String TPGUB 	= ObjectUtils.toString(EXPORT.get("E_TPGUB"));
                final String DATE 	= box.get("WORK_DATE");
                final String VTKEN 	= box.get("VTKEN");

                Logger.debug.println(this, "Box.get[work_date] >> " + box.get("WORK_DATE"));
                req.setAttribute("EMPGUB", EMPGUB);
                req.setAttribute("TPGUB" , TPGUB);
                req.setAttribute("DATUM" , DATE );

                D01OTRealWrokListRFC realworkfunc = new D01OTRealWrokListRFC();
                if (EMPGUB.equals("S")) {
                    final D01OTRealWorkDATA WorkData = realworkfunc.getResult(EMPGUB, PERNR, DATE, VTKEN, ainf_seqn, "");
                    if (realworkfunc.getReturn().isSuccess()) {
                        req.setAttribute("WorkData", WorkData); // 나중에
                    } else {
                        req.setAttribute("WorkData", "");
                        Logger.debug.println(this, "실근무시간 조회 에러!!");
                    }
                } else {
                    // 월간 실근로시간 현황 조회
                    rfcResultData = RfcHandler.execute("ZGHR_RFC_NTM_OT_REQ_RW_LIST", new HashMap<String, Object>() {
                        {
                            put("I_PERNR", PERNR);
                            put("I_DATUM", DATE);
                            put("I_EMPGUB", EMPGUB);
                        }
                    });
                    WebUtil.setAttributes(req, getSummaryData(rfcResultData, EMPGUB, g.getMessage("MSG.D.D01.0064", "1"))); // 사무직(월간)/현장직(주간) 실근로시간 현황 데이터를 조회하지 못하였습니다.
                }
                // [WorkTime52] END

                dest = WebUtil.JspURL + "D/D01OT/D01OTBuild_KR.jsp";

                /*
                            } else if( jobid.equals("check") ) {

                D01OTData_vt   = new Vector();
                D01OTData data = new D01OTData();

                box.copyToEntity(data);
                DataUtil.fixNull(data);

                D01OTData_vt.addElement(data);  //정보를 클라이언트로 되돌린다.

                String message  = "";

                //[CSR ID:2595636] 동일일에 휴가&대근 차단 요청 건
                D16OTHDDupCheckRFC2 checkFunc = new D16OTHDDupCheckRFC2();
                Vector OTHDDupCheckData_new_vt = checkFunc.getChecResult( firstData.PERNR, UPMU_TYPE, data.WORK_DATE, data.WORK_DATE);
                String e_flag = OTHDDupCheckData_new_vt.get(0).toString();
                String e_message = OTHDDupCheckData_new_vt.get(1).toString();

                if( e_flag.equals("Y")){//Y면 중복, N은 OK
                	message = e_message;
                }else{
                    D01OTCheckRFC func = new D01OTCheckRFC();
                    Vector D01OTCheck_vt = func.check( firstData.PERNR, data.WORK_DATE, data.WORK_DATE, data.BEGUZ, data.ENDUZ );

                    // 2002.07.04. 신청시간이 근무일정과 중복되었을경우 R3에 초과근무 신청 로직을 적용하기위해서 수정함.


                    D01OTCheckData checkData = (D01OTCheckData)D01OTCheck_vt.get(0);

                    if( !checkData.ERRORTEXTS.equals("") && checkData.STDAZ.equals("0") ) {        //에러메시지가 있고, 한계결정을 할 수 없는 경우
                        message = "근무일정과 중복되었습니다.";
                    } else if( checkData.ERRORTEXTS.equals("") ) {                                 //에러메시지가 없고, 정상적이거나 한계결정을 한 경우.
                        if( checkData.BEGUZ.equals(data.BEGUZ) && checkData.ENDUZ.equals(data.ENDUZ) ) {
                            message = "";
                        } else {
                            message = "근무일정과 중복되어 신청시간을 정정하였습니다.";
                            data.BEGUZ = checkData.BEGUZ;                                          //한계결정한 시간정보로 재설정해준다.
                            data.ENDUZ = checkData.ENDUZ;
                            data.STDAZ = checkData.STDAZ;
                        }
                    }
                    // 2002.07.04. 신청시간이 근무일정과 중복되었을경우 R3에 초과근무 신청 로직을 적용하기위해서 수정함.
                }

                //결재정보를 되돌린다.
                Vector AppLineData_vt  = new Vector();
                int rowcount = box.getInt("RowCount");
                for( int i = 0; i < rowcount; i++) {
                    AppLineData appLine = new AppLineData();
                   // String      idx     = Integer.toString(i);

                    // 같은 이름으로 여러행 받을때
                    box.copyToEntity(appLine ,i);

                    AppLineData_vt.addElement(appLine);
                }

                D16OTHDDupCheckRFC func2 = new D16OTHDDupCheckRFC();
                Vector OTHDDupCheckData_vt = func2.getCheckList( firstData.PERNR, UPMU_TYPE );

                req.setAttribute("message", message);
                req.setAttribute("jobid", jobid);
                req.setAttribute("D01OTData_vt",  D01OTData_vt);
                req.setAttribute("AppLineData_vt", AppLineData_vt);
                req.setAttribute("OTHDDupCheckData_vt", OTHDDupCheckData_vt);
                dest = WebUtil.JspURL+"D/D01OT/D01OTChange.jsp";
                */

                /*************************************************************************************/
            } else if (jobid.equals("change")) {
                Logger.debug.println(this, "change...");

                // 실제 수정 부분 /
                dest = changeApproval(req, box, D01OTData.class, rfc, new ChangeFunction<D01OTData>() {

                    public String porcess(D01OTData data, ApprovalHeader approvalHeader, Vector<ApprovalLineData> approvalLine) throws GeneralException {

                        Vector D01OTData_vt = new Vector();
                        box.copyToEntity(data);
                        DataUtil.fixNull(data);

                        data.PERNR	= PERNR;
                        data.ZPERNR = user.empNo;              // 신청자 사번(대리신청, 본인 신청)
                        data.UNAME 	= user.empNo;              // 신청자 사번(대리신청, 본인 신청)
                        data.AEDTM 	= DataUtil.getCurrentDate();  // 변경일(현재날짜)
                        D01OTData_vt.addElement(data);

                        D01OTCheckRFC func = new D01OTCheckRFC();
                        // RFC : ZGHR_RFC_IS_AVAIL_OVERTIME [worktime52 PJT:2018-07-10 I_NTM [X] 추가]
                        Vector D01OTCheck_vt = func.check(firstData.PERNR, data.WORK_DATE, data.WORK_DATE, data.BEGUZ, data.ENDUZ, "X");

                        String message = "";
                        // C20140515_40601 인사하위영역 27,36: -사무직시간선택제(4H) 4시간체크 START
                        // C20140515_40601 인사하위영역 28,37: -사무직시간선택제(6H) 6시간체크
                        // 주말/공휴일 시간선택제 사무(27,28)/계약(36.37) 휴일특근은 4, 6 시간제약 동일
                        Logger.debug.println(this, "phonenumdata.E_PERSK : " + phonenumdata.E_PERSK);
                        if (phonenumdata.E_PERSK.equals("27") || phonenumdata.E_PERSK.equals("28") || phonenumdata.E_PERSK.equals("36") || phonenumdata.E_PERSK.equals("37")) { //

                            // 공휴일, 토,일만 가능
                            D01OTHolidayCheckRFC funHc = new D01OTHolidayCheckRFC();
                            Vector D01OTHolidayCheck_vt = funHc.check("L1", data.WORK_DATE, data.WORK_DATE);
                            D01OTHolidayCheckData HolidaycheckData = (D01OTHolidayCheckData) D01OTHolidayCheck_vt.get(0);
                            if (HolidaycheckData.HOLIDAY.equals("X") || (HolidaycheckData.WEEKDAY.equals("6") || HolidaycheckData.WEEKDAY.equals("7"))) {
                                if ((phonenumdata.E_PERSK.equals("27") || phonenumdata.E_PERSK.equals("36")) && !data.STDAZ.equals("4")) {
                                    message = "사무직 시간선택제(4H) 사원은 4시간만 신청가능합니다.";
                                }
                                if ((phonenumdata.E_PERSK.equals("28") || phonenumdata.E_PERSK.equals("37")) && !data.STDAZ.equals("6")) {
                                    message = "사무직 시간선택제(6H) 사원은 6시간만 신청가능합니다.";
                                }
                            } else { // 평일
                                if (phonenumdata.E_PERSK.equals("27") || phonenumdata.E_PERSK.equals("28")) { // 시간 선택제

                                    message = message + "사무직 시간선택제 사원은  공휴일, 토요일, 일요일에만 초과근무 신청이 가능합니다.";
                                }
                            }

                            Logger.debug.println(this, "HolidaycheckData : " + HolidaycheckData.toString());
                            Logger.debug.println(this, "[[message : " + message);
                        }
                        // C20140515_40601 인사하위영역 27: -사무직시간선택제(6H) 공휴일 6시간체크 END

                        // [CSR ID:2595636] 동일일에 휴가&대근 차단 요청 건
                        D16OTHDDupCheckRFC2 checkFunc = new D16OTHDDupCheckRFC2();
                        Vector OTHDDupCheckData_new_vt = checkFunc.getChecResult(firstData.PERNR, UPMU_TYPE, data.WORK_DATE, data.WORK_DATE);
                        String e_flag = OTHDDupCheckData_new_vt.get(0).toString();
                        String e_message = OTHDDupCheckData_new_vt.get(1).toString();

                        if (e_flag.equals("Y")) {// Y면 중복, N은 OK
                            message = e_message;
                        } else {
                            // 2002.07.04. 신청시간이 근무일정과 중복되었을경우 R3에 초과근무 신청 로직을 적용하기위해서 수정함.
                            D01OTCheckData checkData = (D01OTCheckData) D01OTCheck_vt.get(0);

                            if (!checkData.ERRORTEXTS.equals("") && checkData.STDAZ.equals("0")) {        // 에러메시지가 있고, 한계결정을 할 수 없는 경우
                                message = message + " 근무일정과 중복되었습니다. 다시 신청해주십시요.";
                            } else if (checkData.ERRORTEXTS.equals("")) {                                 // 에러메시지가 없고, 정상적이거나 한계결정을 한 경우.
                                if (checkData.BEGUZ.equals(data.BEGUZ) && checkData.ENDUZ.equals(data.ENDUZ)) {
                                    message = message + "";
                                } else {
                                    message = message + " 근무일정과 중복되어 신청시간을 정정하였습니다.";
                                    data.BEGUZ = checkData.BEGUZ;                                          // 한계결정한 시간정보로 재설정해준다.
                                    data.ENDUZ = checkData.ENDUZ;
                                    data.STDAZ = checkData.STDAZ;
                                }
                            }
                            // 2002.07.04. 신청시간이 근무일정과 중복되었을경우 R3에 초과근무 신청 로직을 적용하기위해서 수정함.
                        }

                        // [CSR ID:2803878] 요청 초과근무 신청화면 1주 12시간 체크
                        D02KongsuHourRFC rfcH = new D02KongsuHourRFC();
                        String yymm = DataUtil.getCurrentYear() + DataUtil.getCurrentMonth();
                        // 'C' = 현황, 'R' = 신청,'M' = 수정, 'G' = 결재
                        Vector submitData_vt = rfcH.getOvtmHour(firstData.PERNR, yymm, "M", data);
                        String PRECHECK = rfcH.getOvtmHour(firstData.PERNR, yymm, data.WORK_DATE, "");// 전일근태 체크가 가능한지 여부 확인(N이면 체크하면 안됨)
                        detailApporval(req, res, rfc);
                        req.setAttribute("isUpdate", true); // [결재]등록 수정 여부 <- 수정쪽에는 반드시 필요함

                        // [WorkTime52]사원 구분 조회(사무직:A,C / 현장직:B,D)
                        Map<String, Object> rfcResultData = RfcHandler.execute("ZGHR_RFC_NTM_GET_EMPGUB", new HashMap<String, Object>() {
                            {
                                put("I_PERNR", PERNR);
                            }
                        });

                        final String EMPGUB = ObjectUtils.toString(getData(rfcResultData, "EXPORT", g.getMessage("MSG.D.D01.0063")).get("E_EMPGUB"));
                        final String TPGUB  = ObjectUtils.toString(getData(rfcResultData, "EXPORT", g.getMessage("MSG.D.D01.0063")).get("E_TPGUB"));
                        final String I_DATE = data.WORK_DATE;

                        D01OTRealWrokListRFC realworkfunc = new D01OTRealWrokListRFC();
                        if (EMPGUB.equals("S")) {
                            String MODE = "";
                            final D01OTRealWorkDATA WorkData = realworkfunc.getResult(EMPGUB, PERNR, I_DATE, data.VTKEN, ainf_seqn, MODE);
                            if (realworkfunc.getReturn().isSuccess()) {
                                req.setAttribute("WorkData", WorkData); // 나중에
                            } else {
                                req.setAttribute("WorkData", "");
                                Logger.debug.println(this, "실근무시간 조회 에러!!");
                            }
                        } else {
                            // 월간 실근로시간 현황 조회
                            rfcResultData = RfcHandler.execute("ZGHR_RFC_NTM_OT_REQ_RW_LIST", new HashMap<String, Object>() {
                                {
                                    put("I_PERNR", PERNR);
                                    put("I_DATUM", I_DATE);
                                    put("I_EMPGUB", EMPGUB);
                                }
                            });
                            WebUtil.setAttributes(req, getSummaryData(rfcResultData, EMPGUB, g.getMessage("MSG.D.D01.0064", "1"))); // 사무직(월간)/현장직(주간) 실근로시간 현황 데이터를 조회하지 못하였습니다.
                        }
                        // [WorkTime52]

                        if (StringUtils.isBlank(message)) {
                            Logger.debug.println(this, "check Add RFC 시작");
                            // RFC : ZGHR_RFC_NTM_OT_AVAL_CHK_ADD [2018-07-10 AINF_SEQN 추가]
                            D01OTCheckDataAdd ChkData = new D01OTCheckDataAdd();
                            ChkData.PERNR = data.PERNR;
                            ChkData.AINF_SEQN = data.AINF_SEQN;	//Add
                            ChkData.BEGDA = data.WORK_DATE;
                            ChkData.WORK_DATE = data.WORK_DATE;
                            ChkData.VTKEN = data.VTKEN;
                            ChkData.BEGUZ = data.BEGUZ;
                            ChkData.ENDUZ = data.ENDUZ;
                            ChkData.STDAZ = data.STDAZ;
                            ChkData.ZPERNR = data.ZPERNR;

                            Vector ChkDataAdd_vt = new Vector();
                            ChkDataAdd_vt.addElement(ChkData);

                            // RFC : ZGHR_RFC_NTM_OT_AVAL_CHK_ADD
                            D01OTCheckAddRFC chkaddFunc = new D01OTCheckAddRFC();
                            chkaddFunc.check(ChkDataAdd_vt);

                            message = StringUtils.defaultString(chkaddFunc.getReturn().MSGTX);

                            Logger.debug.println(this, " Add Check chkaddFunc.getReturn().MSGTX >> " + message);
                        }

                        if (StringUtils.isNotBlank(message)) { // 원페이지로

                            D16OTHDDupCheckRFC func2 = new D16OTHDDupCheckRFC();
                            Vector OTHDDupCheckData_vt = func2.getCheckList(firstData.PERNR, UPMU_TYPE, user.area);

                            Logger.debug.println(this, "원래패이지로1");
                            req.setAttribute("msg2", message);
                            req.setAttribute("message", message);
                            req.setAttribute("jobid", jobid);
                            req.setAttribute("D01OTData_vt", D01OTData_vt);
                            req.setAttribute("OTHDDupCheckData_vt", OTHDDupCheckData_vt);
                            req.setAttribute("approvalLine", approvalLine); // 변경된 결재라인
                            req.setAttribute("committed", "Y");

                            // [WorkTime52]
                            req.setAttribute("EMPGUB", EMPGUB);
                            req.setAttribute("TPGUB", TPGUB);
                            req.setAttribute("DATUM", data.WORK_DATE);
                            // [WorkTime52]

                            String url = WebUtil.JspURL + "D/D01OT/D01OTBuild_KR.jsp";

                            printJspPage(req, res, url);

                            return null;

                            // [CSR ID:2803878] 요청 건 초과근무 신청내역 alert
                        } else if (!data.OVTM12YN.equals("N") || (PRECHECK.equals("N") && data.VTKEN.equals("X"))) { // confirm 용 message 추가

                            D16OTHDDupCheckRFC func2 = new D16OTHDDupCheckRFC();
                            Vector OTHDDupCheckData_vt = func2.getCheckList(user.empNo, UPMU_TYPE, user.area);

                            Logger.debug.println(this, "원래패이지로2");
                            Logger.debug.println(this, "Change DATUM : " + data.WORK_DATE + "  /   " + EMPGUB);
                            req.setAttribute("jobid", jobid);
                            req.setAttribute("D01OTData_vt", D01OTData_vt);
                            req.setAttribute("submitData_vt", submitData_vt);
                            req.setAttribute("PRECHECK", PRECHECK);
                            req.setAttribute("OTHDDupCheckData_vt", OTHDDupCheckData_vt);
                            // getApprovalInfo(req, PERNR); //<-- 반드시 추가

                            req.setAttribute("approvalLine", approvalLine); // 변경된 결재라인
                            req.setAttribute("committed", "Y");

                            // [WorkTime52]
                            req.setAttribute("EMPGUB", EMPGUB);
                            req.setAttribute("TPGUB", TPGUB);
                            req.setAttribute("DATUM", data.WORK_DATE);

                            // [WorkTime52]

                            String url = WebUtil.JspURL + "D/D01OT/D01OTBuild_KR.jsp";

                            printJspPage(req, res, url);

                            return null;
                        }

                        /*************************************************************************************/
                        // * 결재 신청 RFC 호출 * /
                        rfc.setChangeInput(user.empNo, UPMU_TYPE, approvalHeader.AINF_SEQN);

                        Logger.debug("-------- AINF_SEQN " + data.AINF_SEQN);

                        // changeRFC.build(firstData.PERNR, Utils.asVector(data), box, req);//ainf_seqn, bankflag,
                        rfc.change(ainf_seqn, firstData.PERNR, D01OTData_vt, box, req);

                        if (!rfc.getReturn().isSuccess()) {
                            req.setAttribute("msg", rfc.getReturn().MSGTX);   // 실패 메세지 처리 - 임시
                            return null;
                        }

                        return data.AINF_SEQN;
                        // * 개발자 작성 부분 끝 */
                    }
                });

                /*

                Vector AppLineData_vt = new Vector();
                D01OTData data      = new D01OTData();
                D01OTData_vt = new Vector();

                box.copyToEntity(data);
                DataUtil.fixNull(data);

                data.PERNR     = firstData.PERNR;
                data.AINF_SEQN = ainf_seqn;
                data.ZPERNR    = firstData.ZPERNR;        // 신청자 사번(대리신청, 본인 신청)
                data.UNAME     = user.empNo;              // 신청자 사번(대리신청, 본인 신청)
                data.AEDTM     = DataUtil.getCurrentDate();  // 변경일(현재날짜)


                    Logger.debug.println(this, "수정으로");
                    int rowcount = box.getInt("RowCount");
                    for( int i = 0; i < rowcount; i++ ) {
                        AppLineData appLine = new AppLineData();
                        String      idx     = Integer.toString(i);

                        // 같은 이름으로 여러행 받을때
                        box.copyToEntity(appLine ,i);

                        appLine.APPL_MANDT     = user.clientNo;
                        appLine.APPL_BUKRS     = user.companyCode;
                        appLine.APPL_PERNR     = firstData.PERNR;
                        appLine.APPL_BEGDA     = data.BEGDA;
                        appLine.APPL_AINF_SEQN = ainf_seqn;
                        appLine.APPL_UPMU_TYPE = UPMU_TYPE;

                        AppLineData_vt.addElement(appLine);
                    }
                    Logger.debug.println(this, AppLineData_vt.toString());

                    con = DBUtil.getTransaction();
                    AppLineDB appDB = new AppLineDB(con);

                    String msg;
                    String msg2 = null;

                    if( appDB.canUpdate((AppLineData)AppLineData_vt.get(0)) ) {

                        // 기존 결재자 리스트
                        Vector orgAppLineData_vt = AppUtil.getAppChangeVt(ainf_seqn);

                        appDB.change(AppLineData_vt);
                        rfc.change( ainf_seqn, firstData.PERNR, D01OTData_vt );
                        con.commit();

                        msg = "msg002";

                        AppLineData oldAppLine = (AppLineData) orgAppLineData_vt.get(0);
                        AppLineData newAppLine = (AppLineData) AppLineData_vt.get(0);

                        Logger.debug.println(this ,oldAppLine);
                        Logger.debug.println(this ,newAppLine);

                        if (!newAppLine.APPL_APPU_NUMB.equals(oldAppLine.APPL_PERNR)) {

                            // 결재자 변경시 멜 보내기 ,ElOffice 인터 페이스
                            phonenumdata = (PersonData)numfunc.getPersonInfo(firstData.PERNR);

                            // 이메일 보내기
                            Properties ptMailBody = new Properties();
                            ptMailBody.setProperty("SServer",user.SServer);             // ElOffice 접속 서버
                            ptMailBody.setProperty("from_empNo" ,user.empNo);           // 멜 발송자 사번
                            ptMailBody.setProperty("to_empNo" ,oldAppLine.APPL_PERNR);  // 멜 수신자 사번

                            ptMailBody.setProperty("ename" ,phonenumdata.E_ENAME);      // (피)신청자명
                            ptMailBody.setProperty("empno" ,phonenumdata.E_PERNR);      // (피)신청자 사번

                            ptMailBody.setProperty("UPMU_NAME" ,"초과근무");            // 문서 이름
                            ptMailBody.setProperty("AINF_SEQN" ,ainf_seqn);             // 신청서 순번

                            // 멜 제목
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
                                ElofficInterfaceData eof = ddfe.makeDocForChange(ainf_seqn ,user.SServer , phonenumdata.E_PERNR, ptMailBody.getProperty("UPMU_NAME") , oldAppLine.APPL_PERNR);
                                Vector vcElofficInterfaceData = new Vector();
                                vcElofficInterfaceData.add(eof);

                                ElofficInterfaceData eofD = ddfe.makeDocContents(ainf_seqn ,user.SServer,ptMailBody.getProperty("UPMU_NAME"));
                                vcElofficInterfaceData.add(eofD);

                                req.setAttribute("vcElofficInterfaceData", vcElofficInterfaceData);
                                dest = WebUtil.JspURL+"common/ElOfficeInterface.jsp";
                            } catch (Exception e) {
                                dest = WebUtil.JspURL+"common/msg.jsp";
                                msg2 = msg2 + "\\n" + " Eloffic 연동 실패" ;
                            } // end try
                        } else {
                            msg = "msg002";
                            dest = WebUtil.JspURL+"common/msg.jsp";
                        } // end if
                    } else {
                        msg = "msg005";
                        dest = WebUtil.JspURL+"common/msg.jsp";
                    } // end if

                    String url = "location.href = '" + WebUtil.ServletURL+"hris.D.D01OT.D01OTDetailSV?AINF_SEQN="+ainf_seqn+"" +
                    "&RequestPageName=" + RequestPageName + "';";
                    req.setAttribute("msg", msg);
                    req.setAttribute("msg2", msg2);
                    req.setAttribute("url", url);
                }
                */
            } else {
                throw new BusinessException(g.getMessage("MSG.COMMON.0016"));// "내부명령(jobid)이 올바르지 않습니다.");
            }
            Logger.debug.println(this, "destributed = " + dest);
            if (req.getAttribute("committed").equals("N")) {
                printJspPage(req, res, dest);
            }

        } catch (Exception e) {
            throw new GeneralException(e);
        } finally {
            // DBUtil.close(con);
            // try{ con.close(); } catch(Exception e){
            // Logger.err.println(e, e);
            // }
        }
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
