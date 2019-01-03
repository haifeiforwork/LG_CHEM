/*                                                                              */
/*   System Name  : e-HR                                                        */
/*   1Depth Name  : HR ������                                                   */
/*   2Depth Name  : ���� �Ϸ� ����                                              */
/*   Program Name : ���� ��û                                                   */
/*   Program ID   : G021ApprovalFinishDisasterSV                                */
/*   Description  : ���� ��û ���� �Ϸ�                                         */
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
import hris.E.E19Disaster.E19CongcondData;
import hris.E.E19Congra.rfc.E19CongraRequestRFC;
import hris.common.PersInfoData;
import hris.common.WebUserData;
import hris.common.rfc.PersInfoWithNoRFC;
import hris.common.util.AppUtil;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.Vector;


public class G021ApprovalFinishDisasterSV extends EHRBaseServlet 
{
    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        try{
            HttpSession session = req.getSession(false);
            WebUserData user = WebUtil.getSessionUser(req);
            
            Vector  vcAppLineData;
            Vector vcE19CongcondData;
            Vector vcE19DisasterData;
            
            E19CongcondData e19CongcondData;
            
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
               
                
                E19CongraRequestRFC rfc = new E19CongraRequestRFC();
                Vector returnAll           = null;

//                returnAll = rfc.detail(AINF_SEQN);

                vcE19CongcondData = (Vector)returnAll.get(0);
                Logger.debug.println(this, vcE19CongcondData);
                
                if( vcE19CongcondData.size() < 1 ){
                    String msg = "System Error! \n\n ��ȸ�� �׸��� �����ϴ�.";
                    req.setAttribute("msg", msg);
                    dest = WebUtil.JspURL+"common/caution.jsp";
                }else{
                    // ���� �� ����
                    e19CongcondData = (E19CongcondData)vcE19CongcondData.get(0);
                    // ������ ����
                    vcAppLineData = AppUtil.getAppChangeVt(AINF_SEQN);
                    
                    // ���� ���ؽŰ�
                    vcE19DisasterData = (Vector)returnAll.get(1);
                    
                    PersInfoWithNoRFC   piRfc   = new PersInfoWithNoRFC();
                    PersInfoData        pid     = (PersInfoData) piRfc.getApproval(e19CongcondData.PERNR).get(0);
                    req.setAttribute("PersInfoData" ,pid );
                    
                    req.setAttribute("e19CongcondData", e19CongcondData);
                    req.setAttribute("vcE19DisasterData", vcE19DisasterData);
                    req.setAttribute("vcAppLineData" , vcAppLineData);
                    
                    dest = WebUtil.JspURL+"G/G021ApprovalFinishDisaster.jsp";
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