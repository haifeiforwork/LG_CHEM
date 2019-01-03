/********************************************************************************/
/**                                                               				*/
/**   System Name  : ESS     													*/
/**   1Depth Name  : MY HR 정보                                                  		*/
/**   2Depth Name  : 휴가/근태                                                    		*/
/**   Program Name : 초과근무 실적입력                                               	*/
/**   Program ID   : D01OTOvertimeInputSV                   					*/
/**   Description  : 초과근무 실적입력 하는 Class                          		*/
/**   Note         :                                                  			*/
/**   Creation     : 2018-06-08  성환희                                          		*/
/**   Update       :                                           					*/
/********************************************************************************/

package servlet.hris.D.D01OT;

import java.util.Calendar;
import java.util.HashMap;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.common.RFCReturnEntity;
import com.sns.jdf.GeneralException;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;

import hris.D.D01OT.D01OTHeaderData;
import hris.D.D01OT.D01OTListData;
import hris.D.D01OT.D01OTReqtmData;
import hris.D.D01OT.D01OTResultData;
import hris.D.D01OT.rfc.D01OTOvertimeInput2RFC;
import hris.D.D01OT.rfc.D01OTOvertimeInputRFC;
import hris.common.WebUserData;

public class D01OTOvertimeInputSV extends EHRBaseServlet {
	
