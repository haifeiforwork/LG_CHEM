/********************************************************************************/
/*
/*   System Name  : Mobile
/*   1Depth Name  : 
/*   2Depth Name  : 
/*   Program Name : Flextime 신청
/*   Program ID   : D20FlextimeMbBuildSV
/*   Description  : 
/*   Note         : 
/*   Creation     : 2018-08-21 [WorkTime52]
/* 
/********************************************************************************/

package servlet.hris.D.D20Flextime;

import java.util.Properties;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.common.RFCReturnEntity;
import com.common.Utils;
import com.sns.jdf.ApLoggerWriter;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.mobile.MobileCodeErrVO;
import com.sns.jdf.mobile.XmlUtil;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.MobileXmlBaseServlet;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;

import hris.D.D20Flextime.D20FlextimeData;
import hris.D.D20Flextime.D20FlextimeScreen;
import hris.D.D20Flextime.rfc.D20FlextimeAuthCheckRFC;
import hris.D.D20Flextime.rfc.D20FlextimeCheckRFC;
import hris.D.D20Flextime.rfc.D20FlextimeRFC;
import hris.D.D20Flextime.rfc.D20FlextimeSelectScreenRFC;
import hris.common.DraftDocForEloffice;
import hris.common.MailSendToEloffic;
import hris.common.MobileReturnData;
import hris.common.PersonData;
import hris.common.WebUserData;
import hris.common.approval.ApprovalLineData;
import hris.common.approval.ApprovalLineRFC;
import hris.common.rfc.PersonInfoRFC;
import servlet.hris.MobileCommonSV;

@SuppressWarnings("serial")
public class D20FlextimeMbBuildSV extends MobileXmlBaseServlet {

    private final String UPMU_TYPE = "42";         // 결재 업무타입
    private final String UPMU_NAME = "Flextime";   // 결재 업무명
    private final String ROOT_NAME = "apprResult"; // XML root element name

    @Override
    protected String getRootName() {
        return ROOT_NAME;
    }

    @Override
    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {

        Logger.debug.println(this, "D20FlextimeMbBuildSV start");

        // 결재처리 및 처리결과 XML 문자열 생성
        String returnXml = apprItem(req, res);

        // 처리결과 XML 문자열 request에 저장
        req.setAttribute(RETURN_XML, returnXml);
        Logger.debug.println(this, "==============================================");
        Logger.debug.println(this, returnXml);

        // response에 처리결과 XML 문자열 출력
        printJspPage(req, res, WebUtil.JspURL + "common/mobileResult.jsp");

        Logger.debug.println(this, "D20FlextimeMbBuildSV end");
    }

