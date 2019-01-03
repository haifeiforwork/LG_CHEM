/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR ����                                                  */
/*   2Depth Name  : �������� �ȳ�/��û                                          */
/*   Program Name : �������� ��ȸ                                               */
/*   Program ID   : C02CurriDetailSV                                            */
/*   Description  : ����������û ��ȸ�� �Ҽ� �ֵ��� �ϴ� Class                  */
/*   Note         :                                                             */
/*   Creation     : 2002-01-15  �ڿ���                                          */
/*   Update       : 2005-02-25  ������                                          */
/*                                                                              */
/********************************************************************************/

package servlet.hris.C.C02Curri;

import java.sql.*;
import java.util.Properties;
import java.util.Vector;
import javax.servlet.http.*;

import com.sns.jdf.*;
import com.sns.jdf.db.*;
import com.sns.jdf.util.*;
import com.sns.jdf.servlet.*;

import hris.common.*;
import hris.common.db.*;
import hris.common.rfc.PersonInfoRFC;

import hris.C.C02Curri.C02CurriApplData;
import hris.C.C02Curri.rfc.*;

public class C02CurriDetailSV extends EHRBaseServlet {

    private String UPMU_TYPE ="08";

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        Connection con = null;

        try{
            WebUserData user = WebUtil.getSessionUser(req);

            String dest = "";
            String jobid = "";

            Box box = WebUtil.getBox(req);
            jobid = box.get("jobid");

            if( jobid.equals("") ){
                jobid = "first";
            }
            Logger.debug.println(this, "[jobid] = "+jobid + " [user] : "+user.toString());

            String ainf_seqn = box.get("AINF_SEQN");

            C02CurriApplRFC func = new C02CurriApplRFC();
            C02CurriApplData c02CurriApplData = null;

            Vector C02CurriApplData_vt = func.getDetail( ainf_seqn );

            c02CurriApplData = (C02CurriApplData)C02CurriApplData_vt.get(0);

            // �븮 ��û �߰�
            PersonInfoRFC numfunc = new PersonInfoRFC();
            PersonData phonenumdata;
            phonenumdata = (PersonData)numfunc.getPersonInfo(c02CurriApplData.PERNR);

            req.setAttribute("PersonData" , phonenumdata );

            //ó�� �� ���� �� ������
            String RequestPageName = box.get("RequestPageName");
            req.setAttribute("RequestPageName", RequestPageName);

            if( jobid.equals("first") ) {

                req.setAttribute("c02CurriApplData", c02CurriApplData);

                dest = WebUtil.JspURL+"C/C02Curri/C02CurriDetail.jsp";

            } else if( jobid.equals("delete") ) {

                Vector AppLineData_vt = new Vector();

                AppLineData  appLine = new AppLineData();
                appLine.APPL_MANDT     = user.clientNo;
                appLine.APPL_BUKRS     = user.companyCode;
                appLine.APPL_PERNR     = c02CurriApplData.PERNR;
                appLine.APPL_UPMU_TYPE = UPMU_TYPE;
                appLine.APPL_AINF_SEQN = ainf_seqn;

                // 2002.07.25.----------------------------------------------------------------
                // ��û�� ������ ���� ������ ���� �ʿ��� ������ ������ �����´�.
                // ����
                int rowcount = box.getInt("RowCount");
                for( int i = 0; i < rowcount; i++) {
                    AppLineData app = new AppLineData();
                    String      idx = Integer.toString(i);

                    box.copyToEntity(app ,i);

                    AppLineData_vt.addElement(app);
                }
                Logger.debug.println(this, "AppLineData : " + AppLineData_vt.toString());
                //              ��û�� ������ ���� ������ ���� �ʿ��� ������ ������ �����´�.
                // 2002.07.25.----------------------------------------------------------------

                con             = DBUtil.getTransaction();
                AppLineDB appDB = new AppLineDB(con);

                if( appDB.canUpdate(appLine) ) {

                    appDB.delete(appLine);
                    func.delete( ainf_seqn );
                    con.commit();

                    // 2002.07.25. ��û�� ������ ���� ������.-----------------------------------------
                    appLine = (AppLineData)AppLineData_vt.get(0);
                    Properties ptMailBody = new Properties();
                    ptMailBody.setProperty("SServer",user.SServer);              // ElOffice ���� ����
                    ptMailBody.setProperty("from_empNo" ,user.empNo);            // �� �߼��� ���
                    ptMailBody.setProperty("to_empNo" ,appLine.APPL_APPU_NUMB);  // �� ������ ���

                    ptMailBody.setProperty("ename" ,phonenumdata.E_ENAME);       // (��)��û�ڸ�
                    ptMailBody.setProperty("empno" ,phonenumdata.E_PERNR);       // (��)��û�� ���

                    ptMailBody.setProperty("UPMU_NAME" ,"��������");             // ���� �̸�
                    ptMailBody.setProperty("AINF_SEQN" ,ainf_seqn);              // ��û�� ����
                    // 2002.07.25. ��û�� ������ ���� ������.-----------------------------------------

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
                    if (user.loginPlace != null && !user.loginPlace.equals("elearning")) {
                        try {
                            DraftDocForEloffice ddfe = new DraftDocForEloffice();
                            ElofficInterfaceData eof = ddfe.makeDocForRemove(ainf_seqn ,user.SServer ,ptMailBody.getProperty("UPMU_NAME") 
                                    ,c02CurriApplData.PERNR ,appLine.APPL_APPU_NUMB);
                            
                            Vector vcElofficInterfaceData = new Vector();
                            vcElofficInterfaceData.add(eof);
                            req.setAttribute("vcElofficInterfaceData", vcElofficInterfaceData);
                            dest = WebUtil.JspURL+"common/ElOfficeInterface.jsp";
                        } catch (Exception e) {
                            dest = WebUtil.JspURL+"common/msg.jsp";
                            msg2 = msg2 + "\\n" + " Eloffic ���� ����" ;
                        } // end try
                    } else {
                        dest = WebUtil.JspURL+"common/msg.jsp";
                    } // end if
                    
                    String msg = "msg003";
                    String url ;

                    //  ���� ������ ������ �������� �̵��ϱ� ���� ����
                    if(RequestPageName != null &&  !RequestPageName.equals("") ){
                        url = "location.href = '" + RequestPageName.replace('|','&') + "';";
                    } else {
                        url = "location.href = '" + WebUtil.ServletURL+"hris.C.C02Curri.C02CurriInfoListSV';";
                    } // end if
                    //  ���� ������ ������ �������� �̵��ϱ� ���� ����

                    req.setAttribute("msg", msg);
                    req.setAttribute("url", url);

                } else {
                    String msg = "msg005";
                    String url = "location.href = '" + WebUtil.ServletURL+"hris.C.C02Curri.C02CurriDetailSV?AINF_SEQN=" + ainf_seqn + "';";
                    req.setAttribute("msg", msg);
                    req.setAttribute("url", url);
                    dest = WebUtil.JspURL+"common/caution.jsp";
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