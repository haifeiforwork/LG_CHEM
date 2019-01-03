/********************************************************************************/
/*   System Name  : ESS
/*   1Depth Name  : My HR
/*   2Depth Name  : 휴가/근태
/*   Program Name : 근무 시간 입력
/*   Program ID   : D25WorkTimeCalendarSV.java
/*   Description  : 근무시간 달력 JSP 요청처리 class
/*   Note         : 
/*   Creation     : 2018-05-04 [WorkTime52] 유정우
/*   Update       : 
/********************************************************************************/

package servlet.hris.D.D25WorkTime;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.sns.jdf.GeneralException;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.WebUtil;

@SuppressWarnings("serial")
public class D25WorkTimeCalendarSV extends EHRBaseServlet {

	protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {

		printJspPage(req, res, WebUtil.JspURL + "D/D25WorkTime/D25WorkTimeCalendar.jsp");
	}

}