/******************************************************************************/
/*																							*/
/*   System Name	:  MSS														*/
/*   1Depth Name		:   부서근태													*/
/*   2Depth Name		:   근무계획표 조회(근무조)								*/
/*   Program Name	:   근무계획표 조회(근무조)								*/
/*   Program ID		: D40TmSchkzPlanningChartGroupSV.java			*/
/*   Description		: 근무계획표 조회(근무조)									*/
/*   Note				: 																*/
/*   Creation			: 2017-12-08  정준현                                          	*/
/*   Update				: 2017-12-08  정준현                                          	*/
/*                                                                              			*/
/********************************************************************************/
package servlet.hris.D.D40TmGroup;

import hris.D.D40TmGroup.D40TmSchkzFrameData;
import hris.D.D40TmGroup.rfc.D40TmSchkzPlanningChartGroupRFC;
import hris.common.WebUserData;

import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.sns.jdf.GeneralException;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;

public class D40TmSchkzPlanningChartGroupSV extends EHRBaseServlet {

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

			//상단 공통 조회
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
					D40TmSchkzFrameData data = new D40TmSchkzFrameData();
					if(deptNos[i] != null && !"".equals(deptNos[i])){
				    	data.OBJID = WebUtil.nvl(deptNos[i]);
				      	OBJID.addElement(data);
					}
				}
			}

	    	String I_DATUM = "";
	    	if(req.getParameter("I_DATUM") == null){
	    		I_DATUM = DataUtil.getCurrentDate();
	    	}else{
	    		I_DATUM = WebUtil.nvl(req.getParameter("I_DATUM")).replace(".","");
	    	}

	    	String I_SCHKZ = WebUtil.nvl(req.getParameter("I_SCHKZ"));


	    	Vector vec = (new D40TmSchkzPlanningChartGroupRFC()).getPlanningChart(user.empNo, I_SELTAB, OBJID, I_DATUM, I_SCHKZ);
//	    	String E_DATUM = (String)vec.get(0);	//선택일자
	    	String E_INFO = (String)vec.get(0);	//안내문구
	    	String E_RETURN    = (String)vec.get(1);
            String E_MESSAGE = (String)vec.get(2);
            Vector T_SCHKZ = (Vector)vec.get(3);		//계획근무
            Vector T_TPROG = (Vector)vec.get(4);		//일일근무상세설명
            Vector T_EXPORTA = (Vector)vec.get(5);	 //근무계획표-TITLE
            Vector T_EXPORTB = (Vector)vec.get(6);	 //근무계획표-DATA

            req.setAttribute("E_INFO", E_INFO);
            req.setAttribute("E_RETURN", E_RETURN);
            req.setAttribute("E_MESSAGE", E_MESSAGE);
            req.setAttribute("T_SCHKZ", T_SCHKZ);
            req.setAttribute("T_TPROG", T_TPROG);
            req.setAttribute("T_EXPORTA", T_EXPORTA);
            req.setAttribute("T_EXPORTB", T_EXPORTB);

            req.setAttribute("I_DATUM", I_DATUM);
            req.setAttribute("I_SCHKZ", I_SCHKZ);

            if("EXCEL".equals(gubun)){
            	printJspPage(req, res, WebUtil.JspURL + "D/D40TmGroup/D40TmSchkzPlanningChartGroupExcel.jsp");
            }else if("PRINT".equals(gubun)){
            	printJspPage(req, res, WebUtil.JspURL + "D/D40TmGroup/D40TmSchkzPlanningChartGroupPrint.jsp");
//            }else if("PDF".equals(gubun)){
//            	printJspPage(req, res, WebUtil.JspURL + "D/D40TmGroup/D40TmSchkzPlanningChartGroupPdf.jsp");
            }else{
            	printJspPage(req, res, WebUtil.JspURL + "D/D40TmGroup/D40TmSchkzPlanningChartGroup.jsp");
            }

		} catch (Exception e) {
			throw new GeneralException(e);
		}
	}

}
