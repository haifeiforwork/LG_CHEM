/********************************************************************************/
/*   System Name  : Mobile
/*   1Depth Name  : 
/*   2Depth Name  : 
/*   Program Name : 
/*   Program ID   : MobileBaseServlet.java
/*   Description  : Mobile interface용 자동 로그인 base servlet
/*   Note         : Mobile에 response로 보내지는 data format이 JSON인 경우에만 사용할 것
/*   Creation     : 2018-08-21 [WorkTime52] 유정우
/*   Update       : 
/********************************************************************************/

package com.sns.jdf.servlet;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang.StringUtils;

import com.common.AjaxResultMap;
import com.sns.jdf.Config;
import com.sns.jdf.Configuration;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.mobile.EncryptionTool;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;

import hris.common.PersonData;
import hris.common.WebUserData;
import hris.common.rfc.PersonInfoRFC;

@SuppressWarnings("serial")
public abstract class MobileJsonBaseServlet extends EHRBaseServlet {

    @Override
    protected void performPreTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {

        try {
            // 암호화 사번을 복호화하여 자동 로그인 처리(session 생성)
            autoLogin(req, res);

            performTask(req, res);

        } catch (GeneralException e) {
            Logger.err.println(this, e);

            try {
                new AjaxResultMap().setErrorMessage(e.getMessage()).writeJson(res);
            } catch (Exception e1) {
                Logger.err.println(this, e1);
                throw new GeneralException(e1);
            }

        }
    }

    protected abstract void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException;

    public void autoLogin(HttpServletRequest req, HttpServletResponse res) throws GeneralException {

        Logger.debug.println(this, "Mobile(JSON) auto login - start");
        try {
            // 사번 복호화
            String empNo = EncryptionTool.decrypt(WebUtil.getBox(req).getString("empNo"));

            if (empNo.length() >= 9) {
                throw new Exception("Mobile(JSON) auto login - 복호화된 사번의 길이가 9이상입니다. empNo : " + empNo);
            }

            WebUserData user = new WebUserData();
            user.empNo = DataUtil.fixEndZero(empNo, 8);
            Logger.debug.println(this, "Mobile(JSON) auto login - empNo : " + user.empNo);

            PersonInfoRFC personInfoRFC = new PersonInfoRFC();
            PersonData personData = personInfoRFC.getPersonInfo(empNo, "X");

            if (StringUtils.isBlank(personData.E_BUKRS)) {
                throw new Exception("Mobile(JSON) auto login - 회사코드 없음");
            }

            Config conf = new Configuration();
            user.clientNo = conf.get("com.sns.jdf.sap.SAP_CLIENT");
            user.login_stat = "Y";

            personInfoRFC.setSessionUserData(personData, user);

            user.loginPlace = "ElOffice";
            user.empNo = DataUtil.fixEndZero(empNo, 8);

            DataUtil.fixNull(user);

            // Session 생성
            HttpSession session = req.getSession(true);
            session.setMaxInactiveInterval(Integer.parseInt(conf.get("com.sns.jdf.SESSION_MAX_INACTIVE_INTERVAL")));
            session.setAttribute("user", user);

            Logger.debug.println(this, "Mobile(JSON) auto login - complete");

        } catch (Exception e) {
            Logger.err.println(this, "Mobile(JSON) auto login - 처리 오류");
            Logger.err.println(this, e);

            throw new GeneralException(e);

        }
    }

}