/********************************************************************************/
/*                                                                              */
/*   System Name  :  e-HR                                                        */
/*   1Depth Name  : HR 결재함                                                   */
/*   2Depth Name  : 결재 해야할 문서                                            */
/*   Program Name : 경조금 신청                                                 */
/*   Program ID   : G004ApprovalCongraSV                                        */
/*   Description  : 경조금 신청 부서장 결재/반려                                */
/*   Note         : 없음                                                        */
/*   Creation     : 2005-03-14  이승희                                          */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/

package servlet.hris.G;
/*
 * 작성된 날짜: 2005. 1. 31.
 *
 */
import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;
import hris.A.A01SelfDetailData;
import hris.A.rfc.A01SelfDetailRFC;
import hris.E.E19Congra.E19CongcondData;
import hris.E.E19Congra.E19CongraDupCheckData;
import hris.E.E19Congra.rfc.E19CongraDupCheckRFC;
import hris.E.E19Congra.rfc.E19CongraRequestRFC;
import hris.common.MailSendToEloffic;
import hris.common.ManageInfoData;
import hris.common.PersonData;
import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalHeader;
import hris.common.approval.ApprovalLineData;
import hris.common.rfc.ManageInfoRFC;
import hris.common.rfc.PersonInfoRFC;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Properties;
import java.util.Vector;
/**
 * @author 이승희
 *
 */
public class G004ApprovalCongraSV extends ApprovalBaseServlet
{
    /* (비Javadoc)
     * @see com.sns.jdf.servlet.EHRBaseServlet#performTask(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse)
     */

    private String UPMU_TYPE ="01";   // 결재 업무타입(경조금)
    private String UPMU_NAME = "경조금";

    protected String getUPMU_TYPE() {
        return UPMU_TYPE;
    }

    protected String getUPMU_NAME() {
        return UPMU_NAME;
    }

