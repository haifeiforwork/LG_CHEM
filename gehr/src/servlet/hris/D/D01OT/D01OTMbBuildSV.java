/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 초과근무                                                        */
/*   Program Name : 초과근무 신청 (모바일에서요청)                                  */
/*   Program ID   : D01OTMBBuildSV                                        */
/*   Description  : 초과근무를 신청할 수 있도록 하는 Class                          */
/*   Note         :                                                             */
/*   Creation     : 2013-10-29     								 */
/*                  	2014-05-13  C20140515_40601  사무직시간선택제(6H,4H )  휴일,공휴일이면서 4,6시간 만 가능하게 체크로직추가*/
/*						E_PERSK - 27  : 사무직시간선택제(4H)  28 :  사무직(6H)  */
/*                  	2015-03-13 [CSR ID:2727336] HR-근태신청 오류 수정요청의 건   */
/*                     2017-06-29 eunha  [CSR ID:3420113] 인사시스템 신청 및 결재 메일 UI 표준작업*/
/*                   : 2018/06/09 rdcamel [CSR ID:3701161] 모바일 초과근무 신청/결재 로직 수정 요청 건                                                                           */
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

    private String UPMU_TYPE ="17";   // 결재 업무타입(초과근무신청)
    private String UPMU_NAME = "초과근무";
    private static String UPMU_FLAG ="A";   // 결재
    private static String APPR_TYPE ="01";   // 결재

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {

    	try{

        	Logger.debug.println("D01OTMbBuildSV start++++++++++++++++++++++++++++++++++++++" );

        	//로그인처리
        	MobileCommonSV mobileCommon = new MobileCommonSV() ;
        	mobileCommon.autoLogin(req,res);

            HttpSession session = req.getSession(false);
            WebUserData user = WebUtil.getSessionUser(req);

            String dest  = "";
            Box box = WebUtil.getBox(req);

            String empNo     = box.get("empNo"); //사번
            empNo = EncryptionTool.decrypt(empNo);
            empNo = DataUtil.fixEndZero( empNo ,8);

            Logger.debug.println("=============empNo================================="+empNo);
            // 결재처리 결과값
            String returnXml = apprItem(req,res);

            // 결과에 대한 xmlStirng을  저장한다.
            req.setAttribute("returnXml", returnXml);
            //LHtmlUtil.blockHttpCache(res);
Logger.debug.println("==============================================");
Logger.debug.println(returnXml);

            // 3.return URL을 호출한다.
            dest = WebUtil.JspURL+"common/mobileResult.jsp";
            Logger.debug.println(this, " destributed = " + dest);
            printJspPage(req, res,dest );

        } catch(Exception e) {
            throw new GeneralException(e);
        }
    }
        /**
         * 신청 결과를 XML형태로 가져온다.
         * @return
         */
    public String apprItem( HttpServletRequest req, HttpServletResponse res){

    	Element envelope = null;

        String xmlString = "";
        String itemsName = "apprResult";
        //String docStatus = "";

        String errorCode = "";
        String errorMsg = "";

       //통합결재연동 결과값
    	MobileReturnData retunMsgEL = new MobileReturnData();

        try{
        	Logger.debug.println("D01OTMbBuildSV apprItem Strart++++++++++++++++++++++++++++++++++++++" );

            HttpSession session = req.getSession(false);
            WebUserData user = WebUtil.getSessionUser(req);

            Box box = WebUtil.getBox(req);
            String empNo = box.get("empNo"); //사번
            empNo = EncryptionTool.decrypt(empNo);
            empNo = DataUtil.fixEndZero( empNo ,8);
            String PERNR = empNo;

            // 1.Envelop XML을 생성한다.
            envelope =  XmlUtil.createEnvelope();

            // 2.Body XML을 생성한다.
            Element body =  XmlUtil.createBody();

            // 3.WAT_RESPONSE 를 생성한다.
            Element waitResponse =  XmlUtil.createWaitResponse();

            // 4.결과값을 생성한다.
            Element items = XmlUtil.createItems(itemsName);

            /* //신청 데이터
            applyOtDate         신청일                   : BEGDA
            applyOtWorkDate     초과근무일               : WORK_DATE
            applyOtVtken        근태포함 checkbox        : VTKEN
            applyOtFromTime     신청시간                 : BEGUZ
            applyOtToTime       종료시간                 : ENDUZ
            applyOtOvtmCode     신청사유 선택박스(여수만): OVTM_CODE
            applyOtReason       신청사유                 : REASON
            applyOtOvtmName     원근무자(대근시)         : OVTM_NAME
            applyOtPbeg1        휴게시간1 : PBEG1
            applyOtPend1        휴게시간1 : PEND1
            applyOtPunb1        휴게시간1 : PUNB1
            applyOtPbez1        휴게시간1 : PBEZ1
            applyOtPbeg2        휴게시간2 : PBEG2
            applyOtPend2        휴게시간2 : PEND2
            applyOtPunb2        휴게시간2 : PUNB2
            applyOtPbez2        휴게시간2 : PBEZ2
		    */


            //Logger.debug.println(this, "[PERNR] = "+PERNR + " [user] : "+user.toString());

            Logger.debug.println("D01OTMbBuildSV apprItem ++++++++++++++++++++++++++++++++++++++" );

            Vector  D01OTData_vt = new Vector();
            D01OTData  D01OTData = new D01OTData();


            //대리신청
            PersonInfoRFC numfunc = new PersonInfoRFC();
            PersonData phonenumdata;
            phonenumdata = (PersonData)numfunc.getPersonInfo(PERNR);
            //신청
            //D01OTData_vt = new Vector();
            //결재라인
            Vector  AppLineData_vt     = new Vector();
            Vector  AppLineData_vt1    = new Vector();
            String  AINF_SEQN          = "";

           // String  applyOtDate       =   box.get("applyOtDate");        // 신청일
            String  applyOtDate       =   DataUtil.getCurrentDate();        // 신청일
            String  applyOtWorkDate   =   box.get("applyOtWorkDate");    // 초과근무일
            String  applyOtVtken     =   box.get("applyOtVtken");      // 근태포함 checkbox
            String  applyOtFromTime   =   DataUtil.removeBlank(box.get("applyOtFromTime"));        // 시작시간
            String  applyOtToTime     =   DataUtil.removeBlank(box.get("applyOtToTime"));        // 종료시간
            String  applyOtSTDAZ     =   DataUtil.removeBlank(box.get("applyOtSTDAZ"));        // 시간
            String  applyOtOvtmCode       =   box.get("applyOtOvtmCode");       // 신청사유 선택박스(여수만)
            String  applyOtReason     =   WebUtil.decode(box.get("applyOtReason"));       // 신청 사유
            String  applyOtOvtmName =   box.get("applyOtOvtmName");         // 원근무자(대근시)
            String  applyOtPbeg1 =   box.get("applyOtPbeg1");         // 휴게시간1
            String  applyOtPend1 =   box.get("applyOtPend1");         // 휴게시간1
            String  applyOtPunb1 =   box.get("applyOtPunb1");         // 휴게시간1
            String  applyOtPbez1 =   box.get("applyOtPbez1");         // 휴게시간1
            String  applyOtPbeg2 =   box.get("applyOtPbeg2");         // 휴게시간2
            String  applyOtPend2 =   box.get("applyOtPend2");         // 휴게시간2
            String  applyOtPunb2 =   box.get("applyOtPunb2");         // 휴게시간2
            String  applyOtPbez2 =   box.get("applyOtPbez2");         // 휴게시간2

            Logger.debug.println("D01OTMbBuildSV applyOtDate " +applyOtDate);

	        // 휴일근무,반일특근 및 체크로직 대상자GET 사무지도직(S):휴일특근,반일특근신청가능 ,사전신청체크 , 전문기능(T) : 사전신청가능
	        String E_PERSKG  = (new D03VocationAReasonRFC()).getE_PERSKG(user.companyCode ,PERNR, "2005", DataUtil.getCurrentDate());
	        XmlUtil.addChildElement(items, "apprRequestPERSKG", E_PERSKG);

	        //C20100812_18478 휴일근무 신청 대상자 조정 :팀장미만 신청가능
	        String OTbuildYn  = (new D03VocationAReasonRFC()).getE_OVTYN(user.companyCode,  PERNR, "2005",DataUtil.getCurrentDate());
	        /*// BBIA 파주사업장제외로직 구현
	        String E_BTRTL  = (new D03VocationAReasonRFC()).getE_BTRTL(user.companyCode, PERNR, "2005",DataUtil.getCurrentDate());*/
	        
	        //[CSR ID:3701161] 모바일 초과근무 신청/결재 로직 수정 요청 건
	        D25WorkTimeEmpGubRFC empGubRfc = new D25WorkTimeEmpGubRFC();
	        Vector empGub_vt = empGubRfc.getEmpGub(PERNR, DataUtil.getCurrentDate());
	        String empGubVal = "";
	        
	        if( empGub_vt != null && empGub_vt.get(0).equals("S")){
	        	empGubVal =   empGub_vt.get(3)+"";//E_TPGUB : A(사무직일반),B(현장직일반),C(사무직 선택근로),D(현장직 선택근로)
	        	Logger.debug.println(empNo +"의 E_TPGUB : A(사무직일반),B(현장직일반),C(사무직 선택근로),D(현장직 선택근로) : "+empGubVal);
            }else{
            	errorCode = MobileCodeErrVO.ERROR_CODE_600;
                errorMsg = MobileCodeErrVO.ERROR_MSG_600+empGub_vt.get(1);
		        xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
	            return xmlString;
            }//[CSR ID:3701161] 모바일 초과근무 신청/결재 로직 수정 요청 건 끝

            //대상자체크 : 모바일에서는 사무기술직만 입력가능
            if (!E_PERSKG.equals("S")){
                 errorCode = MobileCodeErrVO.ERROR_CODE_500;
                 errorMsg  = MobileCodeErrVO.ERROR_MSG_600+ "모바일 신청은 사무지도직만 가능합니다.";
                 xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
                 return xmlString;
            }
            if (!OTbuildYn.equals("Y")){
                 errorCode = MobileCodeErrVO.ERROR_CODE_500;
                 errorMsg  = MobileCodeErrVO.ERROR_MSG_600+ "초과근무 신청 대상자가 아닙니다.";
                 xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
                 return xmlString;
            }


//          2003.01.29 - 시간관리에 대한 최초 재계산일을 읽어 신청을 막아준다.
            GetTimmoRFC rfcG = new GetTimmoRFC();
            String E_RRDAT = rfcG.GetTimmo( user.companyCode );
            long   D_RRDAT = Long.parseLong(DataUtil.removeStructur(E_RRDAT,"-"));
            if( Long.parseLong(DataUtil.removeStructur(applyOtWorkDate,"-")) < D_RRDAT ) {
                errorCode = MobileCodeErrVO.ERROR_CODE_500;
                errorMsg  = MobileCodeErrVO.ERROR_MSG_600+ E_RRDAT+ "일 이후에만 신청 가능합니다.";
                xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
                return xmlString;
            }

            //필수입력값 Check
            if (applyOtDate.equals("")){
                 errorCode = MobileCodeErrVO.ERROR_CODE_500;
                 errorMsg  = MobileCodeErrVO.ERROR_MSG_600+ "신청일자는 필수 입력입니다.";
                 xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
                 return xmlString;
            }
            if (applyOtWorkDate.equals("")){
                errorCode = MobileCodeErrVO.ERROR_CODE_500;
                errorMsg  = MobileCodeErrVO.ERROR_MSG_600+ "초과근무일자는 필수 입력입니다.";
                xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
                return xmlString;
           }
            if (applyOtFromTime.equals("")){
                errorCode = MobileCodeErrVO.ERROR_CODE_500;
                errorMsg  = MobileCodeErrVO.ERROR_MSG_600+ "시작시간는  필수 입력입니다.";
                xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
                return xmlString;
            }
            if (applyOtToTime.equals("")){
                errorCode = MobileCodeErrVO.ERROR_CODE_500;
                errorMsg  = MobileCodeErrVO.ERROR_MSG_600+ "종료시간는  필수 입력입니다.";
                xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
                return xmlString;
            }
            if (applyOtReason.equals("")){
                errorCode = MobileCodeErrVO.ERROR_CODE_500;
                errorMsg  = MobileCodeErrVO.ERROR_MSG_600+ "신청사유는 필수 입력입니다.";
                xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
                return xmlString;
            }
            
            //[CSR ID:3701161] 사무직 선택근로가 아닐 경우만 로직 탄다.
            if(!empGubVal.trim().equals("C")){//E_TPGUB : A(사무직일반),B(현장직일반),C(사무직 선택근로),D(현장직 선택근로)
            //E_PERSKG : 사무지도직인경우만
	            if (Long.parseLong(applyOtFromTime) < 90000 ||Long.parseLong(applyOtFromTime) > 180000){
	                errorCode = MobileCodeErrVO.ERROR_CODE_500;
	                errorMsg  = MobileCodeErrVO.ERROR_MSG_600+ "시작시간 인정 기준시간은 9:00 ~ 18:00 입니다";
	                xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
	                return xmlString;
	            }
	            //E_PERSKG : 사무지도직인경우만
	            if (Long.parseLong(applyOtToTime) < 90000 ||Long.parseLong(applyOtToTime) > 180000){
	                errorCode = MobileCodeErrVO.ERROR_CODE_500;
	                errorMsg  = MobileCodeErrVO.ERROR_MSG_600+ "종료시간 인정 기준시간은 9:00 ~ 18:00 입니다";
	                xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
	                return xmlString;
	            }
            }
            /////////////////////////////////////////////////////////////////////////////
            // 초과근무신청 저장..
            D01OTData.BEGDA       = applyOtDate     ;        //신청일
            D01OTData.WORK_DATE   = applyOtWorkDate ;   //초과근무일
            D01OTData.VTKEN       = applyOtVtken   ;         //근태포함 checkbox
            D01OTData.BEGUZ       = applyOtFromTime ;        //신청시간
            D01OTData.ENDUZ       = applyOtToTime   ;        //종료시간
            D01OTData.OVTM_CODE   = applyOtOvtmCode ;  //신청사유 선택박스(여수만)
            D01OTData.REASON      = applyOtReason   ;       //신청사유
            D01OTData.BEGUZ       = applyOtFromTime ;       //신청시간
            D01OTData.ENDUZ       = applyOtToTime   ;       //종료시간
            D01OTData.STDAZ       = applyOtSTDAZ   ;       //시간
            D01OTData.OVTM_NAME   = applyOtOvtmName ; //원근무자(대근시)
            D01OTData.PBEG1      = applyOtPbeg1   ;     // 휴게시간1
            D01OTData.PEND1      = applyOtPend1   ;     // 휴게시간1
            D01OTData.PUNB1      = applyOtPunb1   ;     // 휴게시간1
            D01OTData.PBEZ1      = applyOtPbez1   ;     // 휴게시간1
            D01OTData.PBEG2      = applyOtPbeg2   ;     // 휴게시간2
            D01OTData.PEND2      = applyOtPend2   ;     // 휴게시간2
            D01OTData.PUNB2      = applyOtPunb2   ;     // 휴게시간2
            D01OTData.PBEZ2      = applyOtPbez2   ;     // 휴게시간2

            D01OTData.PERNR       = PERNR;                  //신청자 사번 설정(대리신청 ,본인 신청)
            D01OTData.ZPERNR       = user.empNo;                  //신청자 사번 설정(대리신청 ,본인 신청)
            D01OTData.UNAME        = user.empNo;                  //신청자 사번 설정(대리신청 ,본인 신청)
            D01OTData.AEDTM        = DataUtil.getCurrentDate();   // 변경일(현재날짜)

            //Logger.debug.println("D01OTMbBuildSV D01OTData +++++++++++++++++++++++++>"+D01OTData.toString() );

            //C20140515_40601  인사하위영역 27,36: -사무직시간선택제(4H)   4시간체크   START
            //C20140515_40601  인사하위영역 28,37: -사무직시간선택제(6H)   6시간체크
           if(phonenumdata.E_PERSK.equals("27")||phonenumdata.E_PERSK.equals("28")||phonenumdata.E_PERSK.equals("36")||phonenumdata.E_PERSK.equals("37")) { //

            	//공휴일, 토,일만 가능
            	D01OTHolidayCheckRFC funHc = new D01OTHolidayCheckRFC();
                Vector D01OTHolidayCheck_vt = funHc.check( "L1", D01OTData.WORK_DATE, D01OTData.WORK_DATE );
                D01OTHolidayCheckData HolidaycheckData = (D01OTHolidayCheckData)D01OTHolidayCheck_vt.get(0);

              	 if  ( HolidaycheckData.HOLIDAY.equals("X") || ( HolidaycheckData.WEEKDAY.equals("6" ) || HolidaycheckData.WEEKDAY.equals("7" )) ) {
                	if ( (phonenumdata.E_PERSK.equals("27")||phonenumdata.E_PERSK.equals("36"))&&!D01OTData.STDAZ.equals("4")  ) {
                        errorCode = MobileCodeErrVO.ERROR_CODE_600;
                        errorMsg = MobileCodeErrVO.ERROR_MSG_600+"사무직 시간선택제(4H) 사원은 4시간만 신청가능합니다. 다시 신청해주십시요.";
                        xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
                        return xmlString;
                	}
	               	if (( phonenumdata.E_PERSK.equals("28")|| phonenumdata.E_PERSK.equals("37"))&&!D01OTData.STDAZ.equals("6") ) {
	                    errorCode = MobileCodeErrVO.ERROR_CODE_600;
	                    errorMsg = MobileCodeErrVO.ERROR_MSG_600+"사무직 시간선택제(6H) 사원은 6시간만 신청가능합니다. 다시 신청해주십시요.";
	                    xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
	                    return xmlString;
	               	}
              	 }else{ //평일
              		if (phonenumdata.E_PERSK.equals("27")||phonenumdata.E_PERSK.equals("28"))  { //시간 선택제
	                    errorCode = MobileCodeErrVO.ERROR_CODE_600;
	                    errorMsg = MobileCodeErrVO.ERROR_MSG_600+"사무직 시간선택제 사원은  공휴일, 토요일, 일요일에만 초과근무 신청이 가능합니다 다시 신청해주십시요.";
	                    xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
	                    return xmlString;
              		}
              	}

                 Logger.debug.println(this, "HolidaycheckData : " + HolidaycheckData.toString());
            }
           //C20140515_40601  인사하위영역 27: -사무직시간선택제(6H) 공휴일 6시간체크  END

            // Dup Check
            D01OTCheckRFC funCheck = new D01OTCheckRFC();
            Vector D01OTCheck_vt = funCheck.check( PERNR, D01OTData.WORK_DATE, D01OTData.WORK_DATE, D01OTData.BEGUZ, D01OTData.ENDUZ );

            //  2002.07.04. 신청시간이 근무일정과 중복되었을경우 R3에 초과근무 신청 로직을 적용하기위해서 수정함.
            D01OTCheckData checkData = (D01OTCheckData)D01OTCheck_vt.get(0);

            if( !checkData.ERRORTEXTS.equals("") && checkData.STDAZ.equals("0") ) {  //에러메시지가 있고, 한계결정을 할 수 없는 경우
                errorCode = MobileCodeErrVO.ERROR_CODE_600;
                errorMsg = MobileCodeErrVO.ERROR_MSG_600+"근무일정과 중복되었습니다. 다시 신청해주십시요.";
                xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
                return xmlString;
            } else if( checkData.ERRORTEXTS.equals("") ) {                          //에러메시지가 없고, 정상적이거나 한계결정을 한 경우.
                if( checkData.BEGUZ.equals(D01OTData.BEGUZ) && checkData.ENDUZ.equals(D01OTData.ENDUZ) ) {
                	errorCode="";
                } else {
                    errorCode = MobileCodeErrVO.ERROR_CODE_600;
                    errorMsg = MobileCodeErrVO.ERROR_MSG_600+"근무일정과 중복됩니다. 신청시간을 변경하세요.";
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
		                    errorMsg = MobileCodeErrVO.ERROR_MSG_600+"현재 결재신청이 되어 있으므로 결재진행현황에서 확인하시기 바랍니다.";
		                    xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
		                    return xmlString;
		                }
		                //ENDUZ가 다음날로 넘어가지 않을 경우.
		                else if(  !"R".equals(c_Data.APPR_STAT) &&  s_BEGUZ  <   s_ENDUZ   && (( s_BEGUZ   <= Integer.parseInt(D01OTData.BEGUZ) &&  s_ENDUZ   > Integer.parseInt(D01OTData.BEGUZ)) || (  s_BEGUZ  < Integer.parseInt(D01OTData.ENDUZ) &&  s_ENDUZ  >= Integer.parseInt(D01OTData.ENDUZ)) || ( s_BEGUZ >= Integer.parseInt(D01OTData.BEGUZ) &&  s_ENDUZ <= Integer.parseInt(D01OTData.ENDUZ))) ) {
		                    errorCode = MobileCodeErrVO.ERROR_CODE_600;
		                    errorMsg = MobileCodeErrVO.ERROR_MSG_600+"현재 결재신청이 되어 있으므로 결재진행현황에서 확인하시기 바랍니다.";
		                    xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
		                    return xmlString;
		                }
		                //ENDUZ가 다음날로 넘어가는 경우.
//		              [CSR ID:2727336] 기 신청일이 현재 신청일보다 나중 날짜일 경우 조건이 추가되어야 함.
		                //else if(!c_Data.APPR_STAT.equals("R")   && s_BEGUZ  >  s_ENDUZ && ((( s_BEGUZ<= Integer.parseInt(D01OTData.BEGUZ) && Integer.parseInt(D01OTData.BEGUZ) < 2400) || (Integer.parseInt(D01OTData.BEGUZ) >= 0000 &&  s_ENDUZ   > Integer.parseInt(D01OTData.BEGUZ))) || ((Integer.parseInt(D01OTData.ENDUZ) <= 2400 &&  s_BEGUZ   < Integer.parseInt(D01OTData.ENDUZ)) || (Integer.parseInt(D01OTData.ENDUZ) > 0000 &&  s_ENDUZ  >= Integer.parseInt(D01OTData.ENDUZ))) || (Integer.parseInt(D01OTData.BEGUZ) >Integer.parseInt(D01OTData.ENDUZ) &&   s_BEGUZ  >= Integer.parseInt(D01OTData.BEGUZ) &&  s_ENDUZ   <= Integer.parseInt(D01OTData.ENDUZ))) ) {
		                else if(!"R".equals(c_Data.APPR_STAT)   && s_BEGUZ  >  s_ENDUZ && ((( s_BEGUZ<= Integer.parseInt(D01OTData.BEGUZ) && Integer.parseInt(D01OTData.BEGUZ) < 2400) || (Integer.parseInt(D01OTData.BEGUZ) >= 0000 &&  s_ENDUZ   > Integer.parseInt(D01OTData.BEGUZ) && s_BEGUZ  < Integer.parseInt(D01OTData.ENDUZ)) || (Integer.parseInt(D01OTData.BEGUZ) >= 0000 &&  s_BEGUZ   < Integer.parseInt(D01OTData.ENDUZ) && s_BEGUZ  > Integer.parseInt(D01OTData.ENDUZ))) || ((Integer.parseInt(D01OTData.ENDUZ) <= 2400 &&  s_BEGUZ   < Integer.parseInt(D01OTData.ENDUZ)) || (Integer.parseInt(D01OTData.ENDUZ) > 0000 &&  s_ENDUZ  >= Integer.parseInt(D01OTData.ENDUZ))) || (Integer.parseInt(D01OTData.BEGUZ) >Integer.parseInt(D01OTData.ENDUZ) &&   s_BEGUZ  >= Integer.parseInt(D01OTData.BEGUZ) &&  s_ENDUZ   <= Integer.parseInt(D01OTData.ENDUZ))) ) {
		                    errorCode = MobileCodeErrVO.ERROR_CODE_600;
		                    errorMsg = MobileCodeErrVO.ERROR_MSG_600+"이미 결재신청된 시간과 중복됩니다. 결재진행현황에서 확인하시기 바랍니다.";
		                    xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
		                    return xmlString;
		                }
		          }
          }

            //DUP CHECK END
            
            //[CSR ID:3701161] 주 52시간 근무제 초과근무 관련 체크로직 START
            D01OTCheckAddRFC ntmOtChkRfc = new D01OTCheckAddRFC();
            Vector<D01OTData> d01OtCheckData_vt = new Vector<D01OTData>();
            d01OtCheckData_vt.addElement(D01OTData);
            Vector ret = ntmOtChkRfc.check(d01OtCheckData_vt);
            if(ret.get(0).equals("E")){//''W':경고, 'E':에러 이며, W는 생산직의 경우에 발생하는 case로 모바일에서는 무시함.
            	errorCode = MobileCodeErrVO.ERROR_CODE_600;
                errorMsg = MobileCodeErrVO.ERROR_MSG_600+ret.get(1);
                xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
                return xmlString;
            }
            //[CSR ID:3701161] 주 52시간 근무제 초과근무 관련 체크로직 END
            

            NumberGetNextRFC  func              = new NumberGetNextRFC();
            //문서번호GET
            AINF_SEQN   = func.getNumberGetNext();
            D01OTData.AINF_SEQN   = AINF_SEQN;
            D01OTRFC    rfc              = new D01OTRFC();
            //결재라인 세팅
            //ApprInfoRFC appRfc = new ApprInfoRFC();
            AppLineData_vt1 = AppUtil.getAppVector( PERNR, UPMU_TYPE );


            Vector<ApprovalLineData> approvalLineList = new Vector<ApprovalLineData>();
            int nRowCount = AppLineData_vt1.size();
            Logger.debug.println( this, "######### nRowCount : "+nRowCount );
            for( int i = 0; i < nRowCount; i++) {

                //String      idx     = Integer.toString(i);

                AppLineData appLine = (AppLineData)AppLineData_vt1.get(i);

                ApprovalLineData approvalLine = new ApprovalLineData();
                approvalLine.APPU_NUMB = appLine.APPL_PERNR;//결재자
                approvalLine.APPU_TYPE = appLine.APPL_APPU_TYPE;
                approvalLine.APPR_SEQN = appLine.APPL_APPR_SEQN;

                approvalLine.OTYPE = appLine.APPL_OTYPE;
                approvalLine.OBJID = appLine.APPL_OBJID;

                approvalLine.PERNR     = PERNR;//신청자
                approvalLine.AINF_SEQN = AINF_SEQN;
                approvalLine.APPR_TYPE = APPR_TYPE;

                approvalLineList.addElement(approvalLine);


               /*
                 AppLineData appLine = new AppLineData();
               //appLine.APPL_APPU_NUMB = "00001412";
                appLine.APPL_APPU_NUMB = appLine.APPL_PERNR;//결재자
                appLine.APPL_MANDT     = user.clientNo;
                appLine.APPL_BUKRS     = user.companyCode;
                appLine.APPL_PERNR     = PERNR;//신청자
                appLine.APPL_BEGDA     = DataUtil.delDateGubn(d03VocationData.BEGDA) ;
                appLine.APPL_AINF_SEQN = AINF_SEQN;
                appLine.APPL_UPMU_TYPE = UPMU_TYPE;
                appLine.APPL_UPMU_FLAG = UPMU_FLAG;
                appLine.APPL_APPR_TYPE = APPR_TYPE;

                AppLineData_vt.addElement(appLine);*/
            }
            Logger.debug.println( this, "######### 결재라인 : "+AppLineData_vt.toString() );
            Logger.debug.println( this, "######### AINF_SEQN : "+AINF_SEQN );

            Logger.info.println( this, "D01OTMb######### AINF_SEQN : "+AINF_SEQN );
            try{
            	/*con = DBUtil.getTransaction();
                AppLineDB appDB    = new AppLineDB(con);

                int iResult = appDB.create(AppLineData_vt);
                if ( iResult < 1 ){
                	con.rollback();
                	errorCode = MobileCodeErrVO.ERROR_CODE_400;
                    errorMsg  ="결재라인정보 DB입력시 오류발생하였습니다." ;
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
                Logger.debug.println(this, "결재번호  ainf_seqn=" + AINF_SEQN.toString());
                if (!rfc.getReturn().isSuccess() || AINF_SEQN == null) {
                    throw new Exception(rfc.getReturn().MSGTX);
                }

            } catch (Exception e){
                Logger.error(e);
                errorCode = MobileCodeErrVO.ERROR_CODE_400;
                errorMsg  ="결재라인정보 를 입력하지 못했습니다." ;
                if(rfc.getReturn().MSGTY.equals("E"))
                	errorMsg = rfc.getReturn().MSGTX;
                xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
                return xmlString;
            }


            // 메일 수신자 사람 ,
            ApprovalLineData appLine = approvalLineList.get(0);


            Logger.debug.println(this, "########## D01OTData : " + appLine.toString());


            Properties ptMailBody = new Properties();
            ptMailBody.setProperty("SServer",user.SServer);                 // ElOffice 접속 서버
            ptMailBody.setProperty("from_empNo" ,user.empNo);               // 멜 발송자 사번
            ptMailBody.setProperty("to_empNo" ,appLine.APPU_NUMB);     // 멜 수신자 사번

            ptMailBody.setProperty("ename" ,phonenumdata.E_ENAME);          // (피)신청자명
            ptMailBody.setProperty("empno" ,phonenumdata.E_PERNR);          // (피)신청자 사번

            ptMailBody.setProperty("UPMU_NAME" ,UPMU_NAME);                 // 문서 이름
            ptMailBody.setProperty("AINF_SEQN" ,AINF_SEQN);
            // 신청서 순번
            // 멜 제목
            StringBuffer sbSubject = new StringBuffer(512);
            Logger.debug.println(this, "########## D01OTData : test" );

         // [CSR ID:3420113] 인사시스템 신청 및 결재 메일 UI 표준작업  2017-06-29 eunha start
            //sbSubject.append("[" + ptMailBody.getProperty("UPMU_NAME") + "] ");
            //sbSubject.append("" + ptMailBody.getProperty("ename") +"님이 신청하셨습니다.");
            sbSubject.append("[HR] 결재요청(" + ptMailBody.getProperty("UPMU_NAME") + ") ");
         // [CSR ID:3420113] 인사시스템 신청 및 결재 메일 UI 표준작업  2017-06-29 eunha end


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

	        String subMenuNm = "모바일초과근무신청";
        	ApLoggerWriter.writeApLog("모바일", subMenuNm, "D01OTMbBuildSV", subMenuNm, ctrl, cnt, val, user, req.getRemoteAddr());
        	//Aplog end

            try {
                DraftDocForEloffice ddfe = new DraftDocForEloffice();
                ElofficInterfaceData eof = ddfe.makeDocContents(AINF_SEQN ,user.SServer,ptMailBody.getProperty("UPMU_NAME"));
                Vector vcElofficInterfaceData = new Vector();
                vcElofficInterfaceData.add(eof);

                //통합결재 연동
            	MobileCommonSV mobileCommon = new MobileCommonSV() ;
                retunMsgEL = mobileCommon.ElofficInterface( vcElofficInterfaceData, user);
                //통합결재 연동관련 오류 발생시 오류값 return
                if (!retunMsgEL.CODE.equals("0")){
	  	            errorCode = MobileCodeErrVO.ERROR_CODE_400+""+retunMsgEL.CODE;
                    errorMsg  = retunMsgEL.VALUE ;
                    xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
                    return xmlString;
                }

            } catch (Exception e) {

                msg2 += "\\n" + " Eloffic 연동 실패" ;

                errorCode = MobileCodeErrVO.ERROR_CODE_400;
                errorMsg  = MobileCodeErrVO.ERROR_MSG_400+  msg2;
                xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
                return xmlString;
            } // end try

	        // 성공인경우 리턴코드에 0을 세팅한다.
	        XmlUtil.addChildElement(items, "returnDesc", "");
	        XmlUtil.addChildElement(items, "returnCode", "0");

	        // XML을 조합한다.
	        XmlUtil.addChildElement(waitResponse, items);
	        XmlUtil.addChildElement(body, waitResponse);
	        XmlUtil.addChildElement(envelope, body);

	        // 최종적으로 XML Document를 XML String을 변환한다.
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
