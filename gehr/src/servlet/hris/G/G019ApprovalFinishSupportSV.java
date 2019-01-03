/********************************************************************************/
/*                                                                              */
/*   System Name  : e-HR                                                        */
/*   1Depth Name  : HR 결재함                                                   */
/*   2Depth Name  : 결재 완료 문서                                              */
/*   Program Name : 부양가족 신청                                               */
/*   Program ID   : G019ApprovalFinishSupportSV                                 */
/*   Description  : 부양가족 신청 결재 완료                                     */
/*   Note         : 없음                                                        */
/*   Creation     : 2005-03-14  이승희                                          */
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
import hris.A.A12Family.A12FamilyBuyangData;
import hris.A.A12Family.A12FamilyListData;
import hris.A.A12Family.rfc.A12FamilyBuyangRFC;
import hris.A.A12Family.rfc.A12FamilyListRFC;
import hris.common.PersInfoData;
import hris.common.WebUserData;
import hris.common.rfc.PersInfoWithNoRFC;
import hris.common.util.AppUtil;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.Vector;


public class G019ApprovalFinishSupportSV extends EHRBaseServlet 
{
    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        try{
            HttpSession session = req.getSession(false);
            WebUserData user = WebUtil.getSessionUser(req);
            
            Vector  vcAppLineData;
            Vector  vcA12FamilyBuyangData;
            A12FamilyBuyangData     a12FamilyBuyangData;
            
            
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
                // 가족 상세 정보 
                A12FamilyListRFC    rfc_list  = new A12FamilyListRFC();
                Vector  vcA12FamilyListData;
                
                A12FamilyBuyangRFC rfc  = new A12FamilyBuyangRFC();
                vcA12FamilyBuyangData = rfc.getFamilyBuyang(  );

                Logger.debug.println(this, vcA12FamilyBuyangData);
                if( vcA12FamilyBuyangData.size() < 1 ){
                    String msg = "System Error! \n\n 조회할 항목이 없습니다.";
                    req.setAttribute("msg", msg);
                    dest = WebUtil.JspURL+"common/caution.jsp";
                }else{
                    
                    a12FamilyBuyangData = (A12FamilyBuyangData)vcA12FamilyBuyangData.get(0);
                    vcAppLineData = AppUtil.getAppChangeVt(AINF_SEQN);
                    
                    
                    vcA12FamilyListData = rfc_list.getFamilyList(a12FamilyBuyangData.PERNR, a12FamilyBuyangData.SUBTY, a12FamilyBuyangData.OBJPS);
                    A12FamilyListData   a12FamilyListData   = (A12FamilyListData)vcA12FamilyListData.get(0);
                    
                    PersInfoWithNoRFC   piRfc              = new PersInfoWithNoRFC();
                    PersInfoData    pid = (PersInfoData) piRfc.getApproval(a12FamilyBuyangData.PERNR).get(0);
                    req.setAttribute("PersInfoData" ,pid );
                    
                    req.setAttribute("a12FamilyListData", a12FamilyListData);
                    req.setAttribute("a12FamilyBuyangData", a12FamilyBuyangData);
                    req.setAttribute("vcAppLineData" , vcAppLineData);
                    
                    dest = WebUtil.JspURL+"G/G019ApprovalFinishSupport.jsp";
                }
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