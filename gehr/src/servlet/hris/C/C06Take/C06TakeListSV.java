package servlet.hris.C.C06Take;

import java.io.*;
import java.util.Vector;
import javax.servlet.*;
import javax.servlet.http.*;

import com.sns.jdf.*;
import com.sns.jdf.util.*;
import com.sns.jdf.servlet.*;

import hris.C.C02Curri.*;
import hris.C.C02Curri.rfc.*; 
import hris.C.C06Take.*;
import hris.C.C06Take.rfc.*;
import hris.common.WebUserData;

/**
 * C06TakeListSV.java
 * 개인이 수강신청한 현황을 jsp로 넘겨주는 class 
 *  C06TakeRFC 를 호출하여 C06TakeList.jsp로 정보를 넘겨준다.
 *
 * @author 이형석   
 * @version 1.0, 2002/12/23
 */
public class C06TakeListSV extends EHRBaseServlet {
    
    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        try{
            HttpSession session = req.getSession(false);
            WebUserData user   = (WebUserData)session.getAttribute("user");

            String jobid = "";
            String dest = "";
            String page  = "";

            Box box = WebUtil.getBox(req);
            jobid = box.get("jobid");

            if( jobid.equals("") ){
                jobid = "first";
            }
            Logger.debug.println(this, "[jobid] = "+jobid + " [user] : "+user.toString());

            C06TakeRFC  func1  = new C06TakeRFC(); 
                            
            if(jobid.equals("first")) { 
                String year       = DataUtil.getCurrentYear();
                Vector total_vt   = func1.getTakeList(user.empNo, year);
                
                Vector c06Take_vt = (Vector)total_vt.get(0);
                Vector p_edu_vt   = (Vector)total_vt.get(1);
                                           
                c06Take_vt = SortUtil.sort( c06Take_vt, "GBEGDA", "desc");
                p_edu_vt   = SortUtil.sort( p_edu_vt,   "BEGDA",  "desc");
                
                Logger.debug.println(this,"c06Take_vt"+c06Take_vt.toString());
                Logger.debug.println(this,"p_edu_vt"+p_edu_vt.toString());
                
                req.setAttribute("jobid", jobid);
                req.setAttribute("year", year);
                req.setAttribute("page", page);
                req.setAttribute("c06Take_vt", c06Take_vt);
                req.setAttribute("p_edu_vt"  , p_edu_vt);
                Logger.debug.println(this,"c06Take_vt"+c06Take_vt.toString());
                
                dest = WebUtil.JspURL+"C/C06Take/C06TakeList.jsp";
            }else if( jobid.equals("search")){
                page  = box.get("page");
                String reqyear    = Integer.toString(box.getInt("YEAR"));
                Vector total_vt   = func1.getTakeList(user.empNo, reqyear);
                
                Vector c06Take_vt = (Vector)total_vt.get(0);
                Vector p_edu_vt   = (Vector)total_vt.get(1);
                
                c06Take_vt = SortUtil.sort( c06Take_vt, "GBEGDA", "desc");
                p_edu_vt   = SortUtil.sort( p_edu_vt,   "BEGDA",  "desc");
                
                Logger.debug.println(this,"c06Take_vt"+c06Take_vt.toString());
                Logger.debug.println(this,"p_edu_vt"+p_edu_vt.toString());
                
                req.setAttribute("jobid", jobid);
                req.setAttribute("year", reqyear);
                req.setAttribute("page", page);
                req.setAttribute("c06Take_vt", c06Take_vt);
                req.setAttribute("p_edu_vt"  , p_edu_vt);

                 dest = WebUtil.JspURL+"C/C06Take/C06TakeList.jsp";
             } else if( jobid.equals("detail") ) {
                C02CurriInfoData data = new C02CurriInfoData();
                box.copyToEntity(data);

                C02CurriInfoRFC   func = new C02CurriInfoRFC();
                Vector            ret   = func.getCurriInfo( data.GWAID, data.CHAID );
                  
                Vector C02CurriEventInfoData_vt = (Vector)ret.get(0);
                Vector C02CurriEventData_vt     = (Vector)ret.get(1);
                Vector C02CurriData_Course_vt   = (Vector)ret.get(2);
                Vector C02CurriData_Grint_vt    = (Vector)ret.get(3);
                Vector C02CurriData_Get_vt      = (Vector)ret.get(4);
            
                req.setAttribute("C02CurriInfoData", data);
                req.setAttribute("C02CurriEventInfoData_vt", C02CurriEventInfoData_vt);
                req.setAttribute("C02CurriEventData_vt", C02CurriEventData_vt);
                req.setAttribute("C02CurriData_Course_vt", C02CurriData_Course_vt);
                req.setAttribute("C02CurriData_Grint_vt", C02CurriData_Grint_vt);
                req.setAttribute("C02CurriData_Get_vt", C02CurriData_Get_vt);
  
                dest = WebUtil.JspURL+"C/C06Take/C06TakeDetail.jsp";
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
