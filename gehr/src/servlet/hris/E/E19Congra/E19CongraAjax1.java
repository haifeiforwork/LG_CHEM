package servlet.hris.E.E19Congra;

import hris.E.E19Congra.rfc.E19CongraRFC;

import java.io.IOException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.EHRBaseServlet;



public class E19CongraAjax1 extends EHRBaseServlet {

	@Override
	protected void performTask(HttpServletRequest req, HttpServletResponse res)
			throws GeneralException {
		// TODO Auto-generated method stub
		String PERNR = req.getParameter("PERNR");
		String CELTY = req.getParameter("CELTY");
		String FAMSA = req.getParameter("FAMSA");
		String FAMY_CODE = req.getParameter("FAMY_CODE");
		String OBJPS = req.getParameter("OBJPS");
		E19CongraRFC rfc_congra = new E19CongraRFC();
		String check = rfc_congra.getCheck(PERNR, CELTY, FAMY_CODE, FAMSA, OBJPS);

		try {

			res.getWriter().print(check);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			Logger.error(e);
		}


	}

}
