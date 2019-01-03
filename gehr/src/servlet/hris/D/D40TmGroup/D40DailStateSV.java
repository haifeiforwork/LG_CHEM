/******************************************************************************/
/*																							*/
/*   System Name	:  MSS														*/
/*   1Depth Name		:   부서근태													*/
/*   2Depth Name		:   근태집계표												*/
/*   Program Name	:   일간근태집계표											*/
/*   Program ID		: D40DailStateSV.java									*/
/*   Description		: 일간근태집계표											*/
/*   Note				: 																*/
/*   Creation			: 2017-12-08  정준현                                          	*/
/*   Update				: 2017-12-08  정준현                                          	*/
/*                                                                              			*/
/********************************************************************************/
package servlet.hris.D.D40TmGroup;

import hris.D.D40TmGroup.D40OverTimeFrameData;
import hris.D.D40TmGroup.D40TmSchkzFrameData;
import hris.D.D40TmGroup.rfc.D40DailStateRFC;
import hris.common.WebUserData;

import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.sns.jdf.GeneralException;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.WebUtil;

public class D40DailStateSV extends EHRBaseServlet {

	protected void performTask( HttpServletRequest req, HttpServletResponse res ) throws GeneralException {

		try{

			WebUserData user	= WebUtil.getSessionUser(req);
			String gubun 			= WebUtil.nvl(req.getParameter("gubun"));
			String p_gubun 		= WebUtil.nvl(req.getParameter("p_gubun"));
			String orgOrTm 		= WebUtil.nvl(req.getParameter("orgOrTm"));
			String searchDeptNo	= WebUtil.nvl(req.getParameter("searchDeptNo"));
			String searchDeptNm	= WebUtil.nvl(req.getParameter("searchDeptNm"));
			String iSeqno 			= WebUtil.nvl(req.getParameter("iSeqno"));
			String ISEQNO 		= WebUtil.nvl(req.getParameter("ISEQNO"));
			String I_SELTAB 		= WebUtil.nvl(req.getParameter("I_SELTAB"));
			String I_GUBUN 		= WebUtil.nvl(req.getParameter("I_GUBUN"));	//1:월간,2:일일, "": 기본조회
			String I_SCHKZ 		= WebUtil.nvl(req.getParameter("I_SCHKZ"));
			String I_BEGDA 		= WebUtil.nvl(req.getParameter("I_BEGDA"));
			String I_ENDDA 		= WebUtil.nvl(req.getParameter("I_ENDDA"));
			String I_ACTTY 		= WebUtil.nvl(req.getParameter("I_ACTTY"));


			if("".equals(I_ACTTY)){
				I_ACTTY = "T";			//T:일괄초기조회
			}

			Vector OBJID = new Vector();

			if("2".equals(orgOrTm)){		//근태그룹으로 선택하기
				if("PRINT".equals(gubun)){
					String[] iSeqnos = ISEQNO.split("-");
					for(int i=0; i<iSeqnos.length; i++){
						D40TmSchkzFrameData data = new D40TmSchkzFrameData();
						if(!"".equals(iSeqnos[i])){
							data.OBJID = WebUtil.nvl(iSeqnos[i]);
							OBJID.addElement(data);
						}
					}
				}else{
					String[] iSeqnos = ISEQNO.split(",");
					for(int i=0; i<iSeqnos.length; i++){
						D40TmSchkzFrameData data = new D40TmSchkzFrameData();
						if(!"".equals(iSeqnos[i])){
							data.OBJID = WebUtil.nvl(iSeqnos[i]);
							OBJID.addElement(data);
						}
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
	    	String[] empNos = null;
	    	String[] empNms = null;
	    	Vector T_IMPERS = new Vector();
	    	if("PRINT".equals(gubun)){
		    	empNos = empNo.split(":");
		    	empNms = empNm.split(":");
	    	}else{
	    		empNos = empNo.split(",");
		    	empNms = empNm.split(",");
	    	}
	    	for(int i=0; i<empNos.length; i++){
	    		D40OverTimeFrameData data = new D40OverTimeFrameData();
				if(!"".equals(empNos[i])){
					data.PERNR = WebUtil.nvl(empNos[i]);
					data.ENAME = WebUtil.nvl(empNms[i]);
					T_IMPERS.addElement(data);
				}
			}
	    	if("A".equals(p_gubun)){
	    		I_GUBUN = "2";
	    	}else if("B".equals(p_gubun)){
	    		I_GUBUN = "1";
	    	}

	    	String I_DATUM = "";
	    	D40DailStateRFC fnc = new D40DailStateRFC();

			Vector vec = fnc.getDailState(user.empNo, I_ACTTY, I_DATUM, I_BEGDA, I_ENDDA, I_SCHKZ, I_GUBUN, T_IMPERS, I_SELTAB, OBJID);

			String E_BEGDA = (String)vec.get(2);		//조회시작일
			String E_ENDDA = (String)vec.get(3);		//조회종료일
			String E_DAY_CNT = (String)vec.get(4);	//일자수
			String E_INFO = (String)vec.get(5);			//안내문구
			Vector T_EXPORTA = (Vector)vec.get(6);	//일간집계표 TITLE
			Vector T_EXPORTB = (Vector)vec.get(7);	//일간집계표 DATA
			Vector T_EXPORTC = (Vector)vec.get(8);	//월간집계표 DATA
			Vector T_EXPORTD = (Vector)vec.get(9);	//월간집계표 DATA
			Vector T_SCHKZ = (Vector)vec.get(10);	//계획근무 코드-텍스트

			if("A".equals(p_gubun)){
//				if(T_EXPORTA.size() > 0){

					req.setAttribute("I_BEGDA", I_BEGDA);
		            req.setAttribute("I_ENDDA", I_ENDDA);

		            req.setAttribute("E_BEGDA", E_BEGDA);
		            req.setAttribute("E_ENDDA", E_ENDDA);
		            req.setAttribute("E_DAY_CNT", E_DAY_CNT);
		            req.setAttribute("T_EXPORTA", T_EXPORTA);
		            req.setAttribute("T_EXPORTB", T_EXPORTB);
		            req.setAttribute("T_EXPORTC", T_EXPORTC);
		            req.setAttribute("T_EXPORTD", T_EXPORTD);
		            req.setAttribute("E_INFO", E_INFO);
		            req.setAttribute("T_SCHKZ", T_SCHKZ);
		            if("PRINT".equals(gubun)){
		            	printJspPage(req, res, WebUtil.JspURL + "D/D40TmGroup/D40DailStatePrint.jsp");
		            }else if("EXCEL".equals(gubun)){
		            	printJspPage(req, res, WebUtil.JspURL + "D/D40TmGroup/D40DailStateExcel.jsp");
		            }else{	//SEARCH
		            	printJspPage(req, res, WebUtil.JspURL + "D/D40TmGroup/D40DailState.jsp");
		            }
//				}else{
//			        String msg = "해당 자료가 없습니다.";
//	                String url = "history.back();";
//			        //String url = "location.href = '"+WebUtil.JspURL+"F/F43DeptDayWorkCondition.jsp?checkYn="+checkYN+"';";
//			        req.setAttribute("msg", msg);
//			        req.setAttribute("url", url);
//
//			        printJspPage(req, res, WebUtil.JspURL+"common/caution.jsp");
//		        }

			}else if("B".equals(p_gubun)){

//				if(T_EXPORTC.size() > 0){

					req.setAttribute("I_BEGDA", I_BEGDA);
		            req.setAttribute("I_ENDDA", I_ENDDA);

		            req.setAttribute("E_BEGDA", E_BEGDA);
		            req.setAttribute("E_ENDDA", E_ENDDA);
		            req.setAttribute("E_DAY_CNT", E_DAY_CNT);
		            req.setAttribute("T_EXPORTA", T_EXPORTA);
		            req.setAttribute("T_EXPORTB", T_EXPORTB);
		            req.setAttribute("T_EXPORTC", T_EXPORTC);
		            req.setAttribute("T_EXPORTD", T_EXPORTD);
		            req.setAttribute("E_INFO", E_INFO);
		            req.setAttribute("T_SCHKZ", T_SCHKZ);

		            if("PRINT".equals(gubun)){
		            	printJspPage(req, res, WebUtil.JspURL + "D/D40TmGroup/D40MonthStatePrint.jsp");
		            }else if("EXCEL".equals(gubun)){
		            	printJspPage(req, res, WebUtil.JspURL + "D/D40TmGroup/D40MonthStateExcel.jsp");
		            }else{	//SEARCH
		            	printJspPage(req, res, WebUtil.JspURL + "D/D40TmGroup/D40MonthState.jsp");
		            }

//				}else{
//			        String msg = "해당 자료가 없습니다.";
//	                String url = "history.back();";
//			        //String url = "location.href = '"+WebUtil.JspURL+"F/F43DeptDayWorkCondition.jsp?checkYn="+checkYN+"';";
//			        req.setAttribute("msg", msg);
//			        req.setAttribute("url", url);
//
//			        printJspPage(req, res, WebUtil.JspURL+"common/caution.jsp");
//		        }
			}


		} catch (Exception e) {
//			e.printStackTrace();
			throw new GeneralException(e);
		}
	}

}
