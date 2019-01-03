/********************************************************************************/
/*   System Name  : ESS
/*   1Depth Name  : My HR
/*   2Depth Name  : 휴가/근태
/*   Program Name : 보상휴가 발생내역
/*   Program ID   : D03CompTimeListSV.java
/*   Description  : 보상휴가 발생내역 JSP 호출 class
/*   Note         : 
/*   Creation     : 2018-07-25 [WorkTime52] 유정우
/*   Update       : 
/********************************************************************************/

package servlet.hris.D.D03Vocation;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.sns.jdf.GeneralException;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.WebUtil;

@SuppressWarnings("serial")
public class D03CompTimeListSV extends EHRBaseServlet {

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {

        printJspPage(req, res, WebUtil.JspURL + "D/D03Vocation/D03CompTimeList.jsp");
    }

}