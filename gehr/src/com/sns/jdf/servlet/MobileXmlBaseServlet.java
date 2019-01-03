/********************************************************************************/
/*   System Name  : Mobile
/*   1Depth Name  : 
/*   2Depth Name  : 
/*   Program Name : 
/*   Program ID   : MobileBaseServlet.java
/*   Description  : Mobile interface�� �ڵ� �α��� base servlet
/*   Note         : Mobile�� response�� �������� data format�� XML�� ��쿡�� ����� ��
/*   Creation     : 2018-08-21 [WorkTime52] ������
/*   Update       : 
/********************************************************************************/

package com.sns.jdf.servlet;

import java.util.Collection;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang.StringUtils;

import com.common.Utils;
import com.google.common.base.Predicate;
import com.google.common.collect.Collections2;
import com.sns.jdf.Config;
import com.sns.jdf.Configuration;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.mobile.EncryptionTool;
import com.sns.jdf.mobile.MobileCodeErrVO;
import com.sns.jdf.mobile.XmlUtil;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;

import hris.common.PersonData;
import hris.common.WebUserData;
import hris.common.approval.ApprovalLineData;
import hris.common.rfc.PersonInfoRFC;

@SuppressWarnings("serial")
public abstract class MobileXmlBaseServlet extends EHRBaseServlet {

    protected final String RETURN_XML = "returnXml";

    /**
     * XML root element name ��ȯ
     * 
     * @return
     */
    protected abstract String getRootName();

    @Override
    protected void performPreTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {

        try {
            // ��ȣȭ ����� ��ȣȭ�Ͽ� �ڵ� �α��� ó��(session ����)
            autoLogin(req, res);

            performTask(req, res);

        } catch (GeneralException e) {
            Logger.err.println(this, e);

            req.setAttribute(RETURN_XML, XmlUtil.createErroXml(getRootName(), MobileCodeErrVO.ERROR_CODE_999, e.getMessage()));
            printJspPage(req, res, WebUtil.JspURL + "common/mobileResult.jsp");
        }
    }

    /**
     * ��ȣȭ�� empNo parameter�� ��ȣȭ �� session�� �����Ѵ�.
     * 
     * @param req
     * @param res
     * @throws GeneralException
     */
    protected void autoLogin(HttpServletRequest req, HttpServletResponse res) throws GeneralException {

        Logger.debug.println(this, "Mobile(XML) auto login - start");
        try {
            // ��� ��ȣȭ
            String empNo = EncryptionTool.decrypt(WebUtil.getBox(req).getString("empNo"));

            if (empNo.length() >= 9) {
                throw new Exception("Mobile(XML) auto login - ��ȣȭ�� ����� ���̰� 9�̻��Դϴ�. empNo : " + empNo);
            }

            WebUserData user = new WebUserData();
            user.empNo = DataUtil.fixEndZero(empNo, 8);
            Logger.debug.println(this, "Mobile(XML) auto login - empNo : " + user.empNo);

            PersonInfoRFC personInfoRFC = new PersonInfoRFC();
            PersonData personData = personInfoRFC.getPersonInfo(empNo, "X");

            if (StringUtils.isBlank(personData.E_BUKRS)) {
                throw new Exception("Mobile(XML) auto login - ȸ���ڵ� ����");
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

            Logger.debug.println(this, "Mobile(XML) auto login - complete");

        } catch (Exception e) {
            Logger.err.println(this, "Mobile(XML) auto login - ó�� ����");

            throw new GeneralException(e);

        }
    }

    /**
     * ���� ���� ���������� ���� �Ұ����� ������� ���� üũ
     *
     * @param approvalLine
     * @param approvalLineDefault
     * @return
     */
    protected boolean checkApprovalLine(Vector<ApprovalLineData> approvalLine, Vector<ApprovalLineData> approvalLineDefault) {

        for (final ApprovalLineData row : approvalLineDefault) {
            if ("01".equals(row.APPU_TYPE)) {
                continue;
            }

            // ���� APPR_SEQN APPU_TYPE�� ���� PERNR�� �����ϴ��� Ȯ�� �Ѵ�. 1�� �̾�� ����
            Collection<ApprovalLineData> changeList = Collections2.filter(approvalLine, new Predicate<ApprovalLineData>() {
                public boolean apply(ApprovalLineData approvalLineData) {
                    return StringUtils.equals(row.APPR_SEQN, approvalLineData.APPR_SEQN)
                        && StringUtils.equals(row.APPU_TYPE, approvalLineData.APPU_TYPE)
                        && StringUtils.equals(row.APPU_NUMB, approvalLineData.APPU_NUMB);
                }
            });

            if (Utils.getSize(changeList) != 1) {
                return false;
            }
        }

        return true;
    }

}