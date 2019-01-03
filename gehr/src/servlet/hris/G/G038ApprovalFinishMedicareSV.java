/********************************************************************************/
/*                                                                              */
/*   System Name  : e-HR                                                        */
/*   1Depth Name  : HR ������                                                   */
/*   2Depth Name  : ���� �Ϸ� ����                                              */
/*   Program Name : �ǰ����� �Ǻξ��� ��û                                      */
/*   Program ID   : G038ApprovalFinishMedicareSV                                */
/*   Description  : �ǰ����� �Ǻξ��� ��û ���� �Ϸ�                            */
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
import hris.E.E01Medicare.E01HealthGuaranteeData;
import hris.E.E01Medicare.rfc.E01HealthGuaranteeRFC;
import hris.common.PersInfoData;
import hris.common.WebUserData;
import hris.common.rfc.PersInfoWithNoRFC;
import hris.common.util.AppUtil;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.Vector;


public class G038ApprovalFinishMedicareSV extends EHRBaseServlet 
{
    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        try{
            HttpSession session = req.getSession(false);
            WebUserData user = WebUtil.getSessionUser(req);
            
            Vector vcE01HealthGuaranteeData = null;
            Vector vcAppLineData;
            
            E01HealthGuaranteeData e01HealthGuaranteeData;
            
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
                
                E01HealthGuaranteeRFC  rfc       = new E01HealthGuaranteeRFC();

//                vcE01HealthGuaranteeData = rfc.getHealthGuarantee( "", AINF_SEQN );
//                Logger.debug.println(this ,vcE01HealthGuaranteeData);

                if( vcE01HealthGuaranteeData.size() < 1 ){
                    String msg = "System Error! \n\n ��ȸ�� �׸��� �����ϴ�.";
                    req.setAttribute("msg", msg);
                    dest = WebUtil.JspURL+"common/caution.jsp";
                }else{
                    // �ǰ����� �Ǻξ��� ��û
                    e01HealthGuaranteeData = (E01HealthGuaranteeData)vcE01HealthGuaranteeData.get(0);
                    
                    // ������ ����
                    vcAppLineData = AppUtil.getAppChangeVt(AINF_SEQN);
                    
                    PersInfoWithNoRFC   piRfc   = new PersInfoWithNoRFC();
                    PersInfoData        pid     = (PersInfoData) piRfc.getApproval(e01HealthGuaranteeData.PERNR).get(0);
                    req.setAttribute("PersInfoData" ,pid );
                    
                    req.setAttribute("vcE01HealthGuaranteeData", vcE01HealthGuaranteeData);
                    req.setAttribute("vcAppLineData"  , vcAppLineData);
                    
                    dest = WebUtil.JspURL+"G/G038ApprovalFinishMedicare.jsp";
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