package servlet.hris.D.D09Bond ;

import java.io.* ;
import java.sql.* ;
import java.util.Vector ;
import javax.servlet.* ;
import javax.servlet.http.* ;

import com.sns.jdf.* ;
import com.sns.jdf.db.* ;
import com.sns.jdf.util.* ;
import com.sns.jdf.servlet.* ;

import hris.common.* ;
import hris.D.D09Bond.* ;
import hris.D.D09Bond.rfc.* ;

/**
 * D09BondListSV.java
 *  채권 압류 현황을 조회할 수 있도록 하는 Class
 *
 * @author 한성덕
 * @version 1.0, 2002/02/27
 */
public class D09BondCortSV extends EHRBaseServlet {

    protected void performTask( HttpServletRequest req, HttpServletResponse res ) throws GeneralException {

        try {
            HttpSession session = req.getSession( false ) ;
            WebUserData user    = ( WebUserData ) session.getAttribute( "user" ) ;
            Box         box     = WebUtil.getBox( req ) ;

            String jobid = "" ;
            String dest  = "" ;

            String CRED_NUMB = box.get( "CRED_NUMB" ) ;
            String SEQN_NUMB = box.get( "SEQN_NUMB" ) ;

            Logger.debug.println( this, "empNo : " + user.empNo ) ;

            D09BondCortRFC      func1                   = null ;

            Vector              D09BondCortData_vt      = null ;

            func1              = new D09BondCortRFC() ;

            // BondCort      - ZHRP_RFC_BOND_CORT - 채권 이력 현황
            D09BondCortData_vt      = func1.getBondCort( user.empNo, CRED_NUMB, SEQN_NUMB ) ;

            if( D09BondCortData_vt.size() == 0 ) {
                Logger.debug.println( this, "Data Not Found" ) ;
                String msg = "조회할 내용이 없습니다." ;
                String url = "history.back() ;" ;
                req.setAttribute( "msg", msg ) ;
                req.setAttribute( "url", url ) ;
                dest = WebUtil.JspURL + "common/msg.jsp" ;
            } else {
                Logger.debug.println( this, "D09BondCortData_vt      : " + D09BondCortData_vt.toString() ) ;

                req.setAttribute( "D09BondCortData_vt", D09BondCortData_vt ) ;

                dest = WebUtil.JspURL + "D/D09Bond/D09BondCort.jsp" ;
            }
            Logger.debug.println( this, " destributed = " + dest ) ;

            printJspPage( req, res, dest ) ;

        } catch( Exception e ) {
            throw new GeneralException( e ) ;
        } finally {
        }

    }

}
