/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR ����                                                  */
/*   2Depth Name  : �ʰ��ٹ�                                                        */
/*   Program Name : �ʰ��ٹ� ��û (����Ͽ�����û)                                  */
/*   Program ID   : D01OTMBBuildSV                                        */
/*   Description  : �ʰ��ٹ��� ��û�� �� �ֵ��� �ϴ� Class                          */
/*   Note         :                                                             */
/*   Creation     : 2013-10-29     								 */
/*                  	2014-05-13  C20140515_40601  �繫���ð�������(6H,4H )  ����,�������̸鼭 4,6�ð� �� �����ϰ� üũ�����߰�*/
/*						E_PERSK - 27  : �繫���ð�������(4H)  28 :  �繫��(6H)  */
/*                  	2015-03-13 [CSR ID:2727336] HR-���½�û ���� ������û�� ��   */
/*                     2017-06-29 eunha  [CSR ID:3420113] �λ�ý��� ��û �� ���� ���� UI ǥ���۾�*/
/*                   : 2018/06/09 rdcamel [CSR ID:3701161] ����� �ʰ��ٹ� ��û/���� ���� ���� ��û ��                                                                           */
/*                                                                              */
/********************************************************************************/

package servlet.hris.D.D01OT;

import com.sns.jdf.ApLoggerWriter;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.mobile.EncryptionTool;
import com.sns.jdf.mobile.MobileCodeErrVO;
import com.sns.jdf.mobile.XmlUtil;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;
import hris.D.D01OT.D01OTCheckData;
import hris.D.D01OT.D01OTCheckDataAdd;
import hris.D.D01OT.D01OTData;
import hris.D.D01OT.D01OTHolidayCheckData;
import hris.D.D01OT.rfc.D01OTCheckAddRFC;
import hris.D.D01OT.rfc.D01OTCheckRFC;
import hris.D.D01OT.rfc.D01OTHolidayCheckRFC;
import hris.D.D01OT.rfc.D01OTRFC;
import hris.D.D03Vocation.rfc.D03VocationAReasonRFC;
import hris.D.D25WorkTime.rfc.D25WorkTimeEmpGubRFC;
import hris.D.D16OTHDDupCheckData;
import hris.D.rfc.D16OTHDDupCheckRFC;
import hris.common.*;
import hris.common.approval.ApprovalLineData;
import hris.common.rfc.GetTimmoRFC;
import hris.common.rfc.NumberGetNextRFC;
import hris.common.rfc.PersonInfoRFC;
import hris.common.util.AppUtil;
import org.jdom.Document;
import org.jdom.Element;
import servlet.hris.MobileAutoLoginSV;
import servlet.hris.MobileCommonSV;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.Properties;
import java.util.Vector;

public class D01OTMbBuildSV extends MobileAutoLoginSV {

