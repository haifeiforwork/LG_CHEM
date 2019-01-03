/******************************************************************************/
/*																							*/
/*   System Name	:  MSS														*/
/*   1Depth Name		:   부서근태													*/
/*   2Depth Name		:   공통														*/
/*   Program Name	:   부서명 조회												*/
/*   Program ID		: D40SearchDeptSV.java								*/
/*   Description		: 부서명 조회												*/
/*   Note				: 																*/
/*   Creation			: 2017-12-08  정준현                                          	*/
/*   Update				: 2017-12-08  정준현                                          	*/
/*                                                                              			*/
/********************************************************************************/
package servlet.hris.D.D40TmGroup;

import hris.D.D40TmGroup.rfc.D40SearchDeptRFC;
import hris.common.WebUserData;

import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.sns.jdf.GeneralException;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.WebUtil;

public class D40SearchDeptSV extends EHRBaseServlet {

	protected void performTask( HttpServletRequest req, HttpServletResponse res ) throws GeneralException {

		try{
            WebUserData user    = WebUtil.getSessionUser(req);
            Box box = WebUtil.getBox(req);
	        String deptNm      =   box.get("txt_deptNm"); //부서명...
            String authClsf    =   box.get("authClsf");
            String I_DATUM    =   box.get("I_DATUM");

//			Logger.debug("=----------------------------------------------- ");
	        String dest    		= "";
	        String E_RETURN  	= "";
	        String E_MESSAGE 	= "부서명을 얻지 못했습니다.";

	        D40SearchDeptRFC func = null;
	        Vector DeptName_vt  = null;

	        if ( !deptNm.equals("") ) {
	        	func       		= new D40SearchDeptRFC();
	        	DeptName_vt  	= new Vector();
                if (authClsf == null || authClsf.equals("")) {
                    authClsf = "M";
                } // end if
	            Vector ret 		= func.getDeptName(user.empNo, deptNm, authClsf, I_DATUM); //권한 Set!!!
//	            Logger.debug.println(this ,"userNo =" + user.empNo + " dptNm = " + deptNm + " authClsf =" + authClsf+ " I_DATUM =" + I_DATUM);
	            E_RETURN   		= (String)ret.get(0);
	            E_MESSAGE  		= (String)ret.get(1);
	            DeptName_vt 	= (Vector)ret.get(2);
	        }

	        req.setAttribute("E_RETURN", E_RETURN);
	        req.setAttribute("E_MESSAGE", E_MESSAGE);
	        req.setAttribute("DeptName_vt", DeptName_vt);
	        dest = WebUtil.JspURL+"D/D40TmGroup/common/SearchD40DeptPopIF.jsp";

//	        Logger.debug.println(this, "DeptName_vt : "+ DeptName_vt.toString());

//	        Logger.debug.println(this, " destributed = " + dest);
	        printJspPage(req, res, dest);
    	} catch(Exception e) {
            throw new GeneralException(e);
        }
	}

}
