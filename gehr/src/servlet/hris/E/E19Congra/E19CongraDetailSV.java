/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 경조금                                                      */
/*   Program Name : 경조금 신청 조회                                            */
/*   Program ID   : E19CongraDetailSV                                           */
/*   Description  : 경조금을 신청조회할 수 있도록 하는 Class                    */
/*   Note         : 없음                                                        */
/*   Creation     : 2001-12-19  김성일                                          */
/*   Update       : 2005-02-14  이승희                                          */
/*                  2005-02-24  윤정현                                          */
/*                  2014-04-24  [CSR ID:C20140416_24713]  화환신청시 0007 주문업체 정보추가 , 통상임금정보삭제 , 배송업체메일발송,sms추가,초기구분자 추가  ,삭제시 메일 발송  */
/*                  2014-08-22   화환신청시 0007 삭제 sms추가   */
/*                                                                              */
/********************************************************************************/

package servlet.hris.E.E19Congra;

import hris.A.A04FamilyDetailData;
import hris.A.rfc.A04FamilyDetailRFC;
import hris.E.E19Congra.E19CongFlowerInfoData;
import hris.E.E19Congra.E19CongGrupData;
import hris.E.E19Congra.E19CongcondData;
import hris.E.E19Congra.rfc.E19CongraFlowerInfoRFC;
import hris.E.E19Congra.rfc.E19CongraGrubNumbRFC;
import hris.E.E19Congra.rfc.E19CongraRequestRFC;
import hris.common.MailSendToOutside;
import hris.common.PersonData;
import hris.common.PhoneNumData;
import hris.common.UplusSmsData;
import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalLineData;
import hris.common.db.UplusSmsDB;
import hris.common.rfc.PersonInfoRFC;
import hris.common.rfc.PhoneNumRFC;

import java.sql.SQLException;
import java.util.Properties;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.common.RFCReturnEntity;
import com.common.Utils;
import com.sns.jdf.BusinessException;
import com.sns.jdf.ConfigurationException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.WebUtil;

public class E19CongraDetailSV extends ApprovalBaseServlet
{
    private String UPMU_TYPE ="01";   // 결재 업무타입(경조금)
    private String UPMU_NAME = "경조금";

    protected String getUPMU_TYPE() {
        return UPMU_TYPE;
    }

