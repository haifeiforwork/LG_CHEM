package servlet.hris.A.A12Family;

import com.common.AjaxResultMap;
import com.sns.jdf.GeneralException;
import com.sns.jdf.servlet.EHRBaseServlet;

import hris.A.A12Family.rfc.A12FamilyAusprRFC;
import hris.A.A12Family.rfc.A12FamilyRelationRFC;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Vector;

/**
 * D15EmpPayTypeListAjax.java
 * 개인인적사항 가족 탭 자녀 수 가져오는 ajax
 *
 * @author rdcamel
 * @version 1.0, 2018/01/07 [CSR ID:3569665] 2017년 연말정산 웹화면 수정 요청의 건
 */
public class A12FamilySubType2Ajax extends EHRBaseServlet {

	@Override
	protected void performTask(HttpServletRequest req, HttpServletResponse res)
			throws GeneralException {
		
		try {
			//String SUBTY = req.getParameter("SUBTY");

			Vector resultList2  = (new A12FamilyAusprRFC()).getFamilyAuspr();

			AjaxResultMap resultMap = new AjaxResultMap();
			resultMap.put("resultList2", resultList2);

			resultMap.writeJson(res);
	
        } catch( Exception e ) {
            throw new GeneralException(e);
		}
	}
	
}
