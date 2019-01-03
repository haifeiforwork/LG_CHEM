package servlet.hris.E.Global.E21Expense;

import hris.common.rfc.CurrencyChangeRFC;

import java.io.IOException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.WebUtil;

public class E21ExpenseAjax1  extends EHRBaseServlet {
	protected void performTask(HttpServletRequest req, HttpServletResponse res)
	throws GeneralException {
		try {
			String waers1=req.getParameter("waers1");
			String waers2=req.getParameter("waers2");
			String betrg=req.getParameter("betrg");
			CurrencyChangeRFC rfc = new CurrencyChangeRFC();
			String total = rfc.getCurrencyChange(waers1, waers2, betrg);
			res.getWriter().println("<input type=\"text\" id=\"CERT_BETG_C\"  name=\"CERT_BETG_C\" style=\"text-align:right;\" class=\"noBorder\" value=\""+WebUtil.printNumFormat(total,2)+"\" size=\"10\" readonly>&nbsp;&nbsp;&nbsp;<input type=\"text\" name=\"cmoney\" value=\""+waers2+"\" size=\"4\" class=\"noBorder\" readonly>");
		} catch(Exception ex){
            //Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
			}
		}
}