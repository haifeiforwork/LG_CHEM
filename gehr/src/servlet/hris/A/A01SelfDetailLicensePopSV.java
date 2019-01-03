/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : 자격수당 조회                                                */
/*   Program Name : 자격수당 조회                                                */
/*   Program ID   : A01SelfDetailLicensePopSV                                           */
/*   Description  : 자격수당 조회하는 class                              */
/*   Note         :                                                             */
/*   Creation     : 2006-09-19  정진만                                          */
/*                                                                              */
/********************************************************************************/

package servlet.hris.A;

import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.WebUtil;
import hris.A.A08LicenseDetailAlloData;
import hris.A.rfc.A08LicenseDetailAlloRFC;
import hris.common.WebUserData;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Vector;

public class A01SelfDetailLicensePopSV extends EHRBaseServlet {

	protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {
        //Connection con = null;

        try{
            if(!checkAuthorization(req, res)) return;

            WebUserData user_m = WebUtil.getSessionMSSUser(req);
            WebUserData user = WebUtil.getSessionUser(req);

            Box box = WebUtil.getBox(req, user_m);

            String licn_code = box.get("licn_code");
            //법정선임 Detail 리스트
            A08LicenseDetailAlloRFC func2                   = new A08LicenseDetailAlloRFC();
            Vector                  A08LicenseDetailAllo_vt = new Vector();
            Vector                  temp_vt                 = func2.getLicenseDetailAllo(user_m.empNo);

            for( int i = 0 ; i < temp_vt.size() ; i++ ) {
                A08LicenseDetailAlloData data = (A08LicenseDetailAlloData)temp_vt.get(i);
                if( data.LICN_CODE.equals(licn_code) ) {
                    A08LicenseDetailAllo_vt.addElement(data);
                }
            }

            Logger.debug.println(this, "A08LicenseDetailAllo_vt : "+ A08LicenseDetailAllo_vt.toString());

            req.setAttribute("A08LicenseDetailAllo_vt", A08LicenseDetailAllo_vt);

            printJspPage(req, res, WebUtil.JspURL+"A/A08LicensePop_m.jsp");

        } catch(Exception e) {
            throw new GeneralException(e);
        } finally {
        }
	}
}