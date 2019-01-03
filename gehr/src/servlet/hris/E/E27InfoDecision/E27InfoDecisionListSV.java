package servlet.hris.E.E27InfoDecision;

import java.io.*;
import java.util.Vector;
import javax.servlet.*;
import javax.servlet.http.*;

import com.sns.jdf.*;
import com.sns.jdf.util.*;
import com.sns.jdf.servlet.*;

import hris.common.WebUserData;
import hris.E.E27InfoDecision.*;
import hris.E.E27InfoDecision.rfc.*;

/**
 * E27InfoDecisionListSV.java
 * 인포멀 신청에 대한 결재정보를 jsp로 넘겨주는 class 
 * jobid가 first일 경우는 검색조건의 값을 jsp로 넘겨주고,
 * jobid가 search 일경우는 결재정보 List 를 가져오는 E27InfoDecisionRFC를 호출하여 jsp로 결재정보를 넘겨준다.
 *
 * @author 이형석
 * @version 1.0, 2001/01/15
 */
public class E27InfoDecisionListSV extends EHRBaseServlet {
    
    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        try{

            HttpSession session = req.getSession(false);
            WebUserData user = WebUtil.getSessionUser(req);

            String dest  = "";
            String jobid = "";
            String page  = "";

            E27InfoDecisionKey key = new E27InfoDecisionKey();
            Vector E27InfoDecision_vt = new Vector();
            
            Box box = WebUtil.getBox(req);
            jobid = box.get("jobid");
            page  = box.get("page");

            if( jobid.equals("") ) {
                jobid = "first";
            }
            Logger.debug.println(this, "[jobid] = "+jobid + " [user] : "+user.toString());

                
            if( jobid.equals("first") || jobid.equals("search") ) {
                if(jobid.equals("first")) {

//              2002.06.11. default세팅 : 신청일 --> 현재날짜를 기준으로 일주일을 세팅.
//                                        list  --> 일주일간의 신청건을 default로 뿌려주도록 한다.
//                     key.P_BEGDA     = DataUtil.getCurrentDate();
                    key.P_BEGDA     = DataUtil.getAfterDate(DataUtil.getCurrentDate(), -7);
                    key.P_ENDDA     = DataUtil.getCurrentDate();
                    key.P_PERNR     = user.empNo;
                    key.P_APPL_DATE = "";
                    key.P_APPR_STAT = "";
                    key.P_INFO_TYPE = "2";
                    key.P_CONT_TYPE = "1";
                     
                    E27InfoDecisionRFC func = new E27InfoDecisionRFC();
                    E27InfoDecision_vt = func.getInfoDecision(key);
                    
                    Logger.debug.println(this, "E27InfoDecision_vt : "+ E27InfoDecision_vt.toString());
                } else if( jobid.equals("search") ) {

                    box.copyToEntity(key);
                    
                    key.P_CONT_TYPE = "1" ;
                    key.P_PERNR     = user.empNo;
                    key.P_APPL_DATE = "";
                                   
                    E27InfoDecisionRFC func = new E27InfoDecisionRFC();
                    E27InfoDecision_vt = func.getInfoDecision(key);
                                          
                    Logger.debug.println(this, "E27InfoDecision_vt : "+ E27InfoDecision_vt.toString());
                }
                req.setAttribute("jobid", jobid);
                req.setAttribute("page", page);
                req.setAttribute("E27InfoDecisionKey", key);
                req.setAttribute("E27InfoDecision_vt", E27InfoDecision_vt);

                dest = WebUtil.JspURL+"E/E27InfoDecision/E27InfoDecision.jsp";
            } else if( jobid.equals("detail")){
               E27InfoDecisionData data = new E27InfoDecisionData();
               box.copyToEntity(data);
               box.copyToEntity(key);
               
               key.P_PERNR = user.empNo;
               
               req.setAttribute("E27InfoDecisionData", data);
               req.setAttribute("E27InfoDecisionKey", key);

               if(data.INFO_TYPE.equals("0") ) {

                dest = WebUtil.JspURL+"E/E27InfoDecision/E27JoinDecision.jsp";
               
               } else {
                    
                dest = WebUtil.JspURL+"E/E27InfoDecision/E27SecessDecision.jsp"; 
               } 
        } else {
               throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
        }
        Logger.debug.println(this, " destributed = " + dest);
        printJspPage(req, res, dest);
        
        } catch (Exception e) {
            throw new GeneralException(e);
        }
    }
}

