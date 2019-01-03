/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR ����                                                  */
/*   2Depth Name  : �ʰ��ٹ�                                                    */
/*   Program Name : �ʰ��ٹ� ��û                                               */
/*   Program ID   : D01OTBuildSV                                                */
/*   Description  : �ʰ��ٹ�(OT/Ư��)��û�� �ϴ� Class                          */
/*   Note         :                                                             */
/*   Creation     : 2002-01-15  �ڿ���                                          */
/*   Update       : 2005-03-07  ������                                          */
/*                 	2014-05-13  C20140515_40601  �繫���ð�������(6H,4H )  ����,�������̸鼭 4,6�ð� �� �����ϰ� üũ�����߰�*/
/*						E_PERSK - 27  : �繫���ð�������(4H)  28 :  �繫��(6H)  */
/*             		2014-08-24   [CSR ID:2595636] �����Ͽ� �ް�&��� ���� ��û ��                                                                 */
/*                 	2015-03-13 [CSR ID:2727336] HR-���½�û ���� ������û�� ��   */
/*             		2015-06-18  [CSR ID:2803878] �ʰ��ٹ� ��û Process ���� ��û     */
/*                 	2016-09-21 ���ձ��� - ���ö                      */
/*						2018-02-12 rdcamel [CSR ID:3608185] e-HR �ʰ��ٹ� ���Ľ�û ���� �ý��� ���� ��û */
/*						2015-05-23 [WorkTime52] ��52�ð� �ٷνð� ���� PJT	*/
/*						2015-06-25 [WorkTime52] ZGHR_RFC_IS_AVAIL_OVERTIME �Ķ���� �߰�(I_NTM = X)
/********************************************************************************/

package servlet.hris.D.D01OT;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.ObjectUtils;

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

import hris.D.D16OTHDDupCheckData;
import hris.D.D01OT.D01OTCheckData;
/*[WorkTime52] start */
import hris.D.D01OT.D01OTCheckDataAdd;
import hris.D.D01OT.D01OTData;
import hris.D.D01OT.D01OTHolidayCheckData;
import hris.D.D01OT.D01OTRealWorkDATA;
import hris.D.D01OT.rfc.D01OTCheckAddRFC;
import hris.D.D01OT.rfc.D01OTCheckRFC;
import hris.D.D01OT.rfc.D01OTHolidayCheckRFC;
import hris.D.D01OT.rfc.D01OTRFC;
import hris.D.D01OT.rfc.D01OTRealWrokListRFC;
import hris.D.D03Vocation.rfc.D03ShiftCheckRFC;
/*[WorkTime52] end*/
import hris.D.rfc.D02KongsuHourRFC;
import hris.D.rfc.D16OTHDDupCheckRFC;
import hris.D.rfc.D16OTHDDupCheckRFC2;
import hris.common.PersonData;
import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalLineData;
import hris.common.rfc.PersonInfoRFC;

@SuppressWarnings({ "rawtypes", "serial" })
public class D01OTBuildSV extends ApprovalBaseServlet {

    private String UPMU_TYPE = "17";
    private String UPMU_NAME = "�ʰ��ٹ�";
    private String OT_AFTER = "";// [CSR ID:3608185]���Ľ�û ���� �߰�

    protected String getUPMU_TYPE() {
        return UPMU_TYPE;
    }

    protected String getUPMU_NAME() {
        return UPMU_NAME + OT_AFTER;// [CSR ID:3608185]���Ľ�û ���� �߰�
    }

