/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR ����                                                  */
/*   2Depth Name  : �ʰ��ٹ�                                                    */
/*   Program Name : �ʰ��ٹ� ��ȸ                                               */
/*   Program ID   : D01OTDetailSV                                               */
/*   Description  : �ʰ��ٹ� ��ȸ �� ������ �� �� �ֵ��� �ϴ� Class             */
/*   Note         :                                                             */
/*   Creation     : 2002-01-15  �ڿ���                                          */
/*   Update       : 2005-03-03  ������                                          */
/*                      2018/06/08 rdcamel	[CSR ID:3700538] �����ް��� ���Կ� ���� Mobile �ް���û �� ����ȭ�� ���� ��û ��  
 *                                                               */
/********************************************************************************/

package servlet.hris;

import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.jdom.Document;
import org.jdom.Element;

import com.common.Utils;
import com.sns.jdf.Configuration;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.mobile.EncryptionTool;
import com.sns.jdf.mobile.MobileCodeErrVO;
import com.sns.jdf.mobile.XmlUtil;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;

import hris.D.D01OT.D01OTData;
import hris.D.D01OT.rfc.D01OTAFRFC;
import hris.D.D01OT.rfc.D01OTRFC;
import hris.D.D03Vocation.D03VocationData;
import hris.D.D03Vocation.rfc.D03VocationRFC;
import hris.D.D20Flextime.D20FlextimeData;
import hris.D.D20Flextime.rfc.D20FlextimeRFC;
import hris.G.rfc.ApprovalHeaderRFC;
import hris.common.PersInfoData;
import hris.common.approval.ApprovalHeader;
import hris.common.approval.ApprovalLineData;
import hris.common.rfc.PersInfoWithNoRFC;

@SuppressWarnings("serial")
public class MobileDetailSV extends MobileAutoLoginSV {

    private final String APPR_SYSTEM_ID_GEA = "EHR";
    private final String COMPANY_NAME = "LG Chem";

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {

        try {
            Logger.debug.println("MobileDetailSV start++++++++++++++++++++++++++++++++++++++");

            Box box = WebUtil.getBox(req);

            String AINF_SEQN = box.get("apprDocID"); // ���繮����ȣ
            String empNo = DataUtil.fixEndZero(EncryptionTool.decrypt(box.get("empNo")), 8); // ���

            // Logger.debug.println("jkd1234 +++++++++++++++++++++++++>"+ EncryptionTool.encrypt("jkd1234"));
            // Logger.debug.println("00003456 ++++++++++++++++++++++++>"+ EncryptionTool.encrypt("00003456"));
            // Logger.debug.println("test5678 ++++++++++++++++++++++++>"+ EncryptionTool.encrypt("test5678"));
            Logger.debug.println("JMK empNo+++++++++++++++++++++++++++++++++>" + empNo);
            Logger.debug.println("AINF_SEQN+++++++++++++++++++++++++++++++++>" + AINF_SEQN);

            // �󼼹��� ��ȸ
            String returnXml = apprItem(AINF_SEQN, empNo);

            // ����� ���� xmlStirng�� �����Ѵ�.
            req.setAttribute("returnXml", returnXml);
            // LHtmlUtil.blockHttpCache(res);

            // 3.return URL�� ȣ���Ѵ�.
            String dest = WebUtil.JspURL + "common/mobileResult.jsp";
            Logger.debug.println(this, " destributed = " + dest);
            printJspPage(req, res, dest);

        } catch (Exception e) {
            throw new GeneralException(e);
        }
    }

