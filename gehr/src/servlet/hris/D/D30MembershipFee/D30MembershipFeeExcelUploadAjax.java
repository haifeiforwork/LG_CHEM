package servlet.hris.D.D30MembershipFee;

import com.common.AjaxResultMap;
import com.common.ExcelUtils;
import com.common.vo.ReadExcelInputVO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.WebUtil;
import hris.D.D15EmpPayInfo.D15EmpPayData;
import hris.D.D15EmpPayInfo.rfc.D15EmpPayRFC;
import hris.common.WebUserData;
import org.apache.commons.fileupload.disk.DiskFileItem;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Arrays;
import java.util.Map;
import java.util.Vector;

/**
 * D30MembershipFeeExcelUploadAjax.java
 * 엑셀 업로드
 *
 * @author jungin
 * @version 1.0, 2010/10/13
 */
public class D30MembershipFeeExcelUploadAjax extends EHRBaseServlet {

	@Override
	protected void performTask(HttpServletRequest req, HttpServletResponse res)
			throws GeneralException {
		
		try {
			WebUserData user = WebUtil.getSessionUser(req);

			Map<String, Object> requestMap = WebUtil.uploadFile(req);

			ReadExcelInputVO excelInputVO = new ReadExcelInputVO((DiskFileItem) requestMap.get("uploadFile"), D15EmpPayData.class,
					Arrays.asList("PERNR", "LGART"), 1);

			Vector<D15EmpPayData> excelResultList = ExcelUtils.readExcel(excelInputVO);

			D15EmpPayRFC rfc = new D15EmpPayRFC();
			Vector<D15EmpPayData> resultList = rfc.validateRow(user.empNo, (String) requestMap.get("I_YYYYMM"), excelResultList);

			AjaxResultMap resultMap = new AjaxResultMap();
			resultMap.put("resultList", resultList);

			resultMap.writeJson(res);
	
        } catch( Exception e ) {
			Logger.error(e);
            throw new GeneralException(e);
		}
	}
	
}
