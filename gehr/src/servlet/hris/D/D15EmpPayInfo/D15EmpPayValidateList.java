package servlet.hris.D.D15EmpPayInfo;

import com.sns.jdf.GeneralException;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.WebUtil;
import hris.D.D15EmpPayInfo.D15EmpPayData;
import hris.D.D15EmpPayInfo.rfc.D15EmpPayRFC;
import hris.D.D15EmpPayInfo.rfc.D15EmpPayTypeGlobalRFC;
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
public class D15EmpPayValidateList extends EHRBaseServlet {

	@Override
	protected void performTask(HttpServletRequest req, HttpServletResponse res)
			throws GeneralException {
		
		try {
			WebUserData user = WebUtil.getSessionUser(req);
			Box box = WebUtil.getBox(req);
//			D15EmpPayData inputData = WebUtil.getBox(req).createEntity(D15EmpPayData.class, "LIST_");
			Vector<D15EmpPayData> inputList = box.getVector(D15EmpPayData.class, "LIST_");

			D15EmpPayRFC rfc = new D15EmpPayRFC();

			String I_YYYYMM = box.get("I_YYYYMM");

			Vector<D15EmpPayData> resultList = rfc.validateRow(user.empNo, I_YYYYMM, inputList);
			req.setAttribute("resultList", resultList);

			D15EmpPayTypeGlobalRFC payTypeGlobalRFC = new D15EmpPayTypeGlobalRFC();
			req.setAttribute("payTypeList", payTypeGlobalRFC.getEmpPayType(user.empNo, I_YYYYMM));


			printJspPage(req, res, WebUtil.JspURL + "D/D15EmpPayInfo/D15EmpPayCheckResult.jsp");
	
        } catch( Exception e ) {
            throw new GeneralException(e);
		}
	}
	
}
