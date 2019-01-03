package servlet.hris.A.A12Family;

import com.common.AjaxResultMap;
import com.sns.jdf.GeneralException;
import com.sns.jdf.servlet.EHRBaseServlet;
import hris.A.A12Family.rfc.A12FamilyRelationRFC;

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
public class A12FamilySubTypeAjax extends EHRBaseServlet {

	@Override
	protected void performTask(HttpServletRequest req, HttpServletResponse res)
			throws GeneralException {
		
		try {
			String SUBTY = req.getParameter("SUBTY");

			Vector resultList  = (new A12FamilyRelationRFC()).getFamilyRelation(SUBTY);

			AjaxResultMap resultMap = new AjaxResultMap();
			resultMap.put("resultList", resultList);

			resultMap.writeJson(res);
	
        } catch( Exception e ) {
            throw new GeneralException(e);
		}
	}
	
}
