/********************************************************************************/
/*                                                                              */
/*   System Name  : e-HR                                                        */
/*   1Depth Name  : HR 결재함                                                   */
/*   2Depth Name  : 결재 완료 문서                                              */
/*   Program Name : 입학 축하금 신청                                            */
/*   Program ID   : G014ApprovalFinishEntranceSV                                */
/*   Description  : 입학 축하금 신청 결재 완료                                  */
/*   Note         : 없음                                                        */
/*   Creation     : 2005-03-14  이승희                                          */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/

package servlet.hris.G;

import hris.E.E21Entrance.E21EntranceData;
import hris.E.E21Entrance.rfc.E21EntranceRFC;
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


public class G014ApprovalFinishEntranceSV extends EHRBaseServlet 
{
	protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        try{
            HttpSession session = req.getSession(false);
            WebUserData user = WebUtil.getSessionUser(req);

            Vector              vcAppLineData;
            E21EntranceData     e21EntranceData;
            Vector              vcE21EntranceData;
            
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
                
                E21EntranceRFC rfc                 = new E21EntranceRFC();
                vcE21EntranceData = rfc.getEntrance( user.empNo, AINF_SEQN );
                                
                e21EntranceData = (E21EntranceData) vcE21EntranceData.get(0);
                
                Logger.debug.println(this, "e10PersonalData : " + e21EntranceData);

                vcAppLineData = AppUtil.getAppChangeVt(AINF_SEQN);
                
                PersInfoWithNoRFC   piRfc              = new PersInfoWithNoRFC();
                PersInfoData    pid = (PersInfoData) piRfc.getApproval(e21EntranceData.PERNR).get(0);
                req.setAttribute("PersInfoData" ,pid );

                req.setAttribute("e21EntranceData"  , e21EntranceData);
                req.setAttribute("vcAppLineData"    , vcAppLineData);
                dest = WebUtil.JspURL+"G/G014ApprovalFinishEntrance.jsp";
                
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