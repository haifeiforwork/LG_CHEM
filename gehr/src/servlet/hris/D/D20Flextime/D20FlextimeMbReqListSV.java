/********************************************************************************/
/*
/*   System Name  : Mobile
/*   1Depth Name  : 
/*   2Depth Name  : 
/*   Program Name : Flextime 신청 목록
/*   Program ID   : D20FlextimeMbReqListSV
/*   Description  : 
/*   Note         : 
/*   Creation     : 2018-08-22 [WorkTime52]
/* 
/********************************************************************************/

package servlet.hris.D.D20Flextime;

import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.jdom.Element;

import com.sns.jdf.Configuration;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.mobile.EncryptionTool;
import com.sns.jdf.mobile.MobileCodeErrVO;
import com.sns.jdf.mobile.XmlUtil;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.MobileXmlBaseServlet;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;

import hris.G.G001Approval.ApprovalDocList;
import hris.G.G001Approval.ApprovalListKey;
import hris.G.G001Approval.rfc.G001ApprovalDocListRFC;
import hris.common.WebUserData;

@SuppressWarnings("serial")
public class D20FlextimeMbReqListSV extends MobileXmlBaseServlet {

    private final String UPMU_TYPE = "42";         // 결재 업무타입
    private final String ROOT_NAME = "apprLists";  // XML root element name

    @Override
    protected String getRootName() {
        return ROOT_NAME;
    }

    @Override
    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {

        Logger.debug.println(this, "D20FlextimeMbReqListSV start");

        // 결재처리 및 처리결과 XML 문자열 생성
        String returnXml = apprItem(req, res);

        // 처리결과 XML 문자열 request에 저장
        req.setAttribute(RETURN_XML, returnXml);
        Logger.debug.println(this, "==============================================");
        Logger.debug.println(this, returnXml);

        // response에 처리결과 XML 문자열 출력
        printJspPage(req, res, WebUtil.JspURL + "common/mobileResult.jsp");

        Logger.debug.println(this, "D20FlextimeMbReqListSV end");
    }

    /**
     * 신청취소 처리 결과를 XML형태로 가져온다.
     * 
     * @param req
     * @param res
     * @return
     * @throws GeneralException
     */
    @SuppressWarnings("rawtypes")
    private String apprItem(HttpServletRequest req, HttpServletResponse res) throws GeneralException {

        try {
            final Box box = WebUtil.getBox(req);
            final WebUserData user = WebUtil.getSessionUser(req);
            final String PERNR = user.empNo;

            String fromDate = DataUtil.delDateGubn(box.get("fromDate"));// 시작일자
            String toDate = DataUtil.delDateGubn(box.get("toDate")); // 완료일자

            ApprovalListKey inputData = new ApprovalListKey();
            if (StringUtils.isBlank(fromDate)) {
                inputData.I_BEGDA = DataUtil.getAfterDate(DataUtil.getCurrentDate(), -7);
                inputData.I_ENDDA = DataUtil.getCurrentDate();
            } else {
                inputData.I_BEGDA = fromDate;
                inputData.I_ENDDA = toDate;
            }

            inputData.I_AGUBN = "2"; // 1 : 결재해야할 문서, 2 : 결재진행중 문서, 3 : 결재완료 문서
            inputData.I_PERNR = PERNR;
            inputData.I_UPMU_TYPE = UPMU_TYPE;

            // Flextime 신청 목록
            Vector list = new G001ApprovalDocListRFC().getApprovalDocList(inputData);

            Logger.debug.println(this, "D20FlextimeMbReqListSV list.size() : " + list.size());

            Element items = XmlUtil.createItems(ROOT_NAME);
            StringBuffer baseURL = new StringBuffer("http://").append(new Configuration().getString("com.sns.jdf.eloffice.ResponseURL")).append(WebUtil.ServletURL).append("hris.MobileDetailSV");

            for (int i = 0; i < list.size(); i++) {
                ApprovalDocList data = (ApprovalDocList) list.get(i);

                StringBuffer linkURL = new StringBuffer(baseURL).append("?empNo=").append(WebUtil.encode(EncryptionTool.encrypt(PERNR))).append("&apprDocID=").append(data.AINF_SEQN);

                Element item = XmlUtil.createElement("flextimeReqList");
                XmlUtil.addChildElement(item, "apprSystemID", "EHR");
                XmlUtil.addChildElement(item, "apprSystemName", "인사");
                XmlUtil.addChildElement(item, "apprDocID", data.AINF_SEQN);
                XmlUtil.addChildElement(item, "apprTypeID", "EHR-" + data.AINF_SEQN);
                XmlUtil.addChildElement(item, "apprCategory", "Flextime 신청");
                XmlUtil.addChildElement(item, "subject", data.UPMU_NAME + " " + data.STEXT);
                XmlUtil.addChildElement(item, "linkUrl", linkURL.toString());
                XmlUtil.addChildElement(item, "apprRequestEmpNo", data.PERNR);
                XmlUtil.addChildElement(item, "apprRequestEmpName", data.ENAME);
                XmlUtil.addChildElement(item, "apprRequestEmpDept", data.STEXT);
                XmlUtil.addChildElement(item, "apprRequestEmpTitle", user.e_titel);
                XmlUtil.addChildElement(item, "apprRequestDate", data.BEGDA);

                XmlUtil.addChildElement(items, item);

                Logger.debug.println(this, "D20FlextimeMbReqListSV data : " + data.toString());
            }

            // 최종적으로 XML Document를 XML String으로 변환한다.
            if (list.size() > 0) {
                return XmlUtil.createResponseXml(items, "", Integer.toString(list.size()));
            } else {
                return XmlUtil.createResponseXml(items, "Data가 존재하지 않습니다.", "0");
            }

        } catch (Exception e) {
            return XmlUtil.createErroXml(ROOT_NAME, MobileCodeErrVO.ERROR_CODE_300, e.getMessage());

        }
    }

}