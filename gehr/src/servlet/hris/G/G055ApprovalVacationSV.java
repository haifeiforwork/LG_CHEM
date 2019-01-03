/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : �����ؾ��� ����                                             */
/*   2Depth Name  :                                                             */
/*   Program Name : �ް� ����                                                   */
/*   Program ID   : G055ApprovalVacationSV.java                                 */
/*   Description  : �ް� ���縦 ���� ����                                     */
/*   Note         : ����                                                        */
/*   Creation     : 2005-03-10 �����                                           */
/*   Update       : 2006-01-18 @v1.1 ���ڰ��翬�����з� ���� ���Ϲ߼۰� ��ġ����*/
/*                   : 2017-04-17 ������ [CSR ID:3359686]   ���� ���� 5������        */
/*                                                                              */
/********************************************************************************/

package servlet.hris.G;

import com.common.Utils;
import com.common.constant.Area;
import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;

import hris.D.D01OT.rfc.D01OTCheckGlobalRFC;
import hris.D.D03Vocation.D03VocationData;
import hris.D.D03Vocation.rfc.D03VocationRFC;
import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalHeader;
import hris.common.approval.ApprovalLineData;
import servlet.hris.D.D01OT.D01OTBuildGlobalSV;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.Vector;

public class G055ApprovalVacationSV extends ApprovalBaseServlet
{

    private String UPMU_TYPE = "18";
    private String UPMU_NAME = "�ް�";


    protected String getUPMU_TYPE() {
        if(g.getSapType().isLocal())  return "18";
        else return  "02";
    }

    protected String getUPMU_NAME() {
        if(g.getSapType().isLocal())  return "�ް�";
        else return  "Leave";
    }

