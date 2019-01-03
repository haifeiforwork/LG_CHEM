package servlet.hris.A.A14Bank;

import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.WebUtil;
import hris.A.A14Bank.A14BankCodeData;
import hris.A.A14Bank.rfc.A14BankCodeRFC;
import hris.A.A14Bank.rfc.A14BankProvinceRFC;
import hris.common.util.AppUtil;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Vector;

public class A14BankAjax  extends EHRBaseServlet {
	protected void performTask(HttpServletRequest req, HttpServletResponse res)
	throws GeneralException {
		try {
		String code = req.getParameter("code");
		String pernr = req.getParameter("PERNR");
		String STATE1 = req.getParameter("STATE1");
		  Logger.debug.println("code+pernr:::"+code+","+pernr);
		  
		String I_LAND1 = "";
		A14BankCodeRFC brfc = new A14BankCodeRFC();
		Vector cvalue = brfc.getBankValue(pernr);
		for(int i=0;i<cvalue.size();i++){
			A14BankCodeData cdata= (A14BankCodeData)cvalue.get(i);
			if(cdata.ZBANKL.equals(code)){
				I_LAND1 = cdata.ZBANKS;
			}
		}
		
		
		A14BankProvinceRFC hrfc= new A14BankProvinceRFC();
		Vector hdata = hrfc.getProvinceCode(I_LAND1);
		String msg1 = "<input type=\"hidden\" name=\"ZBANKS\" value=\""+I_LAND1 +"\">";
		res.getWriter().println("<select name=\"STATE1\" class=\"required\"    placeholder=\'"+g.getMessage("MSG.A.A14.0012")+"\' >");
		res.getWriter().println("<option value=\"\">Select</option>");
		res.getWriter().println(AppUtil.escape(WebUtil.printOption(hdata ,STATE1)));
		res.getWriter().println("</select>");
		res.getWriter().println(msg1);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			Logger.error(e);
		}
	}
}
