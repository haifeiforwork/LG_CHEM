/********************************************************************************
*
*   System Name  : MSS
*   1Depth Name  : Manager's Desc
*   2Depth Name  : 인원현황
*   Program Name : 직무별/최종학력별
*   Program ID   : F09DeptDutyLastSchoolSV
*   Description  : 직무별/최종학력별 조회를 위한 서블릿
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

import hris.F.F09DeptDutyLastSchoolTitleGlobalData;
import hris.F.rfc.F09DeptDutyLastSchoolGlobalRFC;
import hris.F.rfc.F09DeptDutyLastSchoolRFC;
import hris.common.WebUserData;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.util.HashMap;
import java.util.Vector;

/**
 * F09DeptDutyLastSchoolSV
 * 부서에 따른 직무별/최종학력별 정보를 가져오는
 * F09DeptDutyLastSchoolRFC 를 호출하는 서블릿 class
 * @author
 * @version 1.0
 */
public class F09DeptDutyLastSchoolSV extends EHRBaseServlet {

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {
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
            Vector F09DeptDutySchoolTitle_vt		= null;
            Vector F09DeptDutySchoolNote_vt		= null;
            boolean RfcSuccess                  = false;

            if ( !deptId.equals("") ) {

            	F09DeptDutySchoolTitle_vt = new Vector();

				if( userArea ){
					F09DeptDutyLastSchoolRFC f09Rfc = null;
					f09Rfc                               = new F09DeptDutyLastSchoolRFC();
					ret                                   = f09Rfc.getDeptDutyLastSchool(deptId, checkYN, user.area.getMolga());

	            	RfcSuccess = f09Rfc.getReturn().isSuccess();
	            	E_MESSAGE = f09Rfc.getReturn().MSGTX;
				}else {
					F09DeptDutyLastSchoolGlobalRFC f09RfcG = null;
					f09RfcG    						                = new F09DeptDutyLastSchoolGlobalRFC();
	            	ret 						                       = f09RfcG.getDeptDutyLastSchool(deptId, checkYN, user.area.getMolga());

	            	RfcSuccess = f09RfcG.getReturn().isSuccess();
	            	E_MESSAGE = f09RfcG.getReturn().MSGTX;
	            }
				F09DeptDutySchoolTitle_vt	= (Vector)ret.get(0);
	            if( userArea ){
	            	F09DeptDutySchoolNote_vt	= (Vector)ret.get(1);
	            }
            }

	        //RFC 호출 성공시.
	        if( RfcSuccess ){
		        req.setAttribute("checkYn", checkYN);
		        if( userArea ){
		        	req.setAttribute("F09DeptDutySchoolTitle_vt", F09DeptDutySchoolTitle_vt);
		        	req.setAttribute("F09DeptDutySchoolNote_vt", F09DeptDutySchoolNote_vt);
		        }else{
		        	req.setAttribute("F09DeptDutySchoolTitle_vt", dataFilter(F09DeptDutySchoolTitle_vt));
		        	req.setAttribute("meta", doWithData(F09DeptDutySchoolTitle_vt) );
		        }
		        String returnDest = "";
		        if( !userArea ) returnDest = "_Global";
		        if( excelDown.equals("ED") ) //엑셀저장일 경우.
		            dest = WebUtil.JspURL+"F/F09DeptDutyLastSchoolExcel"+ returnDest + ".jsp";
		        else
		        	dest = WebUtil.JspURL+"F/F09DeptDutyLastSchool"+ returnDest + ".jsp";

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
	private Vector dataFilter(Vector F09DeptDutySchoolTitle_vt) {
		Vector ret = new Vector();
		boolean flag = false;
		for(int i = 0 ; i < F09DeptDutySchoolTitle_vt.size() ; i ++){
			F09DeptDutyLastSchoolTitleGlobalData entity = (F09DeptDutyLastSchoolTitleGlobalData) F09DeptDutySchoolTitle_vt.get(i);
			if(entity.ZLEVEL == null || entity.ZLEVEL.equals("1")){// || entity.ZLEVEL.equals("2")){
				entity = (F09DeptDutyLastSchoolTitleGlobalData)hris.common.util.AppUtil.initEntity( entity , "0" , "");
				flag = true;
			}
			ret.addElement(entity);
		}
		if(!flag){
			ret = new Vector();
			for (int i = 0; i < F09DeptDutySchoolTitle_vt.size() ; i++) {
				F09DeptDutyLastSchoolTitleGlobalData entity = (F09DeptDutyLastSchoolTitleGlobalData) F09DeptDutySchoolTitle_vt.get(i);
				if(entity.ZLEVEL == null || entity.ZLEVEL.equals("2")){// || entity.ZLEVEL.equals("2")){
					entity = (F09DeptDutyLastSchoolTitleGlobalData)hris.common.util.AppUtil.initEntity( entity , "0" , "");
				}
				ret.addElement(entity);
			}
		}
		return ret;
	}

	//calculate rowspan
	private HashMap doWithData(Vector deptServiceTitle_vt) {
		HashMap tmp = new HashMap<String, Integer>();
		for ( int i = 0; i < deptServiceTitle_vt.size(); i++ ) {
			F09DeptDutyLastSchoolTitleGlobalData entity = (F09DeptDutyLastSchoolTitleGlobalData) deptServiceTitle_vt.get(i);
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