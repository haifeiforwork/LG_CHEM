package servlet.hris.E.Global.E21Expense;

import hris.E.Global.E21Expense.E21ExpenseStructData;
import hris.E.Global.E21Expense.rfc.E21ExpenseRFC;

import java.io.IOException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.WebUtil;

public class E21ExpenseAjax  extends EHRBaseServlet {
	protected void performTask(HttpServletRequest req, HttpServletResponse res)
	throws GeneralException {
		try {
			String WAERS = req.getParameter("WAERS");
			String PERNR = req.getParameter("PERNR");
			String BEGDA = req.getParameter("BEGDA");
			String SUBTY = req.getParameter("SUBTY");
			String SCHL_TYPE = req.getParameter("SCHL_TYPE");
			String SCHL_NAME = req.getParameter("SCHL_NAME");
			String OBJPS = req.getParameter("OBJPS");
			E21ExpenseRFC rfc = new E21ExpenseRFC();
			E21ExpenseStructData data = rfc.displayData(PERNR, SUBTY, SCHL_TYPE, SCHL_NAME, BEGDA, WAERS,OBJPS);
			StringBuffer tem = new StringBuffer();
			tem.append("<input type=\"text\" style=\"text-align:right;\" name=\"REIM_CNTH_REST\" value=\""+WebUtil.printNum(data.REIM_CNTH_REST)+"\" size=\"2\" class=\"noBorder\" readonly>");
			if(data.REIM_AMTH_REST!=null&&(!data.REIM_AMTH_REST.equals(""))&&(!data.REIM_AMTH_REST.equals("0"))){
				tem.append("|");
				tem.append("Balance");
			}else{
				tem.append("|");
				tem.append("");
			}
			tem.append("|");
			tem.append("<input type=\"text\" style=\"text-align:right;\" name=\"REIM_AMTH_REST\" value=\""+ (data.REIM_AMTH_REST.equals("0") ? "" : WebUtil.printNum(data.REIM_AMTH_REST))+"\" size=\"20\" class=\"noBorder\" readonly>");
			tem.append("|");
			tem.append("<input type=\"text\" style=\"text-align:right;\" name=\"WAERS\" value=\""+data.WAERS+"\" size=\"4\" class=\"noBorder\" readonly>");
			tem.append("|");
			tem.append("<input type=\"text\" style=\"text-align:right;\" name=\"REIM_RAT1\" value=\""+WebUtil.printNum(data.REIM_RATE)+"\" class=\"noBorder\" size=\"4\" readonly>");
			tem.append("|");
			tem.append("<input type=\"text\" style=\"text-align:right;\" name=\"REIM_RAT2\" value=\""+WebUtil.printNum(data.REIM_RATE)+"\" class=\"noBorder\" size=\"4\" readonly>");
			tem.append("|");
			tem.append("<input type=\"text\" style=\"text-align:right;\" name=\"REIM_RAT3\" value=\""+WebUtil.printNum(data.REIM_RATE)+"\" class=\"noBorder\" size=\"4\" readonly>");
			tem.append("|");
			tem.append("<input type=\"text\" style=\"text-align:right;\" name=\"REIM_RAT4\" value=\""+WebUtil.printNum(data.REIM_RATE)+"\" class=\"noBorder\" size=\"4\" readonly>");
			tem.append("|");
			tem.append("<input type=\"text\" style=\"text-align:right;\" name=\"REIM_RAT5\" value=\""+WebUtil.printNum(data.REIM_RATE)+"\" class=\"noBorder\" size=\"4\" readonly>");
			if(!((data.WAERS==null)||(data.WAERS.equals("")))){
				tem.append("|");
				tem.append(g.getMessage("LABEL.E.E21.0024"));  // Effective&nbsp;Balance
			}else{
				tem.append("|");
				tem.append("");
			}
			if(!((data.WAERS==null)||(data.WAERS.equals("")))){
				tem.append("|");
				tem.append("<input type=\"text\" id=\"CERT_BETG_C\" style=\"text-align:right;\" name=\"CERT_BETG_C\" value=\"\" class=\"noBorder\" size=\"10\" readonly>&nbsp;&nbsp;&nbsp;<input type=\"text\" name=\"cmoney\" value=\""+data.WAERS+"\" size=\"4\" class=\"noBorder\" readonly>");
			}else{
				tem.append("|");
				tem.append("");
			}
			tem.append("|");
			tem.append("<input type=\"hidden\" name=\"REIM_CONT\" value=\""+WebUtil.printNum(data.REIM_CONT)+"\" >" +
					"<input type=\"hidden\" name=\"REIM_CNTH\" value=\""+WebUtil.printNum(data.REIM_CNTH)+"\" >" +
					"<input type=\"hidden\" name=\"REIM_AMT\" value=\""+WebUtil.printNum(data.REIM_AMT)+"\">" +
					"<input type=\"hidden\" name=\"REIM_AMTH\" value=\""+WebUtil.printNum(data.REIM_AMTH)+"\">");
			if(SUBTY.equals("0001")){
				tem.append("|");
				tem.append(g.getMessage("LABEL.E.E21.0025")+" <font color=\"#006699\"><b>*</b></font>"); // Attached
			}else{
				tem.append("|");
				tem.append("");
			}
			if(SUBTY.equals("0001")){
				tem.append("|");
				tem.append("<input type=\"radio\" name=\"ATTC_NORL\" value=\"N\" onclick=\"javascript:ajax_change()\" checked>"+g.getMessage("LABEL.E.E21.0026")+"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type=\"radio\" name=\"ATTC_NORL\" value=\"A\" onclick=\"javascript:attachmentChange();\">"+g.getMessage("LABEL.E.E21.0025")+"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"); // LABEL.E.E21.0026:Normal/ LABEL.E.E21.002: Attached
			}else{
				tem.append("|");
				tem.append("");
			}
			res.getWriter().println(tem);
		} catch(Exception ex){
            //Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
		}
	}
}
