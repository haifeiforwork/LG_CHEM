/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR ����                                                  */
/*   2Depth Name  : �ʰ��ٹ�                                                    */
/*   Program Name : �ʰ��ٹ� ����                                               */
/*   Program ID   : D01OTChangeSV                                               */
/*   Description  : �ʰ��ٹ��� ���� �� �� �ֵ��� �ϴ� Class                     */
/*   Note         :                                                             */
/*   Creation     : 2002-01-21  �ڿ���                                          */
/*   Update       : 2005-03-07  ������                                          */
/*                  2014-05-13  C20140515_40601  �繫���ð�������(6H,4H )  ����,�������̸鼭 4,6�ð� �� �����ϰ� üũ�����߰�*/
/*				E_PERSK - 27  : �繫���ð�������(4H)  28 :  �繫��(6H)  */
/*             2014-08-24   [CSR ID:2595636] �����Ͽ� �ް�&��� ���� ��û ��    */
/*             2015-06-18   [CSR ID:2803878] �ʰ��ٹ� ��û Process ���� ��û    */
/*             2018-06-05   [WorkTime52] ��52�ð� �ٹ��ð� ����    				*/
/********************************************************************************/

package servlet.hris.D.D01OT;

import java.util.HashMap;
import java.util.Map;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.ObjectUtils;
import org.apache.commons.lang.StringUtils;

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

import hris.D.D01OT.D01OTCheckData;
import hris.D.D01OT.D01OTCheckDataAdd;
import hris.D.D01OT.D01OTData;
import hris.D.D01OT.D01OTHolidayCheckData;
import hris.D.D01OT.D01OTRealWorkDATA;
import hris.D.D01OT.rfc.D01OTCheckAddRFC;
import hris.D.D01OT.rfc.D01OTCheckRFC;
import hris.D.D01OT.rfc.D01OTHolidayCheckRFC;
import hris.D.D01OT.rfc.D01OTRFC;
import hris.D.D01OT.rfc.D01OTRealWrokListRFC;
import hris.D.rfc.D02KongsuHourRFC;
import hris.D.rfc.D16OTHDDupCheckRFC;
import hris.D.rfc.D16OTHDDupCheckRFC2;
import hris.common.PersonData;
import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalHeader;
import hris.common.approval.ApprovalLineData;
import hris.common.rfc.PersonInfoRFC;
/*[WorkTime52] end*/

@SuppressWarnings({ "rawtypes", "serial" })
public class D01OTChangeSV extends ApprovalBaseServlet {

    private String UPMU_TYPE = "17";      // ���� ����Ÿ��(�ʰ��ٹ�)
    private String UPMU_NAME = "�ʰ��ٹ�";

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

            final D01OTRFC rfc = new D01OTRFC();

            String I_APGUB = (String) req.getAttribute("I_APGUB");  // ��� ���������� �Գ�? '1' : ������ ���� , '2' : ������ ���� , '3' : ����Ϸ� ����
            Logger.debug.println(this, "[I_APGUB] = " + I_APGUB);

            final String ainf_seqn = box.get("AINF_SEQN");
            // ���� ������ ���ڵ�..
            rfc.setDetailInput(user.empNo, I_APGUB, ainf_seqn); // ���������
            Vector D01OTData_vt = null;

            D01OTData_vt = rfc.getDetail(ainf_seqn, "");

            // final String PERNR = getPERNR(box, user); //��û����� ���
            final String PERNR = rfc.getApprovalHeader().PERNR;
            final D01OTData firstData = (D01OTData) Utils.indexOf(D01OTData_vt, 0);

            // �븮 ��û �߰�
            PersonInfoRFC numfunc = new PersonInfoRFC();
            final PersonData phonenumdata = (PersonData) numfunc.getPersonInfo(firstData.PERNR);
            req.setAttribute("PersonData", phonenumdata);

            req.setAttribute("committed", "N"); // check already response 2017/1/3 ksc

