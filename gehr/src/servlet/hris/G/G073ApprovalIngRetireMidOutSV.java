/******************************************************************************/
/*                                                                              */
/*   System Name  : ESS                                                         */
/*   1Depth Name  : HR ������                                               */
/*   2Depth Name  : �������� �ߵ����� ����                                           */
/*   Program Name : �������� �ߵ����� ����                              */
/*   Program ID   : G073ApprovalIngRetireMidOutSV                                         */
/*   Description  : �������� �ߵ����� ���� ���� ��                              */
/*   Note         :                                               */
/*   Creation     : 2010-07-07 �ڹο�                                           */
/*   Update       : 2010-07-12 siyakim                                                            */
/*                                                                              */
/*                                                                              */
/********************************************************************************/

package servlet.hris.G;

import hris.E.E03Retire.E03RetireMidOutInfoData;
import hris.E.E03Retire.rfc.E03RetireMBegdaRFC;
import hris.E.E03Retire.rfc.E03RetireMidOutRFC;
import hris.E.E03Retire.rfc.E03RetireMidOutResnRFC;

import hris.G.ApprovalReturnState;
import hris.G.rfc.G001ApprovalProcessRFC;
import hris.common.AppLineData;
import hris.common.DraftDocForEloffice;
import hris.common.ElofficInterfaceData;
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

public class G073ApprovalIngRetireMidOutSV extends EHRBaseServlet
{
    private String UPMU_TYPE ="53";	//���������ڵ�
    private String UPMU_NAME = "�������� �ߵ�����";
    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
       try{
           HttpSession session = req.getSession(false);
           WebUserData user = WebUtil.getSessionUser(req);

           Vector          vcAppLineData      = null;
           Vector          e03RetireMidOutInfoData_vt = null;
           E03RetireMidOutInfoData e03RetireMidOutInfoData    = null;

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
	           	
	            E03RetireMidOutInfoData    MidOutData    = new E03RetireMidOutInfoData();
	            E03RetireMidOutRFC      rfc       = new E03RetireMidOutRFC();
	            
	            Vector E03RetireMidOutData_vt  = null;
	            
	            //��û ����
	            E03RetireMidOutData_vt = rfc.detail(AINF_SEQN);
	            
	            if(E03RetireMidOutData_vt.size() > 0)
	            	MidOutData = (E03RetireMidOutInfoData)E03RetireMidOutData_vt.get(0);
	            
	            Logger.debug.println(this, "E03RetireMidOutData_vt : " + E03RetireMidOutData_vt.toString());
           	            
	            vcAppLineData = AppUtil.getAppChangeVt(AINF_SEQN);

               if(E03RetireMidOutData_vt.size() < 1){
                   String msg = "��ȸ�� �׸��� �����͸� �о���̴� �� ������ �߻��߽��ϴ�.";
                   String url = "history.back();";
                   req.setAttribute("msg", msg);
                   req.setAttribute("url", url);
                   dest = WebUtil.JspURL+"common/msg.jsp";
               }else{
            	   //�ߵ�������� ����Ʈ
                   Vector ResnList_vt = new E03RetireMidOutResnRFC().getMidOutResnList();
                  
                   // �����ڸ���Ʈ
                   Logger.debug.println(this, "AppLineData_vt : "+ vcAppLineData.toString());
                   
                   PersInfoData  pid = (PersInfoData)new PersInfoWithNoRFC().getApproval(MidOutData.PERNR).get(0);

                   req.setAttribute("PersInfoData" ,pid );
                   
                   req.setAttribute("ResnList_vt", ResnList_vt);
                   req.setAttribute("MidOutInfoData", MidOutData);                //�����û ����
                   req.setAttribute("AppLineData_vt", vcAppLineData);

                   dest = WebUtil.JspURL+"G/G073ApprovalIngRetireMidOut.jsp";
               } // end if
            } else if( jobid.equals("save") ) {

            	vcAppLineData = new Vector();
            	e03RetireMidOutInfoData = new E03RetireMidOutInfoData();
            	e03RetireMidOutInfoData_vt = new Vector();
                AppLineData   tempAppLine;

                Vector      vcTempAppLineData = new Vector();
                AppLineData appLine           = new AppLineData();

                // �ߵ����� �űԽ�û ���� �ڷ�
                box.copyToEntity(e03RetireMidOutInfoData);
                e03RetireMidOutInfoData_vt.add(e03RetireMidOutInfoData);

                // ������ ����
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

                Vector vcRet = Apr.setApprovalStatutsList(vcAppLineData ,"T_ZSOLRP012T" ,e03RetireMidOutInfoData_vt);
                ApprovalReturnState ars = (ApprovalReturnState) vcRet.get(0);

                PersonInfoRFC numfunc = new PersonInfoRFC();
                PersonData phonenumdata;
                phonenumdata = (PersonData)numfunc.getPersonInfo(e03RetireMidOutInfoData.PERNR);

                Properties ptMailBody = new Properties();
                ptMailBody.setProperty("SServer",user.SServer);          // ElOffice ���� ����
                ptMailBody.setProperty("from_empNo" ,user.empNo);        // �� �߼��� ���

                ptMailBody.setProperty("ename" ,phonenumdata.E_ENAME);   // (��)��û�ڸ�
                ptMailBody.setProperty("empno" ,phonenumdata.E_PERNR);   // (��)��û�� ���

                ptMailBody.setProperty("UPMU_NAME" ,UPMU_NAME);           // ���� �̸�
                ptMailBody.setProperty("AINF_SEQN" ,AINF_SEQN);          // ��û�� ����

                // �� ����
                StringBuffer sbSubject = new StringBuffer(512);

                sbSubject.append("[" + ptMailBody.getProperty("UPMU_NAME") + "] ");
                sbSubject.append(user.ename  + "���� ");

                String msg;
                String msg2 = "";
                String to_empNo = e03RetireMidOutInfoData.PERNR;

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
                        } else {

                        } // end if
                    } // end for

                    sbSubject.append(ptMailBody.getProperty("UPMU_NAME") +" ���� �ϼ̽��ϴ�.");

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
                        req.setAttribute("vcElofficInterfaceData", vcElofficInterfaceData);
                        dest = WebUtil.JspURL+"common/ElOfficeInterface.jsp";
                    } catch (Exception e) {
                        dest = WebUtil.JspURL+"common/msg.jsp";
                        msg2 = msg2 +  " Eloffic ���� ���� " ;
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
        } finally {

        }
    }
}