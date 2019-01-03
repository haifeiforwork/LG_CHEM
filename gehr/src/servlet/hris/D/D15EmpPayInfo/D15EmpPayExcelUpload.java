package servlet.hris.D.D15EmpPayInfo;

import com.common.ExcelUtils;
import com.common.Utils;
import com.common.vo.ReadExcelInputVO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.WebUtil;
import hris.D.D15EmpPayInfo.D15EmpPayData;
import hris.D.D15EmpPayInfo.rfc.D15EmpPayRFC;
import hris.D.D15EmpPayInfo.rfc.D15EmpPayTypeGlobalRFC;
import hris.common.WebUserData;
import org.apache.commons.fileupload.disk.DiskFileItem;
import org.apache.commons.lang.StringUtils;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Arrays;
import java.util.Map;
import java.util.Vector;

/**
 * D15EmpPayExcelUploadAjax.java
 * 엑셀 업로드
 *
 * @author jungin
 * @version 1.0, 2010/10/13
 */
public class D15EmpPayExcelUpload extends EHRBaseServlet {

	@Override
	protected void performTask(HttpServletRequest req, HttpServletResponse res)
			throws GeneralException {

		try {
			WebUserData user = WebUtil.getSessionUser(req);

			Map<String, Object> requestMap = WebUtil.uploadFile(req);

			ReadExcelInputVO excelInputVO = new ReadExcelInputVO((DiskFileItem) requestMap.get("uploadFile"), D15EmpPayData.class,
					Arrays.asList("PERNR", "LGART", "BETRG"), 1);

			Vector<D15EmpPayData> excelResultList = ExcelUtils.readExcel(excelInputVO);

			Vector<D15EmpPayData> excelInputList = new Vector<D15EmpPayData>();

			if(Utils.getSize(excelResultList) > 0) {
				for(D15EmpPayData row : excelResultList) {
					if(StringUtils.isBlank(row.PERNR) && StringUtils.isBlank(row.LGART) && StringUtils.isBlank(row.BETRG)) {
						continue;
					}
					excelInputList.add(row);
				}
			}

			String I_YYYYMM = (String) requestMap.get("I_YYYYMM");

			D15EmpPayRFC rfc = new D15EmpPayRFC();
			Vector<D15EmpPayData> resultList = rfc.validateRow(user.empNo, I_YYYYMM, excelInputList);

			if(!rfc.getReturn().isSuccess()) {
				moveMsgPage(req, res, g.getMessage("MSG.COMMON.UPLOAD.FAIL") + "\\n" + rfc.getReturn().getMessage(),"history.back();");
				return;
			}

			/*AjaxResultMap resultMap = new AjaxResultMap();
			resultMap.put("resultList", resultList);

			req.setAttribute("resultData", JSONSerializer.toJSON(resultMap).toString());*/

			req.setAttribute("resultList", resultList);

			D15EmpPayTypeGlobalRFC payTypeGlobalRFC = new D15EmpPayTypeGlobalRFC();
			req.setAttribute("payTypeList", payTypeGlobalRFC.getEmpPayType(user.empNo, I_YYYYMM));



			printJspPage(req, res, WebUtil.JspPath + "D/D15EmpPayInfo/D15EmpPayFileUploadResult.jsp");
	
        } catch( Exception e ) {
			Logger.error(e);
            throw new GeneralException(e);
		}
	}
	
}
