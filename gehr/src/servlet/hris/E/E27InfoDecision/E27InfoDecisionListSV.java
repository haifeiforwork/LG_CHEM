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
 * ������ ��û�� ���� ���������� jsp�� �Ѱ��ִ� class 
 * jobid�� first�� ���� �˻������� ���� jsp�� �Ѱ��ְ�,
 * jobid�� search �ϰ��� �������� List �� �������� E27InfoDecisionRFC�� ȣ���Ͽ� jsp�� ���������� �Ѱ��ش�.
 *
 * @author ������
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

//              2002.06.11. default���� : ��û�� --> ���糯¥�� �������� �������� ����.
//                                        list  --> �����ϰ��� ��û���� default�� �ѷ��ֵ��� �Ѵ�.
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

