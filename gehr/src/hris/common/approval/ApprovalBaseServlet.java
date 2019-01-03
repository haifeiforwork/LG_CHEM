/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR ����                                                  */
/*   2Depth Name  : �ڰݸ�����                                                */
/*   Program Name : �ڰݸ����� ��û                                           */
/*   Program ID   : D30MembershipFeeBuildSV                                           */
/*   Description  : �ڰ������㸦 ��û�� �� �ֵ��� �ϴ� Class                    */
/*   Note         :                                                             */
/*   Creation     : 2002-01-11  �ֿ�ȣ                                          */
/*   Update       : 2005-02-15  ������                                          */
/*   Update       : 2005-02-23  �����                                          */
/*   Update		  :  2017-05-15 eunha [CSR ID:3377091] �߱� �λ�ý��� �ݷ� �� ���� ����  */
/*   Upadate	  :  2017-06-29 eunha [CSR ID:3420113] �λ�ý��� ��û �� ���� ���� UI ǥ���۾�*/
/*
 * [�ѱ� ��û �߰����̺�]
01	ZHRA002T	HR ������ ��û
02	ZHRA005T	HR ���� - ���ο���
03	ZHRA006T	HR ���� - �Ƿ��
04	ZHRA007T	HR ���� - ���հ���
05	ZHRA008T	�������ϱ�/���ڱ�/���б�
06	ZHRA008T	�������ϱ�/���ڱ�/���б�
07	ZHRA013T	���� ����, �ξ簡�� ����
08	ZHRA021T	���� ������û
09	ZHRA002T	HR ������ ��û
10	ZHRA011T	�����
11	ZHRA009T	���ǰ��µ��
12	ZHRA014T	���ñ���/����
13	ZHRA015T	�����ڱ� ��ȯ��û
14	ZHRA018T	�ڰݸ��� ��û
16	ZHRA017T	�������� ��û
17	ZHRA022T	�ʰ��ٹ� ���̺�
18	ZHRA024T	�ް� ��û
19	ZHRA019T	������(����, Ż��)
20	ZHRA025T	�ǰ����� �Ǻξ��� �ڰ�(���/���)
21	ZHRA026T	�ǰ������� ���� ��߱� ��û ���̺�
22	ZHRA027T	���ο��� �ڰݺ������ ��û TABLE
23	ZHRA023T	�Ĵ���� ���̺�
24	ZHRA013T	���� ����, �ξ簡�� ����
26	ZHRA005T	HR ���� - ���ο���
27	ZHRA019T	������(����, Ż��)
28	ZHRA029T	�ٷμҵ� �� ���ټ� ��õĪ�� ����
29	ZHRA030T	���� ���� ��ǽ�û
34	ZHRA036T	���������û
35	ZHRA037T	����/���� ��û
36	ZHRA111T	�μ����ϱ��� ��û
37	ZHRA039T	�������� ��ҽ�û
38	ZHRA039T	�������� ��ҽ�û
39	ZHRA007T	HR ���� - ���հ���
40	ZHRA040T	�ʰ��ٹ� ������� ��û
41	ZHRA040T	�ް� ������� ��û


[�ؿ� ��û �߰����̺�]
01	ZHR0045T	Overtime
02	ZHR0046T	Absence Application
021	ZHR0046T	Absence Application
022	ZHR0046T	Absence Application
023	ZHR0046T	Absence Application
03	ZHR0044T	Bank Acount
04	ZHR0043T	License
05	ZHR0036T	Internal Certificate
06	ZHR0037T	Celebration or Condolence
07	ZHR0150T	Duty Allowance
08	ZHR0150T	Duty Allowance_Day Duty
11	ZHR0038T	Medical Fee
12	ZHR0039T	Tuition Fee
13	ZHR0040T	Language Fee
14	ZHR0234T	Address
15	ZHR0237T	Time Sheet
16	ZHR0241T	Contract Extension
17	ZGHR3001TPayments&Deduction
18	ZGHR3001TMembership Fees
 */
/********************************************************************************/

package hris.common.approval;

import com.common.Utils;
import com.google.common.base.Predicate;
import com.google.common.collect.Collections2;
import com.sns.jdf.ConfigurationException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPType;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;
import hris.G.ApprovalReturnState;
import hris.G.rfc.ApprovalHeaderRFC;
import hris.G.rfc.G001ApprovalProcessRFC;
import hris.common.*;
import hris.common.rfc.PersonInfoRFC;
import org.apache.commons.lang.StringUtils;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.Arrays;
import java.util.Collection;
import java.util.Properties;
import java.util.Vector;

public abstract class ApprovalBaseServlet extends EHRBaseServlet {

    public static String APPROVAL_IMPORT = "APPROVAL_IMPORT";

    /**
     * ���� ����
     *
     * @return ��������
     */
    protected abstract String getUPMU_TYPE();

    /**
     * ��������
     *
     * @return ��������
     */
    protected abstract String getUPMU_NAME();


    /**
     * 01		HR ������ ��û		ZHRA002T
     02		HR ���� - ���ο���		ZHRA005T
     03		HR ���� - �Ƿ��		ZHRA006T
     04		HR ���� - ���հ���		ZHRA007T
     05		�������ϱ�/���ڱ�/���б�		ZHRA008T
     06		�������ϱ�/���ڱ�/���б�		ZHRA008T
     07		���� ����, �ξ簡�� ����		ZHRA013T
     08		���� ������û		ZHRA021T
     09		HR ������ ��û		ZHRA002T
     10		�����		ZHRA011T
     11		���ǰ��µ��		ZHRA009T
     12		���ñ���/����		ZHRA014T
     13		�����ڱ� ��ȯ��û		ZHRA015T
     14		�ڰݸ��� ��û		ZHRA018T
     16		�������� ��û		ZHRA017T
     17		�ʰ��ٹ� ���̺�		ZHRA022T
     18		�ް� ��û		ZHRA024T
     19		������(����, Ż��)		ZHRA019T
     20		�ǰ����� �Ǻξ��� �ڰ�(���/���)		ZHRA025T
     21		�ǰ������� ���� ��߱� ��û ���̺�		ZHRA026T
     22		���ο��� �ڰݺ������ ��û TABLE		ZHRA027T
     23		�Ĵ���� ���̺�		ZHRA023T
     24		���� ����, �ξ簡�� ����		ZHRA013T
     26		HR ���� - ���ο���		ZHRA005T
     27		������(����, Ż��)		ZHRA019T
     28		�ٷμҵ� �� ���ټ� ��õĪ�� ����		ZHRA029T
     29		���� ���� ��ǽ�û		ZHRA030T
     34		���������û		ZHRA036T
     35		����/���� ��û		ZHRA037T
     36		�μ����ϱ��� ��û		ZHRA111T
     37		���� ��ҽ�û		ZHRA039T
     38		���� ��ҽ�û		ZHRA039T
     40		�ʰ��ٹ� ������� ��û		ZHRA040T
     41		�ް� ������� ��û		ZHRA040T

     ELoffice ���� ����
     * @return
     */
    protected boolean isEloffice() {

        if(g.getSapType() == SAPType.LOCAL) {

            /* ���� ���� �� eloffice ���� ���� [�ѱ�] : ���հ���, �̿����հ���, �߰��ϰ���  */
            if(Arrays.asList("04", "39").contains(getUPMU_TYPE())) {
                return false;
            }
        }


        return true;
    }

