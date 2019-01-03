/********************************************************************************/
/*                                                                              */
/*   System Name  : e-HR                                                        */
/*   1Depth Name  : HR ������                                                   */
/*   2Depth Name  : ���� ������  ����                                           */
/*   Program Name : ������ ��û                                                 */
/*   Program ID   : G004ApprovalCongraSV                                        */
/*   Description  : ������ ��û ���� ������/���                                */
/*   Note         : ����                                                        */
/*   Creation     : 2005-03-14  �̽���                                          */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/

package servlet.hris.G;
/*
 * �ۼ��� ��¥: 2005. 1. 31.
 *
 */
import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;
import hris.E.E19Congra.E19CongcondData;
import hris.E.E19Congra.rfc.E19CongraRequestRFC;
import hris.G.ApprovalReturnState;
import hris.G.rfc.G001ApprovalProcessRFC;
import hris.common.*;
import hris.common.rfc.PersonInfoRFC;
import hris.common.util.AppUtil;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.Properties;
import java.util.Vector;

//import hris.common.rfc.PersInfoWithNoRFC;

/**
 * @author �̽���
 *
 */
public class G004ApprovalIngCongraSV extends EHRBaseServlet
{
    /* (��Javadoc)
     * @see com.sns.jdf.servlet.EHRBaseServlet#performTask(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse)
     */
    protected void performTask(HttpServletRequest req, HttpServletResponse res)
            throws GeneralException
    {
        try{
            HttpSession session = req.getSession(false);
            WebUserData user = WebUtil.getSessionUser(req);
            
            E19CongcondData     e19CongcondData;
            Vector              E19CongcondData_vt;
            Vector              vcAppLineData;

            String dest  = "";
            String jobid = "";
            
            Box box = WebUtil.getBox(req);
            
            String AINF_SEQN       = box.get("AINF_SEQN");
            
            String RequestPageName = box.get("RequestPageName");
            req.setAttribute("RequestPageName", RequestPageName);
            
            jobid = box.get("jobid");
            if( jobid ==null || jobid.equals("") ){
                jobid = "search";
            } // end if
            
            if( jobid.equals("search") ) {

                E19CongraRequestRFC	rfc					=	new E19CongraRequestRFC();
//				PersInfoWithNoRFC			piRfc				=	new PersInfoWithNoRFC();
                PersonInfoRFC numfunc		=	new PersonInfoRFC();
                                 
                Vector              returnAll           = null;
                
                /*returnAll = rfc.detail(AINF_SEQN);*/
                
                E19CongcondData_vt  = (Vector)returnAll.get(0);
                vcAppLineData = AppUtil.getAppDetailVt(AINF_SEQN);
                
                e19CongcondData = (E19CongcondData)E19CongcondData_vt.get(0);
//                PersInfoData    pid = (PersInfoData) piRfc.getApproval(e19CongcondData.PERNR).get(0);
                PersonData phonenumdata;
                phonenumdata    =   (PersonData)numfunc.getPersonInfo(e19CongcondData.PERNR);
                
                req.setAttribute("PersInfoData" ,phonenumdata );
                req.setAttribute("E19CongcondData" ,e19CongcondData );
                req.setAttribute("vcAppLineData" ,vcAppLineData);

                req.setAttribute("jobid",              jobid);
                dest = WebUtil.JspURL+"G/G004ApprovalIngCongra.jsp";
            } else if (jobid.equals("save")) {
                
                e19CongcondData  = new E19CongcondData();
                box.copyToEntity(e19CongcondData);
                e19CongcondData.AEDTM   =   DataUtil.getCurrentDate();
                e19CongcondData.UNAME   =   user.empNo;
                
                e19CongcondData.WAGE_WONX = Double.toString(Double.parseDouble(e19CongcondData.WAGE_WONX) / 100.0) ;  // ����ӱ�
                e19CongcondData.CONG_WONX = Double.toString(Double.parseDouble(e19CongcondData.CONG_WONX) / 100.0) ;  // ������
                
                e19CongcondData.UNAME   =   user.empNo;
                e19CongcondData.AEDTM   =   DataUtil.getCurrentDate();
                
                E19CongcondData_vt  =   new Vector();
                E19CongcondData_vt.add(e19CongcondData);
                AppLineData         tempAppLine;
                
                Vector vcTempAppLineData   = new Vector();
                AppLineData    appLine     = new AppLineData();
                // ������ 
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
                
                Logger.debug.println(this ,appLine);
                vcAppLineData   =   new Vector();
                vcAppLineData.add(appLine);
                
                G001ApprovalProcessRFC  Apr = new G001ApprovalProcessRFC();
                Vector vcRet = Apr.setApprovalStatutsList(vcAppLineData ,"T_ZHRA002T" ,E19CongcondData_vt);
                
                Logger.debug.println(this ,vcRet);
                ApprovalReturnState ars = (ApprovalReturnState) vcRet.get(0);
                
                PersonInfoRFC numfunc = new PersonInfoRFC();
                PersonData phonenumdata;
                phonenumdata    =   (PersonData)numfunc.getPersonInfo(e19CongcondData.PERNR);
                
                Properties ptMailBody = new Properties();
                ptMailBody.setProperty("SServer",user.SServer);                 // ElOffice ���� ����
                ptMailBody.setProperty("from_empNo" ,user.empNo);               // �� �߼��� ���
                ptMailBody.setProperty("to_empNo" ,e19CongcondData.PERNR);      // �� ������ ���
                
                ptMailBody.setProperty("ename" ,phonenumdata.E_ENAME);          // (��)��û�ڸ� 
                ptMailBody.setProperty("empno" ,phonenumdata.E_PERNR);         // (��)��û�� ���
                
                ptMailBody.setProperty("UPMU_NAME" ,"������");                  // ���� �̸�
                ptMailBody.setProperty("AINF_SEQN" ,AINF_SEQN);                 // ��û�� ����
                
                // �� ����
                StringBuffer sbSubject = new StringBuffer(512);
                
                sbSubject.append("[" + ptMailBody.getProperty("UPMU_NAME") + "] ");
                sbSubject.append(user.ename  + "���� ");

                String msg;
                String msg2 = null;
                String to_empNo = e19CongcondData.PERNR;
                
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
            }

            Logger.debug.println(this, " destributed = " + dest);
            printJspPage(req, res, dest);

        } catch(Exception e) {
            throw new GeneralException(e);
        } finally {
            
        }

    }

}
