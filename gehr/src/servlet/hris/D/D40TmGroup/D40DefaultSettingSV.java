/******************************************************************************/
/*																							*/
/*   System Name	:  MSS														*/
/*   1Depth Name		:  부서근태													*/
/*   2Depth Name		:  공통														*/
/*   Program Name	:  																*/
/*   Program ID		:  D40DefaultSettingSV.java								*/
/*   Description		:  인원추가 기본값 설정팝업									*/
/*   Note				:  																*/
/*   Creation			:  2017-12-08  정준현                                          	*/
/*   Update				:  2017-12-08  정준현                                          	*/
/*                                                                              			*/
/********************************************************************************/

package servlet.hris.D.D40TmGroup;

import hris.D.D40TmGroup.rfc.D40DefaultSettingRFC;
import hris.common.WebUserData;

import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.sns.jdf.GeneralException;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.WebUtil;

public class D40DefaultSettingSV extends EHRBaseServlet {

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {

    	try{
	    	WebUserData user    = WebUtil.getSessionUser(req);

	    	String I_SCREEN = WebUtil.nvl(req.getParameter("I_SCREEN"));

	    	Vector vec = (new D40DefaultSettingRFC()).getDefaultSetting(user.empNo, I_SCREEN);

	    	String E_BEGDA = (String)vec.get(0);			//조회시작일
            String E_ENDDA = (String)vec.get(1);			//조회종료일
            Vector OBJPS_OUT1 = (Vector)vec.get(2);	//유형
            Vector OBJPS_OUT2 = (Vector)vec.get(3);	//사유
            Vector OBJPS_OUT3 = (Vector)vec.get(4);	//입력여부Y/N
            Vector OBJPS_OUT4 = (Vector)vec.get(5);	//기타

            req.setAttribute("E_BEGDA", E_BEGDA);
            req.setAttribute("E_ENDDA", E_ENDDA);
            req.setAttribute("OBJPS_OUT1", OBJPS_OUT1);		//유형
            req.setAttribute("OBJPS_OUT2", OBJPS_OUT2);		//사유
            req.setAttribute("OBJPS_OUT3", OBJPS_OUT3);		//입력여부Y/N
            req.setAttribute("OBJPS_OUT4", OBJPS_OUT4);		//기타

	        printJspPage(req, res, WebUtil.JspURL + "D/D40TmGroup/common/DefaultSettingPop.jsp");

    	} catch (Exception e) {
//			e.printStackTrace();
			throw new GeneralException(e);
		}
    }

}