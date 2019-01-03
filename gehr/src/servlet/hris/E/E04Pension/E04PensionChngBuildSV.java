/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR ����                                                  */
/*   2Depth Name  : ���ο��� �ڰݺ���                                           */
/*   Program Name : ���ο��� �ڰݺ������ ��û                                  */
/*   Program ID   : E04PensionChngBuildSV                                       */
/*   Description  : ���ο��� �ڰݺ�������� ��û�� �� �ֵ��� �ϴ� Class         */
/*   Note         :                                                             */
/*   Creation     : 2002-01-25  �ֿ�ȣ                                          */
/*   Update       : 2005-03-07  ������                                          */
/*                     2018/07/25 rdcamel ������                                                          */
/********************************************************************************/

package servlet.hris.E.E04Pension;

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
import hris.common.util.*;
import hris.common.rfc.*;
import hris.E.E04Pension.E04PensionChngData;
import hris.E.E04Pension.rfc.*;

public class E04PensionChngBuildSV extends EHRBaseServlet {

    private String UPMU_TYPE ="22";    // ���� ����Ÿ��(���ο��� �ڰݺ�����)
    private String UPMU_NAME = "���ο��� �ڰݺ���";

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        Connection con = null;

        try{
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
            
            //          @���������� 20151124
            String reSabunCk = user.e_representative;
            if (PERNR.equals("") || !reSabunCk.equals("Y")) {
                PERNR = user.empNo;
            } // end if
            Logger.debug.println(this, "[PERNR] = "+PERNR);
            // �븮 ��û �߰�
            PersonInfoRFC numfunc = new PersonInfoRFC();
            PersonData phonenumdata;
            phonenumdata = (PersonData)numfunc.getPersonInfo(PERNR);

            if( jobid.equals("first") ) {   //����ó�� ��û ȭ�鿡 ���°��.

                Vector AppLineData_vt = null;

                // �����ڸ���Ʈ
                AppLineData_vt = AppUtil.getAppVector( PERNR, UPMU_TYPE );
                Logger.debug.println(this, "AppLineData_vt : "+ AppLineData_vt.toString());

                req.setAttribute("AppLineData_vt",  AppLineData_vt);
                req.setAttribute("PersonData" , phonenumdata );
                req.setAttribute("PERNR" , PERNR );

                dest = WebUtil.JspURL+"E/E04Pension/E04PensionChngBuild.jsp";

            } else if( jobid.equals("create") ) {
//            	@����༺ ������ ������ ���� üũ 2015-08-25-------------------------------------------------------
            	Vector   AppLine_vt     = null;
            	String		appLineCheck = "Y";
            	AppLine_vt = AppUtil.getAppVector( PERNR, UPMU_TYPE );
            	
            	for (int i = 0; i < AppLine_vt.size(); i++){
            		AppLineData appLine = new AppLineData();
            		appLine = (AppLineData)AppLine_vt.get(i);
            		if(!appLine.APPL_APPU_TYPE.equals("01")){//���� ������ ������ ����
            			Logger.debug.println(this, "appLine.APPL_PERNR : " + appLine.APPL_PERNR.toString());
            			Logger.debug.println(this, "box.get(APPL_APPU_NUMBi) : " + box.get("APPL_APPU_NUMB"+i));
            			if(!appLine.APPL_PERNR.equals(box.get("APPL_APPU_NUMB"+i))){
            				appLineCheck = "N";
            			}
            		}
            	}
            	
            	if(appLineCheck.equals("N")){
            		String msg = "msg020";
                    req.setAttribute("msg", msg);
                    dest = WebUtil.JspURL+"common/caution.jsp";
                    Logger.debug.println(this, " destributed = " + dest);
                    printJspPage(req, res, dest);
                    return;
            	}
//@����༺ ������ ������ ���� üũ ��-------------------------------------------------------
                NumberGetNextRFC    func = new NumberGetNextRFC();
                E04PensionChngRFC   rfc  = new E04PensionChngRFC();
                E04PensionChngData  e04PensionChngData  = new E04PensionChngData();

                Vector AppLineData_vt = new Vector();
                String ainf_seqn      = func.getNumberGetNext();

                /////////////////////////////////////////////////////////////////////////////
                // ���ο��� �ڰݺ������ �Է�..
                e04PensionChngData.AINF_SEQN   = ainf_seqn;               // �������� �Ϸù�ȣ
                e04PensionChngData.PERNR       = PERNR;                   // �����ȣ
                e04PensionChngData.BEGDA       = box.get("BEGDA");        // ��û����
                e04PensionChngData.CHNG_TYPE   = box.get("CHNG_TYPE");    // �ڰݻ��׺����׸��ڵ�
                e04PensionChngData.CHNG_TEXT   = box.get("CHNG_TEXT");
                e04PensionChngData.CHNG_BEFORE = box.get("CHNG_BEFORE");  // �ڰݻ��׺���������Ÿ
                e04PensionChngData.CHNG_AFTER  = box.get("CHNG_AFTER");   // �ڰݻ��׺����ĵ���Ÿ
                e04PensionChngData.ZPERNR      = user.empNo;              // ��û�� ���(�븮��û, ���� ��û)
                e04PensionChngData.UNAME       = user.empNo;              // ��û�� ���(�븮��û, ���� ��û)
                e04PensionChngData.AEDTM       = DataUtil.getCurrentDate();  // ������(���糯¥)
                Logger.debug.println(this, e04PensionChngData.toString());

                // �������� ����..
                int rowcount = box.getInt("RowCount");
                for( int i = 0; i < rowcount; i++ ) {
                    AppLineData appLine = new AppLineData();
                    String      idx     = Integer.toString(i);

                    // ������ �ڷ� �Է�(Web)
                    box.copyToEntity(appLine ,i);
                    
                    appLine.APPL_MANDT     = user.clientNo;
                    appLine.APPL_BUKRS     = user.companyCode;
                    appLine.APPL_PERNR     = PERNR;
                    appLine.APPL_BEGDA     = e04PensionChngData.BEGDA;
                    appLine.APPL_AINF_SEQN = ainf_seqn;
                    appLine.APPL_UPMU_TYPE = UPMU_TYPE;

                    AppLineData_vt.addElement(appLine);
                }
                Logger.debug.println(this, AppLineData_vt.toString());

                con = DBUtil.getTransaction();

                AppLineDB appDB    = new AppLineDB(con);
                appDB.create(AppLineData_vt);
                rfc.build( PERNR, ainf_seqn , e04PensionChngData );
                con.commit();

                // ���� ������ ��� ,
                AppLineData appLine = (AppLineData)AppLineData_vt.get(0);

                Properties ptMailBody = new Properties();
                ptMailBody.setProperty("SServer",user.SServer);                 // ElOffice ���� ����
                ptMailBody.setProperty("from_empNo" ,user.empNo);               // �� �߼��� ���
                ptMailBody.setProperty("to_empNo" ,appLine.APPL_APPU_NUMB);     // �� ������ ���

                ptMailBody.setProperty("ename" ,phonenumdata.E_ENAME);          // (��)��û�ڸ�
                ptMailBody.setProperty("empno" ,phonenumdata.E_PERNR);          // (��)��û�� ���

                ptMailBody.setProperty("UPMU_NAME" ,UPMU_NAME);                 // ���� �̸�
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
                
                String url = "location.href = '" + WebUtil.ServletURL+"hris.E.E04Pension.E04PensionChngDetailSV?AINF_SEQN="+ainf_seqn+"';";
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
