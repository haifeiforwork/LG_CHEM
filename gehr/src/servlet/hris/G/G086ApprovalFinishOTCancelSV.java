/********************************************************************************/
/*                                                                              */
/*   System Name  : e-HR                                                        */
/*   1Depth Name  : HR 결재함                                                   */
/*   2Depth Name  : 결재 진행중 문서                                            */
/*   Program Name : 휴가 결재                                                   */
/*   Program ID   : G055ApprovalIngVacationSV                                   */
/*   Description  : 휴가  신청 결재진행중                                       */
/*   Note         : 없음                                                        */
/*   Creation     : 2005-03-10 유용원                                           */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/

package servlet.hris.G;

import hris.D.D01OT.D01OTData;
import hris.D.D01OT.rfc.D01OTRFC;
import hris.G.ApprovalCancelData;
import hris.G.rfc.ApprovalCancelRFC;
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

public class G086ApprovalFinishOTCancelSV extends EHRBaseServlet
{
    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        try{
            HttpSession session = req.getSession(false);
            WebUserData user = WebUtil.getSessionUser(req);

            ApprovalCancelRFC appRfc = new ApprovalCancelRFC();
            Vector          vcAppLineData      = null;
            Vector          orgVcAppLineData      = null;
            Vector 		   appCancelVt = null;
            Vector          d01OTData_vt = null;
            D01OTData d01OTData    = null;

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
            	//초과근무결재취소조회            	
            	appCancelVt = appRfc.get(user.empNo, AINF_SEQN);
            	if(appCancelVt.size()>0){
            		ApprovalCancelData appData = new ApprovalCancelData();
            		appData = (ApprovalCancelData)appCancelVt.get(0);
            		//결재한 초과근무조회
            		String ORG_AINF_SEQN = appData.ORG_AINF_SEQN;
            		//초과근무
            		D01OTRFC  otRfc       = new D01OTRFC();
            		d01OTData_vt = otRfc.getDetail(ORG_AINF_SEQN, appData.PERNR);
                    if( d01OTData_vt.size() < 1 ){
                        String msg = "System Error! \n\n 조회할 항목이 없습니다.";
                        req.setAttribute("msg", msg);
                        dest = WebUtil.JspURL+"common/caution.jsp";
                    }else{
                        // ORG결재자 정보
                        orgVcAppLineData = AppUtil.getAppChangeVt(ORG_AINF_SEQN);
                        vcAppLineData = AppUtil.getAppChangeVt(AINF_SEQN);
                        // 결재 정보.
                       PersInfoWithNoRFC piRfc = new PersInfoWithNoRFC();
                       PersInfoData      pid   = (PersInfoData) piRfc.getApproval(appData.PERNR).get(0);
                       //원결재정보
                       d01OTData = (D01OTData)d01OTData_vt.get(0);
                        req.setAttribute("PersInfoData" ,pid );
                        req.setAttribute("orgVcAppLineData" , orgVcAppLineData);
                        req.setAttribute("d01OTData", d01OTData);
                        req.setAttribute("vcAppLineData" , vcAppLineData);
                        req.setAttribute("appCancelVt", appCancelVt);
                    } // end if

                    dest = WebUtil.JspURL+"G/G086ApprovalFinishOTCancel.jsp";
                } // end if
            } else {
                throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
            } // end if

            Logger.debug.println(this, " destributed = " + dest);
            printJspPage(req, res, dest);

        } catch(Exception e) {
            Logger.err.println(DataUtil.getStackTrace(e));
            throw new GeneralException(e);
      //  } finally {

        }
    }
}
