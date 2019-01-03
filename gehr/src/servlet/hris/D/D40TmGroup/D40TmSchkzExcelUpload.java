/******************************************************************************/
/*																							*/
/*   System Name	:  MSS														*/
/*   1Depth Name		:   �μ�����													*/
/*   2Depth Name		:   ��ȹ�ٹ����� 											*/
/*   Program Name	:   ��ȹ�ٹ�����(�ϰ�) 									*/
/*   Program ID		: D40TmSchkzExcelUpload.java						*/
/*   Description		: ��ȹ�ٹ�����(�ϰ�)										*/
/*   Note				: ���� ���ε� ����											*/
/*   Creation			: 2017-12-08  ������                                          	*/
/*   Update				: 2017-12-08  ������                                          	*/
/*                                                                              			*/
/********************************************************************************/
package servlet.hris.D.D40TmGroup;

import hris.D.D40TmGroup.D40TmSchkzFrameData;
import hris.D.D40TmGroup.rfc.D40TmSchkzFrameRFC;
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
 * D40TmSchkzExcelUpload.java
 * ���� ���ε�
 *
 * @author jungin
 * @version 1.0, 2010/10/13
 */
public class D40TmSchkzExcelUpload extends EHRBaseServlet {

	@Override
	protected void performTask(HttpServletRequest req, HttpServletResponse res)
			throws GeneralException {

		try {
			WebUserData user = WebUtil.getSessionUser(req);
			Map<String, Object> requestMap = WebUtil.uploadFile(req);

			ReadExcelInputVO excelInputVO = new ReadExcelInputVO((DiskFileItem) requestMap.get("uploadFile"), D40TmSchkzFrameData.class,
					Arrays.asList(
							 "PERNR"
							,"ENAME"
							,"BEGDA"
							,"ENDDA"
							,"SCHKZ"
							), 1);

			Vector<D40TmSchkzFrameData> excelResultList = D40ExcelUtils.readExcel(excelInputVO);

			Vector OBJID = new Vector();
			for( int i = 0; i < excelResultList.size(); i++ ){
				D40TmSchkzFrameData excelDt = new D40TmSchkzFrameData();

				if(!"".equals(WebUtil.nvl(excelResultList.get(i).PERNR))){
					excelDt.PERNR = excelResultList.get(i).PERNR;
					excelDt.ENAME = excelResultList.get(i).ENAME;
					excelDt.BEGDA = excelResultList.get(i).BEGDA;
					excelDt.ENDDA = excelResultList.get(i).ENDDA;
					excelDt.SCHKZ = excelResultList.get(i).SCHKZ;
					OBJID.addElement(excelDt);
				}
			}

			D40TmSchkzFrameRFC rfc = new D40TmSchkzFrameRFC();
			String I_ACTTY = "U";	//������ : U �ϰ����ε�
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
			moveMsgPage(req, res, g.getMessage("MSG.G.G12.0001"), "history.back();");	//���н�
//            throw new GeneralException(e);
		}
	}

}