    protected void performTask(final HttpServletRequest req, final HttpServletResponse res) throws GeneralException {

        try {

            final WebUserData user = WebUtil.getSessionUser(req);

            String dest = "";
            String jobid = "";

            final Box box = WebUtil.getBox(req);

            /*********** Start: ������ �б�ó�� **********************************************************/
            if (!user.area.equals(Area.KR)) { 	// �ؿ�ȭ������
                printJspPage(req, res, WebUtil.ServletURL + "hris.D.D01OT.D01OTBuildGlobalSV");
                return;
            }
            /************** END: ������ �б�ó�� *********************************************************/

            jobid = box.get("jobid", "first");
            boolean isUpdate = box.getBoolean("isUpdate");

            Logger.debug.println(this, "[isUpdate] = " + isUpdate);
            Logger.debug.println(this, "[jobid] = " + jobid + " [user] : " + user.toString());

            final String PERNR = getPERNR(box, user); // ��û����� ���

            // �븮 ��û �߰�
            PersonInfoRFC numfunc = new PersonInfoRFC();
            final PersonData phonenumdata;
            phonenumdata = (PersonData) numfunc.getPersonInfo(PERNR);
            req.setAttribute("PersonData", phonenumdata);
            req.setAttribute("isUpdate", isUpdate); 	// [����]��� ���� ���� <- �����ʿ��� �ݵ�� �ʿ���
            req.setAttribute("PERNR", PERNR);
            req.setAttribute("committed", "N"); 			// check already response 2017/1/3 ksc

            /*************************************************************************************/

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

                D16OTHDDupCheckRFC d16OTHDDupCheckRFC = new D16OTHDDupCheckRFC();
                Vector OTHDDupCheckData_vt = null;
                OTHDDupCheckData_vt = d16OTHDDupCheckRFC.getCheckList(PERNR, UPMU_TYPE, user.area);

                req.setAttribute("OTHDDupCheckData_vt", OTHDDupCheckData_vt);
                // Logger.debug.println(this, "OTHDDupCheckData_vt : "+ OTHDDupCheckData_vt.toString());

                /*************************************************************************************/
                // [WorkTime52] 2018-05-18 Kang Start!!

                // ��� ���� ��ȸ(�繫��:S / ������:H) => [���� :2018-06-07 : A(�繫��-�Ϲ�), B(������-�Ϲ�), C(�繫��-���ñٷ���), D(������-ź�±ٷ���)
                Map<String, Object> rfcResultData = RfcHandler.execute("ZGHR_RFC_NTM_GET_EMPGUB", new HashMap<String, Object>() {
                    {
                        put("I_PERNR", PERNR);
                    }
                });

                final String EMPGUB = ObjectUtils.toString(getData(rfcResultData, "EXPORT", g.getMessage("MSG.D.D01.0063")).get("E_EMPGUB")); 	// (�繫��:S / ������:H)
                final String TPGUB = ObjectUtils.toString(getData(rfcResultData, "EXPORT", g.getMessage("MSG.D.D01.0063")).get("E_TPGUB"));		// A(�繫��-�Ϲ�), B(������-�Ϲ�), C(�繫��-���ñٷ���), D(������-ź�±ٷ���)
                String EMPTXT = "";
                if (TPGUB.equals("A")) {
                    EMPTXT = "�繫��-�Ϲ�";
                } else if (TPGUB.equals("B")) {
                    EMPTXT = "������-�Ϲ�";
                } else if (TPGUB.equals("C")) {
                    EMPTXT = "�繫��-���ñٷ���";
                } else {
                    EMPTXT = "������-���ñٷ���";
                }

                // String I_DATE = req.getParameter("DATUM");
                // I_DATE = (I_DATE == null || I_DATE.equals("")) ? DataUtil.getCurrentDate() : I_DATE;
                final String I_DATE = (req.getParameter("DATUM") == null || req.getParameter("DATUM").equals("")) ? DataUtil.getCurrentDate() : req.getParameter("DATUM");
                // String DATUM = DataUtil.getCurrentDate();

                // final String I_WORK_DATE = I_DATE;
                final String I_VTKEN = ObjectUtils.toString(req.getAttribute("VTKEN"));

                Logger.debug.println(this, "I_DATE :: " + I_DATE);
                Logger.debug.println(this, "I_VTKEN :: " + I_VTKEN);

                // �Ǳٹ��ð� ��ȸ
                D01OTRealWrokListRFC realworkfunc = new D01OTRealWrokListRFC();
                String MODE = "";

                if (EMPGUB.equals("S")) {	// �繫��-�Ϲ�
                    MODE = "";
                    final D01OTRealWorkDATA WorkData = realworkfunc.getResult(EMPGUB, PERNR, I_DATE, I_VTKEN,"", MODE);

                    if (realworkfunc.getReturn().isSuccess()) {
                        req.setAttribute("WorkData", WorkData); // ���߿�
                    } else {
                        req.setAttribute("WorkData", "");
                        Logger.debug.println(this, "�Ǳٹ��ð� ��ȸ ����!!");
                    }

                    Logger.debug.println(this, "WorkData[�繫��] : " + WorkData.toString());

                    req.setAttribute("EMPGUB", EMPGUB);
                    req.setAttribute("TPGUB", TPGUB);
                    req.setAttribute("DATUM", I_DATE);

                } else {		// ������

                    // ���� �Ǳٷνð� ��Ȳ ��ȸ
                    rfcResultData = RfcHandler.execute("ZGHR_RFC_NTM_OT_REQ_RW_LIST", new HashMap<String, Object>() { // ZGHR_RFC_NTM_REALWORK_LIST
                        {
                            put("I_EMPGUB", EMPGUB);
                            put("I_PERNR", PERNR);
                            put("I_DATUM", I_DATE);
                            put("I_VTKEN", "");

                        }
                    });

                    req.setAttribute("MM", Integer.parseInt(DataUtil.getCurrentMonth()));
                    req.setAttribute("EMPGUB", EMPGUB);
                    req.setAttribute("TPGUB", TPGUB);
                    req.setAttribute("DATUM", I_DATE);

                    WebUtil.setAttributes(req, getSummaryData(rfcResultData, EMPGUB, g.getMessage("MSG.D.D01.0064", EMPTXT))); // �繫��(����)/������(�ְ�) �Ǳٷνð� ��Ȳ �����͸� ��ȸ���� ���Ͽ����ϴ�.

                }

                Logger.debug.println(this, "[first] EMPGUB >> " + EMPGUB);
                Logger.debug.println(this, "[first] TGUB >> " + TPGUB);
                Logger.debug.println(this, "[first] MODE >> " + MODE);
                Logger.debug.println(this, "[first] DATUM >> " + I_DATE);
                // [WorkTime52] 2018-05-18 Kang End!!
                /*************************************************************************************/

                dest = WebUtil.JspURL + "D/D01OT/D01OTBuild_KR.jsp";

                /*************************************************************************************/
            } else if (jobid.equals("ajax")) {

                Map<String, Object> rfcResultData = RfcHandler.execute("ZGHR_RFC_NTM_GET_EMPGUB", new HashMap<String, Object>() {
                    {
                        put("I_PERNR", PERNR);
                    }
                });

                // �Ǳٹ��ð� ��ȸ
                final String I_EMPGUB = req.getParameter("I_EMPGUB");
                final String I_TPGUB = ObjectUtils.toString(getData(rfcResultData, "EXPORT", g.getMessage("MSG.D.D01.0063")).get("E_TPGUB"));		// A(�繫��-�Ϲ�), B(������-�Ϲ�), C(�繫��-���ñٷ���), D(������-ź�±ٷ���)
                String DATE = (req.getParameter("DATUM") == null || req.getParameter("DATUM").equals("")) ? DataUtil.getCurrentDate() : req.getParameter("DATUM");
                final String A_DATE = DATE;

                String EMPTXT = "";
                if (I_EMPGUB.equals("S")) {
                    EMPTXT = "�繫��";
                } else {
                    EMPTXT = "������";
                }

                Logger.debug.println(this, "ajax-DATE : " + DATE);
                // Logger.debug.println(this, "ajax-DATE.substring : "+ DATE.substring(5, 6));

                // �Ǳٷνð� ��ȸ
                D01OTRealWrokListRFC realworkfunc01 = new D01OTRealWrokListRFC();

                if (I_EMPGUB.equals("S")) {		// �繫��

                    final D01OTRealWorkDATA worklistdata = realworkfunc01.getResult(I_EMPGUB, PERNR, DATE, "", "","");
                    Logger.debug.println(this, "worklistdata[�繫��-ajax] : " + worklistdata.toString());

                    // ����/����/������ ��ȸ
                    rfcResultData = RfcHandler.execute("ZGHR_RFC_NTM_WORKDAY_LIST", new HashMap<String, Object>() {
                        {
                            put("I_EMPGUB", I_EMPGUB);
                            put("I_PERNR", PERNR);
                            put("I_BEGDA", A_DATE);
                            put("I_ENDDA", A_DATE);
                        }
                    });

                    req.setAttribute("EMPGUB", I_EMPGUB);
                    req.setAttribute("TPGUB" , I_TPGUB);
                    req.setAttribute("DATUM" , A_DATE);

                    List HolidayList = (List) getData(rfcResultData, "TABLES", g.getMessage("MSG.D.D01.0063")).get("T_WLIST");
                    final String Holidaycheck01 = (String) ((Map) HolidayList.get(0)).get("HOLID");	// ������ X
                    final String Holidaycheck02 = (String) ((Map) HolidayList.get(0)).get("SOLLZ");	// ��ٹ��� 0

                    // �ϱ���üũ
                    D03ShiftCheckRFC func_shift = new D03ShiftCheckRFC();
                    final String	shiftCheck = func_shift.check(PERNR, A_DATE);    //D:�ϱ���,1:��ġ������
                    Logger.debug.println(this, "[ajax] shiftCheck ::  " + shiftCheck);

                    new AjaxResultMap().addResult(new HashMap<String, Object>() {
                        {
                            put("E_BASTM", worklistdata.BASTM);	// �⺻�ٹ�
                            put("E_MAXTM", worklistdata.MAXTM);	// �����ִ��ѵ�
                            put("E_PWDWK", worklistdata.PWDWK);	// ���ϱٷνð�-�����Է�
                            put("E_PWEWK", worklistdata.PWEWK);	// ���ϱٷνð�-ȸ������
                            put("E_CWDWK", worklistdata.CWDWK);	// �ָ����ϱٹ��ð�-����
                            put("E_CWEWK", worklistdata.CWEWK);	// �ָ����ϱٹ��ð�-ȸ������
                            put("E_PWTOT", worklistdata.PWTOT); //��-����
                            put("E_CWTOT", worklistdata.CWTOT); //��-ȸ��
                            put("E_RWKTM", worklistdata.RWKTM);	// �Ǳٹ��ð�

                            put("E_HOLID", Holidaycheck01);		// ������
                            put("E_SOLLZ", Holidaycheck02);		// ��ٹ���
                            put("E_SHIFT", shiftCheck);			// �ϱ���/4��3����

                        }
                    }).writeJson(res);

                } else {	// ������
                    try {
                        // ���� �Ǳٷνð� ��Ȳ ��ȸ
                        rfcResultData = RfcHandler.execute("ZGHR_RFC_NTM_OT_REQ_RW_LIST", new HashMap<String, Object>() {
                            {
                                put("I_EMPGUB", I_EMPGUB);
                                put("I_PERNR" , PERNR);
                                put("I_DATUM" , A_DATE);
                                put("I_VTKEN" , "");
                            }
                        });

                        req.setAttribute("EMPGUB", I_EMPGUB);
                        req.setAttribute("TPGUB" , I_TPGUB);
                        req.setAttribute("DATUM" , A_DATE);

                        Map TimeTable = getSummaryData(rfcResultData, I_EMPGUB, g.getMessage("MSG.D.D01.0064", EMPTXT));

                        // ����/����/������ ��ȸ
                        rfcResultData = RfcHandler.execute("ZGHR_RFC_NTM_WORKDAY_LIST", new HashMap<String, Object>() {
                            {
                                put("I_EMPGUB", I_EMPGUB);
                                put("I_PERNR" , PERNR);
                                put("I_BEGDA" , A_DATE);
                                put("I_ENDDA" , A_DATE);
                            }
                        });

                        Logger.debug.println(this, "Holidaycheck value :: rfcResultData " + rfcResultData);
                        List HolidayList = (List) getData(rfcResultData, "TABLES", g.getMessage("MSG.D.D01.0063")).get("T_WLIST");
                        Logger.debug.println(this, "Holidaycheck value :: HolidayList " + HolidayList);
                        // if(CollectionUtils.isEmpty(Holiday)){
                        // �����޼���
                        // }

                        TimeTable.put("Holidycheck01", (String) ((Map) HolidayList.get(0)).get("HOLID"));
                        TimeTable.put("Holidycheck02", (String) ((Map) HolidayList.get(0)).get("SOLLZ"));

                        Logger.debug.println(this, "Holidycheck01 ::  " + (String) ((Map) HolidayList.get(0)).get("HOLID"));
                        Logger.debug.println(this, "Holidycheck02 ::  " + (String) ((Map) HolidayList.get(0)).get("SOLLZ"));

                        new AjaxResultMap().addResult(TimeTable).writeJson(res);

                        return;

                    } catch (Exception e) {
                        Logger.error(e);
                    }
                }

                return;

                /*************************************************************************************/
            } else if (jobid.equals("check")) {
                checkCommon(box, PERNR, user, req);
                req.setAttribute("jobid", jobid);

                // [WorkTime52] START
                // ��� ���� ��ȸ(�繫��:S / ������:H)
                Map<String, Object> rfcResultData = RfcHandler.execute("ZGHR_RFC_NTM_GET_EMPGUB", new HashMap<String, Object>() {
                    {
                        put("I_PERNR", PERNR);
                    }
                });

                final String EMPGUB	= ObjectUtils.toString(getData(rfcResultData, "EXPORT", g.getMessage("MSG.D.D01.0063")).get("E_EMPGUB")); 	// (�繫��:S / ������:H)
                final String TPGUB 	= ObjectUtils.toString(getData(rfcResultData, "EXPORT", g.getMessage("MSG.D.D01.0063")).get("E_TPGUB"));		// A(�繫��-�Ϲ�), B(������-�Ϲ�), C(�繫��-���ñٷ���), D(������-ź�±ٷ���)
                final String I_DATE 	= req.getParameter("DATUM");
                final String I_VTKEN = ObjectUtils.toString(req.getAttribute("VTKEN"));
                final String I_AINF_SEQN = ObjectUtils.toString(req.getAttribute("AINF_SEQN"));

                Logger.debug.println(this, "[ I_DATE : " + I_DATE + "], [ I_VTKEN : " + I_VTKEN + "]");

                D01OTRealWrokListRFC realworkfunc = new D01OTRealWrokListRFC();
                // �繫��
                if (EMPGUB.equals("S")) {
                    String MODE = "";

                    final D01OTRealWorkDATA WorkData = realworkfunc.getResult(EMPGUB, PERNR, I_DATE, I_VTKEN, I_AINF_SEQN, MODE);
                    if (realworkfunc.getReturn().isSuccess()) {
                        req.setAttribute("WorkData", WorkData);
                    } else {
                        req.setAttribute("WorkData", "");
                        Logger.debug.println(this, "�Ǳٹ��ð� ��ȸ ����!!");
                    }
                    // ������
                } else {
                    // ���� �Ǳٷνð� ��Ȳ ��ȸ
                    rfcResultData = RfcHandler.execute("ZGHR_RFC_NTM_OT_REQ_RW_LIST", new HashMap<String, Object>() {
                        {
                            put("I_PERNR" , PERNR);
                            put("I_DATUM" , I_DATE);
                            put("I_EMPGUB", EMPGUB);
                        }
                    });
                    WebUtil.setAttributes(req, getSummaryData(rfcResultData, EMPGUB, g.getMessage("MSG.D.D01.0064", "1"))); // �繫��(����)/������(�ְ�) �Ǳٷνð� ��Ȳ �����͸� ��ȸ���� ���Ͽ����ϴ�.
                }

                req.setAttribute("DATUM" , I_DATE);
                req.setAttribute("EMPGUB", EMPGUB);
                req.setAttribute("TPGUB" , TPGUB);

                // WebUtil.setAttributes(req, getSummaryData(rfcResultData, EMPGUB, g.getMessage("MSG.D.D01.0064","1"))); // �繫��(����)/������(�ְ�) �Ǳٷνð� ��Ȳ �����͸� ��ȸ���� ���Ͽ����ϴ�.
                // [WorkTime52] END

                dest = WebUtil.JspURL + "D/D01OT/D01OTBuild_KR.jsp";

                /*************************************************************************************/
            } else if (jobid.equals("create")) {
                // @����༺ ������ ������ ���� üũ 2015-08-25-------------------------------------------------------

                dest = requestApproval(req, box, D01OTData.class, new RequestFunction<D01OTData>() {
                    public String porcess(D01OTData inputData, Vector<ApprovalLineData> approvalLine) throws GeneralException {

                        D01OTRFC rfc = new D01OTRFC();
                        Vector D01OTData_vt = new Vector();
                        box.copyToEntity(inputData);
                        inputData.PERNR  = PERNR;
                        inputData.ZPERNR = user.empNo;	// ��û�� ���(�븮��û, ���� ��û)
                        inputData.UNAME  = user.empNo;  // ��û�� ���(�븮��û, ���� ��û)
                        inputData.AEDTM  = DataUtil.getCurrentDate();  // ������(���糯¥)

                        // [CSR ID:3608185] e-HR �ʰ��ٹ� ���Ľ�û ���� �ý��� ���� ��û
                        OTAfterCheck(inputData);
                        Logger.debug.println(this, getUPMU_NAME());
                        // [CSR ID:3608185] e-HR �ʰ��ٹ� ���Ľ�û ���� �ý��� ���� ��û

                        DataUtil.fixNull(inputData);

                        D01OTData_vt.addElement(inputData);
                        // Logger.debug.println(this, data.toString() );

                        String message = "";
                        // String message2 = "";

                        // [CSR ID:2803878] ��û �ʰ��ٹ� ��ûȭ�� 1�� 12�ð� üũ
                        D02KongsuHourRFC rfcH = new D02KongsuHourRFC();
                        String yymm = DataUtil.getCurrentYear() + DataUtil.getCurrentMonth();
                        // 'C' = ��Ȳ, 'R' = ��û,'M' = ����, 'G' = ����
                        // 2015-10-21 @marco
                        // �ʰ��ٹ� ��Ȳ���� �븮��û ����� ��� ó��

                        /* üũ ���� �ʿ��� ��� */
                        message = checkData(phonenumdata, inputData, PERNR, user);
                        // if (!message.equals("")) throw new GeneralException(message);

                        /* ���� ��û RFC ȣ�� */
                        // �޿����� ����..

                        // [WorkTime52] START---------------------------------------------------------------------
                        //Vector submitData_vt = rfcH.getOvtmHour(PERNR, yymm, "R", inputData); //����
                        Vector submitData_vt = rfcH.getOvtmHour52(PERNR, inputData.WORK_DATE, "R", inputData, "X");	// �ű�

                        String PRECHECK = rfcH.getOvtmHour(PERNR, yymm, inputData.WORK_DATE, "");	// ���ϱ��� üũ�� �������� ���� Ȯ��(N�̸� üũ�ϸ� �ȵ�)

                        // [WorkTime52]��� ���� ��ȸ(�繫��:S / ������:H)
                        Map<String, Object> rfcResultData = RfcHandler.execute("ZGHR_RFC_NTM_GET_EMPGUB", new HashMap<String, Object>() {
                            {
                                put("I_PERNR", PERNR);
                            }
                        });

                        final String EMPGUB = ObjectUtils.toString(getData(rfcResultData, "EXPORT", g.getMessage("MSG.D.D01.0063")).get("E_EMPGUB"));
                        final String TPGUB = ObjectUtils.toString(getData(rfcResultData, "EXPORT", g.getMessage("MSG.D.D01.0063")).get("E_TPGUB"));
                        String EMPTXT = "";
                        if (TPGUB.equals("A")) {
                            EMPTXT = "�繫��-�Ϲ�";
                        } else if (TPGUB.equals("B")) {
                            EMPTXT = "������-�Ϲ�";
                        } else if (TPGUB.equals("C")) {
                            EMPTXT = "�繫��-���ñٷ���";
                        } else {
                            EMPTXT = "������-���ñٷ���";
                        }

                        final String I_WORK_DATE = inputData.WORK_DATE;

                        Logger.debug.println(this, "checkData() After ....message >> [ " + message + " ]");

                        // [WorkTime52] �Ǳٹ��ð���ȸ
                        D01OTRealWrokListRFC realworkfunc = new D01OTRealWrokListRFC();

                        if (EMPGUB.equals("S")) {
                            String MODE = "";
                            final D01OTRealWorkDATA WorkData = realworkfunc.getResult(EMPGUB, PERNR, inputData.WORK_DATE, inputData.VTKEN, inputData.AINF_SEQN, MODE);
                            if (realworkfunc.getReturn().isSuccess()) {
                                req.setAttribute("WorkData", WorkData); // ���߿�
                            } else {
                                req.setAttribute("WorkData", "");
                                Logger.debug.println(this, "�Ǳٹ��ð� ��ȸ ����!!");
                            }
                        } else {
                            // �Ǳٷνð� ��Ȳ ��ȸ
                            rfcResultData = RfcHandler.execute("ZGHR_RFC_NTM_OT_REQ_RW_LIST", new HashMap<String, Object>() {
                                {
                                    put("I_PERNR"		, PERNR);
                                    put("I_DATUM"		, I_WORK_DATE);
                                    put("I_EMPGUB"	, EMPGUB);
                                }
                            });
                            WebUtil.setAttributes(req, getSummaryData(rfcResultData, EMPGUB, g.getMessage("MSG.D.D01.0064", EMPTXT))); // �繫��(����)/������(�ְ�) �Ǳٷνð� ��Ȳ �����͸� ��ȸ���� ���Ͽ����ϴ�.
                        }
                        // [WorkTime52] END ---------------------------------------------------------------------

                        if (!message.equals("")) { // �޼����� �ִ°��
                            D16OTHDDupCheckRFC func2 = new D16OTHDDupCheckRFC();
                            Vector OTHDDupCheckData_vt = func2.getCheckList(PERNR, UPMU_TYPE, user.area);

                            Logger.debug.println(this, "������������:�޼����� �ִ°��");
                            Logger.debug.println(this, "������������:�޼����� �ִ°�� message : " + message);
                            Logger.debug.println(this, "������������:EMPGUB : " + EMPGUB);
                            Logger.debug.println(this, "������������:DATUM  : " + inputData.WORK_DATE);

                            req.setAttribute("msg2", message);
                            req.setAttribute("message", message);
                            req.setAttribute("D01OTData_vt", D01OTData_vt);
                            req.setAttribute("submitData_vt", submitData_vt);
                            req.setAttribute("OTHDDupCheckData_vt", OTHDDupCheckData_vt);
                            getApprovalInfo(req, PERNR);    // <-- �ݵ�� �߰�
                            req.setAttribute("approvalLine", approvalLine); // ����� �������
                            req.setAttribute("committed", "Y"); // ���ߺб�(������������)�� �������� �Ӽ��߰�
                            // [WorkTime52]
                            req.setAttribute("EMPGUB", EMPGUB);
                            req.setAttribute("TPGUB"  , TPGUB);
                            req.setAttribute("DATUM" , inputData.WORK_DATE);


                            printJspPage(req, res, WebUtil.JspURL + "D/D01OT/D01OTBuild_KR.jsp");

                            return null;// WebUtil.JspURL+"D/D01OT/D01OTBuild_KR.jsp";

                            // [CSR ID:2803878] ��û �� �ʰ��ٹ� ��û���� alert ## ��Ȳ�ȳ��޽����� Ȯ���ϸ� ������.(KSC)
                        } else if (!inputData.OVTM12YN.equals("N") || (PRECHECK.equals("N") && inputData.VTKEN.equals("X"))) { // confirm �� message �߰�
                            D16OTHDDupCheckRFC func2 = new D16OTHDDupCheckRFC();
                            Vector OTHDDupCheckData_vt = func2.getCheckList(PERNR, UPMU_TYPE, user.area);

                            Logger.debug.println(this, "������������:��û���� Alert ");
                            Logger.debug.println(this, "������������:��û���� Alert : message : " + message);

                            // [WorkTime52] START
                            // �Ǳٹ��ð� ��ȸ
                            String MODE = "";

                            if (EMPGUB.equals("S")) {	// �繫��
                                MODE = "";
                                final D01OTRealWorkDATA WorkData = realworkfunc.getResult(EMPGUB, PERNR, inputData.WORK_DATE, inputData.VTKEN, inputData.AINF_SEQN, MODE);
                                if (realworkfunc.getReturn().isSuccess()) {
                                    req.setAttribute("WorkData", WorkData); // ���߿�
                                } else {
                                    req.setAttribute("WorkData", "");
                                    Logger.debug.println(this, "�Ǳٹ��ð� ��ȸ ����!!");
                                }

                                req.setAttribute("EMPGUB", EMPGUB);
                                req.setAttribute("TPGUB", TPGUB);
                                req.setAttribute("DATUM", inputData.WORK_DATE);

                            } else {		// ������
                                rfcResultData = RfcHandler.execute("ZGHR_RFC_NTM_OT_REQ_RW_LIST", new HashMap<String, Object>() {	// �Ǳٷνð� ��Ȳ ��ȸ
                                    {
                                        put("I_PERNR", PERNR);
                                        put("I_DATUM", I_WORK_DATE);
                                        put("I_EMPGUB", EMPGUB);
                                    }
                                });

                                req.setAttribute("MM", Integer.parseInt(DataUtil.getCurrentMonth()));
                                req.setAttribute("EMPGUB", EMPGUB);
                                req.setAttribute("TPGUB", TPGUB);
                                req.setAttribute("DATUM", I_WORK_DATE);

                                WebUtil.setAttributes(req, getSummaryData(rfcResultData, EMPGUB, g.getMessage("MSG.D.D01.0064", EMPTXT))); // �繫��(����)/������(�ְ�) �Ǳٷνð� ��Ȳ �����͸� ��ȸ���� ���Ͽ����ϴ�.
                            }
                            // [WorkTime52] END

                            req.setAttribute("D01OTData_vt", D01OTData_vt);
                            req.setAttribute("submitData_vt", submitData_vt);
                            req.setAttribute("PRECHECK", PRECHECK);
                            req.setAttribute("OTHDDupCheckData_vt", OTHDDupCheckData_vt);
                            getApprovalInfo(req, PERNR);    // <-- �ݵ�� �߰�
                            req.setAttribute("approvalLine", approvalLine); // ����� �������
                            req.setAttribute("committed", "Y");
                            // [WorkTime52]
                            req.setAttribute("EMPGUB", EMPGUB);
                            req.setAttribute("TPGUB", TPGUB);
                            req.setAttribute("DATUM", inputData.WORK_DATE);


                            printJspPage(req, res, WebUtil.JspURL + "D/D01OT/D01OTBuild_KR.jsp");

                            return null;

                        } else { // ����

                            rfc.setRequestInput(user.empNo, UPMU_TYPE);
                            String ainf_seqn = rfc.build(PERNR, D01OTData_vt, box, req);
                            Logger.debug.println(this, "�����ȣ  ainf_seqn=" + ainf_seqn.toString());
                            if (!rfc.getReturn().isSuccess() || ainf_seqn == null) {
                                throw new GeneralException(rfc.getReturn().MSGTX);
                            };
                            // Logger.debug.println(this, "��������:date"+date);
                            //String date = box.get("BEGDA");        // ��û��: 2012.02.10 ���� ������ ��û���� ��������ǿ� ����̵ǰ� �־� ������.
                            String url = "location.href = '" + WebUtil.ServletURL + "hris.D.D01OT.D01OTDetailSV?AINF_SEQN=" + ainf_seqn + "';";
                            req.setAttribute("url", url);
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
        } finally {

        }
    }

    /*
     * jobid = check ��ƾ; D01TOchange������ ȣ��
     */

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

        if (e_flag.equals("Y")) {// Y�� �ߺ�, N�� OK
            message = e_message;
        } else {
            D01OTCheckRFC func = new D01OTCheckRFC();
            //[WorkTime52] ZGHR_RFC_IS_AVAIL_OVERTIME �Ķ���� �߰�(I_NTM = X)
            Vector D01OTCheck_vt = func.check(PERNR, data.WORK_DATE, data.WORK_DATE, data.BEGUZ, data.ENDUZ, "X");

            // 2002.07.04. ��û�ð��� �ٹ������� �ߺ��Ǿ������ R3�� �ʰ��ٹ� ��û ������ �����ϱ����ؼ� ������.

            D01OTCheckData checkData = (D01OTCheckData) D01OTCheck_vt.get(0);

            Logger.debug.println(this, "==checkData== : " + checkData.toString());

            if (!checkData.ERRORTEXTS.equals("") && checkData.STDAZ.equals("0")) {  // �����޽����� �ְ�, �Ѱ������ �� �� ���� ���
                message = "�ٹ������� �ߺ��Ǿ����ϴ�.";
            } else if (checkData.ERRORTEXTS.equals("")) {                          // �����޽����� ����, �������̰ų� �Ѱ������ �� ���.
                if (checkData.BEGUZ.equals(data.BEGUZ) && checkData.ENDUZ.equals(data.ENDUZ)) {
                    message = "";
                } else {
                    message = "�ٹ������� �ߺ��Ǿ� ��û�ð��� �����Ͽ����ϴ�.";
                    data.BEGUZ = checkData.BEGUZ;                                    // �Ѱ������ �ð������� �缳�����ش�.
                    data.ENDUZ = checkData.ENDUZ;
                    data.STDAZ = checkData.STDAZ;
                }
            }
            // 2002.07.04. ��û�ð��� �ٹ������� �ߺ��Ǿ������ R3�� �ʰ��ٹ� ��û ������ �����ϱ����ؼ� ������.
        }

        // ���������� �ǵ�����.
        // ********** �������, ���� ��� ���� ��ȸ ****************
        getApprovalInfo(req, PERNR);    // <-- �ݵ�� �߰�

        D16OTHDDupCheckRFC func2 = new D16OTHDDupCheckRFC();
        Vector OTHDDupCheckData_vt = func2.getCheckList(PERNR, UPMU_TYPE, user.area);
        req.setAttribute("message", message);
        req.setAttribute("D01OTData_vt", D01OTData_vt);
        req.setAttribute("OTHDDupCheckData_vt", OTHDDupCheckData_vt);

    }

    /*
     * 		�ڷ��߰� ������ üũ����
     */
    protected String checkData(PersonData phonenumdata, D01OTData data, String PERNR, WebUserData user) throws GeneralException {

        String message = "";

        try {
            // C20140515_40601 �λ��������� 27,36: -�繫���ð�������(4H) 4�ð�üũ START
            // C20140515_40601 �λ��������� 28,37: -�繫���ð�������(6H) 6�ð�üũ

            Logger.debug.println(this, "phonenumdata.E_PERSK : " + phonenumdata.E_PERSK);
            Logger.debug.println(this, "checkData.data : " + data.toString());

            if (phonenumdata.E_PERSK.equals("27") || phonenumdata.E_PERSK.equals("28") || phonenumdata.E_PERSK.equals("36") || phonenumdata.E_PERSK.equals("37")) { //
                // ������, ��,�ϸ� ����
                D01OTHolidayCheckRFC funHc = new D01OTHolidayCheckRFC();
                Vector D01OTHolidayCheck_vt = funHc.check("L1", data.WORK_DATE, data.WORK_DATE);
                D01OTHolidayCheckData HolidaycheckData = (D01OTHolidayCheckData) D01OTHolidayCheck_vt.get(0);

                if (HolidaycheckData.HOLIDAY.equals("X") || (HolidaycheckData.WEEKDAY.equals("6") || HolidaycheckData.WEEKDAY.equals("7"))) {
                    if ((phonenumdata.E_PERSK.equals("27") || phonenumdata.E_PERSK.equals("36")) && !data.STDAZ.equals("4")) {
                        message = "�繫�� �ð�������(4H) ����� 4�ð��� ��û�����մϴ�. ";
                    }
                    if ((phonenumdata.E_PERSK.equals("28") || phonenumdata.E_PERSK.equals("37")) && !data.STDAZ.equals("6")) {
                        message = "�繫�� �ð�������(6H) ����� 6�ð��� ��û�����մϴ�. ";
                    }
                } else { // ����
                    if (phonenumdata.E_PERSK.equals("27") || phonenumdata.E_PERSK.equals("28")) { // �ð� ������

                        message = message + "�繫�� �ð������� �����  ������, �����, �Ͽ��Ͽ��� �ʰ��ٹ� ��û�� �����մϴ�";
                    }
                }

                Logger.debug.println(this, "HolidaycheckData : " + HolidaycheckData.toString());
                Logger.debug.println(this, "[message] : " + message);

            }

            if (phonenumdata.E_PERSK.equals("27") || phonenumdata.E_PERSK.equals("28") || phonenumdata.E_PERSK.equals("36") || phonenumdata.E_PERSK.equals("37")) { //
                if ((phonenumdata.E_PERSK.equals("27") || phonenumdata.E_PERSK.equals("36")) && !data.STDAZ.equals("4")) {
                    message = "�繫���ð�������(4H)��  4�ð��� ��û�����մϴ�.";
                }
                if ((phonenumdata.E_PERSK.equals("28") || phonenumdata.E_PERSK.equals("37")) && !data.STDAZ.equals("6")) {
                    message = "�繫���ð�������(6H)��  6�ð��� ��û�����մϴ�.";
                }
                Logger.debug.println(this, "[[message : " + message + "data.STDAZ:" + data.STDAZ);
                // ������, ��,�ϸ� ����
                D01OTHolidayCheckRFC funHc = new D01OTHolidayCheckRFC();
                Vector D01OTHolidayCheck_vt = funHc.check("L1", data.WORK_DATE, data.WORK_DATE);
                D01OTHolidayCheckData HolidaycheckData = (D01OTHolidayCheckData) D01OTHolidayCheck_vt.get(0);
                if (phonenumdata.E_PERSK.equals("27") || phonenumdata.E_PERSK.equals("28")) {
                    if (!HolidaycheckData.HOLIDAY.equals("X") && !HolidaycheckData.WEEKDAY.equals("6") && !HolidaycheckData.WEEKDAY.equals("7")) {
                        message = message + "�繫���ð���������  ������,�����,�Ͽ��ϸ� ��û�����մϴ�.";
                    }
                }
                Logger.debug.println(this, "HolidaycheckData : " + HolidaycheckData.toString());
                Logger.debug.println(this, "[message] : " + message);
            }

            // }
            // C20140515_40601 �λ��������� 27: -�繫���ð�������(6H) ������ 6�ð�üũ END

            // DUP CHECK START <<< ����Ͽ��� ������ 2016/12/03 KSC

            D16OTHDDupCheckRFC d16OTHDDupCheckRFC = new D16OTHDDupCheckRFC();
            Vector OTHDDupCheckData_vt = null;
            OTHDDupCheckData_vt = d16OTHDDupCheckRFC.getCheckList(PERNR, UPMU_TYPE, user.area);
            String c_workDate = "";
            for (int i = 0; i < OTHDDupCheckData_vt.size(); i++) {
                D16OTHDDupCheckData c_Data = (D16OTHDDupCheckData) OTHDDupCheckData_vt.get(i);
                String s_BEGUZ1 = c_Data.BEGUZ.substring(0, 2) + c_Data.BEGUZ.substring(3, 5);
                String s_ENDUZ1 = c_Data.ENDUZ.substring(0, 2) + c_Data.ENDUZ.substring(3, 5);
                if (s_ENDUZ1.equals("0000")) {
                    s_ENDUZ1 = "2400";
                }
                int s_BEGUZ = Integer.parseInt(s_BEGUZ1 + "00");
                int s_ENDUZ = Integer.parseInt(s_ENDUZ1 + "00");
                // Logger.debug.println("<br>D01OTMbBuildSV c_Data +++ >"+c_Data.toString() );
                // Logger.debug.println("<br>D01OTMbBuildSV D01OTData ++++ >"+data.toString() );
                // Logger.debug.println("<br>D01OTMbBuildSV s_BEGUZ ++++ >"+s_BEGUZ+"Integer.parseInt(D01OTData.BEGUZ)" +Integer.parseInt(data.BEGUZ));
                // Logger.debug.println("<br>D01OTMbBuildSV s_ENDUZ ++++ >"+s_ENDUZ+"Integer.parseInt(D01OTData.ENDUZ)" +Integer.parseInt(data.ENDUZ));

                c_workDate = c_Data.WORK_DATE.replace("-", "");
                // Logger.debug.println("<br>c_workDate : "+c_workDate);

                if (c_workDate.equals(data.WORK_DATE)) {

                    /** start: ����ð��� ���Ϸ� �Ѿ�°���� ��������(2016/12/12 ksc) */
                    int c_BEGUZ = Integer.parseInt(data.BEGUZ);
                    int c_ENDUZ = Integer.parseInt(data.ENDUZ);
                    if (c_BEGUZ > c_ENDUZ) {
                        c_ENDUZ = c_ENDUZ + 240000;
                    }

                    if (!"R".equals(c_Data.APPR_STAT) && s_BEGUZ == Integer.parseInt(data.BEGUZ) && s_ENDUZ == Integer.parseInt(data.ENDUZ)) {
                        message = "���� �����û�� �Ǿ� �����Ƿ� ����������Ȳ���� Ȯ���Ͻñ� �ٶ��ϴ�.";
                        return message;
                    }
                    // ENDUZ�� �������� �Ѿ�� ���� ���.
                    else if (!"R".equals(c_Data.APPR_STAT) && s_BEGUZ < s_ENDUZ
                                    && ((s_BEGUZ <= c_BEGUZ && s_ENDUZ > c_BEGUZ) || (s_BEGUZ < c_ENDUZ && s_ENDUZ >= c_ENDUZ) || (s_BEGUZ >= c_BEGUZ && s_ENDUZ <= c_ENDUZ))) {
                        message = "���� �����û�� �Ǿ� �����Ƿ� ����������Ȳ���� Ȯ���Ͻñ� �ٶ��ϴ�.";
                        return message;
                    }
                    /** end: ����ð��� ���Ϸ� �Ѿ�°���� ��������(2016/12/12 ksc) */

                    // ENDUZ�� �������� �Ѿ�� ���.
                    // [CSR ID:2727336] �� ��û���� ���� ��û�Ϻ��� ���� ��¥�� ��� ������ �߰��Ǿ�� ��.
                    // else if(!c_Data.APPR_STAT.equals("R") && s_BEGUZ > s_ENDUZ && ((( s_BEGUZ<= Integer.parseInt(D01OTData.BEGUZ) && Integer.parseInt(D01OTData.BEGUZ) < 2400) ||
                    // (Integer.parseInt(D01OTData.BEGUZ) >= 0000 && s_ENDUZ > Integer.parseInt(D01OTData.BEGUZ))) || ((Integer.parseInt(D01OTData.ENDUZ) <= 2400 && s_BEGUZ <
                    // Integer.parseInt(D01OTData.ENDUZ)) || (Integer.parseInt(D01OTData.ENDUZ) > 0000 && s_ENDUZ >= Integer.parseInt(D01OTData.ENDUZ))) || (Integer.parseInt(D01OTData.BEGUZ)
                    // >Integer.parseInt(D01OTData.ENDUZ) && s_BEGUZ >= Integer.parseInt(D01OTData.BEGUZ) && s_ENDUZ <= Integer.parseInt(D01OTData.ENDUZ))) ) {
                    else if (!"R".equals(c_Data.APPR_STAT) && s_BEGUZ > s_ENDUZ && (((s_BEGUZ <= Integer.parseInt(data.BEGUZ) && Integer.parseInt(data.BEGUZ) < 2400)
                                    || (Integer.parseInt(data.BEGUZ) >= 0000 && s_ENDUZ > Integer.parseInt(data.BEGUZ) && s_BEGUZ < Integer.parseInt(data.ENDUZ))
                                    || (Integer.parseInt(data.BEGUZ) >= 0000 && s_BEGUZ < Integer.parseInt(data.ENDUZ) && s_BEGUZ > Integer.parseInt(data.ENDUZ)))
                                    || ((Integer.parseInt(data.ENDUZ) <= 2400 && s_BEGUZ < Integer.parseInt(data.ENDUZ))
                                    || (Integer.parseInt(data.ENDUZ) > 0000 && s_ENDUZ >= Integer.parseInt(data.ENDUZ)))
                                    || (Integer.parseInt(data.BEGUZ) > Integer.parseInt(data.ENDUZ) && s_BEGUZ >= Integer.parseInt(data.BEGUZ) && s_ENDUZ <= Integer.parseInt(data.ENDUZ)))) {
                        message = "�̹� �����û�� �ð��� �ߺ��˴ϴ�. ����������Ȳ���� Ȯ���Ͻñ� �ٶ��ϴ�.";
                        return message;
                    }
                }
            }
            // DUP CHECK END


            // [CSR ID:2595636] �����Ͽ� �ް�&��� ���� ��û �� �ް��� �ʰ��ٹ��� ������ ��û�� �� ����.
            D16OTHDDupCheckRFC2 checkFunc = new D16OTHDDupCheckRFC2();
            Vector OTHDDupCheckData_new_vt = checkFunc.getChecResult(PERNR, UPMU_TYPE, data.WORK_DATE, data.WORK_DATE);
            String e_flag = OTHDDupCheckData_new_vt.get(0).toString();
            String e_message = OTHDDupCheckData_new_vt.get(1).toString();

            if (e_flag.equals("Y")) {// Y�� �ߺ�, N�� OK
                message = e_message;
                Logger.debug.println(this, "[�ߺ��˻� Y [message : " + message + "]");
            } else {
                Logger.debug.println(this, "[checkData 00001] ");

                // 2002.07.04. ��û�ð��� �ٹ������� �ߺ��Ǿ������ R3�� �ʰ��ٹ� ��û ������ �����ϱ����ؼ� ������.
                D01OTCheckRFC func = new D01OTCheckRFC();
                //[WorkTime52] ZGHR_RFC_IS_AVAIL_OVERTIME �Ķ���� �߰�(I_NTM = X)
                Vector D01OTCheck_vt = func.check(PERNR, data.WORK_DATE, data.WORK_DATE, data.BEGUZ, data.ENDUZ, "X");

                D01OTCheckData checkData = (D01OTCheckData) D01OTCheck_vt.get(0);

                if (!checkData.ERRORTEXTS.equals("") && checkData.STDAZ.equals("0")) {  // �����޽����� �ְ�, �Ѱ������ �� �� ���� ���
                    message = message + " �ٹ������� �ߺ��Ǿ����ϴ�. �ٽ� ��û���ֽʽÿ�.";
                } else if (checkData.ERRORTEXTS.equals("")) {                          				// �����޽����� ����, �������̰ų� �Ѱ������ �� ���.
                    if (checkData.BEGUZ.equals(data.BEGUZ) && checkData.ENDUZ.equals(data.ENDUZ)) {
                        message = message + "";
                    } else {
                        message = message + " �ٹ������� �ߺ��Ǿ� ��û�ð��� �����Ͽ����ϴ�.";
                        data.BEGUZ = checkData.BEGUZ;                                    				// �Ѱ������ �ð������� �缳�����ش�.
                        data.ENDUZ = checkData.ENDUZ;
                        data.STDAZ = checkData.STDAZ;
                        Logger.debug.println(this, "[message] :: " + message);
                    }
                }
                // 2002.07.04. ��û�ð��� �ٹ������� �ߺ��Ǿ������ R3�� �ʰ��ٹ� ��û ������ �����ϱ����ؼ� ������.


                // [WorkTime52] Start
                final String I_PERNR = PERNR;
                Map<String, Object> rfcResultData = RfcHandler.execute("ZGHR_RFC_NTM_GET_EMPGUB", new HashMap<String, Object>() {
                    {
                        put("I_PERNR", I_PERNR);
                    }
                });
                // �������
                final String I_EMPGUB = ObjectUtils.toString(getData(rfcResultData, "EXPORT", g.getMessage("MSG.D.D01.0063")).get("E_EMPGUB"));
                final String I_WORK = ObjectUtils.toString(getData(rfcResultData, "EXPORT", g.getMessage("MSG.D.D01.0063")).get("E_WORK"));
                /*
                             rfcResultData = RfcHandler.execute("ZGHR_RFC_NTM_WORKDAY_LIST", new HashMap<String, Object>() {
                 {
                     put("I_EMPGUB"	, I_EMPGUB);
                     put("I_PERNR"		, I_PERNR);
                     put("I_BEGDA"		, I_WORK_DATE);
                     put("I_ENDDA"	, I_WORK_DATE);
                 }
                             });

                             List Holiday = (List)getData(rfcResultData, "TABLES", g.getMessage("MSG.D.D01.0063")).get("T_WLIST");
                             //if(CollectionUtils.isEmpty(Holiday)){
                             	//�����޼���
                             //}

                             final String Holidaycheck01 =  (String)((Map)Holiday.get(0)).get("HOLID");	//������ X
                             final String Holidaycheck02 =  (String)((Map)Holiday.get(0)).get("SOLLZ");	//��ٹ��� 0
                */
                String HolidayYN = "";
                if (I_WORK == "X") {
                    HolidayYN = "Y";
                } else {
                    HolidayYN = "N";
                }

                Logger.debug.println(this, "Holidaycheck value :: [" + I_WORK + "]");
                Logger.debug.println(this, "BEGUZ :: [" + Integer.parseInt(data.BEGUZ) + "]");
                Logger.debug.println(this, "ENDUZ :: [" + Integer.parseInt(data.ENDUZ) + "]");

                if (I_EMPGUB.equals("S")) {
                    if (HolidayYN == "Y") {	// ����
                        if (Integer.parseInt(data.BEGUZ) < 070000 || Integer.parseInt(data.ENDUZ) > 190000) {
                            message = message + "���ϱٷ��� ���۽ð�, ����ð� ���� ���ؽð��� 07:00 ~ 19:00 �Դϴ�.";
                        }
                        if (!data.BEGUZ.substring(2, 4).equals(data.ENDUZ.substring(2, 4))) {
                            message = message + "���ϱٷ��� ���� �� ���� �ð��� �� �ð� ������ ��û ���� �մϴ�.\n��, �Է� �ð��� 10�� ������ �Է��Ͽ� �ֽñ⸦ �ٶ��ϴ�.\n��) ���� 09:30 ~ ���� 13:30 (��)\n     ���� 09:31 ~ ���� 13:31 (��)";
                        }
                    } else {	// ����
                        if (!data.BEGUZ.substring(2, 4).equals(data.ENDUZ.substring(2, 4))) {
                            message = message + "�ʰ��ٷ��� ���� �� ���� �ð��� �� �ð� ������ ��û ���� �մϴ�.\n��, �Է� �ð��� 10�� ������ �Է��Ͽ� �ֽñ⸦ �ٶ��ϴ�.\n��) ���� 09:30 ~ ���� 13:30 (��)\n     ���� 09:31 ~ ���� 13:31 (��)";
                        }
                    }

                } else {
                    if (HolidayYN == "Y") {
                        if (Integer.parseInt(data.BEGUZ) < 070000 || Integer.parseInt(data.ENDUZ) > 190000) {
                            message = message + "���ϱٷ��� ���۽ð�, ����ð� ���� ���ؽð��� 07:00 ~ 19:00 �Դϴ�.";
                        }
                    }
                }

                // RFC : ZGHR_RFC_NTM_OT_AVAL_CHK_ADD
                Logger.debug.println(this, "check Add RFC ����");
                D01OTCheckDataAdd ChkData = new D01OTCheckDataAdd();
                Vector ChkDataAdd_vt = new Vector();

                DataUtil.getCurrentDate();	// ��û�� = ��������
                ChkData.PERNR = PERNR;
                ChkData.BEGDA = data.WORK_DATE;
                ChkData.WORK_DATE = data.WORK_DATE;
                ChkData.VTKEN = "";
                ChkData.BEGUZ = data.BEGUZ;
                ChkData.ENDUZ = data.ENDUZ;
                ChkData.STDAZ = data.STDAZ;
                ChkData.ZPERNR = data.ZPERNR;

                ChkDataAdd_vt.addElement(ChkData);

                D01OTCheckAddRFC chkaddFunc = new D01OTCheckAddRFC();
                Vector ret = chkaddFunc.check(ChkDataAdd_vt);

                // message = message + chkaddFunc.getReturn().MSGTX;

                if ( chkaddFunc.getReturn().MSGTY.equals("W"))
                {
                	message = "";
                } else {
                	message = chkaddFunc.getReturn().MSGTX;
                }

                //message = chkaddFunc.getReturn().MSGTX;
                if ( message.equals("") || message == null) {
                	message = "";
                }

                Logger.debug.println(this, " Add Check chkaddFunc.getReturn().MSGTX >> " + chkaddFunc.getReturn().MSGTX);
                Logger.debug.println(this, " Add Check MESSAGE >> " + message);
                // [WorkTime52] End

            }

        } catch (Exception e) {
            throw new GeneralException(e);

        } finally {
        }
        return message;
    }

    // [CSR ID:3608185] e-HR �ʰ��ٹ� ���Ľ�û ���� �ý��� ���� ��û
    protected void OTAfterCheck(D01OTData data) {
        int dayCount = DataUtil.getBetween(data.BEGDA, data.WORK_DATE);
        if (dayCount < 0)
            OT_AFTER = "���Ľ�û";
        else
            OT_AFTER = "";
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

    /**
     * RFC ���� ����� ���� data���� �繫��(����)/������(�ְ�) �Ǳٷνð� ��Ȳǥ data�� �����Ͽ� ��ȯ
     *
     * @param rfcResultData
     * @param EMPGUB
     * @param message
     * @return
     * @throws GeneralException
     */
    private Map<String, Object> getSummaryData(Map<String, Object> rfcResultData, String EMPGUB, String message) throws GeneralException {
        /*
        if ("H".equals(EMPGUB)) {
            List<Map<String, Object>> T_HDATA = (List<Map<String, Object>>) getData(rfcResultData, "TABLES", message).get("T_HDATA");

            if (CollectionUtils.isEmpty(T_HDATA)) {
                throw new GeneralException(message);
            }

            Map<String, Object> data = T_HDATA.get(0);
            data.put("MAXTM", data.get("WKLMT"));
            return data;

        } else {
            return (Map<String, Object>) getData(rfcResultData, "EXPORT", message).get("E_SDATA");

        }
        */
        return (Map<String, Object>) getData(rfcResultData, "EXPORT", message).get("ES_EMPGUB_H");
    }

}
