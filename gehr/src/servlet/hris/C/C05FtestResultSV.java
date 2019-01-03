package servlet.hris.C;

import com.common.constant.Area;
import com.sns.jdf.GeneralException;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.WebUtil;
import hris.C.C05FtestResult1Data;
import hris.C.rfc.C05FtestResultRFC;
import hris.common.WebUserData;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.*;

/**
 * C05FtestResultSV.java
 * ������ ���дɷ� ������ jsp�� �Ѱ��ִ� class
 * ������ ���дɷ� ������ �������� C05FtestResultRFC�� ȣ���Ͽ� C05FtestResult.jsp�� ������ ���дɷ� ������ �Ѱ��ش�.
 *
 * @author �赵��
 * @version 1.0, 2002/01/14
 * @version @v1.1, 2006/01/06
 * @version 1.1, 2013/12/18 C20131202_46202  0010:TOEIC Speaking,0011:OPIc,0012:JLPT
 * @version 1.2, 2016/02/11 [CSR ID:2981372] SAP/ERP �� G Portal(e-HR) ���м��� �߰� ��û�� ��
 */
public class C05FtestResultSV extends EHRBaseServlet {

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {

        WebUserData user = WebUtil.getSessionUser(req);

        if(process(req, res, user, "E"))
            printJspPage(req, res, WebUtil.JspURL+"C/C05FtestResult_" + (user.area == Area.KR ? "KR" : "GLOBAL") + ".jsp");

    }

    public boolean process(HttpServletRequest req, HttpServletResponse res, WebUserData user_m, String pageType) throws GeneralException {

        try{
            C05FtestResultRFC rfc   = new C05FtestResultRFC();

            String I_CFORM = (String) req.getAttribute("I_CFORM");

            Vector<C05FtestResult1Data> resultList = rfc.getFtestResult(user_m.empNo, I_CFORM);

            if(user_m.area == Area.KR) {
            /* language �� ���� Map*/
                Map<String, List<C05FtestResult1Data>> resultMap = new LinkedHashMap<String, List<C05FtestResult1Data>>();

                for (C05FtestResult1Data row : resultList) {

                    List<C05FtestResult1Data> langs = resultMap.get(row.getLANG_TYPE());
                    if (langs == null) langs = new ArrayList<C05FtestResult1Data>();
                    langs.add(row);

                    resultMap.put(row.getLANG_TYPE(), langs);
                }
                req.setAttribute("langMap", resultMap);
            }

            req.setAttribute("langList", resultList);

            req.setAttribute("pageType", pageType);
            req.setAttribute("user", user_m);

            return true;
        } catch(Exception e) {
            throw new GeneralException(e);
        }

    }


}
