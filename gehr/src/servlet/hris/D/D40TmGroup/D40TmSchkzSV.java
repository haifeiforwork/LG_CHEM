/******************************************************************************/
/*																							*/
/*   System Name	:  MSS														*/
/*   1Depth Name		:   부서근태													*/
/*   2Depth Name		:   계획근무일정 											*/
/*   Program Name	:   계획근무일정(일괄) 									*/
/*   Program ID		: D40TmSchkzSV.java									*/
/*   Description		: 계획근무일정(일괄)										*/
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

public class D40TmSchkzSV extends EHRBaseServlet {

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
						if(!"".equals(WebUtil.nvl(deptNos[i]))){
							D40TmSchkzFrameData data = new D40TmSchkzFrameData();
							data.OBJID = WebUtil.nvl(deptNos[i]);
							OBJID.addElement(data);
						}
					}
				}
				Vector vec = (new D40TmSchkzFrameRFC()).getTmSchkzExcelDown(user.empNo, I_ACTTY, I_SELTAB, OBJID );

				req.setAttribute("excelSheet1", vec.get(0));
				req.setAttribute("excelSheet2", vec.get(1));
				printJspPage(req, res, WebUtil.JspURL + "D/D40TmGroup/D40TmSchkzAllExcelDown.jsp");

		    }else if("SAVE".equals(gubun)){

		    	String PERNR[] = req.getParameterValues("PERNR");
		    	String ENAME[] = req.getParameterValues("ENAME");
		    	String BEGDA[] = req.getParameterValues("BEGDA");
		    	String ENDDA[] = req.getParameterValues("ENDDA");
		    	String SCHKZ[] = req.getParameterValues("SCHKZ");

		    	Vector OBJID = new Vector();
				for( int i = 0; i <  PERNR.length; i++ ){
					D40TmSchkzFrameData excelDt = new D40TmSchkzFrameData();
					excelDt.PERNR = PERNR[i];
					excelDt.ENAME = ENAME[i];
					excelDt.BEGDA = BEGDA[i];
					excelDt.ENDDA = ENDDA[i];
					excelDt.SCHKZ = SCHKZ[i];
					OBJID.addElement(excelDt);
				}

				D40TmSchkzFrameRFC rfc = new D40TmSchkzFrameRFC();
				I_ACTTY = "A";	//실행모드 : U 일괄업로드, A 업로드후수정반영
				Vector resultList = rfc.saveTable(user.empNo, I_ACTTY, OBJID);

				Vector T_SCHKZ = (Vector)resultList.get(2);	//리스트 데이터
				Vector T_EXLIST = (Vector)resultList.get(3);	//조회 selectbox
				String E_RETURN = (String)resultList.get(0);	//조회 selectbox
				String E_SAVE_CNT = (String)resultList.get(5);	//조회 selectbox


				req.setAttribute("OBJPS_OUT", T_SCHKZ);
	   		 	req.setAttribute("T_EXLIST", T_EXLIST);
	   		 	req.setAttribute("E_RETURN", E_RETURN);
	   		 	req.setAttribute("E_SAVE_CNT", E_SAVE_CNT);

	   		 	req.setAttribute("viewSource", "true");

//				req.setAttribute("resultList", resultList);
		    	printJspPage(req, res, WebUtil.JspURL + "D/D40TmGroup/D40TmSchkzAllExcel.jsp");

		    }else{

		    	String I_DATUM = "";
				String I_SCHKZ = "";
				Vector T_IMPERS = new Vector();
				Vector OBJID = new Vector();

				Vector vec = (new D40TmSchkzFrameRFC()).getTmSchkzFrame(user.empNo, I_ACTTY, I_DATUM, I_SCHKZ, T_IMPERS, I_SELTAB, OBJID);
//				String E_RETURN    = (String)vec.get(0);
//	            String E_MESSAGE = (String)vec.get(1);
	            String E_INFO = (String)vec.get(2);	//안내문구
	            Vector OBJPS_OUT = (Vector)vec.get(3);	//계획근무일정
	            req.setAttribute("OBJPS_OUT", OBJPS_OUT);

	            req.setAttribute("viewSource", "true");

		    	printJspPage(req, res, WebUtil.JspURL + "D/D40TmGroup/D40TmSchkzAllExcel.jsp");

		    }

		} catch (Exception e) {
			throw new GeneralException(e);
		}
	}

}