    /**
     * interface ���� callback �� ���� ����ϱ� ���� �������
     * @param <T>
     */
    public interface RequestFunction<T> {
        /**
         * �Ѿ�� ���� RFC ȣ�� �����ȣ�� ���� �Ѵ�
         *
         * @param inputData ȭ�鿡�� �ѿ��� ��û ��û�� �� Entity T_RESULT�� ��ϵǴ� ��
         * @return �����ȣ
         */
        String porcess(T inputData, Vector<ApprovalLineData> approvalLine) throws GeneralException;
    }

    public interface ChangeFunction<T> {
        /**
         * ������ ���
         * @param inputData
         * @param approvalHeader
         * @param approvalLineDatas
         * @return
         * @throws GeneralException
         */
        String porcess(T inputData, ApprovalHeader approvalHeader, Vector<ApprovalLineData> approvalLineDatas) throws GeneralException;
    }

    public interface DeleteFunction {
        boolean porcess() throws GeneralException;
    }

    public interface ApprovalFunction<T> {
        boolean porcess(T inputData, ApprovalHeader approvalHeader, Vector<ApprovalLineData> approvalLineDatas) throws GeneralException;
    }


    /**
     * ���� ��� ���� �� ������������� request�� ����
     * �������� ����
     * @param req
     * @param PERNR
     * @return
     * @throws GeneralException
     */
    protected boolean getApprovalInfo(HttpServletRequest req, String PERNR) throws GeneralException {
        ApprovalLineInput approvalLineInput = new ApprovalLineInput();
        approvalLineInput.I_UPMU_TYPE = getUPMU_TYPE();
        approvalLineInput.I_PERNR = PERNR;

        req.setAttribute("viewSource", "true");

        return getApprovalInfo(req, PERNR, approvalLineInput);
    }
    protected boolean getApprovalInfo(HttpServletRequest req, String PERNR, String DATUM) throws GeneralException {
        ApprovalLineInput approvalLineInput = new ApprovalLineInput();
        approvalLineInput.I_UPMU_TYPE = getUPMU_TYPE();
        approvalLineInput.I_PERNR = PERNR;
        approvalLineInput.I_DATUM = DATUM;

        return getApprovalInfo(req, PERNR, approvalLineInput);
    }
    protected boolean getApprovalInfo(HttpServletRequest req, String PERNR, ApprovalLineInput approvalLineInput) throws GeneralException {
        PersonInfoRFC personInfoRFC = new PersonInfoRFC();
        ApprovalHeader approvalHeader = personInfoRFC.getApprovalHeader(PERNR);
        approvalHeader.setUPMU_TYPE(getUPMU_TYPE());
        approvalHeader.setUPMU_NAME(getUPMU_NAME());

        approvalHeader.setRQDAT(DataUtil.getCurrentDate(req));
        // header ����
        req.setAttribute("approvalHeader", approvalHeader);

        //���� ����Ʈ ��ȸ
        req.setAttribute("approvalLine", getApprovalLine(approvalLineInput));

        return true;
    }

    /**
     * ��������� �����´�
     * @param approvalLineInput
     * @return
     * @throws GeneralException
     */
    protected Vector<ApprovalLineData> getApprovalLine(ApprovalLineInput approvalLineInput) throws GeneralException {
        ApprovalLineRFC approvalLineRFC = new ApprovalLineRFC();
        return approvalLineRFC.getApprovalLine(approvalLineInput);
    }

    /**
     * ���� ������� �������� �κ� - ���簡���� ��츸
     * @param approvalHeader
     * @param approvalLine
     * @return
     */
    protected Vector<ApprovalLineData> getCurrentApprovalLine(ApprovalHeader approvalHeader, Vector<ApprovalLineData> approvalLine) {

        if(Utils.getSize(approvalLine) > 0 && "X".equals(approvalHeader.ACCPFL)) {
            for(ApprovalLineData row : approvalLine) {
                if(StringUtils.isBlank(row.APPR_STAT)) {
                    return Utils.asVector(row);
                }
            }
        }

        return null;

    }

    /**
     * ��û ����
     * @param req
     * @param box
     * @param requestFunction
     * @param <T>
     * @return
     * @throws GeneralException
     */
    protected <T> String requestApproval(HttpServletRequest req, Box box, RequestFunction<T> requestFunction) throws GeneralException {
        return requestApproval(req, box, null, requestFunction);
    }

