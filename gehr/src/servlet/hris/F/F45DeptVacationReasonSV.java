/********************************************************************************/
/*                                                                                   */
/*   System Name  : MSS                                                    */
/*   1Depth Name  : Manager's Desc                                      */
/*   2Depth Name  : 근태                                                                   */
/*   Program Name : 부서별 휴가 사유 리포트                                      */
/*   Program ID   : F45DeptVacationReasonSV                          */
/*   Description  : 부서별 휴가 사유 현황 조회를 위한 서블릿                 */
/*   Note         : 없음                                                                          */
/*   Creation     : 2010-03-16 lsa                                           */
/*   Update       :                                                                */
/*                                                                                     */
/********************************************************************************/

package servlet.hris.F;

import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;
import hris.F.rfc.F45DeptVacationReasonRFC;
import hris.common.WebUserData;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.Vector;

/**
 * F42DeptVacationReasonSV
 * 부서에 따른 전체 부서원의 휴가 사유 현황 정보를 가져오는
 * F41DeptVacationRFC 를 호출하는 서블릿 class
 *
 * @author  유용원
 * @version 1.0
 */
public class F45DeptVacationReasonSV extends EHRBaseServlet {

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
    	try{
	        HttpSession session = req.getSession(false);
	        String deptId       = WebUtil.nvl(req.getParameter("hdn_deptId")); 			//부서코드...
	        String deptName       = WebUtil.nvl(req.getParameter("hdn_deptNm")); 			//부서코드...
	        String checkYN      = WebUtil.nvl(req.getParameter("chck_yeno"), "N"); 		//하위부서여부.
	        String excelDown    = WebUtil.nvl(req.getParameter("hdn_excel"));  			//excelDown...
	        String year            = WebUtil.nvl(req.getParameter("year1"),DataUtil.getCurrentYear() ); 		//년
	        String month          = WebUtil.nvl(req.getParameter("month1"),DataUtil.getCurrentMonth());  		//월
	        String i_gubun      = WebUtil.nvl(req.getParameter("i_gubun"),"1");  //1 - 휴가, 2 - 미결재휴가, 3 - 초과근무, 4 - 미결재초과근무
	        WebUserData user    = (WebUserData)session.getAttribute("user");				//세션.
	        String subView       = WebUtil.nvl(req.getParameter("subView"));				//tab에서 호출되는지 여부

            //초기화면 오픈시 로그인 사용자의 데이터를 보여준다.
            if( deptId.equals("") ){
            	deptId = user.e_objid;
            }

	        String dest    		= "";
	        String E_RETURN  	= "";
	        //String E_MESSAGE 	= "부서 정보를 가져오는데 실패하였습니다.";
	        String E_MESSAGE 	= g.getMessage("MSG.F.F41.0007") ;

           	/**
           	 * @$ 웹보안진단 rdcamel
           	 * 해당 사번이 조직을 조회 할수 있는지 체크
           	 */
			   if(!checkBelongGroup(req, res, deptId, "")) return;
        	// @웹취약성 추가
			   if(!checkAuthorization(req, res)) return;

		        F45DeptVacationReasonRFC func = null;
		        Vector DeptVacation_vt  = null;

		        if ( !deptId.equals("") ) {
		        	func       				= new F45DeptVacationReasonRFC();
		        	DeptVacation_vt  	= new Vector();
		            Vector ret 				= func.getDeptVacation(deptId, checkYN,year+month,i_gubun);

		            E_RETURN   				= (String)ret.get(0);
		            E_MESSAGE  				= (String)ret.get(1);
		            DeptVacation_vt 	= (Vector)ret.get(2);
		        }
		        Logger.debug.println(this, " E_RETURN = " + E_RETURN+"deptId:"+deptId+"year:"+year+"month:"+month+"i_gubun:"+i_gubun);
		        req.setAttribute("subView", subView);
		        req.setAttribute("checkYn", checkYN);
		        //RFC 호출 성공시.
		        if(func.getReturn().isSuccess()){

		        	req.setAttribute("i_gubun", i_gubun);
		        	req.setAttribute("year", year);
		        	req.setAttribute("month",month);
			        req.setAttribute("DeptVacation_vt", DeptVacation_vt);
			        if( excelDown.equals("ED") ) //엑셀저장일 경우.
			            dest = WebUtil.JspURL+"F/F45DeptVacationReasonExcel.jsp";
			        else
			        	dest = WebUtil.JspURL+"F/F45DeptVacationReason.jsp";

			        Logger.debug.println(this, "DeptVacation_vt : "+ DeptVacation_vt.toString());
			    //RFC 호출 실패시.
		       }else{
			        String msg = E_MESSAGE;
			        String url = "location.href = '"+WebUtil.JspURL+"F/F45DeptVacationReason.jsp?subView="+subView+"&chck_yeno="+checkYN+"&hdn_deptId="+deptId+"&hdn_deptNm="+deptName+"&year="+year+"&month="+month+"&i_gubun="+i_gubun+"';";
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