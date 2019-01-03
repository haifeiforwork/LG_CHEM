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
 *  ä�� �з� ��Ȳ�� ��ȸ�� �� �ֵ��� �ϴ� Class
 *
 * @author �Ѽ���
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

            double CRED_TOTA     = 0.0 ;  // ���з��Ѿ�
            double G_SUM         = 0.0 ;  // �����Ѿ�
            double dedu_rest     = 0.0 ;  // �̰����ܾ�
            double GIVE_TOTA     = 0.0 ;  // �����Ѿ�
            double GIVE_TOTA_RES = 0.0 ;  // �����Ѿ�
            double G_DPOT_REST   = 0.0 ;  // �̹���Ź��
            double coll_rest     = 0.0 ;  // �������ܾ�

            double REST_TOTA     = 0.0 ;  // ���з��ܾ� �հ�
            double DPOT_TOTA     = 0.0 ;  // ��Ź������ �հ�

            D09BondListRFC      func1                   = null ;
            D09BondDeductionRFC func2                   = null ;

            Vector              D09BondListData_vt      = null ;
            Vector              D09BondDeductionData_vt = null ;

            func1              = new D09BondListRFC() ;
            func2              = new D09BondDeductionRFC() ;

//          BondList      - ZHRP_RFC_BOND_PRESENTSTATE - ä�� �з� ��Ȳ
            D09BondListData_vt      = func1.getBondList( user.empNo ) ;
//          G_DPOT_REST   - ZHRP_RFC_BOND_PRESENTSTATE - �̹���Ź��
            G_DPOT_REST             = Double.parseDouble( func1.getG_DPOT_REST( user.empNo ) ) ;
//          BondDeduction - ZHRP_RFC_BOND_DEDUCTION    - ä�� �з� ���� ��Ȳ
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
                    CRED_TOTA += Double.parseDouble( data.CRED_AMNT ) ;  // ���з��Ѿ�
                    GIVE_TOTA += Double.parseDouble( data.GIVE_AMNT ) ;  // �����Ѿ�
                    
                    Logger.debug.println(this, "############## GIVE_TOTA : " +  GIVE_TOTA);
                    
                    REST_TOTA += Double.parseDouble( data.REST_AMNT ) ;  // ���з��ܾ� �հ�
                    DPOT_TOTA += Double.parseDouble( data.DPOT_CHRG ) ;  // ��Ź������ �հ�
                } else {
                    GIVE_TOTA_RES += Double.parseDouble( data.GIVE_AMNT ) ;  // ������ �����Ѿ�
                }
            }

//          �����Ѿ��� ���ϱ� ���ؼ�
            for( int i = 0 ; i < D09BondDeductionData_vt.size() ; i++ ) {
                D09BondDeductionData data = ( D09BondDeductionData ) D09BondDeductionData_vt.get( i ) ;
                G_SUM     += Double.parseDouble( data.G_SUM     ) ;  // �����Ѿ�
                Logger.debug.println(this, "############## G_SUM : " +  G_SUM);
            }
//          �����Ѿ׿��� ������ �����Ѿ��� �����Ѵ�.
            G_SUM = G_SUM - GIVE_TOTA_RES;
//          �̰����ܾ� = ( ���з��Ѿ� - �����Ѿ� ) + ��Ź������
            dedu_rest = ( CRED_TOTA - G_SUM ) + DPOT_TOTA ;
//          �������ܾ� = �����Ѿ� - ( �����Ѿ� + �̹���Ź�� + ��Ź������ )
            coll_rest = G_SUM - ( GIVE_TOTA + G_DPOT_REST + DPOT_TOTA ) ;

            Logger.debug.println( this, "D09BondListData_vt      : " + D09BondListData_vt.toString() ) ;
            Logger.debug.println( this, "D09BondDeductionData_vt : " + D09BondDeductionData_vt.toString() ) ;

            Logger.debug.println( this, "CRED_TOTA   : " + Double.toString( CRED_TOTA   ) ) ;  // ���з��Ѿ�
            Logger.debug.println( this, "G_SUM       : " + Double.toString( G_SUM       ) ) ;  // �����Ѿ�
            Logger.debug.println( this, "dedu_rest   : " + Double.toString( dedu_rest   ) ) ;  // �̰����ܾ�
            Logger.debug.println( this, "GIVE_TOTA   : " + Double.toString( GIVE_TOTA   ) ) ;  // �����Ѿ�
            Logger.debug.println( this, "G_DPOT_REST : " + Double.toString( G_DPOT_REST ) ) ;  // �̹���Ź��
            Logger.debug.println( this, "coll_rest   : " + Double.toString( coll_rest   ) ) ;  // �������ܾ�
            Logger.debug.println( this, "REST_TOTA   : " + Double.toString( REST_TOTA   ) ) ;  // ���з��ܾ� �հ�

            req.setAttribute( "D09BondListData_vt", D09BondListData_vt ) ;

            req.setAttribute( "CRED_TOTA",   Double.toString( CRED_TOTA   ) ) ;  // ���з��Ѿ�
            req.setAttribute( "G_SUM",       Double.toString( G_SUM       ) ) ;  // �����Ѿ�
            req.setAttribute( "dedu_rest",   Double.toString( dedu_rest   ) ) ;  // �̰����ܾ�
            req.setAttribute( "GIVE_TOTA",   Double.toString( GIVE_TOTA   ) ) ;  // �����Ѿ�
            req.setAttribute( "G_DPOT_REST", Double.toString( G_DPOT_REST ) ) ;  // �̹���Ź��
            req.setAttribute( "coll_rest",   Double.toString( coll_rest   ) ) ;  // �������ܾ�
            req.setAttribute( "REST_TOTA",   Double.toString( REST_TOTA   ) ) ;  // ���з��ܾ� �հ�

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
