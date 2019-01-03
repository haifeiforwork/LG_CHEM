/********************************************************************************/
/*                                                                              */
/*   System Name  : ��                                                                                                                     */
/*   1Depth Name  :                                                             */
/*   2Depth Name  : ����� ����ȸ                                                                                                */
/*   Program Name : ����� ����ȸ(�ʰ��ٹ�,�ް���û                                                                  */
/*   Program ID   : MobileApprovalSV                                            */
/*   Description  : ����Ͽ��� �󼼿�ûȭ�� ��û�� Return                              */
/*   Note         :                                                             */
/*   Creation     : 2011-05-17  JMK                                             */
/*   Update       :  2015-08-20 ������ [CSR ID:] ehr�ý�������༺���� ����                       */
/*                     2017-06-29 eunha  [CSR ID:3420113] �λ�ý��� ��û �� ���� ���� UI ǥ���۾�*/
/*                     2018/06/09 rdcamel [CSR ID:3701161] ����� �ʰ��ٹ� ��û/���� ���� ���� ��û ��*/
/* update        : 2018/06/08 rdcamel [CSR ID:3700538] �����ް��� ���Կ� ���� Mobile �ް���û �� ����ȭ�� ���� ��û ��*/
/********************************************************************************/

package servlet.hris;

import java.util.Hashtable;
import java.util.Properties;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang.StringUtils;
import org.jdom.Document;
import org.jdom.Element;

import com.common.Utils;
import com.lgchem.esb.adapter.ESBAdapter;
import com.lgchem.esb.adapter.LGChemESBService;
import com.lgchem.esb.exception.ESBTransferException;
import com.lgchem.esb.exception.ESBValidationException;
import com.sns.jdf.Config;
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
import hris.D.D01OT.rfc.D01OTCheckAddRFC;
import hris.D.D01OT.rfc.D01OTCheckGlobalRFC;
import hris.D.D01OT.rfc.D01OTRFC;
import hris.D.D03Vocation.D03VocationData;
import hris.D.D03Vocation.rfc.D03VocationRFC;
import hris.D.D20Flextime.D20FlextimeData;
import hris.D.D20Flextime.rfc.D20FlextimeRFC;
import hris.G.ApprovalReturnState;
import hris.G.rfc.ApprovalHeaderRFC;
import hris.G.rfc.G001ApprovalProcessRFC;
import hris.common.AppLineData;
import hris.common.DraftDocForEloffice;
import hris.common.ElofficInterfaceData;
import hris.common.MailSendToEloffic;
import hris.common.MobileReturnData;
import hris.common.PersonData;
import hris.common.WebUserData;
import hris.common.approval.ApprovalHeader;
import hris.common.approval.ApprovalLineData;
import hris.common.rfc.PersonInfoRFC;
import servlet.hris.D.D01OT.D01OTBuildGlobalSV;

@SuppressWarnings({ "rawtypes", "serial" })
public class MobileApprovalSV extends MobileAutoLoginSV {

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {

        try {
            Logger.debug.println("MobileApprovalSV start++++++++++++++++++++++++++++++++++++++");

            // �α���ó��
            autoLogin(req, res);

            HttpSession session = req.getSession(false);
            /*WebUserData user = WebUtil.getSessionUser(req);*/
            WebUserData user = (WebUserData) session.getAttribute("user");

            Box box = WebUtil.getBox(req);

            // Request
            // String AINF_SEQN = box.get("apprDocID").substring(4); //���繮����ȣ
            String AINF_SEQN = box.get("apprDocID"); // ���繮����ȣ
            String empNo = DataUtil.fixEndZero(EncryptionTool.decrypt(box.get("empNo")), 8); // ���

            // ���� ó���� �����ڰ� ���� ������ ó�� ���а� (01:����, 02:�ΰ�, 03:�ݷ�, 04:����)
            String apprType = box.get("apprType");
            // comment
            String apprComment = box.get("apprComment");

            Logger.debug.println("JMK empNo+++++++++++++++++++++++++++++++++>" + empNo);
            Logger.debug.println("AINF_SEQN+++++++++++++++++++++++++++++++++>" + AINF_SEQN);
            Logger.debug.println("apprType++++++++++++++++++++++++++++++++++>" + apprType);
            Logger.debug.println("apprComment+++++++++++++++++++++++++++++++>" + apprComment);
            Logger.debug.println("user++++++++++++++++++++++++++++++++++++++>" + user);
            // ����ó�� �����
            String returnXml = apprItem(req, AINF_SEQN, empNo, apprType, apprComment, user);

            // ����� ���� xmlStirng�� �����Ѵ�.
            req.setAttribute("returnXml", returnXml);
            // LHtmlUtil.blockHttpCache(res);

            // 3.return URL�� ȣ���Ѵ�.
            String dest = WebUtil.JspURL + "common/mobileResult.jsp";
            Logger.debug.println(this, " destributed = " + dest);
            printJspPage(req, res, dest);

        } catch (Exception e) {
            throw new GeneralException(e);
        } finally {

        }
    }

    /**
     * ���縦 ó���� ����� XML���·� �����´�.
     * 
     * @return
     */
    public String apprItem(HttpServletRequest req, String AINF_SEQN, String P_PERNR, String apprType, String apprComment, WebUserData user) {


        String xmlString = "";
        String itemsName = "apprResult";

        MobileReturnData returnMsg_vt = new MobileReturnData();

        try {
            // �Ķ���� ���� Ȯ��
            if (AINF_SEQN == null || P_PERNR == null || apprType == null || AINF_SEQN == "" || P_PERNR == "" || apprType == "") {
                Logger.debug.println("MobileCodeErrVO.ERROR_MSG_010:" + MobileCodeErrVO.ERROR_MSG_010);
                return XmlUtil.createErroXml(itemsName, MobileCodeErrVO.ERROR_CODE_010, MobileCodeErrVO.ERROR_MSG_010);
            }

            ApprovalHeaderRFC approvalHeaderRFC = new ApprovalHeaderRFC();
            ApprovalHeader approvalHeader = approvalHeaderRFC.getApprovalHeader(AINF_SEQN, user.empNo, "1");

            // �������� GET
            /*DocumentInfo docInfo = new DocumentInfo(AINF_SEQN ,P_PERNR);*/

            if (!approvalHeaderRFC.getReturn().isSuccess()) {
                Logger.debug.println(this.getClass().getName() + " error 1 ");
                return XmlUtil.createErroXml(itemsName, MobileCodeErrVO.ERROR_CODE_000, MobileCodeErrVO.ERROR_MSG_000);
            }

            // ��������Ȯ��
            if (!"X".equals(approvalHeader.ACCPFL)) {
                Logger.info.println(this, user.empNo + "�� " + AINF_SEQN + " ������ ������ �� �����ϴ�");
                String errorMsg = MobileCodeErrVO.ERROR_MSG_200 + user.empNo + "�� " + AINF_SEQN + " ������ ������ �� �����ϴ�";
                return XmlUtil.createErroXml(itemsName, MobileCodeErrVO.ERROR_CODE_200, errorMsg);
            }

            // ����Ÿ��
            String UPMU_TYPE = approvalHeader.getUPMU_TYPE();
            Logger.debug.println(" ====================UPMU_TYPE>>" + UPMU_TYPE);
            // public String STAT_TYPE; // ���� "1 ��û ,2 ���������� ,3 ����Ϸ� ,4 �ݷ�"

            // ����Ÿ���� �������
            if (StringUtils.isBlank(UPMU_TYPE)) {
                return XmlUtil.createErroXml(itemsName, MobileCodeErrVO.ERROR_CODE_100, MobileCodeErrVO.ERROR_MSG_100);
            }

            /********************************
             * ����� APP_DOC ���� ���� ��ȸ
             ********************************/
            // �ʰ��ٹ� ��û ����ó��
            if (UPMU_TYPE.equals("17")) {
                returnMsg_vt = processApprovalOT(AINF_SEQN, user.empNo, apprType, apprComment, user, approvalHeader);
                if (!returnMsg_vt.CODE.equals("0")) {
                    return XmlUtil.createErroXml(itemsName, returnMsg_vt.CODE, returnMsg_vt.VALUE);
                }
            }
            // �ް� ��û ����ó��
            else if (UPMU_TYPE.equals("18")) {
                returnMsg_vt = processApprovalVacation(AINF_SEQN, user.empNo, apprType, apprComment, user, approvalHeader);
                if (!returnMsg_vt.CODE.equals("0")) {
                    return XmlUtil.createErroXml(itemsName, returnMsg_vt.CODE, returnMsg_vt.VALUE);
                }
            }
            // Flextime ��û ����ó��
            else if (UPMU_TYPE.equals("42")) {
                returnMsg_vt = processApprovalFlextime(req, AINF_SEQN, user.empNo, apprType, apprComment, user, approvalHeader);
                if (!returnMsg_vt.CODE.equals("0")) {
                    return XmlUtil.createErroXml(itemsName, returnMsg_vt.CODE, returnMsg_vt.VALUE);
                }
            }
            // ���� �ʰ��ٹ� ��û ����ó��
            else if (UPMU_TYPE.equals("44")) {
                returnMsg_vt = processApprovalOTAfterWork(req, AINF_SEQN, user.empNo, apprType, apprComment, user, approvalHeader);
                if (!returnMsg_vt.CODE.equals("0")) {
                    return XmlUtil.createErroXml(itemsName, returnMsg_vt.CODE, returnMsg_vt.VALUE);
                }
            }

            Logger.debug.println("###########################");
            Logger.debug.println("returnMsg.code : " + returnMsg_vt.CODE);
            Logger.debug.println("returnMsg.value: " + returnMsg_vt.VALUE);
            Logger.debug.println("###########################");

            Element items = XmlUtil.createItems(itemsName); // Root element ����

            // �����ΰ�� �����ڵ忡 0�� �����Ѵ�.
            XmlUtil.addChildElement(items, "returnDesc", "");
            XmlUtil.addChildElement(items, "returnCode", "0");

            Element envelope = XmlUtil.createEnvelope();         // 1. Envelope XML�� �����Ѵ�.
            Element body = XmlUtil.createBody();                 // 2. Body XML�� �����Ѵ�.
            Element waitResponse = XmlUtil.createWaitResponse(); // 3. Wait response�� �����Ѵ�.

            // XML�� �����Ѵ�.
            XmlUtil.addChildElement(waitResponse, items);
            XmlUtil.addChildElement(body, waitResponse);
            XmlUtil.addChildElement(envelope, body);

            // ���������� XML Document�� XML String�� ��ȯ�Ѵ�.
            xmlString = XmlUtil.convertString(new Document(envelope));

        } catch (Exception e) {
            // errorMsg = MobileCodeErrVO.ERROR_MSG_999 + e.getMessage();
            String errorMsg = MobileCodeErrVO.ERROR_MSG_999 + e.getMessage() + "###" + e.getClass();
            // �����ΰ�� �����ڵ�:999, ���� ������ �����Ѵ�.
            xmlString = XmlUtil.createErroXml(itemsName, MobileCodeErrVO.ERROR_CODE_999, errorMsg);
        }

        return xmlString;
    }

