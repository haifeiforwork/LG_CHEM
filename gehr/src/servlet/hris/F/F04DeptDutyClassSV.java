/********************************************************************************
*
*   System Name  : MSS
*   1Depth Name  : Manager's Desc
*   2Depth Name  : 인원현황
*   Program Name : 직무별/직급별 인원현황
*   Program ID   : F04DeptDutyClassSV
*   Description  : 직무별/직급별 인원현황 조회를 위한 서블릿
*   Note         : 없음
*   Creation     :
*   Update       :
*
********************************************************************************/

package servlet.hris.F;

import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.WebUtil;

import hris.F.F04DeptDutyClassTitleGlobalData;
import hris.F.rfc.F04DeptDutyClassGlobalRFC;
import hris.F.rfc.F04DeptDutyClassRFC;
import hris.common.WebUserData;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Vector;

/**
 * F04DeptDutyClassSV
 * 부서에 따른 직무별/직급별 인원현황 정보를 가져오는
 * F04DeptDutyClassRFC 를 호출하는 서블릿 class
 * @author
 * @version 1.0
 */
public class F04DeptDutyClassSV extends EHRBaseServlet {

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

            Vector ret                               = null;
            Vector F04DeptDutyClassTitle_vt = null;
            Vector F04DeptDutyClassNote_vt = null;
            boolean RfcSuccess                  = false;

			if ( !deptId.equals("") ) {

				F04DeptDutyClassTitle_vt  = new Vector();

				if( userArea ){
					F04DeptDutyClassRFC f04Rfc = null;
					f04Rfc                               = new F04DeptDutyClassRFC();
					ret                                   = f04Rfc.getDeptDutyClass(deptId, checkYN, user.area.getMolga());

					F04DeptDutyClassNote_vt	= new Vector();
	            	RfcSuccess = f04Rfc.getReturn().isSuccess();
	            	E_MESSAGE = f04Rfc.getReturn().MSGTX;
				}else {
					F04DeptDutyClassGlobalRFC f04RfcG = null;
	            	f04RfcG    						                = new F04DeptDutyClassGlobalRFC();
	            	ret 						                       = f04RfcG.getDeptDutyClass(deptId, checkYN, user.area.getMolga());
	            	RfcSuccess = f04RfcG.getReturn().isSuccess();
	            	E_MESSAGE = f04RfcG.getReturn().MSGTX;

	            }
				F04DeptDutyClassTitle_vt	= (Vector)ret.get(0);
	            if( userArea ){
	            	F04DeptDutyClassNote_vt	= (Vector)ret.get(1);
	            }
	        }

	        //RFC 호출 성공시.
	        if( RfcSuccess ){
		        req.setAttribute("checkYn", checkYN);
		        req.setAttribute("F04DeptDutyClassTitle_vt", F04DeptDutyClassTitle_vt);
		        if( userArea ){
		        	req.setAttribute("F04DeptDutyClassNote_vt", F04DeptDutyClassNote_vt);
		        }else{
		        	 req.setAttribute("meta", doWithData(F04DeptDutyClassTitle_vt) );
		        }
		        String returnDest = "";
		        if( !userArea ) returnDest = "_Global";
		        if( excelDown.equals("ED") ) //엑셀저장일 경우.
		            dest = WebUtil.JspURL+"F/F04DeptDutyClassExcel"+ returnDest + ".jsp";
		        else
		        	dest = WebUtil.JspURL+"F/F04DeptDutyClass"+ returnDest + ".jsp";

		    //RFC 호출 실패시.
	        }else{
	        	throw new GeneralException(E_MESSAGE);
	        }
	        printJspPage(req, res, dest);
    	} catch(Exception e) {
            throw new GeneralException(e);
        }
    }

	private List<HashMap<String, Integer>> doWithData(Vector deptServiceTitle_vt) {

		HashMap<String, Integer> tmp = new HashMap<String, Integer>();
		HashMap<String, Integer> tmp1 = new HashMap<String, Integer>();
		for (int i = 0; i < deptServiceTitle_vt.size(); i++) {
			F04DeptDutyClassTitleGlobalData entity = (F04DeptDutyClassTitleGlobalData) deptServiceTitle_vt.get(i);
			if (tmp.containsKey(entity.PBTXT)) {
				Integer tmpStr = (Integer) tmp.get(entity.PBTXT);
				int val = tmpStr.intValue() + 1;
				tmp.put(entity.PBTXT, val);
			} else {
				tmp.put(entity.PBTXT, 1);
			}
			if (tmp1.containsKey(entity.PBTXT + entity.JIKGT)) {
				Integer tmpStr = (Integer) tmp1.get(entity.PBTXT + entity.JIKGT);
				int val = tmpStr.intValue() + 1;
				tmp1.put(entity.PBTXT + entity.JIKGT, val);
			} else {
				tmp1.put(entity.PBTXT + entity.JIKGT, 1);
			}
		}
		List<HashMap<String, Integer>> list = new ArrayList<HashMap<String, Integer>>();
		list.add(tmp);
		list.add(tmp1);
		return list;
	}
}