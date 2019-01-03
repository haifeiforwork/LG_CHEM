/********************************************************************************/
/*   System Name  : Mobile
/*   1Depth Name  : 
/*   2Depth Name  : 
/*   Program Name : 
/*   Program ID   : MobileBaseServlet.java
/*   Description  : Mobile interface용 자동 로그인 base servlet
/*   Note         : Mobile에 response로 보내지는 data format이 XML인 경우에만 사용할 것
/*   Creation     : 2018-08-21 [WorkTime52] 유정우
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
     * XML root element name 반환
     * 
     * @return
     */
    protected abstract String getRootName();

    @Override
    protected void performPreTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {

        try {
            // 암호화 사번을 복호화하여 자동 로그인 처리(session 생성)
            autoLogin(req, res);

            performTask(req, res);

        } catch (GeneralException e) {
            Logger.err.println(this, e);

            req.setAttribute(RETURN_XML, XmlUtil.createErroXml(getRootName(), MobileCodeErrVO.ERROR_CODE_999, e.getMessage()));
            printJspPage(req, res, WebUtil.JspURL + "common/mobileResult.jsp");
        }
    }

    /**
     * 암호화된 empNo parameter를 복호화 후 session을 생성한다.
     * 
     * @param req
     * @param res
     * @throws GeneralException
     */
    protected void autoLogin(HttpServletRequest req, HttpServletResponse res) throws GeneralException {

        Logger.debug.println(this, "Mobile(XML) auto login - start");
        try {
            // 사번 복호화
            String empNo = EncryptionTool.decrypt(WebUtil.getBox(req).getString("empNo"));

            if (empNo.length() >= 9) {
                throw new Exception("Mobile(XML) auto login - 복호화된 사번의 길이가 9이상입니다. empNo : " + empNo);
            }

            WebUserData user = new WebUserData();
            user.empNo = DataUtil.fixEndZero(empNo, 8);
            Logger.debug.println(this, "Mobile(XML) auto login - empNo : " + user.empNo);

            PersonInfoRFC personInfoRFC = new PersonInfoRFC();
            PersonData personData = personInfoRFC.getPersonInfo(empNo, "X");

            if (StringUtils.isBlank(personData.E_BUKRS)) {
                throw new Exception("Mobile(XML) auto login - 회사코드 없음");
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

            Logger.debug.println(this, "Mobile(XML) auto login - complete");

        } catch (Exception e) {
            Logger.err.println(this, "Mobile(XML) auto login - 처리 오류");

            throw new GeneralException(e);

        }
    }

    /**
     * 보안 점검 인위적으로 변경 불가능한 결재라인 변경 체크
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

            // 같은 APPR_SEQN APPU_TYPE과 같은 PERNR이 존재하는지 확인 한다. 1행 이어야 정상
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