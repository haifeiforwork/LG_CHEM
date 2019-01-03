package servlet.hris.E.E27InfoDecision;

import java.io.*;
import java.util.Vector;
import javax.servlet.*;
import javax.servlet.http.*;

import com.sns.jdf.*;
import com.sns.jdf.db.*;
import com.sns.jdf.util.*;
import com.sns.jdf.servlet.*;

import hris.common.*;
import hris.common.rfc.*;
import hris.common.mail.*;
import hris.E.E27InfoDecision.*;
import hris.E.E27InfoDecision.rfc.*;

/**
 * E27JoinDecisionSV.java
 * 인포멀가입 및 탈되 신청에대해 결재를 하는 class
 *
 * @author 이형석   
 * @version 1.0, 2002/01/13
 */
public class E27JoinDecisionSV extends EHRBaseServlet {

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {

        try{
            HttpSession session = req.getSession(false);
            WebUserData user = WebUtil.getSessionUser(req);

            String dest  = "";
            String jobid = "";
            
            Box box = WebUtil.getBox(req);
            jobid = box.get("jobid");
                       
            if( jobid.equals("") ){
                jobid = "first";
            }
            Logger.debug.println(this, "[jobid] = "+jobid + " [user] : "+user.toString());
      
            if(jobid.equals("create")) {
                
                Vector E26InfoDecisionData_vt = new Vector();

                E27InfoDecisionRFC    func1   = new E27InfoDecisionRFC();
                E27InfoDecisionData   data    = new E27InfoDecisionData();
                E27InfoDecisionKey    key     = new E27InfoDecisionKey();                                
                
                key.P_CONT_TYPE = "2";
                key.P_INFO_TYPE = box.get("INFO_TYPE"); 
                key.P_APPR_STAT = "";
                key.P_PERNR     = box.get("PERNR");
                key.P_BEGDA     = box.get("P_BEGDA");
                key.P_ENDDA     = box.get("P_ENDDA");
                key.P_APPL_DATE = "";
                 
                data.AINF_SEQN = box.get("AINF_SEQN");
                data.MGART     = box.get("MGART");
                data.STEXT     = box.get("STEXT");
                data.INFO_TYPE = box.get("INFO_TYPE"); 
                data.INFO_TEXT = box.get("INFO_TEXT");
                data.BEGDA     = box.get("BEGDA");
                data.PERNR     = box.get("PERNR");
                data.ENAME     = box.get("ENAME");
                data.BETRG     = box.get("BETRG");
                                
                E26InfoDecisionData_vt.addElement(data);
                               
                if( data.INFO_TYPE.equals("0") ) {
                    
                    func1.build( key, E26InfoDecisionData_vt);
                    String upmu="인포멀 가입 신청";
                    MailMgr.infoDecisionMail(user,data,upmu);
                
                } else {
                    
                    func1.infobuild( key, E26InfoDecisionData_vt);
                    String upmu="인포멀 탈퇴 신청";
                    MailMgr.infoDecisionMail(user,data,upmu);
                }
                
                String msg = "결재 되었습니다.";
                String url = "location.href = '" + WebUtil.ServletURL+"hris.E.E27InfoDecision.E27InfoDecisionListSV';";
                req.setAttribute("msg", msg);
                req.setAttribute("url", url);

                dest = WebUtil.JspURL+"common/msg.jsp";

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

