/********************************************************************************/
/*                                                                              */
/*   System Name  : e-HR                                                        */
/*   1Depth Name  : HR 결재함                                                   */
/*   2Depth Name  : 결재 완료 문서                                              */
/*   Program Name : 가족수당 신청                                               */
/*   Program ID   : G048ApprovalFinishAllowanceSV                               */
/*   Description  : 가족수당 신청 결재 완료                                     */
/*   Note         : 없음                                                        */
/*   Creation     : 2005-03-14  이승희                                          */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/

package servlet.hris.G;

import hris.A.A12Family.A12FamilyBuyangData;
import hris.A.A12Family.A12FamilyListData;
import hris.A.A12Family.rfc.A12FamilyListRFC;
import hris.A.A12Family.rfc.A12FamilySudangRFC;
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


public class G048ApprovalFinishAllowanceSV extends EHRBaseServlet 
{
    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        try{
            HttpSession session = req.getSession(false);
            WebUserData user = WebUtil.getSessionUser(req);
            

            Vector vcA12FamilyBuyangData;
            Vector vcAppLineData;
            
            A12FamilyBuyangData a12FamilyBuyangData;
            
            String dest  = "";
            String jobid = "";
            String bankflag  = "01";
            
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
                
                A12FamilySudangRFC  rfc       = new A12FamilySudangRFC();
                
                vcA12FamilyBuyangData = rfc.getFamilySudang( AINF_SEQN );
                Logger.debug.println(this ,vcA12FamilyBuyangData);

                if( vcA12FamilyBuyangData.size() < 1 ){
                    String msg = "System Error! \n\n 조회할 항목이 없습니다.";
                    req.setAttribute("msg", msg);
                    dest = WebUtil.JspURL+"common/caution.jsp";
                }else{
                    // 가족 수당 신청
                    a12FamilyBuyangData = (A12FamilyBuyangData)vcA12FamilyBuyangData.get(0);
                    
                    /* 신청할 가족 데이터 */
                    A12FamilyListRFC    rfc_list            = new A12FamilyListRFC();
                    Vector              vcA12FamilyListData = rfc_list.getFamilyList(a12FamilyBuyangData.PERNR, a12FamilyBuyangData.SUBTY, a12FamilyBuyangData.OBJPS);
                    A12FamilyListData   a12FamilyListData   = (A12FamilyListData)vcA12FamilyListData.get(0);
                    
                    // 결재자 정보
                    vcAppLineData = AppUtil.getAppChangeVt(AINF_SEQN);
                    
                    PersInfoWithNoRFC   piRfc   = new PersInfoWithNoRFC();
                    PersInfoData        pid     = (PersInfoData) piRfc.getApproval(a12FamilyBuyangData.PERNR).get(0);
                    req.setAttribute("PersInfoData" ,pid );
                    
                    req.setAttribute("a12FamilyBuyangData", a12FamilyBuyangData);
                    req.setAttribute("a12FamilyListData", a12FamilyListData);
                    req.setAttribute("vcAppLineData"  , vcAppLineData);
                    
                    dest = WebUtil.JspURL+"G/G048ApprovalFinishAllowance.jsp";
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