/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : 채권가압류                                                  */
/*   Program Name : 채권가압류                                                  */
/*   Program ID   : D09BondDeductionSV_m                                        */
/*   Description  : 채권 압류 공제 현황을 조회할 수 있도록 하는 Class           */
/*   Note         :                                                             */
/*   Creation     : 2002-02-27  한성덕                                          */
/*   Update       : 2005-01-21  윤정현                                          */
/*                                                                              */
/********************************************************************************/

package servlet.hris.D.D09Bond ;

import java.util.Vector ;
import javax.servlet.http.* ;

import com.sns.jdf.* ;
import com.sns.jdf.util.* ;
import com.sns.jdf.servlet.* ;

import hris.common.* ;
import hris.D.D09Bond.D09BondDeductionData;
import hris.D.D09Bond.rfc.* ;


public class D09BondDeductionSV_m extends EHRBaseServlet {

    protected void performTask( HttpServletRequest req, HttpServletResponse res ) throws GeneralException {

        try {
            HttpSession session = req.getSession( false ) ;
            WebUserData user_m  = ( WebUserData ) session.getAttribute( "user_m" ) ;
            Box         box     = WebUtil.getBox( req ) ;

            String jobid = "" ;
            String dest  = "" ;
            String BEGDA = "19000101" ;
            String ENDDA = "21000101" ;

            WebUserData user = WebUtil.getSessionUser(req);
//          @웹취약성 추가
            if ( user.e_authorization.equals("E")||isBlocklist(user) ) {
                Logger.debug.println(this, "E Authorization!!");
                String msg = "msg015";
                req.setAttribute("msg", msg);
                dest = WebUtil.JspURL+"common/caution.jsp";
                printJspPage(req, res, dest);
                return;
            }

            double TOTA1    = 0.0 ;  // 정규급여
            double TOTA2    = 0.0 ;  // 정규상여
            double TOTA4    = 0.0 ;  // 비정규상여
            double TOTA3    = 0.0 ;  // 퇴직금
            double TOTA_SUM = 0.0 ;  // 공제액계

            Logger.debug.println( this, "empNo : " + user_m.empNo ) ;

            D09BondDeductionRFC func1                   = new D09BondDeductionRFC() ;
            Vector              D09BondDeductionData_vt = new Vector() ;

            if ( user_m != null ) {
                // BondDeduction - ZHRP_RFC_BOND_DEDUCTION - 채권 압류 공제 현황
                D09BondDeductionData_vt = func1.getBondDeduction( user_m.empNo, BEGDA, ENDDA ) ;
            } // if ( user_m != null ) end

            if( D09BondDeductionData_vt.size() == 0 ) {
                Logger.debug.println( this, "Data Not Found" ) ;
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

                dest = WebUtil.JspURL + "D/D09Bond/D09BondDeduction_m.jsp" ;
            }
            Logger.debug.println( this, " destributed = " + dest ) ;

            printJspPage( req, res, dest ) ;

        } catch( Exception e ) {
            throw new GeneralException( e ) ;
        } finally {
        }

    }

}
