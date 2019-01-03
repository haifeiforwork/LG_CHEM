/********************************************************************************/
/*                                                                              */
/*   System Name      : MSS                                                     */
/*   1Depth Name      : MY HR ����                                              */
/*   2Depth Name      : �ʰ��ٹ�  ���Ľ�û                                      */
/*   Program Name     : �ʰ��ٹ�  ���Ľ�û                                      */
/*   Program ID       : D01OTAfterWprlBuildSV                                   */
/*   Description      : �ʰ��ٹ�(OT/Ư��)��û�� �ϴ� Class                      */
/*   Note             :                                                         */
/*   Creation         : 2018-06-12  ������ [worktime52 PJT]                     */
/*   Update           :                                                         */
/*                                                                              */
/********************************************************************************/
package servlet.hris.D.D01OT;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.ObjectUtils;
import org.apache.commons.lang.StringUtils;

import com.common.AjaxResultMap;
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
import hris.D.D01OT.rfc.D01OTAFRFC;
import hris.D.D01OT.rfc.D01OTAfterWorkPercheckRFC;
import hris.D.D01OT.rfc.D01OTAfterWorkTimeListRFC;
import hris.D.D01OT.rfc.D01OTRealWrokListRFC;
import hris.D.D03Vocation.rfc.D03ShiftCheckRFC;
import hris.D.rfc.D02KongsuHourRFC;
import hris.D.rfc.D16OTHDDupCheckRFC2;
import hris.common.EmpGubunData;
import hris.common.PersonData;
import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalLineData;
import hris.common.rfc.GetEmpGubunRFC;
import hris.common.rfc.PersonInfoRFC;

@SuppressWarnings({ "rawtypes", "serial" })
public class D01OTAfterWorkBuildSV extends ApprovalBaseServlet {

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
            final Box box = WebUtil.getBox(req);

            /************** Start: ������ �б�ó�� **********************************************************/
            if (!user.area.equals(Area.KR)) {     // �ؿ�ȭ������
                printJspPage(req, res, WebUtil.ServletURL + "hris.D.D01OT.D01OTBuildGlobalSV");
                return;
            }
            /************** END: ������ �б�ó�� **********************************************************/

            String dest = "";
            String jobid = box.get("jobid", "first");
            boolean isUpdate = box.getBoolean("isUpdate");

            // WorkTime52 Start
            String GTYPE = "";
            String EMPGUB = "";
            String TPGUB = "";
            // WorkTime52 End

            Logger.debug.println(this, "[isUpdate] = " + isUpdate);
            Logger.debug.println(this, "[jobid] = " + jobid + " [user] : " + user.toString());

            final String PERNR = getPERNR(box, user); // ��û����� ���

            // �븮 ��û �߰�
            final PersonData phonenumdata = new PersonInfoRFC().getPersonInfo(PERNR);
            req.setAttribute("PersonData", phonenumdata);
            req.setAttribute("isUpdate", isUpdate); // [����]��� ���� ���� <- �����ʿ��� �ݵ�� �ʿ���
            req.setAttribute("PERNR", PERNR);
            req.setAttribute("committed", "N");     // check already response 2017/1/3 ksc

            final String curdate = DataUtil.getCurrentDate();

