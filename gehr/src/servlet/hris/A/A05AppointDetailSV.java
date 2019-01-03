package	servlet.hris.A ;

import com.common.constant.Area;
import com.sns.jdf.GeneralException;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.WebUtil;
import hris.A.rfc.A05AppointDetail1RFC;
import hris.A.rfc.A05AppointDetail2RFC;
import hris.common.WebUserData;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * A05AppointDetailSV.java
 * 발령사항 내역과 승급사항 내역을 조회할 수 있도록 하는 Class
 *
 * @author 한성덕
 * @version 1.0, 2001/12/17
 * @author rdcamel [CSR ID:3687969]
 * @version    2018-05-25  rdcamel //[CSR ID:3687969] 인사기록부상 해외법인명 한글병기 요청의 건
 */
public class A05AppointDetailSV extends EHRBaseServlet {
    protected void performTask( HttpServletRequest req, HttpServletResponse res ) throws GeneralException {

        if(process(req, res, WebUtil.getSessionUser(req), "E", null))
            printJspPage(req, res, WebUtil.JspURL + "A/A05AppointDetail.jsp") ;
    }

    public boolean process(HttpServletRequest req, HttpServletResponse res, WebUserData user_m, String pageType, String I_CFORG) throws GeneralException {
        try {
            A05AppointDetail1RFC func1 = new A05AppointDetail1RFC() ;
            A05AppointDetail2RFC func2 = new A05AppointDetail2RFC() ;

            String I_CFORM = (String) req.getAttribute("I_CFORM");

            //[CSR ID:3687969]
            //req.setAttribute("appointList", func1.getAppointDetail1(user_m.empNo, I_CFORM, I_CFORG));
            req.setAttribute("appointList", func1.getAppointDetailLong1(user_m.empNo, I_CFORM, I_CFORG));

            if(user_m.area == Area.KR) {
                req.setAttribute("promotionList", func2.getAppointDetail2(user_m.empNo, I_CFORM));
            }

            req.setAttribute("pageType", pageType);
            req.setAttribute("user", user_m);

            return true;

        } catch( Exception e ) {
            throw new GeneralException( e ) ;
        }
    }
}

