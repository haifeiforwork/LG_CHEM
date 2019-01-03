/********************************************************************************
*   System Name  : MSS
*   1Depth Name  : Organization & Staffing
*   2Depth Name  : Headcount
*   Program Name : Org.Unit/Distance
*   Program ID   : F73DistanceInKilometersEurpSV
*   Description  : 소속별 출근거리별 인원현황 조회를 위한 서블릿
*   Note         : 없음
*   Creation     :
*    Update       : [CSR ID:3390354] 인사시스템 보안점검 미준수 사항 조치 2017-07-07 eunha
********************************************************************************/

package servlet.hris.F;

import hris.F.F73DistanceInKilometersEurpGlobalData;
import hris.F.rfc.F73DistanceInKilometersEurpGlobalRFC;
import hris.common.WebUserData;

import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.sns.jdf.GeneralException;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;

/**
 * F73DistanceInKilometersEurpSV
 * 부서에 따른 거주지 출/퇴근거리 정보를 가져오는 F73DistanceInKilometersRFCEurp를 호출하는 서블릿 class
 * @author
 * @version 1.0
 */
public class F73DistanceInKilometersEurpSV extends EHRBaseServlet {

	protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {
		try {
			req.setCharacterEncoding("utf-8");
			String deptId = WebUtil.nvl(req.getParameter("hdn_deptId")); // 부서코드...
			String checkYN = WebUtil.nvl(req.getParameter("chck_yeno"), "N"); // 하위부서여부.
			String excelDown = WebUtil.nvl(req.getParameter("hdn_excel")); // excelDown...
			WebUserData user = WebUtil.getSessionUser(req);		                            //세션

			String i_datum = DataUtil.getCurrentDate();

			// 초기화면 오픈시 로그인 사용자의 데이터를 보여준다.
			if (deptId.equals("")) {
				deptId = user.e_objid;
			}

			String dest = "";
	        boolean E_RETURN  = false;
	        String E_MESSAGE 	= g.getMessage("MSG.F.F41.0007");

	        F73DistanceInKilometersEurpGlobalRFC f73Rfc = null;
			Vector F73DistanceInKilometersTitle_vt = null;

			// [CSR ID:3390354] 인사시스템 보안점검 미준수 사항 조치 start
           	if(!checkBelongGroup( req, res, deptId, "")){
           		return;
           	}
		    // 웹취약성 추가
            if(!checkAuthorization(req, res)) return;
            //[CSR ID:3390354] 인사시스템 보안점검 미준수 사항 조치 end


			if (!deptId.equals("")) {
				f73Rfc = new F73DistanceInKilometersEurpGlobalRFC();
				F73DistanceInKilometersTitle_vt = new Vector();

				Vector ret = f73Rfc.getDistanceInKilometers(deptId, checkYN, i_datum, user.area.getMolga());

				E_RETURN = f73Rfc.getReturn().isSuccess();
            	E_MESSAGE = f73Rfc.getReturn().MSGTX;
				F73DistanceInKilometersTitle_vt = (Vector) ret.get(0);
			}


			// RFC 호출 성공시.
			if (E_RETURN) {
				req.setAttribute("checkYn", checkYN);
				req.setAttribute("F73DistanceInKilometersTitle_vt",  dataFilter(F73DistanceInKilometersTitle_vt));
				if (excelDown.equals("ED")) // 엑셀저장일 경우.
					dest = WebUtil.JspURL + "F/F73DistanceInKilometersExcelEurp.jsp";
				else
					dest = WebUtil.JspURL + "F/F73DistanceInKilometersEurp.jsp";
			    //RFC 호출 실패시.
	        }else{
	        	throw new GeneralException(E_MESSAGE);
	        }
			printJspPage(req, res, dest);
		} catch (Exception e) {
			throw new GeneralException(e);
		}
	}

	private Vector dataFilter(Vector F73DistanceInKilometersTitle_vt) {
		Vector ret = new Vector();
		boolean flag = false;
		for(int i = 0 ; i < F73DistanceInKilometersTitle_vt.size() ; i ++){
			F73DistanceInKilometersEurpGlobalData entity = (F73DistanceInKilometersEurpGlobalData) F73DistanceInKilometersTitle_vt.get(i);
			if(entity.ZLEVEL == null || entity.ZLEVEL.equals("1")){
				entity = (F73DistanceInKilometersEurpGlobalData)hris.common.util.AppUtilEurp.initEntity( entity , "0" , "");
				flag = true;
			}
			ret.addElement(entity);
		}
		if(!flag){
			ret = new Vector();
			for (int i = 0; i < F73DistanceInKilometersTitle_vt.size() ; i++) {
				F73DistanceInKilometersEurpGlobalData entity = (F73DistanceInKilometersEurpGlobalData) F73DistanceInKilometersTitle_vt.get(i);
				if(entity.ZLEVEL == null || entity.ZLEVEL.equals("2")){
					entity = (F73DistanceInKilometersEurpGlobalData)hris.common.util.AppUtilEurp.initEntity( entity , "0" , "");
				}
				ret.addElement(entity);
			}
		}
		return ret;
	}


}