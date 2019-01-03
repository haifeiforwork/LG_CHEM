/******************************************************************************/
/*                                                                              */
/*   System Name  : ESS                                                         */
/*   1Depth Name  : ��������                                               */
/*   2Depth Name  : �������� �ߵ�����                                            */
/*   Program Name : �������� �ߵ�����  ��û ���� ����                               */
/*   Program ID   : E03RetireMidOutChangeSV                                         */
/*   Description  : �������� �ߵ�����  ��û ���� ���� ����                                  */
/*   Note         :                                               */
/*   Creation     : 2010-07-07 �ڹο�                                           */
/*   Update       : 2010-07-12 siyakim                                                            */
/*                                                                              */
/*                                                                              */
/********************************************************************************/

package servlet.hris.E.E03Retire;

import hris.E.E03Retire.E03RetireMidOutInfoData;
import hris.E.E03Retire.rfc.E03RetireMidOutRFC;
import hris.E.E03Retire.rfc.E03RetireMidOutResnRFC;
import hris.common.*;
import hris.common.PersonData;
import hris.common.db.AppLineDB;
import hris.common.rfc.PersInfoWithNoRFC;
import hris.common.rfc.PersonInfoRFC;
import hris.common.util.AppUtil;

import java.sql.Connection;
import java.util.Properties;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.db.DBUtil;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.DateTime;
import com.sns.jdf.util.WebUtil;

public class E03RetireMidOutChangeSV extends EHRBaseServlet {

    private String UPMU_TYPE ="53";
    private String UPMU_NAME = "�������� �ߵ�����";

	protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        Connection con = null;

