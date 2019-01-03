/******************************************************************************/
/*																							*/
/*   System Name	:  MSS														*/
/*   1Depth Name		:   부서근태													*/
/*   2Depth Name		:   일일근태 입력 현황										*/
/*   Program Name	:   일일근태 입력 현황										*/
/*   Program ID		: D40TmDailySV.java										*/
/*   Description		: 일일근태 입력 현황										*/
/*   Note				: 																*/
/*   Creation			: 2017-12-08  정준현                                          	*/
/*   Update				: 2017-12-08  정준현                                          	*/
/*                                                                              			*/
/********************************************************************************/
package servlet.hris.D.D40TmGroup;

import hris.D.D40TmGroup.D40DailScheFrameData;
import hris.D.D40TmGroup.D40TmDailyData;
import hris.D.D40TmGroup.D40TmSchkzFrameData;
import hris.D.D40TmGroup.rfc.D40TmDailyRFC;
import hris.common.WebUserData;

import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.sns.jdf.GeneralException;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.WebUtil;

public class D40TmDailySV extends EHRBaseServlet {

	protected void performTask( HttpServletRequest req, HttpServletResponse res ) throws GeneralException {

		try{

			WebUserData user    = WebUtil.getSessionUser(req);
			String orgOrTm = WebUtil.nvl(req.getParameter("orgOrTm"));
			String iSeqno = WebUtil.nvl(req.getParameter("iSeqno"));
			String ISEQNO = WebUtil.nvl(req.getParameter("ISEQNO"));
			String gubun = WebUtil.nvl(req.getParameter("gubun"));
			String searchDeptNo = WebUtil.nvl(req.getParameter("searchDeptNo"));
			String searchDeptNm = WebUtil.nvl(req.getParameter("searchDeptNm"));
			String empNo = WebUtil.nvl(req.getParameter("I_PERNR"));
	    	String empNm = WebUtil.nvl(req.getParameter("I_ENAME"));

			String I_SELTAB = WebUtil.nvl(req.getParameter("I_SELTAB"));
			String I_SCHKZ = WebUtil.nvl(req.getParameter("I_SCHKZ"));			//선택된 계획근무
//			String T_IMINFTY = WebUtil.nvl(req.getParameter("T_IMINFTY"));		//인포타입
//			String T_IMWTMCD = WebUtil.nvl(req.getParameter("T_IMWTMCD"));//유형
			String searchIminfty = WebUtil.nvl(req.getParameter("searchIminfty"));		//조회 인포타입
			String searchImwtmcd = WebUtil.nvl(req.getParameter("searchImwtmcd"));//조회 유형

			String searchExinfty		= WebUtil.nvl(req.getParameter("searchExinfty"));
			String searchExinftycd	= WebUtil.nvl(req.getParameter("searchExinftycd"));	//인포타입 CODE
			String searchExwtmnm	= WebUtil.nvl(req.getParameter("searchExwtmnm"));
			String searchExwtmcd	= WebUtil.nvl(req.getParameter("searchExwtmcd"));	//유형 CODE
			String searchExwtmpcd	= WebUtil.nvl(req.getParameter("searchExwtmpcd"));	//유형 PKEY

			String I_BEGDA = WebUtil.nvl(req.getParameter("I_BEGDA"));			//조회시작일
			String I_ENDDA = WebUtil.nvl(req.getParameter("I_ENDDA"));			//조회종료일

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

	    	Vector T_IMINFTY = new Vector();
	    	String[] searchExinftycds = searchExinftycd.split(",");
//	    	String[] empNms = empNm.split(",");

	    	for(int i=0; i<searchExinftycds.length; i++){
	    		D40TmDailyData data = new D40TmDailyData();
				if(!"".equals(searchExinftycds[i])){
					data.CODE = WebUtil.nvl(searchExinftycds[i]);
					T_IMINFTY.addElement(data);
				}
			}
	    	Vector T_IMWTMCD = new Vector();
	    	String[] searchExwtmcds = searchExwtmcd.split(",");
	    	String[] searchExwtmpcds = searchExwtmpcd.split(",");

	    	for(int i=0; i<searchExwtmcds.length; i++){
	    		D40TmDailyData data = new D40TmDailyData();
				if(!"".equals(searchExwtmcds[i])){
					data.CODE = WebUtil.nvl(searchExwtmcds[i]);
					data.PKEY = WebUtil.nvl(searchExwtmpcds[i]);
					T_IMWTMCD.addElement(data);
				}
			}

			Vector vec = (new D40TmDailyRFC()).getTmDaily(user.empNo, I_SCHKZ, I_BEGDA, I_ENDDA, I_SELTAB, OBJID, T_IMPERS, T_IMINFTY, T_IMWTMCD);

			Vector T_EXLIST = (Vector)vec.get(2);		//입력현황조회
			Vector T_SCHKZ = (Vector)vec.get(3);		//계획근무 코드-텍스트
			Vector T_EXINFTY = (Vector)vec.get(4);		//선택된 인포타입
	    	Vector T_EXWTMCD = (Vector)vec.get(5);	//선택된 유형
			String E_BEGDA = (String)vec.get(6);			//조회시작일
			String E_ENDDA = (String)vec.get(7);			//조회종료일

			req.setAttribute("I_BEGDA", I_BEGDA);
            req.setAttribute("I_ENDDA", I_ENDDA);
            req.setAttribute("I_SCHKZ", I_SCHKZ);
            req.setAttribute("I_PERNR", empNo);
            req.setAttribute("I_ENAME", empNm);

            req.setAttribute("T_EXLIST", T_EXLIST);
            req.setAttribute("T_SCHKZ", T_SCHKZ);
            req.setAttribute("T_EXINFTY", T_EXINFTY);
            req.setAttribute("T_EXWTMCD", T_EXWTMCD);
            req.setAttribute("E_BEGDA", E_BEGDA);
            req.setAttribute("E_ENDDA", E_ENDDA);

            req.setAttribute("searchExinfty", searchExinfty);
            req.setAttribute("searchExinftycd", searchExinftycd);
            req.setAttribute("searchExwtmnm", searchExwtmnm);
            req.setAttribute("searchExwtmcd", searchExwtmcd	);
            req.setAttribute("searchExwtmpcd", searchExwtmpcd);

            String dest = "";
            if("EXCEL".equals(gubun)){
            	dest = WebUtil.JspURL + "D/D40TmGroup/D40TmDailyExcel.jsp" ;
            }else{
            	dest = WebUtil.JspURL + "D/D40TmGroup/D40TmDaily.jsp" ;
            }
			printJspPage(req, res, dest);

		} catch (Exception e) {
			throw new GeneralException(e);
		}
	}

}
