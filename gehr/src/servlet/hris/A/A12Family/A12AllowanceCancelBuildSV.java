/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR ����                                                  */
/*   2Depth Name  : ��������                                                    */
/*   Program Name : ������������ ��û                                         */
/*   Program ID   : A12AllowanceCancelBuildSV                                   */
/*   Description  : ������������ ��û�� �� �ֵ��� �ϴ� Class                  */
/*   Note         :                                                             */
/*   Creation     : 2002-10-31  �赵��                                          */
/*   Update       : 2005-03-07  ������                                          */
/*                                                                              */
/********************************************************************************/

package servlet.hris.A.A12Family;
  
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
import hris.A.A12Family.A12FamilyBuyangData;
import hris.A.A12Family.rfc.*;

public class A12AllowanceCancelBuildSV extends EHRBaseServlet {

    private String UPMU_TYPE ="29";   // ���� ����Ÿ��(����������)
    private String UPMU_NAME = "����������";
    
    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        Connection con = null;
        
        try{
            HttpSession session = req.getSession(false); 
            
            WebUserData user = WebUtil.getSessionUser(req);
            
            String dest = "";
            String jobid = "";
            String subty = "";
            String objps = "";
            String PERNR;
            
            Box box = WebUtil.getBox(req);
            jobid = box.get("jobid");
            subty = box.get("SUBTY");
            objps = box.get("OBJPS");
            
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

            // XxxDetailSV.java �� XxxDetail.jsp �� '���/��ȭ��' ��ư Ȱ��ȭ ���θ� �����ִ� �κ�            
            String ThisJspName = box.get("ThisJspName");
            req.setAttribute("ThisJspName", ThisJspName);
            //  XxxDetailSV.java �� XxxDetail.jsp �� '���/��ȭ��' ��ư Ȱ��ȭ ���θ� �����ִ� �κ� 
            
            if( jobid.equals("first") ) {           //����ó�� ��û ȭ�鿡 ���°��.

                req.setAttribute("PERNR" , PERNR );
                req.setAttribute("PersonData" , phonenumdata );
                
                A12FamilyListRFC  rfc_list             = new A12FamilyListRFC();
                Vector            a12FamilyListData_vt = null;
                Vector            AppLineData_vt       = null;
                
                // ���������� ��û�� ����
                a12FamilyListData_vt = rfc_list.getFamilyList(PERNR, subty, objps);
                
                // �����ڸ���Ʈ
                AppLineData_vt       = AppUtil.getAppVector( PERNR, UPMU_TYPE );
                
                Logger.debug.println(this, "���������� ��û : " + a12FamilyListData_vt.toString());
                Logger.debug.println(this, "���� : " + AppLineData_vt.toString());
                
                req.setAttribute("a12FamilyListData_vt", a12FamilyListData_vt);
                req.setAttribute("AppLineData_vt",  AppLineData_vt);
                
                dest = WebUtil.JspURL+"A/A12Family/A12AllowanceCancelBuild.jsp";
                
            } else if( jobid.equals("create") ) {       // ���������� ��û
                
                NumberGetNextRFC       func                   = new NumberGetNextRFC();
                A12FamilyAlloCancelRFC rfc                    = new A12FamilyAlloCancelRFC();
                A12FamilyBuyangData    a12FamilyBuyangData    = new A12FamilyBuyangData();
                Vector                 a12FamilyBuyangData_vt = new Vector();
                Vector                 AppLineData_vt         = new Vector();
                String                 ainf_seqn              = func.getNumberGetNext();
                
                // ���������� ��û
                box.copyToEntity(a12FamilyBuyangData);
                a12FamilyBuyangData.PERNR     = PERNR;
                a12FamilyBuyangData.AINF_SEQN = ainf_seqn;
                a12FamilyBuyangData.ZPERNR    = user.empNo;              // ��û�� ���(�븮��û, ���� ��û)
                a12FamilyBuyangData.UNAME     = user.empNo;              // ��û�� ���(�븮��û, ���� ��û)
                a12FamilyBuyangData.AEDTM     = DataUtil.getCurrentDate();  // ������(���糯¥)

                a12FamilyBuyangData_vt.addElement(a12FamilyBuyangData);
                
                Logger.debug.println(this, "���������� ��û : " + a12FamilyBuyangData.toString());
                
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
                    appLine.APPL_BEGDA     = a12FamilyBuyangData.BEGDA;
                    appLine.APPL_AINF_SEQN = ainf_seqn;
                    appLine.APPL_UPMU_TYPE = UPMU_TYPE;
                    
                    AppLineData_vt.addElement(appLine);
                }
                Logger.debug.println(this, AppLineData_vt.toString());
                
                con = DBUtil.getTransaction();
                
                AppLineDB appDB    = new AppLineDB(con);
                appDB.create(AppLineData_vt);
                rfc.build( ainf_seqn, a12FamilyBuyangData_vt );
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
                
                String url = "location.href = '" + WebUtil.ServletURL+"hris.A.A12Family.A12AllowanceCancelDetailSV?AINF_SEQN="+ainf_seqn+"&ThisJspName="+ThisJspName+"';";
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