        try{
            HttpSession session = req.getSession(false);
            WebUserData user = WebUtil.getSessionUser(req);

            String dest = "";
            String jobid = "";
            
            Box box = WebUtil.getBox(req);
            jobid = box.get("jobid");
            if( jobid.equals("") ){
                jobid = "first";
            }
            Logger.debug.println(this, "[jobid] = "+jobid + " [user] : "+user.toString());
            
            E03RetireMidOutRFC  rfc       = new E03RetireMidOutRFC();
            
            Vector E03RetireMidOutData_vt = null;
            String ainf_seqn       = box.get("AINF_SEQN");
            
            E03RetireMidOutData_vt = rfc.detail(ainf_seqn);
            
            E03RetireMidOutInfoData firstData = (E03RetireMidOutInfoData)E03RetireMidOutData_vt.get(0);
            Logger.debug.println(this, "E03RetireMidOutData_vt : " + E03RetireMidOutData_vt.toString());

            String PERNR = firstData.PERNR;            
            // �븮 ��û �߰�
            PersonInfoRFC numfunc = new PersonInfoRFC();
            PersonData phonenumdata;
            phonenumdata = (PersonData)numfunc.getPersonInfo(PERNR);
            req.setAttribute("PersonData" , phonenumdata );

            // ���� ���ư� ������
            String RequestPageName = box.get("RequestPageName");
            req.setAttribute("RequestPageName", RequestPageName);
            
            if( jobid.equals("first") ) {           //����ó�� ��û ȭ�鿡 ���°��.
            	//�ߵ����� ��������Ʈ
                Vector ResnList_vt = new E03RetireMidOutResnRFC().getMidOutResnList();
                // �����ڸ���Ʈ
                Vector AppLineData_vt = new Vector();
                AppLineData_vt = AppUtil.getAppChangeVt(ainf_seqn);

                Logger.debug.println(this, "AppLineData_vt : "+ AppLineData_vt.toString());

                PersInfoData  pid = (PersInfoData)new PersInfoWithNoRFC().getApproval(PERNR).get(0);
                req.setAttribute("PersInfoData" ,pid );                

                req.setAttribute("ResnList_vt", ResnList_vt);
                req.setAttribute("MidOutInfoData", firstData);                //�����û ����	                
                req.setAttribute("AppLineData_vt", AppLineData_vt);

                dest = WebUtil.JspURL+"E/E03Retire/E03RetireMidOutChange.jsp";

            } else if( jobid.equals("change") ) { // DB update �����κ�
                E03RetireMidOutInfoData MidOutData    = new E03RetireMidOutInfoData();
                Vector AppLineData_vt = new Vector();
                Vector MidOutData_vt   = new Vector();

                box.copyToEntity(MidOutData);
                MidOutData.PERNR     = PERNR;
                MidOutData.BEGDA    = DateTime.getShortDateString();              

                
                MidOutData_vt.addElement(MidOutData);
                
                Logger.debug.println(this, MidOutData.toString());

                MidOutData_vt.addElement(MidOutData);
                Logger.debug.println(this, "�ߵ����� ��û ���� MidOutData_vt ="+MidOutData_vt.toString());
                
                int rowcount = box.getInt("RowCount");
                for( int i = 0; i < rowcount; i++) {
                    AppLineData appLine = new AppLineData();
                    String      idx     = Integer.toString(i);

                    // ���� �̸����� ������ ������
                    box.copyToEntity(appLine ,i);
                    
                    appLine.APPL_MANDT      = user.clientNo;
                    appLine.APPL_BUKRS      = phonenumdata.E_BUKRS;
                    appLine.APPL_PERNR      = PERNR;
                    appLine.APPL_BEGDA      = MidOutData.BEGDA;
                    appLine.APPL_AINF_SEQN  = MidOutData.AINF_SEQN;
                    appLine.APPL_UPMU_TYPE  = UPMU_TYPE;

                    AppLineData_vt.addElement(appLine);
                }

                con = DBUtil.getTransaction();
                AppLineDB appDB = new AppLineDB(con);
                
                String msg;
                String msg2 = null;
                
                if( appDB.canUpdate((AppLineData)AppLineData_vt.get(0)) ) {
                    
                    // ���� ������ ����Ʈ
                    Vector orgAppLineData_vt = AppUtil.getAppChangeVt(ainf_seqn);
                    
                    appDB.change(AppLineData_vt);
                    rfc.change(PERNR, ainf_seqn, MidOutData_vt);
                    con.commit();
                    
                    msg = "msg002";

                    AppLineData oldAppLine = (AppLineData) orgAppLineData_vt.get(0);
                    AppLineData newAppLine = (AppLineData) AppLineData_vt.get(0);

                    Logger.debug.println(this ,oldAppLine);
                    Logger.debug.println(this ,newAppLine);

                    if (!newAppLine.APPL_APPU_NUMB.equals(oldAppLine.APPL_PERNR)) {

                        // ������ ����� �� ������ ,ElOffice ���� ���̽�
                        phonenumdata = (PersonData)numfunc.getPersonInfo(PERNR);

                        // �̸��� ������
                        Properties ptMailBody = new Properties();
                        ptMailBody.setProperty("SServer",user.SServer);             // ElOffice ���� ����
                        ptMailBody.setProperty("from_empNo" ,user.empNo);           // �� �߼��� ���
                        ptMailBody.setProperty("to_empNo" ,oldAppLine.APPL_PERNR);  // �� ������ ���

                        ptMailBody.setProperty("ename" ,phonenumdata.E_ENAME);      // (��)��û�ڸ�
                        ptMailBody.setProperty("empno" ,phonenumdata.E_PERNR);      // (��)��û�� ���

                        ptMailBody.setProperty("UPMU_NAME" ,UPMU_NAME);            // ���� �̸�
                        ptMailBody.setProperty("AINF_SEQN" ,ainf_seqn);             // ��û�� ����

                        // �� ����
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

//                      ElOffice �������̽�
                        try {
                            DraftDocForEloffice ddfe = new DraftDocForEloffice();
                            ElofficInterfaceData eof = ddfe.makeDocForChange(ainf_seqn ,user.SServer , phonenumdata.E_PERNR, ptMailBody.getProperty("UPMU_NAME") , oldAppLine.APPL_PERNR);
                            Vector vcElofficInterfaceData = new Vector();
                            vcElofficInterfaceData.add(eof);

                            ElofficInterfaceData eofD = ddfe.makeDocContents(ainf_seqn ,user.SServer,ptMailBody.getProperty("UPMU_NAME"));
                            vcElofficInterfaceData.add(eofD);
                            
                            req.setAttribute("vcElofficInterfaceData", vcElofficInterfaceData);
                            dest = WebUtil.JspURL+"common/ElOfficeInterface.jsp";
                        } catch (Exception e) {
                            dest = WebUtil.JspURL+"common/msg.jsp";
                            msg2 = msg2 + "\\n" + " Eloffic ���� ����" ;
                        } // end try
                    } else {
                        msg = "msg002";
                        dest = WebUtil.JspURL+"common/msg.jsp";
                    } // end if
                } else {
                    msg = "msg005";
                    dest = WebUtil.JspURL+"common/msg.jsp";
                } // end if

                String url = "location.href = '" + WebUtil.ServletURL+"hris.E.E03Retire.E03RetireMidOutDetailSV?AINF_SEQN="+ainf_seqn+"" +
                "&RequestPageName=" + RequestPageName + "';";
                req.setAttribute("msg", msg);
                req.setAttribute("msg2", msg2);
                req.setAttribute("url", url);
                    
            } else {
                throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
            }

            Logger.debug.println(this, " destributed = " + dest);
            printJspPage(req, res, dest);

        } catch(Exception e) {
            throw new GeneralException(e);
        } finally {
            DBUtil.close(con);
        }
	}
}
