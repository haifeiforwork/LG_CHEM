/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : 해외경험                                                    */
/*   Program Name : 해외경험                                                    */
/*   Program ID   : C09GetTripList_m                                          */
/*   Description  : 사원의 교육 이력 사항을 조회할 수 있도록 하는 Class         */
/*   Note         : 없음                                                        */
/*   Creation     : 2016-09-26  정진만                                          */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/


package servlet.hris.C;

import com.sns.jdf.GeneralException;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.WebUtil;
import hris.C.C09GetTripListData;
import hris.C.rfc.C09GetTripListRFC;
import hris.common.WebUserData;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Vector;

public class C09GetTripList_m extends EHRBaseServlet {

    protected void performTask( HttpServletRequest req, HttpServletResponse res ) throws GeneralException {

        try {
            WebUserData user = WebUtil.getSessionMSSUser(req);

            Box box = WebUtil.getBox(req);

            //@웹취약성 추가
            if(!checkAuthorization(req, res)) return;


            C09GetTripListRFC func1 = new C09GetTripListRFC();
            Vector<C09GetTripListData> resultList = func1.getTripList(user.empNo);

            req.setAttribute("resultList", resultList);

            printJspPage(req, res, WebUtil.JspURL + "C/C09GetTripList_m.jsp");

        } catch (Exception e) {
            throw new GeneralException(e);
        }

    }
}
