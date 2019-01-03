/*
 * �ۼ��� ��¥: 2005. 1. 28.
*   Update		  :  2017-05-15 eunha [CSR ID:3377091] �߱� �λ�ý��� �ݷ� �� ���� ����
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
 * @author �̽���
 */
public class ResetApporvalSV extends EHRBaseServlet {

    /* (��Javadoc)
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
                 * ��� ���� - ��������� �ݵ�� �����Ѵ�. TimeSheet �� �� �� ����
                 */
                ApprovalHeaderRFC approvalHeaderRFC = new ApprovalHeaderRFC(sapType);
                approvalHeader = approvalHeaderRFC.getApprovalHeader(AINF_SEQN, PERNR);
                headerReturn = approvalHeaderRFC.getReturn();
                req.setAttribute("approvalHeader", approvalHeader);

                //�����ô� ������� ���� ��ȸ ����
                if(!"delete".equals(jobid)) {
                    /**
                     * ������� ����
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
                    moveMsgPage(req, res, "���������� �����ϴ�.", "history.back();");
                    return;
                }

                /**
                 * Eloffice�� ���� ���� ���� ������ �о�´�
                 * 1. ������ ����
                 * 2. ������ ����
                 *
                 * process
                 * 1. Eloffice �� ��ü ��� ��û�� �Ѵ�
                 *          Main Staus : R , Modify : D
                 2. ������ -> 1�� ������ ����Ÿ�߰�
                 3. 1�� ���� ���� ó�� process
                 */

                SendToESB esb = new SendToESB();
                DraftDocForEloffice ddfe = new DraftDocForEloffice();

                /**
                 * ���� ����Ÿ ����
                 */
                ApprovalLineData firstLineData = Utils.indexOf(approvalLineList, 0, ApprovalLineData.class);
                ElofficInterfaceData removeData = ddfe.makeDocForRemove(approvalHeader.AINF_SEQN, user.SServer, approvalHeader.getUPMU_NAME()
                        , approvalHeader.PERNR, firstLineData.APPU_NUMB);

                String returnMsg = "";  /* ��� �޼��� */

                if(isSend) {
                    returnMsg = esb.process(Utils.asVector(removeData));

                /* ���� ���н� �޼��� ó�� */
                    if (StringUtils.isNotBlank(returnMsg)) {
                        moveMsgPage(req, res, returnMsg, "history.back();");
                        return;
                    }


                    /* 5 ���� ���� */
                    Logger.debug("----------------- sleep start");
                    Thread.sleep(2000);
                    Logger.debug("----------------- sleep end");
                }
                /*Eloffice ���۵� ����Ÿ ����*/
                Vector<ElofficInterfaceData> sendDataList = new Vector<ElofficInterfaceData>();

                /* ��û ����Ÿ */
                ElofficInterfaceData eof = ddfe.makeDocContents(AINF_SEQN, user.SServer, approvalHeader.getUPMU_NAME());
                eof.REQ_DATE = DataUtil.removeSeparate(approvalHeader.RQDAT) + StringUtils.substring(DataUtil.removeSeparate(approvalHeader.RQTIM), 0, 4);  /*��û�� ����*/
                eof.MAIN_STATUS = "R";
                eof.SUB_STATUS = "��û";
                eof.R_EMP_NO = approvalHeader.getPERNR();   /* ��û�� */
                eof.A_EMP_NO = firstLineData.APPU_NUMB;     /* ����� */
                Vector vcElofficInterfaceData = new Vector();
                vcElofficInterfaceData.add(eof);

                /**
                 * ������� ����
                 */
                ApprovalLineData approvalCurrent;

                for (int n = 0; n < nApprovaSize; n++) {
                    approvalCurrent = approvalLineList.get(n);

                    boolean isFinish = n == (nApprovaSize - 1);

                     /* ���� ���°� ������� ��� ���� */
                    if (StringUtils.isBlank(approvalCurrent.APPR_STAT)) break;

                    if ("A".equals(approvalCurrent.APPR_STAT)) {

                        eof = ddfe.makeDocContents(approvalHeader.AINF_SEQN, user.SServer, approvalHeader.getUPMU_NAME());

                        if (isFinish) {
                            eof.MAIN_STATUS = "F";
                            eof.SUB_STATUS = "�Ϸ�";
                        } else {
                            eof.MAIN_STATUS = "M";
                            eof.SUB_STATUS = "������";
                        }

                        //��û��
                        eof.R_EMP_NO = approvalCurrent.APPU_NUMB;
                        if(!isFinish) {
                            eof.A_EMP_NO = approvalLineList.get(n + 1).APPU_NUMB;   //�����
                        }

                    } else {
                        /* ���� ���� �ݷ� test �ʿ� .... */
                        //[CSR ID:3366993] �ڵ� ���� �߼� ���� ���� ������û�� ��
                    	//if (approvalCurrent.APPU_TYPE.equals("02") && Integer.parseInt(approvalCurrent.APPR_SEQN) > 1) {
                    	if (g.getSapType().isLocal() && approvalCurrent.APPU_TYPE.equals("02") && Integer.parseInt(approvalCurrent.APPR_SEQN) > 1) {
                            eof = ddfe.makeDocForMangerReject(approvalHeader.AINF_SEQN, user.SServer, approvalHeader.getUPMU_NAME(), approvalLineList);
                        } else {

                            eof = ddfe.init(AINF_SEQN, user.SServer, approvalHeader.getUPMU_NAME());

                            eof.MAIN_STATUS = "F" ;
                            eof.MODIFY = "" ;
                            eof.SUB_STATUS = "�ݷ�" ;

                            eof.R_EMP_NO = approvalCurrent.APPU_NUMB;   //�ݷ��� ��� ��û��

                            /*eof = ddfe.makeDocForReject(approvalHeader.AINF_SEQN, user.SServer, approvalHeader.getUPMU_NAME(), approvalHeader.PERNR, approvers);*/
                        } // end if
                    } // end if

                    eof.REQ_DATE = DataUtil.removeSeparate(approvalCurrent.APPR_DATE) + StringUtils.substring(DataUtil.removeSeparate(approvalCurrent.APPR_TIME), 0, 4);

                    vcElofficInterfaceData.add(eof);
                }
                if(isSend) {
                    returnMsg = esb.process(vcElofficInterfaceData);    /* ���� */
                }

                if("json".equals(box.get("requestType"))) {
                    AjaxResultMap resultMap = new AjaxResultMap();
                    resultMap.put("approvalHeader", approvalHeader);
                    resultMap.put("approvalLine", approvalLineList);  //�ʿ��
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
                 * ���� ����Ÿ ����
                 */
                ElofficInterfaceData removeData = ddfe.makeDocForRemove(approvalHeader.AINF_SEQN, user.SServer, approvalHeader.getUPMU_NAME()
                        , approvalHeader.PERNR, approvalHeader.PERNR);

                String returnMsg = "";  /* ��� �޼��� */

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
