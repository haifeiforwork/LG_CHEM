package servlet.hris.E.E18Hospital ;

import java.util.Vector ;
import javax.servlet.http.* ;

import com.sns.jdf.* ;
import com.sns.jdf.util.* ;
import com.sns.jdf.servlet.* ;

import hris.common.* ;
import hris.E.E18Hospital.rfc.E18HospitalListRFC ;

/**
 * E18HospitalListSV.java
 *  사원의 의료비 내역을 조회할 수 있도록 하는 Class
 *
 * @author 한성덕
 * @version 1.0, 2002/01/03
 */
public class E18HospitalListSV extends EHRBaseServlet {

    protected void performTask( HttpServletRequest req, HttpServletResponse res ) throws GeneralException {

        try {
            HttpSession session = req.getSession( false ) ;
            WebUserData user    = ( WebUserData ) session.getAttribute( "user" ) ;
            Box         box     = WebUtil.getBox( req ) ;

            String dest   = "" ;
            String sortField = "";   //sortFieldName or sortFieldIndex
            String sortValue = "";  //sortValue ex) desc, asc

            String page   = box.get( "page", "1") ;

            //2016-03-08 [CSR ID:2995203] 보상명세서 적용(Total Compensation)
            String RequestPageName = box.get("RequestPageName");
            req.setAttribute("RequestPageName", RequestPageName);

            E18HospitalListRFC func1                  = null ;
            Vector             E18HospitalListData_vt = null ;

            // HospitalList - ZHRW_RFC_MEDIC - 의료비 내역
            func1                  = new E18HospitalListRFC() ;
            E18HospitalListData_vt = func1.getHospitalList( user.empNo ) ;

            ///////////  SORT    /////////////
            sortField = box.get( "sortField", "POST_DATE");
            sortValue = box.get( "sortValue", "desc");
            /*if( sortField == null ||sortField.equals("")  ) {
                sortField = "POST_DATE"; //최종결재일
            }
            if( sortValue == null || sortValue.equals("") ) {
                sortValue = "desc";  //정렬방법
            }*/
            E18HospitalListData_vt = SortUtil.sort( E18HospitalListData_vt, sortField, sortValue ); //Vector Sort
            req.setAttribute( "sortField", sortField );
            req.setAttribute( "sortValue", sortValue );
            ///////////  SORT    /////////////

            req.setAttribute( "page", page );
            req.setAttribute( "E18HospitalListData_vt", E18HospitalListData_vt ) ;

            dest = WebUtil.JspURL + "E/E18Hospital/E18HospitalList.jsp" ;
//            }
            Logger.debug.println( this, " destributed = " + dest ) ;

            printJspPage( req, res, dest ) ;

        } catch( Exception e ) {
            throw new GeneralException( e ) ;
        }

    }

}
