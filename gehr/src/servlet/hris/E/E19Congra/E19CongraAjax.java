/*
 * update: 2013-03-19  lixinxin  @v1.0   CSR：C20130315_92423	Cel / Con Date
 */
package servlet.hris.E.E19Congra;

import hris.E.E19Congra.E19CongcondGlobalData;
import hris.E.E19Congra.E19CongcondData2;
import hris.E.E19Congra.rfc.E19CongraRFC;
import hris.common.util.AppUtil;


import java.io.IOException;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.common.Utils;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.WebUtil;


public class E19CongraAjax extends EHRBaseServlet {

	@Override
	protected void performTask(HttpServletRequest req, HttpServletResponse res)
			throws GeneralException {

		if (req.getParameter("Itype") != null) {
			try {

				String PERNR = req.getParameter("PERNR");
				String CELTY = req.getParameter("CELTY");
				String FAMSA = "";
				String FAMY_CODE = req.getParameter("FAMY_CODE");
				String OBJPS = req.getParameter("OBJPS");
//				update: 2013-03-19  lixinxin  @v1.0   CSR：C20130315_92423
				String CELDT = req.getParameter("CELDT").replace(".", "").replace(".", "");

				E19CongraRFC rfc_congra = new E19CongraRFC();
				Vector famyCode1 = rfc_congra.getEntryCode(PERNR, "", CELTY);
				Vector fname1 = (Vector)famyCode1.get(1);
		      	 for(int i=0; i<fname1.size();i++){
		      	    E19CongcondData2 ffname = (E19CongcondData2) fname1.get(i);
		      	    if(ffname.FAMY_CODE.equals(FAMY_CODE)){
		      	    	FAMSA = ffname.FAMSA;
		      	    }
		      	 }

					Vector famyCode = rfc_congra.getEntryCode(PERNR, FAMSA, CELTY);
					Vector names = (Vector)famyCode.get(2);
//					update: 2013-03-19  lixinxin  @v1.0  CSR：C20130315_92423 	begin
					//Vector e19CongraData = rfc_congra.getCongraDetail(PERNR, "5",CELTY,FAMSA,FAMY_CODE);
					Vector e19CongraData = rfc_congra.getCongraDetail(PERNR, "5",CELTY,FAMSA,FAMY_CODE,CELDT);
//					update: 2013-03-19  lixinxin  @v1.0   CSR：C20130315_92423	end
					E19CongcondGlobalData data = (E19CongcondGlobalData) e19CongraData.get(0);

			        if(names.size()>0){
			        	if(names.size()>1){
			             	StringBuffer sb = new StringBuffer("<select id=\"OBJPS\" name=\"OBJPS\"  onchange='ENAME.value=OBJPS.options[selectedIndex].text;' >");
			             	String tmpEname = "";
			             	//if(FAMY_CODE.equals("0003")){
								 for(int i=0;i<names.size();i++){
									 E19CongcondData2 fname = (E19CongcondData2) names.get(i);

									 //NAME '성+이름' 으로 출력.	2008-01-10
									 //String ename = fname.FANAM + fname.FAVOR ;
									 String ename = fname.ENAME;

									 if (i==0){
										 tmpEname = ename;
									 }
									 String ecode = fname.OBJPS;
									 String isSelected = "";
									 if(OBJPS != null && !OBJPS.equals(""))
										 isSelected = (OBJPS.equals(ename)? "selected" :"");
									 sb.append("<option value='" + ecode + "' " + isSelected + ">" + AppUtil.escape(ename) + "</option>");

							        	Logger.debug.println("ename                      " + ename);
								 }
								 sb.append("</select><input type=\"hidden\" name=\"ENAME\"  value=\""+ tmpEname +"\">");
								 res.getWriter().println(sb.toString());
//				        	}else{
//				        		res.getWriter().println("<input type=\"hidden\" name=\"ENAME\"  value=\"\">");
//				        	}

			        	}else{
			        		if(names.size()==1){
			                	E19CongcondData2 fname = (E19CongcondData2) names.get(0);
					        	//String ename = fname.FAVOR + fname.FANAM ;
					        	String ename = fname.ENAME;

					   		    res.getWriter().println(
					   		    		AppUtil.escape("<input type=\"text\" name=\"ENAME\"  value=\""
												+ ename
												+ "\"    size=\"30\" readonly> &nbsp; <input type=\"hidden\" name=\"OBJPS\"  value=\""+fname.OBJPS+"\" readonly>"));
			        		}else{
			        			res.getWriter().println("<input type=\"hidden\" name=\"ENAME\"  value=\"\">");
			        		}
			        	}

			        }else{
			        	Vector famy_Code = rfc_congra.getEntryCode(PERNR, "", CELTY);
			        	E19CongcondData2 famy_Code1 = (E19CongcondData2) Utils.indexOf(fname1,0);

			        	if(!FAMY_CODE.equals(famy_Code1.FAMY_CODE)){
			        		res.getWriter().println("<input type=\"hidden\" name=\"ENAME\"  value=\"\">");
			        	}else{

			        		//FAMY_CODE = 0001(本人)은 본인자신. E_ENAME 필드를 출력.		2008-01-15.
			        		//FAMY_CODE = 0101(Employee) 추가.		2008-02-29.
			        		if(famy_Code1.FAMY_CODE.equals("0001") || famy_Code1.FAMY_CODE.equals("0101")){
					        	String uname = rfc_congra.getName(PERNR,"","");
					        	res.getWriter().println(
											"<input type=\"text\" name=\"ENAME\"  value=\""
													+ AppUtil.escape(uname)
													+ "\"    size=\"100\" readonly>");
			        		}else{
			        			res.getWriter().println("<input type=\"hidden\" name=\"ENAME\"  value=\"\">");
			        		}
			        	}
			        }

					res.getWriter().println("|");
					res
							.getWriter()
							.println(
									"<input type=\"text\" name=\"BASE_AMNT\"  value=\""
											+ WebUtil.printNumFormat(data.BASE_AMNT,2)
											+ "\"  size=\"10\" style=\"text-align:right; \" readonly>&nbsp;<input type=\"text\" name=\"CURRENCY\"  value=\""+data.CURRENCY+"\" readonly>");
					res.getWriter().println("|");
					res
							.getWriter()
							.println(
									"<input type=\"text\" name=\"PAYM_RATE\"  value=\""
											+ data.PAYM_RATE
											+ "\"  size=\"10\" style=\"text-align:right;\" readonly>&nbsp;<input type=\"text\"  value=\"%\" readonly>");
					res.getWriter().println("|");
					res
							.getWriter()
							.println(
									"<input type=\"text\" name=\"CLAC_AMNT\"  value=\""
									+ WebUtil.printNumFormat(data.CLAC_AMNT,2)
									+ "\"  size=\"10\" style=\"text-align:right;\" readonly>&nbsp;<input type=\"text\"  name=\"CURRENCY\" value=\""+data.CURRENCY+"\" readonly>");
					res.getWriter().println("|");

					//최대 지급한도.
					res
							.getWriter()
							.println(
									"<input type=\"text\" name=\"MAXM_PAY\"  value=\""
									+ WebUtil.printNumFormat(data.MAXM_PAY,2)
									+ "\"  size=\"10\" style=\"text-align:right;\" readonly>&nbsp;<input type=\"text\"  name=\"CURRENCY\" value=\""+data.CURRENCY+"\" readonly>");
					res.getWriter().println("|");

					res
							.getWriter()
							.println(
									"<input type=\"text\" name=\"ABSN_DATE\" value=\""
											+ data.ABSN_DATE
											+ "\"  style=\"text-align:right;\"  size=\"10\" readonly >&nbsp;<input type=\"text\"  value=\"Days\" readonly>");
					res.getWriter().println("|");

					res
					.getWriter()
					.println(

							"<input type=\"text\" name=\"SYEAR\" value=\""
									+ data.SYEAR
									+ "\"  style=\"text-align:right;\" size=\"5\" readonly > &nbsp;<input type=\"text\"  size=\"5\" value=\"Year\" readonly>&nbsp;" +
											"<input type=\"text\" name=\"SMNTH\" value=\""
									+ data.SMNTH
									+ "\"  style=\"text-align:right;\" size=\"5\" readonly > &nbsp;<input type=\"text\"  size=\"5\" value=\"Month\" readonly>&nbsp;<input type=\"hidden\" name=\"AWART\" value=\""
									+ data.AWART
									+ "\"  style=\"text-align:right;\"  size=\"10\" readonly >");
					res.getWriter().print("|");
					res.getWriter().print(FAMSA);
			} catch (IOException e) {
				Logger.error(e);
			}

		}

	}

}
