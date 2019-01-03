package servlet.hris.D.D30MembershipFee;

import com.common.ExcelUtils;
import com.common.Utils;
import com.common.vo.ReadExcelInputVO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.WebUtil;
import hris.D.D30MembershipFee.D30MembershipFeeData;
import hris.D.D30MembershipFee.rfc.D30MembershipFeeRFC;
import hris.D.D30MembershipFee.rfc.D30MembershipFeeTypeRFC;
import hris.common.WebUserData;
import org.apache.commons.fileupload.disk.DiskFileItem;
import org.apache.commons.lang.StringUtils;

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
public class D30MembershipFeeExcelUpload extends EHRBaseServlet {

	@Override
	protected void performTask(HttpServletRequest req, HttpServletResponse res)
			throws GeneralException {
		
		try {
			WebUserData user = WebUtil.getSessionUser(req);

			Map<String, Object> requestMap = WebUtil.uploadFile(req);

			ReadExcelInputVO excelInputVO = new ReadExcelInputVO((DiskFileItem) requestMap.get("uploadFile"), D30MembershipFeeData.class,
					Arrays.asList("PERNR", "MGART", "RETIRE_YN"), 1);

			Vector<D30MembershipFeeData> excelResultList = ExcelUtils.readExcel(excelInputVO);

			Vector<D30MembershipFeeData> excelInputList = new Vector<D30MembershipFeeData>();

			if(Utils.getSize(excelResultList) > 0) {
				for(D30MembershipFeeData row : excelResultList) {
					if(StringUtils.isBlank(row.PERNR) && StringUtils.isBlank(row.MGART) && StringUtils.isBlank(row.RETIRE_YN)) {
						continue;
					}
					row.ZQUIT = StringUtils.equalsIgnoreCase(row.RETIRE_YN, "Y") ? "X" : "";
					excelInputList.add(row);
				}
			}

			String I_YYYYMM = (String) requestMap.get("I_YYYYMM");

			D30MembershipFeeRFC rfc = new D30MembershipFeeRFC();
			Vector<D30MembershipFeeData> resultList = rfc.validateRow(user.empNo, I_YYYYMM, excelInputList);

			if(!rfc.getReturn().isSuccess()) {
				moveMsgPage(req, res, g.getMessage("MSG.COMMON.UPLOAD.FAIL") + "\\n" + rfc.getReturn().getMessage(),"history.back();");
				return;
			}

			req.setAttribute("resultList", resultList);

			D30MembershipFeeTypeRFC membershipFeeTypeRFC = new D30MembershipFeeTypeRFC();
			req.setAttribute("payTypeList", membershipFeeTypeRFC.getMembershipType(user.empNo, I_YYYYMM));

			req.setAttribute("rfcReturn", rfc.getReturn());

			printJspPage(req, res, WebUtil.JspPath + "D/D30MembershipFee/D30MembershipFreeFileUploadResult.jsp");
	
        } catch( Exception e ) {
			Logger.error(e);
            throw new GeneralException(e);
		}
	}
	
}
