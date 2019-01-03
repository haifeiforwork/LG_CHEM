/********************************************************************************/
/*                                                                              																*/
/*   System Name  : MSS                                                         														*/
/*   1Depth Name  : MY HR ����                                                  																*/
/*   2Depth Name  : �ʰ��ٹ� ���Ľ�û                                           																*/
/*   Program Name : �ʰ��ٹ� ���Ľ�û ����                                      															*/
/*   Program ID   : D01OTChangeSV                                               													*/
/*   Description  : �ʰ��ٹ��� ���� �� �� �ֵ��� �ϴ� Class                     													*/
/*   Note         :                                                             																*/
/*   Creation     : 2018-06-12  ������	 [WorkTime52] ��52�ð� �ٹ��ð� ����    											*/
/*   Update       : 									                                          											*/
/*                                                                              																*/
/********************************************************************************/

package servlet.hris.D.D01OT;

import java.util.HashMap;
import java.util.Map;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.ObjectUtils;

import com.common.Utils;
import com.common.constant.Area;
import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.RfcDataHandler;
import com.sns.jdf.sap.RfcHandler;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;

import hris.D.D01OT.D01OTAfterWorkTimeDATA;
import hris.D.D01OT.D01OTData;
import hris.D.D01OT.D01OTRealWorkDATA;
import hris.D.D01OT.rfc.D01OTAFCheckRFC;
import hris.D.D01OT.rfc.D01OTAfterWorkPercheckRFC;
import hris.D.D01OT.rfc.D01OTAfterWorkTimeListRFC;
import hris.D.D01OT.rfc.D01OTRFC;
import hris.D.D01OT.rfc.D01OTRealWrokListRFC;
import hris.D.rfc.D02KongsuHourRFC;
import hris.common.EmpGubunData;
import hris.common.PersonData;
import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalHeader;
import hris.common.approval.ApprovalLineData;
import hris.common.rfc.GetEmpGubunRFC;
import hris.common.rfc.PersonInfoRFC;
import hris.D.D01OT.rfc.D01OTAFRFC;

@SuppressWarnings({ "rawtypes", "serial" })
public class D01OTAfterWorkChangeSV extends ApprovalBaseServlet {

    private String UPMU_TYPE = "44";
    private String UPMU_NAME = "�ʰ��ٹ� ���Ľ�û";

    protected String getUPMU_TYPE() {
        return UPMU_TYPE;
    }

    protected String getUPMU_NAME() {
        return UPMU_NAME;
    }