    public MobileReturnData processApprovalOTAfterWork(HttpServletRequest req, String AINF_SEQN, String P_PERNR, String apprType, String apprComment, WebUserData user, ApprovalHeader approvalHeader)
                    throws GeneralException {

        Logger.debug.println("processApprovalOTAfterWork start ================");
        // ���ϰ� setting
        MobileReturnData retunMsg = new MobileReturnData();
        retunMsg.CODE = "";
        retunMsg.VALUE = "";
        // ���հ��翬�� �����
        MobileReturnData retunMsgEL = new MobileReturnData();

        // ����/�ݷ�
        String APPR_STAT = "";
        if (apprType.equals("01")) {
            APPR_STAT = "A"; // ����
        } else {
            APPR_STAT = "R"; // �ݷ�
        }
        Logger.debug.println("processApprovalOTAfterWork start================1111");

        try {

            ApprovalLineData tempAppLine;

            // �ʰ��ٹ� �⺻����
            D01OTAFRFC rfc = new D01OTAFRFC();
            Vector D01OTData_vt = null;
            D01OTData d01OTData;
            rfc.setDetailInput(user.empNo, "1", AINF_SEQN);

            D01OTBuildGlobalSV d01sv = new D01OTBuildGlobalSV();
            D01OTData_vt = rfc.getDetail(AINF_SEQN, "");
            d01OTData = (D01OTData) D01OTData_vt.get(0);
            d01OTData = d01sv.doWithData(d01OTData);

            d01OTData.UNAME = user.empNo;
            d01OTData.AEDTM = DataUtil.getCurrentDate();
            d01OTData.I_NTM = "X"; // [WorkTime52]

            D01OTCheckGlobalRFC d01OTCheckGlobalRFC = new D01OTCheckGlobalRFC();
            // 2017-04-03 ������ [CSR ID:3340999] �븸 ������±Ⱓ���� 46�ð� ���� START
            if (!g.getSapType().isLocal()) {
                d01OTCheckGlobalRFC.checkOvertimeTp46Hours(req, d01OTData.PERNR, "A", d01OTData.AINF_SEQN, d01OTData.WORK_DATE, d01OTData.STDAZ);
                if ("E".equals(d01OTCheckGlobalRFC.getReturn().MSGTY)) {
                    retunMsg.CODE = MobileCodeErrVO.ERROR_CODE_300;
                    retunMsg.VALUE = MobileCodeErrVO.ERROR_MSG_300 + g.getMessage("MSG.D.D01.0109");// The Approved overtime hours of this payroll period are over 46 hours.
                    return retunMsg;
                }
                // [CSR ID:3359686] ���� ���� 5������ START
                d01OTCheckGlobalRFC.checkApprovalPeriod(req, d01OTData.PERNR, "A", d01OTData.WORK_DATE, "44", "");
                if ("E".equals(d01OTCheckGlobalRFC.getReturn().MSGTY)) {
                    retunMsg.CODE = MobileCodeErrVO.ERROR_CODE_300;
                    retunMsg.VALUE = MobileCodeErrVO.ERROR_MSG_300 + g.getMessage("MSG.D.D01.0108");// The request date has passed 5 working days. You could not approve it.
                    return retunMsg;
                }
                // [CSR ID:3359686] ���� ���� 5������ END

            }
            // 2017-04-03 ������ [CSR ID:3340999] �븸 ������±Ⱓ���� 46�ð� ���� END

            Vector<ApprovalLineData> approvalLine = rfc.getApprovalLine();

            ApprovalLineData approvalCurrent = null;

            /* ���� ������ �������� */
            for (ApprovalLineData approvalLineData : approvalLine) {
                if (StringUtils.isBlank(approvalLineData.APPR_STAT)) {
                    approvalCurrent = approvalLineData;
                    break;
                }
            }

            /* ����/�ݷ� �� ���� ���� ���� */
            AppLineData appLine = new AppLineData();

            appLine.APPL_BUKRS = user.companyCode;
            appLine.APPL_PERNR = approvalHeader.PERNR;
            appLine.APPL_BEGDA = d01OTData.BEGDA;
            appLine.APPL_AINF_SEQN = approvalHeader.AINF_SEQN;
            appLine.APPL_APPU_TYPE = approvalCurrent.APPU_TYPE;
            appLine.APPL_APPR_SEQN = approvalCurrent.APPR_SEQN;
            appLine.APPL_APPU_NUMB = user.empNo;
            appLine.APPL_APPR_STAT = APPR_STAT;
            appLine.APPL_BIGO_TEXT = apprComment;
            // appLine.APPL_CMMNT = box.getString("BIGO_TEXT"); //���� �ǰ�
            appLine.APPL_APPR_DATE = DataUtil.getCurrentDate();
            appLine.APPL_APPR_TIME = DataUtil.getDate();

            G001ApprovalProcessRFC approvalProcessRFC = new G001ApprovalProcessRFC();
            ApprovalReturnState approvalReturn = approvalProcessRFC.setApproval(Utils.asVector(appLine), "T_ZHRA018T", Utils.asVector(d01OTData));

            // ���Ϲ߼��� ����
            PersonInfoRFC numfunc = new PersonInfoRFC();
            PersonData phonenumdata;
            phonenumdata = numfunc.getPersonInfo(d01OTData.PERNR);

            Properties ptMailBody = new Properties();
            // ptMailBody.setProperty("SServer", user.SServer);
            ptMailBody.setProperty("SServer", "");   // ElOffice ���� ����
            ptMailBody.setProperty("from_empNo", P_PERNR);               // �� �߼��� ���

            ptMailBody.setProperty("ename", phonenumdata.E_ENAME);          // (��)��û�ڸ�
            ptMailBody.setProperty("empno", phonenumdata.E_PERNR);          // (��)��û�� ���

            ptMailBody.setProperty("UPMU_NAME", "�����ʰ� �ٹ�");             // ���� �̸�

            ptMailBody.setProperty("AINF_SEQN", AINF_SEQN);                 // ��û�� ����

            // �� ����
            StringBuffer sbSubject = new StringBuffer(512);

            String msg2 = "";
            String to_empNo = d01OTData.PERNR;

            String APPU_TYPE = approvalCurrent.APPU_TYPE;
            String APPR_SEQN = approvalCurrent.APPR_SEQN;
            String currApprNumb = approvalCurrent.APPU_NUMB;

            if (approvalReturn.isSuccess()) {
                if (appLine.APPL_APPR_STAT.equals("A")) {
                    for (int i = 0; i < approvalLine.size(); i++) {
                        tempAppLine = approvalLine.get(i);
                        if (tempAppLine.APPU_TYPE.equals(approvalCurrent.APPU_TYPE) && tempAppLine.APPR_SEQN.equals(approvalCurrent.APPR_SEQN)) {
                            ptMailBody.setProperty("FileName", "MbNoticeMailApp.html");
                            if (i == approvalLine.size() - 1) {
                                // ������ ������
                                // [CSR ID:3420113] �λ�ý��� ��û �� ���� ���� UI ǥ���۾� 2017-06-29 eunha start
                                // sbSubject.append(ptMailBody.getProperty("UPMU_NAME") +"�� ���� �ϼ̽��ϴ�.");
                                sbSubject.append("[HR] ����Ϸ� �뺸 (" + ptMailBody.getProperty("UPMU_NAME") + ")");
                                // [CSR ID:3420113] �λ�ý��� ��û �� ���� ���� UI ǥ���۾� 2017-06-29 eunha end

                            } else {
                                // ���� ������
                                tempAppLine = approvalLine.get(i + 1);
                                to_empNo = tempAppLine.PERNR;
                                // [CSR ID:3420113] �λ�ý��� ��û �� ���� ���� UI ǥ���۾� 2017-06-29 eunha start
                                // sbSubject.append("���縦 ��û �ϼ̽��ϴ�.");
                                sbSubject.append("[HR] �����û (" + ptMailBody.getProperty("UPMU_NAME") + ")");
                                // [CSR ID:3420113] �λ�ý��� ��û �� ���� ���� UI ǥ���۾� 2017-06-29 eunha end
                                break;
                            } // end if
                        } else {

                        } // end if
                    } // end for
                } else {
                    if (APPU_TYPE.equals("02") && Integer.parseInt(APPR_SEQN) > 1) {
                        for (int i = 0; i < approvalLine.size(); i++) {
                            tempAppLine = approvalLine.get(i);
                            if (tempAppLine.APPU_TYPE.equals("02") && tempAppLine.APPR_SEQN.equals("01")) {
                                tempAppLine = approvalLine.get(i);
                                to_empNo = tempAppLine.PERNR;
                            } // end if
                        } // end for
                    } // end if
                    ptMailBody.setProperty("FileName", "MbNoticeMailRej.html");
                    // [CSR ID:3420113] �λ�ý��� ��û �� ���� ���� UI ǥ���۾� 2017-06-29 eunha start
                    // sbSubject.append(ptMailBody.getProperty("UPMU_NAME") +"�� �ݷ� �ϼ̽��ϴ�.");
                    sbSubject.append("[HR] ����ݷ� �뺸 (" + ptMailBody.getProperty("UPMU_NAME") + ")");
                    // [CSR ID:3420113] �λ�ý��� ��û �� ���� ���� UI ǥ���۾� 2017-06-29 eunha send
                } // end if

                ptMailBody.setProperty("to_empNo", to_empNo);                   // �� ������ ���
                ptMailBody.setProperty("subject", sbSubject.toString());        // �� ���� ����
                MailSendToEloffic maTe = new MailSendToEloffic(ptMailBody);

                try {
                    DraftDocForEloffice ddfe = new DraftDocForEloffice();
                    ElofficInterfaceData eof;
                    Vector vcElofficInterfaceData = new Vector();
                    // ESB ���� ����
                    if (!currApprNumb.equals(user.empNo)) {
                        // ����÷��� ������ ���� �׽�ũ�� ������ �ִ� �����ڰ� �����Ҷ� ó��:���� ���ڰ��翡 ���ִ� DATA�� ������ �ٽ� ó��
                        ElofficInterfaceData eofD = ddfe.makeDocForDelete(AINF_SEQN, user.SServer, phonenumdata.E_PERNR, ptMailBody.getProperty("UPMU_NAME"), currApprNumb);
                        vcElofficInterfaceData.add(eofD);
                        ElofficInterfaceData eofI = ddfe.makeDocForInsert(AINF_SEQN, user.SServer, phonenumdata.E_PERNR, ptMailBody.getProperty("UPMU_NAME"));
                        vcElofficInterfaceData.add(eofI);
                    }
                    // ����ó��
                    if (appLine.APPL_APPR_STAT.equals("A")) {
                        eof = ddfe.makeDocContents(AINF_SEQN, user.SServer, ptMailBody.getProperty("UPMU_NAME"));
                        vcElofficInterfaceData.add(eof);
                        // �ݷ�ó��
                    } else {
                        if (APPU_TYPE.equals("02") && Integer.parseInt(APPR_SEQN) > 1) {
                            eof = ddfe.makeDocForMangerReject(AINF_SEQN, user.SServer, ptMailBody.getProperty("UPMU_NAME"), approvalLine);
                            vcElofficInterfaceData.add(eof);
                        } else {
                            int nRejectLength = 0;
                            for (int i = approvalLine.size() - 1; i >= 0; i--) {
                                tempAppLine = approvalLine.get(i);
                                if (tempAppLine.APPU_TYPE.equals(APPU_TYPE) && tempAppLine.APPR_SEQN.equals(APPR_SEQN)) {
                                    nRejectLength = i + 1;
                                    break;
                                } // end if
                            } // end for

                            String approvers[] = new String[nRejectLength];
                            for (int i = 0; i < approvers.length; i++) {
                                tempAppLine = approvalLine.get(i);
                                approvers[i] = tempAppLine.PERNR;
                            } // end for
                            if (!currApprNumb.equals(user.empNo)) {
                                approvers[approvers.length - 1] = user.empNo; // ESB ���� ����
                            }
                            eof = ddfe.makeDocForReject(AINF_SEQN, user.SServer, ptMailBody.getProperty("UPMU_NAME"), d01OTData.PERNR, approvers);
                            vcElofficInterfaceData.add(eof);
                        } // end if

                        eof.R_EMP_NO = DataUtil.fixEndZero(user.empNo, 8); /* �ݷ� ��û�ڴ� ���� �α��� ��� - �̼۷����� Ȯ�� �� �߰�����  */
                    } // end if

                    // ���հ��� ����
                    retunMsgEL = ElofficInterface(vcElofficInterfaceData, user);
                    // ���հ��� �������� ���� �߻��� ������ return
                    if (!retunMsgEL.CODE.equals("0")) {
                        retunMsg.CODE = MobileCodeErrVO.ERROR_CODE_400 + "" + retunMsgEL.CODE;
                        retunMsg.VALUE = retunMsgEL.VALUE;
                        return retunMsg;
                    }

                } catch (Exception e) {
                    retunMsg.CODE = MobileCodeErrVO.ERROR_CODE_400;
                    retunMsg.VALUE = msg2 + " Eloffic ���� ���� ";
                    return retunMsg;

                } // end try

                // ���Ϲ߼�
                if (!maTe.process()) {
                    msg2 = maTe.getMessage() + "\\n";
                    //
                } // end if

                retunMsg.CODE = "0";
                retunMsg.VALUE = "";// ����

            } else {
                Logger.debug.println("ars.E_RETURN================" + approvalReturn.E_RETURN);
                Logger.debug.println(" ars.E_MESSAGE================" + approvalReturn.E_MESSAGE);
                retunMsg.CODE = MobileCodeErrVO.ERROR_CODE_300;
                retunMsg.VALUE = MobileCodeErrVO.ERROR_MSG_300 + approvalReturn.E_MESSAGE;
                return retunMsg;

            } // end if

        } catch (Exception e) {
            Logger.error(e);
            retunMsg.CODE = MobileCodeErrVO.ERROR_CODE_300;
            retunMsg.VALUE = e.getMessage() + "����ó�� ����";
            return retunMsg;
        }

        return retunMsgEL;

    }

