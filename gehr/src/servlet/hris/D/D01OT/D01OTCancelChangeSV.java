/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : ����Ϸ� ����                                               */
/*   2Depth Name  :                                                             */
/*   Program Name : �ް� ����Ϸ�                                               */
/*   Program ID   : F02DeptPositionDutySV                                       */
/*   Description  : �ް� ����Ϸ� ��ȸ�� ���� ����                            */
/*   Note         : ����                                                        */
/*   Creation     : 2005-03-10 �����                                           */
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

import com.common.RFCReturnEntity;
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
import hris.common.PersInfoData;
import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalHeader;
import hris.common.approval.ApprovalLineData;
import hris.common.rfc.PersInfoWithNoRFC;
import hris.common.util.AppUtil;

@SuppressWarnings({ "rawtypes", "serial" })
public class D01OTCancelChangeSV extends ApprovalBaseServlet {

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

            String dest = WebUtil.JspURL + "D/D01OT/D01OTCancelChange.jsp";

            final Box box = WebUtil.getBox(req);
            final String jobid = box.get("jobid", "first");
            final String AINF_SEQN = box.get("AINF_SEQN");
            final String I_APGUB = (String) req.getAttribute("I_APGUB") == null ? box.get("I_APGUB") : (String) req.getAttribute("I_APGUB");  // ��� ���������� �Գ�? '1' : ������ ���� , '2' : ������ ���� , '3' : ����Ϸ� ����
            req.setAttribute("I_APGUB", I_APGUB);	//WorkTime52 �߰�

            // �ʰ��ٹ����������ȸ
            final ApprovalCancelRFC appRfc = new ApprovalCancelRFC();
            appRfc.setDetailInput(user.empNo, I_APGUB, AINF_SEQN);
            Vector appCancelVt = appRfc.get(user.empNo, AINF_SEQN);
            final String PERNR = appRfc.getApprovalHeader().PERNR; // box.get("PERNR", user.empNo);

            req.setAttribute("isUpdate", false); // ��ȸ����

            if (jobid.equals("changeMode")) {
                req.setAttribute("isUpdate", true); // ��������
            }

