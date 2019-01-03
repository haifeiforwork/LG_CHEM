/********************************************************************************/
/*	  System Name  	: g-HR
/*   1Depth Name		: Application
/*   2Depth Name  	: Benefit Management
/*   Program Name 	: Language Fee
/*   Program ID   		: E23LanguageAjax
/*   Description  		: Language 지원금 신청을 하는 Class
/*   Note         		:
/*   Creation     		:
/*   Update       		: 2009-09-11 jungin @v1.0 [C20090911_23467] ZMONTH_TOT 항목 수정.
/*							: 2010-01-21 jungin @v1.1 [C20100120_96671] Payment Rate 출력 및 로직 처리.
/*							: 2010-06-25 jungin @v1.2 [C20100617_86310] Monthly Payment Limit 금액 계산.
/********************************************************************************/

package servlet.hris.E.Global.E23Language;

import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.CodeEntity;
import com.sns.jdf.util.WebUtil;
import hris.E.Global.E23Language.E23LanguageData;
import hris.E.Global.E23Language.E23LanguageData3;
import hris.E.Global.E23Language.rfc.E23LanguageRFC;
import hris.common.util.AppUtil;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Vector;

public class E23LanguageAjax extends EHRBaseServlet {

	@Override
	protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {

		if(req.getParameter("Itype") != null) {

			try {
				String I_type 		= req.getParameter("Itype");
				String PERNR 		= req.getParameter("PERNR");
				String REIM_WAR = req.getParameter("REIM_WAR");

				String fnames 		= "";
				String ftname 		= "";
				//String FAMI_CODE = req.getParameter("FAMI_CODE");

				E23LanguageRFC rfc_lang = new E23LanguageRFC();

				if(I_type.equals("01")) {	// Employee
					String names	= rfc_lang.getLanguageName(PERNR, "1", "01", "");
					Vector ftype 	= rfc_lang.getLanguageDetail(PERNR, "5", "", ""); //rfc_lang.getLanguageDetail(PERNR, "2", "", "");
					Vector ldata 	= rfc_lang.getLanguageDetail1(PERNR, "5", "01", "", "");

					E23LanguageData data = (E23LanguageData)ldata.get(0);
					res.getWriter().println("");
					res.getWriter().println("|");
					res.getWriter().println("<input type=\"text\" name=\"ENAME\" value=\"" + AppUtil.escape(names) + "\" class=\"noBorder\" size=\"60\" readonly >");
					res.getWriter().println("|");
					res.getWriter().println("<input type=\"text\" id=\"REIM_AMT\" name=\"REIM_AMT\"  value=\"" + WebUtil.printNumFormat(data.REIM_AMT, 2)
													+ "\" class=\"noBorder\" style=\"text-align:right;\" size=\"20\" readonly>&nbsp;<input type=\"text\" name=\"WAERS1\" value=\""
													+ data.WAERS1 + "\" class=\"noBorder\"  size=\"4\" readonly >");
					res.getWriter().println("|");
					res.getWriter().println("<input type=\"text\" name=\"ZMONTH_REST\" style=\"text-align:right;\" value=\"" + data.ZMONTH_REST + "\" class=\"noBorder\" size=\"1\" readonly >");
					res.getWriter().println("|");
					res.getWriter().println("<input type=\"text\" id=\"REIM_AMTH\" name=\"REIM_AMTH\" style=\"text-align:right;\" value=\"" + WebUtil.printNumFormat(data.REIM_AMTH, 2)
													+ "\" class=\"noBorder\" readonly>&nbsp;<input type=\"text\" name=\"REIM_WAR2\" value=\""
													+ data.WAERS1 + "\" class=\"noBorder\"  size=\"4\" readonly >");
					res.getWriter().println("|");
					res.getWriter().println("<input type=\"text\" name=\"REIM_WAR3\" value=\"" + data.REIM_WAR + "\" class=\"noBorder\" size=\"1\" readonly >");
					res.getWriter().println("|");
					res.getWriter().println("<input type=\"text\" name=\"REIM_WAR\" value=\"" + data.REIM_WAR + "\" class=\"noBorder\" size=\"1\" readonly >");
					res.getWriter().println("|");
					res.getWriter().println("<input type=\"hidden\" name=\"REIM_RAT\"  value=\"" + data.REIM_RAT + "\" class=\"noBorder\" >");
					res.getWriter().println("|");
					res.getWriter().println("Monthly Payment Limit");
					res.getWriter().println("|");
					res.getWriter().println("Converted Payment");
					res.getWriter().println("|");
					res.getWriter().println("<input type=\"text\" name=\"COUR_PRID\"  style=\"text-align:right;\" value=\"1\" class=\"input03\" size=\"4\" maxlength=\"3\"  onkeypress=\"onlyNumber1(this);\" onBlur=\"PeriodChange(document.form1.COUR_PRID.value);\">");
					res.getWriter().println("|");
					res.getWriter().println("<input type=\"hidden\" name=\"ZMONTH_TOT\" value=\"" + data.ZMONTH_TOT + "\" >");		//2009-09-11 jungin
					res.getWriter().println("|");
					res.getWriter().println("Payment Rate");
					res.getWriter().println("|");
					res.getWriter().println("<input type=\"text\" id=\"reim_rat\" name=\"reim_rat\" value=\"" + WebUtil.printNum(data.REIM_RAT) + "\" class=\"noBorder\" style=\"text-align:right;\" size=\"1\" readonly >");
					res.getWriter().println("|");
					res.getWriter().print("");

				} else {

					Vector ftype = rfc_lang.getLanguageDetail(PERNR, "5", "", "");// rfc_lang.getLanguageDetail(PERNR, "5", "", "");
					Vector codename = (Vector)ftype.get(1);
					CodeEntity centity = new CodeEntity();

					if(codename.size() > 0) {	// Dependents
						centity = (CodeEntity)codename.get(0);
						Vector names = rfc_lang.getLanguageDetail(PERNR, "1", "02", centity.code);
						Vector name1 = (Vector)names.get(2);

						String obj	= "";
						String objps	= "";

						if(name1.size() > 0){

							if(name1.size() == 1){
								E23LanguageData3 fname = (E23LanguageData3)name1.get(0);
								fnames = "<input type=\"text\" name=\"ENAME\"  value=\""	+ AppUtil.escape(fname.FANAM + " " + fname.FAVOR) + "\" class=\"noBorder\"   size=\"60\" readonly >";
							}else{
								obj = ((E23LanguageData3)name1.get(0)).OBJPS;
								fnames = "<select name=\"ENAME\" style=\"width:135px;\" onChange=\"ajax_change3(this.options.selectedIndex);\" >";

								for(int i=0; i<name1.size(); i++){
									E23LanguageData3 ndata = (E23LanguageData3)name1.get(i);
									fnames	+= "<option value=\"" + AppUtil.escape(ndata.FANAM + "" + ndata.FAVOR)+"\">" + AppUtil.escape(ndata.FANAM + " " + ndata.FAVOR)+"</option>";
									objps		+= "<input type=\"hidden\" name=\"objps" + i + "\" value=\"" + ndata.OBJPS+"\">";
								}
								fnames += "</select>";
							}
						}else{
							fnames = "";
						}

						Vector ldata = rfc_lang.getLanguageDetail1(PERNR, "5", "02", centity.code, obj);

						E23LanguageData data = (E23LanguageData)ldata.get(0);

						if(data != null){
							ftname = "<select name=\"FAMI_CODE\" style=\"width:135px;\" onChange=\"ajax_change1(this.options[this.options.selectedIndex].value)\" >";
							ftname += WebUtil.printOption((Vector)ftype.get(1), data.FAMI_CODE);
							ftname += "</select>";

						}else{
							ftname = "";
							data = new E23LanguageData();
						}

						res.getWriter().println(ftname);
						res.getWriter().println("|");
						res.getWriter().println(fnames);
						res.getWriter().println(objps);
						res.getWriter().println("|");
						res.getWriter().println("<input type=\"text\" id=\"REIM_AMT\" name=\"REIM_AMT\"  value=\"" + WebUtil.printNumFormat(data.REIM_AMT, 2)
														+ "\" class=\"noBorder\" style=\"text-align:right;\" size=\"20\" readonly>&nbsp;<input type=\"text\" name=\"WAERS1\" value=\""
														+ data.WAERS1 + "\" class=\"noBorder\"  size=\"4\" readonly >");
						res.getWriter().println("|");
						res.getWriter().println("<input type=\"text\" name=\"ZMONTH_REST\" style=\"text-align:right;\" value=\"" + data.ZMONTH_REST + "\" class=\"noBorder\" size=\"1\" readonly>");
						res.getWriter().println("|");
						res.getWriter().println("<input type=\"text\" id=\"REIM_AMTH\" name=\"REIM_AMTH\" style=\"text-align:right;\" value=\"" + WebUtil.printNumFormat(data.REIM_AMTH, 2)
														+ "\" class=\"noBorder\" readonly>&nbsp;<input type=\"text\" name=\"REIM_WAR2\" value=\""
														+ data.WAERS1 + "\" class=\"noBorder\"  size=\"4\" readonly >");
						res.getWriter().println("|");
						res.getWriter().println("<input type=\"text\" name=\"REIM_WAR3\" value=\"" + data.REIM_WAR + "\" class=\"noBorder\" size=\"1\" readonly >");
						res.getWriter().println("|");
						res.getWriter().println("<input type=\"text\" name=\"REIM_WAR\" value=\"" + data.REIM_WAR + "\" class=\"noBorder\" size=\"1\" readonly >");
						res.getWriter().println("|");
						res.getWriter().println("<input type=\"hidden\" name=\"REIM_RAT\"  value=\"" + data.REIM_RAT + "\" class=\"noBorder\" >");
						res.getWriter().println("|");
						res.getWriter().println("Payment Limit");
						res.getWriter().println("|");
						res.getWriter().println("Converted Payment");
						res.getWriter().println("|");
						res.getWriter().println("<input type=\"text\" name=\"COUR_PRID\"  style=\"text-align:right;\" value=\"\" size=\"4\" maxlength=\"3\"  onkeypress=\"onlyNumber1(this);\" onBlur=\"PeriodChange(document.form1.COUR_PRID.value);\">");
						res.getWriter().println("|");
						res.getWriter().println("<input type=\"hidden\" name=\"ZMONTH_TOT\" value=\"" + data.ZMONTH_TOT + "\" >");		//2009-09-11 jungin
						res.getWriter().println("|");
						res.getWriter().println("Payment Rate");
						res.getWriter().println("|");
						res.getWriter().println("<input type=\"text\" id=\"reim_rat\" name=\"reim_rat\" value=\"" + WebUtil.printNum(data.REIM_RAT) + "\" class=\"noBorder\" style=\"text-align:right;\" size=\"1\" readonly >");
						res.getWriter().println("|");
						res.getWriter().print("");

					}else{
						res.getWriter().print("");
					}
				}

			} catch (IOException e) {
				Logger.error(e);
			}

		}

	}

}
