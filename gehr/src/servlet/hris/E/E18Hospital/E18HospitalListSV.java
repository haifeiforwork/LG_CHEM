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
 *  ����� �Ƿ�� ������ ��ȸ�� �� �ֵ��� �ϴ� Class
 *
 * @author �Ѽ���
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

            //2016-03-08 [CSR ID:2995203] ������� ����(Total Compensation)
            String RequestPageName = box.get("RequestPageName");
            req.setAttribute("RequestPageName", RequestPageName);

            E18HospitalListRFC func1                  = null ;
            Vector             E18HospitalListData_vt = null ;

            // HospitalList - ZHRW_RFC_MEDIC - �Ƿ�� ����
            func1                  = new E18HospitalListRFC() ;
            E18HospitalListData_vt = func1.getHospitalList( user.empNo ) ;

            ///////////  SORT    /////////////
            sortField = box.get( "sortField", "POST_DATE");
            sortValue = box.get( "sortValue", "desc");
            /*if( sortField == null ||sortField.equals("")  ) {
                sortField = "POST_DATE"; //����������
            }
            if( sortValue == null || sortValue.equals("") ) {
                sortValue = "desc";  //���Ĺ��
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
