/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  		*/
/*   2Depth Name  : 휴가                                                        		*/
/*   Program Name : 휴가 신청 (모바일에서요청)                                  	*/
/*   Program ID   : D03VocationMBBuildSV                                        */
/*   Description  : 휴가를 신청할 수 있도록 하는 Class                          	*/
/*   Note         :                                                             */
/*   Creation     : 2002-01-03  김도신                                          		*/
/*   Update       : 2005-02-16  윤정현                                          		*/
/*   Update       : 2013-09-03  LSA  @CSR1  유급휴일 토요일은 경조휴가일수   미산입(단, 6일 이상의 경조휴가에 한해토요일 산입)  */
/*   Update       : 2014-02-04  C20140106_63914 : 경조휴가 오류 추가   */
/*   Update       : 2014-02-19  C20140219 : 경조휴가 토요일이 공휴일인 경우 휴가일수에 토요일포함로직 제외   */
/*                : 2014-08-24  [CSR ID:2595636] 동일일에 휴가&대근 차단 요청 건    */
/*                : 2015-12-18  [CSR ID:2942508] 연차휴가 신청 팝업 요청     		*/
/*                : 2016-09-21  GEHR 통합작업									*/
/*				  : 2017-04-10  eunha [CSR ID:3351729] 전지재료 익산공장 야간 교대조 휴가신청 Error*/
/*				  : 2017-07-20  eunha [CSR ID:3438118] flexible time 시스템 요청	*/
/* 						//@PJ.멕시코 법인 Rollout 프로젝트 추가 관련(Area = MX("32")) 2018/02/09 rdcamel	 
/*				  : 2018-05-16  성환희 [WorkTime52] 보상휴가 추가 건				*/
/*																				*/
/********************************************************************************/

package servlet.hris.D.D03Vocation ;

import java.io.PrintWriter;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.math.NumberUtils;

import com.common.RFCReturnEntity;
import com.common.constant.Area;
import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.mobile.MobileCodeErrVO;
import com.sns.jdf.mobile.XmlUtil;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;

import hris.D.D16OTHDDupCheckData2;
import hris.D.D03Vocation.D03RemainVocationData;
import hris.D.D03Vocation.D03VocationData;
import hris.D.D03Vocation.D03WorkPeriodData;
import hris.D.D03Vocation.rfc.D03MinusRestRFC;
import hris.D.D03Vocation.rfc.D03RemainVocationOfficeRFC;
import hris.D.D03Vocation.rfc.D03RemainVocationRFC;
import hris.D.D03Vocation.rfc.D03ShiftCheckRFC;
import hris.D.D03Vocation.rfc.D03VacationUsedRFC;
import hris.D.D03Vocation.rfc.D03VocationRFC;
import hris.D.D03Vocation.rfc.D03WorkPeriodRFC;
import hris.D.rfc.D16OTHDDupCheckRFC;
import hris.D.rfc.D16OTHDDupCheckRFC2;
import hris.common.PersonData;
import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalLineData;
import hris.common.rfc.AuthCheckNTMRFC;
import hris.common.rfc.PersonInfoRFC;

public class D03VocationBuildSV extends ApprovalBaseServlet {

    private String UPMU_TYPE ="18";   // 결재 업무타입(휴가신청)

    private String UPMU_NAME = "휴가";

    protected String getUPMU_TYPE() {
        return UPMU_TYPE;
    }

