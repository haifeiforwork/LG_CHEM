/********************************************************************************/
/*	  System Name  	: g-HR
/*   1Depth Name		: Application
/*   2Depth Name  	: Benefit Management
/*   Program Name 	: Language Fee
/*   Program ID   		: E23LanguageAjax1
/*   Description  		: Language 지원금 신청을 하는 Class
/*   Note         		:
/*   Creation     		:
/*   Update       		: 2010-01-21 jungin @v1.0 [C20100120_96671] Payment Rate 출력 및 로직 처리.
/*							: 2010-06-25 jungin @v1.1 [C20100617_86310] Monthly Payment Limit 금액 계산.
/*							: 2011-05-11 lixinxin @v1.2 [C20120510_06459] 语言费申请有问题，当申请人的有一个小孩是，申请不了语言费		            */
/*							                             解决办法：(1)当第一次登陆语言费申请画面的时候，为该页面返回objps_ost变量，此变量的作用是避免直接去取form表单里面的objps_one得值时报错，如果objps_ost有值，则说明form表单里的objps_one现在还没有不能直接取值*/
/*																				  (2)当Family Type发生变化时走change事件,此时将objps_ost清空，程序就会checkfrom表单里的objps_one是否有值，并传到后台去。此功能修复
/*                         :2015-02-26 hehongyan @v1.3 [C20150213_06709]  E-HR语言学费界面异常,E-HR language fee 申请界面中剩余月数显示不正确 		            */
/*
/*
/*
*/

/********************************************************************************/

package servlet.hris.E.Global.E23Language;

import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.WebUtil;
import hris.E.Global.E23Language.E23LanguageData;
import hris.E.Global.E23Language.E23LanguageData3;
import hris.E.Global.E23Language.rfc.E23LanguageRFC;
import hris.common.util.AppUtil;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Vector;

public class E23LanguageAjax1 extends EHRBaseServlet{

	protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {
		// TODO Auto-generated method stub

		if(req.getParameter("Itype") != null){

			try {
				String I_type			= req.getParameter("Itype");
				String PERNR			= req.getParameter("PERNR");
				String REIM_WAR 	= req.getParameter("REIM_WAR");
				//String FAMI_CODE	= req.getParameter("FAMI_CODE");

				E23LanguageRFC rfc_lang = new E23LanguageRFC();

				Vector names =  rfc_lang.getLanguageDetail(PERNR, "1", "02", I_type);
				Vector name1 = (Vector)names.get(2);

				String obj = "";

				E23LanguageData3 fname = new E23LanguageData3();

				if(name1.size() == 1){
					fname =	(E23LanguageData3)name1.get(0);
					//begin 2015-02-26  hehongyan @v1.3 [C20150213_06709 ] add
					obj = fname.OBJPS;
					//end 2015-02-26  hehongyan @v1.3 [C20150213_06709 ]
				}else if(name1.size() > 1){
					obj = ((E23LanguageData3)name1.get(0)).OBJPS;
				}

				Vector ftype	= rfc_lang.getLanguageDetail(PERNR, "5", "", "");//rfc_lang.getLanguageDetail(PERNR, "2", "", "");
				Vector ldata	= rfc_lang.getLanguageDetail1(PERNR, "5", "02", I_type, obj);

				E23LanguageData data = (E23LanguageData)ldata.get(0);
				String objps = "";
				String objps_one = "";
				res.getWriter().println("<select name=\"FAMI_CODE\" style=\"width:135px;\"  onChange=\"ajax_change1(this.options[this.options.selectedIndex].value)\">");
				res.getWriter().println(WebUtil.printOption((Vector)ftype.get(1), data.FAMI_CODE));
				res.getWriter().println("</select>");
				res.getWriter().println("|");
				if(name1.size() == 1){
					res.getWriter().println("<input type=\"text\" name=\"ENAME\"  value=\""+ AppUtil.escape(fname.FANAM + "" + fname.FAVOR) + "\" class=\"noBorder\" size=\"60\" readonly >");
//					 2011-05-11 lixinxin @v1.2 [C20120510_06459] row 2
					objps_one = "<input type=\"hidden\" name=\"objps_one\" value=\"" + fname.OBJPS + "\" >";
					res.getWriter().println(objps_one);
				}else if(name1.size() > 1){
					res.getWriter().println("<select name=\"ENAME\" style=\"width:135px;\"onChange=\"ajax_change3(this.options.selectedIndex);\" >");

					for(int i=0; i<name1.size(); i++){
						E23LanguageData3 ndata =(E23LanguageData3)name1.get(i);
						String str	= "<option value=\"" + AppUtil.escape(ndata.FANAM + "" + ndata.FAVOR) + "\">" + AppUtil.escape(ndata.FANAM + "" + ndata.FAVOR) + "</option>";
						objps 		+= "<input type=\"hidden\" name=\"objps" + i + "\" value=\"" + ndata.OBJPS + "\" >";
						res.getWriter().println(str);
					}
//					 2011-05-11 lixinxin @v1.2 [C20120510_06459] row 1
					objps += "<input type=\"hidden\" name=\"objps_one\" value=\"" +objps_one + "\" >";
					res.getWriter().println("</select>");
					res.getWriter().println(objps);
				}
				res.getWriter().println("|");

				res.getWriter().println("<input type=\"text\" id=\"REIM_AMT\" name=\"REIM_AMT\"  value=\"" + WebUtil.printNumFormat(data.REIM_AMT, 2)
												+ "\" class=\"noBorder\" style=\"text-align:right;\" size=\"20\" readonly>&nbsp;<input type=\"text\" name=\"WAERS1\" value=\""
												+ data.WAERS1 + "\" class=\"noBorder\"  size=\"4\" readonly >");
				res.getWriter().println("|");
				res.getWriter().println("<input type=\"text\" name=\"ZMONTH_REST\" style=\"text-align:right;\" value=\"" + data.ZMONTH_REST+"\" class=\"noBorder\" size=\"1\" readonly >");
				res.getWriter().println("|");
				res.getWriter().println("<input type=\"text\" id=\"REIM_AMTH\" name=\"REIM_AMTH\" style=\"text-align:right;\" value=\"" + WebUtil.printNumFormat(data.REIM_AMTH, 2)
												+ "\" class=\"noBorder\" readonly>&nbsp;<input type=\"text\" name=\"REIM_WAR2\" value=\""
												+ data.WAERS1 + "\" class=\"noBorder\"  size=\"4\" readonly >");
				res.getWriter().println("|");
				res.getWriter().println("<input type=\"text\" name=\"REIM_WAR3\" value=\"" + data.REIM_WAR + "\" class=\"noBorder\" size=\"1\" readonly >");
				res.getWriter().println("|");
				res.getWriter().println("<input type=\"text\" name=\"REIM_WAR\" value=\"" + data.REIM_WAR + "\" class=\"noBorder\" size=\"1\" readonly >");
				res.getWriter().println("|");
				res.getWriter().println("<input type=\"hidden\" name=\"REIM_RAT\" value=\"" + data.REIM_RAT +"\" class=\"noBorder\" style=\"text-align:right;\" >");
				res.getWriter().println("|");
				res.getWriter().println("Payment Limit");
				res.getWriter().println("|");
				res.getWriter().println("Converted Payment");
				res.getWriter().println("|");
				res.getWriter().println("<input type=\"text\" name=\"COUR_PRID\"  style=\"text-align:right;\" value=\"\" class=\"input03\" size=\"4\" maxlength=\"3\"  onkeypress=\"onlyNumber1(this);\" onBlur=\"PeriodChange(document.form1.COUR_PRID.value);\">");
				res.getWriter().println("|");
				res.getWriter().println("<input type=\"hidden\" name=\"WAERS9\" value=\"" + data.WAERS1 +"\" >");
				res.getWriter().println("|");
				res.getWriter().println("Payment Rate");
				res.getWriter().println("|");
				res.getWriter().println("<input type=\"text\" id=\"reim_rat\" name=\"reim_rat\" value=\"" + WebUtil.printNum(data.REIM_RAT) + "\" class=\"noBorder\" style=\"text-align:right;\" size=\"1\" readonly >");

			} catch (IOException e) {
				Logger.error(e);
			}

		}
	}
}
