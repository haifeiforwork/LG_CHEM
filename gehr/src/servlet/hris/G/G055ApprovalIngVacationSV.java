/********************************************************************************/
/*                                                                              */
/*   System Name  : e-HR                                                        */
/*   1Depth Name  : HR ������                                                   */
/*   2Depth Name  : ���� ������ ����                                            */
/*   Program Name : �ް� ����                                                   */
/*   Program ID   : G055ApprovalIngVacationSV                                   */
/*   Description  : �ް�  ��û ����������                                       */
/*   Note         : ����                                                        */
/*   Creation     : 2005-03-10 �����                                           */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/

package servlet.hris.G;

import hris.D.D03Vocation.D03RemainVocationData;
import hris.D.D03Vocation.D03VocationData;
import hris.D.D03Vocation.rfc.D03RemainVocationRFC;
import hris.D.D03Vocation.rfc.D03VocationRFC;
import hris.G.ApprovalReturnState;
import hris.G.rfc.G001ApprovalProcessRFC;
import hris.common.*;
import hris.common.PersonData;
import hris.common.rfc.PersInfoWithNoRFC;
import hris.common.rfc.PersonInfoRFC;
import hris.common.util.AppUtil;

import java.util.Properties;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;

public class G055ApprovalIngVacationSV extends EHRBaseServlet
{
    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        try{
            HttpSession session = req.getSession(false);
            WebUserData user = WebUtil.getSessionUser(req);

            Vector          vcAppLineData      = null;
            Vector          d03VocationData_vt = null;
            D03VocationData d03VocationData    = null;

            String dest  = "";
            String jobid = "";

            Box box = WebUtil.getBox(req);
            String  AINF_SEQN  = box.get("AINF_SEQN");

            // ó�� �� ���� �� ������
            String RequestPageName = box.get("RequestPageName");
            req.setAttribute("RequestPageName", RequestPageName);

            jobid = box.get("jobid");

            if(jobid == null || jobid.equals("") ){
                jobid = "search";
            }// end if

            if( jobid.equals("search") ) {

                //�ް���û ��ȸ
                D03VocationRFC  rfc = new D03VocationRFC();
                d03VocationData_vt = rfc.getVocation( user.empNo, AINF_SEQN );
                Logger.debug.println(this, "�ް� ��ȸ : " + d03VocationData_vt.toString());

                if( d03VocationData_vt.size() < 1 ){
                    String msg = "System Error! \n\n ��ȸ�� �׸��� �����ϴ�.";
                    req.setAttribute("msg", msg);
                    dest = WebUtil.JspURL+"common/caution.jsp";
                }else{
                    //�ް�
                    d03VocationData  = (D03VocationData)d03VocationData_vt.get(0);

                    // �ܿ��ް��ϼ�, ��ġ����ٹ��� üũ
                    D03RemainVocationRFC  rfcRemain             = null;
                    D03RemainVocationData d03RemainVocationData = new D03RemainVocationData();

                    rfcRemain             = new D03RemainVocationRFC();
                    d03RemainVocationData = (D03RemainVocationData)rfcRemain.getRemainVocation(user.empNo, DataUtil.getCurrentDate());

                    // ������ ����
                    vcAppLineData = AppUtil.getAppChangeVt(AINF_SEQN);

                    // ���� ����.
                    PersInfoWithNoRFC piRfc = new PersInfoWithNoRFC();
                    PersInfoData      pid   = (PersInfoData) piRfc.getApproval(d03VocationData.PERNR).get(0);

                    req.setAttribute("PersInfoData" ,pid );
                    req.setAttribute("vcAppLineData" , vcAppLineData);
                    req.setAttribute("d03VocationData_vt", d03VocationData_vt);
                    req.setAttribute("d03RemainVocationData",  d03RemainVocationData);

                    dest = WebUtil.JspURL+"G/G055ApprovalIngVacation.jsp";
                } // end if
            } else if( jobid.equals("save") ) {

                d03VocationData    = new D03VocationData();
                d03VocationData_vt = new Vector();
                vcAppLineData      = new Vector();
                AppLineData  tempAppLine;
                Vector       vcTempAppLineData = new Vector();
                AppLineData  appLine           = new AppLineData();

                // �ް� ���� �ڷ�
                box.copyToEntity(d03VocationData);
                d03VocationData.UNAME = user.empNo;
                d03VocationData.AEDTM = DataUtil.getCurrentDate();

                // ������ ����
                int nRowCount = Integer.parseInt(box.getString("RowCount"));
                String APPU_TYPE = box.get("APPU_TYPE");
                String APPR_SEQN = box.get("APPR_SEQN");

                for (int i = 0; i < nRowCount; i++) {
                    tempAppLine = new AppLineData();
                    box.copyToEntity(tempAppLine ,i);
                    vcTempAppLineData.add(tempAppLine);

                    if (tempAppLine.APPL_APPU_TYPE.equals(APPU_TYPE) && tempAppLine.APPL_APPR_SEQN.equals(APPR_SEQN)) {
                        appLine.APPL_BUKRS = box.getString("BUKRS");
                        appLine.APPL_PERNR = box.getString("PERNR");
                        appLine.APPL_BEGDA = box.getString("BEGDA");
                        appLine.APPL_AINF_SEQN = box.getString("AINF_SEQN");
                        appLine.APPL_APPU_TYPE = APPU_TYPE;
                        appLine.APPL_APPR_SEQN = APPR_SEQN;
                        appLine.APPL_APPU_NUMB = user.empNo;
                        appLine.APPL_APPR_STAT = box.getString("APPR_STAT");
                        appLine.APPL_BIGO_TEXT = box.getString("BIGO_TEXT");
                        appLine.APPL_APPR_DATE = DataUtil.getCurrentDate();
                    } // end if
                } // end for

                Logger.debug.println(this ,vcTempAppLineData);
                Logger.debug.println(this ,appLine);
                vcAppLineData.add(appLine);

                G001ApprovalProcessRFC  Apr = new G001ApprovalProcessRFC();
                Vector vcRet = Apr.setApprovalStatutsList(vcAppLineData );

                Logger.debug.println(this ,vcRet);
                ApprovalReturnState ars = (ApprovalReturnState) vcRet.get(0);

                PersonInfoRFC numfunc = new PersonInfoRFC();
                PersonData phonenumdata;
                phonenumdata = (PersonData)numfunc.getPersonInfo(d03VocationData.PERNR);

                Properties ptMailBody = new Properties();
                ptMailBody.setProperty("SServer",user.SServer);          // ElOffice ���� ����
                ptMailBody.setProperty("from_empNo" ,user.empNo);        // �� �߼��� ���
                ptMailBody.setProperty("ename" ,phonenumdata.E_ENAME);   // (��)��û�ڸ�
                ptMailBody.setProperty("empno" ,phonenumdata.E_PERNR);   // (��)��û�� ���
                ptMailBody.setProperty("UPMU_NAME" ,"�ް�");             // ���� �̸�
                ptMailBody.setProperty("AINF_SEQN" ,AINF_SEQN);          // ��û�� ����

                // �� ����
                StringBuffer sbSubject = new StringBuffer(512);

                sbSubject.append("[" + ptMailBody.getProperty("UPMU_NAME") + "] ");
                //sbSubject.append(user.ename  + "���� ");
                sbSubject.append(user.ename).append( "���� ");
                

                String msg;
                String msg2 = "";
                String to_empNo = d03VocationData.PERNR;

                if (ars.E_RETURN.equals("S")) {

                    ptMailBody.setProperty("FileName" ,"NoticeMail5.html");

                    msg = "msg011";

                    for (int i = 0; i < vcTempAppLineData.size(); i++) {
                        tempAppLine = (AppLineData) vcTempAppLineData.get(i);
                        if (tempAppLine.APPL_APPU_TYPE.equals(APPU_TYPE) && tempAppLine.APPL_APPR_SEQN.equals(APPR_SEQN)) {
                            // ���� ������
                            tempAppLine = (AppLineData) vcTempAppLineData.get(i+1);
                            to_empNo = tempAppLine.APPL_APPU_NUMB;
                            break;
                        } 
                    } // end for

                    sbSubject.append("���� �ϼ̽��ϴ�.");

                    ptMailBody.setProperty("to_empNo" ,to_empNo);                   // �� ������ ���
                    ptMailBody.setProperty("subject"  ,sbSubject.toString());       // �� ���� ����
                    MailSendToEloffic   maTe = new MailSendToEloffic(ptMailBody);

                    if (!maTe.process()) {
                        msg2 = maTe.getMessage() + "\\n";
                    } // end if

                    try {
                        DraftDocForEloffice ddfe = new DraftDocForEloffice();

                        ElofficInterfaceData eof = ddfe.makeDocForCancel(AINF_SEQN ,user.SServer,ptMailBody.getProperty("UPMU_NAME") ,to_empNo);

                        Vector vcElofficInterfaceData = new Vector();      
                        vcElofficInterfaceData.add(eof);
                        
                        //req.setAttribute("vcElofficInterfaceData", vcElofficInterfaceData);
                        //dest = WebUtil.JspURL+"common/ElOfficeInterface.jsp";
                        
                        //���հ��� ���������� ���� ������������ ������  2012.11.07                         
                        try { 
                        	
                        	SendToESB esb = new SendToESB();                
                        	String esbmsg = esb.process(vcElofficInterfaceData );
                            Logger.debug.println(this ,"[esbmsg]  :"+esbmsg); 
                        	req.setAttribute("message", esbmsg);
                        	dest = WebUtil.JspURL+"common/EsbResult.jsp";
    	                } catch (Exception e) {
                           dest = WebUtil.JspURL+"common/msg.jsp";
                           //msg2 = msg2 + "\\n" + "esb.process Eloffice ���� ����" ;
                           msg2 += "\\n" + "esb.process Eloffice ���� ����" ;
                       }                         
    	                
    	                
                        
                    } catch (Exception e) {
                        dest = WebUtil.JspURL+"common/msg.jsp";
                        //msg2 = msg2 +  " Eloffic ���� ���� " ;
                        msg2   += " Eloffic ���� ���� " ;
                    } // end try
                } else {
                    dest = WebUtil.JspURL+"common/msg.jsp";
                    msg = ars.E_MESSAGE;
                } // end if

                String url = "location.href = \"" + RequestPageName.replace('|','&') + "\";";

                req.setAttribute("msg", msg);
                req.setAttribute("msg2", msg2);
                req.setAttribute("url", url);

            } else {
                throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
            } // end if

            Logger.debug.println(this, " destributed = " + dest);
            printJspPage(req, res, dest);

        } catch(Exception e) {
            Logger.err.println(DataUtil.getStackTrace(e));
            throw new GeneralException(e);
      //  } finally {

        }
    }
}