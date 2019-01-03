package servlet.hris.E.Global.E24Language;

import hris.A.rfc.A03AccountDetailRFC;
import hris.E.Global.E24Language.rfc.E24LanguageRFC;
import hris.common.PersonData;
import hris.common.WebUserData;
import hris.common.rfc.PersonInfoRFC;

import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.WebUtil;

public class E24LanguageListSV extends EHRBaseServlet {

	@Override
	protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {
		// TODO Auto-generated method stub
        try{

            HttpSession session = req.getSession(false);
            WebUserData user    = (WebUserData)session.getAttribute("user");
            Box box = WebUtil.getBox(req);

            String dest  = "";
            String PERNR;

            PERNR = box.get("PERNR", user.empNo);
            /*if (PERNR == null || PERNR.equals("")) {
                PERNR = user.empNo;
            } // end if */

            // 대리 신청 추가
            //PhoneNumRFC  numfunc = new PhoneNumRFC();
            //PhoneNumData phonenumdata;
            //phonenumdata = (PhoneNumData)numfunc.getPhoneNum(PERNR);

			PersonInfoRFC numfunc = new PersonInfoRFC();
            PersonData phonenumdata;
            phonenumdata    =   (PersonData)numfunc.getPersonInfo(PERNR);

            E24LanguageRFC func1 = new E24LanguageRFC();
            Vector e24LanguageData_vt = func1.getLanguageList(PERNR);  // 급여계좌

            Logger.debug.println(this, "급여계좌 : "+ e24LanguageData_vt.toString());

            req.setAttribute("PersonData" , phonenumdata );
            req.setAttribute("PERNR" , PERNR );
            req.setAttribute("e24LanguageData_vt", e24LanguageData_vt);

            dest = WebUtil.JspURL+"E/E24Language/E24LanguageList.jsp";

            Logger.debug.println(this, " destributed = " + dest);
            printJspPage(req, res, dest);

        } catch(Exception e) {
            throw new GeneralException(e);
        }
	}

}