    /**
     * �ʰ��ٹ� ����ó�� ó�� �� ��� �ڵ� �� �޼��� Return
     * 
     * @return
     */
    public MobileReturnData processApprovalOT(String AINF_SEQN, String P_PERNR, String apprType, String apprComment, WebUserData user, ApprovalHeader approvalHeader) throws GeneralException {

        Logger.debug.println("processApprovalOT start ================");
        // ���ϰ� setting
        MobileReturnData retunMsg = new MobileReturnData();
        retunMsg.CODE = "";
        retunMsg.VALUE = "";
        // ���հ��翬�� �����
        MobileReturnData retunMsgEL = new MobileReturnData();

        // ����/�ݷ�
        String APPR_STAT = "";
        if (apprType.equals("01")) {
            APPR_STAT = "A"; // ����
        } else {
            APPR_STAT = "R"; // �ݷ�
        }
        Logger.debug.println("processApprovalOT start================1111");
        try {
            ApprovalLineData tempAppLine;

            // �ʰ��ٹ� �⺻����
            Vector D01OTData_vt = null;
            D01OTRFC rfc = new D01OTRFC();
            rfc.setDetailInput(user.empNo, "1", AINF_SEQN);
            D01OTData_vt = rfc.getDetail(AINF_SEQN, "");

            // [CSR ID:3701161] �� 52�ð� �ٹ��� �ʰ��ٹ� ���� üũ���� START
            D01OTCheckAddRFC ntmOtChkRfc = new D01OTCheckAddRFC();
            Vector ret = ntmOtChkRfc.check(D01OTData_vt);
            if (ret.get(0).equals("E")) {// ''W':���, 'E':���� �̸�, W�� �������� ��쿡 �߻��ϴ� case�� ����Ͽ����� ������.
                retunMsg.CODE = MobileCodeErrVO.ERROR_CODE_300;
                retunMsg.VALUE = MobileCodeErrVO.ERROR_MSG_300 + ret.get(1);
                return retunMsg;
            }
            // [CSR ID:3701161] �� 52�ð� �ٹ��� �ʰ��ٹ� ���� üũ���� END

            if (D01OTData_vt.size() < 1) {
                retunMsg.CODE = MobileCodeErrVO.ERROR_CODE_300;
                retunMsg.VALUE = MobileCodeErrVO.ERROR_MSG_300 + "�ʰ��ٹ� �������� �������� �ʽ��ϴ�.";
                return retunMsg;
            }
            D01OTData d01OTData = (D01OTData) D01OTData_vt.get(0);
            d01OTData.I_NTM = "X"; // [CSR ID:3701161] ����� �ʰ��ٹ� ��û/���� ���� ���� ��û ��
            Logger.debug.println("processApprovalOT jmk================d01OTData:" + d01OTData);

            /* // ���� ������ ����
            DocumentInfo docinfo = new DocumentInfo(AINF_SEQN ,P_PERNR,false);
            int approvalStep = docinfo.getApprovalStep();
            int docType = docinfo.getType();
            Logger.debug.println("processApprovalOT jmk================docType:"+docType );
            Logger.debug.println("processApprovalOT jmk================approvalStep:"+approvalStep );
            if(docType !=docinfo.MUST_APPROVAL ){
            	retunMsg.CODE = MobileCodeErrVO.ERROR_CODE_300;
            	retunMsg.VALUE = MobileCodeErrVO.ERROR_MSG_300+"�̹� ����ó���� �����Դϴ�.";
            	return retunMsg;
            }*/

            // �����ڶ��� ����
            // Vector AppLineData_vt = AppUtil.getAppChangeVt(AINF_SEQN);
            /*ApprInfoRFC func = new ApprInfoRFC();
            Vector AppLineData_vt = func.getApproval( AINF_SEQN );
            
            int nRowCount = AppLineData_vt.size();
            
            String APPU_TYPE   = docinfo.getAPPU_TYPE();
            //�������
            String APPR_SEQN   = docinfo.getAPPR_SEQN();
            
            String currApprNumb = "";  //ESB ���� ����
            Logger.debug.println("processApprovalOT jmk================nRowCount:"+nRowCount );
            for (int i = 0; i < nRowCount; i++) {
                tempAppLine = new AppLineData();
            
                tempAppLine = (AppLineData)AppLineData_vt.get(i);
                DataUtil.fixNullAll( tempAppLine );
            
                Logger.debug.println("processApprovalOT jmkjmkjmk=============tempAppLine:"+tempAppLine );
            
                vcTempAppLineData.add(tempAppLine);
                if ((tempAppLine.APPL_APPR_STAT==null|| tempAppLine.APPL_APPR_STAT.equals("")) && currApprNumb.equals("")){
                	currApprNumb = tempAppLine.APPL_PERNR;
                }
            
                Logger.debug.println("processApprovalOT jmk================APPU_TYPE:"+APPU_TYPE );
                Logger.debug.println("processApprovalOT jmk================APPR_SEQN:"+APPR_SEQN );
                if (tempAppLine.APPL_APPU_TYPE.equals(APPU_TYPE) && tempAppLine.APPL_APPR_SEQN.equals(APPR_SEQN)) {
                	Logger.debug.println("processApprovalOT jmk================user.empNo:" +user.empNo);
                    appLine.APPL_BUKRS = user.companyCode;
                    appLine.APPL_PERNR = d01OTData.PERNR; //��û��
                    appLine.APPL_BEGDA = d01OTData.BEGDA;
                    appLine.APPL_AINF_SEQN = AINF_SEQN;
                    appLine.APPL_APPU_TYPE = APPU_TYPE;
                    appLine.APPL_APPR_SEQN = APPR_SEQN;
                    appLine.APPL_APPU_NUMB = P_PERNR; //������
                    appLine.APPL_APPR_STAT = APPR_STAT;
                    appLine.APPL_BIGO_TEXT = apprComment;
                    appLine.APPL_APPR_DATE = DataUtil.getCurrentDate();
                    Logger.debug.println("processApprovalOT jmk================appLine.APPL_APPR_DATE:"+appLine.APPL_APPR_DATE );
                } // end if
            } // end for
            
            Logger.debug.println(this ,"vcTempAppLineData:::::"+vcTempAppLineData);
            Logger.debug.println(this ,"appLine:::::"+appLine);
            vcAppLineData.add(appLine);
            
            //����ó��
            G001ApprovalProcessRFC  Apr = new G001ApprovalProcessRFC();
            Vector vcRet = Apr.setApprovalStatutsList(vcAppLineData );
            
            Logger.debug.println(this ,"vcRet==================>"+vcRet);
            ApprovalReturnState ars = (ApprovalReturnState) vcRet.get(0);
            Logger.debug.println(this ,"ars==================>"+ars);*/

            Vector<ApprovalLineData> approvalLine = rfc.getApprovalLine();

            ApprovalLineData approvalCurrent = null;

            /* ���� ������ �������� */
            for (ApprovalLineData approvalLineData : approvalLine) {
                if (StringUtils.isBlank(approvalLineData.APPR_STAT)) {
                    approvalCurrent = approvalLineData;
                    break;
                }
            }

            /* ����/�ݷ� �� ���� ���� ���� */
            AppLineData appLine = new AppLineData();

            appLine.APPL_BUKRS = user.companyCode;
            appLine.APPL_PERNR = approvalHeader.PERNR;
            appLine.APPL_BEGDA = d01OTData.BEGDA;
            appLine.APPL_AINF_SEQN = approvalHeader.AINF_SEQN;
            appLine.APPL_APPU_TYPE = approvalCurrent.APPU_TYPE;
            appLine.APPL_APPR_SEQN = approvalCurrent.APPR_SEQN;
            appLine.APPL_APPU_NUMB = user.empNo;
            appLine.APPL_APPR_STAT = APPR_STAT;
            appLine.APPL_BIGO_TEXT = apprComment;
            // appLine.APPL_CMMNT = box.getString("BIGO_TEXT"); //���� �ǰ�
            appLine.APPL_APPR_DATE = DataUtil.getCurrentDate();
            appLine.APPL_APPR_TIME = DataUtil.getDate();

            G001ApprovalProcessRFC approvalProcessRFC = new G001ApprovalProcessRFC();
            ApprovalReturnState approvalReturn = approvalProcessRFC.setApproval(Utils.asVector(appLine), "T_ZHRA018T", Utils.asVector(d01OTData));

            // ���Ϲ߼��� ����
            PersonInfoRFC numfunc = new PersonInfoRFC();
            PersonData phonenumdata;
            phonenumdata = numfunc.getPersonInfo(d01OTData.PERNR);

            Properties ptMailBody = new Properties();
            // ptMailBody.setProperty("SServer", user.SServer);
            ptMailBody.setProperty("SServer", "");   // ElOffice ���� ����
            ptMailBody.setProperty("from_empNo", P_PERNR);               // �� �߼��� ���

            ptMailBody.setProperty("ename", phonenumdata.E_ENAME);          // (��)��û�ڸ�
            ptMailBody.setProperty("empno", phonenumdata.E_PERNR);          // (��)��û�� ���

            ptMailBody.setProperty("UPMU_NAME", "�ʰ� �ٹ�");               // ���� �̸�

            ptMailBody.setProperty("AINF_SEQN", AINF_SEQN);                 // ��û�� ����

            // �� ����
            StringBuffer sbSubject = new StringBuffer(512);

            // [CSR ID:3420113] �λ�ý��� ��û �� ���� ���� UI ǥ���۾� 2017-06-29 eunha start
            // sbSubject.append("[" + ptMailBody.getProperty("UPMU_NAME") + "] ");
            // sbSubject.append(user.ename + "���� ");
            // [CSR ID:3420113] �λ�ý��� ��û �� ���� ���� UI ǥ���۾� 2017-06-29 eunha end

            String msg2 = "";
            String to_empNo = d01OTData.PERNR;

            String APPU_TYPE = approvalCurrent.APPU_TYPE;
            String APPR_SEQN = approvalCurrent.APPR_SEQN;
            String currApprNumb = approvalCurrent.APPU_NUMB;

            if (approvalReturn.isSuccess()) {
                if (appLine.APPL_APPR_STAT.equals("A")) {
                    for (int i = 0; i < approvalLine.size(); i++) {
                        tempAppLine = approvalLine.get(i);
                        if (tempAppLine.APPU_TYPE.equals(approvalCurrent.APPU_TYPE) && tempAppLine.APPR_SEQN.equals(approvalCurrent.APPR_SEQN)) {
                            ptMailBody.setProperty("FileName", "MbNoticeMailApp.html");
                            if (i == approvalLine.size() - 1) {
                                // ������ ������
                                // [CSR ID:3420113] �λ�ý��� ��û �� ���� ���� UI ǥ���۾� 2017-06-29 eunha start
                                // sbSubject.append(ptMailBody.getProperty("UPMU_NAME") +"�� ���� �ϼ̽��ϴ�.");
                                sbSubject.append("[HR] ����Ϸ� �뺸 (" + ptMailBody.getProperty("UPMU_NAME") + ")");
                                // [CSR ID:3420113] �λ�ý��� ��û �� ���� ���� UI ǥ���۾� 2017-06-29 eunha end

                            } else {
                                // ���� ������
                                tempAppLine = approvalLine.get(i + 1);
                                to_empNo = tempAppLine.PERNR;
                                // [CSR ID:3420113] �λ�ý��� ��û �� ���� ���� UI ǥ���۾� 2017-06-29 eunha start
                                // sbSubject.append("���縦 ��û �ϼ̽��ϴ�.");
                                sbSubject.append("[HR] �����û (" + ptMailBody.getProperty("UPMU_NAME") + ")");
                                // [CSR ID:3420113] �λ�ý��� ��û �� ���� ���� UI ǥ���۾� 2017-06-29 eunha end
                                break;
                            } // end if
                        } else {

                        } // end if
                    } // end for
                } else {
                    if (APPU_TYPE.equals("02") && Integer.parseInt(APPR_SEQN) > 1) {
                        for (int i = 0; i < approvalLine.size(); i++) {
                            tempAppLine = approvalLine.get(i);
                            if (tempAppLine.APPU_TYPE.equals("02") && tempAppLine.APPR_SEQN.equals("01")) {
                                tempAppLine = approvalLine.get(i);
                                to_empNo = tempAppLine.PERNR;
                            } // end if
                        } // end for
                    } // end if
                    ptMailBody.setProperty("FileName", "MbNoticeMailRej.html");
                    // [CSR ID:3420113] �λ�ý��� ��û �� ���� ���� UI ǥ���۾� 2017-06-29 eunha start
                    // sbSubject.append(ptMailBody.getProperty("UPMU_NAME") +"�� �ݷ� �ϼ̽��ϴ�.");
                    sbSubject.append("[HR] ����ݷ� �뺸 (" + ptMailBody.getProperty("UPMU_NAME") + ")");
                    // [CSR ID:3420113] �λ�ý��� ��û �� ���� ���� UI ǥ���۾� 2017-06-29 eunha send
                } // end if

                ptMailBody.setProperty("to_empNo", to_empNo);                   // �� ������ ���
                ptMailBody.setProperty("subject", sbSubject.toString());        // �� ���� ����
                MailSendToEloffic maTe = new MailSendToEloffic(ptMailBody);

                try {
                    DraftDocForEloffice ddfe = new DraftDocForEloffice();
                    ElofficInterfaceData eof;
                    Vector vcElofficInterfaceData = new Vector();
                    // ESB ���� ����
                    if (!currApprNumb.equals(user.empNo)) {
                        // ����÷��� ������ ���� �׽�ũ�� ������ �ִ� �����ڰ� �����Ҷ� ó��:���� ���ڰ��翡 ���ִ� DATA�� ������ �ٽ� ó��
                        ElofficInterfaceData eofD = ddfe.makeDocForDelete(AINF_SEQN, user.SServer, phonenumdata.E_PERNR, ptMailBody.getProperty("UPMU_NAME"), currApprNumb);
                        vcElofficInterfaceData.add(eofD);
                        ElofficInterfaceData eofI = ddfe.makeDocForInsert(AINF_SEQN, user.SServer, phonenumdata.E_PERNR, ptMailBody.getProperty("UPMU_NAME"));
                        vcElofficInterfaceData.add(eofI);
                    }
                    // ����ó��
                    if (appLine.APPL_APPR_STAT.equals("A")) {
                        eof = ddfe.makeDocContents(AINF_SEQN, user.SServer, ptMailBody.getProperty("UPMU_NAME"));
                        vcElofficInterfaceData.add(eof);
                        // �ݷ�ó��
                    } else {
                        if (APPU_TYPE.equals("02") && Integer.parseInt(APPR_SEQN) > 1) {
                            eof = ddfe.makeDocForMangerReject(AINF_SEQN, user.SServer, ptMailBody.getProperty("UPMU_NAME"), approvalLine);
                            vcElofficInterfaceData.add(eof);
                        } else {
                            int nRejectLength = 0;
                            for (int i = approvalLine.size() - 1; i >= 0; i--) {
                                tempAppLine = approvalLine.get(i);
                                if (tempAppLine.APPU_TYPE.equals(APPU_TYPE) && tempAppLine.APPR_SEQN.equals(APPR_SEQN)) {
                                    nRejectLength = i + 1;
                                    break;
                                } // end if
                            } // end for

                            String approvers[] = new String[nRejectLength];
                            for (int i = 0; i < approvers.length; i++) {
                                tempAppLine = approvalLine.get(i);
                                approvers[i] = tempAppLine.PERNR;
                            } // end for
                            if (!currApprNumb.equals(user.empNo)) {
                                approvers[approvers.length - 1] = user.empNo; // ESB ���� ����
                            }
                            eof = ddfe.makeDocForReject(AINF_SEQN, user.SServer, ptMailBody.getProperty("UPMU_NAME"), d01OTData.PERNR, approvers);
                            vcElofficInterfaceData.add(eof);
                        } // end if

                        eof.R_EMP_NO = DataUtil.fixEndZero(user.empNo, 8); /* �ݷ� ��û�ڴ� ���� �α��� ��� - �̼۷����� Ȯ�� �� �߰�����  */
                    } // end if

                    // ���հ��� ����
                    retunMsgEL = ElofficInterface(vcElofficInterfaceData, user);
                    // ���հ��� �������� ���� �߻��� ������ return
                    if (!retunMsgEL.CODE.equals("0")) {
                        retunMsg.CODE = MobileCodeErrVO.ERROR_CODE_400 + "" + retunMsgEL.CODE;
                        retunMsg.VALUE = retunMsgEL.VALUE;
                        return retunMsg;
                    }

                } catch (Exception e) {
                    retunMsg.CODE = MobileCodeErrVO.ERROR_CODE_400;
                    retunMsg.VALUE = msg2 + " Eloffic ���� ���� ";
                    return retunMsg;

                } // end try

                // ���Ϲ߼�
                if (!maTe.process()) {
                    msg2 = maTe.getMessage() + "\\n";
                    //
                } // end if

                retunMsg.CODE = "0";
                retunMsg.VALUE = "";// ����

            } else {
                Logger.debug.println("ars.E_RETURN================" + approvalReturn.E_RETURN);
                Logger.debug.println(" ars.E_MESSAGE================" + approvalReturn.E_MESSAGE);
                retunMsg.CODE = MobileCodeErrVO.ERROR_CODE_300;
                retunMsg.VALUE = MobileCodeErrVO.ERROR_MSG_300 + approvalReturn.E_MESSAGE;
                return retunMsg;

            } // end if
        } catch (Exception e) {
            Logger.error(e);
            retunMsg.CODE = MobileCodeErrVO.ERROR_CODE_300;
            retunMsg.VALUE = e.getMessage() + "����ó�� ����";
            return retunMsg;
        } // end try 1
        return retunMsg;
    }

