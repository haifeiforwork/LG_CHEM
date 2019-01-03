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
 *  ä�� �з� ��Ź ��Ȳ�� ��ȸ�� �� �ֵ��� �ϴ� Class
 *
 * @author �Ѽ���
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

            double DPOT_AMNT = 0.0 ;  // �ǰ�Ź��
            double DPOT_CHRG = 0.0 ;  // ��Ź������
            double GIVE_AMNT = 0.0 ;  // ���������(����������)
            double DPOT_TOTA = 0.0 ;  // �̹���Ź�װ�

            Logger.debug.println( this, "empNo : " + user.empNo ) ;

            D09BondDepositRFC func1                 = null ;
            Vector            D09BondDepositData_vt = null ;

            func1                 = new D09BondDepositRFC() ;
            // BondDeposit - ZHRP_RFC_BOND_DEPOSITION - ä�� �з� ��Ź ��Ȳ
            D09BondDepositData_vt = func1.getBondDeposit( user.empNo ) ;

            if( D09BondDepositData_vt.size() == 0 ) {
                Logger.debug.println( this, "Data Not Found" ) ;
                //String msg = "��ȸ�� ������ �����ϴ�." ;
                String msg = g.getMessage("MSG.D.D15.0012");
                String url = "history.back() ;" ;
                req.setAttribute( "msg", msg ) ;
                req.setAttribute( "url", url ) ;
                dest = WebUtil.JspURL + "common/msg.jsp" ;
            } else {

                for( int i = 0 ; i < D09BondDepositData_vt.size() ; i++ ) {
                    D09BondDepositData data = ( D09BondDepositData ) D09BondDepositData_vt.get( i ) ;

                    DPOT_AMNT += Double.parseDouble( data.DPOT_AMNT ) ;  // �ǰ�Ź��
                    DPOT_CHRG += Double.parseDouble( data.DPOT_CHRG ) ;  // ��Ź������
                    GIVE_AMNT += Double.parseDouble( data.GIVE_AMNT ) ;  // ���������(����������)
                }

                // �̹���Ź�װ� = �ǰ�Ź�� + ��Ź������ - ���������(����������)
                DPOT_TOTA = DPOT_AMNT + DPOT_CHRG - GIVE_AMNT ;

                Logger.debug.println( this, "D09BondDepositData_vt : " + D09BondDepositData_vt.toString() ) ;
                Logger.debug.println( this, "DPOT_TOTA             : " + Double.toString( DPOT_TOTA ) ) ;

                req.setAttribute( "D09BondDepositData_vt", D09BondDepositData_vt ) ;
                req.setAttribute( "DPOT_TOTA",             Double.toString( DPOT_TOTA ) ) ;  // �ǰ�Ź��

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
