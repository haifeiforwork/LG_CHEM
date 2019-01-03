/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : 의료비지원내역                                              */
/*   Program Name : 의료비지원내역                                              */
/*   Program ID   : E18HospitalListSV_m                                         */
/*   Description  : 사원의 의료비 내역을 조회할 수 있도록 하는 Class            */
/*   Note         :                                                             */
/*   Creation     : 2002-01-03  한성덕                                          */
/*   Update       : 2005-01-24  윤정현                                          */
/*                      2016-03-15 2016-03-08 [CSR ID:2995203] 보상명세서 적용(Total Compensation)  */
/*                                                                              */
/********************************************************************************/

package servlet.hris.E.E18Hospital ;

import java.util.Vector ;
import javax.servlet.http.* ;

import com.sns.jdf.* ;
import com.sns.jdf.util.* ;
import com.sns.jdf.servlet.* ;

import hris.common.* ;
import hris.E.E18Hospital.rfc.* ;

public class E18HospitalListSV_m extends EHRBaseServlet {

    protected void performTask( HttpServletRequest req, HttpServletResponse res ) throws GeneralException {

        try {
            HttpSession session = req.getSession( false ) ;
            WebUserData user_m  = ( WebUserData ) session.getAttribute( "user_m" ) ;
            Box         box     = WebUtil.getBox( req ) ;

            String dest   = "" ;
            String sortField = "";  //sortFieldName or sortFieldIndex
            String sortValue = "";  //sortValue ex) desc, asc

            WebUserData user = WebUtil.getSessionUser(req);
//          @웹취약성 추가
            if ( user.e_authorization.equals("E")) {
                Logger.debug.println(this, "E Authorization!!");
                String msg = "msg015";
                req.setAttribute("msg", msg);
                dest = WebUtil.JspURL+"common/caution.jsp";
                printJspPage(req, res, dest);
            }

            String page_m   = box.get( "page_m", "1" ) ;
            /*if( page_m.equals("") ){
                page_m = "1";
            }*/

          //2016-03-08 [CSR ID:2995203] 보상명세서 적용(Total Compensation)
            String RequestPageName = box.get("RequestPageName");
            req.setAttribute("RequestPageName", RequestPageName);

            E18HospitalListRFC func1                  = new E18HospitalListRFC() ;
            Vector             E18HospitalListData_vt = new Vector();

            if ( user_m != null ) {
                // HospitalList - ZHRW_RFC_MEDIC - 의료비 내역
                E18HospitalListData_vt = func1.getHospitalList( user_m.empNo ) ;
            } // if ( user_m != null ) end

            ///////////  SORT    /////////////
            sortField = box.get( "sortField",  "POST_DATE" );
            sortValue = box.get( "sortValue", "desc" );
            /*if( sortField.equals("") ) {
                sortField = "POST_DATE"; //최종결재일
            }
            if( sortValue.equals("") ) {
                sortValue = "desc";  //정렬방법
            }*/
            E18HospitalListData_vt = SortUtil.sort( E18HospitalListData_vt, sortField, sortValue ); //Vector Sort
            req.setAttribute( "sortField", sortField );
            req.setAttribute( "sortValue", sortValue );
            ///////////  SORT    /////////////

            Logger.debug.println( this, "E18HospitalListData_vt : " + E18HospitalListData_vt.toString() ) ;

            req.setAttribute( "page_m", page_m );
            req.setAttribute( "E18HospitalListData_vt", E18HospitalListData_vt ) ;

            dest = WebUtil.JspURL + "E/E18Hospital/E18HospitalList_m.jsp" ;

            Logger.debug.println( this, " destributed = " + dest ) ;

            printJspPage( req, res, dest ) ;

        } catch( Exception e ) {
            throw new GeneralException( e ) ;
        } finally {
        }
    }
}
