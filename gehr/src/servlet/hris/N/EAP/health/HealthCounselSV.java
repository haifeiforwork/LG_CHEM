package servlet.hris.N.EAP.health;

import hris.N.EHRComCRUDInterfaceRFC;
import hris.N.EHRCommonUtil;
import hris.common.WebUserData;

import java.util.HashMap;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.WebUtil;

public class HealthCounselSV extends  EHRBaseServlet {

	
	private static final long serialVersionUID = 1L;

	protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        try{
            HttpSession session = req.getSession(false);
            WebUserData user = WebUtil.getSessionUser(req);
            Box box = WebUtil.getBox(req);
            String command = box.get("command");
           
            EHRComCRUDInterfaceRFC comRFC = new EHRComCRUDInterfaceRFC();
            box.put("I_GUBUN", "PA0015");
            box.put("I_PERNR", user.empNo);
            if(command.equals("MAIL")){
            	//메일 보내기
//            	String mailFunction = "ZHRC_RFC_SEND_TO_MANAGER";
            	String mailFunction = "ZGHR_RFC_SEND_TO_MANAGER";
            	Vector mailbox = EHRCommonUtil.LongTextSplit(box, "LINE", 255 );
            	String retCode = comRFC.setImportTableData(box, mailFunction, mailbox, "I_MINFO");
            	String msg = "msg001";
            	if(retCode.equals("S")){
            	  msg = "msg001";
            	}
            	 req.setAttribute("msg", msg);
            	
            }
        	//담당자 리스트 
//        	String functionName = "ZHRC_RFC_GET_MANAGER";
        	String functionName = "ZGHR_RFC_GET_MANAGER";
        	box.put("I_GUBUN", "PA0015");
        	box.put("I_BUKRS", user.companyCode);
            HashMap healMailData = comRFC.getReturnST(box, functionName,"T");
            HashMap strData = comRFC.getReturnST(box,functionName,"S");
            
            req.setAttribute("healMailData", healMailData);
            
            Logger.debug.println("---- healMailData"+healMailData);
            Logger.debug.println("---- strData"+strData);
            
            req.setAttribute("strData", strData);
            String dest = WebUtil.JspURL+"N/EAP/health/healthlCounsel.jsp";
            printJspPage(req, res, dest);

        } catch(Exception e) {
            throw new GeneralException(e);
        } finally {
            //DBUtil.close(con);
        }
	}
}