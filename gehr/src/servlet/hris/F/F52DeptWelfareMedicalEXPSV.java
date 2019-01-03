/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manager's Desc                                              */
/*   2Depth Name  :                                                     */
/*   Program Name :                                         */
/*   Program ID   : F52DeptWelfareMedicalEXPSV                                            */
/*   Description  : Overview Medical Fee                     */
/*   Note         :                                                         */
/*   Creation     : 2007-10-11   zhouguangwen   global e-hr update            */
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
import com.sns.jdf.Logger;
import com.sns.jdf.GeneralException;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;

/**
 * F52DeptWelfareMedicalEXPSV
 * using F52DeptWelfareEXPRFC
 *
 * @author  zhouguangwen
 * 2007/10/11
 */
public class F52DeptWelfareMedicalEXPSV extends EHRBaseServlet{

	 protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
	    {

		 try{
	    		req.setCharacterEncoding("utf-8");
		        HttpSession session = req.getSession(false);
		        String deptId       = WebUtil.nvl(req.getParameter("hdn_deptId")); 			//부서코드...
		        String checkYN      = WebUtil.nvl(req.getParameter("chck_yeno"), "N");
		        String startDay     = WebUtil.nvl(req.getParameter("txt_startDay")); 		//검색시작일.
		        String endDay       = WebUtil.nvl(req.getParameter("txt_endDay")); 			//검색종료일.
		        String excelDown    = WebUtil.nvl(req.getParameter("hdn_excel"));  			//excelDown...
		        //WebUserData user    = (WebUserData)session.getAttribute("user");
		        WebUserData user = WebUtil.getSessionUser(req);

                String dest    		= "";

		        startDay 	= DataUtil.removeStructur(startDay, ".");
		        endDay 		= DataUtil.removeStructur(endDay, ".");

//====================init date begin

		        String toDate1 = DataUtil.getCurrentDate();
	            String preDate1 = null;
	            String yearStr1 = toDate1.substring(0, 4);
	            Integer year1 = Integer.parseInt(yearStr1);

	            if(((year1 % 4 == 0 && year1 % 100 != 0) || year1 % 400 == 0)){

	            	preDate1  = DataUtil.addDays(toDate1, -366);
	            }else{
	            	preDate1      = DataUtil.addDays(toDate1, -365);
	            }

	    	    startDay     = WebUtil.nvl(startDay, preDate1);   //검색시작일
	    	    endDay       = WebUtil.nvl(endDay, toDate1);

//===================init date end

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

	    	    String E_RETURN1  	= "";  //for medical
	    	    String E_MESSAGE1 	= "Failed to take the department infomation.";

                F52DeptWelfareEXPRFC func = null;

		        Vector DeptWelfareMedical_vt  = new Vector();

		        if ( !deptId.equals("") ) {

		        	 func       			= new F52DeptWelfareEXPRFC();
		        	 Vector ret1 			= func.getDeptWelfareMedicalEXP(deptId, checkYN, startDay, endDay);

			         E_RETURN1   			= (String) Utils.indexOf(ret1, 0); //(String)ret1.get(0);  // return code
			         E_MESSAGE1  			= (String) Utils.indexOf(ret1, 1); //(String)ret1.get(1); // return message
			         DeptWelfareMedical_vt   =  (Vector) Utils.indexOf(ret1, 2); // (Vector)ret.get(2);

		        }

		        Logger.debug.println(this, " E_RETURN1 = " + E_RETURN1);

		        req.setAttribute("checkYn", checkYN);
		        req.setAttribute("E_RETURN1", E_RETURN1);
		        req.setAttribute("E_MESSAGE1", E_MESSAGE1);

		        req.setAttribute("DeptWelfareMedical_vt", DeptWelfareMedical_vt);

		        if( excelDown.equals("EDmedical") )
				    dest = WebUtil.JspURL+"F/F52DeptWelfareMedicalExcel.jsp";

				else
				    dest = WebUtil.JspURL+"F/F52DeptWelfareMedical.jsp";

		        Logger.debug.println(this, " destributed = " + dest);
		        printJspPage(req, res, dest);

		  } catch(Exception e) {
	            throw new GeneralException(e);
	      }

	    }

}
