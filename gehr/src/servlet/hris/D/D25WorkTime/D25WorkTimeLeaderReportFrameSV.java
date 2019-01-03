/********************************************************************************/
/*   System Name  : MSS
/*   1Depth Name  : 조직/인원현황
/*   2Depth Name  : 실근무 실적현황
/*   Program Name : 리더 실근무 관리 레포트
/*   Program ID   : D25WorkTimeLeaderReportFrameSV.java
/*   Description  : 리더 실근무 관리 레포트 frame 호출 Class
/*   Note         : 
/*   Creation     : 2018-05-28 [WorkTime52] 성환희
/*   Update       : 
/********************************************************************************/
package servlet.hris.D.D25WorkTime;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.sns.jdf.GeneralException;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.WebUtil;

import hris.common.WebUserData;
import hris.common.rfc.AuthCheckNTMRFC;

/**
 * D25WorkTimeLeaderReportFrameSV.java
 * 리더 실근무 관리 레포트 frame 호출 Class
 *
 */
public class D25WorkTimeLeaderReportFrameSV extends EHRBaseServlet {
	
	protected void performTask(final HttpServletRequest req, HttpServletResponse res) throws GeneralException {
		WebUserData user = WebUtil.getSessionUser(req);
		
		// 사원근무 구분값
		/*String EMPGUB = "";
        GetEmpGubunRFC empGubunRFC = new GetEmpGubunRFC();
        Vector<EmpGubunData> tpInfo = empGubunRFC.getEmpGubunData(user.empNo);
        if(empGubunRFC.getReturn().isSuccess()) EMPGUB = tpInfo.get(0).getEMPGUB();*/
		
		// AuthCheckNTMRFC
//        String E_AUTH = "";
//        if(EMPGUB.equals("H")) {
        	AuthCheckNTMRFC authCheckNTMRFC = new AuthCheckNTMRFC();
        	String E_AUTH = authCheckNTMRFC.getAuth(user.empNo, "H_MSS");
//        }
        
        req.setAttribute("E_AUTH", E_AUTH);
		
		printJspPage(req, res, WebUtil.JspURL + "D/D25WorkTime/D25WorkTimeLeaderReportFrame.jsp");
	}

}
