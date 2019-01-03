/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : 국민연금                                                    */
/*   Program Name : 국민연금                                                    */
/*   Program ID   : E29PensionListSV_m                                          */
/*   Description  : 국민연금에 대한 개인누계 및 연도별상세내역을 조회하는 class */
/*   Note         :                                                             */
/*   Creation     : 2002-12-23  이형석                                          */
/*   Update       : 2005-01-25  윤정현                                          */
/*                                                                              */
/********************************************************************************/

package servlet.hris.E.E29PensionDetail;

import java.util.Vector;
import javax.servlet.http.*;

import com.sns.jdf.*;
import com.sns.jdf.util.*;
import com.sns.jdf.servlet.*;

import hris.E.E29PensionDetail.E29PensionDetailData;
import hris.E.E29PensionDetail.rfc.*;
import hris.common.WebUserData;


public class E29PensionListSV_m extends EHRBaseServlet {

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {
        try{

            HttpSession session = req.getSession(false);
            WebUserData user_m = WebUtil.getSessionMSSUser(req);

            String jobid_m = "";
            String dest    = "";

            WebUserData user = WebUtil.getSessionUser(req);
//          @웹취약성 추가
            if ( user.e_authorization.equals("E")) {
                Logger.debug.println(this, "E Authorization!!");
                String msg = "msg015";
                req.setAttribute("msg", msg);
                dest = WebUtil.JspURL+"common/caution.jsp";
                printJspPage(req, res, dest);
            }

            Box box = WebUtil.getBox(req);
            jobid_m = box.get("jobid_m");

            if( jobid_m.equals("") ){
                jobid_m = "first";
            }

            E29PensionDetailData   data  = new E29PensionDetailData();
            E29PensionTotalRFC     func1 = new E29PensionTotalRFC();
            E29NationalPensionRFC  func2 = new E29NationalPensionRFC();
            Vector  E29PensionDetail_vt  = new Vector();

            if(jobid_m.equals("first")) {

                String year = DataUtil.getCurrentYear();
                if ( user_m != null ) {
                    Logger.debug.println(this, "[jobid_m] = "+jobid_m + " [user_m] : "+user_m.toString());

                    data  = (E29PensionDetailData)func1.getPension(user_m.empNo);
                    E29PensionDetail_vt = func2.getNationalList(user_m.empNo, year);
                } // if ( user_m != null ) end

                Logger.debug.println(this,"E29PensionDetail_vt"+E29PensionDetail_vt.toString());

                E29PensionDetail_vt = SortUtil.sort( E29PensionDetail_vt , "PAYDT", "asc");

                req.setAttribute("jobid_m", jobid_m);
                req.setAttribute("year", year);
                req.setAttribute("E29PensionDetailData", data);
                req.setAttribute("E29PensionDetail_vt", E29PensionDetail_vt);

                dest = WebUtil.JspURL+"E/E29PensionDetail_m.jsp";

            } else if( jobid_m.equals("search") ) {

                if ( user_m != null ) {
                    Logger.debug.println(this, "[jobid_m] = "+jobid_m + " [user_m] : "+user_m.toString());

                    data  = (E29PensionDetailData)func1.getPension(user_m.empNo);
                    E29PensionDetail_vt = func2.getNationalList(user_m.empNo,box.get("YEAR"));
                } // if ( user_m != null ) end

                req.setAttribute("year", box.get("YEAR"));
                req.setAttribute("E29PensionDetailData", data);
                req.setAttribute("E29PensionDetail_vt", E29PensionDetail_vt);
                req.setAttribute("jobid_m", jobid_m);

                 dest = WebUtil.JspURL+"E/E29PensionDetail_m.jsp";

            } else {
                throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
            }

            printJspPage(req, res, dest);
            Logger.debug.println(this, " destributed = " + dest);
        } catch(Exception e) {
            throw new GeneralException(e);
        }
    }
}