package servlet.hris.D.D01OT;

import java.util.Properties;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.jdom.Document;
import org.jdom.Element;

import com.common.Utils;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.mobile.EncryptionTool;
import com.sns.jdf.mobile.MobileCodeErrVO;
import com.sns.jdf.mobile.XmlUtil;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;

import hris.D.D01OT.D01OTData;
import hris.D.D01OT.rfc.D01OTAFRFC;
import hris.common.DraftDocForEloffice;
import hris.common.ElofficInterfaceData;
import hris.common.MailSendToEloffic;
import hris.common.MobileReturnData;
import hris.common.PersonData;
import hris.common.WebUserData;
import hris.common.approval.ApprovalHeader;
import hris.common.approval.ApprovalLineData;
import hris.common.rfc.PersonInfoRFC;
import servlet.hris.MobileAutoLoginSV;
import servlet.hris.MobileCommonSV;

public class D01OTAfterWorkMbDeleteSV extends MobileAutoLoginSV {

    private String UPMU_TYPE ="44";            // 결재 업무타입(초과근무 사후신청)

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
       // Connection con = null;

        try{

            Logger.debug.println("D01OTAfterWorkMbDeleteSV start++++++++++++++++++++++++++++++++++++++" );

        	//로그인처리
        	MobileCommonSV mc = new MobileCommonSV() ;
        	mc.autoLogin(req,res);

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

            // 3.return URL을 호출한다.
            dest = WebUtil.JspURL+"common/mobileResult.jsp";
            Logger.debug.println(this, " destributed = " + dest);
            printJspPage(req, res,dest );

        } catch(Exception e) {
            throw new GeneralException(e);
        } finally {

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
        String errorCode = "";
        String errorMsg = "";

       //통합결재연동 결과값
    	MobileReturnData retunMsgEL = new MobileReturnData();

        try{
            HttpSession session = req.getSession(false);
            WebUserData user    = (WebUserData)session.getAttribute("user");

            Box box = WebUtil.getBox(req);

            String   AINF_SEQN = box.get("apprDocID");
            String   empNo     = box.get("empNo"); //사번
            empNo = EncryptionTool.decrypt(empNo);
            empNo = DataUtil.fixEndZero( empNo ,8);

            // 1.Envelop XML을 생성한다.
            envelope =  XmlUtil.createEnvelope();

            // 2.Body XML을 생성한다.
            Element body =  XmlUtil.createBody();

            // 3.WAT_RESPONSE 를 생성한다.
            Element waitResponse =  XmlUtil.createWaitResponse();

            // 4.결과값을 생성한다.
            Element items = XmlUtil.createItems(itemsName);

            D01OTAFRFC rfc = new D01OTAFRFC();
            D01OTData tempData = new D01OTData();
            Vector D01OTData_vt  = null;
            Logger.debug.println(this, "초과근무 사후신청 조회 :user.empNo====> " + user.empNo);
            Logger.debug.println(this, "초과근무 사후신청 조회 :AINF_SEQN====> " + AINF_SEQN);
            //초과근무신청 조회
            String I_APGUB = "2";   //(String) req.getAttribute("I_APGUB");  //어느 페이지에서 왔나? '1' : 결재할 문서 , '2' : 결재중 문서 , '3' : 결재완료 문서

            rfc.setDetailInput(user.empNo, I_APGUB, AINF_SEQN);
            D01OTData_vt = rfc.getDetail( AINF_SEQN, user.empNo );
            if (D01OTData_vt.size() < 1){
            	 errorCode = MobileCodeErrVO.ERROR_CODE_700;
                 errorMsg  = "삭제할 정보가 존재하지 않습니다." ;
                 xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
                 return xmlString;
            }
            Logger.debug.println(this, "초과근무 사후신청 조회 mobile 삭제 : " + D01OTData_vt.toString());

            //문서상태 조회 후 삭제여부 Check
            /*DocumentInfo docinfo = new DocumentInfo(AINF_SEQN ,user.empNo);*/
            if(!"X".equals(rfc.getApprovalHeader().MODFL)) {
            /*if (!docinfo.isModefy()) {*/
            	errorCode = MobileCodeErrVO.ERROR_CODE_700;
                errorMsg  = "수정 및 삭제 불가한 문서입니다." ;
                xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
                return xmlString;
            }

            // 대리 신청 추가
            tempData           = (D01OTData)D01OTData_vt.get(0);
            PersonInfoRFC numfunc         = new PersonInfoRFC();
            PersonData phonenumdata    = null;
            phonenumdata  = (PersonData)numfunc.getPersonInfo(tempData.PERNR);

            /////////////////////////////////////////////////////////////////////////////.
            rfc     = new D01OTAFRFC();
            /*하위 로직 변경됨 */
            rfc.setDetailInput(user.empNo, I_APGUB, AINF_SEQN);
            Vector<D01OTData> resultList = rfc.getDetail(AINF_SEQN, user.empNo);
            D01OTData resultData = Utils.indexOf(resultList, 0);
            Vector<ApprovalLineData> approvalLineList = rfc.getApprovalLine();
            ApprovalHeader approvalHeader = rfc.getApprovalHeader();

            //삭제 가능시
            if("X".equals(approvalHeader.MODFL)) {
            	D01OTAFRFC deleteRfc = new D01OTAFRFC();
                deleteRfc.setDeleteInput(user.empNo, UPMU_TYPE, AINF_SEQN);
                deleteRfc.delete( AINF_SEQN, user.empNo );

                /* 삭제 성공시 */
                if(deleteRfc.getReturn().isSuccess()) {
//결재자 변경시 멜 보내기 ,ElOffice 인터 페이스
                    phonenumdata    =   (PersonData)numfunc.getPersonInfo(tempData.PERNR);
                    Properties ptMailBody = new Properties();

                    ApprovalLineData firstApprovalLine = Utils.indexOf(approvalLineList, 0);

                    ptMailBody.setProperty("SServer",user.SServer);                 // ElOffice 접속 서버
                    ptMailBody.setProperty("from_empNo" ,user.empNo);               // 멜 발송자 사번
                    ptMailBody.setProperty("to_empNo" ,firstApprovalLine.APPU_NUMB);     // 멜 수신자 사번
                    ptMailBody.setProperty("ename" ,phonenumdata.E_ENAME);          // (피)신청자명
                    ptMailBody.setProperty("empno" ,phonenumdata.E_PERNR);          // (피)신청자 사번
                    ptMailBody.setProperty("UPMU_NAME" ,"초과근무 사후신청");                    // 문서 이름
                    ptMailBody.setProperty("AINF_SEQN" ,AINF_SEQN);                 // 신청서 순번

                    //멜 제목
                    StringBuffer sbSubject = new StringBuffer(512);

                    // [CSR ID:3420113] 인사시스템 신청 및 결재 메일 UI 표준작업  2017-06-29 eunha start
                    //sbSubject.append("[" + ptMailBody.getProperty("UPMU_NAME") + "] ");
                    //sbSubject.append( ptMailBody.getProperty("ename") + "님이 신청을 삭제하셨습니다.");
                      sbSubject.append("[HR] 결재삭제통보(" + ptMailBody.getProperty("UPMU_NAME") + ") ");
                    // [CSR ID:3420113] 인사시스템 신청 및 결재 메일 UI 표준작업  2017-06-29 eunha end


                    ptMailBody.setProperty("subject" ,sbSubject.toString());    // 멜 제목 설정

                    ptMailBody.setProperty("FileName" ,"NoticeMail5.html");

                    MailSendToEloffic   maTe = new MailSendToEloffic(ptMailBody);

                    String msg2 = null;
                    if (!maTe.process()) {
                        msg2 = maTe.getMessage();
                    } // end if

                    try {
                        DraftDocForEloffice ddfe = new DraftDocForEloffice();
                        ElofficInterfaceData eof = ddfe.makeDocForRemove(AINF_SEQN ,user.SServer ,ptMailBody.getProperty("UPMU_NAME")
                                ,tempData.PERNR ,firstApprovalLine.APPU_NUMB);

                        Vector vcElofficInterfaceData = new Vector();
                        vcElofficInterfaceData.add(eof);

                        //통합결재 연동
                        MobileCommonSV mc = new MobileCommonSV() ;
                        retunMsgEL = mc.ElofficInterface( vcElofficInterfaceData, user);
                        //통합결재 연동관련 오류 발생시 오류값 return
                        if (!retunMsgEL.CODE.equals("0")){
                            errorCode = MobileCodeErrVO.ERROR_CODE_400+""+retunMsgEL.CODE;
                            errorMsg  = retunMsgEL.VALUE ;
                            xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
                            return xmlString;
                        }

                    } catch (Exception e) {
                        msg2 = msg2 + "\\n" + " Eloffic 연동 실패" ;
                        /*errorCode = MobileCodeErrVO.ERROR_CODE_400;*/
                        errorMsg  = MobileCodeErrVO.ERROR_MSG_400+  msg2;
                        xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
                        return xmlString;
                    } // end try
                } else {
                    errorCode = MobileCodeErrVO.ERROR_CODE_700;
                    errorMsg  = MobileCodeErrVO.ERROR_MSG_700+ "삭제에 실패 하였습니다.";
                    xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
                    return xmlString;
                }
            } else {
                errorCode = MobileCodeErrVO.ERROR_CODE_700;
                errorMsg  = MobileCodeErrVO.ERROR_MSG_700+ "이미 승인되어 삭제 불가 합니다.";
                xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
                return xmlString;
            }


/*





            Vector  AppLineData_vt  = new Vector();
            Vector  AppLineData_vt1 = new Vector();
            AppLineData_vt1 = AppUtil.getAppDetailVt(AINF_SEQN);

            // 결재정보 삭제..
            AppLineData  appLine = new AppLineData();
            appLine.APPL_MANDT     = user.clientNo;
            appLine.APPL_BUKRS     = user.companyCode;
            appLine.APPL_PERNR     = tempData.PERNR;
            appLine.APPL_UPMU_TYPE = UPMU_TYPE;
            appLine.APPL_AINF_SEQN = AINF_SEQN;

// 2002.07.25.---------------------------------------------------------------------------
//          신청건 삭제시 메일 보내기 위해 필요한 결재자 정보를 가져온다.
//          결재
            int nRowCount = AppLineData_vt1.size();
	        Logger.debug.println( this, "######### nRowCount : "+nRowCount );

            for( int i = 0; i < nRowCount; i++) {
                AppLineData app = new AppLineData();
                app = (AppLineData)AppLineData_vt1.get(i);
                app.APPL_APPU_NUMB = app.APPL_PERNR;

                AppLineData_vt.addElement(app);
            }
    //        Logger.debug.println(this, "AppLineData_vt : " + AppLineData_vt.toString());
//              신청건 삭제시 메일 보내기 위해 필요한 결재자 정보를 가져온다.
// 2002.07.25.---------------------------------------------------------------------------

            //초과근무정보 삭제처
            con             = DBUtil.getTransaction();
            AppLineDB appDB = new AppLineDB(con);
            if( appDB.canUpdate(appLine) ) {

              //  Logger.debug.println(this, "appDB.delete : user.empNo " +   user.empNo+"AINF_SEQN:"+AINF_SEQN);
                appDB.delete(appLine);
             //   Logger.debug.println(this," rfc.delete  " +   user.empNo+"AINF_SEQN:"+AINF_SEQN);
             //[CSR ID:2529608]
                rfc.setDeleteInput(user.empNo, UPMU_TYPE, AINF_SEQN);
                rfc.delete( AINF_SEQN, user.empNo );
                con.commit();

                /*//**********수정 시작 (20050223:유용원)**********
                // 신청건 삭제시 메일 보내기.
                appLine = (AppLineData)AppLineData_vt.get(0);

                //결재자 변경시 멜 보내기 ,ElOffice 인터 페이스
                phonenumdata    =   (PersonData)numfunc.getPersonInfo(tempData.PERNR);
                Properties ptMailBody = new Properties();

                ptMailBody.setProperty("SServer",user.SServer);                 // ElOffice 접속 서버
                ptMailBody.setProperty("from_empNo" ,user.empNo);               // 멜 발송자 사번
                ptMailBody.setProperty("to_empNo" ,appLine.APPL_APPU_NUMB);     // 멜 수신자 사번
                ptMailBody.setProperty("ename" ,phonenumdata.E_ENAME);          // (피)신청자명
                ptMailBody.setProperty("empno" ,phonenumdata.E_PERNR);          // (피)신청자 사번
                ptMailBody.setProperty("UPMU_NAME" ,"초과근무");                    // 문서 이름
                ptMailBody.setProperty("AINF_SEQN" ,AINF_SEQN);                 // 신청서 순번

                //멜 제목
                StringBuffer sbSubject = new StringBuffer(512);

                sbSubject.append("[" + ptMailBody.getProperty("UPMU_NAME") + "] ");
                sbSubject.append( ptMailBody.getProperty("ename") + "님이 신청을 삭제하셨습니다.");
                ptMailBody.setProperty("subject" ,sbSubject.toString());    // 멜 제목 설정

                ptMailBody.setProperty("FileName" ,"NoticeMail5.html");

                MailSendToEloffic   maTe = new MailSendToEloffic(ptMailBody);

                String msg2 = null;
                if (!maTe.process()) {
                    msg2 = maTe.getMessage();
                } // end if

                try {
                    DraftDocForEloffice ddfe = new DraftDocForEloffice();
                    ElofficInterfaceData eof = ddfe.makeDocForRemove(AINF_SEQN ,user.SServer ,ptMailBody.getProperty("UPMU_NAME")
                            ,tempData.PERNR ,appLine.APPL_APPU_NUMB);

                    Vector vcElofficInterfaceData = new Vector();
                    vcElofficInterfaceData.add(eof);

                    //통합결재 연동
                	MobileCommonSV mc = new MobileCommonSV() ;
                    retunMsgEL = mc.ElofficInterface( vcElofficInterfaceData, user);
                    //통합결재 연동관련 오류 발생시 오류값 return
                    if (!retunMsgEL.CODE.equals("0")){
    	  	            errorCode = MobileCodeErrVO.ERROR_CODE_400+""+retunMsgEL.CODE;
                        errorMsg  = retunMsgEL.VALUE ;
                        xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
                        return xmlString;
                    }

                } catch (Exception e) {
                	msg2 = msg2 + "\\n" + " Eloffic 연동 실패" ;
                    errorCode = MobileCodeErrVO.ERROR_CODE_400;
                    errorMsg  = MobileCodeErrVO.ERROR_MSG_400+  msg2;
                    xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
                    return xmlString;
                } // end try

            } else {
            	 errorCode = MobileCodeErrVO.ERROR_CODE_500;
                 errorMsg  = MobileCodeErrVO.ERROR_MSG_500+ "이미 승인되어 삭제 불가 합니다.";
                 xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
                 return xmlString;
            }*/

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