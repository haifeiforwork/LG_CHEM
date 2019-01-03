/******************************************************************************/
/*                                                                              */
/*   System Name  : ESS                                                         */
/*   1Depth Name  : HR ������                                                */
/*   2Depth Name  : �������� ����� ���� ����                                           */
/*   Program Name : �������� ����� ���� ����                              */
/*   Program ID   : G069ApprovalRetireBusinessSV                                         */
/*   Description  : �������� ����� ���� ������ ����                               */
/*   Note         :                                               */
/*   Creation     : 2010-07-07 �ڹο�                                           */
/*   Update       : 2010-07-12 siyakim                                                            */
/*                                                                              */
/*                                                                              */
/********************************************************************************/

package servlet.hris.G;

import hris.E.E03Retire.E03RetireBusinessInfoData;
import hris.E.E03Retire.rfc.E03RetireBusinessInfoRFC;
import hris.E.E03Retire.rfc.E03RetireBusinessListRFC;
import hris.E.E03Retire.rfc.E03RetireBusinessRFC;
import hris.E.E03Retire.rfc.E03RetireMBegdaRFC;

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

public class G069ApprovalRetireBusinessSV extends EHRBaseServlet {
    private String UPMU_TYPE ="50";	//���������ڵ�
    private String UPMU_NAME = "�������� ����ں���";
	protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        try{
            HttpSession session = req.getSession(false);
            WebUserData user = WebUtil.getSessionUser(req);

            Vector          vcAppLineData      = null;
            Vector          e03RetireBusinessInfoData_vt = null;
            E03RetireBusinessInfoData e03RetireBusinessInfoData    = null;

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
            	//������ �Է¶� ��/��
            	String m_begda = new E03RetireMBegdaRFC().getRetireMBegdaInfo(UPMU_TYPE);
            	req.setAttribute("m_begda" ,m_begda );     
            	
	            E03RetireBusinessInfoData    businessData    = new E03RetireBusinessInfoData();
	            E03RetireBusinessRFC      rfc       = new E03RetireBusinessRFC();
	            
	            Vector E03RetireBusinessData_vt  = null;
	            
	            //��û ����
	            E03RetireBusinessData_vt = rfc.detail(AINF_SEQN);
	            
	            if(E03RetireBusinessData_vt.size() > 0)
	            	businessData = (E03RetireBusinessInfoData)E03RetireBusinessData_vt.get(0);
	            
	            Logger.debug.println(this, "E03RetireBusinessData_vt : " + E03RetireBusinessData_vt.toString());
            	            
	            vcAppLineData = AppUtil.getAppChangeVt(AINF_SEQN);

                if(E03RetireBusinessData_vt.size() < 1){
                    String msg = "��ȸ�� �׸��� �����͸� �о���̴� �� ������ �߻��߽��ϴ�.";
                    String url = "history.back();";
                    req.setAttribute("msg", msg);
                    req.setAttribute("url", url);
                    dest = WebUtil.JspURL+"common/msg.jsp";
                }else{
                	//���� ����� ����Ʈ
                    Vector BusinessList_vt = new E03RetireBusinessListRFC().getRetireBusinessList(user.companyCode);
                    //���� ������� ���ݻ���� ����
                    E03RetireBusinessInfoData businessInfo = new E03RetireBusinessInfoRFC().getRetireBusinessInfo(user.empNo);
                    // �����ڸ���Ʈ
                    Logger.debug.println(this, "AppLineData_vt : "+ vcAppLineData.toString());
                    
                    PersInfoData  pid = (PersInfoData)new PersInfoWithNoRFC().getApproval(businessData.PERNR).get(0);

                    req.setAttribute("PersInfoData" ,pid );
                    
                    req.setAttribute("BusinessList_vt", BusinessList_vt);
                    req.setAttribute("cur_insu_code", businessInfo.E_INSU_CODE);
                    req.setAttribute("BusinessInfoData", businessData);                //�����û ����
                    req.setAttribute("AppLineData_vt", vcAppLineData);

                    dest = WebUtil.JspURL+"G/G069ApprovalRetireBusiness.jsp";
                } // end if

            } else if( jobid.equals("save") ) {

            	vcAppLineData = new Vector();
            	e03RetireBusinessInfoData = new E03RetireBusinessInfoData();
            	e03RetireBusinessInfoData_vt = new Vector();
                AppLineData   tempAppLine;

                Vector      vcTempAppLineData = new Vector();
                AppLineData appLine           = new AppLineData();

                // ���ݻ� ���� �űԽ�û ���� �ڷ�
                box.copyToEntity(e03RetireBusinessInfoData);
                e03RetireBusinessInfoData_vt.add(e03RetireBusinessInfoData);

                // ������ ����
                int nRowCount = Integer.parseInt(box.getString("RowCount"));
                String APPU_TYPE   =  box.get("APPU_TYPE");
                String APPR_SEQN   =  box.get("APPR_SEQN");
                //ESB ���� ���� =========================================
                String currApprNumb = "";  

                for (int i = 0; i < nRowCount; i++) {
                    tempAppLine = new AppLineData();
                    box.copyToEntity(tempAppLine ,i);
                    vcTempAppLineData.add(tempAppLine);
                    //ESB ���� ���� =========================================
                    if (tempAppLine.APPL_APPR_STAT.equals("�̰�") && currApprNumb.equals("")){
                    	currApprNumb = tempAppLine.APPL_APPU_NUMB;
                    }        
                    //ESB ���� ���� =========================================
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

                Vector vcRet = Apr.setApprovalStatutsList(vcAppLineData ,"T_ZSOLRP011T" ,e03RetireBusinessInfoData_vt);
                ApprovalReturnState ars = (ApprovalReturnState) vcRet.get(0);

                PersonInfoRFC numfunc = new PersonInfoRFC();
                PersonData phonenumdata;
                phonenumdata = (PersonData)numfunc.getPersonInfo(e03RetireBusinessInfoData.PERNR);

                Properties ptMailBody = new Properties();
                ptMailBody.setProperty("SServer",user.SServer);           // ElOffice ���� ����
                ptMailBody.setProperty("from_empNo" ,user.empNo);         // �� �߼��� ���

                ptMailBody.setProperty("ename" ,phonenumdata.E_ENAME);    // (��)��û�ڸ�
                ptMailBody.setProperty("empno" ,phonenumdata.E_PERNR);    // (��)��û�� ���

                ptMailBody.setProperty("UPMU_NAME" ,UPMU_NAME);          // ���� �̸�
                ptMailBody.setProperty("AINF_SEQN" ,AINF_SEQN);           // ��û�� ����

                // �� ����
                StringBuffer sbSubject = new StringBuffer(512);

                sbSubject.append("[" + ptMailBody.getProperty("UPMU_NAME") + "] ");
                sbSubject.append(user.ename  + "���� ");

                String msg;
                String msg2 = "";
                String to_empNo = e03RetireBusinessInfoData.PERNR;

                if (ars.E_RETURN.equals("S")) {

                    if (appLine.APPL_APPR_STAT.equals("A")) {
                        msg = "msg009";
                        for (int i = 0; i < vcTempAppLineData.size(); i++) {
                            tempAppLine = (AppLineData) vcTempAppLineData.get(i);
                            if (tempAppLine.APPL_APPU_TYPE.equals(APPU_TYPE) && tempAppLine.APPL_APPR_SEQN.equals(APPR_SEQN)) {
                                if (i == vcTempAppLineData.size() - 1) {
                                    // ������ ������
                                    ptMailBody.setProperty("FileName" ,"NoticeMail2.html");
                                    sbSubject.append(ptMailBody.getProperty("UPMU_NAME") +"�� ���� �ϼ̽��ϴ�..");
                                } else {
                                    // ���� ������
                                    tempAppLine = (AppLineData) vcTempAppLineData.get(i+1);
                                    to_empNo = tempAppLine.APPL_APPU_NUMB;
                                    sbSubject.append(ptMailBody.getProperty("UPMU_NAME") +" ���縦 ��û �ϼ̽��ϴ�.");
                                    break;
                                } // end if
                            } else {

                            } // end if
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
                        ptMailBody.setProperty("FileName" ,"NoticeMail3.html");
                        sbSubject.append(ptMailBody.getProperty("UPMU_NAME") +"�� �ݷ� �ϼ̽��ϴ�.");
                    } // end if

                    ptMailBody.setProperty("to_empNo" ,to_empNo);                   // �� ������ ���
                    ptMailBody.setProperty("subject" ,sbSubject.toString());        // �� ���� ����
                    MailSendToEloffic   maTe = new MailSendToEloffic(ptMailBody);

                    if (!maTe.process()) {
                        msg2 = maTe.getMessage() + "\\n";
                    } // end if

                    try {
                        DraftDocForEloffice ddfe = new DraftDocForEloffice();
                        ElofficInterfaceData eof;
                        Vector vcElofficInterfaceData = new Vector(); 
                        if (!currApprNumb.equals(user.empNo)) {                        	
                        	//����÷��� ������ ���� �׽�ũ�� ������ �ִ� �����ڰ� �����Ҷ� ó��:���� ���ڰ��翡 ���ִ� DATA�� ������ �ٽ� ó��  
                        	ElofficInterfaceData eofD = ddfe.makeDocForDelete(AINF_SEQN ,user.SServer , phonenumdata.E_PERNR, ptMailBody.getProperty("UPMU_NAME") , currApprNumb);
                            vcElofficInterfaceData.add(eofD); 
                           	ElofficInterfaceData eofI = ddfe.makeDocForInsert(AINF_SEQN ,user.SServer , phonenumdata.E_PERNR,  ptMailBody.getProperty("UPMU_NAME")  );
                            vcElofficInterfaceData.add(eofI); 
                        }
                        
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
                                if (!currApprNumb.equals(user.empNo)) {  
                                    approvers[approvers.length-1] =user.empNo; //ESB ���� ���� 
                                } 
                                eof = ddfe.makeDocForReject(AINF_SEQN ,user.SServer,ptMailBody.getProperty("UPMU_NAME") ,e03RetireBusinessInfoData.PERNR ,approvers);
                            } // end if
                        } // end if

                        vcElofficInterfaceData.add(eof);
                        req.setAttribute("vcElofficInterfaceData", vcElofficInterfaceData);
                        dest = WebUtil.JspURL+"common/ElOfficeInterface.jsp";
                    } catch (Exception e) {
                        dest = WebUtil.JspURL+"common/msg.jsp";
                        msg2 = msg2 +  " Eloffic ���� ���� " ;
                    } // end try
                } else {
                    msg = ars.E_MESSAGE;
                    dest = WebUtil.JspURL+"common/msg.jsp";
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
        	Logger.err.println("##################################################");
            Logger.err.println(DataUtil.getStackTrace(e));
            throw new GeneralException(e);
        } finally {

        }
    }
}