    /**
     * 신청처리 결과를 XML형태로 가져온다.
     * 
     * @param req
     * @param res
     * @return
     * @throws GeneralException
     */
    @SuppressWarnings("rawtypes")
    private String apprItem(HttpServletRequest req, HttpServletResponse res) throws GeneralException {

        try {
            final Box box = WebUtil.getBox(req);
            final WebUserData user = WebUtil.getSessionUser(req);
            final String PERNR = user.empNo;

            // 대상자 여부 체크
            try {
                D20FlextimeAuthCheckRFC rfc = new D20FlextimeAuthCheckRFC();

                if (!"Y".equals(rfc.getE_AVAILABLE(PERNR))) {
                    return XmlUtil.createErroXml(ROOT_NAME, MobileCodeErrVO.ERROR_CODE_800, rfc.getReturn().MSGTX);
                }

            } catch (Exception e) {
                return XmlUtil.createErroXml(ROOT_NAME, MobileCodeErrVO.ERROR_CODE_800, e.getMessage());

            }

            // 선택근무제 대상자 체크
            try {
                D20FlextimeScreen screen = D20FlextimeScreen.lookup(new D20FlextimeSelectScreenRFC().getE_SCREEN(PERNR, null));

                if (screen != D20FlextimeScreen.A && screen != D20FlextimeScreen.B) {
                    return XmlUtil.createErroXml(ROOT_NAME, MobileCodeErrVO.ERROR_CODE_800, "Flextime 신청 대상자가 아닙니다.");
                }

            } catch (Exception e) {
                return XmlUtil.createErroXml(ROOT_NAME, MobileCodeErrVO.ERROR_CODE_800, e.getMessage());

            }

            // 결재선 인위적 변경 체크
            try {
                Vector<ApprovalLineData> approvalLine = box.getVector(ApprovalLineData.class, "APPLINE_");

                if (Utils.getSize(approvalLine) == 0) {
                    throw new Exception(g.getMessage("MSG.APPROVAL.0001")); // 승인자 정보가 없습니다.
                }

                for (ApprovalLineData row : approvalLine) {
                    row.APPU_NUMB = row.getAPPU_NUMB(); // 결재자 사번 복호화
                }

                if (!checkApprovalLine(approvalLine, new ApprovalLineRFC().getApprovalLine(UPMU_TYPE, PERNR))) {
                    throw new Exception("승인자 정보 오류입니다.");
                }

                Logger.debug.println(this, "결재라인 수 : " + approvalLine.size());
                Logger.debug.println(this, "결재라인    : " + approvalLine.toString());

                box.put("approver", approvalLine.get(0)); // 메일 수신자

            } catch (Exception e) {
                return XmlUtil.createErroXml(ROOT_NAME, MobileCodeErrVO.ERROR_CODE_300, e.getMessage());

            }

            D20FlextimeData inputData = box.createEntity(D20FlextimeData.class);
            Utils.setFieldValue(inputData, "ZPERNR", user.empNo);   // 신청자 사번 설정(대리신청 ,본인 신청)
            Utils.setFieldValue(inputData, "UNAME", user.empNo);    // 신청자 사번 설정(대리신청 ,본인 신청)
            Utils.setFieldValue(inputData, "AEDTM", DataUtil.getCurrentDate(req)); // 변경일(현재날짜) - 지역시간
            Utils.setFieldValue(inputData, "BEGDA", DataUtil.getCurrentDate(req));
            Utils.setFieldValue(inputData, "FLEX_BEGDA", DataUtil.removeStructur(inputData.FLEX_BEGDA));
            Utils.setFieldValue(inputData, "FLEX_ENDDA", DataUtil.removeStructur(inputData.FLEX_ENDDA));

            // Flextime 신청
            try {
                // 신청전 data 유효성 검증
                RFCReturnEntity checkResult = new D20FlextimeCheckRFC().check(inputData, "2");

                if (!checkResult.isSuccess()) {
                    return XmlUtil.createErroXml(ROOT_NAME, MobileCodeErrVO.ERROR_CODE_800, checkResult.MSGTX);
                }

                // Flextime 신청
                D20FlextimeRFC rfc = new D20FlextimeRFC();
                rfc.setRequestInput(PERNR, UPMU_TYPE);

                String AINF_SEQN = rfc.build(Utils.asVector(inputData), box, req);

                Logger.debug.println(this, "결재번호 AINF_SEQN : " + AINF_SEQN);

                if (!rfc.getReturn().isSuccess() || AINF_SEQN == null) {
                    return XmlUtil.createErroXml(ROOT_NAME, MobileCodeErrVO.ERROR_CODE_800, rfc.getReturn().MSGTX);
                }

                box.put("AINF_SEQN", AINF_SEQN);

            } catch (Exception e) {
                return XmlUtil.createErroXml(ROOT_NAME, MobileCodeErrVO.ERROR_CODE_800, e.getMessage());

            }

            // 결재자에게 메일 발송
            final ApprovalLineData approver = (ApprovalLineData) box.getObject("approver");
            final PersonData applicant = new PersonInfoRFC().getPersonInfo(PERNR);

            Logger.debug.println(this, "approver  : " + approver.toString());
            Logger.debug.println(this, "applicant : " + applicant.toString());

            Properties mailProperties = new Properties() {
                {
                    setProperty("SServer", user.SServer);           // ElOffice 접속 서버
                    setProperty("from_empNo", user.empNo);          // 메일 발송자 사번
                    setProperty("to_empNo", approver.APPU_NUMB);    // 메일 수신자 사번

                    setProperty("ename", applicant.E_ENAME);        // (피)신청자명
                    setProperty("empno", applicant.E_PERNR);        // (피)신청자 사번

                    setProperty("UPMU_NAME", UPMU_NAME);            // 문서 이름
                    setProperty("AINF_SEQN", box.get("AINF_SEQN")); // 결재번호
                    setProperty("USER_AREA", user.area.toString());

                    setProperty("subject", g.getMessage("MSG.APPROVAL.0002", UPMU_NAME)); // [HR] 결재요청 ({0})
                    setProperty("FileName", "MbNoticeMailBuild.html");
                }
            };
            MailSendToEloffic mail = new MailSendToEloffic(mailProperties);

            StringBuffer msg2 = new StringBuffer();
            if (!mail.process()) {
                Logger.warn.println(this, "메일 발송 오류 : " + mailProperties);
                msg2.append(mail.getMessage());
            }

            // 통합결재 연동
            try {
                Vector ifData = new Vector() {
                    {
                        add(new DraftDocForEloffice().makeDocContents(box.get("AINF_SEQN"), user.SServer, UPMU_NAME));
                    }
                };

                MobileReturnData ifResult = new MobileCommonSV().ElofficInterface(ifData, user);

                if (!ifResult.CODE.equals("0")) {
                    msg2.append(msg2.length() > 0 ? "\\n" : "").append(ifResult.VALUE);
                    Logger.err.println(this, msg2);

                    return XmlUtil.createErroXml(ROOT_NAME, MobileCodeErrVO.ERROR_CODE_400, msg2.toString());
                }

            } catch (Exception e) {
                msg2.append(msg2.length() > 0 ? "\\n" : "").append("통합결재 연동 실패").append("\\n").append(e.getMessage());
                Logger.err.println(this, msg2);

                return XmlUtil.createErroXml(ROOT_NAME, MobileCodeErrVO.ERROR_CODE_400, msg2.toString());

            }

            String subMenuNm = "모바일 Flextime 신청";
            String[] values = new String[] {inputData.PERNR, box.get("AINF_SEQN"), inputData.SCHKZ, inputData.FLEX_BEGDA, inputData.FLEX_ENDDA};

            // 대메뉴명, 서브메뉴명, 프로그램ID, 프로그램명, 조작구분, 처리건수, 입력값, 조작자, 조작자IP
            ApLoggerWriter.writeApLog("모바일", subMenuNm, "D20FlextimeMbBuildSV", subMenuNm, "11", "1", values, user, req.getRemoteAddr());

            // 최종적으로 XML Document를 XML String으로 변환한다.
            return XmlUtil.createSuccessXml(XmlUtil.createItems(ROOT_NAME));

        } catch (Exception e) {
            return XmlUtil.createErroXml(ROOT_NAME, MobileCodeErrVO.ERROR_CODE_300, e.getMessage());

        }
    }

}