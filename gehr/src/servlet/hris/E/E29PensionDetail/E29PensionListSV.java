package servlet.hris.E.E29PensionDetail;
 
import java.util.Vector; 
import javax.servlet.http.*;

import com.sns.jdf.*;
import com.sns.jdf.util.*;
import com.sns.jdf.servlet.*;

import hris.E.E29PensionDetail.*;
import hris.E.E29PensionDetail.rfc.*;
import hris.common.WebUserData;

/**
 * PensionListSV.java
 *  국민연금에 대한 개인 누계 및 연도별 상세내역을 을 jsp로 넘겨주는 class 
 *  NationalPensionRFC,PensionTotalRFC 를 jsp로 정보를 넘겨준다.
 *
 * @author 이형석   
 * @version 1.0, 2002/12/23
 */
public class E29PensionListSV extends EHRBaseServlet {
    
    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        try{

            HttpSession session = req.getSession(false);
            WebUserData user   = (WebUserData)session.getAttribute("user");

            String jobid = "";
            String dest = ""; 

            Box box = WebUtil.getBox(req);
            jobid = box.get("jobid");

            if( jobid.equals("") ){
                jobid = "first";
            }
            Logger.debug.println(this, "[jobid] = "+jobid + " [user] : "+user.toString());

            E29PensionTotalRFC     func1  = new E29PensionTotalRFC(); 
            E29NationalPensionRFC  func2  = new E29NationalPensionRFC();
            Vector  E29PensionDetail_vt   = new Vector();        

            String RequestPageName = box.get("RequestPageName");
            req.setAttribute("RequestPageName", RequestPageName);
            
            if(jobid.equals("first")) { 
                
                String year = DataUtil.getCurrentYear();
                E29PensionDetailData data  = (E29PensionDetailData)func1.getPension(user.empNo); 
                
                E29PensionDetail_vt        = func2.getNationalList(user.empNo, year);
                Logger.debug.println(this,"E29PensionDetail_vt"+E29PensionDetail_vt.toString());
     
                E29PensionDetail_vt = SortUtil.sort( E29PensionDetail_vt , "PAYDT", "asc");
                    
                req.setAttribute("jobid", jobid);
                req.setAttribute("year", year);
                req.setAttribute("E29PensionDetailData", data);
                req.setAttribute("E29PensionDetail_vt", E29PensionDetail_vt);
                
                dest = WebUtil.JspURL+"E/E29PensionDetail.jsp";
              
            } else if( jobid.equals("search") ) {
                
                 E29PensionDetailData data  = (E29PensionDetailData)func1.getPension(user.empNo); 
                 E29PensionDetail_vt = func2.getNationalList(user.empNo,box.get("YEAR"));
                 
                 req.setAttribute("year", box.get("YEAR"));
                 req.setAttribute("E29PensionDetailData", data);
                 req.setAttribute("E29PensionDetail_vt", E29PensionDetail_vt);
                 req.setAttribute("jobid", jobid);
                 
                 dest = WebUtil.JspURL+"E/E29PensionDetail.jsp";
               
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