    protected String getUPMU_NAME() {
        return UPMU_NAME;
    }

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {


        try{

            final WebUserData user = WebUtil.getSessionUser(req);
            Box box = WebUtil.getBox(req);


            String jobid = box.get("jobid", "first");

            String I_APGUB = (String) req.getAttribute("I_APGUB");  //어느 페이지에서 왔나? '1' : 결재할 문서 , '2' : 결재중 문서 , '3' : 결재완료 문서



            final E19CongcondData     e19CongcondData ;

            String  firstYn = "";
            if(firstYn==null|| firstYn.equals("") ){
            	firstYn = "";
            } // end if
            // 대리 신청 추가


            final E19CongraRequestRFC e19CongraRequestRFC = new E19CongraRequestRFC();
            e19CongraRequestRFC.setDetailInput(user.empNo, I_APGUB, box.get("AINF_SEQN"));
            Vector<E19CongcondData> resultList = e19CongraRequestRFC.getDetail(); //결과 데이타
            e19CongcondData = resultList.get(0);



            PersonInfoRFC numfunc = new PersonInfoRFC();
            final PersonData phonenumdata;
            phonenumdata    =   (PersonData)numfunc.getPersonInfo(e19CongcondData.PERNR);
             req.setAttribute("PersonData" , phonenumdata );


            if (jobid.equals("first")) {           //제일처음 신청 화면에 들어온경우.

                req.setAttribute("resultData", Utils.indexOf(resultList, 0));

                if (!detailApporval(req, res, e19CongraRequestRFC))
                    return;

                req.setAttribute("e19CongcondData", Utils.indexOf(resultList, 0));
                req.setAttribute("firstYn", firstYn); //  C20140416_24713   신청에서 조회시 Y

                //결재시 사용
                //신청 대상자 가족 상세정보( 회갑 결재시 생년월일+60년 한 날짜에서 +-1달차이 계산위해)
                A04FamilyDetailRFC a04FamilyDetailRFC                  = new A04FamilyDetailRFC();
                box.put("I_PERNR", e19CongcondData.PERNR);
                Vector             a04FamilyDetailData_vt = a04FamilyDetailRFC.getFamilyDetail(box) ;
                Vector vcA04FamilyData = new Vector();

                for( int i = 0 ; i < a04FamilyDetailData_vt.size() ; i++ ) {
                	A04FamilyDetailData  Data = (A04FamilyDetailData)a04FamilyDetailData_vt.get(i);

                    if (Data.REGNO.equals(e19CongcondData.REGNO )) {
                    	vcA04FamilyData.add(Data);
                    }
                }

                //60번째생일
                String YearTmp="";
                if  (e19CongcondData.REGNO.substring(6,7).equals("1")  ||e19CongcondData.REGNO.substring(6,7).equals("2") ){
                	YearTmp="19";
                }else {
                	YearTmp="20";
                }
                String CheckYy = YearTmp+e19CongcondData.REGNO.substring(0,2);
                String CheckYear =  String.valueOf (Integer.parseInt(CheckYy)+60) ;
                String Sixth_birth =CheckYear+e19CongcondData.REGNO.substring(2,4)+e19CongcondData.REGNO.substring(4,6);

                req.setAttribute("SIXTH_DATE" ,Sixth_birth);
                req.setAttribute("vcA04FamilyData" ,vcA04FamilyData);
            	boolean app = false;
            	Vector  vcAppLineData = e19CongraRequestRFC.getApprovalLine();


            	for (int i = 0; i < vcAppLineData.size(); i++) {
            		ApprovalLineData ald = (ApprovalLineData) vcAppLineData.get(i);
//            		out.println( ald.APPL_PERNR );
//            		out.println( user.empNo );
//            		out.println( e19CongcondData.PERNR );

            		if (ald.APPU_NUMB.equals( user.empNo ) ) {
            			app = true;
//                	    out.println( app );
            			break;
            		}
            	} // end for
            	req.setAttribute("app" ,app);
                printJspPage(req, res, WebUtil.JspURL + "E/E19Congra/E19CongraDetail.jsp");

            } else if (jobid.equals("delete")) {           //제일처음 신청 화면에 들어온경우.

                final String dest = deleteApproval(req, box, e19CongraRequestRFC, new DeleteFunction() {
                    public boolean porcess() throws GeneralException {
                    	String dest="";
                    	E19CongraRequestRFC deleteRFC = new E19CongraRequestRFC();
                        deleteRFC.setDeleteInput(user.empNo, UPMU_TYPE, e19CongraRequestRFC.getApprovalHeader().AINF_SEQN);

                        RFCReturnEntity returnEntity = deleteRFC.delete();

                        if(!returnEntity.isSuccess()) {
                            throw new GeneralException(returnEntity.MSGTX);
                        }
                        String msg = "msg003";
                        // [C20140416_24713] 주문 업체 삭제 메일 발송  start
                        //[CSR ID:3051290] 쌀화환 경조 신청 관련 시스템 개발  2016.07.13 김불휘S
                        //쌀화환도 화환처럼 메일 발송하도록
                        if (e19CongcondData.CONG_CODE.equals("0007") || e19CongcondData.CONG_CODE.equals("0010")){ //화한, 쌀화환 신청시만

    		                 UplusSmsDB smsDB = new UplusSmsDB(); //SMS
    		                 UplusSmsData smsData = new UplusSmsData(); //SMS
    		             	   //근무지리스트
    		             	   Vector E19CongraGrubNumb_vt  = (new E19CongraGrubNumbRFC()).getGrupCode(user.companyCode,"010");
    		             	   String ZGRUP_NUMB_O_NM="";
    		             	   String ZGRUP_NUMB_R_NM="";
    		             	   for( int i = 0 ; i < E19CongraGrubNumb_vt.size() ; i++ ){
    		             		   E19CongGrupData  data = (E19CongGrupData)E19CongraGrubNumb_vt.get(i);
    		             		   if (e19CongcondData.ZGRUP_NUMB_O.equals( data.GRUP_NUMB)){
    		             			   ZGRUP_NUMB_O_NM=data.GRUP_NAME;
    		             		   }
    		             		   if (e19CongcondData.ZGRUP_NUMB_R.equals( data.GRUP_NUMB)){
    		             			   ZGRUP_NUMB_R_NM=data.GRUP_NAME;
    		             		   }
    		             	   }
    		                     //CSR ID: 20140416_24713 화환업체
    		             	   	//[CSR ID:3051290] 쌀화환 경조 신청 관련 시스템 개발  2016.07.13 김불휘S
    		                     Vector e19CongFlowerInfoData_vt = (new E19CongraFlowerInfoRFC()).getFlowerInfoCode(e19CongcondData.CONG_CODE);
    		                     String msg2="";
    		                    //[CSR ID:3051290] 쌀화환 경조 신청 관련 시스템 개발  2016.07.13 김불휘S
    		                 	for( int i = 0 ; i < e19CongFlowerInfoData_vt.size() ; i++ ){

    		                 		if(i==0) {
    		                 		E19CongFlowerInfoData  data = (E19CongFlowerInfoData)e19CongFlowerInfoData_vt.get(i);


    		     	                Properties ptMailBody1 = new Properties();
    		     	                ptMailBody1.setProperty("SServer",user.SServer);              // ElOffice 접속 서버
    		     	                ptMailBody1.setProperty("from_empNo" ,user.empNo);            // 멜 발송자 사번
    		     	                ptMailBody1.setProperty("to_empNo" ,data.ZEMAIL);  // ★멜 수신자 메일id 직접 넣기


    		     	                ptMailBody1.setProperty("ename_R" ,user.ename);       // (피)신청자명
    		     	                //[CSR ID:3051290] 쌀화환 경조 신청 관련 시스템 개발  2016.07.13 김불휘S
    		     	               if (e19CongcondData.CONG_CODE.equals("0007")) {
    		     	                ptMailBody1.setProperty("UPMU_NAME" ,"LG화학 화환 신청 내용 삭제");               // 문서 이름
    		     	               } else if (e19CongcondData.CONG_CODE.equals("0010")) {
    		     	            	  ptMailBody1.setProperty("UPMU_NAME" ,"LG화학 쌀화환 신청 내용 삭제");
    		     	               }

    		     	                ptMailBody1.setProperty("AINF_SEQN" ,e19CongraRequestRFC.getApprovalHeader().AINF_SEQN);              // 신청서 순번
    		     	                ptMailBody1.setProperty("ZGRUP_NUMB_O" ,ZGRUP_NUMB_O_NM);              // 신청자 근무지
    		     	                ptMailBody1.setProperty("ZPHONE_NUM" ,e19CongcondData.ZPHONE_NUM);              // 신청자 전화번호
    		     	                ptMailBody1.setProperty("ZCELL_NUM" ,e19CongcondData.ZCELL_NUM);              // 신청자 핸드폰

    		     	                ptMailBody1.setProperty("ename" ,e19CongcondData.ZUNAME_R);       //대상자(직원명)
    		     	                ptMailBody1.setProperty("empno" ,e19CongcondData.PERNR);       // (피)신청자 사번
    		     	                ptMailBody1.setProperty("ZCELL_NUM_R" ,e19CongcondData.ZCELL_NUM_R);              // 대상자 연락처

    		     	                ptMailBody1.setProperty("ZGRUP_NUMB_R" ,ZGRUP_NUMB_R_NM);              // 대상자 근무지
    		     	                ptMailBody1.setProperty("E_ORGTX" ,phonenumdata.E_ORGTX);              // 대상자 부서
    		     	                ptMailBody1.setProperty("E_PTEXT" ,phonenumdata.E_PTEXT);              // 신분
    		     	                ptMailBody1.setProperty("E_CFLAG" ,  e19CongcondData.ZUNION_FLAG.equals("X") ? "조합원: Y" : ""   );              // 조합원여부
    		     	                ptMailBody1.setProperty("ZTRANS_DATE" ,WebUtil.printDate(e19CongcondData.ZTRANS_DATE,"."));              // 배송일자
    		     	                ptMailBody1.setProperty("ZTRANS_TIME" ,WebUtil.printTime( e19CongcondData.ZTRANS_TIME ) );              // 배송시간

    		     	                ptMailBody1.setProperty("ZTRANS_ADDR" ,e19CongcondData.ZTRANS_ADDR);              // 배송지 주소
    		     	                ptMailBody1.setProperty("ZTRANS_ETC" ,e19CongcondData.ZTRANS_ETC);              // 기타 요구사항

    		     	                //[CSR ID:3051290] 쌀화환 경조 신청 관련 시스템 개발  2016.07.13 김불휘S
    		     	               if(e19CongcondData.CONG_CODE.equals("0007")) {
    		     	            	   ptMailBody1.setProperty("title" ,"아래의 화환 신청 내용이 삭제되었습니다.");              // 내용타이틀
    		     	               } else if(e19CongcondData.CONG_CODE.equals("0010")) {
    		     	            	  ptMailBody1.setProperty("title" ,"아래의 쌀화환 신청 내용이 삭제되었습니다.");
    		     	               }
    		     	                //신청건 삭제시 메일 보내기.
    		     	                // 2002.07.25.------------------------------------------------------------------------

    		     	                // 멜 제목
    		     	                StringBuffer sbSubject1 = new StringBuffer(512);



    		     	                sbSubject1.append("[" + ptMailBody1.getProperty("UPMU_NAME") + "] ");

    		     	                //[CSR ID:3051290] 쌀화환 경조 신청 관련 시스템 개발  2016.07.13 김불휘S
    		     	               if(e19CongcondData.CONG_CODE.equals("0007")) {
    		     	            	   sbSubject1.append( ptMailBody1.getProperty("ename") + "님의 화환 신청 접수건이 삭제되었습니다.");
    		     	               } else if(e19CongcondData.CONG_CODE.equals("0010")) {
    		     	            	  sbSubject1.append( ptMailBody1.getProperty("ename") + "님의 쌀화환 신청 접수건이 삭제되었습니다.");
    		     	               }

    		     	                ptMailBody1.setProperty("subject" ,sbSubject1.toString());    // 멜 제목 설정

    		     	                ptMailBody1.setProperty("FileName" ,"FlowerMailBuild.html");

    		     	                MailSendToOutside maTe1 = null;
									try {
										maTe1 = new MailSendToOutside(ptMailBody1);
									} catch (ConfigurationException e) {

										throw new GeneralException(e);
									}


    		     	                if (!maTe1.process()) {
    		     	                    msg2 = maTe1.getMessage();
    		     	                } // end if
    		     	               msg="삭제 되었습니다. 주문업체에 삭제 메일이 발송되었습니다.";


    			 	                smsData.TR_SENDSTAT = "0"; 					//발송상태 0:발송대기
    			 	                smsData.TR_MSGTYPE = "0"; 						//문자전송형태 0:일반
    			 	                smsData.TR_PHONE = data.ZCELL_NUM;		//수신할 핸드폰번호
    			 	                smsData.TR_CALLBACK = e19CongcondData.ZCELL_NUM;//송신자 전화번호

    		                 	}
                        	}

    		                 	//[CSR ID:3051290] 쌀화환 경조 신청 관련 시스템 개발  2016.07.13 김불휘S
    		                 	 if(e19CongcondData.CONG_CODE.equals("0007")) {
    		                 		 smsData.TR_MSG = "LG화학 "+e19CongcondData.ZUNAME_R+"님의 화환 신청이 삭제되었습니다. 메일 확인후 회신 바랍니다. [삭제자:"+user.ename+"]";
    		                 	 } else if(e19CongcondData.CONG_CODE.equals("0010")) {
    		                 		 smsData.TR_MSG = "LG화학 "+e19CongcondData.ZUNAME_R+"님의 쌀화환 신청이 삭제되었습니다. 메일 확인후 회신 바랍니다. [삭제자:"+user.ename+"]";
    		                 	 }

    			                 Logger.debug.println(this, " smsData = " + smsData.toString());
    			                 try {
									if(smsDB.buildSms(smsData).equals("Y")){
									 	msg=msg+ "\\n" + "및 삭제SMS발송 완료되었습니다.";
									 }else{
									     dest = WebUtil.JspURL+"common/msg.jsp";
									     msg2 = msg2 + "\\n" + " SMS 발송 실패" ;
									 }
								} catch (Exception e) {
									//throw new GeneralException(e);
								}
    			                 // sms

                        }
                        // [C20140416_24713] 주문 업체 삭제 메일 발송  end
                        return true;
                    }
                });

                printJspPage(req, res, dest);

            } else {
                throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
            }


        } catch (Exception e) {
            Logger.error(e);
            throw new GeneralException(e);
        }
    }

}




