/********************************************************************************/
/*	  System Name  	: g-HR
/*   1Depth Name		: Application
/*   2Depth Name  	: Benefit Management
/*   Program Name 	: Medical Fee
/*   Program ID   		: E17HospitalAjax3
/*   Description  		: 보험 가입여부에 따른 금액 조회 Class
/*   Note         		:
/*   Creation    		: 2002-05-25 jungin @v1.0 [C20090514_56175] 보험가입 여부 'ZINSU' 필드 추가.
/********************************************************************************/

package servlet.hris.E.Global.E17Hospital;

import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;
import hris.E.Global.E17Hospital.E17HospitalDetailData;
import hris.E.Global.E17Hospital.rfc.E17HospitalDetailRFC;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Vector;

public class E17HospitalAjax3 extends EHRBaseServlet {
	protected void performTask(HttpServletRequest req, HttpServletResponse res)
	throws GeneralException {

		try {
			String PERNR	= req.getParameter("PERNR");
			String ZINSU	= req.getParameter("ZINSU");
			String BEGDA	= req.getParameter("BEGDA");
			String WAERS	= req.getParameter("WAERS");

			BEGDA = req.getParameter("BEGDA");
			if (BEGDA.equals("")) {
				BEGDA = DataUtil.getCurrentDate();
			} // end if

			WAERS = req.getParameter("WAERS");
			if (WAERS.equals("")) {
				WAERS = "RMB";
			} // end if

			E17HospitalDetailRFC hd_rfc = new E17HospitalDetailRFC();

			Vector sum = hd_rfc.getMediData(PERNR, ZINSU, "", "5", BEGDA, WAERS);

			E17HospitalDetailData hdata = (E17HospitalDetailData)sum.get(0);
			String wtem = (String)sum.get(1);

			StringBuffer tem = new StringBuffer();

			tem.append("<input type=\"text\" id=\"PAMT\" name=\"PAMT_BALANCE\" style=\"text-align:right;\"  value=\""+WebUtil.printNumFormat(hdata.PAMT_BALANCE, 2)+"\" class=\"noBorder\" size=\"10\" readonly>");
			tem.append("|");
			tem.append("<input type=\"text\" id=\"PAMT1\" name=\"PAAMT_BALANCE\" style=\"text-align:right;\"  value=\""+WebUtil.printNumFormat(hdata.PAAMT_BALANCE, 2)+"\" class=\"noBorder\" size=\"10\" readonly><input type=\"hidden\" name=\"PLIMIT\" id=\"PLIMIT\" style=\"text-align:right;\"  value=\""+WebUtil.printNumFormat(hdata.PLIMIT, 2)+"\" size=\"10\" readonly>");

			res.getWriter().println(tem);

		} catch (IOException e) {
			// TODO Auto-generated catch block
			Logger.error(e);
		}
	}

}