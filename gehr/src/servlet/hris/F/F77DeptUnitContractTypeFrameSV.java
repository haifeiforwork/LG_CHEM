/******************************************************************************
*   System Name  	: g-HR
*   1Depth Name		: Organization & Staffing
*   2Depth Name  	: Headcount
*   Program Name 	: Org.Unit/Contract Type
*   Program ID   		: F77DeptUnitContractTypeFrameSV.java
*   Description  		: 부서별 계약 유형 조회를 위한 class (USA)
*   Note         		: 없음
*   Creation     		:
******************************************************************************/

package servlet.hris.F;

import hris.A.A01SelfDetailData;
import hris.A.rfc.A01SelfDetailRFC;
import hris.B.rfc.B01ValuateDetailCheckRFC;
import hris.common.WebUserData;

import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.common.Utils;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.WebUtil;

/**
 * F77DeptUnitContractTypeFrameSV
 * 부서에 따른 계약 유형 정보를 가져오는 F77DeptUnitContractTypeFrame을 호출하는 서블릿 class
 * @author
 * @version 1.0
 */
public class F77DeptUnitContractTypeFrameSV extends EHRBaseServlet {

	protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {
        WebUserData user = WebUtil.getSessionUser(req);

        if(process(req, res, user, "E"))
            printJspPage(req, res, WebUtil.JspURL+"F/F77DeptUnitContractTypeFrame.jsp");
	}

    /**
     * ESS, MSS 공통 로직 정의
     * user_m 에 해당 하는 데이타를 리턴 한다.
     * @param req
     * @param res
     * @param user_m   조회 대상자 정보
     * @param pageType "E" ESS, "M" MSS tab 권한 체크 용
     */
	protected boolean process(HttpServletRequest req, HttpServletResponse res, WebUserData user_m, String pageType) throws GeneralException {
        try{

            WebUserData user = WebUtil.getSessionUser(req);

            Box box = WebUtil.getBox(req);
            String jobid = box.get("jobid", "HEAD");

            req.setAttribute("jobid", jobid);

            A01SelfDetailRFC selffunc = new A01SelfDetailRFC();
            Logger.debug("---- user_m : " + user_m);
            Vector<A01SelfDetailData> a01SelfDetailData_vt = selffunc.getPersInfo(user_m.empNo, user_m.area.getMolga(), "");
            req.setAttribute("resultData", Utils.indexOf(a01SelfDetailData_vt, 0));

            //권한체크
            B01ValuateDetailCheckRFC checkRFC =  new B01ValuateDetailCheckRFC();
            req.setAttribute("check_A01", checkRFC.getValuateDetailCheck(user.empNo, user_m.empNo, "A01", pageType, user_m.area));
            req.setAttribute("check_A03", checkRFC.getValuateDetailCheck(user.empNo, user_m.empNo, "A03", pageType, user_m.area));

            req.setAttribute("pageType", pageType);
            req.setAttribute("user", user_m);

            return true;
        } catch(Exception e) {
            Logger.error(e);
            throw new GeneralException(e);
        }
    }
}
