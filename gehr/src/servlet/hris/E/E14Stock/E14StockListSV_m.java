/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : 우리사주보유현황                                            */
/*   Program Name : 우리사주보유현황                                            */
/*   Program ID   : E14StockListSV_m                                            */
/*   Description  : 우리사주현황, 증권계좌, 인출내역을 jsp로 넘겨주는 class     */
/*   Note         :                                                             */
/*   Creation     : 2002-12-23  이형석                                          */
/*   Update       : 2005-01-24  윤정현                                          */
/*                                                                              */
/********************************************************************************/

package servlet.hris.E.E14Stock;

import java.util.Vector;
import javax.servlet.http.*;

import com.sns.jdf.*;
import com.sns.jdf.util.*;
import com.sns.jdf.servlet.*;

import hris.A.rfc.*;
import hris.E.E14Stock.E14StockData;
import hris.E.E14Stock.rfc.*;
import hris.common.WebUserData;


public class E14StockListSV_m extends EHRBaseServlet {

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        try{

            HttpSession session = req.getSession(false);
            WebUserData user_m = WebUtil.getSessionMSSUser(req);

            String jobid_m = "";
            String dest    = "";
            String page_m  = "";
            
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

            E14SajuRFC          func1 = new E14SajuRFC();
            A03AccountDetailRFC func2 = new A03AccountDetailRFC();
            InchulDetailRFC     func3 = new InchulDetailRFC();
            E14StockData        data  = new E14StockData();
            
            Vector  E14Stock_vt             = new Vector();
            Vector  a03AccountDetailData_vt = new Vector();
            Vector InchulData_vt            = new Vector();

            if(jobid_m.equals("first")) {

                if ( user_m != null ) {
                    Logger.debug.println(this, "[jobid_m] = "+jobid_m + " [user_m] : "+user_m.toString());
                    
                    data  = (E14StockData)func1.getSajufield(user_m.empNo);
                    E14Stock_vt             = func1.getSajuList(user_m.empNo);
                    a03AccountDetailData_vt = func2.getAccountDetail(user_m.empNo, "08");  // 증권계좌
                } // if ( user_m != null ) end

                req.setAttribute("page_m", page_m);
                req.setAttribute("E14StockData", data);
                req.setAttribute("E14Stock_vt", E14Stock_vt);
                req.setAttribute("a03AccountDetailData_vt", a03AccountDetailData_vt);

                dest = WebUtil.JspURL+"E/E14Stock/E14StockList_m.jsp";

            } else if( jobid_m.equals("detail") ) {

                data.INCS_NUMB = box.get("INCS_NUMB");
                data.SHAR_TEXT = box.get("SHAR_TEXT");
                data.SHAR_TYPE = box.get("SHAR_TYPE");
                data.DEPS_QNTY = box.get("DEPS_QNTY");
                data.BEGDA     = box.get("BEGDA");

                if ( user_m != null ) {
                    Logger.debug.println(this, "[jobid_m] = "+jobid_m + " [user_m] : "+user_m.toString());
                    
                    InchulData_vt = func3.getInchulList(user_m.empNo, box.get("INCS_NUMB"));
                } // if ( user_m != null ) end

                req.setAttribute("E14StockData", data);
                req.setAttribute("InchulData_vt", InchulData_vt);

                dest = WebUtil.JspURL+"E/E14Stock/E14StockPop_m.jsp";

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