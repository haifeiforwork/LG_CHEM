package servlet.hris.G;

import java.util.Vector;

import hris.D.D19Duty.D19DutyData2;
import hris.D.D19Duty.rfc.D19DutyEntryRFC;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.common.Utils;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.EHRBaseServlet;

public class G067DutyAjax   extends EHRBaseServlet {
		protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {
			// TODO Auto-generated method stub
			String PERNR = req.getParameter("PERNR");
			String Itype = req.getParameter("Itype");
			String today = req.getParameter("today");
			String JIKCH = req.getParameter("JIKCH");
			String time = req.getParameter("time");
			String ANZHL = req.getParameter("ANZHL");

			//-------------------------------------------------------------------------------------------------------------------	2008-06-18.
			//Logger.debug.println("[G067DutyAjax] 직반유형 변경		< ZHRW_RFC_DUTY_ACCOUNT >");
			Logger.debug.println("[G067DutyAjax] PERNR		:	"	+	PERNR);
			Logger.debug.println("[G067DutyAjax] Itype		:	"	+ 	Itype);
			Logger.debug.println("[G067DutyAjax] today		:	"	+ 	today);
			Logger.debug.println("[G067DutyAjax] JIKCH		:	"	+ 	JIKCH);
			Logger.debug.println("[G067DutyAjax] time			:	"	+ 	time);
			Logger.debug.println("[G067DutyAjax] ANZHL		:	"	+ 	ANZHL);
			//-------------------------------------------------------------------------------------------------------------------

			// ZHOLIDAY1 필드 추가.		2008-01-17
			String ZHOLIDAY1 = req.getParameter("ZHOLIDAY1");
			//Logger.debug.println(" [G067DutyAjax] time = " + time);

			/*
  			if(time == null||time.equals("")){
				time = "";
			}else{
				time = "X";
			}
			*/

			D19DutyEntryRFC rfc2 = new D19DutyEntryRFC();

			Vector ret = rfc2.vcGetMessage(PERNR, Itype,today,JIKCH,time,ANZHL);


			//Vector vcRet = null ;
			//vcRet = rfc2.getMessage(PERNR, Itype,today,JIKCH,time,ANZHL);
			//D19DutyData2 ret =(D19DutyData2) rfc2.getMessage(PERNR, Itype,today,JIKCH,time,ANZHL);


			Logger.debug.println(this, "=====Ajax ret 확인 필요함....====" + ret);
			Logger.debug.println(this, "=====Ajax ret====" + (Object)Utils.indexOf(ret, 0)  );

			//String wtem = (String)Utils.indexOf(vcResult, 1); //(String)vcResult.get(1);

			String E_ACCOUNT = (String)Utils.indexOf(ret, 0); //ret.E_ACCOUNT;
			String E_WAERS = (String)Utils.indexOf(ret, 1); //ret.E_WAERS;

			String E_MESSAGE = (String)Utils.indexOf(ret, 2); //ret.E_MESSAGE;

			Logger.debug.println(this, "=====E_ACCOUNT====" +E_ACCOUNT );
			Logger.debug.println(this, "=====E_WAERS====" +E_WAERS );




			try {

			    /*******************************************************************
				// E_WAERS 널 체크로직 임시주석.		[CSR번호 : C20080514_66331]	2008-05-19.	김정인.

 				if(E_WAERS.equals("")||E_WAERS==null){
					res
					.getWriter()
					.println(
							 );
			        res.getWriter().println("|");
			    	res
					.getWriter()
					.println(
					 );
			        res.getWriter().println("|");
			        res.getWriter().print(E_MESSAGE);
				}else{
				*******************************************************************/
				res.getWriter()	.println("<input type=\"text\" name=\"BETRG\"  id=\"BETRG\" value=\"" + E_ACCOUNT + "\" class=\"noBorder\" size=\"6\" readonly>");
		        res.getWriter().println("|");
		    	res.getWriter()	.println("<input type=\"text\" name=\"WAERS\" id=\"WAERS\" value=\"" + E_WAERS + "\" class=\"noBorder\" size=\"6\" readonly>");
		        res.getWriter().println("|");
		        res.getWriter().print(E_MESSAGE);

				//}

			} catch(Exception ex){
	            //Logger.sap.println(this, "SAPException : "+ex.toString());
	            throw new GeneralException(ex);
			}
	}

}