    /**
     * ��û ����
     * @param req request
     * @param box Box
     * @param klass request���� �Ѿ�� ������ ���� Entity Class
     * @param requestFunction ��û�� ó���� ���� interface ����ü callback ó�� Ȱ��
     * @param <T>
     * @return ��û ó�� �� ��� ������
     * @throws GeneralException
     */
    protected <T> String requestApproval(HttpServletRequest req, Box box, Class<T> klass, RequestFunction<T> requestFunction) throws GeneralException {
        String dest = WebUtil.JspURL + "common/msg.jsp";
        try {
            String PERNR = getPERNR(box, WebUtil.getSessionUser(req));

            WebUserData user = WebUtil.getSessionUser(req);

            /*ApprovalHeader ���·� ����� ���� ��ȸ*/
            PersonInfoRFC personInfoRFC = new PersonInfoRFC();
            ApprovalHeader approvalHeader = personInfoRFC.getApprovalHeader(PERNR);

            /* ������ ���� ���� �Ϻ� ���� */
            Vector<ApprovalLineData> approvalLine = box.getVector(ApprovalLineData.class, "APPLINE_");
            for(ApprovalLineData row : approvalLine) {
                row.APPU_NUMB = row.getAPPU_NUMB(); /* ��� ��ȣȭ �Ǿ��� ��� decrypt*/
            }

            /* ��������� ���� ��� check*/
            if(Utils.getSize(approvalLine) == 0) throw new GeneralException(g.getMessage("MSG.APPROVAL.0001")); //������ ������ �����ϴ�.

            //@����༺ ������ ������ ���� üũ 2015-08-25-------------------------------------------------------
            ApprovalLineRFC approvalLineRFC = new ApprovalLineRFC();
            String UPMU_TYPE = getUPMU_TYPE();
            UPMU_TYPE = UPMU_TYPE.equals("41") ? "18" : UPMU_TYPE;  // �ް���Ұ�������� ��� �ް���û�� �����ϰ� ó��-ksc
            Vector<ApprovalLineData> approvalLineDefault = approvalLineRFC.getApprovalLine(UPMU_TYPE, PERNR);

            if(!"16".equals(UPMU_TYPE)) {
                if (!checkApprovalLine(approvalLine, approvalLineDefault)) {
                    throw new GeneralException("msg020");
                }
            }
//          @����༺ ������ ������ ���� üũ ��-------------------------------------------------------

            /* ������ �ۼ� �κ� ���� */
            T inputData = klass == null ? null : box.createEntity(klass);

            Utils.setFieldValue(inputData, "ZPERNR", user.empNo);   //��û�� ��� ����(�븮��û ,���� ��û)
            Utils.setFieldValue(inputData, "UNAME", user.empNo);    //��û�� ��� ����(�븮��û ,���� ��û)
            Utils.setFieldValue(inputData, "AEDTM", DataUtil.getCurrentDate(req));   // ������(���糯¥) - �����ð�

            /* ������ �ۼ� �κ� ���� */
            String AINF_SEQN = requestFunction.porcess(inputData, approvalLine); //null �� �׽�Ʈ ���غ� -> ������ new Object();
            /* ������ �ۼ� �κ� �� */

            /* ���� �� ó�� ���� - AINF_SEQN ���� NULL �� ��� */
            if(AINF_SEQN == null) throw new GeneralException(g.getMessage("MSG.APPROVAL.REQUEST.FAIL"));

            /* �����ȣ�� approvalHeader�� ����*/
            approvalHeader.AINF_SEQN = AINF_SEQN;

            String msg = "msg001";  //��û�Ǿ����ϴ�.

            /* ���� ���� �⺻ ���� */
            Properties ptMailBody = new Properties();
            ptMailBody.setProperty("FileName", g.getSapType().isLocal() ? "NoticeMail1.html" : "NoticeMail1_GLOBAL.html");


         // [CSR ID:3420113] �λ�ý��� ��û �� ���� ���� UI ǥ���۾�  2017-06-29 eunha start
            /* ���� �߼� */
           /* String msg2 = sendMail(user, user.empNo, Utils.indexOf(approvalLine, 0).APPU_NUMB, approvalHeader,
                    g.getMessage("MSG.APPROVAL.0002", approvalHeader.ENAME), ptMailBody); //{0}���� ��û�ϼ̽��ϴ�.
            */

            String msg2 = sendMail(user, user.empNo, Utils.indexOf(approvalLine, 0).APPU_NUMB, approvalHeader,
                    g.getMessage("MSG.APPROVAL.0002", getUPMU_NAME()), ptMailBody); //[HR] �����û ({0})
         // [CSR ID:3420113] �λ�ý��� ��û �� ���� ���� UI ǥ���۾�  2017-06-29 eunha end

            /* ���հ��� ���� */
            if(isEloffice()) {
                try {
                    DraftDocForEloffice ddfe = new DraftDocForEloffice();

                    ElofficInterfaceData eof = ddfe.makeDocContents(AINF_SEQN, user.SServer, getUPMU_NAME());

                    Vector vcElofficInterfaceData = new Vector();
                    vcElofficInterfaceData.add(eof);
                    req.setAttribute("vcElofficInterfaceData", vcElofficInterfaceData);
                    dest = WebUtil.JspURL + "common/ElOfficeInterface.jsp";
                } catch (Exception e) {
                    msg2 = msg2 + "\\n" + " Eloffic fail";
                } // end try
            }
            /* ���� �߼� �κ� �� */

            // [WorkTime52]
            // ESS_OFW_WORK_TIME(�ٹ� �ð� �Է�) �޴����� popup button�� ���� ȣ��� ���� ��û ȭ���� ��� ���� ��û �Ϸ� �� popup�� �ݾ� �ش�.
            if ("Y".equals(box.getString("FROM_ESS_OFW_WORK_TIME"))) {
                req.setAttribute("url", "top.window.close()");
            } else {
                req.setAttribute("url", getDetailPage(req, approvalHeader, true, true));
            }

            req.setAttribute("msg", msg);
            req.setAttribute("msg2", msg2);

        } catch (GeneralException e) {
        	String UPMU_TYPE = getUPMU_TYPE();
        	req.setAttribute("msg", e.getMessage());
        	if("18".equals(UPMU_TYPE)) {
        		StringBuffer sb = new StringBuffer();
        		sb.append("location.href = '")
	                .append(WebUtil.ServletURL+"hris.D.D03Vocation.D03VocationBuildSV")
	                .append("';");
        		req.setAttribute("url", sb.toString());
        	} else {
        		req.setAttribute("url", "history.back();");
        	}
        	
        } catch (Exception e) {
            Logger.debug.println(e.toString());
        	req.setAttribute("msg", g.getMessage("MSG.APPROVAL.REQUEST.FAIL")); //���� �Ƿ� �����Ͽ����ϴ�.

            req.setAttribute("url", "history.back();");
        }

        return dest;
    }

    protected <T, V extends ApprovalSAPWrap> String changeApproval(HttpServletRequest req, Box box, Class<T> klass,
                                                                   V approvalRFC, ChangeFunction<T> changeFunction) throws GeneralException {
        T inputData = null;
        try {
            inputData = klass.newInstance();
        } catch (Exception e) {
            Logger.error(e);
        }

        return changeApproval(req, box, inputData, approvalRFC, changeFunction);
    }


