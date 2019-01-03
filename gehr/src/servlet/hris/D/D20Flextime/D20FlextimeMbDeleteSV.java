/********************************************************************************/
/*
/*   System Name  : Mobile
/*   1Depth Name  : 
/*   2Depth Name  : 
/*   Program Name : Flextime ��û ���
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

    private final String UPMU_TYPE = "42";         // ���� ����Ÿ��
    private final String UPMU_NAME = "Flextime";   // ���� ������
    private final String ROOT_NAME = "apprResult"; // XML root element name

    @Override
    protected String getRootName() {
        return ROOT_NAME;
    }

    @Override
    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {

        Logger.debug.println(this, "D20FlextimeMbDeleteSV start");

        // ����ó�� �� ó����� XML ���ڿ� ����
        String returnXml = apprItem(req, res);

        // ó����� XML ���ڿ� request�� ����
        req.setAttribute(RETURN_XML, returnXml);
        Logger.debug.println(this, "==============================================");
        Logger.debug.println(this, returnXml);

        // response�� ó����� XML ���ڿ� ���
        printJspPage(req, res, WebUtil.JspURL + "common/mobileResult.jsp");

        Logger.debug.println(this, "D20FlextimeMbDeleteSV end");
    }

    /**
     * ��û��� ó�� ����� XML���·� �����´�.
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
            final String AINF_SEQN = box.get("apprDocID"); // �����ȣ

            final D20FlextimeRFC rfc = new D20FlextimeRFC();

            // ApprovalHeader ���� ��ȸ
            rfc.setDetailInput(PERNR, "2", AINF_SEQN); // 1 : �����ؾ��� ����, 2 : ���������� ����, 3 : ����Ϸ� ����
            rfc.getDetail();

            final ApprovalHeader approvalHeader = rfc.getApprovalHeader();

            // ��û��� ���ɿ��� üũ
            if ("X".equals(approvalHeader.CANCFL)) {
                return XmlUtil.createErroXml(ROOT_NAME, MobileCodeErrVO.ERROR_CODE_300, g.getMessage("MSG.APPROVAL.CANCEL.DISABLE")); // ���� ��Ұ� ������ ���°� �ƴմϴ�.
            }

            // ��û���
            rfc.setDeleteInput(PERNR, UPMU_TYPE, AINF_SEQN);
            RFCReturnEntity result = rfc.delete();

            if (!result.isSuccess()) {
                return XmlUtil.createErroXml(ROOT_NAME, MobileCodeErrVO.ERROR_CODE_300, result.MSGTX);
            }

            // �����ڿ��� ���� �߼�
            final ApprovalLineData approver = Utils.indexOf(rfc.getApprovalLine(), 0);

            Logger.debug.println(this, "approver : " + approver.toString());

            Properties mailProperties = new Properties() {
                {
                    setProperty("SServer", user.SServer);           // ElOffice ���� ����
                    setProperty("from_empNo", PERNR);               // ���� �߼��� ���
                    setProperty("to_empNo", approver.APPU_NUMB);    // ���� ������ ���

                    setProperty("ename", approvalHeader.ENAME);     // (��)��û�ڸ�
                    setProperty("empno", approvalHeader.PERNR);     // (��)��û�� ���

                    setProperty("UPMU_NAME", UPMU_NAME);            // ���� �̸�
                    setProperty("AINF_SEQN", AINF_SEQN);            // �����ȣ
                    setProperty("USER_AREA", user.area.toString());

                    setProperty("subject", g.getMessage("MSG.APPROVAL.0003", UPMU_NAME)); // [HR] ������� �뺸 ({0})
                    setProperty("FileName", g.getSapType().isLocal() ? "NoticeMail5.html" : "NoticeMail5_GLOBAL.html");
                }
            };
            MailSendToEloffic mail = new MailSendToEloffic(mailProperties);

            StringBuffer msg2 = new StringBuffer();
            if (!mail.process()) {
                Logger.warn.println(this, "���� �߼� ���� : " + mailProperties);
                msg2.append(" delete ").append(mail.getMessage());
            }

            // ���հ��� ����ó�� ����
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
                msg2.append(msg2.length() > 0 ? "\\n" : "").append("���հ��� ���� ����").append("\\n").append(e.getMessage());
                Logger.err.println(this, msg2);

                return XmlUtil.createErroXml(ROOT_NAME, MobileCodeErrVO.ERROR_CODE_400, msg2.toString());

            }

            // ���������� XML Document�� XML String���� ��ȯ�Ѵ�.
            return XmlUtil.createSuccessXml(XmlUtil.createItems(ROOT_NAME));

        } catch (Exception e) {
            return XmlUtil.createErroXml(ROOT_NAME, MobileCodeErrVO.ERROR_CODE_300, e.getMessage());

        }
    }

}