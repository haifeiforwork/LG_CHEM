/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manager's Desc                                              */
/*   2Depth Name  : Global육성POOL                                              */
/*   Program Name : Global육성POOL 각각의 상세화면                              */
/*   Program ID   : F71GlobalDetailListSV                                       */
/*   Description  : Global육성POOL 각각의 상세화면 조회를 위한 서블릿           */
/*   Note         : 없음                                                        */
/*   Creation     : 2006-03-16 LSA                                              */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/
   
package servlet.hris.F; 
   
import hris.F.rfc.F71GlobalDetailListRFC;
import hris.N.EHRComCRUDInterfaceRFC;
import hris.common.WebUserData;

import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.WebUtil;

/**
 * F02DeptPositionDutySV
 * Global육성POOL 각각의 상세화면 정보를 가져오는 
 * F71GlobalDetailListRFC 를 호출하는 서블릿 class
 *
 * @author  유용원 
 * @version 1.0 
 */
public class F71GlobalDetailListSV extends EHRBaseServlet {

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
    	try{ 
	        HttpSession session = req.getSession(false);
	        Box         box 	= WebUtil.getBox(req);
	        WebUserData user    = (WebUserData)session.getAttribute("user");				      //세션.
	        
	        String gubun  	= box.get("hdn_gubun");		//구분값.
	        String deptId 	= box.get("hdn_deptId");	//부서코드
	        String checkYN	= box.get("chck_yeno");		//하위부서여부.
	        String paramA 	= box.get("hdn_paramA");	//파라메타
	        String paramB 	= box.get("hdn_paramB");	//파라메타
	        String paramC 	= box.get("hdn_paramC");	//파라메타
	        String paramD 	= box.get("hdn_paramD");	//파라메타
	        String excel  	= box.get("hdn_excel");		//엑셀여부.
	        
	        Logger.debug.println(this, " gubun = " + gubun);
	        Logger.debug.println(this, " deptId = " + deptId);
	        Logger.debug.println(this, " checkYN = " + checkYN);
	        Logger.debug.println(this, " paramA = " + paramA);
	        Logger.debug.println(this, " paramB = " + paramB);
	        Logger.debug.println(this, " paramC = " + paramC);
	        Logger.debug.println(this, " paramD = " + paramD);
            
	        String dest    		= ""; 
	        String E_RETURN  	= ""; 
	        String E_MESSAGE 	= "상세 정보를 가져오는데 실패하였습니다.";
	        
           	/**
           	 * @$ 웹보안진단 rdcamel
           	 * 해당 사번이 조직을 조회 할수 있는지 체크 
           	 */
	        int orgFlag = user.e_authorization.indexOf("M");    //조직도권한여부.
	        
	        //checkBelongGroup(req, res, user, deptId);
	//	      @웹취약성 추가
	            checkAuthorization(req, res);
		        
		        F71GlobalDetailListRFC func    	    = null; 
		        Vector F71GlobalDetailListData_vt   	= null;
		   
		        if ( !gubun.equals("") && !deptId.equals("") ) { 
		        	func       						= new F71GlobalDetailListRFC();
		        	F71GlobalDetailListData_vt		= new Vector();
		            Vector ret 						= func.getDeptDetailList(gubun, deptId, checkYN, paramA, paramB, paramC, paramD);	
		  
		            E_RETURN   						= (String)ret.get(0);
		            E_MESSAGE  						= (String)ret.get(1);
		            F71GlobalDetailListData_vt		= (Vector)ret.get(2);
		        }
		        Logger.debug.println(this, " E_RETURN = " + E_RETURN);
		        
		        //RFC 호출 성공시.
		        if( E_RETURN != null && E_RETURN.equals("S") ){
			        req.setAttribute("F71GlobalDetailListData_vt", F71GlobalDetailListData_vt);
			        if( excel.equals("ED") ) //엑셀저장일 경우.
			            dest = WebUtil.JspURL+"F/F71GlobalDetailListExcel.jsp";
			        else
			        	dest = WebUtil.JspURL+"F/F71GlobalDetailList.jsp";
			        
			        Logger.debug.println(this, "F71GlobalDetailListData_vt : "+ F71GlobalDetailListData_vt.toString());
			    //RFC 호출 실패시.    
		        }else{
		        	Logger.debug.println(this, " E_MESSAGE = " + E_MESSAGE);
			        String msg = E_MESSAGE;
			        String url = "history.back();";
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