    /**
     * ���� ����
     * @param box Box
     * @param inputData ���� �Է��� ��� ����Ÿ
     * @param approvalRFC ApprovalSAPWrap �� ��ӹ��� ����ȸ�� ����� RFC
     * @param changeFunction ������ ���� interface
     * @param <T>
     * @param <V>
     * @return ��� ������
     * @throws GeneralException
     */
    protected <T, V extends ApprovalSAPWrap> String changeApproval(HttpServletRequest req, Box box, T inputData,
                                                                   V approvalRFC, ChangeFunction<T> changeFunction) throws GeneralException {
        String dest = WebUtil.JspURL + "common/msg.jsp";
        try {
            WebUserData user = WebUtil.getSessionUser(req);

            /* ����ȸ���� ApprovalHeader ��ȸ */
            ApprovalHeader approvalHeader = approvalRFC.getApprovalHeader();

            /* ������ ���� ���� �Ϻ� ���� */
            Vector<ApprovalLineData> approvalLine = box.getVector(ApprovalLineData.class, "APPLINE_");
            for(ApprovalLineData row : approvalLine) {
                row.APPU_NUMB = row.getAPPU_NUMB(); /* ��� ��ȣȭ �Ǿ��� ��� decrypt*/
            }

            if(Utils.getSize(approvalLine) == 0) throw new GeneralException(g.getMessage("MSG.APPROVAL.0001")); //������ ������ �����ϴ�.

             /* ���� ���� ���� Ȯ�� */
            /*if(!"X".equals(approvalHeader.MODFL)) {
                req.setAttribute("msg", g.getMessage("MSG.APPROVAL.UPDATE.DISABLE"));   //���� ������ ������ ���°� �ƴմϴ�.
                return dest;
            }*/

            /* RFC ���� ó�� ���� */
            /*
            for(ApprovalLineData approvalLineData : approvalLine) {
//                approvalLineData.PERNR     = approvalHeader.PERNR;
//                approvalLineData.BEGDA     = tempData.BEGDA;
            }
            */

            /*
            // �������� �������� ������
            ApprovalLineRFC approvalLineRFC = new ApprovalLineRFC();
            Vector<ApprovalLineData> approvalLineDefault = approvalLineRFC.getApprovalLine(getUPMU_TYPE(), PERNR);

            //@����༺ ������ ������ ���� üũ 2015-08-25-------------------------------------------------------
            if(!checkApprovalLine(approvalLine, approvalLineDefault)) {
                moveMsgPage(req, res, "msg020", "history.back();"); //���� caution.jsp
                return dest;
            }
//          @����༺ ������ ������ ���� üũ ��-------------------------------------------------------
            */

            /* ���� ���絥��Ÿ �� ������ �ٽ� ���� */
            box.copyToEntity(inputData);

            Utils.setFieldValue(inputData, "PERNR", approvalHeader.ITPNR);     //��û�� ��� ����(�븮��û ,���� ��û) - ����� ���
            Utils.setFieldValue(inputData, "ZPERNR", approvalHeader.RQPNR);   //��û�� ��� ����(�븮��û ,���� ��û) - �α��� ���
            Utils.setFieldValue(inputData, "UNAME", user.empNo);    //��û�� ��� ����(�븮��û ,���� ��û)
            Utils.setFieldValue(inputData, "AEDTM", DataUtil.getCurrentDate(req));   // ������(���糯¥) - �����ð�
            Utils.setFieldValue(inputData, "AINF_SEQN", approvalHeader.AINF_SEQN);   //���� ���� ��ȣ


            if ("X".equals(approvalHeader.MODFL)) {
                throw new GeneralException(g.getMessage("MSG.APPROVAL.UPDATE.DISABLE"));
            }

            /* ������ �ۼ� �κ� ���� */
            String AINF_SEQN = changeFunction.porcess(inputData, approvalHeader, approvalLine); //null �� �׽�Ʈ ���غ� -> ������ new Object();
            /* ������ �ۼ� �κ� �� */

            if(AINF_SEQN == null) {
                throw new GeneralException(g.getMessage("MSG.APPROVAL.UPDATE.FAIL"));   // ������ ���� �Ͽ����ϴ�.
            }

            String msg = "msg002";  //�����Ǿ����ϴ�.
            String msg2 = "";

            Vector<ApprovalLineData> oldAppLine = approvalRFC.getApprovalLine();
            ApprovalLineData oldAppLineFirst = Utils.indexOf(oldAppLine, 0);
            ApprovalLineData approvalLineFirst = Utils.indexOf(approvalLine, 0);

            /* ������� 1������ ���� ������ΰ� �������� ���� ��� ���� �߼� �� ���ڰ��� �ݿ�  */
            if (!StringUtils.equals(oldAppLineFirst.APPU_NUMB, approvalLineFirst.APPU_NUMB)) {

                Properties ptMailBody = new Properties();
                //ptMailBody.setProperty("FileName", "NoticeMail5.html"); //�������� ���� ����
             // [CSR ID:3420113] �λ�ý��� ��û �� ���� ���� UI ǥ���۾�  2017-06-29 eunha start
                /*String deleteMsg = sendMail(user, user.empNo, oldAppLineFirst.APPU_NUMB, approvalHeader,
                        g.getMessage("MSG.APPROVAL.0003", approvalHeader.ENAME), ptMailBody);   //+ "���� ��û�� �����ϼ̽��ϴ�."*/
                String deleteMsg = sendMail(user, user.empNo, oldAppLineFirst.APPU_NUMB, approvalHeader,
                        g.getMessage("MSG.APPROVAL.0003", getUPMU_NAME()), ptMailBody);
             // [CSR ID:3420113] �λ�ý��� ��û �� ���� ���� UI ǥ���۾�  2017-06-29 eunha send
                if (StringUtils.isNotBlank(deleteMsg)) msg2 = g.getMessage("BUTTON.COMMON.DELETE") + " " + deleteMsg;

                // [CSR ID:3420113] �λ�ý��� ��û �� ���� ���� UI ǥ���۾�  2017-06-29 eunha start
                /* ���� �߼� */
               /* String sendMsg = sendMail(user, user.empNo, approvalLineFirst.APPU_NUMB, approvalHeader,
                        g.getMessage("MSG.APPROVAL.0002", approvalHeader.ENAME), null);*/

                String sendMsg = sendMail(user, user.empNo, approvalLineFirst.APPU_NUMB, approvalHeader,
                        g.getMessage("MSG.APPROVAL.0002", getUPMU_NAME()), null);
              /// [CSR ID:3420113] �λ�ý��� ��û �� ���� ���� UI ǥ���۾�  2017-06-29 eunha end

                if (StringUtils.isNotBlank(sendMsg)) msg2 = "\\n " + g.getMessage("BUTTON.COMMON.REQUEST") + " " + sendMsg;

            /* ���հ��� */
                if(isEloffice()) {
                    try {
                        DraftDocForEloffice ddfe = new DraftDocForEloffice();
                        ElofficInterfaceData eof = ddfe.makeDocForChange(AINF_SEQN, user.SServer, approvalHeader.PERNR, getUPMU_NAME(), oldAppLineFirst.PERNR);
                        Vector vcElofficInterfaceData = new Vector();
                        vcElofficInterfaceData.add(eof);

                        ElofficInterfaceData eofD = ddfe.makeDocContents(AINF_SEQN, user.SServer, getUPMU_NAME());
                        vcElofficInterfaceData.add(eofD);

                        req.setAttribute("vcElofficInterfaceData", vcElofficInterfaceData);
                        dest = WebUtil.JspURL + "common/ElOfficeInterface.jsp";
                    } catch (Exception e) {
                        msg2 = msg2 + "\\n" + " Eloffic fail";
                    } // end try
                }
            /* ���� �߼� �κ� �� */
            }

             /* ��û �� msg ó�� �� �̵� ������ ���� - ���� ó��*/
            req.setAttribute("url", getDetailPage(req, approvalHeader, false, false));

            req.setAttribute("msg", msg);
            req.setAttribute("msg2", msg2);

        } catch (GeneralException e) {
        	req.setAttribute("msg", e.getMessage());
    		req.setAttribute("url", "history.back();");
        } catch (Exception e) {
            req.setAttribute("msg", g.getMessage("MSG.APPROVAL.UPDATE.FAIL"));
            req.setAttribute("url", "history.back();");
        }

        return dest;
    }

    /**
     * ���� �� ��û�� ���� �̵��� �������� - ���������� ����
     * @param req
     * @param approvalHeader
     * @param isMoveMenu
     * @param isRequest
     * @return
     */
    private String getDetailPage(HttpServletRequest req, ApprovalHeader approvalHeader, boolean isMoveMenu, boolean isRequest) {
        StringBuffer sb = new StringBuffer();
        StringBuffer sburl = new StringBuffer();

        String I_APGUB = req.getParameter("I_APGUB");

        String url = "hris.G.G002ApprovalIngDetailSV";

        String menuCode = "ESS_APP_ING_DOC";

        /* MSS ������ �޴��� �̵��� �������� */
        if(!g.getSapType().isLocal() && "16".equals(getUPMU_TYPE())) menuCode = "MSS_APP_ING_DOC";

        /* ��.. ING, FINISH, DOC */
        if("1".equals(I_APGUB)) {
            url = "hris.G.G000ApprovalDetailSV";
            menuCode = "ESS_APP_TO_DO_DOC";
        } else if("3".equals(I_APGUB)) {
            url = "hris.G.G003ApprovalFinishDetailSV";
            menuCode = "ESS_APP_VED_DOC";
        }


        /* URL �ۼ� */
        sburl.append(WebUtil.ServletURL).append(url)
            .append("?AINF_SEQN=").append(approvalHeader.AINF_SEQN)
            .append("&UPMU_TYPE=").append(getUPMU_TYPE());

        if(isRequest) sburl.append("&afterRequest=true");

        /* ���� ��û ������(�ڷΰ���� �̵��� ������) �� ������ ��� ������ ����*/
        try {
            if(StringUtils.isNotBlank(g.getRequestPageName(req)))
                sburl.append("&RequestPageName=").append(URLEncoder.encode(g.getRequestPageName(req), "UTF-8"));
        } catch (UnsupportedEncodingException e) {
            Logger.error(e);
        }

        if(isMoveMenu) {
        /* �޴��̵� */
            sb.append("moveMenu(")
                    .append("'").append(menuCode).append("'")
                    .append(",")
                    .append("'").append(sburl).append("'")
                    .append(");");
        } else {
        /* URL ������ �̵�  */
            sb.append("location.href = '")
                    .append(sburl)
                    .append("';");
        }

        Logger.debug("------ move url ------ " + sb);

        return sb.toString();
    }

