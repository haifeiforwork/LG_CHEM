/********************************************************************************/
/*
/*   System Name  : Mobile
/*   1Depth Name  : 
/*   2Depth Name  : 
/*   Program Name : Flextime ��û data ��ȸ
/*   Program ID   : D20FlextimeMbDataSV
/*   Description  : 
/*   Note         : 
/*   Creation     : 2018-08-22 [WorkTime52]
/* 
/********************************************************************************/

package servlet.hris.D.D20Flextime;

import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.jdom.Element;

import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.mobile.MobileCodeErrVO;
import com.sns.jdf.mobile.XmlUtil;
import com.sns.jdf.servlet.MobileXmlBaseServlet;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;

import hris.D.D20Flextime.D20FlextimeListData;
import hris.D.D20Flextime.rfc.D20FlextimeListRFC;
import hris.common.approval.ApprovalLineData;
import hris.common.approval.ApprovalLineRFC;

@SuppressWarnings("serial")
public class D20FlextimeMbDataSV extends MobileXmlBaseServlet {

    private final String UPMU_TYPE = "42";         // ���� ����Ÿ��
    private final String ROOT_NAME = "apprResult"; // XML root element name

    @Override
    protected String getRootName() {
        return ROOT_NAME;
    }

    @Override
    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {

        Logger.debug.println(this, "D20FlextimeMbDataSV start");

        // ����ó�� �� ó����� XML ���ڿ� ����
        String returnXml = apprItem(req, res);

        // ó����� XML ���ڿ� request�� ����
        req.setAttribute(RETURN_XML, returnXml);
        Logger.debug.println(this, "==============================================");
        Logger.debug.println(this, returnXml);

        // response�� ó����� XML ���ڿ� ���
        printJspPage(req, res, WebUtil.JspURL + "common/mobileResult.jsp");

        Logger.debug.println(this, "D20FlextimeMbDataSV end");
    }

    /**
     * ��û data�� XML���·� �����´�.
     * 
     * @param req
     * @param res
     * @return
     * @throws GeneralException
     */
    private String apprItem(HttpServletRequest req, HttpServletResponse res) throws GeneralException {

        String RQID = req.getParameter("RQID");

        // ��û ȭ�� �ʱ� data
        if ("RQST_FORM".equals(RQID)) {
            return getApprovalLineList(req, res);
        }
        // Flextime ��Ȳ
        else if ("SCHD_LIST".equals(RQID)) {
            return getFlextimeList(req, res);
        }
        else {
            return XmlUtil.createErroXml(ROOT_NAME, MobileCodeErrVO.ERROR_CODE_800, g.getMessage("MSG.D.D20.0005")); // �� �� ���� ��û�Դϴ�.
        }
    }

    /**
     * ���缱 ���� ��ȸ
     * 
     * @param req
     * @param res
     * @return
     */
    private String getApprovalLineList(HttpServletRequest req, HttpServletResponse res) {

        try {
            Element approvalLineList = XmlUtil.createElement("approvalLineList");

            Vector<ApprovalLineData> list = new ApprovalLineRFC().getApprovalLine(UPMU_TYPE, WebUtil.getSessionUser(req).empNo);
            for (int i = 0; i < list.size(); i++) {
                ApprovalLineData data = list.get(i);

                Element item = XmlUtil.createElement("approver");
                XmlUtil.addChildElement(item, "apprApproveEmpNo", data.PERNR);
                XmlUtil.addChildElement(item, "apprApproveEmpName", data.ENAME);
                XmlUtil.addChildElement(item, "apprApproveEmpDept", data.APPU_NAME);
                XmlUtil.addChildElement(item, "apprApproveEmpTitle", data.JIKWT);
                XmlUtil.addChildElement(item, "apprApproveEmpEmail", " ");
                XmlUtil.addChildElement(item, "apprApproveEmpOffice", data.PHONE_NUM);
                XmlUtil.addChildElement(item, "apprApproveEmpMobile", " ");
                XmlUtil.addChildElement(item, "apprApproveDate", data.APPR_DATE);
                XmlUtil.addChildElement(item, "apprApproveType", "APPROVAL"); // ����, �ݷ��� ����
                XmlUtil.addChildElement(item, "apprComment", data.BIGO_TEXT);
                XmlUtil.addChildElement(item, "apprType", "A".equals(data.APPR_STAT) ? "����" : ("R".equals(data.APPR_STAT) ? "�ݷ�" : "�̰�"));

                XmlUtil.addChildElement(approvalLineList, item);
            }

            Element items = XmlUtil.createItems(ROOT_NAME);

            XmlUtil.addChildElement(items, approvalLineList);

            // ���������� XML Document�� XML String���� ��ȯ�Ѵ�.
            return XmlUtil.createSuccessXml(items);

        } catch (Exception e) {
            return XmlUtil.createErroXml(ROOT_NAME, MobileCodeErrVO.ERROR_CODE_800, e.getMessage());

        }
    }

