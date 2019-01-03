package servlet.hris.E.E09House ;

import java.util.Vector ;
import javax.servlet.* ;
import javax.servlet.http.* ;

import com.sns.jdf.* ;
import com.sns.jdf.util.* ;
import com.sns.jdf.servlet.* ;

import hris.common.* ;

/**
 * E18HospitalFrameSV.java
 *  ����� �Ƿ�� ������ ��ȸ�� �� �ֵ��� �ϴ� Class
 *
 * @author �Ѽ���
 * @version 1.0, 2002/01/03
 * 				 2007/10/05 update by huang peng xiao
 */
public class E09HouseFrameSV extends EHRBaseServlet {

    protected void performTask( HttpServletRequest req, HttpServletResponse res ) throws GeneralException {

        try {
            HttpSession session = req.getSession( false ) ;
            WebUserData user    = ( WebUserData ) session.getAttribute( "user" ) ;
            Box         box     = WebUtil.getBox( req ) ;

	        String RequestPageName = box.get("RequestPageName");
	        req.setAttribute("RequestPageName", RequestPageName);
            String dest  =  WebUtil.JspURL + "E/E09House/E09HouseFrame.jsp" ;

            Logger.debug.println( this, " destributed = " + dest ) ;

            printJspPage( req, res, dest ) ;

        } catch( Exception e ) {
            throw new GeneralException( e ) ;
        } finally {
        }

    }

}
