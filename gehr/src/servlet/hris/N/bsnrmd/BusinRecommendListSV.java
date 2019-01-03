package servlet.hris.N.bsnrmd;

import com.sns.jdf.GeneralException;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;
import hris.N.EHRComCRUDInterfaceRFC;
import hris.N.bsnrmd.BusinRecommendData;
import hris.common.WebUserData;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.Vector;

public class BusinRecommendListSV  extends  EHRBaseServlet {

	
	private static final long serialVersionUID = 1L;

	protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        try{
            HttpSession session = req.getSession(false);
            WebUserData user = WebUtil.getSessionUser(req);
           
            Box box = WebUtil.getBox(req);
            String orgCode = box.get("I_ORGEH");
            EHRComCRUDInterfaceRFC comRFC = new EHRComCRUDInterfaceRFC();
 
        	box.put("I_ORGEH", orgCode);
        	box.put("I_DATUM", DataUtil.getCurrentDate());
        	
           	String functionName = "ZGHR_RFC_GET_PS_PROFILE";
           	String command = WebUtil.nvl(box.get("command"));
           	String dest = WebUtil.JspURL+"N/bsnrmd/BusinRecommendList.jsp";
           	
           	/**
           	 * @$ 웹보안진단 marco257
           	 * 해당 사번이 조직을 조회 할수 있는지 체크 
           	 */
           	box.put("I_PERNR", user.empNo);
           	box.put("I_AUTHOR", "M");
           	box.put("I_GUBUN", "3");
           	
           	
          /* 	String sfunctionName = "ZHRA_RFC_CHECK_BELONG3";

           	EHRComCRUDInterfaceRFC sRFC = new EHRComCRUDInterfaceRFC();
	    	String reCode = sRFC.setImportInsert(box, sfunctionName, "RETURN");*/


	    	if(checkBelongGroup(req, res, orgCode, "3")){ //조회 가능
           	
           	
	           	if(command.equals("EDIT")){
	           		dest = WebUtil.JspURL+"N/bsnrmd/edit_condition_p.jsp";
	           	}else if(command.equals("SAVE")){
	           		Vector op = box.getVector("OPTIO");
	                int dataSize = op.size();
	          	 
	                Vector newVt = new Vector();
	                for(int n = 0 ; n < dataSize ; n++){
	                	BusinRecommendData businData = new BusinRecommendData();
	                	box.copyToEntity(businData, n);
	                	businData.GUBUN_TX = WebUtil.nvl((String)box.getVector("GUBUN_TX").get(n));
	                	businData.QK_ITEM_TX = WebUtil.nvl((String)box.getVector("QK_ITEM_TX").get(n)); 
	                	businData.OPTIO = WebUtil.nvl((String)box.getVector("OPTIO").get(n));
	                	newVt.addElement(businData);
	                }
	                String retCode = comRFC.setTableInsert(box, functionName, newVt, "T_IMPORT");
	           		
	           	}
	           	
	            HashMap resultVT = comRFC.getExecutAll(box, functionName);

				resultVT.put("E_RETURN", comRFC.getReturn().MSGTY);

	            req.setAttribute("resultVT", resultVT);
	           
	    	}else{
	    		String msg = "인사조직 조회권한이 없습니다";
                String url = "history.back();";
                req.setAttribute("msg", msg);
                req.setAttribute("url", url);
                dest = WebUtil.JspURL+"common/msg.jsp";
	    	}
	    	 printJspPage(req, res, dest);
        } catch(Exception e) {
            throw new GeneralException(e);
        } finally {
            //DBUtil.close(con);
        }
	}
}