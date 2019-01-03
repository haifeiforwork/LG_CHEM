/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR ����                                                  */
/*   2Depth Name  : ���ο��� �ڰݺ���                                           */
/*   Program Name : ���ο��� �ڰݺ������ ��û ����                             */
/*   Program ID   : E04PensionChngChangeSV                                      */
/*   Description  : ���ο��� �ڰݺ����� ������ �� �ֵ��� �ϴ� Class             */
/*   Note         :                                                             */
/*   Creation     : 2002-01-25  �ֿ�ȣ                                          */
/*   Update       : 2005-03-07  ������                                          */
/*                                                                              */
/********************************************************************************/

package servlet.hris.E.E04Pension;

import hris.E.E04Pension.E04PensionChngData;
import hris.E.E04Pension.rfc.E04PensionChngRFC;
import hris.common.*;
import hris.common.PersonData;
import hris.common.db.AppLineDB;
import hris.common.rfc.PersonInfoRFC;
import hris.common.util.AppUtil;

import java.sql.Connection;
import java.util.Properties;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.db.DBUtil;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;

public class E04PensionChngChangeSV extends EHRBaseServlet {

    private String UPMU_TYPE ="22";    // ���� ����Ÿ��(���ο��� �ڰݺ���)

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        Connection con = null;

