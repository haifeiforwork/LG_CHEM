package servlet.hris.D.D09ContractExtension;

import com.common.AjaxResultMap;
import com.common.RFCReturnEntity;
import com.sns.jdf.GeneralException;
import com.sns.jdf.servlet.EHRBaseServlet;
import hris.D.D09ContractExtension.rfc.D09ContractExtensionPeriodCheckRFC;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * D09ContractExtensionAjax.java
 * Contract Type에 따른 기간 체크하는 RFC를 호출하는 Class
 *
 * @author jungin
 * @version 1.0, 2010/10/13
 */
public class D09ContractExtensionAjax extends EHRBaseServlet {

	@Override
	protected void performTask(HttpServletRequest req, HttpServletResponse res)
			throws GeneralException {
		
		try {
			String PERNR = req.getParameter("PERNR");
			String CTTYP = req.getParameter("CTTYP");
			String CBEGDA = req.getParameter("CBEGDA");
			String CTEDT = req.getParameter("CTEDT");
			
			D09ContractExtensionPeriodCheckRFC rfc = new D09ContractExtensionPeriodCheckRFC();
			RFCReturnEntity rfcReturnEntity = rfc.getPeriodCheck(PERNR, CTTYP, CBEGDA, CTEDT);

			AjaxResultMap resultMap = new AjaxResultMap();
			resultMap.put("resultData", rfcReturnEntity);

			resultMap.writeJson(res);
	
        } catch( Exception e ) {
            throw new GeneralException(e);
		}
	}
	
}
