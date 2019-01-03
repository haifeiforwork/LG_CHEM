/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 휴가                                                        */
/*   Program Name : 휴가 신청 (모바일에서요청)                                  */
/*   Program ID   : D03VocationMBBuildSV                                        */
/*   Description  : 휴가를 신청할 수 있도록 하는 Class                          */
/*   Note         :                                                             */
/*   Creation     : 2011-05-18  JMK                                             */
/*                  2013-06-18  [※CSR ID:C20130617_50756 ] 하계휴가 신청 기간 조정요청  */
/*                  2014-05-13  C20140515_40601 E_PERSK - 27 ,28 사무직시간선택제(4H,6H) 반일은 오류처리 */
/*                                                           반일휴가(전반):0120,후반:0121, 모성보호휴가:0190,시간공가:0180  */
/*                      2014-08-24   [CSR ID:2595636] 동일일에 휴가&대근 차단 요청 건                  */
/*					 2017-07-20 eunha [CSR ID:3438118] flexible time 시스템 요청*/
/*                     2017-06-29 eunha  [CSR ID:3420113] 인사시스템 신청 및 결재 메일 UI 표준작업*/
/* update        : 2018/06/08 rdcamel [CSR ID:3700538] 보상휴가제 도입에 따른 Mobile 휴가신청 및 결재화면 수정 요청 건*/ 
/*                    2018/07/24 rdcamel [CSR ID:3748125] g-mobile 휴가 신청 시 결재 라인 오류 건 수정 */
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

    private String UPMU_TYPE ="18";   // 결재 업무타입(휴가신청)
    private String UPMU_NAME = "휴가";
    private static String UPMU_FLAG ="A";   // 결재
    private static String APPR_TYPE ="01";   // 결재

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {

    	try{

        	Logger.debug.println("D03VocationMbBuildSV start++++++++++++++++++++++++++++++++++++++" );

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
        	Logger.debug.println("D03VocationMbBuildSV apprItem Strart++++++++++++++++++++++++++++++++++++++" );

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
            applyHolidayDate          신청일
            applyHolidayType          근무/휴무 유형
            applyHolidayType          근무/휴무 유형
            applyHolidayReason        신청사유
            applyHolidayFromDate      신청시작일
            applyHolidayToDate        신청종료일
            applyHolidayFromTime      신청시간
            applyHolidayToTime        종료시간
            applyHolidayRemainDate    잔여휴가일수

            0110 전일휴가
			0120  반일휴가(전반)
			0121  반일휴가(후반)
			-------------------------
			0340 휴일비근무 - LG석유화학
			0360 근무면제 - LG석유화학
			--------------------------
			0140  하계휴가
			0130  경조휴가
			0170  전일공가
			0180  시간공가
			0150  보건휴가 - 여성
			0190  모성보호휴가 - 여성 (20140728 모바일 추가)
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

            // 잔여휴가일수// [CSR ID:3700538] function 교체
            //D03RemainVocationRFC  rfcRemain             = null;
            D03GetWorkdayOfficeRFC rfcRemain             = null;

            //대리신청
            PersonInfoRFC numfunc = new PersonInfoRFC();
            PersonData phonenumdata;
            phonenumdata = (PersonData)numfunc.getPersonInfo(PERNR);
            //신청
            //d03VocationData_vt = new Vector();
            //결재라인
            //Vector  AppLineData_vt     = new Vector(); [CSR ID:3748125]변수 삭제
            //Vector  AppLineData_vt1    = new Vector(); [CSR ID:3748125]변수 삭제
            String  AINF_SEQN          = "";

            String  dateFrom     = "";
            String  dateTo       = "";
            //String  message      = "";
            double  remain_date  = 0.0;
            double  vacation_day = 0.0;  // 휴무일수
            long    beg_time     = 0;
            long    end_time     = 0;
            long    work_time    = 0;

            String  applyHolidayDate       =   box.get("applyHolidayDate");        // 신청일
            String  applyHolidayType       =   box.get("applyHolidayType");        // 근무/휴무 유형
            String  applyHolidayReason     =   WebUtil.decode(box.get("applyHolidayReason"));       // 신청 사유 * ksc
            String  applyHolidayFromDate   =   box.get("applyHolidayFromDate");    // 신청시작일
            String  applyHolidayToDate     =   box.get("applyHolidayToDate");      // 신청종료일
            String  applyHolidayFromTime   =   DataUtil.removeBlank(box.get("applyHolidayFromTime"));        // 시작시간
            String  applyHolidayToTime     =   DataUtil.removeBlank(box.get("applyHolidayToTime"));        // 종료시간
            //String  applyHolidayRemainDate =   box.get("applyHolidayRemainDate");         // 잔여일수
            String  DEDUCT_DATE = "";


            /////////[CSR ID:2942508] 연차휴가 신청 팝업 요청///////////////////////////////////////////////////////////////
            String currDate =  DataUtil.getCurrentDate();
            String currMon = DataUtil.getCurrentMonth();
            String nextMon = DataUtil.getAfterMonth(currDate, 1);

            //필수입력값 Check 안정화후 삭제 가능함
            if (applyHolidayDate.equals("")){
                 errorCode = MobileCodeErrVO.ERROR_CODE_500;
                 errorMsg  = MobileCodeErrVO.ERROR_MSG_500+ "신청일자는 필수 입력입니다.";
                 xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
                 return xmlString;
            }
            if (applyHolidayType.equals("")){
                errorCode = MobileCodeErrVO.ERROR_CODE_500;
                errorMsg  = MobileCodeErrVO.ERROR_MSG_500+ "근무/휴무 유형은 필수 입력입니다.";
                xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
                return xmlString;
            }
            if (applyHolidayReason.equals("")){
                errorCode = MobileCodeErrVO.ERROR_CODE_500;
                errorMsg  = MobileCodeErrVO.ERROR_MSG_500+ "신청사유는 필수 입력입니다.";
                xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
                return xmlString;
            }
            if (applyHolidayFromDate.equals("")){
                errorCode = MobileCodeErrVO.ERROR_CODE_500;
                errorMsg  = MobileCodeErrVO.ERROR_MSG_500+ "신청시작일는  필수 입력입니다.";
                xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
                return xmlString;
            }
            if (applyHolidayToDate.equals("")){
                errorCode = MobileCodeErrVO.ERROR_CODE_500;
                errorMsg  = MobileCodeErrVO.ERROR_MSG_500+ "신청종료일는  필수 입력입니다.";
                xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
                return xmlString;
            }
            //C20140515_40601 반일휴가(전반):0120,후반:0121 시간제 인 경우 신청불가//20180702 - 시간선택제 대상 인원 없음.
            if (( phonenumdata.E_PERSK.equals("27")||phonenumdata.E_PERSK.equals("28")||phonenumdata.E_PERSK.equals("36")||phonenumdata.E_PERSK.equals("37") ) &&
            	(applyHolidayType.equals( "0120" )||applyHolidayType.equals( "0121" ) ) ){

                errorCode = MobileCodeErrVO.ERROR_CODE_500;
                errorMsg  = MobileCodeErrVO.ERROR_MSG_500+ "사무직 시간선택제 사원은 반일휴가(전반), 반일휴가(후반)은 선택할 수 없습니다.";
                xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
                return xmlString;
            }
            
/*            //테스트 데이터
              applyHolidayDate       =  "2018.07.02";        // 신청일
              applyHolidayType       =  "0112";        // 근무/휴무 유형
              applyHolidayReason     =  "모바일 신청 보상 반일 전반";       // 신청 사유
              applyHolidayFromDate   =  "2018.07.03";      // 신청시작일
              applyHolidayToDate     =  "2018.07.03";
              applyHolidayFromTime   =  "";        // 시작시간
              applyHolidayToTime     =  "";     // 종료시간
              //applyHolidayRemainDate = "53.0";         // 잔여일수
              DEDUCT_DATE = "";*/
            

            //전일휴가일때만 1,
            if (applyHolidayType.equals( "0110" ) || applyHolidayType.equals( "0111" )){//CSR ID:3700538 보상 전일 추가
                DEDUCT_DATE  = "1";
            }else if (applyHolidayType.equals( "0120" )||applyHolidayType.equals( "0121" ) ||applyHolidayType.equals( "0112" )||applyHolidayType.equals( "0113" )){//CSR ID:3700538 보상 반일 추가
            	DEDUCT_DATE  = "0.5";
            }else{
            	  DEDUCT_DATE  = "0";
            }
            //Logger.debug.println("D03VocationMbBuildSV applyHolidayFromDate +++++++++++++++++++++++++>"+ WebUtil.printDate(DataUtil.delDateGubn(applyHolidayFromDate)) );
            //Logger.debug.println("D03VocationMbBuildSV applyHolidayToDate   +++++++++++++++++++++++++>"+ WebUtil.printDate(DataUtil.delDateGubn(applyHolidayToDate)) );

            /////////////////////////////////////////////////////////////////////////////
            // 휴가신청 저장..
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
            d03VocationData.DEDUCT_DATE = DEDUCT_DATE;  // 공제일수
            //**********수정부분 시작 (20050223:유용원)**********
            d03VocationData.ZPERNR       = user.empNo;                  //신청자 사번 설정(대리신청 ,본인 신청)
            d03VocationData.UNAME        = user.empNo;                  //신청자 사번 설정(대리신청 ,본인 신청)
            d03VocationData.AEDTM        = DataUtil.getCurrentDate();   // 변경일(현재날짜)
            d03VocationData.CONG_CODE    = "";   // 경조내역
            d03VocationData.OVTM_CODE    = "";   // 사유코드CSR ID:1546748
            d03VocationData.OVTM_NAME    = "";   // 사유코드CSR ID:1546748
            //**********수정 부분 끝.****************************
            Logger.debug.println("D03VocationMbBuildSV d03VocationData +++++++++++++++++++++++++>"+d03VocationData.toString() );
            //rfcRemain                   = new D03RemainVocationRFC();//[CSR ID:3700538] 잔여휴가 일수 function 수정
            rfcRemain                   = new D03GetWorkdayOfficeRFC();
            //d03RemainVocationData       = (D03RemainVocationData)rfcRemain.getRemainVocation(PERNR, d03VocationData.APPL_TO);
            //A : 연차휴가, B : 보상휴가, C : 전체휴가(Report 용), M 모바일용 휴가조회 //신청일에 대한 잔여 휴가 체크를 위해 from 날짜를 대입함.
            String compensation_remaint = DataUtil.getValue((D03GetWorkdayData)rfcRemain.getWorkday( PERNR, d03VocationData.APPL_FROM, "B" ), "ZKVRB");
            Logger.debug.println(this, "[compensation_remaint]   pernr:"+PERNR+", d03VocationData.APPL_FROM:"+d03VocationData.APPL_FROM+", RemainVocation : " + compensation_remaint);
            String annualLeave_remaint = DataUtil.getValue((D03GetWorkdayData)rfcRemain.getWorkday( PERNR, d03VocationData.APPL_FROM, "A" ), "ZKVRB");
            Logger.debug.println(this, "[annualLeave_remaint]  pernr:"+PERNR+", d03VocationData.APPL_FROM:"+d03VocationData.APPL_FROM+", RemainVocation : " + annualLeave_remaint);
            //d03VocationData.REMAIN_DATE = d03RemainVocationData.E_REMAIN;
//            d03VocationData.REMAIN_DATE = d03RemainVocationData.ZKVRB;

            //Logger.debug.println("D03VocationMbBuildSV d03VocationData +++++++++++++++++++++++++>"+d03VocationData.toString() );

            Logger.debug.println("D03VocationMbBuildSV apprItem user.e_regno:+++++++++++++++++++++++++>"+user.e_regno );
            //보건휴가는 여성만 가능 Check
            if (d03VocationData.AWART.equals("0150")){
            	if( !user.e_regno.equals("") && (user.e_regno.substring(6,7).equals("1")||
            		 user.e_regno.substring(6,7).equals("3")||
            		 user.e_regno.substring(6,7).equals("5")||
            		 user.e_regno.substring(6,7).equals("7")||
            		 user.e_regno.substring(6,7).equals("9")) ) {

            		 errorCode = MobileCodeErrVO.ERROR_CODE_500;
                     errorMsg = MobileCodeErrVO.ERROR_MSG_500+"보건휴가는 여성만 신청 가능합니다.";
                     xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
                     return xmlString;
            	}

            }
            //날짜 중복 Check를 위한  --------------------------------------
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


	            if(c_AWART.equals( "0120" )||c_AWART.equals( "0121" ) ||c_AWART.equals( "0112" )||c_AWART.equals( "0113")) { //if 1 : 내가 신청한게 반차라면
	                // 반일휴가(전반), 반일휴가(후반), 시간공가의 경우
	            	if( dup_Data.APPL_FROM.equals(c_APPL_FROM) &&dup_Data.APPL_TO.equals(c_APPL_TO)) {//if 2 : 날짜같을 경우
	            		if( s_BEGUZ != 0 || s_ENDUZ != 0 ) { //if 3 : 기존 신청한 건들 중 반차일 경우, 반차(from to 시간 값이 있는 경우)	                    
	                        if( s_BEGUZ1.equals(c_BEGUZ)&& s_ENDUZ1.equals(c_ENDUZ)) {//시간 같을 경우
	                              errorCode = MobileCodeErrVO.ERROR_CODE_500;
	                              errorMsg = MobileCodeErrVO.ERROR_MSG_500+"현재 결재신청이 되어 있으므로 결재진행현황에서 확인하시기 바랍니다.";
	                              xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
	                              return xmlString;
	                        }else if( (s_BEGUZ <= i_BEGUZ && s_ENDUZ > i_BEGUZ) ||
	                        		  ( s_BEGUZ < i_ENDUZ &&  s_ENDUZ >= i_ENDUZ) ||
	                        		  ( s_BEGUZ >= i_BEGUZ && s_ENDUZ <= i_ENDUZ) ) {//시간이 걸쳐져서 중복인 경우
	                              errorCode = MobileCodeErrVO.ERROR_CODE_500;
	                              errorMsg = MobileCodeErrVO.ERROR_MSG_500+"이미 결재신청된 시간과 중복됩니다. 결재진행현황에서 확인하시기 바랍니다.";
	                              xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
	                              return xmlString;
	                        }
	                    }else{// if 3 : 기존 신청한 건들이 전일 휴가일 경우-막음
	                    	errorCode = MobileCodeErrVO.ERROR_CODE_500;
                            errorMsg = MobileCodeErrVO.ERROR_MSG_500+"이미 결재신청된 시간과 중복됩니다. 결재진행현황에서 확인하시기 바랍니다.";
                            xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
                            return xmlString;
	                    }
	                }else if( ( Integer.parseInt(dup_Data.APPL_FROM)  <= Integer.parseInt(c_APPL_FROM) && Integer.parseInt(dup_Data.APPL_TO)  > Integer.parseInt(c_APPL_FROM)) ||
                        		   ( Integer.parseInt(dup_Data.APPL_FROM)  <  Integer.parseInt(c_APPL_TO)   && Integer.parseInt(dup_Data.APPL_TO) >= Integer.parseInt(c_APPL_TO)) ||
                        		   ( Integer.parseInt(dup_Data.APPL_FROM)  >= Integer.parseInt(c_APPL_FROM) && Integer.parseInt(dup_Data.APPL_TO)  <= Integer.parseInt(c_APPL_TO))){
	                	//날짜는 다른데 from-to가 걸치는 경우
	                	errorCode = MobileCodeErrVO.ERROR_CODE_500;
                        errorMsg = MobileCodeErrVO.ERROR_MSG_500+"이미 결재신청된 시간과 중복됩니다. 결재진행현황에서 확인하시기 바랍니다.";
                        xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
                        return xmlString;
	                }
	            } //if 1 반차의 경우 끝
	            
	                else { //전일 휴가의 경우
                        if( dup_Data.APPL_FROM.equals(c_APPL_FROM) && dup_Data.APPL_TO.equals(c_APPL_TO)) { //if 2 : 날짜같을 경우
	                        errorCode = MobileCodeErrVO.ERROR_CODE_500;
	                        errorMsg = MobileCodeErrVO.ERROR_MSG_500+"현재 결재신청이 되어 있으므로 결재진행현황에서 확인하시기 바랍니다.";
	                        xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
	                        return xmlString;
                        } else if( ( Integer.parseInt(dup_Data.APPL_FROM)  <= Integer.parseInt(c_APPL_FROM) && Integer.parseInt(dup_Data.APPL_TO)  > Integer.parseInt(c_APPL_FROM)) ||
                        		   ( Integer.parseInt(dup_Data.APPL_FROM)  <  Integer.parseInt(c_APPL_TO)   && Integer.parseInt(dup_Data.APPL_TO) >= Integer.parseInt(c_APPL_TO)) ||
                        		   ( Integer.parseInt(dup_Data.APPL_FROM)  >= Integer.parseInt(c_APPL_FROM) && Integer.parseInt(dup_Data.APPL_TO)  <= Integer.parseInt(c_APPL_TO)) ) {
	                        errorCode = MobileCodeErrVO.ERROR_CODE_500;
	                        errorMsg = MobileCodeErrVO.ERROR_MSG_500+"이미 결재신청된 날짜와 중복됩니다. 결재진행현황에서 확인하시기 바랍니다.";
	                        xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
	                        return xmlString;
                        } //if 3
	                } //if 2
	           

            }
            //날짜 중복 Check를 위한  end --------------------------------------

            //  2003.01.29 - 시간관리에 대한 최초 재계산일을 읽어 신청을 막아준다.
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
                errorMsg = MobileCodeErrVO.ERROR_MSG_500+"휴가는 "+ WebUtil.printDate(E_RRDAT)+"일 이후에만 신청 가능합니다.";
                xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
                return xmlString;
            }

            //------------------------------------ 개인 근무 일정 체크 ------------------------------------//
            dateFrom    = d03VocationData.APPL_FROM;
            dateTo      = d03VocationData.APPL_TO;

            //[CSR ID:3700538]보상휴가 유형은 보상휴가의 잔여 값으로 담길 수 있도록.
            if(d03VocationData.AWART.equals("0111")||d03VocationData.AWART.equals("0112")||d03VocationData.AWART.equals("0113")){
            	remain_date =  NumberUtils.toDouble(compensation_remaint);
            }else{
            	remain_date =  NumberUtils.toDouble(annualLeave_remaint);
            }

            //remain_date = NumberUtils.toDouble(d03RemainVocationData.E_REMAIN);  //Double.parseDouble(box.get("REMAIN_DATE"));
