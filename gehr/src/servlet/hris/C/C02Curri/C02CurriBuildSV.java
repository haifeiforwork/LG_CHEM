/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR ����                                                  */
/*   2Depth Name  : �������� �ȳ�/��û                                          */
/*   Program Name : �������� ��û                                               */
/*   Program ID   : C02CurriBuildSV                                             */
/*   Description  : ���� ��û�� �Ҽ� �ֵ��� �ϴ� Class                          */
/*   Note         :                                                             */
/*   Creation     : 2002-01-15  �ڿ���                                          */
/*   Update       : 2005-03-07  ������                                          */
/*                      ������� ����.                                                        */
/********************************************************************************/

package servlet.hris.C.C02Curri;

import java.util.Properties;
import java.sql.*;
import java.util.Vector;
import javax.servlet.http.*;

import com.sns.jdf.*;
import com.sns.jdf.db.*;
import com.sns.jdf.util.*;
import com.sns.jdf.servlet.*;

import hris.common.*;
import hris.common.db.*;
import hris.common.rfc.*;

import hris.C.C02Curri.C02CurriApplData;
import hris.C.C02Curri.C02CurriInfoData;
import hris.C.C02Curri.rfc.*;

public class C02CurriBuildSV extends EHRBaseServlet {
    
    private String UPMU_TYPE ="08";
    private String UPMU_NAME = "��������";
    
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
            
            //ó�� �� ���� �� ������
            String RequestPageName = box.get("RequestPageName");
            req.setAttribute("RequestPageName", RequestPageName);
            
            PERNR = box.get("PERNR");
            if (PERNR == null || PERNR.equals("")) {
                PERNR = user.empNo;
            } // end if

            // �븮 ��û �߰�
            PersonInfoRFC numfunc = new PersonInfoRFC();
            PersonData phonenumdata;
            phonenumdata    =   (PersonData)numfunc.getPersonInfo(PERNR);
            
            req.setAttribute("PERNR" , PERNR );
            req.setAttribute("PersonData" , phonenumdata );
            
            if( jobid.equals("first") ) {
                
                C02CurriInfoData key = new C02CurriInfoData();
                box.copyToEntity(key);
                req.setAttribute("C02CurriInfoKey", key);
                
                C02CurriInfoData data = new C02CurriInfoData();
                box.copyToEntity(data);
                
                C02CurriPersonRFC func = new C02CurriPersonRFC();
                Vector C02CurriPersonData_vt = func.getCurriPerson( PERNR );
                Logger.debug.println(this, data.toString() );
                Logger.debug.println(this, C02CurriPersonData_vt.toString() );
                
                // ��û�Ϸ��� ������ �Ⱓ�� �ߺ��Ǵ� ������ �ִ����� üũ�Ѵ�.
                C02CurriGetFlagRFC func_check = new C02CurriGetFlagRFC();
                String checkFlag  = func_check.check( PERNR, data.BEGDA, data.ENDDA, data.CHAID );
                
                Logger.debug.println(this, "checkFlag = " + checkFlag );
                
                req.setAttribute("checkFlag", checkFlag);
                // ��û�Ϸ��� ������ �Ⱓ�� �ߺ��Ǵ� ������ �ִ����� üũ�Ѵ�.
                
                req.setAttribute("C02CurriInfoData", data);
                req.setAttribute("C02CurriPersonData_vt", C02CurriPersonData_vt);
                
                dest = WebUtil.JspURL+"C/C02Curri/C02CurriBuild.jsp";
            } else if( jobid.equals("create") ) {
                
                NumberGetNextRFC seqn  = new NumberGetNextRFC();
                C02CurriApplRFC  rfc   = new C02CurriApplRFC();
                Vector AppLineData_vt  = new Vector();
                String ainf_seqn       = seqn.getNumberGetNext();
                String date            = DataUtil.getCurrentDate();
                
                Vector C02CurriApplData_vt    = new Vector();
                C02CurriApplData data         = new C02CurriApplData();
                /**
                 C02CurriInfoRFC func          = new C02CurriInfoRFC();
                 
                 Vector ret = func.getCurriInfo( box.get("GWAID"), box.get("CHAID") );
                 
                 Vector C02CurriEventData_vt = (Vector)ret.get(1);
                 C02CurriEventData eventData = (C02CurriEventData)C02CurriEventData_vt.get(0);
                 **/
                box.copyToEntity(data);
                
                data.MANDT     = user.clientNo;
                data.PERNR     = PERNR;
                data.BEGDA     = date;
                data.AINF_SEQN = ainf_seqn;
                data.GWAID     = box.get("GWAID");
                data.GWAJUNG   = box.get("GWAJUNG");
                data.GBEGDA    = box.get("BEGDA");
                data.GENDDA    = box.get("ENDDA");
                data.CHASU     = box.get("CHASU");
                data.CHAID     = box.get("CHAID");
                data.ENAME     = box.get("ENAME");
                data.ORGTX     = box.get("ORGTX");
                data.TITEL     = box.get("TITEL");
                data.TRFGR     = box.get("TRFGR");
                data.TRFST     = box.get("TRFST");
                data.VGLST     = box.get("VGLST");
                data.TEXT      = box.get("TEXT");
                data.ZPERNR    = user.empNo;                 // ��û�� ���(�븮��û, ���� ��û)
                data.UNAME     = user.empNo;                 // ��û�� ���(�븮��û, ���� ��û)
                data.AEDTM     = DataUtil.getCurrentDate();  // ������(���糯¥)
                
                data.P_AINF_SEQN = ainf_seqn;  //�������� �Ϸù�ȣ
                data.P_PERNR     = PERNR;
                data.P_CHAID     = box.get("CHAID");;      
                data.P_FDATE     = box.get("SDATE");
                data.P_TDATE     = box.get("EDATE");
                
                C02CurriApplData_vt.addElement(data);
                
                int rowcount = box.getInt("RowCount");
                for( int i = 0; i < rowcount; i++) {
                    AppLineData appLine = new AppLineData();
                    String      idx     = Integer.toString(i);
                    
                    // ������ �ڷ� �Է�(Web)
                    box.copyToEntity(appLine ,i);

                    appLine.APPL_MANDT     = user.clientNo;
                    appLine.APPL_BUKRS     = user.companyCode;
                    appLine.APPL_PERNR     = PERNR;
                    appLine.APPL_BEGDA     = date;
                    appLine.APPL_AINF_SEQN = ainf_seqn;
                    appLine.APPL_UPMU_TYPE = UPMU_TYPE;

                    AppLineData_vt.addElement(appLine);
                }
                Logger.debug.println( this, C02CurriApplData_vt.toString() );
                Logger.debug.println( this, "�������� : "+AppLineData_vt.toString() );
                
                con = DBUtil.getTransaction();
                
                AppLineDB appDB    = new AppLineDB(con);
                appDB.create(AppLineData_vt);
                rfc.build( data.P_AINF_SEQN, data.P_CHAID, data.P_PERNR, data.P_FDATE, data.P_TDATE, C02CurriApplData_vt );
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

                String msg = "msg001";
                String msg2 = "";

                if (!maTe.process()) {
                    msg2 = maTe.getMessage();
                } // end if
                
                if (user.loginPlace != null && !user.loginPlace.equals("elearning")) {
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
                } else {
                    dest = WebUtil.JspURL+"common/msg.jsp";
                } // end if
                
                String url = "location.href = '" + WebUtil.ServletURL+"hris.C.C02Curri.C02CurriDetailSV?AINF_SEQN="+ainf_seqn+"';";
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
