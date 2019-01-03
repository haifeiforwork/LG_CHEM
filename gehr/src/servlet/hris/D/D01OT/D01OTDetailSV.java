/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS
/*   1Depth Name  : MY HR ����
/*   2Depth Name  : �ʰ��ٹ�
/*   Program Name : �ʰ��ٹ� ��ȸ
/*   Program ID   : D01OTDetailSV
/*   Description  : �ʰ��ٹ� ��ȸ �� ������ �� �� �ֵ��� �ϴ� Class
/*   Note         :
/*   Creation     : 2002-01-15 �ڿ���
/*   Update       : 2005-03-03 ������
/*                  2018-05-17 [WorkTime52] ������
/*                                                                              */
/********************************************************************************/

package servlet.hris.D.D01OT;

import java.util.HashMap;
import java.util.Map;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.ObjectUtils;
import org.apache.commons.lang.StringUtils;

import com.common.RFCReturnEntity;
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

import hris.D.D01OT.D01OTData;
import hris.D.D01OT.D01OTRealWorkDATA;
import hris.D.D01OT.rfc.D01OTRFC;
import hris.D.D01OT.rfc.D01OTRealWrokListRFC;
import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.rfc.PersonInfoRFC;

@SuppressWarnings({ "rawtypes", "serial" })
public class D01OTDetailSV extends ApprovalBaseServlet {

    private String UPMU_TYPE = "17";

    private String UPMU_NAME = "�ʰ��ٹ�";

    protected String getUPMU_TYPE() {
        return UPMU_TYPE;
    }