            /*************************************************************************************/
            if (jobid.equals("first")) {

                // �������, ���� ��� ���� ��ȸ
                getApprovalInfo(req, PERNR);    // <-- �ݵ�� �߰�

                Vector D01OTData_vt = new Vector();
                D01OTData data = new D01OTData();

                box.copyToEntity(data);
                data.PERNR = PERNR;
                DataUtil.fixNull(data);

                D01OTData_vt.addElement(data);  // ������ Ŭ���̾�Ʈ�� �ǵ�����.
                req.setAttribute("D01OTData_vt", D01OTData_vt);

                req.setAttribute("jobid", jobid);

                /*************************************************************************************/

                // ��� ���� ��ȸ(�繫��:S / ������:H) => [���� :2018-06-07 : A(�繫��-�Ϲ�), B(������-�Ϲ�), C(�繫��-���ñٷ���), D(������-ź�±ٷ���)
                GetEmpGubunRFC empGubunRFC = new GetEmpGubunRFC();
                Vector<EmpGubunData> tpInfo = empGubunRFC.getEmpGubunData(PERNR);
                if (empGubunRFC.getReturn().isSuccess()) EMPGUB = tpInfo.get(0).getEMPGUB();
                if (empGubunRFC.getReturn().isSuccess()) TPGUB = tpInfo.get(0).getTPGUB();

                final String I_DATE = (req.getParameter("DATUM") == null || req.getParameter("DATUM").equals("")) ? curdate : req.getParameter("DATUM");
                final String I_VTKEN = ObjectUtils.toString(req.getAttribute("VTKEN"));

                // �Ǳٹ��ð� ��ȸ[info Table]
                D01OTRealWrokListRFC realworkfunc = new D01OTRealWrokListRFC();
                // �Ǳٹ�/��û����...
                D01OTAfterWorkTimeListRFC rfcaf = new D01OTAfterWorkTimeListRFC();
                String MODE = "";
                GTYPE = "1";    // ó������( 1 =�� , 2 =�����Ƿ�, 3 =����, 4 = ���� )

                if (EMPGUB.equals("S")) {    // �繫��-�Ϲ�
                    MODE = "";
                    final D01OTRealWorkDATA WorkData = realworkfunc.getResult(EMPGUB, PERNR, I_DATE, I_VTKEN, data.AINF_SEQN, MODE);
                    final D01OTAfterWorkTimeDATA AfterData = rfcaf.getResult(GTYPE, PERNR, I_DATE, I_VTKEN, data.AINF_SEQN, curdate, "");

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

                Logger.debug.println(this, "[first] EMPGUB        : " + EMPGUB);
                Logger.debug.println(this, "[first] TGUB         : " + TPGUB);
                Logger.debug.println(this, "[first] MODE        : " + MODE);
                Logger.debug.println(this, "[first] DATUM        : " + I_DATE);

                dest = WebUtil.JspURL + "D/D01OT/D01OTAfterWorkBuild_KR.jsp";

                /*************************************************************************************/
            } else if (jobid.equals("ajax")) {

                String I_TPGUB = "";
                GetEmpGubunRFC empGubunRFC = new GetEmpGubunRFC();
                Vector<EmpGubunData> tpInfo = empGubunRFC.getEmpGubunData(PERNR);

                // �Ǳٹ��ð� ��ȸ
                if (empGubunRFC.getReturn().isSuccess()) {
                    I_TPGUB = tpInfo.get(0).getTPGUB();
                }

                final String I_EMPGUB = req.getParameter("I_EMPGUB");
                final String I_GTYPE = StringUtils.defaultIfEmpty(req.getParameter("GTYPE"), "1"); // ó������( 1 =�� , 2 =�����Ƿ�, 3 =����, 4 = ���� )
                final String I_DATUM = StringUtils.defaultIfEmpty(req.getParameter("DATUM"), curdate);
                final String AINF_SEQN = req.getParameter("AINF_SEQN");

                Logger.debug.println(this, "ajax-DATE : " + I_DATUM);

                // �Ǳٷνð� ��ȸ - info
                D01OTRealWrokListRFC realworkfunc01 = new D01OTRealWrokListRFC();
                // �Ǳٹ�/��û���ɽð�.
                final D01OTAfterWorkTimeListRFC rfcaf = new D01OTAfterWorkTimeListRFC();

                if (I_EMPGUB.equals("S")) { // �繫��
                    final D01OTRealWorkDATA worklistdata = realworkfunc01.getResult(I_EMPGUB, PERNR, I_DATUM, "", AINF_SEQN, "");
                    final D01OTAfterWorkTimeDATA AfterData = rfcaf.getResult(I_GTYPE, PERNR, I_DATUM, "", AINF_SEQN, curdate, "");

                    Logger.debug.println(this, "worklistdata[�繫��-ajax] : " + worklistdata.toString());
                    Logger.debug.println(this, "AfterData[�繫��-ajax] : " + AfterData.toString());

                    // ����/����/������ ��ȸ
                    Map<String, Object> rfcResultData = RfcHandler.execute("ZGHR_RFC_NTM_WORKDAY_LIST", new HashMap<String, Object>() {
                        {
                            put("I_EMPGUB", I_EMPGUB);
                            put("I_PERNR", PERNR);
                            put("I_BEGDA", I_DATUM);
                            put("I_ENDDA", I_DATUM);
                        }
                    });

                    req.setAttribute("EMPGUB", I_EMPGUB);
                    req.setAttribute("TPGUB", I_TPGUB);
                    req.setAttribute("DATUM", I_DATUM);

                    List HolidayList = (List) getData(rfcResultData, "TABLES", g.getMessage("MSG.D.D01.0063")).get("T_WLIST");
                    final String Holidaycheck01 = (String) ((Map) HolidayList.get(0)).get("HOLID");    // ������ X
                    final String Holidaycheck02 = (String) ((Map) HolidayList.get(0)).get("SOLLZ");    // ��ٹ��� 0

                    // �ϱ���üũ
                    D03ShiftCheckRFC func_shift = new D03ShiftCheckRFC();
                    final String shiftCheck = func_shift.check(PERNR, I_DATUM);    // D:�ϱ���,1:��ġ������
                    Logger.debug.println(this, "[ajax] shiftCheck ::  " + shiftCheck);

                    new AjaxResultMap().addResult(new HashMap<String, Object>() {
                        {
                            put("MSGTY", rfcaf.getReturn().MSGTY);
                            put("MSGTX", rfcaf.getReturn().MSGTX);

                            // �ٹ��ð� ��Ȳǥ
                            put("E_BASTM", worklistdata.BASTM);    // �⺻�ٹ�
                            put("E_MAXTM", worklistdata.MAXTM);    // �����ִ��ѵ�
                            put("E_PWDWK", worklistdata.PWDWK);    // ���ϱٷνð�-�����Է�
                            put("E_PWEWK", worklistdata.PWEWK);    // ���ϱٷνð�-ȸ������
                            put("E_CWDWK", worklistdata.CWDWK);    // �ָ����ϱٹ��ð�-����
                            put("E_CWEWK", worklistdata.CWEWK);    // �ָ����ϱٹ��ð�-ȸ������
                            put("E_PWTOT", worklistdata.PWTOT);    // ��-����
                            put("E_CWTOT", worklistdata.CWTOT);    // ��-ȸ��
                            put("E_RWKTM", worklistdata.RWKTM);    // �Ǳٹ��ð�

                            // �Ǳٹ��ð�
                            put("E_CSTDAZ", AfterData.CSTDAZ);        // ����
                            put("E_CAREWK", AfterData.CAREWK);        // �����簳
                            put("E_CTOTAL", AfterData.CTOTAL);        // �հ�

                            // ���Ľ�û���ɽð�
                            put("E_CRQPST", AfterData.CRQPST);

                            // ��û����
                            put("E_NRFLGG", AfterData.NRFLGG);        // �����ʰ� ��û���� flag
                            put("E_R01FLG", AfterData.R01FLG);        // �����簳1 ��û���� flag
                            put("E_R02FLG", AfterData.R02FLG);        // �����簳2 ��û���� flag

                            // �����ʰ� ��û���ɽ�
                            put("E_STDAZ", AfterData.STDAZ);          // �ٹ��ð�
                            put("E_NRQPST", AfterData.NRQPST);        // �ٹ��ð� ��û���ɽð�
                            put("E_CPDABS", AfterData.CPDABS);        // �ް�/��ٹ��ð� Text
                            put("E_PDABS", AfterData.PDABS);          // �ް�/��ٹ��ð�

                            // �����簳1 �Ǵ� �����簳2 ��û���ɽ�
                            put("E_AREWK01", AfterData.AREWK01);      // �����簳�ð�1
                            put("E_AREWK02", AfterData.AREWK02);      // �����簳�ð�2
                            put("E_RRQPST", AfterData.RRQPST);        // �����簳�ð� ��û���ɽð�

                            // �����ʰ� ���ý�
                            put("E_BEGUZ", AfterData.BEGUZ);          // �ð� - ����
                            put("E_ENDUZ", AfterData.ENDUZ);          // �ð� - ����
                            // �����簳1 ���ý�
                            put("E_ABEGUZ01", AfterData.ABEGUZ01);    // �����簳�ð�1 - ����
                            put("E_AENDUZ01", AfterData.AENDUZ01);    // �����簳�ð�1 - ����
                            // �����簳2 ���ý�
                            put("E_ABEGUZ02", AfterData.ABEGUZ02);    // �����簳�ð�2 - ����
                            put("E_AENDUZ02", AfterData.AENDUZ02);    // �����簳�ð�2 - ����

                            put("E_HOLID", Holidaycheck01);        // ������
                            put("E_SOLLZ", Holidaycheck02);        // ��ٹ���
                            put("E_SHIFT", shiftCheck);            // �ϱ���/4��3����

                        }
                    }).writeJson(res);
                }

                return;

                /*************************************************************************************/
            } else if (jobid.equals("check")) {
                checkCommon(box, PERNR, user, req);
                req.setAttribute("jobid", jobid);

                // ��� ���� ��ȸ
                // Map<String, Object> rfcResultData = RfcHandler.execute("ZGHR_RFC_NTM_GET_EMPGUB", new HashMap<String, Object>() {
                // {
                // put("I_PERNR" , PERNR);
                // }
                // });
                // final String EMPGUB = ObjectUtils.toString(getData(rfcResultData, "EXPORT", g.getMessage("MSG.D.D01.0063")).get("E_EMPGUB")); //(�繫��:S / ������:H)
                // final String TPGUB = ObjectUtils.toString(getData(rfcResultData, "EXPORT", g.getMessage("MSG.D.D01.0063")).get("E_TPGUB")); //A(�繫��-�Ϲ�), B(������-�Ϲ�), C(�繫��-���ñٷ���), D(������-ź�±ٷ���)

                GetEmpGubunRFC empGubunRFC = new GetEmpGubunRFC();
                Vector<EmpGubunData> tpInfo = empGubunRFC.getEmpGubunData(PERNR);
                if (empGubunRFC.getReturn().isSuccess())
                    EMPGUB = tpInfo.get(0).getEMPGUB();
                if (empGubunRFC.getReturn().isSuccess())
                    TPGUB = tpInfo.get(0).getTPGUB();

                final String I_DATE = ObjectUtils.toString(req.getAttribute("WORK_DATE"));    // req.getParameter("DATUM");
                final String I_VTKEN = ObjectUtils.toString(req.getAttribute("VTKEN"));
                final String I_AINF_SEQN = ObjectUtils.toString(req.getAttribute("AINF_SEQN"));

                Logger.debug.println(this, "EMPGUB >> " + EMPGUB);
                Logger.debug.println(this, "TPGUB >> " + TPGUB);
                Logger.debug.println(this, "I_DATE >> " + I_DATE);

                D01OTRealWrokListRFC realworkfunc = new D01OTRealWrokListRFC();

                if (EMPGUB.equals("S")) {    // �繫��
                    String MODE = "";

                    final D01OTRealWorkDATA WorkData = realworkfunc.getResult(EMPGUB, PERNR, I_DATE, I_VTKEN, I_AINF_SEQN, MODE);
                    if (realworkfunc.getReturn().isSuccess()) {
                        req.setAttribute("WorkData", WorkData); // ���߿�
                    } else {
                        req.setAttribute("WorkData", "");
                        Logger.debug.println(this, "�Ǳٹ��ð� ��ȸ ����!!");
                    }
                }

                req.setAttribute("DATUM", I_DATE);
                req.setAttribute("EMPGUB", EMPGUB);
                req.setAttribute("TPGUB", TPGUB);

                dest = WebUtil.JspURL + "D/D01OT/D01OTAfterWorkBuild_KR.jsp";

                /*************************************************************************************/
            } else if (jobid.equals("create")) {    // �����Ƿ�
                // @����༺ ������ ������ ���� üũ 2015-08-25-------------------------------------------------------

                dest = requestApproval(req, box, D01OTData.class, new RequestFunction<D01OTData>() {
                    public String porcess(D01OTData inputData, Vector<ApprovalLineData> approvalLine) throws GeneralException {

                        box.copyToEntity(inputData);
                        inputData.PERNR = PERNR;
                        inputData.ZPERNR = user.empNo;               // ��û�� ���(�븮��û, ���� ��û)
                        inputData.UNAME = user.empNo;                // ��û�� ���(�븮��û, ���� ��û)
                        inputData.AEDTM = curdate; // ������(���糯¥)

                        DataUtil.fixNull(inputData);

                        String PRECHECK = new D01OTAfterWorkPercheckRFC().getPRECHECK(PERNR, inputData.WORK_DATE, "").E_PRECHECK;
                        Logger.debug.println(this, "[create] PRECHECK >> " + PRECHECK);

                        /* üũ ���� �ʿ��� ��� */
                        String message = checkData(inputData);
                        Logger.debug.println(this, "checkData() After ....message >> [ " + message + " ]");

                        // [WorkTime52] START---------------------------------------------------------------------
                        // [CSR ID:2803878] ��û �ʰ��ٹ� ��ûȭ�� 1�� 12�ð� üũ
                        String yymm = DataUtil.getCurrentYear() + DataUtil.getCurrentMonth();
                        Vector submitData_vt = new D02KongsuHourRFC().getOvtmHour(PERNR, yymm, "R", inputData); // 'C' = ��Ȳ, 'R' = ��û,'M' = ����, 'G' = ����

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
                            String MODE = "";
                            final D01OTRealWorkDATA WorkData = realworkfunc.getResult(EMPGUB, PERNR, inputData.WORK_DATE, inputData.VTKEN, inputData.AINF_SEQN, MODE);
                            final D01OTAfterWorkTimeDATA AfterData = rfcaf.getResult("2", PERNR, inputData.WORK_DATE, "", "", curdate, "");

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

                        // �޼����� �ִ°��
                        if (!message.equals("")) {

                            Logger.debug.println(this, "[AF]������������:�޼����� �ִ°��");
                            Logger.debug.println(this, "[AF]������������:�޼����� �ִ°�� message : " + message);
                            Logger.debug.println(this, "[AF]������������:EMPGUB : " + EMPGUB);
                            Logger.debug.println(this, "[AF]������������:DATUM  : " + inputData.WORK_DATE);

                            req.setAttribute("msg2", message);
                            req.setAttribute("message", message);
                            req.setAttribute("D01OTData_vt", D01OTData_vt);
                            req.setAttribute("submitData_vt", submitData_vt);
                            getApprovalInfo(req, PERNR);                            // <-- �ݵ�� �߰�
                            req.setAttribute("approvalLine", approvalLine);     // ����� �������
                            req.setAttribute("committed", "Y");                     // ���ߺб�(������������)�� �������� �Ӽ��߰�

                            req.setAttribute("EMPGUB", EMPGUB);
                            req.setAttribute("TPGUB", TPGUB);
                            req.setAttribute("DATUM", inputData.WORK_DATE);

                            printJspPage(req, res, WebUtil.JspURL + "D/D01OT/D01OTAfterWorkBuild_KR.jsp");

                            return null;// WebUtil.JspURL+"D/D01OT/D01OTBuild_KR.jsp";

                            // [CSR ID:2803878] ��û �� �ʰ��ٹ� ��û���� alert ## ��Ȳ�ȳ��޽����� Ȯ���ϸ� ������.(KSC)
                        } else if (!inputData.OVTM12YN.equals("N") || (PRECHECK.equals("N") && inputData.VTKEN.equals("X"))) { // confirm �� message �߰�

                            Logger.debug.println(this, "[AF]������������:��û���� Alert ");
                            Logger.debug.println(this, "[AF]������������:��û���� Alert : message : " + message);

                            // �Ǳٹ��ð� ��ȸ
                            String MODE = "";

                            if (EMPGUB.equals("S")) {    // �繫��
                                MODE = "";
                                final D01OTRealWorkDATA WorkData = realworkfunc.getResult(EMPGUB, PERNR, inputData.WORK_DATE, inputData.VTKEN, inputData.AINF_SEQN, MODE);

                                if (realworkfunc.getReturn().isSuccess()) {
                                    req.setAttribute("WorkData", WorkData); // ���߿�
                                } else {
                                    // req.setAttribute("WorkData" , "" );
                                    Logger.debug.println(this, "�Ǳٹ��ð� ��ȸ ����!!");
                                }

                            }

                            req.setAttribute("D01OTData_vt", D01OTData_vt);
                            req.setAttribute("submitData_vt", submitData_vt);
                            req.setAttribute("PRECHECK", PRECHECK);
                            getApprovalInfo(req, PERNR);    // <-- �ݵ�� �߰�
                            req.setAttribute("approvalLine", approvalLine); // ����� �������
                            req.setAttribute("committed", "Y");

                            req.setAttribute("EMPGUB", EMPGUB);
                            req.setAttribute("TPGUB", TPGUB);
                            req.setAttribute("DATUM", inputData.WORK_DATE);

                            printJspPage(req, res, WebUtil.JspURL + "D/D01OT/D01OTAfterWorkBuild_KR.jsp");

                            return null;

                        } else { // ����
                            D01OTAFRFC rfc = new D01OTAFRFC();
                            rfc.setRequestInput(user.empNo, UPMU_TYPE);
                            String ainf_seqn = rfc.build(PERNR, D01OTData_vt, box, req);

                            Logger.debug.println(this, "�����ȣ  ainf_seqn=" + ainf_seqn.toString());

                            if (!rfc.getReturn().isSuccess() || ainf_seqn == null) {
                                throw new GeneralException(rfc.getReturn().MSGTX);
                            }

                            return ainf_seqn;
                        }
                        /* ��û �� msg ó�� �� �̵� ������ ���� */

                        /* ������ �ۼ� �κ� �� */
                    }
                });

                // @����༺ ������ ������ ���� üũ ��-------------------------------------------------------

            } else {
                throw new BusinessException(g.getMessage("MSG.COMMON.0016")); // ���θ��(jobid)�� �ùٸ��� �ʽ��ϴ�.
            }

            Logger.debug.println(this, " destributed = " + dest);

            if (req.getAttribute("committed").equals("N")) {
                printJspPage(req, res, dest);
            }

        } catch (Exception e) {
            throw new GeneralException(e);
        }
    }

    /***************************************************************************************
     * jobid = check ��ƾ; D01TOchange������ ȣ��
     ***************************************************************************************/

    void checkCommon(Box box, String PERNR, WebUserData user, HttpServletRequest req) throws GeneralException {

        Vector D01OTData_vt = new Vector();
        D01OTData data = new D01OTData();

        box.copyToEntity(data);
        data.PERNR = PERNR;
        DataUtil.fixNull(data);

        D01OTData_vt.addElement(data);  // ������ Ŭ���̾�Ʈ�� �ǵ�����.

        String message = "";

        // [CSR ID:2595636] �����Ͽ� �ް�&��� ���� ��û ��
        D16OTHDDupCheckRFC2 checkFunc = new D16OTHDDupCheckRFC2();
        Vector OTHDDupCheckData_new_vt = checkFunc.getChecResult(PERNR, UPMU_TYPE, data.WORK_DATE, data.WORK_DATE);
        String e_flag = OTHDDupCheckData_new_vt.get(0).toString();
        String e_message = OTHDDupCheckData_new_vt.get(1).toString();

        Logger.debug.println(this, "e_flag > " + e_flag);
        Logger.debug.println(this, "e_message > " + e_message);

        // ���������� �ǵ�����.
        // ********** �������, ���� ��� ���� ��ȸ ****************
        getApprovalInfo(req, PERNR);    // <-- �ݵ�� �߰�

        req.setAttribute("message", message);
        req.setAttribute("D01OTData_vt", D01OTData_vt);
    }

    /*
     *         �ڷ��߰� ������ üũ����
     */
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