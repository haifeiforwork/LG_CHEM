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
 * D09BondProvisionSV.java
 *  채권 압류 지급 현황을 조회할 수 있도록 하는 Class
 *
 * @author 한성덕
 * @version 1.0, 2002/01/25
 */
public class D09BondProvisionSV extends EHRBaseServlet {

    protected void performTask( HttpServletRequest req, HttpServletResponse res ) throws GeneralException {

        try {
            HttpSession session = req.getSession( false ) ;
            WebUserData user    = ( WebUserData ) session.getAttribute( "user" ) ;
            Box         box     = WebUtil.getBox( req ) ;

            String jobid     = "" ;
            String dest      = "" ;
            String MGTT_NUMB = "" ;

            String sortField = "";   //sortFieldName or sortFieldIndex
            String sortValue = "";  //sortValue ex) desc, asc

            jobid = box.get("jobid");

            // 지급액 클릭시..
            if( jobid.equals("detail") ) {
                MGTT_NUMB = box.get( "MGTT_NUMB" ) ;
            }

            double GIVE_TOTA   = 0.0 ;  // 지급총액
            double GIVE_SUBA   = 0.0 ;  // 지급액계

            Logger.debug.println( this, "empNo : " + user.empNo ) ;

            D09BondProvisionRFC func1                   = null ;
            Vector              D09BondProvisionData_vt = null ;
            Vector              D09BondProvision_tot    = new Vector();
            Vector              D09BondProvision_sub    = new Vector();

            func1                   = new D09BondProvisionRFC() ;
            // BondProvision - ZHRP_RFC_BOND_RECEIPT - 채권압류 지급현황
            D09BondProvisionData_vt = func1.getBondProvision( user.empNo ) ;

            if( D09BondProvisionData_vt.size() == 0 ) {
                Logger.debug.println( this, "Data Not Found" ) ;
                //String msg = "조회할 내용이 없습니다." ;
                String msg = g.getMessage("MSG.D.D15.0012");
                String url = "history.back() ;" ;
                req.setAttribute( "msg", msg ) ;
                req.setAttribute( "url", url ) ;
                dest = WebUtil.JspURL + "common/msg.jsp" ;
            } else {
                for( int i = 0 ; i < D09BondProvisionData_vt.size() ; i++ ) {
                    D09BondProvisionData data = ( D09BondProvisionData ) D09BondProvisionData_vt.get( i ) ;

                    if( data.BOND_TYPE.equals( "1" ) ) {
                        //data.BOND_TYPE = "공탁배정" ;
                    	data.BOND_TYPE =g.getMessage("LABEL.D.D15.01161") ;
                    } else if( data.BOND_TYPE.equals( "2" ) ) {
                        //data.BOND_TYPE = "지급" ;
                    	data.BOND_TYPE = g.getMessage("LABEL.D.D15.01162") ;
                    }
                    // 지급 총액 클릭시..
                    // 해지된 데이터는 보이지 않는다.
                    if( !data.FIRE_FLAG.equals("X") ) {
                        GIVE_TOTA += Double.parseDouble( data.GIVE_AMNT ) + Double.parseDouble( data.DPOT_CHRG ) ;  // 지급총액

                        D09BondProvision_tot.addElement(data) ;
                    }

                    // 각 지급액 클릭시..
                    if( data.CRED_NUMB.equals(MGTT_NUMB) ) {
                        GIVE_SUBA += Double.parseDouble( data.GIVE_AMNT ) + Double.parseDouble( data.DPOT_CHRG ) ;  // 지급액계

                        D09BondProvision_sub.addElement(data) ;
                    }
                }

                ///////////  SORT    /////////////
                sortField = box.get( "sortField" );
                sortValue = box.get( "sortValue" );
                if( sortField.equals("") || sortField == null) {
                    sortField = "CRED_NAME,CRED_NUMB,BEGDA"; //채권자
                }
                if( sortValue.equals("") || sortValue == null) {
                    sortValue = "asc,asc,desc";       //올림차순
                }
                req.setAttribute( "sortField", sortField );
                req.setAttribute( "sortValue", sortValue );
                ///////////  SORT    /////////////

                if( MGTT_NUMB.equals("") ) {
                    ///////////  SORT    /////////////
                    D09BondProvision_tot = SortUtil.sort( D09BondProvision_tot, sortField, sortValue ); //Vector Sort
                    ///////////  SORT    /////////////

                    Logger.debug.println( this, "D09BondProvision_tot : " + D09BondProvision_tot.toString() ) ;
                    Logger.debug.println( this, "GIVE_TOTA            : " + Double.toString( GIVE_TOTA ) ) ;

                    req.setAttribute( "D09BondProvision_tot", D09BondProvision_tot ) ;
                    req.setAttribute( "GIVE_TOTA"           , Double.toString( GIVE_TOTA ) ) ;  // 지급총액

                    dest = WebUtil.JspURL + "D/D09Bond/D09BondProvision.jsp" ;
                } else {      // 지급액 클릭시..
                    ///////////  SORT    /////////////
                    D09BondProvision_sub = SortUtil.sort( D09BondProvision_sub, sortField, sortValue ); //Vector Sort
                    ///////////  SORT    /////////////

                    Logger.debug.println( this, "D09BondProvision_sub : " + D09BondProvision_sub.toString() ) ;
                    Logger.debug.println( this, "GIVE_SUBA            : " + Double.toString( GIVE_SUBA ) ) ;

                    req.setAttribute( "D09BondProvision_sub", D09BondProvision_sub );
                    req.setAttribute( "GIVE_SUBA"           , Double.toString( GIVE_SUBA ) );  // 지급액계
                    req.setAttribute( "MGTT_NUMB"           , MGTT_NUMB );
                    req.setAttribute( "jobid"               , jobid );

                    dest = WebUtil.JspURL + "D/D09Bond/D09BondProvDetail.jsp" ;
                }
            }
            Logger.debug.println( this, " destributed = " + dest ) ;

            printJspPage( req, res, dest ) ;

        } catch( Exception e ) {
            throw new GeneralException( e ) ;
        } finally {
        }

    }

}
