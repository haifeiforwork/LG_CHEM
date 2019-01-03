package servlet.hris.N.mssperson;

import com.sns.jdf.GeneralException;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;
import hris.D.D05Mpay.rfc.D05ScreenControlRFC;
import hris.N.AES.AESgenerUtil;
import hris.N.WebAccessLog;
import hris.common.PersonData;
import hris.common.WebUserData;
import hris.common.rfc.PersonInfoRFC;
import org.apache.commons.lang.StringUtils;
import servlet.hris.N.essperson.A01SelfDetailNeoSV;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class A01SelfDetailNeoSV_m  extends A01SelfDetailNeoSV {

	
	private static final long serialVersionUID = 1L;

	protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {


        WebUserData user = WebUtil.getSessionUser(req);

        req.setAttribute("pageType", "M");

        Box box = WebUtil.getBox(req);

        //1. 암호화 -> 복호화 작업
        String prsn = WebUtil.getSessionMSSUser(req).empNo;
       
        try {
        	if(!WebUtil.nvl(box.get("viewEmpno")).equals("")){//[CSR ID:3687969] null 일때, 오류나서 수정(rdcamel)
				prsn = AESgenerUtil.decryptAES(box.get("viewEmpno"), req);
				
				  /* M 권한 확인 */
				if(!checkAuthorization(req, res)) return;
				
				WebUserData user_m = WebUtil.getSessionMSSUser(req);
				
				if(StringUtils.equals(user.empNo, user_m.empNo) && "true".equals(box.get("first")) ) {
				    printJspPage(req, res, WebUtil.JspURL+"N/mssperson/A01SelfDetailNeo_m.jsp");
				    return;
				}
				
				/* 대상 권한 확인 */
				if(checkBelongPerson(req, res, prsn, box.get("I_RETIR"))) {
				
				/* MSS 사용자 정보 확인 및 세션 생성 */
				    if(!setUserSession(prsn, req)) {
				        moveMsgPage(req, res, g.getMessage("MSG.COMMON.0083"),  "history.back();");
				        return;
				    }
				} else return;
        	}
        } catch(Exception e) {

        }

        req.setAttribute("O_CHECK_FLAG", ( new D05ScreenControlRFC() ).getScreenCheckYn(prsn));

        /*******************
         * 웹로그 메뉴 코드명
         *******************/
        String sMenuCode = StringUtils.defaultString(req.getParameter("sMenuCode"), "MSS_PA_LIST_INFO");

        if(!user.user_group.equals("01") && !user.user_group.equals("02") && !user.user_group.equals("03")){
            (new WebAccessLog()).setAccessLog(sMenuCode, user.empNo, prsn, user.remoteIP);
        }

        if(process(req, res, WebUtil.getSessionMSSUser(req), "M"))
            printJspPage(req, res, WebUtil.JspURL+"N/mssperson/A01SelfDetailNeo_m.jsp");

	}
	
	public boolean setUserSession(String empNo, HttpServletRequest req) throws GeneralException{
		
		WebUserData user_m     = new WebUserData();
	    
	    PersonInfoRFC personInfoRFC        = new PersonInfoRFC();
        PersonData personData = personInfoRFC.getPersonInfo(empNo, "X");
        if(!personInfoRFC.getReturn().isSuccess()) {
            return false;
        }

	    user_m.login_stat   = "Y";
	    user_m.companyCode  = personData.E_BUKRS ;

	    user_m.empNo        = empNo ;

        /* MSS 세션 정보 set */
        personInfoRFC.setSessionUserData(personData, user_m);
        user_m.e_mss = "X";

	    DataUtil.fixNull(user_m);

	    req.getSession().setAttribute("user_m",user_m);

        return true;
	}
}
