/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR ����                                                  */
/*   2Depth Name  : ���ο���                                                    */
/*   Program Name : ���ο��� ��û                                               */
/*   Program ID   : E10PersonalBuildSV                                          */
/*   Description  : ���ο����� ��û�� �� �ֵ��� �ϴ� Class                      */
/*   Note         :                                                             */
/*   Creation     : 2002-02-03  ������                                          */
/*   Update       : 2005-03-07  ������                                          */
/*                      2018/07/25 rdcamel ������                                                         */
/********************************************************************************/

package servlet.hris.E.E10Personal;

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
import hris.E.E11Personal.*;
import hris.E.E10Personal.E10PentionMoneyData;
import hris.E.E10Personal.E10PersonalData;
import hris.E.E10Personal.rfc.*;
import hris.E.E11Personal.rfc.*;

public class E10PersonalBuildSV extends EHRBaseServlet {

    private String UPMU_TYPE ="02";   // ���� ����Ÿ��(���ο���)
    private String UPMU_NAME = "���ο���";

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        Connection con = null;

        try{
            WebUserData user = WebUtil.getSessionUser(req);

            String dest = "";
            String jobid = "";
            String PERNR;

            String cautionMsg = "";

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

                E10PentionMoneyData  data_money_1 = new E10PentionMoneyData();
                E10PentionMoneyData  data_money_2 = new E10PentionMoneyData();
                E10PersonalData      data         = new E10PersonalData();
                E11PersonalDetailRFC func1        = new E11PersonalDetailRFC();
                E11PersonalData      edata        = new E11PersonalData();
                Vector AppLineData_vt = null;

                req.setAttribute("PersonData" , phonenumdata );
                data.PERNR = PERNR;

                Vector  data_money_vt      = new Vector();
                Vector  E11PersonalData_vt = func1.getDetail(PERNR, "", "");
                boolean flag               = true;

                for( int i=0; i< E11PersonalData_vt.size();i++) {
                    edata = (E11PersonalData)E11PersonalData_vt.get(i);
                    Logger.debug.println(this, "edata : "+ edata.toString());

                    //  2002.10.11. ����, �ؾ������쿡�� �Ǵٽ� ��û ������. - ���ǰ��
                    if(edata.STATUS.equals("������")){
                        flag = false;
                        break;
                    }
                }

                dest = WebUtil.JspURL+"E/E10Personal/E10PersonalBuild.jsp";

                // ���ο��� �������� ��ư���.
                data_money_vt  = (new E10PentionMoneyRFC()).getPentionMoney( user.companyCode, DataUtil.getCurrentDate(), "0001" );

                if( data_money_vt.size() > 0 ) {

                    // �ӿ�, ��������, ��������, �����(�ڹ�/��), ������� ��� ���ο��� ��û�Ұ�. 2003.5.23.mkbae.
                    int num1 = Integer.parseInt(phonenumdata.E_PERSK);
                    if( num1==11 || num1==12 || num1==13 || num1==14 || num1==24 ) {

                        cautionMsg = "��û ����� �ƴմϴ�. ����ڿ��� ���� �ٶ��ϴ�.";
                    }

                    data_money_1   = (E10PentionMoneyData)data_money_vt.get(0);

                    data.PERL_AMNT = Double.toString( Double.parseDouble(data_money_1.DEDUCT) - Double.parseDouble(data_money_1.ASSIST) );
                    data.CMPY_AMNT = data_money_1.ASSIST;
                    data.MNTH_AMNT = Double.toString( Double.parseDouble(data_money_1.DEDUCT) + Double.parseDouble(data_money_1.DISCOUNT) );
                    data.BEGDA     = DataUtil.getCurrentDate();
                    data.ENTR_TERM = "10";
                } else {
                    cautionMsg = "���ο��� �����ݾ��� �����ϴ�.";
                }

                // ���̶����� �������� ��ư���.
                data_money_vt  = null;
                data_money_vt  = (new E10PentionMoneyRFC()).getPentionMoney( user.companyCode, DataUtil.getCurrentDate(), "0002" );

                if( data_money_vt.size() > 0 ) {
                    data_money_2     = (E10PentionMoneyData)data_money_vt.get(0);
                } else {
                    Logger.debug.println(this, "���̶����� �����ݾ��� �����ϴ�.");
                }

                Logger.debug.println(this, "data : "+ data.toString());
                Logger.debug.println(this, "���̶����� �����ݾ� : "+ data_money_2.toString());

                AppLineData_vt = AppUtil.getAppVector( PERNR, UPMU_TYPE );

                Logger.debug.println(this, "AppLineData_vt : "+ AppLineData_vt.toString());

                req.setAttribute("data_money_2",    data_money_2);
                req.setAttribute("E10PersonalData", data);
                req.setAttribute("E11PersonalData", edata);
                req.setAttribute("AppLineData_vt",  AppLineData_vt);

                if( !flag ) {
                    cautionMsg = "��û�ڰ��� �����ϴ�.";
                }
                req.setAttribute("cautionMsg",      cautionMsg);

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

                NumberGetNextRFC   func = new NumberGetNextRFC();
                E10PersonalApplRFC rfc  = new E10PersonalApplRFC();
                E10PersonalData    data = new E10PersonalData();

                Vector AppLineData_vt = new Vector();
                Vector personal_vt    = new Vector();
                String ainf_seqn      = func.getNumberGetNext();

                data.MANDT     = user.companyCode;
                data.PERNR     = DataUtil.fixEndZero(PERNR ,8);
                data.BEGDA     = box.get("BEGDA");
                data.AINF_SEQN = ainf_seqn;
                data.APPL_TYPE = "1";
                data.PENT_TYPE = box.get("PENT_TYPE");
                data.BANK_TYPE = box.get("BANK_TYPE");
                data.ENTR_DATE = box.get("ENTR_DATE");
                data.ENTR_TERM = DataUtil.fixEndZero(box.get("ENTR_TERM"),1);
                data.MNTH_AMNT = box.get("MNTH_AMNT");
                data.PERL_AMNT = box.get("PERL_AMNT");
                data.CMPY_AMNT = box.get("CMPY_AMNT");
                data.ZPERNR    = user.empNo;              // ��û�� ���(�븮��û, ���� ��û)
                data.UNAME     = user.empNo;              // ��û�� ���(�븮��û, ���� ��û)
                data.AEDTM     = DataUtil.getCurrentDate();  // ������(���糯¥)

                personal_vt.addElement(data);

                Logger.debug.println(this, personal_vt.toString());

                // �������� ����..
                int rowcount = box.getInt("RowCount");
                for( int i = 0; i < rowcount; i++ ) {
                    AppLineData appLine = new AppLineData();
                    String      idx     = Integer.toString(i);

                    // ������ �ڷ� �Է�(Web)
                    box.copyToEntity(appLine ,i);

                    appLine.APPL_MANDT     = user.clientNo;
                    appLine.APPL_BUKRS     = user.companyCode;
                    appLine.APPL_PERNR     = DataUtil.fixEndZero(PERNR,8);
                    appLine.APPL_BEGDA     = box.get("BEGDA");
                    appLine.APPL_AINF_SEQN = ainf_seqn;
                    appLine.APPL_UPMU_TYPE = UPMU_TYPE;

                    AppLineData_vt.addElement(appLine);
                }
                Logger.debug.println(this, AppLineData_vt.toString());

                con = DBUtil.getTransaction();

                AppLineDB appDB = new AppLineDB(con);
                appDB.create(AppLineData_vt);
                rfc.build(ainf_seqn, personal_vt);
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
                
                String url = "location.href = '" + WebUtil.ServletURL+"hris.E.E10Personal.E10PersonalDetailSV?AINF_SEQN="+ainf_seqn+"';";
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
