package servlet.hris.E.Global.E18Hospital ;

import java.util.Vector ;
import javax.servlet.http.* ;

import com.sns.jdf.* ;
import com.sns.jdf.util.* ;
import com.sns.jdf.servlet.* ;

import hris.common.* ;

/**
 * E18BenefitFrameSV.java
 *  ����� �Ƿ�� ������ ��ȸ�� �� �ֵ��� �ϴ� Class
 *
 * @author �Ѽ���
 * @version 1.0, 2002/01/03
 * 				 2007/10/05 update by huang peng xiao
 */
public class E18BenefitFrameSV extends EHRBaseServlet {

    protected void performTask( HttpServletRequest req, HttpServletResponse res ) throws GeneralException {

        try {
            HttpSession session = req.getSession( false ) ;
            WebUserData user = WebUtil.getSessionUser(req);
            Box         box     = WebUtil.getBox( req ) ;

            String dest  =  WebUtil.JspURL + "E/E18Hospital/E18BenefitFrame_Global.jsp" ;

            Logger.debug.println( this, " destributed = " + dest ) ;

            printJspPage( req, res, dest ) ;

        } catch( Exception e ) {
            throw new GeneralException( e ) ;
        }

    }

}
