/********************************************************************************/
/*                                                                              */
/*   System Name  : e-HR                                                        */
/*   1Depth Name  : HR 결재함                                                   */
/*   2Depth Name  : 결재 완료 문서                                              */
/*   Program Name : 식권/영업사원 신청                                          */
/*   Program ID   : G045ApprovalFinishMealChargeSV                              */
/*   Description  : 식권/영업사원 신청 결재 완료                                */
/*   Note         : 없음                                                        */
/*   Creation     : 2005-03-14  이승희                                          */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/

package servlet.hris.G;

import hris.G.MealChargeData;
import hris.G.rfc.MealChargeRFC;
import hris.common.PersInfoData;
import hris.common.WebUserData;
import hris.common.approval.ApprovalHeader;
import hris.common.rfc.PersInfoWithNoRFC;
import hris.common.rfc.PersonInfoRFC;
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


public class G045ApprovalFinishMealChargeSV extends EHRBaseServlet
{
    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        try{
            HttpSession session = req.getSession(false);
            WebUserData user = WebUtil.getSessionUser(req);


            Vector vcMealChargeData;
            Vector vcAppLineData;

            MealChargeData mealChargeData;

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

                MealChargeRFC  rfc       = new MealChargeRFC();

                vcMealChargeData = rfc.getMealChargeData( AINF_SEQN );
                Logger.debug.println(this ,vcMealChargeData);

                if( vcMealChargeData.size() < 1 ){
                    String msg = "System Error! \n\n 조회할 항목이 없습니다.";
                    req.setAttribute("msg", msg);
                    dest = WebUtil.JspURL+"common/caution.jsp";
                }else{
                    // 국민연금 자격변경
                    mealChargeData = (MealChargeData)vcMealChargeData.get(0);

                    // 결재자 정보
                    vcAppLineData = AppUtil.getAppChangeVt(AINF_SEQN);

                    PersonInfoRFC personInfoRFC = new PersonInfoRFC();
                    ApprovalHeader approvalHeader = personInfoRFC.getApprovalHeader(mealChargeData.PERNR);
                    // header 정보
                    req.setAttribute("approvalHeader", approvalHeader);

                    req.setAttribute("mealChargeData", mealChargeData);
                    req.setAttribute("vcAppLineData"  , vcAppLineData);

                    dest = WebUtil.JspURL+"G/G045ApprovalFinishMealCharge.jsp";
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