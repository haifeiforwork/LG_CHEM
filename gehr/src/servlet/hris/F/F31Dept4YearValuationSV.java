/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manager's Desc                                              */
/*   2Depth Name  : 인원현황                                                    */
/*   Program Name : 부서별 4개년 상대화 평가                                    */
/*   Program ID   : F31Dept4YearValuationSV                                     */
/*   Description  : 부서별 4개년 상대화 평가 조회를 위한 서블릿                 */
/*   Note         : 없음                                                        */
/*   Creation     : 2005-02-01 유용원                                           */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/
  
package servlet.hris.F;
 
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.WebUtil;
import hris.F.rfc.F31Dept4YearValuationRFC;
import hris.common.WebUserData;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.Vector;

/**
 * F31Dept4YearValuationSV
 * 부서에 따른 전체 부서원의 4개년 상대화 평가 정보를 가져오는 
 * F31Dept4YearValuationRFC 를 호출하는 서블릿 class
 *
 * @author  유용원
 * @version 1.0
 */
public class F31Dept4YearValuationSV extends EHRBaseServlet {

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
	        boolean isSuccess = false;
	        String E_MESSAGE 	= "부서 정보를 가져오는데 실패하였습니다.";
	        
           	/**
           	 * @$ 웹보안진단 rdcamel
           	 * 해당 사번이 조직을 조회 할수 있는지 체크 
           	 */
			if(!checkBelongGroup( req, res, deptId, "")){
				return;
			}
			// 웹취약성 추가
			if(!checkAuthorization(req, res)) return;

	//	      @웹취약성 추가

		        Vector Dept4YearValuation_vt  = null;
		   
		        if ( !deptId.equals("") ) {
					F31Dept4YearValuationRFC func  = new F31Dept4YearValuationRFC();
					Dept4YearValuation_vt				= func.getDept4YearValuation(deptId, checkYN);
					isSuccess = func.getReturn().isSuccess();
		
		        }

		        //RFC 호출 성공시.
		        if( isSuccess){
		        	req.setAttribute("checkYn", checkYN);
			        req.setAttribute("Dept4YearValuation_vt", Dept4YearValuation_vt);
			        if( excelDown.equals("ED") ) //엑셀저장일 경우.
			            dest = WebUtil.JspURL+"F/F31Dept4YearValuationExcel.jsp";
			        else
			        	dest = WebUtil.JspURL+"F/F31Dept4YearValuation.jsp";
			        
			        Logger.debug.println(this, "Dept4YearValuation_vt : "+ Dept4YearValuation_vt.toString());
			    //RFC 호출 실패시.    
		        }else{
			        String msg = E_MESSAGE;
			        String url = "location.href = '"+WebUtil.JspURL+"F/F31Dept4YearValuation.jsp?checkYn="+checkYN+"';";
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