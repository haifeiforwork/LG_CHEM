/******************************************************************************/
/*																							*/
/*   System Name	:  MSS														*/
/*   1Depth Name		:  부서근태													*/
/*   2Depth Name		:  일일근무일정												*/
/*   Program Name	:  일일근무일정(개별)										*/
/*   Program ID		:  D40DailScheEachSV.java							*/
/*   Description		:  일일근무일정(개별)										*/
/*   Note				:  																*/
/*   Creation			:  2017-12-08  정준현                                          	*/
/*   Update				:  2017-12-08  정준현                                          	*/
/*                                                                              			*/
/********************************************************************************/
package servlet.hris.D.D40TmGroup;

import hris.D.D40TmGroup.D40DailScheFrameData;
import hris.D.D40TmGroup.D40TmSchkzFrameData;
import hris.D.D40TmGroup.rfc.D40DailScheEachRFC;
import hris.common.WebUserData;

import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.sns.jdf.GeneralException;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;

public class D40DailScheEachSV extends EHRBaseServlet {

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
						D40TmSchkzFrameData data = new D40TmSchkzFrameData();
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

		    	Vector vec = (new D40DailScheEachRFC()).getDailScheEach(user.empNo, I_ACTTY, I_BEGDA, I_ENDDA, I_SCHKZ, T_IMPERS, I_SELTAB, OBJID);

				String E_RETURN    = (String)vec.get(0);		//return message code
	            String E_MESSAGE = (String)vec.get(1);		//return message
	            String E_INFO = (String)vec.get(2);				//안내문구
	            String E_BEGDA = (String)vec.get(3);			//조회시작일
	            String E_ENDDA = (String)vec.get(4);			//조회종료일
	            Vector OBJPS_OUT1 = (Vector)vec.get(5);	//계획근무
	            Vector OBJPS_OUT2 = (Vector)vec.get(6);	//조회된 내용
	            Vector OBJPS_OUT3 = (Vector)vec.get(7);	//일일근무

	            req.setAttribute("I_DATUM", WebUtil.nvl(req.getParameter("I_DATUM")));
	            req.setAttribute("I_SCHKZ", I_SCHKZ);
	            req.setAttribute("I_PERNR", empNo);
	            req.setAttribute("I_ENAME", empNm);
	            req.setAttribute("gubun", gubun);

	            req.setAttribute("E_INFO", E_INFO);
	            req.setAttribute("E_BEGDA", E_BEGDA);
	            req.setAttribute("E_ENDDA", E_ENDDA);
	            req.setAttribute("OBJPS_OUT1", OBJPS_OUT1);
	            req.setAttribute("OBJPS_OUT2", OBJPS_OUT2);
	            req.setAttribute("OBJPS_OUT3", OBJPS_OUT3);
	            req.setAttribute("viewSource", "true");
	            req.setAttribute("textChange", "Y");		//일일근무일정 안내문구 교체한다.

