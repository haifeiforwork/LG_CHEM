/******************************************************************************/
/*																							*/
/*   System Name	:  MSS														*/
/*   1Depth Name		:  부서근태													*/
/*   2Depth Name		:  초과근무													*/
/*   Program Name	:  초과근무(일괄)											*/
/*   Program ID		:  D40OverTimeExcelUpload.java						*/
/*   Description		:  초과근무(일괄)											*/
/*   Note				:  엑셀 업로드 저장											*/
/*   Creation			:  2017-12-08  정준현                                          	*/
/*   Update				:  2017-12-08  정준현                                          	*/
/*                                                                              			*/
/********************************************************************************/
package servlet.hris.D.D40TmGroup;

import hris.D.D40TmGroup.D40OverTimeFrameData;
import hris.D.D40TmGroup.rfc.D40OverTimeLumpFrameRFC;
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
 * D40OverTimeExcelUpload.java
 * 엑셀 업로드
 *
 * @author jungin
 * @version 1.0, 2010/10/13
 */
public class D40OverTimeExcelUpload extends EHRBaseServlet {

	@Override
	protected void performTask(HttpServletRequest req, HttpServletResponse res)
			throws GeneralException {

		try {
			WebUserData user = WebUtil.getSessionUser(req);
			Map<String, Object> requestMap = WebUtil.uploadFile(req);

			ReadExcelInputVO excelInputVO = new ReadExcelInputVO((DiskFileItem) requestMap.get("uploadFile"), D40OverTimeFrameData.class,
					Arrays.asList(
							 "PERNR"
							,"ENAME"
							,"BEGDA"
							,"ENDDA"
							,"BEGUZ"
							,"ENDUZ"
//							,"STDAZ"
							,"PBEG1"
							,"PEND1"
							,"PBEG2"
							,"PEND2"
							,"VTKEN"
//							,"TPROG"
							,"REASON"
							,"DETAIL"
							), 1);

			Vector<D40OverTimeFrameData> excelResultList = D40ExcelUtils.readExcel(excelInputVO);

			Vector OBJID = new Vector();
			for( int i = 0; i < excelResultList.size(); i++ ){
				D40OverTimeFrameData excelDt = new D40OverTimeFrameData();

				if(!"".equals(WebUtil.nvl(excelResultList.get(i).PERNR))){
					excelDt.PERNR = excelResultList.get(i).PERNR;
					excelDt.ENAME = excelResultList.get(i).ENAME;
					excelDt.BEGDA = excelResultList.get(i).BEGDA;
					excelDt.ENDDA = excelResultList.get(i).ENDDA;
					if(!"".equals(excelResultList.get(i).BEGUZ) && excelResultList.get(i).BEGUZ != null){
						if(excelResultList.get(i).BEGUZ.length() > 3){
							if("24".equals(excelResultList.get(i).BEGUZ.substring(0,2))){
								excelDt.BEGUZ = "00"+excelResultList.get(i).BEGUZ.substring(2,4);
							}else{
								excelDt.BEGUZ = excelResultList.get(i).BEGUZ;
							}
						}else{
							excelDt.BEGUZ = excelResultList.get(i).BEGUZ;
						}
					}
					if(!"".equals(excelResultList.get(i).ENDUZ) && excelResultList.get(i).ENDUZ != null){
						if(excelResultList.get(i).ENDUZ.length() > 3){
							if("0000".equals(excelResultList.get(i).ENDUZ)){
								excelDt.ENDUZ = "2400";
							}else{
								excelDt.ENDUZ = excelResultList.get(i).ENDUZ;
							}
						}else{
							excelDt.ENDUZ = excelResultList.get(i).ENDUZ;
						}
					}

					if(!"".equals(excelResultList.get(i).PBEG1) && excelResultList.get(i).PBEG1 != null){
						if(excelResultList.get(i).PBEG1.length() > 3){
							if("24".equals(excelResultList.get(i).PBEG1.substring(0,2))){
								excelDt.PBEG1 = "00"+excelResultList.get(i).PBEG1.substring(2,4);
							}else{
								excelDt.PBEG1 = excelResultList.get(i).PBEG1;
							}
						}else{
							excelDt.PBEG1 = excelResultList.get(i).PBEG1;
						}
					}
					if(!"".equals(excelResultList.get(i).PEND1) && excelResultList.get(i).PEND1 != null){
						if(excelResultList.get(i).PEND1.length() > 3){
							if("0000".equals(excelResultList.get(i))){
								excelDt.PEND1 = "2400";
							}else{
								excelDt.PEND1 = excelResultList.get(i).PEND1;
							}
						}else{
							excelDt.PEND1 = excelResultList.get(i).PEND1;
						}
					}

					if(!"".equals(excelResultList.get(i).PBEG2) && excelResultList.get(i).PBEG2 != null){
						if(excelResultList.get(i).PBEG2.length() > 3){
							if("24".equals(excelResultList.get(i).PBEG2.substring(0,2))){
								excelDt.PBEG2 = "00"+excelResultList.get(i).PBEG2.substring(2,4);
							}else{
								excelDt.PBEG2 = excelResultList.get(i).PBEG2;
							}
						}else{
							excelDt.PBEG2 = excelResultList.get(i).PBEG2;
						}
					}
					if(!"".equals(excelResultList.get(i).PEND2) && excelResultList.get(i).PEND2 != null){
						if(excelResultList.get(i).PEND2.length() > 3){
							if("0000".equals(excelResultList.get(i))){
								excelDt.PEND2 = "2400";
							}else{
								excelDt.PEND2 = excelResultList.get(i).PEND2;
							}
						}else{
							excelDt.PEND2 = excelResultList.get(i).PEND2;
						}
					}

					excelDt.VTKEN = excelResultList.get(i).VTKEN;
					excelDt.REASON = excelResultList.get(i).REASON;
					excelDt.DETAIL = excelResultList.get(i).DETAIL;

					OBJID.addElement(excelDt);
				}
			}

			D40OverTimeLumpFrameRFC rfc = new D40OverTimeLumpFrameRFC();
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
