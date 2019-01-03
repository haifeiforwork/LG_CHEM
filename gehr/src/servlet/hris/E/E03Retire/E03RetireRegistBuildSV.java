/******************************************************************************/
/*                                                                              */
/*   System Name  : ESS                                                         */
/*   1Depth Name  : ��������                                               */
/*   2Depth Name  : ��������                                             */
/*   Program Name : �������� ��û                                */
/*   Program ID   : E03RetireRegistBuildSV                                         */
/*   Description  : �������� ��û ����                                  */
/*   Note         :                                               */
/*   Creation     : 2010-07-07 �ڹο�                                           */
/*   Update       : 2010-07-12 siyakim                                                            */
/*                     2018/07/25 rdcamel ������                                                          */
/*                                                                              */
/********************************************************************************/

package servlet.hris.E.E03Retire;

import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.db.DBUtil;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.DateTime;
import com.sns.jdf.util.WebUtil;
import hris.E.E03Retire.E03RetireRegistInfoData;
import hris.E.E03Retire.rfc.*;
import hris.common.*;
import hris.common.db.AppLineDB;
import hris.common.rfc.NumberGetNextRFC;
import hris.common.rfc.PersonInfoRFC;
import hris.common.util.AppUtil;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.sql.Connection;
import java.util.Properties;
import java.util.Vector;

// �������� ��û
public class E03RetireRegistBuildSV extends EHRBaseServlet {
    private String UPMU_TYPE ="51";	//���������ڵ�
    private static String UPMU_SUBTYPE ="01";	//�Ϻ�����
    private String UPMU_NAME = "��������";
        
        protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
        {
            Connection con = null;
            
            try{
                HttpSession session = req.getSession(false);
                
                WebUserData user    = (WebUserData)session.getAttribute("user");
                
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

                String retireType = new E03RetireGubunRFC().getRetireGubunInfo(user.empNo);
            	req.setAttribute("retireType", retireType);   
                req.setAttribute("PERNR" , PERNR );
                req.setAttribute("PersonData" , phonenumdata );
                
                if(!retireType.equalsIgnoreCase("")){//DB/DC ������ �ȵȰ�츸 �ش�
                	dest = WebUtil.JspURL+"E/E03Retire/E03RetireRegistBuild.jsp";
                }else{            
                	boolean retirePeriod = new E03RetirePeriodRFC().getRetirePeriodInfo(user.companyCode, UPMU_TYPE, UPMU_SUBTYPE);
    	            req.setAttribute("retirePeriod", retirePeriod+"");//��û �Ⱓ üũ
    	            
    	            if( jobid.equals("first") ) {     //����ó�� ��û ȭ�鿡 ���°��.
    	            	//�������� �ڵ帮��Ʈ
    	                Vector ResnList_vt = new E03RetireRegistResnRFC().getRetireTypeList();
    	                // �����ڸ���Ʈ
    	                Vector AppLineData_vt = AppUtil.getAppVector( PERNR, UPMU_TYPE );
    	                Logger.debug.println(this, "AppLineData_vt : "+ AppLineData_vt.toString());
    	                
    	                req.setAttribute("ResnList_vt", ResnList_vt);
    	                req.setAttribute("AppLineData_vt", AppLineData_vt);

        	          	//DC�� ��� �����ϴ� ���� ����� ����Ʈ
    	                Vector BusinessList_vt = new E03RetireBusinessListRFC().getRetireBusinessList(user.companyCode);      	                
    	                req.setAttribute("BusinessList_vt", BusinessList_vt);
    	                
    	                dest = WebUtil.JspURL+"E/E03Retire/E03RetireRegistBuild.jsp";
    	                
    	            } else if( jobid.equals("create") ) { // DB insert �����κ�

    	                NumberGetNextRFC func      = new NumberGetNextRFC();
    	                E03RetireRegistRFC      rfc       = new E03RetireRegistRFC();
    	                E03RetireRegistInfoData     RegistData = new E03RetireRegistInfoData();
    	                
    	                Vector RegistData_vt   = new Vector();
    	                Vector AppLineData_vt = new Vector();
    	                String ainf_seqn      = func.getNumberGetNext();
    	                
    	                box.copyToEntity(RegistData);
    	                RegistData.PERNR     = PERNR;
    	                RegistData.AINF_SEQN = ainf_seqn;
    	                RegistData.BEGDA    = DateTime.getShortDateString();              // ��û�� ���(�븮��û, ���� ��û)

    	                
    	                RegistData_vt.addElement(RegistData);
    	                Logger.debug.println(this, "�������ݽ�û RegistData_vt ="+RegistData_vt.toString());
    	                
    	                int rowcount = box.getInt("RowCount");
    	                for( int i = 0; i < rowcount; i++) {
    	                    AppLineData appLine = new AppLineData();
    	                    String      idx     = Integer.toString(i);
    	                    
    	                    // ������ �ڷ� �Է�(Web)
    	                    box.copyToEntity(appLine ,i);
    	                    
    	                    appLine.APPL_MANDT     = user.clientNo;
    	                    appLine.APPL_BUKRS     = phonenumdata.E_BUKRS;
    	                    appLine.APPL_PERNR     = PERNR;
    	                    appLine.APPL_BEGDA     = RegistData.BEGDA;
    	                    appLine.APPL_AINF_SEQN = ainf_seqn;
    	                    appLine.APPL_UPMU_TYPE = UPMU_TYPE;
    	                    
    	                    AppLineData_vt.addElement(appLine);
    	                }
    	                
    	                con = DBUtil.getTransaction();
    	                
    	                AppLineDB appDB = new AppLineDB(con);
    	                
    	                appDB.create(AppLineData_vt);
    	                rfc.build(PERNR, ainf_seqn, RegistData_vt );
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
    	                
    	                String msg = "msg001";	//��û�Ǿ����ϴ�.
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
    	
    	                String url = "location.href = '" + WebUtil.ServletURL+"hris.E.E03Retire.E03RetireRegistDetailSV?AINF_SEQN="+ainf_seqn+"';";
    	                req.setAttribute("msg", msg);
    	                req.setAttribute("msg2", msg2);
    	                req.setAttribute("url", url);
    	                
    	            } else {
    	                throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
    	            }
                }
                Logger.debug.println(this, " destributed = " + dest);
                printJspPage(req, res, dest);
                
            } catch(Exception e) {
//                throw new GeneralException(e);
                String url = "location.href = '" + WebUtil.ServletURL+"hris.E.E03Retire.E03RetireRegistBuildSV';";
                req.setAttribute("url", url);
                
                String dest = WebUtil.JspURL+"common/msg.jsp";
            	printJspPage(req, res, dest);
            } finally {
                DBUtil.close(con);
            }
        }
    }

