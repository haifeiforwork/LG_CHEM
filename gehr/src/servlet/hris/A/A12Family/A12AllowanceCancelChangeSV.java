/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR ����                                                  */
/*   2Depth Name  : ��������                                                    */
/*   Program Name : ���������� ��û ����                                      */
/*   Program ID   : A12AllowanceCancelChangeSV                                  */
/*   Description  : ���������� ��û�� ������ �� �ֵ��� �ϴ� Class             */
/*   Note         :                                                             */
/*   Creation     : 2002-10-31  �赵��                                          */
/*   Update       : 2005-03-07  ������                                          */
/*                                                                              */
/********************************************************************************/

package	servlet.hris.A.A12Family;

import hris.A.A12Family.A12FamilyBuyangData;
import hris.A.A12Family.rfc.A12FamilyAlloCancelRFC;
import hris.common.AppLineData;
import hris.common.DraftDocForEloffice;
import hris.common.ElofficInterfaceData;
import hris.common.MailSendToEloffic;
import hris.common.PersonData;
import hris.common.WebUserData;
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

public class A12AllowanceCancelChangeSV extends EHRBaseServlet {

    private String UPMU_TYPE ="29";     // ���� ����Ÿ��(����������)

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

            A12FamilyAlloCancelRFC rfc    = new A12FamilyAlloCancelRFC();
            A12FamilyBuyangData firstData = new A12FamilyBuyangData();
       
            Vector a12FamilyBuyangData_vt = null;
            Vector AppLineData_vt         = null;
            String ainf_seqn              = box.get("AINF_SEQN");

            // ���� ������ ���ڵ�
            a12FamilyBuyangData_vt     = rfc.getFamilyAlloCancel(ainf_seqn);

            firstData = (A12FamilyBuyangData)a12FamilyBuyangData_vt.get(0);

            // �븮 ��û �߰�
            PersonInfoRFC numfunc = new PersonInfoRFC();
            PersonData phonenumdata;
            phonenumdata = (PersonData)numfunc.getPersonInfo(firstData.PERNR);
            req.setAttribute("PersonData" , phonenumdata );

            // ���� ���ư� ������
            String RequestPageName = box.get("RequestPageName");
            req.setAttribute("RequestPageName", RequestPageName);

            // XxxDetailSV.java �� XxxDetail.jsp �� '���' ��ư Ȱ��ȭ ���θ� �����ִ� �κ�
            String ThisJspName = box.get("ThisJspName");
            req.setAttribute("ThisJspName", ThisJspName);
            //  XxxDetailSV.java �� XxxDetail.jsp �� '���' ��ư Ȱ��ȭ ���θ� �����ִ� �κ�

            if( jobid.equals("first") ) {     //����ó�� ���� ȭ�鿡 ���°��.

                // �����ڸ���Ʈ
                AppLineData_vt = AppUtil.getAppChangeVt(ainf_seqn);

                Logger.debug.println(this, "���������� ��û ���� ��ȸ : " + a12FamilyBuyangData_vt.toString());
                Logger.debug.println(this, "���� : "+ AppLineData_vt.toString());

                req.setAttribute("a12FamilyBuyangData_vt", a12FamilyBuyangData_vt);
                req.setAttribute("AppLineData_vt",  AppLineData_vt);

                dest = WebUtil.JspURL+"A/A12Family/A12AllowanceCancelChange.jsp";

            } else if( jobid.equals("change") ) {

                A12FamilyBuyangData    a12FamilyBuyangData = new A12FamilyBuyangData();
                a12FamilyBuyangData_vt = new Vector();
                AppLineData_vt         = new Vector();

                // ���������� ��û
                box.copyToEntity(a12FamilyBuyangData);
                a12FamilyBuyangData.PERNR     = firstData.PERNR;
                a12FamilyBuyangData.AINF_SEQN = ainf_seqn;
                a12FamilyBuyangData.ZPERNR    = firstData.ZPERNR;        // ��û�� ���(�븮��û, ���� ��û)
                a12FamilyBuyangData.UNAME     = user.empNo;              // ��û�� ���(�븮��û, ���� ��û)
                a12FamilyBuyangData.AEDTM     = DataUtil.getCurrentDate();  // ������(���糯¥)

                a12FamilyBuyangData_vt.addElement(a12FamilyBuyangData);

                Logger.debug.println(this, "���������� ��û ���� : " + a12FamilyBuyangData.toString());
                //  XxxDetailSV.java �� XxxDetail.jsp �� '���/��ȭ��' ��ư Ȱ��ȭ ���θ� �����ִ� �κ�            
                ThisJspName = box.get("ThisJspName");
                //  XxxDetailSV.java �� XxxDetail.jsp �� '���/��ȭ��' ��ư Ȱ��ȭ ���θ� �����ִ� �κ� 

                // �������� ����..
                int rowcount = box.getInt("RowCount");
                for( int i = 0; i < rowcount; i++ ) {
                    AppLineData appLine = new AppLineData();
                    String      idx     = Integer.toString(i);

                    // ������ �ڷ� �Է�(Web)
                    box.copyToEntity(appLine ,i);

                    appLine.APPL_MANDT     = user.clientNo;
                    appLine.APPL_BUKRS     = user.companyCode;
                    appLine.APPL_PERNR     = firstData.PERNR;
                    appLine.APPL_BEGDA     = a12FamilyBuyangData.BEGDA;
                    appLine.APPL_AINF_SEQN = ainf_seqn;
                    appLine.APPL_UPMU_TYPE = UPMU_TYPE;

                    AppLineData_vt.addElement(appLine);
                }
                Logger.debug.println(this, AppLineData_vt.toString());

                con = DBUtil.getTransaction();
                AppLineDB appDB    = new AppLineDB(con);

                String msg;
                String msg2 = null;

                if( appDB.canUpdate((AppLineData)AppLineData_vt.get(0)) ) {

                    // ���� ������ ����Ʈ
                    Vector orgAppLineData_vt = AppUtil.getAppChangeVt(ainf_seqn);

                    appDB.change(AppLineData_vt);
                    rfc.change( ainf_seqn , a12FamilyBuyangData_vt );
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

                        ptMailBody.setProperty("UPMU_NAME" ,"����������");        // ���� �̸�
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
                        sbSubject.append(ptMailBody.getProperty("ename") +"���� ��û�ϼ̽��ϴ�");
                        
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
                            ElofficInterfaceData eof = ddfe.makeDocForChange(ainf_seqn ,user.SServer ,phonenumdata.E_PERNR, ptMailBody.getProperty("UPMU_NAME") ,oldAppLine.APPL_PERNR);
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
                
                String url = "location.href = '" + WebUtil.ServletURL+"hris.A.A12Family.A12AllowanceCancelDetailSV?AINF_SEQN="+ainf_seqn+"&ThisJspName="+ThisJspName+"" +
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
