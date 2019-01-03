/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : 주택지원                                                    */
/*   Program Name : 주택지원                                                    */
/*   Program ID   : E09HouseListSV_m                                            */
/*   Description  : 개인의 주택자금 융자정보를 조회하여 jsp로 넘겨주는 class    */
/*   Note         :                                                             */
/*   Creation     : 2002-01-29  이형석                                          */
/*   Update       : 2005-01-24  윤정현                                          */
/*                     2016-03-15    2016-03-15 //2016-03-08 [CSR ID:2995203] 보상명세서 적용(Total Compensation)                                                     */
/********************************************************************************/

package servlet.hris.E.E09House;

import java.util.Vector;
import javax.servlet.http.*;

import com.sns.jdf.*;
import com.sns.jdf.util.*;
import com.sns.jdf.servlet.*;

import hris.E.E09House.E09HouseDetailData;
import hris.E.E09House.rfc.*;
import hris.common.WebUserData;


public class E09HouseListSV_m extends EHRBaseServlet {

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        try{

            HttpSession session = req.getSession(false);
            WebUserData user_m = WebUtil.getSessionMSSUser(req);


            String jobid_m = "";
            String dest = "";
            String page  = "";


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
            jobid_m = box.get("jobid_m", "first");

            //2016-03-08 [CSR ID:2995203] 보상명세서 적용(Total Compensation)
            String RequestPageName = box.get("RequestPageName");
            req.setAttribute("RequestPageName", RequestPageName);

            /*if( jobid_m.equals("") ){
                jobid_m = "first";
            }*/
            String year = box.get("year", "");
            String month = box.get("month", "");
            /*if( year.equals("") ){
            	year = "";
            }
            if( month.equals("") ){
            	month = "";
            }*/
            if( jobid_m.equals("first") ) {
                E09HouseListRFC func1 = new E09HouseListRFC();
                Vector E09House_vt = new Vector();

                if ( user_m != null ) {
                    Logger.debug.println(this, "[jobid_m] = "+jobid_m + " [user_m] : "+user_m.toString());

                  //E09House_vt  = func1.getHouseList(user_m.empNo);
                    E09House_vt  = func1.getHouseList(user_m.empNo,year+month); //[CSR ID:2995203] 이자지원액 추가

                } // if ( user_m != null ) end

                req.setAttribute("page", page);
                req.setAttribute("E09House_vt", E09House_vt);

                dest = WebUtil.JspURL+"E/E09House/E09HouseList_m.jsp";

            } else if( jobid_m.equals("detail") ) {

                E09HouseDetailData key = new E09HouseDetailData();
                key.I_PERNR = user_m.empNo;
                key.I_SUBTY = box.get("SUBTY");
                key.I_BEGDA = box.get("BEGDA");
                key.I_ENDDA = box.get("ENDDA");
                key.I_BETRG = box.get("BETRG");
                key.I_BETRG = Double.toString(Double.parseDouble(key.I_BETRG) / 100.0 );

                E09HouseDetailRFC fun = new E09HouseDetailRFC();
                Object data           = fun.getHouseDetail( key );
                req.setAttribute("E09HouseDetailData", data);
                dest = WebUtil.JspURL+"E/E09House/E09HouseDetail_m.jsp";
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