/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR ����                                                  */
/*   2Depth Name  : �������ϱ�                                                  */
/*   Program Name : �������ϱ� ����                                             */
/*   Program ID   : E21EntranceChangeSV                                         */
/*   Description  : �������ϱ��� ������ �� �ֵ��� �ϴ� Class                    */
/*   Note         :                                                             */
/*   Creation     : 2002-01-03  �赵��                                          */
/*   Update       : 2005-03-07  ������                                          */
/*                                                                              */
/********************************************************************************/

package servlet.hris.E.E21Entrance;

import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.db.DBUtil;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;
import hris.A.A04FamilyDetailData;
import hris.A.rfc.A04FamilyDetailRFC;
import hris.E.E21Entrance.E21EntranceData;
import hris.E.E21Entrance.rfc.E21EntranceDupCheckRFC;
import hris.E.E21Entrance.rfc.E21EntranceRFC;
import hris.common.*;
import hris.common.db.AppLineDB;
import hris.common.rfc.PersonInfoRFC;
import hris.common.util.AppUtil;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.sql.Connection;
import java.util.Properties;
import java.util.Vector;

public class E21EntranceChangeSV extends EHRBaseServlet {

    private String UPMU_TYPE ="05";    // ���� ����Ÿ��(�������ϱ�)

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        Connection con = null;

        try{
            WebUserData user = WebUtil.getSessionUser(req);

            String dest = "";
            String jobid = "";
            String msgFLAG = "";
            String msgTEXT = "";

            Box box = WebUtil.getBox(req);
            jobid = box.get("jobid");
            if( jobid.equals("") ){
                jobid = "first";
            }
            Logger.debug.println(this, "[jobid] = "+jobid + " [user] : "+user.toString());

            E21EntranceRFC   rfc       = new E21EntranceRFC();
            E21EntranceData  firstData = new E21EntranceData();

            Vector e21EntranceData_vt  = null;
            Vector AppLineData_vt      = null;
            String ainf_seqn           = box.get("AINF_SEQN");

            e21EntranceData_vt = rfc.getEntrance( "", ainf_seqn );
            Logger.debug.println(this, "e21EntranceData_vt : " + e21EntranceData_vt.toString());

            firstData = (E21EntranceData)e21EntranceData_vt.get(0);

            // �븮 ��û �߰�
            PersonInfoRFC numfunc = new PersonInfoRFC();
            PersonData phonenumdata;
            phonenumdata = (PersonData)numfunc.getPersonInfo(firstData.PERNR);
            req.setAttribute("PersonData" , phonenumdata );

            // ���� ���ư� ������
            String RequestPageName = box.get("RequestPageName");
            req.setAttribute("RequestPageName", RequestPageName);

            if( jobid.equals("first") ) {     // ����ó�� ��û ȭ�鿡 ���°��.

                AppLineData_vt = new Vector();

                // ��������Ʈ(�ڳ�)�� �����Ѵ�.
                A04FamilyDetailRFC  rfc_family = new A04FamilyDetailRFC();
                A04FamilyDetailData data       = new A04FamilyDetailData();

                Vector a04FamilyDetailData_vt = new Vector();
                box.put("I_PERNR", firstData.PERNR);
                Vector temp_vt                = rfc_family.getFamilyDetail(box) ;
                Vector e21EntranceDupCheck_vt = (new E21EntranceDupCheckRFC()).getCheckList( firstData.PERNR );

                for( int i = 0 ; i < temp_vt.size() ; i++ ) {
                    data = (A04FamilyDetailData)temp_vt.get(i);

                    if( data.SUBTY.equals("2") ) {
                        a04FamilyDetailData_vt.addElement(data);
                    }
                }
                // ��������Ʈ(�ڳ�)�� �����Ѵ�.

                if( a04FamilyDetailData_vt.size() == 0 ) {  // �����̱⶧���� �� ������ �����ϱ�� ����ڴ�.
                    //String msg = "�������ϱ��� ��û�� �ڳడ �����ϴ�.";
                    msgFLAG = "C";
                    msgTEXT = "�������ϱ��� ��û�� �ڳడ �����ϴ�.";
                } 
                // �ڳฮ��Ʈ
                Logger.debug.println(this, "a04FamilyDetailData_vt : "+ a04FamilyDetailData_vt.toString());
                
                req.setAttribute("a04FamilyDetailData_vt", a04FamilyDetailData_vt);
                
                // �����ڸ���Ʈ
                AppLineData_vt = AppUtil.getAppChangeVt(ainf_seqn);
                
                req.setAttribute("e21EntranceData_vt",     e21EntranceData_vt);
                req.setAttribute("AppLineData_vt",         AppLineData_vt);
                req.setAttribute("e21EntranceDupCheck_vt", e21EntranceDupCheck_vt);
                
                dest = WebUtil.JspURL+"E/E21Entrance/E21EntranceChange.jsp";

            } else if( jobid.equals("change") ) {

                E21EntranceData e21EntranceData = new E21EntranceData();
                AppLineData_vt = new Vector();

                // �������ϱ� ����..
                e21EntranceData.AINF_SEQN = ainf_seqn;               // �������� �Ϸù�ȣ
                e21EntranceData.PERNR     = firstData.PERNR;         // �����ȣ
                e21EntranceData.SUBF_TYPE = "1";                     // �������ϱ� ��û���� (1)
                e21EntranceData.BEGDA     = box.get("BEGDA");        // ��û����
                e21EntranceData.FAMSA     = box.get("FAMSA");        // �������ڵ�����
                e21EntranceData.ATEXT     = box.get("ATEXT");        // �ؽ�Ʈ, 20����
                e21EntranceData.LNMHG     = box.get("LNMHG");        // ��(�ѱ�)
                e21EntranceData.FNMHG     = box.get("FNMHG");        // �̸�(�ѱ�)
                e21EntranceData.REGNO     = DataUtil.removeSeparate(box.get("REGNO"));    // �ֹε�Ϲ�ȣ
                e21EntranceData.ACAD_CARE = box.get("ACAD_CARE");    // �з�
                e21EntranceData.STEXT     = box.get("STEXT");        // �б������׽�Ʈ
                e21EntranceData.FASIN     = box.get("FASIN");        // �������
                e21EntranceData.ZPERNR    = firstData.ZPERNR;        // ��û�� ���(�븮��û, ���� ��û)
                e21EntranceData.UNAME     = user.empNo;              // ��û�� ����(�븮��û, ���� ��û)
                e21EntranceData.AEDTM     = DataUtil.getCurrentDate();  // ������(���糯¥)
				e21EntranceData.PROP_YEAR = box.get("PROP_YEAR"); // ��û�⵵(���г⵵)

                Logger.debug.println(this, e21EntranceData.toString());

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
                    appLine.APPL_BEGDA     = e21EntranceData.BEGDA;
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
                    rfc.change( firstData.PERNR, ainf_seqn , e21EntranceData );
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

                        ptMailBody.setProperty("UPMU_NAME" ,"�������ϱ�");          // ���� �̸�
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

                String url = "location.href = '" + WebUtil.ServletURL+"hris.E.E21Entrance.E21EntranceDetailSV?AINF_SEQN="+ainf_seqn+"" +
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
