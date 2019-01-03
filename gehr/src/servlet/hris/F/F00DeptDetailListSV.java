/********************************************************************************
*
*   System Name  : MSS
*   1Depth Name  : Manager's Desc
*   2Depth Name  : 인원현황
*   Program Name : 인원현황 각각의 상세화면
*   Program ID   : F00DeptDetailListSV
*   Description  : 인원현황 각각의 상세화면 조회를 위한 서블릿
*   Note         : 없음
*   Creation     :
*   Update       :
*
********************************************************************************/

package servlet.hris.F;

import hris.F.rfc.F00DeptDetailListGlobalRFC;
import hris.F.rfc.F00DeptDetailListRFC;
import hris.common.WebUserData;

import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.sns.jdf.GeneralException;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.WebUtil;

/**
 * F02DeptPositionDutySV
 * 인원현황 각각의 상세화면 정보를 가져오는
 * F00DeptDetailListRFC 를 호출하는 서블릿 class
 * @author
 * @version 1.0
 */
public class F00DeptDetailListSV extends EHRBaseServlet {
    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {
    	try{
	        Box         box 	= WebUtil.getBox(req);
	        WebUserData user = WebUtil.getSessionUser(req);	  //세션
	        boolean userArea = user.area.toString().equals("KR");

	        String gubun  	= box.get("hdn_gubun");		//구분값.
	        String deptId 	= box.get("hdn_deptId");	//부서코드
	        String checkYN	= box.get("chck_yeno");		//하위부서여부.
	        String paramA 	= box.get("hdn_paramA");	//파라메타
	        String paramB 	= box.get("hdn_paramB");	//파라메타
	        String paramC 	= box.get("hdn_paramC");	//파라메타
	        String paramD 	= box.get("hdn_paramD");	//파라메타
	        String paramE 	= box.get("hdn_paramE");	//파라메타
	        String paramF = "";
	        if( !userArea ){
	        	paramF 	= box.get("hdn_paramF");;
	        }
	        String excel  	= box.get("hdn_excel");		//엑셀여부.

	        String dest    		= "";
	        boolean E_RETURN  	=false;
	        String E_MESSAGE 	= g.getMessage("MSG.F.F41.0007"); //"상세 정보를 가져오는데 실패하였습니다.";

           	/**
           	 * @$ 웹보안진단
           	 * 해당 사번이 조직을 조회 할수 있는지 체크
           	 */
           	if(!checkBelongGroup( req, res, deptId, "")){
           		return;
           	}

		    // 웹취약성 추가
            if(!checkAuthorization(req, res)) return;

            Vector F00DeptDetailListData_vt = null;
            F00DeptDetailListData_vt		    = new Vector();
            Vector ret                               = null;

	        if ( !gubun.equals("") && !deptId.equals("") ) {
	        	if( userArea ){
	        		F00DeptDetailListRFC f00Rfc  = null;
	        		f00Rfc       						   = new F00DeptDetailListRFC();

	        		ret 						           = f00Rfc.getDeptDetailList(gubun, deptId, checkYN, user.area.getMolga(), paramA, paramB, paramC, paramD, paramE);

	        		E_RETURN = f00Rfc.getReturn().isSuccess();
	        		E_MESSAGE = f00Rfc.getReturn().MSGTX;
	        	}else{
	        		F00DeptDetailListGlobalRFC f00RfcG  = null;
	        		f00RfcG       						   = new F00DeptDetailListGlobalRFC();
	        		ret 						               = f00RfcG.getDeptDetailList(gubun, deptId, checkYN, user.area.getMolga(), paramA, paramB, paramC, paramD, paramE, paramF);

	        		E_RETURN = f00RfcG.getReturn().isSuccess();
	            	E_MESSAGE = f00RfcG.getReturn().MSGTX;
	        	}
	            F00DeptDetailListData_vt		= (Vector)ret.get(0);
	        }

	        //RFC 호출 성공시.
	        if( E_RETURN ){

		        req.setAttribute("F00DeptDetailListData_vt", F00DeptDetailListData_vt);
		        String returnDest = "";
		        if( !userArea ) returnDest = "_Global";
		        if( excel.equals("ED") ) //엑셀저장일 경우.
		            dest = WebUtil.JspURL+"F/F00DeptDetailListExcel"+ returnDest + ".jsp";
		        else
		        	dest = WebUtil.JspURL+"F/F00DeptDetailList"+ returnDest + ".jsp";
	        }else{
	        	throw new GeneralException(E_MESSAGE);
	        }
	        printJspPage(req, res, dest);
    	} catch(Exception e) {
            throw new GeneralException(e);
        }
    }
}