    // �ް���û ����ó�� ó�� �� ��� �ڵ� �� �޼��� Return
    /**
     * �ް���û ����ó�� ó�� �� ��� �ڵ� �� �޼��� Return
     * 
     * @return
     */
    public MobileReturnData processApprovalVacation(String AINF_SEQN, String P_PERNR, String apprType, String apprComment, WebUserData user, ApprovalHeader approvalHeader) throws GeneralException {

        Logger.debug.println("processApprovalVaction start================");
        // ���ϰ� setting
        MobileReturnData retunMsg = new MobileReturnData();
        retunMsg.CODE = "";
        retunMsg.VALUE = "";
        // ���հ��翬�� �����
        MobileReturnData retunMsgEL = new MobileReturnData();

        Vector d03VocationData_vt = null;
        D03VocationData d03VocationData = null;

        // ����/�ݷ�
        String APPR_STAT = "";
        if (apprType.equals("01")) {
            APPR_STAT = "A"; // ����
        } else {
            APPR_STAT = "R"; // �ݷ�
        }
        Logger.debug.println("processApprovalVaction jmk APPR_STAT================>" + APPR_STAT);
        try {
            d03VocationData = new D03VocationData();
            d03VocationData_vt = new Vector();
            ApprovalLineData tempAppLine;

            // �ް� ���� �ڷ�
            D03VocationRFC rfc = new D03VocationRFC();
            rfc.setDetailInput(user.empNo, "1", AINF_SEQN);
            d03VocationData_vt = rfc.getVocation(user.empNo, AINF_SEQN);
            Logger.debug.println(this, "�ް� ��ȸ : " + d03VocationData_vt.toString());

            if (d03VocationData_vt.size() < 1) {
                retunMsg.CODE = MobileCodeErrVO.ERROR_CODE_300;
                retunMsg.VALUE = MobileCodeErrVO.ERROR_CODE_300 + " �ް������� �������� �ʽ��ϴ�.";
                return retunMsg;
            } else {
                // �ް�
                d03VocationData = (D03VocationData) d03VocationData_vt.get(0);
                d03VocationData.I_NTM = "X";// [CSR ID:3700538] �����ް��� ���Կ� ���� Mobile �ް���û �� ����ȭ�� ���� ��û ��
            }

            /*// ���� ������ ����
            DocumentInfo docinfo = new DocumentInfo(AINF_SEQN ,P_PERNR,false);
            int approvalStep = docinfo.getApprovalStep();
            int docType = docinfo.getType();
            Logger.debug.println("processApprovalVaction jmk================docType:"+docType );
            Logger.debug.println("processApprovalVaction jmk================approvalStep:"+approvalStep );
            if(docType !=docinfo.MUST_APPROVAL ){
            	retunMsg.CODE = MobileCodeErrVO.ERROR_CODE_300;
            	retunMsg.VALUE = MobileCodeErrVO.ERROR_MSG_300+"�̹� ����ó���� �����Դϴ�.";
            	return retunMsg;
            }
            
            // �����ڶ��� ����
            //Vector AppLineData_vt = AppUtil.getAppChangeVt(AINF_SEQN);
            ApprInfoRFC func = new ApprInfoRFC();
            Vector AppLineData_vt = func.getApproval( AINF_SEQN );
            
            int nRowCount = AppLineData_vt.size();
            Logger.debug.println("processApprovalVaction jmk================nRowCount:"+nRowCount );
            String APPU_TYPE   = docinfo.getAPPU_TYPE();
            //�������
            String APPR_SEQN   = docinfo.getAPPR_SEQN();
            
            String currApprNumb = "";  //ESB ���� ����
            
            for (int i = 0; i < nRowCount; i++) {
                tempAppLine = new AppLineData();
                tempAppLine = (AppLineData)AppLineData_vt.get(i);
                DataUtil.fixNullAll( tempAppLine );
                vcTempAppLineData.add(tempAppLine);
                Logger.debug.println("processApprovalVaction jmk==JMK===========tempAppLine.toString:"+tempAppLine.toString());
                Logger.debug.println("processApprovalVaction jmk=============tempAppLine.APPL_APPR_STAT:"+tempAppLine.APPL_APPR_STAT );
                Logger.debug.println("processApprovalVaction jmk=============tempAppLine.currApprNumb:"+currApprNumb );
                Logger.debug.println("processApprovalVaction jmk=============tempAppLine.APPL_APPU_NUMB:"+ tempAppLine.APPL_APPU_NUMB );
            
            
            
                if ((tempAppLine.APPL_APPR_STAT==null||tempAppLine.APPL_APPR_STAT.equals("")) && currApprNumb.equals("")){
                	//currApprNumb = tempAppLine.APPL_APPU_NUMB;
                	currApprNumb = tempAppLine.APPL_PERNR;
            
                }
                Logger.debug.println("processApprovalVaction jmk=============tempAppLine.currApprNumb:"+currApprNumb );
                Logger.debug.println("processApprovalVaction jmk================APPU_TYPE:"+APPU_TYPE );
                Logger.debug.println("processApprovalVaction jmk================APPR_SEQN:"+APPR_SEQN );
            
                if (tempAppLine.APPL_APPU_TYPE.equals(APPU_TYPE) && tempAppLine.APPL_APPR_SEQN.equals(APPR_SEQN)) {
                    appLine.APPL_BUKRS = user.companyCode;
                    appLine.APPL_PERNR = d03VocationData.PERNR; //��û��
                    appLine.APPL_BEGDA = d03VocationData.BEGDA;
                    appLine.APPL_AINF_SEQN = AINF_SEQN;
                    appLine.APPL_APPU_TYPE = APPU_TYPE;
                    appLine.APPL_APPR_SEQN = APPR_SEQN;
                    appLine.APPL_APPU_NUMB = user.empNo;
                    appLine.APPL_APPR_STAT = APPR_STAT;
                    appLine.APPL_BIGO_TEXT = apprComment;
                    appLine.APPL_APPR_DATE = DataUtil.getCurrentDate();
                } // end if
            } // end for
            
            Logger.debug.println("processApprovalVaction jmk================vcTempAppLineData:"+vcTempAppLineData);
            Logger.debug.println("processApprovalVaction jmk================appLine:"+appLine.toString());
            vcAppLineData.add(appLine);
            
            G001ApprovalProcessRFC  Apr = new G001ApprovalProcessRFC();
            Vector vcRet = Apr.setApprovalStatutsList(vcAppLineData );
            
            Logger.debug.println("processApprovalVaction jmk================vcRet:"+vcRet);
            
            ApprovalReturnState ars = (ApprovalReturnState) vcRet.get(0);
            
            Logger.debug.println("processApprovalVaction ars================ars:"+ars.toString());*/

            Vector<ApprovalLineData> approvalLine = rfc.getApprovalLine();

            ApprovalLineData approvalCurrent = null;

            /* ���� ������ �������� */
            for (ApprovalLineData approvalLineData : approvalLine) {
                if (StringUtils.isBlank(approvalLineData.APPR_STAT)) {
                    approvalCurrent = approvalLineData;
                    break;
                }
            }

            /* ����/�ݷ� �� ���� ���� ���� */
            AppLineData appLine = new AppLineData();

            appLine.APPL_BUKRS = user.companyCode;
            appLine.APPL_PERNR = approvalHeader.PERNR;
            appLine.APPL_BEGDA = d03VocationData.BEGDA;
            appLine.APPL_AINF_SEQN = approvalHeader.AINF_SEQN;
            appLine.APPL_APPU_TYPE = approvalCurrent.APPU_TYPE;
            appLine.APPL_APPR_SEQN = approvalCurrent.APPR_SEQN;
            appLine.APPL_APPU_NUMB = user.empNo;
            appLine.APPL_APPR_STAT = APPR_STAT;
            appLine.APPL_BIGO_TEXT = apprComment;
            // appLine.APPL_CMMNT = box.getString("BIGO_TEXT"); //���� �ǰ�
            appLine.APPL_APPR_DATE = DataUtil.getCurrentDate();
            appLine.APPL_APPR_TIME = DataUtil.getDate();

            G001ApprovalProcessRFC approvalProcessRFC = new G001ApprovalProcessRFC();
            ApprovalReturnState approvalReturn = approvalProcessRFC.setApproval(Utils.asVector(appLine), "T_ZHRA018T", Utils.asVector(d03VocationData));

            // ���Ϲ߼��� ����
            PersonInfoRFC numfunc = new PersonInfoRFC();
            PersonData phonenumdata;
            phonenumdata = numfunc.getPersonInfo(d03VocationData.PERNR);

            Properties ptMailBody = new Properties();
            // ptMailBody.setProperty("SServer", user.SServer);
            ptMailBody.setProperty("SServer", "");   // ElOffice ���� ����
            ptMailBody.setProperty("from_empNo", P_PERNR);               // �� �߼��� ���

            ptMailBody.setProperty("ename", phonenumdata.E_ENAME);          // (��)��û�ڸ�
            ptMailBody.setProperty("empno", phonenumdata.E_PERNR);          // (��)��û�� ���

            ptMailBody.setProperty("UPMU_NAME", "�ް�");               // ���� �̸�

            ptMailBody.setProperty("AINF_SEQN", AINF_SEQN);                 // ��û�� ����

            // �� ����
            StringBuffer sbSubject = new StringBuffer(512);

            // [CSR ID:3420113] �λ�ý��� ��û �� ���� ���� UI ǥ���۾� 2017-06-29 eunha start
            // sbSubject.append("[" + ptMailBody.getProperty("UPMU_NAME") + "] ");
            // sbSubject.append(user.ename + "���� ");
            // [CSR ID:3420113] �λ�ý��� ��û �� ���� ���� UI ǥ���۾� 2017-06-29 eunha end

            String msg2 = "";
            String to_empNo = d03VocationData.PERNR;

            String APPU_TYPE = approvalCurrent.APPU_TYPE;
            String APPR_SEQN = approvalCurrent.APPR_SEQN;
            String currApprNumb = approvalCurrent.APPU_NUMB;

            if (approvalReturn.isSuccess()) {
                if (appLine.APPL_APPR_STAT.equals("A")) {
                    for (int i = 0; i < approvalLine.size(); i++) {
                        tempAppLine = approvalLine.get(i);
                        if (tempAppLine.APPU_TYPE.equals(approvalCurrent.APPU_TYPE) && tempAppLine.APPR_SEQN.equals(approvalCurrent.APPR_SEQN)) {
                            ptMailBody.setProperty("FileName", "MbNoticeMailApp.html");
                            if (i == approvalLine.size() - 1) {
                                // ������ ������
                                // [CSR ID:3420113] �λ�ý��� ��û �� ���� ���� UI ǥ���۾� 2017-06-29 eunha start
                                // sbSubject.append(ptMailBody.getProperty("UPMU_NAME") +"�� ���� �ϼ̽��ϴ�.");
                                sbSubject.append("[HR] ����Ϸ� �뺸 (" + ptMailBody.getProperty("UPMU_NAME") + ")");
                                // [CSR ID:3420113] �λ�ý��� ��û �� ���� ���� UI ǥ���۾� 2017-06-29 eunha end
                            } else {
                                // ���� ������
                                tempAppLine = approvalLine.get(i + 1);
                                to_empNo = tempAppLine.PERNR;
                                // sbSubject.append("���縦 ��û �ϼ̽��ϴ�.");
                                break;
                            } // end if
                        } else {

                        } // end if
                    } // end for
                } else {
                    if (APPU_TYPE.equals("02") && Integer.parseInt(APPR_SEQN) > 1) {
                        for (int i = 0; i < approvalLine.size(); i++) {
                            tempAppLine = approvalLine.get(i);
                            if (tempAppLine.APPU_TYPE.equals("02") && tempAppLine.APPR_SEQN.equals("01")) {
                                tempAppLine = approvalLine.get(i);
                                to_empNo = tempAppLine.PERNR;
                            } // end if
                        } // end for
                    } // end if
                    ptMailBody.setProperty("FileName", "MbNoticeMailRej.html");
                    // [CSR ID:3420113] �λ�ý��� ��û �� ���� ���� UI ǥ���۾� 2017-06-29 eunha start
                    // sbSubject.append(ptMailBody.getProperty("UPMU_NAME") +"�� �ݷ� �ϼ̽��ϴ�.");
                    sbSubject.append("[HR] ����ݷ� �뺸 (" + ptMailBody.getProperty("UPMU_NAME") + ")");
                    // [CSR ID:3420113] �λ�ý��� ��û �� ���� ���� UI ǥ���۾� 2017-06-29 eunha end
                } // end if

                ptMailBody.setProperty("to_empNo", to_empNo);                   // �� ������ ���
                ptMailBody.setProperty("subject", sbSubject.toString());        // �� ���� ����
                MailSendToEloffic maTe = new MailSendToEloffic(ptMailBody);

                try {
                    DraftDocForEloffice ddfe = new DraftDocForEloffice();
                    ElofficInterfaceData eof;
                    Vector vcElofficInterfaceData = new Vector();
                    // ESB ���� ����
                    if (!currApprNumb.equals(user.empNo)) {
                        // ����÷��� ������ ���� �׽�ũ�� ������ �ִ� �����ڰ� �����Ҷ� ó��:���� ���ڰ��翡 ���ִ� DATA�� ������ �ٽ� ó��
                        ElofficInterfaceData eofD = ddfe.makeDocForDelete(AINF_SEQN, user.SServer, phonenumdata.E_PERNR, ptMailBody.getProperty("UPMU_NAME"), currApprNumb);
                        vcElofficInterfaceData.add(eofD);
                        ElofficInterfaceData eofI = ddfe.makeDocForInsert(AINF_SEQN, user.SServer, phonenumdata.E_PERNR, ptMailBody.getProperty("UPMU_NAME"));
                        vcElofficInterfaceData.add(eofI);
                    }
                    // ����ó��
                    if (appLine.APPL_APPR_STAT.equals("A")) {
                        eof = ddfe.makeDocContents(AINF_SEQN, user.SServer, ptMailBody.getProperty("UPMU_NAME"));
                        vcElofficInterfaceData.add(eof);
                        // �ݷ�ó��
                    } else {
                        if (APPU_TYPE.equals("02") && Integer.parseInt(APPR_SEQN) > 1) {
                            eof = ddfe.makeDocForMangerReject(AINF_SEQN, user.SServer, ptMailBody.getProperty("UPMU_NAME"), approvalLine);
                            vcElofficInterfaceData.add(eof);
                        } else {
                            int nRejectLength = 0;
                            for (int i = approvalLine.size() - 1; i >= 0; i--) {
                                tempAppLine = approvalLine.get(i);
                                if (tempAppLine.APPU_TYPE.equals(APPU_TYPE) && tempAppLine.APPR_SEQN.equals(APPR_SEQN)) {
                                    nRejectLength = i + 1;
                                    break;
                                } // end if
                            } // end for

                            String approvers[] = new String[nRejectLength];
                            for (int i = 0; i < approvers.length; i++) {
                                tempAppLine = approvalLine.get(i);
                                approvers[i] = tempAppLine.PERNR;
                            } // end for
                            if (!currApprNumb.equals(user.empNo)) {
                                approvers[approvers.length - 1] = user.empNo; // ESB ���� ����
                            }
                            eof = ddfe.makeDocForReject(AINF_SEQN, user.SServer, ptMailBody.getProperty("UPMU_NAME"), d03VocationData.PERNR, approvers);
                            vcElofficInterfaceData.add(eof);
                        } // end if

                        eof.R_EMP_NO = DataUtil.fixEndZero(user.empNo, 8); /* �ݷ� ��û�ڴ� ���� �α��� ��� - �̼۷����� Ȯ�� �� �߰�����  */

                    } // end if

                    // ���հ��� ����
                    retunMsgEL = ElofficInterface(vcElofficInterfaceData, user);
                    // ���հ��� �������� ���� �߻��� ������ return
                    if (!retunMsgEL.CODE.equals("0")) {
                        retunMsg.CODE = MobileCodeErrVO.ERROR_CODE_400 + "" + retunMsgEL.CODE;
                        retunMsg.VALUE = retunMsgEL.VALUE;
                        return retunMsg;
                    }

                } catch (Exception e) {
                    retunMsg.CODE = MobileCodeErrVO.ERROR_CODE_400;
                    retunMsg.VALUE = msg2 + " Eloffic ���� ���� ";
                    return retunMsg;

                } // end try

                // ���Ϲ߼�
                if (!maTe.process()) {
                    msg2 = maTe.getMessage() + "\\n";
                    //
                } // end if

                retunMsg.CODE = "0";
                retunMsg.VALUE = "";// ����

            } else {
                Logger.debug.println("ars.E_RETURN================" + approvalReturn.E_RETURN);
                Logger.debug.println(" ars.E_MESSAGE================" + approvalReturn.E_MESSAGE);
                retunMsg.CODE = MobileCodeErrVO.ERROR_CODE_300;
                retunMsg.VALUE = MobileCodeErrVO.ERROR_MSG_300 + approvalReturn.E_MESSAGE;
                return retunMsg;

            }
        } catch (Exception e) {
            Logger.error(e);
            retunMsg.CODE = MobileCodeErrVO.ERROR_CODE_300;
            retunMsg.VALUE = e.getMessage() + "����ó�� ����";
            return retunMsg;
        }
        return retunMsg;
    }

