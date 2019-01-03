/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR ����                                                  */
/*   2Depth Name  : ��������                                                    */
/*   Program Name : �ξ簡�� ����(����) ��û                                    */
/*   Program ID   : A12SupportCancelBuildSV                                     */
/*   Description  : �ξ簡�� ����(����)�� ��û�� �� �ֵ��� �ϴ� Class           */
/*   Note         :                                                             */
/*   Creation     : 2003-02-24  �赵��                                          */
/*   Update       : 2005-03-08  ������                                          */
/*                     2018/07/25 rdcamel ��� ����                                                  */
/********************************************************************************/

package	servlet.hris.A.A12Family;

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

public class A12SupportCancelBuildSV extends EHRBaseServlet {

    private String UPMU_TYPE = "30";       // ���� ����Ÿ��(�ξ簡�� ����(����))
    private String UPMU_NAME = "�ξ簡�� ����(����)";

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        Connection con = null;

        try{
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

            /******************************
             * 
             * @$ ���������� marco257
             * �븮��û ����üũ �߰�
             * user.e_representative;
             * 
             ******************************/
            //�븮��û ������ �ִ� ��� �߰�
            PERNR = WebUtil.nvl(box.get("PERNR"));
            String reSabunCk = user.e_representative;
            if (PERNR.equals("") || !reSabunCk.equals("Y")) {
                PERNR = user.empNo;
            } // end if
            
            
            // �븮 ��û �߰�
            PersonInfoRFC numfunc = new PersonInfoRFC();
            PersonData phonenumdata;
            phonenumdata    =   (PersonData)numfunc.getPersonInfo(PERNR);

            req.setAttribute("PERNR" , PERNR );
            req.setAttribute("PersonData" , phonenumdata );

            if( jobid.equals("first") ) {           //����ó�� ��û ȭ�鿡 ���°��.

                A12FamilyListRFC  rfc_list             = new A12FamilyListRFC();
                Vector            a12FamilyListData_vt = null;
                Vector            AppLineData_vt       = null;

                // �ξ簡�� ����(����) ��û�� ����
                a12FamilyListData_vt = rfc_list.getFamilyList(PERNR, subty, objps);

                // �����ڸ���Ʈ
                AppLineData_vt       = AppUtil.getAppVector( PERNR, UPMU_TYPE );

                Logger.debug.println(this, "�ξ簡�� ����(����) ��û : " + a12FamilyListData_vt.toString());
                Logger.debug.println(this, "���� : " + AppLineData_vt.toString());

                req.setAttribute("a12FamilyListData_vt", a12FamilyListData_vt);
                req.setAttribute("AppLineData_vt",  AppLineData_vt);

                //  XxxDetailSV.java �� XxxDetail.jsp �� '���/��ȭ��' ��ư Ȱ��ȭ ���θ� �����ִ� �κ�
                String ThisJspName = box.get("ThisJspName");
                req.setAttribute("ThisJspName", ThisJspName);
                //  XxxDetailSV.java �� XxxDetail.jsp �� '���/��ȭ��' ��ư Ȱ��ȭ ���θ� �����ִ� �κ�

                dest = WebUtil.JspURL+"A/A12Family/A12SupportCancelBuild.jsp";

            } else if( jobid.equals("create") ) {       // �ξ簡�� ����(����) ��û
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
                NumberGetNextRFC         func                   = new NumberGetNextRFC();
                A12FamilyBuyangCancelRFC rfc                    = new A12FamilyBuyangCancelRFC();
                A12FamilyBuyangData      a12FamilyBuyangData    = new A12FamilyBuyangData();
                Vector                   a12FamilyBuyangData_vt = new Vector();
                Vector                   AppLineData_vt         = new Vector();
                String                   ainf_seqn              = func.getNumberGetNext();

//              XxxDetailSV.java �� XxxDetail.jsp �� '���/��ȭ��' ��ư Ȱ��ȭ ���θ� �����ִ� �κ�            
                String ThisJspName = box.get("ThisJspName");
//  XxxDetailSV.java �� XxxDetail.jsp �� '���/��ȭ��' ��ư Ȱ��ȭ ���θ� �����ִ� �κ� 
                
                // �ξ簡�� ����(����) ��û
                box.copyToEntity(a12FamilyBuyangData);
                a12FamilyBuyangData.PERNR     = PERNR;
                a12FamilyBuyangData.AINF_SEQN = ainf_seqn;
                a12FamilyBuyangData.ZPERNR    = user.empNo;              // ��û�� ���(�븮��û, ���� ��û)
                a12FamilyBuyangData.UNAME     = user.empNo;              // ��û�� ���(�븮��û, ���� ��û)
                a12FamilyBuyangData.AEDTM     = DataUtil.getCurrentDate();  // ������(���糯¥)

                a12FamilyBuyangData_vt.addElement(a12FamilyBuyangData);

                Logger.debug.println(this, "�ξ簡�� ����(����) ��û : " + a12FamilyBuyangData.toString());

                // �������� ����..
                int rowcount = box.getInt("RowCount");
                for( int i = 0; i < rowcount; i++ ) {
                    AppLineData appLine = new AppLineData();
                    String      idx     = Integer.toString(i);

//                  ������ �ڷ� �Է�(Web)
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

                String url = "location.href = '" + WebUtil.ServletURL+"hris.A.A12Family.A12SupportCancelDetailSV?AINF_SEQN="+ainf_seqn+"&ThisJspName="+ThisJspName+"';";
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
