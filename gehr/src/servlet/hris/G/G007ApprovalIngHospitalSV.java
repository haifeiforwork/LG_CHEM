/********************************************************************************/
/*                                                                              */
/*   System Name  : e-HR                                                        */
/*   1Depth Name  : HR ������                                                   */
/*   2Depth Name  : ���� ������ ����                                            */
/*   Program Name : �Ƿ�� ��û                                                 */
/*   Program ID   : G004ApprovalCongraSV                                        */
/*   Description  : �Ƿ�� ���� ���                                            */
/*   Note         : ����                                                        */
/*   Creation     : 2005-03-14  �̽���                                          */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/

package servlet.hris.G;

import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;
import hris.E.E17Hospital.E17HospitalData;
import hris.E.E17Hospital.E17HospitalResultData;
import hris.E.E17Hospital.E17SickData;
import hris.E.E17Hospital.rfc.E17HospitalRFC;
import hris.E.E17Hospital.rfc.E17MedicCheckYNRFC;
import hris.E.E18Hospital.E18HospitalListData;
import hris.E.E18Hospital.rfc.E18HospitalListRFC;
import hris.G.ApprovalReturnState;
import hris.G.rfc.G001ApprovalProcessRFC;
import hris.common.*;
import hris.common.rfc.PersInfoWithNoRFC;
import hris.common.rfc.PersonInfoRFC;
import hris.common.util.AppUtil;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.Properties;
import java.util.Vector;


public class G007ApprovalIngHospitalSV extends EHRBaseServlet 
{

	protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
       try{
            HttpSession session = req.getSession(false);
            WebUserData user = WebUtil.getSessionUser(req);

            Vector              vcAppLineData;
            E17SickData         e17SickData;
            E17HospitalResultData returnAll;
            Vector              vcE17SickData;
            Vector              vcE17HospitalData;
            
            String dest  = "";
            String jobid = "";
            Box box = WebUtil.getBox(req);
            
            String  AINF_SEQN  = box.get("AINF_SEQN");
            
            String RequestPageName = box.get("RequestPageName");
            req.setAttribute("RequestPageName", RequestPageName);
            
            jobid = box.get("jobid");
            if(jobid == null || jobid.equals("") ){
                jobid = "search";
            }// end if

            if( jobid.equals("search") ) {

                E17HospitalRFC      rfc                = new E17HospitalRFC();
                PersInfoWithNoRFC   piRfc              = new PersInfoWithNoRFC();
                Vector              E17BillData_vt;
                
                String             l_CTRL_NUMB         = "";
                String             P_Flag              = "";
                double            dWCOMP_SUM            = 0.0;
                double            dSCOMP_SUM            = 0.0;
                
                returnAll = rfc.detail();
                Logger.debug.println(this, returnAll);

                vcE17SickData       = (Vector)returnAll.T_ZHRA006T;
                vcE17HospitalData   = (Vector)returnAll.T_ZHRW005A;
                vcAppLineData       = AppUtil.getAppChangeVt(AINF_SEQN);

                if(vcE17SickData.size() < 1){
                    String msg = "��ȸ�� �׸��� �����͸� �о���̴� �� ������ �߻��߽��ϴ�.";
                    String url = "history.back();";
                    req.setAttribute("msg", msg);
                    req.setAttribute("url", url);
                    dest = WebUtil.JspURL+"common/msg.jsp";
                }else{
                    e17SickData = (E17SickData)vcE17SickData.get(0);
                    
                    
                    E17MedicCheckYNRFC checkYN = new E17MedicCheckYNRFC();
                    P_Flag  = checkYN.getE_FLAG( DataUtil.getCurrentYear(), e17SickData.PERNR );
                   
                    //  ȸ������ �Ѿ��� �����ֱ� ���ؼ� �Ѿ��� ����Ѵ�.
                    E18HospitalListRFC func_E18            = new E18HospitalListRFC();
                    Vector             E18HospitalData_vt  = new Vector();
                    E18HospitalData_vt = func_E18.getHospitalList( e17SickData.PERNR) ;
                    
                    for ( int i = 0 ; i < E18HospitalData_vt.size() ; i++ ) {
                        E18HospitalListData data_18 = ( E18HospitalListData ) E18HospitalData_vt.get( i ) ;
                        l_CTRL_NUMB = data_18.CTRL_NUMB.substring(0, 4);
                        if( data_18.GUEN_CODE.equals("0001") && l_CTRL_NUMB.equals(e17SickData.BEGDA.substring(0, 4)) ) {
                            dSCOMP_SUM = dSCOMP_SUM + Double.parseDouble( data_18.COMP_WONX );
                        } else if( data_18.GUEN_CODE.equals("0002") && l_CTRL_NUMB.equals(e17SickData.BEGDA.substring(0, 4)) ) {
                            dWCOMP_SUM = dWCOMP_SUM + Double.parseDouble( data_18.COMP_WONX );
                        } // end if
                    } // end for
                    
                    PersInfoData    pid = (PersInfoData) piRfc.getApproval(e17SickData.PERNR).get(0);
                    
                    req.setAttribute("PersInfoData" ,pid );
                    req.setAttribute("e17SickData"       , e17SickData);
                    req.setAttribute("vcE17HospitalData", vcE17HospitalData);
                    req.setAttribute("vcAppLineData"     , vcAppLineData);
                    
                    req.setAttribute("P_Flag"           , P_Flag);
                    req.setAttribute("WCOMP_SUM"        , Double.toString(dWCOMP_SUM));
                    req.setAttribute("SCOMP_SUM"        , Double.toString(dSCOMP_SUM));
                    
                    dest = WebUtil.JspURL+"G/G007ApprovalIngHospital.jsp";
                } // end if

            } else if( jobid.equals("save") ) {

                e17SickData         = new E17SickData();
               
                vcAppLineData       = new Vector();
                
                vcE17SickData       = new Vector();
                vcE17HospitalData   = new Vector();
                
                E17HospitalData     e17HospitalData;
                AppLineData         tempAppLine;
                
                Vector vcTempAppLineData   = new Vector();
                AppLineData    appLine        = new AppLineData();
                
                // �Ƿ�� ���� �ڷ�
                box.copyToEntity(e17SickData);
                if (e17SickData.WAERS.equals("KRW")) {
                    e17SickData.COMP_WONX= Double.toString(Double.parseDouble(e17SickData.COMP_WONX) / 100.0) ;  // ����ӱ�
                    e17SickData.YTAX_WONX = Double.toString(Double.parseDouble(e17SickData.YTAX_WONX) / 100.0) ;  // ������
                } // end if
                
                e17SickData.UNAME   =   user.empNo;
                e17SickData.AEDTM   =   DataUtil.getCurrentDate();
                
                vcE17SickData.add(e17SickData);
                
                int nRowCount = Integer.parseInt(box.getString("HospitalRowCount"));
                for (int i = 0; i < nRowCount; i++) {
                    e17HospitalData = new E17HospitalData();
                    box.copyToEntity(e17HospitalData ,i);
                    e17HospitalData.BEGDA   =   e17SickData.BEGDA;
                    e17HospitalData.COMP_WONX = e17SickData.COMP_WONX;
                    if (e17SickData.WAERS.equals("KRW")) {
                        e17HospitalData.EMPL_WONX = Double.toString(Double.parseDouble( e17HospitalData.EMPL_WONX) / 100.0) ;  // ���� �ǳ��ξ�
                    } // end if
                    vcE17HospitalData.add(e17HospitalData);
                } // end for
                
                // ������ ���� 
                nRowCount = Integer.parseInt(box.getString("RowCount"));
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
                Vector vcRet = Apr.setApprovalStatutsList(vcAppLineData ,"T_ZHRA006T" ,vcE17SickData ,"T_ZHRW005A" ,vcE17HospitalData);
                
                Logger.debug.println(this ,vcRet);
                ApprovalReturnState ars = (ApprovalReturnState) vcRet.get(0);
                
                PersonInfoRFC numfunc = new PersonInfoRFC();
                PersonData phonenumdata;
                phonenumdata    =   (PersonData)numfunc.getPersonInfo(e17SickData.PERNR);
                
                Properties ptMailBody = new Properties();
                ptMailBody.setProperty("SServer",user.SServer);                 // ElOffice ���� ����
                ptMailBody.setProperty("from_empNo" ,user.empNo);               // �� �߼��� ���
                
                ptMailBody.setProperty("ename" ,phonenumdata.E_ENAME);          // (��)��û�ڸ� 
                ptMailBody.setProperty("empno" ,phonenumdata.E_PERNR);          // (��)��û�� ���
                
                ptMailBody.setProperty("UPMU_NAME" ,"�Ƿ��");                  // ���� �̸�
                ptMailBody.setProperty("AINF_SEQN" ,AINF_SEQN);                 // ��û�� ����
                
                // �� ����
                StringBuffer sbSubject = new StringBuffer(512);
                
                sbSubject.append("[" + ptMailBody.getProperty("UPMU_NAME") + "] ");
                sbSubject.append(user.ename  + "���� ");

                String msg;
                String msg2 = "";
                String to_empNo = e17SickData.PERNR;
                
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