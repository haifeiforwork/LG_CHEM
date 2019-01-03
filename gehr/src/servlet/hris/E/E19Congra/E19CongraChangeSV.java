/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 경조금                                                      */
/*   Program Name : 경조금 신청 수정                                            */
/*   Program ID   : E19CongraChangeSV                                           */
/*   Description  : 경조금을 수정할 수 있도록 하는 Class                        */
/*   Note         : 없음                                                        */
/*   Creation     : 2001-12-19  김성일                                          */
/*   Update       : 2005-02-14  이승희                                          */
/*                  2005-02-24  윤정현                                          */
/*                  2014-04-24  [CSR ID:C20140416_24713]  화환신청시 0007 주문업체 정보추가 , 통상임금정보삭제 , 배송업체메일발송,sms추가,초기구분자 추가  ,삭제시 메일 발송  */
/*                  2014-08-27  [CSR ID:2599072] 경조화환 신청시 계좌등록 사항 미적용 반영의 건   */
/*					 2017-07-03  eunha [CSR ID:3423281] 경조화환 복리후생 메뉴 추가  */
/*                  2017-12-01 이지은 [CSR ID:3546961] 경조화환 신청 관련의 건*/
/********************************************************************************/

package servlet.hris.E.E19Congra;

import hris.A.A17Licence.A17LicenceData;
import hris.A.A17Licence.rfc.A17LicenceRFC;
import hris.E.E19Congra.E19CongCodeCheckData;
import hris.E.E19Congra.E19CongFlowerInfoData;
import hris.E.E19Congra.E19CongGrupData;
import hris.E.E19Congra.E19CongcondData;
import hris.E.E19Congra.rfc.E19CongCodeCheckRFC;
import hris.E.E19Congra.rfc.E19CongMoreRelaRFC;
import hris.E.E19Congra.rfc.E19CongRateRFC;
import hris.E.E19Congra.rfc.E19CongraDupCheckRFC;
import hris.E.E19Congra.rfc.E19CongraFlowerInfoRFC;
import hris.E.E19Congra.rfc.E19CongraGrubNumbRFC;
import hris.E.E19Congra.rfc.E19CongraRequestRFC;
import hris.common.*;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalHeader;
import hris.common.approval.ApprovalLineData;
import hris.common.approval.ApprovalBaseServlet.ChangeFunction;
import hris.common.db.AppLineDB;
import hris.common.rfc.ESSExceptCheckRFC;
import hris.common.rfc.PersonInfoRFC;
import hris.common.util.AppUtil;

import java.sql.Connection;
import java.util.Properties;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import servlet.hris.A.A17Licence.A17LicenceBuildSV;

import com.common.Utils;
import com.sns.jdf.BusinessException;
import com.sns.jdf.ConfigurationException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.db.DBUtil;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;

public class E19CongraChangeSV extends ApprovalBaseServlet
{
    private String UPMU_TYPE ="01";   // 결재 업무타입(경조금)
    private String UPMU_NAME = "경조금";

    protected String getUPMU_TYPE() {
        return UPMU_TYPE;
    }

    protected String getUPMU_NAME() {
        return UPMU_NAME;
    }


