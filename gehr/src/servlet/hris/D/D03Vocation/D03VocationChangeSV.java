/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : 신청                                                        		*/
/*   2Depth Name  : 근태                                                        		*/
/*   Program Name : 휴가 수정                                                   		*/
/*   Program ID   : D03VocationChangeSV                                         */
/*   Description  : 휴가 수정 할수 있도록 하는 Class                            	*/
/*   Note         :                                                             */
/*   Creation     : 2002-01-04  김도신                                          		*/
/*   Update       : 2005-03-04  유용원                                          		*/
/*   Update       : 2013-09-03  LSA  @CSR1  유급휴일 토요일은 경조휴가일수   미산입(단, 6일 이상의 경조휴가에 한해토요일 산입)  */
/*   Update       : 2014-02-04  C20140106_63914 : 경조휴가 오류 추가   			*/
/*   Update       : 2014-02-19  C20140219 : 경조휴가 토요일이 공휴일인 경우 휴가일수에 토요일포함로직 제외   */
/*                : 2014-08-24   [CSR ID:2595636] 동일일에 휴가&대근 차단 요청 건   */
/*                : 2016-10-10 FD-038 GEHR통합작업-KSC 							*/
/*                : 2017-08-21 [CSR ID:3462893] 잔여연차 오류 수정요청의 건 		*/
/*						//@PJ.멕시코 법인 Rollout 프로젝트 추가 관련(Area = MX("32")) 2018/02/09 rdcamel */
/*                : 2017-05-17 성환희 [WorkTime52] 보상휴가 추가 건 				*/
/********************************************************************************/
package servlet.hris.D.D03Vocation;

import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.common.Utils;
import com.common.constant.Area;
import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;

import hris.D.D03Vocation.D03CondolHolidaysData;
import hris.D.D03Vocation.D03RemainVocationData;
import hris.D.D03Vocation.D03VocationData;
import hris.D.D03Vocation.D03WorkPeriodData;
import hris.D.D03Vocation.rfc.D03CondolHolidaysRFC;
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
import hris.common.approval.ApprovalHeader;
import hris.common.approval.ApprovalLineData;
import hris.common.rfc.AuthCheckNTMRFC;
import hris.common.rfc.PersonInfoRFC;

public class D03VocationChangeSV extends ApprovalBaseServlet {

    private String UPMU_TYPE ="18";            // 결재 업무타입(휴가신청)

	private String UPMU_NAME = "Leave";

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
            /**         * Start: 국가별 분기처리 
             * //@PJ.멕시코 법인 Rollout 프로젝트 추가 관련(Area = MX("32")) 2018/02/09 rdcamel */
           if (user.area.equals(Area.KR) ) {
			} else if (user.area.equals(Area.PL) || user.area.equals(Area.DE) || user.area.equals(Area.US)|| user.area.equals(Area.MX)) { // PL 폴랜드, DE 독일 은 유럽화면으로
        	   printJspPage(req, res, WebUtil.ServletURL+"hris.D.D03Vocation.D03VocationChangeEurpSV" );
		       	return;
			} else{
				printJspPage(req, res, WebUtil.ServletURL+"hris.D.D03Vocation.D03VocationChangeGlobalSV" );
		       	return;
			}
            /**             * END: 국가별 분기처리             */

            String dest = "";

            final Box box = WebUtil.getBox(req);
            final String jobid = box.get("jobid", "first");
            Logger.debug.println(this, "[jobid] = "+jobid + " [user] : "+user.toString());


            String I_APGUB = (String) req.getAttribute("I_APGUB");  //어느 페이지에서 왔나? '1' : 결재할 문서 , '2' : 결재중 문서 , '3' : 결재완료 문서

            //**********수정 시작 (20050304:유용원)**********
            final String          ainf_seqn           = box.get("AINF_SEQN");
            final D03VocationRFC  rfc                 = new D03VocationRFC();
            rfc.setDetailInput(user.empNo, I_APGUB, ainf_seqn); // 결재란설정

            D03VocationData d03VocationData     = new D03VocationData();

            Vector          d03VocationData_vt  = null;
            D03VocationData  tempData    = new D03VocationData();
            d03VocationData_vt = rfc.getVocation( tempData.PERNR, ainf_seqn );
            tempData   = (D03VocationData)Utils.indexOf(d03VocationData_vt, 0);
            //휴가신청 조회
            Logger.debug.println(this, "휴가신청 조회 : " + d03VocationData_vt.toString());

            // 대리 신청 추가
            PersonInfoRFC numfunc         = new PersonInfoRFC();
            PersonData phonenumdata    = null;

            phonenumdata  = (PersonData)numfunc.getPersonInfo(tempData.PERNR, "X" );
            req.setAttribute("PersonData" , phonenumdata );

            //**********수정 끝.****************************