    protected String getUPMU_NAME() {
        return UPMU_NAME;
    }
    protected void performTask(final HttpServletRequest req, final HttpServletResponse res) throws GeneralException
    {
        //Connection con = null;

        try{
            final WebUserData user = WebUtil.getSessionUser(req);

            String dest = "";

            /***********     Start:   **********************************************************/

            		String fdUrl = ".";

        	        //Case of Europe(Poland, Germany) and USA
                    /*
                     * e_area :	46 (Poland)
                     *         		01 (Germany)
                     *				10 (USA)
                     *             //@PJ.멕시코 법인 Rollout 프로젝트 추가 관련(Area = MX("32")) 2018/02/09 rdcamel 
                    */
		           if (user.area.equals(Area.DE) || user.area.equals(Area.US)|| user.area.equals(Area.PL)|| user.area.equals(Area.MX)){
		               fdUrl = "hris.D.D03Vocation.D03VocationBuildEurpSV";
		           }else if(!user.area.equals(Area.KR)){
		               fdUrl = "hris.D.D03Vocation.D03VocationBuildGlobalSV";
		           }

		           Logger.debug.println(this, "-------------[user.area] = "+user.area + " fdUrl: " + fdUrl );

		            if( !".".equals(fdUrl )){
		            	printJspPage(req, res, WebUtil.ServletURL+ fdUrl);
				       	return;
		           }

            /**************    END:  *********************************************************/

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

		    final Box box = WebUtil.getBox(req);
            final String jobid = box.get("jobid", "first");
            Logger.debug.println(this, "[jobid] = "+jobid + " [user] : "+user.toString());

            final String PERNR =  getPERNR(box, user); //box.get("PERNR",  user.empNo);

            // 대리 신청 추가
            PersonInfoRFC numfunc = new PersonInfoRFC();

            final PersonData phonenumdata    = (PersonData)numfunc.getPersonInfo(PERNR, "X" );
            req.setAttribute("PersonData" , phonenumdata );

            Vector  d03VocationData_vt = new Vector();
            D03VocationData  d03VocationData = new D03VocationData();

            d03VocationData.AWART         = "0110";   // default 전일휴가
            d03VocationData.DEDUCT_DATE   = "1";
            d03VocationData.PERNR = PERNR;
            DataUtil.fixNull(d03VocationData);

            d03VocationData_vt.addElement(d03VocationData);
            req.setAttribute("d03VocationData_vt",  d03VocationData_vt);
            
            // 보상휴가 권한체크
            AuthCheckNTMRFC authCheckNTMRFC = new AuthCheckNTMRFC();
        	String E_AUTH = authCheckNTMRFC.getAuth(PERNR, "S_ESS");
        	req.setAttribute("E_AUTH", E_AUTH);

            if( jobid.equals("first") ) {            //제일처음 신청 화면에 들어온경우.


                getApprovalInfo(req, PERNR);    //<--필수

                D03RemainVocationData d03RemainVocationData = new D03RemainVocationData();
                if("Y".equals(E_AUTH)) {	//사무직
                	D03RemainVocationOfficeRFC  rfcRemain             = new D03RemainVocationOfficeRFC();
                	d03RemainVocationData = (D03RemainVocationData)rfcRemain.getRemainVocation(PERNR, DataUtil.getCurrentDate(), "A");
                } else {					//현장직
                	// 잔여휴가일수, 장치교대근무조 체크
                	D03RemainVocationRFC  rfcRemain             = new D03RemainVocationRFC();
                	d03RemainVocationData = (D03RemainVocationData)rfcRemain.getRemainVocation(PERNR, DataUtil.getCurrentDate());
                }


                req.setAttribute("jobid",                 jobid);
                req.setAttribute("d03RemainVocationData", d03RemainVocationData);

                D16OTHDDupCheckRFC d16OTHDDupCheckRFC = new D16OTHDDupCheckRFC();
                Vector OTHDDupCheckData_vt = null;
                OTHDDupCheckData_vt = d16OTHDDupCheckRFC.getCheckList( PERNR, UPMU_TYPE, user.area );
//                Logger.debug.println(this, "OTHDDupCheckData_vt : "+ OTHDDupCheckData_vt.toString());
                req.setAttribute("OTHDDupCheckData_vt", OTHDDupCheckData_vt);

                dest = WebUtil.JspURL+"D/D03Vocation/D03VocationBuild.jsp";


			} else if (jobid.equals("check")) {	//날짜 체크.

			    D03RemainVocationData dataRemain = new D03RemainVocationData();
			    RFCReturnEntity rfcReturns = new RFCReturnEntity();
			    
			    String APPL_FROM  = req.getParameter("APPL_FROM");
			    APPL_FROM = (APPL_FROM == null) ? DataUtil.getCurrentDate() : APPL_FROM;
			    String mode = req.getParameter("MODE");

			    if("Y".equals(E_AUTH)) {	//사무직
			    	D03RemainVocationOfficeRFC  rfcRemain             = new D03RemainVocationOfficeRFC();
			    	dataRemain = (D03RemainVocationData)rfcRemain.getRemainVocation(PERNR, APPL_FROM, mode);
			    	rfcReturns = rfcRemain.getReturn();
			    } else {					//현장직
			    	D03RemainVocationRFC  rfcRemain  =new D03RemainVocationRFC();
			    	dataRemain = (D03RemainVocationData)rfcRemain.getRemainVocation(PERNR, APPL_FROM);
			    	rfcReturns = rfcRemain.getReturn();
			    }

			    PrintWriter out = res.getWriter();

				if (!rfcReturns.isSuccess()) {

					String flag = rfcReturns.MSGTY ;
					String msg = rfcReturns.MSGTX ;

					out.println(flag + "," + msg); // fail

				}else{

					String remainDays = dataRemain.OCCUR.equals("0")?"0" : WebUtil.printNumFormat(Double.toString(NumberUtils.toDouble(dataRemain.ABWTG)  / NumberUtils.toDouble(dataRemain.OCCUR) * 100.0),2);

					dataRemain.E_REMAIN =  (dataRemain.E_REMAIN.equals("0") ||  dataRemain.E_REMAIN.equals("")) ? "0" : WebUtil.printNumFormat(dataRemain.E_REMAIN,2) ;
					dataRemain.ZKVRB = (dataRemain.ZKVRB.equals("0") ||  dataRemain.ZKVRB.equals("")) ? "0" : WebUtil.printNumFormat(dataRemain.ZKVRB,1) ;
					dataRemain.OCCUR =  (dataRemain.OCCUR.equals("0") ||  dataRemain.OCCUR.equals("")) ? "0" : WebUtil.printNumFormat(dataRemain.OCCUR,2) ;
					dataRemain.ABWTG = (dataRemain.ABWTG.equals("0") ||  dataRemain.ABWTG.equals("")) ? "0" : WebUtil.printNumFormat(dataRemain.ABWTG,2);

					out.println(remainDays + "," + dataRemain.E_REMAIN + "," + dataRemain.ZKVRB + "," + dataRemain.OCCUR + "," + dataRemain.ABWTG+ "," + dataRemain.ZKVRBTX);

					Logger.debug.println("[#####]	JOBID	 :	[ " + jobid + " ]	0) remainDays		 	 :	[ " + remainDays + " ]");
					Logger.debug.println("[#####]	JOBID	 :	[ " + jobid + " ]	1) dataRemain.E_REMAIN 	 :	[ " + dataRemain.E_REMAIN  + " ]");
					Logger.debug.println("[#####]	JOBID	 :	[ " + jobid + " ]	2) dataRemain.ZKVRB 	 :	[ " + dataRemain.ZKVRB  + " ]");
					Logger.debug.println("[#####]	JOBID	 :	[ " + jobid + " ]	3) dataRemain.OCCUR		 :	[ " + dataRemain.OCCUR + " ]");
					Logger.debug.println("[#####]	JOBID	 :	[ " + jobid + " ]	4) dataRemain.ABWTG		 :	[ " + dataRemain.ABWTG + " ]");
					Logger.debug.println("[#####]	JOBID	 :	[ " + jobid + " ]	5) dataRemain.ZKVRBTX	 :	[ " + dataRemain.ZKVRBTX + " ]");
				}

				return;

            } else if( jobid.equals("create") ) {


        	    dest = requestApproval(req, box,  D03VocationData.class, new RequestFunction<D03VocationData>() {
        	                        public String porcess(D03VocationData inputData, Vector<ApprovalLineData> approvalLine) throws GeneralException {

        	        //D03VocationData d03VocationData   = new D03VocationData();
        	        D03VocationRFC    rfc               = new D03VocationRFC();
        	        Vector d03VocationData_vt = new Vector();

	                //------------------------------------  체크 ------------------------------------//

	                String message = checkData( box,  user,  PERNR,  phonenumdata, inputData, req );
	                String AINF_SEQN = null;

        	        //req.setAttribute("d03VocationData_vt", d03VocationData_vt);

//                    Logger.debug.println(this, "########## d03VocationData : " + inputData);

	                if( !message.equals("") ){
	                    String  P_A024_SEQN   = box.get("P_A024_SEQN");         // SEQN

	                    Logger.debug.println(this, "66666:"+message);
	                    req.setAttribute("jobid", jobid);
	                    req.setAttribute("message", message);
	                    req.setAttribute("P_A024_SEQN", P_A024_SEQN);

	                    Logger.debug.println(this, "4 : "  );
//	                    String url = "location.href = '" + WebUtil.ServletURL+"hris.D.D03Vocation.D03VocationDetailSV?AINF_SEQN="+AINF_SEQN+"';";
//	                    req.setAttribute("url", url);

                    	//d03VocationData.PERNR       = PERNR;
                        //d03VocationData_vt.addElement(d03VocationData);
	                    
	                    // 보상휴가 권한체크
	                    AuthCheckNTMRFC authCheckNTMRFC = new AuthCheckNTMRFC();
	                	String E_AUTH = authCheckNTMRFC.getAuth(PERNR, "S_ESS");
	                	req.setAttribute("E_AUTH", E_AUTH);

	                    // 잔여휴가일수, 장치교대근무조 체크
	                    D03RemainVocationData d03RemainVocationData = new D03RemainVocationData();
	                    if("Y".equals(E_AUTH)) {	//사무직
	                    	D03RemainVocationOfficeRFC  rfcRemain             = new D03RemainVocationOfficeRFC();
	                    	d03RemainVocationData = (D03RemainVocationData)rfcRemain.getRemainVocation(PERNR, DataUtil.getCurrentDate(), "A");
	                    } else {					//현장직
	                    	// 잔여휴가일수, 장치교대근무조 체크
	                    	D03RemainVocationRFC  rfcRemain             = new D03RemainVocationRFC();
	                    	d03RemainVocationData = (D03RemainVocationData)rfcRemain.getRemainVocation(PERNR, DataUtil.getCurrentDate());
	                    }
/*
                        D16OTHDDupCheckRFC func2 = new D16OTHDDupCheckRFC();
                        Vector OTHDDupCheckData_vt = func2.getCheckList( PERNR, UPMU_TYPE , user.area);

                        req.setAttribute("OTHDDupCheckData_vt", OTHDDupCheckData_vt);
                        */
                        req.setAttribute("d03RemainVocationData", d03RemainVocationData);
	                    //
	                    getApprovalInfo(req, PERNR);    //<--
                        req.setAttribute("approvalLine", approvalLine); //변경된 결재라인

	                    printJspPage(req, res, WebUtil.JspURL+"D/D03Vocation/D03VocationBuild.jsp");

	                    return null;

	                } else { //

        	            d03VocationData_vt.addElement(inputData);
        	            inputData.PERNR     = PERNR;
	                    //@v1.0
	                    String  P_A024_SEQN   = box.get("P_A024_SEQN");         // SEQN

	                    Logger.debug.println(this, "22222");
	                    //Logger.debug.println( this, d03WorkPeriodData_vt.toString() );
	                    Vector          ret             = new Vector();
	                    Logger.debug.println(this, " rfc.build before" );

                        rfc.setRequestInput(user.empNo, UPMU_TYPE);
	                    AINF_SEQN =  rfc.build( PERNR, inputData, P_A024_SEQN, box, req );

	                    if(!rfc.getReturn().isSuccess() || AINF_SEQN==null) {
                            throw new GeneralException(rfc.getReturn().MSGTX);
                        };



                        /*
	                        Logger.debug.println(this, "SAP"+E_MESSAGE);
	                        req.setAttribute("jobid", jobid);
	                        req.setAttribute("message", msg);
	                        req.setAttribute("d03VocationData_vt", d03VocationData_vt);
	                        req.setAttribute("d03WorkPeriodData_vt", d03WorkPeriodData_vt);
	                        req.setAttribute("d03RemainVocationData",  d03RemainVocationData);
	                        req.setAttribute("OTHDDupCheckData_vt", OTHDDupCheckData_vt);
	                        req.setAttribute("CONG_DATE", CONG_DATE);
	                        req.setAttribute("HOLI_CONT", HOLI_CONT);
	                        req.setAttribute("P_A024_SEQN", P_A024_SEQN);
	                        dest = WebUtil.JspURL+"D/D03Vocation/D03VocationBuild.jsp";
                        */
	                }
	                return AINF_SEQN;
                }});
            } else {
                throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
            }
            if(  req.getAttribute("message")==null || req.getAttribute("message").equals("")){
	            Logger.debug.println(this, " destributed = " + dest);
	            printJspPage(req, res, dest);
            }
        } catch(Exception e) {
            throw new GeneralException(e);
        } finally {

        }

    }