//            remain_date = NumberUtils.toDouble(d03RemainVocationData.ZKVRB);  //Double.parseDouble(box.get("REMAIN_DATE"));

            Vector d03WorkPeriodData_vt = rfcWork.getWorkPeriod( PERNR, dateFrom, dateTo );
            Logger.debug.println(this, "개인 기간 작업 스케줄 : " + d03WorkPeriodData_vt.toString());

            //--2002.09.06. 마이너스 휴가를 적용할 경우를 체크하고 한계를 정한다. ------------------------------------//
            D03MinusRestRFC func_minus = new D03MinusRestRFC();
            String          minusRest  = func_minus.check(PERNR, user.companyCode, dateFrom);
            double          minus      = NumberUtils.toDouble(minusRest);
            if( minus < 0.0 ) {
                minus = minus * (-1);
            }
/*
            // LG석유화학 전일, 반휴, 토요휴가 신청시 마이너스휴가 적용한다.---------------------------------------
            if( user.companyCode.equals("N100") ) {
                remain_date = remain_date + minus;
            // LG화학이면서 토요휴가 신청시 마이너스휴가 적용한다.---------------------------------------
            } else*/
            if( user.companyCode.equals("C100") && d03VocationData.AWART.equals("0122") ) {
                remain_date = remain_date + minus;
            }

            Logger.debug.println(this, "remain_date : " + remain_date);
            //--2002.09.06. 마이너스 휴가를 적용할 경우를 체크하고 한계를 정한다. --------------------------//

            // 날짜 제한은 sap에 규칙을 따른다. //
            /* 전일휴가 : 휴가 잔여일수보다 많은 일수를 신청할수 없다.
		             신청 기간의 근무 일수(토요일과 휴일 제외)를 계산해서 공제일수를 구한다.
		             평일반휴 : 평일에만 신청가능
		             토요휴가 : 토요일에만 신청가능하며, 사무직인 경우만 신청가능하다.
		             경조휴가 : 6일 이하로 신청가능하다.
		             하계휴가 : 5일 이하로 신청가능하다.
		             전일공가 : 기간 제한 없이 신청가능하다.(단, 모바일에서는 1day 만 가능)
		             시간공가 : 근무일정이 존재하는 날에만 신청가능하다.
		             휴무일수는 평일근무일정과 토요일로 구한다.                            */

            if( d03VocationData.AWART.equals("0110")||d03VocationData.AWART.equals("0111") ) {  // 전일휴가..
                int count     = 0;
                int day_count = 0;

                for( int i = 0 ; i < d03WorkPeriodData_vt.size() ; i++ ) {
                    d03WorkPeriodData = (D03WorkPeriodData)d03WorkPeriodData_vt.get(i);

                    // 신청기간 일자수를 구한다.
                    day_count++;

                    // 근무시간 계산
                    beg_time  = Long.parseLong(d03WorkPeriodData.BEGUZ);
                    end_time  = Long.parseLong(d03WorkPeriodData.ENDUZ);

                    work_time = end_time - beg_time;
                    if( work_time > 40000 ) {
                        count++;
                    }

                    // 휴무일수 계산
                    if( work_time >= 40000 ) {
                        vacation_day++;
                    }
                }

                if( count == day_count ) {
                    if( count > remain_date ) {
                        errorCode = MobileCodeErrVO.ERROR_CODE_500;
                        errorMsg  = MobileCodeErrVO.ERROR_MSG_500+"휴가신청일수(시간)가 잔여휴가일수(시간) 보다 많습니다.";

                        //[CSR ID:2942508] 연차휴가 신청 팝업 요청
                        if(currMon.equals("12") && !d03VocationData.AWART.equals("0111")){
                        	errorMsg=MobileCodeErrVO.ERROR_MSG_500+"휴가기간이 '"+currDate.substring(2, 4)+".12.21 이후일 경우, '"+nextMon.substring(2, 4)+"년 신규 연차가 생성되어야 신청 가능합니다.(연차생성일:'"+currDate.substring(2, 4)+".12.21)";
                        }
                        xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
                        return xmlString;

                    } else if( count == 0 ) {
                        errorCode = MobileCodeErrVO.ERROR_CODE_500;
                        errorMsg  = MobileCodeErrVO.ERROR_MSG_500+"신청기간에 근무일정이 존재하지 않습니다.";
                        xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
                        return xmlString;
                    }
                    d03VocationData.DEDUCT_DATE = Double.toString(count);   // 전일휴가일때만 공제일수를 다시 계산한다.
                } else {
                	errorCode = MobileCodeErrVO.ERROR_CODE_500;
                    errorMsg  = MobileCodeErrVO.ERROR_MSG_500+"전일휴가는 근무일정이 있는 평일에만 신청가능합니다.";
                    xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
                    return xmlString;
                }

            } else if( d03VocationData.AWART.equals("0120") || d03VocationData.AWART.equals("0121") ||d03VocationData.AWART.equals("0112")||d03VocationData.AWART.equals("0113") ) { // 평일반휴..+보상반휴
                d03WorkPeriodData = (D03WorkPeriodData)d03WorkPeriodData_vt.get(0);

                // 근무시간 계산
                beg_time  = Long.parseLong(d03WorkPeriodData.BEGUZ);
                end_time  = Long.parseLong(d03WorkPeriodData.ENDUZ);

                work_time = end_time - beg_time;

                if( work_time > 40000 ) {
                    //vacation_day++;
                    //if( vacation_day > remain_date ) {
                    if ( remain_date < 0.5 ) {   //0.5일만 남았어도 신청가능하도록
                    	errorCode = MobileCodeErrVO.ERROR_CODE_500;
                        errorMsg  = MobileCodeErrVO.ERROR_MSG_500+ "휴가신청일수(시간)가 잔여휴가일수(시간) 보다 많습니다.";

                      //[CSR ID:2942508] 연차휴가 신청 팝업 요청
                        if(currMon.equals("12")){
                        	errorMsg=MobileCodeErrVO.ERROR_MSG_500+"휴가기간이 '"+currDate.substring(2, 4)+".12.21 이후일 경우, '"+nextMon.substring(2, 4)+"년 신규 연차가 생성되어야 신청 가능합니다.(연차생성일:'"+currDate.substring(2, 4)+".12.21)";
                        }
                        xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
                        return xmlString;

                    }
                } else {
                	errorCode = MobileCodeErrVO.ERROR_CODE_500;
                    errorMsg  = MobileCodeErrVO.ERROR_MSG_500+ "반일휴가는 근무일정이 있는 평일에만 신청가능합니다.";
                    xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
                    return xmlString;
                }


                // [※CSR ID:C20130130_63372]반일휴가 신청 변경요청
                // 21:간부사원,22:사무직
                //1. 반일(전반):0120 종료시간이 14:00 이후 불가
                //2. 반일(후반):0121 시작시간이 13:00 이전 불가

              if (Integer.parseInt(DataUtil.removeStructur(d03VocationData.APPL_FROM,"-"))<Integer.parseInt("20170801")){ //[CSR ID:3438118] flexible time 시스템 요청 20170720 eunha
                if( phonenumdata.E_PERSK.equals("21")||phonenumdata.E_PERSK.equals("22") ) {

	                if( d03VocationData.AWART.equals("0120") &&  Long.parseLong(d03VocationData.ENDUZ) > 140000  ) {
	                	errorCode = MobileCodeErrVO.ERROR_CODE_500;
	                    errorMsg  = MobileCodeErrVO.ERROR_MSG_500+ "반일휴가(전반) 종료시간은 14:00 이후로 입력할 수 없습니다.";
	                    xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
	                    return xmlString;
	                }
	                if( d03VocationData.AWART.equals("0121") && Long.parseLong(d03VocationData.BEGUZ) < 130000  ) {
	                	errorCode = MobileCodeErrVO.ERROR_CODE_500;
	                    errorMsg  = MobileCodeErrVO.ERROR_MSG_500+ "반일휴가(후반) 시작시간은 13:00 이전으로 입력할 수 없습니다.";
	                    xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
	                    return xmlString;
	                }
                }
              }//[CSR ID:3438118] flexible time 시스템 요청 20170720 eunha

            } else if( d03VocationData.AWART.equals("0122") ) {     // 토요휴가..
                d03WorkPeriodData = (D03WorkPeriodData)d03WorkPeriodData_vt.get(0);

                // 근무시간 계산
                beg_time  = Long.parseLong(d03WorkPeriodData.BEGUZ);
                end_time  = Long.parseLong(d03WorkPeriodData.ENDUZ);

                work_time = end_time - beg_time;

                //------------------장치교대근무자인지 체크하고 장치교대근무자이면 신청을 막는다.(2002.05.29)
                D03ShiftCheckRFC func_shift = new D03ShiftCheckRFC();
                String           shiftCheck = func_shift.check(PERNR, dateFrom);
                if( shiftCheck.equals("1") ) {
                	errorCode = MobileCodeErrVO.ERROR_CODE_500;
                    errorMsg  = MobileCodeErrVO.ERROR_MSG_500+"휴가 신청일은 일일근무일정이 장치교대조로 토요휴가를 신청할수 없습니다.";
                    xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
                    return xmlString;
                } else {
                    //------------------장치교대근무자인지 체크하고 장치교대근무자이면 신청을 막는다.
                    if( work_time >= 40000 ) {
                        vacation_day++;
                        if( vacation_day > remain_date ) {
                            //message = "휴가신청일수가 잔여휴가일수보다 많습니다.";
                            errorCode = MobileCodeErrVO.ERROR_CODE_500;
                            errorMsg  = MobileCodeErrVO.ERROR_MSG_500+"휴가신청일수(시간)가 잔여휴가일수(시간) 보다 많습니다.";

                          //[CSR ID:2942508] 연차휴가 신청 팝업 요청
                            if(currMon.equals("12") && !(d03VocationData.AWART.equals("0112")||d03VocationData.AWART.equals("0113"))){
                            	errorMsg=MobileCodeErrVO.ERROR_MSG_500+"휴가기간이 '"+currDate.substring(2, 4)+".12.21 이후일 경우, '"+nextMon.substring(2, 4)+"년 신규 연차가 생성되어야 신청 가능합니다.(연차생성일:'"+currDate.substring(2, 4)+".12.21)";
                            }
                            xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
                            return xmlString;
                        }
                    } else {
                        //message = "토요휴가는 근무일정이 있는 토요일에만 신청가능합니다.";
                        errorCode = MobileCodeErrVO.ERROR_CODE_500;
                        errorMsg  = MobileCodeErrVO.ERROR_MSG_500+"토요휴가는 근무일정이 있는 토요일에만 신청가능합니다.";
                        xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
                        return xmlString;
                    }
                }

            } else if( d03VocationData.AWART.equals("0130")||d03VocationData.AWART.equals("0370") ) { // 경조휴가, [CSR ID : 1225704] 0370:자녀출산무급
                int count = 0;
                for( int i = 0 ; i < d03WorkPeriodData_vt.size() ; i++ ) {
                    d03WorkPeriodData = (D03WorkPeriodData)d03WorkPeriodData_vt.get(i);

                    // 근무시간 계산
                    beg_time  = Long.parseLong(d03WorkPeriodData.BEGUZ);
                    end_time  = Long.parseLong(d03WorkPeriodData.ENDUZ);

                    work_time = end_time - beg_time;
                    if( work_time >= 40000 ) {
                        count++;
                    }

                    // 휴무일수 계산
                    if( work_time >= 40000 ) {
                        vacation_day++;
                    }
                }

                String date = DataUtil.getCurrentDate();
                int day9001 =0;
                if (Integer.parseInt(date) >= 20120802) { //20120802일 부터 자녀출산시 유급 휴가 1일 →3일
                	day9001=3;
                }else{
                	day9001=1;
                }
                if( d03VocationData.CONG_CODE.equals("9001") && count > day9001 ) {
                    //message = "경조휴가:자녀출산(유급)은 "+day9001+"일 이하로 신청 가능합니다.";
                    errorCode = MobileCodeErrVO.ERROR_CODE_500;
                    errorMsg  = MobileCodeErrVO.ERROR_MSG_500+ "경조휴가:자녀출산(유급)은"+day9001+"일 이하로 신청 가능합니다.";
                    xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
                    return xmlString;
                } else if( d03VocationData.CONG_CODE.equals("9002") && count > 2 ) {
                        //message = "경조휴가:자녀출산(무급)은 2일 이하로 신청 가능합니다.";
                        errorCode = MobileCodeErrVO.ERROR_CODE_500;
                        errorMsg  = MobileCodeErrVO.ERROR_MSG_500+"경조휴가:자녀출산(무급)은 2일 이하로 신청 가능합니다.";
                        xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
                        return xmlString;
                } else if( count > 6 ) {
                        // = "경조휴가는 6일 이하로 신청 가능합니다.";
                        errorCode = MobileCodeErrVO.ERROR_CODE_500;
                        errorMsg  = MobileCodeErrVO.ERROR_MSG_500+"경조휴가는 6일 이하로 신청 가능합니다.";
                        xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
                        return xmlString;
                } else if( count == 0 &&  DataUtil.getDay( DataUtil.removeStructur(d03WorkPeriodData.BEGDA,"-") ) != 7  ) {
                    //message = "신청기간에 근무일정이 존재하지 않습니다.";
                    errorCode = MobileCodeErrVO.ERROR_CODE_500;
                    errorMsg  = MobileCodeErrVO.ERROR_MSG_500+"경조휴가는 6일 이하로 신청 가능합니다.";
                    xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
                    return xmlString;
                }

            } else if( d03VocationData.AWART.equals("0140") ) { // 하계휴가..
                // 2003.01.02. - 하계휴가 사용일수를 가져간다.
                D03VacationUsedRFC    rfcVacation           = new D03VacationUsedRFC();
                double                E_ABRTG               = NumberUtils.toDouble( rfcVacation.getE_ABRTG(PERNR) );
                //----------------------------------------------------------------------------------------------------

                int count = 0;
                for( int i = 0 ; i < d03WorkPeriodData_vt.size() ; i++ ) {
                    d03WorkPeriodData = (D03WorkPeriodData)d03WorkPeriodData_vt.get(i);

                    // 근무시간 계산
                    beg_time  = Long.parseLong(d03WorkPeriodData.BEGUZ);
                    end_time  = Long.parseLong(d03WorkPeriodData.ENDUZ);

                    work_time = end_time - beg_time;
                    if( work_time >= 40000 ) {
                        count++;
                    }

                    // 휴무일수 계산
                    if( work_time >= 40000 ) {
                        vacation_day++;
                    }
                }
                //※CSR ID:C20130617_50756
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
                        errorMsg  = MobileCodeErrVO.ERROR_MSG_500+ "하계휴가 기간 ( " +WebUtil.printDate( checkFrom) +"~"+WebUtil.printDate(checkTo)+ " ) 이 아니오니 확인후 재신청 바랍니다.";
                        xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
                        return xmlString;
    	            }

                }
                if( (count + E_ABRTG) > 5 ) {
                    //message = "하계휴가는 5일 이하로 신청 가능합니다. 현재 사용한 하계휴가 일수는 " + WebUtil.printNumFormat(E_ABRTG) + "일 입니다.";
                    errorCode = MobileCodeErrVO.ERROR_CODE_500;
                    errorMsg  = MobileCodeErrVO.ERROR_MSG_500+ "하계휴가는 5일 이하로 신청 가능합니다. 현재 사용한 하계휴가 일수는 " + WebUtil.printNumFormat(E_ABRTG) + "일 입니다.";
                    xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
                    return xmlString;
                } else if( count == 0 ) {
                    //message = "신청기간에 근무일정이 존재하지 않습니다.";
                    errorCode = MobileCodeErrVO.ERROR_CODE_500;
                    errorMsg  = MobileCodeErrVO.ERROR_MSG_500+ "신청기간에 근무일정이 존재하지 않습니다.";
                    xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
                    return xmlString;

                }

            } else if( d03VocationData.AWART.equals("0170") ) { // 전일공가..
                int count = 0;
                for( int i = 0 ; i < d03WorkPeriodData_vt.size() ; i++ ) {
                    d03WorkPeriodData = (D03WorkPeriodData)d03WorkPeriodData_vt.get(i);

                    // 근무시간 계산
                    beg_time  = Long.parseLong(d03WorkPeriodData.BEGUZ);
                    end_time  = Long.parseLong(d03WorkPeriodData.ENDUZ);

                    work_time = end_time - beg_time;
                    if( work_time >= 40000 ) {
                        count++;
                    }

                    // 휴무일수 계산
                    if( work_time >= 40000 ) {
                        vacation_day++;
                    }
                }
                if( count == 0 ) {
                    //message = "신청기간에 근무일정이 존재하지 않습니다.";
                    errorCode = MobileCodeErrVO.ERROR_CODE_500;
                    errorMsg  = MobileCodeErrVO.ERROR_MSG_500+ "신청기간에 근무일정이 존재하지 않습니다.";
                    xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
                    return xmlString;

                }

            } else if( d03VocationData.AWART.equals("0180") || d03VocationData.AWART.equals("0190")) { // 시간공가..  모성보호휴가추가_0729
                d03WorkPeriodData = (D03WorkPeriodData)d03WorkPeriodData_vt.get(0);

                // 근무시간 계산
                beg_time  = Long.parseLong(d03WorkPeriodData.BEGUZ);
                end_time  = Long.parseLong(d03WorkPeriodData.ENDUZ);

                work_time = end_time - beg_time;
                if( work_time < 40000 ) {
                    //message = "신청기간에 근무일정이 존재하지 않습니다.";
                    errorCode = MobileCodeErrVO.ERROR_CODE_500;
                    errorMsg  = MobileCodeErrVO.ERROR_MSG_500+  "신청기간에 근무일정이 존재하지 않습니다.";
                    xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
                    return xmlString;
                }

                // 휴무일수 계산
                if( work_time >= 40000 ) {
                    vacation_day++;
                }

                // 2002.07.08. 보건휴가 로직 추가
            } else if( d03VocationData.AWART.equals("0150") ) { // 보건휴가..
                // 결근한도에 보건휴가 쿼터가 존재할때만 신청가능하도록 체크한다.
                D03MinusRestRFC func_0150 = new D03MinusRestRFC();
                String          e_anzhl   = func_0150.getE_ANZHL(PERNR, dateFrom);
                double          d_anzhl   = NumberUtils.toDouble(e_anzhl);

                if( d_anzhl > 0.0 ) {
                    d03WorkPeriodData = (D03WorkPeriodData)d03WorkPeriodData_vt.get(0);

                    // 근무시간 계산
                    beg_time  = Long.parseLong(d03WorkPeriodData.BEGUZ);
                    end_time  = Long.parseLong(d03WorkPeriodData.ENDUZ);

                    work_time = end_time - beg_time;
                    if( work_time < 40000 ) {
                        //message = "신청기간에 근무일정이 존재하지 않습니다.";
                        errorCode = MobileCodeErrVO.ERROR_CODE_500;
                        errorMsg  = MobileCodeErrVO.ERROR_MSG_500+ g.getMessage("MSG.D.D03.0066");//"신청기간에 근무일정이 존재하지 않습니다.";
                        xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
                        return xmlString;
                    }

                    // 휴무일수 계산
                    if( work_time >= 40000 ) {
                        vacation_day++;
                    }
                } else {
                    //message = "잔여(보건) 휴가가 없습니다.";
                    errorCode = MobileCodeErrVO.ERROR_CODE_500;
                    errorMsg  = MobileCodeErrVO.ERROR_MSG_500+"잔여(보건) 휴가가 없습니다.";
                    xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
                    return xmlString;
                }

                //  2002.08.17. LG석유화학 휴일비근무 신청 추가
            } else if( d03VocationData.AWART.equals("0340") ) {  // 휴일비근무..
                String chk_0340 = "";
                for( int i = 0 ; i < d03WorkPeriodData_vt.size() ; i++ ) {
                    d03WorkPeriodData = (D03WorkPeriodData)d03WorkPeriodData_vt.get(i);

                    //  휴일이면서 근무일정이 있을때만 휴일비근무 신청 가능하다. CHK_0340 = 'Y'인 경우
                    chk_0340 = d03WorkPeriodData.CHK_0340;

                    if( !chk_0340.equals("Y") ) {
                        //message = "휴일비근무는 근무일정이 있는 휴일에만 신청가능합니다.";
                        errorCode = MobileCodeErrVO.ERROR_CODE_500;
                        errorMsg  = MobileCodeErrVO.ERROR_MSG_500+ "휴일비근무는 근무일정이 있는 휴일에만 신청가능합니다.";
                        xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
                        return xmlString;
                    } else {
                        vacation_day++;
                    }
                }

                // 2002.09.03. LG석유화학 근무면제 신청 추가
            } else if( d03VocationData.AWART.equals("0360") ) {  // 근무면제..
                d03WorkPeriodData = (D03WorkPeriodData)d03WorkPeriodData_vt.get(0);

                // 근무시간 계산
                beg_time  = Long.parseLong(d03WorkPeriodData.BEGUZ);
                end_time  = Long.parseLong(d03WorkPeriodData.ENDUZ);

                work_time = end_time - beg_time;
                if( work_time < 40000 ) {
                    //message = "신청기간에 근무일정이 존재하지 않습니다.";
                    errorCode = MobileCodeErrVO.ERROR_CODE_500;
                    errorMsg  = MobileCodeErrVO.ERROR_MSG_500+  "신청기간에 근무일정이 존재하지 않습니다.";
                    xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
                    return xmlString;
                }

                // 휴무일수 계산
                if( work_time >= 40000 ) {
                    vacation_day++;
                }
            }

