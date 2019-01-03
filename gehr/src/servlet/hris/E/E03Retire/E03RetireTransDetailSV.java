/******************************************************************************/
/*                                                                              */
/*   System Name  : ESS                                                         */
/*   1Depth Name  : ��������                                               */
/*   2Depth Name  : �������� ������ȯ                                            */
/*   Program Name : �������� ������ȯ  ��û ���� ��ȸ                               */
/*   Program ID   : E03RetireTransDetailSV                                         */
/*   Description  : �������� ������ȯ  ��û ���� ��ȸ ����                                  */
/*   Note         :                                               */
/*   Creation     : 2010-07-07 �ڹο�                                           */
/*   Update       : 2010-07-12 siyakim                                                            */
/*                     2018/07/25 rdcamel ������                                                          */
/*                                                                              */
/********************************************************************************/

package servlet.hris.E.E03Retire;

import hris.E.E03Retire.E03RetireTransInfoData;
import hris.E.E03Retire.rfc.E03RetireTransRFC;
import hris.E.E03Retire.rfc.E03RetireTransResnRFC;
import hris.common.AppLineData;
import hris.common.DraftDocForEloffice;
import hris.common.ElofficInterfaceData;
import hris.common.MailSendToEloffic;
import hris.common.PersInfoData;
import hris.common.PersonData;
import hris.common.WebUserData;
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
import com.sns.jdf.util.WebUtil;

//�������� ������ȯ��û��ȸ����
public class E03RetireTransDetailSV extends EHRBaseServlet {

    private String UPMU_TYPE ="52";
    private String UPMU_NAME = "�������� ������ȯ";

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        Connection con = null;

        try{
            HttpSession session = req.getSession(false);
            WebUserData user = WebUtil.getSessionUser(req);

            String dest  = "";
            String jobid = "";

            Box box = WebUtil.getBox(req);
            jobid = box.get("jobid");
            if( jobid.equals("") ){
                jobid = "first";
            }

            Logger.debug.println(this, "[jobid] = "+jobid + " [user] : "+user.toString());

            E03RetireTransInfoData    firstData    = new E03RetireTransInfoData();
            E03RetireTransRFC      rfc       = new E03RetireTransRFC();
            
            Vector E03RetireTransData_vt  = null;
            String ainf_seqn           = box.get("AINF_SEQN");
            
            E03RetireTransData_vt = rfc.detail(ainf_seqn);
            
            if(E03RetireTransData_vt.size() > 0)
            	firstData = (E03RetireTransInfoData)E03RetireTransData_vt.get(0);
            
            Logger.debug.println(this, "E03RetireTransData_vt : " + E03RetireTransData_vt.toString());

            String PERNR = firstData.PERNR;
            // �븮 ��û �߰�
            PersonInfoRFC numfunc = new PersonInfoRFC();
            PersonData phonenumdata;
            phonenumdata = (PersonData)numfunc.getPersonInfo(PERNR);
            req.setAttribute("PersonData" , phonenumdata );

            // ���� ���ư� ������
            String RequestPageName = box.get("RequestPageName");
            req.setAttribute("RequestPageName", RequestPageName);
            
            if( jobid.equals("first") ) {
            	//������ȯ �ڵ帮��Ʈ
                Vector ResnList_vt = new E03RetireTransResnRFC().getTransResnList();
                // �����ڸ���Ʈ
                Vector AppLineData_vt = AppUtil.getAppVector( PERNR, UPMU_TYPE );
                Logger.debug.println(this, "AppLineData_vt : "+ AppLineData_vt.toString());

                PersInfoData  pid = (PersInfoData)new PersInfoWithNoRFC().getApproval(PERNR).get(0);
                req.setAttribute("PersInfoData" ,pid );
                
                req.setAttribute("ResnList_vt", ResnList_vt);
                req.setAttribute("TransInfoData", firstData);                //�����û ����	                
                req.setAttribute("AppLineData_vt", AppLineData_vt);
                
                dest = WebUtil.JspURL+"E/E03Retire/E03RetireTransDetail.jsp";
            } else if( jobid.equals("delete") ) {
                Vector AppLineData_vt = new Vector();

                AppLineData  appLine = new AppLineData();
                appLine.APPL_MANDT     = user.clientNo;
                appLine.APPL_BUKRS     = phonenumdata.E_BUKRS;
                appLine.APPL_PERNR     = PERNR;
                appLine.APPL_UPMU_TYPE = UPMU_TYPE;
                appLine.APPL_AINF_SEQN = ainf_seqn;

                // 2002.07.25.---------------------------------------------------------------------------
                // ��û�� ������ ���� ������ ���� �ʿ��� ������ ������ �����´�.
                // ����
                int rowcount = box.getInt("RowCount");
                for( int i = 0; i < rowcount; i++) {
                    AppLineData app = new AppLineData();
                    String      idx = Integer.toString(i);

//                  ���� �̸����� ������ ������
                    box.copyToEntity(app ,i);
                    
                    AppLineData_vt.addElement(app);
                }
                Logger.debug.println(this, "AppLineData : " + AppLineData_vt.toString());
                // ��û�� ������ ���� ������ ���� �ʿ��� ������ ������ �����´�.
                // 2002.07.25.---------------------------------------------------------------------------

                con                = DBUtil.getTransaction();
                AppLineDB  appDB   = new AppLineDB(con);
                
                if( appDB.canUpdate(appLine) ) {
                    appDB.delete(appLine);
                    rfc.delete(PERNR, ainf_seqn );
                    con.commit();

//                  ��û�� ������ ���� ������.
                    appLine = (AppLineData)AppLineData_vt.get(0);
                    Properties ptMailBody = new Properties();
                    ptMailBody.setProperty("SServer",user.SServer);              // ElOffice ���� ����
                    ptMailBody.setProperty("from_empNo" ,user.empNo);            // �� �߼��� ���
                    ptMailBody.setProperty("to_empNo" ,appLine.APPL_APPU_NUMB);  // �� ������ ���

                    ptMailBody.setProperty("ename" ,phonenumdata.E_ENAME);       // (��)��û�ڸ�
                    ptMailBody.setProperty("empno" ,phonenumdata.E_PERNR);       // (��)��û�� ���

                    ptMailBody.setProperty("UPMU_NAME" ,UPMU_NAME);             // ���� �̸�
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
                                ,PERNR ,appLine.APPL_APPU_NUMB);
                        
                        Vector vcElofficInterfaceData = new Vector();
                        vcElofficInterfaceData.add(eof);
                        req.setAttribute("vcElofficInterfaceData", vcElofficInterfaceData);
                        dest = WebUtil.JspURL+"common/ElOfficeInterface.jsp";
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
                        url = "location.href = '" + WebUtil.ServletURL+"hris.E.E03Retire.E03RetireTransBuildSV';";
                    } // end if
                    //  ���� ������ ������ �������� �̵��ϱ� ���� ����

                    req.setAttribute("msg", msg);
                    req.setAttribute("url", url);
                } else {
                    String msg = "msg005";
                    String url = "location.href = '" + WebUtil.ServletURL+"hris.E.E03Retire.E03RetireTransDetailSV?AINF_SEQN="+ainf_seqn+"';";
                    req.setAttribute("msg", msg);
                    req.setAttribute("url", url);
                    dest = WebUtil.JspURL+"common/msg.jsp";
                }

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
