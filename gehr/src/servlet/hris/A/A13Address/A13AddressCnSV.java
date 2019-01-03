package servlet.hris.A.A13Address;

import com.sns.jdf.GeneralException;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.WebUtil;
import hris.common.rfc.SearchAddrRFCCn;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Vector;

public class A13AddressCnSV extends EHRBaseServlet {
	protected void performTask(HttpServletRequest req, HttpServletResponse res)
			throws GeneralException {
		try {
			String jobid = "";
			String dest = "";

			Box box = WebUtil.getBox(req);
			jobid = box.get("jobid");

			if (jobid.equals("getcode1")) {
				String PRVNCD = box.get("PRVNCD1");
				if(!PRVNCD.equals("")){
					Vector ZipCodeData_vt = (new SearchAddrRFCCn()).getAddrDetail("2", "", PRVNCD, "", "");

					req.setAttribute("citycd", ZipCodeData_vt);
				}
				
				dest = WebUtil.JspURL + "A/A13Address/A13Hidden1.jsp";
			}else if(jobid.equals("getcode2")){
				String PRVNCD = box.get("PRVNCD1");
				String CITYCD = box.get("CITYCD1");
				if( (!PRVNCD.equals(""))&&(!CITYCD.equals("")) ){

				Vector cntycd = (new SearchAddrRFCCn()).getAddrDetail("3", "", PRVNCD, CITYCD, "");
				req.setAttribute("cntycd", cntycd);
				}
				dest = WebUtil.JspURL + "A/A13Address/A13Hidden2.jsp";
				
			}
			printJspPage(req, res, dest);
		} catch (Exception e) {
			throw new GeneralException(e);
		}
	}
}