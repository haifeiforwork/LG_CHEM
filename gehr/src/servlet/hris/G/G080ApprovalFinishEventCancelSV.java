/********************************************************************************/
/*                                                                              */
/*   System Name  : e-HR                                                        */
/*   1Depth Name  : HR ������                                                   */
/*   2Depth Name  : ���� �Ϸ� ����                                              */
/*   Program Name : ������ҽ�û ��û                                               */
/*   Program ID   : G080ApprovalFinishEventCancelSV                              */
/*   Description  : ������ҽ�û ��û ���� �Ϸ�                                     */
/*   Note         : ����                                                        */
/*   Creation     : 2013-006-12 lsa������ҽ�û ���� �߰� | [��û��ȣ]C20130627_58399   */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/

package servlet.hris.G;

import hris.C.C03EventCancel.C03EventCancelData;
import hris.C.C03EventCancel.rfc.C03EventCancelApplRFC;
import hris.C.C02Curri.C02CurriInfoData;
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


public class G080ApprovalFinishEventCancelSV extends EHRBaseServlet 
{
    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        try{
            HttpSession session = req.getSession(false);
            WebUserData user = WebUtil.getSessionUser(req);

            Vector vcC03EventCancelData;
            Vector vcAppLineData;
            
            C03EventCancelData c03EventCancelData;
            
            String dest;
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
                 
                C03EventCancelApplRFC func = new C03EventCancelApplRFC();
                vcC03EventCancelData = func.getDetail( AINF_SEQN );
                Logger.debug.println(this ,vcC03EventCancelData);

                if( vcC03EventCancelData.size() < 1 ){
                    String msg = "System Error! \n\n ��ȸ�� �׸��� �����ϴ�.";
                    req.setAttribute("msg", msg);
                    dest = WebUtil.JspURL+"common/caution.jsp";
                }else{
                    // ������ҽ�û
                    c03EventCancelData = (C03EventCancelData)vcC03EventCancelData.get(0);
                    
                    // ������ ����
                    vcAppLineData = AppUtil.getAppChangeVt(AINF_SEQN);
                    
                    PersInfoWithNoRFC   piRfc   = new PersInfoWithNoRFC();
                    PersInfoData        pid     = (PersInfoData) piRfc.getApproval(c03EventCancelData.PERNR).get(0);
                    req.setAttribute("PersInfoData" ,pid );
                    
                    // ���� ����
                    C02CurriInfoData c02CurriInfoData = (C02CurriInfoData)(new EducationInfoRFC()).getEducationInfo(c03EventCancelData.GWAID ,c03EventCancelData.CHAID);

                    req.setAttribute("c03EventCancelData", c03EventCancelData);
                    req.setAttribute("c02CurriInfoData", c02CurriInfoData);
                    req.setAttribute("vcAppLineData" , vcAppLineData);
                   
                    dest = WebUtil.JspURL+"G/G080ApprovalFinishEventCancel.jsp";
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