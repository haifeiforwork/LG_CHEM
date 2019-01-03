/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR ����                                                  */
/*   2Depth Name  : �����ڱ� ��ȯ��û                                           */
/*   Program Name : �����ڱ� ��ȯ��û                                           */
/*   Program ID   : E06RehouseBuildSV                                           */
/*   Description  : �����ڱ� ��ȯ��û�� �Ҽ� �ֵ��� �ϴ� Class                  */
/*   Note         :                                                             */
/*   Creation     : 2001-12-26  ������                                          */
/*   Update       : 2005-03-07  ������                                          */
/*                     2018/07/25 rdcamel ������                                                          */
/********************************************************************************/

package servlet.hris.E.E06Rehouse;

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
import hris.common.util.*;
import hris.E.E05House.*;
import hris.E.E05House.rfc.*;
import hris.E.E06Rehouse.E06RehouseData;
import hris.E.E06Rehouse.E06RehouseKey;
import hris.E.E06Rehouse.rfc.*;

public class E06RehouseBuildSV extends EHRBaseServlet {

    private String UPMU_TYPE ="13";
    private String UPMU_NAME = "�����ڱ� ��ȯ";

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        Connection con = null;

        try{
            HttpSession session = req.getSession(false);
            WebUserData user    = (WebUserData)session.getAttribute("user");

            String dest   = "";
            String jobid  = "";
            String PERNR;

            Box box = WebUtil.getBox(req);

            jobid = box.get("jobid");
            Vector   AppLineData_vt = new Vector();
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

            req.setAttribute("PERNR" , PERNR );
            req.setAttribute("PersonData" , phonenumdata );

            Vector PersLoanData_vt        = new Vector();
            E06RehouseData e06RehouseData = new E06RehouseData();
            E06RehouseKey  key            = new E06RehouseKey();
            E05PersLoanRFC func2          = new E05PersLoanRFC();
            E06RehouseRFC  func1          = null;

            PersLoanData_vt = func2.getPersLoan(PERNR);

            Logger.debug.println(this,"PersLoanData_vt"+PersLoanData_vt.toString());

            if( jobid.equals("first") || jobid.equals("second") ) {

                if( jobid.equals("first") ) {           //����ó�� ��û ȭ�鿡 ���°��.

                    if( PersLoanData_vt.size() > 0 ) {
                        E05PersLoanData persLoanData = (E05PersLoanData)PersLoanData_vt.get(0);

                        key.I_PERNR     = PERNR;
                        key.I_DATE      = DataUtil.getCurrentDate();
                        key.I_LOAN_CODE = persLoanData.DLART;
                        AppLineData_vt  = AppUtil.getAppVector( PERNR, UPMU_TYPE );
                    }

                } else if( jobid.equals("second") ) {

                    key.I_PERNR     = PERNR;
                    key.I_DATE      = box.get("I_DATE");
                    key.I_LOAN_CODE = box.get("I_LOAN_CODE");

                    int RowCount = box.getInt("RowCount");
                    for( int i = 0; i < RowCount; i++) {
                        AppLineData appLine = new AppLineData();
                        String      idx     = Integer.toString(i);

                        // ������ �ڷ� �Է�(Web)
                        box.copyToEntity(appLine ,i);

                        AppLineData_vt.addElement(appLine);
                    }
                    Logger.debug.println(this, AppLineData_vt.toString());
                }

                dest = WebUtil.JspURL+"E/E06Rehouse/E06RehouseBuild.jsp";

                func1          = new E06RehouseRFC();
                if( PersLoanData_vt.size() > 0 ) {
                    e06RehouseData = (E06RehouseData)func1.getBaseLoanData(key);
                }
                req.setAttribute("e06RehouseKey",   key);
                req.setAttribute("AppLineData_vt",  AppLineData_vt);
                req.setAttribute("PersLoanData_vt", PersLoanData_vt);
                req.setAttribute("e06RehouseData",  e06RehouseData);

            } else if( jobid.equals("create") ) { // DB insert �����κ�
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
                NumberGetNextRFC     func        = new NumberGetNextRFC();
                E06RehouseData       rehouseData = new E06RehouseData();
                E06RehouseRequestRFC rfc         = new E06RehouseRequestRFC();
                String ainf_seqn      = func.getNumberGetNext();
                Vector rehouseData_vt = new Vector();

                key.I_PERNR     = PERNR;
                key.I_DATE      = box.get("I_DATE");
                key.I_LOAN_CODE = box.get("I_LOAN_CODE");

                func1 = new E06RehouseRFC();
                rehouseData = (E06RehouseData)func1.getBaseLoanData(key);
                rehouseData.MANDT     = user.clientNo;
                rehouseData.PERNR     = PERNR;
                rehouseData.AINF_SEQN = ainf_seqn;
                rehouseData.DLART     = key.I_LOAN_CODE;
                rehouseData.REPT_DATE = key.I_DATE;
                rehouseData.BEGDA     = box.get("BEGDA");
                rehouseData.DATBW     = DataUtil.removeStructur(rehouseData.DATBW,"-");
                rehouseData.ZPERNR    = user.empNo;              // ��û�� ���(�븮��û, ���� ��û)
                rehouseData.UNAME     = user.empNo;              // ��û�� ���(�븮��û, ���� ��û)
                rehouseData.AEDTM     = DataUtil.getCurrentDate();  // ������(���糯¥)

                // 2002.06.11. �����ڱ����ڸ� ���� �� ��ȯ���ݰ� ������ �����ڱ����ڸ� ���� �հ��� ���ڸ��� '0'�� �ƴϸ�,
                // �հ谡 '0'�� �ǵ��� �����ڱ����ڿ��� ������ �Ͽ�, �հ��� ���ڸ��� '0'���� �����.  ������ : �赵��
                double total_amnt = Double.parseDouble( rehouseData.TOTL_AMNT );
                double intr_amnt  = Double.parseDouble( rehouseData.INTR_AMNT );
                double mod_value  = 0.0;

                mod_value = total_amnt % 10;

                if( mod_value > 0 ) {
                    total_amnt = total_amnt - mod_value;  // ��
                    intr_amnt  = intr_amnt  - mod_value;  // ����

                    rehouseData.TOTL_AMNT = Double.toString(total_amnt);
                    rehouseData.INTR_AMNT  = Double.toString(intr_amnt);
                }
                // 2002.06.11. �����ڱ����ڸ� ���� �� ��ȯ���ݰ� ������ �����ڱ����ڸ� ���� �հ��� ���ڸ��� '0'�� �ƴϸ�,
                // �հ谡 '0'�� �ǵ��� �����ڱ����ڿ��� ������ �Ͽ�, �հ��� ���ڸ��� '0'���� �����.  ������ : �赵��

                rehouseData.RPAY_AMNT    = Double.toString(Double.parseDouble(rehouseData.RPAY_AMNT)/100.0    );
                rehouseData.INTR_AMNT    = Double.toString(Double.parseDouble(rehouseData.INTR_AMNT)/100.0    );
                rehouseData.TOTL_AMNT    = Double.toString(Double.parseDouble(rehouseData.TOTL_AMNT)/100.0    );
                rehouseData.DARBT        = Double.toString(Double.parseDouble(rehouseData.DARBT)/100.0    );
                rehouseData.ALREADY_AMNT = Double.toString(Double.parseDouble(rehouseData.ALREADY_AMNT)/100.0    );

                int rowcount = box.getInt("RowCount");
                for( int i = 0; i < rowcount; i++) {
                    AppLineData appLine = new AppLineData();
                    String      idx     = Integer.toString(i);

                    // ������ �ڷ� �Է�(Web)
                    box.copyToEntity(appLine ,i);

                    appLine.APPL_MANDT     = user.clientNo;
                    appLine.APPL_BUKRS     = user.companyCode;
                    appLine.APPL_PERNR     = PERNR;
                    appLine.APPL_BEGDA     = box.get("BEGDA");
                    appLine.APPL_AINF_SEQN = ainf_seqn;
                    appLine.APPL_UPMU_TYPE = UPMU_TYPE;

                    AppLineData_vt.addElement(appLine);
                }

                con = DBUtil.getTransaction();

                AppLineDB appDB      = new AppLineDB(con);

                Logger.debug.println(this,"AppLineData_vt : "+AppLineData_vt.toString());

                rehouseData_vt.addElement(rehouseData);
                Logger.debug.println(this, "�����ڱ� ��ȯ��û rehouseData_vt ="+rehouseData_vt.toString());

                appDB.create(AppLineData_vt);
                rfc.build( ainf_seqn , rehouseData_vt );
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

                String url = "location.href = '" + WebUtil.ServletURL+"hris.E.E06Rehouse.E06RehouseDetailSV?AINF_SEQN="+ainf_seqn+"';";
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
