package servlet.hris.D.D12Rotation;

import com.common.AjaxResultMap;
import com.common.ExcelUtils;
import com.common.vo.ReadExcelInputVO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;
import hris.D.D12Rotation.D12RotationBuildCnData;
import hris.D.D12Rotation.D12RotationBuildCnExcelData;
import hris.D.D12Rotation.rfc.D12RoataionBuildCnRFC;
import hris.common.WebUserData;
import net.sf.json.JSONSerializer;
import org.apache.commons.fileupload.disk.DiskFileItem;
import org.apache.commons.lang.math.NumberUtils;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Arrays;
import java.util.Map;
import java.util.Vector;

/**
 * D12RotationExcelUpload
 * @author
 * @version
 */
public class D12RotationCnExcelUpload extends EHRBaseServlet {
	@Override
	protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {
		try {
	        WebUserData user = WebUtil.getSessionUser(req);		                            //세션
			Map<String, Object> requestMap = WebUtil.uploadFile(req);

			ReadExcelInputVO excelInputVO = new ReadExcelInputVO((DiskFileItem) requestMap.get("uploadFile"), D12RotationBuildCnExcelData.class,
					Arrays.asList("PERNR","CBEGDA", "VTKEN", "BEGUZ", "ENDUZ", "PBEG1", "PEND1", "PBEG2", "PEND2", "REASON"), 1);
			Vector<D12RotationBuildCnExcelData> excelResultList = ExcelUtils.readExcel(excelInputVO);

			/* 공백행 제거 */
			for( int i = excelResultList.size() -1 ; i >= 0 ; i-- ){
				if ((excelResultList.get(i).PERNR==null || (excelResultList.get(i).PERNR.trim().length() != 8)) && 
					(excelResultList.get(i).CBEGDA==null || (excelResultList.get(i).CBEGDA.length() != 8 )) && 
					(excelResultList.get(i).VTKEN==null  || (excelResultList.get(i).VTKEN.trim().length()==0) )){
					excelResultList.remove(i);
				}

			}

			for( int i = 0; i < excelResultList.size(); i++ ){
				excelResultList.get(i).setZLINE(String.valueOf(i+2));
/*				excelResultList.get(i).setBEGUZS();
				excelResultList.get(i).setENDUZS();
				excelResultList.get(i).setPBEG1S();
				excelResultList.get(i).setPEND1S();
				excelResultList.get(i).setPBEG2S();
				excelResultList.get(i).setPEND2S();*/
			}
			
			D12RoataionBuildCnRFC d12Rfc = new D12RoataionBuildCnRFC();
			Vector<D12RotationBuildCnData> resultList = d12Rfc.validateRow(user.empNo, null, excelResultList);
			req.setAttribute("successSize", excelResultList.size());
			AjaxResultMap resultMap = new AjaxResultMap();

			for( int i = 0; i < resultList.size(); i++ ){
				resultList.get(i).setBEGUZ(NumberUtils.toLong(DataUtil.removeSeparate(resultList.get(i).getBEGUZ())) == 0 ? "" : resultList.get(i).getBEGUZ());
				resultList.get(i).setENDUZ(NumberUtils.toLong(DataUtil.removeSeparate(resultList.get(i).getENDUZ())) == 0 ? "" : resultList.get(i).getENDUZ());
				resultList.get(i).setPBEG1(NumberUtils.toLong(DataUtil.removeSeparate(resultList.get(i).getPBEG1())) == 0 ? "" : resultList.get(i).getPBEG1());
				resultList.get(i).setPEND1(NumberUtils.toLong(DataUtil.removeSeparate(resultList.get(i).getPEND1())) == 0 ? "" : resultList.get(i).getPEND1());
				resultList.get(i).setPBEG2(NumberUtils.toLong(DataUtil.removeSeparate(resultList.get(i).getPBEG2())) == 0 ? "" : resultList.get(i).getPBEG2());
				resultList.get(i).setPEND2(NumberUtils.toLong(DataUtil.removeSeparate(resultList.get(i).getPEND2())) == 0 ? "" : resultList.get(i).getPEND2());

				/*
				data.setBEGUZ(data.getBEGUZ().equals("00:00:00") ? "" : data.getBEGUZ());
				data.setENDUZ(data.getENDUZ().equals("00:00:00") ? "" : data.getENDUZ());
				data.setPBEG1(data.getPBEG1().equals("00:00:00") ? "" : data.getPBEG1());
				data.setPEND1(data.getPEND1().equals("00:00:00") ? "" : data.getPEND1());
				data.setPBEG2(data.getPBEG2().equals("00:00:00") ? "" : data.getPBEG2());
				data.setPEND2(data.getPEND2().equals("00:00:00") ? "" : data.getPEND2());
				*/
				/*D12RotationBuildCnData data = resultList.get(i);
				data.setCBEGDA(WebUtil.printDate(data.getCBEGDA()));
				if(data.getBEGUZ().equals("00:00:00") && data.getENDUZ().equals("00:00:00")){	// from to 모두 00:00:00일때만 공백으로 처리
					data.setBEGUZ( "" );
					data.setENDUZ( "" );
				}
				if(data.getPBEG1().equals("00:00:00") && data.getPEND1().equals("00:00:00")){
					data.setPBEG1( "" );
					data.setPEND1( "" );
				}
				if(data.getPBEG2().equals("00:00:00") && data.getPEND2().equals("00:00:00")){
					data.setPBEG2( "" );
					data.setPEND2( "" );
				}

				if(data.getENDUZ().equals("00:00:00")){	// 종료시간이  00:00:00일때 24:00으로 처리
					data.setENDUZ( "24:00:00" );
				}
				if(data.getPEND1().equals("00:00:00")){	// 종료시간이  00:00:00일때 24:00으로 처리
					data.setPEND1( "24:00:00" );
				}
				if(data.getPEND2().equals("00:00:00")){	// 종료시간이  00:00:00일때 24:00으로 처리
					data.setPEND2( "24:00:00" );
				}*/

			}

			resultMap.put("resultList", resultList);
			req.setAttribute("failSize", resultList.size());
			req.setAttribute("resultData", JSONSerializer.toJSON(resultMap).toString());

			printJspPage(req, res, WebUtil.JspPath + "D/D12Rotation/D12RotationCnFileUploadResult.jsp");

        } catch( Exception e ) {
			Logger.error(e);
			moveMsgPage(req, res, g.getMessage("MSG.G.G12.0001"), "history.back();");	//실패시
            //throw new GeneralException(e);
		}
	}

}
