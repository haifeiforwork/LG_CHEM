/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : 공통                                                        */
/*   2Depth Name  :                                                             */
/*   Program Name : 부서명 검색                                                 */
/*   Program ID   : OrganListSV.java                                            */
/*   Description  : 부서명 검색하는 include 파일                                */
/*   Note         : 없음                                                        */
/*   Creation     : 2005-02-20 유용원                                           */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/
  
package servlet.hris.common; 
 
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.WebUtil;
import hris.common.WebUserData;
import hris.common.rfc.SearchDeptNameRFC;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Vector;

/**
 * SearchDeptNameSV
 * 권한에 따른 전체 부서명 정보를 가져오는 
 * SearchDeptNameRFC 를 호출하는 서블릿 class
 *
 * @author  유용원 
 * @version 1.0
 */
public class SearchDeptNameSV extends EHRBaseServlet {

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        try{ 
            WebUserData user    = WebUtil.getSessionUser(req);
            Box box = WebUtil.getBox(req);
	        String deptNm      =   box.get("txt_deptNm"); //부서명...
            String authClsf    =   box.get("authClsf");

			Logger.debug("=----------------------------------------------- ");
	        String dest    		= "";
	        String E_RETURN  	= ""; 
	        String E_MESSAGE 	= "부서명을 얻지 못했습니다.";
	        
	        SearchDeptNameRFC func = null;
	        Vector DeptName_vt  = null; 
	   
	        if ( !deptNm.equals("") ) { 
	        	func       		= new SearchDeptNameRFC();
	        	DeptName_vt  	= new Vector();
                if (authClsf == null || authClsf.equals("")) {
                    authClsf = "M";
                } // end if
	            Vector ret 		= func.getDeptName(user.empNo, deptNm, authClsf); //권한 Set!!!	
	            Logger.debug.println(this ,"userNo =" + user.empNo + " dptNm = " + deptNm + " authClsf =" + authClsf);
	            E_RETURN   		= (String)ret.get(0);
	            E_MESSAGE  		= (String)ret.get(1);
	            DeptName_vt 	= (Vector)ret.get(2);
	        }	
	        Logger.debug.println(this, " E_RETURN = " + E_RETURN);
	        
	        //RFC 호출 성공시.
	        if( E_RETURN != null && E_RETURN.equals("S") ){
		        req.setAttribute("DeptName_vt", DeptName_vt);
		        dest = WebUtil.JspURL+"common/SearchDeptNamePopIF.jsp";
		        
		        Logger.debug.println(this, "DeptName_vt : "+ DeptName_vt.toString());
		    //RFC 호출 실패시.    
	        }else{
		        String msg = E_MESSAGE;
		        String url = " parent.close(); ";
		        
		        req.setAttribute("msg", msg);
		        req.setAttribute("url", url);
		        dest = WebUtil.JspURL+"common/msg.jsp";
	        }
	        
	        Logger.debug.println(this, " destributed = " + dest);
	        printJspPage(req, res, dest);
    	} catch(Exception e) {
            throw new GeneralException(e);
        }        
    }
}