            /*************************************************************************************/
            if (jobid.equals("first")) {

                req.setAttribute("jobid", jobid);
                req.setAttribute("D01OTData_vt", D01OTData_vt);
                req.setAttribute("isUpdate", true); // [����]��� ���� ���� <- �����ʿ��� �ݵ�� �ʿ���

                D16OTHDDupCheckRFC d16OTHDDupCheckRFC = new D16OTHDDupCheckRFC();
                Vector OTHDDupCheckData_vt = null;
                OTHDDupCheckData_vt = d16OTHDDupCheckRFC.getCheckList(firstData.PERNR, UPMU_TYPE, user.area);
                Logger.debug.println(this, "OTHDDupCheckData_vt : " + OTHDDupCheckData_vt.toString());

                req.setAttribute("OTHDDupCheckData_vt", OTHDDupCheckData_vt);

                // [WorkTime52]
                // ��� ���� ��ȸ(�繫��:A,C / ������:B,D)
                Map<String, Object> rfcResultData = RfcHandler.execute("ZGHR_RFC_NTM_GET_EMPGUB", new HashMap<String, Object>() {
                    {
                        put("I_PERNR", PERNR);
                    }
                });

                Map<String, Object> EXPORT = getData(rfcResultData, "EXPORT", g.getMessage("MSG.D.D01.0063"));
                final String EMPGUB = ObjectUtils.toString(EXPORT.get("E_EMPGUB"));
                final String TPGUB 	= ObjectUtils.toString(EXPORT.get("E_TPGUB"));		// A(�繫��-�Ϲ�), B(������-�Ϲ�), C(�繫��-���ñٷ���), D(������-ź�±ٷ���)
                final String I_DATE = firstData.WORK_DATE.replaceAll("[^\\d]", "");
                final String I_VTKEN = firstData.VTKEN;
                final String I_AINF_SEQN = firstData.AINF_SEQN;

                D01OTRealWrokListRFC realworkfunc = new D01OTRealWrokListRFC();
                if (EMPGUB.equals("S")) {
                    String MODE = "";

                    final D01OTRealWorkDATA WorkData = realworkfunc.getResult(EMPGUB, PERNR, I_DATE, I_VTKEN, I_AINF_SEQN, MODE);
                    if (realworkfunc.getReturn().isSuccess()) {
                        req.setAttribute("WorkData", WorkData); // ���߿�
                    } else {
                        req.setAttribute("WorkData", "");
                        Logger.debug.println(this, "�Ǳٹ��ð� ��ȸ ����!!");
                    }
                } else {
                    // ���� �Ǳٷνð� ��Ȳ ��ȸ
                    rfcResultData = RfcHandler.execute("ZGHR_RFC_NTM_OT_REQ_RW_LIST", new HashMap<String, Object>() {
                        {
                            put("I_PERNR", PERNR);
                            put("I_DATUM", I_DATE);
                            put("I_EMPGUB", EMPGUB);
                        }
                    });
                    WebUtil.setAttributes(req, getSummaryData(rfcResultData, EMPGUB, g.getMessage("MSG.D.D01.0064", "1"))); // �繫��(����)/������(�ְ�) �Ǳٷνð� ��Ȳ �����͸� ��ȸ���� ���Ͽ����ϴ�.
                }

                req.setAttribute("EMPGUB", EMPGUB);
                req.setAttribute("TPGUB" , TPGUB);
                req.setAttribute("DATUM" , I_DATE);

                Logger.debug.println(this, "[first] EMPGUB :: " + EMPGUB);
                Logger.debug.println(this, "[first] TPGUB  :: " + TPGUB);
                Logger.debug.println(this, "[first] DATUM  :: " + I_DATE);
                // [WorkTime52]

                detailApporval(req, res, rfc);

                dest = WebUtil.JspURL + "D/D01OT/D01OTBuild_KR.jsp";// "D/D01OT/D01OTChange.jsp";

            /*************************************************************************************/
            } else if (jobid.equals("check")) {
                final D01OTBuildSV sv = new D01OTBuildSV();
                sv.checkCommon(box, PERNR, user, req);
                req.setAttribute("isUpdate", true); // [����]��� ���� ���� <- �����ʿ��� �ݵ�� �ʿ���
                req.setAttribute("jobid", jobid);
                detailApporval(req, res, rfc);

                // [WorkTime52]
                // ��� ���� ��ȸ(�繫��:A,C / ������:B,D)
                Map<String, Object> rfcResultData = RfcHandler.execute("ZGHR_RFC_NTM_GET_EMPGUB", new HashMap<String, Object>() {
                    {
                        put("I_PERNR", PERNR);
                    }
                });

                Map<String, Object> EXPORT = getData(rfcResultData, "EXPORT", g.getMessage("MSG.D.D01.0063"));
                final String EMPGUB = ObjectUtils.toString(EXPORT.get("E_EMPGUB"));
                final String TPGUB 	= ObjectUtils.toString(EXPORT.get("E_TPGUB"));
                final String DATE 	= box.get("WORK_DATE");
                final String VTKEN 	= box.get("VTKEN");

                Logger.debug.println(this, "Box.get[work_date] >> " + box.get("WORK_DATE"));
                req.setAttribute("EMPGUB", EMPGUB);
                req.setAttribute("TPGUB" , TPGUB);
                req.setAttribute("DATUM" , DATE );

                D01OTRealWrokListRFC realworkfunc = new D01OTRealWrokListRFC();
                if (EMPGUB.equals("S")) {
                    final D01OTRealWorkDATA WorkData = realworkfunc.getResult(EMPGUB, PERNR, DATE, VTKEN, ainf_seqn, "");
                    if (realworkfunc.getReturn().isSuccess()) {
                        req.setAttribute("WorkData", WorkData); // ���߿�
                    } else {
                        req.setAttribute("WorkData", "");
                        Logger.debug.println(this, "�Ǳٹ��ð� ��ȸ ����!!");
                    }
                } else {
                    // ���� �Ǳٷνð� ��Ȳ ��ȸ
                    rfcResultData = RfcHandler.execute("ZGHR_RFC_NTM_OT_REQ_RW_LIST", new HashMap<String, Object>() {
                        {
                            put("I_PERNR", PERNR);
                            put("I_DATUM", DATE);
                            put("I_EMPGUB", EMPGUB);
                        }
                    });
                    WebUtil.setAttributes(req, getSummaryData(rfcResultData, EMPGUB, g.getMessage("MSG.D.D01.0064", "1"))); // �繫��(����)/������(�ְ�) �Ǳٷνð� ��Ȳ �����͸� ��ȸ���� ���Ͽ����ϴ�.
                }
                // [WorkTime52] END

                dest = WebUtil.JspURL + "D/D01OT/D01OTBuild_KR.jsp";

                /*
                            } else if( jobid.equals("check") ) {

                D01OTData_vt   = new Vector();
                D01OTData data = new D01OTData();

                box.copyToEntity(data);
                DataUtil.fixNull(data);

                D01OTData_vt.addElement(data);  //������ Ŭ���̾�Ʈ�� �ǵ�����.

                String message  = "";

                //[CSR ID:2595636] �����Ͽ� �ް�&��� ���� ��û ��
                D16OTHDDupCheckRFC2 checkFunc = new D16OTHDDupCheckRFC2();
                Vector OTHDDupCheckData_new_vt = checkFunc.getChecResult( firstData.PERNR, UPMU_TYPE, data.WORK_DATE, data.WORK_DATE);
                String e_flag = OTHDDupCheckData_new_vt.get(0).toString();
                String e_message = OTHDDupCheckData_new_vt.get(1).toString();

                if( e_flag.equals("Y")){//Y�� �ߺ�, N�� OK
                	message = e_message;
                }else{
                    D01OTCheckRFC func = new D01OTCheckRFC();
                    Vector D01OTCheck_vt = func.check( firstData.PERNR, data.WORK_DATE, data.WORK_DATE, data.BEGUZ, data.ENDUZ );

                    // 2002.07.04. ��û�ð��� �ٹ������� �ߺ��Ǿ������ R3�� �ʰ��ٹ� ��û ������ �����ϱ����ؼ� ������.


                    D01OTCheckData checkData = (D01OTCheckData)D01OTCheck_vt.get(0);

                    if( !checkData.ERRORTEXTS.equals("") && checkData.STDAZ.equals("0") ) {        //�����޽����� �ְ�, �Ѱ������ �� �� ���� ���
                        message = "�ٹ������� �ߺ��Ǿ����ϴ�.";
                    } else if( checkData.ERRORTEXTS.equals("") ) {                                 //�����޽����� ����, �������̰ų� �Ѱ������ �� ���.
                        if( checkData.BEGUZ.equals(data.BEGUZ) && checkData.ENDUZ.equals(data.ENDUZ) ) {
                            message = "";
                        } else {
                            message = "�ٹ������� �ߺ��Ǿ� ��û�ð��� �����Ͽ����ϴ�.";
                            data.BEGUZ = checkData.BEGUZ;                                          //�Ѱ������ �ð������� �缳�����ش�.
                            data.ENDUZ = checkData.ENDUZ;
                            data.STDAZ = checkData.STDAZ;
                        }
                    }
                    // 2002.07.04. ��û�ð��� �ٹ������� �ߺ��Ǿ������ R3�� �ʰ��ٹ� ��û ������ �����ϱ����ؼ� ������.
                }

                //���������� �ǵ�����.
                Vector AppLineData_vt  = new Vector();
                int rowcount = box.getInt("RowCount");
                for( int i = 0; i < rowcount; i++) {
                    AppLineData appLine = new AppLineData();
                   // String      idx     = Integer.toString(i);

                    // ���� �̸����� ������ ������
                    box.copyToEntity(appLine ,i);

                    AppLineData_vt.addElement(appLine);
                }

                D16OTHDDupCheckRFC func2 = new D16OTHDDupCheckRFC();
                Vector OTHDDupCheckData_vt = func2.getCheckList( firstData.PERNR, UPMU_TYPE );

                req.setAttribute("message", message);
                req.setAttribute("jobid", jobid);
                req.setAttribute("D01OTData_vt",  D01OTData_vt);
                req.setAttribute("AppLineData_vt", AppLineData_vt);
                req.setAttribute("OTHDDupCheckData_vt", OTHDDupCheckData_vt);
                dest = WebUtil.JspURL+"D/D01OT/D01OTChange.jsp";
                */

                /*************************************************************************************/
            } else if (jobid.equals("change")) {
                Logger.debug.println(this, "change...");

                // ���� ���� �κ� /
                dest = changeApproval(req, box, D01OTData.class, rfc, new ChangeFunction<D01OTData>() {

                    public String porcess(D01OTData data, ApprovalHeader approvalHeader, Vector<ApprovalLineData> approvalLine) throws GeneralException {

                        Vector D01OTData_vt = new Vector();
                        box.copyToEntity(data);
                        DataUtil.fixNull(data);

                        data.PERNR	= PERNR;
                        data.ZPERNR = user.empNo;              // ��û�� ���(�븮��û, ���� ��û)
                        data.UNAME 	= user.empNo;              // ��û�� ���(�븮��û, ���� ��û)
                        data.AEDTM 	= DataUtil.getCurrentDate();  // ������(���糯¥)
                        D01OTData_vt.addElement(data);

                        D01OTCheckRFC func = new D01OTCheckRFC();
                        // RFC : ZGHR_RFC_IS_AVAIL_OVERTIME [worktime52 PJT:2018-07-10 I_NTM [X] �߰�]
                        Vector D01OTCheck_vt = func.check(firstData.PERNR, data.WORK_DATE, data.WORK_DATE, data.BEGUZ, data.ENDUZ, "X");

                        String message = "";
                        // C20140515_40601 �λ��������� 27,36: -�繫���ð�������(4H) 4�ð�üũ START
                        // C20140515_40601 �λ��������� 28,37: -�繫���ð�������(6H) 6�ð�üũ
                        // �ָ�/������ �ð������� �繫(27,28)/���(36.37) ����Ư���� 4, 6 �ð����� ����
                        Logger.debug.println(this, "phonenumdata.E_PERSK : " + phonenumdata.E_PERSK);
                        if (phonenumdata.E_PERSK.equals("27") || phonenumdata.E_PERSK.equals("28") || phonenumdata.E_PERSK.equals("36") || phonenumdata.E_PERSK.equals("37")) { //

                            // ������, ��,�ϸ� ����
                            D01OTHolidayCheckRFC funHc = new D01OTHolidayCheckRFC();
                            Vector D01OTHolidayCheck_vt = funHc.check("L1", data.WORK_DATE, data.WORK_DATE);
                            D01OTHolidayCheckData HolidaycheckData = (D01OTHolidayCheckData) D01OTHolidayCheck_vt.get(0);
                            if (HolidaycheckData.HOLIDAY.equals("X") || (HolidaycheckData.WEEKDAY.equals("6") || HolidaycheckData.WEEKDAY.equals("7"))) {
                                if ((phonenumdata.E_PERSK.equals("27") || phonenumdata.E_PERSK.equals("36")) && !data.STDAZ.equals("4")) {
                                    message = "�繫�� �ð�������(4H) ����� 4�ð��� ��û�����մϴ�.";
                                }
                                if ((phonenumdata.E_PERSK.equals("28") || phonenumdata.E_PERSK.equals("37")) && !data.STDAZ.equals("6")) {
                                    message = "�繫�� �ð�������(6H) ����� 6�ð��� ��û�����մϴ�.";
                                }
                            } else { // ����
                                if (phonenumdata.E_PERSK.equals("27") || phonenumdata.E_PERSK.equals("28")) { // �ð� ������

                                    message = message + "�繫�� �ð������� �����  ������, �����, �Ͽ��Ͽ��� �ʰ��ٹ� ��û�� �����մϴ�.";
                                }
                            }

                            Logger.debug.println(this, "HolidaycheckData : " + HolidaycheckData.toString());
                            Logger.debug.println(this, "[[message : " + message);
                        }
                        // C20140515_40601 �λ��������� 27: -�繫���ð�������(6H) ������ 6�ð�üũ END

                        // [CSR ID:2595636] �����Ͽ� �ް�&��� ���� ��û ��
                        D16OTHDDupCheckRFC2 checkFunc = new D16OTHDDupCheckRFC2();
                        Vector OTHDDupCheckData_new_vt = checkFunc.getChecResult(firstData.PERNR, UPMU_TYPE, data.WORK_DATE, data.WORK_DATE);
                        String e_flag = OTHDDupCheckData_new_vt.get(0).toString();
                        String e_message = OTHDDupCheckData_new_vt.get(1).toString();

                        if (e_flag.equals("Y")) {// Y�� �ߺ�, N�� OK
                            message = e_message;
                        } else {
                            // 2002.07.04. ��û�ð��� �ٹ������� �ߺ��Ǿ������ R3�� �ʰ��ٹ� ��û ������ �����ϱ����ؼ� ������.
                            D01OTCheckData checkData = (D01OTCheckData) D01OTCheck_vt.get(0);

                            if (!checkData.ERRORTEXTS.equals("") && checkData.STDAZ.equals("0")) {        // �����޽����� �ְ�, �Ѱ������ �� �� ���� ���
                                message = message + " �ٹ������� �ߺ��Ǿ����ϴ�. �ٽ� ��û���ֽʽÿ�.";
                            } else if (checkData.ERRORTEXTS.equals("")) {                                 // �����޽����� ����, �������̰ų� �Ѱ������ �� ���.
                                if (checkData.BEGUZ.equals(data.BEGUZ) && checkData.ENDUZ.equals(data.ENDUZ)) {
                                    message = message + "";
                                } else {
                                    message = message + " �ٹ������� �ߺ��Ǿ� ��û�ð��� �����Ͽ����ϴ�.";
                                    data.BEGUZ = checkData.BEGUZ;                                          // �Ѱ������ �ð������� �缳�����ش�.
                                    data.ENDUZ = checkData.ENDUZ;
                                    data.STDAZ = checkData.STDAZ;
                                }
                            }
                            // 2002.07.04. ��û�ð��� �ٹ������� �ߺ��Ǿ������ R3�� �ʰ��ٹ� ��û ������ �����ϱ����ؼ� ������.
                        }

                        // [CSR ID:2803878] ��û �ʰ��ٹ� ��ûȭ�� 1�� 12�ð� üũ
                        D02KongsuHourRFC rfcH = new D02KongsuHourRFC();
                        String yymm = DataUtil.getCurrentYear() + DataUtil.getCurrentMonth();
                        // 'C' = ��Ȳ, 'R' = ��û,'M' = ����, 'G' = ����
                        Vector submitData_vt = rfcH.getOvtmHour(firstData.PERNR, yymm, "M", data);
                        String PRECHECK = rfcH.getOvtmHour(firstData.PERNR, yymm, data.WORK_DATE, "");// ���ϱ��� üũ�� �������� ���� Ȯ��(N�̸� üũ�ϸ� �ȵ�)
                        detailApporval(req, res, rfc);
                        req.setAttribute("isUpdate", true); // [����]��� ���� ���� <- �����ʿ��� �ݵ�� �ʿ���

                        // [WorkTime52]��� ���� ��ȸ(�繫��:A,C / ������:B,D)
                        Map<String, Object> rfcResultData = RfcHandler.execute("ZGHR_RFC_NTM_GET_EMPGUB", new HashMap<String, Object>() {
                            {
                                put("I_PERNR", PERNR);
                            }
                        });

                        final String EMPGUB = ObjectUtils.toString(getData(rfcResultData, "EXPORT", g.getMessage("MSG.D.D01.0063")).get("E_EMPGUB"));
                        final String TPGUB  = ObjectUtils.toString(getData(rfcResultData, "EXPORT", g.getMessage("MSG.D.D01.0063")).get("E_TPGUB"));
                        final String I_DATE = data.WORK_DATE;

                        D01OTRealWrokListRFC realworkfunc = new D01OTRealWrokListRFC();
                        if (EMPGUB.equals("S")) {
                            String MODE = "";
                            final D01OTRealWorkDATA WorkData = realworkfunc.getResult(EMPGUB, PERNR, I_DATE, data.VTKEN, ainf_seqn, MODE);
                            if (realworkfunc.getReturn().isSuccess()) {
                                req.setAttribute("WorkData", WorkData); // ���߿�
                            } else {
                                req.setAttribute("WorkData", "");
                                Logger.debug.println(this, "�Ǳٹ��ð� ��ȸ ����!!");
                            }
                        } else {
                            // ���� �Ǳٷνð� ��Ȳ ��ȸ
                            rfcResultData = RfcHandler.execute("ZGHR_RFC_NTM_OT_REQ_RW_LIST", new HashMap<String, Object>() {
                                {
                                    put("I_PERNR", PERNR);
                                    put("I_DATUM", I_DATE);
                                    put("I_EMPGUB", EMPGUB);
                                }
                            });
                            WebUtil.setAttributes(req, getSummaryData(rfcResultData, EMPGUB, g.getMessage("MSG.D.D01.0064", "1"))); // �繫��(����)/������(�ְ�) �Ǳٷνð� ��Ȳ �����͸� ��ȸ���� ���Ͽ����ϴ�.
                        }
                        // [WorkTime52]

                        if (StringUtils.isBlank(message)) {
                            Logger.debug.println(this, "check Add RFC ����");
                            // RFC : ZGHR_RFC_NTM_OT_AVAL_CHK_ADD [2018-07-10 AINF_SEQN �߰�]
                            D01OTCheckDataAdd ChkData = new D01OTCheckDataAdd();
                            ChkData.PERNR = data.PERNR;
                            ChkData.AINF_SEQN = data.AINF_SEQN;	//Add
                            ChkData.BEGDA = data.WORK_DATE;
                            ChkData.WORK_DATE = data.WORK_DATE;
                            ChkData.VTKEN = data.VTKEN;
                            ChkData.BEGUZ = data.BEGUZ;
                            ChkData.ENDUZ = data.ENDUZ;
                            ChkData.STDAZ = data.STDAZ;
                            ChkData.ZPERNR = data.ZPERNR;

                            Vector ChkDataAdd_vt = new Vector();
                            ChkDataAdd_vt.addElement(ChkData);

                            // RFC : ZGHR_RFC_NTM_OT_AVAL_CHK_ADD
                            D01OTCheckAddRFC chkaddFunc = new D01OTCheckAddRFC();
                            chkaddFunc.check(ChkDataAdd_vt);

                            message = StringUtils.defaultString(chkaddFunc.getReturn().MSGTX);

                            Logger.debug.println(this, " Add Check chkaddFunc.getReturn().MSGTX >> " + message);
                        }

                        if (StringUtils.isNotBlank(message)) { // ����������

                            D16OTHDDupCheckRFC func2 = new D16OTHDDupCheckRFC();
                            Vector OTHDDupCheckData_vt = func2.getCheckList(firstData.PERNR, UPMU_TYPE, user.area);

                            Logger.debug.println(this, "������������1");
                            req.setAttribute("msg2", message);
                            req.setAttribute("message", message);
                            req.setAttribute("jobid", jobid);
                            req.setAttribute("D01OTData_vt", D01OTData_vt);
                            req.setAttribute("OTHDDupCheckData_vt", OTHDDupCheckData_vt);
                            req.setAttribute("approvalLine", approvalLine); // ����� �������
                            req.setAttribute("committed", "Y");

                            // [WorkTime52]
                            req.setAttribute("EMPGUB", EMPGUB);
                            req.setAttribute("TPGUB", TPGUB);
                            req.setAttribute("DATUM", data.WORK_DATE);
                            // [WorkTime52]

                            String url = WebUtil.JspURL + "D/D01OT/D01OTBuild_KR.jsp";

                            printJspPage(req, res, url);

                            return null;

                            // [CSR ID:2803878] ��û �� �ʰ��ٹ� ��û���� alert
                        } else if (!data.OVTM12YN.equals("N") || (PRECHECK.equals("N") && data.VTKEN.equals("X"))) { // confirm �� message �߰�

                            D16OTHDDupCheckRFC func2 = new D16OTHDDupCheckRFC();
                            Vector OTHDDupCheckData_vt = func2.getCheckList(user.empNo, UPMU_TYPE, user.area);

                            Logger.debug.println(this, "������������2");
                            Logger.debug.println(this, "Change DATUM : " + data.WORK_DATE + "  /   " + EMPGUB);
                            req.setAttribute("jobid", jobid);
                            req.setAttribute("D01OTData_vt", D01OTData_vt);
                            req.setAttribute("submitData_vt", submitData_vt);
                            req.setAttribute("PRECHECK", PRECHECK);
                            req.setAttribute("OTHDDupCheckData_vt", OTHDDupCheckData_vt);
                            // getApprovalInfo(req, PERNR); //<-- �ݵ�� �߰�

                            req.setAttribute("approvalLine", approvalLine); // ����� �������
                            req.setAttribute("committed", "Y");

                            // [WorkTime52]
                            req.setAttribute("EMPGUB", EMPGUB);
                            req.setAttribute("TPGUB", TPGUB);
                            req.setAttribute("DATUM", data.WORK_DATE);

                            // [WorkTime52]

                            String url = WebUtil.JspURL + "D/D01OT/D01OTBuild_KR.jsp";

                            printJspPage(req, res, url);

                            return null;
                        }

                        /*************************************************************************************/
                        // * ���� ��û RFC ȣ�� * /
                        rfc.setChangeInput(user.empNo, UPMU_TYPE, approvalHeader.AINF_SEQN);

                        Logger.debug("-------- AINF_SEQN " + data.AINF_SEQN);

                        // changeRFC.build(firstData.PERNR, Utils.asVector(data), box, req);//ainf_seqn, bankflag,
                        rfc.change(ainf_seqn, firstData.PERNR, D01OTData_vt, box, req);

                        if (!rfc.getReturn().isSuccess()) {
                            req.setAttribute("msg", rfc.getReturn().MSGTX);   // ���� �޼��� ó�� - �ӽ�
                            return null;
                        }

                        return data.AINF_SEQN;
                        // * ������ �ۼ� �κ� �� */
                    }
                });

                /*

                Vector AppLineData_vt = new Vector();
                D01OTData data      = new D01OTData();
                D01OTData_vt = new Vector();

                box.copyToEntity(data);
                DataUtil.fixNull(data);

                data.PERNR     = firstData.PERNR;
                data.AINF_SEQN = ainf_seqn;
                data.ZPERNR    = firstData.ZPERNR;        // ��û�� ���(�븮��û, ���� ��û)
                data.UNAME     = user.empNo;              // ��û�� ���(�븮��û, ���� ��û)
                data.AEDTM     = DataUtil.getCurrentDate();  // ������(���糯¥)


                    Logger.debug.println(this, "��������");
                    int rowcount = box.getInt("RowCount");
                    for( int i = 0; i < rowcount; i++ ) {
                        AppLineData appLine = new AppLineData();
                        String      idx     = Integer.toString(i);

                        // ���� �̸����� ������ ������
                        box.copyToEntity(appLine ,i);

                        appLine.APPL_MANDT     = user.clientNo;
                        appLine.APPL_BUKRS     = user.companyCode;
                        appLine.APPL_PERNR     = firstData.PERNR;
                        appLine.APPL_BEGDA     = data.BEGDA;
                        appLine.APPL_AINF_SEQN = ainf_seqn;
                        appLine.APPL_UPMU_TYPE = UPMU_TYPE;

                        AppLineData_vt.addElement(appLine);
                    }
                    Logger.debug.println(this, AppLineData_vt.toString());

                    con = DBUtil.getTransaction();
                    AppLineDB appDB = new AppLineDB(con);

                    String msg;
                    String msg2 = null;

                    if( appDB.canUpdate((AppLineData)AppLineData_vt.get(0)) ) {

                        // ���� ������ ����Ʈ
                        Vector orgAppLineData_vt = AppUtil.getAppChangeVt(ainf_seqn);

                        appDB.change(AppLineData_vt);
                        rfc.change( ainf_seqn, firstData.PERNR, D01OTData_vt );
                        con.commit();

                        msg = "msg002";

                        AppLineData oldAppLine = (AppLineData) orgAppLineData_vt.get(0);
                        AppLineData newAppLine = (AppLineData) AppLineData_vt.get(0);

                        Logger.debug.println(this ,oldAppLine);
                        Logger.debug.println(this ,newAppLine);

                        if (!newAppLine.APPL_APPU_NUMB.equals(oldAppLine.APPL_PERNR)) {

                            // ������ ����� �� ������ ,ElOffice ���� ���̽�
                            phonenumdata = (PersonData)numfunc.getPersonInfo(firstData.PERNR);

                            // �̸��� ������
                            Properties ptMailBody = new Properties();
                            ptMailBody.setProperty("SServer",user.SServer);             // ElOffice ���� ����
                            ptMailBody.setProperty("from_empNo" ,user.empNo);           // �� �߼��� ���
                            ptMailBody.setProperty("to_empNo" ,oldAppLine.APPL_PERNR);  // �� ������ ���

                            ptMailBody.setProperty("ename" ,phonenumdata.E_ENAME);      // (��)��û�ڸ�
                            ptMailBody.setProperty("empno" ,phonenumdata.E_PERNR);      // (��)��û�� ���

                            ptMailBody.setProperty("UPMU_NAME" ,"�ʰ��ٹ�");            // ���� �̸�
                            ptMailBody.setProperty("AINF_SEQN" ,ainf_seqn);             // ��û�� ����

                            // �� ����
                            StringBuffer sbSubject = new StringBuffer(512);

                            sbSubject.append("[" + ptMailBody.getProperty("UPMU_NAME") + "] ");
                            sbSubject.append( ptMailBody.getProperty("ename") + "���� ��û�� �����ϼ̽��ϴ�.");
                            ptMailBody.setProperty("subject" ,sbSubject.toString());

                            ptMailBody.setProperty("FileName" ,"NoticeMail5.html");

                            MailSendToEloffic   maTe = new MailSendToEloffic(ptMailBody);
                            // ���� ������ �� ����
                            if (!maTe.process()) {
                                msg2 = msg2 + " ���� " + maTe.getMessage();
                            } // end if

                            // �� ����
                            sbSubject = new StringBuffer(512);
                            sbSubject.append("[" + ptMailBody.getProperty("UPMU_NAME") + "] ");
                            sbSubject.append(ptMailBody.getProperty("ename") +"���� ��û�ϼ̽��ϴ�.");

                            ptMailBody.setProperty("subject" ,sbSubject.toString());
                            ptMailBody.remove("FileName");
                            ptMailBody.setProperty("to_empNo" ,newAppLine.APPL_APPU_NUMB);

                            maTe = new MailSendToEloffic(ptMailBody);
                            // �ű� ������ �� ����
                            if (!maTe.process()) {
                                msg2 = msg2 +" \\n ��û " + maTe.getMessage();
                            } // end if

                            // ElOffice �������̽�
                            try {
                                DraftDocForEloffice ddfe = new DraftDocForEloffice();
                                ElofficInterfaceData eof = ddfe.makeDocForChange(ainf_seqn ,user.SServer , phonenumdata.E_PERNR, ptMailBody.getProperty("UPMU_NAME") , oldAppLine.APPL_PERNR);
                                Vector vcElofficInterfaceData = new Vector();
                                vcElofficInterfaceData.add(eof);

                                ElofficInterfaceData eofD = ddfe.makeDocContents(ainf_seqn ,user.SServer,ptMailBody.getProperty("UPMU_NAME"));
                                vcElofficInterfaceData.add(eofD);

                                req.setAttribute("vcElofficInterfaceData", vcElofficInterfaceData);
                                dest = WebUtil.JspURL+"common/ElOfficeInterface.jsp";
                            } catch (Exception e) {
                                dest = WebUtil.JspURL+"common/msg.jsp";
                                msg2 = msg2 + "\\n" + " Eloffic ���� ����" ;
                            } // end try
                        } else {
                            msg = "msg002";
                            dest = WebUtil.JspURL+"common/msg.jsp";
                        } // end if
                    } else {
                        msg = "msg005";
                        dest = WebUtil.JspURL+"common/msg.jsp";
                    } // end if

                    String url = "location.href = '" + WebUtil.ServletURL+"hris.D.D01OT.D01OTDetailSV?AINF_SEQN="+ainf_seqn+"" +
                    "&RequestPageName=" + RequestPageName + "';";
                    req.setAttribute("msg", msg);
                    req.setAttribute("msg2", msg2);
                    req.setAttribute("url", url);
                }
                */
            } else {
                throw new BusinessException(g.getMessage("MSG.COMMON.0016"));// "���θ��(jobid)�� �ùٸ��� �ʽ��ϴ�.");
            }
            Logger.debug.println(this, "destributed = " + dest);
            if (req.getAttribute("committed").equals("N")) {
                printJspPage(req, res, dest);
            }

        } catch (Exception e) {
            throw new GeneralException(e);
        } finally {
            // DBUtil.close(con);
            // try{ con.close(); } catch(Exception e){
            // Logger.err.println(e, e);
            // }
        }
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
