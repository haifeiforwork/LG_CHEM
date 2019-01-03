/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : 채권가압류                                                  */
/*   Program Name : 채권가압류                                                  */
/*   Program ID   : D09BondDepositSV_m                                          */
/*   Description  : 채권 압류 공탁 현황을 조회할 수 있도록 하는 Class           */
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
import hris.D.D09Bond.D09BondDepositData;
import hris.D.D09Bond.rfc.* ;


public class D09BondDepositSV_m extends EHRBaseServlet {

    protected void performTask( HttpServletRequest req, HttpServletResponse res ) throws GeneralException {

        try {
            HttpSession session = req.getSession( false ) ;
            WebUserData user_m  = ( WebUserData ) session.getAttribute( "user_m" ) ;
            Box         box     = WebUtil.getBox( req ) ;

            String jobid_m = "" ;
            String dest  = "" ;

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

            double DPOT_AMNT = 0.0;  // 실공탁액
            double DPOT_CHRG = 0.0;  // 공탁수수료
            double GIVE_AMNT = 0.0;  // 배당정리액(수수료포함)
            double DPOT_TOTA = 0.0;  // 미배당공탁액계

            Logger.debug.println( this, "empNo : " + user_m.empNo ) ;

            D09BondDepositRFC func1 = new D09BondDepositRFC();
            Vector D09BondDepositData_vt = new Vector();

            if ( user_m != null ) {

                // BondDeposit - ZHRP_RFC_BOND_DEPOSITION - 채권 압류 공탁 현황
                D09BondDepositData_vt = func1.getBondDeposit( user_m.empNo ) ;

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

                    dest = WebUtil.JspURL + "D/D09Bond/D09BondDeposit_m.jsp" ;
                }
            } // if ( user_m != null ) end
            req.setAttribute( "D09BondDepositData_vt", D09BondDepositData_vt ) ;
            req.setAttribute( "DPOT_TOTA",             Double.toString( DPOT_TOTA ) ) ;  // 실공탁액

            Logger.debug.println( this, " destributed = " + dest ) ;

            printJspPage( req, res, dest ) ;

        } catch( Exception e ) {
            throw new GeneralException( e ) ;
        } finally {
        }
    }
}
