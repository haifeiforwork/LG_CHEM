/********************************************************************************/
/*                                                                              																*/
/*   System Name  : MSS                                                         														*/
/*   1Depth Name  : MY HR 정보                                                  																*/
/*   2Depth Name  : 초과근무 사후신청                                           																*/
/*   Program Name : 초과근무 사후신청 수정                                      															*/
/*   Program ID   : D01OTChangeSV                                               													*/
/*   Description  : 초과근무를 수정 할 수 있도록 하는 Class                     													*/
/*   Note         :                                                             																*/
/*   Creation     : 2018-06-12  강동민	 [WorkTime52] 주52시간 근무시간 대응    											*/
/*   Update       : 									                                          											*/
/*                                                                              																*/
/********************************************************************************/

package servlet.hris.D.D01OT;

import java.util.HashMap;
import java.util.Map;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.ObjectUtils;

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

import hris.D.D01OT.D01OTAfterWorkTimeDATA;
import hris.D.D01OT.D01OTData;
import hris.D.D01OT.D01OTRealWorkDATA;
import hris.D.D01OT.rfc.D01OTAFCheckRFC;
import hris.D.D01OT.rfc.D01OTAfterWorkPercheckRFC;
import hris.D.D01OT.rfc.D01OTAfterWorkTimeListRFC;
import hris.D.D01OT.rfc.D01OTRFC;
import hris.D.D01OT.rfc.D01OTRealWrokListRFC;
import hris.D.rfc.D02KongsuHourRFC;
import hris.common.EmpGubunData;
import hris.common.PersonData;
import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalHeader;
import hris.common.approval.ApprovalLineData;
import hris.common.rfc.GetEmpGubunRFC;
import hris.common.rfc.PersonInfoRFC;
import hris.D.D01OT.rfc.D01OTAFRFC;

@SuppressWarnings({ "rawtypes", "serial" })
public class D01OTAfterWorkChangeSV extends ApprovalBaseServlet {

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

            //final D01OTRFC rfc = new D01OTRFC();
            final D01OTAFRFC rfc = new D01OTAFRFC();

            String I_APGUB = (String) req.getAttribute("I_APGUB");  // 어느 페이지에서 왔나? '1' : 결재할 문서 , '2' : 결재중 문서 , '3' : 결재완료 문서
            Logger.debug.println(this, "[I_APGUB] = " + I_APGUB);

            final String ainf_seqn = box.get("AINF_SEQN");
            // 현재 수정할 레코드..
            rfc.setDetailInput(user.empNo, I_APGUB, ainf_seqn); // 결재란설정
            Vector D01OTData_vt = null;

            D01OTData_vt = rfc.getDetail(ainf_seqn, "");

            final String PERNR = rfc.getApprovalHeader().PERNR;
            final D01OTData firstData = (D01OTData) Utils.indexOf(D01OTData_vt, 0);

            // 대리 신청 추가
            PersonInfoRFC numfunc = new PersonInfoRFC();
            final PersonData phonenumdata = (PersonData) numfunc.getPersonInfo(firstData.PERNR);
            req.setAttribute("PersonData", phonenumdata);


            req.setAttribute("committed", "N"); // check already response 2017/1/3 ksc

            final String curdate = DataUtil.getCurrentDate();

