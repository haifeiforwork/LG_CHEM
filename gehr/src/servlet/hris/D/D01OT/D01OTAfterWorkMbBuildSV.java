package servlet.hris.D.D01OT;

import java.util.Properties;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.jdom.Document;
import org.jdom.Element;

import com.sns.jdf.ApLoggerWriter;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.mobile.EncryptionTool;
import com.sns.jdf.mobile.MobileCodeErrVO;
import com.sns.jdf.mobile.XmlUtil;
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
import hris.D.rfc.D02KongsuHourRFC;
import hris.common.AppLineData;
import hris.common.DraftDocForEloffice;
import hris.common.ElofficInterfaceData;
import hris.common.EmpGubunData;
import hris.common.MailSendToEloffic;
import hris.common.MobileReturnData;
import hris.common.PersonData;
import hris.common.WebUserData;
import hris.common.approval.ApprovalLineData;
import hris.common.rfc.GetEmpGubunRFC;
import hris.common.rfc.NumberGetNextRFC;
import hris.common.rfc.PersonInfoRFC;
import hris.common.util.AppUtil;
import servlet.hris.MobileAutoLoginSV;
import servlet.hris.MobileCommonSV;

public class D01OTAfterWorkMbBuildSV extends MobileAutoLoginSV {

    private String UPMU_TYPE ="44";   // ���� ����Ÿ��(�ʰ��ٹ� ���Ľ�û)
    private String UPMU_NAME = "�ʰ��ٹ� ���Ľ�û";
    private static String APPR_TYPE ="01";   // ����

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {

    	try{

        	Logger.debug.println("D01OTAfterWorkMbBuildSV start++++++++++++++++++++++++++++++++++++++" );

        	//�α���ó��
        	MobileCommonSV mobileCommon = new MobileCommonSV() ;
        	mobileCommon.autoLogin(req,res);

            HttpSession session = req.getSession(false);
            WebUserData user = WebUtil.getSessionUser(req);

            String dest  = "";
            Box box = WebUtil.getBox(req);

            String empNo     = box.get("empNo"); //���
            empNo = EncryptionTool.decrypt(empNo);
            empNo = DataUtil.fixEndZero( empNo ,8);

            Logger.debug.println("=============empNo================================="+empNo);
            // ����ó�� �����
            String returnXml = apprItem(req,res);

            // ����� ���� xmlStirng��  �����Ѵ�.
            req.setAttribute("returnXml", returnXml);
            //LHtmlUtil.blockHttpCache(res);
			Logger.debug.println("==============================================");
			Logger.debug.println(returnXml);

            // 3.return URL�� ȣ���Ѵ�.
            dest = WebUtil.JspURL+"common/mobileResult.jsp";
            Logger.debug.println(this, " destributed = " + dest);
            printJspPage(req, res,dest );

        } catch(Exception e) {
            throw new GeneralException(e);
        }
    }
    
