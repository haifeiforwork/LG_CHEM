/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manager's Desc                                              */
/*   2Depth Name  : 코스트센터                                                  */
/*   Program Name : 부서별 코스트센터 조회                                      */
/*   Program ID   : F61DeptCostCenterSV                                         */
/*   Description  : 부서별 코스트센터 조회 조회를 위한 서블릿                   */
/*   Note         : 없음                                                        */
/*   Creation     : 2005-02-21 유용원                                           */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/
  
package servlet.hris.F;
 
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.WebUtil;
import hris.F.rfc.F61DeptCostCenterRFC;
import hris.common.WebUserData;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.Vector;

/**
 * F61DeptCostCenterSV
 * 부서에 따른 전체 코스트센터 조회 정보를 가져오는 
 * F61DeptCostCenterRFC 를 호출하는 서블릿 class
 *
 * @author  유용원
 * @version 1.0
 */
public class F61DeptCostCenterSV extends EHRBaseServlet {

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
    	try{ 
	        HttpSession session = req.getSession(false);
	        String deptId       = WebUtil.nvl(req.getParameter("hdn_deptId")); 			//부서코드...
	        String checkYN      = WebUtil.nvl(req.getParameter("chck_yeno"), "N"); 		//하위부서여부.
	        String excelDown    = WebUtil.nvl(req.getParameter("hdn_excel"));  			//excelDown...
	        WebUserData user    = (WebUserData)session.getAttribute("user");				//세션.

            //초기화면 오픈시 로그인 사용자의 데이터를 보여준다.
            if( deptId.equals("") ){
            	deptId = user.e_objid;
            }
            
	        String dest    		= "";
	        String E_RETURN  	= ""; 
	        String E_MESSAGE 	= "부서 정보를 가져오는데 실패하였습니다.";
	        
           	/**
           	 * @$ 웹보안진단 rdcamel
           	 * 해당 사번이 조직을 조회 할수 있는지 체크 
           	 */
			checkBelongGroup(req, res, deptId, "");
	//	      @웹취약성 추가
	            checkAuthorization(req, res);
		        
		        F61DeptCostCenterRFC func = null;
		        Vector DeptCostCenter_vt  = null;
		   
		        if ( !deptId.equals("") ) { 
		        	func       			= new F61DeptCostCenterRFC();
		        	DeptCostCenter_vt  	= new Vector();
		            Vector ret 			= func.getDeptCostCenter(deptId, checkYN);		
		
		            E_RETURN   			= (String)ret.get(0);
		            E_MESSAGE  			= (String)ret.get(1);
		            DeptCostCenter_vt 	= (Vector)ret.get(2);
		        }
		        Logger.debug.println(this, " E_RETURN = " + E_RETURN);
		        
		        //RFC 호출 성공시.
		        if( E_RETURN != null && E_RETURN.equals("S") ){
		        	req.setAttribute("checkYn", checkYN);
			        req.setAttribute("DeptCostCenter_vt", DeptCostCenter_vt);
			        if( excelDown.equals("ED") ) //엑셀저장일 경우.
			            dest = WebUtil.JspURL+"F/F61DeptCostCenterExcel.jsp";
			        else
			        	dest = WebUtil.JspURL+"F/F61DeptCostCenter.jsp";
			        
			        Logger.debug.println(this, "DeptCostCenter_vt : "+ DeptCostCenter_vt.toString());
			    //RFC 호출 실패시.    
		        }else{
			        String msg = E_MESSAGE;
			        String url = "location.href = '"+WebUtil.JspURL+"F/F61DeptCostCenter.jsp?checkYn="+checkYN+"';";
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