    /**
     * ���� ����
     * @param req request
     * @param box BOx
     * @param approvalRFC ApprovalSAPWrap �� ��ӹ��� ����ȸ�� ����� RFC
     * @param deleteFunction ������ ���� interface
     * @param <V>
     * @return
     * @throws GeneralException
     */
    protected <V extends ApprovalSAPWrap> String deleteApproval(HttpServletRequest req, Box box,
                                                                V approvalRFC, DeleteFunction deleteFunction) throws GeneralException {

        String dest = WebUtil.JspURL + "common/msg.jsp";
        try {
            WebUserData user = WebUtil.getSessionUser(req);

            /*ApporvalHeader ��ȸ*/
            ApprovalHeader approvalHeader = approvalRFC.getApprovalHeader();

            if ("X".equals(approvalHeader.CANCFL)) {
                throw new GeneralException(g.getMessage("MSG.APPROVAL.CANCEL.DISABLE"));  //���� ��Ұ� ������ ���°� �ƴմϴ�.
            }

            /* ������ �ۼ� �κ� ���� */
            if(!deleteFunction.porcess()) throw new GeneralException(g.getMessage("MSG.APPROVAL.CANCEL.FAIL")); //"��ҿ� ���� �Ͽ����ϴ�."
            /* ������ �ۼ� �κ� �� */


            String msg = "msg003";  //�����Ǿ����ϴ�.
            String msg2 = "";

            /* ������� ù��° ����ڿ��� ���� �߼� ���հ��� ���� ó�� */
            ApprovalLineData oldAppLineFirst = Utils.indexOf(approvalRFC.getApprovalLine(), 0);

            if(oldAppLineFirst != null) {

                Properties ptMailBody = new Properties();
                ptMailBody.setProperty("FileName", g.getSapType().isLocal() ? "NoticeMail5.html" : "NoticeMail5_GLOBAL.html");
                // [CSR ID:3420113] �λ�ý��� ��û �� ���� ���� UI ǥ���۾�  2017-06-29 eunha start
                /*String deleteMsg = sendMail(user, user.empNo, oldAppLineFirst.APPU_NUMB, approvalHeader,
                        g.getMessage("MSG.APPROVAL.0003", approvalHeader.ENAME), ptMailBody);   //+ "���� ��û�� �����ϼ̽��ϴ�."*/

                String deleteMsg = sendMail(user, user.empNo, oldAppLineFirst.APPU_NUMB, approvalHeader,
                		g.getMessage("MSG.APPROVAL.0003", getUPMU_NAME()), ptMailBody);

             // [CSR ID:3420113] �λ�ý��� ��û �� ���� ���� UI ǥ���۾�  2017-06-29 eunha end

                if (StringUtils.isNotBlank(deleteMsg)) msg2 = " delete " + deleteMsg;

                if(isEloffice()) {
                    try {
                        DraftDocForEloffice ddfe = new DraftDocForEloffice();
                        ElofficInterfaceData eof = ddfe.makeDocForRemove(approvalHeader.AINF_SEQN, user.SServer, getUPMU_NAME()
                                , approvalHeader.PERNR, oldAppLineFirst.APPU_NUMB);

                        Vector vcElofficInterfaceData = new Vector();
                        vcElofficInterfaceData.add(eof);
                        req.setAttribute("vcElofficInterfaceData", vcElofficInterfaceData);
                        dest = WebUtil.JspURL + "common/ElOfficeInterface.jsp";

                    } catch (Exception e) {
                        msg2 = msg2 + "\\n" + " Eloffic fail";
                    } // end try
                }

            }

            String url = "location.href = '" + g.getRequestPageName(req) + "';";
            req.setAttribute("url", url);

            req.setAttribute("msg", msg);
            req.setAttribute("msg2", msg2);

        } catch (GeneralException e) {
            req.setAttribute("msg", e.getMessage());
            req.setAttribute("url", "history.back();");
        } catch (Exception e) {
            req.setAttribute("msg", g.getMessage("MSG.APPROVAL.CANCEL.FAIL"));  //"��ҿ� ���� �Ͽ����ϴ�."
            req.setAttribute("url", "history.back();");
        }
        return dest;
    }

