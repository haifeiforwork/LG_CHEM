/********************************************************************************/
/*                                                                              */
/*   System Name  :  e-HR                                                       */
/*   1Depth Name  : HR ������                                                   */
/*   2Depth Name  : ���� �ؾ��� ����                                            */
/*   Program Name : �ʰ� �ٹ� ��û                                              */
/*   Program ID   : G028ApprovalOTSV                                            */
/*   Description  : �ʰ� �ٹ� ��û�μ���  ����/�ݷ�                             */
/*   Note         : ����                                                        */
/*   Creation     : 2005-03-14  �̽���                                                                */
/*   Update       : 2006-01-18  @v1.1 ���ڰ��翬�����з� ���� ���Ϲ߼۰� ��ġ����                     */
/*                  2017-04-03  ������  [CSR ID:3340999]  �븸 ������±Ⱓ���� 46�ð� ����           */
/*                  2017-04-17  ������  [CSR ID:3303691] ����Ⱓ���� �����߰�                        */
/*					2018-02-12  rdcamel [CSR ID:3608185] e-HR �ʰ��ٹ� ���Ľ�û ���� �ý��� ���� ��û */
/*                  2017-04-17  [WorkTime52] I_NTM ���� �߰�                                          */
/********************************************************************************/
package servlet.hris.G;

import com.common.constant.Area;
import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;
import hris.D.D01OT.D01OTData;
import hris.D.D01OT.rfc.D01OTCheckGlobalRFC;
import hris.D.D01OT.rfc.D01OTRFC;
import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalHeader;
import hris.common.approval.ApprovalLineData;
import servlet.hris.D.D01OT.D01OTBuildGlobalSV;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.Vector;


public class G028ApprovalOTSV extends ApprovalBaseServlet
{
    private String UPMU_TYPE ="17";
    private String UPMU_NAME = "�ʰ��ٹ���û";
    private String OT_AFTER = "";//[CSR ID:3608185]���� ���� �߰�

    protected String getUPMU_TYPE() {
        if(g.getSapType().isLocal())  return "17";
        else return  "01";   }

    protected String getUPMU_NAME() {
        if(g.getSapType().isLocal())  return "�ʰ��ٹ�"+OT_AFTER+"��û";
        else return  "OverTime";
    }

