package servlet.hris.F;

import java.util.Vector;
import javax.servlet.http.*;

import com.sns.jdf.*;
import com.sns.jdf.util.*;
import com.sns.jdf.servlet.*;

import hris.F.rfc.*;
import hris.F.F46OverTimeData;
import hris.N.EHRComCRUDInterfaceRFC;
import hris.common.WebUserData;

/**
 * F46OverTimeSV
 * 부서에 따른 전체 부서원의 연장근로실적 정보를 가져오는
 *  F46OverTimeRFC 를 호출하는 서블릿 class
 *
 * @author  손혜영
 * @version 1.0
 */
public class F46OverTimeSV extends EHRBaseServlet {

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
    	try{
    		//ApLog
        	String ctrl = "";
        	String cnt = "0";
        	String[] val = null;

	        HttpSession session = req.getSession(false);
	        Logger.debug.println(this, "start..........");
	        F46OverTimeData data = new F46OverTimeData();
	        String hdn_deptId = WebUtil.nvl(req.getParameter("hdn_deptId"));
	        String hdn_deptNm = WebUtil.nvl(req.getParameter("hdn_deptNm"));
	        String checkYn = WebUtil.nvl(req.getParameter("chck_yeno"), "N");
	        data.I_ORGEH = hdn_deptId; 			//부서코드...
	        data.I_LOWERYN = checkYn; 		//하위부서여부.
	        String E_YYYYMON = "";
	        data.I_GUBUN = WebUtil.nvl(req.getParameter("gubun"), "1");
	        data.I_TODAY = "";

	        data.year   = WebUtil.nvl(req.getParameter("year"));
	        data.month  = WebUtil.nvl(req.getParameter("month"));
	        data.yymmdd   = WebUtil.nvl(req.getParameter("yymmdd"));

            data.I_OVERYN = WebUtil.nvl(req.getParameter("overYn"), "N");
            String excelDown    = WebUtil.nvl(req.getParameter("hdn_excel"));  			//excelDown...

            WebUserData user    = (WebUserData)session.getAttribute("user");				//세션.
            String subView       = WebUtil.nvl(req.getParameter("subView"));				//tab에서 호출되는지 여부

            //초기화면 오픈시 로그인 사용자의 데이터를 보여준다.
            if( data.I_ORGEH.equals("") ){
            	data.I_ORGEH = user.e_objid;
            }

            if(data.I_GUBUN.equals("1")){
            	if(data.year.equals("")||data.month.equals("")){
            		data.I_TODAY = DataUtil.getCurrentDate();
				} else {
					data.I_TODAY = data.year + data.month + "20";
				}
            } else {
            	if(data.yymmdd.equals("")){
            		data.I_TODAY = DataUtil.getCurrentDate();
            	} else {
            		data.I_TODAY = DataUtil.delDateGubn(data.yymmdd);
            	}
            }
	        String dest    		= "";

           	/**
           	 * @$ 웹보안진단 rdcamel
           	 * 해당 사번이 조직을 조회 할수 있는지 체크
           	 */
	        int orgFlag = user.e_authorization.indexOf("M");    //조직도권한여부.

	        Box box = WebUtil.getBox(req);
           	box.put("I_PERNR", user.empNo);
           	//초기화면오픈시 에러발생 조치 eunha
           	//box.put("I_ORGEH", hdn_deptId);
           	box.put("I_ORGEH", data.I_ORGEH);
           	if(orgFlag >0){
           		box.put("I_AUTHOR", "M");
           	}else{
           		box.put("I_AUTHOR", "");
           	}
           	box.put("I_GUBUN", "");
           	/**
           	 * @$ 웹보안진단 rdcamel
           	 * 해당 사번이 조직을 조회 할수 있는지 체크
           	 */
			   if(!checkBelongGroup(req, res, data.I_ORGEH, "")) return;
        	// @웹취약성 추가
			   if(!checkAuthorization(req, res)) return;

		        F46OverTimeRFC func    = new F46OverTimeRFC();
		        Vector rtnVt  = new Vector();
		        Vector overTimeVt  = new Vector();
				if ( !data.I_ORGEH.equals("") ) {
					rtnVt = func.getOverTime(data);
					E_YYYYMON = (String)rtnVt.get(0);
					overTimeVt 	= (Vector)rtnVt.get(1);
		        }
				Logger.debug.println(this, " E_YYYYMON = " + E_YYYYMON);
				Logger.debug.println(this, " overTimeVt = " + overTimeVt);
				req.setAttribute("E_YYYYMON", E_YYYYMON);
				req.setAttribute("hdn_deptId", hdn_deptId);
				req.setAttribute("hdn_deptNm", hdn_deptNm);
				req.setAttribute("checkYn", checkYn);
				req.setAttribute("searchData", data);
				req.setAttribute("overTimeVt", overTimeVt);
				req.setAttribute("subView", subView);
	        	Logger.debug.println(this, " subView = " + subView);

				 if( excelDown.equals("ED") ){ //엑셀저장일 경우.
			         dest = WebUtil.JspURL+"F/F46OverTimeExcel.jsp";
			         ctrl = "24";
				 } else {
					 dest = WebUtil.JspURL+"F/F46OverTime.jsp";
					 ctrl = "12";
				 }

	        Logger.debug.println(this, " destributed = " + dest);
	        //ApLog
            ApLoggerWriter.writeApLog("조직통계", "근태", "F46OverTimeSV", "연장근로실적정보조회", ctrl, cnt, val, user, req.getRemoteAddr());

	        printJspPage(req, res, dest);
    	} catch(Exception e) {
            throw new GeneralException(e);
        }
    }
}