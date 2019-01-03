package servlet.hris.E.E18Hospital ;

import javax.servlet.http.* ;

import com.sns.jdf.* ;
import com.sns.jdf.util.* ;
import com.sns.jdf.servlet.* ;

import hris.common.* ;

/**
 * E18HospitalFrameSV.java
 *  사원의 의료비 내역을 조회할 수 있도록 하는 Class
 *
 * @author 한성덕
 * @version 1.0, 2002/01/03
 * 				 2007/10/05 update by huang peng xiao
 */
public class E18HospitalFrameSV extends EHRBaseServlet {

    protected void performTask( HttpServletRequest req, HttpServletResponse res ) throws GeneralException {

        try {
            HttpSession session = req.getSession( false ) ;
            WebUserData user    = ( WebUserData ) session.getAttribute( "user" ) ;
            Box         box     = WebUtil.getBox( req ) ;

	        String RequestPageName = box.get("RequestPageName"); // 조회를 위해 추가 -ksc 2016.10.4
	        req.setAttribute("RequestPageName", RequestPageName);
	        
            String dest  =  WebUtil.JspURL + "E/E18Hospital/E18HospitalFrame.jsp" ;

            Logger.debug.println( this, " destributed = " + dest ) ;

            printJspPage( req, res, dest ) ;

        } catch( Exception e ) {
            throw new GeneralException( e ) ;
        } finally {
        }

    }

}
