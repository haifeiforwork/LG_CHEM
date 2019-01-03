/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR ����                                                  */
/*   2Depth Name  : ���ο���                                                    */
/*   Program Name : ���ο���/���̶����� �ؾ���ȸ                                */
/*   Program ID   : E11AnuulmentDetailSV                                        */
/*   Description  : ���ο��� �ؾ� ��ȸ�� �Ҽ� �ֵ��� �ϴ� Class                 */
/*   Note         :                                                             */
/*   Creation     : 2002-02-05  �ڿ���                                          */
/*   Update       : 2005-02-24  ������                                          */
/*                                                                              */
/********************************************************************************/

package servlet.hris.E.E11Personal;

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
import hris.common.rfc.*;

import hris.E.E11Personal.E11PersonalData;
import hris.E.E11Personal.rfc.*;

public class E11AnuulmentDetailSV extends EHRBaseServlet {

    private String UPMU_TYPE ="26";

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

            String               AINF_SEQN  = box.get("AINF_SEQN");
            E11PersonalData      detailData = new E11PersonalData();
            E11PersonalDetailRFC func1      = new E11PersonalDetailRFC();
            E11PersonalApplRFC   func       = new E11PersonalApplRFC();

            Vector E11PersonalData_vt = func.getPersList( box.get("AINF_SEQN") );

            E11PersonalData firstData  = (E11PersonalData)E11PersonalData_vt.get(0);

//          �븮 ��û �߰�
            PersonInfoRFC numfunc = new PersonInfoRFC();
            PersonData phonenumdata;
            phonenumdata = (PersonData)numfunc.getPersonInfo(firstData.PERNR);

            req.setAttribute("PersonData" , phonenumdata );

            //ó�� �� ���� �� ������
            String RequestPageName = box.get("RequestPageName");
            req.setAttribute("RequestPageName", RequestPageName);

            if( jobid.equals("first") ) {

                Vector detailData_vt = func1.getDetail( firstData.PERNR, firstData.PENT_TYPE, firstData.ENTR_DATE );
                if( detailData_vt.size() > 0 ) {
                    detailData  = (E11PersonalData)detailData_vt.get(0);
                }

                Logger.debug.println( this, firstData.toString() );
                Logger.debug.println( this, detailData.toString() );

                req.setAttribute("E11PersonalData", firstData);
                req.setAttribute("detailData",      detailData);

                dest = WebUtil.JspURL+"E/E11Personal/E11AnnulmentDetail.jsp";

            } else if( jobid.equals("delete") ) {

                Vector AppLineData_vt = new Vector();

                AppLineData  appLine   = new AppLineData();
                appLine.APPL_MANDT     = user.clientNo;
                appLine.APPL_BUKRS     = user.companyCode;
                appLine.APPL_PERNR     = firstData.PERNR;
                appLine.APPL_UPMU_TYPE = UPMU_TYPE;
                appLine.APPL_AINF_SEQN = box.get("AINF_SEQN");

// 2002.07.25.---------------------------------------------------------------------------
//              ��û�� ������ ���� ������ ���� �ʿ��� ������ ������ �����´�.
//              ����
                int rowcount = box.getInt("RowCount");
                for( int i = 0; i < rowcount; i++) {
                    AppLineData app = new AppLineData();
                    String      idx = Integer.toString(i);

                    // ������ �ڷ� �Է�(Web)
                    box.copyToEntity(app ,i);

                    AppLineData_vt.addElement(app);
                }
                Logger.debug.println(this, "AppLineData : " + AppLineData_vt.toString());
//              ��û�� ������ ���� ������ ���� �ʿ��� ������ ������ �����´�.
// 2002.07.25.---------------------------------------------------------------------------

                con             = DBUtil.getTransaction();
                AppLineDB appDB = new AppLineDB(con);

                if( appDB.canUpdate(appLine) ) {
                    appDB.delete(appLine);
                    func.delete( AINF_SEQN );
                    con.commit();

//                  2002.07.25. ��û�� ������ ���� ������.-----------------------------------------
                    appLine = (AppLineData)AppLineData_vt.get(0);
                    Properties ptMailBody = new Properties();
                    ptMailBody.setProperty("SServer",user.SServer);              // ElOffice ���� ����
                    ptMailBody.setProperty("from_empNo" ,user.empNo);            // �� �߼��� ���
                    ptMailBody.setProperty("to_empNo" ,appLine.APPL_APPU_NUMB);  // �� ������ ���

                    ptMailBody.setProperty("ename" ,phonenumdata.E_ENAME);       // (��)��û�ڸ�
                    ptMailBody.setProperty("empno" ,phonenumdata.E_PERNR);       // (��)��û�� ���

                    ptMailBody.setProperty("UPMU_NAME" ,"���ο���/���̶����� �ؾ�");  // ���� �̸�
                    ptMailBody.setProperty("AINF_SEQN" ,AINF_SEQN);              // ��û�� ����
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

                    try {
                        DraftDocForEloffice ddfe = new DraftDocForEloffice();
                        ElofficInterfaceData eof = ddfe.makeDocForRemove(AINF_SEQN ,user.SServer ,ptMailBody.getProperty("UPMU_NAME") 
                                ,firstData.PERNR ,appLine.APPL_APPU_NUMB);
                        
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
                        url = "location.href = '" + WebUtil.ServletURL+"hris.E.E11Personal.E11PersonalDetailSV';";
                   } // end if
                    //  ���� ������ ������ �������� �̵��ϱ� ���� ����

                    req.setAttribute("msg", msg);
                    req.setAttribute("url", url);
                    
                } else {
                    String msg = "msg005";
                    String url = "location.href = '" + WebUtil.ServletURL+"hris.E.E11Personal.E11AnnulmentDetailSV?AINF_SEQN="+AINF_SEQN+"';";
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
