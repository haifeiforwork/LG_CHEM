/********************************************************************************/
/*                                                                              */
/*   System Name  :  e-HR                                                       */
/*   1Depth Name  : HR 결재함                                                   */
/*   2Depth Name  : 결재 해야할 문서                                            */
/*   Program Name : 초과 근무 신청                                              */
/*   Program ID   : G028ApprovalOTSV                                            */
/*   Description  : 초과 근무 신청부서장  결재/반려                             */
/*   Note         : 없음                                                        */
/*   Creation     : 2005-03-14  이승희                                                                */
/*   Update       : 2006-01-18  @v1.1 전자결재연동실패로 인해 메일발송과 위치변경                     */
/*                  2017-04-03  김은하  [CSR ID:3340999]  대만 당월근태기간동안 46시간 제한           */
/*                  2017-04-17  김은하  [CSR ID:3303691] 결재기간제어 로직추가                        */
/*					2018-02-12  rdcamel [CSR ID:3608185] e-HR 초과근무 사후신청 관련 시스템 개선 요청 */
/*                  2017-04-17  [WorkTime52] I_NTM 변수 추가                                          */
/********************************************************************************/
package servlet.hris.G;

import com.common.constant.Area;
import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;
import hris.D.D01OT.D01OTData;
import hris.D.D01OT.rfc.D01OTCheckGlobalRFC;
import hris.D.D01OT.rfc.D01OTRFC;
import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalHeader;
import hris.common.approval.ApprovalLineData;
import servlet.hris.D.D01OT.D01OTBuildGlobalSV;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.Vector;


public class G028ApprovalOTSV extends ApprovalBaseServlet
{
    private String UPMU_TYPE ="17";
    private String UPMU_NAME = "초과근무신청";
    private String OT_AFTER = "";//[CSR ID:3608185]사후 문구 추가

    protected String getUPMU_TYPE() {
        if(g.getSapType().isLocal())  return "17";
        else return  "01";   }

    protected String getUPMU_NAME() {
        if(g.getSapType().isLocal())  return "초과근무"+OT_AFTER+"신청";
        else return  "OverTime";
    }

