/********************************************************************************/
/*                                                                              */
/*   System Name  : EHR                                                         */
/*   1Depth Name  : Manager's Desc                                              */
/*   2Depth Name  : Global육성POOL                                              */
/*   Program Name : HPI Global육성POOL                                          */
/*   Program ID   : F70GlobalClassSV                                            */
/*   Description  : HPI Global육성POOL 조회를 위한 서블릿                       */
/*   Note         : 없음                                                        */
/*   Creation     : 2006-03-15 LSA                                              */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/
   
package servlet.hris.F;
   
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;
import hris.F.rfc.F70GlobalClassRFC;
import hris.common.WebUserData;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.Vector;

/**
 * F70GlobalClassSV
 * 부서에 따른 HPI Global육성POOL 정보를 가져오는 
 * F70GlobalClassRFC 를 호출하는 서블릿 class
 *
 * @author  유용원 
 * @version 1.0
 */
public class F70GlobalClassSV extends EHRBaseServlet {

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
    	try{ 
	        HttpSession session = req.getSession(false);
	        String jobid        = WebUtil.nvl(req.getParameter("jobid")); 			      //초기null...
	        String deptId       = WebUtil.nvl(req.getParameter("hdn_deptId")); 			  //부서코드...
	        String hdn_deptNm   = WebUtil.nvl(req.getParameter("hdn_deptNm")); 			  //부서명...
	        String checkYN      = WebUtil.nvl(req.getParameter("chck_yeno"), "N"); 		//하위부서여부.
	        String excelDown    = WebUtil.nvl(req.getParameter("hdn_excel"));  			  //excelDown...
	        String pool_gubn    = WebUtil.nvl(req.getParameter("pool"));  	   		    //01: HPI02: 지역전문가03: HPI&지역전문가04: 육성MBA05: HPI&육성MBA06: 법인장교육이수자07: 확보MBA08: 해외학위자09: R&D박사10: 국내외국인근무자11: 중국지역경험자12: 중국外지역경험자13: TOEIC 800점 이상자14: HSK 5등급 이상자15: LGA 3.5점 이상자16: 중국어 전공자17: 영어&중국어 가능자
	        WebUserData user    = (WebUserData)session.getAttribute("user");				      //세션.

            //초기화면 오픈시 로그인 사용자의 데이터를 보여준다.
            //if( deptId.equals("") ){
            //   	deptId = user.e_objid;          
            //}
          if( jobid.equals("") && !pool_gubn.equals("")) {
              jobid = "first";
          }            
          if( !pool_gubn.equals("")) {
              pool_gubn  = pool_gubn.substring(0,2);
          }            
	        String dest    		= "";
	        String E_RETURN  	= ""; 
	        //String E_MESSAGE 	= "부서 정보를 가져오는데 실패하였습니다.";
	        String E_MESSAGE 	= "메뉴구분을 가져오는데 실패하였습니다.";
	        Logger.debug.println(this, " pool_gubn = " + pool_gubn+"[deptId:"+deptId);
	        
           	/**
           	 * @$ 웹보안진단 rdcamel
           	 * 해당 사번이 조직을 조회 할수 있는지 체크 
           	 */
			checkBelongGroup(req, res, deptId, "");
		        
	//	      @웹취약성 추가
	            checkAuthorization(req, res);
		        
		        F70GlobalClassRFC func    	= null;
		        Vector F70GlobalClassTitle_vt	= null;
		        Vector F70GlobalClassNote_vt  = null;
		   
		        if ( !deptId.equals("") ) { 
		        	func       						= new F70GlobalClassRFC();
		        	F70GlobalClassTitle_vt	= new Vector();
		        	F70GlobalClassNote_vt		= new Vector();
		            Vector ret 						= func.getDeptPositionClass(deptId, checkYN,DataUtil.getCurrentDate(),pool_gubn);	
		
		            E_RETURN   						= (String)ret.get(0);
		            E_MESSAGE  						= (String)ret.get(1);
		            F70GlobalClassTitle_vt	= (Vector)ret.get(2);
		            F70GlobalClassNote_vt		= (Vector)ret.get(3);
		        }
		        Logger.debug.println(this, " E_RETURN = " + E_RETURN+"jobid:"+jobid+"checkYn:"+checkYN);
		        
		        //RFC 호출 성공시.
		        if( jobid.equals("first") ) {    
		        	
			          req.setAttribute("checkYn", checkYN);
			          req.setAttribute("pool"   , pool_gubn);
			          req.setAttribute("jobid"   , jobid);
			          req.setAttribute("F70GlobalClassTitle_vt", F70GlobalClassTitle_vt);
			          req.setAttribute("F70GlobalClassNote_vt", F70GlobalClassNote_vt);
			          dest = WebUtil.JspURL+"F/F70GlobalClass.jsp";
			        
		        }else if( E_RETURN != null && E_RETURN.equals("S") ){
			        req.setAttribute("checkYn", checkYN);
			        req.setAttribute("pool"   , pool_gubn);
			        req.setAttribute("F70GlobalClassTitle_vt", F70GlobalClassTitle_vt);
			        req.setAttribute("F70GlobalClassNote_vt", F70GlobalClassNote_vt);
			        req.setAttribute("jobid"   , jobid);
			        if( excelDown.equals("ED") ) //엑셀저장일 경우.
			            dest = WebUtil.JspURL+"F/F70GlobalClassExcel.jsp";
			        else
			        	dest = WebUtil.JspURL+"F/F70GlobalClass.jsp";
			        
			        Logger.debug.println(this, "F70GlobalClassTitle_vt : "+ F70GlobalClassTitle_vt.toString());
			        Logger.debug.println(this, "F70GlobalClassNote_vt : "+ F70GlobalClassNote_vt.toString());
			    //RFC 호출 실패시.    
		        }else if( pool_gubn == null || pool_gubn.equals("") ){
			        String msg = E_MESSAGE;
			        String url = "history.back();";
			        req.setAttribute("msg", msg);
			        req.setAttribute("url", url);
			        req.setAttribute("jobid"   , jobid);
			        dest = WebUtil.JspURL+"common/msg.jsp";
		        }else{
			        String msg = E_MESSAGE;
			        String url = "location.href = '"+WebUtil.JspURL+"F/F70GlobalClass.jsp?checkYn="+checkYN+"&pool="+pool_gubn+"&jobid="+jobid+"&hdn_deptId="+deptId+"&hdn_deptNm="+hdn_deptNm+"';";
			        req.setAttribute("msg", msg);
			        req.setAttribute("url", url);
			        req.setAttribute("jobid"   , jobid);
			        dest = WebUtil.JspURL+"common/msg.jsp";
		        }
	    	
	        Logger.debug.println(this, " destributed = " + dest);
	        printJspPage(req, res, dest);
    	} catch(Exception e) {
            throw new GeneralException(e);
        }        
    }
}