/********************************************************************************/
/*                                                                              */
/*   System Name  : e-HR                                                        */
/*   1Depth Name  : HR ������                                                   */
/*   2Depth Name  : ���� �ؾ��� ����                                            */
/*   Program Name : ������û                                                    */
/*   Program ID   : G080ApprovalEventCancelSV                                    */
/*   Description  : ������û���  �μ��� ����/�ݷ�                              */
/*   Note         : ����                                                        */
/*   Creation     : 2013-006-12 lsa������ҽ�û ���� �߰� | [��û��ȣ]C20130627_58399  */
/*   Update       :                                                                 */
/*                                                                              */
/********************************************************************************/

package servlet.hris.G;

import hris.C.C02Curri.C02CurriInfoData;
import hris.C.C03EventCancel.C03EventCancelData; 
import hris.C.C03EventCancel.C03GetEventChargeListData;
import hris.C.C03EventCancel.C03bapiReturnData;
import hris.C.C03EventCancel.rfc.C03EventCancelApplRFC; 
import hris.C.C03EventCancel.rfc.C03GetEventChargeListRFC;
import hris.G.ApprovalReturnState;
import hris.G.rfc.EducationInfoRFC;
import hris.G.rfc.G001ApprovalProcessRFC;
import hris.common.AppLineData; 
import hris.common.MailSendToEloffic;
import hris.common.PersInfoData;
import hris.common.PersonData;
import hris.common.WebUserData;
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

