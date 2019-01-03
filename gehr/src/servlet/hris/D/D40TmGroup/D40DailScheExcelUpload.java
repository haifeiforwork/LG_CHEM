/******************************************************************************/
/*																							*/
/*   System Name	:  MSS														*/
/*   1Depth Name		:  부서근태													*/
/*   2Depth Name		:  일일근무일정												*/
/*   Program Name	:  일일근무일정(일괄)										*/
/*   Program ID		:  D40DailScheExcelUpload.java						*/
/*   Description		:  일일근무일정(일괄)										*/
/*   Note				:  엑셀 업로드 저장											*/
/*   Creation			:  2017-12-08  정준현                                          	*/
/*   Update				:  2017-12-08  정준현                                          	*/
/*                                                                              			*/
/********************************************************************************/
package servlet.hris.D.D40TmGroup;

import hris.D.D40TmGroup.D40DailScheFrameData;
import hris.D.D40TmGroup.rfc.D40DailScheLumpFrameRFC;
import hris.common.WebUserData;

import java.util.Arrays;
import java.util.Map;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONSerializer;

import org.apache.commons.fileupload.disk.DiskFileItem;

import com.common.AjaxResultMap;
import com.common.D40ExcelUtils;
import com.common.vo.ReadExcelInputVO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.WebUtil;

/**
 * D40DailScheExcelUpload.java
 * 엑셀 업로드
 *
 * @author jungin
 * @version 1.0, 2010/10/13
 */
public class D40DailScheExcelUpload extends EHRBaseServlet {

	@Override
	protected void performTask(HttpServletRequest req, HttpServletResponse res)
			throws GeneralException {

		try {
			WebUserData user = WebUtil.getSessionUser(req);
			Map<String, Object> requestMap = WebUtil.uploadFile(req);

			ReadExcelInputVO excelInputVO = new ReadExcelInputVO((DiskFileItem) requestMap.get("uploadFile"), D40DailScheFrameData.class,
					Arrays.asList(
							 "PERNR"
							,"ENAME"
							,"BEGDA"
							,"ENDDA"
							,"TPROG"
							), 1);

			Vector<D40DailScheFrameData> excelResultList = D40ExcelUtils.readExcel(excelInputVO);

			Vector OBJID = new Vector();
			for( int i = 0; i < excelResultList.size(); i++ ){
				D40DailScheFrameData excelDt = new D40DailScheFrameData();

				if(!"".equals(WebUtil.nvl(excelResultList.get(i).PERNR))){
					excelDt.PERNR = excelResultList.get(i).PERNR;
					excelDt.ENAME = excelResultList.get(i).ENAME;
					excelDt.BEGDA = excelResultList.get(i).BEGDA;
					excelDt.ENDDA = excelResultList.get(i).ENDDA;
					excelDt.TPROG = excelResultList.get(i).TPROG;
					OBJID.addElement(excelDt);
				}
			}
//			D40DailScheFrameData
			D40DailScheLumpFrameRFC rfc = new D40DailScheLumpFrameRFC();
			String I_ACTTY = "U";	//실행모드 : U 일괄업로드
//			Vector<D13ScheduleChangeData> resultList = rfc.validateRow(user.empNo, (String) requestMap.get("I_YYYYMM"), excelResultList);
			Vector resultList = rfc.saveRow(user.empNo, I_ACTTY, OBJID);

			int failSize=0;
			int successSize = excelResultList.size();

			AjaxResultMap resultMap = new AjaxResultMap();
			req.setAttribute("successSize", successSize);
			req.setAttribute("failSize", failSize);
			req.setAttribute("E_RETURN", resultList.get(0));
			req.setAttribute("E_MESSAGE", resultList.get(1));
			req.setAttribute("E_SAVE_CNT", resultList.get(3));

			resultMap.put("resultList", resultList.get(2));
			req.setAttribute("resultData", JSONSerializer.toJSON(resultMap).toString());

            printJspPage(req, res, WebUtil.JspPath + "D/D40TmGroup/D40ExcelUploadResult.jsp");

        } catch( Exception e ) {
			Logger.error(e);
			moveMsgPage(req, res, g.getMessage("MSG.G.G12.0001"), "history.back();");	//실패시
//            throw new GeneralException(e);
		}
	}

}