            if (jobid.equals("first") || jobid.equals("changeMode")) {

                if (appCancelVt.size() > 0) {
                    ApprovalCancelData appData = (ApprovalCancelData) appCancelVt.get(0);
                    // ������ �ʰ��ٹ���ȸ
                    String ORG_AINF_SEQN = appData.ORG_AINF_SEQN;
                    // �ʰ��ٹ�
                    D01OTRFC otRfc = new D01OTRFC();
                    otRfc.setDetailInput(user.empNo, I_APGUB, ORG_AINF_SEQN);
                    Vector d01OTData_vt = otRfc.getDetail(ORG_AINF_SEQN, PERNR);

                    if (!detailApporval(req, res, appRfc))
                        return; // ** ����: �ݵ�� ��Ұ����ȣ�� ������� **/

                    if (d01OTData_vt.size() < 1) {
                        String msg = "System Error! \n\n ��ȸ�� �׸��� �����ϴ�.";
                        req.setAttribute("msg", msg);
                        dest = WebUtil.JspURL + "common/caution.jsp";
                    } else {

                        // ORG������ ����
                        Vector orgVcAppLineData = AppUtil.getAppChangeVt(ORG_AINF_SEQN);
                        // ���� ����.
                        PersInfoWithNoRFC piRfc = new PersInfoWithNoRFC();
                        PersInfoData pid = (PersInfoData) piRfc.getApproval(PERNR).get(0);

                        // ����������
                        final D01OTData d01OTData = (D01OTData) d01OTData_vt.get(0);

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

                        req.setAttribute("d01OTData", d01OTData);
                        req.setAttribute("PersInfoData", pid);
                        req.setAttribute("orgVcAppLineData", orgVcAppLineData);
                        req.setAttribute("appCancelVt", appCancelVt);
                    } // end if

                }

            } else if (jobid.equals("change")) {

                dest = changeApproval(req, box, ApprovalCancelData.class, appRfc, new ChangeFunction<ApprovalCancelData>() {
                    public String porcess(ApprovalCancelData cngData, ApprovalHeader approvalHeader, Vector<ApprovalLineData> approvalLineDatas) throws GeneralException {

                        // ����
                        box.copyToEntity(cngData);
                        cngData.AINF_SEQN = AINF_SEQN;
                        cngData.PERNR = PERNR;
                        cngData.BEGDA = box.get("BEGDA");
                        cngData.ORG_AINF_SEQN = box.get("ORG_AINF_SEQN");
                        cngData.ORG_BEGDA = box.get("ORG_BEGDA");
                        cngData.ORG_UPMU_TYPE = box.get("ORG_UPMU_TYPE");
                        cngData.AEDTM = DataUtil.getCurrentDate();
                        cngData.ZPERNR = PERNR;
                        cngData.UNAME = PERNR;
                        // �������μ����� ���� �߰�����
                        cngData.APPL_TO = box.get("ORG_BEGDA");
                        cngData.APPL_FROM = box.get("ORG_BEGDA");
                        cngData.APPL_REAS = box.get("CANC_REASON");

                        cngData.CANC_REASON = box.get("CANC_REASON");
                        Vector changeVt = new Vector();
                        changeVt.add(cngData);
                        appRfc.setChangeInput(user.empNo, UPMU_TYPE, approvalHeader.AINF_SEQN);
                        appRfc.change(PERNR, AINF_SEQN, changeVt, box, req);

                        if (!appRfc.getReturn().isSuccess()) {
                            req.setAttribute("msg", appRfc.getReturn().MSGTX);   // ���� �޼��� ó�� - �ӽ�
                            return null;
                        }
                        return AINF_SEQN;

                    }
                });
                /*
                  	//����
                  	ApprovalCancelData cngData = new ApprovalCancelData();
                  	cngData.AINF_SEQN = AINF_SEQN;
                  	cngData.PERNR = PERNR;
                  	cngData.BEGDA = box.get("BEGDA");
                  	cngData.ORG_AINF_SEQN = box.get("ORG_AINF_SEQN");
                  	cngData.ORG_BEGDA = box.get("ORG_BEGDA");
                  	cngData.ORG_UPMU_TYPE = box.get("ORG_UPMU_TYPE");
                  	cngData.AEDTM = DataUtil.getCurrentDate();
                  	cngData.ZPERNR = PERNR;
                  	cngData.UNAME = PERNR;

                  	cngData.CANC_REASON = box.get("CANC_REASON");
                  	Vector changeVt = new Vector();
                  	changeVt.add(cngData);

                  	int rowcount = box.getInt("RowCount");
                for( int i = 0; i < rowcount; i++) {
                    AppLineData appLine = new AppLineData();
                    String      idx     = Integer.toString(i);
                    appLine.APPL_MANDT     = user.clientNo;
                    appLine.APPL_BUKRS     = user.companyCode;
                    appLine.APPL_AINF_SEQN = AINF_SEQN;
                    appLine.APPL_UPMU_FLAG = box.get("APPL_UPMU_FLAG"+idx);
                    appLine.APPL_UPMU_TYPE = UPMU_TYPE;
                    appLine.APPL_APPR_TYPE = box.get("APPL_APPR_TYPE"+idx);
                    appLine.APPL_APPU_TYPE = box.get("APPL_APPU_TYPE"+idx);
                    appLine.APPL_APPR_SEQN = box.get("APPL_APPR_SEQN"+idx);
                    appLine.APPL_OTYPE     = box.get("APPL_OTYPE"+idx);
                    appLine.APPL_OBJID     = box.get("APPL_OBJID"+idx);
                    appLine.APPL_APPU_NUMB = box.get("APPL_APPU_NUMB"+idx);
                    //**********���� ���� (20050223:�����)**********
                    appLine.APPL_PERNR     = PERNR;
                    appLine.APPL_BEGDA     = cngData.BEGDA;
                    //**********���� ��.****************************
                    appLine.APPL_BEGDA = appLine.APPL_BEGDA.replaceAll("-","");
                    appLineVt.addElement(appLine);
                }
                Logger.debug.println( this, cngData.toString() );
                Logger.debug.println( this, "�������� : "+appLineVt.toString() );

                con = DBUtil.getTransaction();
                AppLineDB appDB    = new AppLineDB(con);
                String msg  = null;
                String msg2 = null;
                if( appDB.canUpdate((AppLineData)appLineVt.get(0)) ) {
                	Logger.debug.println( this, " D03VocationCancel appDB.change :appLineVt "+appLineVt.toString() );
                    // ���� ������ ����Ʈ
                    Vector orgAppLineData_vt = AppUtil.getAppChangeVt(AINF_SEQN);
                    appDB.change(appLineVt);
                    Vector          ret             = new Vector();
                   appRfc.change(PERNR, AINF_SEQN, changeVt, box, req);
                    Logger.debug.println( this, " D03VocationCancel appRfc.change :changeVt "+changeVt.toString() );
                    //C20111025_86242 üũ�޼��� �߰�
                    String E_RETURN    = (String)ret.get(0);
                    String E_MESSAGE = (String)ret.get(1);

                    Logger.debug.println(this, "E_RETURN : " +E_RETURN );
                    Logger.debug.println(this, "E_MESSAGE : " +E_MESSAGE );

                    if ( E_RETURN.equals("") ) {
                        con.commit();
                        msg = "msg002";
                        AppLineData oldAppLine = (AppLineData) orgAppLineData_vt.get(0);
                        AppLineData newAppLine = (AppLineData) appLineVt.get(0);
                       Logger.debug.println(this ,oldAppLine);
                        Logger.debug.println(this ,newAppLine);

                        if (!newAppLine.APPL_APPU_NUMB.equals(oldAppLine.APPL_PERNR)) {
                            // �̸��� ������
                            Properties ptMailBody = new Properties();
                            ptMailBody.setProperty("SServer",user.SServer);                 // ElOffice ���� ����
                            ptMailBody.setProperty("from_empNo" ,user.empNo);               // �� �߼��� ���
                            ptMailBody.setProperty("to_empNo" ,oldAppLine.APPL_PERNR);      // �� ������ ���
                            ptMailBody.setProperty("ename" ,user.ename);          // (��)��û�ڸ�
                            ptMailBody.setProperty("empno" ,user.empNo);          // (��)��û�� ���
                            ptMailBody.setProperty("UPMU_NAME" , UPMU_NAME);                    // ���� �̸�
                            ptMailBody.setProperty("AINF_SEQN" ,AINF_SEQN);                 // ��û�� ����

                            //                          �� ����
                            StringBuffer sbSubject = new StringBuffer(512);

                            sbSubject.append("[" + ptMailBody.getProperty("UPMU_NAME") + "] ");
                            sbSubject.append( ptMailBody.getProperty("ename") + "���� ��û�� �����ϼ̽��ϴ�.");
                            ptMailBody.setProperty("subject" ,sbSubject.toString());

                            ptMailBody.setProperty("FileName" ,"NoticeMail5.html");

                            MailSendToEloffic   maTe = new MailSendToEloffic(ptMailBody);
                            // ���� ������ �� ����
                            if (!maTe.process()) {
                                msg2 = msg2 + " ���� " + maTe.getMessage();
                            } // end if

                            // �� ����
                            sbSubject = new StringBuffer(512);
                            sbSubject.append("[" + ptMailBody.getProperty("UPMU_NAME") + "] ");
                            sbSubject.append(ptMailBody.getProperty("ename") +"���� ��û�ϼ̽��ϴ�.");

                            ptMailBody.setProperty("subject" ,sbSubject.toString());
                            ptMailBody.remove("FileName");
                            ptMailBody.setProperty("to_empNo" ,newAppLine.APPL_APPU_NUMB);

                            maTe = new MailSendToEloffic(ptMailBody);
                            // �ű� ������ �� ����
                            if (!maTe.process()) {
                                msg2 = msg2 +" \\n ��û " + maTe.getMessage();
                            } // end if

                            // ElOffice �������̽�
                            try {
                                DraftDocForEloffice ddfe = new DraftDocForEloffice();
                                ElofficInterfaceData eof = ddfe.makeDocForChange(AINF_SEQN ,user.SServer , PERNR, ptMailBody.getProperty("UPMU_NAME") , oldAppLine.APPL_PERNR);

                                Logger.debug.println(this, "makeDocForChange AINF_SEQN:"+AINF_SEQN+"oldAppLine.APPL_PERNR = " + oldAppLine.APPL_PERNR);
                                Vector vcElofficInterfaceData = new Vector();
                                vcElofficInterfaceData.add(eof);

                                ElofficInterfaceData eofD = ddfe.makeDocContents(AINF_SEQN ,user.SServer,ptMailBody.getProperty("UPMU_NAME"));
                                vcElofficInterfaceData.add(eofD);
                //                              ���հ��� ���������� ���� ������������ ������  2012.11.07
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
                                msg2 = msg2 + "\\n" + " Eloffic ���� ����" ;
                            } // end try
                        } else {
                            msg = "msg002";
                            dest = WebUtil.JspURL+"common/msg.jsp";
                        } // end if

                    } else {
                    	con.rollback();
                        msg = E_MESSAGE;
                        dest = WebUtil.ServletURL+"hris.D.D01OT.D01OTCancelChangeSV?AINF_SEQN="+AINF_SEQN+"&msg="+msg+"&RequestPageName=" + RequestPageName + "';";
                 }
                } else {
                    msg = "msg005";
                    dest = WebUtil.JspURL+"common/msg.jsp";
                } // end if

                String url = "location.href = '" + WebUtil.ServletURL+"hris.D.D01OT.D01OTCancelChangeSV?AINF_SEQN="+AINF_SEQN+
                "&RequestPageName=" + RequestPageName + "';";
                req.setAttribute("msg", msg);
                req.setAttribute("msg2", msg2);
                req.setAttribute("url", url);
                */
            } else if (jobid.equals("delete")) {

                dest = deleteApproval(req, box, appRfc, new DeleteFunction() {
                    public boolean porcess() throws GeneralException {

                        // D01OTRFC deleteRFC = new D01OTRFC();
                        appRfc.setDeleteInput(user.empNo, UPMU_TYPE, appRfc.getApprovalHeader().AINF_SEQN);

                        RFCReturnEntity returnEntity = appRfc.delete(PERNR, AINF_SEQN);

                        if (!returnEntity.isSuccess()) {
                            throw new GeneralException(returnEntity.MSGTX);
                        }

                        return true;
                    }
                });
                /*
                //              ��û�� ������ ���� ������ ���� �ʿ��� ������ ������ �����´�.
                //              ����
                int rowcount = box.getInt("RowCount");
                for( int i = 0; i < rowcount; i++) {
                    AppLineData app = new AppLineData();
                    String      idx     = Integer.toString(i);

                    app.APPL_APPR_SEQN = box.get("APPL_APPR_SEQN"+idx);
                    app.APPL_APPU_TYPE = box.get("APPL_APPU_TYPE"+idx);
                    app.APPL_APPU_NUMB = box.get("APPL_APPU_NUMB"+idx);

                    appLineVt.addElement(app);
                }
                Logger.debug.println(this, "AppLineData : " + appLineVt.toString());
                //              ��û�� ������ ���� ������ ���� �ʿ��� ������ ������ �����´�.
                con             = DBUtil.getTransaction();
                AppLineDB appDB = new AppLineDB(con);
                //              �������� ����..
                AppLineData  appLine = new AppLineData();
                appLine.APPL_MANDT     = user.clientNo;
                appLine.APPL_BUKRS     = user.companyCode;
                appLine.APPL_PERNR     = PERNR;
                appLine.APPL_UPMU_TYPE = UPMU_TYPE;
                appLine.APPL_AINF_SEQN = box.get("AINF_SEQN");

                if( appDB.canUpdate(appLine) ) {
                    appDB.delete(appLine);
                //                  ����
                            		appRfc.delete(PERNR, AINF_SEQN);
                    con.commit();

                    //**********���� ���� (20050223:�����)**********
                    // ��û�� ������ ���� ������.
                    appLine = (AppLineData)appLineVt.get(0);

                    //������ ����� �� ������ ,ElOffice ���� ���̽�
                    Properties ptMailBody = new Properties();

                    ptMailBody.setProperty("SServer",user.SServer);                 // ElOffice ���� ����
                    ptMailBody.setProperty("from_empNo" ,user.empNo);               // �� �߼��� ���
                    ptMailBody.setProperty("to_empNo" ,appLine.APPL_APPU_NUMB);     // �� ������ ���
                    ptMailBody.setProperty("ename" ,user.ename);          // (��)��û�ڸ�
                    ptMailBody.setProperty("empno" ,user.empNo);          // (��)��û�� ���
                    ptMailBody.setProperty("UPMU_NAME" , UPMU_NAME);                    // ���� �̸�
                    ptMailBody.setProperty("AINF_SEQN" ,AINF_SEQN);                 // ��û�� ����

                    //�� ����
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
                        ElofficInterfaceData eof = ddfe.makeDocForRemove(AINF_SEQN ,user.SServer ,ptMailBody.getProperty("UPMU_NAME")
                                ,PERNR ,appLine.APPL_APPU_NUMB);

                        Vector vcElofficInterfaceData = new Vector();
                        vcElofficInterfaceData.add(eof);
                //                      ���հ��� ���������� ���� ������������ ������  2012.11.07
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
                        msg2 = msg2 + "\\n" + " Eloffic ���� ����" ;
                    } // end try

                    String msg = "msg003";
                    String url ;

                    //  ���� ������ ������ �������� �̵��ϱ� ���� ����
                    if(RequestPageName != null &&  !RequestPageName.equals("") ){
                        url = "location.href = '" + RequestPageName.replace('|','&') + "';";
                    } else {
                        url = "location.href = '" + WebUtil.ServletURL+"hris.D.D01OT.D01OTCancelChangeSV?AINF_SEQN="+AINF_SEQN+"&RequestPageName=" + RequestPageName + "';";
                    } // end if
                    //**********���� ��.****************************

                    req.setAttribute("msg", msg);
                    req.setAttribute("url", url);
                } else {
                    String msg = "msg005";
                    String url = "location.href = '" + WebUtil.ServletURL+"hris.D.D01OT.D01OTCancelChangeSV?AINF_SEQN="+AINF_SEQN+"&RequestPageName=" + RequestPageName + "';";
                    req.setAttribute("msg", msg);
                    req.setAttribute("url", url);
                    dest = WebUtil.JspURL+"common/msg.jsp";
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
        } finally {

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