    protected void performTask(final HttpServletRequest req, final HttpServletResponse res) throws GeneralException
    {
        Connection con = null;

        try{

            final WebUserData user = WebUtil.getSessionUser(req);

            final Box box = WebUtil.getBox(req);

            String dest = "";


            String jobid = box.get("jobid", "first");
            final String AINF_SEQN = box.get("AINF_SEQN");

            String I_APGUB = (String) req.getAttribute("I_APGUB");  //어느 페이지에서 왔나? '1' : 결재할 문서 , '2' : 결재중 문서 , '3' : 결재완료 문서

            Vector E19CongcondData_rate = null;
            Vector AppLineData_vt       = null;
            Vector e19CongraDupCheck_vt = null;

            final E19CongcondData   firstData;
            //[CSR ID:3051290] 쌀화환 경조 신청 관련 시스템 개발  2016.07.13 김불휘S
            // jsp에서 고른 경조내역을 CONG_CODE 에 담는다
            String CONG_CODE = "";
            CONG_CODE = box.get("CONG_CODE");

            final E19CongraRequestRFC e19CongraRequestRFC = new E19CongraRequestRFC();
            e19CongraRequestRFC.setDetailInput(user.empNo, I_APGUB, box.get("AINF_SEQN"));
            Vector<E19CongcondData> resultList = e19CongraRequestRFC.getDetail(); //결과 데이타
            firstData = resultList.get(0);
            //[CSR ID:3423281] 경조화환 복리후생 메뉴 추가 20170703 eunha start
            String isFlower = "N";
            if (firstData.CONG_CODE.equals("0007") || firstData.CONG_CODE.equals("0010")){
            	isFlower = "Y";
            }
          //[CSR ID:3423281] 경조화환 복리후생 메뉴 추가 20170703 eunha end
            req.setAttribute("isFlower" , isFlower );
            // 대리 신청 추가
            PersonInfoRFC numfunc = new PersonInfoRFC();
            final PersonData phonenumdata;
            phonenumdata = (PersonData)numfunc.getPersonInfo(firstData.PERNR);
            req.setAttribute("PersonData" , phonenumdata );


            if( jobid.equals("first") ) {    //제일 처음 수정 화면에 들어온경우.


                E19CongcondData_rate = (new E19CongRateRFC()).getCongRate(firstData.PERNR);

                // 2003.02.20 - 경조금의 중복신청을 .jsp에서 막기위해서 추가됨.
                e19CongraDupCheck_vt = (new E19CongraDupCheckRFC()).getCheckList( firstData.PERNR );

                /**** 계좌정보(계좌번호,은행명)를 새로가져온다. 수정:2002/01/22 ****/
                hris.common.rfc.AccountInfoRFC accountInfoRFC = new hris.common.rfc.AccountInfoRFC();
                Vector AccountData_pers_vt = accountInfoRFC.getPersAccountInfo(firstData.PERNR);
                
                //[CSR ID:3546961] start--------------------------------
                ESSExceptCheckRFC essExcptChk = new ESSExceptCheckRFC();
                String exceptChk = essExcptChk.essExceptcheck(firstData.PERNR, "E0"+UPMU_TYPE).MSGTY;
                Logger.debug.println("경조금 수정 예외 사번 : "+firstData.PERNR+", 예외 코드 : "+exceptChk);
                req.setAttribute("ESS_EXCPT_CHK" , exceptChk );
                //[CSR ID:3546961] end--------------------------------

                AccountData AccountData_hidden = new AccountData();
                DataUtil.fixNull(AccountData_hidden);
                req.setAttribute("AccountData_hidden" , AccountData_hidden );

                req.setAttribute("AccountData_pers_vt", AccountData_pers_vt);
                /**** 계좌정보(계좌번호,은행명)를 새로가져온다.****/
Logger.debug.println("firstData----------------"+firstData);
                req.setAttribute("resultData", Utils.indexOf(resultList, 0));
                req.setAttribute("e19CongcondData",  firstData);
                req.setAttribute("E19CongcondData_rate", E19CongcondData_rate);
                req.setAttribute("e19CongraDupCheck_vt", e19CongraDupCheck_vt);
                req.setAttribute("isUpdate", true); //등록 수정 여부

                detailApporval(req, res, e19CongraRequestRFC);


                dest = WebUtil.JspURL+"E/E19Congra/E19CongraBuild.jsp";

            } else if( jobid.equals("change") ) { //
                /* 실제 신청 부분 */
                dest = changeApproval(req, box, E19CongcondData.class, e19CongraRequestRFC, new ChangeFunction<E19CongcondData>(){

                    public String porcess(E19CongcondData inputData, ApprovalHeader approvalHeader, Vector<ApprovalLineData> approvalLineDatas) throws GeneralException {
                    	String dest="";
                    	inputData.PERNR     = firstData.PERNR;

                        /**** 신청된금액이 입금될 계좌정보가 있는지 체크 ******************************************/
//                      [CSR ID:2599072] 경조화환 신청시 계좌등록 사항 미적용 반영의 건
                        if(!inputData.CONG_CODE.equals("0007")){
        	                hris.common.rfc.AccountInfoRFC accountInfoRFC = new hris.common.rfc.AccountInfoRFC();
        	                if( ! accountInfoRFC.hasPersAccount(firstData.PERNR) ){
        	                    String msg = "msg006";
        	                    req.setAttribute("msg", msg);
        	                    dest = WebUtil.JspURL+"common/caution.jsp";
        	                    throw new GeneralException(msg);
        	                }
                        }
                        /**** 신청된금액이 입금될 계좌정보가 있는지 체크 ******************************************/

                        Vector e19CongCodeCheck_vt  = null;  // @v1.1
                        E19CongCodeCheckData Check_vt  = (E19CongCodeCheckData)(new E19CongCodeCheckRFC()).getCongCodeCheck( "C100", inputData.CONG_DATE,inputData.CONG_CODE,inputData.RELA_CODE,inputData.PERNR );

                  Logger.debug.println("Check_vt = " + Check_vt.toString());
                        if(  !Check_vt.E_FLAG.equals("Y")  ){
                            String msg = Check_vt.E_MESSAGE;
                            req.setAttribute("msg", msg);
                            dest = WebUtil.JspURL+"common/caution.jsp";
                            throw new GeneralException(msg);
                        }


                          /* 결재 신청 RFC 호출 */
                    	E19CongraRequestRFC changeRFC = new E19CongraRequestRFC();
                        changeRFC.setChangeInput(user.empNo, UPMU_TYPE, approvalHeader.AINF_SEQN);

                        Logger.debug("-------- AINF_SEQN " + inputData.AINF_SEQN);

                        changeRFC.build(inputData, box, req);

                        if(!changeRFC.getReturn().isSuccess()) {
                            throw new GeneralException(changeRFC.getReturn().MSGTX);
                        }


                        // [C20140416_24713] 주문 업체 삭제 메일 발송  start
                        if (inputData.CONG_CODE.equals("0007") || inputData.CONG_CODE.equals("0010")) { //화한, 쌀화환 신청시만
    	                 	   //근무지리스트
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
    	                         String msg2="";
    	                         String msg;
    	                     	for( int i = 0 ; i < e19CongFlowerInfoData_vt.size() ; i++ ){
    	                     	   E19CongFlowerInfoData  data = (E19CongFlowerInfoData)e19CongFlowerInfoData_vt.get(i);


    	         	                Properties ptMailBody1 = new Properties();
    	         	                ptMailBody1.setProperty("SServer",user.SServer);              // ElOffice 접속 서버
    	         	                ptMailBody1.setProperty("from_empNo" ,user.empNo);            // 멜 발송자 사번
    	         	                ptMailBody1.setProperty("to_empNo" ,data.ZEMAIL);  // ★멜 수신자 메일id 직접 넣기


    	         	                ptMailBody1.setProperty("ename_R" ,user.ename);       // (피)신청자명

    	         	                //[CSR ID:3051290] 쌀화환 경조 신청 관련 시스템 개발  2016.07.13 김불휘S
    	         	               if(inputData.CONG_CODE.equals("0007")) {
    	         	                ptMailBody1.setProperty("UPMU_NAME" ,"LG화학 화환 신청 내용 변경");               // 문서 이름
    	         	               } else if(inputData.CONG_CODE.equals("0010")) {
    	         	            	  ptMailBody1.setProperty("UPMU_NAME" ,"LG화학 쌀화환 신청 내용 변경");
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
    	         	               if(inputData.CONG_CODE.equals("0007")) {
    	         	            	   ptMailBody1.setProperty("title" ,"화환 신청 내용이 아래와 같이 변경되었습니다.");              // 내용타이틀
    	         	               } else if(inputData.CONG_CODE.equals("0010")) {
    	         	            	  ptMailBody1.setProperty("title" ,"쌀화환 신청 내용이 아래와 같이 변경되었습니다.");
    	         	               }
    	         	                //신청건 삭제시 메일 보내기.
    	         	                // 2002.07.25.------------------------------------------------------------------------

    	         	                // 멜 제목
    	         	                StringBuffer sbSubject1 = new StringBuffer(512);

    	         	                sbSubject1.append("[" + ptMailBody1.getProperty("UPMU_NAME") + "] ");

    	         	                //[CSR ID:3051290] 쌀화환 경조 신청 관련 시스템 개발  2016.07.13 김불휘S
    	         	               if(inputData.CONG_CODE.equals("0007")) {
    	         	            	   sbSubject1.append( ptMailBody1.getProperty("ename") + "님의 화환 신청 접수내용이 변경되었습니다.");
    	         	               } else if(inputData.CONG_CODE.equals("0010")) {
    	         	            	   sbSubject1.append( ptMailBody1.getProperty("ename") + "님의 쌀화환 신청 접수내용이 변경되었습니다.");
    	         	               }

    	         	                ptMailBody1.setProperty("subject" ,sbSubject1.toString());    // 멜 제목 설정

    	         	                ptMailBody1.setProperty("FileName" ,"FlowerMailBuild.html");

    	         	                MailSendToOutside maTe1;
									try {
										maTe1 = new MailSendToOutside(ptMailBody1);
									} catch (ConfigurationException e) {
										throw new GeneralException(e);
									}

    	         	                if (!maTe1.process()) {
    	         	                    msg2 = msg2+maTe1.getMessage();
    	         	                } // end if
    	         	               msg ="수정 되었습니다.주문업체에 내용 수정 메일이 발송되었습니다.";

    		         	              Logger.debug.println(this, "====수정 업체 메일  msg =[  " + msg+"]]]]]data.ZEMAIL:"+data.ZEMAIL);
    	                     	}
                        }
                        // [C20140416_24713] 주문 업체 수정 메일 발송  end
                        return inputData.AINF_SEQN;
                        /* 개발자 작성 부분 끝 */
                    }
                });
            }else if(jobid.equals("change_code")) {//신청화면에서 화환 및 쌀화화을 선택하였을 때, 경조내역 설정을 위해 서블릿을 한번 탄다


                E19CongcondData_rate = (new E19CongRateRFC()).getCongRate(firstData.PERNR);

                // 2003.02.20 - 경조금의 중복신청을 .jsp에서 막기위해서 추가됨.
                e19CongraDupCheck_vt = (new E19CongraDupCheckRFC()).getCheckList( firstData.PERNR );

                /**** 계좌정보(계좌번호,은행명)를 새로가져온다. 수정:2002/01/22 ****/
                hris.common.rfc.AccountInfoRFC accountInfoRFC = new hris.common.rfc.AccountInfoRFC();
                Vector AccountData_pers_vt = accountInfoRFC.getPersAccountInfo(firstData.PERNR);

              //[CSR ID:3051290] 쌀화환 경조 신청 관련 시스템 개발  2016.07.13 김불휘S
                String CONG_CODE_SV = "";
                if( CONG_CODE.equals("0007") ) { //화환 선택했을 경우
                 		CONG_CODE_SV = CONG_CODE;

                 	} else if( CONG_CODE.equals("0010")) { //쌀화환 선택했을 경우
                 		CONG_CODE_SV = CONG_CODE;
                 	}

                 req.setAttribute("CONG_CODE_SV" , CONG_CODE_SV );
                 firstData.CONG_CODE = CONG_CODE_SV;
                 
                 //[CSR ID:3546961] start--------------------------------
                 ESSExceptCheckRFC essExcptChk = new ESSExceptCheckRFC();
                 String exceptChk = essExcptChk.essExceptcheck(firstData.PERNR, "E0"+UPMU_TYPE).MSGTY;
                 Logger.debug.println("경조금 수정 예외 사번 : "+firstData.PERNR+", 예외 코드 : "+exceptChk);
                 req.setAttribute("ESS_EXCPT_CHK" , exceptChk );
                 //[CSR ID:3546961] end--------------------------------

                AccountData AccountData_hidden = new AccountData();
                DataUtil.fixNull(AccountData_hidden);
                req.setAttribute("AccountData_hidden" , AccountData_hidden );

                req.setAttribute("AccountData_pers_vt", AccountData_pers_vt);
                /**** 계좌정보(계좌번호,은행명)를 새로가져온다.****/

                req.setAttribute("e19CongcondData",  firstData);
                req.setAttribute("E19CongcondData_rate", E19CongcondData_rate);
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

