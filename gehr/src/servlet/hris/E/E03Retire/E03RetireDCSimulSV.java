/******************************************************************************/
/*                                                                              */
/*   System Name  : ESS                                                         */
/*   1Depth Name  : ÅðÁ÷±Ý                                               */
/*   2Depth Name  : ÅðÁ÷±Ý Á¶È¸                                                 */
/*   Program Name : ÅðÁ÷±Ý Á¶È¸ - DC»ç¿ëÀÚ                                */
/*   Program ID   : E03RetireDCSimulSV                                         */
/*   Description  : ÅðÁ÷±Ý  Á¶È¸ ¼­ºí¸´ - DC»ç¿ëÀÚ                                  */
/*   Note         :                                               */
/*   Creation     : 2010-07-07 ¹Ú¹Î¿µ                                           */
/*   Update       : 2010-07-12 siyakim                                                            */
/*                                                                              */
/*                                                                              */
/********************************************************************************/

package servlet.hris.E.E03Retire;

//ÅðÁ÷±Ý Á¶È¸
import java.util.Properties;
import java.util.Vector;

import javax.servlet.http.*;

import com.sns.jdf.*;
import com.sns.jdf.util.*;
import com.sns.jdf.servlet.*;

import hris.common.*;
import hris.common.util.*;
import hris.common.rfc.*;

import hris.E.E03Retire.*;
import hris.E.E03Retire.rfc.*;
import hris.common.WebUserData;

public class E03RetireDCSimulSV extends EHRBaseServlet 
{
	protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {
		// TODO Auto-generated method stub
		Logger.debug.println("request = " + req.getRemoteAddr() + ":" + req.getRemoteHost());
		
		try {

            HttpSession session = req.getSession(false);
            WebUserData user    = (WebUserData)session.getAttribute("user");

            String dest = "";
            String jobid = "";
    
            Box box = WebUtil.getBox(req);
            jobid = box.get("jobid");

            if( jobid.equals("") ){
                jobid = "first";
            }

            String retireType = new E03RetireGubunRFC().getRetireGubunInfo(user.empNo);
        	req.setAttribute("retireType", retireType);            
            if(retireType.equalsIgnoreCase("DB") || retireType.equalsIgnoreCase("")){
                dest = WebUtil.JspURL+"E/E03Retire/E03RetireDCSimul.jsp";  
            }else{
		        	Vector v = (Vector)new E03RetireDCSimulRFC().setRetireList(user.empNo);
		        	Vector v_table = null;
		        	E03RetireDCSimulData d_field = null;
		        	
		        	if(v.size() > 0){
		        		v_table = (Vector)v.get(0);		
		        		d_field = (E03RetireDCSimulData)v.get(1);
		        	}
		        	req.setAttribute("v_table", v_table); 
	                req.setAttribute("insu_text", d_field.E_INSU_TEXT);  
	                dest = WebUtil.JspURL+"E/E03Retire/E03RetireDCSimul.jsp";

            }
            printJspPage(req, res, dest);
            Logger.debug.println(this, " destributed = " + dest);
        } catch(Exception e) {
            throw new GeneralException(e);
        } 
    }
}
