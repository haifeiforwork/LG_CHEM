/*
 * 작성된 날짜: 2005. 1. 28.
*   Update		  :  2017-05-15 eunha [CSR ID:3377091] 중국 인사시스템 반려 시 오류 수정
 */
package servlet.hris;

import com.common.AjaxResultMap;
import com.common.RFCReturnEntity;
import com.common.Utils;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPType;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;
import hris.G.G001Approval.ApprovalDocList;
import hris.G.rfc.ApprovalHeaderRFC;
import hris.common.DraftDocForEloffice;
import hris.common.ElofficInterfaceData;
import hris.common.SendToESB;
import hris.common.WebUserData;
import hris.common.approval.ApprovalHeader;
import hris.common.approval.ApprovalLineData;
import hris.common.approval.ApprovalLineInput;
import hris.common.approval.ApprovalLineRFC;
import org.apache.commons.lang.StringUtils;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Vector;

/**
 * @author 이승희
 */
public class ResetApporvalSV extends EHRBaseServlet {

    /* (비Javadoc)
     * @see com.sns.jdf.servlet.EHRBaseServlet#performTask(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse)
     */
    protected void performTask(HttpServletRequest req, HttpServletResponse res)
            throws GeneralException {

        try {
            req.setAttribute("viewSource", "true");
            Box box = WebUtil.getBox(req);
            WebUserData user = WebUtil.getSessionUser(req);

            String jobid = box.get("jobid", "first");

            String AINF_SEQN = box.get("AINF_SEQN");
            String PERNR = box.get("PERNR", user.empNo);


            ApprovalHeader approvalHeader = null;
            RFCReturnEntity headerReturn = new RFCReturnEntity();
            Vector<ApprovalLineData> approvalLineList = null;
            int nApprovaSize = 0;

            if(StringUtils.isNotBlank(AINF_SEQN)) {
                SAPType sapType = SAPType.LOCAL;
                if ("7".equals(StringUtils.substring(AINF_SEQN, 0, 1))) {
                    sapType = SAPType.GLOBAL;
                }

                /**
                 * 헤더 정보 - 헤더정보는 반드시 존재한다. TimeSheet 는 알 수 없음
                 */
                ApprovalHeaderRFC approvalHeaderRFC = new ApprovalHeaderRFC(sapType);
                approvalHeader = approvalHeaderRFC.getApprovalHeader(AINF_SEQN, PERNR);
                headerReturn = approvalHeaderRFC.getReturn();
                req.setAttribute("approvalHeader", approvalHeader);

                //삭제시는 결재라인 정보 조회 안함
                if(!"delete".equals(jobid)) {
                    /**
                     * 결재라인 정보
                     */
                    ApprovalLineRFC approvalLineRFC = new ApprovalLineRFC(sapType);
                    approvalLineList = approvalLineRFC.getApprovalLine(new ApprovalLineInput(AINF_SEQN, PERNR));
                    nApprovaSize = Utils.getSize(approvalLineList);
                    req.setAttribute("approvalLine", approvalLineList);
                }

            }

            req.setAttribute("jobid", jobid);

            if("save".equals(jobid)) {

                boolean isSend = !"Y".equals(box.get("noSend"));
                if (!headerReturn.isSuccess() || "".equals(StringUtils.remove(approvalHeader.AINF_SEQN, "0"))) {
                    moveMsgPage(req, res, "결재정보가 없습니다.", "history.back();");
                    return;
                }

                /**
                 * Eloffice를 위해 결재 상태 정보를 읽어온다
                 * 1. 승인자 정보
                 * 2. 결재자 정보
                 *
                 * process
                 * 1. Eloffice 에 전체 취소 요청을 한다
                 *          Main Staus : R , Modify : D
                 2. 승인자 -> 1차 결재자 데이타추가
                 3. 1차 결재 이후 처리 process
                 */

                SendToESB esb = new SendToESB();
                DraftDocForEloffice ddfe = new DraftDocForEloffice();

                /**
                 * 기존 데이타 삭제
                 */
                ApprovalLineData firstLineData = Utils.indexOf(approvalLineList, 0, ApprovalLineData.class);
                ElofficInterfaceData removeData = ddfe.makeDocForRemove(approvalHeader.AINF_SEQN, user.SServer, approvalHeader.getUPMU_NAME()
                        , approvalHeader.PERNR, firstLineData.APPU_NUMB);

                String returnMsg = "";  /* 결과 메세지 */

                if(isSend) {
                    returnMsg = esb.process(Utils.asVector(removeData));

                /* 삭제 실패시 메세지 처리 */
                    if (StringUtils.isNotBlank(returnMsg)) {
                        moveMsgPage(req, res, returnMsg, "history.back();");
                        return;
                    }


                    /* 5 초후 실행 */
                    Logger.debug("----------------- sleep start");
                    Thread.sleep(2000);
                    Logger.debug("----------------- sleep end");
                }
                /*Eloffice 전송될 데이타 생성*/
                Vector<ElofficInterfaceData> sendDataList = new Vector<ElofficInterfaceData>();

                /* 신청 데이타 */
                ElofficInterfaceData eof = ddfe.makeDocContents(AINF_SEQN, user.SServer, approvalHeader.getUPMU_NAME());
                eof.REQ_DATE = DataUtil.removeSeparate(approvalHeader.RQDAT) + StringUtils.substring(DataUtil.removeSeparate(approvalHeader.RQTIM), 0, 4);  /*신청일 셋팅*/
                eof.MAIN_STATUS = "R";
                eof.SUB_STATUS = "신청";
                eof.R_EMP_NO = approvalHeader.getPERNR();   /* 요청자 */
                eof.A_EMP_NO = firstLineData.APPU_NUMB;     /* 대상자 */
                Vector vcElofficInterfaceData = new Vector();
                vcElofficInterfaceData.add(eof);

                /**
                 * 결재라인 생성
                 */
                ApprovalLineData approvalCurrent;

                for (int n = 0; n < nApprovaSize; n++) {
                    approvalCurrent = approvalLineList.get(n);

                    boolean isFinish = n == (nApprovaSize - 1);

                     /* 결재 상태가 비어잇을 경우 중지 */
                    if (StringUtils.isBlank(approvalCurrent.APPR_STAT)) break;

                    if ("A".equals(approvalCurrent.APPR_STAT)) {

                        eof = ddfe.makeDocContents(approvalHeader.AINF_SEQN, user.SServer, approvalHeader.getUPMU_NAME());

                        if (isFinish) {
                            eof.MAIN_STATUS = "F";
                            eof.SUB_STATUS = "완료";
                        } else {
                            eof.MAIN_STATUS = "M";
                            eof.SUB_STATUS = "진행중";
                        }

                        //요청자
                        eof.R_EMP_NO = approvalCurrent.APPU_NUMB;
                        if(!isFinish) {
                            eof.A_EMP_NO = approvalLineList.get(n + 1).APPU_NUMB;   //대상자
                        }

                    } else {
                        /* 최종 결재 반려 test 필요 .... */
                        //[CSR ID:3366993] 자동 메일 발송 관련 제목 수정요청의 건
                    	//if (approvalCurrent.APPU_TYPE.equals("02") && Integer.parseInt(approvalCurrent.APPR_SEQN) > 1) {
                    	if (g.getSapType().isLocal() && approvalCurrent.APPU_TYPE.equals("02") && Integer.parseInt(approvalCurrent.APPR_SEQN) > 1) {
                            eof = ddfe.makeDocForMangerReject(approvalHeader.AINF_SEQN, user.SServer, approvalHeader.getUPMU_NAME(), approvalLineList);
                        } else {

                            eof = ddfe.init(AINF_SEQN, user.SServer, approvalHeader.getUPMU_NAME());

                            eof.MAIN_STATUS = "F" ;
                            eof.MODIFY = "" ;
                            eof.SUB_STATUS = "반려" ;

                            eof.R_EMP_NO = approvalCurrent.APPU_NUMB;   //반려일 경우 요청자

                            /*eof = ddfe.makeDocForReject(approvalHeader.AINF_SEQN, user.SServer, approvalHeader.getUPMU_NAME(), approvalHeader.PERNR, approvers);*/
                        } // end if
                    } // end if

                    eof.REQ_DATE = DataUtil.removeSeparate(approvalCurrent.APPR_DATE) + StringUtils.substring(DataUtil.removeSeparate(approvalCurrent.APPR_TIME), 0, 4);

                    vcElofficInterfaceData.add(eof);
                }
                if(isSend) {
                    returnMsg = esb.process(vcElofficInterfaceData);    /* 전송 */
                }

                if("json".equals(box.get("requestType"))) {
                    AjaxResultMap resultMap = new AjaxResultMap();
                    resultMap.put("approvalHeader", approvalHeader);
                    resultMap.put("approvalLine", approvalLineList);  //필요시
                    resultMap.put("message", returnMsg);
                    resultMap.put("isSuccess", StringUtils.isBlank(returnMsg));

                    resultMap.writeJson(res);

                    return;
                } else {
                    req.setAttribute("jobid", jobid);
                    req.setAttribute("message", returnMsg);
                    req.setAttribute("isSuccess", StringUtils.isBlank(returnMsg));
                    req.setAttribute("interfaceDataList", vcElofficInterfaceData);
                }
            } else if("delete".equals(jobid)) {

                SendToESB esb = new SendToESB();
                DraftDocForEloffice ddfe = new DraftDocForEloffice();

                /**
                 * 기존 데이타 삭제
                 */
                ElofficInterfaceData removeData = ddfe.makeDocForRemove(approvalHeader.AINF_SEQN, user.SServer, approvalHeader.getUPMU_NAME()
                        , approvalHeader.PERNR, approvalHeader.PERNR);

                String returnMsg = "";  /* 결과 메세지 */

                returnMsg = esb.process(Utils.asVector(removeData));

                req.setAttribute("message", returnMsg);
                req.setAttribute("isSuccess", StringUtils.isBlank(returnMsg));
            }

            printJspPage(req, res, WebUtil.JspURL + "resetApproval.jsp");
        }  catch (Exception e) {
            Logger.error(e);
            throw new GeneralException(e);
        }finally {

        }
    }

    private ApprovalDocList findApproval(Vector<ApprovalDocList> vcApprovalDocList, String AINF_SEQN ) {

        for(ApprovalDocList row : vcApprovalDocList) {
            if(StringUtils.equals(row.AINF_SEQN, AINF_SEQN)) return row;
        }

        return null;
    }
}
