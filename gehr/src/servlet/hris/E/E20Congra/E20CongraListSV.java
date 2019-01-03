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
import java.util.Vector;

/**
 * E20CongraListSV.java
 * 경조금 리스트를 조회 및 상세 조회 하는 Class
 *
 * @author 박영락
 * @version 1.0, 2001/12/19
 *                     2016-03-15 //2016-03-08 [CSR ID:2995203] 보상명세서 적용(Total Compensation)
 */
public class E20CongraListSV extends EHRBaseServlet {

	protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {
        try{
            WebUserData user = WebUtil.getSessionUser(req);

            Box box = WebUtil.getBox(req);

            String dest  = "";
            String page  = "";      //paging 처리
            String sortField = "";   //sortFieldName or sortFieldIndex
            String sortValue = "";  //sortValue ex) desc, asc
            String dest_deail = "";

            page  = box.get("page");
            if(page == null || page.equals("")  ){
                page = "1";
            }
	        if (!user.sapType.isLocal()){
	        	dest_deail = "Global";
	        }else {
	        	dest_deail = "KR";
	        	//2016-03-08 [CSR ID:2995203] 보상명세서 적용(Total Compensation)
	        	String RequestPageName = box.get("RequestPageName");
	        	req.setAttribute("RequestPageName", RequestPageName);
	        }

            Vector E20CongcondData_dis = new E20CongDisplayRFC().getCongDisplay(user.sapType,user.empNo );

/*            if ( E20CongcondData_dis.size() == 0 ) {
                Logger.debug.println(this, "Data Not Found");
                String msg = "msg004";
                //String url = "history.back();";
                req.setAttribute("msg", msg);
                //req.setAttribute("url", url);
                dest = WebUtil.JspURL+"common/caution.jsp";

            } else {        */
            ///////////  SORT    /////////////
            sortField = box.get( "sortField" );
            sortValue = box.get( "sortValue" );
            if( sortValue == null||sortValue.equals("") ) {
                sortValue = "desc"; //정렬방법
            }

	        if (!user.sapType.isLocal()){
				if (sortField.equals("") || sortField == null) {
					sortField = "CELDT"; // 신청일
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
	 	            sortField = "CONG_DATE"; //신청일
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

            req.setAttribute( "page", page );
            req.setAttribute( "E20CongcondData_dis", E20CongcondData_dis );

            dest = WebUtil.JspURL+"E/E20Congra/E20CongraList_"+dest_deail+".jsp";
//            }
            Logger.debug.println(this, " destributed = " + dest + "  page : "+ page);
            printJspPage(req, res, dest);

        } catch(Exception e) {
            throw new GeneralException(e);
        }
	}
}