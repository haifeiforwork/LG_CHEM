/********************************************************************************/
/*   System Name  : MSS
/*   1Depth Name  : ��������
/*   2Depth Name  : ����/�ο���Ȳ
/*   Program Name : �ٹ� �Է� ��Ȳ
/*   Program ID   : D25WorkTimeLeaderWeeklySV.java
/*   Description  : �Ϻ� �ٹ� �Է� ��Ȳ ��� JSP ��ûó�� class
/*   Note         : 
/*   Creation     : 2018-05-04 [WorkTime52] ������
/*   Update       : 
/********************************************************************************/

package servlet.hris.D.D25WorkTime;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;

import com.sns.jdf.GeneralException;
import com.sns.jdf.sap.RfcDataHandler;
import com.sns.jdf.sap.RfcHandler;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;

@SuppressWarnings("serial")
public class D25WorkTimeLeaderWeeklySV extends EHRBaseServlet {

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {

        // Excel download
        if ("excel-download".equals(req.getParameter("jobid"))) {
            Box box = WebUtil.getBox(req);

            final Map<String, Object> params = box.getHashMap();
            params.put("I_LOGPER", WebUtil.getSessionUser(req).getEmpNo());
            params.put("I_DATUM", DataUtil.getCurrentDate());
            params.put("I_ACTGB", "W");

            Map<String, Object> rfcResultData = RfcHandler.execute("ZGHR_RFC_NTM_ORGEH_RWKD_LIST", params);
            String message = g.getMessage("MSG.D.D25.N0002"); // �ٹ��ð� ���� ����� ��ȸ���� ���߽��ϴ�.

            if (!RfcDataHandler.isSuccess(rfcResultData)) {
                String msg = RfcDataHandler.getMessage(rfcResultData);
                throw new GeneralException(StringUtils.isEmpty(msg) ? message : msg);
            }

            req.setAttribute("TABLES", rfcResultData.get("TABLES"));

            printJspPage(req, res, WebUtil.JspURL + "D/D25WorkTime/D25WorkTimeLeaderWeeklyExcel.jsp");

        } else {
            printJspPage(req, res, WebUtil.JspURL + "D/D25WorkTime/D25WorkTimeLeaderWeekly.jsp");

        }
    }

}