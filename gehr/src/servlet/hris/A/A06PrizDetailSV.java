package	servlet.hris.A;

import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.SortUtil;
import com.sns.jdf.util.WebUtil;
import hris.A.A06PrizDetailData;
import hris.A.rfc.A06PrizDetailRFC;
import hris.common.MappingPernrData;
import hris.common.WebUserData;
import hris.common.rfc.MappingPernrRFC;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.Vector;

/**
 * PrizDetailSV.java
 * ���������� jsp�� �Ѱ��ִ� class
 * jobid�� search �ϰ��� �������� List �� �������� PrizDetailRFC�� ȣ���Ͽ� PrizDetail.jsp�� ���������� �Ѱ��ش�.
 *
 * @author �ֿ�ȣ
 * @version 1.0, 2001/12/17
 */
public class A06PrizDetailSV extends EHRBaseServlet {

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        try{

            HttpSession session = req.getSession(false);
            WebUserData user = WebUtil.getSessionUser(req);
            Box box = WebUtil.getBox(req);

            String jobid = "";
            String dest  = "";
            String page  = "";      //paging ó��

            String sortField = "";   //sortFieldName or sortFieldIndex
            String sortValue = "";

            page  = box.get("page");
            Logger.debug.println(this, "servlet Page : " + page);
            if( page.equals("") || page == null ){
                page = "1";
            }

            A06PrizDetailRFC     func1  = null;
            Vector A06PrizDetailData_vt = new Vector();

            //// ���Ի��� ����� �������� RFC - 2004.11.19 YJH
            MappingPernrRFC  mapfunc = null ;
            MappingPernrData mapData = new MappingPernrData();
            Vector mapData_vt  = new Vector() ;
            Vector prizData_vt = new Vector() ;

            mapfunc    = new MappingPernrRFC() ;
            mapData_vt = mapfunc.getPernr( user.empNo ) ;

            if ( user.companyCode.equals("C100") && mapData_vt != null && mapData_vt.size() > 0 ) {  // ���Ի��� ó��
                A06PrizDetailData data = new A06PrizDetailData();

                for ( int i=0; i < mapData_vt.size(); i++) {
                    mapData = (MappingPernrData)mapData_vt.get(i);

                    func1       = new A06PrizDetailRFC() ;
                    prizData_vt = func1.getPrizDetail( mapData.PERNR , "", null, null) ;

                    for( int j = 0 ; j < prizData_vt.size() ; j++ ) {
                        data = (A06PrizDetailData)prizData_vt.get(j);
                        A06PrizDetailData_vt.addElement(data);
                    }
                }

            } else {
                func1                = new A06PrizDetailRFC();
                A06PrizDetailData_vt = func1.getPrizDetail(user.empNo, "", null, null);
            }

            ///////////  SORT    /////////////
            sortField = box.get( "sortField" );
            sortValue = box.get( "sortValue" );
            if( sortField.equals("") || sortField == null) {
                sortField = "BEGDA"; //��û��
            }
            if( sortValue.equals("") || sortValue == null) {
                sortValue = "desc"; //���Ĺ��
            }
            A06PrizDetailData_vt = SortUtil.sort( A06PrizDetailData_vt, sortField, sortValue ); //Vector Sort
            req.setAttribute( "sortField", sortField );
            req.setAttribute( "sortValue", sortValue );
            ///////////  SORT    /////////////

            req.setAttribute( "page", page );
            Logger.debug.println(this, "A06PrizDetailData_vt : "+ A06PrizDetailData_vt.toString());
            req.setAttribute("A06PrizDetailData_vt", A06PrizDetailData_vt);
            dest = WebUtil.JspURL+"A/A06PrizDetail.jsp";

            Logger.debug.println(this, " destributed = " + dest);
            printJspPage(req, res, dest);

        } catch (Exception e) {
            throw new GeneralException(e);
        }
    }
}