    protected void performTask(final HttpServletRequest req, final HttpServletResponse res) throws GeneralException {

        try {

            final WebUserData user = WebUtil.getSessionUser(req);
            /************** Start: ������ �б�ó�� **********************************************************/
            if (!user.area.equals(Area.KR)) { 	// �ؿ�ȭ������
                printJspPage(req, res, WebUtil.ServletURL + "hris.D.D01OT.D01OTChangeGlobalSV");
                return;
            }

            /************** END: ������ �б�ó�� *********************************************************/

            String dest = "";

            final Box box = WebUtil.getBox(req);
            final String jobid = box.get("jobid", "first");
            Logger.debug.println(this, "[jobid] = " + jobid + " [user] : " + user.toString());

            //final D01OTRFC rfc = new D01OTRFC();
            final D01OTAFRFC rfc = new D01OTAFRFC();

            String I_APGUB = (String) req.getAttribute("I_APGUB");  // ��� ���������� �Գ�? '1' : ������ ���� , '2' : ������ ���� , '3' : ����Ϸ� ����
            Logger.debug.println(this, "[I_APGUB] = " + I_APGUB);

            final String ainf_seqn = box.get("AINF_SEQN");
            // ���� ������ ���ڵ�..
            rfc.setDetailInput(user.empNo, I_APGUB, ainf_seqn); // ���������
            Vector D01OTData_vt = null;

            D01OTData_vt = rfc.getDetail(ainf_seqn, "");

            final String PERNR = rfc.getApprovalHeader().PERNR;
            final D01OTData firstData = (D01OTData) Utils.indexOf(D01OTData_vt, 0);

            // �븮 ��û �߰�
            PersonInfoRFC numfunc = new PersonInfoRFC();
            final PersonData phonenumdata = (PersonData) numfunc.getPersonInfo(firstData.PERNR);
            req.setAttribute("PersonData", phonenumdata);


            req.setAttribute("committed", "N"); // check already response 2017/1/3 ksc

            final String curdate = DataUtil.getCurrentDate();

            /*************************************************************************************/
            if (jobid.equals("first")) {

                req.setAttribute("jobid", jobid);
                req.setAttribute("D01OTData_vt", D01OTData_vt);
                req.setAttribute("isUpdate", true); // [����]��� ���� ���� <- �����ʿ��� �ݵ�� �ʿ���

                // [WorkTime52]
                // ��� ���� ��ȸ(�繫��:A,C / ������:B,D)
                Map<String, Object> rfcResultData = RfcHandler.execute("ZGHR_RFC_NTM_GET_EMPGUB", new HashMap<String, Object>() {
                    {
                        put("I_PERNR", PERNR);
                    }
                });

                final String EMPGUB = ObjectUtils.toString(getData(rfcResultData, "EXPORT", g.getMessage("MSG.D.D01.0063")).get("E_EMPGUB"));
                final String TPGUB = ObjectUtils.toString(getData(rfcResultData, "EXPORT", g.getMessage("MSG.D.D01.0063")).get("E_TPGUB"));		// A(�繫��-�Ϲ�), B(������-�Ϲ�), C(�繫��-���ñٷ���), D(������-ź�±ٷ���)
                final String I_DATE = firstData.WORK_DATE.replaceAll("[^\\d]", "");
                final String I_VTKEN = firstData.VTKEN;
                final String I_AINF_SEQN = ainf_seqn;

                D01OTRealWrokListRFC realworkfunc = new D01OTRealWrokListRFC();
                D01OTAfterWorkTimeListRFC rfcaf = new D01OTAfterWorkTimeListRFC();

                if (EMPGUB.equals("S")) {
                    final D01OTRealWorkDATA WorkData = realworkfunc.getResult(EMPGUB, PERNR, I_DATE, I_VTKEN, I_AINF_SEQN, "");
                    final D01OTAfterWorkTimeDATA AfterData = rfcaf.getResult("1", PERNR, I_DATE, I_VTKEN, ainf_seqn, curdate, ""); // ó������( 1 =�� , 2 =�����Ƿ�, 3 =����, 4 = ���� )

                    if (realworkfunc.getReturn().isSuccess()) {
                        req.setAttribute("WorkData", WorkData); // ���߿�
                    } else {
                        Logger.debug.println(this, "�Ǳٹ��ð� ��ȸ ����!!");
                    }

                    if (rfcaf.getReturn().isSuccess()) {
                        req.setAttribute("AfterData", AfterData); // ���߿�
                    } else {
                        Logger.debug.println(this, "AF �Ǳٹ��ð� ��ȸ ����!!");
                    }

                    Logger.debug.println(this, "WorkData[�繫��] : " + WorkData.toString());
                    Logger.debug.println(this, "AfterData[�繫�� ���ıٷν�û �Ǳٹ�����] : " + AfterData.toString());

                    req.setAttribute("EMPGUB", EMPGUB);
                    req.setAttribute("TPGUB", TPGUB);
                    req.setAttribute("DATUM", I_DATE);
                }

                Logger.debug.println(this, "[first] DATUM :: " + I_DATE);
                Logger.debug.println(this, "[first] EMPGUB :: " + EMPGUB);
                Logger.debug.println(this, "[first] TPGUB :: " + TPGUB);
                // [WorkTime52]

                detailApporval(req, res, rfc);

                dest = WebUtil.JspURL + "D/D01OT/D01OTAfterWorkBuild_KR.jsp";// "D/D01OT/D01OTChange.jsp";

                /*************************************************************************************/
            } else if (jobid.equals("check")) {
                final D01OTAfterWorkBuildSV sv = new D01OTAfterWorkBuildSV();
                sv.checkCommon(box, PERNR, user, req);
                req.setAttribute("isUpdate", true); // [����]��� ���� ���� <- �����ʿ��� �ݵ�� �ʿ���
                req.setAttribute("jobid", jobid);
                detailApporval(req, res, rfc);
                dest = WebUtil.JspURL + "D/D01OT/D01OTAfterWorkBuild_KR.jsp";

                /*************************************************************************************/
            } else if (jobid.equals("change")) {
                Logger.debug.println(this, "change...");

                // ���� ���� �κ� /
                dest = changeApproval(req, box, D01OTData.class, rfc, new ChangeFunction<D01OTData>() {
                    public String porcess(D01OTData inputData, ApprovalHeader approvalHeader, Vector<ApprovalLineData> approvalLine) throws GeneralException {

                        box.copyToEntity(inputData);
                        inputData.PERNR = PERNR;
                        inputData.ZPERNR = user.empNo;              // ��û�� ���(�븮��û, ���� ��û)
                        inputData.UNAME = user.empNo;              // ��û�� ���(�븮��û, ���� ��û)
                        inputData.AEDTM = DataUtil.getCurrentDate();  // ������(���糯¥)

                        DataUtil.fixNull(inputData);

                        String PRECHECK = new D01OTAfterWorkPercheckRFC().getPRECHECK(PERNR, inputData.WORK_DATE, "").E_PRECHECK;
                        Logger.debug.println(this, "[change] PRECHECK >> " + PRECHECK);

                        String message = checkData(inputData);
                        Logger.debug.println(this, "checkData() After ....message >> [ " + message + " ]");

                        // [CSR ID:2803878] ��û �ʰ��ٹ� ��ûȭ�� 1�� 12�ð� üũ
                        String yymm = DataUtil.getCurrentYear() + DataUtil.getCurrentMonth();
                        Vector submitData_vt = new D02KongsuHourRFC().getOvtmHour(firstData.PERNR, yymm, "M", inputData); // 'C' = ��Ȳ, 'R' = ��û,'M' = ����, 'G' = ����

                        detailApporval(req, res, rfc);

                        req.setAttribute("isUpdate", true); // [����]��� ���� ���� <- �����ʿ��� �ݵ�� �ʿ���

                        // [WorkTime52]��� ���� ��ȸ(�繫��:A,C / ������:B,D)
                        String EMPGUB = "";
                        String TPGUB = "";
                        GetEmpGubunRFC empGubunRFC = new GetEmpGubunRFC();
                        Vector<EmpGubunData> tpInfo = empGubunRFC.getEmpGubunData(PERNR);
                        if (empGubunRFC.getReturn().isSuccess()) {
                            EmpGubunData empGubunData = tpInfo.get(0);
                            EMPGUB = empGubunData.getEMPGUB();
                            TPGUB = empGubunData.getTPGUB();
                        }

                        // [WorkTime52] �Ǳٹ��ð���ȸ
                        D01OTRealWrokListRFC realworkfunc = new D01OTRealWrokListRFC();
                        D01OTAfterWorkTimeListRFC rfcaf = new D01OTAfterWorkTimeListRFC();

                        if (EMPGUB.equals("S")) {
                            final D01OTRealWorkDATA WorkData = realworkfunc.getResult(EMPGUB, PERNR, inputData.WORK_DATE, inputData.VTKEN, inputData.AINF_SEQN,"");
                            final D01OTAfterWorkTimeDATA AfterData = rfcaf.getResult("1", PERNR, inputData.WORK_DATE, inputData.VTKEN, ainf_seqn, curdate, "");

                            if (realworkfunc.getReturn().isSuccess()) {
                                req.setAttribute("WorkData", WorkData);
                            } else {
                                Logger.debug.println(this, "�Ǳٹ��ð� ��ȸ ����!!");
                            }

                            if (rfcaf.getReturn().isSuccess()) {
                                req.setAttribute("AfterData", AfterData);
                            } else {
                                Logger.debug.println(this, "AF �Ǳٹ��ð� ��ȸ ����!!");
                            }
                        }

                        Vector D01OTData_vt = new Vector();
                        D01OTData_vt.addElement(inputData);

                        if (!message.equals("")) { // ����������
                            Logger.debug.println(this, "������������1");

                            req.setAttribute("msg2", message);
                            req.setAttribute("message", message);
                            req.setAttribute("jobid", jobid);
                            req.setAttribute("D01OTData_vt", D01OTData_vt);
                            req.setAttribute("approvalLine", approvalLine); // ����� �������
                            req.setAttribute("committed", "Y");
                            // [WorkTime52]
                            req.setAttribute("EMPGUB", EMPGUB);
                            req.setAttribute("TPGUB", TPGUB);
                            req.setAttribute("DATUM", inputData.WORK_DATE);
                            // [WorkTime52]

                            String url = WebUtil.JspURL + "D/D01OT/D01OTAfterWorkBuild_KR.jsp";

                            printJspPage(req, res, url);

                            return null;

                            // [CSR ID:2803878] ��û �� �ʰ��ٹ� ��û���� alert
                        } else if (!inputData.OVTM12YN.equals("N") || (PRECHECK.equals("N") && inputData.VTKEN.equals("X"))) { // confirm �� message �߰�
                            Logger.debug.println(this, "������������2");
                            Logger.debug.println(this, "Change DATUM : " + inputData.WORK_DATE + "  /   " + EMPGUB);

                            req.setAttribute("jobid", jobid);
                            req.setAttribute("D01OTData_vt", D01OTData_vt);
                            req.setAttribute("submitData_vt", submitData_vt);
                            req.setAttribute("PRECHECK", PRECHECK);
                            req.setAttribute("approvalLine", approvalLine); // ����� �������
                            req.setAttribute("committed", "Y");
                            // [WorkTime52]
                            req.setAttribute("EMPGUB", EMPGUB);
                            req.setAttribute("TPGUB", TPGUB);
                            req.setAttribute("DATUM", inputData.WORK_DATE);
                            // [WorkTime52]

                            String url = WebUtil.JspURL + "D/D01OT/D01OTAfterWorkBuild_KR.jsp";

                            printJspPage(req, res, url);

                            return null;
                        }

                        /*************************************************************************************/
                        // * ���� ��û RFC ȣ�� * /
                        rfc.setChangeInput(user.empNo, UPMU_TYPE, approvalHeader.AINF_SEQN);

                        Logger.debug("-------- AINF_SEQN " + inputData.AINF_SEQN);

                        rfc.change(ainf_seqn, firstData.PERNR, D01OTData_vt, box, req);

                        if (!rfc.getReturn().isSuccess()) {
                            req.setAttribute("msg", rfc.getReturn().MSGTX);   // ���� �޼��� ó�� - �ӽ�
                            return null;
                        }

                        return inputData.AINF_SEQN;
                        // * ������ �ۼ� �κ� �� */
                    }
                });

            } else {
                throw new BusinessException(g.getMessage("MSG.COMMON.0016"));// "���θ��(jobid)�� �ùٸ��� �ʽ��ϴ�.");
            }

            Logger.debug.println(this, "destributed = " + dest);

            if (req.getAttribute("committed").equals("N")) {
                printJspPage(req, res, dest);
            }

        } catch (Exception e) {
            throw new GeneralException(e);
        }
    }