    /**
     * ���� �ݷ� ����
     * @param req
     * @param box
     * @param detailImportTableName ���ν� ��ϵ� table��
     * @param detailData    ���ν� ��� ����Ÿ
     * @param approvalRFC ApprovalSAPWrap �� ��ӹ��� ����ȸ�� ����� RFC
     * @param approvalFunction interface
     * @param isAccept ����/�ݷ� ����
     * @param <T>
     * @param <V>
     * @return ��� ������
     * @throws GeneralException
     */
    protected <T, V extends ApprovalSAPWrap> String approval(HttpServletRequest req, Box box, String detailImportTableName, T detailData,
                                                                   V approvalRFC, ApprovalFunction<T> approvalFunction, boolean isAccept) throws GeneralException {

        String dest = WebUtil.JspURL + "common/msg.jsp";
        String msg = g.getMessage("MSG.APPROVAL." + (isAccept ? "ACCEPT" : "REJECT") + ".FAIL");
        String msg2 = "";

        try{
            WebUserData user = WebUtil.getSessionUser(req);

            ApprovalHeader approvalHeader = approvalRFC.getApprovalHeader();
            Vector<ApprovalLineData> approvalLine = approvalRFC.getApprovalLine();

            /* ���� ���� ���� Ȯ�� */
            if(!"X".equals(approvalHeader.ACCPFL)) {
                req.setAttribute("msg", g.getMessage("MSG.APPROVAL." + (isAccept ? "ACCEPT" : "REJECT") + ".DISABLE"));   //"���� ������ ���°� �ƴմϴ�."
                return dest;
            }

            if(approvalFunction != null) {
                /* ������ ���� ���� */
                if(!approvalFunction.porcess(detailData, approvalHeader, approvalLine)) {
                    return dest;
                }
                /* ������ ���� �� */
            }

                    /* ���� / �ݷ� ���� */
            ApprovalLineData approvalCurrent = null;

                /* ���� ������ �������� */
            for(ApprovalLineData approvalLineData : approvalLine) {
                if(StringUtils.isBlank(approvalLineData.APPR_STAT)) {
                    approvalCurrent = approvalLineData;
                    break;
                }
            }

                /* ����/�ݷ� �� ���� ���� ���� */
            AppLineData appLine        = new AppLineData();

            appLine.APPL_BUKRS = user.companyCode;
            appLine.APPL_PERNR = approvalHeader.PERNR;
            appLine.APPL_BEGDA = Utils.getFieldValue(detailData, "BEGDA", box.get("BEGDA"));
            appLine.APPL_AINF_SEQN = approvalHeader.AINF_SEQN;
            appLine.APPL_APPU_TYPE = approvalCurrent.APPU_TYPE;
            appLine.APPL_APPR_SEQN = approvalCurrent.APPR_SEQN;
            appLine.APPL_APPU_NUMB = user.empNo;
            appLine.APPL_APPR_STAT = box.getString("APPR_STAT");
            appLine.APPL_BIGO_TEXT = box.getString("BIGO_TEXT");
//            appLine.APPL_CMMNT = box.getString("BIGO_TEXT");  //���� �ǰ�
            appLine.APPL_APPR_DATE = DataUtil.getCurrentDate(req);
            appLine.APPL_APPR_TIME = DataUtil.getDate(req);

            /* ���� �⺻ ���̺� �� �߰� ���̺��� ���� �� ��� - box.put(APPROVAL_IMPORT, ApprovalImport) ���*/
            G001ApprovalProcessRFC approvalProcessRFC = new G001ApprovalProcessRFC();
            ApprovalImport approvalImport = (ApprovalImport) box.getObject(APPROVAL_IMPORT);

            if(approvalImport != null) {
                approvalProcessRFC.setApprovalImport(approvalImport);
            }

            /* ���� �ݷ� RFC ó�� */
            ApprovalReturnState approvalReturn = approvalProcessRFC.setApproval(Utils.asVector(appLine), detailImportTableName, Utils.asVector(detailData));

            msg = isAccept ? "msg009" : "msg010";

            if(!approvalReturn.isSuccess()) throw new GeneralException(approvalReturn.E_MESSAGE);

            /* �� ������ ���� ������Ƽ */
            Properties ptMailBody = new Properties();
            ptMailBody.setProperty("UPMU_NAME", getUPMU_NAME());

            // �� ����
            StringBuffer sbSubject = new StringBuffer(512);

            String to_empNo = approvalHeader.PERNR;

            try {
                if (isAccept) {
            /* ������ ��� ���� ������ ���� Ȯ�� �� ���� ���� */
                    for (int i = 0; i < approvalLine.size(); i++) {
                        ApprovalLineData tempAppLine = approvalLine.get(i);

                        if (tempAppLine.APPU_TYPE.equals(approvalCurrent.APPU_TYPE) && tempAppLine.APPR_SEQN.equals(approvalCurrent.APPR_SEQN)) {
                            if (i == approvalLine.size() - 1) {
                                // ������ ������
                                ptMailBody.setProperty("FileName", g.getSapType().isLocal() ? "NoticeMail2.html" : "NoticeMail2_GLOBAL.html");
                                // [CSR ID:3420113] �λ�ý��� ��û �� ���� ���� UI ǥ���۾�  2017-06-29 eunha start
                                //[HR] ����Ϸ� �뺸(������)
                                sbSubject.append(g.getMessage("MSG.APPROVAL.0004",  getUPMU_NAME()));
                             // [CSR ID:3420113] �λ�ý��� ��û �� ���� ���� UI ǥ���۾�  2017-06-29 eunha end
                            } else {
                                // ���� ������
                                tempAppLine = approvalLine.get(i + 1);
                                to_empNo = tempAppLine.APPU_NUMB;
                                //{0}���� ���縦 ��û �ϼ̽��ϴ�.
                                ptMailBody.setProperty("FileName", g.getSapType().isLocal() ? "NoticeMail1.html" : "NoticeMail1_GLOBAL.html");
                             // [CSR ID:3420113] �λ�ý��� ��û �� ���� ���� UI ǥ���۾�  2017-06-29 eunha start
                                //sbSubject.append(g.getMessage("MSG.APPROVAL.0005", user.ename));
                                sbSubject.append(g.getMessage("MSG.APPROVAL.0005",  getUPMU_NAME()));
                             // [CSR ID:3420113] �λ�ý��� ��û �� ���� ���� UI ǥ���۾�  2017-06-29 eunha end
                                break;
                            } // end if
                        }
                    } // end for
                } else {
            /* �ݷ��� ��� */
            /* ���������� 02 �� ������ �� 2���� �̻��� ���簡 �ݷ� �� ��� 02�� ù���� ���������� ���� �߼� - ������ ��츸 */
                    if(g.getSapType().isLocal()) {
                        if ("02".equals(approvalCurrent.APPU_TYPE) && Integer.parseInt(approvalCurrent.APPR_SEQN) > 1) {
                            for (int i = 0; i < approvalLine.size(); i++) {
                                ApprovalLineData tempAppLine = approvalLine.get(i);
                                if (tempAppLine.APPU_TYPE.equals("02") && tempAppLine.APPR_SEQN.equals("01")) {
                                    tempAppLine = approvalLine.get(i);
                                    to_empNo = tempAppLine.APPU_NUMB;
                                } // end if
                            } // end for
                        } // end if
                    }

                    ptMailBody.setProperty("FileName", g.getSapType().isLocal() ? "NoticeMail3.html" : "NoticeMail3_GLOBAL.html");
                    // [CSR ID:3420113] �λ�ý��� ��û �� ���� ���� UI ǥ���۾�  2017-06-29 eunha start
                    //[HR] ����ݷ� �뺸(������)
                    //{0}���� {1}�� �ݷ� �ϼ̽��ϴ�.
                    //sbSubject.append(g.getMessage("MSG.APPROVAL.0006", user.ename, getUPMU_NAME()));
                    sbSubject.append(g.getMessage("MSG.APPROVAL.0006", getUPMU_NAME()));
                 // [CSR ID:3420113] �λ�ý��� ��û �� ���� ���� UI ǥ���۾�  2017-06-29 eunha end
                }

                String sendMsg = sendMail(user, user.empNo, to_empNo, approvalHeader, sbSubject.toString(), ptMailBody);


                if (StringUtils.isNotBlank(sendMsg)) msg2 = sendMsg + "\\n";
            } catch (Exception e) {
                msg2 = g.getMessage("COMMON.APPROVAL.MAIL.FAIL") ;
            }

            /* ���� ���� ���� */
            if(isEloffice()) {
                try {
                    DraftDocForEloffice ddfe = new DraftDocForEloffice();
                    ElofficInterfaceData eof;
                    Vector vcElofficInterfaceData = new Vector();
                    if (!approvalCurrent.APPU_NUMB.equals(user.empNo)) {
                        //����÷��� ������ ���� �׽�ũ�� ������ �ִ� �����ڰ� �����Ҷ� ó��:���� ���ڰ��翡 ���ִ� DATA�� ������ �ٽ� ó��
                        ElofficInterfaceData eofD = ddfe.makeDocForDelete(approvalHeader.AINF_SEQN, user.SServer, approvalHeader.PERNR, ptMailBody.getProperty("UPMU_NAME"), approvalCurrent.APPU_NUMB);
                        vcElofficInterfaceData.add(eofD);
                        ElofficInterfaceData eofI = ddfe.makeDocForInsert(approvalHeader.AINF_SEQN, user.SServer, approvalHeader.PERNR, ptMailBody.getProperty("UPMU_NAME"));
                        vcElofficInterfaceData.add(eofI);
                    }
//                    if (appLine.APPL_APPR_STAT.equals("A")) {
                /* ���� �� ?*/
                    if (isAccept) {
                        eof = ddfe.makeDocContents(approvalHeader.AINF_SEQN, user.SServer, ptMailBody.getProperty("UPMU_NAME"));
                    } else {
                        //[CSR ID:3377091] �߱� �λ�ý��� �ݷ� �� ���� ����
                    	//if (approvalCurrent.APPU_TYPE.equals("02") && Integer.parseInt(approvalCurrent.APPR_SEQN) > 1) {
                    	if (g.getSapType().isLocal() && approvalCurrent.APPU_TYPE.equals("02") && Integer.parseInt(approvalCurrent.APPR_SEQN) > 1) {
                            eof = ddfe.makeDocForMangerReject(approvalHeader.AINF_SEQN, user.SServer, ptMailBody.getProperty("UPMU_NAME"), approvalLine);
                        /* ���� ���� �ݷ� �� ��� */
                            //eof.R_EMP_NO = DataUtil.fixEndZero( user.empNo ,8);  /* �ݷ� ��û�ڴ� ���� �α��� ��� - �̼۷����� Ȯ�� �� �߰�����  */ //???? �߰� �ؾ� �Ǵ°ǰ�?
                        } else {
                            int nRejectLength = 0;

                            for (int i = approvalLine.size() - 1; i >= 0; i--) {
                                ApprovalLineData tempAppLine = approvalLine.get(i);
                                if (tempAppLine.APPU_TYPE.equals(approvalCurrent.APPU_TYPE) && tempAppLine.APPR_SEQN.equals(approvalCurrent.APPU_TYPE)) {
                                    nRejectLength = i + 1;
                                    break;
                                } // end if
                            } // end for

                            String approvers[] = new String[nRejectLength];
                            for (int i = 0; i < approvers.length; i++) {
                                ApprovalLineData tempAppLine = approvalLine.get(i);
                                approvers[i] = tempAppLine.APPU_NUMB;
                            } // end for
                            if (!approvalCurrent.APPU_NUMB.equals(user.empNo)) {
                                approvers[approvers.length - 1] = user.empNo; //ESB ���� ����
                            }
                            eof = ddfe.makeDocForReject(approvalHeader.AINF_SEQN, user.SServer, ptMailBody.getProperty("UPMU_NAME"), approvalHeader.PERNR, approvers);

                            eof.R_EMP_NO = DataUtil.fixEndZero(user.empNo, 8);  /* �ݷ� ��û�ڴ� ���� �α��� ��� - �̼۷����� Ȯ�� �� �߰�����  */
                        } // end if

                    /*
                    1�� 00202350
                    2�� 00219665
                    3�� 00202350
                    �� ���
                    R_EMP_NO - A_EMP_NO
                1�� 00202350 - 00219665   R
                2�� 00219665 - 00202350  M
                3�� 00202350  - �ǹ̾���C�ݷ�, F����

                     */
                    } // end if
                    vcElofficInterfaceData.add(eof);
                    req.setAttribute("vcElofficInterfaceData", vcElofficInterfaceData);
                    dest = WebUtil.JspURL + "common/ElOfficeInterface.jsp";
                } catch (Exception e) {
                    Logger.error(e);
                    msg2 = msg2 + " Eloffic fail";
                } // end try
            }

            String url = "location.href = \"" + g.getRequestPageName(req) + "\";";
            req.setAttribute("url", url);
            req.setAttribute("msg", msg);

        } catch (GeneralException e) {
            Logger.error(e);
            req.setAttribute("msg", e.getMessage());
            req.setAttribute("url", "history.back();");
        } catch (Exception e) {
            Logger.error(e);
            req.setAttribute("msg", g.getMessage("MSG.APPROVAL." + (isAccept ? "ACCEPT" : "REJECT") + ".FAIL"));  //���翡 ���� �Ͽ����ϴ�.
            req.setAttribute("url", "history.back();");
        }

        return dest;
    }

