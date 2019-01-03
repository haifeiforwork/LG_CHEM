/******************************************************************************/
/*																							*/
/*   System Name	:  MSS														*/
/*   1Depth Name		:   부서근태													*/
/*   2Depth Name		:   근태그룹정의 											*/
/*   Program Name	:   근태그룹정의 											*/
/*   Program ID		: D40TmGroupFrameSV.java							*/
/*   Description		: 근태그룹정의 												*/
/*   Note				: 																*/
/*   Creation			: 2017-12-08  정준현                                          	*/
/*   Update				: 2017-12-08  정준현                                          	*/
/*                                                                              			*/
/********************************************************************************/

package servlet.hris.D.D40TmGroup;

import hris.D.D40TmGroup.D40TmGroupData;
import hris.D.D40TmGroup.rfc.D40TmGroupFrameRFC;
import hris.common.WebUserData;

import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.sns.jdf.GeneralException;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.WebUtil;

public class D40TmGroupFrameSV extends EHRBaseServlet {

	protected void performTask( HttpServletRequest req, HttpServletResponse res ) throws GeneralException {

		try {

			WebUserData user    = WebUtil.getSessionUser(req);
			Box         box     = WebUtil.getBox( req ) ;

			String I_PABRJ  = WebUtil.nvl(req.getParameter("I_PABRJ")); //년
			String I_PABRP  = WebUtil.nvl(req.getParameter("I_PABRP")); //월
			String I_SEQNO  = WebUtil.nvl(req.getParameter("I_SEQNO")); //근태그룹
			String I_GTYPE  = WebUtil.nvl(req.getParameter("I_GTYPE")); //처리그룹
			if(I_GTYPE == null || "".equals(I_GTYPE)){
				I_GTYPE = "1";
			}

			if("1".equals(I_GTYPE)){
				D40TmGroupFrameRFC func = new D40TmGroupFrameRFC();
				Vector ret = func.getTmYyyyMmList(user.empNo, I_GTYPE, I_PABRJ, I_PABRP, I_SEQNO);

				Vector data_vt = (Vector)ret.get(0);	//리스트 데이터
				Vector select_vt = (Vector)ret.get(1);	//조회 selectbox
	            String E_RETURN    = (String)ret.get(2);
	            String E_MESSAGE = (String)ret.get(3);
	            String E_OTEXT = (String)ret.get(4);	//선택연도
	            String E_ORGEH = (String)ret.get(5);	//선택월

	            String jobid   = "" ;
	            String dest    = "" ;
	            String e_year  = box.get( "I_PABRJ" ) ;
	            String e_month = box.get( "I_PABRP" ) ;
	            if( e_year == null || e_year.equals("")) {
	            	e_year = E_OTEXT;
	            }

	            if( e_month == null ||e_month.equals("")) {
	            	e_month = E_ORGEH;
	            }

	            req.setAttribute( "I_PABRJ",  e_year  ) ;  // 년
	            req.setAttribute( "I_PABRP", e_month ) ;  // 월

	            String sMenuCode       = WebUtil.nvl(req.getParameter("sMenuCode"));
	            req.setAttribute("sMenuCode", sMenuCode);
	            req.setAttribute("I_SEQNO", I_SEQNO);
	   		 	req.setAttribute("data_vt", data_vt);
	   		 	req.setAttribute("select_vt", select_vt);
	   		 	req.setAttribute("E_RETURN", E_RETURN);
	   		 	req.setAttribute("E_MESSAGE", E_MESSAGE);

	   		 	dest = WebUtil.JspURL + "D/D40TmGroup/D40TmGroupFrame.jsp" ;

//	   		 	Logger.debug.println( this, " e_year = " + e_year ) ;
//	   		 	Logger.debug.println( this, " e_month = " + e_month ) ;
//	   		 	Logger.debug.println( this, " destributed = " + dest ) ;

	   		 	printJspPage( req, res, dest ) ;

			}else{

				String SEQNO[] = req.getParameterValues("SEQNO");
				String TIME_GRUP[] = req.getParameterValues("TIME_GRUP");
				String BEGDA[] = req.getParameterValues("BEGDA");
				int rowCount  = Integer.parseInt( WebUtil.nvl(req.getParameter("rowCount")));

				//D40TmGroupData data = new D40TmGroupData();
				Vector OBJID = new Vector();
				for (int i = 0; i <  rowCount; i++) {
					D40TmGroupData data = new D40TmGroupData();
					data.SEQNO = WebUtil.nvl(SEQNO[i]);
					data.TIME_GRUP = WebUtil.nvl(TIME_GRUP[i]);
					data.BEGDA = WebUtil.nvl(BEGDA[i].replace(".",""));
					OBJID.addElement(data);
				}

		      	D40TmGroupFrameRFC func = new D40TmGroupFrameRFC();

		      	Vector ret2 		= func.saveData(user.empNo, "2", OBJID, I_PABRJ, I_PABRP);
//				Vector ret = (new D40OrganPersListRFC()).getPersonList(user.empNo, I_SELTAB, I_DATUM, OBJID);

				Vector ret = func.getTmYyyyMmList(user.empNo, "1", I_PABRJ, I_PABRP, I_SEQNO);

				Vector data_vt = (Vector)ret.get(0);	//리스트 데이터
				Vector select_vt = (Vector)ret.get(1);	//조회 selectbox
	            String E_RETURN    = (String)ret.get(2);
	            String E_MESSAGE = (String)ret.get(3);
	            String E_OTEXT = (String)ret.get(4);	//선택연도
	            String E_ORGEH = (String)ret.get(5);	//선택월

	            String jobid   = "" ;
	            String dest    = "" ;
	            String e_year  = box.get( "I_PABRJ" ) ;
	            String e_month = box.get( "I_PABRP" ) ;
	            if( e_year == null || e_year.equals("")) {
	            	e_year = E_OTEXT;
	            }

	            if( e_month == null ||e_month.equals("")) {
	            	e_month = E_ORGEH;
	            }

	            req.setAttribute( "I_PABRJ",  e_year  ) ;  // 년
	            req.setAttribute( "I_PABRP", e_month ) ;  // 월

	            String sMenuCode       = WebUtil.nvl(req.getParameter("sMenuCode"));
	            req.setAttribute("sMenuCode", sMenuCode);
	   		 	req.setAttribute("data_vt", data_vt);
	   		 	req.setAttribute("select_vt", select_vt);
	   		 	req.setAttribute("E_RETURN", E_RETURN);
	   		 	req.setAttribute("E_MESSAGE", E_MESSAGE);

	   		 	dest = WebUtil.JspURL + "D/D40TmGroup/D40TmGroupFrame.jsp" ;

//	   		 	Logger.debug.println( this, " e_year = " + e_year ) ;
//	   		 	Logger.debug.println( this, " e_month = " + e_month ) ;
//	   		 	Logger.debug.println( this, " destributed = " + dest ) ;

	   		 	printJspPage( req, res, dest ) ;
			}


		} catch (Exception e) {
			throw new GeneralException(e);
		}
	}

}
