/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR ����                                                  */
/*   2Depth Name  : �ް�                                                        */
/*   Program Name : �ް� ��û (����Ͽ�����û)                                  */
/*   Program ID   : D03VocationMBBuildSV                                        */
/*   Description  : �ް��� ��û�� �� �ֵ��� �ϴ� Class                          */
/*   Note         :                                                             */
/*   Creation     : 2011-05-18  JMK                                             */
/*                  2013-06-18  [��CSR ID:C20130617_50756 ] �ϰ��ް� ��û �Ⱓ ������û  */
/*                  2014-05-13  C20140515_40601 E_PERSK - 27 ,28 �繫���ð�������(4H,6H) ������ ����ó�� */
/*                                                           �����ް�(����):0120,�Ĺ�:0121, �𼺺�ȣ�ް�:0190,�ð�����:0180  */
/*                      2014-08-24   [CSR ID:2595636] �����Ͽ� �ް�&��� ���� ��û ��                  */
/*					 2017-07-20 eunha [CSR ID:3438118] flexible time �ý��� ��û*/
/*                     2017-06-29 eunha  [CSR ID:3420113] �λ�ý��� ��û �� ���� ���� UI ǥ���۾�*/
/* update        : 2018/06/08 rdcamel [CSR ID:3700538] �����ް��� ���Կ� ���� Mobile �ް���û �� ����ȭ�� ���� ��û ��*/ 
/*                    2018/07/24 rdcamel [CSR ID:3748125] g-mobile �ް� ��û �� ���� ���� ���� �� ���� */
/********************************************************************************/

package servlet.hris.D.D03Vocation;

import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.mobile.EncryptionTool;
import com.sns.jdf.mobile.MobileCodeErrVO;
import com.sns.jdf.mobile.XmlUtil;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;

import hris.D.D03Vocation.D03GetWorkdayData;
import hris.D.D03Vocation.D03VocationData;
import hris.D.D03Vocation.D03WorkPeriodData;
import hris.D.D03Vocation.rfc.*;
import hris.D.D16OTHDDupCheckData2;
import hris.D.rfc.D16OTHDDupCheckRFC;
import hris.D.rfc.D16OTHDDupCheckRFC2;
import hris.common.*;
import hris.common.approval.ApprovalLineData;
import hris.common.approval.ApprovalLineRFC;
import hris.common.rfc.GetTimmoRFC;
import hris.common.rfc.NumberGetNextRFC;
import hris.common.rfc.PersonInfoRFC;
import hris.common.util.AppUtil;
import org.apache.commons.lang.math.NumberUtils;
import org.jdom.Document;
import org.jdom.Element;
import servlet.hris.MobileAutoLoginSV;
import servlet.hris.MobileCommonSV;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.Properties;
import java.util.Vector;

public class D03VocationMbBuildSV extends MobileAutoLoginSV {

