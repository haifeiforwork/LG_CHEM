package servlet.hris.N.EAP.mental;

import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.WebUtil;
import hris.N.EHRComCRUDInterfaceRFC;
import hris.N.EHRCommonUtil;
import hris.common.WebUserData;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.Vector;

public class MentalCounselSV extends  EHRBaseServlet {

	
	private static final long serialVersionUID = 1L;

	protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        try{
            HttpSession session = req.getSession(false);
            WebUserData user = WebUtil.getSessionUser(req);
            Box box = WebUtil.getBox(req);
          
            String command = box.get("command");
            EHRComCRUDInterfaceRFC comRFC = new EHRComCRUDInterfaceRFC();
            box.put("I_GUBUN", "PA0014");
            box.put("I_PERNR", user.empNo);
            if(command.equals("MAIL")){
            	//메일 보내기
//            	String mailFunction = "ZHRC_RFC_SEND_TO_MANAGER";
            	String mailFunction = "ZGHR_RFC_SEND_TO_MANAGER";
            	Vector mailbox = EHRCommonUtil.LongTextSplit(box, "LINE", 255 );
            	String retCode = comRFC.setImportTableData(box, mailFunction, mailbox, "I_MINFO");
            	
            	// Box[requestbox]={HOPEP=on, UZEIT=15:00, ORGTX=CHO, PERNR=00034122, RECEIVER=mhkim@lgchem.com, command=MAIL, JIKWI=상무, DATUM=2015.05.28, TLINE=안녕하세요 !! 
            	//심리상담 부탁드립니다., ENAME=김민환}
            	String msg = "msg001";
            	if(retCode.equals("S")){
            	  msg = "msg001";
            	}
            	 req.setAttribute("msg", msg);
            	
            }
        	//담당자 리스트 
        	//String functionName = "ZHRC_RFC_GET_MANAGER";
        	String functionName = "ZGHR_RFC_GET_MANAGER";
        	
            box.put("I_BUKRS", user.companyCode);
            HashMap mentMailData = comRFC.getReturnST(box,functionName,"T");
            HashMap strData = comRFC.getReturnST(box,functionName,"S");
           
            req.setAttribute("mentMailData", mentMailData);
            req.setAttribute("strData", strData);

            String dest = WebUtil.JspURL+"N/EAP/mental/mentalCounsel.jsp";

            printJspPage(req, res, dest);

        } catch(Exception e) {
            Logger.error(e);
            throw new GeneralException(e);
        } finally {
            //DBUtil.close(con);
        }
	}
}