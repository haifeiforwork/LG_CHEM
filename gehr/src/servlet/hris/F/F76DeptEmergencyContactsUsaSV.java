/******************************************************************************/
/*   System Name  	: g-HR
/*   1Depth Name		: Organization & Staffing
/*   2Depth Name  	: Personnel Info
/*   Program Name 	: Emergency Contacts
/*   Program ID   		: F76DeptEmergencyContactsUsaSV.java
/*   Description  		: 부서별 비상연락망 조회를 위한 class (USA)
/*   Note         		: 없음
/*   Creation     		: 2010-10-08 jungin
/*    Update       : [CSR ID:3390354] 인사시스템 보안점검 미준수 사항 조치 2017-07-07 eunha
 /******************************************************************************/

package servlet.hris.F;

import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.WebUtil;
import hris.F.rfc.F76DeptEmergencyContactsRFCUsa;
import hris.common.WebUserData;
import org.apache.commons.lang.StringUtils;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.Vector;

/**
 * F76DeptEmergencyContactsUsaSV
 * 부서에 따른 전체 부서원의 비상연락망 정보를 가져오는
 * F76DeptEmergencyContactsRFCUsa 를 호출하는 서블릿 class
 *
 * @author jungin
 * @version 1.0
 */
public class F76DeptEmergencyContactsUsaSV extends EHRBaseServlet {

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
    	try{
    		req.setCharacterEncoding("utf-8");

	        HttpSession session = req.getSession(false);

	        String deptId = WebUtil.nvl(req.getParameter("hdn_deptId")); 				//부서코드.
	        String checkYN = WebUtil.nvl(req.getParameter("chck_yeno"), "N"); 		//하위부서여부.
	        String excelDown = WebUtil.nvl(req.getParameter("hdn_excel"));  			//excelDown.
	        WebUserData user = (WebUserData)session.getAttribute("user");			//세션.

            //초기화면 오픈시 로그인 사용자의 데이터를 보여준다.
            if (deptId.equals("")) {
            	deptId = user.e_objid;
            }

	        String dest = "";
			boolean isSuccess = false;
	        String E_MESSAGE = "부서 정보를 가져오는데 실패하였습니다.";

	        F76DeptEmergencyContactsRFCUsa func = null;
	        Vector DeptEmergencyContacts_vt  = new Vector();

			// [CSR ID:3390354] 인사시스템 보안점검 미준수 사항 조치 start
           	if(!checkBelongGroup( req, res, deptId, "")){
           		return;
           	}
		    // 웹취약성 추가
            if(!checkAuthorization(req, res)) return;
            //[CSR ID:3390354] 인사시스템 보안점검 미준수 사항 조치 end

	        if (StringUtils.isNotBlank(deptId)) {
	        	func = new F76DeptEmergencyContactsRFCUsa();
				DeptEmergencyContacts_vt = func.DeptEmergencyContacts(deptId, checkYN);

				isSuccess = func.getReturn().isSuccess();
	        }

			req.setAttribute("checkYn", checkYN);
			req.setAttribute("DeptEmergencyContacts_vt", DeptEmergencyContacts_vt);

			if (excelDown.equals("ED")) {	//엑셀저장일 경우.
				dest = WebUtil.JspURL+"F/F76DeptEmergencyContactsExcelUsa.jsp";
			} else {
				dest = WebUtil.JspURL+"F/F76DeptEmergencyContactsUsa.jsp";
			}

	        Logger.debug.println(this, "#####	dest = " + dest);

	        printJspPage(req, res, dest);
    	} catch(Exception e) {
            throw new GeneralException(e);
        }
    }

}
