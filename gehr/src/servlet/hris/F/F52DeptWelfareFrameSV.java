package servlet.hris.F ;

import java.util.Vector ;
import javax.servlet.http.* ;

import com.sns.jdf.* ;
import com.sns.jdf.util.* ;
import com.sns.jdf.servlet.* ;

import hris.common.* ;

/**
 * E18BenefitFrameSV.java
 *  사원의 의료비 내역을 조회할 수 있도록 하는 Class
 *
 * @author 한성덕
 * @version 1.0, 2002/01/03
 * 				 2007/10/05 update by huang peng xiao
 */
public class F52DeptWelfareFrameSV extends EHRBaseServlet {

    protected void performTask( HttpServletRequest req, HttpServletResponse res ) throws GeneralException {

        try {
            HttpSession session = req.getSession( false ) ;
            WebUserData user = WebUtil.getSessionUser(req);
            Box         box     = WebUtil.getBox( req ) ;

            String dest  =  WebUtil.JspURL + "F/F52DeptWelfareFrame.jsp" ;

            Logger.debug.println( this, " destributed = " + dest ) ;

            printJspPage( req, res, dest ) ;

        } catch( Exception e ) {
            throw new GeneralException( e ) ;
        } finally {
        }

    }

}
