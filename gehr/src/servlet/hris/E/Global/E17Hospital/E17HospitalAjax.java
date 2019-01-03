package servlet.hris.E.Global.E17Hospital;

import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.WebUtil;
import hris.common.rfc.CurrencyChangeRFC;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class E17HospitalAjax extends EHRBaseServlet {
	protected void performTask(HttpServletRequest req, HttpServletResponse res)
	throws GeneralException {
		try {
			String waers1=req.getParameter("waers1");
			String waers2=req.getParameter("waers2");
			String betrg=req.getParameter("betrg");
			CurrencyChangeRFC rfc = new CurrencyChangeRFC();
			String total = rfc.getCurrencyChange(waers1, waers2, betrg);
			res.getWriter().println("<input type=\"text\" id=\"PAAMT\" name=\"PAAMT\" style=\"text-align:right;\"  class=\"noBorder\" value=\""+WebUtil.printNumFormat(total,2)+"\" size=\"10\" readonly>&nbsp;<input type=\"text\" name=\"WAERS3\" class=\"noBorder\" value=\""+ waers2+ "\" size=\"4\" readonly ><input type=\"hidden\" name=\"CERT_BETG_C\" style=\"text-align:right;\" size=\"10\" readonly value=\""+WebUtil.printNumFormat(total,2)+"\">");
			} catch (IOException e) {
				// TODO Auto-generated catch block
			Logger.error(e);
			}
		}
}