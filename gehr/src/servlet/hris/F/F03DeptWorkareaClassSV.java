/********************************************************************************
*
*   System Name  : MSS
*   1Depth Name  : Manager's Desc
*   2Depth Name  : 인원현황
*   Program Name : 근무지별/직급별 인원현황
*   Program ID   : F03DeptWorkareaClassSV
*   Description  : 근무지별/직급별 인원현황 조회를 위한 서블릿
*   Note         : 없음
*   Creation     :
*   Update       :
*
********************************************************************************/

package servlet.hris.F;

import com.sns.jdf.GeneralException;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.WebUtil;

import hris.F.F03DeptWorkareaClassTitleGlobalData;
import hris.F.rfc.F03DeptWorkareaClassGlobalRFC;
import hris.F.rfc.F03DeptWorkareaClassRFC;
import hris.common.WebUserData;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.util.HashMap;
import java.util.Vector;

/**
 * F03DeptWorkareaClassSV
 * 부서에 따른 근무지별/직급별 인원현황 정보를 가져오는
 * F03DeptWorkareaClassRFC 를 호출하는 서블릿 class
 *
 * @author
 * @version 1.0
 */
public class F03DeptWorkareaClassSV extends EHRBaseServlet {

	protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException{
    	try{
	        String deptId       = WebUtil.nvl(req.getParameter("hdn_deptId")); 			//부서코드...
	        String checkYN      = WebUtil.nvl(req.getParameter("chck_yeno"), "N"); 		//하위부서여부.
	        String excelDown    = WebUtil.nvl(req.getParameter("hdn_excel"));  			//excelDown...
	        WebUserData user = WebUtil.getSessionUser(req);		                            //세션
	        boolean userArea = user.area.toString().equals("KR");

            //초기화면 오픈시 로그인 사용자의 데이터를 보여준다.
            if( deptId.equals("") ){
            	deptId = user.e_objid;
            }

	        String dest    		= "";
	        String E_RETURN  	= "";
	        String E_MESSAGE 	= g.getMessage("MSG.F.F41.0007");

           	/**
           	 * @$ 웹보안진단 rdcamel
           	 * 해당 사번이 조직을 조회 할수 있는지 체크
           	 */

           	if(!checkBelongGroup( req, res, deptId, "")){
           		return;
           	}

		    // 웹취약성 추가
            if(!checkAuthorization(req, res)) return;

		    //F03DeptWorkareaClassRFC func    	= null;
	        Vector ret                                   = null;
	        Vector F03DeptWorkareaClassTitle_vt = null;
	        Vector F03DeptWorkareaClassNote_vt = null;
	        boolean RfcSuccess                       = false;
	        E_MESSAGE                                   = "";

	        if ( !deptId.equals("") ) {
	        	F03DeptWorkareaClassTitle_vt		= new Vector();
	        	F03DeptWorkareaClassNote_vt	    = new Vector();

	            if( userArea ){
	            	F03DeptWorkareaClassRFC f03Rfc = null;
	            	f03Rfc       						       = new F03DeptWorkareaClassRFC();
	            	ret 						               = f03Rfc.getDeptWorkareaClass(deptId, checkYN, user.area.getMolga());

	            	RfcSuccess = f03Rfc.getReturn().isSuccess();
	            	E_MESSAGE = f03Rfc.getReturn().MSGTX;
	            }else {
	            	F03DeptWorkareaClassGlobalRFC f03RfcG = null;
	            	f03RfcG    						                = new F03DeptWorkareaClassGlobalRFC();

	            	ret 						                       = f03RfcG.getDeptWorkareaClass(deptId, checkYN, user.area.getMolga());
	            	RfcSuccess = f03RfcG.getReturn().isSuccess();
	            	E_MESSAGE = f03RfcG.getReturn().MSGTX;
	            }

	            F03DeptWorkareaClassTitle_vt	= (Vector)ret.get(0);
	            if( userArea ){
	            	F03DeptWorkareaClassNote_vt	= (Vector)ret.get(1);
	            }
	        }

	        //RFC 호출 성공시.
	        if( RfcSuccess ){
		        req.setAttribute("checkYn", checkYN);
		        req.setAttribute("F03DeptWorkareaClassTitle_vt", F03DeptWorkareaClassTitle_vt);
		        if( userArea ){
		        	req.setAttribute("F03DeptWorkareaClassNote_vt", F03DeptWorkareaClassNote_vt);
		        }else{
		        	 req.setAttribute("meta", doWithData(F03DeptWorkareaClassTitle_vt) );
		        }
		        String returnDest = "";
		        if( !userArea ) returnDest = "_Global";
		        if( excelDown.equals("ED") ) //엑셀저장일 경우.
		            dest = WebUtil.JspURL+"F/F03DeptWorkareaClassExcel"+ returnDest + ".jsp";
		        else
		        	dest = WebUtil.JspURL+"F/F03DeptWorkareaClass"+ returnDest + ".jsp";

		    //RFC 호출 실패시.
	        }else{
	        	throw new GeneralException(E_MESSAGE);
	        }
	        printJspPage(req, res, dest);
    	} catch(Exception e) {
            throw new GeneralException(e);
        }
    }

	//calculate colspan
	private HashMap doWithData(Vector deptServiceTitle_vt) {
		HashMap tmp = new HashMap<String, Integer>();
		for (int i = 0; i < deptServiceTitle_vt.size(); i++) {
			F03DeptWorkareaClassTitleGlobalData entity = (F03DeptWorkareaClassTitleGlobalData) deptServiceTitle_vt.get(i);
			if (tmp.containsKey(entity.PBTXT)) {
				Integer tmpStr = (Integer) tmp.get(entity.PBTXT);
				int val = tmpStr.intValue() + 1;
				tmp.put(entity.PBTXT, val);
			} else {
				tmp.put(entity.PBTXT, 1);
			}
		}
		return tmp;
	}
}