//          [CSR ID:2595636] 동일일에 휴가&대근 차단 요청 건
            D16OTHDDupCheckRFC2 checkFunc = new D16OTHDDupCheckRFC2();
            Vector OTHDDupCheckData_new_vt = checkFunc.getChecResult( PERNR, UPMU_TYPE, dateFrom, dateTo);
            String e_flag = OTHDDupCheckData_new_vt.get(0).toString();
            String e_message = OTHDDupCheckData_new_vt.get(1).toString();

            if( e_flag.equals("Y")){//Y면 중복, N은 OK
            	errorCode = MobileCodeErrVO.ERROR_CODE_500;
                errorMsg  = MobileCodeErrVO.ERROR_MSG_500+ e_message;
                xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
                return xmlString;
            }

            // 계산한 휴무일수(조회화면에 보여주기위한 일수를 저장한다 - 일단위)를 저장한다.
            d03VocationData.PBEZ4 = Double.toString(vacation_day);
            //------------------------------------ 개인 근무 일정 체크 ------------------------------------//

            //문서번호GET
            /*AINF_SEQN   = func.getNumberGetNext();

            d03VocationData.AINF_SEQN = AINF_SEQN;   // 결재정보 일련번호*/
            d03VocationData.PERNR     = PERNR;  // 사원번호
            //@v1.0 경조휴가시 로직추가
            String  P_A024_SEQN   = "";         // 경조신청내역SEQN

            //결재라인 세팅
            //ApprInfoRFC appRfc = new ApprInfoRFC();
            //AppLineData_vt1 = AppUtil.getAppVector( PERNR, UPMU_TYPE ); [CSR ID:3748125] 주석처리 후 아래 로직으로 반영
            ApprovalLineRFC approvalLineRFC = new ApprovalLineRFC();//[CSR ID:3748125] 결재라인 호출 로직 변경
            Vector<ApprovalLineData> approvalLineList = approvalLineRFC.getApprovalLine(UPMU_TYPE, PERNR);//[CSR ID:3748125] 결재라인 호출 로직 변경

	        int nRowCount = approvalLineList.size();
	        Logger.debug.println( this, "######### 결재라인 수 nRowCount : "+nRowCount );
          /* [CSR ID:3748125] 주석처리하고, approvalLineList 를 바로 "T_IMPORTA" 에 담아 결재라인 넘김. 
           * for( int i = 0; i < nRowCount; i++) {

                //String      idx     = Integer.toString(i);

            	  ApprovalLineData appLine = (ApprovalLineData)AppLineData_vt1.get(i);

                 // ApprovalLineData approvalLine = new ApprovalLineData();
                  approvalLine.APPU_NUMB = appLine.APPU_NUMB;//결재자
                  approvalLine.APPU_TYPE = appLine.APPU_TYPE;
                  approvalLine.APPR_SEQN = appLine.APPR_SEQN;

                  approvalLine.OTYPE = appLine.APPL_OTYPE;
                  approvalLine.OBJID = appLine.APPL_OBJID;

                  approvalLine.PERNR     = PERNR;//신청자
                  approvalLine.AINF_SEQN = AINF_SEQN;
                  approvalLine.APPR_TYPE = APPR_TYPE;

                  approvalLineList.addElement(appLine);
            }*/
            Logger.debug.println( this, d03WorkPeriodData_vt.toString() );
            Logger.debug.println( this, "######### 결재라인 : "+approvalLineList.toString() );
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
                    errorMsg  ="결재라인정보 DB입력시 오류발생하였습니다." ;
                    xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
                    return xmlString;
                }