public class G080ApprovalEventCancelSV extends EHRBaseServlet 
{
    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        try{
            HttpSession session = req.getSession(false);
            WebUserData user = WebUtil.getSessionUser(req);

            Vector vcC03EventCancelData;
            Vector vcAppLineData;
            
            C03EventCancelData c03EventCancelData;
            
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
                  
                C03EventCancelApplRFC func = new C03EventCancelApplRFC();
                vcC03EventCancelData = func.getDetail( AINF_SEQN );
                
                Logger.debug.println(this ,vcC03EventCancelData);

                if( vcC03EventCancelData.size() < 1 ){
                    String msg = "System Error! \n\n ��ȸ�� �׸��� �����ϴ�.";
                    req.setAttribute("msg", msg);
                    dest = WebUtil.JspURL+"common/caution.jsp";
                }else{
                    // ������ҽ�û
                    c03EventCancelData = (C03EventCancelData)vcC03EventCancelData.get(0);
                    
                    // ������ ����
                    vcAppLineData = AppUtil.getAppChangeVt(AINF_SEQN);
                    
                    PersInfoWithNoRFC   piRfc   = new PersInfoWithNoRFC();
                    PersInfoData        pid     = (PersInfoData) piRfc.getApproval(c03EventCancelData.PERNR).get(0);
                    req.setAttribute("PersInfoData" ,pid );
                       
                    // ���� ����
                    C02CurriInfoData c02CurriInfoData = (C02CurriInfoData)(new EducationInfoRFC()).getEducationInfo(c03EventCancelData.GWAID ,c03EventCancelData.CHAID);
                    
                    req.setAttribute("c03EventCancelData", c03EventCancelData);
                    req.setAttribute("c02CurriInfoData", c02CurriInfoData); 
                    req.setAttribute("vcAppLineData" , vcAppLineData);

                    dest = WebUtil.JspURL+"G/G080ApprovalEventCancel.jsp";
                } // end if
            } else if( jobid.equals("save") ) {
                
                c03EventCancelData     = new C03EventCancelData();
                vcC03EventCancelData   = new Vector();
                
                // �ǰ����� ��߱� ��û 
                box.copyToEntity(c03EventCancelData);
                c03EventCancelData.CHENAME     = user.empNo; 
                
                vcC03EventCancelData.add(c03EventCancelData);
                
                // ������ ����
                vcAppLineData       = new Vector();
                AppLineData    appLine     = new AppLineData();
                
                Vector vcTempAppLineData   = new Vector();
                AppLineData         tempAppLine;
                 
                int nRowCount = Integer.parseInt(box.getString("RowCount"));
                
                String APPU_TYPE   =  box.get("APPU_TYPE");
                String APPR_SEQN   =  box.get("APPR_SEQN");
                
                for (int i = 0; i < nRowCount; i++) {
                    tempAppLine = new AppLineData();
                    box.copyToEntity(tempAppLine ,i);
                    vcTempAppLineData.add(tempAppLine);
                    
                    if (tempAppLine.APPL_APPU_TYPE.equals(APPU_TYPE) && tempAppLine.APPL_APPR_SEQN.equals(APPR_SEQN)) {
                        appLine.APPL_BUKRS = box.getString("BUKRS");
                        appLine.APPL_PERNR = box.getString("PERNR");
                        appLine.APPL_BEGDA = box.getString("BEGDA1");
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
                phonenumdata    =   (PersonData)numfunc.getPersonInfo(c03EventCancelData.PERNR);
                
                Properties ptMailBody = new Properties();
                ptMailBody.setProperty("SServer",user.SServer);                 // ElOffice ���� ����
                ptMailBody.setProperty("from_empNo" ,user.empNo);               // �� �߼��� ���
                
                ptMailBody.setProperty("ename" ,phonenumdata.E_ENAME);          // (��)��û�ڸ� 
                ptMailBody.setProperty("empno" ,phonenumdata.E_PERNR);          // (��)��û�� ���
                
                ptMailBody.setProperty("UPMU_NAME" ,"������ҽ�û");            // ���� �̸�
                ptMailBody.setProperty("AINF_SEQN" ,AINF_SEQN);                 // ��û�� ����
                
                // �� ����
                StringBuffer sbSubject = new StringBuffer(512);
                
                sbSubject.append("[" + ptMailBody.getProperty("UPMU_NAME") + "] ");
                sbSubject.append(user.ename  + "���� ");
                
                String msg;
                String msg2 = "";
                String to_empNo = c03EventCancelData.PERNR; 
                if (ars.E_RETURN.equals("S")) { 
                    if (appLine.APPL_APPR_STAT.equals("A")) {
                        msg = "msg009";
                        for (int i = 0; i < vcTempAppLineData.size(); i++) {
                            tempAppLine = (AppLineData) vcTempAppLineData.get(i);
                            if (tempAppLine.APPL_APPU_TYPE.equals(APPU_TYPE) && tempAppLine.APPL_APPR_SEQN.equals(APPR_SEQN)) {
                                if (i == vcTempAppLineData.size() -1) {
                                    // ������ ������
                                    ptMailBody.setProperty("FileName" ,"NoticeMail2_Hrd.html");  //HRD �� �ٷΰ���
                                    sbSubject.append(ptMailBody.getProperty("UPMU_NAME") +"�� ���� �ϼ̽��ϴ�.");
                                } else {
                                    // ���� ������
                                    ptMailBody.setProperty("FileName" ,"NoticeMail2.html");   //EHR �ǰ��� ������ �ٷΰ���
                                    tempAppLine = (AppLineData) vcTempAppLineData.get(i+1);
                                    to_empNo = tempAppLine.APPL_APPU_NUMB;
                                    sbSubject.append("���縦 ��û �ϼ̽��ϴ�.");
                                    break;
                                } // end if
                            }// end if
                        } // end for
                    } else {
                        msg = "msg010";
                        if (APPU_TYPE.equals("02") && Integer.parseInt(APPR_SEQN) > 1) {
                            for (int i = 0; i < vcTempAppLineData.size(); i++) {
                                tempAppLine = (AppLineData) vcTempAppLineData.get(i);
                                if (tempAppLine.APPL_APPU_TYPE.equals("02") && tempAppLine.APPL_APPR_SEQN.equals("01")) {
                                    tempAppLine = (AppLineData) vcTempAppLineData.get(i);
                                    to_empNo = tempAppLine.APPL_APPU_NUMB;
                                } // end if
                            } // end for
                        } // end if
                        ptMailBody.setProperty("FileName" ,"NoticeMail3_Hrd.html");
                        sbSubject.append(ptMailBody.getProperty("UPMU_NAME") +"�� �ݷ� �ϼ̽��ϴ�.");
                    } // end if
                   
                    ptMailBody.setProperty("to_empNo" ,to_empNo);                   // �� ������ ���
                    ptMailBody.setProperty("subject" ,sbSubject.toString());        // �� ���� ����
                    MailSendToEloffic   maTe = new MailSendToEloffic(ptMailBody);

                    if (!maTe.process()) {
                        msg2 = maTe.getMessage() + "\\n";
                    } // end if
                    

                   //----------------- ����Ϸ�� �̺�Ʈ����ڿ��� �����뺸     
                   if (ars.E_RETURN.equals("S") &&  appLine.APPL_APPR_STAT.equals("A")) { 
	                         
	                    Properties ptMailBodyT = new Properties();
	                    ptMailBodyT.setProperty("SServer",user.SServer);                 // ElOffice ���� ����
	                    ptMailBodyT.setProperty("from_empNo" ,user.empNo);               // �� �߼��� ���                    
	                    ptMailBodyT.setProperty("ename" ,phonenumdata.E_ENAME);          // (��)��û�ڸ� 
	                    ptMailBodyT.setProperty("empno" ,phonenumdata.E_PERNR);          // (��)��û�� ���                    
	                    ptMailBodyT.setProperty("UPMU_NAME" ,"������ҽ�û(�뺸�ڿ�)");            // ���� �̸�
	                    ptMailBodyT.setProperty("AINF_SEQN" ,AINF_SEQN);                 // ��û�� ����                    
	                    // �� ����
	                    StringBuffer sbSubjectT = new StringBuffer(512);
	                    
	                    sbSubjectT.append("[" + ptMailBodyT.getProperty("UPMU_NAME") + "] ");
	                    sbSubjectT.append(user.ename  + "���� ");
	                    
	                    ptMailBodyT.setProperty("FileName" ,"NoticeMail2_Inform.html");
	                    sbSubjectT.append("������ҽ�û�� ���� �Ͽ����� �뺸�帳�ϴ�.");
	                        
	                    ptMailBodyT.setProperty("to_empNo" ,to_empNo);                   // �� ������ ���
	                    ptMailBodyT.setProperty("subject" ,sbSubjectT.toString());        // �� ���� ����
	                    MailSendToEloffic   maTeT = new MailSendToEloffic(ptMailBodyT);
	  
	                    //-------------�뺸�ڸ���Ʈ--------------
				        C03GetEventChargeListRFC func = new C03GetEventChargeListRFC();         
				        Vector ret = func.getChargeList(  c03EventCancelData.CHAID );
	                    Vector c03GetEventChargeListData_vt = new Vector();
	
	                    C03bapiReturnData c03bapiReturnData = new C03bapiReturnData();  // RETURN CODE
	                    c03GetEventChargeListData_vt = (Vector)ret.get(0);
	                    c03bapiReturnData  = (C03bapiReturnData)ret.get(1); 
	
		                C03GetEventChargeListData         tempChargeList;
				        if ( c03bapiReturnData.CODE.equals("S")) {		
	                        for (int i = 0; i < c03GetEventChargeListData_vt.size(); i++) {
	                        	tempChargeList = (C03GetEventChargeListData) c03GetEventChargeListData_vt.get(i);
	                            if ( !tempChargeList.CHPERNR.equals("")  ) {  
	                                ptMailBodyT.setProperty("to_empNo" ,tempChargeList.CHPERNR);                   // �� ������ ���
	                                ptMailBodyT.setProperty("GWAJUNG" ,c03EventCancelData.GWAJUNG);        // ������  CSRID:
	                                ptMailBodyT.setProperty("CHASU" ,c03EventCancelData.CHASU); // ������ CSRID: 
	                                ptMailBodyT.setProperty("CHASUID" ,c03EventCancelData.CHAID); // ����ID CSRID: 
	                                
	                                
	                            } // end if
	                            if (!maTeT.process()) {
	                            	msg2  += maTeT.getMessage() + "\\n";
	                            }
	    			            Logger.debug.println(this, "�뺸�ڸ���  to_empNo = " +tempChargeList.CHPERNR);
	                        } // end for
	                    }
	                     
			            Logger.debug.println(this, " c03GetEventChargeListData_vt = " + c03GetEventChargeListData_vt.toString());
			            Logger.debug.println(this, " c03bapiReturnData = " + c03bapiReturnData.toString());
		            }
                    //----------------- ����Ϸ�� �̺�Ʈ����ڿ��� �����뺸 END
                    
                    
/*
                    try {
                        DraftDocForEloffice ddfe = new DraftDocForEloffice();
                        ElofficInterfaceData eof;
                        
                        if (appLine.APPL_APPR_STAT.equals("A")) {
                            eof = ddfe.makeDocContents(AINF_SEQN ,user.SServer,ptMailBody.getProperty("UPMU_NAME"));
                        } else {
                            if (APPU_TYPE.equals("02") && Integer.parseInt(APPR_SEQN) > 1) {
                                eof = ddfe.makeDocForMangerReject(AINF_SEQN ,user.SServer,ptMailBody.getProperty("UPMU_NAME") ,vcTempAppLineData);
                            } else {
                                int nRejectLength = 0;
                                for (int i = vcTempAppLineData.size() - 1; i >= 0; i--) {
                                    tempAppLine = (AppLineData) vcTempAppLineData.get(i);
                                    if (tempAppLine.APPL_APPU_TYPE.equals(APPU_TYPE) && tempAppLine.APPL_APPR_SEQN.equals(APPR_SEQN)) {
                                        nRejectLength = i + 1;
                                        break;
                                    } // end if
                                } // end for
                                
                                String approvers[] = new String[nRejectLength];
                                for (int i = 0; i < approvers.length; i++) {
                                    tempAppLine = (AppLineData) vcTempAppLineData.get(i);
                                    approvers[i]    =   tempAppLine.APPL_APPU_NUMB;
                                } // end for
                                eof = ddfe.makeDocForReject(AINF_SEQN ,user.SServer,ptMailBody.getProperty("UPMU_NAME") ,c03EventCancelData.PERNR ,approvers);
                            } // end if
                        } // end if
                        
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
                           msg2 += "\\n" + "esb.process Eloffice ���� ����" ;
                       }   
                        
                       
                    } catch (Exception e) {
                        dest = WebUtil.JspURL+"common/msg.jsp";
                        msg2 = msg2 +  " Eloffic ���� ���� " ;
                    } // end try
                    */
		            

	                dest = WebUtil.JspURL+"common/msg.jsp";
	                
                } else {
                     msg = ars.E_MESSAGE; 
                    dest = WebUtil.JspURL+"common/msg.jsp";
                } // end if
                
                String url = "location.href = \"" + RequestPageName.replace('|','&') + "\";";

                Logger.debug.println(this, " url = " + url);
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
        } finally {
            
        }
    }
}