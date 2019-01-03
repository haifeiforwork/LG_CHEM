/********************************************************************************/
/*	  System Name  	: g-HR
/*   1Depth Name		: Application
/*   2Depth Name  	: Benefit Management
/*   Program Name 	: Language Fee
/*   Program ID   		: E23LanguageAjax2
/*   Description  		: Language 지원금 신청을 하는 Class
/*   Note         		:
/*   Creation     		:
/*   Update       		: 2010-01-21 jungin @v1.0 [C20100120_96671] Payment Rate 출력 및 로직 처리.
 *   Update       		: 2010-12-22 liukuo @v1.0 [C20101222_94456] Payment Amount计算逻辑修改.
 */
/********************************************************************************/

package servlet.hris.E.Global.E23Language;

import hris.common.rfc.CurrencyChangeRFC;

import java.io.IOException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.WebUtil;

public class E23LanguageAjax2 extends EHRBaseServlet{

	@Override
	protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {
		// TODO Auto-generated method stub

		try {
			String waers1	= req.getParameter("waers1");
			String waers2	= req.getParameter("waers2");
			String betrg		= req.getParameter("betrg");

			CurrencyChangeRFC rfc = new CurrencyChangeRFC();

			String total = rfc.getCurrencyChange(waers1, waers2, betrg);
			String exRate = rfc.getExchangeRate(waers1, waers2, betrg); // add by liukuo 2010.12.21
			Logger.debug.println("total:"+total);
			Logger.debug.println("exRate:"+exRate);

			res.getWriter().println("<input type=\"text\" id=\"REIM_AMTH\" name=\"REIM_AMTH\" style=\"text-align:right;\" value=\"" + WebUtil.printNumFormat(total, 2)
											+ "\" class=\"noBorder\" readonly>&nbsp;<input type=\"text\" name=\"REIM_WAR2\" value=\"" + waers2 + "\" class=\"noBorder\"  size=\"4\" readonly >|"+exRate);

		} catch (IOException e) {
			// TODO Auto-generated catch block
			Logger.error(e);
		}
	}


}