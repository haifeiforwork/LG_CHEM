/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR ����                                                  */
/*   2Depth Name  : �������ϱ�                                                  */
/*   Program Name : �������ϱ� ��û                                             */
/*   Program ID   : E21EntranceBuildSV                                          */
/*   Description  : �������ϱ��� ��û�� �� �ֵ��� �ϴ� Class                    */
/*   Note         :                                                             */
/*   Creation     : 2002-01-03  �赵��                                          */
/*   Update       : 2005-03-07  ������                                          */
/*                     2018/07/25 rdcamel ������                                                         */
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
import hris.common.rfc.NumberGetNextRFC;
import hris.common.rfc.PersonInfoRFC;
import hris.common.util.AppUtil;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.sql.Connection;
import java.util.Properties;
import java.util.Vector;

public class E21EntranceBuildSV extends EHRBaseServlet {

    private String UPMU_TYPE ="05";    // ���� ����Ÿ��(�������ϱ�)
    private String UPMU_NAME = "�������ϱ�";

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        Connection con = null;

        try{
            WebUserData user = WebUtil.getSessionUser(req);

            String dest = "";
            String jobid = "";
            String PERNR;
            String msgFLAG = "";
            String msgTEXT = "";

            Box box = WebUtil.getBox(req);
            jobid = box.get("jobid", "first");

            Logger.debug.println(this, "[jobid] = "+jobid + " [user] : "+user.toString());

            PERNR = box.get("PERNR", user.empNo);

            // �븮 ��û �߰�
            PersonInfoRFC numfunc = new PersonInfoRFC();
            PersonData phonenumdata;
            phonenumdata = (PersonData)numfunc.getPersonInfo(PERNR);

            if( jobid.equals("first") ) {   //����ó�� ��û ȭ�鿡 ���°��.

                Vector AppLineData_vt = null;

                req.setAttribute("PERNR" , PERNR );
                req.setAttribute("PersonData" , phonenumdata );

                //*********** ��������Ʈ(�ڳ�)�� �����Ѵ�. *********************************
                A04FamilyDetailRFC  rfc_family = new A04FamilyDetailRFC();
                A04FamilyDetailData data       = new A04FamilyDetailData();

                Vector a04FamilyDetailData_vt = new Vector();
                box.put("I_PERNR", PERNR);
                Vector temp_vt                = rfc_family.getFamilyDetail(box) ;
                Vector e21EntranceDupCheck_vt = (new E21EntranceDupCheckRFC()).getCheckList( PERNR );

                for( int i = 0 ; i < temp_vt.size() ; i++ ) {
                    data = (A04FamilyDetailData)temp_vt.get(i);

                    if( data.SUBTY.equals("2") ) {
                        a04FamilyDetailData_vt.addElement(data);
                    }
                }
                //*********** ��������Ʈ(�ڳ�)�� �����Ѵ�. *********************************

                if( a04FamilyDetailData_vt.size() == 0 ) {
                    //String msg = "�������ϱ��� ��û�� �ڳడ �����ϴ�.";
                    msgFLAG = "C";
                    msgTEXT = "�������ϱ��� ��û�� �ڳడ �����ϴ�.";
                }
                
                // �ڳฮ��Ʈ
                Logger.debug.println(this, "a04FamilyDetailData_vt : "+ a04FamilyDetailData_vt.toString());
                req.setAttribute("a04FamilyDetailData_vt", a04FamilyDetailData_vt);
                
                // �����ڸ���Ʈ
                AppLineData_vt = AppUtil.getAppVector( PERNR, UPMU_TYPE );
                Logger.debug.println(this, "AppLineData_vt : "+ AppLineData_vt.toString());
                req.setAttribute("msgFLAG", msgFLAG);
                req.setAttribute("msgTEXT", msgTEXT);
                req.setAttribute("AppLineData_vt",         AppLineData_vt);
                req.setAttribute("e21EntranceDupCheck_vt", e21EntranceDupCheck_vt);
                
                dest = WebUtil.JspURL+"E/E21Entrance/E21EntranceBuild.jsp";
                

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
                // if( ! user.e_oversea.equals("X") ){  // �ؿܱٹ��ڰ� �ƴҰ�츸
                /**** ��û�ȱݾ��� �Աݵ� ���������� �ִ��� üũ ***************************************/
                hris.common.rfc.AccountInfoRFC accountInfoRFC = new hris.common.rfc.AccountInfoRFC();
                if( ! accountInfoRFC.hasPersAccount(PERNR) ){
                    String msg = "msg006";
                    req.setAttribute("msg", msg);
                    dest = WebUtil.JspURL+"common/caution.jsp";
                    Logger.debug.println(this, " destributed = " + dest);
                    printJspPage(req, res, dest);
                    return;
                }
                /**** ��û�ȱݾ��� �Աݵ� ���������� �ִ��� üũ ***************************************/
                // }

                NumberGetNextRFC func            = new NumberGetNextRFC();
                E21EntranceRFC   rfc             = new E21EntranceRFC();
                E21EntranceData  e21EntranceData = new E21EntranceData();

                Vector AppLineData_vt = new Vector();
                String ainf_seqn      = func.getNumberGetNext();

                /////////////////////////////////////////////////////////////////
                // �������ϱ� ����..
                e21EntranceData.AINF_SEQN = ainf_seqn;             // �������� �Ϸù�ȣ
                e21EntranceData.PERNR     = PERNR;                 // �����ȣ
                e21EntranceData.SUBF_TYPE = "1";                   // �������ϱ� ��û���� (1)
                e21EntranceData.BEGDA     = box.get("BEGDA");      // ��û����
                e21EntranceData.FAMSA     = box.get("FAMSA");      // �������ڵ�����
                e21EntranceData.ATEXT     = box.get("ATEXT");      // �ؽ�Ʈ, 20����
                e21EntranceData.LNMHG     = box.get("LNMHG");      // ��(�ѱ�)
                e21EntranceData.FNMHG     = box.get("FNMHG");      // �̸�(�ѱ�)
                e21EntranceData.REGNO     = DataUtil.removeSeparate(box.get("REGNO"));  // �ֹε�Ϲ�ȣ
                e21EntranceData.ACAD_CARE = box.get("ACAD_CARE");  // �з�
                e21EntranceData.STEXT     = box.get("STEXT");      // �б������׽�Ʈ
                e21EntranceData.FASIN     = box.get("FASIN");      // �������
                e21EntranceData.ZPERNR    = user.empNo;            // ��û�� ���(�븮��û, ���� ��û)
                e21EntranceData.UNAME     = user.empNo;            // ��û�� ���(�븮��û, ���� ��û)
                e21EntranceData.AEDTM     = DataUtil.getCurrentDate();  // ������(���糯¥)
				e21EntranceData.PROP_YEAR = box.get("PROP_YEAR"); // ��û�⵵(���г⵵)

                Logger.debug.println(this, e21EntranceData.toString());

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
                    appLine.APPL_BEGDA     = e21EntranceData.BEGDA;
                    appLine.APPL_AINF_SEQN = ainf_seqn;
                    appLine.APPL_UPMU_TYPE = UPMU_TYPE;

                    AppLineData_vt.addElement(appLine);
                }
                Logger.debug.println(this, AppLineData_vt.toString());

                con = DBUtil.getTransaction();

                AppLineDB appDB    = new AppLineDB(con);
                appDB.create(AppLineData_vt);
                rfc.build( PERNR, ainf_seqn , e21EntranceData );
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
                
                String url = "location.href = '" + WebUtil.ServletURL+"hris.E.E21Entrance.E21EntranceDetailSV?AINF_SEQN="+ainf_seqn+"';";
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
