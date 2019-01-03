/*                                                                              */
/*   System Name  : e-HR                                                        */
/*   1Depth Name  : HR ������                                                   */
/*   2Depth Name  : ���� �Ϸ� ����                                              */
/*   Program Name : �ʰ� �ٹ� ��û                                              */
/*   Program ID   : G029ApprovalFinishOTSV                                      */
/*   Description  : �ʰ� �ٹ� ��û ���� �Ϸ�                                    */
/*   Note         : ����                                                        */
/*   Creation     : 2005-03-14  �̽���                                          */
/*   Update       :                                                             */
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

import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.RfcDataHandler;
import com.sns.jdf.sap.RfcHandler;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;

import hris.D.D01OT.D01OTData;
import hris.D.D01OT.rfc.D01OTRFC;
import hris.G.ApprovalCancelData;
import hris.G.rfc.ApprovalCancelRFC;
import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalHeader;
import hris.common.approval.ApprovalLineData;
import hris.common.rfc.PersInfoWithNoRFC;

@SuppressWarnings({ "rawtypes", "serial" })
public class D01OTCancelBuildSV extends ApprovalBaseServlet {

    private static String ORG_UPMU_TYPE = "17"; // ���� ����Ÿ��(�ʰ��ٹ�)
    private static String NEW_UPMU_TYPE = "40";

    private String UPMU_TYPE = "40";
    private String UPMU_NAME = "�ʰ��ٹ� �������";

    protected String getUPMU_TYPE() {
        return UPMU_TYPE;
    }

    protected String getUPMU_NAME() {
        return UPMU_NAME;
    }