    /**********************************************************************************
     *
     * @return String message ; Success="", fail:msg
     * @throws GeneralException
     */
    protected String checkData(Box box, WebUserData user, String PERNR, PersonData phonenumdata,
    		D03VocationData d03VocationData, HttpServletRequest req) throws GeneralException {

        //req.setAttribute("PersonData" , phonenumdata );

    	try{
	        D03WorkPeriodRFC  rfcWork           = new D03WorkPeriodRFC();
	        D03WorkPeriodData d03WorkPeriodData = new D03WorkPeriodData();
	        
	        // 보상휴가 권한체크
            AuthCheckNTMRFC authCheckNTMRFC = new AuthCheckNTMRFC();
        	String E_AUTH = authCheckNTMRFC.getAuth(PERNR, "S_ESS");

	        //잔여휴가일수, 장치교대근무조 체크
	        D03RemainVocationData d03RemainVocationData = new D03RemainVocationData();

	        String  AINF_SEQN          = "";

	        String  dateFrom     = "";
	        String  dateTo       = "";
	        String  message      = "";
	        double  remain_date  = 0.0;
	        double  vacation_day = 0.0;  //휴무일수
	        long    beg_time     = 0;
	        long    end_time     = 0;
	        long    work_time    = 0;

//	        DataUtil.getDay(DataUtil.removeStructur(null);  // general exception 오류유발코드(test)
	        //@@ data처리 해야함
	        String   CONG_DATE    = WebUtil.nvl(box.get("CONG_DATE"));   // @CSR1 경조일자
	        String   HOLI_CONT    = WebUtil.nvl(box.get("HOLI_CONT"),"0");   // @CSR1 경조일수

	        /////////////////////////////////////////////////////////////////////////////
	        // 휴가신청 저장..
	        d03VocationData.BEGDA       = box.get("BEGDA");        // 신청일
	        d03VocationData.AWART       = box.get("AWART");        // 근무/휴무 유형
	        d03VocationData.REASON      = box.get("REASON");      // 신청 사유
	        d03VocationData.APPL_FROM   = box.get("APPL_FROM");     // 신청시작일
	        d03VocationData.APPL_TO     = box.get("APPL_TO");     // 신청종료일
	        d03VocationData.BEGUZ       = box.get("BEGUZ");        // 시작시간
	        d03VocationData.ENDUZ       = box.get("ENDUZ");       // 종료시간
	        d03VocationData.DEDUCT_DATE = box.get("DEDUCT_DATE");  // 공제일수
	        //**********수정부분 시작 (20050223:유용원)**********
	        d03VocationData.ZPERNR       = user.empNo;                  //신청자 사번 설정(대리신청 ,본인 신청)
	        d03VocationData.UNAME        = user.empNo;                  //신청자 사번 설정(대리신청 ,본인 신청)
	        d03VocationData.AEDTM        = DataUtil.getCurrentDate();  // 변경일(현재날짜)
	        d03VocationData.CONG_CODE    = box.get("CONG_CODE");    // 경조내역
	        d03VocationData.OVTM_CODE    = box.get("OVTM_CODE");   /// 사유코드CSR ID:1546748
	        d03VocationData.OVTM_NAME    = box.get("OVTM_NAME");    // 사유코드CSR ID:1546748
	        //**********수정 부분 끝..****************************

	        if("Y".equals(E_AUTH)) {	//사무직
	        	String vocaType = (d03VocationData.AWART.equals("0111") 
									|| d03VocationData.AWART.equals("0112") 
									|| d03VocationData.AWART.equals("0113")) ? "B" : "A";
            	D03RemainVocationOfficeRFC  rfcRemain             = new D03RemainVocationOfficeRFC();
            	d03RemainVocationData = (D03RemainVocationData)rfcRemain.getRemainVocation(PERNR, d03VocationData.APPL_FROM, vocaType);
            } else {					//현장직
            	D03RemainVocationRFC  rfcRemain             = new D03RemainVocationRFC();
            	d03RemainVocationData = (D03RemainVocationData)rfcRemain.getRemainVocation(PERNR, d03VocationData.APPL_FROM);
            }

	        //** 2016.11.01 rfcRemain.ZKVRB -> rfcRemain.ZKVRB 잔여휴가일수 **//

	        if (d03RemainVocationData.ZKVRB==null || d03RemainVocationData.ZKVRB.equals(""))
	        	d03RemainVocationData.ZKVRB="0";

	        d03VocationData.REMAIN_DATE = d03RemainVocationData.ZKVRB;   //box.get("REMAIN_DATE");   // 잔여휴가일수

	        //------------------------------------ 개인 근무 일정 체크 -----------------------------------//
	        dateFrom    = box.get("APPL_FROM");
	        dateTo      = box.get("APPL_TO");
	        Logger.debug.println(this, "  pernr:"+PERNR+"d03VocationData.APPL_FROM:"+d03VocationData.APPL_FROM+"RemainVocation : " + d03RemainVocationData.toString());

	        remain_date = Double.parseDouble(box.get("REMAIN_DATE")); //==>d03RemainVocationData.E_REMIAN와 동일함 //Double.parseDouble(d03RemainVocationData.ZKVRB);  //

	        Vector d03WorkPeriodData_vt = rfcWork.getWorkPeriod( PERNR, dateFrom, dateTo );
	        if (d03WorkPeriodData_vt.size()==0 || rfcWork.getReturn().isSuccess()==false){
	        	return "개인 작업 스케줄에 문제가 있습니다. 인사담당자에게 문의바랍니다.";
	        }
	        Logger.debug.println(this, "개인 기간 작업 스케줄 : " + d03WorkPeriodData_vt.toString());

	        //--2002.09.06.  마이너스 휴가를 적용할 경우를 체크하고 한계를 정한다
	        D03MinusRestRFC func_minus = new D03MinusRestRFC();
	        String          minusRest  = func_minus.check(PERNR, user.companyCode, dateFrom);
	        double          minus      = Double.parseDouble(minusRest);
	        if( minus < 0.0 ) {
	            minus = minus * (-1);
	        }
/*
	        // LG석유화학 전일, 반휴, 토요휴가 신청시 마이너스휴가 적용한다.----
	        if( user.companyCode.equals("N100") ) {
	            remain_date = remain_date + minus;
	        // LG화학이면서 토요휴가 신청시 마이너스휴가 적용한다.-----------------------------------
	        } else */
	        if( user.companyCode.equals("C100") && d03VocationData.AWART.equals("0122") ) {
	            remain_date = remain_date + minus;
	        }

	        Logger.debug.println( "minusRest : " + minusRest);
	        Logger.debug.println( "minus : " + minus);
	        Logger.debug.println( "remain_date : " + remain_date);
            //--2002.09.06. 마이너스 휴가를 적용할 경우를 체크하고 한계를 정한다. --------------------------//

            // 날짜 제한은 sap에 규칙을 따른다. //
            /* 전일휴가 : 휴가 잔여일수보다 많은 일수를 신청할수 없다.
             신청 기간의 근무 일수(토요일과 휴일 제외)를 계산해서 공제일수를 구한다.
             평일반휴 : 평일에만 신청가능
             토요휴가 : 토요일에만 신청가능하며, 사무직인 경우만 신청가능하다.
             경조휴가 : 6일 이하로 신청가능하다.
             하계휴가 : 5일 이하로 신청가능하다.
             전일공가 : 기간 제한 없이 신청가능하다.
             시간공가 : 근무일정이 존재하는 날에만 신청가능하다.
             휴무일수는 평일근무일정과 토요일로 구한다.                            */

	        /////////[CSR ID:2942508] 연차휴가 신청 팝업 요청///////////////////////////////////////////////////////////////
	        String currDate =  DataUtil.getCurrentDate();
	        String currMon = DataUtil.getCurrentMonth();
	        String nextMon = DataUtil.getAfterMonth(currDate, 1);
	        //Logger.debug.println(this, "@@@~~~~~@@@ : "+ currDate+", "+currMon+", "+nextMon+", "+currDate.substring(2, 4));
	        /////////[CSR ID:2942508]연차휴가 신청 팝업 요청//////////////////////////////////////////////////////////

	        if( d03VocationData.AWART.equals("0110") || d03VocationData.AWART.equals("0111") ) { // 전일휴가..
	            int count     = 0;
	            int request_days = 0;

	            for( int i = 0 ; i < d03WorkPeriodData_vt.size() ; i++ ) {
	                d03WorkPeriodData = (D03WorkPeriodData)d03WorkPeriodData_vt.get(i);

	             // 신청기간 일자수를 구한다.
	                request_days++;

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

	            if( count == request_days ) {
	                if( count > remain_date ) {
	    	        	Logger.debug.println(this, "count > remain_date :" + count+","+remain_date );
	                    message = g.getMessage("MSG.D.D03.0056");//휴가신청일수가 잔여휴가일수보다 많습니다.";

	                    //[CSR ID:2942508]  연차휴가 신청 팝업 요청 - 보상휴가 제외
	                    if(currMon.equals("12") && d03VocationData.AWART.equals("0110")){
	                    	String arg[]= {currDate.substring(2, 4), nextMon.substring(2, 4) } ;
	                    	message=g.getMessage("MSG.D.D03.0057", arg);
	                    	//"휴가기간이 '"+currDate.substring(2, 4)+".12.21 이후일 경우, '"+nextMon.substring(2, 4)+"년 신규 연차가 생성되어야 \\n신청 가능합니다.(연차생성일:'"+currDate.substring(2, 4)+".12.21)";
	                    }
	                } else if( count == 0 ) {
	                    message = g.getMessage("MSG.D.D03.0055");//"신청기간에 근무일정이 존재하지 않습니다.";
	                }
	                d03VocationData.DEDUCT_DATE = Double.toString(count);   // 전일휴가일때만 공제일수를 다시 계산한다.
	            } else {
	                message = g.getMessage("MSG.D.D03.0058");//"전일휴가는 근무일정이 있는 평일에만 신청가능합니다.";
	            }

	        } else if( d03VocationData.AWART.equals("0120") || d03VocationData.AWART.equals("0121") 
	        			|| d03VocationData.AWART.equals("0112") || d03VocationData.AWART.equals("0113") ) { //  평일반휴..
	            d03WorkPeriodData = (D03WorkPeriodData)d03WorkPeriodData_vt.get(0);

	            //  근무시간 계산
	            beg_time  = Long.parseLong(d03WorkPeriodData.BEGUZ);
	            end_time  = Long.parseLong(d03WorkPeriodData.ENDUZ);

	            work_time = end_time - beg_time;
	            if( work_time > 40000 ) {
	                //vacation_day++;
	                //if( vacation_day > remain_date ) {
	                if ( remain_date < 0.5 ) {   //0.5일만 남았어도 신청가능하도록
	    	        	Logger.debug.println(this, "remain_date < 0.5 :" + remain_date );
	                    message = g.getMessage("MSG.D.D03.0056");//휴가신청일수가 잔여휴가일수보다 많습니다.";

	                  //[CSR ID:2942508] 연차휴가 신청 팝업 요청 - 보상휴가 제외
	                    if(currMon.equals("12") && (d03VocationData.AWART.equals("0120") || d03VocationData.AWART.equals("0121"))){
	                    	String arg[]= {currDate.substring(2, 4), nextMon.substring(2, 4) } ;
	                    	message=g.getMessage("MSG.D.D03.0057", arg);
	                    	//message="휴가기간이 '"+currDate.substring(2, 4)+".12.21 이후일 경우, '"+nextMon.substring(2, 4)+"년 신규 연차가 생성되어야 \\n신청 가능합니다.(연차생성일:'"+currDate.substring(2, 4)+".12.21)";
	                    }
	                }
	            } else {
	                message = g.getMessage("MSG.D.D03.0072");//"반일휴가는 근무일정이 있는 평일에만 신청가능합니다.";
	            }
	            Logger.debug.println(this, "d03VocationData.BEGUZ : " + Long.parseLong(d03VocationData.BEGUZ));
	            Logger.debug.println(this, "d03VocationData.ENDUZ : " + Long.parseLong(d03VocationData.ENDUZ));
                // [※CSR ID:C20130130_63372]반일휴가 신청 변경요청
                //21:간부사원,22:사무직
                //1. 반일(전반):0120 종료시간이 14:00 이후 불가
                //2. 반일(후반):0121 시작시간이 13:00 이전 불가

	            if (Integer.parseInt(DataUtil.removeStructur(d03VocationData.APPL_FROM,"-"))<Integer.parseInt("20170801")){ //[CSR ID:3438118] flexible time 시스템 요청 20170720 eunha
	             if( phonenumdata.E_PERSK.equals("21")||phonenumdata.E_PERSK.equals("22") ) {
	                if( d03VocationData.AWART.equals("0120") &&  Long.parseLong(d03VocationData.ENDUZ) > 140000  ) {
	                	message = g.getMessage("MSG.D.D03.0059");//"반일휴가(전반) 종료시간은 14:00 이후로 입력할 수 없습니다.";
	                }
	                if( d03VocationData.AWART.equals("0121") && Long.parseLong(d03VocationData.BEGUZ) < 130000  ) {
	                	message = g.getMessage("MSG.D.D03.0060");//"반일휴가(후반) 시작시간은 13:00 이전으로 입력할 수 없습니다.";
	                }
	             }
	            } //[CSR ID:3438118] flexible time 시스템 요청 20170720 eunha

	          //[CSR ID:3351729] 전지재료 익산공장 야간 교대조 휴가신청 Error start
	          //사원하위그룹 39 운영직과 40 계약직(운영직) 반휴(전반) 이고 주간근로자이면 휴가시작일자가 종료일자보다 작아야 한다.
	            if( phonenumdata.E_PERSK.equals("39")||phonenumdata.E_PERSK.equals("40") ) {
	                if( d03VocationData.AWART.equals("0120") &&  beg_time <=90000  ) {
	                	if(Long.parseLong(d03VocationData.BEGUZ) >= Long.parseLong(d03VocationData.ENDUZ) ){
	                		message = g.getMessage("MSG.D.D03.0027");//시작시간을 확인하세요.
	                	}
	                }
	            }
	          //[CSR ID:3351729] 전지재료 익산공장 야간 교대조 휴가신청 Error end
	        	Logger.debug.println(this, "message : " + message);
	        } else if( d03VocationData.AWART.equals("0122") ) {     // 토요휴가..
	            d03WorkPeriodData = (D03WorkPeriodData)d03WorkPeriodData_vt.get(0);

	            // 근무시간 계산
	            beg_time  = Long.parseLong(d03WorkPeriodData.BEGUZ);
	            end_time  = Long.parseLong(d03WorkPeriodData.ENDUZ);

	            work_time = end_time - beg_time;

	            //------------------장치교대근무자인지 체크하고 장치교대근무자이면 신청을 막는다.
	            D03ShiftCheckRFC func_shift = new D03ShiftCheckRFC();
	            String           shiftCheck = func_shift.check(PERNR, dateFrom);
	            if( shiftCheck.equals("1") ) {
	                message = g.getMessage("MSG.D.D03.0061");// "
	            } else {
	                //------------------장치교대근무자인지 체크하고 장치교대근무자이면 신청을 막는다.
	                if( work_time >= 40000 ) {
	                    vacation_day++;

	                    if( vacation_day > vacation_day ) {

		    	        	Logger.debug.println(this, "vacation_day > vacation_day :" + vacation_day +">"+vacation_day );
		    	        	message = g.getMessage("MSG.D.D03.0056");//"휴가신청일수가 잔여휴가일수보다 많습니다.";

	                      //[CSR ID:2942508] 연차휴가 신청 팝업 요청
	                        if(currMon.equals("12")){
		                    	String arg[]= {currDate.substring(2, 4), nextMon.substring(2, 4) } ;
		                    	message=g.getMessage("MSG.D.D03.0057", arg);
	                        	//휴가기간이 '"+currDate.substring(2, 4)+".12.21 이후일 경우, '"+nextMon.substring(2, 4)+"년 신규 연차가 생성되어야 \\n신청 가능합니다.(연차생성일:'"+currDate.substring(2, 4)+".12.21)";
	                        }
	                    }
	                } else {
	                    message = g.getMessage("MSG.D.D03.0062");//"토요휴가는 근무일정이 있는 토요일에만 신청가능합니다.";
	                }
	            }

	        } else if( d03VocationData.AWART.equals("0130")||d03VocationData.AWART.equals("0370") ) { // 경조휴가, [CSR ID : 1225704] 0370:자녀출산무급
	            int count = 0;

	        	Logger.debug.println(this, "d03VocationData.CONG_CODE:" + d03VocationData.CONG_CODE);

	        	//  2013.12.17
            	//<경조휴가 일수 제외>
            	//      1순위 : 유급휴일 (공휴일, 일요일)
            	//      2순위 : 근무일정이 OFF(단, 토요일은 포함)
            	//	사무직은 토요일이 유급휴일이므로 휴가일수체크시포함되어야 함
	        	D03ShiftCheckRFC func_shift = new D03ShiftCheckRFC();
	        	String           shiftCheck = func_shift.check(PERNR, dateFrom);

	            for( int i = 0 ; i < d03WorkPeriodData_vt.size() ; i++ ) {
	                d03WorkPeriodData = (D03WorkPeriodData)d03WorkPeriodData_vt.get(i);

	                //  근무시간 계산
	                beg_time  = Long.parseLong(d03WorkPeriodData.BEGUZ);
	                end_time  = Long.parseLong(d03WorkPeriodData.ENDUZ);

	                work_time = end_time - beg_time;
	            	Logger.debug.println(this, "beg_time:" +beg_time+" end_time:"+end_time+"work_time:"+work_time+"count:"+count);
	                if( work_time >= 40000 ) {
	                    count++;
                    	Logger.debug.println(this, "? work_time >= 4000 : count :" +work_time +"count:"+count);
	                }else if ( shiftCheck.equals("D")   &&   d03WorkPeriodData.DAY.equals("6")&& Integer.parseInt(HOLI_CONT)>=6
	                			&& d03WorkPeriodData.CHK_0340.equals("")){
                        //@CSR1  유급휴일 토요일은 경조휴가일수   미산입(단, 6일 이상의 경조휴가에 한해토요일 산입)
                    	//CSR ID : C20140219  CHK_0340:"" :일반 ,값이있는경우 공휴일 ..
                    	//shiftCheck: D 는 교대조가 아닌 일근직
	                        	count++;
	                        	Logger.debug.println(this, "HOLI_CONT:" + HOLI_CONT+"count:"+count);
	                }
	                // 휴무일수 계산
	            	// C20140106_63914
	                if( work_time >= 40000 ) {
	                    vacation_day++;
	                }else if ( shiftCheck.equals("D")   &&   d03WorkPeriodData.DAY.equals("6")&& Integer.parseInt(HOLI_CONT)>=6
	                			&& d03WorkPeriodData.CHK_0340.equals("")){
                        //@CSR1  유급휴일 토요일은 경조휴가일수   미산입(단, 6일 이상의 경조휴가에 한해토요일 산입)
                    	//CSR ID : C20140219  CHK_0340:"" :일반 ,값이있는경우 공휴일 ..
                    	//shiftCheck: D 는 교대조가 아닌 일근직
	                	vacation_day++;
	                	Logger.debug.println(this, "HOLI_CONT:" + HOLI_CONT+"vacation_day:"+vacation_day);
	                }

	            }

	        	Logger.debug.println(this, "count:" + count);
	        	Logger.debug.println(this, "HOLI_CONT:" + HOLI_CONT);
	        	Logger.debug.println(this, "CONG_DATE:" + CONG_DATE);
	        	Logger.debug.println(this, "d03VocationData.CONG_CODE:" + d03VocationData.CONG_CODE);
	            String date = DataUtil.getCurrentDate();
	            int day9001 =0;
	            if (Integer.parseInt(date) >= 20120802) { //20120802일 부터 자녀출산시 유급 휴가 1일 →3일
	            	day9001=3;
	            }else{
	            	day9001=1;
	            }
	            if( d03VocationData.CONG_CODE.equals("9001") && count > day9001 ) {
	                message =  g.getMessage("MSG.D.D03.0063", Integer.toString(day9001));// 경조휴가:자녀출산(유급)은 "+day9001+"일 이하로 신청 가능합니다.";
	            } else if( d03VocationData.CONG_CODE.equals("9002") && count > 2 ) {
	                    message = g.getMessage("MSG.D.D03.0064");//""경조휴가:자녀출산(무급)은 2일 이하로 신청 가능합니다.";
	            } else if( count > 6 ) {
	                    message = g.getMessage("MSG.D.D03.0065");//"경조휴가는 6일 이하로 신청 가능합니다.";
	            } else if( count == 0 &&  DataUtil.getDay( DataUtil.removeStructur(d03WorkPeriodData.BEGDA,"-") ) != 7  ) {
	                message = g.getMessage("MSG.D.D03.0066");//"신청기간에 근무일정이 존재하지 않습니다.";
	            }
	             //@@@
	            if ( (count> Integer.parseInt(HOLI_CONT) ) &&  !CONG_DATE.equals("")){

	            	message = g.getMessage("MSG.D.D03.0067", HOLI_CONT);//경조발생일을 포함하여 신청해야 하며, 정해진 경조휴가일수"+HOLI_CONT+"일을 초과할 수 없습니다.";
	            }

	        } else if( d03VocationData.AWART.equals("0140") ) { //
	            // 2003.01.02. - 하계휴가 사용일수를 가져간다.
	            D03VacationUsedRFC    rfcVacation           = new D03VacationUsedRFC();
	            double                E_ABRTG               = Double.parseDouble( rfcVacation.getE_ABRTG(PERNR) );
	            //----------------------------------------------------------------------------------------------------

	            int count = 0;
	            for( int i = 0 ; i < d03WorkPeriodData_vt.size() ; i++ ) {
	                d03WorkPeriodData = (D03WorkPeriodData)d03WorkPeriodData_vt.get(i);

	                //
	                beg_time  = Long.parseLong(d03WorkPeriodData.BEGUZ);
	                end_time  = Long.parseLong(d03WorkPeriodData.ENDUZ);

	                work_time = end_time - beg_time;
	                if( work_time >= 40000 ) {
	                    count++;
	                }

	                //
	                if( work_time >= 40000 ) {
	                    vacation_day++;
	                }
	            }
	            if( (count + E_ABRTG) > 5 ) {
	                message = g.getMessage("MSG.D.D03.0068", WebUtil.printNumFormat(E_ABRTG));//"
	            } else if( count == 0 ) {
	                message = g.getMessage("MSG.D.D03.0069");//
	            }

	        } else if( d03VocationData.AWART.equals("0170") ) { //
	            int count = 0;
	            for( int i = 0 ; i < d03WorkPeriodData_vt.size() ; i++ ) {
	                d03WorkPeriodData = (D03WorkPeriodData)d03WorkPeriodData_vt.get(i);

	                //
	                beg_time  = Long.parseLong(d03WorkPeriodData.BEGUZ);
	                end_time  = Long.parseLong(d03WorkPeriodData.ENDUZ);

	                work_time = end_time - beg_time;
	                if( work_time >= 40000 ) {
	                    count++;
	                }

	                //
	                if( work_time >= 40000 ) {
	                    vacation_day++;
	                }
	            }
	            if( count == 0 ) {
	                message = g.getMessage("MSG.D.D03.0066");//
	            }

	        } else if( d03VocationData.AWART.equals("0180") ||d03VocationData.AWART.equals("0190")) { //
	            d03WorkPeriodData = (D03WorkPeriodData)d03WorkPeriodData_vt.get(0);

	            // 근무시간 계산
	            beg_time  = Long.parseLong(d03WorkPeriodData.BEGUZ);
	            end_time  = Long.parseLong(d03WorkPeriodData.ENDUZ);

	            work_time = end_time - beg_time;
	            if( work_time < 40000 ) {
	                message = g.getMessage("MSG.D.D03.0066");//
	            }

	         // 휴무일수 계산
	            if( work_time >= 40000 ) {
	                vacation_day++;
	            }

	            // 2002.07.08. 보건휴가 로직 추가
	        } else if( d03VocationData.AWART.equals("0150") ) {  // 보건휴가..
	        	// 결근한도에 보건휴가 쿼터가 존재할때만 신청가능하도록 체크한다.
	            D03MinusRestRFC func_0150 = new D03MinusRestRFC();
	            String          e_anzhl   = func_0150.getE_ANZHL(PERNR, dateFrom);
	            double          d_anzhl   = Double.parseDouble(e_anzhl);

	            if( d_anzhl > 0.0 ) {
	                d03WorkPeriodData = (D03WorkPeriodData)d03WorkPeriodData_vt.get(0);

	             // 근무시간 계산
	                beg_time  = Long.parseLong(d03WorkPeriodData.BEGUZ);
	                end_time  = Long.parseLong(d03WorkPeriodData.ENDUZ);

	                work_time = end_time - beg_time;
	                if( work_time < 40000 ) {
	                    message = g.getMessage("MSG.D.D03.0066");//"신청기간에 근무일정이 존재하지 않습니다.";
	                }

	                // 휴무일수 계산
	                if( work_time >= 40000 ) {
	                    vacation_day++;
	                }
	            } else {
	                message =g.getMessage("MSG.D.D03.0070");// "占쌤울옙(占쏙옙占쏙옙) 占쌨곤옙占쏙옙 占쏙옙占쏙옙占싹댐옙.";
	            }

	            //  2002.08.17. LG석유화학 휴일비근무 신청 추가
	        } else if( d03VocationData.AWART.equals("0340") ) {   // 휴일비근무..
	            String chk_0340 = "";
	            for( int i = 0 ; i < d03WorkPeriodData_vt.size() ; i++ ) {
	                d03WorkPeriodData = (D03WorkPeriodData)d03WorkPeriodData_vt.get(i);

	            //  휴일이면서 근무일정이 있을때만 휴일비근무 신청 가능하다. CHK_0340 = 'Y'인 경우
	                chk_0340 = d03WorkPeriodData.CHK_0340;

	                if( !chk_0340.equals("Y") ) {
	                    message = g.getMessage("MSG.D.D03.0071");// "휴일비근무는 근무일정이 있는 휴일에만 신청가능합니다.";
	                } else {
	                    vacation_day++;
	                }
	            }

	            // 2002.09.03. LG석유화학 근무면제 신청 추가
	        } else if( d03VocationData.AWART.equals("0360") ) {   // 근무면제..
	            d03WorkPeriodData = (D03WorkPeriodData)d03WorkPeriodData_vt.get(0);

	            // 근무시간 계산
	            beg_time  = Long.parseLong(d03WorkPeriodData.BEGUZ);
	            end_time  = Long.parseLong(d03WorkPeriodData.ENDUZ);

	            work_time = end_time - beg_time;
	            if( work_time < 40000 ) {
	                message = g.getMessage("MSG.D.D03.0055");// "신청기간에 근무일정이 존재하지 않습니다.";
	            }

	            // 휴무일수 계산
	            if( work_time >= 40000 ) {
	                vacation_day++;
	            }
	        }

	//       [CSR ID:2595636] 동일일에 휴가&대근 차단 요청 건
	        D16OTHDDupCheckRFC2 checkFunc = new D16OTHDDupCheckRFC2();
	        Vector OTHDDupCheckData_new_vt = checkFunc.getChecResult( PERNR, UPMU_TYPE, dateFrom, dateTo);
	        String e_flag = OTHDDupCheckData_new_vt.get(0).toString();
	        String e_message = OTHDDupCheckData_new_vt.get(1).toString();

	        if( e_flag.equals("Y")){//Y면 중복, N은 OK
	        	message = e_message;
	        }

	        // 계산한 휴무일수(조회화면에 보여주기위한 일수를 저장한다 - 일단위)를 저장한다.
	        d03VocationData.PBEZ4 = Double.toString(vacation_day);

	        req.setAttribute("d03WorkPeriodData_vt", d03WorkPeriodData_vt);
	        req.setAttribute("d03RemainVocationData",  d03RemainVocationData);
	        req.setAttribute("CONG_DATE", CONG_DATE); //@@@
	        req.setAttribute("HOLI_CONT", HOLI_CONT);//@@@


            D16OTHDDupCheckRFC func2 = new D16OTHDDupCheckRFC();
            Vector OTHDDupCheckData_vt = func2.getCheckList( PERNR, UPMU_TYPE , user.area);
            req.setAttribute("OTHDDupCheckData_vt", OTHDDupCheckData_vt);


            //**************** 중복체크- 모바일루틴에서 가져옴 start (ksc)********************
            for( int i = 0 ; i < OTHDDupCheckData_vt.size() ; i++ ) {
                D16OTHDDupCheckData2 dup_Data = (D16OTHDDupCheckData2)OTHDDupCheckData_vt.get(i);

	        	String s_BEGUZ1 = "";
	        	String s_ENDUZ1 = "";
                int s_BEGUZ = 0;
                int s_ENDUZ = 0;

                dup_Data.APPL_FROM = DataUtil.removeStructur(dup_Data.APPL_FROM,"-");
                dup_Data.APPL_TO = DataUtil.removeStructur(dup_Data.APPL_TO,"-");

	        	if (dup_Data.BEGUZ.equals("")){
//	        		Logger.debug.println(" jmk test 11 c_Data.BEGUZ-->"+i+":"+c_Data.BEGUZ);
	        	    s_BEGUZ1 = "";
	        	    s_BEGUZ = 0;
	        	}else{
//	        		Logger.debug.println(" jmk test 22 c_Data.BEGUZ-->"+i+":"+c_Data.BEGUZ);
//	        		Logger.debug.println(" jmk test 22 c_Data.BEGUZ.substring(0,2)-->"+i+":"+c_Data.BEGUZ.substring(0,2));
//	        		Logger.debug.println(" jmk test 22 c_Data.BEGUZ.substring(3,5)-->"+i+":"+c_Data.BEGUZ.substring(3,5));
                    s_BEGUZ1 = dup_Data.BEGUZ.substring(0,2) + dup_Data.BEGUZ.substring(3,5);
                    s_BEGUZ = Integer.parseInt(s_BEGUZ1);
	            }
//	        	Logger.debug.println(" jmk test 33 c_Data.ENDUZ-->"+i+":"+c_Data.ENDUZ);
	        	if (dup_Data.ENDUZ.equals("")){
//	        		Logger.debug.println(" jmk test 44 c_Data.ENDUZ-->"+i+":"+c_Data.ENDUZ);
	        	    s_ENDUZ1 = "";
	        	    s_ENDUZ = 0;
	        	}else{
//	        		Logger.debug.println(" jmk test 55 c_Data.ENDUZ-->"+i+":"+c_Data.ENDUZ);
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

//	            Logger.debug.println("D03VocationMbBuildSV OTHDDupCheckData_vt1 APPL_FROM:+++++++++++++++++++++++>"+c_Data.APPL_FROM );
//	            Logger.debug.println("D03VocationMbBuildSV OTHDDupCheckData_vt1 APPL_TO:+++++++++++++++++++++++++>"+c_Data.APPL_TO );
//	            Logger.debug.println("D03VocationMbBuildSV OTHDDupCheckData_vt1 c_APPL_FROM:+++++++++++++++++++++>"+c_APPL_FROM );
//	            Logger.debug.println("D03VocationMbBuildSV OTHDDupCheckData_vt1 c_APPL_TO:+++++++++++++++++++++++>"+c_APPL_TO );

	            if(c_AWART.equals( "0120" )||c_AWART.equals( "0121" ) ||c_AWART.equals( "0112" )||c_AWART.equals( "0113")) { //if 1 : 내가 신청한게 반차라면
	                // 반일휴가(전반), 반일휴가(후반), 시간공가의 경우
	            	if( dup_Data.APPL_FROM.equals(c_APPL_FROM) &&dup_Data.APPL_TO.equals(c_APPL_TO)) {//if 2 : 날짜같을 경우
	            		if( s_BEGUZ != 0 || s_ENDUZ != 0 ) { //if 3 : 기존 신청한 건들 중 반차일 경우, 반차(from to 시간 값이 있는 경우)	                    
	                        if( s_BEGUZ1.equals(c_BEGUZ)&& s_ENDUZ1.equals(c_ENDUZ)) {//시간 같을 경우
	                        	  message = g.getMessage("MSG.D.D03.0011");//"현재 결재신청이 되어 있으므로 결재진행현황에서 확인하시기 바랍니다.";
	                              return message;
	                        }else if( (s_BEGUZ <= i_BEGUZ && s_ENDUZ > i_BEGUZ) ||
	                        		  ( s_BEGUZ < i_ENDUZ &&  s_ENDUZ >= i_ENDUZ) ||
	                        		  ( s_BEGUZ >= i_BEGUZ && s_ENDUZ <= i_ENDUZ) ) {//시간이 걸쳐져서 중복인 경우
	                        	  message =g.getMessage("MSG.D.D03.0012");//"이미 결재신청된 시간과 중복됩니다. 결재진행현황에서 확인하시기 바랍니다.";
	                              return message;
	                        }
	                    }else{// if 3 : 기존 신청한 건들이 전일 휴가일 경우-막음
	                    	message =g.getMessage("MSG.D.D03.0012");//"이미 결재신청된 시간과 중복됩니다. 결재진행현황에서 확인하시기 바랍니다.";
                            return message;
	                    }
	                }else if( ( Integer.parseInt(dup_Data.APPL_FROM)  <= Integer.parseInt(c_APPL_FROM) && Integer.parseInt(dup_Data.APPL_TO)  > Integer.parseInt(c_APPL_FROM)) ||
                        		   ( Integer.parseInt(dup_Data.APPL_FROM)  <  Integer.parseInt(c_APPL_TO)   && Integer.parseInt(dup_Data.APPL_TO) >= Integer.parseInt(c_APPL_TO)) ||
                        		   ( Integer.parseInt(dup_Data.APPL_FROM)  >= Integer.parseInt(c_APPL_FROM) && Integer.parseInt(dup_Data.APPL_TO)  <= Integer.parseInt(c_APPL_TO))){
	                	//날짜는 다른데 from-to가 걸치는 경우
	                	message =g.getMessage("MSG.D.D03.0012");//"이미 결재신청된 시간과 중복됩니다. 결재진행현황에서 확인하시기 바랍니다.";
                        return message;
	                }
	            } //if 1 반차의 경우 끝
	            
                else { //전일 휴가의 경우
                    if( dup_Data.APPL_FROM.equals(c_APPL_FROM) && dup_Data.APPL_TO.equals(c_APPL_TO)) { //if 2 : 날짜같을 경우
                    	message = g.getMessage("MSG.D.D03.0011");//"현재 결재신청이 되어 있으므로 결재진행현황에서 확인하시기 바랍니다.";
                        return message;
                    } else if( ( Integer.parseInt(dup_Data.APPL_FROM)  <= Integer.parseInt(c_APPL_FROM) && Integer.parseInt(dup_Data.APPL_TO)  > Integer.parseInt(c_APPL_FROM)) ||
                    		   ( Integer.parseInt(dup_Data.APPL_FROM)  <  Integer.parseInt(c_APPL_TO)   && Integer.parseInt(dup_Data.APPL_TO) >= Integer.parseInt(c_APPL_TO)) ||
                    		   ( Integer.parseInt(dup_Data.APPL_FROM)  >= Integer.parseInt(c_APPL_FROM) && Integer.parseInt(dup_Data.APPL_TO)  <= Integer.parseInt(c_APPL_TO)) ) {
                    	message = g.getMessage("MSG.D.D03.0012");//"이미 결재신청된 날짜와 중복됩니다. 결재진행현황에서 확인하시기 바랍니다.";
                        return message;
                    } //if 3
                } //if 2

            }
            //**************** 모바일루틴 end ********************


	        return message;

	    } catch(Exception e) {
	        throw new GeneralException(e);

	    } finally {
	    }
    }

}

