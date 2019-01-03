/********************************************************************************/
/*
/*   System Name  : Mobile
/*   1Depth Name  : 
/*   2Depth Name  : 
/*   Program Name : Flextime 신청 취소
/*   Program ID   : D20FlextimeMbDeleteSV
/*   Description  : 
/*   Note         : 
/*   Creation     : 2018-08-22 [WorkTime52]
/* 
/********************************************************************************/

package servlet.hris.D.D20Flextime;

import java.util.Properties;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.common.RFCReturnEntity;
import com.common.Utils;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.mobile.MobileCodeErrVO;
import com.sns.jdf.mobile.XmlUtil;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.MobileXmlBaseServlet;
import com.sns.jdf.util.WebUtil;

import hris.D.D20Flextime.rfc.D20FlextimeRFC;
import hris.common.DraftDocForEloffice;
import hris.common.MailSendToEloffic;
import hris.common.MobileReturnData;
import hris.common.WebUserData;
import hris.common.approval.ApprovalHeader;
import hris.common.approval.ApprovalLineData;
import servlet.hris.MobileCommonSV;

@SuppressWarnings("serial")
public class D20FlextimeMbDeleteSV extends MobileXmlBaseServlet {

    private final String UPMU_TYPE = "42";         // 결재 업무타입
    private final String UPMU_NAME = "Flextime";   // 결재 업무명
    private final String ROOT_NAME = "apprResult"; // XML root element name

    @Override
    protected String getRootName() {
        return ROOT_NAME;
    }

    @Override
    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {

        Logger.debug.println(this, "D20FlextimeMbDeleteSV start");

        // 결재처리 및 처리결과 XML 문자열 생성
        String returnXml = apprItem(req, res);

        // 처리결과 XML 문자열 request에 저장
        req.setAttribute(RETURN_XML, returnXml);
        Logger.debug.println(this, "==============================================");
        Logger.debug.println(this, returnXml);

        // response에 처리결과 XML 문자열 출력
        printJspPage(req, res, WebUtil.JspURL + "common/mobileResult.jsp");

        Logger.debug.println(this, "D20FlextimeMbDeleteSV end");
    }

    /**
     * 신청취소 처리 결과를 XML형태로 가져온다.
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
            final String AINF_SEQN = box.get("apprDocID"); // 결재번호

            final D20FlextimeRFC rfc = new D20FlextimeRFC();

            // ApprovalHeader 정보 조회
            rfc.setDetailInput(PERNR, "2", AINF_SEQN); // 1 : 결재해야할 문서, 2 : 결재진행중 문서, 3 : 결재완료 문서
            rfc.getDetail();

            final ApprovalHeader approvalHeader = rfc.getApprovalHeader();

            // 신청취소 가능여부 체크
            if ("X".equals(approvalHeader.CANCFL)) {
                return XmlUtil.createErroXml(ROOT_NAME, MobileCodeErrVO.ERROR_CODE_300, g.getMessage("MSG.APPROVAL.CANCEL.DISABLE")); // 현재 취소가 가능한 상태가 아닙니다.
            }

            // 신청취소
            rfc.setDeleteInput(PERNR, UPMU_TYPE, AINF_SEQN);
            RFCReturnEntity result = rfc.delete();

            if (!result.isSuccess()) {
                return XmlUtil.createErroXml(ROOT_NAME, MobileCodeErrVO.ERROR_CODE_300, result.MSGTX);
            }

            // 결재자에게 메일 발송
            final ApprovalLineData approver = Utils.indexOf(rfc.getApprovalLine(), 0);

            Logger.debug.println(this, "approver : " + approver.toString());

            Properties mailProperties = new Properties() {
                {
                    setProperty("SServer", user.SServer);           // ElOffice 접속 서버
                    setProperty("from_empNo", PERNR);               // 메일 발송자 사번
                    setProperty("to_empNo", approver.APPU_NUMB);    // 메일 수신자 사번

                    setProperty("ename", approvalHeader.ENAME);     // (피)신청자명
                    setProperty("empno", approvalHeader.PERNR);     // (피)신청자 사번

                    setProperty("UPMU_NAME", UPMU_NAME);            // 문서 이름
                    setProperty("AINF_SEQN", AINF_SEQN);            // 결재번호
                    setProperty("USER_AREA", user.area.toString());

                    setProperty("subject", g.getMessage("MSG.APPROVAL.0003", UPMU_NAME)); // [HR] 결재삭제 통보 ({0})
                    setProperty("FileName", g.getSapType().isLocal() ? "NoticeMail5.html" : "NoticeMail5_GLOBAL.html");
                }
            };
            MailSendToEloffic mail = new MailSendToEloffic(mailProperties);

            StringBuffer msg2 = new StringBuffer();
            if (!mail.process()) {
                Logger.warn.println(this, "메일 발송 오류 : " + mailProperties);
                msg2.append(" delete ").append(mail.getMessage());
            }

            // 통합결재 삭제처리 연동
            try {
                Vector ifData = new Vector() {
                    {
                        add(new DraftDocForEloffice().makeDocForRemove(AINF_SEQN, user.SServer, UPMU_NAME, approvalHeader.PERNR, approver.APPU_NUMB));
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

            // 최종적으로 XML Document를 XML String으로 변환한다.
            return XmlUtil.createSuccessXml(XmlUtil.createItems(ROOT_NAME));

        } catch (Exception e) {
            return XmlUtil.createErroXml(ROOT_NAME, MobileCodeErrVO.ERROR_CODE_300, e.getMessage());

        }
    }

}