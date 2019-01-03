/********************************************************************************/
/*                                                                              */
/*   System Name  : e-HR                                                        */
/*   1Depth Name  : HR 결재함                                                   */
/*   2Depth Name  : 결재 완료 문서                                              */
/*   Program Name : 교육신청 신청                                               */
/*   Program ID   : G058ApprovalFinishCurriculumSV                              */
/*   Description  : 교육신청 신청 결재 완료                                     */
/*   Note         : 없음                                                        */
/*   Creation     : 2005-03-14  이승희                                          */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/

package servlet.hris.G;

import hris.C.C02Curri.C02CurriApplData;
import hris.C.C02Curri.C02CurriInfoData;
import hris.C.C02Curri.rfc.C02CurriApplRFC;
import hris.G.ApprovalReturnState;
import hris.G.rfc.CancelEduRFC;
import hris.G.rfc.EducationInfoRFC;
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


public class G058ApprovalFinishCurriculumSV extends EHRBaseServlet 
{
    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        try{
            HttpSession session = req.getSession(false);
            WebUserData user = WebUtil.getSessionUser(req);

            Vector vcC02CurriApplData;
            Vector vcAppLineData;
            
            C02CurriApplData c02CurriApplData;
            
            String dest;
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
                
                C02CurriApplRFC func = new C02CurriApplRFC();
                vcC02CurriApplData = func.getDetail( AINF_SEQN );
                
                Logger.debug.println(this ,vcC02CurriApplData);

                if( vcC02CurriApplData.size() < 1 ){
                    String msg = "System Error! \n\n 조회할 항목이 없습니다.";
                    req.setAttribute("msg", msg);
                    dest = WebUtil.JspURL+"common/caution.jsp";
                }else{
                    // 교육시청
                    c02CurriApplData = (C02CurriApplData)vcC02CurriApplData.get(0);
                    
                    // 결재자 정보
                    vcAppLineData = AppUtil.getAppChangeVt(AINF_SEQN);
                    
                    PersInfoWithNoRFC   piRfc   = new PersInfoWithNoRFC();
                    PersInfoData        pid     = (PersInfoData) piRfc.getApproval(c02CurriApplData.PERNR).get(0);
                    req.setAttribute("PersInfoData" ,pid );
                    
                    // 교육 정보
                    C02CurriInfoData c02CurriInfoData = (C02CurriInfoData)(new EducationInfoRFC()).getEducationInfo(c02CurriApplData.GWAID ,c02CurriApplData.CHAID);

                    req.setAttribute("c02CurriApplData", c02CurriApplData);
                    req.setAttribute("c02CurriInfoData", c02CurriInfoData);
                    req.setAttribute("vcAppLineData" , vcAppLineData);
                   
                    dest = WebUtil.JspURL+"G/G058ApprovalFinishCurriculum.jsp";
                } // end if
            } else if( jobid.equals("save") ) {
                
                ApprovalReturnState ars = (ApprovalReturnState) (new CancelEduRFC()).cancelEdu(AINF_SEQN);
                Logger.debug.println(this ,ars);
                
                String msg;
                String msg2 = "";
                String url;
                
                if (ars.E_RETURN.equals("S")) {
                    msg = "교육 참가 취소 되었습니다.";
                    url = "location.href = \"" + RequestPageName.replace('|','&') + "\";";
                } else {
                    msg = ars.E_MESSAGE;
                    url = "location.href = \"" + WebUtil.ServletURL + 
                        "hris.G.G058ApprovalFinishCurriculumSV?AINF_SEQN="+ AINF_SEQN+"&RequestPageName=" + RequestPageName + "\";";
                } // end if
                
                req.setAttribute("msg", msg);
                req.setAttribute("url", url);
                
                dest = WebUtil.JspURL+"common/msg.jsp";
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