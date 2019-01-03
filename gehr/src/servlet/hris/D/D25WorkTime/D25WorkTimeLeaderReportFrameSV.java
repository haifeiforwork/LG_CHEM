/********************************************************************************/
/*   System Name  : MSS
/*   1Depth Name  : ����/�ο���Ȳ
/*   2Depth Name  : �Ǳٹ� ������Ȳ
/*   Program Name : ���� �Ǳٹ� ���� ����Ʈ
/*   Program ID   : D25WorkTimeLeaderReportFrameSV.java
/*   Description  : ���� �Ǳٹ� ���� ����Ʈ frame ȣ�� Class
/*   Note         : 
/*   Creation     : 2018-05-28 [WorkTime52] ��ȯ��
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
 * ���� �Ǳٹ� ���� ����Ʈ frame ȣ�� Class
 *
 */
public class D25WorkTimeLeaderReportFrameSV extends EHRBaseServlet {
	
	protected void performTask(final HttpServletRequest req, HttpServletResponse res) throws GeneralException {
		WebUserData user = WebUtil.getSessionUser(req);
		
		// ����ٹ� ���а�
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