    /**
     * Flextime ����ó��
     * 
     * @param req
     * @param AINF_SEQN
     * @param PERNR
     * @param type
     * @param comment
     * @param user
     * @param approvalHeader
     * @return
     * @throws GeneralException
     */
    public MobileReturnData processApprovalFlextime(HttpServletRequest req, String AINF_SEQN, String PERNR, String type, String comment, WebUserData user, ApprovalHeader approvalHeader)
                    throws GeneralException {

        Logger.debug.println("processApprovalFlextime start ================");

        try {
            // Flextime ��û ����
            D20FlextimeRFC rfc = new D20FlextimeRFC();
            rfc.setDetailInput(user.empNo, "1", AINF_SEQN); // 1 : �����ؾ��� ����, 2 : ���������� ����, 3 : ����Ϸ� ����

            D20FlextimeData data = Utils.indexOf(rfc.getDetail(), 0);
            data.UNAME = user.empNo;
            data.AEDTM = DataUtil.getCurrentDate();
            data.I_NTM = "X";

            Vector<ApprovalLineData> approvalLine = rfc.getApprovalLine();

            /* ���� ������ �������� */
            ApprovalLineData approvalCurrent = null;
            for (ApprovalLineData approvalLineData : approvalLine) {
                if (StringUtils.isBlank(approvalLineData.APPR_STAT)) {
                    approvalCurrent = approvalLineData;
                    break;
                }
            }

            // ���Ϲ߼��� ����
            PersonData personData = new PersonInfoRFC().getPersonInfo(data.PERNR);

            Properties mailProperties = new Properties();
            mailProperties.setProperty("SServer", "");                // ElOffice ���� ����
            mailProperties.setProperty("from_empNo", PERNR);          // ���� �߼��� ���

            mailProperties.setProperty("ename", personData.E_ENAME);  // (��)��û�ڸ�
            mailProperties.setProperty("empno", personData.E_PERNR);  // (��)��û�� ���

            mailProperties.setProperty("UPMU_NAME", "Flextime ��û"); // ���� �̸�
            mailProperties.setProperty("AINF_SEQN", AINF_SEQN);       // �����ȣ

            String APPU_TYPE = approvalCurrent.APPU_TYPE;
            String APPR_SEQN = approvalCurrent.APPR_SEQN;
            String currApprNumb = approvalCurrent.APPU_NUMB;

            String to_empNo = data.PERNR;
            String subject = null;
            StringBuffer mailResultMsg = new StringBuffer();

            /* ����/�ݷ� �� ���� ���� ���� */
            AppLineData appLine = new AppLineData();

            appLine.APPL_BUKRS = user.companyCode;
            appLine.APPL_PERNR = approvalHeader.PERNR;
            appLine.APPL_BEGDA = data.BEGDA;
            appLine.APPL_AINF_SEQN = approvalHeader.AINF_SEQN;
            appLine.APPL_APPU_TYPE = approvalCurrent.APPU_TYPE;
            appLine.APPL_APPR_SEQN = approvalCurrent.APPR_SEQN;
            appLine.APPL_APPU_NUMB = user.empNo;
            appLine.APPL_APPR_STAT = "01".equals(type) ? "A" : "R";
            appLine.APPL_BIGO_TEXT = comment;
            appLine.APPL_APPR_DATE = DataUtil.getCurrentDate();
            appLine.APPL_APPR_TIME = DataUtil.getDate();

            ApprovalReturnState approvalReturn = new G001ApprovalProcessRFC().setApproval(Utils.asVector(appLine), "T_ZHRA041T", Utils.asVector(data));

            if (approvalReturn.isSuccess()) {
                if (appLine.APPL_APPR_STAT.equals("A")) {
                    for (int i = 0; i < approvalLine.size(); i++) {
                        ApprovalLineData tempAppLine = approvalLine.get(i);
                        if (tempAppLine.APPU_TYPE.equals(approvalCurrent.APPU_TYPE) && tempAppLine.APPR_SEQN.equals(approvalCurrent.APPR_SEQN)) {
                            mailProperties.setProperty("FileName", "MbNoticeMailApp.html");
                            if (i == approvalLine.size() - 1) {
                                // ������ ������
                                subject = g.getMessage("MSG.APPROVAL.0004", mailProperties.getProperty("UPMU_NAME")); // [HR] ����Ϸ� �뺸 ({0})

                            } else {
                                // ���� ������
                                tempAppLine = approvalLine.get(i + 1);
                                to_empNo = tempAppLine.PERNR;
                                subject = g.getMessage("MSG.APPROVAL.0005", mailProperties.getProperty("UPMU_NAME")); // [HR] �����û ({0})
                                break;
                            }
                        }
                    }
                } else {
                    if (APPU_TYPE.equals("02") && Integer.parseInt(APPR_SEQN) > 1) {
                        for (int i = 0; i < approvalLine.size(); i++) {
                            ApprovalLineData tempAppLine = approvalLine.get(i);
                            if (tempAppLine.APPU_TYPE.equals("02") && tempAppLine.APPR_SEQN.equals("01")) {
                                tempAppLine = approvalLine.get(i);
                                to_empNo = tempAppLine.PERNR;
                            }
                        }
                    }
                    mailProperties.setProperty("FileName", "MbNoticeMailRej.html");
                    subject = g.getMessage("MSG.APPROVAL.0006", mailProperties.getProperty("UPMU_NAME")); // [HR] ����ݷ� �뺸 ({0})
                }

                mailProperties.setProperty("to_empNo", to_empNo); // ���� ������ ���
                mailProperties.setProperty("subject", subject);   // ���� ���� ����

                MailSendToEloffic maTe = new MailSendToEloffic(mailProperties);

                // ���Ϲ߼�
                if (!maTe.process()) {
                    mailResultMsg.append(maTe.getMessage());
                }

                try {
                    DraftDocForEloffice ddfe = new DraftDocForEloffice();
                    ElofficInterfaceData eof;
                    Vector vcElofficInterfaceData = new Vector();
                    // ESB ���� ����
                    if (!currApprNumb.equals(user.empNo)) {
                        // ����÷��� ������ ���� �׽�ũ�� ������ �ִ� �����ڰ� �����Ҷ� ó��:���� ���ڰ��翡 ���ִ� DATA�� ������ �ٽ� ó��
                        ElofficInterfaceData eofD = ddfe.makeDocForDelete(AINF_SEQN, user.SServer, personData.E_PERNR, mailProperties.getProperty("UPMU_NAME"), currApprNumb);
                        vcElofficInterfaceData.add(eofD);
                        ElofficInterfaceData eofI = ddfe.makeDocForInsert(AINF_SEQN, user.SServer, personData.E_PERNR, mailProperties.getProperty("UPMU_NAME"));
                        vcElofficInterfaceData.add(eofI);
                    }
                    // ����ó��
                    if (appLine.APPL_APPR_STAT.equals("A")) {
                        eof = ddfe.makeDocContents(AINF_SEQN, user.SServer, mailProperties.getProperty("UPMU_NAME"));
                        vcElofficInterfaceData.add(eof);
                    }
                    // �ݷ�ó��
                    else {
                        if (APPU_TYPE.equals("02") && Integer.parseInt(APPR_SEQN) > 1) {
                            eof = ddfe.makeDocForMangerReject(AINF_SEQN, user.SServer, mailProperties.getProperty("UPMU_NAME"), approvalLine);
                            vcElofficInterfaceData.add(eof);
                        } else {
                            int nRejectLength = 0;
                            for (int i = approvalLine.size() - 1; i >= 0; i--) {
                                ApprovalLineData tempAppLine = approvalLine.get(i);
                                if (tempAppLine.APPU_TYPE.equals(APPU_TYPE) && tempAppLine.APPR_SEQN.equals(APPR_SEQN)) {
                                    nRejectLength = i + 1;
                                    break;
                                }
                            }

                            String approvers[] = new String[nRejectLength];
                            for (int i = 0; i < approvers.length; i++) {
                                ApprovalLineData tempAppLine = approvalLine.get(i);
                                approvers[i] = tempAppLine.PERNR;
                            }
                            if (!currApprNumb.equals(user.empNo)) {
                                approvers[approvers.length - 1] = user.empNo; // ESB ���� ����
                            }
                            eof = ddfe.makeDocForReject(AINF_SEQN, user.SServer, mailProperties.getProperty("UPMU_NAME"), data.PERNR, approvers);
                            vcElofficInterfaceData.add(eof);
                        }

                        eof.R_EMP_NO = DataUtil.fixEndZero(user.empNo, 8); // �ݷ� ��û�ڴ� ���� �α��� ��� - �̼۷����� Ȯ�� �� �߰���
                    }

                    // ���հ��� ����
                    MobileReturnData ifReturnData = ElofficInterface(vcElofficInterfaceData, user);

                    // ���հ��� �������� ���� �߻��� ������ return
                    if (!ifReturnData.CODE.equals("0")) {
                        MobileReturnData returnData = new MobileReturnData();
                        returnData.CODE = MobileCodeErrVO.ERROR_CODE_400 + ifReturnData.CODE;
                        returnData.VALUE = ifReturnData.VALUE;
                        return returnData;
                    }

                    ifReturnData.VALUE = "A".equals(appLine.APPL_APPR_STAT) ? g.getMessage("MSG.COMMON.0009") : g.getMessage("MSG.COMMON.0010"); // ���� �ϼ̽��ϴ�. : �ݷ� �ϼ̽��ϴ�.

                    return ifReturnData;

                } catch (Exception e) {
                    MobileReturnData returnData = new MobileReturnData();
                    returnData.CODE = MobileCodeErrVO.ERROR_CODE_400;
                    returnData.VALUE = mailResultMsg + " Eloffic ���� ���� ";
                    return returnData;

                }

            } else {
                Logger.debug.println("approvalReturn.E_RETURN=================" + approvalReturn.E_RETURN);
                Logger.debug.println("approvalReturn.E_MESSAGE================" + approvalReturn.E_MESSAGE);

                MobileReturnData returnData = new MobileReturnData();
                returnData.CODE = MobileCodeErrVO.ERROR_CODE_300;
                returnData.VALUE = MobileCodeErrVO.ERROR_MSG_300 + approvalReturn.E_MESSAGE;
                return returnData;

            }

        } catch (Exception e) {
            Logger.error(e);

            MobileReturnData returnData = new MobileReturnData();
            returnData.CODE = MobileCodeErrVO.ERROR_CODE_300;
            returnData.VALUE = e.getMessage() + "����ó�� ����";
            return returnData;
        }
    }