    /**
     * ���ν�
     * @param req
     * @param box
     * @param detailImportTableName
     * @param detailData
     * @param approvalRFC
     * @param approvalFunction
     * @param <T>
     * @param <V>
     * @return
     * @throws GeneralException
     */
    protected <T, V extends ApprovalSAPWrap> String accept(HttpServletRequest req, Box box, String detailImportTableName, T detailData,
                                                             V approvalRFC, ApprovalFunction<T> approvalFunction) throws GeneralException {
        return approval(req, box, detailImportTableName, detailData, approvalRFC, approvalFunction, true);
    }

    /**
     * �ݷ���
     * @param req
     * @param box
     * @param detailImportTableName
     * @param detailData
     * @param approvalRFC
     * @param approvalFunction
     * @param <T>
     * @param <V>
     * @return
     * @throws GeneralException
     */
    protected <T, V extends ApprovalSAPWrap> String reject(HttpServletRequest req, Box box, String detailImportTableName, T detailData,
                                                           V approvalRFC, ApprovalFunction<T> approvalFunction) throws GeneralException {
        return approval(req, box, detailImportTableName, detailData, approvalRFC, approvalFunction, false);
    }

    protected <T, V extends ApprovalSAPWrap> String cancel(HttpServletRequest req, Box box, String detailImportTableName, T detailData,
                                                           V approvalRFC, ApprovalFunction<T> approvalFunction) throws GeneralException {
        String dest = WebUtil.JspURL + "common/msg.jsp";
        String msg = g.getMessage("MSG.APPROVAL.CANCEL.FAIL");
        String msg2 = "";

        try{
            WebUserData user = WebUtil.getSessionUser(req);

            ApprovalHeaderRFC approvalHeaderRFC = new ApprovalHeaderRFC();

            ApprovalHeader approvalHeader = approvalRFC.getApprovalHeader();
            Vector<ApprovalLineData> approvalLine = approvalRFC.getApprovalLine();


            ApprovalHeader cancelHeader = approvalHeaderRFC.getApprovalHeader(approvalHeader.AINF_SEQN, user.empNo, "2");

            /* ���� ���� ���� Ȯ�� */
            if(!"X".equals(cancelHeader.CANCFL)) {
                req.setAttribute("msg", g.getMessage("MSG.APPROVAL.CANCEL.DISABLE"));   //"��� ������ ���°� �ƴմϴ�."
                return dest;
            }

            if(approvalFunction != null) {
                /* ������ ���� ���� */
                if(!approvalFunction.porcess(detailData, approvalHeader, approvalLine)) {
                    return dest;
                }
                /* ������ ���� �� */
            }

                    /* ���� / �ݷ� ���� */
            ApprovalLineData approvalCurrent = null;

                /* ������ ������ �������� */
            for(ApprovalLineData approvalLineData : approvalLine) {
                if(StringUtils.isBlank(approvalLineData.APPR_STAT)) {
                    break;
                }
                approvalCurrent = approvalLineData;
            }

                /* ����/�ݷ� �� ���� ���� ���� */
            AppLineData appLine        = new AppLineData();

            appLine.APPL_BUKRS = user.companyCode;
            appLine.APPL_PERNR = approvalHeader.PERNR;
            appLine.APPL_BEGDA = Utils.getFieldValue(detailData, "BEGDA", box.get("BEGDA"));
            appLine.APPL_AINF_SEQN = approvalHeader.AINF_SEQN;
            appLine.APPL_APPU_TYPE = approvalCurrent.APPU_TYPE;
            appLine.APPL_APPR_SEQN = approvalCurrent.APPR_SEQN;
            appLine.APPL_APPU_NUMB = user.empNo;
            appLine.APPL_APPR_STAT = box.getString("APPR_STAT");
            appLine.APPL_BIGO_TEXT = "";    //box.getString("BIGO_TEXT");
//            appLine.APPL_CMMNT = box.getString("BIGO_TEXT");  //���� �ǰ�
            appLine.APPL_APPR_DATE = null;  //DataUtil.getCurrentDate(req);
            appLine.APPL_APPR_TIME = null;  //DataUtil.getDate(req);

            G001ApprovalProcessRFC approvalProcessRFC = new G001ApprovalProcessRFC();
            ApprovalImport approvalImport = (ApprovalImport) box.getObject(APPROVAL_IMPORT);

            if(approvalImport != null) {
                approvalProcessRFC.setApprovalImport(approvalImport);
            }

            ApprovalReturnState approvalReturn = approvalProcessRFC.setApproval(Utils.asVector(appLine), detailImportTableName, Utils.asVector(detailData));

            msg = "msg011";

            if(!approvalReturn.isSuccess()) throw new GeneralException(approvalReturn.E_MESSAGE);

            Properties ptMailBody = new Properties();
            ptMailBody.setProperty("UPMU_NAME", getUPMU_NAME());

            // �� ����
            StringBuffer sbSubject = new StringBuffer(512);

            String to_empNo = approvalHeader.PERNR;

            try {
                ptMailBody.setProperty("FileName" ,"NoticeMail5.html");

                msg = "msg011";

                for (int i = 0; i < approvalLine.size(); i++) {
                    ApprovalLineData tempAppLine = approvalLine.get(i);

                    if (tempAppLine.APPU_TYPE.equals(approvalCurrent.APPU_TYPE) && tempAppLine.APPR_SEQN.equals(approvalCurrent.APPR_SEQN)) {
                        // ���� ������
                        tempAppLine = approvalLine.get(i + 1);
                        to_empNo = tempAppLine.APPU_NUMB;
                        //{0}���� ���縦 ��û �ϼ̽��ϴ�.
                     // [CSR ID:3420113] �λ�ý��� ��û �� ���� ���� UI ǥ���۾�  2017-06-29 eunha start
                        //sbSubject.append(g.getMessage("MSG.APPROVAL.0005", user.ename));
                        sbSubject.append(g.getMessage("MSG.APPROVAL.0005", getUPMU_NAME()));
                     // [CSR ID:3420113] �λ�ý��� ��û �� ���� ���� UI ǥ���۾�  2017-06-29 eunha end
                        break;
                    }
                } // end for

                sbSubject.append("���� �ϼ̽��ϴ�.");

                ptMailBody.setProperty("to_empNo" ,to_empNo);                   // �� ������ ���
                ptMailBody.setProperty("subject"  ,sbSubject.toString());       // �� ���� ����

                String sendMsg = sendMail(user, user.empNo, to_empNo, approvalHeader, sbSubject.toString(), ptMailBody);

                if (StringUtils.isNotBlank(sendMsg)) msg2 = sendMsg + "\\n";

                try {
                    DraftDocForEloffice ddfe = new DraftDocForEloffice();

                    ElofficInterfaceData eof = ddfe.makeDocForCancel(approvalHeader.AINF_SEQN ,user.SServer,ptMailBody.getProperty("UPMU_NAME") ,to_empNo);

                    Vector vcElofficInterfaceData = new Vector();
                    vcElofficInterfaceData.add(eof);
                    req.setAttribute("vcElofficInterfaceData", vcElofficInterfaceData);
                    dest = WebUtil.JspURL+"common/ElOfficeInterface.jsp";
                } catch (Exception e) {
                    dest = WebUtil.JspURL+"common/msg.jsp";
                    msg2 = msg2 +  " Eloffic ���� ���� " ;
                } // end try
                if (StringUtils.isNotBlank(sendMsg)) msg2 = sendMsg + "\\n";
            } catch (Exception e) {
                msg2 = g.getMessage("COMMON.APPROVAL.MAIL.FAIL") ;
            }

            String url = "location.href = \"" + g.getRequestPageName(req) + "\";";
            req.setAttribute("url", url);
            req.setAttribute("msg", msg);

        } catch (GeneralException e) {
            Logger.error(e);
            req.setAttribute("msg", e.getMessage());
            req.setAttribute("url", "history.back();");
        } catch (Exception e) {
            Logger.error(e);
            req.setAttribute("msg", g.getMessage("MSG.APPROVAL.CANCEL.FAIL"));  //���翡 ���� �Ͽ����ϴ�.
            req.setAttribute("url", "history.back();");
        }

        return dest;

    }


