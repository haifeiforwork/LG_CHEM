/********************************************************************************/
/*                                                                              */
/*   System Name  : e-HR                                                        */
/*   1Depth Name  : HR 결재함                                                   */
/*   2Depth Name  : 결재 완료 문서                                              */
/*   Program Name : 개인연금 신청                                               */
/*   Program ID   : G011ApprovalFinishPersonalSV                                */
/*   Description  : 개인연금 신청 결재 완료                                     */
/*   Note         : 없음                                                        */
/*   Creation     : 2005-03-14  이승희                                          */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/

package servlet.hris.G;

import hris.E.E10Personal.E10PersonalData;
import hris.E.E10Personal.rfc.E10PersonalApplRFC;
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


public class G011ApprovalFinishPersonalSV extends EHRBaseServlet 
{
	protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        try{
            HttpSession session = req.getSession(false);
            WebUserData user = WebUtil.getSessionUser(req);

            Vector              vcAppLineData;
            E10PersonalData     e10PersonalData;
            Vector              vcE10PersonalData;
            
            String dest  = "";
            String jobid = "";
            Box box = WebUtil.getBox(req);
            
            String  AINF_SEQN  = box.get("AINF_SEQN");
            
            String RequestPageName = box.get("RequestPageName");
            req.setAttribute("RequestPageName", RequestPageName);
            
            jobid = box.get("jobid");
            Logger.debug.println("jobid = " + jobid);
            if(jobid == null || jobid.equals("") ){
                jobid = "search";
            }// end if
            
            if( jobid.equals("search") ) {
                
                E10PersonalApplRFC  rfc  = new E10PersonalApplRFC();
                vcE10PersonalData = rfc.getPersList( AINF_SEQN );
                
                e10PersonalData = (E10PersonalData) vcE10PersonalData.get(0);
                
                Logger.debug.println(this, "e10PersonalData : " + e10PersonalData);

                vcAppLineData = AppUtil.getAppChangeVt(AINF_SEQN);
                
                PersInfoWithNoRFC   piRfc              = new PersInfoWithNoRFC();
                PersInfoData    pid = (PersInfoData) piRfc.getApproval(e10PersonalData.PERNR).get(0);
                req.setAttribute("PersInfoData" ,pid );
                
                req.setAttribute("e10PersonalData"    , e10PersonalData);
                req.setAttribute("vcAppLineData" , vcAppLineData);
                dest = WebUtil.JspURL+"G/G011ApprovalFinishPersonal.jsp";
            } else {
                throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
            } // end if

            printJspPage(req, res, dest);

        } catch(Exception e) {
            Logger.err.println(DataUtil.getStackTrace(e));
            throw new GeneralException(e);
        } finally {
            
        }
	}
}