    protected void performTask(final HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        try{
            HttpSession session = req.getSession(false);
            final WebUserData user = WebUtil.getSessionUser(req);

            /* �ؿ� ���� Ÿ��*/
/*           if(user.area != Area.KR) {
               UPMU_NAME = "OverTime";
           } else {
               UPMU_NAME = "�ʰ��ٹ���û";
           }
           getUPMU_NAME();//[CSR ID:3608185]
*/
            D01OTData   d01OTData;

            String dest  = "";
            String jobid = "";
            String bankflag  = "01";

            final Box box = WebUtil.getBox(req);

            String  AINF_SEQN  = box.get("AINF_SEQN");

            // ó�� �� ���� �� ������
            String RequestPageName = box.get("RequestPageName");

            req.setAttribute("RequestPageName", RequestPageName);

            jobid =box.get("jobid", "search");

            final D01OTRFC rfc           = new D01OTRFC();
            rfc.setDetailInput(user.empNo, "1", AINF_SEQN);
            final D01OTBuildGlobalSV d01sv = new D01OTBuildGlobalSV();
            final Vector vcD01OTData = rfc.getDetail( AINF_SEQN, "");
            d01OTData      = (D01OTData)vcD01OTData.get(0);
            d01OTData = d01sv.doWithData(d01OTData);
            Logger.debug.println(this, "------------");
            Logger.debug.println(this, vcD01OTData);

//            String tableName = "T_ZHRA024T";

            /* �ؿ� ���� Ÿ��
             *	tableName�� null�� ó���ϸ� SAP���� �˾Ƽ� ó����.(������ table�� ã�Ƽ� ó��)
             */
/*           if(user.area != Area.KR) {
               UPMU_TYPE = "01"; // ���� ����Ÿ��
               UPMU_NAME = "Overtime";
//               tableName = "T_ZHR0045T";

           } else {
               UPMU_TYPE = "17";
               UPMU_NAME = "�ʰ��ٹ���û";
//               tableName = "T_ZHRA022T";
//               tableName = "T_ZHR0045T";
           }
*/           
            /* ���� �� */
            if("A".equals(jobid)) {
                /* ������ ���� �� */
                dest = accept(req, box, null, d01OTData, rfc, new ApprovalFunction<D01OTData>() {
                    public boolean porcess(D01OTData inputData, ApprovalHeader approvalHeader, Vector<ApprovalLineData> approvalLineDatas)
                    		throws GeneralException {

                        /* ������ ���� ���� */
                        box.copyToEntity(inputData);  // ����ڰ� �Է��� ����Ÿ�� ������Ʈ
                        inputData = d01sv.doWithData(inputData); // time formatting (ksc)2016/12/21
                        inputData.UNAME = user.empNo;
                        inputData.AEDTM = DataUtil.getCurrentDate();
                        inputData.I_NTM = "X"; // [WorkTime52]
                        D01OTCheckGlobalRFC d01OTCheckGlobalRFC = new D01OTCheckGlobalRFC();

                        // [CSR ID:3608185] e-HR �ʰ��ٹ� ���Ľ�û ���� �ý��� ���� ��û
                        OTAfterCheck(inputData);
                        Logger.debug.println(this, getUPMU_NAME());
                        // [CSR ID:3608185] e-HR �ʰ��ٹ� ���Ľ�û ���� �ý��� ���� ��û

                        // 2017-04-03 ������ [CSR ID:3340999] �븸 ������±Ⱓ���� 46�ð� ���� START
                        if (!g.getSapType().isLocal()) {
                            d01OTCheckGlobalRFC.checkOvertimeTp46Hours(req, inputData.PERNR, "A", inputData.AINF_SEQN, inputData.WORK_DATE, inputData.STDAZ);
                            if ("E".equals(d01OTCheckGlobalRFC.getReturn().MSGTY)) {
                                throw new GeneralException(g.getMessage("MSG.D.D01.0109"));// The Approved overtime hours of this payroll period are over 46 hours.
                            }
                            // [CSR ID:3359686] ���� ���� 5������ START
                            d01OTCheckGlobalRFC.checkApprovalPeriod(req, inputData.PERNR, "A", inputData.WORK_DATE, UPMU_TYPE, "");
                            if ("E".equals(d01OTCheckGlobalRFC.getReturn().MSGTY)) {
                                throw new GeneralException(g.getMessage("MSG.D.D01.0108")); // The request date has passed 5 working days. You could not approve it.
                            }
                            // [CSR ID:3359686] ���� ���� 5������ END

                        }
                        // 2017-04-03 ������ [CSR ID:3340999] �븸 ������±Ⱓ���� 46�ð� ���� END

                        return true;
                    }
                });

            /* �ݷ��� */
            } else if("R".equals(jobid)) {
                dest = reject(req, box, null, vcD01OTData, rfc, null);
            } else if("C".equals(jobid)) {
                dest = cancel(req, box, null, vcD01OTData, rfc, null);
/*

            if( jobid.equals("search") ) {

                D01OTRFC rfc           = new D01OTRFC();

                vcD01OTData = rfc.getDetail( AINF_SEQN, "");
                Logger.debug.println(this, vcD01OTData);

                if( vcD01OTData.size() < 1 ){
                    String msg = "System Error! \n\n ��ȸ�� �׸��� �����ϴ�.";
                    req.setAttribute("msg", msg);
                    dest = WebUtil.JspURL+"common/caution.jsp";
                }else{
                    // OT(�ʰ� �ٹ�)
                    d01OTData      = (D01OTData)vcD01OTData.get(0);
                    // ������ ����
                    vcAppLineData = AppUtil.getAppChangeVt(AINF_SEQN);

                    PersInfoWithNoRFC   piRfc   = new PersInfoWithNoRFC();
                    PersInfoData        pid     = (PersInfoData) piRfc.getApproval(d01OTData.PERNR).get(0);
                    req.setAttribute("PersInfoData" ,pid );

                    req.setAttribute("d01OTData", d01OTData);
                    req.setAttribute("vcAppLineData" , vcAppLineData);

                    dest = WebUtil.JspURL+"G/G028ApprovalOT.jsp";
                } // end if
            } else if( jobid.equals("save") ) {

                d01OTData = new D01OTData();
                vcD01OTData = new Vector();

                vcAppLineData       = new Vector();

                AppLineData         tempAppLine;

                Vector vcTempAppLineData   = new Vector();
                AppLineData    appLine     = new AppLineData();

                // OT(�ʰ��ٹ�) ���� �ڷ�
                box.copyToEntity(d01OTData);

                // ������ ����
                int nRowCount = Integer.parseInt(box.getString("RowCount"));

                String APPU_TYPE   =  box.get("APPU_TYPE");
                String APPR_SEQN   =  box.get("APPR_SEQN");
                String currApprNumb = "";  //ESB ���� ����

                for (int i = 0; i < nRowCount; i++) {
                    tempAppLine = new AppLineData();
                    box.copyToEntity(tempAppLine ,i);
                    vcTempAppLineData.add(tempAppLine);
                    if (tempAppLine.APPL_APPR_STAT.equals("�̰�") && currApprNumb.equals("")){
                    	currApprNumb = tempAppLine.APPL_APPU_NUMB;
                    }
                    if (tempAppLine.APPL_APPU_TYPE.equals(APPU_TYPE) && tempAppLine.APPL_APPR_SEQN.equals(APPR_SEQN)) {
                        appLine.APPL_BUKRS = box.getString("BUKRS");
                        appLine.APPL_PERNR = box.getString("PERNR");
                        appLine.APPL_BEGDA = box.getString("BEGDA");
                        appLine.APPL_AINF_SEQN = box.getString("AINF_SEQN");
                        appLine.APPL_APPU_TYPE = APPU_TYPE;
                        appLine.APPL_APPR_SEQN = APPR_SEQN;
                        appLine.APPL_APPU_NUMB = user.empNo;
                        appLine.APPL_APPR_STAT = box.getString("APPR_STAT");
                        appLine.APPL_BIGO_TEXT = box.getString("BIGO_TEXT");
                        appLine.APPL_APPR_DATE = DataUtil.getCurrentDate();
                    } // end if
                } // end for

                Logger.debug.println(this ,vcTempAppLineData);
                Logger.debug.println(this ,appLine);
                vcAppLineData.add(appLine);


                G001ApprovalProcessRFC  Apr = new G001ApprovalProcessRFC();
                Vector vcRet = Apr.setApprovalStatutsList(vcAppLineData );

                Logger.debug.println(this ,vcRet);
                ApprovalReturnState ars = (ApprovalReturnState) vcRet.get(0);

                PersonInfoRFC numfunc = new PersonInfoRFC();
                PersonData phonenumdata;
                phonenumdata    =   (PersonData)numfunc.getPersonInfo(d01OTData.PERNR);

                Properties ptMailBody = new Properties();
                ptMailBody.setProperty("SServer",user.SServer);                 // ElOffice ���� ����
                ptMailBody.setProperty("from_empNo" ,user.empNo);               // �� �߼��� ���

                ptMailBody.setProperty("ename" ,phonenumdata.E_ENAME);          // (��)��û�ڸ�
                ptMailBody.setProperty("empno" ,phonenumdata.E_PERNR);          // (��)��û�� ���

                ptMailBody.setProperty("UPMU_NAME" ,"�ʰ� �ٹ�");               // ���� �̸�
                ptMailBody.setProperty("AINF_SEQN" ,AINF_SEQN);                 // ��û�� ����

                // �� ����
                StringBuffer sbSubject = new StringBuffer(512);

                sbSubject.append("[" + ptMailBody.getProperty("UPMU_NAME") + "] ");
                sbSubject.append(user.ename  + "���� ");

                String msg;
                String msg2 = "";
                String to_empNo = d01OTData.PERNR;

                if (ars.E_RETURN.equals("S")) {
                    if (appLine.APPL_APPR_STAT.equals("A")) {
                        msg = "msg009";
                        for (int i = 0; i < vcTempAppLineData.size(); i++) {
                            tempAppLine = (AppLineData) vcTempAppLineData.get(i);
                            if (tempAppLine.APPL_APPU_TYPE.equals(APPU_TYPE) && tempAppLine.APPL_APPR_SEQN.equals(APPR_SEQN)) {
                                if (i == vcTempAppLineData.size() -1) {
                                    // ������ ������
                                    ptMailBody.setProperty("FileName" ,"MbNoticeMailApp.html");
                                    sbSubject.append(ptMailBody.getProperty("UPMU_NAME") +"�� ���� �ϼ̽��ϴ�.");
                                } else {
                                    ptMailBody.setProperty("FileName" ,"MbNoticeMailBuild.html");
                                    // ���� ������
                                    tempAppLine = (AppLineData) vcTempAppLineData.get(i+1);
                                    to_empNo = tempAppLine.APPL_APPU_NUMB;
                                    sbSubject.append("���縦 ��û �ϼ̽��ϴ�.");
                                    break;
                                } // end if
                            }// end if
                        } // end for
                    } else {
                        msg = "msg010";
                        if (APPU_TYPE.equals("02") && Integer.parseInt(APPR_SEQN) > 1) {
                            for (int i = 0; i < vcTempAppLineData.size(); i++) {
                                tempAppLine = (AppLineData) vcTempAppLineData.get(i);
                                if (tempAppLine.APPL_APPU_TYPE.equals("02") && tempAppLine.APPL_APPR_SEQN.equals("01")) {
                                    tempAppLine = (AppLineData) vcTempAppLineData.get(i);
                                    to_empNo = tempAppLine.APPL_APPU_NUMB;
                                } // end if
                            } // end for
                        } // end if
                        ptMailBody.setProperty("FileName" ,"MbNoticeMailRej.html");
                        sbSubject.append(ptMailBody.getProperty("UPMU_NAME") +"�� �ݷ� �ϼ̽��ϴ�.");
                    } // end if

                    ptMailBody.setProperty("to_empNo" ,to_empNo);                   // �� ������ ���
                    ptMailBody.setProperty("subject" ,sbSubject.toString());        // �� ���� ����
                    MailSendToEloffic   maTe = new MailSendToEloffic(ptMailBody);

                    try {
                        DraftDocForEloffice ddfe = new DraftDocForEloffice();
                        ElofficInterfaceData eof;
                        Vector vcElofficInterfaceData = new Vector();
                       	//ESB ���� ����
                    	if (!currApprNumb.equals(user.empNo)) {
                        	//����÷��� ������ ���� �׽�ũ�� ������ �ִ� �����ڰ� �����Ҷ� ó��:���� ���ڰ��翡 ���ִ� DATA�� ������ �ٽ� ó��
                        	ElofficInterfaceData eofD = ddfe.makeDocForDelete(AINF_SEQN ,user.SServer , phonenumdata.E_PERNR, ptMailBody.getProperty("UPMU_NAME") , currApprNumb);
                            vcElofficInterfaceData.add(eofD);
                           	ElofficInterfaceData eofI = ddfe.makeDocForInsert(AINF_SEQN ,user.SServer , phonenumdata.E_PERNR,  ptMailBody.getProperty("UPMU_NAME")  );
                            vcElofficInterfaceData.add(eofI);
                	    }
                        if (appLine.APPL_APPR_STAT.equals("A")) {
                            eof = ddfe.makeDocContents(AINF_SEQN ,user.SServer,ptMailBody.getProperty("UPMU_NAME"));
                        } else {
                            if (APPU_TYPE.equals("02") && Integer.parseInt(APPR_SEQN) > 1) {
                                eof = ddfe.makeDocForMangerReject(AINF_SEQN ,user.SServer,ptMailBody.getProperty("UPMU_NAME") ,vcTempAppLineData);
                            } else {
                                int nRejectLength = 0;
                                for (int i = vcTempAppLineData.size() - 1; i >= 0; i--) {
                                    tempAppLine = (AppLineData) vcTempAppLineData.get(i);
                                    if (tempAppLine.APPL_APPU_TYPE.equals(APPU_TYPE) && tempAppLine.APPL_APPR_SEQN.equals(APPR_SEQN)) {
                                        nRejectLength = i + 1;
                                        break;
                                    } // end if
                                } // end for

                                String approvers[] = new String[nRejectLength];
                                for (int i = 0; i < approvers.length; i++) {
                                    tempAppLine = (AppLineData) vcTempAppLineData.get(i);
                                    approvers[i]    =   tempAppLine.APPL_APPU_NUMB;
                                } // end for
                                if (!currApprNumb.equals(user.empNo)) {
                                    approvers[approvers.length-1] =user.empNo; //ESB ���� ����
                                }
                                eof = ddfe.makeDocForReject(AINF_SEQN ,user.SServer,ptMailBody.getProperty("UPMU_NAME") ,d01OTData.PERNR ,approvers);
                            } // end if
                        } // end if

                        vcElofficInterfaceData.add(eof);
                        Logger.info.println(this ,"^^^^^ G028ApprovalOTSV</b>[eof:]"+eof.toString());
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
                           dest = WebUtil.JspURL+"common/msg.jsp";
                           msg2 += "\\n" + "esb.process Eloffice ���� ����" ;
                       }

                    } catch (Exception e) {
                        dest = WebUtil.JspURL+"common/msg.jsp";
                        msg2 = msg2 +  " Eloffic ���� ���� " ;
                    } // end try
                    //@v1.1
                    if (!maTe.process()) {
                        msg2 = maTe.getMessage() + "\\n";
                    } // end if

                } else {
                    msg = ars.E_MESSAGE;
                    dest = WebUtil.JspURL+"common/msg.jsp";
                } // end if

                String url = "location.href = \"" + RequestPageName.replace('|','&') + "\";";

                req.setAttribute("msg", msg);
                req.setAttribute("msg2", msg2);
                req.setAttribute("url", url);
*/
            } else {
                throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
            } // end if

            Logger.debug.println(this, " destributed = " + dest);
            printJspPage(req, res, dest);

        } catch(Exception e) {
            Logger.err.println(DataUtil.getStackTrace(e));
            throw new GeneralException(e);
        }
    }
    
  //[CSR ID:3608185] e-HR �ʰ��ٹ� ���Ľ�û ���� �ý��� ���� ��û	
    protected void OTAfterCheck(D01OTData data){
    	int dayCount = DataUtil.getBetween(data.BEGDA, data.WORK_DATE);
        if (dayCount < 0)
        	OT_AFTER = "����";
        else		
        	OT_AFTER = "";
    }
}