	            printJspPage(req, res, WebUtil.JspURL + "D/D40TmGroup/D40DailScheEach.jsp");

		    }else if("SAVE".equals(gubun)){		//계획근무일정 조회 개별

		    	String EDIT[] = req.getParameterValues("EDIT");
		    	String PERNR[] = req.getParameterValues("PERNR");
		    	String ENAME[] = req.getParameterValues("ENAME");
		    	String BEGDA[] = req.getParameterValues("BEGDA");
		    	String ENDDA[] = req.getParameterValues("ENDDA");
		    	String TPROG[] = req.getParameterValues("TPROG");

		    	String ACTIO[] = req.getParameterValues("ACTIO");
		    	String OBEGDA[] = req.getParameterValues("OBEGDA");
		    	String OENDDA[] = req.getParameterValues("OENDDA");
		    	String OSEQNR[] = req.getParameterValues("OSEQNR");
		    	String OTPROG[] = req.getParameterValues("OTPROG");

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
				for( int i = 0; i <  PERNR.length; i++ ){
					D40DailScheFrameData data = new D40DailScheFrameData();
//					if("X".equals(EDIT[i])){

						data.EDIT = EDIT[i];
						data.PERNR = PERNR[i];
						data.ENAME = ENAME[i];
						data.BEGDA = BEGDA[i];
						data.ENDDA = ENDDA[i];
						data.TPROG = TPROG[i];

						data.ACTIO = ACTIO[i];
						data.OBEGDA = OBEGDA[i];
						data.OENDDA = OENDDA[i];
						data.OSEQNR = OSEQNR[i];
						data.OTPROG = OTPROG[i];
						OBJID.addElement(data);
//					}
				}

				D40DailScheEachRFC rfc = new D40DailScheEachRFC();
				I_ACTTY = "I";	//실행모드 :  I 개별입력, U 일괄업로드, A 업로드후수정반영
				Vector resultList = rfc.saveTable(user.empNo, I_ACTTY, OBJID, I_BEGDA, I_ENDDA);

				String E_RETURN    = (String)resultList.get(0);		//return message code
	            String E_MESSAGE = (String)resultList.get(1);		//return message
	            String E_INFO = (String)resultList.get(2);				//안내문구
	            String E_BEGDA = (String)resultList.get(3);			//조회시작일
	            String E_ENDDA = (String)resultList.get(4);			//조회종료일
	            String E_SAVE_CNT = (String)resultList.get(5);		//저장시 건수 카운트 안내문구
	            Vector OBJPS_OUT1 = (Vector)resultList.get(6);	//계획근무
	            Vector OBJPS_OUT2 = (Vector)resultList.get(7);	//조회된 내용
	            Vector OBJPS_OUT3 = (Vector)resultList.get(8);	//일일근무

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
	            req.setAttribute("viewSource", "true");

//	            req.setAttribute("textChange", "Y");		//일일근무일정 안내문구 교체한다.

		    	printJspPage(req, res, WebUtil.JspURL + "D/D40TmGroup/D40DailScheEach.jsp");

		    }else if("EXCEL".equals(gubun)){		//계획근무일정 조회 개별

		    	I_ACTTY = "R";	//T:일괄초기조회, U:일괄업로드, A:업로드후수정반영, R:개별조회, I:개별입력

		    	Vector OBJID = new Vector();
				if("2".equals(orgOrTm)){		//근태그룹으로 선택하기
					String[] iSeqnos = ISEQNO.split(",");
					for(int i=0; i<iSeqnos.length; i++){
						D40TmSchkzFrameData data = new D40TmSchkzFrameData();
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

		    	Vector vec = (new D40DailScheEachRFC()).getDailScheEach(user.empNo, I_ACTTY, I_BEGDA, I_ENDDA, I_SCHKZ, T_IMPERS, I_SELTAB, OBJID);

				String E_RETURN    = (String)vec.get(0);		//return message code
	            String E_MESSAGE = (String)vec.get(1);		//return message
	            String E_INFO = (String)vec.get(2);				//안내문구
	            String E_BEGDA = (String)vec.get(3);			//조회시작일
	            String E_ENDDA = (String)vec.get(4);			//조회종료일
	            Vector OBJPS_OUT1 = (Vector)vec.get(5);	//계획근무
	            Vector OBJPS_OUT2 = (Vector)vec.get(6);	//조회된 내용
	            Vector OBJPS_OUT3 = (Vector)vec.get(7);	//일일근무

				req.setAttribute("resultList", OBJPS_OUT2);

				printJspPage(req, res, WebUtil.JspURL + "D/D40TmGroup/D40DailScheEachExcel.jsp");

		    }else if("SEARCHONE".equals(gubun)){		//행 조회

		    	I_ACTTY = "P";	//P:행추가 후 입력필드 변경때마다 실행

		    	String searchPERNR = WebUtil.nvl(req.getParameter("searchPERNR"));
				String searchBEGDA = WebUtil.nvl(req.getParameter("searchBEGDA"));
				String no = WebUtil.nvl(req.getParameter("no"));


		    	Vector T_IMLIST = new Vector();
		    	D40DailScheFrameData data = new D40DailScheFrameData();

				if(!"".equals(searchPERNR)){
					data.PERNR = searchPERNR;
				}
				if(!"".equals(searchBEGDA)){
					data.BEGDA = searchBEGDA.replace(".","");
				}

				T_IMLIST.addElement(data);

		    	Vector vec = (new D40DailScheEachRFC()).getDailScheOne(user.empNo, I_ACTTY, T_IMLIST);

		    	String E_RETURN = (String)vec.get(0);	//RETURN
		    	String E_MESSAGE = (String)vec.get(1);	//RETURN message
		    	Vector OBJPS_OUT1 = (Vector)vec.get(2);	//조회된 내용

		    	req.setAttribute("OBJPS_OUT1", OBJPS_OUT1);
		    	req.setAttribute("E_RETURN", E_RETURN);
		    	req.setAttribute("no", no);
		    	req.setAttribute("viewSource", "true");
		    	printJspPage(req, res, WebUtil.JspURL + "D/D40TmGroup/D40DailScheHidden.jsp");

		    }

		} catch (Exception e) {
//			e.printStackTrace();
			throw new GeneralException(e);
		}
	}

}