    /**
     * ���� ���� ���������� ���� �Ұ����� ������� ���� üũ
     *
     * @param approvalLine
     * @param approvalLineDefault
     * @return
     */
    private boolean checkApprovalLine(Vector<ApprovalLineData> approvalLine, Vector<ApprovalLineData> approvalLineDefault) {
        for (final ApprovalLineData row : approvalLineDefault) {
            if ("01".equals(row.APPU_TYPE)) continue;

            //���� APPR_SEQN APPU_TYPE �� ���� PERNR �� �����ϴ��� Ȯ�� �Ѵ�. 1 row ���� ����
            Collection<ApprovalLineData> changeList = Collections2.filter(approvalLine, new Predicate<ApprovalLineData>() {
                public boolean apply(ApprovalLineData approvalLineData) {
                    return StringUtils.equals(row.APPR_SEQN, approvalLineData.APPR_SEQN) && StringUtils.equals(row.APPU_TYPE, approvalLineData.APPU_TYPE) &&
                            StringUtils.equals(row.APPU_NUMB, approvalLineData.APPU_NUMB);
                }
            });

            if (Utils.getSize(changeList) != 1) {
                return false;
            }
        }
        return true;
    }

    protected String sendMail(WebUserData user, String sender, String receiver, ApprovalHeader approvalHeader, String subjectSuffix, Properties ptMailBody) throws ConfigurationException {

        String returnMsg = "";

         /* ���� �߼� �κ� ���� */
        if (ptMailBody == null) ptMailBody = new Properties();

        ptMailBody.setProperty("SServer", user.SServer);              // ElOffice ���� ����
        ptMailBody.setProperty("from_empNo", sender);            // �� �߼��� ���
        ptMailBody.setProperty("to_empNo", receiver);  // �� ������ ���

        ptMailBody.setProperty("ename", approvalHeader.ENAME);       // (��)��û�ڸ�
        ptMailBody.setProperty("empno", approvalHeader.PERNR);       // (��)��û�� ���

        ptMailBody.setProperty("UPMU_NAME", getUPMU_NAME());              // ���� �̸�
        ptMailBody.setProperty("AINF_SEQN", approvalHeader.AINF_SEQN);
        ptMailBody.setProperty("USER_AREA", user.area.toString());
        // ��û�� ����
        //�� ����
        StringBuffer sbSubject = new StringBuffer(512);

        // [CSR ID:3420113] �λ�ý��� ��û �� ���� ���� UI ǥ���۾�  2017-06-29 eunha start
        //sbSubject.append("[" + getUPMU_NAME() + "] ");
      /// [CSR ID:3420113] �λ�ý��� ��û �� ���� ���� UI ǥ���۾�  2017-06-29 eunha end
        sbSubject.append(subjectSuffix);

        ptMailBody.setProperty("subject", sbSubject.toString());

        MailSendToEloffic maTe = new MailSendToEloffic(ptMailBody);

        if (!maTe.process()) {
            returnMsg = maTe.getMessage();
        }

        return returnMsg;
    }

    /**
     * �� ����
     *
     * @param request           HttpServletRequest
     * @param response          HttpServletResponse
     * @param approvalRFC       ApprovalSAPWrap �� ��� ���� RFC
     * @param <T>
     * @throws GeneralException
     */
    protected <T extends ApprovalSAPWrap> boolean detailApporval(HttpServletRequest request, HttpServletResponse response,
                                                                 T approvalRFC) throws GeneralException {

        ApprovalHeader approvalHeader = approvalRFC.getApprovalHeader();  //���
        Vector<ApprovalLineData> approvalLine = approvalRFC.getApprovalLine();    //�������

            /* ������ ��ȸ ���� Ȯ�� */
        if (approvalHeader==null) {
            //�ش� �������� ������ �����ϴ�.
			moveMsgPage(request, response, g.getMessage("MSG.COMMON.0060"), "document.location.href='" + g.getRequestPageName(request) + "'");
			return false;
		}

        if (!"X".equals(approvalHeader.DISPFL)) {
                            //�ش� �������� ������ �����ϴ�.
            moveMsgPage(request, response, g.getMessage("MSG.COMMON.0060"), "document.location.href='" + g.getRequestPageName(request) + "'");
            return false;
        }

        /* width �� */
       // if ("X".equals(approvalHeader.ACCPFL) && WebUtil.isDev(request)) {
        //if ("true".equals(request.getSession().getAttribute("mail"))) {
        //	request.setAttribute("buttonWidth", "width:740px;");
         //   request.setAttribute("bodyWidth", "width:760px");
         //   request.setAttribute("subWrappwidth", "min-width:760px");
        //}

        request.setAttribute("approvalHeader", approvalHeader);
        request.setAttribute("approvalLine", approvalLine);
        if(request.getAttribute("RequestPageName") == null)
            request.setAttribute("RequestPageName", g.getRequestPageName(request));

        return true;
    }


}