    protected String checkData(D01OTData data) throws GeneralException {

        // RFC : ZGHR_RFC_NTM_AFTOT_AVAIL_CHECK [�ʰ��ٹ� ���� ��û- üũ RFC]
        Logger.debug.println(this, "AF AVAIL CHECK RFC ����");

        D01OTAFCheckRFC AFCheckFunc = new D01OTAFCheckRFC();

        Vector T_RESULT = new Vector();
        T_RESULT.addElement(data);

        // ����
        AFCheckFunc.AFCheck(T_RESULT);

        String message = AFCheckFunc.getReturn().MSGTX;
        if (AFCheckFunc.getReturn().isSuccess()) {
            message = "";
        }

        Logger.debug.println(this, " AF Check chkaddFunc.getReturn().MSGTX >> " + AFCheckFunc.getReturn().MSGTX);
        Logger.debug.println(this, " AF Check MESSAGE >> " + message);

        return message;
    }

    // WorkTime52
    /**
     * RFC ���� ����� ���� data���� EXPORT �Ǵ� TABLES data�� �����Ͽ� ��ȯ
     *
     * @param rfcResultData
     * @param target
     * @param message
     * @return
     * @throws GeneralException
     */
    private Map<String, Object> getData(Map<String, Object> rfcResultData, String target, String message) throws GeneralException {

        if (!RfcDataHandler.isSuccess(rfcResultData)) {
            throw new GeneralException(message);
        }

        return (Map<String, Object>) rfcResultData.get(target);
    }

}