    /**
     * ���հ��� ����
     * 
     * @param vcElofficInterfaceData
     * @param user
     * @return
     */
    public MobileReturnData ElofficInterface(Vector vcElofficInterfaceData, WebUserData user) {

        Logger.debug.println(this, "ElofficInterface  =++++++++++++++++++++>start");
        // ���ϰ� setting
        MobileReturnData retunMsg = new MobileReturnData();
        retunMsg.CODE = "";
        retunMsg.VALUE = "";
        Logger.debug.println(this, "vcElofficInterfaceData=++++++++++++++++++++>" + vcElofficInterfaceData.toString());

        try {
            Vector vcEof = vcElofficInterfaceData;
            com.sns.jdf.Config conf = new com.sns.jdf.Configuration();

            String mobileUrl = "http://" + conf.getString("com.sns.jdf.eloffice.ResponseURL") + WebUtil.ServletURL + "hris.MobileDetailSV?"; // ������ȣ�� ����� Mobile���� �����ش�

            // MobileDetailSV
            Logger.debug.println(this, "mobileUrl=++++++++++++++++++++>" + mobileUrl);
            Logger.debug.println(this, "vcEof.size()=++++++++++++++++++++>" + vcEof.size());
            for (int i = 0; i < vcEof.size(); i++) {
                ElofficInterfaceData eof = (ElofficInterfaceData) vcEof.get(i);

                try {

                    ESBAdapter esbAp = new LGChemESBService("APPINT_ESB", conf.getString("com.sns.jdf.eloffice.ESBInfo"));
                    Hashtable appParam = new Hashtable();
                    // if ( eof.SUBJECT.equals("�Ƿ��")||eof.SUBJECT.equals("�ξ簡��")||eof.SUBJECT.equals("�ξ� ���� ����")||eof.SUBJECT.equals("���б�/���ڱ�")||eof.SUBJECT.equals("���б�/���ڱ� ��û")) {

                    Logger.debug.println(this, "^^^^^ ElOfficeInterface</b>[eof:]" + eof.toString());
                    // }

                    if (eof.APP_ID.length() > 0) {
                        if (eof.APP_ID.indexOf("?eHR=") > 0)
                            eof.APP_ID = eof.APP_ID.substring(0, 10);
                    }
                    if (eof.URL.length() > 0) {
                        if (eof.URL.indexOf("?eHR=") > 0)
                            eof.URL = StringUtils.remove(eof.URL, "?eHR=");
                    }
                    appParam.put("CATEGORY", eof.CATEGORY);    // ��ĸ�
                    appParam.put("MAIN_STATUS", eof.MAIN_STATUS);    // ���� Main����
                    appParam.put("P_MAIN_STATUS", eof.P_MAIN_STATUS);
                    appParam.put("SUB_STATUS", eof.SUB_STATUS);    // ���� Sub����
                    appParam.put("REQ_DATE", eof.REQ_DATE);    // ��û��
                    appParam.put("EXPIRE_DATE", eof.EXPIRE_DATE);    // ��������
                    appParam.put("AUTH_DIV", eof.AUTH_DIV);    // �����Һμ�
                    appParam.put("AUTH_EMP", eof.AUTH_EMP);    // �����Ұ���
                    appParam.put("MODIFY", eof.MODIFY);    // ��������
                    appParam.put("F_AGREE", eof.F_AGREE);    // �ڵ�����
                    appParam.put("R_EMP_NO", eof.R_EMP_NO);    // ����ڻ��
                    appParam.put("A_EMP_NO", eof.A_EMP_NO);    // �����ڻ��
                    appParam.put("SUBJECT", eof.SUBJECT);    // �������
                    appParam.put("APP_ID", eof.APP_ID);    // ���繮��ID
                    appParam.put("URL", eof.URL);
                    // appParam.put("DUMMY1" ,eof.URL ); //�����URL
                    appParam.put("DUMMY1", mobileUrl + "apprDocID=" + eof.APP_ID);     // �����URL
                    String ret_msg = "";

                    if (eof.MODIFY.equals("D")) {
                        // out.println( ret_msg+"<br><b>����</b>[appParam:]"+appParam.toString());
                        ret_msg = esbAp.modifyESB(appParam);
                    } else {
                        // out.println( ret_msg+"<br><b>����</b>[appParam:]"+appParam.toString());
                        ret_msg = esbAp.callESB(appParam);
                    }

                    String esb_ret_code = ret_msg.substring(0, 4);
                    // out.println("<br>[ret_msg:"+ret_msg);
                    if (!esb_ret_code.equals("0000")) {
                        retunMsg.CODE = esb_ret_code;
                        retunMsg.VALUE = ret_msg + "\\n" + "���հ��� ���� ����";
                    }

                    // ������
                    retunMsg.CODE = "0";
                    retunMsg.VALUE = "";

                } catch (ESBValidationException eV) {
                    retunMsg.CODE = "400";
                    retunMsg.VALUE = eV.getMessage() + "\\n" + "ESBValidationException ���հ��� ���� ����";
                    return retunMsg;

                } catch (ESBTransferException eT) {
                    retunMsg.CODE = "400";
                    retunMsg.VALUE = eT.getMessage() + "\\n" + "ESBTransferException ���հ��� ���� ����";
                    return retunMsg;
                } catch (Exception e) {
                    Logger.error(e);
                    retunMsg.CODE = "400";
                    retunMsg.VALUE = e.getMessage() + "\\n" + "Exception ���հ��� ���� ����";
                    return retunMsg;
                }
            }

        } catch (Exception e) {
            Logger.error(e);
            retunMsg.CODE = "400";
            retunMsg.VALUE = e.getMessage() + "\\n" + "���հ��� ���� ����";
            return retunMsg;
        }
        return retunMsg;
    }

