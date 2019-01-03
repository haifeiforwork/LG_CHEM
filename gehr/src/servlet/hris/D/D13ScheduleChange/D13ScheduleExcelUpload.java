package servlet.hris.D.D13ScheduleChange;

import java.util.Arrays;
import java.util.Map;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.fileupload.disk.DiskFileItem;

import com.common.AjaxResultMap;
import com.common.ExcelUtils;
import com.common.vo.ReadExcelInputVO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;

import hris.D.D13ScheduleChange.D13ScheduleChangeData;
import hris.D.D13ScheduleChange.rfc.D13ScheduleChangeRFC;
import hris.common.WebUserData;
import net.sf.json.JSONSerializer;

/**
 * D13ScheduleExcelUploadAjax.java
 * ¿¢¼¿ ¾÷·Îµå
 *
 * @author jungin
 * @version 1.0, 2010/10/13
 */
public class D13ScheduleExcelUpload extends EHRBaseServlet {

	@Override
	protected void performTask(HttpServletRequest req, HttpServletResponse res)
			throws GeneralException {

		try {
			WebUserData user = WebUtil.getSessionUser(req);
			Map<String, Object> requestMap = WebUtil.uploadFile(req);

			ReadExcelInputVO excelInputVO = new ReadExcelInputVO((DiskFileItem) requestMap.get("uploadFile"), D13ScheduleChangeData.class,
					Arrays.asList(
							 "PERNR"
							,"CBEGDA"
							,"CENDDA"
							,"VTART"
							,"TPROG"
							), 1);

			Vector<D13ScheduleChangeData> excelResultList = ExcelUtils.readExcel(excelInputVO);
			for( int i = excelResultList.size() -1 ; i >= 0 ; i-- ){
				if ((excelResultList.get(i).PERNR==null || (excelResultList.get(i).PERNR.trim().length() ==0 )) && 
					(excelResultList.get(i).CBEGDA==null || (excelResultList.get(i).CBEGDA.trim().length() != 8 )) && 
					(excelResultList.get(i).ENDDA==null|| (excelResultList.get(i).ENDDA.trim().length()!=8) )){
					excelResultList.remove(i);
					continue;
				}
				if(DataUtil.isDate(excelResultList.get(i).CBEGDA)==false){
					excelResultList.get(i).setCBEGDA(null);
				}
				if(DataUtil.isDate(excelResultList.get(i).CENDDA)==false){
					excelResultList.get(i).setCENDDA(null);
				}
			}
			for( int i = 0; i < excelResultList.size(); i++ ){
				excelResultList.get(i).setZLINE(String.valueOf(i+2));
			}

			D13ScheduleChangeRFC rfc = new D13ScheduleChangeRFC();
//			Vector<D13ScheduleChangeData> resultList = rfc.validateRow(user.empNo, (String) requestMap.get("I_YYYYMM"), excelResultList);
			Vector<D13ScheduleChangeData> resultList = rfc.saveRow(user.empNo, user.e_orgeh, excelResultList);
			
			int failSize=0;
			int successSize = excelResultList.size();
			for( int i = 0; i < resultList.size(); i++ ){
				failSize += (resultList.get(i).getZBIGO().equals("") ? 0 : 1 );
				
			}

			AjaxResultMap resultMap = new AjaxResultMap();
			req.setAttribute("successSize", successSize);
			req.setAttribute("failSize", failSize);
			resultMap.put("resultList", resultList);
			req.setAttribute("resultData", JSONSerializer.toJSON(resultMap).toString());
		
            if(  !rfc.getReturn().isSuccess()){
//                req.setAttribute("url",  "javascript:history.back();");
//            	req.setAttribute("url",  WebUtil.JspPath + "D/D13ScheduleChange/D13ScheduleFileUploadResult.jsp");
//                 printJspPage(req, res, WebUtil.JspURL+"common/msg.jsp");  
//                return;
            }else{
                req.setAttribute("msg", g.getMessage("MSG.COMMON.0008"));
            }
            req.setAttribute("msg2", rfc.getReturn().MSGTX);
            printJspPage(req, res, WebUtil.JspPath + "D/D13ScheduleChange/D13ScheduleFileUploadResult.jsp");

        } catch( Exception e ) {
			Logger.error(e);
			moveMsgPage(req, res, g.getMessage("MSG.G.G12.0001"), "history.back();");	//½ÇÆÐ½Ã
//            throw new GeneralException(e);
		}
	}
	
}
