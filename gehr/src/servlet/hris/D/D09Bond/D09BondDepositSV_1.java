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
 * D09BondDepositSV_1.java
 *  ��������� ������Ȳ�� ��ȸ�� �� �ֵ��� �ϴ� Class
 *
 * @author �Ѽ���
 * @version 1.0, 2002/01/25
 */
public class D09BondDepositSV_1 extends EHRBaseServlet {

    protected void performTask( HttpServletRequest req, HttpServletResponse res ) throws GeneralException {

        try {
            HttpSession session = req.getSession( false ) ;
            WebUserData user    = ( WebUserData ) session.getAttribute( "user" ) ;
            Box         box     = WebUtil.getBox( req ) ;

            String jobid = "" ;
            String dest  = "" ;

            String BEGDA = box.get( "BEGDA" ) ;

            double DPOT_TOTA   = 0.0 ;  // ��Ź�װ�

            D09BondProvisionRFC func1                   = null ;
            Vector              D09BondProvisionData_vt = null ;
            Vector              D09BondDepositDetail_vt = new Vector() ;

            func1                   = new D09BondProvisionRFC() ;
            // BondProvision - ZHRP_RFC_BOND_RECEIPT - ��������� ������Ȳ
            D09BondProvisionData_vt = func1.getBondProvision( user.empNo ) ;

            for( int i = 0 ; i < D09BondProvisionData_vt.size() ; i++ ) {
                D09BondProvisionData data = ( D09BondProvisionData ) D09BondProvisionData_vt.get( i ) ;

                if( data.BOND_TYPE.equals( "1" ) && data.DPOT_DATE.equals( BEGDA ) ) {
                    data.BOND_TYPE = "��Ź����" ;
                    D09BondDepositDetail_vt.addElement( data ) ;

                    DPOT_TOTA += Double.parseDouble( data.GIVE_AMNT ) ;  // ��Ź�װ�
                }
            }

            if( D09BondDepositDetail_vt.size() == 0 ) {
                Logger.debug.println( this, "Data Not Found" ) ;
                String msg = "��ȸ�� ������ �����ϴ�." ;
                String url = "history.back() ;" ;
                req.setAttribute( "msg", msg ) ;
                req.setAttribute( "url", url ) ;
                dest = WebUtil.JspURL + "common/msg.jsp" ;
            } else {

                Logger.debug.println( this, "D09BondDepositDetail_vt : " + D09BondDepositDetail_vt.toString() ) ;
                Logger.debug.println( this, "DPOT_TOTA               : " + Double.toString( DPOT_TOTA ) ) ;

                req.setAttribute( "D09BondDepositDetail_vt", D09BondDepositDetail_vt ) ;
                req.setAttribute( "DPOT_TOTA",               Double.toString( DPOT_TOTA ) ) ;  // ��Ź�װ�

                dest = WebUtil.JspURL + "D/D09Bond/D09BondDeposit_1.jsp" ;
            }
            Logger.debug.println( this, " destributed = " + dest ) ;

            printJspPage( req, res, dest ) ;

        } catch( Exception e ) {
            throw new GeneralException( e ) ;
        } finally {
        }

    }

}
