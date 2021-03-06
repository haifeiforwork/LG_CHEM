/*                                                                              */
/*   System Name  : e-HR                                                        */
/*   1Depth Name  : HR 결재함                                                   */
/*   2Depth Name  : 결재 완료 문서                                              */
/*   Program Name : 개인연금 해약 신청                                          */
/*   Program ID   : G036ApprovalFinishAnnulmentSV                               */
/*   Description  : 개인연금 해약 신청 결재 완료                                */
/*   Note         : 없음                                                        */
/*   Creation     : 2005-03-14  이승희                                          */
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
            
            // 처리 후 돌아 갈 페이지
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
                    String msg = "System Error! \n\n 조회할 항목이 없습니다.";
                    req.setAttribute("msg", msg);
                    dest = WebUtil.JspURL+"common/caution.jsp";
                }else{
                    // 개인 연금 해지
                    e11PersonalData = (E11PersonalData)vcE11PersonalData.get(0);
                    
                    // 연금 추가 정보
                    E11PersonalDetailRFC appendFunc = new E11PersonalDetailRFC();
                    E11PersonalData appendData = (E11PersonalData)appendFunc.getDetail( e11PersonalData.PERNR, e11PersonalData.PENT_TYPE, e11PersonalData.ENTR_DATE ).get(0);
                    
                    // 결재자 정보
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