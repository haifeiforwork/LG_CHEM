/********************************************************************************/
/*
/*   System Name  : Mobile
/*   1Depth Name  : 
/*   2Depth Name  : 
/*   Program Name : Flextime ��û
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

    private final String UPMU_TYPE = "42";         // ���� ����Ÿ��
    private final String UPMU_NAME = "Flextime";   // ���� ������
    private final String ROOT_NAME = "apprResult"; // XML root element name

    @Override
    protected String getRootName() {
        return ROOT_NAME;
    }

    @Override
    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {

        Logger.debug.println(this, "D20FlextimeMbBuildSV start");

        // ����ó�� �� ó����� XML ���ڿ� ����
        String returnXml = apprItem(req, res);

        // ó����� XML ���ڿ� request�� ����
        req.setAttribute(RETURN_XML, returnXml);
        Logger.debug.println(this, "==============================================");
        Logger.debug.println(this, returnXml);

        // response�� ó����� XML ���ڿ� ���
        printJspPage(req, res, WebUtil.JspURL + "common/mobileResult.jsp");

        Logger.debug.println(this, "D20FlextimeMbBuildSV end");
    }

    /**
     * ��ûó�� ����� XML���·� �����´�.
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

            // ����� ���� üũ
            try {
                D20FlextimeAuthCheckRFC rfc = new D20FlextimeAuthCheckRFC();

                if (!"Y".equals(rfc.getE_AVAILABLE(PERNR))) {
                    return XmlUtil.createErroXml(ROOT_NAME, MobileCodeErrVO.ERROR_CODE_800, rfc.getReturn().MSGTX);
                }

            } catch (Exception e) {
                return XmlUtil.createErroXml(ROOT_NAME, MobileCodeErrVO.ERROR_CODE_800, e.getMessage());

            }

            // ���ñٹ��� ����� üũ
            try {
                D20FlextimeScreen screen = D20FlextimeScreen.lookup(new D20FlextimeSelectScreenRFC().getE_SCREEN(PERNR, null));

                if (screen != D20FlextimeScreen.A && screen != D20FlextimeScreen.B) {
                    return XmlUtil.createErroXml(ROOT_NAME, MobileCodeErrVO.ERROR_CODE_800, "Flextime ��û ����ڰ� �ƴմϴ�.");
                }

            } catch (Exception e) {
                return XmlUtil.createErroXml(ROOT_NAME, MobileCodeErrVO.ERROR_CODE_800, e.getMessage());

            }

            // ���缱 ������ ���� üũ
            try {
                Vector<ApprovalLineData> approvalLine = box.getVector(ApprovalLineData.class, "APPLINE_");

                if (Utils.getSize(approvalLine) == 0) {
                    throw new Exception(g.getMessage("MSG.APPROVAL.0001")); // ������ ������ �����ϴ�.
                }

                for (ApprovalLineData row : approvalLine) {
                    row.APPU_NUMB = row.getAPPU_NUMB(); // ������ ��� ��ȣȭ
                }

                if (!checkApprovalLine(approvalLine, new ApprovalLineRFC().getApprovalLine(UPMU_TYPE, PERNR))) {
                    throw new Exception("������ ���� �����Դϴ�.");
                }

                Logger.debug.println(this, "������� �� : " + approvalLine.size());
                Logger.debug.println(this, "�������    : " + approvalLine.toString());

                box.put("approver", approvalLine.get(0)); // ���� ������

            } catch (Exception e) {
                return XmlUtil.createErroXml(ROOT_NAME, MobileCodeErrVO.ERROR_CODE_300, e.getMessage());

            }

            D20FlextimeData inputData = box.createEntity(D20FlextimeData.class);
            Utils.setFieldValue(inputData, "ZPERNR", user.empNo);   // ��û�� ��� ����(�븮��û ,���� ��û)
            Utils.setFieldValue(inputData, "UNAME", user.empNo);    // ��û�� ��� ����(�븮��û ,���� ��û)
            Utils.setFieldValue(inputData, "AEDTM", DataUtil.getCurrentDate(req)); // ������(���糯¥) - �����ð�
            Utils.setFieldValue(inputData, "BEGDA", DataUtil.getCurrentDate(req));
            Utils.setFieldValue(inputData, "FLEX_BEGDA", DataUtil.removeStructur(inputData.FLEX_BEGDA));
            Utils.setFieldValue(inputData, "FLEX_ENDDA", DataUtil.removeStructur(inputData.FLEX_ENDDA));

            // Flextime ��û
            try {
                // ��û�� data ��ȿ�� ����
                RFCReturnEntity checkResult = new D20FlextimeCheckRFC().check(inputData, "2");

                if (!checkResult.isSuccess()) {
                    return XmlUtil.createErroXml(ROOT_NAME, MobileCodeErrVO.ERROR_CODE_800, checkResult.MSGTX);
                }

                // Flextime ��û
                D20FlextimeRFC rfc = new D20FlextimeRFC();
                rfc.setRequestInput(PERNR, UPMU_TYPE);

                String AINF_SEQN = rfc.build(Utils.asVector(inputData), box, req);

                Logger.debug.println(this, "�����ȣ AINF_SEQN : " + AINF_SEQN);

                if (!rfc.getReturn().isSuccess() || AINF_SEQN == null) {
                    return XmlUtil.createErroXml(ROOT_NAME, MobileCodeErrVO.ERROR_CODE_800, rfc.getReturn().MSGTX);
                }

                box.put("AINF_SEQN", AINF_SEQN);

            } catch (Exception e) {
                return XmlUtil.createErroXml(ROOT_NAME, MobileCodeErrVO.ERROR_CODE_800, e.getMessage());

            }

            // �����ڿ��� ���� �߼�
            final ApprovalLineData approver = (ApprovalLineData) box.getObject("approver");
            final PersonData applicant = new PersonInfoRFC().getPersonInfo(PERNR);

            Logger.debug.println(this, "approver  : " + approver.toString());
            Logger.debug.println(this, "applicant : " + applicant.toString());

            Properties mailProperties = new Properties() {
                {
                    setProperty("SServer", user.SServer);           // ElOffice ���� ����
                    setProperty("from_empNo", user.empNo);          // ���� �߼��� ���
                    setProperty("to_empNo", approver.APPU_NUMB);    // ���� ������ ���

                    setProperty("ename", applicant.E_ENAME);        // (��)��û�ڸ�
                    setProperty("empno", applicant.E_PERNR);        // (��)��û�� ���

                    setProperty("UPMU_NAME", UPMU_NAME);            // ���� �̸�
                    setProperty("AINF_SEQN", box.get("AINF_SEQN")); // �����ȣ
                    setProperty("USER_AREA", user.area.toString());

                    setProperty("subject", g.getMessage("MSG.APPROVAL.0002", UPMU_NAME)); // [HR] �����û ({0})
                    setProperty("FileName", "MbNoticeMailBuild.html");
                }
            };
            MailSendToEloffic mail = new MailSendToEloffic(mailProperties);

            StringBuffer msg2 = new StringBuffer();
            if (!mail.process()) {
                Logger.warn.println(this, "���� �߼� ���� : " + mailProperties);
                msg2.append(mail.getMessage());
            }

            // ���հ��� ����
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
                msg2.append(msg2.length() > 0 ? "\\n" : "").append("���հ��� ���� ����").append("\\n").append(e.getMessage());
                Logger.err.println(this, msg2);

                return XmlUtil.createErroXml(ROOT_NAME, MobileCodeErrVO.ERROR_CODE_400, msg2.toString());

            }

            String subMenuNm = "����� Flextime ��û";
            String[] values = new String[] {inputData.PERNR, box.get("AINF_SEQN"), inputData.SCHKZ, inputData.FLEX_BEGDA, inputData.FLEX_ENDDA};

            // ��޴���, ����޴���, ���α׷�ID, ���α׷���, ���۱���, ó���Ǽ�, �Է°�, ������, ������IP
            ApLoggerWriter.writeApLog("�����", subMenuNm, "D20FlextimeMbBuildSV", subMenuNm, "11", "1", values, user, req.getRemoteAddr());

            // ���������� XML Document�� XML String���� ��ȯ�Ѵ�.
            return XmlUtil.createSuccessXml(XmlUtil.createItems(ROOT_NAME));

        } catch (Exception e) {
            return XmlUtil.createErroXml(ROOT_NAME, MobileCodeErrVO.ERROR_CODE_300, e.getMessage());

        }
    }

}