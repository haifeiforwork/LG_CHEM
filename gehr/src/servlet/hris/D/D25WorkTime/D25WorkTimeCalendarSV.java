/********************************************************************************/
/*   System Name  : ESS
/*   1Depth Name  : My HR
/*   2Depth Name  : �ް�/����
/*   Program Name : �ٹ� �ð� �Է�
/*   Program ID   : D25WorkTimeCalendarSV.java
/*   Description  : �ٹ��ð� �޷� JSP ��ûó�� class
/*   Note         : 
/*   Creation     : 2018-05-04 [WorkTime52] ������
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