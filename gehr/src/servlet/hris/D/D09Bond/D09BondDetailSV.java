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
 * D09BondDetailSV.java
 *  ä�� �з� ���� ������ ��ȸ�� �� �ֵ��� �ϴ� Class
 *
 * @author �Ѽ���
 * @version 1.0, 2002/02/28
 */
public class D09BondDetailSV extends EHRBaseServlet {

    protected void performTask( HttpServletRequest req, HttpServletResponse res ) throws GeneralException {

        try {
            HttpSession session = req.getSession( false ) ;
            WebUserData user    = ( WebUserData ) session.getAttribute( "user" ) ;
            Box         box     = WebUtil.getBox( req ) ;

            String jobid = "" ;
            String dest  = "" ;

            String BEGDA     = box.get( "BEGDA"     );
            String CRED_NAME = box.get( "CRED_NAME" );
            String MGTT_NUMB = box.get( "MGTT_NUMB" );
            String CRED_ADDR = box.get( "CRED_ADDR" );
            String CRED_AMNT = box.get( "CRED_AMNT" );
            String CRED_TEXT = box.get( "CRED_TEXT" );
            String CRED_NUMB = box.get( "CRED_NUMB" );
            String SEQN_NUMB = box.get( "SEQN_NUMB" );

            // 2004.09.14 ���� - ȭ�����
            D09BondCortRFC func1              = null ;
            Vector         D09BondCortData_vt = null ;
            func1 = new D09BondCortRFC() ;
            // BondCort      - ZHRP_RFC_BOND_CORT - ä�� �̷� ��Ȳ
            D09BondCortData_vt = func1.getBondCort( user.empNo, CRED_NUMB, SEQN_NUMB );

            Logger.debug.println( this, "empNo     : " + user.empNo );

//            Logger.debug.println( this, "BEGDA     : " + BEGDA     );
//            Logger.debug.println( this, "CRED_NAME : " + CRED_NAME );
//            Logger.debug.println( this, "MGTT_NUMB : " + MGTT_NUMB );
//            Logger.debug.println( this, "CRED_ADDR : " + CRED_ADDR );
//            Logger.debug.println( this, "CRED_AMNT : " + CRED_AMNT );
//            Logger.debug.println( this, "CRED_TEXT : " + CRED_TEXT );
//            Logger.debug.println( this, "CRED_NUMB : " + CRED_NUMB );
//            Logger.debug.println( this, "SEQN_NUMB : " + SEQN_NUMB );

            req.setAttribute( "BEGDA",     BEGDA     );  // ������
            req.setAttribute( "CRED_NAME", CRED_NAME );  // ä���� ����
            req.setAttribute( "MGTT_NUMB", MGTT_NUMB );  // ������ȣ
            req.setAttribute( "CRED_ADDR", CRED_ADDR );  // �ּ�
            req.setAttribute( "CRED_AMNT", CRED_AMNT );  // ���з���
            req.setAttribute( "CRED_TEXT", CRED_TEXT );  // ä�ǻ���
            req.setAttribute( "CRED_NUMB", CRED_NUMB );  // ä���� ID
            req.setAttribute( "SEQN_NUMB", SEQN_NUMB );  // �Ϸù�ȣ
            req.setAttribute( "D09BondCortData_vt", D09BondCortData_vt ) ;

            dest = WebUtil.JspURL + "D/D09Bond/D09BondDetail.jsp" ;

            Logger.debug.println( this, " destributed = " + dest ) ;

            printJspPage( req, res, dest ) ;

        } catch( Exception e ) {
            throw new GeneralException( e ) ;
        } finally {
        }
    }
}