    /**
     * @param req
     * @param res
     * @throws GeneralException
     */
    protected void autoLogin(HttpServletRequest req, HttpServletResponse res) throws GeneralException {

        try {
            Logger.debug.println("autoLogin  start++++++++++++++++++++++++++++++++++++++");
            HttpSession session = req.getSession(true);

            WebUserData user = new WebUserData();
            Box box = WebUtil.getBox(req);
            Logger.debug.println("##########box####################>" + box);
            String empNo = DataUtil.fixEndZero(EncryptionTool.decrypt(box.getString("empNo")), 8);
            user.empNo = empNo;
            Logger.debug.println("#############################empNo:" + empNo);

            try {
                PersonInfoRFC personInfoRFC = new PersonInfoRFC();
                PersonData personData = personInfoRFC.getPersonInfo(empNo, "X");

                if (personData.E_BUKRS == null || personData.E_BUKRS.equals("")) {
                    // String msg = "�����ȣ�� Ȯ���Ͽ� �ֽʽÿ�.";
                    req.setAttribute("msg", "���� �� ������ �߻��Ͽ����ϴ�."); // [CSR ID:] ehr�ý�������༺���� ����
                    req.setAttribute("url", "histroy.back(-1);");

                } else {
                    Config conf = new Configuration();
                    user.clientNo = conf.get("com.sns.jdf.sap.SAP_CLIENT");

                    user.login_stat = "Y";
                    personInfoRFC.setSessionUserData(personData, user);
                    WebUtil.setLang(WebUtil.getLangFromCookie(req), req, user);
                    user.loginPlace = "ElOffice";
                    user.empNo = DataUtil.fixEndZero(empNo, 8);
                    // user.SServer = SServer;

                    // @v1.0 �޴����� db�� oracle���� sap�� �̰�
                    /*SysAuthGroupRFC rfc_Auth         = new SysAuthGroupRFC();
                    user.user_group = rfc_Auth.getAuthGroup(user.e_authorization);*/

                    DataUtil.fixNull(user);
                    session = req.getSession(true);

                    int maxSessionTime = Integer.parseInt(conf.get("com.sns.jdf.SESSION_MAX_INACTIVE_INTERVAL"));
                    session.setMaxInactiveInterval(maxSessionTime);
                    session.setAttribute("user", user);

                }
            } catch (Exception ex) {
                Logger.err.println(this, "Data Not Found");

                req.setAttribute("msg", "���� �� ������ �߻��Ͽ����ϴ�."); // [CSR ID:] ehr�ý�������༺���� ����
                req.setAttribute("url", "histroy.back(-1);");
            }

        } catch (Exception e) {
            throw new GeneralException(e);

        }
    }

}