        try{
            WebUserData user = WebUtil.getSessionUser(req);

            String dest     = "";
            String jobid    = "";

            Box box = WebUtil.getBox(req);
            jobid = box.get("jobid");
            if( jobid.equals("") ){
                jobid = "first";
            }
            Logger.debug.println(this, "[jobid] = "+jobid + " [user] : "+user.toString());

            E04PensionChngRFC  rfc       = new E04PensionChngRFC();
            E04PensionChngData firstData = new E04PensionChngData();

            Vector e04PensionChngData_vt = null;
            Vector AppLineData_vt        = null;
            String ainf_seqn             = box.get("AINF_SEQN");

            e04PensionChngData_vt = rfc.getPensionChng( "", ainf_seqn );
            Logger.debug.println(this, "���ο��� �ڰݺ��� ���� : " + e04PensionChngData_vt.toString());

            firstData = (E04PensionChngData)e04PensionChngData_vt.get(0);

            // �븮 ��û �߰�
            PersonInfoRFC numfunc = new PersonInfoRFC();
            PersonData phonenumdata;
            phonenumdata = (PersonData)numfunc.getPersonInfo(firstData.PERNR);
            req.setAttribute("PersonData" , phonenumdata );

            // ���� ���ư� ������
            String RequestPageName = box.get("RequestPageName");
            req.setAttribute("RequestPageName", RequestPageName);

            if( jobid.equals("first") ) {     //����ó�� ���� ȭ�鿡 ���°��.

                AppLineData_vt = new Vector();

                // �����ڸ���Ʈ
                AppLineData_vt = AppUtil.getAppChangeVt(ainf_seqn);

                req.setAttribute("AppLineData_vt", AppLineData_vt);
                req.setAttribute("e04PensionChngData_vt", e04PensionChngData_vt);

                dest = WebUtil.JspURL+"E/E04Pension/E04PensionChngChange.jsp";

            } else if( jobid.equals("change") ) {

                E04PensionChngData e04PensionChngData = new E04PensionChngData();
                AppLineData_vt     = new Vector();

                // ���ο��� �ڰݺ������..
                e04PensionChngData.AINF_SEQN   = ainf_seqn;              // �������� �Ϸù�ȣ
                e04PensionChngData.PERNR       = firstData.PERNR;        // �����ȣ
                e04PensionChngData.BEGDA       = box.get("BEGDA");       // ��û����
                e04PensionChngData.CHNG_TYPE   = box.get("CHNG_TYPE");   // �ڰݻ��׺����׸��ڵ�
                e04PensionChngData.CHNG_TEXT   = box.get("CHNG_TEXT");   // �ڰݻ��׺����׸��ڵ� text
                e04PensionChngData.CHNG_BEFORE = box.get("CHNG_BEFORE"); // �ڰݻ��׺���������Ÿ
                e04PensionChngData.CHNG_AFTER  = box.get("CHNG_AFTER");  // �ڰݻ��׺����ĵ���Ÿ
                e04PensionChngData.ZPERNR      = firstData.ZPERNR;       // ��û�� ���(�븮��û, ���� ��û)
                e04PensionChngData.UNAME       = user.empNo;             // ������ ���(�븮��û, ���� ��û)
                e04PensionChngData.AEDTM       = DataUtil.getCurrentDate();  // ������(���糯¥)

                Logger.debug.println(this, "���ο��� �ڰݺ��� ���� : " + e04PensionChngData.toString());

                // �������� ����..
                int rowcount = box.getInt("RowCount");
                for( int i = 0; i < rowcount; i++ ) {
                    AppLineData appLine = new AppLineData();
                    String      idx     = Integer.toString(i);

                    // ���� �̸����� ������ ������
                    box.copyToEntity(appLine ,i);

                    appLine.APPL_MANDT     = user.clientNo;
                    appLine.APPL_BUKRS     = user.companyCode;
                    appLine.APPL_PERNR     = firstData.PERNR;
                    appLine.APPL_BEGDA     = e04PensionChngData.BEGDA;
                    appLine.APPL_AINF_SEQN = ainf_seqn;
                    appLine.APPL_UPMU_TYPE = UPMU_TYPE;

                    AppLineData_vt.addElement(appLine);
                }
                Logger.debug.println(this, AppLineData_vt.toString());

                con = DBUtil.getTransaction();
                AppLineDB appDB = new AppLineDB(con);

                String msg;
                String msg2 = null;

                if( appDB.canUpdate((AppLineData)AppLineData_vt.get(0)) ) {

                    // ���� ������ ����Ʈ
                    Vector orgAppLineData_vt = AppUtil.getAppChangeVt(ainf_seqn);

                    appDB.change(AppLineData_vt);
                    rfc.change( firstData.PERNR, ainf_seqn, e04PensionChngData );
                    con.commit();

                    msg = "msg002";

                    AppLineData oldAppLine = (AppLineData) orgAppLineData_vt.get(0);
                    AppLineData newAppLine = (AppLineData) AppLineData_vt.get(0);

                    Logger.debug.println(this ,oldAppLine);
                    Logger.debug.println(this ,newAppLine);

                    if (!newAppLine.APPL_APPU_NUMB.equals(oldAppLine.APPL_PERNR)) {

                        // ������ ����� �� ������ ,ElOffice ���� ���̽�
                        phonenumdata = (PersonData)numfunc.getPersonInfo(firstData.PERNR);

                        // �̸��� ������
                        Properties ptMailBody = new Properties();
                        ptMailBody.setProperty("SServer",user.SServer);             // ElOffice ���� ����
                        ptMailBody.setProperty("from_empNo" ,user.empNo);           // �� �߼��� ���
                        ptMailBody.setProperty("to_empNo" ,oldAppLine.APPL_PERNR);  // �� ������ ���

                        ptMailBody.setProperty("ename" ,phonenumdata.E_ENAME);      // (��)��û�ڸ�
                        ptMailBody.setProperty("empno" ,phonenumdata.E_PERNR);      // (��)��û�� ���

                        ptMailBody.setProperty("UPMU_NAME" ,"���ο��� �ڰݺ���");   // ���� �̸�
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
                            ElofficInterfaceData eof = ddfe.makeDocForChange(ainf_seqn ,user.SServer , phonenumdata.E_PERNR, ptMailBody.getProperty("UPMU_NAME") ,oldAppLine.APPL_PERNR);
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

                String url = "location.href = '" + WebUtil.ServletURL+"hris.E.E04Pension.E04PensionChngDetailSV?AINF_SEQN="+ainf_seqn+"" +
                "&RequestPageName=" + RequestPageName + "';";
                req.setAttribute("msg", msg);
                req.setAttribute("msg2", msg2);
                req.setAttribute("url", url);

            } else {
                throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
            }
            Logger.debug.println(this, "destributed = " + dest);
            printJspPage(req, res, dest);

        } catch(Exception e) {
            throw new GeneralException(e);
        } finally {
            DBUtil.close(con);
        }
    }
}