    /**
     * ��û ����� XML���·� �����´�.
     * @return
     */
    public String apprItem( HttpServletRequest req, HttpServletResponse res){

    	Element envelope = null;

        String xmlString = "";
        String itemsName = "apprResult";
        //String docStatus = "";

        String errorCode = "";
        String errorMsg = "";

       //���հ��翬�� �����
    	MobileReturnData retunMsgEL = new MobileReturnData();

        try{
        	Logger.debug.println("D01OTAfterWorkMbBuildSV apprItem Strart++++++++++++++++++++++++++++++++++++++" );

            HttpSession session = req.getSession(false);
            WebUserData user = WebUtil.getSessionUser(req);

            Box box = WebUtil.getBox(req);
            String empNo = box.get("empNo"); //���
            empNo = EncryptionTool.decrypt(empNo);
            empNo = DataUtil.fixEndZero( empNo ,8);
            String PERNR = empNo;
            boolean isUpdate = box.getBoolean("isUpdate");
            
            String curdate = DataUtil.getCurrentDate();

            // 1.Envelop XML�� �����Ѵ�.
            envelope =  XmlUtil.createEnvelope();

            // 2.Body XML�� �����Ѵ�.
            Element body =  XmlUtil.createBody();

            // 3.WAT_RESPONSE �� �����Ѵ�.
            Element waitResponse =  XmlUtil.createWaitResponse();

            // 4.������� �����Ѵ�.
            Element items = XmlUtil.createItems(itemsName);

            /* //��û ������
            applyOtDate         ��û��                   : BEGDA
            applyOtWorkDate     �ʰ��ٹ���               : WORK_DATE
            applyOtVtken        �������� checkbox        : VTKEN
            applyOtFromTime     ��û�ð�                 : BEGUZ
            applyOtToTime       ����ð�                 : ENDUZ
            applyOtOvtmCode     ��û���� ���ùڽ�(������): OVTM_CODE
            applyOtReason       ��û����                 : REASON
            applyOtOvtmName     ���ٹ���(��ٽ�)         : OVTM_NAME
            applyOtPbeg1        �ްԽð�1 : PBEG1
            applyOtPend1        �ްԽð�1 : PEND1
            applyOtPunb1        �ްԽð�1 : PUNB1
            applyOtPbez1        �ްԽð�1 : PBEZ1
            applyOtPbeg2        �ްԽð�2 : PBEG2
            applyOtPend2        �ްԽð�2 : PEND2
            applyOtPunb2        �ްԽð�2 : PUNB2
            applyOtPbez2        �ްԽð�2 : PBEZ2
		    */

            //Logger.debug.println(this, "[PERNR] = "+PERNR + " [user] : "+user.toString());

            Logger.debug.println("D01OTAfterWorkMbBuildSV apprItem ++++++++++++++++++++++++++++++++++++++" );

            Vector  D01OTData_vt = new Vector();
            D01OTData  D01OTData = new D01OTData();

            //�븮��û
            PersonInfoRFC numfunc = new PersonInfoRFC();
            PersonData phonenumdata;
            phonenumdata = (PersonData)numfunc.getPersonInfo(PERNR);
            
            XmlUtil.addChildElement(items, "isUpdate", String.valueOf(isUpdate)); // [����]��� ���� ���� <- �����ʿ��� �ݵ�� �ʿ���
            XmlUtil.addChildElement(items, "PERNR", PERNR);
            XmlUtil.addChildElement(items, "committed", "N");
            Element persondataItem = XmlUtil.createElement("PersonData");
            XmlUtil.addChildElement(persondataItem, "persondataE_MOLG", phonenumdata.E_MOLGA);
            XmlUtil.addChildElement(persondataItem, "persondataE_PERN", phonenumdata.E_PERNR);
            XmlUtil.addChildElement(persondataItem, "persondataE_ENAM", phonenumdata.E_ENAME);
            XmlUtil.addChildElement(persondataItem, "persondataE_BUKR", phonenumdata.E_BUKRS);
            XmlUtil.addChildElement(persondataItem, "persondataE_WERK", phonenumdata.E_WERKS);
            XmlUtil.addChildElement(persondataItem, "persondataE_BTRT", phonenumdata.E_BTRTL);
            XmlUtil.addChildElement(persondataItem, "persondataE_ORGE", phonenumdata.E_ORGEH);
            XmlUtil.addChildElement(persondataItem, "persondataE_ORGT", phonenumdata.E_ORGTX);
            XmlUtil.addChildElement(persondataItem, "persondataE_PERS", phonenumdata.E_PERSG);
            XmlUtil.addChildElement(persondataItem, "persondataE_PERS", phonenumdata.E_PERSK);
            XmlUtil.addChildElement(persondataItem, "persondataE_OBJI", phonenumdata.E_OBJID);
            XmlUtil.addChildElement(persondataItem, "persondataE_OBJT", phonenumdata.E_OBJTX);
            XmlUtil.addChildElement(persondataItem, "persondataE_DAT0", phonenumdata.E_DAT02);
            XmlUtil.addChildElement(persondataItem, "persondataE_PHONE_NUM", phonenumdata.E_PHONE_NUM);
            XmlUtil.addChildElement(persondataItem, "persondataE_CELL_PHONE", phonenumdata.E_CELL_PHONE);
            XmlUtil.addChildElement(persondataItem, "persondataE_MAIL", phonenumdata.E_MAIL);
            XmlUtil.addChildElement(persondataItem, "persondataE_TIMEADMIN", phonenumdata.E_TIMEADMIN);
            XmlUtil.addChildElement(persondataItem, "persondataE_REPRESENTATIVE", phonenumdata.E_REPRESENTATIVE);
            XmlUtil.addChildElement(persondataItem, "persondataE_AUTHORIZATION", phonenumdata.E_AUTHORIZATION);
            XmlUtil.addChildElement(persondataItem, "persondataE_AUTHORIZATION2", phonenumdata.E_AUTHORIZATION2);
            XmlUtil.addChildElement(persondataItem, "persondataE_DEPTC", phonenumdata.E_DEPTC);
            XmlUtil.addChildElement(persondataItem, "persondataE_RETIR", phonenumdata.E_RETIR);
            XmlUtil.addChildElement(persondataItem, "persondataE_REDAY", phonenumdata.E_REDAY);
            XmlUtil.addChildElement(persondataItem, "persondataE_IS_CHIEF", phonenumdata.E_IS_CHIEF);
            XmlUtil.addChildElement(persondataItem, "persondataE_GANSA", phonenumdata.E_GANSA);
            XmlUtil.addChildElement(persondataItem, "persondataE_OVERSEA", phonenumdata.E_OVERSEA);
            XmlUtil.addChildElement(persondataItem, "persondataE_RECON", phonenumdata.E_RECON);
            XmlUtil.addChildElement(persondataItem, "persondataE_GBDAT", phonenumdata.E_GBDAT);
            XmlUtil.addChildElement(persondataItem, "persondataE_GRUP_NUMB", phonenumdata.E_GRUP_NUMB);
            XmlUtil.addChildElement(persondataItem, "persondataE_JIKWE", phonenumdata.E_JIKWE);
            XmlUtil.addChildElement(persondataItem, "persondataE_JIKWT", phonenumdata.E_JIKWT);
            XmlUtil.addChildElement(persondataItem, "persondataE_JIKKB", phonenumdata.E_JIKKB);
            XmlUtil.addChildElement(persondataItem, "persondataE_JIKK", phonenumdata.E_JIKKT);
            XmlUtil.addChildElement(persondataItem, "persondataE_REGN", phonenumdata.E_REGNO);
            XmlUtil.addChildElement(persondataItem, "persondataE_TRFA", phonenumdata.E_TRFAR);
            XmlUtil.addChildElement(persondataItem, "persondataE_TRFG", phonenumdata.E_TRFGR);
            XmlUtil.addChildElement(persondataItem, "persondataE_TRFS", phonenumdata.E_TRFST);
            XmlUtil.addChildElement(persondataItem, "persondataE_VGLG", phonenumdata.E_VGLGR);
            XmlUtil.addChildElement(persondataItem, "persondataE_VGLS", phonenumdata.E_VGLST);
            XmlUtil.addChildElement(persondataItem, "persondataE_STRA", phonenumdata.E_STRAS);
            XmlUtil.addChildElement(persondataItem, "persondataE_LOCA", phonenumdata.E_LOCAT);
            XmlUtil.addChildElement(persondataItem, "persondataE_JIKC", phonenumdata.E_JIKCH);
            XmlUtil.addChildElement(persondataItem, "persondataE_JIKC", phonenumdata.E_JIKCT);
            XmlUtil.addChildElement(persondataItem, "persondataE_EXPI", phonenumdata.E_EXPIR);
            XmlUtil.addChildElement(persondataItem, "persondataE_PTEXT", phonenumdata.E_PTEXT);
            XmlUtil.addChildElement(persondataItem, "persondataE_BTEXT", phonenumdata.E_BTEXT);
            
            XmlUtil.addChildElement(items, persondataItem);
            
            //��û
            //�������
            Vector  AppLineData_vt     = new Vector();
            Vector  AppLineData_vt1    = new Vector();
            String  AINF_SEQN          = "";

            String  applyOtDate       =   DataUtil.getCurrentDate();        // ��û��
            String  applyOtWorkDate   =   box.get("applyOtWorkDate");    // �ʰ��ٹ���
            String  applyOtVtken     =   box.get("applyOtVtken");      // �������� checkbox
            String  applyOtFromTime   =   DataUtil.removeBlank(box.get("applyOtFromTime"));        // ���۽ð�
            String  applyOtToTime     =   DataUtil.removeBlank(box.get("applyOtToTime"));        // ����ð�
            String  applyOtSTDAZ     =   DataUtil.removeBlank(box.get("applyOtSTDAZ"));        // �ð�
            String  applyOtOvtmCode       =   box.get("applyOtOvtmCode");       // ��û���� ���ùڽ�(������)
            String  applyOtReason     =   WebUtil.decode(box.get("applyOtReason"));       // ��û ����
            String  applyOtOvtmName =   box.get("applyOtOvtmName");         // ���ٹ���(��ٽ�)
            String  applyOtPbeg1 =   box.get("applyOtPbeg1");         // �ްԽð�1
            String  applyOtPend1 =   box.get("applyOtPend1");         // �ްԽð�1
            String  applyOtPunb1 =   box.get("applyOtPunb1");         // �ްԽð�1
            String  applyOtPbez1 =   box.get("applyOtPbez1");         // �ްԽð�1
            String  applyOtPbeg2 =   box.get("applyOtPbeg2");         // �ްԽð�2
            String  applyOtPend2 =   box.get("applyOtPend2");         // �ްԽð�2
            String  applyOtPunb2 =   box.get("applyOtPunb2");         // �ްԽð�2
            String  applyOtPbez2 =   box.get("applyOtPbez2");         // �ްԽð�2

            Logger.debug.println("D01OTAfterWorkMbBuildSV applyOtDate " +applyOtDate);
            
            // �ʰ��ٹ� ���Ľ�û�� ���üũ
            String PRECHECK = new D01OTAfterWorkPercheckRFC().getPRECHECK(PERNR, applyOtWorkDate, "").E_PRECHECK;
            Logger.debug.println(this, "[create] PRECHECK >> " + PRECHECK);
            
            /////////////////////////////////////////////////////////////////////////////
            // �ʰ��ٹ� ���Ľ�û ����..
            D01OTData.BEGDA       = applyOtDate     ;        //��û��
            D01OTData.WORK_DATE   = applyOtWorkDate ;   //�ʰ��ٹ���
            D01OTData.VTKEN       = applyOtVtken   ;         //�������� checkbox
            D01OTData.BEGUZ       = applyOtFromTime ;        //��û�ð�
            D01OTData.ENDUZ       = applyOtToTime   ;        //����ð�
            D01OTData.OVTM_CODE   = applyOtOvtmCode ;  //��û���� ���ùڽ�(������)
            D01OTData.REASON      = applyOtReason   ;       //��û����
            D01OTData.BEGUZ       = applyOtFromTime ;       //��û�ð�
            D01OTData.ENDUZ       = applyOtToTime   ;       //����ð�
            D01OTData.STDAZ       = applyOtSTDAZ   ;       //�ð�
            D01OTData.OVTM_NAME   = applyOtOvtmName ; //���ٹ���(��ٽ�)
            D01OTData.PBEG1      = applyOtPbeg1   ;     // �ްԽð�1
            D01OTData.PEND1      = applyOtPend1   ;     // �ްԽð�1
            D01OTData.PUNB1      = applyOtPunb1   ;     // �ްԽð�1
            D01OTData.PBEZ1      = applyOtPbez1   ;     // �ްԽð�1
            D01OTData.PBEG2      = applyOtPbeg2   ;     // �ްԽð�2
            D01OTData.PEND2      = applyOtPend2   ;     // �ްԽð�2
            D01OTData.PUNB2      = applyOtPunb2   ;     // �ްԽð�2
            D01OTData.PBEZ2      = applyOtPbez2   ;     // �ްԽð�2

            D01OTData.PERNR       = PERNR;                  //��û�� ��� ����(�븮��û ,���� ��û)
            D01OTData.ZPERNR       = user.empNo;                  //��û�� ��� ����(�븮��û ,���� ��û)
            D01OTData.UNAME        = user.empNo;                  //��û�� ��� ����(�븮��û ,���� ��û)
            D01OTData.AEDTM        = DataUtil.getCurrentDate();   // ������(���糯¥)
            
            // �ʰ��ٹ� �ش翩�θ� üũ ����
            D01OTAFCheckRFC AFCheckFunc = new D01OTAFCheckRFC();
            Vector T_RESULT = new Vector();
            T_RESULT.addElement(D01OTData);
            AFCheckFunc.AFCheck(T_RESULT);

            String message = AFCheckFunc.getReturn().MSGTX;
            if (AFCheckFunc.getReturn().isSuccess()) {
                message = "";
            }

            Logger.debug.println(this, " AF Check chkaddFunc.getReturn().MSGTX >> " + AFCheckFunc.getReturn().MSGTX);
            Logger.debug.println(this, " AF Check MESSAGE >> " + message);
            
            String yymm = DataUtil.getCurrentYear() + DataUtil.getCurrentMonth();
            Vector submitData_vt = new D02KongsuHourRFC().getOvtmHour(PERNR, yymm, "R", D01OTData); // 'C' = ��Ȳ, 'R' = ��û,'M' = ����, 'G' = ����

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
                final D01OTRealWorkDATA WorkData = realworkfunc.getResult(EMPGUB, PERNR, D01OTData.WORK_DATE, D01OTData.VTKEN, D01OTData.AINF_SEQN, MODE);
                final D01OTAfterWorkTimeDATA AfterData = rfcaf.getResult("2", PERNR, D01OTData.WORK_DATE, "", "", curdate, "");

                if (realworkfunc.getReturn().isSuccess()) {
                    Element workdataItem = XmlUtil.createElement("workdata");
                    XmlUtil.addChildElement(workdataItem, "workdataPERNR", WorkData.PERNR);
                    XmlUtil.addChildElement(workdataItem, "workdataBASTM", WorkData.BASTM);
                    XmlUtil.addChildElement(workdataItem, "workdataMAXTM", WorkData.MAXTM);
                    XmlUtil.addChildElement(workdataItem, "workdataPWDWK", WorkData.PWDWK);
                    XmlUtil.addChildElement(workdataItem, "workdataPWEWK", WorkData.PWEWK);
                    XmlUtil.addChildElement(workdataItem, "workdataCWDWK", WorkData.CWDWK);
                    XmlUtil.addChildElement(workdataItem, "workdataCWEWK", WorkData.CWEWK);
                    XmlUtil.addChildElement(workdataItem, "workdataPWTOT", WorkData.PWTOT);
                    XmlUtil.addChildElement(workdataItem, "workdataCWTOT", WorkData.CWTOT);
                    XmlUtil.addChildElement(workdataItem, "workdataRWKTM", WorkData.RWKTM);
                    XmlUtil.addChildElement(workdataItem, "workdataWKLMT", WorkData.WKLMT);
                    XmlUtil.addChildElement(workdataItem, "workdataNORTM", WorkData.NORTM);
                    XmlUtil.addChildElement(workdataItem, "workdataOVRTM", WorkData.OVRTM);
                    XmlUtil.addChildElement(workdataItem, "workdataBRKTM", WorkData.BRKTM);
                    XmlUtil.addChildElement(workdataItem, "workdataNWKTM", WorkData.NWKTM);
                    
                    XmlUtil.addChildElement(items, workdataItem);
                } else {
                    Logger.debug.println(this, "�Ǳٹ��ð� ��ȸ ����!!");
                }

                if (rfcaf.getReturn().isSuccess()) {
                	Element afterdataItem = XmlUtil.createElement("afterdata");
                    XmlUtil.addChildElement(afterdataItem, "afterdataPERNR", AfterData.PERNR);
                    XmlUtil.addChildElement(afterdataItem, "afterdataAINF_SEQN", AfterData.AINF_SEQN);
                    XmlUtil.addChildElement(afterdataItem, "afterdataBUKRS", AfterData.BUKRS);
                    XmlUtil.addChildElement(afterdataItem, "afterdataEMPGUB", AfterData.EMPGUB);
                    XmlUtil.addChildElement(afterdataItem, "afterdataTPGUB", AfterData.TPGUB);
                    XmlUtil.addChildElement(afterdataItem, "afterdataWKDAT", AfterData.WKDAT);
                    XmlUtil.addChildElement(afterdataItem, "afterdataBEGUZ", AfterData.BEGUZ);
                    XmlUtil.addChildElement(afterdataItem, "afterdataENDUZ", AfterData.ENDUZ);
                    XmlUtil.addChildElement(afterdataItem, "afterdataABEGUZ01", AfterData.ABEGUZ01);
                    XmlUtil.addChildElement(afterdataItem, "afterdataAENDUZ01", AfterData.AENDUZ01);
                    XmlUtil.addChildElement(afterdataItem, "afterdataAREWK01", AfterData.AREWK01);
                    XmlUtil.addChildElement(afterdataItem, "afterdataABEGUZ02", AfterData.ABEGUZ02);
                    XmlUtil.addChildElement(afterdataItem, "afterdataAENDUZ02", AfterData.AENDUZ02);
                    XmlUtil.addChildElement(afterdataItem, "afterdataAREWK02", AfterData.AREWK02);
                    XmlUtil.addChildElement(afterdataItem, "afterdataBASTM", AfterData.BASTM);
                    XmlUtil.addChildElement(afterdataItem, "afterdataMAXTM", AfterData.MAXTM);
                    XmlUtil.addChildElement(afterdataItem, "afterdataPDUNB", AfterData.PDUNB);
                    XmlUtil.addChildElement(afterdataItem, "afterdataABSTD", AfterData.ABSTD);
                    XmlUtil.addChildElement(afterdataItem, "afterdataPDABS", AfterData.PDABS);
                    XmlUtil.addChildElement(afterdataItem, "afterdataSTDAZ", AfterData.STDAZ);
                    XmlUtil.addChildElement(afterdataItem, "afterdataAREWK", AfterData.AREWK);
                    XmlUtil.addChildElement(afterdataItem, "afterdataTOTAL", AfterData.TOTAL);
                    XmlUtil.addChildElement(afterdataItem, "afterdataNRQPST", AfterData.NRQPST);
                    XmlUtil.addChildElement(afterdataItem, "afterdataRRQPST", AfterData.RRQPST);
                    XmlUtil.addChildElement(afterdataItem, "afterdataRQPST", AfterData.RQPST);
                    XmlUtil.addChildElement(afterdataItem, "afterdataCPDUNB", AfterData.CPDUNB);
                    XmlUtil.addChildElement(afterdataItem, "afterdataCABSTD", AfterData.CABSTD);
                    XmlUtil.addChildElement(afterdataItem, "afterdataCPDABS", AfterData.CPDABS);
                    XmlUtil.addChildElement(afterdataItem, "afterdataCSTDAZ", AfterData.CSTDAZ);
                    XmlUtil.addChildElement(afterdataItem, "afterdataCAREWK", AfterData.CAREWK);
                    XmlUtil.addChildElement(afterdataItem, "afterdataCTOTAL", AfterData.CTOTAL);
                    XmlUtil.addChildElement(afterdataItem, "afterdataCNRQPST", AfterData.CNRQPST);
                    XmlUtil.addChildElement(afterdataItem, "afterdataCRRQPST", AfterData.CRRQPST);
                    XmlUtil.addChildElement(afterdataItem, "afterdataCRQPST", AfterData.CRQPST);
                    XmlUtil.addChildElement(afterdataItem, "afterdataNRFLGG", AfterData.NRFLGG);
                    XmlUtil.addChildElement(afterdataItem, "afterdataR01FLG", AfterData.R01FLG);
                    XmlUtil.addChildElement(afterdataItem, "afterdataR02FLG", AfterData.R02FLG);
                    XmlUtil.addChildElement(afterdataItem, "afterdataZOVTYP", AfterData.ZOVTYP);
                    XmlUtil.addChildElement(afterdataItem, "afterdataE_EMPGUB", AfterData.E_EMPGUB);
                    XmlUtil.addChildElement(afterdataItem, "afterdataE_TPGUB", AfterData.E_TPGUB);
                    XmlUtil.addChildElement(afterdataItem, "afterdataE_WKDYN", AfterData.E_WKDYN);
                    XmlUtil.addChildElement(afterdataItem, "afterdataE_PRECHECK", AfterData.E_PRECHECK);
                    
                    XmlUtil.addChildElement(items, afterdataItem);
                } else {
                    Logger.debug.println(this, "AF �Ǳٹ��ð� ��ȸ ����!!");
                }
            }
            
            D01OTData_vt.addElement(D01OTData);
            
            // �޼����� �ִ°��
            if (!message.equals("")) {
            	errorCode = MobileCodeErrVO.ERROR_CODE_700;
                errorMsg = MobileCodeErrVO.ERROR_MSG_700+message;
                xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
                return xmlString;
            // [CSR ID:2803878] ��û �� �ʰ��ٹ� ��û���� alert ## ��Ȳ�ȳ��޽����� Ȯ���ϸ� ������.(KSC)
            } else if (!D01OTData.OVTM12YN.equals("N") || (PRECHECK.equals("N") && D01OTData.VTKEN.equals("X"))) { // confirm �� message �߰�

            	/******************************************
            	 * �� ���μ��� Ȯ�� �� ����Ϸ� Convert �ʿ���. 
            	 ******************************************/
                /*Logger.debug.println(this, "[AF]������������:��û���� Alert ");
                Logger.debug.println(this, "[AF]������������:��û���� Alert : message : " + message);

                // �Ǳٹ��ð� ��ȸ
                String MODE = "";

                if (EMPGUB.equals("S")) {    // �繫��
                    MODE = "";
                    final D01OTRealWorkDATA WorkData = realworkfunc.getResult(EMPGUB, PERNR, D01OTData.WORK_DATE, D01OTData.VTKEN, D01OTData.AINF_SEQN, MODE);

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
                req.setAttribute("DATUM", D01OTData.WORK_DATE);

                printJspPage(req, res, WebUtil.JspURL + "D/D01OT/D01OTAfterWorkBuild_KR.jsp");

                return null;*/

            } else { // ����
                NumberGetNextRFC  func              = new NumberGetNextRFC();
                //������ȣGET
                AINF_SEQN   = func.getNumberGetNext();
                D01OTData.AINF_SEQN   = AINF_SEQN;
                D01OTAFRFC    rfc              = new D01OTAFRFC();
                //������� ����
                //ApprInfoRFC appRfc = new ApprInfoRFC();
                AppLineData_vt1 = AppUtil.getAppVector( PERNR, UPMU_TYPE );


                Vector<ApprovalLineData> approvalLineList = new Vector<ApprovalLineData>();
                int nRowCount = AppLineData_vt1.size();
                Logger.debug.println( this, "######### nRowCount : "+nRowCount );
                for( int i = 0; i < nRowCount; i++) {

                    //String      idx     = Integer.toString(i);

                    AppLineData appLine = (AppLineData)AppLineData_vt1.get(i);

                    ApprovalLineData approvalLine = new ApprovalLineData();
                    approvalLine.APPU_NUMB = appLine.APPL_PERNR;//������
                    approvalLine.APPU_TYPE = appLine.APPL_APPU_TYPE;
                    approvalLine.APPR_SEQN = appLine.APPL_APPR_SEQN;

                    approvalLine.OTYPE = appLine.APPL_OTYPE;
                    approvalLine.OBJID = appLine.APPL_OBJID;

                    approvalLine.PERNR     = PERNR;//��û��
                    approvalLine.AINF_SEQN = AINF_SEQN;
                    approvalLine.APPR_TYPE = APPR_TYPE;

                    approvalLineList.addElement(approvalLine);
                }
                Logger.debug.println( this, "######### ������� : "+AppLineData_vt.toString() );
                Logger.debug.println( this, "######### AINF_SEQN : "+AINF_SEQN );

                Logger.info.println( this, "D01OTMb######### AINF_SEQN : "+AINF_SEQN );
                try{
                    D01OTData_vt.addElement(D01OTData);
                    Logger.debug.println(this, "#rfc.build######### D01OTData_vt : " + D01OTData_vt);
                    //rfc.build( AINF_SEQN, PERNR, D01OTData_vt );

                    box.put("T_IMPORTA", approvalLineList);
                    rfc.setRequestInput(PERNR, UPMU_TYPE);
                    AINF_SEQN = rfc.build( PERNR, D01OTData_vt, box, req );
                    Logger.debug.println(this, "�����ȣ  ainf_seqn=" + AINF_SEQN.toString());
                    if (!rfc.getReturn().isSuccess() || AINF_SEQN == null) {
                        throw new Exception(rfc.getReturn().MSGTX);
                    }

                } catch (Exception e){
                    Logger.error(e);
                    errorCode = MobileCodeErrVO.ERROR_CODE_400;
                    errorMsg  ="����������� �� �Է����� ���߽��ϴ�." ;
                    if(rfc.getReturn().MSGTY.equals("E"))
                    	errorMsg = rfc.getReturn().MSGTX;
                    xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
                    return xmlString;
                }

                // ���� ������ ��� ,
                ApprovalLineData appLine = approvalLineList.get(0);

                Logger.debug.println(this, "########## D01OTData : " + appLine.toString());

                Properties ptMailBody = new Properties();
                ptMailBody.setProperty("SServer",user.SServer);                 // ElOffice ���� ����
                ptMailBody.setProperty("from_empNo" ,user.empNo);               // �� �߼��� ���
                ptMailBody.setProperty("to_empNo" ,appLine.APPU_NUMB);     // �� ������ ���

                ptMailBody.setProperty("ename" ,phonenumdata.E_ENAME);          // (��)��û�ڸ�
                ptMailBody.setProperty("empno" ,phonenumdata.E_PERNR);          // (��)��û�� ���

                ptMailBody.setProperty("UPMU_NAME" ,UPMU_NAME);                 // ���� �̸�
                ptMailBody.setProperty("AINF_SEQN" ,AINF_SEQN);
                // ��û�� ����
                // �� ����
                StringBuffer sbSubject = new StringBuffer(512);
                Logger.debug.println(this, "########## D01OTData : test" );

             // [CSR ID:3420113] �λ�ý��� ��û �� ���� ���� UI ǥ���۾�  2017-06-29 eunha start
                //sbSubject.append("[" + ptMailBody.getProperty("UPMU_NAME") + "] ");
                //sbSubject.append("" + ptMailBody.getProperty("ename") +"���� ��û�ϼ̽��ϴ�.");
                sbSubject.append("[HR] �����û(" + ptMailBody.getProperty("UPMU_NAME") + ") ");
             // [CSR ID:3420113] �λ�ý��� ��û �� ���� ���� UI ǥ���۾�  2017-06-29 eunha end


                ptMailBody.setProperty("subject" ,sbSubject.toString());

                //String msg = "msg001";;
                String msg2 = "";
                ptMailBody.setProperty("FileName" ,"MbNoticeMailBuild.html");
                MailSendToEloffic  maTe = new MailSendToEloffic(ptMailBody);

                if (!maTe.process()) {
                    msg2 = maTe.getMessage();
                } // end if

            	//ApLog start
            	String ctrl = "11"; //
            	String cnt = "1";
            	String[] val = null;
            	val = new String[5];
                val[0] = D01OTData.PERNR;
                val[1] = AINF_SEQN;
                val[2] = D01OTData.WORK_DATE;
                val[3] = D01OTData.BEGUZ;
                val[4] = D01OTData.ENDUZ;

    	        String subMenuNm = "������ʰ��ٹ����Ľ�û";
            	ApLoggerWriter.writeApLog("�����", subMenuNm, "D01OTAfterWorkMbBuildSV", subMenuNm, ctrl, cnt, val, user, req.getRemoteAddr());
            	//Aplog end

                try {
                    DraftDocForEloffice ddfe = new DraftDocForEloffice();
                    ElofficInterfaceData eof = ddfe.makeDocContents(AINF_SEQN ,user.SServer,ptMailBody.getProperty("UPMU_NAME"));
                    Vector vcElofficInterfaceData = new Vector();
                    vcElofficInterfaceData.add(eof);

                    //���հ��� ����
                	MobileCommonSV mobileCommon = new MobileCommonSV() ;
                    retunMsgEL = mobileCommon.ElofficInterface( vcElofficInterfaceData, user);
                    //���հ��� �������� ���� �߻��� ������ return
                    if (!retunMsgEL.CODE.equals("0")){
    	  	            errorCode = MobileCodeErrVO.ERROR_CODE_400+""+retunMsgEL.CODE;
                        errorMsg  = retunMsgEL.VALUE ;
                        xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
                        return xmlString;
                    }

                } catch (Exception e) {

                    msg2 += "\\n" + " Eloffic ���� ����" ;

                    errorCode = MobileCodeErrVO.ERROR_CODE_400;
                    errorMsg  = MobileCodeErrVO.ERROR_MSG_400+  msg2;
                    xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
                    return xmlString;
                } // end try

    	        // �����ΰ�� �����ڵ忡 0�� �����Ѵ�.
    	        XmlUtil.addChildElement(items, "returnDesc", "");
    	        XmlUtil.addChildElement(items, "returnCode", "0");

    	        // XML�� �����Ѵ�.
    	        XmlUtil.addChildElement(waitResponse, items);
    	        XmlUtil.addChildElement(body, waitResponse);
    	        XmlUtil.addChildElement(envelope, body);

    	        // ���������� XML Document�� XML String�� ��ȯ�Ѵ�.
    	        xmlString = XmlUtil.convertString(new Document(envelope));
            }
            
	    } catch(Exception e) {

	    	errorCode = MobileCodeErrVO.ERROR_CODE_700;
            errorMsg  = MobileCodeErrVO.ERROR_MSG_700+  e.getMessage();
            xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
            return xmlString;

	    }

	    return xmlString;
    }
}
