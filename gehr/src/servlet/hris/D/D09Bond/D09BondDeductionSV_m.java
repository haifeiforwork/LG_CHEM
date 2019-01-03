/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : ä�ǰ��з�                                                  */
/*   Program Name : ä�ǰ��з�                                                  */
/*   Program ID   : D09BondDeductionSV_m                                        */
/*   Description  : ä�� �з� ���� ��Ȳ�� ��ȸ�� �� �ֵ��� �ϴ� Class           */
/*   Note         :                                                             */
/*   Creation     : 2002-02-27  �Ѽ���                                          */
/*   Update       : 2005-01-21  ������                                          */
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
//          @����༺ �߰�
            if ( user.e_authorization.equals("E")||isBlocklist(user) ) {
                Logger.debug.println(this, "E Authorization!!");
                String msg = "msg015";
                req.setAttribute("msg", msg);
                dest = WebUtil.JspURL+"common/caution.jsp";
                printJspPage(req, res, dest);
                return;
            }

            double TOTA1    = 0.0 ;  // ���Ա޿�
            double TOTA2    = 0.0 ;  // ���Ի�
            double TOTA4    = 0.0 ;  // �����Ի�
            double TOTA3    = 0.0 ;  // ������
            double TOTA_SUM = 0.0 ;  // �����װ�

            Logger.debug.println( this, "empNo : " + user_m.empNo ) ;

            D09BondDeductionRFC func1                   = new D09BondDeductionRFC() ;
            Vector              D09BondDeductionData_vt = new Vector() ;

            if ( user_m != null ) {
                // BondDeduction - ZHRP_RFC_BOND_DEDUCTION - ä�� �з� ���� ��Ȳ
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

                    TOTA1    += Double.parseDouble( data.BETRG01 ) ;  // ���Ա޿�
                    TOTA2    += Double.parseDouble( data.BETRG02 ) ;  // ���Ի�
                    TOTA4    += Double.parseDouble( data.BETRG04 ) ;  // �����Ի�
                    TOTA3    += Double.parseDouble( data.BETRG03 ) ;  // ������
                    TOTA_SUM += Double.parseDouble( data.G_SUM   ) ;  // �����װ�
                }

                Logger.debug.println( this, "D09BondDeductionData_vt : " + D09BondDeductionData_vt.toString() ) ;

                req.setAttribute( "D09BondDeductionData_vt", D09BondDeductionData_vt ) ;
                req.setAttribute( "TOTA1",                   Double.toString( TOTA1 ) ) ;     // ���Ա޿�
                req.setAttribute( "TOTA2",                   Double.toString( TOTA2 ) ) ;     // ���Ի�
                req.setAttribute( "TOTA4",                   Double.toString( TOTA4 ) ) ;     // �����Ի�
                req.setAttribute( "TOTA3",                   Double.toString( TOTA3 ) ) ;     // ������
                req.setAttribute( "TOTA_SUM",                Double.toString( TOTA_SUM ) ) ;  // �����װ�

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
