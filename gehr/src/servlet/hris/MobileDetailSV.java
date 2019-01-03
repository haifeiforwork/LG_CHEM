/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 초과근무                                                    */
/*   Program Name : 초과근무 조회                                               */
/*   Program ID   : D01OTDetailSV                                               */
/*   Description  : 초과근무 조회 및 삭제를 할 수 있도록 하는 Class             */
/*   Note         :                                                             */
/*   Creation     : 2002-01-15  박영락                                          */
/*   Update       : 2005-03-03  윤정현                                          */
/*                      2018/06/08 rdcamel	[CSR ID:3700538] 보상휴가제 도입에 따른 Mobile 휴가신청 및 결재화면 수정 요청 건  
 *                                                               */
/********************************************************************************/

package servlet.hris;

import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.jdom.Document;
import org.jdom.Element;

import com.common.Utils;
import com.sns.jdf.Configuration;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.mobile.EncryptionTool;
import com.sns.jdf.mobile.MobileCodeErrVO;
import com.sns.jdf.mobile.XmlUtil;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;

import hris.D.D01OT.D01OTData;
import hris.D.D01OT.rfc.D01OTAFRFC;
import hris.D.D01OT.rfc.D01OTRFC;
import hris.D.D03Vocation.D03VocationData;
import hris.D.D03Vocation.rfc.D03VocationRFC;
import hris.D.D20Flextime.D20FlextimeData;
import hris.D.D20Flextime.rfc.D20FlextimeRFC;
import hris.G.rfc.ApprovalHeaderRFC;
import hris.common.PersInfoData;
import hris.common.approval.ApprovalHeader;
import hris.common.approval.ApprovalLineData;
import hris.common.rfc.PersInfoWithNoRFC;

@SuppressWarnings("serial")
public class MobileDetailSV extends MobileAutoLoginSV {

    private final String APPR_SYSTEM_ID_GEA = "EHR";
    private final String COMPANY_NAME = "LG Chem";

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {

        try {
            Logger.debug.println("MobileDetailSV start++++++++++++++++++++++++++++++++++++++");

            Box box = WebUtil.getBox(req);

            String AINF_SEQN = box.get("apprDocID"); // 결재문서번호
            String empNo = DataUtil.fixEndZero(EncryptionTool.decrypt(box.get("empNo")), 8); // 사번

            // Logger.debug.println("jkd1234 +++++++++++++++++++++++++>"+ EncryptionTool.encrypt("jkd1234"));
            // Logger.debug.println("00003456 ++++++++++++++++++++++++>"+ EncryptionTool.encrypt("00003456"));
            // Logger.debug.println("test5678 ++++++++++++++++++++++++>"+ EncryptionTool.encrypt("test5678"));
            Logger.debug.println("JMK empNo+++++++++++++++++++++++++++++++++>" + empNo);
            Logger.debug.println("AINF_SEQN+++++++++++++++++++++++++++++++++>" + AINF_SEQN);

            // 상세문서 조회
            String returnXml = apprItem(AINF_SEQN, empNo);

            // 결과에 대한 xmlStirng을 저장한다.
            req.setAttribute("returnXml", returnXml);
            // LHtmlUtil.blockHttpCache(res);

            // 3.return URL을 호출한다.
            String dest = WebUtil.JspURL + "common/mobileResult.jsp";
            Logger.debug.println(this, " destributed = " + dest);
            printJspPage(req, res, dest);

        } catch (Exception e) {
            throw new GeneralException(e);
        }
    }

