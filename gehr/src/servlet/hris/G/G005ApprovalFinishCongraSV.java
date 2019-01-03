/********************************************************************************/
/*                                                                              */
/*   System Name  : e-HR                                                        */
/*   1Depth Name  : HR 결재함                                                   */
/*   2Depth Name  : 결재 완료 문서                                              */
/*   Program Name : 경조금 신청                                                 */
/*   Program ID   : G005ApprovalFinishCongraSV                                  */
/*   Description  : 경조금 신청 결재 완료                                       */
/*   Note         : 없음                                                        */
/*   Creation     : 2005-03-14  이승희                                          */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/

package servlet.hris.G;
/*
 * 작성된 날짜: 2005. 1. 31.
 *
 */
import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.WebUtil;
import hris.E.E19Congra.E19CongcondData;
import hris.E.E19Congra.rfc.E19CongraRequestRFC;
import hris.common.PersonData;
import hris.common.WebUserData;
import hris.common.rfc.PersonInfoRFC;
import hris.common.util.AppUtil;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.Vector;

//import hris.common.rfc.PersInfoWithNoRFC;

/**
 * @author 이승희
 *
 */
public class G005ApprovalFinishCongraSV extends EHRBaseServlet
{
    /* (비Javadoc)
     * @see com.sns.jdf.servlet.EHRBaseServlet#performTask(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse)
     */
    protected void performTask(HttpServletRequest req, HttpServletResponse res)
            throws GeneralException
    {
        try{
            HttpSession session = req.getSession(false);
            WebUserData user = WebUtil.getSessionUser(req);
            
            E19CongcondData     e19CongcondData;
            Vector              E19CongcondData_vt;
            Vector              vcAppLineData;

            String dest  = "";
            String jobid = "";
            
            Box box = WebUtil.getBox(req);
            
            String RequestPageName = box.get("RequestPageName");
            req.setAttribute("RequestPageName", RequestPageName);
            
            Logger.debug.println("RequestPageName = " + RequestPageName);
            
            jobid = box.get("jobid");
            
            if( jobid ==null || jobid.equals("") ){
                jobid = "search";
            } // end if
            
            if( jobid.equals("search") ) {

                E19CongraRequestRFC	rfc						=	new E19CongraRequestRFC();
//				PersInfoWithNoRFC			piRfc					=	new PersInfoWithNoRFC();
                PersonInfoRFC numfunc			=	new PersonInfoRFC();
                                 
                Vector              returnAll           = null;
                
                String              keycode             = box.get("AINF_SEQN");
                
                /*returnAll = rfc.detail(keycode);*/
                
                E19CongcondData_vt  = (Vector)returnAll.get(0);
                vcAppLineData = AppUtil.getAppDetailVt(keycode);
                
                e19CongcondData = (E19CongcondData)E19CongcondData_vt.get(0);
                
//                PersInfoData    pid = (PersInfoData) piRfc.getApproval(e19CongcondData.PERNR).get(0);
                PersonData phonenumdata;
                phonenumdata    =   (PersonData)numfunc.getPersonInfo(e19CongcondData.PERNR, "X");
                
                req.setAttribute("PersInfoData" ,phonenumdata );
                req.setAttribute("E19CongcondData" ,e19CongcondData );
                req.setAttribute("vcAppLineData" ,vcAppLineData);

                req.setAttribute("jobid",              jobid);
                dest = WebUtil.JspURL+"G/G005ApprovalFinishCongra.jsp";
            } else {
                throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
            }

            Logger.debug.println(this, " destributed = " + dest);
            printJspPage(req, res, dest);

        } catch(Exception e) {
            throw new GeneralException(e);
        } finally {
            
        }

    }

}
