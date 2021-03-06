/******************************************************************************/
/*																							*/
/*   System Name	:  MSS														*/
/*   1Depth Name		:  부서근태													*/
/*   2Depth Name		:  비근무/근무												*/
/*   Program Name	:  비근무/근무(개별)										*/
/*   Program ID		:  D40AbscTimeEachSV.java							*/
/*   Description		:  비근무/근무(개별)										*/
/*   Note				:             													*/
/*   Creation			:  2017-12-08  정준현                                          	*/
/*   Update				:  2017-12-08  정준현                                          	*/
/*                                                                              			*/
/********************************************************************************/
package servlet.hris.D.D40TmGroup;

import hris.D.D40TmGroup.D40AbscTimeFrameData;
import hris.D.D40TmGroup.D40DailScheFrameData;
import hris.D.D40TmGroup.D40TmSchkzFrameData;
import hris.D.D40TmGroup.rfc.D40AbscTimeEachRFC;
import hris.D.D40TmGroup.rfc.D40AbscTimeLumpFrameRFC;
import hris.common.WebUserData;

import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.sns.jdf.GeneralException;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;

public class D40AbscTimeEachSV extends EHRBaseServlet {

	protected void performTask( HttpServletRequest req, HttpServletResponse res ) throws GeneralException {

		try{

			WebUserData user    = WebUtil.getSessionUser(req);
			String gubun = WebUtil.nvl(req.getParameter("gubun"),"SEARCH");
			String orgOrTm = WebUtil.nvl(req.getParameter("orgOrTm"));
			String searchDeptNo = WebUtil.nvl(req.getParameter("searchDeptNo"));
			String searchDeptNm = WebUtil.nvl(req.getParameter("searchDeptNm"));
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
						D40AbscTimeFrameData data = new D40AbscTimeFrameData();
						if(!"".equals(iSeqnos[i])){
							data.OBJID = WebUtil.nvl(iSeqnos[i]);
							OBJID.addElement(data);
						}
					}
				}else{		//조직도로 선택하기
					String[] deptNos = searchDeptNo.split(",");
					for(int i=0; i<deptNos.length; i++){
						if(!"".equals(WebUtil.nvl(deptNos[i]))){
							D40AbscTimeFrameData data = new D40AbscTimeFrameData();
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
		    		D40AbscTimeFrameData data = new D40AbscTimeFrameData();
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
//		    		I_BEGDA = DataUtil.getCurrentDate();
		    		I_BEGDA = "";
		    	}else{
		    		I_BEGDA = WebUtil.nvl(req.getParameter("I_BEGDA")).replace(".","");
		    	}
		    	if("".equals(WebUtil.nvl(req.getParameter("I_ENDDA")))){
//		    		I_ENDDA = DataUtil.getCurrentDate();
		    		I_ENDDA = "";
		    	}else{
		    		I_ENDDA = WebUtil.nvl(req.getParameter("I_ENDDA")).replace(".","");
		    	}

		    	Vector vec = (new D40AbscTimeEachRFC()).getDailScheEach(user.empNo, I_ACTTY, I_BEGDA, I_ENDDA, I_SCHKZ, T_IMPERS, I_SELTAB, OBJID);

				String E_RETURN    = (String)vec.get(0);		//return message code
	            String E_MESSAGE = (String)vec.get(1);		//return message
	            String E_INFO = (String)vec.get(2);				//안내문구
	            String E_BEGDA = (String)vec.get(3);			//조회시작일
	            String E_ENDDA = (String)vec.get(4);			//조회종료일
	            Vector OBJPS_OUT1 = (Vector)vec.get(5);	//계획근무
	            Vector OBJPS_OUT2 = (Vector)vec.get(6);	//조회된 내용
	            Vector OBJPS_OUT3 = (Vector)vec.get(7);	//근태사유 코드-텍스트
	            Vector OBJPS_OUT4 = (Vector)vec.get(8);	//근태사유 코드-텍스트
	            Vector OBJPS_OUT5 = (Vector)vec.get(9);	//기타

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
	            printJspPage(req, res, WebUtil.JspURL + "D/D40TmGroup/D40AbscTimeEach.jsp");

		    }else if("SAVE".equals(gubun)){		//계획근무일정 조회 개별

		    	String EDIT[] = req.getParameterValues("EDIT");
		    	String PERNR[] = req.getParameterValues("PERNR");
		    	String ENAME[] = req.getParameterValues("ENAME");
		    	String ACTIO[] = req.getParameterValues("ACTIO");

		    	/*오리지널 */
		    	String OBEGDA[] = req.getParameterValues("OBEGDA");
		    	String OENDDA[] = req.getParameterValues("OENDDA");
		    	String OSEQNR[] = req.getParameterValues("OSEQNR");
		    	String OWTMCODE[] = req.getParameterValues("OWTMCODE");
		    	String OAWART[] = req.getParameterValues("OAWART");
		    	String OINFTY[] = req.getParameterValues("OINFTY");
		    	String OBEGUZ[] = req.getParameterValues("OBEGUZ");
		    	String OENDUZ[] = req.getParameterValues("OENDUZ");
		    	String OREASON[] = req.getParameterValues("OREASON");
		    	String ODETAIL[] = req.getParameterValues("ODETAIL");
		    	/*오리지널 end*/
		    	String BEGDA[] = req.getParameterValues("BEGDA");
		    	String ENDDA[] = req.getParameterValues("ENDDA");
		    	String WTMCODE[] = req.getParameterValues("WTMCODE");
		    	String AWART[] = req.getParameterValues("AWART");
		    	String INFTY[] = req.getParameterValues("INFTY");
		    	String BEGUZ[] = req.getParameterValues("BEGUZ");
		    	String ENDUZ[] = req.getParameterValues("ENDUZ");
		    	String REASON[] = req.getParameterValues("REASON");
		    	String REASON_YN[] = req.getParameterValues("REASON_YN");
		    	String REASON_TX[] = req.getParameterValues("REASON_TX");
		    	String DETAIL[] = req.getParameterValues("DETAIL");
		    	String DETAIL_YN[] = req.getParameterValues("DETAIL_YN");
		    	String TIME_YN[] = req.getParameterValues("TIME_YN");
		    	String TPROG[] = req.getParameterValues("TPROG");

		    	String I_BEGDA = "";
		    	String I_ENDDA = "";
		    	String I_SCHKZ = WebUtil.nvl(req.getParameter("I_SCHKZ"));
		    	String empNo = WebUtil.nvl(req.getParameter("I_PERNR"));
		    	String empNm = WebUtil.nvl(req.getParameter("I_ENAME"));

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
		    	Vector OBJID = new Vector();
//		    	Vector OBJID2 = new Vector();

		    	//화면 데이터
		    	if(PERNR != null){
					for( int i = 0; i <  PERNR.length; i++ ){
						D40AbscTimeFrameData data = new D40AbscTimeFrameData();

						data.EDIT	= EDIT[i];
						data.PERNR	= PERNR[i];
						data.ENAME = ENAME[i];
						data.ACTIO = ACTIO[i];		//인포타입운영	- 행추가INS /  행삭제 DEL

						/*오리지널*/
						data.OBEGDA	= OBEGDA[i].replace(".","");	//오리지널-시작일
						data.OENDDA	= OENDDA[i].replace(".","");	//오리지널-종료일
						data.OWTMCODE	= OWTMCODE[i];				//오리지널-근태유형
						data.OAWART	= OAWART[i];						// 오리지널-근무/휴무 유형
						data.OINFTY	= OINFTY[i];						// 오리지널-인포타입
						data.OSEQNR	= OSEQNR[i];						// 오리지널-인포타입
						data.OBEGUZ	= OBEGUZ[i];						//오리지널-시작시간
						data.OENDUZ	= OENDUZ[i];						//오리지널-종료시간
						data.OREASON = OREASON[i];					//오리지널-사유코드
						data.ODETAIL = ODETAIL[i];						//오리지널-상세사유
						/*오리지널 end*/

						data.BEGDA	= BEGDA[i].replace(".","");			//시작일
						data.ENDDA	= ENDDA[i].replace(".","");			//종료일
						data.WTMCODE	= WTMCODE[i];				//근태유형
						data.AWART	= AWART[i];						//근무/휴무 유형
						data.INFTY	= INFTY[i];								//인포타입
						data.TPROG	= TPROG[i];								//일일근무일정

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

						data.REASON = REASON[i];
						data.DETAIL = DETAIL[i];
						data.REASON_YN = REASON_YN[i];
						data.DETAIL_YN = DETAIL_YN[i];
						data.TIME_YN = TIME_YN[i];

						OBJID.addElement(data);
					}
		    	}
				D40AbscTimeEachRFC rfc = new D40AbscTimeEachRFC();
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
	            Vector OBJPS_OUT3 = (Vector)resultList.get(8);	//근태사유
	            Vector OBJPS_OUT4 = (Vector)resultList.get(9);	//유형
	            Vector OBJPS_OUT5 = (Vector)resultList.get(10);	//기타

	            req.setAttribute("E_RETURN", E_RETURN);
	            req.setAttribute("I_BEGDA", I_BEGDA);
	            req.setAttribute("I_ENDDA", I_ENDDA);
	            req.setAttribute("I_SCHKZ", I_SCHKZ);
	            req.setAttribute("I_PERNR", empNo);
	            req.setAttribute("I_ENAME", empNm);
	            req.setAttribute("gubun", gubun);

	            req.setAttribute("E_SAVE_CNT", E_SAVE_CNT);
	            req.setAttribute("OBJPS_OUT1", OBJPS_OUT1);	//계획근무
	            req.setAttribute("OBJPS_OUT2", OBJPS_OUT2);	//조회된 내용
	            req.setAttribute("OBJPS_OUT3", OBJPS_OUT3);	//근태사유
	            req.setAttribute("OBJPS_OUT4", OBJPS_OUT4);	//유형
	            req.setAttribute("OBJPS_OUT5", OBJPS_OUT5);	//기타
	            req.setAttribute("viewSource", "true");
//	            req.setAttribute("textChange", "Y");		//일일근무일정 안내문구 교체한다.

		    	printJspPage(req, res, WebUtil.JspURL + "D/D40TmGroup/D40AbscTimeEach.jsp");

		    }else if("EXCEL".equals(gubun)){		//계획근무일정 조회 개별

		    	I_ACTTY = "R";	//T:일괄초기조회, U:일괄업로드, A:업로드후수정반영, R:개별조회, I:개별입력

		    	Vector OBJID = new Vector();
				if("2".equals(orgOrTm)){		//근태그룹으로 선택하기
					String[] iSeqnos = ISEQNO.split(",");
					for(int i=0; i<iSeqnos.length; i++){
						D40AbscTimeFrameData data = new D40AbscTimeFrameData();
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
		    	Vector vec = (new D40AbscTimeEachRFC()).getDailScheEach(user.empNo, I_ACTTY, I_BEGDA, I_ENDDA, I_SCHKZ, T_IMPERS, I_SELTAB, OBJID);

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
				printJspPage(req, res, WebUtil.JspURL + "D/D40TmGroup/D40AbscTimeEachExcel.jsp");

		    }else if("SEARCHONE".equals(gubun)){

		    	I_ACTTY = "P";	//P:행추가 후 입력필드 변경때마다 실행

		    	String searchPERNR = WebUtil.nvl(req.getParameter("searchPERNR"));
				String searchBEGDA = WebUtil.nvl(req.getParameter("searchBEGDA"));
				String searchWTMCODE = WebUtil.nvl(req.getParameter("searchWTMCODE"));
				String no = WebUtil.nvl(req.getParameter("no"));

		    	Vector T_IMLIST = new Vector();
	    		D40AbscTimeFrameData data = new D40AbscTimeFrameData();

				if(!"".equals(searchPERNR)){
					data.PERNR = searchPERNR;
				}
				if(!"".equals(searchBEGDA)){
					data.BEGDA = searchBEGDA.replace(".","");
				}
				if(!"".equals(searchWTMCODE)){
					data.WTMCODE = searchWTMCODE;
				}
				T_IMLIST.addElement(data);

		    	Vector vec = (new D40AbscTimeLumpFrameRFC()).getOverTimeOne(user.empNo, I_ACTTY, T_IMLIST);

		    	Vector OBJPS_OUT1 = (Vector)vec.get(2);	//조회된 내용
		    	String E_RETURN = (String)vec.get(3);	//RETURN

		    	req.setAttribute("OBJPS_OUT1", OBJPS_OUT1);
		    	req.setAttribute("E_RETURN", E_RETURN);
		    	req.setAttribute("no", no);
		    	req.setAttribute("viewSource", "true");
		    	printJspPage(req, res, WebUtil.JspURL + "D/D40TmGroup/D40AbscTimeHidden.jsp");

		    }

		} catch (Exception e) {
//			e.printStackTrace();
			throw new GeneralException(e);
		}
	}

}
