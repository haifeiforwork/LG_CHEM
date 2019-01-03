package servlet.hris.N.orgstats;

import hris.N.EHRComCRUDInterfaceRFC;
import hris.common.WebUserData;

import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.sns.jdf.GeneralException;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;

public class DeptPositionSV    extends  EHRBaseServlet {

	
	private static final long serialVersionUID = 1L;

	protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        try{
            HttpSession session = req.getSession(false);
            WebUserData user = WebUtil.getSessionUser(req);
            Box box = WebUtil.getBox(req);
            
            String orgCode = box.get("I_ORGEH");
            String command = box.get("command");
            EHRComCRUDInterfaceRFC comRFC = new EHRComCRUDInterfaceRFC();
           	String functionName = "ZHRC_RFC_GET_JIKKP_CONDITION";
           	String dest = WebUtil.JspURL+"N/orgstats/DeptPosition.jsp";
        	//담당자 리스트 
        	//box.put("I_ORGEH", orgCode);
        	box.put("I_DATUM", DataUtil.getCurrentDate());
        	//box.put("I_PERNR", user.empNo);
        	//box.put("I_GUBUN", "1");
        	if(command.equals("PSN")){
        		box.put("I_GUBUN", "1");
        		dest = WebUtil.JspURL+"N/orgstats/DeptPositionPrsnFrame.jsp";
        	}else if(command.equals("WRK")){
        		box.put("I_GUBUN", "2");
        		dest = WebUtil.JspURL+"N/orgstats/DeptAverageWorkFrame.jsp";
        	}else if(command.equals("OLD")){
        		box.put("I_GUBUN", "3");
        		dest = WebUtil.JspURL+"N/orgstats/DeptAverageOldFrame.jsp";
        	}else if(command.equals("EXC")){
        		dest = WebUtil.JspURL+"N/orgstats/DeptPositionExcel.jsp";
        	}
        	
            HashMap resultVT = comRFC.getExecutAllTable(box, functionName,"RETURN");
           // Logger.debug("resultVT : >>>>>>>>>>>>>>>>>>>"+resultVT);
            req.setAttribute("resultVT", resultVT);
            
            printJspPage(req, res, dest);

        } catch(Exception e) {
            throw new GeneralException(e);
        } finally {
            //DBUtil.close(con);
        }
	}
}

