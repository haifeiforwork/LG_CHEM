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
public class D09BondListSV extends EHRBaseServlet {

    protected void performTask( HttpServletRequest req, HttpServletResponse res ) throws GeneralException {

        try {
            HttpSession session = req.getSession( false ) ;
            WebUserData user    = ( WebUserData ) session.getAttribute( "user" ) ;
            Box         box     = WebUtil.getBox( req ) ;

            String jobid = "" ;
            String dest  = "" ;
            String BEGDA = "19000101" ;
            String ENDDA = "21000101" ;

            double CRED_TOTA     = 0.0 ;  // 가압류총액
            double G_SUM         = 0.0 ;  // 공제총액
            double dedu_rest     = 0.0 ;  // 미공제잔액
            double GIVE_TOTA     = 0.0 ;  // 지급총액
            double GIVE_TOTA_RES = 0.0 ;  // 지급총액
            double G_DPOT_REST   = 0.0 ;  // 미배당공탁액
            double coll_rest     = 0.0 ;  // 예수금잔액

            double REST_TOTA     = 0.0 ;  // 가압류잔액 합계
            double DPOT_TOTA     = 0.0 ;  // 공탁수수료 합계

            D09BondListRFC      func1                   = null ;
            D09BondDeductionRFC func2                   = null ;

            Vector              D09BondListData_vt      = null ;
            Vector              D09BondDeductionData_vt = null ;

            func1              = new D09BondListRFC() ;
            func2              = new D09BondDeductionRFC() ;

//          BondList      - ZHRP_RFC_BOND_PRESENTSTATE - 채권 압류 현황
            D09BondListData_vt      = func1.getBondList( user.empNo ) ;
//          G_DPOT_REST   - ZHRP_RFC_BOND_PRESENTSTATE - 미배당공탁액
            G_DPOT_REST             = Double.parseDouble( func1.getG_DPOT_REST( user.empNo ) ) ;
//          BondDeduction - ZHRP_RFC_BOND_DEDUCTION    - 채권 압류 공제 현황
            D09BondDeductionData_vt = func2.getBondDeduction( user.empNo, BEGDA, ENDDA ) ;

/*            if( D09BondListData_vt.size() == 0 ) {
                Logger.debug.println(this, "Data Not Found");
                String msg = "msg004";
                //String url = "history.back();";
                req.setAttribute("msg", msg);
                //req.setAttribute("url", url);
                dest = WebUtil.JspURL+"common/caution.jsp";
            } else {   */
            
            for( int i = 0 ; i < D09BondListData_vt.size() ; i++ ) {
                D09BondListData data = ( D09BondListData ) D09BondListData_vt.get( i ) ;
                if( data.ENDDA.equals( "0000-00-00" )||data.ENDDA.equals( "" ) ) {
                    CRED_TOTA += Double.parseDouble( data.CRED_AMNT ) ;  // 가압류총액
                    GIVE_TOTA += Double.parseDouble( data.GIVE_AMNT ) ;  // 지급총액
                    
                    Logger.debug.println(this, "############## GIVE_TOTA : " +  GIVE_TOTA);
                    
                    REST_TOTA += Double.parseDouble( data.REST_AMNT ) ;  // 가압류잔액 합계
                    DPOT_TOTA += Double.parseDouble( data.DPOT_CHRG ) ;  // 공탁수수료 합계
                } else {
                    GIVE_TOTA_RES += Double.parseDouble( data.GIVE_AMNT ) ;  // 해지된 지급총액
                }
            }

//          공제총액을 구하기 위해서
            for( int i = 0 ; i < D09BondDeductionData_vt.size() ; i++ ) {
                D09BondDeductionData data = ( D09BondDeductionData ) D09BondDeductionData_vt.get( i ) ;
                G_SUM     += Double.parseDouble( data.G_SUM     ) ;  // 공제총액
                Logger.debug.println(this, "############## G_SUM : " +  G_SUM);
            }
//          공제총액에서 해지된 지급총액을 제외한다.
            G_SUM = G_SUM - GIVE_TOTA_RES;
//          미공제잔액 = ( 가압류총액 - 공제총액 ) + 공탁수수료
            dedu_rest = ( CRED_TOTA - G_SUM ) + DPOT_TOTA ;
//          예수금잔액 = 공제총액 - ( 지급총액 + 미배당공탁액 + 공탁수수료 )
            coll_rest = G_SUM - ( GIVE_TOTA + G_DPOT_REST + DPOT_TOTA ) ;

            Logger.debug.println( this, "D09BondListData_vt      : " + D09BondListData_vt.toString() ) ;
            Logger.debug.println( this, "D09BondDeductionData_vt : " + D09BondDeductionData_vt.toString() ) ;

            Logger.debug.println( this, "CRED_TOTA   : " + Double.toString( CRED_TOTA   ) ) ;  // 가압류총액
            Logger.debug.println( this, "G_SUM       : " + Double.toString( G_SUM       ) ) ;  // 공제총액
            Logger.debug.println( this, "dedu_rest   : " + Double.toString( dedu_rest   ) ) ;  // 미공제잔액
            Logger.debug.println( this, "GIVE_TOTA   : " + Double.toString( GIVE_TOTA   ) ) ;  // 지급총액
            Logger.debug.println( this, "G_DPOT_REST : " + Double.toString( G_DPOT_REST ) ) ;  // 미배당공탁액
            Logger.debug.println( this, "coll_rest   : " + Double.toString( coll_rest   ) ) ;  // 예수금잔액
            Logger.debug.println( this, "REST_TOTA   : " + Double.toString( REST_TOTA   ) ) ;  // 가압류잔액 합계

            req.setAttribute( "D09BondListData_vt", D09BondListData_vt ) ;

            req.setAttribute( "CRED_TOTA",   Double.toString( CRED_TOTA   ) ) ;  // 가압류총액
            req.setAttribute( "G_SUM",       Double.toString( G_SUM       ) ) ;  // 공제총액
            req.setAttribute( "dedu_rest",   Double.toString( dedu_rest   ) ) ;  // 미공제잔액
            req.setAttribute( "GIVE_TOTA",   Double.toString( GIVE_TOTA   ) ) ;  // 지급총액
            req.setAttribute( "G_DPOT_REST", Double.toString( G_DPOT_REST ) ) ;  // 미배당공탁액
            req.setAttribute( "coll_rest",   Double.toString( coll_rest   ) ) ;  // 예수금잔액
            req.setAttribute( "REST_TOTA",   Double.toString( REST_TOTA   ) ) ;  // 가압류잔액 합계

            dest = WebUtil.JspURL + "D/D09Bond/D09BondList.jsp" ;
//            }
            Logger.debug.println( this, " destributed = " + dest ) ;

            printJspPage( req, res, dest ) ;
        } catch( Exception e ) {
            throw new GeneralException( e ) ;
        } finally {
        }
    }
}
