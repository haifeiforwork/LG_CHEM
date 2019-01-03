/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : ��������������                                              */
/*   Program Name : ��������������                                              */
/*   Program ID   : E20CongraListSV_m                                           */
/*   Description  : ������ ����Ʈ�� ��ȸ �� �� ��ȸ �ϴ� Class                */
/*   Note         :                                                             */
/*   Creation     : 2001-12-19  �ڿ���                                          */
/*   Update       : 2005-01-24  ������                                          */
/*                      2016-03-15 2016-03-08 [CSR ID:2995203] ������� ����(Total Compensation)                                                        */
/********************************************************************************/

package servlet.hris.E.E20Congra;

import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.SortUtil;
import com.sns.jdf.util.WebUtil;
import hris.E.E20Congra.rfc.E20CongDisplayRFC;
import hris.common.WebUserData;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.Vector;

public class E20CongraListSV_m extends EHRBaseServlet {

	protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {
	    try{
	        HttpSession session = req.getSession(false);

	        WebUserData user_m = WebUtil.getSessionMSSUser(req);
	        Box box = WebUtil.getBox(req);

	        String dest      = "";
	        String page_m    = "";  //paging ó��
	        String sortField = "";  //sortFieldName or sortFieldIndex
	        String sortValue = "";  //sortValue ex) desc, asc
	        String dest_deail = "";

            WebUserData user = WebUtil.getSessionUser(req);
	        if (!user.sapType.isLocal()){
	        	dest_deail = "Global";
	        }else {
	        	dest_deail = "KR";
	        	if(!checkAuthorization(req, res)) return;
		        //2016-03-08 [CSR ID:2995203] ������� ����(Total Compensation)
	            String RequestPageName = box.get("RequestPageName");
	            req.setAttribute("RequestPageName", RequestPageName);
	        }


	        page_m  = box.get("page_m");
	        if( page_m.equals("")  ){
	            page_m = "1";
	        }


	        Vector E20CongcondData_dis = new Vector();

	        if ( user_m != null ) {
	            E20CongcondData_dis = ( new E20CongDisplayRFC() ).getCongDisplay( user.sapType,user_m.empNo );
	        } // if ( user_m != null ) end

	        ///////////  SORT    /////////////
	        sortField = box.get( "sortField" );
	        sortValue = box.get( "sortValue" );
	        if( sortValue.equals("") ) {
	            sortValue = "desc"; //���Ĺ��
	        }

	        if (!user.sapType.isLocal()){
				if (sortField.equals("") || sortField == null) {
					sortField = "CELDT"; // ��û��
				}
				if (sortField.equals("PAYM_AMNT") || sortField.equals("REFU_AMNT")) {
					E20CongcondData_dis = SortUtil.sort_num(E20CongcondData_dis,
							sortField, sortValue); // Number
				} else {
					E20CongcondData_dis = SortUtil.sort(E20CongcondData_dis,
							sortField, sortValue); // String
				}
	        }else{
	        	 if( sortField.equals("")  ) {
	 	            sortField = "CONG_DATE"; //��û��
	 	        }
	        	 if( sortField.equals("CONG_WONX") ) {
	 	            E20CongcondData_dis = SortUtil.sort_num( E20CongcondData_dis, sortField, sortValue ); // Number
	 	        } else {
	 	            E20CongcondData_dis = SortUtil.sort( E20CongcondData_dis, sortField, sortValue );     // String
	 	        }
	        }

            req.setAttribute( "sortField", sortField );
	        req.setAttribute( "sortValue", sortValue );
	        ///////////  SORT    /////////////

	        req.setAttribute( "page_m", page_m );
	        req.setAttribute( "E20CongcondData_dis", E20CongcondData_dis );

	        dest = WebUtil.JspURL+"E/E20Congra/E20CongraList_m_"+dest_deail+".jsp";

	        Logger.debug.println(this, " destributed = " + dest + "  page_m : "+ page_m);
	        printJspPage(req, res, dest);

	    } catch(Exception e) {
	        throw new GeneralException(e);
	    } finally {
	    }
	}
}