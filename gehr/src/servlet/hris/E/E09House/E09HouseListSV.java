package servlet.hris.E.E09House;

import java.util.Vector;
import javax.servlet.http.*;

import com.sns.jdf.*;
import com.sns.jdf.util.*;
import com.sns.jdf.servlet.*;

import hris.E.E09House.*;
import hris.E.E09House.rfc.*;
import hris.common.WebUserData;

/**
 * E09HouseListSV.java
 * 개인의 주택자금 융자정보를 조회하여 jsp로 넘겨주는 class
 *  E09HouseListRFC를 호출하여 E09HouseList.jsp,E09HouseList 데이터를 넘겨준다.
 *
 * @author 이형석
 * @version 1.0, 2002/01/29
 */
public class E09HouseListSV extends EHRBaseServlet {

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        try{

            HttpSession session = req.getSession(false);
            WebUserData user   = (WebUserData)session.getAttribute("user");

            String jobid = "";
            String dest = "";
            String page  = "";

            Box box = WebUtil.getBox(req);
            jobid = box.get("jobid", "first");

            /*if( jobid.equals("") ){
                jobid = "first";
            }*/
            Logger.debug.println(this, "[jobid] = "+jobid + " [user] : "+user.toString());

            String RequestPageName = box.get("RequestPageName");
            String year = box.get("year", "");
            String month = box.get("month", "");
            /*if( year.equals("") ){
            	year = "";
            }
            if( month.equals("") ){
            	month = "";
            }*/
             req.setAttribute("RequestPageName", RequestPageName);
             req.setAttribute("year", year);
             req.setAttribute("month", month);

             if( jobid.equals("first") ) {
                E09HouseListRFC  func1  = new E09HouseListRFC();
                //Vector  E09House_vt  = func1.getHouseList(user.empNo,year+month); //버전관리 실패로 소스 수정
                Vector  E09House_vt  = func1.getHouseList(user.empNo);

/*                if(E09House_vt.size()==0){
                    Logger.debug.println(this, "Data Not Found");
                    String msg = "msg004";
                    req.setAttribute("msg", msg);
                    dest = WebUtil.JspURL+"common/caution.jsp";
                } else {          */

//                E09House_vt = SortUtil.sort( E09House_vt , "DATBW", "desc");

                req.setAttribute("page", page);
                req.setAttribute("E09House_vt", E09House_vt);

                dest = WebUtil.JspURL+"E/E09House/E09HouseList.jsp";
//                }

             } else if( jobid.equals("detail") ) {

                 E09HouseDetailData key = new E09HouseDetailData();
                 key.I_PERNR = user.empNo;
                 key.I_SUBTY = box.get("SUBTY");
                 key.I_BEGDA = box.get("BEGDA");
                 key.I_ENDDA = box.get("ENDDA");
                 key.I_BETRG = box.get("BETRG");
                 key.I_BETRG = Double.toString(Double.parseDouble(key.I_BETRG) / 100.0 );

                 E09HouseDetailRFC fun = new E09HouseDetailRFC();
                 Object data           = fun.getHouseDetail( key );
                 req.setAttribute("E09HouseDetailData", data);
                 dest = WebUtil.JspURL+"E/E09House/E09HouseDetail.jsp";
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