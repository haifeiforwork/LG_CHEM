package servlet.hris.common;

import com.sns.jdf.Config;
import com.sns.jdf.Configuration;
import com.sns.jdf.GeneralException;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;
import hris.common.PersonData;
import hris.common.WebUserData;
import hris.common.rfc.PersonInfoRFC;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class MSSPersonValCheckSV extends EHRBaseServlet {


    private static final long serialVersionUID = 1L;

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {
        try {
            HttpSession session = req.getSession(false);
            WebUserData user = WebUtil.getSessionUser(req);

            Box box = WebUtil.getBox(req);

            String prsn = box.get("empNo");

            /********************************************
             *  @$ 웹보안진단 marco257
             *  MSS 부서개인인적사항 조직도 사원 검색시
             *  로그인 사번이 해당 사번을 조회할수 있는지
             *  체크함.
             ********************************************/
            box.put("I_DEPT", user.empNo); //로그인 사번
            box.put("I_PERNR", prsn);   // 조회사번
            //box.put("I_RETIR", ""); //재직자만 조회됨 - 기존 로직
            String reCode ="S";
            if (user.sapType.isLocal()){
                if(!checkBelongPerson(req, res, prsn, box.get("I_RETIR"))) reCode = "E";
            }
            String dest = "";
            if (reCode.equals("S")) { //조회 가능
                WebUserData user_m = new WebUserData();

                PersonInfoRFC personInfoRFC = new PersonInfoRFC();
                PersonData personData = new PersonData();

                personData = (PersonData) personInfoRFC.getPersonInfo(prsn, "X");

                user_m.login_stat = "Y";
                user_m.companyCode = personData.E_BUKRS;

                Config conf = new Configuration();
                user_m.clientNo = conf.get("com.sns.jdf.sap.SAP_CLIENT");

                user_m.empNo = prsn;
                personInfoRFC.setSessionUserData(personData, user_m);
                user_m.e_mss = "X";

                DataUtil.fixNull(user_m);

                session = req.getSession(true);

                int maxSessionTime = Integer.parseInt(conf.get("com.sns.jdf.SESSION_MAX_INACTIVE_INTERVAL"));
                session.setMaxInactiveInterval(maxSessionTime);

                session.setAttribute("user_m", user_m);


                dest = WebUtil.JspURL + "common/NewSession.jsp";
            } else {
                String msg = "인사정보 조회대상이 아니거나 사원마스터가 없습니다";
                //String url = "history.back();";
                req.setAttribute("msg", msg);
                //req.setAttribute("url", url);
                dest = WebUtil.JspURL + "common/msg.jsp";
            }
            printJspPage(req, res, dest);
        } catch (Exception e) {
            throw new GeneralException(e);
        } finally {
            //DBUtil.close(con);
        }
    }
}