package servlet.hris.D.D15EmpPayInfo;

import com.common.AjaxResultMap;
import com.sns.jdf.GeneralException;
import com.sns.jdf.servlet.EHRBaseServlet;
import hris.D.D15EmpPayInfo.D15EmpPayTypeData;
import hris.D.D15EmpPayInfo.rfc.D15EmpPayTypeGlobalRFC;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Vector;

/**
 * D15EmpPayTypeListAjax.java
 * 임금유형 가져오는 ajax
 *
 * @author jungin
 * @version 1.0, 2010/10/13
 */
public class D15EmpPayTypeListAjax extends EHRBaseServlet {

	@Override
	protected void performTask(HttpServletRequest req, HttpServletResponse res)
			throws GeneralException {
		
		try {
			String I_PERNR = req.getParameter("I_PERNR");
			String I_YYYYMM = req.getParameter("I_YYYYMM");

			D15EmpPayTypeGlobalRFC rfc = new D15EmpPayTypeGlobalRFC();
			Vector<D15EmpPayTypeData> resultList = rfc.getEmpPayType(I_PERNR, I_YYYYMM);

			AjaxResultMap resultMap = new AjaxResultMap();
			resultMap.put("resultList", resultList);

			resultMap.writeJson(res);
	
        } catch( Exception e ) {
            throw new GeneralException(e);
		}
	}
	
}