    private String UPMU_TYPE ="17";   // ���� ����Ÿ��(�ʰ��ٹ���û)
    private String UPMU_NAME = "�ʰ��ٹ�";
    private static String UPMU_FLAG ="A";   // ����
    private static String APPR_TYPE ="01";   // ����

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {

    	try{

        	Logger.debug.println("D01OTMbBuildSV start++++++++++++++++++++++++++++++++++++++" );

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
        	Logger.debug.println("D01OTMbBuildSV apprItem Strart++++++++++++++++++++++++++++++++++++++" );

            HttpSession session = req.getSession(false);
            WebUserData user = WebUtil.getSessionUser(req);

            Box box = WebUtil.getBox(req);
            String empNo = box.get("empNo"); //���
            empNo = EncryptionTool.decrypt(empNo);
            empNo = DataUtil.fixEndZero( empNo ,8);
            String PERNR = empNo;

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

            Logger.debug.println("D01OTMbBuildSV apprItem ++++++++++++++++++++++++++++++++++++++" );

            Vector  D01OTData_vt = new Vector();
            D01OTData  D01OTData = new D01OTData();


            //�븮��û
            PersonInfoRFC numfunc = new PersonInfoRFC();
            PersonData phonenumdata;
            phonenumdata = (PersonData)numfunc.getPersonInfo(PERNR);
            //��û
            //D01OTData_vt = new Vector();
            //�������
            Vector  AppLineData_vt     = new Vector();
            Vector  AppLineData_vt1    = new Vector();
            String  AINF_SEQN          = "";

           // String  applyOtDate       =   box.get("applyOtDate");        // ��û��
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

            Logger.debug.println("D01OTMbBuildSV applyOtDate " +applyOtDate);

	        // ���ϱٹ�,����Ư�� �� üũ���� �����GET �繫������(S):����Ư��,����Ư�ٽ�û���� ,������ûüũ , �������(T) : ������û����
	        String E_PERSKG  = (new D03VocationAReasonRFC()).getE_PERSKG(user.companyCode ,PERNR, "2005", DataUtil.getCurrentDate());
	        XmlUtil.addChildElement(items, "apprRequestPERSKG", E_PERSKG);

	        //C20100812_18478 ���ϱٹ� ��û ����� ���� :����̸� ��û����
	        String OTbuildYn  = (new D03VocationAReasonRFC()).getE_OVTYN(user.companyCode,  PERNR, "2005",DataUtil.getCurrentDate());
	        /*// BBIA ���ֻ�������ܷ��� ����
	        String E_BTRTL  = (new D03VocationAReasonRFC()).getE_BTRTL(user.companyCode, PERNR, "2005",DataUtil.getCurrentDate());*/
	        
	        //[CSR ID:3701161] ����� �ʰ��ٹ� ��û/���� ���� ���� ��û ��
	        D25WorkTimeEmpGubRFC empGubRfc = new D25WorkTimeEmpGubRFC();
	        Vector empGub_vt = empGubRfc.getEmpGub(PERNR, DataUtil.getCurrentDate());
	        String empGubVal = "";
	        
	        if( empGub_vt != null && empGub_vt.get(0).equals("S")){
	        	empGubVal =   empGub_vt.get(3)+"";//E_TPGUB : A(�繫���Ϲ�),B(�������Ϲ�),C(�繫�� ���ñٷ�),D(������ ���ñٷ�)
	        	Logger.debug.println(empNo +"�� E_TPGUB : A(�繫���Ϲ�),B(�������Ϲ�),C(�繫�� ���ñٷ�),D(������ ���ñٷ�) : "+empGubVal);
            }else{
            	errorCode = MobileCodeErrVO.ERROR_CODE_600;
                errorMsg = MobileCodeErrVO.ERROR_MSG_600+empGub_vt.get(1);
		        xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
	            return xmlString;
            }//[CSR ID:3701161] ����� �ʰ��ٹ� ��û/���� ���� ���� ��û �� ��

            //�����üũ : ����Ͽ����� �繫������� �Է°���
            if (!E_PERSKG.equals("S")){
                 errorCode = MobileCodeErrVO.ERROR_CODE_500;
                 errorMsg  = MobileCodeErrVO.ERROR_MSG_600+ "����� ��û�� �繫�������� �����մϴ�.";
                 xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
                 return xmlString;
            }
            if (!OTbuildYn.equals("Y")){
                 errorCode = MobileCodeErrVO.ERROR_CODE_500;
                 errorMsg  = MobileCodeErrVO.ERROR_MSG_600+ "�ʰ��ٹ� ��û ����ڰ� �ƴմϴ�.";
                 xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
                 return xmlString;
            }


//          2003.01.29 - �ð������� ���� ���� �������� �о� ��û�� �����ش�.
            GetTimmoRFC rfcG = new GetTimmoRFC();
            String E_RRDAT = rfcG.GetTimmo( user.companyCode );
            long   D_RRDAT = Long.parseLong(DataUtil.removeStructur(E_RRDAT,"-"));
            if( Long.parseLong(DataUtil.removeStructur(applyOtWorkDate,"-")) < D_RRDAT ) {
                errorCode = MobileCodeErrVO.ERROR_CODE_500;
                errorMsg  = MobileCodeErrVO.ERROR_MSG_600+ E_RRDAT+ "�� ���Ŀ��� ��û �����մϴ�.";
                xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
                return xmlString;
            }

            //�ʼ��Է°� Check
            if (applyOtDate.equals("")){
                 errorCode = MobileCodeErrVO.ERROR_CODE_500;
                 errorMsg  = MobileCodeErrVO.ERROR_MSG_600+ "��û���ڴ� �ʼ� �Է��Դϴ�.";
                 xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
                 return xmlString;
            }
            if (applyOtWorkDate.equals("")){
                errorCode = MobileCodeErrVO.ERROR_CODE_500;
                errorMsg  = MobileCodeErrVO.ERROR_MSG_600+ "�ʰ��ٹ����ڴ� �ʼ� �Է��Դϴ�.";
                xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
                return xmlString;
           }
            if (applyOtFromTime.equals("")){
                errorCode = MobileCodeErrVO.ERROR_CODE_500;
                errorMsg  = MobileCodeErrVO.ERROR_MSG_600+ "���۽ð���  �ʼ� �Է��Դϴ�.";
                xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
                return xmlString;
            }
            if (applyOtToTime.equals("")){
                errorCode = MobileCodeErrVO.ERROR_CODE_500;
                errorMsg  = MobileCodeErrVO.ERROR_MSG_600+ "����ð���  �ʼ� �Է��Դϴ�.";
                xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
                return xmlString;
            }
            if (applyOtReason.equals("")){
                errorCode = MobileCodeErrVO.ERROR_CODE_500;
                errorMsg  = MobileCodeErrVO.ERROR_MSG_600+ "��û������ �ʼ� �Է��Դϴ�.";
                xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
                return xmlString;
            }
            
            //[CSR ID:3701161] �繫�� ���ñٷΰ� �ƴ� ��츸 ���� ź��.
            if(!empGubVal.trim().equals("C")){//E_TPGUB : A(�繫���Ϲ�),B(�������Ϲ�),C(�繫�� ���ñٷ�),D(������ ���ñٷ�)
            //E_PERSKG : �繫�������ΰ�츸
	            if (Long.parseLong(applyOtFromTime) < 90000 ||Long.parseLong(applyOtFromTime) > 180000){
	                errorCode = MobileCodeErrVO.ERROR_CODE_500;
	                errorMsg  = MobileCodeErrVO.ERROR_MSG_600+ "���۽ð� ���� ���ؽð��� 9:00 ~ 18:00 �Դϴ�";
	                xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
	                return xmlString;
	            }
	            //E_PERSKG : �繫�������ΰ�츸
	            if (Long.parseLong(applyOtToTime) < 90000 ||Long.parseLong(applyOtToTime) > 180000){
	                errorCode = MobileCodeErrVO.ERROR_CODE_500;
	                errorMsg  = MobileCodeErrVO.ERROR_MSG_600+ "����ð� ���� ���ؽð��� 9:00 ~ 18:00 �Դϴ�";
	                xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
	                return xmlString;
	            }
            }
            /////////////////////////////////////////////////////////////////////////////
            // �ʰ��ٹ���û ����..
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

            //Logger.debug.println("D01OTMbBuildSV D01OTData +++++++++++++++++++++++++>"+D01OTData.toString() );

            //C20140515_40601  �λ��������� 27,36: -�繫���ð�������(4H)   4�ð�üũ   START
            //C20140515_40601  �λ��������� 28,37: -�繫���ð�������(6H)   6�ð�üũ
           if(phonenumdata.E_PERSK.equals("27")||phonenumdata.E_PERSK.equals("28")||phonenumdata.E_PERSK.equals("36")||phonenumdata.E_PERSK.equals("37")) { //

            	//������, ��,�ϸ� ����
            	D01OTHolidayCheckRFC funHc = new D01OTHolidayCheckRFC();
                Vector D01OTHolidayCheck_vt = funHc.check( "L1", D01OTData.WORK_DATE, D01OTData.WORK_DATE );
                D01OTHolidayCheckData HolidaycheckData = (D01OTHolidayCheckData)D01OTHolidayCheck_vt.get(0);

              	 if  ( HolidaycheckData.HOLIDAY.equals("X") || ( HolidaycheckData.WEEKDAY.equals("6" ) || HolidaycheckData.WEEKDAY.equals("7" )) ) {
                	if ( (phonenumdata.E_PERSK.equals("27")||phonenumdata.E_PERSK.equals("36"))&&!D01OTData.STDAZ.equals("4")  ) {
                        errorCode = MobileCodeErrVO.ERROR_CODE_600;
                        errorMsg = MobileCodeErrVO.ERROR_MSG_600+"�繫�� �ð�������(4H) ����� 4�ð��� ��û�����մϴ�. �ٽ� ��û���ֽʽÿ�.";
                        xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
                        return xmlString;
                	}
	               	if (( phonenumdata.E_PERSK.equals("28")|| phonenumdata.E_PERSK.equals("37"))&&!D01OTData.STDAZ.equals("6") ) {
	                    errorCode = MobileCodeErrVO.ERROR_CODE_600;
	                    errorMsg = MobileCodeErrVO.ERROR_MSG_600+"�繫�� �ð�������(6H) ����� 6�ð��� ��û�����մϴ�. �ٽ� ��û���ֽʽÿ�.";
	                    xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
	                    return xmlString;
	               	}
              	 }else{ //����
              		if (phonenumdata.E_PERSK.equals("27")||phonenumdata.E_PERSK.equals("28"))  { //�ð� ������
	                    errorCode = MobileCodeErrVO.ERROR_CODE_600;
	                    errorMsg = MobileCodeErrVO.ERROR_MSG_600+"�繫�� �ð������� �����  ������, �����, �Ͽ��Ͽ��� �ʰ��ٹ� ��û�� �����մϴ� �ٽ� ��û���ֽʽÿ�.";
	                    xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
	                    return xmlString;
              		}
              	}

                 Logger.debug.println(this, "HolidaycheckData : " + HolidaycheckData.toString());
            }
           //C20140515_40601  �λ��������� 27: -�繫���ð�������(6H) ������ 6�ð�üũ  END

            // Dup Check
            D01OTCheckRFC funCheck = new D01OTCheckRFC();
            Vector D01OTCheck_vt = funCheck.check( PERNR, D01OTData.WORK_DATE, D01OTData.WORK_DATE, D01OTData.BEGUZ, D01OTData.ENDUZ );

            //  2002.07.04. ��û�ð��� �ٹ������� �ߺ��Ǿ������ R3�� �ʰ��ٹ� ��û ������ �����ϱ����ؼ� ������.
            D01OTCheckData checkData = (D01OTCheckData)D01OTCheck_vt.get(0);

            if( !checkData.ERRORTEXTS.equals("") && checkData.STDAZ.equals("0") ) {  //�����޽����� �ְ�, �Ѱ������ �� �� ���� ���
                errorCode = MobileCodeErrVO.ERROR_CODE_600;
                errorMsg = MobileCodeErrVO.ERROR_MSG_600+"�ٹ������� �ߺ��Ǿ����ϴ�. �ٽ� ��û���ֽʽÿ�.";
                xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
                return xmlString;
            } else if( checkData.ERRORTEXTS.equals("") ) {                          //�����޽����� ����, �������̰ų� �Ѱ������ �� ���.
                if( checkData.BEGUZ.equals(D01OTData.BEGUZ) && checkData.ENDUZ.equals(D01OTData.ENDUZ) ) {
                	errorCode="";
                } else {
                    errorCode = MobileCodeErrVO.ERROR_CODE_600;
                    errorMsg = MobileCodeErrVO.ERROR_MSG_600+"�ٹ������� �ߺ��˴ϴ�. ��û�ð��� �����ϼ���.";
                    xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
                    return xmlString;
                }
            }

            //DUP CHECK START
            D16OTHDDupCheckRFC d16OTHDDupCheckRFC = new D16OTHDDupCheckRFC();
            Vector OTHDDupCheckData_vt = null;
            OTHDDupCheckData_vt = d16OTHDDupCheckRFC.getCheckList( PERNR, UPMU_TYPE , user.area);
            String c_workDate="";
            for( int i = 0 ; i < OTHDDupCheckData_vt.size() ; i++ ) {
	              D16OTHDDupCheckData c_Data = (D16OTHDDupCheckData)OTHDDupCheckData_vt.get(i);
	              String s_BEGUZ1 = c_Data.BEGUZ.substring(0,2) + c_Data.BEGUZ.substring(3,5);
	              String s_ENDUZ1 = c_Data.ENDUZ.substring(0,2) + c_Data.ENDUZ.substring(3,5);
	              if(s_ENDUZ1.equals("0000")) {
	                s_ENDUZ1 = "2400";
	              }
	              int s_BEGUZ = Integer.parseInt(s_BEGUZ1+"00");
	              int s_ENDUZ = Integer.parseInt(s_ENDUZ1+"00");
//	              Logger.debug.println("<br>D01OTMbBuildSV c_Data +++ >"+c_Data.toString() );
//	              Logger.debug.println("<br>D01OTMbBuildSV D01OTData ++++ >"+D01OTData.toString() );
//	              Logger.debug.println("<br>D01OTMbBuildSV s_BEGUZ ++++ >"+s_BEGUZ+"Integer.parseInt(D01OTData.BEGUZ)" +Integer.parseInt(D01OTData.BEGUZ));
//	              Logger.debug.println("<br>D01OTMbBuildSV s_ENDUZ ++++ >"+s_ENDUZ+"Integer.parseInt(D01OTData.ENDUZ)" +Integer.parseInt(D01OTData.ENDUZ));

	              c_workDate=c_Data.WORK_DATE.replace("-","");
	              Logger.debug.println("<br>c_workDate : "+c_workDate);
		          if(  c_workDate.equals(D01OTData.WORK_DATE)   ) {
		                if(  !"R".equals(c_Data.APPR_STAT) && s_BEGUZ==Integer.parseInt(D01OTData.BEGUZ)   &&  s_ENDUZ==Integer.parseInt(D01OTData.ENDUZ) ) {
		                    errorCode = MobileCodeErrVO.ERROR_CODE_600;
		                    errorMsg = MobileCodeErrVO.ERROR_MSG_600+"���� �����û�� �Ǿ� �����Ƿ� ����������Ȳ���� Ȯ���Ͻñ� �ٶ��ϴ�.";
		                    xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
		                    return xmlString;
		                }
		                //ENDUZ�� �������� �Ѿ�� ���� ���.
		                else if(  !"R".equals(c_Data.APPR_STAT) &&  s_BEGUZ  <   s_ENDUZ   && (( s_BEGUZ   <= Integer.parseInt(D01OTData.BEGUZ) &&  s_ENDUZ   > Integer.parseInt(D01OTData.BEGUZ)) || (  s_BEGUZ  < Integer.parseInt(D01OTData.ENDUZ) &&  s_ENDUZ  >= Integer.parseInt(D01OTData.ENDUZ)) || ( s_BEGUZ >= Integer.parseInt(D01OTData.BEGUZ) &&  s_ENDUZ <= Integer.parseInt(D01OTData.ENDUZ))) ) {
		                    errorCode = MobileCodeErrVO.ERROR_CODE_600;
		                    errorMsg = MobileCodeErrVO.ERROR_MSG_600+"���� �����û�� �Ǿ� �����Ƿ� ����������Ȳ���� Ȯ���Ͻñ� �ٶ��ϴ�.";
		                    xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
		                    return xmlString;
		                }
		                //ENDUZ�� �������� �Ѿ�� ���.
//		              [CSR ID:2727336] �� ��û���� ���� ��û�Ϻ��� ���� ��¥�� ��� ������ �߰��Ǿ�� ��.
		                //else if(!c_Data.APPR_STAT.equals("R")   && s_BEGUZ  >  s_ENDUZ && ((( s_BEGUZ<= Integer.parseInt(D01OTData.BEGUZ) && Integer.parseInt(D01OTData.BEGUZ) < 2400) || (Integer.parseInt(D01OTData.BEGUZ) >= 0000 &&  s_ENDUZ   > Integer.parseInt(D01OTData.BEGUZ))) || ((Integer.parseInt(D01OTData.ENDUZ) <= 2400 &&  s_BEGUZ   < Integer.parseInt(D01OTData.ENDUZ)) || (Integer.parseInt(D01OTData.ENDUZ) > 0000 &&  s_ENDUZ  >= Integer.parseInt(D01OTData.ENDUZ))) || (Integer.parseInt(D01OTData.BEGUZ) >Integer.parseInt(D01OTData.ENDUZ) &&   s_BEGUZ  >= Integer.parseInt(D01OTData.BEGUZ) &&  s_ENDUZ   <= Integer.parseInt(D01OTData.ENDUZ))) ) {
		                else if(!"R".equals(c_Data.APPR_STAT)   && s_BEGUZ  >  s_ENDUZ && ((( s_BEGUZ<= Integer.parseInt(D01OTData.BEGUZ) && Integer.parseInt(D01OTData.BEGUZ) < 2400) || (Integer.parseInt(D01OTData.BEGUZ) >= 0000 &&  s_ENDUZ   > Integer.parseInt(D01OTData.BEGUZ) && s_BEGUZ  < Integer.parseInt(D01OTData.ENDUZ)) || (Integer.parseInt(D01OTData.BEGUZ) >= 0000 &&  s_BEGUZ   < Integer.parseInt(D01OTData.ENDUZ) && s_BEGUZ  > Integer.parseInt(D01OTData.ENDUZ))) || ((Integer.parseInt(D01OTData.ENDUZ) <= 2400 &&  s_BEGUZ   < Integer.parseInt(D01OTData.ENDUZ)) || (Integer.parseInt(D01OTData.ENDUZ) > 0000 &&  s_ENDUZ  >= Integer.parseInt(D01OTData.ENDUZ))) || (Integer.parseInt(D01OTData.BEGUZ) >Integer.parseInt(D01OTData.ENDUZ) &&   s_BEGUZ  >= Integer.parseInt(D01OTData.BEGUZ) &&  s_ENDUZ   <= Integer.parseInt(D01OTData.ENDUZ))) ) {
		                    errorCode = MobileCodeErrVO.ERROR_CODE_600;
		                    errorMsg = MobileCodeErrVO.ERROR_MSG_600+"�̹� �����û�� �ð��� �ߺ��˴ϴ�. ����������Ȳ���� Ȯ���Ͻñ� �ٶ��ϴ�.";
		                    xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
		                    return xmlString;
		                }
		          }
          }

            //DUP CHECK END
            
            //[CSR ID:3701161] �� 52�ð� �ٹ��� �ʰ��ٹ� ���� üũ���� START
            D01OTCheckAddRFC ntmOtChkRfc = new D01OTCheckAddRFC();
            Vector<D01OTData> d01OtCheckData_vt = new Vector<D01OTData>();
            d01OtCheckData_vt.addElement(D01OTData);
            Vector ret = ntmOtChkRfc.check(d01OtCheckData_vt);
            if(ret.get(0).equals("E")){//''W':���, 'E':���� �̸�, W�� �������� ��쿡 �߻��ϴ� case�� ����Ͽ����� ������.
            	errorCode = MobileCodeErrVO.ERROR_CODE_600;
                errorMsg = MobileCodeErrVO.ERROR_MSG_600+ret.get(1);
                xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
                return xmlString;
            }
            //[CSR ID:3701161] �� 52�ð� �ٹ��� �ʰ��ٹ� ���� üũ���� END
            

            NumberGetNextRFC  func              = new NumberGetNextRFC();
            //������ȣGET
            AINF_SEQN   = func.getNumberGetNext();
            D01OTData.AINF_SEQN   = AINF_SEQN;
            D01OTRFC    rfc              = new D01OTRFC();
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


               /*
                 AppLineData appLine = new AppLineData();
               //appLine.APPL_APPU_NUMB = "00001412";
                appLine.APPL_APPU_NUMB = appLine.APPL_PERNR;//������
                appLine.APPL_MANDT     = user.clientNo;
                appLine.APPL_BUKRS     = user.companyCode;
                appLine.APPL_PERNR     = PERNR;//��û��
                appLine.APPL_BEGDA     = DataUtil.delDateGubn(d03VocationData.BEGDA) ;
                appLine.APPL_AINF_SEQN = AINF_SEQN;
                appLine.APPL_UPMU_TYPE = UPMU_TYPE;
                appLine.APPL_UPMU_FLAG = UPMU_FLAG;
                appLine.APPL_APPR_TYPE = APPR_TYPE;

                AppLineData_vt.addElement(appLine);*/
            }
            Logger.debug.println( this, "######### ������� : "+AppLineData_vt.toString() );
            Logger.debug.println( this, "######### AINF_SEQN : "+AINF_SEQN );

            Logger.info.println( this, "D01OTMb######### AINF_SEQN : "+AINF_SEQN );
            try{
            	/*con = DBUtil.getTransaction();
                AppLineDB appDB    = new AppLineDB(con);

                int iResult = appDB.create(AppLineData_vt);
                if ( iResult < 1 ){
                	con.rollback();
                	errorCode = MobileCodeErrVO.ERROR_CODE_400;
                    errorMsg  ="����������� DB�Է½� �����߻��Ͽ����ϴ�." ;
                    xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
                    return xmlString;
                }

                con.commit();
                */
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

	        String subMenuNm = "������ʰ��ٹ���û";
        	ApLoggerWriter.writeApLog("�����", subMenuNm, "D01OTMbBuildSV", subMenuNm, ctrl, cnt, val, user, req.getRemoteAddr());
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

	    } catch(Exception e) {

	    	errorCode = MobileCodeErrVO.ERROR_CODE_600;
            errorMsg  = MobileCodeErrVO.ERROR_MSG_600+  e.getMessage();
            xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
            return xmlString;

	    }

	    return xmlString;
    }
}