    protected void performTask(final HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        try{
            HttpSession session = req.getSession(false);
            final WebUserData user = WebUtil.getSessionUser(req);

            /* 해외 업무 타입*/
/*           if(user.area != Area.KR) {
               UPMU_NAME = "OverTime";
           } else {
               UPMU_NAME = "초과근무신청";
           }
           getUPMU_NAME();//[CSR ID:3608185]
*/
            D01OTData   d01OTData;

            String dest  = "";
            String jobid = "";
            String bankflag  = "01";

            final Box box = WebUtil.getBox(req);

            String  AINF_SEQN  = box.get("AINF_SEQN");

            // 처리 후 돌아 갈 페이지
            String RequestPageName = box.get("RequestPageName");

            req.setAttribute("RequestPageName", RequestPageName);

            jobid =box.get("jobid", "search");

            final D01OTRFC rfc           = new D01OTRFC();
            rfc.setDetailInput(user.empNo, "1", AINF_SEQN);
            final D01OTBuildGlobalSV d01sv = new D01OTBuildGlobalSV();
            final Vector vcD01OTData = rfc.getDetail( AINF_SEQN, "");
            d01OTData      = (D01OTData)vcD01OTData.get(0);
            d01OTData = d01sv.doWithData(d01OTData);
            Logger.debug.println(this, "------------");
            Logger.debug.println(this, vcD01OTData);

//            String tableName = "T_ZHRA024T";

            /* 해외 업무 타입
             *	tableName은 null로 처리하면 SAP에서 알아서 처리함.(적정한 table을 찾아서 처리)
             */
/*           if(user.area != Area.KR) {
               UPMU_TYPE = "01"; // 결재 업무타입
               UPMU_NAME = "Overtime";
//               tableName = "T_ZHR0045T";

           } else {
               UPMU_TYPE = "17";
               UPMU_NAME = "초과근무신청";
//               tableName = "T_ZHRA022T";
//               tableName = "T_ZHR0045T";
           }
*/           
            /* 승인 시 */
            if("A".equals(jobid)) {
                /* 개발자 영역 끝 */
                dest = accept(req, box, null, d01OTData, rfc, new ApprovalFunction<D01OTData>() {
                    public boolean porcess(D01OTData inputData, ApprovalHeader approvalHeader, Vector<ApprovalLineData> approvalLineDatas)
                    		throws GeneralException {

                        /* 개발자 영역 시작 */
                        box.copyToEntity(inputData);  // 사용자가 입력한 데이타로 업데이트
                        inputData = d01sv.doWithData(inputData); // time formatting (ksc)2016/12/21
                        inputData.UNAME = user.empNo;
                        inputData.AEDTM = DataUtil.getCurrentDate();
                        inputData.I_NTM = "X"; // [WorkTime52]
                        D01OTCheckGlobalRFC d01OTCheckGlobalRFC = new D01OTCheckGlobalRFC();

                        // [CSR ID:3608185] e-HR 초과근무 사후신청 관련 시스템 개선 요청
                        OTAfterCheck(inputData);
                        Logger.debug.println(this, getUPMU_NAME());
                        // [CSR ID:3608185] e-HR 초과근무 사후신청 관련 시스템 개선 요청

                        // 2017-04-03 김은하 [CSR ID:3340999] 대만 당월근태기간동안 46시간 제한 START
                        if (!g.getSapType().isLocal()) {
                            d01OTCheckGlobalRFC.checkOvertimeTp46Hours(req, inputData.PERNR, "A", inputData.AINF_SEQN, inputData.WORK_DATE, inputData.STDAZ);
                            if ("E".equals(d01OTCheckGlobalRFC.getReturn().MSGTY)) {
                                throw new GeneralException(g.getMessage("MSG.D.D01.0109"));// The Approved overtime hours of this payroll period are over 46 hours.
                            }
                            // [CSR ID:3359686] 남경 결재 5일제어 START
                            d01OTCheckGlobalRFC.checkApprovalPeriod(req, inputData.PERNR, "A", inputData.WORK_DATE, UPMU_TYPE, "");
                            if ("E".equals(d01OTCheckGlobalRFC.getReturn().MSGTY)) {
                                throw new GeneralException(g.getMessage("MSG.D.D01.0108")); // The request date has passed 5 working days. You could not approve it.
                            }
                            // [CSR ID:3359686] 남경 결재 5일제어 END

                        }
                        // 2017-04-03 김은하 [CSR ID:3340999] 대만 당월근태기간동안 46시간 제한 END

                        return true;
                    }
                });

            /* 반려시 */
            } else if("R".equals(jobid)) {
                dest = reject(req, box, null, vcD01OTData, rfc, null);
            } else if("C".equals(jobid)) {
                dest = cancel(req, box, null, vcD01OTData, rfc, null);
/*

            if( jobid.equals("search") ) {

                D01OTRFC rfc           = new D01OTRFC();

                vcD01OTData = rfc.getDetail( AINF_SEQN, "");
                Logger.debug.println(this, vcD01OTData);

                if( vcD01OTData.size() < 1 ){
                    String msg = "System Error! \n\n 조회할 항목이 없습니다.";
                    req.setAttribute("msg", msg);
                    dest = WebUtil.JspURL+"common/caution.jsp";
                }else{
                    // OT(초과 근무)
                    d01OTData      = (D01OTData)vcD01OTData.get(0);
                    // 결재자 정보
                    vcAppLineData = AppUtil.getAppChangeVt(AINF_SEQN);

                    PersInfoWithNoRFC   piRfc   = new PersInfoWithNoRFC();
                    PersInfoData        pid     = (PersInfoData) piRfc.getApproval(d01OTData.PERNR).get(0);
                    req.setAttribute("PersInfoData" ,pid );

                    req.setAttribute("d01OTData", d01OTData);
                    req.setAttribute("vcAppLineData" , vcAppLineData);

                    dest = WebUtil.JspURL+"G/G028ApprovalOT.jsp";
                } // end if
            } else if( jobid.equals("save") ) {

                d01OTData = new D01OTData();
                vcD01OTData = new Vector();

                vcAppLineData       = new Vector();

                AppLineData         tempAppLine;

                Vector vcTempAppLineData   = new Vector();
                AppLineData    appLine     = new AppLineData();

                // OT(초과근무) 기초 자료
                box.copyToEntity(d01OTData);

                // 결재자 정보
                int nRowCount = Integer.parseInt(box.getString("RowCount"));

                String APPU_TYPE   =  box.get("APPU_TYPE");
                String APPR_SEQN   =  box.get("APPR_SEQN");
                String currApprNumb = "";  //ESB 오류 수정

                for (int i = 0; i < nRowCount; i++) {
                    tempAppLine = new AppLineData();
                    box.copyToEntity(tempAppLine ,i);
                    vcTempAppLineData.add(tempAppLine);
                    if (tempAppLine.APPL_APPR_STAT.equals("미결") && currApprNumb.equals("")){
                    	currApprNumb = tempAppLine.APPL_APPU_NUMB;
                    }
                    if (tempAppLine.APPL_APPU_TYPE.equals(APPU_TYPE) && tempAppLine.APPL_APPR_SEQN.equals(APPR_SEQN)) {
                        appLine.APPL_BUKRS = box.getString("BUKRS");
                        appLine.APPL_PERNR = box.getString("PERNR");
                        appLine.APPL_BEGDA = box.getString("BEGDA");
                        appLine.APPL_AINF_SEQN = box.getString("AINF_SEQN");
                        appLine.APPL_APPU_TYPE = APPU_TYPE;
                        appLine.APPL_APPR_SEQN = APPR_SEQN;
                        appLine.APPL_APPU_NUMB = user.empNo;
                        appLine.APPL_APPR_STAT = box.getString("APPR_STAT");
                        appLine.APPL_BIGO_TEXT = box.getString("BIGO_TEXT");
                        appLine.APPL_APPR_DATE = DataUtil.getCurrentDate();
                    } // end if
                } // end for

                Logger.debug.println(this ,vcTempAppLineData);
                Logger.debug.println(this ,appLine);
                vcAppLineData.add(appLine);


                G001ApprovalProcessRFC  Apr = new G001ApprovalProcessRFC();
                Vector vcRet = Apr.setApprovalStatutsList(vcAppLineData );

                Logger.debug.println(this ,vcRet);
                ApprovalReturnState ars = (ApprovalReturnState) vcRet.get(0);

                PersonInfoRFC numfunc = new PersonInfoRFC();
                PersonData phonenumdata;
                phonenumdata    =   (PersonData)numfunc.getPersonInfo(d01OTData.PERNR);

                Properties ptMailBody = new Properties();
                ptMailBody.setProperty("SServer",user.SServer);                 // ElOffice 접속 서버
                ptMailBody.setProperty("from_empNo" ,user.empNo);               // 멜 발송자 사번

                ptMailBody.setProperty("ename" ,phonenumdata.E_ENAME);          // (피)신청자명
                ptMailBody.setProperty("empno" ,phonenumdata.E_PERNR);          // (피)신청자 사번

                ptMailBody.setProperty("UPMU_NAME" ,"초과 근무");               // 문서 이름
                ptMailBody.setProperty("AINF_SEQN" ,AINF_SEQN);                 // 신청서 순번

                // 멜 제목
                StringBuffer sbSubject = new StringBuffer(512);

                sbSubject.append("[" + ptMailBody.getProperty("UPMU_NAME") + "] ");
                sbSubject.append(user.ename  + "님이 ");

                String msg;
                String msg2 = "";
                String to_empNo = d01OTData.PERNR;

                if (ars.E_RETURN.equals("S")) {
                    if (appLine.APPL_APPR_STAT.equals("A")) {
                        msg = "msg009";
                        for (int i = 0; i < vcTempAppLineData.size(); i++) {
                            tempAppLine = (AppLineData) vcTempAppLineData.get(i);
                            if (tempAppLine.APPL_APPU_TYPE.equals(APPU_TYPE) && tempAppLine.APPL_APPR_SEQN.equals(APPR_SEQN)) {
                                if (i == vcTempAppLineData.size() -1) {
                                    // 마직막 결재자
                                    ptMailBody.setProperty("FileName" ,"MbNoticeMailApp.html");
                                    sbSubject.append(ptMailBody.getProperty("UPMU_NAME") +"를 승인 하셨습니다.");
                                } else {
                                    ptMailBody.setProperty("FileName" ,"MbNoticeMailBuild.html");
                                    // 이후 결재자
                                    tempAppLine = (AppLineData) vcTempAppLineData.get(i+1);
                                    to_empNo = tempAppLine.APPL_APPU_NUMB;
                                    sbSubject.append("결재를 요청 하셨습니다.");
                                    break;
                                } // end if
                            }// end if
                        } // end for
                    } else {
                        msg = "msg010";
                        if (APPU_TYPE.equals("02") && Integer.parseInt(APPR_SEQN) > 1) {
                            for (int i = 0; i < vcTempAppLineData.size(); i++) {
                                tempAppLine = (AppLineData) vcTempAppLineData.get(i);
                                if (tempAppLine.APPL_APPU_TYPE.equals("02") && tempAppLine.APPL_APPR_SEQN.equals("01")) {
                                    tempAppLine = (AppLineData) vcTempAppLineData.get(i);
                                    to_empNo = tempAppLine.APPL_APPU_NUMB;
                                } // end if
                            } // end for
                        } // end if
                        ptMailBody.setProperty("FileName" ,"MbNoticeMailRej.html");
                        sbSubject.append(ptMailBody.getProperty("UPMU_NAME") +"를 반려 하셨습니다.");
                    } // end if

                    ptMailBody.setProperty("to_empNo" ,to_empNo);                   // 멜 수신자 사번
                    ptMailBody.setProperty("subject" ,sbSubject.toString());        // 멜 제목 설정
                    MailSendToEloffic   maTe = new MailSendToEloffic(ptMailBody);

                    try {
                        DraftDocForEloffice ddfe = new DraftDocForEloffice();
                        ElofficInterfaceData eof;
                        Vector vcElofficInterfaceData = new Vector();
                       	//ESB 오류 수정
                    	if (!currApprNumb.equals(user.empNo)) {
                        	//결재올려진 결재자 외의 테스크를 가지고 있는 결재자가 결재할때 처리:현재 전자결재에 들어가있는 DATA를 삭제후 다시 처리
                        	ElofficInterfaceData eofD = ddfe.makeDocForDelete(AINF_SEQN ,user.SServer , phonenumdata.E_PERNR, ptMailBody.getProperty("UPMU_NAME") , currApprNumb);
                            vcElofficInterfaceData.add(eofD);
                           	ElofficInterfaceData eofI = ddfe.makeDocForInsert(AINF_SEQN ,user.SServer , phonenumdata.E_PERNR,  ptMailBody.getProperty("UPMU_NAME")  );
                            vcElofficInterfaceData.add(eofI);
                	    }
                        if (appLine.APPL_APPR_STAT.equals("A")) {
                            eof = ddfe.makeDocContents(AINF_SEQN ,user.SServer,ptMailBody.getProperty("UPMU_NAME"));
                        } else {
                            if (APPU_TYPE.equals("02") && Integer.parseInt(APPR_SEQN) > 1) {
                                eof = ddfe.makeDocForMangerReject(AINF_SEQN ,user.SServer,ptMailBody.getProperty("UPMU_NAME") ,vcTempAppLineData);
                            } else {
                                int nRejectLength = 0;
                                for (int i = vcTempAppLineData.size() - 1; i >= 0; i--) {
                                    tempAppLine = (AppLineData) vcTempAppLineData.get(i);
                                    if (tempAppLine.APPL_APPU_TYPE.equals(APPU_TYPE) && tempAppLine.APPL_APPR_SEQN.equals(APPR_SEQN)) {
                                        nRejectLength = i + 1;
                                        break;
                                    } // end if
                                } // end for

                                String approvers[] = new String[nRejectLength];
                                for (int i = 0; i < approvers.length; i++) {
                                    tempAppLine = (AppLineData) vcTempAppLineData.get(i);
                                    approvers[i]    =   tempAppLine.APPL_APPU_NUMB;
                                } // end for
                                if (!currApprNumb.equals(user.empNo)) {
                                    approvers[approvers.length-1] =user.empNo; //ESB 오류 수정
                                }
                                eof = ddfe.makeDocForReject(AINF_SEQN ,user.SServer,ptMailBody.getProperty("UPMU_NAME") ,d01OTData.PERNR ,approvers);
                            } // end if
                        } // end if

                        vcElofficInterfaceData.add(eof);
                        Logger.info.println(this ,"^^^^^ G028ApprovalOTSV</b>[eof:]"+eof.toString());
                        //req.setAttribute("vcElofficInterfaceData", vcElofficInterfaceData);
                        //dest = WebUtil.JspURL+"common/ElOfficeInterface.jsp";

                        //통합결재 잦은오류로 인해 서버실행으로 변경함  2012.11.07
                        try {

                        	SendToESB esb = new SendToESB();
                        	String esbmsg = esb.process(vcElofficInterfaceData );
                            Logger.debug.println(this ,"[esbmsg]  :"+esbmsg);
                        	req.setAttribute("message", esbmsg);
                        	dest = WebUtil.JspURL+"common/EsbResult.jsp";
    	                } catch (Exception e) {
                           dest = WebUtil.JspURL+"common/msg.jsp";
                           msg2 += "\\n" + "esb.process Eloffice 연동 실패" ;
                       }

                    } catch (Exception e) {
                        dest = WebUtil.JspURL+"common/msg.jsp";
                        msg2 = msg2 +  " Eloffic 연동 실패 " ;
                    } // end try
                    //@v1.1
                    if (!maTe.process()) {
                        msg2 = maTe.getMessage() + "\\n";
                    } // end if

                } else {
                    msg = ars.E_MESSAGE;
                    dest = WebUtil.JspURL+"common/msg.jsp";
                } // end if

                String url = "location.href = \"" + RequestPageName.replace('|','&') + "\";";

                req.setAttribute("msg", msg);
                req.setAttribute("msg2", msg2);
                req.setAttribute("url", url);
*/
            } else {
                throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
            } // end if

            Logger.debug.println(this, " destributed = " + dest);
            printJspPage(req, res, dest);

        } catch(Exception e) {
            Logger.err.println(DataUtil.getStackTrace(e));
            throw new GeneralException(e);
        }
    }
    
  //[CSR ID:3608185] e-HR 초과근무 사후신청 관련 시스템 개선 요청	
    protected void OTAfterCheck(D01OTData data){
    	int dayCount = DataUtil.getBetween(data.BEGDA, data.WORK_DATE);
        if (dayCount < 0)
        	OT_AFTER = "사후";
        else		
        	OT_AFTER = "";
    }
}