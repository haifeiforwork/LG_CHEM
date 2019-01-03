/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manager's Desc                                              */
/*   2Depth Name  : 복리후생                                                    */
/*   Program Name : 부서별 복리후생 현황                                        */
/*   Program ID   : F51DeptWelfareSV                                            */
/*   Description  : 부서별 복리후생 현황 조회를 위한 서블릿                     */
/*   Note         : 없음                                                        */
/*   Creation     : 2005-02-21 유용원                                           */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/

package servlet.hris.F;

import com.common.RFCReturnEntity;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;
import hris.F.rfc.F51DeptWelfareRFC;
import hris.common.WebUserData;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.Vector;

/**
 * F51DeptWelfareSV
 * 부서에 따른 전체 부서원의 복리후생 현황 정보를 가져오는
 * F51DeptWelfareRFC 를 호출하는 서블릿 class
 *
 * @author  유용원
 * @version 1.0
 */
public class F51DeptWelfareSV extends EHRBaseServlet {

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
    	try{
	        HttpSession session = req.getSession(false);
	        String deptId       = WebUtil.nvl(req.getParameter("hdn_deptId")); 			//부서코드...
	        String checkYN      = WebUtil.nvl(req.getParameter("chck_yeno"), "N"); 		//하위부서여부.
	        String selGubun     = WebUtil.nvl(req.getParameter("sel_gubun"), "99"); 	//구분 99:전체.
	        String startDay     = WebUtil.nvl(req.getParameter("txt_startDay")); 		//검색시작일.
	        String endDay       = WebUtil.nvl(req.getParameter("txt_endDay")); 			//검색종료일.
	        String excelDown    = WebUtil.nvl(req.getParameter("hdn_excel"));  			//excelDown...
	        WebUserData user    = (WebUserData)session.getAttribute("user");				//세션.

	        String dest    		= "";
	        String dest_detail    		= "";
//	        String jobid = WebUtil.nvl(req.getParameter("jobid"));

	        //(.)제거.
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
            if (!user.sapType.isLocal()) {
    	    startDay     = WebUtil.nvl(startDay, preDate1);
    	    endDay       = WebUtil.nvl(endDay, toDate1);
            }

            //초기화면 오픈시 로그인 사용자의 데이터를 보여준다.
            if( deptId.equals("") ){
            	deptId = user.e_objid;
            }

            if (!user.sapType.isLocal()) {
            	dest_detail = "Global";
            }else {
            	dest_detail = "KR";
            }
           	/**
           	 * @$ 웹보안진단 rdcamel
           	 * 해당 사번이 조직을 조회 할수 있는지 체크
           	 */
			   if(!checkBelongGroup(req, res, deptId, "")) return;
        	// @웹취약성 추가
			   if(!checkAuthorization(req, res)) return;

	        String E_RETURN  	= "";
	        String E_MESSAGE 	= g.getMessage("MSG.F.F41.0007") ;

		        F51DeptWelfareRFC func = null;
		        Vector DeptWelfare_vt  = null;

		        if ( !deptId.equals("") ) {
		        	func       			= new F51DeptWelfareRFC();
		        	DeptWelfare_vt  	= new Vector();
		            Vector ret 			= func.getDeptWelfare(deptId, checkYN, selGubun, startDay, endDay,DataUtil.getCurrentDate(),user.sapType);
		            E_RETURN   			= (String)ret.get(0);
		            E_MESSAGE  			= (String)ret.get(1);
		            DeptWelfare_vt 		= (Vector)ret.get(2);
		        }
		        Logger.debug.println(this, " E_RETURN = " + E_RETURN);
		        RFCReturnEntity result = func.getReturn();
		        //RFC 호출 성공시.
		        if( result.isSuccess()){
		        	req.setAttribute("checkYn", checkYN);
		        	req.setAttribute("E_RETURN", E_RETURN);
		        	req.setAttribute("E_MESSAGE", E_MESSAGE);
			        req.setAttribute("DeptWelfare_vt", DeptWelfare_vt);
			        if( excelDown.equals("ED") ) //엑셀저장일 경우.
			            dest = WebUtil.JspURL+"F/F51DeptWelfareExcel_"+dest_detail+".jsp";
			        else
			        	dest = WebUtil.JspURL+"F/F51DeptWelfare_"+dest_detail+".jsp";

			        Logger.debug.println(this, "DeptWelfare_vt : "+ DeptWelfare_vt.toString());
			    //RFC 호출 실패시.
		        }else{
			        String msg = E_MESSAGE;
			        String url = "location.href = '"+WebUtil.JspURL+"F/F51DeptWelfare"+dest_detail+".jsp?checkYn="+checkYN+"';";
			        req.setAttribute("msg", msg);
			        req.setAttribute("url", url);
			        dest = WebUtil.JspURL+"common/msg.jsp?checkYn="+checkYN;
		        }

	        Logger.debug.println(this, " destributed = " + dest);
	        printJspPage(req, res, dest);
    	} catch(Exception e) {
            throw new GeneralException(e);
        }
    }
}