            /*************************************************************************************/
            if (jobid.equals("first")) {

                req.setAttribute("jobid", jobid);
                req.setAttribute("D01OTData_vt", D01OTData_vt);
                req.setAttribute("isUpdate", true); // [결재]등록 수정 여부 <- 수정쪽에는 반드시 필요함

                // [WorkTime52]
                // 사원 구분 조회(사무직:A,C / 현장직:B,D)
                Map<String, Object> rfcResultData = RfcHandler.execute("ZGHR_RFC_NTM_GET_EMPGUB", new HashMap<String, Object>() {
                    {
                        put("I_PERNR", PERNR);
                    }
                });

                final String EMPGUB = ObjectUtils.toString(getData(rfcResultData, "EXPORT", g.getMessage("MSG.D.D01.0063")).get("E_EMPGUB"));
                final String TPGUB = ObjectUtils.toString(getData(rfcResultData, "EXPORT", g.getMessage("MSG.D.D01.0063")).get("E_TPGUB"));		// A(사무직-일반), B(현장직-일반), C(사무직-선택근로제), D(현장직-탄력근로제)
                final String I_DATE = firstData.WORK_DATE.replaceAll("[^\\d]", "");
                final String I_VTKEN = firstData.VTKEN;
                final String I_AINF_SEQN = ainf_seqn;

                D01OTRealWrokListRFC realworkfunc = new D01OTRealWrokListRFC();
                D01OTAfterWorkTimeListRFC rfcaf = new D01OTAfterWorkTimeListRFC();

                if (EMPGUB.equals("S")) {
                    final D01OTRealWorkDATA WorkData = realworkfunc.getResult(EMPGUB, PERNR, I_DATE, I_VTKEN, I_AINF_SEQN, "");
                    final D01OTAfterWorkTimeDATA AfterData = rfcaf.getResult("1", PERNR, I_DATE, I_VTKEN, ainf_seqn, curdate, ""); // 처리구분( 1 =상세 , 2 =결재의뢰, 3 =수정, 4 = 삭제 )

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

                Logger.debug.println(this, "[first] DATUM :: " + I_DATE);
                Logger.debug.println(this, "[first] EMPGUB :: " + EMPGUB);
                Logger.debug.println(this, "[first] TPGUB :: " + TPGUB);
                // [WorkTime52]

                detailApporval(req, res, rfc);

                dest = WebUtil.JspURL + "D/D01OT/D01OTAfterWorkBuild_KR.jsp";// "D/D01OT/D01OTChange.jsp";

                /*************************************************************************************/
            } else if (jobid.equals("check")) {
                final D01OTAfterWorkBuildSV sv = new D01OTAfterWorkBuildSV();
                sv.checkCommon(box, PERNR, user, req);
                req.setAttribute("isUpdate", true); // [결재]등록 수정 여부 <- 수정쪽에는 반드시 필요함
                req.setAttribute("jobid", jobid);
                detailApporval(req, res, rfc);
                dest = WebUtil.JspURL + "D/D01OT/D01OTAfterWorkBuild_KR.jsp";

                /*************************************************************************************/
            } else if (jobid.equals("change")) {
                Logger.debug.println(this, "change...");

                // 실제 수정 부분 /
                dest = changeApproval(req, box, D01OTData.class, rfc, new ChangeFunction<D01OTData>() {
                    public String porcess(D01OTData inputData, ApprovalHeader approvalHeader, Vector<ApprovalLineData> approvalLine) throws GeneralException {

                        box.copyToEntity(inputData);
                        inputData.PERNR = PERNR;
                        inputData.ZPERNR = user.empNo;              // 신청자 사번(대리신청, 본인 신청)
                        inputData.UNAME = user.empNo;              // 신청자 사번(대리신청, 본인 신청)
                        inputData.AEDTM = DataUtil.getCurrentDate();  // 변경일(현재날짜)

                        DataUtil.fixNull(inputData);

                        String PRECHECK = new D01OTAfterWorkPercheckRFC().getPRECHECK(PERNR, inputData.WORK_DATE, "").E_PRECHECK;
                        Logger.debug.println(this, "[change] PRECHECK >> " + PRECHECK);

                        String message = checkData(inputData);
                        Logger.debug.println(this, "checkData() After ....message >> [ " + message + " ]");

                        // [CSR ID:2803878] 요청 초과근무 신청화면 1주 12시간 체크
                        String yymm = DataUtil.getCurrentYear() + DataUtil.getCurrentMonth();
                        Vector submitData_vt = new D02KongsuHourRFC().getOvtmHour(firstData.PERNR, yymm, "M", inputData); // 'C' = 현황, 'R' = 신청,'M' = 수정, 'G' = 결재

                        detailApporval(req, res, rfc);

                        req.setAttribute("isUpdate", true); // [결재]등록 수정 여부 <- 수정쪽에는 반드시 필요함

                        // [WorkTime52]사원 구분 조회(사무직:A,C / 현장직:B,D)
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
                            final D01OTRealWorkDATA WorkData = realworkfunc.getResult(EMPGUB, PERNR, inputData.WORK_DATE, inputData.VTKEN, inputData.AINF_SEQN,"");
                            final D01OTAfterWorkTimeDATA AfterData = rfcaf.getResult("1", PERNR, inputData.WORK_DATE, inputData.VTKEN, ainf_seqn, curdate, "");

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

                        if (!message.equals("")) { // 원페이지로
                            Logger.debug.println(this, "원래패이지로1");

                            req.setAttribute("msg2", message);
                            req.setAttribute("message", message);
                            req.setAttribute("jobid", jobid);
                            req.setAttribute("D01OTData_vt", D01OTData_vt);
                            req.setAttribute("approvalLine", approvalLine); // 변경된 결재라인
                            req.setAttribute("committed", "Y");
                            // [WorkTime52]
                            req.setAttribute("EMPGUB", EMPGUB);
                            req.setAttribute("TPGUB", TPGUB);
                            req.setAttribute("DATUM", inputData.WORK_DATE);
                            // [WorkTime52]

                            String url = WebUtil.JspURL + "D/D01OT/D01OTAfterWorkBuild_KR.jsp";

                            printJspPage(req, res, url);

                            return null;

                            // [CSR ID:2803878] 요청 건 초과근무 신청내역 alert
                        } else if (!inputData.OVTM12YN.equals("N") || (PRECHECK.equals("N") && inputData.VTKEN.equals("X"))) { // confirm 용 message 추가
                            Logger.debug.println(this, "원래패이지로2");
                            Logger.debug.println(this, "Change DATUM : " + inputData.WORK_DATE + "  /   " + EMPGUB);

                            req.setAttribute("jobid", jobid);
                            req.setAttribute("D01OTData_vt", D01OTData_vt);
                            req.setAttribute("submitData_vt", submitData_vt);
                            req.setAttribute("PRECHECK", PRECHECK);
                            req.setAttribute("approvalLine", approvalLine); // 변경된 결재라인
                            req.setAttribute("committed", "Y");
                            // [WorkTime52]
                            req.setAttribute("EMPGUB", EMPGUB);
                            req.setAttribute("TPGUB", TPGUB);
                            req.setAttribute("DATUM", inputData.WORK_DATE);
                            // [WorkTime52]

                            String url = WebUtil.JspURL + "D/D01OT/D01OTAfterWorkBuild_KR.jsp";

                            printJspPage(req, res, url);

                            return null;
                        }

                        /*************************************************************************************/
                        // * 결재 신청 RFC 호출 * /
                        rfc.setChangeInput(user.empNo, UPMU_TYPE, approvalHeader.AINF_SEQN);

                        Logger.debug("-------- AINF_SEQN " + inputData.AINF_SEQN);

                        rfc.change(ainf_seqn, firstData.PERNR, D01OTData_vt, box, req);

                        if (!rfc.getReturn().isSuccess()) {
                            req.setAttribute("msg", rfc.getReturn().MSGTX);   // 실패 메세지 처리 - 임시
                            return null;
                        }

                        return inputData.AINF_SEQN;
                        // * 개발자 작성 부분 끝 */
                    }
                });

            } else {
                throw new BusinessException(g.getMessage("MSG.COMMON.0016"));// "내부명령(jobid)이 올바르지 않습니다.");
            }

            Logger.debug.println(this, "destributed = " + dest);

            if (req.getAttribute("committed").equals("N")) {
                printJspPage(req, res, dest);
            }

        } catch (Exception e) {
            throw new GeneralException(e);
        }
    }

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

}