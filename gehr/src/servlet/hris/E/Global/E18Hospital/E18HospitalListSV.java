package servlet.hris.E.Global.E18Hospital ;

import com.common.Utils;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.SortUtil;
import com.sns.jdf.util.WebUtil;
import hris.E.Global.E18Hospital.rfc.E18HospitalListRFC;
import hris.common.WebUserData;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.Vector;

/**
 * E18HospitalListSV.java
 *  사원의 의료비 내역을 조회할 수 있도록 하는 Class
 *
 * @author 한성덕
 * @version 1.0, 2002/01/03
 * 				 2007/10/05 update by huang peng xiao
 */
public class E18HospitalListSV extends EHRBaseServlet {

    protected void performTask( HttpServletRequest req, HttpServletResponse res ) throws GeneralException {

        try {
            HttpSession session = req.getSession( false ) ;
            WebUserData user    = ( WebUserData ) session.getAttribute( "user" ) ;
            Box         box     = WebUtil.getBox( req ) ;

            String dest   = "" ;
            String PERNR = "";
            String sortField = "";   //sortFieldName or sortFieldIndex
            String sortValue = "";  //sortValue ex) desc, asc

            String page   = box.get( "page","1" ) ;

            PERNR =  getPERNR(box, user); //WebUtil.getRepresentative(req);

            //Logger.debug.println(this, "user.empNo==============================!"+user.empNo);

            E18HospitalListRFC func1                    = null ;
            Vector             ret 						     = null ;
            Vector		      E18HospitalListData_vt = null;

           // HospitalList - ZHRW_RFC_MEDIC - 의료비 내역
            func1                  = new E18HospitalListRFC() ;
            ret = func1.getHospitalList( user.empNo ) ;

            String E_RETURN   = (String) Utils.indexOf(ret, 0);       //(String)ret.get(0);  // return code
            String  E_MESSAGE  = (String) Utils.indexOf(ret, 1);     //(String)ret.get(1); // return message
            E18HospitalListData_vt = (Vector) Utils.indexOf(ret, 2); // (Vector)ret.get(2);

            ///////////  SORT    /////////////
            sortField = box.get( "sortField", "EXDATE" );
            sortValue = box.get( "sortValue", "desc" );
            /*if( sortField.equals("") || sortField == null) {
                sortField = "EXDATE"; //최종결재일
            }
            if( sortValue.equals("") || sortValue == null) {
                sortValue = "desc";  //정렬방법
            }*/
            E18HospitalListData_vt = SortUtil.sort( E18HospitalListData_vt, sortField, sortValue ); //Vector Sort
            req.setAttribute( "sortField", sortField );
            req.setAttribute( "sortValue", sortValue );
            ///////////  SORT    /////////////

            req.setAttribute( "page", page );
            req.setAttribute( "E18HospitalListData_vt", E18HospitalListData_vt ) ;

            dest = WebUtil.JspURL + "E/E18Hospital/E18HospitalList_Global.jsp" ;

            Logger.debug.println( this, " destributed = " + dest ) ;

            printJspPage( req, res, dest ) ;

        } catch( Exception e ) {
            throw new GeneralException( e ) ;
        } finally {
        }

    }

}