    /**
     * Flextime ��Ȳ ��� ��ȸ
     * 
     * @param req
     * @param res
     * @return
     */
    private String getFlextimeList(HttpServletRequest req, HttpServletResponse res) {

        try {
            Element flextimeList = XmlUtil.createElement("flextimeList");

            Vector<D20FlextimeListData> list = new D20FlextimeListRFC().getList(WebUtil.getSessionUser(req).empNo, DataUtil.getCurrentYear());

            for (int i = 0; i < list.size(); i++) {
                D20FlextimeListData data = list.get(i);

                Element item = XmlUtil.createElement("flextime");
                XmlUtil.addChildElement(item, "SCHKZ01", data.SCHKZ01);
                XmlUtil.addChildElement(item, "SCHKZ02", data.SCHKZ02);
                XmlUtil.addChildElement(item, "SCHKZ03", data.SCHKZ03);
                XmlUtil.addChildElement(item, "SCHKZ04", data.SCHKZ04);
                XmlUtil.addChildElement(item, "SCHKZ05", data.SCHKZ05);
                XmlUtil.addChildElement(item, "SCHKZ06", data.SCHKZ06);
                XmlUtil.addChildElement(item, "SCHKZ07", data.SCHKZ07);
                XmlUtil.addChildElement(item, "SCHKZ08", data.SCHKZ08);
                XmlUtil.addChildElement(item, "SCHKZ09", data.SCHKZ09);
                XmlUtil.addChildElement(item, "SCHKZ10", data.SCHKZ10);
                XmlUtil.addChildElement(item, "SCHKZ11", data.SCHKZ11);
                XmlUtil.addChildElement(item, "SCHKZ12", data.SCHKZ12);

                XmlUtil.addChildElement(item, "ZDATE01", data.ZDATE01);
                XmlUtil.addChildElement(item, "ZDATE02", data.ZDATE02);
                XmlUtil.addChildElement(item, "ZDATE03", data.ZDATE03);
                XmlUtil.addChildElement(item, "ZDATE04", data.ZDATE04);
                XmlUtil.addChildElement(item, "ZDATE05", data.ZDATE05);
                XmlUtil.addChildElement(item, "ZDATE06", data.ZDATE06);
                XmlUtil.addChildElement(item, "ZDATE07", data.ZDATE07);
                XmlUtil.addChildElement(item, "ZDATE08", data.ZDATE08);
                XmlUtil.addChildElement(item, "ZDATE09", data.ZDATE09);
                XmlUtil.addChildElement(item, "ZDATE10", data.ZDATE10);
                XmlUtil.addChildElement(item, "ZDATE11", data.ZDATE11);
                XmlUtil.addChildElement(item, "ZDATE12", data.ZDATE12);

                XmlUtil.addChildElement(flextimeList, item);
            }

            Element items = XmlUtil.createItems(ROOT_NAME);

            XmlUtil.addChildElement(items, flextimeList);

            // ���������� XML Document�� XML String���� ��ȯ�Ѵ�.
            return XmlUtil.createSuccessXml(items);

        } catch (Exception e) {
            return XmlUtil.createErroXml(ROOT_NAME, MobileCodeErrVO.ERROR_CODE_800, e.getMessage());

        }
    }

}