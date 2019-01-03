/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : 채권가압류                                                  */
/*   Program Name : 채권가압류                                                  */
/*   Program ID   : D09BondDepositSV_1_m                                        */
/*   Description  : 배당정리액 내역현황을 조회할 수 있도록 하는 Class           */
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
import hris.D.D09Bond.D09BondProvisionData;
import hris.D.D09Bond.rfc.* ;

public class D09BondDepositSV_1_m extends EHRBaseServlet {

    protected void performTask( HttpServletRequest req, HttpServletResponse res ) throws GeneralException {

        try {
            HttpSession session = req.getSession( false ) ;
            WebUserData user_m  = ( WebUserData ) session.getAttribute( "user_m" ) ;
            Box         box     = WebUtil.getBox( req ) ;

            String dest  = "" ;
            String BEGDA = box.get( "BEGDA" ) ;

            double DPOT_TOTA   = 0.0 ;  // 공탁액계

            D09BondProvisionRFC func1 = new D09BondProvisionRFC() ;
            Vector D09BondProvisionData_vt = new Vector() ;
            Vector D09BondDepositDetail_vt = new Vector() ;
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
            if ( user_m != null ) {
                // BondProvision - ZHRP_RFC_BOND_RECEIPT - 배당정리액 내역현황
                D09BondProvisionData_vt = func1.getBondProvision( user_m.empNo ) ;
            } // if ( user_m != null ) end

            for( int i = 0 ; i < D09BondProvisionData_vt.size() ; i++ ) {
                D09BondProvisionData data = ( D09BondProvisionData ) D09BondProvisionData_vt.get( i ) ;

                if( data.BOND_TYPE.equals( "1" ) && data.DPOT_DATE.equals( BEGDA ) ) {
                    data.BOND_TYPE = "공탁배정" ;
                    D09BondDepositDetail_vt.addElement( data ) ;

                    DPOT_TOTA += Double.parseDouble( data.GIVE_AMNT ) ;  // 공탁액계
                }
            }

            if( D09BondDepositDetail_vt.size() == 0 ) {
                Logger.debug.println( this, "Data Not Found" ) ;
                String msg = "조회할 내용이 없습니다." ;
                String url = "history.back() ;" ;
                req.setAttribute( "msg", msg ) ;
                req.setAttribute( "url", url ) ;
                dest = WebUtil.JspURL + "common/msg.jsp" ;
            } else {

                Logger.debug.println( this, "D09BondDepositDetail_vt : " + D09BondDepositDetail_vt.toString() ) ;
                Logger.debug.println( this, "DPOT_TOTA               : " + Double.toString( DPOT_TOTA ) ) ;

                req.setAttribute( "D09BondDepositDetail_vt", D09BondDepositDetail_vt ) ;
                req.setAttribute( "DPOT_TOTA",               Double.toString( DPOT_TOTA ) ) ;  // 공탁액계

                dest = WebUtil.JspURL + "D/D09Bond/D09BondDeposit_1_m.jsp" ;
            }
            Logger.debug.println( this, " destributed = " + dest ) ;

            printJspPage( req, res, dest ) ;

        } catch( Exception e ) {
            throw new GeneralException( e ) ;
        } finally {
        }
    }
}