    /**
     * 결재를 처리한 결과를 XML형태로 가져온다.
     * 
     * @return
     */
    @SuppressWarnings("rawtypes")
    public String apprItem(String AINF_SEQN, String P_PERNR) {

        String xmlString = "";
        String itemsName = "apprItem";

        // LData appDocData = null; // 저장된 문서 정보
        // LData myAppTarget = null; // 내결재정보
        // LData appIntSubInfo = null; // 통합결재 정보
        // LMultiData appTargetList = null; // 결재자 리스트
        // LMultiData fileList = null;

        // String locale = input.getString("locale");

        try {
            Vector<ApprovalLineData> appTargetList = null; // 결재라인

            String apprSummary = "";     // 상세요약정보
            String appRequestSabun = ""; // 기안자 사번
            String apprRequestDate = ""; // 신청일자
            String apprLinkDocUrl = "";  // 원문보기 URL
            String apprLinkDocName = ""; // 원문보기 URL명
            String apprLinkBaseUrl = new Configuration().getString("com.sns.jdf.eloffice.ResponseURL");

            ApprovalHeader approvalHeader = new ApprovalHeaderRFC().getApprovalHeader(AINF_SEQN, P_PERNR);

            if (!"X".equals(approvalHeader.DISPFL)) {
                Logger.info.println(this, P_PERNR + "는 " + AINF_SEQN + " 문서에 접근할 수 없습니다");

                String errorMsg = MobileCodeErrVO.ERROR_MSG_200 + P_PERNR + "는 " + AINF_SEQN + " 문서에 접근할 수 없습니다";
                return XmlUtil.createErroXml(itemsName, MobileCodeErrVO.ERROR_CODE_200, errorMsg);
            }
/*
            // 문서정보 GET
            DocumentInfo docInfo = new DocumentInfo(AINF_SEQN ,P_PERNR);
            
            if (docInfo == null) {
               	Logger.debug.println(this.getClass().getName() + " error 1 ");

                return XmlUtil.createErroXml(itemsName, MobileCodeErrVO.ERROR_CODE_000, MobileCodeErrVO.ERROR_MSG_000);
            }
            
            // 문서권한확인
            if (!docInfo.isHaveAuth()) {
                Logger.info.println(this ,P_PERNR + "는 " + AINF_SEQN + " 문서에 접근할 수 없습니다");

                String errorMsg = MobileCodeErrVO.ERROR_MSG_200+P_PERNR + "는 " + AINF_SEQN + " 문서에 접근할 수 없습니다";
                return XmlUtil.createErroXml(itemsName, MobileCodeErrVO.ERROR_CODE_200, errorMsg);
            }
*/
            String UPMU_TYPE = approvalHeader.getUPMU_TYPE(); // 문서타입
            String apprDelFlag = ""; // 휴가신청 삭제가능 flag

            Logger.debug.println(" ====================UPMU_TYPE>>" + UPMU_TYPE);
            /*********************************
             * 문서타입이 없을경우
             *********************************/
            if (StringUtils.isBlank(UPMU_TYPE)) {
                String errorMsg = MobileCodeErrVO.ERROR_MSG_100;
                return XmlUtil.createErroXml(itemsName, MobileCodeErrVO.ERROR_CODE_100, errorMsg);
            }

            /******************************
             * 저장된 APP_DOC 문서 정보 조회
             ******************************/
            // 초과근무
            if (UPMU_TYPE.equals("17")) {
                D01OTRFC rfc17 = new D01OTRFC();
                rfc17.setDetailInput(P_PERNR, approvalHeader.UPMU_TYPE, AINF_SEQN);
                Vector D01OTData_vt = rfc17.getDetail(AINF_SEQN, P_PERNR);
                appTargetList = rfc17.getApprovalLine(); // 결재선

                D01OTData firstData = (D01OTData) D01OTData_vt.get(0); // 초과근무 신청정보

                String VTKEN = (firstData.VTKEN).equals("X") ? "포함" : "불포함"; // 전일근무 포함 여부
                String PUNB1 = (firstData.PUNB1).equals("0") ? "" : WebUtil.printNum(firstData.PUNB1);
                String PBEZ1 = (firstData.PBEZ1).equals("0") ? "" : WebUtil.printNum(firstData.PBEZ1);
                String PUNB2 = (firstData.PUNB2).equals("0") ? "" : WebUtil.printNum(firstData.PUNB2);
                String PBEZ2 = (firstData.PBEZ2).equals("0") ? "" : WebUtil.printNum(firstData.PBEZ2);

                apprSummary = new StringBuffer()
                    .append("◎신청일:").append(firstData.BEGDA)
                    .append("\n◎초과근무일:").append(firstData.WORK_DATE)
                    .append("\n◎전일근태에포함:").append(VTKEN)
                    .append("\n◎시간:").append(WebUtil.printTime(firstData.BEGUZ)).append("~").append(WebUtil.printTime(firstData.ENDUZ)).append("(").append(firstData.STDAZ).append("시간)")
                    .append("\n◎신청사유:").append(firstData.REASON)
                    .append("\n◎휴게시간1시작:").append(WebUtil.printTime(firstData.PBEG1))
                    .append("\n◎휴게시간1종료:").append(WebUtil.printTime(firstData.PEND1))
                    .append("\n◎휴게시간1무급:").append(PUNB1)
                    .append("\n◎휴게시간1유급:").append(PBEZ1)
                    .append("\n◎휴게시간2시작:").append(WebUtil.printTime(firstData.PBEG2))
                    .append("\n◎휴게시간2종료:").append(WebUtil.printTime(firstData.PEND2))
                    .append("\n◎휴게시간2무급:").append(PUNB2)
                    .append("\n◎휴게시간2유급:").append(PBEZ2).toString();

                appRequestSabun = firstData.PERNR; // 신청자 사번
                apprRequestDate = firstData.BEGDA; // 신청일자
                apprLinkDocName = "초과근무";      // 원문보기 URL명
                apprLinkDocUrl = "http://" + apprLinkBaseUrl + WebUtil.ServletURL + "hris.MobilePassSV?AINF_SEQN=" + AINF_SEQN + "&isNotApp=false"; // 원문보기 URL
            }
            // 휴가
            else if (UPMU_TYPE.equals("18")) {
                D03VocationRFC rfc18 = new D03VocationRFC();
                rfc18.setDeleteInput(P_PERNR, approvalHeader.UPMU_TYPE, AINF_SEQN);
                Vector d03VocationData_vt = rfc18.getVocation(P_PERNR, AINF_SEQN);
                appTargetList = rfc18.getApprovalLine(); // 결재선

                D03VocationData d03VocationData = (D03VocationData) d03VocationData_vt.get(0); // 휴가 신청정보

                String strAwrt = "";
                String strAwrtType = "연차휴가";// [CSR ID:3700538] 연차/보상 휴가 구분
                String strTime = d03VocationData.BEGUZ.equals("") ? "" : WebUtil.printTime(d03VocationData.BEGUZ) + "~" + WebUtil.printTime(d03VocationData.ENDUZ);

                if (d03VocationData.AWART.equals("0110")) {
                    strAwrt = "전일휴가";
                } else if (d03VocationData.AWART.equals("0120")) {
                    strAwrt = "반일휴가(전반)";
                } else if (d03VocationData.AWART.equals("0121")) {
                    strAwrt = "반일휴가(후반)";
                } else if (d03VocationData.AWART.equals("0122")) {
                    strAwrt = "토요휴가";
                } else if (d03VocationData.AWART.equals("0340")) {
                    strAwrt = "휴일비근무";
                } else if (d03VocationData.AWART.equals("0360")) {
                    strAwrt = "근무면제";
                } else if (d03VocationData.AWART.equals("0140")) {
                    strAwrt = "하계휴가";
                } else if (d03VocationData.AWART.equals("0130")) {
                    strAwrt = "경조휴가";
                } else if (d03VocationData.AWART.equals("0170")) {
                    strAwrt = "전일공가";
                } else if (d03VocationData.AWART.equals("0180")) {
                    strAwrt = "시간공가";
                } else if (d03VocationData.AWART.equals("0150")) {
                    strAwrt = "보건휴가";
                }
                // [CSR ID:3700538] 보상 전용 휴가 유형 및 구분 추가
                else if (d03VocationData.AWART.equals("0111")) {
                    strAwrt = "전일휴가";
                    strAwrtType = "보상휴가";
                } else if (d03VocationData.AWART.equals("0112")) {
                    strAwrt = "반일휴가(전반)";
                    strAwrtType = "보상휴가";
                } else if (d03VocationData.AWART.equals("0113")) {
                    strAwrt = "반일휴가(후반)";
                    strAwrtType = "보상휴가";
                }
                // [CSR ID:3700538] 휴가유형 추가
                apprSummary = new StringBuffer()
                    .append("◎신청일:").append(d03VocationData.BEGDA)
                    .append("\n◎휴가유형:").append(strAwrtType)
                    .append("\n◎휴가구분:").append(strAwrt)
                    .append("\n◎신청사유:").append(d03VocationData.REASON)
                    .append("\n◎휴가기간:").append(d03VocationData.APPL_FROM).append("~").append(d03VocationData.APPL_TO)
                    .append("\n◎휴가시간:").append(strTime).toString();

                // 휴가신청 삭제 Flag T 이면 삭제 가능
                if ("X".equals(approvalHeader.MODFL)) {
                    apprDelFlag = "T";
                }

                appRequestSabun = d03VocationData.PERNR; // 신청자 사번
                apprRequestDate = d03VocationData.BEGDA; // 신청일자
                apprLinkDocName = "휴가신청"; // 원문보기 URL명
                apprLinkDocUrl  = "http://" + apprLinkBaseUrl + WebUtil.ServletURL + "hris.MobilePassSV?AINF_SEQN=" + AINF_SEQN + "&isNotApp=false"; // 원문보기 URL
            }
            // Flextime
            else if (UPMU_TYPE.equals("42")) {
                D20FlextimeRFC rfc42 = new D20FlextimeRFC();
                rfc42.setDetailInput(P_PERNR, approvalHeader.UPMU_TYPE, AINF_SEQN);
                Vector<D20FlextimeData> detailList = rfc42.getDetail();
                appTargetList = rfc42.getApprovalLine(); // 결재선

                // Flextime 신청정보
                D20FlextimeData data = (D20FlextimeData) Utils.indexOf(detailList, 0);

                boolean isB = StringUtils.isBlank(data.FLEX_ENDDA);
                apprSummary = new StringBuffer()
                    .append("◎신청일:").append(data.BEGDA)
                    .append("\n◎근무시간:").append(WebUtil.printTime(data.FLEX_BEGTM)).append("~").append(WebUtil.printTime(data.FLEX_ENDTM))
                    .append("\n◎적용기간:").append(WebUtil.printDate(data.FLEX_BEGDA)).append(isB ? "" : "~").append(isB ? "" : WebUtil.printTime(data.FLEX_ENDDA)).toString();

                appRequestSabun = data.PERNR; // 신청자 사번
                apprRequestDate = data.BEGDA; // 신청일자
                apprLinkDocName = "Flextime 신청"; // 원문보기 URL명
                apprLinkDocUrl = "http://" + apprLinkBaseUrl + WebUtil.ServletURL + "hris.MobilePassSV?AINF_SEQN=" + AINF_SEQN + "&isNotApp=false"; // 원문보기 URL
            }
            // 사후 초과근무
            else if (UPMU_TYPE.equals("44")) {
                D01OTAFRFC rfc44 = new D01OTAFRFC();
                rfc44.setDetailInput(P_PERNR, approvalHeader.UPMU_TYPE, AINF_SEQN);
                Vector D01OTData_vt = rfc44.getDetail(AINF_SEQN, P_PERNR);
                appTargetList = rfc44.getApprovalLine(); // 결재선

                // 사후 초과근무 신청정보
                D01OTData firstData = (D01OTData) Utils.indexOf(D01OTData_vt, 0);

                // 전일근무 포함 여부
                String VTKEN = (firstData.VTKEN).equals("X") ? "포함" : "불포함";
                String PUNB1 = (firstData.PUNB1).equals("0") ? "" : WebUtil.printNum(firstData.PUNB1);
                String PBEZ1 = (firstData.PBEZ1).equals("0") ? "" : WebUtil.printNum(firstData.PBEZ1);
                String PUNB2 = (firstData.PUNB2).equals("0") ? "" : WebUtil.printNum(firstData.PUNB2);
                String PBEZ2 = (firstData.PBEZ2).equals("0") ? "" : WebUtil.printNum(firstData.PBEZ2);

                apprSummary = new StringBuffer()
                    .append("◎신청일:").append(firstData.BEGDA)
                    .append("\n◎초과근무일:").append(firstData.WORK_DATE)
                    .append("\n◎전일근태에포함:").append(VTKEN)
                    .append("\n◎시간:").append(WebUtil.printTime(firstData.BEGUZ)).append("~").append(WebUtil.printTime(firstData.ENDUZ)).append("(").append(firstData.STDAZ).append("시간)")
                    .append("\n◎신청사유:").append(firstData.REASON)
                    .append("\n◎휴게시간1시작:").append(WebUtil.printTime(firstData.PBEG1))
                    .append("\n◎휴게시간1종료:").append(WebUtil.printTime(firstData.PEND1))
                    .append("\n◎휴게시간1무급:").append(PUNB1)
                    .append("\n◎휴게시간1유급:").append(PBEZ1)
                    .append("\n◎휴게시간2시작:").append(WebUtil.printTime(firstData.PBEG2))
                    .append("\n◎휴게시간2종료:").append(WebUtil.printTime(firstData.PEND2))
                    .append("\n◎휴게시간2무급:").append(PUNB2)
                    .append("\n◎휴게시간2유급:").append(PBEZ2).toString();

                appRequestSabun = firstData.PERNR; // 신청자 사번
                apprRequestDate = firstData.BEGDA; // 신청일자
                apprLinkDocName = "초과근무사후신청"; // 원문보기 URL명
                apprLinkDocUrl = "http://" + apprLinkBaseUrl + WebUtil.ServletURL + "hris.MobilePassSV?AINF_SEQN=" + AINF_SEQN + "&isNotApp=false"; // 원문보기 URL
            }
            Logger.debug.println("###########################");
            Logger.debug.println("apprSummary : " + apprSummary);
            Logger.debug.println("###########################");

            /* 기안자정보 */
            PersInfoWithNoRFC piRfc = new PersInfoWithNoRFC();
            Vector apprRequest_vt = piRfc.getApproval(appRequestSabun);

            Logger.debug.println("###########################");
            Logger.debug.println("pid : " + apprRequest_vt);
            Logger.debug.println("###########################");

            /* 결재자 LIST */
/*
            ApprInfoRFC func = new ApprInfoRFC();
            appTargetList = func.getApproval( AINF_SEQN );
*/
            Logger.debug.println("###########################");
            Logger.debug.println("appTargetList : " + appTargetList);
            Logger.debug.println("###########################");

            Element items = XmlUtil.createItems(itemsName); // Root element 생성

            // 성공인경우 리턴코드에 0을 세팅한다.
            XmlUtil.addChildElement(items, "returnDesc", "");
            XmlUtil.addChildElement(items, "returnCode", "0");

            PersInfoData pid = (PersInfoData) apprRequest_vt.get(0);
            // Logger.debug.println("###################### "+ input +" ####################");
            // 기안자
            XmlUtil.addChildElement(items, "apprSystemID", APPR_SYSTEM_ID_GEA);
            // XmlUtil.addChildElement(items, "apprTypeID","EHR-"+AINF_SEQN);
            XmlUtil.addChildElement(items, "apprDocID", AINF_SEQN);
            XmlUtil.addChildElement(items, "apprRequestEmpNo", pid.PERNR);
            XmlUtil.addChildElement(items, "apprRequestEmpName", pid.ENAME);
            XmlUtil.addChildElement(items, "apprRequestEmpDept", pid.ORGEH);
            XmlUtil.addChildElement(items, "apprRequestEmpTitle", pid.TITEL);
            XmlUtil.addChildElement(items, "apprRequestEmpEmail", "");
            XmlUtil.addChildElement(items, "apprRequestEmpOffice", pid.TELNUMBER);
            XmlUtil.addChildElement(items, "apprRequestEmpMobile", "");
            XmlUtil.addChildElement(items, "apprRequestCompanyKorName", COMPANY_NAME);
            XmlUtil.addChildElement(items, "apprRequestDate", apprRequestDate);
            XmlUtil.addChildElement(items, "apprSummary", apprSummary);
            XmlUtil.addChildElement(items, "apprDelFlag", apprDelFlag);

            // 결재라인 검색된 결과값을 이용하여 row데이터에 대한 XML element를 생성한다.
            String APPL_APPR_STAT = ""; // 승인상태
            String apprCurFlag = ""; // 현결재자여부
            String apprCurFlagTemp = "";
            String APPL_APPR_DATA = ""; // 승인일자

            for (int i = 0; i < appTargetList.size(); i++) {
                ApprovalLineData appLineData = appTargetList.get(i);

                // 승인일자
                APPL_APPR_DATA = appLineData.APPR_DATE.equals("") ? "" : appLineData.APPR_DATE.equals("0000-00-00") ? "" : WebUtil.printDate(appLineData.APPR_DATE, "-");
                if (appLineData.APPR_STAT.equals("A")) {
                    APPL_APPR_STAT = "승인";
                } else if (appLineData.APPR_STAT.equals("R")) {
                    APPL_APPR_STAT = "반려";
                } else {
                    APPL_APPR_STAT = "미결";
                    // 현재결재라인 인지를 위한 처리
                    apprCurFlag = "";// 초기화
                    if (apprCurFlag.equals("") && apprCurFlagTemp.equals("")) {
                        apprCurFlag = "T";
                    }
                    apprCurFlagTemp = "T";
                }

                Element item = XmlUtil.createElement("approver");
                XmlUtil.addChildElement(item, "apprCurFlag", apprCurFlag);
                XmlUtil.addChildElement(item, "apprApproveEmpNo", appLineData.PERNR);
                XmlUtil.addChildElement(item, "apprApproveEmpName", appLineData.ENAME);
                XmlUtil.addChildElement(item, "apprApproveEmpDept", appLineData.APPU_NAME);
                XmlUtil.addChildElement(item, "apprApproveEmpTitle", appLineData.JIKWT);
                XmlUtil.addChildElement(item, "apprApproveEmpEmail", "");
                XmlUtil.addChildElement(item, "apprApproveEmpOffice", appLineData.PHONE_NUM);
                XmlUtil.addChildElement(item, "apprApproveEmpMobile", "");
                XmlUtil.addChildElement(item, "apprApproveCompanyKorName", COMPANY_NAME);
                XmlUtil.addChildElement(item, "apprApproveDate", APPL_APPR_DATA);
                XmlUtil.addChildElement(item, "apprApproveType", "APPROVAL"); // 승인,반려만 있음
                XmlUtil.addChildElement(item, "apprComment", appLineData.BIGO_TEXT);
                XmlUtil.addChildElement(item, "apprType", APPL_APPR_STAT);

                XmlUtil.addChildElement(items, item);
            }

            // HR은 원문보기 하나만 존재함
            for (int i = 0; i < 1; i++) {
                Element item = XmlUtil.createElement("apprLinkDocUrls");
                XmlUtil.addChildElement(item, "apprLinkDocName", apprLinkDocName);
                XmlUtil.addChildElement(item, "apprLinkDocUrl", apprLinkDocUrl); // 상세보기 원문
                XmlUtil.addChildElement(items, item);
            }

            Element envelope = XmlUtil.createEnvelope();         // 1. Envelope XML을 생성한다.
            Element body = XmlUtil.createBody();                 // 2. Body XML을 생성한다.
            Element waitResponse = XmlUtil.createWaitResponse(); // 3. Wait response를 생성한다.

            // XML을 조합한다.
            XmlUtil.addChildElement(waitResponse, items);
            XmlUtil.addChildElement(body, waitResponse);
            XmlUtil.addChildElement(envelope, body);

            // 최종적으로 XML Document를 XML String을 변환한다.
            xmlString = XmlUtil.convertString(new Document(envelope));

            Logger.debug("xmlString : " + xmlString);
            return xmlString;

        } catch (Exception e) {
            Logger.error(e);
            // String errorMsg = MobileCodeErrVO.ERROR_MSG_999 + e.getMessage();
            String errorMsg = MobileCodeErrVO.ERROR_MSG_999 + e.getMessage() + "###" + e.getClass();
            // 실패인경우 에러코드:999, 에러 사유를 세팅한다.
            return XmlUtil.createErroXml(itemsName, MobileCodeErrVO.ERROR_CODE_999, errorMsg);
        }
    }

}