    private String UPMU_TYPE ="18";   // ���� ����Ÿ��(�ް���û)
    private String UPMU_NAME = "�ް�";
    private static String UPMU_FLAG ="A";   // ����
    private static String APPR_TYPE ="01";   // ����

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {

    	try{

        	Logger.debug.println("D03VocationMbBuildSV start++++++++++++++++++++++++++++++++++++++" );

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
        	Logger.debug.println("D03VocationMbBuildSV apprItem Strart++++++++++++++++++++++++++++++++++++++" );

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
            applyHolidayDate          ��û��
            applyHolidayType          �ٹ�/�޹� ����
            applyHolidayType          �ٹ�/�޹� ����
            applyHolidayReason        ��û����
            applyHolidayFromDate      ��û������
            applyHolidayToDate        ��û������
            applyHolidayFromTime      ��û�ð�
            applyHolidayToTime        ����ð�
            applyHolidayRemainDate    �ܿ��ް��ϼ�

            0110 �����ް�
			0120  �����ް�(����)
			0121  �����ް�(�Ĺ�)
			-------------------------
			0340 ���Ϻ�ٹ� - LG����ȭ��
			0360 �ٹ����� - LG����ȭ��
			--------------------------
			0140  �ϰ��ް�
			0130  �����ް�
			0170  ���ϰ���
			0180  �ð�����
			0150  �����ް� - ����
			0190  �𼺺�ȣ�ް� - ���� (20140728 ����� �߰�)
		    */


            //Logger.debug.println(this, "[PERNR] = "+PERNR + " [user] : "+user.toString());

            Logger.debug.println("D03VocationMbBuildSV apprItem JMK++++++++++++++++++++++++++++++++++++++" );

            //Vector  d03VocationData_vt = new Vector();
            D03VocationData  d03VocationData = new D03VocationData();

            NumberGetNextRFC  func              = new NumberGetNextRFC();
            D03VocationRFC    rfc               = new D03VocationRFC();
            D03WorkPeriodRFC  rfcWork           = new D03WorkPeriodRFC();
            D03WorkPeriodData d03WorkPeriodData = new D03WorkPeriodData();
            d03VocationData   = new D03VocationData();

            // �ܿ��ް��ϼ�// [CSR ID:3700538] function ��ü
            //D03RemainVocationRFC  rfcRemain             = null;
            D03GetWorkdayOfficeRFC rfcRemain             = null;

            //�븮��û
            PersonInfoRFC numfunc = new PersonInfoRFC();
            PersonData phonenumdata;
            phonenumdata = (PersonData)numfunc.getPersonInfo(PERNR);
            //��û
            //d03VocationData_vt = new Vector();
            //�������
            //Vector  AppLineData_vt     = new Vector(); [CSR ID:3748125]���� ����
            //Vector  AppLineData_vt1    = new Vector(); [CSR ID:3748125]���� ����
            String  AINF_SEQN          = "";

            String  dateFrom     = "";
            String  dateTo       = "";
            //String  message      = "";
            double  remain_date  = 0.0;
            double  vacation_day = 0.0;  // �޹��ϼ�
            long    beg_time     = 0;
            long    end_time     = 0;
            long    work_time    = 0;

            String  applyHolidayDate       =   box.get("applyHolidayDate");        // ��û��
            String  applyHolidayType       =   box.get("applyHolidayType");        // �ٹ�/�޹� ����
            String  applyHolidayReason     =   WebUtil.decode(box.get("applyHolidayReason"));       // ��û ���� * ksc
            String  applyHolidayFromDate   =   box.get("applyHolidayFromDate");    // ��û������
            String  applyHolidayToDate     =   box.get("applyHolidayToDate");      // ��û������
            String  applyHolidayFromTime   =   DataUtil.removeBlank(box.get("applyHolidayFromTime"));        // ���۽ð�
            String  applyHolidayToTime     =   DataUtil.removeBlank(box.get("applyHolidayToTime"));        // ����ð�
            //String  applyHolidayRemainDate =   box.get("applyHolidayRemainDate");         // �ܿ��ϼ�
            String  DEDUCT_DATE = "";


            /////////[CSR ID:2942508] �����ް� ��û �˾� ��û///////////////////////////////////////////////////////////////
            String currDate =  DataUtil.getCurrentDate();
            String currMon = DataUtil.getCurrentMonth();
            String nextMon = DataUtil.getAfterMonth(currDate, 1);

            //�ʼ��Է°� Check ����ȭ�� ���� ������
            if (applyHolidayDate.equals("")){
                 errorCode = MobileCodeErrVO.ERROR_CODE_500;
                 errorMsg  = MobileCodeErrVO.ERROR_MSG_500+ "��û���ڴ� �ʼ� �Է��Դϴ�.";
                 xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
                 return xmlString;
            }
            if (applyHolidayType.equals("")){
                errorCode = MobileCodeErrVO.ERROR_CODE_500;
                errorMsg  = MobileCodeErrVO.ERROR_MSG_500+ "�ٹ�/�޹� ������ �ʼ� �Է��Դϴ�.";
                xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
                return xmlString;
            }
            if (applyHolidayReason.equals("")){
                errorCode = MobileCodeErrVO.ERROR_CODE_500;
                errorMsg  = MobileCodeErrVO.ERROR_MSG_500+ "��û������ �ʼ� �Է��Դϴ�.";
                xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
                return xmlString;
            }
            if (applyHolidayFromDate.equals("")){
                errorCode = MobileCodeErrVO.ERROR_CODE_500;
                errorMsg  = MobileCodeErrVO.ERROR_MSG_500+ "��û�����ϴ�  �ʼ� �Է��Դϴ�.";
                xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
                return xmlString;
            }
            if (applyHolidayToDate.equals("")){
                errorCode = MobileCodeErrVO.ERROR_CODE_500;
                errorMsg  = MobileCodeErrVO.ERROR_MSG_500+ "��û�����ϴ�  �ʼ� �Է��Դϴ�.";
                xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
                return xmlString;
            }
            //C20140515_40601 �����ް�(����):0120,�Ĺ�:0121 �ð��� �� ��� ��û�Ұ�//20180702 - �ð������� ��� �ο� ����.
            if (( phonenumdata.E_PERSK.equals("27")||phonenumdata.E_PERSK.equals("28")||phonenumdata.E_PERSK.equals("36")||phonenumdata.E_PERSK.equals("37") ) &&
            	(applyHolidayType.equals( "0120" )||applyHolidayType.equals( "0121" ) ) ){

                errorCode = MobileCodeErrVO.ERROR_CODE_500;
                errorMsg  = MobileCodeErrVO.ERROR_MSG_500+ "�繫�� �ð������� ����� �����ް�(����), �����ް�(�Ĺ�)�� ������ �� �����ϴ�.";
                xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
                return xmlString;
            }
            
/*            //�׽�Ʈ ������
              applyHolidayDate       =  "2018.07.02";        // ��û��
              applyHolidayType       =  "0112";        // �ٹ�/�޹� ����
              applyHolidayReason     =  "����� ��û ���� ���� ����";       // ��û ����
              applyHolidayFromDate   =  "2018.07.03";      // ��û������
              applyHolidayToDate     =  "2018.07.03";
              applyHolidayFromTime   =  "";        // ���۽ð�
              applyHolidayToTime     =  "";     // ����ð�
              //applyHolidayRemainDate = "53.0";         // �ܿ��ϼ�
              DEDUCT_DATE = "";*/
            

            //�����ް��϶��� 1,
            if (applyHolidayType.equals( "0110" ) || applyHolidayType.equals( "0111" )){//CSR ID:3700538 ���� ���� �߰�
                DEDUCT_DATE  = "1";
            }else if (applyHolidayType.equals( "0120" )||applyHolidayType.equals( "0121" ) ||applyHolidayType.equals( "0112" )||applyHolidayType.equals( "0113" )){//CSR ID:3700538 ���� ���� �߰�
            	DEDUCT_DATE  = "0.5";
            }else{
            	  DEDUCT_DATE  = "0";
            }
            //Logger.debug.println("D03VocationMbBuildSV applyHolidayFromDate +++++++++++++++++++++++++>"+ WebUtil.printDate(DataUtil.delDateGubn(applyHolidayFromDate)) );
            //Logger.debug.println("D03VocationMbBuildSV applyHolidayToDate   +++++++++++++++++++++++++>"+ WebUtil.printDate(DataUtil.delDateGubn(applyHolidayToDate)) );

            /////////////////////////////////////////////////////////////////////////////
            // �ް���û ����..
            //d03VocationData.BEGDA       = WebUtil.printDate(applyHolidayDate,"-");
            d03VocationData.BEGDA       = applyHolidayDate     ;
            d03VocationData.AWART       = applyHolidayType     ;
            d03VocationData.REASON      = applyHolidayReason   ;

            d03VocationData.APPL_FROM   = applyHolidayFromDate ;
            d03VocationData.APPL_TO     = applyHolidayToDate   ;
            d03VocationData.BEGUZ       = applyHolidayFromTime ;
            d03VocationData.ENDUZ       = applyHolidayToTime   ;

            //d03VocationData.APPL_FROM   = WebUtil.printDate(applyHolidayFromDate,"-");
            //d03VocationData.APPL_TO     = WebUtil.printDate(applyHolidayToDate,"-");
            //d03VocationData.BEGUZ       = DataUtil.removeStructur(applyHolidayFromTime,":")   ;
            //d03VocationData.ENDUZ       = DataUtil.removeStructur(applyHolidayToTime,":")     ;
            d03VocationData.DEDUCT_DATE = DEDUCT_DATE;  // �����ϼ�
            //**********�����κ� ���� (20050223:�����)**********
            d03VocationData.ZPERNR       = user.empNo;                  //��û�� ��� ����(�븮��û ,���� ��û)
            d03VocationData.UNAME        = user.empNo;                  //��û�� ��� ����(�븮��û ,���� ��û)
            d03VocationData.AEDTM        = DataUtil.getCurrentDate();   // ������(���糯¥)
            d03VocationData.CONG_CODE    = "";   // ��������
            d03VocationData.OVTM_CODE    = "";   // �����ڵ�CSR ID:1546748
            d03VocationData.OVTM_NAME    = "";   // �����ڵ�CSR ID:1546748
            //**********���� �κ� ��.****************************
            Logger.debug.println("D03VocationMbBuildSV d03VocationData +++++++++++++++++++++++++>"+d03VocationData.toString() );
            //rfcRemain                   = new D03RemainVocationRFC();//[CSR ID:3700538] �ܿ��ް� �ϼ� function ����
            rfcRemain                   = new D03GetWorkdayOfficeRFC();
            //d03RemainVocationData       = (D03RemainVocationData)rfcRemain.getRemainVocation(PERNR, d03VocationData.APPL_TO);
            //A : �����ް�, B : �����ް�, C : ��ü�ް�(Report ��), M ����Ͽ� �ް���ȸ //��û�Ͽ� ���� �ܿ� �ް� üũ�� ���� from ��¥�� ������.
            String compensation_remaint = DataUtil.getValue((D03GetWorkdayData)rfcRemain.getWorkday( PERNR, d03VocationData.APPL_FROM, "B" ), "ZKVRB");
            Logger.debug.println(this, "[compensation_remaint]   pernr:"+PERNR+", d03VocationData.APPL_FROM:"+d03VocationData.APPL_FROM+", RemainVocation : " + compensation_remaint);
            String annualLeave_remaint = DataUtil.getValue((D03GetWorkdayData)rfcRemain.getWorkday( PERNR, d03VocationData.APPL_FROM, "A" ), "ZKVRB");
            Logger.debug.println(this, "[annualLeave_remaint]  pernr:"+PERNR+", d03VocationData.APPL_FROM:"+d03VocationData.APPL_FROM+", RemainVocation : " + annualLeave_remaint);
            //d03VocationData.REMAIN_DATE = d03RemainVocationData.E_REMAIN;
//            d03VocationData.REMAIN_DATE = d03RemainVocationData.ZKVRB;

            //Logger.debug.println("D03VocationMbBuildSV d03VocationData +++++++++++++++++++++++++>"+d03VocationData.toString() );

            Logger.debug.println("D03VocationMbBuildSV apprItem user.e_regno:+++++++++++++++++++++++++>"+user.e_regno );
            //�����ް��� ������ ���� Check
            if (d03VocationData.AWART.equals("0150")){
            	if( !user.e_regno.equals("") && (user.e_regno.substring(6,7).equals("1")||
            		 user.e_regno.substring(6,7).equals("3")||
            		 user.e_regno.substring(6,7).equals("5")||
            		 user.e_regno.substring(6,7).equals("7")||
            		 user.e_regno.substring(6,7).equals("9")) ) {

            		 errorCode = MobileCodeErrVO.ERROR_CODE_500;
                     errorMsg = MobileCodeErrVO.ERROR_MSG_500+"�����ް��� ������ ��û �����մϴ�.";
                     xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
                     return xmlString;
            	}

            }
            //��¥ �ߺ� Check�� ����  --------------------------------------
            D16OTHDDupCheckRFC func2 = new D16OTHDDupCheckRFC();
            Vector OTHDDupCheckData_vt = func2.getCheckList( PERNR, UPMU_TYPE, user.area );
            Logger.debug.println("D03VocationMbBuildSV OTHDDupCheckData_vt1 PERNR:+++++++++++++++++++++++++>"+PERNR );
            Logger.debug.println("D03VocationMbBuildSV OTHDDupCheckData_vt1.size:+++++++++++++++++++++++++>"+OTHDDupCheckData_vt.size() );
            for( int i = 0 ; i < OTHDDupCheckData_vt.size() ; i++ ) {
                D16OTHDDupCheckData2 dup_Data = (D16OTHDDupCheckData2)OTHDDupCheckData_vt.get(i);

                //Logger.debug.println("D03VocationMbBuildSV OTHDDupCheckData_vt1.size:+++++++++++++++++++++++++>"+OTHDDupCheckData_vt.toString() );


	        	String s_BEGUZ1 = "";
	        	String s_ENDUZ1 = "";
                int s_BEGUZ = 0;
                int s_ENDUZ = 0;

                dup_Data.APPL_FROM = DataUtil.removeStructur(dup_Data.APPL_FROM,"-");
                dup_Data.APPL_TO = DataUtil.removeStructur(dup_Data.APPL_TO,"-");

	        	if (dup_Data.BEGUZ.equals("")){
	        		//Logger.debug.println(" jmk test 11 c_Data.BEGUZ-->"+i+":"+c_Data.BEGUZ);
	        	    s_BEGUZ1 = "";
	        	    s_BEGUZ = 0;
	        	}else{
	        		//Logger.debug.println(" jmk test 22 c_Data.BEGUZ-->"+i+":"+c_Data.BEGUZ);
	        		//Logger.debug.println(" jmk test 22 c_Data.BEGUZ.substring(0,2)-->"+i+":"+c_Data.BEGUZ.substring(0,2));
	        		//Logger.debug.println(" jmk test 22 c_Data.BEGUZ.substring(3,5)-->"+i+":"+c_Data.BEGUZ.substring(3,5));
                    s_BEGUZ1 = dup_Data.BEGUZ.substring(0,2) + dup_Data.BEGUZ.substring(3,5);
                    s_BEGUZ = Integer.parseInt(s_BEGUZ1);
	            }
	        	//Logger.debug.println(" jmk test 33 c_Data.ENDUZ-->"+i+":"+c_Data.ENDUZ);
	        	if (dup_Data.ENDUZ.equals("")){
	        		//Logger.debug.println(" jmk test 44 c_Data.ENDUZ-->"+i+":"+c_Data.ENDUZ);
	        	    s_ENDUZ1 = "";
	        	    s_ENDUZ = 0;
	        	}else{
	        		//Logger.debug.println(" jmk test 55 c_Data.ENDUZ-->"+i+":"+c_Data.ENDUZ);
	                s_ENDUZ1 = dup_Data.ENDUZ.substring(0,2) + dup_Data.ENDUZ.substring(3,5);
                    s_ENDUZ = Integer.parseInt(s_ENDUZ1);
                }

	        	String c_APPL_FROM = "";
                String c_APPL_TO  = "";
                String c_BEGUZ = "";
                String c_ENDUZ = "";
                String c_AWART = "";

                int i_BEGUZ = 0;
	            int i_ENDUZ = 0;

	            c_APPL_FROM = DataUtil.removeStructur(d03VocationData.APPL_FROM,"-");
	            c_APPL_TO   = DataUtil.removeStructur(d03VocationData.APPL_TO,"-");
	            c_AWART     = d03VocationData.AWART;

	            c_BEGUZ     = DataUtil.removeStructur(d03VocationData.BEGUZ,":");
	            if (c_BEGUZ.equals("")) {
	            	i_BEGUZ     = 0;
	            }else{
	            	c_BEGUZ     = c_BEGUZ.substring(0, 4);
	            	i_BEGUZ     = Integer.parseInt(c_BEGUZ);
	            }
	            c_ENDUZ = DataUtil.removeStructur(d03VocationData.ENDUZ,":");
	            if ( c_ENDUZ.equals("")) {
	            	i_ENDUZ     = 0;
	            }else{
	            	 c_ENDUZ     = c_ENDUZ.substring(0, 4);
	            	 i_ENDUZ     = Integer.parseInt(c_ENDUZ);
	            }

	            //Logger.debug.println("D03VocationMbBuildSV OTHDDupCheckData_vt1 APPL_FROM:+++++++++++++++++++++++>"+c_Data.APPL_FROM );
	            //Logger.debug.println("D03VocationMbBuildSV OTHDDupCheckData_vt1 APPL_TO:+++++++++++++++++++++++++>"+c_Data.APPL_TO );
	            //Logger.debug.println("D03VocationMbBuildSV OTHDDupCheckData_vt1 c_APPL_FROM:+++++++++++++++++++++>"+c_APPL_FROM );
	            //Logger.debug.println("D03VocationMbBuildSV OTHDDupCheckData_vt1 c_APPL_TO:+++++++++++++++++++++++>"+c_APPL_TO );


	            if(c_AWART.equals( "0120" )||c_AWART.equals( "0121" ) ||c_AWART.equals( "0112" )||c_AWART.equals( "0113")) { //if 1 : ���� ��û�Ѱ� �������
	                // �����ް�(����), �����ް�(�Ĺ�), �ð������� ���
	            	if( dup_Data.APPL_FROM.equals(c_APPL_FROM) &&dup_Data.APPL_TO.equals(c_APPL_TO)) {//if 2 : ��¥���� ���
	            		if( s_BEGUZ != 0 || s_ENDUZ != 0 ) { //if 3 : ���� ��û�� �ǵ� �� ������ ���, ����(from to �ð� ���� �ִ� ���)	                    
	                        if( s_BEGUZ1.equals(c_BEGUZ)&& s_ENDUZ1.equals(c_ENDUZ)) {//�ð� ���� ���
	                              errorCode = MobileCodeErrVO.ERROR_CODE_500;
	                              errorMsg = MobileCodeErrVO.ERROR_MSG_500+"���� �����û�� �Ǿ� �����Ƿ� ����������Ȳ���� Ȯ���Ͻñ� �ٶ��ϴ�.";
	                              xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
	                              return xmlString;
	                        }else if( (s_BEGUZ <= i_BEGUZ && s_ENDUZ > i_BEGUZ) ||
	                        		  ( s_BEGUZ < i_ENDUZ &&  s_ENDUZ >= i_ENDUZ) ||
	                        		  ( s_BEGUZ >= i_BEGUZ && s_ENDUZ <= i_ENDUZ) ) {//�ð��� �������� �ߺ��� ���
	                              errorCode = MobileCodeErrVO.ERROR_CODE_500;
	                              errorMsg = MobileCodeErrVO.ERROR_MSG_500+"�̹� �����û�� �ð��� �ߺ��˴ϴ�. ����������Ȳ���� Ȯ���Ͻñ� �ٶ��ϴ�.";
	                              xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
	                              return xmlString;
	                        }
	                    }else{// if 3 : ���� ��û�� �ǵ��� ���� �ް��� ���-����
	                    	errorCode = MobileCodeErrVO.ERROR_CODE_500;
                            errorMsg = MobileCodeErrVO.ERROR_MSG_500+"�̹� �����û�� �ð��� �ߺ��˴ϴ�. ����������Ȳ���� Ȯ���Ͻñ� �ٶ��ϴ�.";
                            xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
                            return xmlString;
	                    }
	                }else if( ( Integer.parseInt(dup_Data.APPL_FROM)  <= Integer.parseInt(c_APPL_FROM) && Integer.parseInt(dup_Data.APPL_TO)  > Integer.parseInt(c_APPL_FROM)) ||
                        		   ( Integer.parseInt(dup_Data.APPL_FROM)  <  Integer.parseInt(c_APPL_TO)   && Integer.parseInt(dup_Data.APPL_TO) >= Integer.parseInt(c_APPL_TO)) ||
                        		   ( Integer.parseInt(dup_Data.APPL_FROM)  >= Integer.parseInt(c_APPL_FROM) && Integer.parseInt(dup_Data.APPL_TO)  <= Integer.parseInt(c_APPL_TO))){
	                	//��¥�� �ٸ��� from-to�� ��ġ�� ���
	                	errorCode = MobileCodeErrVO.ERROR_CODE_500;
                        errorMsg = MobileCodeErrVO.ERROR_MSG_500+"�̹� �����û�� �ð��� �ߺ��˴ϴ�. ����������Ȳ���� Ȯ���Ͻñ� �ٶ��ϴ�.";
                        xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
                        return xmlString;
	                }
	            } //if 1 ������ ��� ��
	            
	                else { //���� �ް��� ���
                        if( dup_Data.APPL_FROM.equals(c_APPL_FROM) && dup_Data.APPL_TO.equals(c_APPL_TO)) { //if 2 : ��¥���� ���
	                        errorCode = MobileCodeErrVO.ERROR_CODE_500;
	                        errorMsg = MobileCodeErrVO.ERROR_MSG_500+"���� �����û�� �Ǿ� �����Ƿ� ����������Ȳ���� Ȯ���Ͻñ� �ٶ��ϴ�.";
	                        xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
	                        return xmlString;
                        } else if( ( Integer.parseInt(dup_Data.APPL_FROM)  <= Integer.parseInt(c_APPL_FROM) && Integer.parseInt(dup_Data.APPL_TO)  > Integer.parseInt(c_APPL_FROM)) ||
                        		   ( Integer.parseInt(dup_Data.APPL_FROM)  <  Integer.parseInt(c_APPL_TO)   && Integer.parseInt(dup_Data.APPL_TO) >= Integer.parseInt(c_APPL_TO)) ||
                        		   ( Integer.parseInt(dup_Data.APPL_FROM)  >= Integer.parseInt(c_APPL_FROM) && Integer.parseInt(dup_Data.APPL_TO)  <= Integer.parseInt(c_APPL_TO)) ) {
	                        errorCode = MobileCodeErrVO.ERROR_CODE_500;
	                        errorMsg = MobileCodeErrVO.ERROR_MSG_500+"�̹� �����û�� ��¥�� �ߺ��˴ϴ�. ����������Ȳ���� Ȯ���Ͻñ� �ٶ��ϴ�.";
	                        xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
	                        return xmlString;
                        } //if 3
	                } //if 2
	           

            }
            //��¥ �ߺ� Check�� ����  end --------------------------------------

            //  2003.01.29 - �ð������� ���� ���� �������� �о� ��û�� �����ش�.
            GetTimmoRFC rfcTime = new GetTimmoRFC();
            String E_RRDAT = rfcTime.GetTimmo( user.companyCode );
            Logger.debug.println("D03VocationMbBuildSV OTHDDupCheckData_vt1 d03VocationData.APPL_FROM:+++++++++++++++++++++++++>"+d03VocationData.APPL_FROM );
            Logger.debug.println("D03VocationMbBuildSV OTHDDupCheckData_vt1 E_RRDAT:+++++++++++++++++++++++++>"+E_RRDAT );

            long   D_RRDAT = Long.parseLong(DataUtil.removeStructur(E_RRDAT,"-"));
            long  D_APPL_FROM = Long.parseLong(DataUtil.removeStructur(d03VocationData.APPL_FROM,"-"));
            if (E_RRDAT.equalsIgnoreCase("")){
            	E_RRDAT="0000-00-00";
            }
            Logger.debug.println("D03VocationMbBuildSV OTHDDupCheckData_vt1 d03VocationData.APPL_FROM:+++++++++>"+d03VocationData.APPL_FROM );
            Logger.debug.println("D03VocationMbBuildSV OTHDDupCheckData_vt1 E_RRDAT:+++++++++++++++++++++++++>"+E_RRDAT );
            if( D_APPL_FROM < D_RRDAT ) {
                errorCode = MobileCodeErrVO.ERROR_CODE_500;
                errorMsg = MobileCodeErrVO.ERROR_MSG_500+"�ް��� "+ WebUtil.printDate(E_RRDAT)+"�� ���Ŀ��� ��û �����մϴ�.";
                xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
                return xmlString;
            }

            //------------------------------------ ���� �ٹ� ���� üũ ------------------------------------//
            dateFrom    = d03VocationData.APPL_FROM;
            dateTo      = d03VocationData.APPL_TO;

            //[CSR ID:3700538]�����ް� ������ �����ް��� �ܿ� ������ ��� �� �ֵ���.
            if(d03VocationData.AWART.equals("0111")||d03VocationData.AWART.equals("0112")||d03VocationData.AWART.equals("0113")){
            	remain_date =  NumberUtils.toDouble(compensation_remaint);
            }else{
            	remain_date =  NumberUtils.toDouble(annualLeave_remaint);
            }

            //remain_date = NumberUtils.toDouble(d03RemainVocationData.E_REMAIN);  //Double.parseDouble(box.get("REMAIN_DATE"));
//            remain_date = NumberUtils.toDouble(d03RemainVocationData.ZKVRB);  //Double.parseDouble(box.get("REMAIN_DATE"));

            Vector d03WorkPeriodData_vt = rfcWork.getWorkPeriod( PERNR, dateFrom, dateTo );
            Logger.debug.println(this, "���� �Ⱓ �۾� ������ : " + d03WorkPeriodData_vt.toString());

            //--2002.09.06. ���̳ʽ� �ް��� ������ ��츦 üũ�ϰ� �Ѱ踦 ���Ѵ�. ------------------------------------//
            D03MinusRestRFC func_minus = new D03MinusRestRFC();
            String          minusRest  = func_minus.check(PERNR, user.companyCode, dateFrom);
            double          minus      = NumberUtils.toDouble(minusRest);
            if( minus < 0.0 ) {
                minus = minus * (-1);
            }
/*
            // LG����ȭ�� ����, ����, ����ް� ��û�� ���̳ʽ��ް� �����Ѵ�.---------------------------------------
            if( user.companyCode.equals("N100") ) {
                remain_date = remain_date + minus;
            // LGȭ���̸鼭 ����ް� ��û�� ���̳ʽ��ް� �����Ѵ�.---------------------------------------
            } else*/
            if( user.companyCode.equals("C100") && d03VocationData.AWART.equals("0122") ) {
                remain_date = remain_date + minus;
            }

            Logger.debug.println(this, "remain_date : " + remain_date);
            //--2002.09.06. ���̳ʽ� �ް��� ������ ��츦 üũ�ϰ� �Ѱ踦 ���Ѵ�. --------------------------//

            // ��¥ ������ sap�� ��Ģ�� ������. //
            /* �����ް� : �ް� �ܿ��ϼ����� ���� �ϼ��� ��û�Ҽ� ����.
		             ��û �Ⱓ�� �ٹ� �ϼ�(����ϰ� ���� ����)�� ����ؼ� �����ϼ��� ���Ѵ�.
		             ���Ϲ��� : ���Ͽ��� ��û����
		             ����ް� : ����Ͽ��� ��û�����ϸ�, �繫���� ��츸 ��û�����ϴ�.
		             �����ް� : 6�� ���Ϸ� ��û�����ϴ�.
		             �ϰ��ް� : 5�� ���Ϸ� ��û�����ϴ�.
		             ���ϰ��� : �Ⱓ ���� ���� ��û�����ϴ�.(��, ����Ͽ����� 1day �� ����)
		             �ð����� : �ٹ������� �����ϴ� ������ ��û�����ϴ�.
		             �޹��ϼ��� ���ϱٹ������� ����Ϸ� ���Ѵ�.                            */

            if( d03VocationData.AWART.equals("0110")||d03VocationData.AWART.equals("0111") ) {  // �����ް�..
                int count     = 0;
                int day_count = 0;

                for( int i = 0 ; i < d03WorkPeriodData_vt.size() ; i++ ) {
                    d03WorkPeriodData = (D03WorkPeriodData)d03WorkPeriodData_vt.get(i);

                    // ��û�Ⱓ ���ڼ��� ���Ѵ�.
                    day_count++;

                    // �ٹ��ð� ���
                    beg_time  = Long.parseLong(d03WorkPeriodData.BEGUZ);
                    end_time  = Long.parseLong(d03WorkPeriodData.ENDUZ);

                    work_time = end_time - beg_time;
                    if( work_time > 40000 ) {
                        count++;
                    }

                    // �޹��ϼ� ���
                    if( work_time >= 40000 ) {
                        vacation_day++;
                    }
                }

                if( count == day_count ) {
                    if( count > remain_date ) {
                        errorCode = MobileCodeErrVO.ERROR_CODE_500;
                        errorMsg  = MobileCodeErrVO.ERROR_MSG_500+"�ް���û�ϼ�(�ð�)�� �ܿ��ް��ϼ�(�ð�) ���� �����ϴ�.";

                        //[CSR ID:2942508] �����ް� ��û �˾� ��û
                        if(currMon.equals("12") && !d03VocationData.AWART.equals("0111")){
                        	errorMsg=MobileCodeErrVO.ERROR_MSG_500+"�ް��Ⱓ�� '"+currDate.substring(2, 4)+".12.21 ������ ���, '"+nextMon.substring(2, 4)+"�� �ű� ������ �����Ǿ�� ��û �����մϴ�.(����������:'"+currDate.substring(2, 4)+".12.21)";
                        }
                        xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
                        return xmlString;

                    } else if( count == 0 ) {
                        errorCode = MobileCodeErrVO.ERROR_CODE_500;
                        errorMsg  = MobileCodeErrVO.ERROR_MSG_500+"��û�Ⱓ�� �ٹ������� �������� �ʽ��ϴ�.";
                        xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
                        return xmlString;
                    }
                    d03VocationData.DEDUCT_DATE = Double.toString(count);   // �����ް��϶��� �����ϼ��� �ٽ� ����Ѵ�.
                } else {
                	errorCode = MobileCodeErrVO.ERROR_CODE_500;
                    errorMsg  = MobileCodeErrVO.ERROR_MSG_500+"�����ް��� �ٹ������� �ִ� ���Ͽ��� ��û�����մϴ�.";
                    xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
                    return xmlString;
                }

            } else if( d03VocationData.AWART.equals("0120") || d03VocationData.AWART.equals("0121") ||d03VocationData.AWART.equals("0112")||d03VocationData.AWART.equals("0113") ) { // ���Ϲ���..+�������
                d03WorkPeriodData = (D03WorkPeriodData)d03WorkPeriodData_vt.get(0);

                // �ٹ��ð� ���
                beg_time  = Long.parseLong(d03WorkPeriodData.BEGUZ);
                end_time  = Long.parseLong(d03WorkPeriodData.ENDUZ);

                work_time = end_time - beg_time;

                if( work_time > 40000 ) {
                    //vacation_day++;
                    //if( vacation_day > remain_date ) {
                    if ( remain_date < 0.5 ) {   //0.5�ϸ� ���Ҿ ��û�����ϵ���
                    	errorCode = MobileCodeErrVO.ERROR_CODE_500;
                        errorMsg  = MobileCodeErrVO.ERROR_MSG_500+ "�ް���û�ϼ�(�ð�)�� �ܿ��ް��ϼ�(�ð�) ���� �����ϴ�.";

                      //[CSR ID:2942508] �����ް� ��û �˾� ��û
                        if(currMon.equals("12")){
                        	errorMsg=MobileCodeErrVO.ERROR_MSG_500+"�ް��Ⱓ�� '"+currDate.substring(2, 4)+".12.21 ������ ���, '"+nextMon.substring(2, 4)+"�� �ű� ������ �����Ǿ�� ��û �����մϴ�.(����������:'"+currDate.substring(2, 4)+".12.21)";
                        }
                        xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
                        return xmlString;

                    }
                } else {
                	errorCode = MobileCodeErrVO.ERROR_CODE_500;
                    errorMsg  = MobileCodeErrVO.ERROR_MSG_500+ "�����ް��� �ٹ������� �ִ� ���Ͽ��� ��û�����մϴ�.";
                    xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
                    return xmlString;
                }


                // [��CSR ID:C20130130_63372]�����ް� ��û �����û
                // 21:���λ��,22:�繫��
                //1. ����(����):0120 ����ð��� 14:00 ���� �Ұ�
                //2. ����(�Ĺ�):0121 ���۽ð��� 13:00 ���� �Ұ�

              if (Integer.parseInt(DataUtil.removeStructur(d03VocationData.APPL_FROM,"-"))<Integer.parseInt("20170801")){ //[CSR ID:3438118] flexible time �ý��� ��û 20170720 eunha
                if( phonenumdata.E_PERSK.equals("21")||phonenumdata.E_PERSK.equals("22") ) {

	                if( d03VocationData.AWART.equals("0120") &&  Long.parseLong(d03VocationData.ENDUZ) > 140000  ) {
	                	errorCode = MobileCodeErrVO.ERROR_CODE_500;
	                    errorMsg  = MobileCodeErrVO.ERROR_MSG_500+ "�����ް�(����) ����ð��� 14:00 ���ķ� �Է��� �� �����ϴ�.";
	                    xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
	                    return xmlString;
	                }
	                if( d03VocationData.AWART.equals("0121") && Long.parseLong(d03VocationData.BEGUZ) < 130000  ) {
	                	errorCode = MobileCodeErrVO.ERROR_CODE_500;
	                    errorMsg  = MobileCodeErrVO.ERROR_MSG_500+ "�����ް�(�Ĺ�) ���۽ð��� 13:00 �������� �Է��� �� �����ϴ�.";
	                    xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
	                    return xmlString;
	                }
                }
              }//[CSR ID:3438118] flexible time �ý��� ��û 20170720 eunha

            } else if( d03VocationData.AWART.equals("0122") ) {     // ����ް�..
                d03WorkPeriodData = (D03WorkPeriodData)d03WorkPeriodData_vt.get(0);

                // �ٹ��ð� ���
                beg_time  = Long.parseLong(d03WorkPeriodData.BEGUZ);
                end_time  = Long.parseLong(d03WorkPeriodData.ENDUZ);

                work_time = end_time - beg_time;

                //------------------��ġ����ٹ������� üũ�ϰ� ��ġ����ٹ����̸� ��û�� ���´�.(2002.05.29)
                D03ShiftCheckRFC func_shift = new D03ShiftCheckRFC();
                String           shiftCheck = func_shift.check(PERNR, dateFrom);
                if( shiftCheck.equals("1") ) {
                	errorCode = MobileCodeErrVO.ERROR_CODE_500;
                    errorMsg  = MobileCodeErrVO.ERROR_MSG_500+"�ް� ��û���� ���ϱٹ������� ��ġ�������� ����ް��� ��û�Ҽ� �����ϴ�.";
                    xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
                    return xmlString;
                } else {
                    //------------------��ġ����ٹ������� üũ�ϰ� ��ġ����ٹ����̸� ��û�� ���´�.
                    if( work_time >= 40000 ) {
                        vacation_day++;
                        if( vacation_day > remain_date ) {
                            //message = "�ް���û�ϼ��� �ܿ��ް��ϼ����� �����ϴ�.";
                            errorCode = MobileCodeErrVO.ERROR_CODE_500;
                            errorMsg  = MobileCodeErrVO.ERROR_MSG_500+"�ް���û�ϼ�(�ð�)�� �ܿ��ް��ϼ�(�ð�) ���� �����ϴ�.";

                          //[CSR ID:2942508] �����ް� ��û �˾� ��û
                            if(currMon.equals("12") && !(d03VocationData.AWART.equals("0112")||d03VocationData.AWART.equals("0113"))){
                            	errorMsg=MobileCodeErrVO.ERROR_MSG_500+"�ް��Ⱓ�� '"+currDate.substring(2, 4)+".12.21 ������ ���, '"+nextMon.substring(2, 4)+"�� �ű� ������ �����Ǿ�� ��û �����մϴ�.(����������:'"+currDate.substring(2, 4)+".12.21)";
                            }
                            xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
                            return xmlString;
                        }
                    } else {
                        //message = "����ް��� �ٹ������� �ִ� ����Ͽ��� ��û�����մϴ�.";
                        errorCode = MobileCodeErrVO.ERROR_CODE_500;
                        errorMsg  = MobileCodeErrVO.ERROR_MSG_500+"����ް��� �ٹ������� �ִ� ����Ͽ��� ��û�����մϴ�.";
                        xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
                        return xmlString;
                    }
                }

            } else if( d03VocationData.AWART.equals("0130")||d03VocationData.AWART.equals("0370") ) { // �����ް�, [CSR ID : 1225704] 0370:�ڳ���깫��
                int count = 0;
                for( int i = 0 ; i < d03WorkPeriodData_vt.size() ; i++ ) {
                    d03WorkPeriodData = (D03WorkPeriodData)d03WorkPeriodData_vt.get(i);

                    // �ٹ��ð� ���
                    beg_time  = Long.parseLong(d03WorkPeriodData.BEGUZ);
                    end_time  = Long.parseLong(d03WorkPeriodData.ENDUZ);

                    work_time = end_time - beg_time;
                    if( work_time >= 40000 ) {
                        count++;
                    }

                    // �޹��ϼ� ���
                    if( work_time >= 40000 ) {
                        vacation_day++;
                    }
                }

                String date = DataUtil.getCurrentDate();
                int day9001 =0;
                if (Integer.parseInt(date) >= 20120802) { //20120802�� ���� �ڳ����� ���� �ް� 1�� ��3��
                	day9001=3;
                }else{
                	day9001=1;
                }
                if( d03VocationData.CONG_CODE.equals("9001") && count > day9001 ) {
                    //message = "�����ް�:�ڳ����(����)�� "+day9001+"�� ���Ϸ� ��û �����մϴ�.";
                    errorCode = MobileCodeErrVO.ERROR_CODE_500;
                    errorMsg  = MobileCodeErrVO.ERROR_MSG_500+ "�����ް�:�ڳ����(����)��"+day9001+"�� ���Ϸ� ��û �����մϴ�.";
                    xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
                    return xmlString;
                } else if( d03VocationData.CONG_CODE.equals("9002") && count > 2 ) {
                        //message = "�����ް�:�ڳ����(����)�� 2�� ���Ϸ� ��û �����մϴ�.";
                        errorCode = MobileCodeErrVO.ERROR_CODE_500;
                        errorMsg  = MobileCodeErrVO.ERROR_MSG_500+"�����ް�:�ڳ����(����)�� 2�� ���Ϸ� ��û �����մϴ�.";
                        xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
                        return xmlString;
                } else if( count > 6 ) {
                        // = "�����ް��� 6�� ���Ϸ� ��û �����մϴ�.";
                        errorCode = MobileCodeErrVO.ERROR_CODE_500;
                        errorMsg  = MobileCodeErrVO.ERROR_MSG_500+"�����ް��� 6�� ���Ϸ� ��û �����մϴ�.";
                        xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
                        return xmlString;
                } else if( count == 0 &&  DataUtil.getDay( DataUtil.removeStructur(d03WorkPeriodData.BEGDA,"-") ) != 7  ) {
                    //message = "��û�Ⱓ�� �ٹ������� �������� �ʽ��ϴ�.";
                    errorCode = MobileCodeErrVO.ERROR_CODE_500;
                    errorMsg  = MobileCodeErrVO.ERROR_MSG_500+"�����ް��� 6�� ���Ϸ� ��û �����մϴ�.";
                    xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
                    return xmlString;
                }

            } else if( d03VocationData.AWART.equals("0140") ) { // �ϰ��ް�..
                // 2003.01.02. - �ϰ��ް� ����ϼ��� ��������.
                D03VacationUsedRFC    rfcVacation           = new D03VacationUsedRFC();
                double                E_ABRTG               = NumberUtils.toDouble( rfcVacation.getE_ABRTG(PERNR) );
                //----------------------------------------------------------------------------------------------------

                int count = 0;
                for( int i = 0 ; i < d03WorkPeriodData_vt.size() ; i++ ) {
                    d03WorkPeriodData = (D03WorkPeriodData)d03WorkPeriodData_vt.get(i);

                    // �ٹ��ð� ���
                    beg_time  = Long.parseLong(d03WorkPeriodData.BEGUZ);
                    end_time  = Long.parseLong(d03WorkPeriodData.ENDUZ);

                    work_time = end_time - beg_time;
                    if( work_time >= 40000 ) {
                        count++;
                    }

                    // �޹��ϼ� ���
                    if( work_time >= 40000 ) {
                        vacation_day++;
                    }
                }
                //��CSR ID:C20130617_50756
                if (phonenumdata.E_WERKS.equals("AA00")||phonenumdata.E_WERKS.equals("AB00") ) {

                    String checkFrom = DataUtil.getCurrentYear()+"0701";
                    String checkTo   = DataUtil.getCurrentYear()+"0831";
                    String c_APPL_FROM = DataUtil.removeStructur(d03VocationData.APPL_FROM,"-");
                    String c_APPL_TO   = DataUtil.removeStructur(d03VocationData.APPL_TO,"-");
    	            if(   ( Integer.parseInt(c_APPL_FROM)  < Integer.parseInt(checkFrom) || Integer.parseInt(c_APPL_FROM)  > Integer.parseInt(checkTo) ) ||
    	            	  ( Integer.parseInt(c_APPL_TO)  < Integer.parseInt(checkFrom) || Integer.parseInt(c_APPL_TO)  > Integer.parseInt(checkTo) )
     	            	)
    	            {
                        errorCode = MobileCodeErrVO.ERROR_CODE_500;
                        errorMsg  = MobileCodeErrVO.ERROR_MSG_500+ "�ϰ��ް� �Ⱓ ( " +WebUtil.printDate( checkFrom) +"~"+WebUtil.printDate(checkTo)+ " ) �� �ƴϿ��� Ȯ���� ���û �ٶ��ϴ�.";
                        xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
                        return xmlString;
    	            }

                }
                if( (count + E_ABRTG) > 5 ) {
                    //message = "�ϰ��ް��� 5�� ���Ϸ� ��û �����մϴ�. ���� ����� �ϰ��ް� �ϼ��� " + WebUtil.printNumFormat(E_ABRTG) + "�� �Դϴ�.";
                    errorCode = MobileCodeErrVO.ERROR_CODE_500;
                    errorMsg  = MobileCodeErrVO.ERROR_MSG_500+ "�ϰ��ް��� 5�� ���Ϸ� ��û �����մϴ�. ���� ����� �ϰ��ް� �ϼ��� " + WebUtil.printNumFormat(E_ABRTG) + "�� �Դϴ�.";
                    xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
                    return xmlString;
                } else if( count == 0 ) {
                    //message = "��û�Ⱓ�� �ٹ������� �������� �ʽ��ϴ�.";
                    errorCode = MobileCodeErrVO.ERROR_CODE_500;
                    errorMsg  = MobileCodeErrVO.ERROR_MSG_500+ "��û�Ⱓ�� �ٹ������� �������� �ʽ��ϴ�.";
                    xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
                    return xmlString;

                }

            } else if( d03VocationData.AWART.equals("0170") ) { // ���ϰ���..
                int count = 0;
                for( int i = 0 ; i < d03WorkPeriodData_vt.size() ; i++ ) {
                    d03WorkPeriodData = (D03WorkPeriodData)d03WorkPeriodData_vt.get(i);

                    // �ٹ��ð� ���
                    beg_time  = Long.parseLong(d03WorkPeriodData.BEGUZ);
                    end_time  = Long.parseLong(d03WorkPeriodData.ENDUZ);

                    work_time = end_time - beg_time;
                    if( work_time >= 40000 ) {
                        count++;
                    }

                    // �޹��ϼ� ���
                    if( work_time >= 40000 ) {
                        vacation_day++;
                    }
                }
                if( count == 0 ) {
                    //message = "��û�Ⱓ�� �ٹ������� �������� �ʽ��ϴ�.";
                    errorCode = MobileCodeErrVO.ERROR_CODE_500;
                    errorMsg  = MobileCodeErrVO.ERROR_MSG_500+ "��û�Ⱓ�� �ٹ������� �������� �ʽ��ϴ�.";
                    xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
                    return xmlString;

                }

            } else if( d03VocationData.AWART.equals("0180") || d03VocationData.AWART.equals("0190")) { // �ð�����..  �𼺺�ȣ�ް��߰�_0729
                d03WorkPeriodData = (D03WorkPeriodData)d03WorkPeriodData_vt.get(0);

                // �ٹ��ð� ���
                beg_time  = Long.parseLong(d03WorkPeriodData.BEGUZ);
                end_time  = Long.parseLong(d03WorkPeriodData.ENDUZ);

                work_time = end_time - beg_time;
                if( work_time < 40000 ) {
                    //message = "��û�Ⱓ�� �ٹ������� �������� �ʽ��ϴ�.";
                    errorCode = MobileCodeErrVO.ERROR_CODE_500;
                    errorMsg  = MobileCodeErrVO.ERROR_MSG_500+  "��û�Ⱓ�� �ٹ������� �������� �ʽ��ϴ�.";
                    xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
                    return xmlString;
                }

                // �޹��ϼ� ���
                if( work_time >= 40000 ) {
                    vacation_day++;
                }

                // 2002.07.08. �����ް� ���� �߰�
            } else if( d03VocationData.AWART.equals("0150") ) { // �����ް�..
                // ����ѵ��� �����ް� ���Ͱ� �����Ҷ��� ��û�����ϵ��� üũ�Ѵ�.
                D03MinusRestRFC func_0150 = new D03MinusRestRFC();
                String          e_anzhl   = func_0150.getE_ANZHL(PERNR, dateFrom);
                double          d_anzhl   = NumberUtils.toDouble(e_anzhl);

                if( d_anzhl > 0.0 ) {
                    d03WorkPeriodData = (D03WorkPeriodData)d03WorkPeriodData_vt.get(0);

                    // �ٹ��ð� ���
                    beg_time  = Long.parseLong(d03WorkPeriodData.BEGUZ);
                    end_time  = Long.parseLong(d03WorkPeriodData.ENDUZ);

                    work_time = end_time - beg_time;
                    if( work_time < 40000 ) {
                        //message = "��û�Ⱓ�� �ٹ������� �������� �ʽ��ϴ�.";
                        errorCode = MobileCodeErrVO.ERROR_CODE_500;
                        errorMsg  = MobileCodeErrVO.ERROR_MSG_500+ g.getMessage("MSG.D.D03.0066");//"��û�Ⱓ�� �ٹ������� �������� �ʽ��ϴ�.";
                        xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
                        return xmlString;
                    }

                    // �޹��ϼ� ���
                    if( work_time >= 40000 ) {
                        vacation_day++;
                    }
                } else {
                    //message = "�ܿ�(����) �ް��� �����ϴ�.";
                    errorCode = MobileCodeErrVO.ERROR_CODE_500;
                    errorMsg  = MobileCodeErrVO.ERROR_MSG_500+"�ܿ�(����) �ް��� �����ϴ�.";
                    xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
                    return xmlString;
                }

                //  2002.08.17. LG����ȭ�� ���Ϻ�ٹ� ��û �߰�
            } else if( d03VocationData.AWART.equals("0340") ) {  // ���Ϻ�ٹ�..
                String chk_0340 = "";
                for( int i = 0 ; i < d03WorkPeriodData_vt.size() ; i++ ) {
                    d03WorkPeriodData = (D03WorkPeriodData)d03WorkPeriodData_vt.get(i);

                    //  �����̸鼭 �ٹ������� �������� ���Ϻ�ٹ� ��û �����ϴ�. CHK_0340 = 'Y'�� ���
                    chk_0340 = d03WorkPeriodData.CHK_0340;

                    if( !chk_0340.equals("Y") ) {
                        //message = "���Ϻ�ٹ��� �ٹ������� �ִ� ���Ͽ��� ��û�����մϴ�.";
                        errorCode = MobileCodeErrVO.ERROR_CODE_500;
                        errorMsg  = MobileCodeErrVO.ERROR_MSG_500+ "���Ϻ�ٹ��� �ٹ������� �ִ� ���Ͽ��� ��û�����մϴ�.";
                        xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
                        return xmlString;
                    } else {
                        vacation_day++;
                    }
                }

                // 2002.09.03. LG����ȭ�� �ٹ����� ��û �߰�
            } else if( d03VocationData.AWART.equals("0360") ) {  // �ٹ�����..
                d03WorkPeriodData = (D03WorkPeriodData)d03WorkPeriodData_vt.get(0);

                // �ٹ��ð� ���
                beg_time  = Long.parseLong(d03WorkPeriodData.BEGUZ);
                end_time  = Long.parseLong(d03WorkPeriodData.ENDUZ);

                work_time = end_time - beg_time;
                if( work_time < 40000 ) {
                    //message = "��û�Ⱓ�� �ٹ������� �������� �ʽ��ϴ�.";
                    errorCode = MobileCodeErrVO.ERROR_CODE_500;
                    errorMsg  = MobileCodeErrVO.ERROR_MSG_500+  "��û�Ⱓ�� �ٹ������� �������� �ʽ��ϴ�.";
                    xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
                    return xmlString;
                }

                // �޹��ϼ� ���
                if( work_time >= 40000 ) {
                    vacation_day++;
                }
            }

//          [CSR ID:2595636] �����Ͽ� �ް�&��� ���� ��û ��
            D16OTHDDupCheckRFC2 checkFunc = new D16OTHDDupCheckRFC2();
            Vector OTHDDupCheckData_new_vt = checkFunc.getChecResult( PERNR, UPMU_TYPE, dateFrom, dateTo);
            String e_flag = OTHDDupCheckData_new_vt.get(0).toString();
            String e_message = OTHDDupCheckData_new_vt.get(1).toString();

            if( e_flag.equals("Y")){//Y�� �ߺ�, N�� OK
            	errorCode = MobileCodeErrVO.ERROR_CODE_500;
                errorMsg  = MobileCodeErrVO.ERROR_MSG_500+ e_message;
                xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
                return xmlString;
            }

            // ����� �޹��ϼ�(��ȸȭ�鿡 �����ֱ����� �ϼ��� �����Ѵ� - �ϴ���)�� �����Ѵ�.
            d03VocationData.PBEZ4 = Double.toString(vacation_day);
            //------------------------------------ ���� �ٹ� ���� üũ ------------------------------------//

            //������ȣGET
            /*AINF_SEQN   = func.getNumberGetNext();

            d03VocationData.AINF_SEQN = AINF_SEQN;   // �������� �Ϸù�ȣ*/
            d03VocationData.PERNR     = PERNR;  // �����ȣ
            //@v1.0 �����ް��� �����߰�
            String  P_A024_SEQN   = "";         // ������û����SEQN

            //������� ����
            //ApprInfoRFC appRfc = new ApprInfoRFC();
            //AppLineData_vt1 = AppUtil.getAppVector( PERNR, UPMU_TYPE ); [CSR ID:3748125] �ּ�ó�� �� �Ʒ� �������� �ݿ�
            ApprovalLineRFC approvalLineRFC = new ApprovalLineRFC();//[CSR ID:3748125] ������� ȣ�� ���� ����
            Vector<ApprovalLineData> approvalLineList = approvalLineRFC.getApprovalLine(UPMU_TYPE, PERNR);//[CSR ID:3748125] ������� ȣ�� ���� ����

	        int nRowCount = approvalLineList.size();
	        Logger.debug.println( this, "######### ������� �� nRowCount : "+nRowCount );
          /* [CSR ID:3748125] �ּ�ó���ϰ�, approvalLineList �� �ٷ� "T_IMPORTA" �� ��� ������� �ѱ�. 
           * for( int i = 0; i < nRowCount; i++) {

                //String      idx     = Integer.toString(i);

            	  ApprovalLineData appLine = (ApprovalLineData)AppLineData_vt1.get(i);

                 // ApprovalLineData approvalLine = new ApprovalLineData();
                  approvalLine.APPU_NUMB = appLine.APPU_NUMB;//������
                  approvalLine.APPU_TYPE = appLine.APPU_TYPE;
                  approvalLine.APPR_SEQN = appLine.APPR_SEQN;

                  approvalLine.OTYPE = appLine.APPL_OTYPE;
                  approvalLine.OBJID = appLine.APPL_OBJID;

                  approvalLine.PERNR     = PERNR;//��û��
                  approvalLine.AINF_SEQN = AINF_SEQN;
                  approvalLine.APPR_TYPE = APPR_TYPE;

                  approvalLineList.addElement(appLine);
            }*/
            Logger.debug.println( this, d03WorkPeriodData_vt.toString() );
            Logger.debug.println( this, "######### ������� : "+approvalLineList.toString() );
            Logger.debug.println( this, "######### AINF_SEQN : "+AINF_SEQN );

            Logger.info.println( this, "D03VocationMb######### AINF_SEQN : "+AINF_SEQN );
            try{
                /*
            	con = DBUtil.getTransaction();
                AppLineDB appDB    = new AppLineDB(con);

                int iResult = appDB.create(AppLineData_vt);
                if ( iResult < 1 ){
                	con.rollback();
                	errorCode = MobileCodeErrVO.ERROR_CODE_400;
                    errorMsg  ="����������� DB�Է½� �����߻��Ͽ����ϴ�." ;
                    xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
                    return xmlString;
                }
*/
                Logger.debug.println(this, "########## d03VocationData : " + d03VocationData);

                box.put("T_IMPORTA", approvalLineList);
                rfc.setRequestInput(PERNR, UPMU_TYPE);
                AINF_SEQN = rfc.build( PERNR, d03VocationData,P_A024_SEQN ,box, req);
                Logger.debug.println(this, "�����ȣ  ainf_seqn=" + AINF_SEQN.toString());
                if (!rfc.getReturn().isSuccess() || AINF_SEQN == null) {
                    throw new Exception(rfc.getReturn().MSGTX);
                }
                
//                con.commit();
            } catch (Exception e){
//            	con.rollback();
            	errorCode = MobileCodeErrVO.ERROR_CODE_400;
                errorMsg  ="����������� �� �Է����� ���߽��ϴ�." ;
                if(rfc.getReturn().MSGTY.equals("E"))
                	errorMsg = rfc.getReturn().MSGTX;
                xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
                return xmlString;
            }


            // ���� ������ ��� ,
            ApprovalLineData appLine = approvalLineList.get(0);

            Logger.debug.println(this, "########## d03VocationData : " + appLine.toString());


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
            Logger.debug.println(this, "########## d03VocationData : test" );

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

	    	errorCode = MobileCodeErrVO.ERROR_CODE_500;
            errorMsg  = MobileCodeErrVO.ERROR_MSG_500+  e.getMessage();
            xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
            Logger.error(e);
            return xmlString;

	    }

	    return xmlString;
    }
}
