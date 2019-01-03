/******************************************************************************/
/*																							*/
/*   System Name	:  MSS														*/
/*   1Depth Name		:   부서근태													*/
/*   2Depth Name		:   근태그룹정의 - 인원지정								*/
/*   Program Name	:   근태그룹정의 - 인원지정								*/
/*   Program ID		: D40TmGroupFramePersSV.java						*/
/*   Description		: 근태그룹정의 - 인원지정									*/
/*   Note				: 																*/
/*   Creation			: 2017-12-08  정준현                                          	*/
/*   Update				: 2017-12-08  정준현                                          	*/
/*                                                                              			*/
/********************************************************************************/
package servlet.hris.D.D40TmGroup;

import hris.D.D40TmGroup.D40TmGroupPersData;
import hris.D.D40TmGroup.rfc.D40TmGroupPersRFC;
import hris.common.WebUserData;

import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.sns.jdf.GeneralException;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.WebUtil;

public class D40TmGroupFramePersSV extends EHRBaseServlet {

	protected void performTask( HttpServletRequest req, HttpServletResponse res ) throws GeneralException {

		try {

			WebUserData user    = WebUtil.getSessionUser(req);
			String gubun = WebUtil.nvl(req.getParameter("gubun"));
			String paramSEQNO = WebUtil.nvl(req.getParameter("paramSEQNO"));
			String paramTIME_GRUP = WebUtil.nvl(req.getParameter("paramTIME_GRUP"));
			String paramBEGDA = WebUtil.nvl(req.getParameter("paramBEGDA"));
			String paramPABRJ = WebUtil.nvl(req.getParameter("I_PABRJ"));
			String paramPABRP = WebUtil.nvl(req.getParameter("I_PABRP"));

			//저장
			if("SAVE".equals(gubun)){
				Vector save_vt = new Vector();
				String SPERNR[] = req.getParameterValues("SPERNR");
				if(SPERNR != null){
					for (int i = 0; i <  SPERNR.length; i++) {
						D40TmGroupPersData data = new D40TmGroupPersData();
						data.SPERNR = WebUtil.nvl(SPERNR[i]);
						save_vt.addElement(data);
					}
				}
				Vector save_ret = (new D40TmGroupPersRFC()).saveTmGroupPersList(user.empNo, "2", paramPABRJ, paramPABRP, paramSEQNO, save_vt);
			}

			Vector ret = (new D40TmGroupPersRFC()).getTmGroupPersList(user.empNo, "1", paramPABRJ, paramPABRP, paramSEQNO);
			Vector vt = (Vector)ret.get(0);
			String E_RETURN = WebUtil.nvl((String)ret.get(1));
			String E_MESSAGE = WebUtil.nvl((String)ret.get(2));
			int cnt = vt.size();

			String dest    = "" ;

			if("EXCEL".equals(gubun)){

				req.setAttribute("resultList", vt);
				dest = WebUtil.JspURL + "D/D40TmGroup/D40TmGroupPersExcel.jsp" ;

		    }else{
		    	req.setAttribute("paramSEQNO", paramSEQNO);
		    	req.setAttribute("paramTIME_GRUP", paramTIME_GRUP);
		    	req.setAttribute("paramBEGDA", paramBEGDA);
		    	req.setAttribute("I_PABRJ", paramPABRJ);
		    	req.setAttribute("I_PABRP", paramPABRP);
		    	req.setAttribute("vt", vt);
		    	req.setAttribute("cnt", cnt+"");

		    	dest = WebUtil.JspURL + "D/D40TmGroup/D40TmGroupPers.jsp" ;

		    }

   		 	printJspPage( req, res, dest ) ;

		} catch (Exception e) {
			throw new GeneralException(e);
		}
	}

}
