/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 경조금                                                      */
/*   Program Name : 경조금 신청                                                 */
/*   Program ID   : E19CongraBuildSV                                            */
/*   Description  : 경조금을 신청할 수 있도록 하는 Class                        */
/*   Note         : 없음                                                        */
/*   Creation     : 2001-12-19  김성일                                          */
/*   Update       : 2005-02-14  이승희                                          */
/*                  2005-03-07  윤정현                                          */
/*                  2006-06-20  @v1.1     체크로직추가                          */
/*                  2014-04-21  CSR ID: 20140416_24713 화환업체추가                     */
/*                  2014-08-27  [CSR ID:2599072] 경조화환 신청시 계좌등록 사항 미적용 반영의 건   */
/*					 2017-07-03  eunha [CSR ID:3423281] 경조화환 복리후생 메뉴 추가  */
/*					 2017-07-26  eunha [CSR ID:3444623] 경조금 신청 화면 스크립트 오류 수정  */
/*                  2017-12-01  이지은 [CSR ID:3546961] 경조화환 신청 관련의 건*/
/********************************************************************************/

package servlet.hris.E.E19Congra;

import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.Properties;
import java.util.Vector;

import javax.servlet.http.*;

import org.apache.commons.lang.math.NumberUtils;

import com.common.Utils;
import com.sns.jdf.*;
import com.sns.jdf.util.*;
import com.sns.jdf.servlet.*;

import hris.common.*;
import hris.common.util.*;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalLineData;
import hris.common.approval.ApprovalBaseServlet.RequestFunction;
import hris.common.db.UplusSmsDB;
import hris.common.rfc.*;
import hris.A.A17Licence.A17LicenceData;
import hris.A.A17Licence.rfc.A17LicenceRFC;
import hris.D.D03Vocation.D03RemainVocationData;
import hris.D.D03Vocation.rfc.D03RemainVocationRFC;
import hris.E.E19Congra.rfc.*;
import hris.E.E19Congra.*;

public class E19CongraBuildSV extends ApprovalBaseServlet
{
    private String UPMU_TYPE ="01";   // 결재 업무타입(경조금)
    private String UPMU_NAME = "경조금";

    protected String getUPMU_TYPE() {
        return UPMU_TYPE;
    }

    protected String getUPMU_NAME() {
        return UPMU_NAME;
    }

