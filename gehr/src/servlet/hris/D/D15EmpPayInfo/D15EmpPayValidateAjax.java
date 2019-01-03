package servlet.hris.D.D15EmpPayInfo;

import com.common.AjaxResultMap;
import com.common.Utils;
import com.sns.jdf.GeneralException;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.WebUtil;
import hris.D.D15EmpPayInfo.D15EmpPayData;
import hris.D.D15EmpPayInfo.rfc.D15EmpPayRFC;
import hris.common.WebUserData;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Vector;

/**
 * D15EmpPayValidateAjax.java
 * 입력된 임금유형의 validation check 가져오는 ajax
 *
 * @author jungin
 * @version 1.0, 2010/10/13
 */
public class D15EmpPayValidateAjax extends EHRBaseServlet {

	@Override
	protected void performTask(HttpServletRequest req, HttpServletResponse res)
			throws GeneralException {
		
		try {
			WebUserData user = WebUtil.getSessionUser(req);
			Box box = WebUtil.getBox(req);
			D15EmpPayData inputData = WebUtil.getBox(req).createEntity(D15EmpPayData.class, "LIST_");

			D15EmpPayRFC rfc = new D15EmpPayRFC();
			Vector<D15EmpPayData> resultList = rfc.validateRow(user.empNo, box.get("I_YYYYMM"), Utils.asVector(inputData));

			AjaxResultMap resultMap = new AjaxResultMap();
			resultMap.put("resultList", resultList);

			resultMap.writeJson(res);
	
        } catch( Exception e ) {
            throw new GeneralException(e);
		}
	}
	
}