    protected void performTask(final HttpServletRequest req, HttpServletResponse res) throws GeneralException {

        try {
            final WebUserData user = WebUtil.getSessionUser(req);

            final Box box = WebUtil.getBox(req);
            final String jobid = box.get("jobid", "search");
            final String AINF_SEQN = box.get("AINF_SEQN");
            final String PERNR = getPERNR(box, user); // box.get("PERNR", user.empNo);

            String I_APGUB = (String) req.getAttribute("I_APGUB");  // ��� ���������� �Գ�? '1' : ������ ���� , '2' : ������ ���� , '3' : ����Ϸ� ����

            String dest = WebUtil.JspURL + "D/D01OT/D01OTCancelBuild.jsp";

            if (jobid.equals("search") || jobid.equals("after")) {
                if (jobid.equals("after")) {
                    req.setAttribute("jobid", "create");
                }

                D01OTRFC rfc = new D01OTRFC(user.empNo, I_APGUB, AINF_SEQN);

                Vector vcD01OTData = rfc.getDetail(AINF_SEQN, "");
                Logger.debug.println(this, vcD01OTData);

                // �����ڸ���Ʈ
                // Vector AppLineData_vt = AppUtil.getAppVector( PERNR, UPMU_TYPE );
                // Vector AppLineData_vt = AppUtil.getAppVector( PERNR, "17" );
                // Logger.debug.println(this, "AppLineData_vt : "+ AppLineData_vt.toString());

                // req.setAttribute("AppLineData_vt", AppLineData_vt);

                if (vcD01OTData.size() < 1) {
                    req.setAttribute("msg", "System Error! \n\n ��ȸ�� �׸��� �����ϴ�.");
                    dest = WebUtil.JspURL + "common/caution.jsp";

                } else {
                    // OT(�ʰ� �ٹ�)
                    final D01OTData d01OTData = (D01OTData) vcD01OTData.get(0);
                    req.setAttribute("d01OTData", d01OTData);

                    // ������ ����
                    req.setAttribute("PersInfoData", new PersInfoWithNoRFC().getApproval(d01OTData.PERNR).get(0));

                    // �������, ���� ��� ���� ��ȸ
                    UPMU_TYPE = ORG_UPMU_TYPE;
                    getApprovalInfo(req, PERNR);    // <-- �ݵ�� �߰�
                    UPMU_TYPE = NEW_UPMU_TYPE;

                    ApprovalHeader approvalHeader = (ApprovalHeader) req.getAttribute("approvalHeader");
                    approvalHeader.setUPMU_TYPE(getUPMU_TYPE());
                    req.setAttribute("approvalHeader", approvalHeader);

                    if (!detailApporval(req, res, rfc)) return;

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
                        if (!"1".equals(I_APGUB) || !user.empNo.equals(d01OTData.PERNR)) {
                            final String WORK_DATE = StringUtils.defaultString(d01OTData.WORK_DATE).replaceAll("[^\\d]", "");
                            final String I_DATUM = "X".equals(d01OTData.VTKEN) ? DataUtil.addDays(WORK_DATE, -1, "yyyyMMdd") : WORK_DATE;

                            // ��û�� ��� ���� ��ȸ : S(�繫��) or H(������)
                            Map<String, Object> rfcResultData = RfcHandler.execute("ZGHR_RFC_NTM_GET_EMPGUB", new HashMap<String, Object>() {
                                {
                                    put("I_PERNR", d01OTData.PERNR);
                                    put("I_DATUM", I_DATUM);
                                }
                            });

                            Map<String, Object> EXPORT = getData(rfcResultData, "EXPORT", g.getMessage("MSG.D.D01.0063")); // �Ǳٹ��ð� ��Ȳ ��ȸ�� �ʿ��� ��� ����(�繫�� or ������) �����͸� ��ȸ���� ���Ͽ����ϴ�.
                            final String EMPGUB = ObjectUtils.toString(EXPORT.get("E_EMPGUB"));
                            final String TPGUB = ObjectUtils.toString(EXPORT.get("E_TPGUB"));
                            req.setAttribute("EMPGUB", EMPGUB);
                            req.setAttribute("TPGUB", TPGUB);

                            if ("S".equals(EMPGUB) || ("H".equals(EMPGUB) && !user.empNo.equals(d01OTData.PERNR))) {
                                // ��û�� �Ǳٹ��ð� ��Ȳ ��ȸ
                                rfcResultData = RfcHandler.execute("ZGHR_RFC_NTM_OT_REQ_RW_LIST", new HashMap<String, Object>() {
                                    {
                                        put("I_EMPGUB", EMPGUB);
                                        put("I_PERNR", d01OTData.PERNR);
                                        put("I_DATUM", WORK_DATE);
                                        if ("H".equals(EMPGUB)) put("I_VTKEN", d01OTData.VTKEN);
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

                } // end if

                /***********************************************
                 * Create ��ҿ�ûó��
                 **************************************************/

            } else if (jobid.equals("create")) {

                UPMU_TYPE = NEW_UPMU_TYPE;
                dest = requestApproval(req, box, ApprovalCancelData.class, new RequestFunction<ApprovalCancelData>() {
                    public String porcess(ApprovalCancelData data, Vector<ApprovalLineData> approvalLine) throws GeneralException {

                        ApprovalCancelRFC rfc = new ApprovalCancelRFC();
                        Vector approvalCancelVt = new Vector();
                        box.copyToEntity(data);
                        data.PERNR = PERNR;
                        data.BEGDA = DataUtil.getCurrentDate();
                        data.CANC_REASON = box.get("CANC_REASON");
                        data.ORG_AINF_SEQN = AINF_SEQN;
                        data.ORG_UPMU_TYPE = ORG_UPMU_TYPE;
                        data.AEDTM = DataUtil.getCurrentDate();
                        data.ZPERNR = PERNR;
                        data.UNAME = PERNR;
                        data.I_NTM = "X";
                        approvalCancelVt.addElement(data);

                        // UPMU_TYPE = OLD_UPMU_TYPE;
                        rfc.setRequestInput(user.empNo, UPMU_TYPE);
                        String new_AINF_SEQN = rfc.build(data.PERNR, data.AINF_SEQN, approvalCancelVt, box, req);

                        if (!rfc.getReturn().isSuccess() || new_AINF_SEQN == null) {
                            throw new GeneralException(rfc.getReturn().MSGTX);
                        }
                        ;
                        Logger.debug.print("new_AINF_SEQN:" + new_AINF_SEQN);
                        return new_AINF_SEQN;
                    }
                });

                /*
                            } else if( jobid.equals("create") ) {
                            	NumberGetNextRFC  func              = new NumberGetNextRFC();
                            	ApprovalCancelRFC    rfc               = new ApprovalCancelRFC();
                            	Vector approvalCancelVt = new Vector();
                            	Vector appLineDataVt = new Vector();
                            	ApprovalCancelData data = new ApprovalCancelData();
                            	data.AINF_SEQN = func.getNumberGetNext();
                            	data.PERNR = PERNR;
                            	data.BEGDA = DataUtil.getCurrentDate();
                            	data.CANC_REASON = box.get("CANC_REASON");
                            	data.ORG_AINF_SEQN = AINF_SEQN;
                            	data.ORG_UPMU_TYPE = ORG_UPMU_TYPE;
                            	data.AEDTM = DataUtil.getCurrentDate();
                            	data.ZPERNR = PERNR;
                            	data.UNAME = PERNR;

                            	approvalCancelVt.addElement(data);
                            	int rowcount = box.getInt("RowCount");
                            	for( int i = 0; i < rowcount; i++) {
                            		AppLineData appLine = new AppLineData();
                    //String      idx     = Integer.toString(i);

                    // ������ �ڷ� �Է�(Web)
                    box.copyToEntity(appLine ,i);

                    appLine.APPL_MANDT    = user.clientNo;
                    appLine.APPL_BUKRS     = user.companyCode;
                    appLine.APPL_PERNR     = PERNR;
                    appLine.APPL_BEGDA     = data.BEGDA;
                    appLine.APPL_AINF_SEQN = data.AINF_SEQN;
                    appLine.APPL_UPMU_TYPE = UPMU_TYPE;

                    appLineDataVt.addElement(appLine);
                            	}
                            	Logger.debug.println( this, approvalCancelVt.toString() );
                Logger.debug.println( this, "�������� : "+appLineDataVt.toString() );
                con = DBUtil.getTransaction();
                AppLineDB appDB    = new AppLineDB(con);
                appDB.create(appLineDataVt);

                Vector          vcRet             = new Vector();
                Logger.debug.println(this, "rfc.build before" );
                rfc.build(data.PERNR, data.AINF_SEQN,  approvalCancelVt, box, req);
                String E_RETURN    = (String)vcRet.get(0);
                String E_MESSAGE = (String)vcRet.get(1);

                Logger.debug.println(this, "E_RETURN : " +E_RETURN );
                Logger.debug.println(this, "E_MESSAGE : " +E_MESSAGE );
                if ( E_RETURN.equals("") ) {
                	con.commit();
                //                	 ���� ������ ��� ,
                    AppLineData appLine = (AppLineData)appLineDataVt.get(0);

                    Properties ptMailBody = new Properties();
                    ptMailBody.setProperty("SServer",user.SServer);                 // ElOffice ���� ����
                    ptMailBody.setProperty("from_empNo" ,user.empNo);               // �� �߼��� ���
                    ptMailBody.setProperty("to_empNo", appLine.APPL_APPU_NUMB);     // �� ������ ���

                    ptMailBody.setProperty("ename" ,user.ename);          // (��)��û�ڸ�
                    ptMailBody.setProperty("empno" ,user.empNo);          // (��)��û�� ���

                    ptMailBody.setProperty("UPMU_NAME" ,UPMU_NAME);                 // ���� �̸�
                    ptMailBody.setProperty("AINF_SEQN", data.AINF_SEQN);
                    // ��û�� ����
                    // �� ����
                    StringBuffer sbSubject = new StringBuffer(512);

                    sbSubject.append("[" + ptMailBody.getProperty("UPMU_NAME") + "] ");
                    sbSubject.append(ptMailBody.getProperty("ename") +"���� ��û�ϼ̽��ϴ�.");

                    ptMailBody.setProperty("subject" ,sbSubject.toString());
                    ptMailBody.setProperty("FileName" ,"MbNoticeMailBuild.html");

                    String msg = "msg001";
                    String msg2 = "";

                    MailSendToEloffic  maTe = new MailSendToEloffic(ptMailBody);

                    if (!maTe.process()) {
                        msg2 = maTe.getMessage();
                    } // end if

                    try {
                        DraftDocForEloffice ddfe = new DraftDocForEloffice();

                        ElofficInterfaceData eof = ddfe.makeDocContents(data.AINF_SEQN ,user.SServer,ptMailBody.getProperty("UPMU_NAME"));

                        Vector vcElofficInterfaceData = new Vector();
                        vcElofficInterfaceData.add(eof);
                        //req.setAttribute("vcElofficInterfaceData", vcElofficInterfaceData);
                        //dest = WebUtil.JspURL+"common/ElOfficeInterface.jsp";
                        //���հ��� ���������� ���� ������������ ������  2012.11.07
                        try {
                        	SendToESB esb = new SendToESB();
                        	String esbmsg = esb.process(vcElofficInterfaceData );
                            Logger.debug.println(this ,"[esbmsg]  :"+esbmsg);
                        	req.setAttribute("message", esbmsg);
                        	dest = WebUtil.JspURL+"common/EsbResult.jsp";
                        } catch (Exception e) {
                        	e.printStackTrace();
                           dest = WebUtil.JspURL+"common/msg.jsp";
                           msg2 = msg2 + "\\n" + " Eloffic ���� ����" ;
                       }
                    } catch (Exception e) {
                        dest = WebUtil.JspURL+"common/msg.jsp";
                        //msg2 = msg2 + "\\n" + " Eloffic ���� ����" ;
                        msg = msg + "\\n" + " Eloffic ���� ����" ;
                    } // end try

                    String url = "location.href = \'" + WebUtil.ServletURL+"hris.D.D01OT.D01OTCancelBuildSV?AINF_SEQN="+AINF_SEQN+"&jobid=after\'";
                    req.setAttribute("msg", msg);
                    req.setAttribute("msg2", msg2);
                    req.setAttribute("url", url);
                } else {
                	con.rollback();
                	String msg = E_MESSAGE;
                	req.setAttribute("", jobid);
                    req.setAttribute("message", msg);
                    dest = WebUtil.ServletURL+"hris.D.D01OT.D01OTCancelBuildSV?AINF_SEQN="+AINF_SEQN+"';";
                }
                */
            } else {
                throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
            } // end if

            Logger.debug.println(this, " destributed = " + dest);
            printJspPage(req, res, dest);

        } catch (Exception e) {
            Logger.err.println(DataUtil.getStackTrace(e));
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