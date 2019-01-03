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
 * D09BondDeductionSV.java
 *  채권 압류 공제 현황을 조회할 수 있도록 하는 Class
 *
 * @author 한성덕
 * @version 1.0, 2002/01/25
 */
public class D09BondDeductionSV extends EHRBaseServlet {

    protected void performTask( HttpServletRequest req, HttpServletResponse res ) throws GeneralException {

        try {
            HttpSession session = req.getSession( false ) ;
            WebUserData user    = ( WebUserData ) session.getAttribute( "user" ) ;
            Box         box     = WebUtil.getBox( req ) ;

            String jobid = "" ;
            String dest  = "" ;
            String BEGDA = "19000101" ;
            String ENDDA = "21000101" ;

            double TOTA1    = 0.0 ;  // 정규급여
            double TOTA2    = 0.0 ;  // 정규상여
            double TOTA4    = 0.0 ;  // 비정규상여
            double TOTA3    = 0.0 ;  // 퇴직금
            double TOTA_SUM = 0.0 ;  // 공제액계

            Logger.debug.println( this, "empNo : " + user.empNo ) ;

            D09BondDeductionRFC func1                   = null ;
            Vector              D09BondDeductionData_vt = null ;

            func1                   = new D09BondDeductionRFC() ;
            // BondDeduction - ZHRP_RFC_BOND_DEDUCTION - 채권 압류 공제 현황
            D09BondDeductionData_vt = func1.getBondDeduction( user.empNo, BEGDA, ENDDA ) ;

            if( D09BondDeductionData_vt.size() == 0 ) {
                Logger.debug.println( this, "Data Not Found" ) ;
                //String msg = "조회할 내용이 없습니다." ;
                String msg = g.getMessage("MSG.D.D15.0012");
                String url = "history.back() ;" ;
                req.setAttribute( "msg", msg ) ;
                req.setAttribute( "url", url ) ;
                dest = WebUtil.JspURL + "common/msg.jsp" ;
            } else {

                for( int i = 0 ; i < D09BondDeductionData_vt.size() ; i++ ) {
                    D09BondDeductionData data = ( D09BondDeductionData ) D09BondDeductionData_vt.get( i ) ;

                    TOTA1    += Double.parseDouble( data.BETRG01 ) ;  // 정규급여
                    TOTA2    += Double.parseDouble( data.BETRG02 ) ;  // 정규상여
                    TOTA4    += Double.parseDouble( data.BETRG04 ) ;  // 비정규상여
                    TOTA3    += Double.parseDouble( data.BETRG03 ) ;  // 퇴직금
                    TOTA_SUM += Double.parseDouble( data.G_SUM   ) ;  // 공제액계
                }

                Logger.debug.println( this, "D09BondDeductionData_vt : " + D09BondDeductionData_vt.toString() ) ;

                req.setAttribute( "D09BondDeductionData_vt", D09BondDeductionData_vt ) ;
                req.setAttribute( "TOTA1",                   Double.toString( TOTA1 ) ) ;     // 정규급여
                req.setAttribute( "TOTA2",                   Double.toString( TOTA2 ) ) ;     // 정규상여
                req.setAttribute( "TOTA4",                   Double.toString( TOTA4 ) ) ;     // 비정규상여
                req.setAttribute( "TOTA3",                   Double.toString( TOTA3 ) ) ;     // 퇴직금
                req.setAttribute( "TOTA_SUM",                Double.toString( TOTA_SUM ) ) ;  // 공제액계

                dest = WebUtil.JspURL + "D/D09Bond/D09BondDeduction.jsp" ;
            }
            Logger.debug.println( this, " destributed = " + dest ) ;

            printJspPage( req, res, dest ) ;

        } catch( Exception e ) {
            throw new GeneralException( e ) ;
        } finally {
        }

    }

}
