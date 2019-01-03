/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manager's Desc                                              */
/*   2Depth Name  :                                                     */
/*   Program Name :                                         */
/*   Program ID   : F52DeptWelfareLanguageEXPSV                                            */
/*   Description  :                      */
/*   Note         :                                                         */
/*   Creation     : 2007-9-14      heli  global hr create                                            */
/*   Update       : [CSR ID:3390354] 인사시스템 보안점검 미준수 사항 조치 2017-07-07 eunha
/*                                                                              */
/********************************************************************************/
package servlet.hris.F;

import java.util.Vector;

import hris.F.rfc.F52DeptWelfareEXPRFC;
import hris.common.WebUserData;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.common.Utils;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;

public class F52DeptWelfareLanguageEXPSV extends EHRBaseServlet{


	 protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
	    {
	    	try{
	    		req.setCharacterEncoding("utf-8");
		        HttpSession session = req.getSession(false);
		        String deptId       = WebUtil.nvl(req.getParameter("hdn_deptId"));
		        String checkYN      = WebUtil.nvl(req.getParameter("chck_yeno"), "N");
		        String startDay     = WebUtil.nvl(req.getParameter("txt_startDay"));
		        String endDay       = WebUtil.nvl(req.getParameter("txt_endDay"));
		        String excelDown    = WebUtil.nvl(req.getParameter("hdn_excel"));  			//excelDown...
		        WebUserData user = WebUtil.getSessionUser(req);

		        String dest    		= "";

		        startDay 	= DataUtil.removeStructur(startDay, ".");
		        endDay 		= DataUtil.removeStructur(endDay, ".");


  		        String toDate1 = DataUtil.getCurrentDate();
	            String preDate1 = null;
	            String yearStr1 = toDate1.substring(0, 4);
	            Integer year1 = Integer.parseInt(yearStr1);

	            if(((year1 % 4 == 0 && year1 % 100 != 0) || year1 % 400 == 0)){

	            	preDate1  = DataUtil.addDays(toDate1, -366);
	            }else{
	            	preDate1      = DataUtil.addDays(toDate1, -365);
	            }

	    	    startDay     = WebUtil.nvl(startDay, preDate1);
	    	    endDay       = WebUtil.nvl(endDay, toDate1);


	            if( deptId.equals("") ){
	            	deptId = user.e_objid;
	            }

				// [CSR ID:3390354] 인사시스템 보안점검 미준수 사항 조치 start
	           	if(!checkBelongGroup( req, res, deptId, "")){
	           		return;
	           	}
			    // 웹취약성 추가
	            if(!checkAuthorization(req, res)) return;
	            //[CSR ID:3390354] 인사시스템 보안점검 미준수 사항 조치 end

		        String E_RETURN3  	= "";  //for language
		        String E_MESSAGE3 	= "Failed to take the department infomation.";

		        F52DeptWelfareEXPRFC func = null;

		        Vector DeptWelfareLanguage_vt  = new Vector();

                if ( !deptId.equals("") ) {

		        	   func  = new F52DeptWelfareEXPRFC();
		        	   Vector ret3 			= func.getDeptWelfareLanguageEXP(deptId, checkYN, startDay, endDay);

		               E_RETURN3   			= (String) Utils.indexOf(ret3, 0); //(String)ret3.get(0);  // return code
				       E_MESSAGE3  			= (String) Utils.indexOf(ret3, 1); //(String)ret3.get(1); // return message
				       DeptWelfareLanguage_vt   =  (Vector) Utils.indexOf(ret3, 2); // (Vector)ret3.get(2);
                }


                Logger.debug.println(this, " E_RETURN3 = " + E_RETURN3);

		        req.setAttribute("checkYn", checkYN);

		        req.setAttribute("E_RETURN3", E_RETURN3);
		        req.setAttribute("E_MESSAGE3", E_MESSAGE3);

		        req.setAttribute("DeptWelfareLanguage_vt", DeptWelfareLanguage_vt);

		        if(excelDown.equals("EDlanguage"))
		        	 dest = WebUtil.JspURL+"F/F52DeptWelfareLanguageExcel.jsp";
		        else
		             dest = WebUtil.JspURL+"F/F52DeptWelfareLanguage.jsp";

		        Logger.debug.println(this, " destributed = " + dest);
		        printJspPage(req, res, dest);

	    	} catch(Exception e) {
	            throw new GeneralException(e);
	        }
	    }





}
