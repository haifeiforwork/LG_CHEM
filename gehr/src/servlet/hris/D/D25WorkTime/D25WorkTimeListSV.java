/********************************************************************************/
/*   System Name  : ESS
/*   1Depth Name  : My HR
/*   2Depth Name  : 휴가/근태
/*   Program Name : 근무 입력 현황
/*   Program ID   : D25WorkTimeListSV.java
/*   Description  : 근무 입력 현황 목록 JSP 호출 class
/*   Note         : 
/*   Creation     : 2018-05-04 [WorkTime52] 유정우
/*   Update       : 
/********************************************************************************/

package servlet.hris.D.D25WorkTime;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.sns.jdf.GeneralException;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.WebUtil;

@SuppressWarnings("serial")
public class D25WorkTimeListSV extends EHRBaseServlet {

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {

        Box box = WebUtil.getBox(req);

        req.setAttribute("E_TPGUB", box.containsKey("E_TPGUB") ? box.getString("E_TPGUB") : ""); // 사원구분

        printJspPage(req, res, WebUtil.JspURL + "D/D25WorkTime/D25WorkTimeList.jsp");
    }

}