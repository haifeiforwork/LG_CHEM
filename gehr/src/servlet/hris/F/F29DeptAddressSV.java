/********************************************************************************
*   System Name  : MSS
*   1Depth Name  : Manager's Desc
*   2Depth Name  : 인원현황
*   Program Name : 부서별 현주소
*   Program ID   : F29DeptAddressSV
*   Description  : 부서별 현주소 조회를 위한 서블릿
*   Note         : 없음
*   Creation     :
*   Update       :
********************************************************************************/

package servlet.hris.F;

import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.WebUtil;

import hris.F.F26DeptExperiencedEmpData;
import hris.F.F29DeptAddressData;
import hris.F.rfc.F27DeptRewardNPunishRFC;
import hris.F.rfc.F29DeptAddressRFC;
import hris.common.WebUserData;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.util.HashMap;
import java.util.Vector;

/**
 * F29DeptAddressSV
 * 부서에 따른 전체 부서원의 현주소 정보를 가져오는
 * F29DeptAddressRFC 를 호출하는 서블릿 class
 * @author
 * @version 1.0
 */
public class F29DeptAddressSV extends EHRBaseServlet {

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException{
    	try{
	        String deptId       = WebUtil.nvl(req.getParameter("hdn_deptId")); 			//부서코드...
	        String checkYN      = WebUtil.nvl(req.getParameter("chck_yeno"), "N"); 		//하위부서여부.
	        String excelDown    = WebUtil.nvl(req.getParameter("hdn_excel"));  			//excelDown...
	        WebUserData user = WebUtil.getSessionUser(req);	                               //세션
	        boolean userArea = user.area.toString().equals("KR");

            //초기화면 오픈시 로그인 사용자의 데이터를 보여준다.
            if( deptId.equals("") ){
            	deptId = user.e_objid;
            }

	        String dest    		= "";
	        boolean RfcSuccess  	= false;
	        String E_MESSAGE 	= g.getMessage("MSG.F.F41.0007");

           	if(!checkBelongGroup( req, res, deptId, "")){
           		return;
           	}
		    // 웹취약성 추가
            if(!checkAuthorization(req, res)) return;


        	Vector ret = null;
        	F29DeptAddressRFC f29Rfc = null;
	        Vector DeptAddress_vt  = null;

	        if ( !deptId.equals("") ) {
	        	f29Rfc              = new F29DeptAddressRFC();
	        	DeptAddress_vt = new Vector();
	            ret                  = f29Rfc.getDeptLegalAssignment(deptId, checkYN);

	            RfcSuccess   = f29Rfc.getReturn().isSuccess();
            	E_MESSAGE = f29Rfc.getReturn().MSGTX;

	            DeptAddress_vt = (Vector)ret.get(0);
	        }

	        //RFC 호출 성공시.
	        if( RfcSuccess ){
	        	req.setAttribute("checkYn", checkYN);
		        req.setAttribute("DeptAddress_vt", DeptAddress_vt);

				HashMap<String, Integer> empCnt = new HashMap<String, Integer>();
				int cnt = 0;
				String oldPer = "";

				for (int i = 0; i < DeptAddress_vt.size(); i++) {
					F29DeptAddressData data = (F29DeptAddressData) DeptAddress_vt.get(i);
					if (oldPer.equals(data.PERNR) || (i == 0)) {
						cnt++;
					} else {
						empCnt.put(oldPer, cnt);
						cnt = 1;
					}
					if (i == DeptAddress_vt.size() - 1) {
						empCnt.put(data.PERNR, cnt);
					}
					oldPer = data.PERNR;
				}
				req.setAttribute("empCnt1", empCnt);
		        if( excelDown.equals("ED") ) //엑셀저장일 경우.
		            dest = WebUtil.JspURL+"F/F29DeptAddressExcel.jsp";
		        else
		        	dest = WebUtil.JspURL+"F/F29DeptAddress.jsp";

		        Logger.debug.println(this, "DeptAddress_vt : "+ DeptAddress_vt.toString());
		    //RFC 호출 실패시.
	        }else{
	        	throw new GeneralException(E_MESSAGE);
	        }
	        printJspPage(req, res, dest);
    	} catch(Exception e) {
            throw new GeneralException(e);
        }
    }
}