/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : 채권가압류                                                  */
/*   Program Name : 채권가압류                                                  */
/*   Program ID   : D09BondProvisionSV_m                                        */
/*   Description  : 채권 압류 지급 현황을 조회할 수 있도록 하는 Class           */
/*   Note         :                                                             */
/*   Creation     : 2002-02-25  한성덕                                          */
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


public class D09BondProvisionSV_m extends EHRBaseServlet {

    protected void performTask( HttpServletRequest req, HttpServletResponse res ) throws GeneralException {

        try {
            HttpSession session = req.getSession( false ) ;
            WebUserData user_m  = ( WebUserData ) session.getAttribute( "user_m" ) ;
            Box         box     = WebUtil.getBox( req ) ;

            String jobid_m   = "" ;
            String dest      = "" ;
            String MGTT_NUMB = "" ;

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

            String sortField = "";   //sortFieldName or sortFieldIndex
            String sortValue = "";  //sortValue ex) desc, asc

            jobid_m = box.get("jobid_m");

            // 지급액 클릭시..
            if( jobid_m.equals("detail") ) {
                MGTT_NUMB = box.get( "MGTT_NUMB" ) ;
            }

            double GIVE_TOTA = 0.0 ;  // 지급총액
            double GIVE_SUBA = 0.0 ;  // 지급액계

            D09BondProvisionRFC func1      = new D09BondProvisionRFC() ;
            Vector D09BondProvisionData_vt = new Vector();
            Vector D09BondProvision_tot    = new Vector();
            Vector D09BondProvision_sub    = new Vector();


            if ( user_m != null ) {

                Logger.debug.println( this, "empNo : " + user_m.empNo ) ;

                D09BondProvisionData_vt = func1.getBondProvision( user_m.empNo ) ; // BondProvision - ZHRP_RFC_BOND_RECEIPT - 채권압류 지급현황

                if( D09BondProvisionData_vt.size() == 0 ) {
                    Logger.debug.println( this, "Data Not Found" ) ;
                   // String msg = "조회할 내용이 없습니다." ;
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
                    if( sortField.equals("") ) {
                        sortField = "CRED_NAME,CRED_NUMB,BEGDA"; //채권자
                    }
                    if( sortValue.equals("") ) {
                        sortValue = "asc,asc,desc";       //올림차순
                    }
                    req.setAttribute( "sortField", sortField );
                    req.setAttribute( "sortValue", sortValue );
                    ///////////  SORT    /////////////
                }

            }//          if ( user_m != null ) end

            if( MGTT_NUMB.equals("") ) {
                ///////////  SORT    /////////////
                D09BondProvision_tot = SortUtil.sort( D09BondProvision_tot, sortField, sortValue ); //Vector Sort
                ///////////  SORT    /////////////

                Logger.debug.println( this, "D09BondProvision_tot : " + D09BondProvision_tot.toString() ) ;
                Logger.debug.println( this, "GIVE_TOTA            : " + Double.toString( GIVE_TOTA ) ) ;

                req.setAttribute( "D09BondProvision_tot", D09BondProvision_tot ) ;
                req.setAttribute( "GIVE_TOTA"           , Double.toString( GIVE_TOTA ) ) ;  // 지급총액

                dest = WebUtil.JspURL + "D/D09Bond/D09BondProvision_m.jsp" ;
            } else {      // 지급액 클릭시..
                ///////////  SORT    /////////////
                D09BondProvision_sub = SortUtil.sort( D09BondProvision_sub, sortField, sortValue ); //Vector Sort
                ///////////  SORT    /////////////

                Logger.debug.println( this, "D09BondProvision_sub : " + D09BondProvision_sub.toString() ) ;
                Logger.debug.println( this, "GIVE_SUBA            : " + Double.toString( GIVE_SUBA ) ) ;

                req.setAttribute( "D09BondProvision_sub", D09BondProvision_sub );
                req.setAttribute( "GIVE_SUBA"           , Double.toString( GIVE_SUBA ) );  // 지급액계
                req.setAttribute( "MGTT_NUMB"           , MGTT_NUMB );
                req.setAttribute( "jobid_m"             , jobid_m );

                dest = WebUtil.JspURL + "D/D09Bond/D09BondProvDetail_m.jsp" ;
            }

            Logger.debug.println( this, " destributed = " + dest ) ;

            printJspPage( req, res, dest ) ;

        } catch( Exception e ) {
            throw new GeneralException( e ) ;
        } finally {
        }
    }
}