    /**
     * ���縦 ó���� ����� XML���·� �����´�.
     * 
     * @return
     */
    @SuppressWarnings("rawtypes")
    public String apprItem(String AINF_SEQN, String P_PERNR) {

        String xmlString = "";
        String itemsName = "apprItem";

        // LData appDocData = null; // ����� ���� ����
        // LData myAppTarget = null; // ����������
        // LData appIntSubInfo = null; // ���հ��� ����
        // LMultiData appTargetList = null; // ������ ����Ʈ
        // LMultiData fileList = null;

        // String locale = input.getString("locale");

        try {
            Vector<ApprovalLineData> appTargetList = null; // �������

            String apprSummary = "";     // �󼼿������
            String appRequestSabun = ""; // ����� ���
            String apprRequestDate = ""; // ��û����
            String apprLinkDocUrl = "";  // �������� URL
            String apprLinkDocName = ""; // �������� URL��
            String apprLinkBaseUrl = new Configuration().getString("com.sns.jdf.eloffice.ResponseURL");

            ApprovalHeader approvalHeader = new ApprovalHeaderRFC().getApprovalHeader(AINF_SEQN, P_PERNR);

            if (!"X".equals(approvalHeader.DISPFL)) {
                Logger.info.println(this, P_PERNR + "�� " + AINF_SEQN + " ������ ������ �� �����ϴ�");

                String errorMsg = MobileCodeErrVO.ERROR_MSG_200 + P_PERNR + "�� " + AINF_SEQN + " ������ ������ �� �����ϴ�";
                return XmlUtil.createErroXml(itemsName, MobileCodeErrVO.ERROR_CODE_200, errorMsg);
            }
/*
            // �������� GET
            DocumentInfo docInfo = new DocumentInfo(AINF_SEQN ,P_PERNR);
            
            if (docInfo == null) {
               	Logger.debug.println(this.getClass().getName() + " error 1 ");

                return XmlUtil.createErroXml(itemsName, MobileCodeErrVO.ERROR_CODE_000, MobileCodeErrVO.ERROR_MSG_000);
            }
            
            // ��������Ȯ��
            if (!docInfo.isHaveAuth()) {
                Logger.info.println(this ,P_PERNR + "�� " + AINF_SEQN + " ������ ������ �� �����ϴ�");

                String errorMsg = MobileCodeErrVO.ERROR_MSG_200+P_PERNR + "�� " + AINF_SEQN + " ������ ������ �� �����ϴ�";
                return XmlUtil.createErroXml(itemsName, MobileCodeErrVO.ERROR_CODE_200, errorMsg);
            }
*/
            String UPMU_TYPE = approvalHeader.getUPMU_TYPE(); // ����Ÿ��
            String apprDelFlag = ""; // �ް���û �������� flag

            Logger.debug.println(" ====================UPMU_TYPE>>" + UPMU_TYPE);
            /*********************************
             * ����Ÿ���� �������
             *********************************/
            if (StringUtils.isBlank(UPMU_TYPE)) {
                String errorMsg = MobileCodeErrVO.ERROR_MSG_100;
                return XmlUtil.createErroXml(itemsName, MobileCodeErrVO.ERROR_CODE_100, errorMsg);
            }

            /******************************
             * ����� APP_DOC ���� ���� ��ȸ
             ******************************/
            // �ʰ��ٹ�
            if (UPMU_TYPE.equals("17")) {
                D01OTRFC rfc17 = new D01OTRFC();
                rfc17.setDetailInput(P_PERNR, approvalHeader.UPMU_TYPE, AINF_SEQN);
                Vector D01OTData_vt = rfc17.getDetail(AINF_SEQN, P_PERNR);
                appTargetList = rfc17.getApprovalLine(); // ���缱

                D01OTData firstData = (D01OTData) D01OTData_vt.get(0); // �ʰ��ٹ� ��û����

                String VTKEN = (firstData.VTKEN).equals("X") ? "����" : "������"; // ���ϱٹ� ���� ����
                String PUNB1 = (firstData.PUNB1).equals("0") ? "" : WebUtil.printNum(firstData.PUNB1);
                String PBEZ1 = (firstData.PBEZ1).equals("0") ? "" : WebUtil.printNum(firstData.PBEZ1);
                String PUNB2 = (firstData.PUNB2).equals("0") ? "" : WebUtil.printNum(firstData.PUNB2);
                String PBEZ2 = (firstData.PBEZ2).equals("0") ? "" : WebUtil.printNum(firstData.PBEZ2);

                apprSummary = new StringBuffer()
                    .append("�ݽ�û��:").append(firstData.BEGDA)
                    .append("\n���ʰ��ٹ���:").append(firstData.WORK_DATE)
                    .append("\n�����ϱ��¿�����:").append(VTKEN)
                    .append("\n�ݽð�:").append(WebUtil.printTime(firstData.BEGUZ)).append("~").append(WebUtil.printTime(firstData.ENDUZ)).append("(").append(firstData.STDAZ).append("�ð�)")
                    .append("\n�ݽ�û����:").append(firstData.REASON)
                    .append("\n���ްԽð�1����:").append(WebUtil.printTime(firstData.PBEG1))
                    .append("\n���ްԽð�1����:").append(WebUtil.printTime(firstData.PEND1))
                    .append("\n���ްԽð�1����:").append(PUNB1)
                    .append("\n���ްԽð�1����:").append(PBEZ1)
                    .append("\n���ްԽð�2����:").append(WebUtil.printTime(firstData.PBEG2))
                    .append("\n���ްԽð�2����:").append(WebUtil.printTime(firstData.PEND2))
                    .append("\n���ްԽð�2����:").append(PUNB2)
                    .append("\n���ްԽð�2����:").append(PBEZ2).toString();

                appRequestSabun = firstData.PERNR; // ��û�� ���
                apprRequestDate = firstData.BEGDA; // ��û����
                apprLinkDocName = "�ʰ��ٹ�";      // �������� URL��
                apprLinkDocUrl = "http://" + apprLinkBaseUrl + WebUtil.ServletURL + "hris.MobilePassSV?AINF_SEQN=" + AINF_SEQN + "&isNotApp=false"; // �������� URL
            }
            // �ް�
            else if (UPMU_TYPE.equals("18")) {
                D03VocationRFC rfc18 = new D03VocationRFC();
                rfc18.setDeleteInput(P_PERNR, approvalHeader.UPMU_TYPE, AINF_SEQN);
                Vector d03VocationData_vt = rfc18.getVocation(P_PERNR, AINF_SEQN);
                appTargetList = rfc18.getApprovalLine(); // ���缱

                D03VocationData d03VocationData = (D03VocationData) d03VocationData_vt.get(0); // �ް� ��û����

                String strAwrt = "";
                String strAwrtType = "�����ް�";// [CSR ID:3700538] ����/���� �ް� ����
                String strTime = d03VocationData.BEGUZ.equals("") ? "" : WebUtil.printTime(d03VocationData.BEGUZ) + "~" + WebUtil.printTime(d03VocationData.ENDUZ);

                if (d03VocationData.AWART.equals("0110")) {
                    strAwrt = "�����ް�";
                } else if (d03VocationData.AWART.equals("0120")) {
                    strAwrt = "�����ް�(����)";
                } else if (d03VocationData.AWART.equals("0121")) {
                    strAwrt = "�����ް�(�Ĺ�)";
                } else if (d03VocationData.AWART.equals("0122")) {
                    strAwrt = "����ް�";
                } else if (d03VocationData.AWART.equals("0340")) {
                    strAwrt = "���Ϻ�ٹ�";
                } else if (d03VocationData.AWART.equals("0360")) {
                    strAwrt = "�ٹ�����";
                } else if (d03VocationData.AWART.equals("0140")) {
                    strAwrt = "�ϰ��ް�";
                } else if (d03VocationData.AWART.equals("0130")) {
                    strAwrt = "�����ް�";
                } else if (d03VocationData.AWART.equals("0170")) {
                    strAwrt = "���ϰ���";
                } else if (d03VocationData.AWART.equals("0180")) {
                    strAwrt = "�ð�����";
                } else if (d03VocationData.AWART.equals("0150")) {
                    strAwrt = "�����ް�";
                }
                // [CSR ID:3700538] ���� ���� �ް� ���� �� ���� �߰�
                else if (d03VocationData.AWART.equals("0111")) {
                    strAwrt = "�����ް�";
                    strAwrtType = "�����ް�";
                } else if (d03VocationData.AWART.equals("0112")) {
                    strAwrt = "�����ް�(����)";
                    strAwrtType = "�����ް�";
                } else if (d03VocationData.AWART.equals("0113")) {
                    strAwrt = "�����ް�(�Ĺ�)";
                    strAwrtType = "�����ް�";
                }
                // [CSR ID:3700538] �ް����� �߰�
                apprSummary = new StringBuffer()
                    .append("�ݽ�û��:").append(d03VocationData.BEGDA)
                    .append("\n���ް�����:").append(strAwrtType)
                    .append("\n���ް�����:").append(strAwrt)
                    .append("\n�ݽ�û����:").append(d03VocationData.REASON)
                    .append("\n���ް��Ⱓ:").append(d03VocationData.APPL_FROM).append("~").append(d03VocationData.APPL_TO)
                    .append("\n���ް��ð�:").append(strTime).toString();

                // �ް���û ���� Flag T �̸� ���� ����
                if ("X".equals(approvalHeader.MODFL)) {
                    apprDelFlag = "T";
                }

                appRequestSabun = d03VocationData.PERNR; // ��û�� ���
                apprRequestDate = d03VocationData.BEGDA; // ��û����
                apprLinkDocName = "�ް���û"; // �������� URL��
                apprLinkDocUrl  = "http://" + apprLinkBaseUrl + WebUtil.ServletURL + "hris.MobilePassSV?AINF_SEQN=" + AINF_SEQN + "&isNotApp=false"; // �������� URL
            }
            // Flextime
            else if (UPMU_TYPE.equals("42")) {
                D20FlextimeRFC rfc42 = new D20FlextimeRFC();
                rfc42.setDetailInput(P_PERNR, approvalHeader.UPMU_TYPE, AINF_SEQN);
                Vector<D20FlextimeData> detailList = rfc42.getDetail();
                appTargetList = rfc42.getApprovalLine(); // ���缱

                // Flextime ��û����
                D20FlextimeData data = (D20FlextimeData) Utils.indexOf(detailList, 0);

                boolean isB = StringUtils.isBlank(data.FLEX_ENDDA);
                apprSummary = new StringBuffer()
                    .append("�ݽ�û��:").append(data.BEGDA)
                    .append("\n�ݱٹ��ð�:").append(WebUtil.printTime(data.FLEX_BEGTM)).append("~").append(WebUtil.printTime(data.FLEX_ENDTM))
                    .append("\n������Ⱓ:").append(WebUtil.printDate(data.FLEX_BEGDA)).append(isB ? "" : "~").append(isB ? "" : WebUtil.printTime(data.FLEX_ENDDA)).toString();

                appRequestSabun = data.PERNR; // ��û�� ���
                apprRequestDate = data.BEGDA; // ��û����
                apprLinkDocName = "Flextime ��û"; // �������� URL��
                apprLinkDocUrl = "http://" + apprLinkBaseUrl + WebUtil.ServletURL + "hris.MobilePassSV?AINF_SEQN=" + AINF_SEQN + "&isNotApp=false"; // �������� URL
            }
            // ���� �ʰ��ٹ�
            else if (UPMU_TYPE.equals("44")) {
                D01OTAFRFC rfc44 = new D01OTAFRFC();
                rfc44.setDetailInput(P_PERNR, approvalHeader.UPMU_TYPE, AINF_SEQN);
                Vector D01OTData_vt = rfc44.getDetail(AINF_SEQN, P_PERNR);
                appTargetList = rfc44.getApprovalLine(); // ���缱

                // ���� �ʰ��ٹ� ��û����
                D01OTData firstData = (D01OTData) Utils.indexOf(D01OTData_vt, 0);

                // ���ϱٹ� ���� ����
                String VTKEN = (firstData.VTKEN).equals("X") ? "����" : "������";
                String PUNB1 = (firstData.PUNB1).equals("0") ? "" : WebUtil.printNum(firstData.PUNB1);
                String PBEZ1 = (firstData.PBEZ1).equals("0") ? "" : WebUtil.printNum(firstData.PBEZ1);
                String PUNB2 = (firstData.PUNB2).equals("0") ? "" : WebUtil.printNum(firstData.PUNB2);
                String PBEZ2 = (firstData.PBEZ2).equals("0") ? "" : WebUtil.printNum(firstData.PBEZ2);

                apprSummary = new StringBuffer()
                    .append("�ݽ�û��:").append(firstData.BEGDA)
                    .append("\n���ʰ��ٹ���:").append(firstData.WORK_DATE)
                    .append("\n�����ϱ��¿�����:").append(VTKEN)
                    .append("\n�ݽð�:").append(WebUtil.printTime(firstData.BEGUZ)).append("~").append(WebUtil.printTime(firstData.ENDUZ)).append("(").append(firstData.STDAZ).append("�ð�)")
                    .append("\n�ݽ�û����:").append(firstData.REASON)
                    .append("\n���ްԽð�1����:").append(WebUtil.printTime(firstData.PBEG1))
                    .append("\n���ްԽð�1����:").append(WebUtil.printTime(firstData.PEND1))
                    .append("\n���ްԽð�1����:").append(PUNB1)
                    .append("\n���ްԽð�1����:").append(PBEZ1)
                    .append("\n���ްԽð�2����:").append(WebUtil.printTime(firstData.PBEG2))
                    .append("\n���ްԽð�2����:").append(WebUtil.printTime(firstData.PEND2))
                    .append("\n���ްԽð�2����:").append(PUNB2)
                    .append("\n���ްԽð�2����:").append(PBEZ2).toString();

                appRequestSabun = firstData.PERNR; // ��û�� ���
                apprRequestDate = firstData.BEGDA; // ��û����
                apprLinkDocName = "�ʰ��ٹ����Ľ�û"; // �������� URL��
                apprLinkDocUrl = "http://" + apprLinkBaseUrl + WebUtil.ServletURL + "hris.MobilePassSV?AINF_SEQN=" + AINF_SEQN + "&isNotApp=false"; // �������� URL
            }
            Logger.debug.println("###########################");
            Logger.debug.println("apprSummary : " + apprSummary);
            Logger.debug.println("###########################");

            /* ��������� */
            PersInfoWithNoRFC piRfc = new PersInfoWithNoRFC();
            Vector apprRequest_vt = piRfc.getApproval(appRequestSabun);

            Logger.debug.println("###########################");
            Logger.debug.println("pid : " + apprRequest_vt);
            Logger.debug.println("###########################");

            /* ������ LIST */
/*
            ApprInfoRFC func = new ApprInfoRFC();
            appTargetList = func.getApproval( AINF_SEQN );
*/
            Logger.debug.println("###########################");
            Logger.debug.println("appTargetList : " + appTargetList);
            Logger.debug.println("###########################");

            Element items = XmlUtil.createItems(itemsName); // Root element ����

            // �����ΰ�� �����ڵ忡 0�� �����Ѵ�.
            XmlUtil.addChildElement(items, "returnDesc", "");
            XmlUtil.addChildElement(items, "returnCode", "0");

            PersInfoData pid = (PersInfoData) apprRequest_vt.get(0);
            // Logger.debug.println("###################### "+ input +" ####################");
            // �����
            XmlUtil.addChildElement(items, "apprSystemID", APPR_SYSTEM_ID_GEA);
            // XmlUtil.addChildElement(items, "apprTypeID","EHR-"+AINF_SEQN);
            XmlUtil.addChildElement(items, "apprDocID", AINF_SEQN);
            XmlUtil.addChildElement(items, "apprRequestEmpNo", pid.PERNR);
            XmlUtil.addChildElement(items, "apprRequestEmpName", pid.ENAME);
            XmlUtil.addChildElement(items, "apprRequestEmpDept", pid.ORGEH);
            XmlUtil.addChildElement(items, "apprRequestEmpTitle", pid.TITEL);
            XmlUtil.addChildElement(items, "apprRequestEmpEmail", "");
            XmlUtil.addChildElement(items, "apprRequestEmpOffice", pid.TELNUMBER);
            XmlUtil.addChildElement(items, "apprRequestEmpMobile", "");
            XmlUtil.addChildElement(items, "apprRequestCompanyKorName", COMPANY_NAME);
            XmlUtil.addChildElement(items, "apprRequestDate", apprRequestDate);
            XmlUtil.addChildElement(items, "apprSummary", apprSummary);
            XmlUtil.addChildElement(items, "apprDelFlag", apprDelFlag);

            // ������� �˻��� ������� �̿��Ͽ� row�����Ϳ� ���� XML element�� �����Ѵ�.
            String APPL_APPR_STAT = ""; // ���λ���
            String apprCurFlag = ""; // �������ڿ���
            String apprCurFlagTemp = "";
            String APPL_APPR_DATA = ""; // ��������

            for (int i = 0; i < appTargetList.size(); i++) {
                ApprovalLineData appLineData = appTargetList.get(i);

                // ��������
                APPL_APPR_DATA = appLineData.APPR_DATE.equals("") ? "" : appLineData.APPR_DATE.equals("0000-00-00") ? "" : WebUtil.printDate(appLineData.APPR_DATE, "-");
                if (appLineData.APPR_STAT.equals("A")) {
                    APPL_APPR_STAT = "����";
                } else if (appLineData.APPR_STAT.equals("R")) {
                    APPL_APPR_STAT = "�ݷ�";
                } else {
                    APPL_APPR_STAT = "�̰�";
                    // ���������� ������ ���� ó��
                    apprCurFlag = "";// �ʱ�ȭ
                    if (apprCurFlag.equals("") && apprCurFlagTemp.equals("")) {
                        apprCurFlag = "T";
                    }
                    apprCurFlagTemp = "T";
                }

                Element item = XmlUtil.createElement("approver");
                XmlUtil.addChildElement(item, "apprCurFlag", apprCurFlag);
                XmlUtil.addChildElement(item, "apprApproveEmpNo", appLineData.PERNR);
                XmlUtil.addChildElement(item, "apprApproveEmpName", appLineData.ENAME);
                XmlUtil.addChildElement(item, "apprApproveEmpDept", appLineData.APPU_NAME);
                XmlUtil.addChildElement(item, "apprApproveEmpTitle", appLineData.JIKWT);
                XmlUtil.addChildElement(item, "apprApproveEmpEmail", "");
                XmlUtil.addChildElement(item, "apprApproveEmpOffice", appLineData.PHONE_NUM);
                XmlUtil.addChildElement(item, "apprApproveEmpMobile", "");
                XmlUtil.addChildElement(item, "apprApproveCompanyKorName", COMPANY_NAME);
                XmlUtil.addChildElement(item, "apprApproveDate", APPL_APPR_DATA);
                XmlUtil.addChildElement(item, "apprApproveType", "APPROVAL"); // ����,�ݷ��� ����
                XmlUtil.addChildElement(item, "apprComment", appLineData.BIGO_TEXT);
                XmlUtil.addChildElement(item, "apprType", APPL_APPR_STAT);

                XmlUtil.addChildElement(items, item);
            }

            // HR�� �������� �ϳ��� ������
            for (int i = 0; i < 1; i++) {
                Element item = XmlUtil.createElement("apprLinkDocUrls");
                XmlUtil.addChildElement(item, "apprLinkDocName", apprLinkDocName);
                XmlUtil.addChildElement(item, "apprLinkDocUrl", apprLinkDocUrl); // �󼼺��� ����
                XmlUtil.addChildElement(items, item);
            }

            Element envelope = XmlUtil.createEnvelope();         // 1. Envelope XML�� �����Ѵ�.
            Element body = XmlUtil.createBody();                 // 2. Body XML�� �����Ѵ�.
            Element waitResponse = XmlUtil.createWaitResponse(); // 3. Wait response�� �����Ѵ�.

            // XML�� �����Ѵ�.
            XmlUtil.addChildElement(waitResponse, items);
            XmlUtil.addChildElement(body, waitResponse);
            XmlUtil.addChildElement(envelope, body);

            // ���������� XML Document�� XML String�� ��ȯ�Ѵ�.
            xmlString = XmlUtil.convertString(new Document(envelope));

            Logger.debug("xmlString : " + xmlString);
            return xmlString;

        } catch (Exception e) {
            Logger.error(e);
            // String errorMsg = MobileCodeErrVO.ERROR_MSG_999 + e.getMessage();
            String errorMsg = MobileCodeErrVO.ERROR_MSG_999 + e.getMessage() + "###" + e.getClass();
            // �����ΰ�� �����ڵ�:999, ���� ������ �����Ѵ�.
            return XmlUtil.createErroXml(itemsName, MobileCodeErrVO.ERROR_CODE_999, errorMsg);
        }
    }

}