    protected void performTask(final HttpServletRequest req, final HttpServletResponse res)
            throws GeneralException
    {
        try{
            final WebUserData user = WebUtil.getSessionUser(req);

           String dest  = "";

           final Box box = WebUtil.getBox(req);

           final E19CongcondData     e19CongcondData ;

           String  AINF_SEQN  = box.get("AINF_SEQN");

           String jobid = box.get("jobid");

           final E19CongraRequestRFC e19CongraRequestRFC  = new E19CongraRequestRFC();
           e19CongraRequestRFC.setDetailInput(user.empNo, "1", AINF_SEQN);
           Vector<E19CongcondData> resultList = e19CongraRequestRFC.getDetail(); //결과 데이타
           e19CongcondData = resultList.get(0);

           PersonInfoRFC numfunc = new PersonInfoRFC();
           final PersonData phonenumdata;
           phonenumdata    =   (PersonData)numfunc.getPersonInfo(e19CongcondData.PERNR);

           //경조차이 메일내용의 사업장정보 GET 위함 2012.12.04
           A01SelfDetailRFC			piRfc				=	new A01SelfDetailRFC();
           A01SelfDetailData    pid = (A01SelfDetailData) piRfc.getPersInfo(e19CongcondData.PERNR, user.area.getMolga(), "").get(0);


           /* 승인 시 */
           if("A".equals(jobid)) {
               /* 개발자 영역 끝 */
               dest = accept(req, box, "T_ZHRA002T", e19CongcondData, e19CongraRequestRFC, new ApprovalFunction<E19CongcondData>() {
                   public boolean porcess(E19CongcondData inputData, ApprovalHeader approvalHeader, Vector<ApprovalLineData> approvalLineDatas) throws GeneralException {
                	       inputData.PROOF = box.get("PROOF");
                	       inputData.REASON_CD = box.get("REASON_CD");
                           inputData.WAGE_WONX = DataUtil.changeGlobalAmount(box.get("WAGE_WONX"), user.area) ;  // 통상임금
                           inputData.CONG_WONX = DataUtil.changeGlobalAmount(box.get("CONG_WONX"), user.area) ;  // 경조금
                           inputData.UNAME     = user.empNo;
                           inputData.AEDTM     = DataUtil.getCurrentDate();


                       Vector e19CongraDupCheck_vt = null;

                       e19CongraDupCheck_vt = (new E19CongraDupCheckRFC()).getCheckList( e19CongcondData.PERNR );


                       //신청시 오류로 체크가 안되어 결재시 dup 체크로직을 추가함 2009.09.25

                       for( int i = 0 ; i < e19CongraDupCheck_vt.size() ; i++ ) {
                           E19CongraDupCheckData c_Data = (E19CongraDupCheckData)e19CongraDupCheck_vt.get(i);
                           if(c_Data.CONG_CODE.equals(e19CongcondData.CONG_CODE) &&  c_Data.RELA_CODE.equals(e19CongcondData.RELA_CODE)
                                   && c_Data.EREL_NAME.equals(e19CongcondData.EREL_NAME) ) {
                                 if( c_Data.INFO_FLAG.equals("I") ) {
                                     String msg = "해당 경조내역에 이미 동명의 경조대상자가 있습니다.";
                                     String url = "history.back();";
                                     req.setAttribute("msg", msg);
                                     req.setAttribute("url", url);
                                     printJspPage(req, res, WebUtil.JspURL+"common/msg.jsp");
                                     return false;
                                 }
                           }
                       }


                       return true;
                   }
               });
               /*------경조금 회갑 결재시 회갑일 1달 이상 차이 나는 대상자를 사업장 업무담당자에게 메일발송 START----*/

               String SIXTH_DATE   =  box.get("SIXTH_DATE"); //회갑일
               String Check_from    = DataUtil.addDays(SIXTH_DATE,-30);
               String Check_to       = DataUtil.addDays(SIXTH_DATE,30);

               Logger.debug.println(this ,"SIXTH_DATE:"+SIXTH_DATE+"Check_from:"+Check_from+"Check_to:"+Check_to);

               StringBuffer mangerMailTitle = new StringBuffer(512);
               StringBuffer mangerMailUpmuName = new StringBuffer(512);
               StringBuffer sbGuideText = new StringBuffer(512);

               if (  e19CongcondData.CONG_CODE.equals("0002") && e19CongcondData.REGNO  != "" &&
	                    ( Integer.parseInt(DataUtil.delDateGubn(e19CongcondData.CONG_DATE ) )  <   Integer.parseInt(Check_from) ||  Integer.parseInt( DataUtil.delDateGubn(e19CongcondData.CONG_DATE ) )  >  Integer.parseInt(Check_to ) )
	                    )
	            {
               	mangerMailTitle.append("경조일자와 생년월일 차이 안내");
               	mangerMailUpmuName.append("경조금 회갑 결재 내용 확인");
               	sbGuideText.append("안녕하십니까? 다음과 같이 경조금 결재가 진행되었으나,<br>경조일자와 생년월일 차이가 발생 되었음에 따라 사실 확인을 하시기 바랍니다.<br>");
	            }
               //임원: 11 임원, 12 연구위원  인경우 담당자에게 메일발송
               if (  phonenumdata.E_PERSK.equals("11") || phonenumdata.E_PERSK.equals("12") ){
               	if ( mangerMailTitle.length()>0 ){

	                	mangerMailTitle.append(" 및 ");
	                	mangerMailUpmuName.append(" 및 ");
	                	sbGuideText.append("<br>");
               	}else{
	                	sbGuideText.append("안녕하십니까? 다음과 같이 ");
               	}
               	mangerMailTitle.append("임원경조금 결재완료 안내");
               	mangerMailUpmuName.append("임원 경조금 결재완료");
               	sbGuideText.append("임원 경조금 결재가 완료되었습니다.<br>");
               }

               if (mangerMailTitle.length()>0 )
               {


           		Properties ptMailBody2 = new Properties();
                   ptMailBody2.setProperty("SServer",user.SServer);                 // ElOffice 접속 서버
                   ptMailBody2.setProperty("from_empNo" ,user.empNo);               // 멜 발송자 사번
                   ptMailBody2.setProperty("to_empNo" ,e19CongcondData.PERNR);      // 멜 수신자 사번

                   ptMailBody2.setProperty("ename" ,phonenumdata.E_ENAME);          // (피)신청자명
                   ptMailBody2.setProperty("empno" ,phonenumdata.E_PERNR);         // (피)신청자 사번

                   ptMailBody2.setProperty("UPMU_NAME" , mangerMailUpmuName.toString());// 문서 이름
                   ptMailBody2.setProperty("AINF_SEQN" ,AINF_SEQN);                 // 신청서 순번

                   // 멜 제목
                   StringBuffer sbSubject1 = new StringBuffer(512);

                   sbSubject1.append("[" + ptMailBody2.getProperty("UPMU_NAME") + "] ");
                   sbSubject1.append(phonenumdata.E_ENAME  + "님의  ");

                   ptMailBody2.setProperty("FileName" ,"WarningCongraMail1.html");
                   sbSubject1.append(mangerMailTitle);
                   ptMailBody2.setProperty("subject" ,sbSubject1.toString());        // 멜 제목 설정
                   ptMailBody2.setProperty("sbGuideText" ,sbGuideText.toString());        // 멜 첫줄  안내 내용
                   ptMailBody2.setProperty("CONG_DATE" ,e19CongcondData.CONG_DATE);        // 경조일자
                   ptMailBody2.setProperty("CONG_NAME" ,e19CongcondData.CONG_NAME);       // 경조명
                   ptMailBody2.setProperty("RELA_TEXT" , box.get("RELA_TEXT")  );       // 관계명
                   ptMailBody2.setProperty("EREL_NAME" , e19CongcondData.EREL_NAME);       // 대상자성명

                   ptMailBody2.setProperty("REGNO" ,e19CongcondData.REGNO.substring(0,6)+"-*******");       // 경조대상자주민번호
                   ptMailBody2.setProperty("WAGE_WONX" ,WebUtil.printNumFormat(Double.toString(Double.parseDouble(e19CongcondData.WAGE_WONX) * 100.0) ));       // 통상임금
                   ptMailBody2.setProperty("CONG_RATE" ,e19CongcondData.CONG_RATE);       // 지급률
                   ptMailBody2.setProperty("CONG_WONX" ,WebUtil.printNumFormat(Double.toString(Double.parseDouble(e19CongcondData.CONG_WONX) * 100.0)));       // 경조금액
                   ptMailBody2.setProperty("BANK_NAME" , e19CongcondData.BANK_NAME);       // 이체은행명
                   ptMailBody2.setProperty("BANKN" ,e19CongcondData.BANKN);       // 은행계좌번호
                   ptMailBody2.setProperty("LIFNR" ,e19CongcondData.LIFNR);       // 부서계좌번호
                   ptMailBody2.setProperty("HOLI_CONT" ,Integer.toString(Integer.parseInt(e19CongcondData.HOLI_CONT)));       // 경조휴가일수
                   ptMailBody2.setProperty("WORK_YEAR_TEXT" ,box.get("WORK_YEAR_TEXT"));       // 근속년수
                   ptMailBody2.setProperty("BEGDA" ,e19CongcondData.BEGDA);       // 신청일
                   ptMailBody2.setProperty("PROOF" ,box.get("PROOF").equals("X")?"Yes":"" );       //  사실여부확인

                   ptMailBody2.setProperty("E_ORGTX" , pid.ORGTX);       // 신청자조직명
                   ptMailBody2.setProperty("BTEXT" , pid.BTEXT);       // 신청자사업장
                   ptMailBody2.setProperty("REASON_TEXT" ,box.get("REASON_TEXT")  );       //차이사유
                   ptMailBody2.setProperty("BIGO_TEXT" , box.get("BIGO_TEXT")  );       // 적요

                   //------------메일발송 담당자 list  ★ ★ ★ ★ ★ ★
                   String to_empNo="";
                   String msg2 = "";
                   ManageInfoRFC  Minfo = new ManageInfoRFC();
                   Vector ManageInfo_vt = Minfo.getManageInfo("01");
                   for (int i = 0; i < ManageInfo_vt.size(); i++) {
                   	ManageInfoData data = (ManageInfoData) ManageInfo_vt.get(i);

                       to_empNo = data.PERNR;
	                    ptMailBody2.setProperty("to_empNo" ,to_empNo);                   // 멜 수신자 사번
	                    MailSendToEloffic   maTe2 = new MailSendToEloffic(ptMailBody2);

	                    if (!maTe2.process()) {
	                    	msg2  += maTe2.getMessage() + "\\n";
	                    } // end if

                   } // end for


                   Logger.debug.println(this ,"ptMailBody2:"+ptMailBody2.toString());
                   Logger.debug.println(this ,"==========경조 회갑 warning 메일 대상자사번 to_empNo:"+to_empNo);
               }

               /*------경조금 회갑 결재시 회갑일 1달 이상 차이 나는 대상자를 사업장 업무담당자에게 메일발송 END----*/
           /* 반려시 */
           } else if("R".equals(jobid)) {
               dest = reject(req, box,  null, e19CongcondData, e19CongraRequestRFC, null);
           } else if("C".equals(jobid)) {
               dest = cancel(req, box,  null, e19CongcondData, e19CongraRequestRFC, null);
           }  else {
               throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
           }

           Logger.debug.println(this, " destributed = " + dest);
           printJspPage(req, res, dest);

       } catch(Exception e) {
           Logger.err.println(DataUtil.getStackTrace(e));
           throw new GeneralException(e);
       }
   }
}