    //[CSR ID:3423281] 경조화환 복리후생 메뉴 추가 20170703 start
    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {
    	process(req, res, "N");
	}
      //protected void process(final HttpServletRequest req, HttpServletResponse res) throws GeneralException
    protected void process(final HttpServletRequest req, HttpServletResponse res, String isFlower) throws GeneralException
    //[CSR ID:3423281] 경조화환 복리후생 메뉴 추가 20170703 end
    {

        try {

            final WebUserData user = WebUtil.getSessionUser(req);

            final Box box = WebUtil.getBox(req);

            String dest = "";

            // [CSR ID:3051290] 쌀화환 경조 신청 관련 시스템 개발  2016.07.13 김불휘S
            // jsp에서 넘어온 경조내역을 담아두는 변수 CONG_CODE 생성
            String CONG_CODE = "";
            String jobid = box.get("jobid", "first");
            CONG_CODE = box.get("CONG_CODE");


           final String PERNR = getPERNR(box, user); //신청대상자 사번

            // 대리 신청 추가
            PersonInfoRFC numfunc = new PersonInfoRFC();
            final PersonData phonenumdata;
            phonenumdata    =   (PersonData)numfunc.getPersonInfo(PERNR);
             req.setAttribute("PersonData" , phonenumdata );

            Logger.debug.println("=============PersonData:"+phonenumdata );
            req.setAttribute("isFlower" , isFlower); //[CSR ID:3423281] 경조화환 복리후생 메뉴 추가 20170703

            if( jobid.equals("first") ) {           //제일처음 신청 화면에 들어온경우.

                Vector E19CongcondData_more = null;
                Vector e19CongraDupCheck_vt = null;
                Vector e19CongraLifnr_vt    = null;  // 부서계좌정보



                if ( phonenumdata.E_RECON.equals("")) {
                    // 결재
                	 getApprovalInfo(req, PERNR);

                } else {
                    // 퇴직자 결재일때는 퇴직일자 하루전 날짜를 I_DATE 에 넣어준다. 2005.04.15 추가
                    String reday = DataUtil.removeStructur(phonenumdata.E_REDAY, "-");
                    getApprovalInfo(req, PERNR,DataUtil.addDays(reday, -1));

                }

                E19CongcondData_more = (new E19CongMoreRelaRFC()).getCongMoreRela( PERNR, DataUtil.getCurrentDate() ,"1");
                E19CongcondData e19CongcondData = (E19CongcondData)E19CongcondData_more.get(0);
                e19CongcondData.PERNR = PERNR;

                // 2003.02.20 - 경조금의 중복신청을 .jsp에서 막기위해서 추가됨.
                e19CongraDupCheck_vt = (new E19CongraDupCheckRFC()).getCheckList( PERNR );

                // 계좌정보(계좌번호,은행명)를 새로가져온다. 수정:2002/01/22
                hris.common.rfc.AccountInfoRFC accountInfoRFC = new hris.common.rfc.AccountInfoRFC();
                Vector AccountData_pers_vt = accountInfoRFC.getPersAccountInfo(PERNR);

                AccountData AccountData_hidden = new AccountData();
                DataUtil.fixNull(AccountData_hidden);
                
                //[CSR ID:3546961] start--------------------------------
                ESSExceptCheckRFC essExcptChk = new ESSExceptCheckRFC();
                String exceptChk = essExcptChk.essExceptcheck(PERNR, "E0"+UPMU_TYPE).MSGTY;
                Logger.debug.println("경조금 신청 예외 사번 : "+PERNR+", 예외 코드 : "+exceptChk);
                req.setAttribute("ESS_EXCPT_CHK" , exceptChk );
                //[CSR ID:3546961] end--------------------------------
                
                req.setAttribute("AccountData_hidden" , AccountData_hidden );
                req.setAttribute("AccountData_pers_vt", AccountData_pers_vt);
                // 계좌정보(계좌번호,은행명)를 새로가져온다.
                req.setAttribute("e19CongcondData",      e19CongcondData);
                Logger.debug.println(this,e19CongcondData );
                req.setAttribute("e19CongraDupCheck_vt", e19CongraDupCheck_vt);

                dest = WebUtil.JspURL+"E/E19Congra/E19CongraBuild.jsp";

           //[CSR ID:3444623] 경조금 신청 화면 스크립트 오류 수정 start
            } else if (jobid.equals("check")) {	//날짜 체크.

			    String i_CONG_DATE = req.getParameter("CONG_DATE");
			    String i_PERNR     = req.getParameter("PERNR");
			    String i_CONG_CODE = req.getParameter("CONG_CODE");
			    String i_RELA_CODE = req.getParameter("RELA_CODE");

			    Vector E19CongcondData_vt = (new E19CongMoreRelaRFC()).getCongMoreRela(i_PERNR, i_CONG_DATE,"1");

			    if( E19CongcondData_vt.size() > 0 ){
			        E19CongcondData e19CongcondData = (E19CongcondData)E19CongcondData_vt.get(0);

			    Vector e19CongCodeCheck_vt  = null;  // @v1.1
			    E19CongCodeCheckData Check_vt  = (E19CongCodeCheckData)(new E19CongCodeCheckRFC()).getCongCodeCheck( "C100", i_CONG_DATE,i_CONG_CODE,i_RELA_CODE,i_PERNR );

			    PrintWriter out = res.getWriter();

				out.println(Check_vt.E_FLAG + "||" + Check_vt.E_MESSAGE+ "||"); // fail

				out.println(e19CongcondData.WORK_YEAR + "||" + e19CongcondData.WORK_MNTH+ "||" + WebUtil.printNumFormat(e19CongcondData.WAGE_WONX) );

					Logger.debug.println("[#####]	JOBID	 :	[ " + jobid + " ]	0) Check_vt.E_FLAG		 			 :	[ " + Check_vt.E_FLAG + " ]");
					Logger.debug.println("[#####]	JOBID	 :	[ " + jobid + " ]	1) Check_vt.E_MESSAGE 	 :	[ " + Check_vt.E_MESSAGE  + " ]");
					Logger.debug.println("[#####]	JOBID	 :	[ " + jobid + " ]	2) e19CongcondData.WORK_YEAR 		 :	[ " + e19CongcondData.WORK_YEAR  + " ]");
					Logger.debug.println("[#####]	JOBID	 :	[ " + jobid + " ]	3) e19CongcondData.WORK_MNTH		 :	[ " + e19CongcondData.WORK_MNTH + " ]");
					Logger.debug.println("[#####]	JOBID	 :	[ " + jobid + " ]	4) e19CongcondData.WAGE_WONX		 :	[ " + WebUtil.printNumFormat(e19CongcondData.WAGE_WONX) + " ]");
				}

				return;
			//[CSR ID:3444623] 경조금 신청 화면 스크립트 오류 수정 end
            }else if( jobid.equals("create") ) {

                /* 실제 신청 부분 */
                dest = requestApproval(req, box, E19CongcondData.class, new RequestFunction<E19CongcondData>() {
                    public String porcess(E19CongcondData inputData, Vector<ApprovalLineData> approvalLine) throws GeneralException {
                    	String dest="";

                        Vector e19CongCodeCheck_vt  = null;  // @v1.1
                        E19CongCodeCheckData Check_vt  = (E19CongCodeCheckData)(new E19CongCodeCheckRFC()).getCongCodeCheck( "C100", inputData.CONG_DATE,inputData.CONG_CODE,inputData.RELA_CODE,inputData.PERNR );

                        if(  !Check_vt.E_FLAG.equals("Y")  ){
                            String msg = Check_vt.E_MESSAGE;
                            req.setAttribute("msg", msg);
                            dest = WebUtil.JspURL+"common/caution.jsp";
                            throw new GeneralException(msg);
                        }

                        /**** 신청된금액이 입금될 계좌정보가 있는지 체크 ****************************************************/
                        //[CSR ID:2599072] 경조화환 신청시 계좌등록 사항 미적용 반영의 건
                        if(!inputData.CONG_CODE.equals("0007")){
        	                hris.common.rfc.AccountInfoRFC accountInfoRFC = new hris.common.rfc.AccountInfoRFC();
        	                if( ! accountInfoRFC.hasPersAccount(PERNR) ){
        	                    String msg = "msg006";
        	                    req.setAttribute("msg", msg);
        	                    dest = WebUtil.JspURL+"common/caution.jsp";
        	                    Logger.debug.println(this, " destributed = " + dest);
        	                    throw new GeneralException(msg);
        	                }
                        }
                        /**** 신청된금액이 입금될 계좌정보가 있는지 체크 ****************************************************/

                        /* 결재 신청 RFC 호출 */
                        E19CongraRequestRFC e19CongraRequestRFC = new E19CongraRequestRFC();
                        e19CongraRequestRFC.setRequestInput(user.empNo, UPMU_TYPE);
                        String AINF_SEQN = e19CongraRequestRFC.build(inputData, box, req);

                        if(!e19CongraRequestRFC.getReturn().isSuccess()) {
                            throw new GeneralException(e19CongraRequestRFC.getReturn().MSGTX);
                        };
                        String msg = "msg001";
                        String msg2 = "";

                        ////////////////주문업체 메일발송 sms ///////////////////////////////
                  	   //근무지리스트

                         // [C20140416_24713] 주문 업체 삭제 메일 발송  start
                         //[CSR ID:3051290] 쌀화환 경조 신청 관련 시스템 개발  2016.07.13 김불휘S
                         //화환의 경우에 해당하던 메일을 쌀화환도 적용
                         if (inputData.CONG_CODE.equals("0007") || inputData.CONG_CODE.equals("0010")){ //화한, 쌀화환 신청시만

         		         	   Vector E19CongraGrubNumb_vt  = (new E19CongraGrubNumbRFC()).getGrupCode(user.companyCode,"010");
         		         	   String ZGRUP_NUMB_O_NM="";
         		         	   String ZGRUP_NUMB_R_NM="";
         		         	   for( int i = 0 ; i < E19CongraGrubNumb_vt.size() ; i++ ){
         		         		   E19CongGrupData  data = (E19CongGrupData)E19CongraGrubNumb_vt.get(i);
         		         		   if (inputData.ZGRUP_NUMB_O.equals( data.GRUP_NUMB)){
         		         			   ZGRUP_NUMB_O_NM=data.GRUP_NAME;
         		         		   }
         		         		   if (inputData.ZGRUP_NUMB_R.equals( data.GRUP_NUMB)){
         		         			   ZGRUP_NUMB_R_NM=data.GRUP_NAME;
         		         		   }
         		         	   }
         		                 //CSR ID: 20140416_24713 화환업체
         		         	//[CSR ID:3051290] 쌀화환 경조 신청 관련 시스템 개발  2016.07.13 김불휘S
         		                 Vector e19CongFlowerInfoData_vt = (new E19CongraFlowerInfoRFC()).getFlowerInfoCode(inputData.CONG_CODE);

         		                 UplusSmsDB smsDB = new UplusSmsDB(); //SMS
         		                 UplusSmsData smsData = new UplusSmsData(); //SMS

         		           //      String msg2 = null;

         		                 //[CSR ID:3051290] 쌀화환 경조 신청 관련 시스템 개발  2016.07.13 김불휘S
         		                 //쌀화환의 경우는 화환과 다른 문자가 가도록 설정
         		             	for( int i = 0 ; i < e19CongFlowerInfoData_vt.size() ; i++ ){
         		             		if(i==0) {
         		             	   E19CongFlowerInfoData  data = (E19CongFlowerInfoData)e19CongFlowerInfoData_vt.get(i);


         		 	                Properties ptMailBody1 = new Properties();
         		 	                ptMailBody1.setProperty("SServer",user.SServer);              // ElOffice 접속 서버
         		 	                ptMailBody1.setProperty("from_empNo" ,user.empNo);            // 멜 발송자 사번
         		 	                ptMailBody1.setProperty("to_empNo" ,data.ZEMAIL);  // ★멜 수신자 메일id 직접 넣기


         		 	                ptMailBody1.setProperty("ename_R" ,user.ename);       // (피)신청자명

         		 	                //쌀화환의 경우는 화환과 다른 문자가 가도록 설정
         		 	                if(inputData.CONG_CODE.equals("0007")) {
         		 	                ptMailBody1.setProperty("UPMU_NAME" ,"LG화학 화환 신청 접수");               // 문서 이름
         		 	               } else if(inputData.CONG_CODE.equals("0010")) {
         		 	            	  ptMailBody1.setProperty("UPMU_NAME" ,"LG화학 쌀화환 신청 접수");
         		 	               }
         		 	                ptMailBody1.setProperty("AINF_SEQN" ,AINF_SEQN);              // 신청서 순번
         		 	                ptMailBody1.setProperty("ZGRUP_NUMB_O" ,ZGRUP_NUMB_O_NM);              // 신청자 근무지
         		 	                ptMailBody1.setProperty("ZPHONE_NUM" ,inputData.ZPHONE_NUM);              // 신청자 전화번호
         		 	                ptMailBody1.setProperty("ZCELL_NUM" ,inputData.ZCELL_NUM);              // 신청자 핸드폰

         		 	                ptMailBody1.setProperty("ename" ,inputData.ZUNAME_R);       //대상자(직원명)
         		 	                ptMailBody1.setProperty("empno" ,inputData.PERNR);       // (피)신청자 사번
         		 	                ptMailBody1.setProperty("ZCELL_NUM_R" ,inputData.ZCELL_NUM_R);              // 대상자 연락처
         		 	                ptMailBody1.setProperty("RELA_NAME" ,inputData.RELA_NAME);              // 경조대상자 관계
         		 	                ptMailBody1.setProperty("EREL_NAME" ,inputData.EREL_NAME);              // 경조대상자 성명



         		 	                ptMailBody1.setProperty("ZGRUP_NUMB_R" ,ZGRUP_NUMB_R_NM);              // 대상자 근무지
         		 	                ptMailBody1.setProperty("E_ORGTX" ,phonenumdata.E_ORGTX);              // 대상자 부서
         		 	                ptMailBody1.setProperty("E_PTEXT" ,phonenumdata.E_PTEXT);              // 신분
         		 	                ptMailBody1.setProperty("E_CFLAG" ,  inputData.ZUNION_FLAG.equals("X") ? "조합원: Y" : ""   );              // 조합원여부
         		 	                ptMailBody1.setProperty("ZTRANS_DATE" ,WebUtil.printDate(inputData.ZTRANS_DATE,"."));              // 배송일자
         		 	                ptMailBody1.setProperty("ZTRANS_TIME" ,WebUtil.printTime( inputData.ZTRANS_TIME ) );              // 배송시간

         		 	                ptMailBody1.setProperty("ZTRANS_ADDR" ,inputData.ZTRANS_ADDR);              // 배송지 주소
         		 	                ptMailBody1.setProperty("ZTRANS_ETC" ,inputData.ZTRANS_ETC);              // 기타 요구사항
         		 	                //[CSR ID:3051290] 쌀화환 경조 신청 관련 시스템 개발  2016.07.13 김불휘S
         		 	                //쌀화환의 경우는 화환과 다른 문자가 가도록 설정
         		 	                if(inputData.CONG_CODE.equals("0007")) {
         		 	                ptMailBody1.setProperty("title" ,"화환 신청이 아래의 내용으로 접수되었습니다.");              // 내용타이틀
         		 	               } else if(inputData.CONG_CODE.equals("0010")) {
         		 	            	  ptMailBody1.setProperty("title" ,"쌀화환 신청이 아래의 내용으로 접수되었습니다.");
         		 	               }

         		 	                //신청건 삭제시 메일 보내기.
         		 	                // 2002.07.25.------------------------------------------------------------------------

         		 	                // 멜 제목
         		 	                StringBuffer sbSubject1 = new StringBuffer(512);

         		 	                sbSubject1.append("[" + ptMailBody1.getProperty("UPMU_NAME") + "] ");
         		 	                //[CSR ID:3051290] 쌀화환 경조 신청 관련 시스템 개발  2016.07.13 김불휘S
         		 	                //쌀화환의 경우는 화환과 다른 문자가 가도록 설정
         		 	               if(inputData.CONG_CODE.equals("0007")) {
         		 	            	   sbSubject1.append( ptMailBody1.getProperty("ename") + "님의 화환 신청이 접수되었습니다.");
         		 	               } else if(inputData.CONG_CODE.equals("0010")) {
         		 	            	  sbSubject1.append( ptMailBody1.getProperty("ename") + "님의 쌀화환 신청이 접수되었습니다.");
         		 	               }

         		 	                ptMailBody1.setProperty("subject" ,sbSubject1.toString());    // 멜 제목 설정

         		 	                ptMailBody1.setProperty("FileName" ,"FlowerMailBuild.html");

         		 	                MailSendToOutside maTe1;
									try {
										maTe1 = new MailSendToOutside(ptMailBody1);

										if (!maTe1.process()) {
											msg2 = maTe1.getMessage();
										} // end if
									} catch (ConfigurationException e) {
										throw new GeneralException(e);
									}


         		 	                smsData.TR_SENDSTAT = "0"; 					//발송상태 0:발송대기
         		 	                smsData.TR_MSGTYPE = "0"; 						//문자전송형태 0:일반
         		 	                smsData.TR_PHONE = data.ZCELL_NUM;		//수신할 핸드폰번호
         		 	                smsData.TR_CALLBACK = inputData.ZCELL_NUM;//송신자 전화번호


         		             		}
         		             	}

         		                 msg = "신청 되었습니다."+ "\\n" + "주문업체에 메일발송 ";
         		                 //[CSR ID:3051290] 쌀화환 경조 신청 관련 시스템 개발  2016.07.13 김불휘S
         		                 //쌀화환의 경우는 화환과 다른 문자가 가도록 설정
         		                 if(inputData.CONG_CODE.equals("0007")) {
         		                	 smsData.TR_MSG = "LG화학 "+inputData.ZUNAME_R+"님의 화환 신청이 접수되었습니다. 메일 확인후 회신 바랍니다. [신청자:"+user.ename+"]";
         		                 } else if(inputData.CONG_CODE.equals("0010")) {
         		                	 smsData.TR_MSG = "LG화학 "+inputData.ZUNAME_R+"님의 쌀화환 신청이 접수되었습니다. 메일 확인후 회신 바랍니다. [신청자:"+user.ename+"]";
         		                 }

         		                 Logger.debug.println(this, " smsData = " + smsData.toString());
         		                 try {
									if(smsDB.buildSms(smsData).equals("Y")){
									 	msg=msg+ "\\n" + "및 SMS발송 완료되었습니다.";
									 }else{
									     dest = WebUtil.JspURL+"common/msg.jsp";
									     msg2 = msg2 + "\\n" + " SMS 발송 실패" ;
									 }
								} catch (Exception e) {

									//throw new GeneralException(e);
								}
         		                 // sms

         		                 // [C20140416_24713] 주문 업체 SMS 발송  end
         		                 //String url = "location.href = '" + WebUtil.ServletURL+"hris.E.E19Congra.E19CongraDetailSV?AINF_SEQN=" + box.get("AINF_SEQN") + "';";
         		                 //req.setAttribute("msg", msg);
         		                 //req.setAttribute("url", url);
         		                 //dest = WebUtil.JspURL+"common/msg.jsp";
                          }
                          //////////////주문업체 메일발송 sms end //////////////////////////////////




                        return AINF_SEQN;
                        /* 개발자 작성 부분 끝 */
                    }
                });
            }else if(jobid.equals("change_code")) {//신청화면에서 화환 및 쌀화화을 선택하였을 때, 경조내역 설정을 위해 서블릿을 한번 탄다
            	Vector E19CongcondData_more = null;
                Vector e19CongraDupCheck_vt = null;
                Vector e19CongraLifnr_vt    = null;  // 부서계좌정보

                E19CongcondData     e19CongcondData = new E19CongcondData();

                box.copyToEntity(e19CongcondData);

                if ( phonenumdata.E_RECON.equals("")) {
                    // 결재
                	 getApprovalInfo(req, PERNR);

                } else {
                    // 퇴직자 결재일때는 퇴직일자 하루전 날짜를 I_DATE 에 넣어준다. 2005.04.15 추가
                    String reday = DataUtil.removeStructur(phonenumdata.E_REDAY, "-");
                    getApprovalInfo(req, PERNR,DataUtil.addDays(reday, -1));

                }

                E19CongcondData_more = (new E19CongMoreRelaRFC()).getCongMoreRela( PERNR, DataUtil.getCurrentDate() ,"1");

                e19CongcondData = (E19CongcondData)E19CongcondData_more.get(0);

                e19CongcondData.PERNR = PERNR;

                // 2003.02.20 - 경조금의 중복신청을 .jsp에서 막기위해서 추가됨.
                e19CongraDupCheck_vt = (new E19CongraDupCheckRFC()).getCheckList( PERNR );

                // 계좌정보(계좌번호,은행명)를 새로가져온다. 수정:2002/01/22
                hris.common.rfc.AccountInfoRFC accountInfoRFC = new hris.common.rfc.AccountInfoRFC();
                Vector AccountData_pers_vt = accountInfoRFC.getPersAccountInfo(PERNR);

                AccountData AccountData_hidden = new AccountData();
                DataUtil.fixNull(AccountData_hidden);

               //[CSR ID:3051290] 쌀화환 경조 신청 관련 시스템 개발  2016.07.13 김불휘S
               // 선택한 경조내역을 다시 jsp로 넘겨주기 위해 변수 CONG_CODE_SV 를 새로 생성한다
               String CONG_CODE_SV = "";
               if( CONG_CODE.equals("0007") ) { //화환 선택했을 경우
                		CONG_CODE_SV = CONG_CODE;

                	} else if( CONG_CODE.equals("0010")) { //쌀화환 선택했을 경우
                		CONG_CODE_SV = CONG_CODE;
                	}

                req.setAttribute("CONG_CODE_SV" , CONG_CODE_SV );
                
                //[CSR ID:3546961] start--------------------------------
                ESSExceptCheckRFC essExcptChk = new ESSExceptCheckRFC();
                String exceptChk = essExcptChk.essExceptcheck(PERNR, "E0"+UPMU_TYPE).MSGTY;
                Logger.debug.println("경조금 신청 예외 사번 : "+PERNR+", 예외 코드 : "+exceptChk);
                req.setAttribute("ESS_EXCPT_CHK" , exceptChk );
                //[CSR ID:3546961] end--------------------------------


                req.setAttribute("AccountData_hidden" , AccountData_hidden );
                req.setAttribute("AccountData_pers_vt", AccountData_pers_vt);
                // 계좌정보(계좌번호,은행명)를 새로가져온다.

                req.setAttribute("e19CongcondData",      e19CongcondData);
                req.setAttribute("e19CongraDupCheck_vt", e19CongraDupCheck_vt);

                dest = WebUtil.JspURL+"E/E19Congra/E19CongraBuild.jsp";


            } else {
                throw new GeneralException("내부명령(jobid)이 올바르지 않습니다. ");
            }
            Logger.debug.println(this, " destributed = " + dest);
            printJspPage(req, res, dest);

        } catch(Exception e) {
            throw new GeneralException(e);
        }
    }
}