    protected void performTask(final HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        try{
            HttpSession session = req.getSession(false);
            final WebUserData user = WebUtil.getSessionUser(req);

            String tableName = "T_ZHRA024T";
            /* �ؿ� ���� Ÿ��*/
           if(user.area != Area.KR) {
               UPMU_TYPE = "02"; // ���� ����Ÿ��
               UPMU_NAME = "Leave";
               tableName = "T_ZHR0046T";
           } else {
               UPMU_TYPE = "18";
               UPMU_NAME = "�ް� ��û";
               tableName = "T_ZHRA024T";
           }
            Vector          vcAppLineData      = null;
            Vector          d03VocationData_vt = null;

            String dest  = "";
            String jobid = "";

            final Box box = WebUtil.getBox(req);
            String  AINF_SEQN  = box.get("AINF_SEQN");

            // ó�� �� ���� �� ������
            String RequestPageName = box.get("RequestPageName");
            req.setAttribute("RequestPageName", RequestPageName);

            jobid = box.get("jobid", "search");


            //�ް���û ��ȸ
            final D03VocationRFC  rfc = new D03VocationRFC();
            rfc.setDetailInput(user.empNo, "1", AINF_SEQN);
            d03VocationData_vt = rfc.getVocation( user.empNo, AINF_SEQN );
            final D03VocationData d03VocationData = (D03VocationData) Utils.indexOf(d03VocationData_vt, 0); //��� ����Ÿ

            /* ���� �� */
            if("A".equals(jobid)) {
                /* ������ ���� �� */
                dest = accept(req, box, null, d03VocationData, rfc, new ApprovalFunction<D03VocationData>() {
                    public boolean porcess(D03VocationData inputData, ApprovalHeader approvalHeader, Vector<ApprovalLineData> approvalLineDatas)
                    		throws GeneralException {

                        /* ������ ���� ���� */
                        // box.copyToEntity(inputData);  //����ڰ� �Է��� ����Ÿ�� ������Ʈ

                        // time formatting (ksc)2016/12/21
                        final D01OTBuildGlobalSV d01sv = new D01OTBuildGlobalSV();
                        inputData.BEGUZ = d01sv.toTimeFormat(inputData.BEGUZ);
                        inputData.ENDUZ = d01sv.toTimeFormat(inputData.ENDUZ);

                        inputData.UNAME     = user.empNo;
                        inputData.AEDTM     = DataUtil.getCurrentDate();
                        
                        // [WorkTime52] �߰�
                        inputData.I_NTM 	= "X";
                        
                        //[CSR ID:3359686]   ���� ���� 5������ START
                        D01OTCheckGlobalRFC  d01OTCheckGlobalRFC           = new D01OTCheckGlobalRFC();
                        if(!g.getSapType().isLocal()){
                            d01OTCheckGlobalRFC.checkApprovalPeriod(req,inputData.PERNR,"A", inputData.APPL_FROM,   UPMU_TYPE, inputData.AWART );
                            if ("E".equals(d01OTCheckGlobalRFC.getReturn().MSGTY)) {
        						throw new GeneralException(g.getMessage("MSG.D.D01.0108")); //The request date has passed 5 working days. You could not approve it.
        					}
                        }
                      //[CSR ID:3359686]   ���� ���� 5������ END
                        return true;
                    }
                });

            /* �ݷ��� */
            } else if("R".equals(jobid)) {
                dest = reject(req, box, null, d03VocationData_vt, rfc, null);
            } else if("C".equals(jobid)) {
                dest = cancel(req, box, null, d03VocationData_vt, rfc, null);
            } else {
                throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
            }
/*
            if( jobid.equals("search") ) {

                //�ް���û ��ȸ
                final D03VocationRFC  rfc = new D03VocationRFC();
                d03VocationData_vt = rfc.getVocation( user.empNo, AINF_SEQN );
                Logger.debug.println(this, "�ް� ��ȸ : " + d03VocationData_vt.toString());

                if( d03VocationData_vt.size() < 1 ){
                    String msg = "System Error! \n\n ��ȸ�� �׸��� �����ϴ�.";
                    req.setAttribute("msg", msg);
                    dest = WebUtil.JspURL+"common/caution.jsp";
                }else{
                    //�ް�
                    d03VocationData  = (D03VocationData)d03VocationData_vt.get(0);

                    // �ܿ��ް��ϼ�, ��ġ����ٹ��� üũ
                    D03RemainVocationRFC  rfcRemain             = null;
                    D03RemainVocationData d03RemainVocationData = new D03RemainVocationData();

                    rfcRemain             = new D03RemainVocationRFC();
                    d03RemainVocationData = (D03RemainVocationData)rfcRemain.getRemainVocation(user.empNo, DataUtil.getCurrentDate());

                    // ������ ����
                    vcAppLineData = AppUtil.getAppChangeVt(AINF_SEQN);

                    // ���� ����.
                    PersInfoWithNoRFC piRfc = new PersInfoWithNoRFC();
                    PersInfoData      pid   = (PersInfoData) piRfc.getApproval(d03VocationData.PERNR).get(0);

                    req.setAttribute("PersInfoData" ,pid );
                    req.setAttribute("vcAppLineData" , vcAppLineData);
                    req.setAttribute("d03VocationData_vt", d03VocationData_vt);
                    req.setAttribute("d03RemainVocationData",  d03RemainVocationData);

                    dest = WebUtil.JspURL+"G/G055ApprovalVacation.jsp";
                } // end if
            } else if( jobid.equals("save") ) {

                d03VocationData    = new D03VocationData();
                d03VocationData_vt = new Vector();
                vcAppLineData      = new Vector();
                AppLineData  tempAppLine;
                Vector       vcTempAppLineData = new Vector();
                AppLineData  appLine           = new AppLineData();

                // �ް� ���� �ڷ�
                box.copyToEntity(d03VocationData);
                d03VocationData.UNAME = user.empNo;
                d03VocationData.AEDTM = DataUtil.getCurrentDate();

                // ������ ����
                int nRowCount = Integer.parseInt(box.getString("RowCount"));
                String APPU_TYPE = box.get("APPU_TYPE");
                String APPR_SEQN = box.get("APPR_SEQN");
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
                phonenumdata = (PersonData)numfunc.getPersonInfo(d03VocationData.PERNR);

                Properties ptMailBody = new Properties();
                ptMailBody.setProperty("SServer",user.SServer);          // ElOffice ���� ����
                ptMailBody.setProperty("from_empNo" ,user.empNo);        // �� �߼��� ���
                ptMailBody.setProperty("ename" ,phonenumdata.E_ENAME);   // (��)��û�ڸ�
                ptMailBody.setProperty("empno" ,phonenumdata.E_PERNR);   // (��)��û�� ���
                ptMailBody.setProperty("UPMU_NAME" ,"�ް�");             // ���� �̸�
                ptMailBody.setProperty("AINF_SEQN" ,AINF_SEQN);          // ��û�� ����

                // �� ����
                StringBuffer sbSubject = new StringBuffer(512);

                sbSubject.append("[" + ptMailBody.getProperty("UPMU_NAME") + "] ");
                //sbSubject.append(user.ename  + "���� ");
                sbSubject.append(user.ename).append("���� ");

                String msg;
                String msg2 = "";
                String to_empNo = d03VocationData.PERNR;

                if (ars.E_RETURN.equals("S")) {

                    if (appLine.APPL_APPR_STAT.equals("A")) {
                        msg = "msg009";
                        for (int i = 0; i < vcTempAppLineData.size(); i++) {
                            tempAppLine = (AppLineData) vcTempAppLineData.get(i);
                            if (tempAppLine.APPL_APPU_TYPE.equals(APPU_TYPE) && tempAppLine.APPL_APPR_SEQN.equals(APPR_SEQN)) {
                                if (i == vcTempAppLineData.size() -1) {
                                    // ������ ������
                                    ptMailBody.setProperty("FileName" ,"MbNoticeMailApp.html");
                                    sbSubject.append(ptMailBody.getProperty("UPMU_NAME") +"�� ���� �ϼ̽��ϴ�..");
                                } else {
                                    // ���� ������
                                    tempAppLine = (AppLineData) vcTempAppLineData.get(i+1);
                                    to_empNo = tempAppLine.APPL_APPU_NUMB;
                                    ptMailBody.setProperty("FileName" ,"MbNoticeMailBuild.html");
                                    sbSubject.append(ptMailBody.getProperty("UPMU_NAME") +" ���縦 ��û �ϼ̽��ϴ�.");
                                    break;
                                } // end if
                            } // end if
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
                        Vector vcElofficInterfaceData = new Vector(); //ESB ���� ����
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
                                eof = ddfe.makeDocForReject(AINF_SEQN ,user.SServer,ptMailBody.getProperty("UPMU_NAME") ,d03VocationData.PERNR ,approvers);
                            } // end if
                        } // end if

                        vcElofficInterfaceData.add(eof);

                        //���� ������� �������� ����
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
                        msg2 +=  " Eloffic ���� ���� " ;
                    } // end try
                    //@v1.1 ���ڰ��翬�����з� ���ϰ� ��ġ����
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

            } else {
                throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
            } // end if
*/
            Logger.debug.println(this, " destributed = " + dest);
            printJspPage(req, res, dest);

        } catch(Exception e) {
            Logger.err.println(DataUtil.getStackTrace(e));
            throw new GeneralException(e);
        }
    }
}
