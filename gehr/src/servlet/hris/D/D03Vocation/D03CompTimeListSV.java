/********************************************************************************/
/*   System Name  : ESS
/*   1Depth Name  : My HR
/*   2Depth Name  : �ް�/����
/*   Program Name : �����ް� �߻�����
/*   Program ID   : D03CompTimeListSV.java
/*   Description  : �����ް� �߻����� JSP ȣ�� class
/*   Note         : 
/*   Creation     : 2018-07-25 [WorkTime52] ������
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