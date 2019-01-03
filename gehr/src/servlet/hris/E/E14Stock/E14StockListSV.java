package servlet.hris.E.E14Stock;

import java.io.*;
import java.util.Vector;
import javax.servlet.*;
import javax.servlet.http.*;

import com.sns.jdf.*;
import com.sns.jdf.util.*;
import com.sns.jdf.servlet.*;

import hris.A.*;
import hris.A.rfc.*;
import hris.E.E14Stock.*;
import hris.E.E14Stock.rfc.*;
import hris.common.WebUserData;

/**
 * E14StockListSV.java
 * 우리사주현황, 증권계좌, 인출내역을 jsp로 넘겨주는 class 
 *  A03AccountDetailRFC,E14SajuRFC,InchulDetailRFC를 호출하여 E14StockList.jsp,E14Stockpop로 정보를 넘겨준다.
 *
 * @author 이형석   
 * @version 1.0, 2002/12/23
 */
public class E14StockListSV extends EHRBaseServlet {
    
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

            E14SajuRFC          func1  = new E14SajuRFC(); 
            A03AccountDetailRFC func2  = new A03AccountDetailRFC();
                
            if(jobid.equals("first")) { 
                E14StockData data  = (E14StockData)func1.getSajufield(user.empNo); 
                Vector  E14Stock_vt             = func1.getSajuList(user.empNo);
                Vector  a03AccountDetailData_vt = func2.getAccountDetail(user.empNo, "08");  // 증권계좌
                      
/*                if(E14Stock_vt.size()==0){
                    Logger.debug.println(this, "Data Not Found");
                    String msg = "msg004";
                    req.setAttribute("msg", msg);
                    dest = WebUtil.JspURL+"common/caution.jsp";
                } else if( a03AccountDetailData_vt.size() == 0 ){
                    Logger.debug.println(this, "Data Not Found");
                    String msg = "증권계좌에 대한 데이터를 가져올 수 없습니다.";
                    req.setAttribute("msg", msg);
                    dest = WebUtil.JspURL+"common/caution.jsp";
                } else {      */
                req.setAttribute("page", page);
                req.setAttribute("E14StockData", data);
                req.setAttribute("E14Stock_vt", E14Stock_vt);
                req.setAttribute("a03AccountDetailData_vt", a03AccountDetailData_vt);
            
                dest = WebUtil.JspURL+"E/E14Stock/E14StockList.jsp";
//                }
            } else if( jobid.equals("detail") ) {
                E14StockData    data = new E14StockData();
                InchulDetailRFC func3  = new InchulDetailRFC();
                                  
                data.INCS_NUMB = box.get("INCS_NUMB");
                data.SHAR_TEXT = box.get("SHAR_TEXT");
                data.SHAR_TYPE = box.get("SHAR_TYPE");
                data.DEPS_QNTY = box.get("DEPS_QNTY"); 
                data.BEGDA     = box.get("BEGDA");

                Vector InchulData_vt = func3.getInchulList(user.empNo, box.get("INCS_NUMB"));

                req.setAttribute("E14StockData", data);
                req.setAttribute("InchulData_vt", InchulData_vt);
                 
                dest = WebUtil.JspURL+"E/E14Stock/E14StockPop.jsp";
               
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