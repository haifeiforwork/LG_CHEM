/********************************************************************************/
/*	  System Name  	: g-HR
/*   1Depth Name		: Application
/*   2Depth Name  	: Benefit Management
/*   Program Name 	: Language Fee
/*   Program ID   		: E23LanguageAjax3
/*   Description  		: Language 지원금 신청을 하는 Class
/*   Note         		:
/*   Creation     		:
/*   Update       		: 2010-01-21 jungin @v1.0 [C20100120_96671] Payment Rate 출력 및 로직 처리.
/********************************************************************************/

package servlet.hris.E.Global.E23Language;

import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.WebUtil;
import hris.E.Global.E23Language.E23LanguageData;
import hris.E.Global.E23Language.rfc.E23LanguageRFC;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Vector;

public class E23LanguageAjax3 extends EHRBaseServlet{

	protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {
		// TODO Auto-generated method stub

		if(req.getParameter("Itype") != null){

			try {
				String I_type			= req.getParameter("Itype");
				String PERNR			= req.getParameter("PERNR");
				String objps				= req.getParameter("objps");
				//String FAMI_CODE	= req.getParameter("FAMI_CODE");

				E23LanguageRFC rfc_lang = new E23LanguageRFC();

				Vector ftype	= rfc_lang.getLanguageDetail(PERNR, "5", "", "");//rfc_lang.getLanguageDetail(PERNR, "2", "", "");
				Vector ldata	= rfc_lang.getLanguageDetail1(PERNR, "5", "02", I_type,objps);

	            E23LanguageData data = (E23LanguageData)ldata.get(0);

				res.getWriter().println("<input type=\"text\" id=\"REIM_AMT\" name=\"REIM_AMT\"  value=\"" + WebUtil.printNumFormat(data.REIM_AMT, 2)
												+ "\" class=\"noBorder\" style=\"text-align:right;\" size=\"20\" readonly>&nbsp;<input type=\"text\" name=\"WAERS1\" value=\""
												+ data.WAERS1 + "\" class=\"noBorder\"  size=\"4\" readonly >");
				res.getWriter().println("|");
				res.getWriter().println("<input type=\"text\" name=\"ZMONTH_REST\" value=\"" + data.ZMONTH_REST + "\" style=\"text-align:right;\" class=\"noBorder\" size=\"1\" readonly>");
				res.getWriter().println("|");
				res.getWriter().println("<input type=\"hidden\" name=\"WAERS9\" value=\"" + data.WAERS1 + "\">");

			} catch (IOException e) {
				Logger.error(e);
			}

		}
	}
}
