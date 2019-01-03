/********************************************************************************
*
*   System Name  : MSS
*   1Depth Name  : Manager's Desc
*   2Depth Name  : 인원현황
*   Program Name : 소속별/직급별 평균연령
*   Program ID   : F07DeptPositionClassAgeSV
*   Description  : 소속별/직급별 평균연령 조회를 위한 서블릿
*   Note         : 없음
*   Creation     :
*   Update       :
*
********************************************************************************/

package servlet.hris.F;

import java.util.HashMap;
import java.util.Vector;
import javax.servlet.http.*;

import com.sns.jdf.*;
import com.sns.jdf.util.*;
import com.sns.jdf.servlet.*;

import hris.F.F07DeptPositionClassAgeTitleGlobalData;
import hris.F.rfc.*;
import hris.common.WebUserData;

/**
 * F07DeptPositionClassAgeSV
 * 부서에 따른 소속별/직급별 평균연령 정보를 가져오는
 * F07DeptPositionClassAgeRFC 를 호출하는 서블릿 class
 * @author
 * @version 1.0
 */
public class F07DeptPositionClassAgeSV extends EHRBaseServlet {

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

            Vector ret                                  = null;
            Vector F07DeptAgeTitle_vt		= null;
            Vector F07DeptAgeNote_vt		= null;
	        boolean RfcSuccess                  = false;

            if ( !deptId.equals("") ) {
            	F07DeptAgeTitle_vt			= new Vector();
            	if( userArea ){
            		F07DeptPositionClassAgeRFC f07Rfc = null;
            		f07Rfc = new F07DeptPositionClassAgeRFC();
            		ret                                   = f07Rfc.getDeptPositionClassAge(deptId, checkYN, user.area.getMolga());

	            	RfcSuccess = f07Rfc.getReturn().isSuccess();
	            	E_MESSAGE = f07Rfc.getReturn().MSGTX;
            	}else{
            		F07DeptPositionClassAgeGlobalRFC f07RfcG = null;
            		f07RfcG = new F07DeptPositionClassAgeGlobalRFC();
            		ret                                   = f07RfcG.getDeptPositionClassAge(deptId, checkYN, user.area.getMolga());

            		RfcSuccess = f07RfcG.getReturn().isSuccess();
            		E_MESSAGE = f07RfcG.getReturn().MSGTX;
            	}

				F07DeptAgeTitle_vt			= (Vector)ret.get(0);
				if( userArea ){
					F07DeptAgeNote_vt			= (Vector)ret.get(1);
				}
            }

	        //RFC 호출 성공시.
	        if( RfcSuccess ){
		        req.setAttribute("checkYn", checkYN);
		        if( userArea ){
			        req.setAttribute("F07DeptAgeTitle_vt", F07DeptAgeTitle_vt);
			        req.setAttribute("F07DeptAgeNote_vt", F07DeptAgeNote_vt);
		        }else{
		        	req.setAttribute("F07DeptAgeTitle_vt", dataFilter(F07DeptAgeTitle_vt));
		        	req.setAttribute("meta", doWithData(F07DeptAgeTitle_vt) );
		        }
		        String returnDest = "";
		        if( !userArea ) returnDest = "_Global";
		        if( excelDown.equals("ED") ) //엑셀저장일 경우.
		            dest = WebUtil.JspURL+"F/F07DeptPositionClassAgeExcel"+ returnDest + ".jsp";
		        else
		        	dest = WebUtil.JspURL+"F/F07DeptPositionClassAge"+ returnDest + ".jsp";
		    //RFC 호출 실패시.
	        }else{
	        	throw new GeneralException(E_MESSAGE);
	        }
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
		for (int i = 0; i < deptPositionClassTitle_vt.size(); i++) {
			F07DeptPositionClassAgeTitleGlobalData entity = (F07DeptPositionClassAgeTitleGlobalData) deptPositionClassTitle_vt.get(i);
			if (entity.ZLEVEL == null || entity.ZLEVEL.equals("1")) {// ||
				entity = (F07DeptPositionClassAgeTitleGlobalData) hris.common.util.AppUtil.initEntity(entity, "0", "");
				flag = true;
			}
			ret.addElement(entity);
		}
		if (!flag) {
			ret = new Vector();
			for (int i = 0; i < deptPositionClassTitle_vt.size(); i++) {
				F07DeptPositionClassAgeTitleGlobalData entity = (F07DeptPositionClassAgeTitleGlobalData) deptPositionClassTitle_vt.get(i);
				if (entity.ZLEVEL == null || entity.ZLEVEL.equals("2")) {// ||
					entity = (F07DeptPositionClassAgeTitleGlobalData) hris.common.util.AppUtil.initEntity(entity, "0", "");
				}
				ret.addElement(entity);
			}
		}
		return ret;
	}

	//calculate rowspan
	private HashMap doWithData(Vector deptServiceTitle_vt) {
		HashMap tmp = new HashMap<String, Integer>();
		for (int i = 0; i < deptServiceTitle_vt.size(); i++) {
			F07DeptPositionClassAgeTitleGlobalData entity = (F07DeptPositionClassAgeTitleGlobalData) deptServiceTitle_vt.get(i);
			if (tmp.containsKey(entity.STEXT + entity.OBJID)) {
				Integer tmpStr = (Integer) tmp.get(entity.STEXT + entity.OBJID);
				tmp.put(entity.STEXT + entity.OBJID, tmpStr.intValue() + 1);
			} else {
				tmp.put(entity.STEXT + entity.OBJID, 1);
			}
		}
		return tmp;
	}
}