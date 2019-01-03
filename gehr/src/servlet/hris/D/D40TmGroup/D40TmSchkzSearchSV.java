/******************************************************************************/
/*																							*/
/*   System Name	:  MSS														*/
/*   1Depth Name		:   부서근태													*/
/*   2Depth Name		:   계획근무일정 											*/
/*   Program Name	:   계획근무일정(개별) 									*/
/*   Program ID		: D40TmSchkzSearchSV.java							*/
/*   Description		: 계획근무일정(개별)										*/
/*   Note				: 																*/
/*   Creation			: 2017-12-08  정준현                                          	*/
/*   Update				: 2017-12-08  정준현                                          	*/
/*                                                                              			*/
/********************************************************************************/
package servlet.hris.D.D40TmGroup;

import hris.D.D40TmGroup.D40TmSchkzFrameData;
import hris.D.D40TmGroup.rfc.D40TmSchkzFrameRFC;
import hris.common.WebUserData;

import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.sns.jdf.GeneralException;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.WebUtil;

public class D40TmSchkzSearchSV extends EHRBaseServlet {

	protected void performTask( HttpServletRequest req, HttpServletResponse res ) throws GeneralException {

		try{

			WebUserData user    = WebUtil.getSessionUser(req);
			String gubun = WebUtil.nvl(req.getParameter("gubun"));
			String orgOrTm = WebUtil.nvl(req.getParameter("orgOrTm"));
			String searchDeptNo = WebUtil.nvl(req.getParameter("searchDeptNo"));
			String searchDeptNm = WebUtil.nvl(req.getParameter("searchDeptNm"));
			String iSeqno = WebUtil.nvl(req.getParameter("iSeqno"));
			String ISEQNO = WebUtil.nvl(req.getParameter("ISEQNO"));
			String I_SELTAB = WebUtil.nvl(req.getParameter("I_SELTAB"));
			String I_ACTTY = WebUtil.nvl(req.getParameter("I_ACTTY"));

			if("EXCEL".equals(gubun)){

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
						D40TmSchkzFrameData data = new D40TmSchkzFrameData();
				    	data.OBJID = WebUtil.nvl(deptNos[i]);
				      	OBJID.addElement(data);
					}
				}
				String empNo = WebUtil.nvl(req.getParameter("I_PERNR"));
		    	String empNm = WebUtil.nvl(req.getParameter("I_ENAME"));

		    	Vector T_IMPERS = new Vector();
		    	String[] empNos = empNo.split(",");
		    	String[] empNms = empNm.split(",");
		    	for(int i=0; i<empNos.length; i++){
					D40TmSchkzFrameData data = new D40TmSchkzFrameData();
					if(!"".equals(empNos[i])){
						data.PERNR = WebUtil.nvl(empNos[i]);
						data.ENAME = WebUtil.nvl(empNms[i]);
						T_IMPERS.addElement(data);
					}
				}

		    	String I_DATUM = WebUtil.nvl(req.getParameter("I_DATUM")).replace(".","");
		    	String I_SCHKZ = WebUtil.nvl(req.getParameter("I_SCHKZ"));

		    	Vector resultList = (new D40TmSchkzFrameRFC()).getTmSchkzFrame(user.empNo, I_ACTTY, I_DATUM, I_SCHKZ, T_IMPERS, I_SELTAB, OBJID);

				Vector OBJPS_OUT2 = (Vector)resultList.get(5);	//조회된 내용

				req.setAttribute("resultList", OBJPS_OUT2);

				printJspPage(req, res, WebUtil.JspURL + "D/D40TmGroup/D40TmSchkzSearchExcel.jsp");

		    }else if("SAVE".equals(gubun)){

		    	String PERNR[] = req.getParameterValues("PERNR");		//사번
		    	String ENAME[] = req.getParameterValues("ENAME");		//성명
		    	String BEGDA[] = req.getParameterValues("BEGDA");		//시작일
		    	String ENDDA[] = req.getParameterValues("ENDDA");		//종료일
		    	String SCHKZ[] = req.getParameterValues("SCHKZ");		//계획근무일정 코드
		    	String SCHKZ_TX[] = req.getParameterValues("SCHKZ_TX");	//계획근무일정 텍스트
		    	String NBEGDA[] = req.getParameterValues("NBEGDA");		//변경 - 시작일
		    	String NENDDA[] = req.getParameterValues("NENDDA");		//변경 - 종료일
		    	String NSCHKZ[] = req.getParameterValues("NSCHKZ");		//변경 - 계획근무일정 코드

		    	String empNo = WebUtil.nvl(req.getParameter("I_PERNR"));
		    	String empNm = WebUtil.nvl(req.getParameter("I_ENAME"));
		    	String I_SCHKZ = WebUtil.nvl(req.getParameter("I_SCHKZ"));

		    	Vector OBJID = new Vector();
				for( int i = 0; i <  PERNR.length; i++ ){
					D40TmSchkzFrameData dt = new D40TmSchkzFrameData();
					dt.PERNR = PERNR[i];
					dt.ENAME = ENAME[i];
					dt.BEGDA = BEGDA[i];
					dt.ENDDA = ENDDA[i];
					dt.SCHKZ = SCHKZ[i];
					dt.SCHKZ_TX = SCHKZ_TX[i];
					dt.NBEGDA = NBEGDA[i];
					dt.NENDDA = NENDDA[i];
					dt.NSCHKZ = NSCHKZ[i];

					OBJID.addElement(dt);
				}

				D40TmSchkzFrameRFC rfc = new D40TmSchkzFrameRFC();
				I_ACTTY = "I";	//실행모드 >>  I 개별입력 , U 일괄업로드, A 업로드후수정반영,
				Vector resultList = rfc.saveTable(user.empNo, I_ACTTY, OBJID);

				String E_RETURN = (String)resultList.get(0);		// E_RETURN
				String E_MESSAGE = (String)resultList.get(1);	// E_MESSAGE
				Vector T_SCHKZ = (Vector)resultList.get(2);	//리스트 데이터
				Vector T_EXLIST = (Vector)resultList.get(3);	//조회 selectbox
				String E_DATUM = (String)resultList.get(4);	//조회 selectbox
				String E_SAVE_CNT = (String)resultList.get(5);	//조회 selectbox

				req.setAttribute("I_DATUM", WebUtil.nvl(req.getParameter("I_DATUM")));
	            req.setAttribute("I_SCHKZ", I_SCHKZ);
	            req.setAttribute("I_PERNR", empNo);
	            req.setAttribute("I_ENAME", empNm);

				req.setAttribute("OBJPS_OUT", T_SCHKZ);
	   		 	req.setAttribute("T_EXLIST", T_EXLIST);
				req.setAttribute("gubun", gubun);
				req.setAttribute("E_DATUM", E_DATUM);
				req.setAttribute("E_SAVE_CNT", E_SAVE_CNT);

				req.setAttribute("E_RETURN", E_RETURN);
				req.setAttribute("E_MESSAGE", E_MESSAGE);

				req.setAttribute("viewSource", "true");

		    	printJspPage(req, res, WebUtil.JspURL + "D/D40TmGroup/D40TmSchkzSearch.jsp");

		    }else if("SEARCH".equals(gubun)){		//계획근무일정 조회 개별

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
						D40TmSchkzFrameData data = new D40TmSchkzFrameData();
				    	data.OBJID = WebUtil.nvl(deptNos[i]);
				      	OBJID.addElement(data);
					}
				}
				String empNo = WebUtil.nvl(req.getParameter("I_PERNR"));
		    	String empNm = WebUtil.nvl(req.getParameter("I_ENAME"));

		    	Vector T_IMPERS = new Vector();
		    	String[] empNos = empNo.split(",");
		    	String[] empNms = empNm.split(",");
		    	for(int i=0; i<empNos.length; i++){
					D40TmSchkzFrameData data = new D40TmSchkzFrameData();
					if(!"".equals(empNos[i])){
						data.PERNR = WebUtil.nvl(empNos[i]);
						data.ENAME = WebUtil.nvl(empNms[i]);
						T_IMPERS.addElement(data);
					}
				}

		    	String I_DATUM = WebUtil.nvl(req.getParameter("I_DATUM")).replace(".","");
		    	String I_SCHKZ = WebUtil.nvl(req.getParameter("I_SCHKZ"));

		    	Vector vec = (new D40TmSchkzFrameRFC()).getTmSchkzFrame(user.empNo, I_ACTTY, I_DATUM, I_SCHKZ, T_IMPERS, I_SELTAB, OBJID);
