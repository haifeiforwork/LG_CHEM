/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR ����                                                  */
/*   2Depth Name  : ���ο���                                                    */
/*   Program Name : ���ο���/���̶����� �ؾ��û                                */
/*   Program ID   : E11AnnulmentBuildSV                                         */
/*   Description  : ���ο���/���̶����� �ؾ��û�� �Ҽ� �ֵ��� �ϴ� Class       */
/*   Note         :                                                             */
/*   Creation     : 2002-02-05  �ڿ���                                          */
/*   Update       : 2005-03-07  ������                                          */
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

public class E11AnnulmentBuildSV extends EHRBaseServlet {

    private String UPMU_TYPE ="26";
    private String UPMU_NAME = "���ο���/���̶����� �ؾ�";
    
    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        Connection con = null;
        
        try{
            HttpSession session = req.getSession(false);
            
            WebUserData user = WebUtil.getSessionUser(req);
            
            String dest = "";
            String jobid = "";
            String PERNR;
            
            Box box = WebUtil.getBox(req);
            jobid = box.get("jobid");
            
            if( jobid.equals("") ){
                jobid = "first";
            }
            Logger.debug.println(this, "[jobid] = "+jobid + " [user] : "+user.toString());
            
            PERNR = box.get("PERNR");
            if (PERNR == null || PERNR.equals("")) {
                PERNR = user.empNo;
            } // end if

            // �븮 ��û �߰�
            PersonInfoRFC numfunc = new PersonInfoRFC();
            PersonData phonenumdata;
            phonenumdata = (PersonData)numfunc.getPersonInfo(PERNR);
            
            if( jobid.equals("first") ) {
                
                req.setAttribute("PersonData" , phonenumdata );
                
                E11PersonalData      detailData  = new E11PersonalData();
                E11PersonalDetailRFC func1       = new E11PersonalDetailRFC();
                
                Vector detailData_vt = func1.getDetail( PERNR, box.get("PENT_TYPE"), box.get("BEGDA") );
                if( detailData_vt.size() > 0 ) {
                    detailData  = (E11PersonalData)detailData_vt.get(0);
                }
                
                E11PersonalData data = new E11PersonalData();
                box.copyToEntity(data);
                data.PERNR = PERNR;
                req.setAttribute( "E11PersonalData", data );
                
                dest = WebUtil.JspURL+"E/E11Personal/E11AnnulmentBuild.jsp";
                
            } else if( jobid.equals("create") ) {
                
                NumberGetNextRFC seqn   = new NumberGetNextRFC();
                E11PersonalApplRFC func = new E11PersonalApplRFC();
                E11PersonalData data    = new E11PersonalData();
                
                Vector AppLineData_vt     = new Vector();
                Vector E11PersonalData_vt = new Vector();
                String ainf_seqn           = seqn.getNumberGetNext();
                
                box.copyToEntity(data);
                
                data.MANDT     = user.clientNo;
                data.PERNR     = PERNR;
                data.AINF_SEQN = ainf_seqn;
                data.APPL_TYPE = "2";  //�ؾ��û
                data.ZPERNR    = user.empNo;              // ��û�� ���(�븮��û, ���� ��û)
                data.UNAME     = user.empNo;              // ��û�� ���(�븮��û, ���� ��û)
                data.AEDTM     = DataUtil.getCurrentDate();  // ������(���糯¥)
                
                E11PersonalData_vt.addElement(data);
                
                int rowcount = box.getInt("RowCount");
                for( int i = 0; i < rowcount; i++) {
                    AppLineData appLine = new AppLineData();
                    String      idx     = Integer.toString(i);
                    
                    // ������ �ڷ� �Է�(Web)
                    box.copyToEntity(appLine ,i);
                    
                    appLine.APPL_MANDT     = user.clientNo;
                    appLine.APPL_BUKRS     = user.companyCode;
                    appLine.APPL_PERNR     = PERNR;
                    appLine.APPL_BEGDA     = data.BEGDA;
                    appLine.APPL_AINF_SEQN = ainf_seqn;
                    appLine.APPL_UPMU_TYPE = UPMU_TYPE;
                    
                    AppLineData_vt.addElement(appLine);
                }
                Logger.debug.println( this, E11PersonalData_vt.toString() );
                Logger.debug.println( this, "��������"+AppLineData_vt.toString() );
                
                con = DBUtil.getTransaction();
                AppLineDB appDB    = new AppLineDB(con);
                appDB.create(AppLineData_vt);
                func.build( ainf_seqn, E11PersonalData_vt );
                con.commit();

                // ���� ������ ��� ,
                AppLineData appLine = (AppLineData)AppLineData_vt.get(0);

                Properties ptMailBody = new Properties();
                ptMailBody.setProperty("SServer",user.SServer);              // ElOffice ���� ����
                ptMailBody.setProperty("from_empNo" ,user.empNo);            // �� �߼��� ���
                ptMailBody.setProperty("to_empNo" ,appLine.APPL_APPU_NUMB);  // �� ������ ���

                ptMailBody.setProperty("ename" ,phonenumdata.E_ENAME);       // (��)��û�ڸ�
                ptMailBody.setProperty("empno" ,phonenumdata.E_PERNR);       // (��)��û�� ���

                ptMailBody.setProperty("UPMU_NAME" ,UPMU_NAME);              // ���� �̸�
                ptMailBody.setProperty("AINF_SEQN" ,ainf_seqn);
                // ��û�� ����

                // �� ����
                StringBuffer sbSubject = new StringBuffer(512);

                sbSubject.append("[" + ptMailBody.getProperty("UPMU_NAME") + "] ");
                sbSubject.append(ptMailBody.getProperty("ename") +"���� ��û�ϼ̽��ϴ�.");
                
                ptMailBody.setProperty("subject" ,sbSubject.toString());

                MailSendToEloffic  maTe = new MailSendToEloffic(ptMailBody);

                String msg = "msg001";;
                String msg2 = "";

                if (!maTe.process()) {
                    msg2 = maTe.getMessage();
                } // end if

                try {
                    DraftDocForEloffice ddfe = new DraftDocForEloffice();
                    
                    ElofficInterfaceData eof = ddfe.makeDocContents(ainf_seqn ,user.SServer,ptMailBody.getProperty("UPMU_NAME"));

                    Vector vcElofficInterfaceData = new Vector();
                    vcElofficInterfaceData.add(eof);
                    req.setAttribute("vcElofficInterfaceData", vcElofficInterfaceData);
                    dest = WebUtil.JspURL+"common/ElOfficeInterface.jsp";
                } catch (Exception e) {
                    dest = WebUtil.JspURL+"common/msg.jsp";
                    msg2 = msg2 + "\\n" + " Eloffic ���� ����" ;
                } // end try                  

                String url = "location.href = '" + WebUtil.ServletURL+"hris.E.E11Personal.E11AnuulmentDetailSV?AINF_SEQN="+ainf_seqn+"';";
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
