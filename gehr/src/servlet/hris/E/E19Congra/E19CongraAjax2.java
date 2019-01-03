package servlet.hris.E.E19Congra;

import hris.E.E19Congra.rfc.E19CongraRFC;
import hris.common.util.AppUtil;

import java.io.IOException;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.WebUtil;

public class E19CongraAjax2 extends EHRBaseServlet {

	@Override
	protected void performTask(HttpServletRequest req, HttpServletResponse res)
			throws GeneralException {

		if (req.getParameter("Itype") != null) {

			String PERNR = req.getParameter("PERNR");
			String CELTY = req.getParameter("CELTY");

			E19CongraRFC rfc_congra = new E19CongraRFC();
			Vector famyCode = rfc_congra.getEntryCode(PERNR, "", CELTY);
			StringBuffer sb = new StringBuffer();
			sb.append("<select name=\"FAMY_CODE\"  onChange=\"ajax_change(this.options[this.options.selectedIndex].value)\">");
			sb.append("<option value=\"\">Select</option>");
			sb.append(AppUtil.escape(WebUtil.printOption((Vector) famyCode.get(3), "")));
			sb.append("</select>");
			Logger.debug.println(sb.toString());
			try {
				res.getWriter().println(sb.toString());
			} catch (IOException e) {

				// TODO Auto-generated catch block
				Logger.error(e);
			}
		}
	}
}
