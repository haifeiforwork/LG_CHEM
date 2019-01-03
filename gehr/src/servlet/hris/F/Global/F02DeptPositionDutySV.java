/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manager's Desc                                              */
/*   2Depth Name  : 인원현황                                                    */
/*   Program Name : 소속별/직무별 인원현황                                      */
/*   Program ID   : F02DeptPositionDutySV                                       */
/*   Description  : 소속별/직무별 인원현황 조회를 위한 서블릿                   */
/*   Note         : 없음                                                        */
/*   Creation     : 2005-03-01 유용원                                           */
/*   Update       : 2007-09-13  huang peng xiao                                 */
/*                                                                              */
/********************************************************************************/

package servlet.hris.F.Global;

import hris.F.Global.F02DeptPositionDutyNoteData;
import hris.F.Global.F02DeptPositionDutyTitleData;
import hris.F.rfc.Global.F02DeptPositionDutyRFC;
import hris.common.WebUserData;

import java.util.HashMap;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.WebUtil;

/**
 * F02DeptPositionDutySV
 * 부서에 따른 소속별/직무별 인원현황 정보를 가져오는
 * F02DeptPositionDutyRFC 를 호출하는 서블릿 class
 *
 * @author  유용원
 * @version 1.0
 */
public class F02DeptPositionDutySV extends EHRBaseServlet {

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
    	try{
    		req.setCharacterEncoding("utf-8");
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

	        F02DeptPositionDutyRFC func    	    = null;
	        Vector F02DeptPositionDutyTitle_vt	= null;
	        Vector F02DeptPositionDutyNote_vt   = null;

	        if ( !deptId.equals("") ) {
	        	func       						= new F02DeptPositionDutyRFC();
	        	F02DeptPositionDutyTitle_vt		= new Vector();
	        	F02DeptPositionDutyNote_vt		= new Vector();
	            Vector ret 						= func.getDeptPositionDuty(deptId, checkYN);

	            E_RETURN   						= (String)ret.get(0);
	            E_MESSAGE  						= (String)ret.get(1);
	            F02DeptPositionDutyTitle_vt		= (Vector)ret.get(2);
	            F02DeptPositionDutyNote_vt		= (Vector)ret.get(3);
	        }
			HashMap meta = doWithData(F02DeptPositionDutyTitle_vt);
	        Logger.debug.println(this, " E_RETURN = " + E_RETURN);
	        F02DeptPositionDutyNote_vt = dataFilter(F02DeptPositionDutyNote_vt);
	        //RFC 호출 성공시.
	        if( E_RETURN != null && E_RETURN.equals("S") ){
		        req.setAttribute("checkYn", checkYN);
		        req.setAttribute("F02DeptPositionDutyTitle_vt", F02DeptPositionDutyTitle_vt);
		        req.setAttribute("F02DeptPositionDutyNote_vt", F02DeptPositionDutyNote_vt);
		        req.setAttribute("meta", meta);
		        if( excelDown.equals("ED") ) //엑셀저장일 경우.
		            dest = WebUtil.JspURL+"F/F02DeptPositionDutyExcel_Global.jsp";
		        else
		        	dest = WebUtil.JspURL+"F/F02DeptPositionDuty_Global.jsp";

		    //RFC 호출 실패시.
	        }else{
		        String msg = E_MESSAGE;
		        String url = "location.href = '"+WebUtil.JspURL+"F/F02DeptPositionDuty_Global.jsp?checkYn="+checkYN+"';";
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
	/**
	 * @param deptPositionClassTitle_vt
	 * if ZLEVEL is 2 or null, clear data
	 * @return
	 */
	private Vector dataFilter(Vector deptPositionClassTitle_vt) {
		Vector ret = new Vector();
		boolean flag = false;
		for(int i = 0 ; i < deptPositionClassTitle_vt.size() ; i ++){
			F02DeptPositionDutyNoteData entity = (F02DeptPositionDutyNoteData) deptPositionClassTitle_vt.get(i);
			if(entity.ZLEVEL == null || entity.ZLEVEL.equals("1")){// || entity.ZLEVEL.equals("2")){
				entity = (F02DeptPositionDutyNoteData)hris.common.util.AppUtil.initEntity( entity , "0" , "");
				flag = true;
			}
			ret.addElement(entity);
		}
		if(!flag){
			ret = new Vector();
			for (int i = 0; i < deptPositionClassTitle_vt.size() ; i++) {
				F02DeptPositionDutyNoteData entity = (F02DeptPositionDutyNoteData) deptPositionClassTitle_vt.get(i);
				if(entity.ZLEVEL == null || entity.ZLEVEL.equals("2")){// || entity.ZLEVEL.equals("2")){
					entity = (F02DeptPositionDutyNoteData)hris.common.util.AppUtil.initEntity( entity , "0" , "");
					//flag = true;
				}
				ret.addElement(entity);
			}
		}
		//ret.addElement(deptPositionClassTitle_vt.get(deptPositionClassTitle_vt.size() - 1));
		return ret;
	}
	private HashMap doWithData(Vector deptServiceTitle_vt) {//calculate colspan
		HashMap tmp = new HashMap();
		for (int i = 0; i < deptServiceTitle_vt.size(); i++) {
			F02DeptPositionDutyTitleData entity = (F02DeptPositionDutyTitleData) deptServiceTitle_vt
					.get(i);
			if (tmp.containsKey(entity.PERST)) {
				Integer tmpStr = (Integer) tmp.get(entity.PERST);
				int val = tmpStr.intValue() + 1;
				tmp.put(entity.PERST, val);
			} else {
				tmp.put(entity.PERST, 1);
			}
		}
		return tmp;
	}
}