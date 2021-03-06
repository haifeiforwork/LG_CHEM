/*                                                                              */
/*   System Name  : e-HR                                                        */
/*   1Depth Name  : HR 결재함                                                   */
/*   2Depth Name  : 결재 완료 문서                                              */
/*   Program Name : 교육/출 신청                                              */
/*   Program ID   : G070ApprovalFinishEduTripSV                                    */
/*   Description  : 교육/출장 신청 결재 완료                                    */
/*   Note         : 없음                                                        */
/*   Creation     : 2010-03-09 lsa                                          */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/

package servlet.hris.G;

import hris.D.D19EduTrip.D19EduTripData;
import hris.D.D19EduTrip.rfc.D19EduTripRFC;
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


public class G070ApprovalFinishEduTripSV extends EHRBaseServlet 
{
    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        try{
            HttpSession session = req.getSession(false);
            WebUserData user = WebUtil.getSessionUser(req);
            
            Vector  vcAppLineData;
            Vector  vcD19EduTripData; 
            
            D19EduTripData   D19EduTripData;
            
            String dest  = "";
            String jobid = "";
            
            Box box = WebUtil.getBox(req);
            
            String  AINF_SEQN  = box.get("AINF_SEQN");
            
            // 처리 후 돌아 갈 페이지
            String RequestPageName = box.get("RequestPageName");
            req.setAttribute("RequestPageName", RequestPageName);
            
            jobid = box.get("jobid");
            
            if(jobid == null || jobid.equals("") ){
                jobid = "search";
            }// end if
            
            if( jobid.equals("search") ) {

                D19EduTripRFC rfc           = new D19EduTripRFC();

                vcD19EduTripData = rfc.getVocation( );
//                vcD19EduTripData = rfc.getVocation( user.empNo,  AINF_SEQN);
                Logger.debug.println(this, vcD19EduTripData);
                
                if( vcD19EduTripData.size() < 1 ){
                    String msg = "System Error! \n\n 조회할 항목이 없습니다.";
                    req.setAttribute("msg", msg);
                    dest = WebUtil.JspURL+"common/caution.jsp";
                }else{
                    // (교육/출장)
                    D19EduTripData      = (D19EduTripData)vcD19EduTripData.get(0);
                    // 결재자 정보
                    vcAppLineData = AppUtil.getAppChangeVt(AINF_SEQN);
                    
                    PersInfoWithNoRFC   piRfc   = new PersInfoWithNoRFC();
                    PersInfoData        pid     = (PersInfoData) piRfc.getApproval(D19EduTripData.PERNR).get(0);
                    req.setAttribute("PersInfoData" ,pid );
                    
                    req.setAttribute("D19EduTripData", D19EduTripData);
                    req.setAttribute("vcAppLineData" , vcAppLineData);
                    
                    dest = WebUtil.JspURL+"G/G070ApprovalFinishEduTrip.jsp";
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