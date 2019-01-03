/********************************************************************************/
/*																				*/
/*   System Name	:  MSS														*/
/*   1Depth Name	:  부서근태													*/
/*   2Depth Name	:  초과근무													*/
/*   Program Name	:  초과근무(개별)												*/
/*   Program ID		:  D40OverTimeEachSV.java									*/
/*   Description	:  초과근무(개별)												*/
/*   Note			:  															*/
/*   Creation		:  2017-12-08  정준현                                          	*/
/*   Update			:  2017-12-08  정준현                                          	*/
/*   				:  2018-04-17 cykim [CSR ID:3660625] 현장직 Web 근태 시스템 수정 요청 */
/*   				:  2018-06-18 성환희 [WorkTime52]  							*/
/*                                                                             	*/
/********************************************************************************/
package servlet.hris.D.D40TmGroup;

import hris.D.D40TmGroup.D40DailScheFrameData;
import hris.D.D40TmGroup.D40OverTimeFrameData;
import hris.D.D40TmGroup.D40TmSchkzFrameData;
import hris.D.D40TmGroup.rfc.D40OverTimeEachRFC;
import hris.common.WebUserData;

import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.sns.jdf.GeneralException;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;

public class D40OverTimeEachSV extends EHRBaseServlet {

	protected void performTask( HttpServletRequest req, HttpServletResponse res ) throws GeneralException {

		try{

			WebUserData user    = WebUtil.getSessionUser(req);
			String gubun = WebUtil.nvl(req.getParameter("gubun"),"SEARCH");
			String orgOrTm = WebUtil.nvl(req.getParameter("orgOrTm"));
			String searchDeptNo = WebUtil.nvl(req.getParameter("searchDeptNo"));
//			String searchDeptNm = WebUtil.nvl(req.getParameter("searchDeptNm"));
			String iSeqno = WebUtil.nvl(req.getParameter("iSeqno"));
			String ISEQNO = WebUtil.nvl(req.getParameter("ISEQNO"));
			String I_SELTAB = WebUtil.nvl(req.getParameter("I_SELTAB"));
			String I_ACTTY = WebUtil.nvl(req.getParameter("I_ACTTY"));

			if("SEARCH".equals(gubun)){		//계획근무일정 조회 개별

		    	I_ACTTY = "R";	//T:일괄초기조회, U:일괄업로드, A:업로드후수정반영, R:개별조회, I:개별입력

		    	Vector OBJID = new Vector();
				if("2".equals(orgOrTm)){		//근태그룹으로 선택하기
					String[] iSeqnos = ISEQNO.split(",");
					for(int i=0; i<iSeqnos.length; i++){
						D40OverTimeFrameData data = new D40OverTimeFrameData();
						if(!"".equals(iSeqnos[i])){
							data.OBJID = WebUtil.nvl(iSeqnos[i]);
							OBJID.addElement(data);
						}
					}
				}else{		//조직도로 선택하기
					String[] deptNos = searchDeptNo.split(",");
					for(int i=0; i<deptNos.length; i++){
						if(!"".equals(WebUtil.nvl(deptNos[i]))){
							D40OverTimeFrameData data = new D40OverTimeFrameData();
							data.OBJID = WebUtil.nvl(deptNos[i]);
							OBJID.addElement(data);
						}
					}
				}
				String empNo = WebUtil.nvl(req.getParameter("I_PERNR"));
		    	String empNm = WebUtil.nvl(req.getParameter("I_ENAME"));

		    	Vector T_IMPERS = new Vector();
		    	String[] empNos = empNo.split(",");
		    	String[] empNms = empNm.split(",");

		    	for(int i=0; i<empNos.length; i++){
		    		D40OverTimeFrameData data = new D40OverTimeFrameData();
					if(!"".equals(empNos[i])){
						data.PERNR = WebUtil.nvl(empNos[i]);
						data.ENAME = WebUtil.nvl(empNms[i]);
						T_IMPERS.addElement(data);
					}
				}

		    	String I_BEGDA = "";
		    	String I_ENDDA = "";
		    	String I_SCHKZ = WebUtil.nvl(req.getParameter("I_SCHKZ"));

		    	if("".equals(WebUtil.nvl(req.getParameter("I_BEGDA")))){
		    		I_BEGDA = "";
		    	}else{
		    		I_BEGDA = WebUtil.nvl(req.getParameter("I_BEGDA")).replace(".","");
		    	}
		    	if("".equals(WebUtil.nvl(req.getParameter("I_ENDDA")))){
		    		I_ENDDA = "";
		    	}else{
		    		I_ENDDA = WebUtil.nvl(req.getParameter("I_ENDDA")).replace(".","");
		    	}

		    	Vector vec = (new D40OverTimeEachRFC()).getDailScheEach(user.empNo, I_ACTTY, I_BEGDA, I_ENDDA, I_SCHKZ, T_IMPERS, I_SELTAB, OBJID);

//				String E_RETURN    = (String)vec.get(0);		//return message code
//	            String E_MESSAGE = (String)vec.get(1);		//return message
	            String E_INFO = (String)vec.get(2);				//안내문구
	            String E_BEGDA = (String)vec.get(3);			//조회시작일
	            String E_ENDDA = (String)vec.get(4);			//조회종료일
	            Vector OBJPS_OUT1 = (Vector)vec.get(5);	//계획근무
	            Vector OBJPS_OUT2 = (Vector)vec.get(6);	//조회된 내용
	            Vector OBJPS_OUT3 = (Vector)vec.get(7);	//근태사유 코드-텍스트
	            Vector OBJPS_OUT4 = (Vector)vec.get(8);	//근태사유 코드-텍스트
	            Vector OBJPS_OUT5 = (Vector)vec.get(9);	//근태사유 코드-텍스트

	            req.setAttribute("I_DATUM", WebUtil.nvl(req.getParameter("I_DATUM")));
	            req.setAttribute("I_SCHKZ", I_SCHKZ);
	            req.setAttribute("I_PERNR", empNo);
	            req.setAttribute("I_ENAME", empNm);

	            req.setAttribute("E_INFO", E_INFO);
	            req.setAttribute("E_BEGDA", E_BEGDA);
	            req.setAttribute("E_ENDDA", E_ENDDA);
	            req.setAttribute("OBJPS_OUT1", OBJPS_OUT1);
	            req.setAttribute("OBJPS_OUT2", OBJPS_OUT2);
	            req.setAttribute("OBJPS_OUT3", OBJPS_OUT3);
	            req.setAttribute("OBJPS_OUT4", OBJPS_OUT4);
	            req.setAttribute("OBJPS_OUT5", OBJPS_OUT5);

	            req.setAttribute("textChange", "Y");		//일일근무일정 안내문구 교체한다.
	            req.setAttribute("viewSource", "true");
//	            printJspPage(req, res, WebUtil.JspURL + "D/D40TmGroup/D40DailScheEach.jsp");
	            printJspPage(req, res, WebUtil.JspURL + "D/D40TmGroup/D40OverTimeEach.jsp");

		    }else if("SAVE".equals(gubun)){		//계획근무일정 조회 개별

		    	String EDIT[] = req.getParameterValues("EDIT");
		    	String PERNR[] = req.getParameterValues("PERNR");
		    	String ENAME[] = req.getParameterValues("ENAME");
		    	String WWKTM[] = req.getParameterValues("WWKTM");
		    	/*오리지널 */
		    	String OSEQNR[] = req.getParameterValues("OSEQNR");
		    	String OBEGDA[] = req.getParameterValues("OBEGDA");
		    	String OENDDA[] = req.getParameterValues("OENDDA");
		    	String OBEGUZ[] = req.getParameterValues("OBEGUZ");
		    	String OENDUZ[] = req.getParameterValues("OENDUZ");
		    	String OPBEG1[] = req.getParameterValues("OPBEG1");
		    	String OPEND1[] = req.getParameterValues("OPEND1");
		    	String OPBEG2[] = req.getParameterValues("OPBEG2");
		    	String OPEND2[] = req.getParameterValues("OPEND2");
		    	//[CSR ID:3660625] 현장직 Web 근태 시스템 수정 요청 start
		    	String OVTKEN[] = req.getParameterValues("OVTKEN");
		    	//[CSR ID:3660625] 현장직 Web 근태 시스템 수정 요청 end
		    	String ACTIO[] = req.getParameterValues("ACTIO");
		    	String OREASON[] = req.getParameterValues("OREASON");
		    	String ODETAIL[] = req.getParameterValues("ODETAIL");
		    	/*오리지널 end*/
		    	String BEGDA[] = req.getParameterValues("BEGDA");
		    	String ENDDA[] = req.getParameterValues("ENDDA");
		    	String BEGUZ[] = req.getParameterValues("BEGUZ");
		    	String ENDUZ[] = req.getParameterValues("ENDUZ");
		    	String PBEG1[] = req.getParameterValues("PBEG1");
		    	String PEND1[] = req.getParameterValues("PEND1");
		    	String PBEG2[] = req.getParameterValues("PBEG2");
		    	String PEND2[] = req.getParameterValues("PEND2");
		    	String VTKEN[] = req.getParameterValues("VTKEN");
		    	String REASON[] = req.getParameterValues("REASON");
		    	String REASON_YN[] = req.getParameterValues("REASON_YN");
		    	String REASON_TX[] = req.getParameterValues("REASON_TX");
		    	String DETAIL[] = req.getParameterValues("DETAIL");
		    	String DETAIL_YN[] = req.getParameterValues("DETAIL_YN");
		    	String PKEY[] = req.getParameterValues("PKEY");
		    	String TPROG[] = req.getParameterValues("TPROG");

		    	String I_BEGDA = "";
		    	String I_ENDDA = "";
		    	String I_SCHKZ = WebUtil.nvl(req.getParameter("I_SCHKZ"));
		    	String empNo = WebUtil.nvl(req.getParameter("I_PERNR"));
		    	String empNm = WebUtil.nvl(req.getParameter("I_ENAME"));

		    	if("".equals(WebUtil.nvl(req.getParameter("I_BEGDA")))){
		    		I_BEGDA = "";
		    	}else{
		    		I_BEGDA = WebUtil.nvl(req.getParameter("I_BEGDA")).replace(".","");
		    	}
		    	if("".equals(WebUtil.nvl(req.getParameter("I_ENDDA")))){
		    		I_ENDDA = "";
		    	}else{
		    		I_ENDDA = WebUtil.nvl(req.getParameter("I_ENDDA")).replace(".","");
		    	}
		    	Vector OBJID = new Vector();
//		    	Vector OBJID2 = new Vector();

		    	//화면 데이터
		    	if(PERNR != null){
					for( int i = 0; i <  PERNR.length; i++ ){
						D40OverTimeFrameData data = new D40OverTimeFrameData();

						data.EDIT	= EDIT[i];
						data.PERNR	= PERNR[i];
						data.ENAME = ENAME[i];
						data.WWKTM = WWKTM[i];
						data.OSEQNR = OSEQNR[i];
						/*오리지널*/
						data.OBEGDA	= OBEGDA[i].replace(".","");
						data.OENDDA	= OENDDA[i].replace(".","");
						data.OBEGUZ	= OBEGUZ[i];
						data.OENDUZ	= OENDUZ[i];
						data.OPBEG1	= OPBEG1[i];
						data.OPEND1	= OPEND1[i];
						data.OPBEG2	= OPBEG2[i];
						data.OPEND2	= OPEND2[i];
						//[CSR ID:3660625] 현장직 Web 근태 시스템 수정 요청 start
				    	data.OVTKEN 	= OVTKEN[i];
				    	//[CSR ID:3660625] 현장직 Web 근태 시스템 수정 요청 end
						data.ACTIO = ACTIO[i];
						data.OREASON = OREASON[i];
						data.ODETAIL = ODETAIL[i];
						/*오리지널 end*/

						data.BEGDA	= BEGDA[i].replace(".","");
						data.ENDDA	= ENDDA[i].replace(".","");

						data.BEGUZ	= BEGUZ[i].replace(":","");
						if(!"".equals(WebUtil.nvl(ENDUZ[i]))){
							if("00:00".equals(WebUtil.nvl(ENDUZ[i]))){
								data.ENDUZ = "2400";
							}else{
								data.ENDUZ = ENDUZ[i].replace(":","");
							}
						}else{
							data.ENDUZ = ENDUZ[i];
						}

						data.PBEG1	= PBEG1[i].replace(":","");
						if(!"".equals(WebUtil.nvl(PEND1[i]))){
							if("00:00".equals(WebUtil.nvl(PEND1[i]))){
								data.PEND1 = "2400";
							}else{
								data.PEND1 = PEND1[i].replace(":","");
							}
						}else{
							data.PEND1 = PEND1[i];
						}

						data.PBEG2	= PBEG2[i].replace(":","");
						if(!"".equals(WebUtil.nvl(PEND2[i]))){
							if("00:00".equals(WebUtil.nvl(PEND2[i]))){
								data.PEND2 = "2400";
							}else{
								data.PEND2 = PEND2[i].replace(":","");
							}
						}else{
							data.PEND2 = PEND2[i];
						}

						data.VTKEN	= VTKEN[i];
						data.REASON = REASON[i];
						data.DETAIL = DETAIL[i];
						data.REASON_YN = REASON_YN[i];
						data.DETAIL_YN = DETAIL_YN[i];
						data.PKEY = PKEY[i];
						data.ACTIO = ACTIO[i];
						data.TPROG = TPROG[i];

						OBJID.addElement(data);
					}
		    	}
		    	//삭제된 데이터
//				if(OPERNR != null){
//					for( int i = 0; i <  OPERNR.length; i++ ){
//						D40OverTimeFrameData data = new D40OverTimeFrameData();
//						if("DEL".equals(ACTIO[i])){
//							data.EDIT	= OEDIT[i];
//							data.PERNR	= OPERNR[i];
//							data.ENAME = OENAME[i];
//							data.OSEQNR = OSEQNR[i];
//							data.OBEGDA	= OBEGDA[i].replace("-","");

//							data.VTKEN	= OVTKEN[i];
//							data.REASON = OREASON[i];
//							data.DETAIL = ODETAIL[i];
//							data.REASON_YN = OREASON_YN[i];
//							data.DETAIL_YN = ODETAIL_YN[i];
//							data.PKEY = OPKEY[i];
//							data.ACTIO = ACTIO[i];
//							OBJID2.addElement(data);
//						}
//					}
//				}

				D40OverTimeEachRFC rfc = new D40OverTimeEachRFC();
				I_ACTTY = "I";	//실행모드 :  I 개별입력, U 일괄업로드, A 업로드후수정반영
				Vector resultList = rfc.saveTable(user.empNo, I_ACTTY, OBJID,  I_BEGDA, I_ENDDA);

				String E_RETURN    = (String)resultList.get(0);		//return message code
	            String E_MESSAGE = (String)resultList.get(1);		//return message
	            String E_INFO = (String)resultList.get(2);				//안내문구
	            String E_BEGDA = (String)resultList.get(3);			//조회시작일
	            String E_ENDDA = (String)resultList.get(4);			//조회종료일
	            String E_SAVE_CNT = (String)resultList.get(5);		//저장시 건수 카운트 안내문구
	            Vector OBJPS_OUT1 = (Vector)resultList.get(6);	//계획근무
	            Vector OBJPS_OUT2 = (Vector)resultList.get(7);	//조회된 내용
	            Vector OBJPS_OUT3 = (Vector)resultList.get(8);	//일일근무
	            Vector OBJPS_OUT4 = (Vector)resultList.get(9);	//일일근무
	            Vector OBJPS_OUT5 = (Vector)resultList.get(10);	//기타
	            Vector OBJPS_OUT6 = (Vector)resultList.get(11);	//주 50시간 초과자

	            req.setAttribute("E_RETURN", E_RETURN);
	            req.setAttribute("I_BEGDA", I_BEGDA);
	            req.setAttribute("I_ENDDA", I_ENDDA);
	            req.setAttribute("I_SCHKZ", I_SCHKZ);
	            req.setAttribute("I_PERNR", empNo);
	            req.setAttribute("I_ENAME", empNm);
	            req.setAttribute("gubun", gubun);

//	            req.setAttribute("E_INFO", E_INFO);
//	            req.setAttribute("E_BEGDA", E_BEGDA);
//	            req.setAttribute("E_ENDDA", E_ENDDA);
	            req.setAttribute("E_SAVE_CNT", E_SAVE_CNT);
	            req.setAttribute("OBJPS_OUT1", OBJPS_OUT1);
	            req.setAttribute("OBJPS_OUT2", OBJPS_OUT2);
	            req.setAttribute("OBJPS_OUT3", OBJPS_OUT3);
	            req.setAttribute("OBJPS_OUT4", OBJPS_OUT4);
	            req.setAttribute("OBJPS_OUT5", OBJPS_OUT5);
	            req.setAttribute("OBJPS_OUT6", OBJPS_OUT6);
	            req.setAttribute("viewSource", "true");
//	            req.setAttribute("textChange", "Y");		//일일근무일정 안내문구 교체한다.

		    	printJspPage(req, res, WebUtil.JspURL + "D/D40TmGroup/D40OverTimeEach.jsp");

		    }else if("EXCEL".equals(gubun)){		//계획근무일정 조회 개별

		    	I_ACTTY = "R";	//T:일괄초기조회, U:일괄업로드, A:업로드후수정반영, R:개별조회, I:개별입력

		    	Vector OBJID = new Vector();
				if("2".equals(orgOrTm)){		//근태그룹으로 선택하기
					String[] iSeqnos = ISEQNO.split(",");
					for(int i=0; i<iSeqnos.length; i++){
						D40OverTimeFrameData data = new D40OverTimeFrameData();
						if(!"".equals(iSeqnos[i])){
							data.OBJID = WebUtil.nvl(iSeqnos[i]);
							OBJID.addElement(data);
						}
					}
				}else{		//조직도로 선택하기
					String[] deptNos = searchDeptNo.split(",");
					for(int i=0; i<deptNos.length; i++){
						if(!"".equals(WebUtil.nvl(deptNos[i]))){
							D40TmSchkzFrameData data = new D40TmSchkzFrameData();
							data.OBJID = WebUtil.nvl(deptNos[i]);
							OBJID.addElement(data);
						}
					}
				}
				String empNo = WebUtil.nvl(req.getParameter("I_PERNR"));
		    	String empNm = WebUtil.nvl(req.getParameter("I_ENAME"));

		    	Vector T_IMPERS = new Vector();
		    	String[] empNos = empNo.split(",");
		    	String[] empNms = empNm.split(",");

		    	for(int i=0; i<empNos.length; i++){
		    		D40DailScheFrameData data = new D40DailScheFrameData();
					if(!"".equals(empNos[i])){
						data.PERNR = WebUtil.nvl(empNos[i]);
						data.ENAME = WebUtil.nvl(empNms[i]);
						T_IMPERS.addElement(data);
					}
				}

		    	String I_BEGDA = "";
		    	String I_ENDDA = "";
		    	String I_SCHKZ = WebUtil.nvl(req.getParameter("I_SCHKZ"));

		    	if("".equals(WebUtil.nvl(req.getParameter("I_BEGDA")))){
		    		I_BEGDA = DataUtil.getCurrentDate();
		    	}else{
		    		I_BEGDA = WebUtil.nvl(req.getParameter("I_BEGDA")).replace(".","");
		    	}
		    	if("".equals(WebUtil.nvl(req.getParameter("I_ENDDA")))){
		    		I_ENDDA = DataUtil.getCurrentDate();
		    	}else{
		    		I_ENDDA = WebUtil.nvl(req.getParameter("I_ENDDA")).replace(".","");
		    	}

//		    	Vector vec = (new D40DailScheEachRFC()).getDailScheEach(user.empNo, I_ACTTY, I_BEGDA, I_ENDDA, I_SCHKZ, T_IMPERS, I_SELTAB, OBJID);
		    	Vector vec = (new D40OverTimeEachRFC()).getDailScheEach(user.empNo, I_ACTTY, I_BEGDA, I_ENDDA, I_SCHKZ, T_IMPERS, I_SELTAB, OBJID);

		    	String E_RETURN    = (String)vec.get(0);		//return message code
	            String E_MESSAGE = (String)vec.get(1);		//return message
	            String E_INFO = (String)vec.get(2);				//안내문구
	            String E_BEGDA = (String)vec.get(3);			//조회시작일
	            String E_ENDDA = (String)vec.get(4);			//조회종료일
	            Vector OBJPS_OUT1 = (Vector)vec.get(5);	//계획근무
	            Vector OBJPS_OUT2 = (Vector)vec.get(6);	//조회된 내용
	            Vector OBJPS_OUT3 = (Vector)vec.get(7);	//근태사유 코드-텍스트
	            Vector OBJPS_OUT4 = (Vector)vec.get(8);	//근태사유 코드-텍스트

//	            req.setAttribute("I_DATUM", WebUtil.nvl(req.getParameter("I_DATUM")));
//	            req.setAttribute("I_SCHKZ", I_SCHKZ);
//	            req.setAttribute("I_PERNR", empNo);
//	            req.setAttribute("I_ENAME", empNm);

//	            req.setAttribute("E_INFO", E_INFO);
//	            req.setAttribute("E_BEGDA", E_BEGDA);
//	            req.setAttribute("E_ENDDA", E_ENDDA);
//	            req.setAttribute("OBJPS_OUT1", OBJPS_OUT1);
	            req.setAttribute("OBJPS_OUT2", OBJPS_OUT2);
//	            req.setAttribute("OBJPS_OUT3", OBJPS_OUT3);
//	            req.setAttribute("OBJPS_OUT4", OBJPS_OUT4);
	            req.setAttribute("viewSource", "true");
				printJspPage(req, res, WebUtil.JspURL + "D/D40TmGroup/D40OverTimeEachExcel.jsp");

		    }else if("SEARCHONE".equals(gubun)){
		    	I_ACTTY = "P";	//P:행추가 후 입력필드 변경때마다 실행

		    	String searchPERNR = WebUtil.nvl(req.getParameter("searchPERNR"));
				String searchBEGDA = WebUtil.nvl(req.getParameter("searchBEGDA"));
				String no = WebUtil.nvl(req.getParameter("no"));

		    	Vector T_IMLIST = new Vector();
	    		D40OverTimeFrameData data = new D40OverTimeFrameData();

				if(!"".equals(searchPERNR)){
					data.PERNR = searchPERNR;
				}
				if(!"".equals(searchBEGDA)){
					data.BEGDA = searchBEGDA.replace(".","");
				}
				T_IMLIST.addElement(data);

		    	Vector vec = (new D40OverTimeEachRFC()).getOverTimeEachOne(user.empNo, I_ACTTY, T_IMLIST);

		    	Vector OBJPS_OUT1 = (Vector)vec.get(2);	//조회된 내용

		    	req.setAttribute("OBJPS_OUT1", OBJPS_OUT1);
		    	req.setAttribute("no", no);
		    	req.setAttribute("viewSource", "true");
		    	printJspPage(req, res, WebUtil.JspURL + "D/D40TmGroup/D40OverTimeEachHidden.jsp");

		    }

		} catch (Exception e) {
//			e.printStackTrace();
			throw new GeneralException(e);
		}
	}

}
