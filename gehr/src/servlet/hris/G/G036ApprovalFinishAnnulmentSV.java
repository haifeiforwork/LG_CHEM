/*                                                                              */
/*   System Name  : e-HR                                                        */
/*   1Depth Name  : HR ������                                                   */
/*   2Depth Name  : ���� �Ϸ� ����                                              */
/*   Program Name : ���ο��� �ؾ� ��û                                          */
/*   Program ID   : G036ApprovalFinishAnnulmentSV                               */
/*   Description  : ���ο��� �ؾ� ��û ���� �Ϸ�                                */
/*   Note         : ����                                                        */
/*   Creation     : 2005-03-14  �̽���                                          */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/

package servlet.hris.G;

import hris.E.E11Personal.E11PersonalData;
import hris.E.E11Personal.rfc.E11PersonalApplRFC;
import hris.E.E11Personal.rfc.E11PersonalDetailRFC;
import hris.common.PersInfoData;
import hris.common.WebUserData;
import hris.common.rfc.PersInfoWithNoRFC;
import hris.common.util.AppUtil;

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


public class G036ApprovalFinishAnnulmentSV extends EHRBaseServlet 
{
    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        try{
            HttpSession session = req.getSession(false);
            WebUserData user = WebUtil.getSessionUser(req);
            
            Vector vcE11PersonalData;
            Vector vcAppLineData;
            
            E11PersonalData e11PersonalData;
            
            String dest  = "";
            String jobid = "";
            String bankflag  = "01";
            
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
                
                E11PersonalApplRFC   func       = new E11PersonalApplRFC();
                
                vcE11PersonalData = func.getPersList(AINF_SEQN);
                Logger.debug.println(this ,vcE11PersonalData);

                if( vcE11PersonalData.size() < 1 ){
                    String msg = "System Error! \n\n ��ȸ�� �׸��� �����ϴ�.";
                    req.setAttribute("msg", msg);
                    dest = WebUtil.JspURL+"common/caution.jsp";
                }else{
                    // ���� ���� ����
                    e11PersonalData = (E11PersonalData)vcE11PersonalData.get(0);
                    
                    // ���� �߰� ����
                    E11PersonalDetailRFC appendFunc = new E11PersonalDetailRFC();
                    E11PersonalData appendData = (E11PersonalData)appendFunc.getDetail( e11PersonalData.PERNR, e11PersonalData.PENT_TYPE, e11PersonalData.ENTR_DATE ).get(0);
                    
                    // ������ ����
                    vcAppLineData = AppUtil.getAppChangeVt(AINF_SEQN);
                    
                    PersInfoWithNoRFC   piRfc   = new PersInfoWithNoRFC();
                    PersInfoData        pid     = (PersInfoData) piRfc.getApproval(e11PersonalData.PERNR).get(0);
                    req.setAttribute("PersInfoData" ,pid );
                    
                    req.setAttribute("e11PersonalData", e11PersonalData);
                    req.setAttribute("appendData"     , appendData);
                    req.setAttribute("vcAppLineData"  , vcAppLineData);
                    
                    dest = WebUtil.JspURL+"G/G036ApprovalFinishAnnualment.jsp";
                } // end if
            
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