	protected void performTask(final HttpServletRequest req, final HttpServletResponse res) throws GeneralException {
		
		try {
			
			WebUserData user = WebUtil.getSessionUser(req);
			
			Box box = WebUtil.getBox(req);
			
			String PERNR = box.get("PERNR", user.empNo);
			String isPop = box.get("isPop");
			String viewMode = box.get("viewMode", "N");
			String PARAM_ACTION = box.get("PARAM_ACTION", "SEARCH");
			String PARAM_YYYY = box.get("PARAM_YYYY", DataUtil.getCurrentYear());
			String PARAM_MM = box.get("PARAM_MM", DataUtil.getCurrentMonth());
			String PARAM_DATE = box.get("PARAM_DATE", "");
			
			String CURRENT_YEAR = DataUtil.getCurrentYear();
			
			D01OTOvertimeInputRFC rfc = new D01OTOvertimeInputRFC();
			D01OTOvertimeInput2RFC rfc2 = new D01OTOvertimeInput2RFC();
			
			// 기준년월(2018년 8월) - 테스트용 7월부터 신규 프로세스
			Calendar compareDate = Calendar.getInstance();
			compareDate.set(2018, Calendar.AUGUST, 31);
//			compareDate.set(2018, Calendar.JUNE, 30);
			
			// 검색년월
			Calendar searchDate = Calendar.getInstance();
			searchDate.set(Integer.parseInt(PARAM_YYYY), Integer.parseInt(PARAM_MM) - 1, 1);
			
			if(PARAM_ACTION.equals("SEARCH")) {
				
				String dest = "";
				Vector export = null;
				Vector<D01OTHeaderData> T_HEADER = new Vector<D01OTHeaderData>();
				Vector<D01OTListData> T_LIST = new Vector<D01OTListData>();
				Vector<D01OTReqtmData> T_REQTM = new Vector<D01OTReqtmData>();
				Vector<D01OTResultData> T_RESULT = new Vector<D01OTResultData>();
				
				// 2018년 8월 이전 검색시 기존 프로세스로 분기한다.
				if(compareDate.compareTo(searchDate) >= 0) {
					export = rfc.search(PERNR, PARAM_YYYY + PARAM_MM, isPop);
					
					T_HEADER = (Vector<D01OTHeaderData>) export.get(1);
					T_LIST = (Vector<D01OTListData>) export.get(2);
					Vector<D01OTListData> T_LIST_TMP = new Vector<D01OTListData>();
					
					if(!PARAM_DATE.equals("")) {
						String tmpDATUM = "";
						for(D01OTListData data : T_LIST) {
							tmpDATUM = DataUtil.removeStructur(data.getDATUM(), "-");
							
							if(PARAM_DATE.equals(tmpDATUM)) T_LIST_TMP.addElement(data);
						}
						
						T_LIST = T_LIST_TMP;
					}
					
					dest = WebUtil.JspURL + "D/D01OT/D01OTOvertimeInput.jsp";
				} else {
					export = rfc2.search(PERNR, PARAM_YYYY + PARAM_MM, isPop);
					
					T_HEADER = (Vector<D01OTHeaderData>) export.get(1);
					// 실적 건별 데이터
					T_REQTM = (Vector<D01OTReqtmData>) export.get(2);
					// 일별 정보 데이터
					T_RESULT = (Vector<D01OTResultData>) export.get(3);
					
					Vector<D01OTReqtmData> T_REQTM_TMP = new Vector<D01OTReqtmData>();
					
					// 팝업용 - PARAM_DATE값이 있을경우 T_REQTM테이블에 해당 일자 데이터만 선별한다.
					if(!PARAM_DATE.equals("")) {
						String tmpDATUM = "";
						for(D01OTReqtmData data : T_REQTM) {
							tmpDATUM = DataUtil.removeStructur(data.getDATUM(), "-");
							
							if(PARAM_DATE.equals(tmpDATUM)) T_REQTM_TMP.addElement(data);
						}
						
						T_REQTM = T_REQTM_TMP;
					}
					
					// 일자별로 결재승인이 아닌건이 있을경우 해당일자에 X값 셋팅
					HashMap<String, String> chekboxMap = new HashMap<String, String>();
					for(D01OTReqtmData tempReqtm: T_REQTM) {
						if(chekboxMap.get(tempReqtm.getDATUM()) == null) chekboxMap.put(tempReqtm.getDATUM(), "");
						if(!tempReqtm.getAPPR_STAT().equals("3")) {
							chekboxMap.put(tempReqtm.getDATUM(), "X");
						}
					}
					
					for(D01OTReqtmData tempReqtm: T_REQTM) {
						// 일자에 위에서 셋팅한 X값이 있을경우 ISDISABLED에 true값 셋팅(view에서 체크박스 비활성처리를 위한)
						String tempDatum = tempReqtm.getDATUM();
						if(chekboxMap.get(tempDatum).equals("X")) {
							tempReqtm.setISDISABLED("true");
						}
						
						// T_RESULT정보를 T_REQTM에 담는다.(일자 비교) - 테이블build 용
						for(D01OTResultData tempResult: T_RESULT) {
							if(tempResult.getDATUM().equals(tempReqtm.getDATUM())) {
								tempReqtm.setTRESULT(tempResult);
							}
						}
					}
				
					dest = WebUtil.JspURL + "D/D01OT/D01OTOvertimeInput2.jsp";
				}
				
				req.setAttribute("T_HEADER", T_HEADER);
				req.setAttribute("T_LIST", T_LIST);
				req.setAttribute("T_REQTM", T_REQTM);
				req.setAttribute("T_RESULT", T_RESULT);
				
				req.setAttribute("isPop", isPop);
				req.setAttribute("viewMode", viewMode);
				req.setAttribute("PARAM_YYYY", PARAM_YYYY);
				req.setAttribute("PARAM_MM", PARAM_MM);
				req.setAttribute("PARAM_DATE", PARAM_DATE);
				req.setAttribute("CURRENT_YEAR", CURRENT_YEAR);
				
				printJspPage(req, res, dest);
				
			} else if(PARAM_ACTION.equals("SAVE")) {
				
				RFCReturnEntity rfcReturn = null;
				
				if(compareDate.compareTo(searchDate) >= 0) {
					Vector<D01OTListData> T_LIST = box.getVector(hris.D.D01OT.D01OTListData.class);
					
					rfc.save(PERNR, PARAM_YYYY + PARAM_MM, T_LIST);
					
					rfcReturn = rfc.getReturn();
				} else {
					Vector<D01OTReqtmData> T_REQTM = box.getVector(hris.D.D01OT.D01OTReqtmData.class, "REQTM_", false);
					Vector<D01OTResultData> T_RESULT = box.getVector(hris.D.D01OT.D01OTResultData.class);
					
					rfc2.save(PERNR, PARAM_YYYY + PARAM_MM, T_REQTM, T_RESULT);
					
					rfcReturn = rfc2.getReturn();
				}
				
				if(rfcReturn.isSuccess()) {
					if("Y".equals(isPop)) {
						moveMsgPage(req, res, "msg008", "parent.self.close();");
					} else {
						moveMsgPage(req, res, "msg008",
								"location.href = '" + WebUtil.ServletURL+"hris.D.D01OT.D01OTOvertimeInputSV?PARAM_ACTION=SEARCH&isPop="+isPop+"&PARAM_DATE="+PARAM_DATE+"&PARAM_MM="+PARAM_MM+"&PARAM_YYYY="+PARAM_YYYY+"';");
					}
            	} else {
					moveMsgPage(req, res, rfcReturn.getMessage(), "history.back(); ");
            	}
				
			}
			
		} catch (Exception e) {
			throw new GeneralException(e);
		}
		
	}

}
