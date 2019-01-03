/********************************************************************************/
/*   System Name  : Mobile
/*   1Depth Name  : 
/*   2Depth Name  : 
/*   Program Name : 
/*   Program ID   : MobileBaseServlet.java
/*   Description  : Mobile interface�� �ڵ� �α��� base servlet
/*   Note         : Mobile�� response�� �������� data format�� JSON�� ��쿡�� ����� ��
/*   Creation     : 2018-08-21 [WorkTime52] ������
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
            // ��ȣȭ ����� ��ȣȭ�Ͽ� �ڵ� �α��� ó��(session ����)
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
            // ��� ��ȣȭ
            String empNo = EncryptionTool.decrypt(WebUtil.getBox(req).getString("empNo"));

            if (empNo.length() >= 9) {
                throw new Exception("Mobile(JSON) auto login - ��ȣȭ�� ����� ���̰� 9�̻��Դϴ�. empNo : " + empNo);
            }

            WebUserData user = new WebUserData();
            user.empNo = DataUtil.fixEndZero(empNo, 8);
            Logger.debug.println(this, "Mobile(JSON) auto login - empNo : " + user.empNo);

            PersonInfoRFC personInfoRFC = new PersonInfoRFC();
            PersonData personData = personInfoRFC.getPersonInfo(empNo, "X");

            if (StringUtils.isBlank(personData.E_BUKRS)) {
                throw new Exception("Mobile(JSON) auto login - ȸ���ڵ� ����");
            }

            Config conf = new Configuration();
            user.clientNo = conf.get("com.sns.jdf.sap.SAP_CLIENT");
            user.login_stat = "Y";

            personInfoRFC.setSessionUserData(personData, user);

            user.loginPlace = "ElOffice";
            user.empNo = DataUtil.fixEndZero(empNo, 8);

            DataUtil.fixNull(user);

            // Session ����
            HttpSession session = req.getSession(true);
            session.setMaxInactiveInterval(Integer.parseInt(conf.get("com.sns.jdf.SESSION_MAX_INACTIVE_INTERVAL")));
            session.setAttribute("user", user);

            Logger.debug.println(this, "Mobile(JSON) auto login - complete");

        } catch (Exception e) {
            Logger.err.println(this, "Mobile(JSON) auto login - ó�� ����");
            Logger.err.println(this, e);

            throw new GeneralException(e);

        }
    }

}