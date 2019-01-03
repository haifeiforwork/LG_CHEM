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
 * D09BondDepositSV.java
 *  채권 압류 공탁 현황을 조회할 수 있도록 하는 Class
 *
 * @author 한성덕
 * @version 1.0, 2002/01/25
 */
public class D09BondDepositSV extends EHRBaseServlet {

    protected void performTask( HttpServletRequest req, HttpServletResponse res ) throws GeneralException {

        try {
            HttpSession session = req.getSession( false ) ;
            WebUserData user    = ( WebUserData ) session.getAttribute( "user" ) ;
            Box         box     = WebUtil.getBox( req ) ;

            String jobid = "" ;
            String dest  = "" ;

            double DPOT_AMNT = 0.0 ;  // 실공탁액
            double DPOT_CHRG = 0.0 ;  // 공탁수수료
            double GIVE_AMNT = 0.0 ;  // 배당정리액(수수료포함)
            double DPOT_TOTA = 0.0 ;  // 미배당공탁액계

            Logger.debug.println( this, "empNo : " + user.empNo ) ;

            D09BondDepositRFC func1                 = null ;
            Vector            D09BondDepositData_vt = null ;

            func1                 = new D09BondDepositRFC() ;
            // BondDeposit - ZHRP_RFC_BOND_DEPOSITION - 채권 압류 공탁 현황
            D09BondDepositData_vt = func1.getBondDeposit( user.empNo ) ;

            if( D09BondDepositData_vt.size() == 0 ) {
                Logger.debug.println( this, "Data Not Found" ) ;
                //String msg = "조회할 내용이 없습니다." ;
                String msg = g.getMessage("MSG.D.D15.0012");
                String url = "history.back() ;" ;
                req.setAttribute( "msg", msg ) ;
                req.setAttribute( "url", url ) ;
                dest = WebUtil.JspURL + "common/msg.jsp" ;
            } else {

                for( int i = 0 ; i < D09BondDepositData_vt.size() ; i++ ) {
                    D09BondDepositData data = ( D09BondDepositData ) D09BondDepositData_vt.get( i ) ;

                    DPOT_AMNT += Double.parseDouble( data.DPOT_AMNT ) ;  // 실공탁액
                    DPOT_CHRG += Double.parseDouble( data.DPOT_CHRG ) ;  // 공탁수수료
                    GIVE_AMNT += Double.parseDouble( data.GIVE_AMNT ) ;  // 배당정리액(수수료포함)
                }

                // 미배당공탁액계 = 실공탁액 + 공탁수수료 - 배당정리액(수수료포함)
                DPOT_TOTA = DPOT_AMNT + DPOT_CHRG - GIVE_AMNT ;

                Logger.debug.println( this, "D09BondDepositData_vt : " + D09BondDepositData_vt.toString() ) ;
                Logger.debug.println( this, "DPOT_TOTA             : " + Double.toString( DPOT_TOTA ) ) ;

                req.setAttribute( "D09BondDepositData_vt", D09BondDepositData_vt ) ;
                req.setAttribute( "DPOT_TOTA",             Double.toString( DPOT_TOTA ) ) ;  // 실공탁액

                dest = WebUtil.JspURL + "D/D09Bond/D09BondDeposit.jsp" ;
            }
            Logger.debug.println( this, " destributed = " + dest ) ;

            printJspPage( req, res, dest ) ;

        } catch( Exception e ) {
            throw new GeneralException( e ) ;
        } finally {
        }

    }

}
