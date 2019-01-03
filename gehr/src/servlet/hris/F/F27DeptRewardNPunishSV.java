/********************************************************************************
*   System Name  : MSS
*   1Depth Name  : Manager's Desc
*   2Depth Name  : 인원현황
*   Program Name : 부서별 포상/징계 내역
*   Program ID   : F27DeptRewardNPunishSV
*   Description  : 부서별 포상/징계 내역 조회를 위한 서블릿
*   Note         : 없음
*   Creation     :
*   Update       :
********************************************************************************/

package servlet.hris.F;

import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.WebUtil;

import hris.F.F27DeptRewardNPunish01Data;
import hris.F.F27DeptRewardNPunish01GlobalData;
import hris.F.F27DeptRewardNPunish02Data;
import hris.F.F27DeptRewardNPunish02GlobalData;
import hris.F.rfc.F27DeptRewardNPunishRFC;
import hris.common.WebUserData;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.util.HashMap;
import java.util.Vector;

/**
 * F27DeptRewardNPunishSV
 * 부서에 따른 전체 부서원의 포상/징계 내역 정보를 가져오는
 * F27DeptRewardNPunishRFC 를 호출하는 서블릿 class
 * @author
 * @version 1.0
 */
public class F27DeptRewardNPunishSV extends EHRBaseServlet {

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

           	/**
           	 * @$ 웹보안진단 rdcamel
           	 * 해당 사번이 조직을 조회 할수 있는지 체크
           	 */

           	if(!checkBelongGroup( req, res, deptId, "")){
           		return;
           	}
		    // 웹취약성 추가
            if(!checkAuthorization(req, res)) return;

        	Vector ret = null;
	        F27DeptRewardNPunishRFC f27Rfc = null;
	        Vector DeptReward_vt  = null;
	        Vector DeptPunish_vt  = null;

	        if ( !deptId.equals("") ) {
	        	f27Rfc       = new F27DeptRewardNPunishRFC();
	            DeptReward_vt  = new Vector();
		        DeptPunish_vt  = new Vector();
	            ret = f27Rfc.getDeptRewardNPunish(deptId, checkYN, userArea);

	            RfcSuccess   = f27Rfc.getReturn().isSuccess();
            	E_MESSAGE = f27Rfc.getReturn().MSGTX;

	            DeptReward_vt = (Vector)ret.get(0);
	            DeptPunish_vt = (Vector)ret.get(1);
	        }

	        //RFC 호출 성공시.
	        if( RfcSuccess ){
	        	req.setAttribute("checkYn", checkYN);
		        req.setAttribute("DeptReward_vt", DeptReward_vt);
		        req.setAttribute("DeptPunish_vt", DeptPunish_vt);

				HashMap<String, Integer> empCnt = new HashMap<String, Integer>();
				int cnt = 0;
				String oldPer = "";

				for (int i = 0; i < DeptReward_vt.size(); i++) {
					if( userArea ){
						F27DeptRewardNPunish01Data data = (F27DeptRewardNPunish01Data) DeptReward_vt.get(i);
						if (oldPer.equals(data.PERNR) || (i == 0)) {
							cnt++;
						} else {
							empCnt.put(oldPer, cnt);
							cnt = 1;
						}
						if (i == DeptReward_vt.size() - 1) {
							empCnt.put(data.PERNR, cnt);
						}
						oldPer = data.PERNR;
					}else{
						F27DeptRewardNPunish01GlobalData data = (F27DeptRewardNPunish01GlobalData) DeptReward_vt.get(i);
						if (oldPer.equals(data.PERNR) || (i == 0)) {
							cnt++;
						} else {
							empCnt.put(oldPer, cnt);
							cnt = 1;
						}
						if (i == DeptReward_vt.size() - 1) {
							empCnt.put(data.PERNR, cnt);
						}
						oldPer = data.PERNR;
					}
				}
				req.setAttribute("empCnt1", empCnt);


				empCnt = new HashMap<String, Integer>();
				cnt = 0;
				oldPer = "";
				for (int i = 0; i < DeptPunish_vt.size(); i++) {
					if( userArea ){
						F27DeptRewardNPunish02Data data = (F27DeptRewardNPunish02Data) DeptPunish_vt.get(i);
						if (oldPer.equals(data.PERNR) || (i == 0)) {
							cnt++;
						} else {
							empCnt.put(oldPer, cnt);
							cnt = 1;
						}
						if (i == DeptPunish_vt.size() - 1) {
							empCnt.put(data.PERNR, cnt);
						}
						oldPer = data.PERNR;
					}else{
						F27DeptRewardNPunish02GlobalData data = (F27DeptRewardNPunish02GlobalData) DeptPunish_vt.get(i);
						if (oldPer.equals(data.PERNR) || (i == 0)) {
							cnt++;
						} else {
							empCnt.put(oldPer, cnt);
							cnt = 1;
						}
						if (i == DeptPunish_vt.size() - 1) {
							empCnt.put(data.PERNR, cnt);
						}
						oldPer = data.PERNR;

					}
				}
				req.setAttribute("empCnt2", empCnt);

		        if( excelDown.equals("ED") ) //엑셀저장일 경우.
		            dest = WebUtil.JspURL+"F/F27DeptRewardNPunishExcel.jsp";
		        else
		        	dest = WebUtil.JspURL+"F/F27DeptRewardNPunish.jsp";

		    //RFC 호출 실패시.
	        }else{
	        	throw new GeneralException(E_MESSAGE);
	        }


	        Logger.debug.println(this, " destributed = " + dest);
	        printJspPage(req, res, dest);
    	} catch(Exception e) {
            throw new GeneralException(e);
        }
    }
}