    protected String getUPMU_NAME() {
        return UPMU_NAME;
    }

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {

        try {
            final WebUserData user = WebUtil.getSessionUser(req);

            /* start : ������ �б�ó�� */
            if (!user.area.equals(Area.KR)) { // �ؿ�ȭ������
                printJspPage(req, res, WebUtil.ServletURL + "hris.D.D01OT.D01OTDetailGlobalSV");
                return;
            }
            /*   end : ������ �б�ó�� */

            Box box = WebUtil.getBox(req);

            final String AINF_SEQN = box.get("AINF_SEQN");
            final String I_APGUB = (String) req.getAttribute("I_APGUB");  // ��� ���������� �Գ�? '1' : ������ ���� , '2' : ������ ���� , '3' : ����Ϸ� ����
            req.setAttribute("APGUB", I_APGUB);

            final D01OTRFC rfc = new D01OTRFC(user.empNo, I_APGUB, AINF_SEQN);

            Vector D01OTData_vt = rfc.getDetail(null, null);

            final D01OTData firstData = (D01OTData) Utils.indexOf(D01OTData_vt, 0);

            // �븮 ��û �߰� and �Ǳٹ��ð� ��Ȳǥ �߰�
            if (firstData != null) {
                req.setAttribute("PersonData", new PersonInfoRFC().getPersonInfo(firstData.PERNR));

                // ���� : 2018.05.17 [WorkTime52] ������ - �Ǳٹ��ð� ��Ȳǥ �߰�
                try {
                    /**
                     * �Ǳٹ��ð� ��Ȳǥ �߰�����
                     *     S(�繫�� ��Ȳǥ �߰�)
                     *     H(������ ��Ȳǥ �߰�)
                     *     -(���� �ʰ��ٹ� ��Ȳǥ ����)
                     *     X(�ش� ����)
                     *
                     * -------------------------------------------------------------------------
                     *           ���� ����          | ������ ���� | ������ ���� | ����Ϸ� ����
                     *                              | I_APGUB = 1 | I_APGUB = 2 | I_APGUB = 3
                     * -------------------------------------------------------------------------
                     *         | �繫��(S) | ��û�� |  X          |  S          |  S
                     *         |-----------|        |-------------------------------------------
                     *  ��û�� | ������(H) |  ȭ��  |  X          |  -          |  -
                     *   ���  |----------------------------------------------------------------
                     *   ����  | �繫��(S) | ������ |  S          |  S          |  S
                     *         |-----------|        |-------------------------------------------
                     *         | ������(H) |  ȭ��  |  H          |  H          |  H
                     * -------------------------------------------------------------------------
                     *
                     * ������ ���忡���� ��� ���� ȭ�鿡 ��Ȳǥ �߰�
                     * ��û�� ���忡���� �������̰ų� ����Ϸ�� ���� ȭ�鿡 ��Ȳǥ �߰�
                     */
                    if (!"1".equals(I_APGUB) || !user.empNo.equals(firstData.PERNR)) {
                        final String WORK_DATE = StringUtils.defaultString(firstData.WORK_DATE).replaceAll("[^\\d]", "");
                        final String I_DATUM = "X".equals(firstData.VTKEN) ? DataUtil.addDays(WORK_DATE, -1, "yyyyMMdd") : WORK_DATE;

                        // ��û�� ��� ���� ��ȸ : S(�繫��) or H(������)
                        Map<String, Object> rfcResultData = RfcHandler.execute("ZGHR_RFC_NTM_GET_EMPGUB", new HashMap<String, Object>() {
                            {
                                put("I_PERNR", firstData.PERNR);
                                put("I_DATUM", I_DATUM);
                            }
                        });

                        Map<String, Object> EXPORT = getData(rfcResultData, "EXPORT", g.getMessage("MSG.D.D01.0063"));
                        final String EMPGUB = ObjectUtils.toString(EXPORT.get("E_EMPGUB")); // �Ǳٹ��ð� ��Ȳ ��ȸ�� �ʿ��� ��� ����(�繫�� or ������) �����͸� ��ȸ���� ���Ͽ����ϴ�.
                        req.setAttribute("EMPGUB", EMPGUB);
                        req.setAttribute("TPGUB", EXPORT.get("E_TPGUB"));
                        req.setAttribute("MM", Integer.parseInt(DataUtil.getCurrentMonth()));

                        if ("S".equals(EMPGUB) || ("H".equals(EMPGUB) && !user.empNo.equals(firstData.PERNR))) {
                            // ��û�� �Ǳٹ��ð� ��Ȳ ��ȸ
                            rfcResultData = RfcHandler.execute("ZGHR_RFC_NTM_OT_REQ_RW_LIST", new HashMap<String, Object>() {
                                {
                                    put("I_EMPGUB", EMPGUB);
                                    put("I_PERNR", firstData.PERNR);
                                    put("I_DATUM", WORK_DATE);
                                    put("I_AINF_SEQN", firstData.AINF_SEQN);
                                    if ("H".equals(EMPGUB)) put("I_VTKEN", firstData.VTKEN);
                                }
                            });

                            WebUtil.setAttributes(req, (Map<String, Object>) getData(rfcResultData, "EXPORT", g.getMessage("MSG.D.D01.0064")).get("ES_EMPGUB_" + EMPGUB)); // �Ǳٹ��ð� ��Ȳ �����͸� ��ȸ���� ���Ͽ����ϴ�.
                        }

                    }

                } catch (Exception e) {
                    req.setAttribute("msg", e.getMessage());
                    req.setAttribute("url", "history.back()");

                    printJspPage(req, res, WebUtil.JspURL + "common/msg.jsp");
                    return;
                }
                // ���� : 2018.05.17 [WorkTime52] ������ - �Ǳٹ��ð� ��Ȳǥ �߰�
            }

            String dest = null;
            String jobid = box.get("jobid", "first");

            Logger.debug.println(this, "[jobid] = " + jobid + " [user] : " + user.toString());

            if ("first".equals(jobid)) {
                req.setAttribute("D01OTData_vt", D01OTData_vt);

                if (!detailApporval(req, res, rfc)) return;

                dest = WebUtil.JspURL + "D/D01OT/D01OTDetail.jsp";

            } else if ("delete".equals(jobid)) {
                dest = deleteApproval(req, box, rfc, new DeleteFunction() {
                    public boolean porcess() throws GeneralException {

                        // D01OTRFC deleteRFC = new D01OTRFC();
                        rfc.setDeleteInput(user.empNo, UPMU_TYPE, rfc.getApprovalHeader().AINF_SEQN);

                        RFCReturnEntity returnEntity = rfc.delete(AINF_SEQN, firstData.PERNR);

                        if (!returnEntity.isSuccess()) {
                            throw new GeneralException(returnEntity.MSGTX);
                        }

                        return true;
                    }
                });

                /*
                Vector   AppLineData_vt = new Vector();
                AppLineData  appLine = new AppLineData();
                appLine.APPL_MANDT     = user.clientNo;
                appLine.APPL_BUKRS     = user.companyCode;
                appLine.APPL_PERNR     = firstData.PERNR;
                appLine.APPL_UPMU_TYPE = UPMU_TYPE;
                appLine.APPL_AINF_SEQN = ainf_seqn;
                // 2002.07.25.---------------------------------------------------------------
                // ��û�� ������ ���� ������ ���� �ʿ��� ������ ������ �����´�.
                // ����
                int rowcount = box.getInt("RowCount");
                for( int i = 0; i < rowcount; i++) {
                    AppLineData app = new AppLineData();
                    String      idx     = Integer.toString(i);

                    // ���� �̸����� ������ ������
                    box.copyToEntity(app ,i);

                    AppLineData_vt.addElement(app);
                }
                Logger.debug.println(this, "AppLineData : " + AppLineData_vt.toString());
                 */
                // ��û�� ������ ���� ������ ���� �ʿ��� ������ ������ �����´�.
                // 2002.07.25.---------------------------------------------------------------

                /*
                con             = DBUtil.getTransaction();
                AppLineDB appDB = new AppLineDB(con);

                if( appDB.canUpdate(appLine) ) {
                    appDB.delete(appLine);
                    rfc.delete( ainf_seqn, firstData.PERNR );
                    con.commit();

                    // ��û�� ������ ���� ������.
                    appLine = (AppLineData)AppLineData_vt.get(0);
                    Properties ptMailBody = new Properties();
                    ptMailBody.setProperty("SServer",user.SServer);              // ElOffice ���� ����
                    ptMailBody.setProperty("from_empNo" ,user.empNo);            // �� �߼��� ���
                    ptMailBody.setProperty("to_empNo" ,appLine.APPL_APPU_NUMB);  // �� ������ ���

                    ptMailBody.setProperty("ename" ,phonenumdata.E_ENAME);       // (��)��û�ڸ�
                    ptMailBody.setProperty("empno" ,phonenumdata.E_PERNR);       // (��)��û�� ���

                    ptMailBody.setProperty("UPMU_NAME" ,"�ʰ��ٹ�");             // ���� �̸�
                    ptMailBody.setProperty("AINF_SEQN" ,ainf_seqn);              // ��û�� ����
                    // ��û�� ������ ���� ������.

                    // �� ����
                    StringBuffer sbSubject = new StringBuffer(512);

                    sbSubject.append("[" + ptMailBody.getProperty("UPMU_NAME") + "] ");
                    sbSubject.append( ptMailBody.getProperty("ename") + "���� ��û�� �����ϼ̽��ϴ�.");
                    ptMailBody.setProperty("subject" ,sbSubject.toString());    // �� ���� ����

                    ptMailBody.setProperty("FileName" ,"NoticeMail5.html");

                    MailSendToEloffic   maTe = new MailSendToEloffic(ptMailBody);

                    String msg2 = null;
                    if (!maTe.process()) {
                        msg2 = maTe.getMessage();
                    } // end if

                    try {
                        DraftDocForEloffice ddfe = new DraftDocForEloffice();
                        ElofficInterfaceData eof = ddfe.makeDocForRemove(ainf_seqn ,user.SServer ,ptMailBody.getProperty("UPMU_NAME")
                                ,firstData.PERNR ,appLine.APPL_APPU_NUMB);

                        Vector vcElofficInterfaceData = new Vector();
                        vcElofficInterfaceData.add(eof);
                        Logger.info.println(this ,"^^^^^ D01OTDetailSV Remove</b>[eof:]"+eof.toString());

                        req.setAttribute("vcElofficInterfaceData", vcElofficInterfaceData);
                        dest = WebUtil.JspURL+"common/ElOfficeInterface.jsp";
                    } catch (Exception e) {
                        dest = WebUtil.JspURL+"common/msg.jsp";
                        msg2 = msg2 + "\\n" + " Eloffic ���� ����" ;
                    } // end try

                    String msg = "msg003";
                    String url ;

                    //  ���� ������ ������ �������� �̵��ϱ� ���� ����
                    //  ���� ������ ������ �������� �̵��ϱ� ���� ����
                    req.setAttribute("msg", msg);
                    req.setAttribute("url", url);
                } else {
                    String msg = "msg005";
                    String url = "location.href = '" + WebUtil.ServletURL+"hris.D.D01OT.D01OTDetailSV?AINF_SEQN="+ainf_seqn+"';";
                    req.setAttribute("msg", msg);
                    dest = WebUtil.JspURL+"common/msg.jsp";
                }
                */
            } else {
                throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
            }

            Logger.debug.println(this, " destributed = " + dest);
            printJspPage(req, res, dest);

        } catch (Exception e) {
            throw new GeneralException(e);

        }
    }

    /**
     * RFC ���� ����� ���� data���� EXPORT �Ǵ� TABLES data�� �����Ͽ� ��ȯ
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