*/
                Logger.debug.println(this, "########## d03VocationData : " + d03VocationData);

                box.put("T_IMPORTA", approvalLineList);
                rfc.setRequestInput(PERNR, UPMU_TYPE);
                AINF_SEQN = rfc.build( PERNR, d03VocationData,P_A024_SEQN ,box, req);
                Logger.debug.println(this, "결재번호  ainf_seqn=" + AINF_SEQN.toString());
                if (!rfc.getReturn().isSuccess() || AINF_SEQN == null) {
                    throw new Exception(rfc.getReturn().MSGTX);
                }
                
//                con.commit();
            } catch (Exception e){
//            	con.rollback();
            	errorCode = MobileCodeErrVO.ERROR_CODE_400;
                errorMsg  ="결재라인정보 를 입력하지 못했습니다." ;
                if(rfc.getReturn().MSGTY.equals("E"))
                	errorMsg = rfc.getReturn().MSGTX;
                xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
                return xmlString;
            }


            // 메일 수신자 사람 ,
            ApprovalLineData appLine = approvalLineList.get(0);

            Logger.debug.println(this, "########## d03VocationData : " + appLine.toString());


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
            Logger.debug.println(this, "########## d03VocationData : test" );

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

	    	errorCode = MobileCodeErrVO.ERROR_CODE_500;
            errorMsg  = MobileCodeErrVO.ERROR_MSG_500+  e.getMessage();
            xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
            Logger.error(e);
            return xmlString;

	    }

	    return xmlString;
    }
}