//				String E_RETURN    = (String)vec.get(0);
//	            String E_MESSAGE = (String)vec.get(1);
	            String E_INFO = (String)vec.get(2);	//안내문구
	            Vector OBJPS_OUT = (Vector)vec.get(3);	//계획근무일정
	            String E_DATUM = (String)vec.get(4);	//현근무일정 조회기준일
	            Vector OBJPS_OUT2 = (Vector)vec.get(5);	//조회된 내용


	            req.setAttribute("I_DATUM", WebUtil.nvl(req.getParameter("I_DATUM")));
	            req.setAttribute("I_SCHKZ", I_SCHKZ);
	            req.setAttribute("I_PERNR", empNo);
	            req.setAttribute("I_ENAME", empNm);

	            req.setAttribute("E_INFO", E_INFO);
	            req.setAttribute("E_DATUM", E_DATUM);
	            req.setAttribute("OBJPS_OUT", OBJPS_OUT);
	            req.setAttribute("OBJPS_OUT2", OBJPS_OUT2);

	            req.setAttribute("viewSource", "true");

	            printJspPage(req, res, WebUtil.JspURL + "D/D40TmGroup/D40TmSchkzSearch.jsp");

//		    	printJspPage(req, res, WebUtil.JspURL + "D/D40TmGroup/D40TmSchkzSearch.jsp");

		    }else{

		    	I_ACTTY = "R";	//T:일괄초기조회, U:일괄업로드, A:업로드후수정반영, R:개별조회, I:개별입력

		    	Vector OBJID = new Vector();
				if("2".equals(orgOrTm)){		//근태그룹으로 선택하기
					String[] iseqnos = ISEQNO.split(",");
					for(int i=0; i<iseqnos.length; i++){
						D40TmSchkzFrameData data = new D40TmSchkzFrameData();
						if(!"".equals(iseqnos[i])){
							data.OBJID = WebUtil.nvl(iseqnos[i]);
							OBJID.addElement(data);
						}
					}
				}else{		//조직도로 선택하기
					String[] deptNos = searchDeptNo.split(",");
					for(int i=0; i<deptNos.length; i++){
						D40TmSchkzFrameData data = new D40TmSchkzFrameData();
				    	data.OBJID = WebUtil.nvl(deptNos[i]);
				      	OBJID.addElement(data);
					}
				}
				String empNo = WebUtil.nvl(req.getParameter("I_PERNR"));
		    	String empNm = WebUtil.nvl(req.getParameter("I_ENAME"));

		    	Vector T_IMPERS = new Vector();
		    	String[] empNos = empNo.split(",");
		    	String[] empNms = empNm.split(",");
		    	for(int i=0; i<empNos.length; i++){
					D40TmSchkzFrameData data = new D40TmSchkzFrameData();
					if(!"".equals(empNos[i])){
						data.PERNR = WebUtil.nvl(empNos[i]);
						data.ENAME = WebUtil.nvl(empNms[i]);
						T_IMPERS.addElement(data);
					}
				}

		    	String I_DATUM = WebUtil.nvl(req.getParameter("I_DATUM")).replace(".","");
		    	String I_SCHKZ = WebUtil.nvl(req.getParameter("I_SCHKZ"));

		    	I_ACTTY = "R";	//T:일괄초기조회, U:일괄업로드, A:업로드후수정반영, R:개별조회, I:개별입력
		    	Vector vec = (new D40TmSchkzFrameRFC()).getTmSchkzFrame(user.empNo, I_ACTTY, I_DATUM, I_SCHKZ, T_IMPERS, I_SELTAB, OBJID);
//				String E_RETURN    = (String)vec.get(0);
//	            String E_MESSAGE = (String)vec.get(1);
	            String E_INFO = (String)vec.get(2);	//안내문구
	            Vector OBJPS_OUT = (Vector)vec.get(3);	//계획근무일정
	            String E_DATUM = (String)vec.get(4);	//현근무일정 조회기준일
	            Vector OBJPS_OUT2 = (Vector)vec.get(5);	//조회된 내용

	            req.setAttribute("E_INFO", E_INFO);
	            req.setAttribute("E_DATUM", E_DATUM);
	            req.setAttribute("OBJPS_OUT", OBJPS_OUT);
	            req.setAttribute("OBJPS_OUT2", OBJPS_OUT2);

	            req.setAttribute("viewSource", "true");

	            printJspPage(req, res, WebUtil.JspURL + "D/D40TmGroup/D40TmSchkzSearch.jsp");

		    }

		} catch (Exception e) {
			throw new GeneralException(e);
		}
	}

}