            if( jobid.equals("first") ) {           //제일처음 신청 화면에 들어온경우.

                req.setAttribute("isUpdate", true); //[결재]등록 수정 여부   <- 수정쪽에는 반드시 필요함

                // 휴가신청 조회
                d03VocationData_vt = rfc.getVocation( tempData.PERNR, ainf_seqn );
                d03VocationData    = (D03VocationData)d03VocationData_vt.get(0);
                Logger.debug.println(this, "휴가신청 조회 : " + d03VocationData_vt.toString());
                
                // 보상휴가 권한체크
                AuthCheckNTMRFC authCheckNTMRFC = new AuthCheckNTMRFC();
            	String E_AUTH = authCheckNTMRFC.getAuth(tempData.PERNR, "S_ESS");
            	req.setAttribute("E_AUTH", E_AUTH);
            	
                // 잔여휴가일수, 장치교대근무조 체크
                D03RemainVocationData d03RemainVocationData = new D03RemainVocationData();
                
                if("Y".equals(E_AUTH)) {	//사무직
                	String vocaType = (d03VocationData.AWART.equals("0111") 
                						|| d03VocationData.AWART.equals("0112") 
                						|| d03VocationData.AWART.equals("0113")) ? "B" : "A";
                	D03RemainVocationOfficeRFC  rfcRemain = new D03RemainVocationOfficeRFC();
                	d03RemainVocationData = (D03RemainVocationData)rfcRemain.getRemainVocation(tempData.PERNR, d03VocationData.APPL_TO, vocaType);
                } else {
                	D03RemainVocationRFC rfcRemain             = new D03RemainVocationRFC();
                	d03RemainVocationData = (D03RemainVocationData)rfcRemain.getRemainVocation(tempData.PERNR, d03VocationData.APPL_TO);
                }
                
                //@csr1경조휴가인경우 경조일수,경조일 넘기기 위해 추가
                Vector D03CondolHolidaysData_dis = ( new D03CondolHolidaysRFC() ).getCongDisplay(tempData.PERNR ,"1",DataUtil.getCurrentDate(),"","");

                String CONG_DATE = "";
                String HOLI_CONT = "";

                for( int i = 0 ; i < D03CondolHolidaysData_dis.size() ; i++ ) {
                    D03CondolHolidaysData data = (D03CondolHolidaysData)D03CondolHolidaysData_dis.get(i);

                    if ( data.AINF_SEQN.equals(d03VocationData.A002_SEQN)){
                    	HOLI_CONT = data.HOLI_CONT;
                    	CONG_DATE = data.CONG_DATE;
                    }
                }

                Logger.debug.println(this, "d03VocationData.A002_SEQN : "+ d03VocationData.A002_SEQN );
                Logger.debug.println(this, "CONG_DATE : "+ CONG_DATE );
                Logger.debug.println(this, "HOLI_CONT : "+ HOLI_CONT );
                req.setAttribute("d03RemainVocationData", d03RemainVocationData);
                req.setAttribute("d03VocationData_vt",    d03VocationData_vt);
                req.setAttribute("CONG_DATE",        CONG_DATE); //@csr1
                req.setAttribute("HOLI_CONT",        HOLI_CONT); //@csr1


                D16OTHDDupCheckRFC d16OTHDDupCheckRFC = new D16OTHDDupCheckRFC();
                Vector OTHDDupCheckData_vt = null;
                OTHDDupCheckData_vt = d16OTHDDupCheckRFC.getCheckList( tempData.PERNR, UPMU_TYPE ,user.area);
                Logger.debug.println(this, "OTHDDupCheckData_vt : "+ OTHDDupCheckData_vt.toString());
                req.setAttribute("OTHDDupCheckData_vt", OTHDDupCheckData_vt);

                detailApporval(req, res, rfc);

                dest = WebUtil.JspURL+"D/D03Vocation/D03VocationBuild.jsp";

            } else if( jobid.equals("change") ) {       //

            	final D03VocationData firstData = tempData;
                // 실제 수정 부분 /
                dest = changeApproval(req, box, D03VocationData.class, rfc, new ChangeFunction<D03VocationData>(){
                    public String porcess(D03VocationData d03VocationData, ApprovalHeader approvalHeader,
                    		Vector<ApprovalLineData> approvalLine)
                			throws GeneralException {


                Vector d03VocationData_vt = new Vector();

                /////////////////////////////////////////////////////////////////////////////
                // 휴가신청 저장..
                d03VocationData.AINF_SEQN   = ainf_seqn;                // 결재정보 일련번호
                d03VocationData.BEGDA       = box.get("BEGDA");         // 신청일
                d03VocationData.AWART       = box.get("AWART");         // 근무/휴무 유형
                d03VocationData.REASON      = box.get("REASON");          // 신청 사유
                d03VocationData.APPL_FROM   = box.get("APPL_FROM");     // 신청시작일
                d03VocationData.APPL_TO     = box.get("APPL_TO");       // 신청종료일
                d03VocationData.BEGUZ       = box.get("BEGUZ");         // 시작시간
                d03VocationData.ENDUZ       = box.get("ENDUZ");         // 종료시간
                d03VocationData.DEDUCT_DATE = box.get("DEDUCT_DATE");   // 공제일수
                //**********수정 시작 (20050223:유용원)**********
                d03VocationData.PERNR       = firstData.PERNR;           // 사원번호
                d03VocationData.ZPERNR      = user.empNo;           // 사원번호
                d03VocationData.UNAME       = user.empNo;               //신청자 사번 설정(대리신청 ,본인 신청)
                d03VocationData.AEDTM       = DataUtil.getCurrentDate();
                d03VocationData.CONG_CODE   = box.get("CONG_CODE");   // 경조내역                 // 변경일(현재날짜)
                d03VocationData.OVTM_CODE    = box.get("OVTM_CODE");   // 사유코드CSR ID:1546748
                d03VocationData.OVTM_NAME    = box.get("OVTM_NAME");   // 사유코드CSR ID:1546748
                //**********수정 끝.****************************

                String message = checkData(box, d03VocationData, user , firstData, req);


                //------------------------------------ 개인 근무 일정 체크 ------------------------------------//

                if( !message.equals("") ){      //메세지가 있는경우
                    d03VocationData_vt.addElement(d03VocationData);



                    String  P_A024_SEQN   = box.get("P_A024_SEQN");         // 경조신청내역SEQN
                    Logger.debug.println(this, "원래패이지로");
                    req.setAttribute("jobid", jobid);
                    req.setAttribute("message", message);
                    req.setAttribute("msg2", message);
                    req.setAttribute("d03VocationData_vt", d03VocationData_vt);
                    req.setAttribute("P_A024_SEQN", P_A024_SEQN);

                    D16OTHDDupCheckRFC func2 = new D16OTHDDupCheckRFC();
                    Vector OTHDDupCheckData_vt = func2.getCheckList( firstData.PERNR, UPMU_TYPE ,user.area);
                    req.setAttribute("OTHDDupCheckData_vt", OTHDDupCheckData_vt);

                    detailApporval(req, res, rfc);

                    req.setAttribute("approvalLine", approvalLine); //변경된 결재라인

                    req.setAttribute("isUpdate", true); //[결재]등록 수정 여부   <- 수정쪽에는 반드시 필요함
//                    String url =  WebUtil.JspURL+"D/D03Vocation/D03VocationBuild_KR.jsp";
//                    printJspPage(req,res,url);


                    return null;

                } else { //저장

                    //**********수정 시작 (20050223:유용원)**********
                    String msg  = null;
                    String msg2 = null;

	                // * 결재 신청 RFC 호출 * /
	                rfc.setChangeInput(user.empNo, UPMU_TYPE, approvalHeader.AINF_SEQN);

	               // Logger.debug("-------- AINF_SEQN " + inputData.AINF_SEQN);

	                String  P_A024_SEQN   = box.get("P_A024_SEQN");         // 경조신청내역SEQN
	                String new_ainf_seqn = rfc.build(firstData.PERNR, d03VocationData, P_A024_SEQN, box, req);//ainf_seqn, bankflag,

	                if(!rfc.getReturn().isSuccess()) {
	                    /*req.setAttribute("msg", rfc.getReturn().MSGTX);   //실패 메세지 처리 - 임시
	                    return null;*/
	                	throw new GeneralException(rfc.getReturn().MSGTX);
	                }

	                return approvalHeader.AINF_SEQN;
	                // * 개발자 작성 부분 끝 */
                }

            }});
/*
                    if( appDB.canUpdate((AppLineData)AppLineData_vt.get(0)) ) {

                        Logger.debug.println( this, " D03Vocation appDB.c hange :AppLineData_vt "+AppLineData_vt.toString() );
                        // 기존 결재자 리스트
                        Vector orgAppLineData_vt = AppUtil.getAppChangeVt(ainf_seqn);

                        appDB.change(AppLineData_vt);
                        Vector          ret             = new Vector();
                        ret =  rfc.change( firstData.PERNR, ainf_seqn , d03VocationData,P_A024_SEQN );
	                    //C20111025_86242 체크메세지 추가
	                    String E_RETURN    = (String)ret.get(0);
	                    String E_MESSAGE = (String)ret.get(1);

	                    Logger.debug.println(this, "E_RETURN : " +E_RETURN );
	                    Logger.debug.println(this, "E_MESSAGE : " +E_MESSAGE );
	                    if ( E_RETURN.equals("") ) {
	                        con.commit();

	                        msg = "msg002";

	                        AppLineData oldAppLine = (AppLineData) orgAppLineData_vt.get(0);
	                        AppLineData newAppLine = (AppLineData) AppLineData_vt.get(0);
	                       Logger.debug.println(this ,oldAppLine);
	                        Logger.debug.println(this ,newAppLine);

	                        if (!newAppLine.APPL_APPU_NUMB.equals(oldAppLine.APPL_PERNR)) {

	                            // 결재자 변경시 멜 보내기 ,ElOffice 인터 페이스
	                            phonenumdata    =   (PersonData)numfunc.getPersonInfo(firstData.PERNR);

	                            // 이메일 보내기
	                            Properties ptMailBody = new Properties();
	                            ptMailBody.setProperty("SServer",user.SServer);                 // ElOffice 접속 서버
	                            ptMailBody.setProperty("from_empNo" ,user.empNo);               // 멜 발송자 사번
	                            ptMailBody.setProperty("to_empNo" ,oldAppLine.APPL_PERNR);      // 멜 수신자 사번
	                            ptMailBody.setProperty("ename" ,phonenumdata.E_ENAME);          // (피)신청자명
	                            ptMailBody.setProperty("empno" ,phonenumdata.E_PERNR);          // (피)신청자 사번
	                            ptMailBody.setProperty("UPMU_NAME" ,"휴가");                    // 문서 이름
	                            ptMailBody.setProperty("AINF_SEQN" ,ainf_seqn);                 // 신청서 순번

	                            //                          멜 제목
	                            StringBuffer sbSubject = new StringBuffer(512);

	                            sbSubject.append("[" + ptMailBody.getProperty("UPMU_NAME") + "] ");
	                            sbSubject.append( ptMailBody.getProperty("ename") + "님이 신청을 삭제하셨습니다.");
	                            ptMailBody.setProperty("subject" ,sbSubject.toString());

	                            ptMailBody.setProperty("FileName" ,"NoticeMail5.html");

	                            MailSendToEloffic   maTe = new MailSendToEloffic(ptMailBody);
	                            // 기존 결재자 멜 전송
	                            if (!maTe.process()) {
	                                msg2 = msg2 + " 삭제 " + maTe.getMessage();
	                            } // end if

	                            // 멜 제목
	                            sbSubject = new StringBuffer(512);
	                            sbSubject.append("[" + ptMailBody.getProperty("UPMU_NAME") + "] ");
	                            sbSubject.append(ptMailBody.getProperty("ename") +"님이 신청하셨습니다.");

	                            ptMailBody.setProperty("subject" ,sbSubject.toString());
	                            ptMailBody.remove("FileName");
	                            ptMailBody.setProperty("to_empNo" ,newAppLine.APPL_APPU_NUMB);

	                            maTe = new MailSendToEloffic(ptMailBody);
	                            // 신규 결재자 멜 전송
	                            if (!maTe.process()) {
	                                msg2 = msg2 +" \\n 신청 " + maTe.getMessage();
	                            } // end if

	                            // ElOffice 인터페이스
	                            try {
	                                DraftDocForEloffice ddfe = new DraftDocForEloffice();
	                                ElofficInterfaceData eof = ddfe.makeDocForChange(ainf_seqn ,user.SServer , phonenumdata.E_PERNR, ptMailBody.getProperty("UPMU_NAME") , oldAppLine.APPL_PERNR);

	                                Logger.debug.println(this, "makeDocForChange AINF_SEQN:"+ainf_seqn+"oldAppLine.APPL_PERNR = " + oldAppLine.APPL_PERNR);
	                                Vector vcElofficInterfaceData = new Vector();
	                                vcElofficInterfaceData.add(eof);

	                                ElofficInterfaceData eofD = ddfe.makeDocContents(ainf_seqn ,user.SServer,ptMailBody.getProperty("UPMU_NAME"));
	                                vcElofficInterfaceData.add(eofD);

	                                req.setAttribute("vcElofficInterfaceData", vcElofficInterfaceData);
	                                dest = WebUtil.JspURL+"common/ElOfficeInterface.jsp";
	                            } catch (Exception e) {
	                                dest = WebUtil.JspURL+"common/msg.jsp";
	                                msg2 = msg2 + "\\n" + " Eloffic 연동 실패" ;
	                            } // end try
	                        } else {
	                            msg = "msg002";
	                            dest = WebUtil.JspURL+"common/msg.jsp";
	                        } // end if

	                    } else {

	                    	con.rollback();
	                        msg = E_MESSAGE;

	                    	d03VocationData.PERNR       = firstData.PERNR;
	                        d03VocationData_vt.addElement(d03VocationData);

	                        D16OTHDDupCheckRFC func2 = new D16OTHDDupCheckRFC();
	                        Vector OTHDDupCheckData_vt = func2.getCheckList( firstData.PERNR, UPMU_TYPE );

	                        Logger.debug.println(this, "SAP 오류 체크로 원래패이지로"+E_MESSAGE);
	                        req.setAttribute("jobid", jobid);
	                        req.setAttribute("message", msg);
	                        req.setAttribute("d03VocationData_vt", d03VocationData_vt);
	                        req.setAttribute("d03WorkPeriodData_vt", d03WorkPeriodData_vt);
	                        req.setAttribute("d03RemainVocationData",  d03RemainVocationData);
	                        req.setAttribute("AppLineData_vt"      , AppLineData_vt);

	                        req.setAttribute("OTHDDupCheckData_vt", OTHDDupCheckData_vt);

	                        dest = WebUtil.JspURL+"D/D03Vocation/D03VocationChange.jsp";
	                 }
                    } else {
                        msg = "msg005";
                        dest = WebUtil.JspURL+"common/msg.jsp";
                    } // end if

                    String url = "location.href = '" + WebUtil.ServletURL+"hris.D.D03Vocation.D03VocationDetailSV?AINF_SEQN="+ainf_seqn+"" +
                    "&RequestPageName=" + RequestPageName + "';";
                    req.setAttribute("msg", msg);
                    req.setAttribute("msg2", msg2);
                    req.setAttribute("url", url);
                    //**********수정 시작 (20050223:유용원)**********
*/

            } else {
                throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
            }
            Logger.debug.println(this, "destributed = " + dest);
            printJspPage(req, res, dest);

        } catch(Exception e) {
            throw new GeneralException(e);
        } finally {

        }
    }







    protected String checkData(Box box, D03VocationData d03VocationData, WebUserData user , D03VocationData firstData, HttpServletRequest req) throws GeneralException {

        String  dateFrom           = "";
        String  dateTo             = "";
        String  message            = "";
        double  remain_date        = 0.0;
        double  vacation_day       = 0.0;       // 휴무일수
        long    beg_time           = 0;
        long    end_time           = 0;
        long    work_time          = 0;

        try{
        //rfc                   = new D03VocationRFC();
        //d03VocationData       = new D03VocationData();
        D03WorkPeriodRFC      rfcWork               = new D03WorkPeriodRFC();
        D03WorkPeriodData     d03WorkPeriodData     = new D03WorkPeriodData();

        // 보상휴가 권한체크
        AuthCheckNTMRFC authCheckNTMRFC = new AuthCheckNTMRFC();
    	String E_AUTH = authCheckNTMRFC.getAuth(firstData.PERNR, "S_ESS");
    	
        // 잔여휴가일수, 장치교대근무조 체크
        D03RemainVocationData d03RemainVocationData = new D03RemainVocationData();
        
        if("Y".equals(E_AUTH)) {	//사무직
        	String vocaType = (d03VocationData.AWART.equals("0111") 
								|| d03VocationData.AWART.equals("0112") 
								|| d03VocationData.AWART.equals("0113")) ? "B" : "A";
        	D03RemainVocationOfficeRFC  rfcRemain = new D03RemainVocationOfficeRFC();
        	d03RemainVocationData = (D03RemainVocationData)rfcRemain.getRemainVocation(firstData.PERNR, d03VocationData.APPL_TO, vocaType);
        } else {					//현장직
        	D03RemainVocationRFC  rfcRemain = new D03RemainVocationRFC();
        	d03RemainVocationData = (D03RemainVocationData)rfcRemain.getRemainVocation(firstData.PERNR, d03VocationData.APPL_TO);
        }

//        d03VocationData.REMAIN_DATE = d03RemainVocationData.E_REMAIN;                            //box.get("REMAIN_DATE");   // 잔여휴가일수
        d03VocationData.REMAIN_DATE = d03RemainVocationData.ZKVRB;                            //box.get("REMAIN_DATE");   // 잔여휴가일수

        //------------------------------------ 개인 근무 일정 체크 ------------------------------------//
        dateFrom    = box.get("APPL_FROM");
        dateTo      = box.get("APPL_TO");

        //@@@ 경조일,경조일수 체크로직추가
        String   HOLI_CONT    = WebUtil.nvl( box.get("HOLI_CONT"),"0");   //  경조일수
        String   CONG_DATE    = WebUtil.nvl(box.get("CONG_DATE"),"");   //  경조일자

//        remain_date = Double.parseDouble(d03RemainVocationData.E_REMAIN);              //Double.parseDouble(box.get("REMAIN_DATE"));
        //[CSR ID:3462893] 잔여연차 오류 수정요청의 건 start
        //remain_date = Double.parseDouble(d03RemainVocationData.ZKVRB);              //Double.parseDouble(box.get("REMAIN_DATE"));
        remain_date = Double.parseDouble(box.get("REMAIN_DATE"));
        //[CSR ID:3462893] 잔여연차 오류 수정요청의 건 end

        Vector d03WorkPeriodData_vt = rfcWork.getWorkPeriod( firstData.PERNR, dateFrom, dateTo );
        Logger.debug.println(this, "개인 기간 작업 스케줄 : " + d03WorkPeriodData_vt.toString());

        //--2002.09.06. 마이너스 휴가를 적용할 경우를 체크하고 한계를 정한다. ------------------------------------//
        D03MinusRestRFC func_minus = new D03MinusRestRFC();
        String          minusRest  = func_minus.check(firstData.PERNR, user.companyCode, dateFrom);
        double          minus      = Double.parseDouble(minusRest);
        if( minus < 0.0 ) {
            minus = minus * (-1);
        }
/*
        //              LG석유화학 전일, 반휴, 토요휴가 신청시 마이너스휴가 적용한다.---------------------------------------
        if( user.companyCode.equals("N100") ) {
            remain_date = remain_date + minus;
            //              LG화학이면서 토요휴가 신청시 마이너스휴가 적용한다.---------------------------------------
        } else*/
        if( user.companyCode.equals("C100") && d03VocationData.AWART.equals("0122") ) {
            remain_date = remain_date + minus;
        }

        Logger.debug.println(this, "remain_date : " + remain_date);
        //--2002.09.06. 마이너스 휴가를 적용할 경우를 체크하고 한계를 정한다. ------------------------------------//

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


        if( d03VocationData.AWART.equals("0110") || d03VocationData.AWART.equals("0111") ) {        // 전일휴가..
            int count     = 0;
            int day_count = 0;

            for( int i = 0 ; i < d03WorkPeriodData_vt.size() ; i++ ) {
                d03WorkPeriodData = (D03WorkPeriodData)d03WorkPeriodData_vt.get(i);

                //                      신청기간 일자수를 구한다.
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
                    message = "휴가신청일수가 잔여휴가일수보다 많습니다.";

                    //[CSR ID:2942508] 연차휴가 신청 팝업 요청
                    if(currMon.equals("12")){
                    	message="휴가기간이 '"+currDate.substring(2, 4)+".12.21 이후일 경우, '"+nextMon.substring(2, 4)+"년 신규 연차가 생성되어야 \\n신청 가능합니다.(연차생성일:'"+currDate.substring(2, 4)+".12.21)";
                    }
                } else if( count == 0 ) {
                    message = "신청기간에 근무일정이 존재하지 않습니다.";
                }
                d03VocationData.DEDUCT_DATE = Double.toString(count);   // 전일휴가일때만 공제일수를 다시 계산한다.
            } else {
                message = "전일휴가는 근무일정이 있는 평일에만 신청가능합니다.";
            }

        } else if( d03VocationData.AWART.equals("0120") || d03VocationData.AWART.equals("0121")
        			|| d03VocationData.AWART.equals("0112") || d03VocationData.AWART.equals("0113")) { // 평일반휴..
            d03WorkPeriodData = (D03WorkPeriodData)d03WorkPeriodData_vt.get(0);

            // 근무시간 계산
            beg_time  = Long.parseLong(d03WorkPeriodData.BEGUZ);
            end_time  = Long.parseLong(d03WorkPeriodData.ENDUZ);

            work_time = end_time - beg_time;
            if( work_time > 40000 ) {
                //vacation_day++;
                //if( vacation_day > remain_date ) {
                if ( remain_date < 0.5 ) {  //0.5일만 남았어도 신청가능하도록
                    message = "휴가신청일수가 잔여휴가일수보다 많습니다.";

                    //[CSR ID:2942508] 연차휴가 신청 팝업 요청
                    if(currMon.equals("12")){
                    	message="휴가기간이 '"+currDate.substring(2, 4)+".12.21 이후일 경우, '"+nextMon.substring(2, 4)+"년 신규 연차가 생성되어야 \\n신청 가능합니다.(연차생성일:'"+currDate.substring(2, 4)+".12.21)";
                    }
                }
            } else {
                message = "반일휴가는 근무일정이 있는 평일에만 신청가능합니다.";
            }

        } else if( d03VocationData.AWART.equals("0122") ) {     // 토요휴가..
            d03WorkPeriodData = (D03WorkPeriodData)d03WorkPeriodData_vt.get(0);

            // 근무시간 계산
            beg_time  = Long.parseLong(d03WorkPeriodData.BEGUZ);
            end_time  = Long.parseLong(d03WorkPeriodData.ENDUZ);

            work_time = end_time - beg_time;

            //------------------장치교대근무자인지 체크하고 장치교대근무자이면 신청을 막는다.(2002.05.29)
            D03ShiftCheckRFC func_shift = new D03ShiftCheckRFC();
            String           shiftCheck = func_shift.check(firstData.PERNR, dateFrom);
            if( shiftCheck.equals("1") ) {
                message = "휴가 신청일은 일일근무일정이 장치교대조로 토요휴가를 신청할수 없습니다.";
            } else {
                //------------------장치교대근무자인지 체크하고 장치교대근무자이면 신청을 막는다.
                if( work_time >= 40000 ) {
                    vacation_day++;

                    if( vacation_day > remain_date ) {
                        message = "휴가신청일수가 잔여휴가일수보다 많습니다.";

                        //[CSR ID:2942508] 연차휴가 신청 팝업 요청
                        if(currMon.equals("12")){
                        	message="휴가기간이 '"+currDate.substring(2, 4)+".12.21 이후일 경우, '"+nextMon.substring(2, 4)+"년 신규 연차가 생성되어야 \\n신청 가능합니다.(연차생성일:'"+currDate.substring(2, 4)+".12.21)";
                        }
                    }
                } else {
                    message = "토요휴가는 근무일정이 있는 토요일에만 신청가능합니다.";
                }
            }

        } else if( d03VocationData.AWART.equals("0130") ||d03VocationData.AWART.equals("0370")) { // 경조휴가, [CSR ID : 1225704] 0370:자녀출산무급
            int count = 0;
            for( int i = 0 ; i < d03WorkPeriodData_vt.size() ; i++ ) {
                d03WorkPeriodData = (D03WorkPeriodData)d03WorkPeriodData_vt.get(i);

                // 근무시간 계산
                beg_time  = Long.parseLong(d03WorkPeriodData.BEGUZ);
                end_time  = Long.parseLong(d03WorkPeriodData.ENDUZ);

                work_time = end_time - beg_time;


            	//  2013.12.17
            	//<경조휴가 일수 제외>
            	//      1순위 : 유급휴일 (공휴일, 일요일)
            	//      2순위 : 근무일정이 OFF(단, 토요일은 포함)
            	//	사무직은 토요일이 유급휴일이므로 휴가일수체크시포함되어야 함
            	// C20140106_63914
            	D03ShiftCheckRFC func_shift = new D03ShiftCheckRFC();
            	String           shiftCheck = func_shift.check(firstData.PERNR, dateFrom);

                if( work_time >= 40000 ) {
                    count++;
                }else if ( shiftCheck.equals("D") &&   d03WorkPeriodData.DAY.equals("6")&& Integer.parseInt(HOLI_CONT)>=6 && d03WorkPeriodData.CHK_0340.equals("")){
                   //@CSR1  유급휴일 토요일은 경조휴가일수   미산입(단, 6일 이상의 경조휴가에 한해토요일 산입)
                	//   CSR ID : C20140219  CHK_0340:"" :일반 ,값이있는경우 공휴일 ..
               	   count++;
                	Logger.debug.println(this, "HOLI_CONT:" + HOLI_CONT+"count:"+count);
                }

                // 휴무일수 계산
                if( work_time >= 40000 ) {
                    vacation_day++;
                }else if ( shiftCheck.equals("D") &&   d03WorkPeriodData.DAY.equals("6")&& Integer.parseInt(HOLI_CONT)>=6 && d03WorkPeriodData.CHK_0340.equals("")){
                    //@CSR1  유급휴일 토요일은 경조휴가일수   미산입(단, 6일 이상의 경조휴가에 한해토요일 산입)
                	//   CSR ID : C20140219  CHK_0340:"" :일반 ,값이있는경우 공휴일 ..
                	vacation_day++;
                 	Logger.debug.println(this, "HOLI_CONT:" + HOLI_CONT+"vacation_day:"+vacation_day);
                }
            }
            String date = DataUtil.getCurrentDate();
            int day9001 =0;
            if (Integer.parseInt(date) >= 20120802) { //20120802일 부터 자녀출산시 유급 휴가 1일 →3일
            	day9001=3;
            }else{
            	day9001=1;
            }
            if( d03VocationData.CONG_CODE.equals("9001") && count >day9001 ) {
                message = "경조휴가:자녀출산(유급)은  "+day9001+"일 이하로 신청 가능합니다.";
            } else if( d03VocationData.CONG_CODE.equals("9002") && count > 2 ) {
                message = "경조휴가:자녀출산(무급)은 2일 이하로 신청 가능합니다.";
            } else if( count > 6 ) {
                message = "경조휴가는 6일 이하로 신청 가능합니다.";
            } else if( count == 0 &&  DataUtil.getDay( DataUtil.removeStructur(d03WorkPeriodData.BEGDA,"-") ) != 7  ) {
                message = "신청기간에 근무일정이 존재하지 않습니다.";
            }
            if (!CONG_DATE.equals("") && count> Integer.parseInt(HOLI_CONT)){ //@@@
            	message = "경조발생일을 포함하여 신청해야 하며, 정해진 경조휴가일수를 초과할 수 없습니다.";

            }

            Logger.debug.println( this, "count: "+count+"HOLI_CONT:"+HOLI_CONT+"CONG_DATE:"+CONG_DATE);

        } else if( d03VocationData.AWART.equals("0140") ) { // 하계휴가..
            //                  2003.01.02. - 하계휴가 사용일수를 가져간다.
            D03VacationUsedRFC    rfcVacation           = new D03VacationUsedRFC();
            double                E_ABRTG               = Double.parseDouble( rfcVacation.getE_ABRTG(firstData.PERNR) );
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
            if( (count + E_ABRTG) > 5 ) {
                message = "하계휴가는 5일 이하로 신청 가능합니다. 현재 사용한 하계휴가 일수는 " + WebUtil.printNumFormat(E_ABRTG) + "일 입니다.";
            } else if( count == 0 ) {
                message = "신청기간에 근무일정이 존재하지 않습니다.";
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
                message = "신청기간에 근무일정이 존재하지 않습니다.";
            }

        } else if( d03VocationData.AWART.equals("0180") ) { // 시간공가..
            d03WorkPeriodData = (D03WorkPeriodData)d03WorkPeriodData_vt.get(0);

            // 근무시간 계산
            beg_time  = Long.parseLong(d03WorkPeriodData.BEGUZ);
            end_time  = Long.parseLong(d03WorkPeriodData.ENDUZ);

            work_time = end_time - beg_time;
            if( work_time < 40000 ) {
                message = "신청기간에 근무일정이 존재하지 않습니다.";
            }

            // 휴무일수 계산
            if( work_time >= 40000 ) {
                vacation_day++;
            }

            //              2002.07.08. 보건휴가 로직 추가
        } else if( d03VocationData.AWART.equals("0150") ) { // 보건휴가..
            //                  결근한도에 보건휴가 쿼터가 존재할때만 신청가능하도록 체크한다.
            D03MinusRestRFC func_0150 = new D03MinusRestRFC();
            String          e_anzhl   = func_0150.getE_ANZHL(firstData.PERNR, dateFrom);
            double          d_anzhl   = Double.parseDouble(e_anzhl);

            if( d_anzhl > 0.0 ) {
                d03WorkPeriodData = (D03WorkPeriodData)d03WorkPeriodData_vt.get(0);

                // 근무시간 계산
                beg_time  = Long.parseLong(d03WorkPeriodData.BEGUZ);
                end_time  = Long.parseLong(d03WorkPeriodData.ENDUZ);

                work_time = end_time - beg_time;
                if( work_time < 40000 ) {
                    message = "신청기간에 근무일정이 존재하지 않습니다.";
                }

                // 휴무일수 계산
                if( work_time >= 40000 ) {
                    vacation_day++;
                }
            } else {
                message = "잔여(보건) 휴가가 없습니다.";
            }

            //              2002.08.17. LG석유화학 휴일비근무 신청 추가
        } else if( d03VocationData.AWART.equals("0340") ) {        // 휴일비근무..
            String chk_0340 = "";
            for( int i = 0 ; i < d03WorkPeriodData_vt.size() ; i++ ) {
                d03WorkPeriodData = (D03WorkPeriodData)d03WorkPeriodData_vt.get(i);

                //                      휴일이면서 근무일정이 있을때만 휴일비근무 신청 가능하다. CHK_0340 = 'Y'인 경우
                chk_0340 = d03WorkPeriodData.CHK_0340;

                if( !chk_0340.equals("Y") ) {
                    message = "휴일비근무는 근무일정이 있는 휴일에만 신청가능합니다.";
                } else {
                    vacation_day++;
                }
            }

            //              2002.09.03. LG석유화학 근무면제 신청 추가
        } else if( d03VocationData.AWART.equals("0360") ) {        // 근무면제..
            d03WorkPeriodData = (D03WorkPeriodData)d03WorkPeriodData_vt.get(0);

            // 근무시간 계산
            beg_time  = Long.parseLong(d03WorkPeriodData.BEGUZ);
            end_time  = Long.parseLong(d03WorkPeriodData.ENDUZ);

            work_time = end_time - beg_time;
            if( work_time < 40000 ) {
                message = "신청기간에 근무일정이 존재하지 않습니다.";
            }

            // 휴무일수 계산
            if( work_time >= 40000 ) {
                vacation_day++;
            }
        }

        Logger.debug.println(this, "저장으로");
        Logger.debug.println( this, d03WorkPeriodData_vt.toString() );

        req.setAttribute("d03WorkPeriodData_vt", d03WorkPeriodData_vt);
        req.setAttribute("d03RemainVocationData",  d03RemainVocationData);
        req.setAttribute("CONG_DATE", CONG_DATE); //@@@
        req.setAttribute("HOLI_CONT", HOLI_CONT);  //@@@
        // 계산한 휴무일수(조회화면에 보여주기위한 일수를 저장한다 - 일단위)를 저장한다.
        d03VocationData.PBEZ4 = Double.toString(vacation_day);

//      [CSR ID:2595636] 동일일에 휴가&대근 차단 요청 건
        D16OTHDDupCheckRFC2 checkFunc = new D16OTHDDupCheckRFC2();
        Vector OTHDDupCheckData_new_vt = checkFunc.getChecResult( firstData.PERNR, UPMU_TYPE, dateFrom, dateTo);
        String e_flag = OTHDDupCheckData_new_vt.get(0).toString();
        String e_message = OTHDDupCheckData_new_vt.get(1).toString();

        if( e_flag.equals("Y")){//Y면 중복, N은 OK
        	message = e_message;
        }

	    } catch(Exception e) {
	        throw new GeneralException(e);

	    } finally {
	    }
        return message;
    }
}
