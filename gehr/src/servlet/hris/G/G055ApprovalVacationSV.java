/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : 결재해야할 문서                                             */
/*   2Depth Name  :                                                             */
/*   Program Name : 휴가 결재                                                   */
/*   Program ID   : G055ApprovalVacationSV.java                                 */
/*   Description  : 휴가 결재를 위한 서블릿                                     */
/*   Note         : 없음                                                        */
/*   Creation     : 2005-03-10 유용원                                           */
/*   Update       : 2006-01-18 @v1.1 전자결재연동실패로 인해 메일발송과 위치변경*/
/*                   : 2017-04-17 김은하 [CSR ID:3359686]   남경 결재 5일제어        */
/*                                                                              */
/********************************************************************************/

package servlet.hris.G;

import com.common.Utils;
import com.common.constant.Area;
import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;

import hris.D.D01OT.rfc.D01OTCheckGlobalRFC;
import hris.D.D03Vocation.D03VocationData;
import hris.D.D03Vocation.rfc.D03VocationRFC;
import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalHeader;
import hris.common.approval.ApprovalLineData;
import servlet.hris.D.D01OT.D01OTBuildGlobalSV;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.Vector;

public class G055ApprovalVacationSV extends ApprovalBaseServlet
{

    private String UPMU_TYPE = "18";
    private String UPMU_NAME = "휴가";


    protected String getUPMU_TYPE() {
        if(g.getSapType().isLocal())  return "18";
        else return  "02";
    }

    protected String getUPMU_NAME() {
        if(g.getSapType().isLocal())  return "휴가";
        else return  "Leave";
    }

    protected void performTask(final HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        try{
            HttpSession session = req.getSession(false);
            final WebUserData user = WebUtil.getSessionUser(req);

            String tableName = "T_ZHRA024T";
            /* 해외 업무 타입*/
           if(user.area != Area.KR) {
               UPMU_TYPE = "02"; // 결재 업무타입
               UPMU_NAME = "Leave";
               tableName = "T_ZHR0046T";
           } else {
               UPMU_TYPE = "18";
               UPMU_NAME = "휴가 신청";
               tableName = "T_ZHRA024T";
           }
            Vector          vcAppLineData      = null;
            Vector          d03VocationData_vt = null;

            String dest  = "";
            String jobid = "";

            final Box box = WebUtil.getBox(req);
            String  AINF_SEQN  = box.get("AINF_SEQN");

            // 처리 후 돌아 갈 페이지
            String RequestPageName = box.get("RequestPageName");
            req.setAttribute("RequestPageName", RequestPageName);

            jobid = box.get("jobid", "search");


            //휴가신청 조회
            final D03VocationRFC  rfc = new D03VocationRFC();
            rfc.setDetailInput(user.empNo, "1", AINF_SEQN);
            d03VocationData_vt = rfc.getVocation( user.empNo, AINF_SEQN );
            final D03VocationData d03VocationData = (D03VocationData) Utils.indexOf(d03VocationData_vt, 0); //결과 데이타

            /* 승인 시 */
            if("A".equals(jobid)) {
                /* 개발자 영역 끝 */
                dest = accept(req, box, null, d03VocationData, rfc, new ApprovalFunction<D03VocationData>() {
                    public boolean porcess(D03VocationData inputData, ApprovalHeader approvalHeader, Vector<ApprovalLineData> approvalLineDatas)
                    		throws GeneralException {

                        /* 개발자 영역 시작 */
                        // box.copyToEntity(inputData);  //사용자가 입력한 데이타로 업데이트

                        // time formatting (ksc)2016/12/21
                        final D01OTBuildGlobalSV d01sv = new D01OTBuildGlobalSV();
                        inputData.BEGUZ = d01sv.toTimeFormat(inputData.BEGUZ);
                        inputData.ENDUZ = d01sv.toTimeFormat(inputData.ENDUZ);

                        inputData.UNAME     = user.empNo;
                        inputData.AEDTM     = DataUtil.getCurrentDate();
                        
                        // [WorkTime52] 추가
                        inputData.I_NTM 	= "X";
                        
                        //[CSR ID:3359686]   남경 결재 5일제어 START
                        D01OTCheckGlobalRFC  d01OTCheckGlobalRFC           = new D01OTCheckGlobalRFC();
                        if(!g.getSapType().isLocal()){
                            d01OTCheckGlobalRFC.checkApprovalPeriod(req,inputData.PERNR,"A", inputData.APPL_FROM,   UPMU_TYPE, inputData.AWART );
                            if ("E".equals(d01OTCheckGlobalRFC.getReturn().MSGTY)) {
        						throw new GeneralException(g.getMessage("MSG.D.D01.0108")); //The request date has passed 5 working days. You could not approve it.
        					}
                        }
                      //[CSR ID:3359686]   남경 결재 5일제어 END
                        return true;
                    }
                });

            /* 반려시 */
            } else if("R".equals(jobid)) {
                dest = reject(req, box, null, d03VocationData_vt, rfc, null);
            } else if("C".equals(jobid)) {
                dest = cancel(req, box, null, d03VocationData_vt, rfc, null);
            } else {
                throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
            }
/*
            if( jobid.equals("search") ) {

                //휴가신청 조회
                final D03VocationRFC  rfc = new D03VocationRFC();
                d03VocationData_vt = rfc.getVocation( user.empNo, AINF_SEQN );
                Logger.debug.println(this, "휴가 조회 : " + d03VocationData_vt.toString());

                if( d03VocationData_vt.size() < 1 ){
                    String msg = "System Error! \n\n 조회할 항목이 없습니다.";
                    req.setAttribute("msg", msg);
                    dest = WebUtil.JspURL+"common/caution.jsp";
                }else{
                    //휴가
                    d03VocationData  = (D03VocationData)d03VocationData_vt.get(0);

                    // 잔여휴가일수, 장치교대근무조 체크
                    D03RemainVocationRFC  rfcRemain             = null;
                    D03RemainVocationData d03RemainVocationData = new D03RemainVocationData();

                    rfcRemain             = new D03RemainVocationRFC();
                    d03RemainVocationData = (D03RemainVocationData)rfcRemain.getRemainVocation(user.empNo, DataUtil.getCurrentDate());

                    // 결재자 정보
                    vcAppLineData = AppUtil.getAppChangeVt(AINF_SEQN);

                    // 결재 정보.
                    PersInfoWithNoRFC piRfc = new PersInfoWithNoRFC();
                    PersInfoData      pid   = (PersInfoData) piRfc.getApproval(d03VocationData.PERNR).get(0);

                    req.setAttribute("PersInfoData" ,pid );
                    req.setAttribute("vcAppLineData" , vcAppLineData);
                    req.setAttribute("d03VocationData_vt", d03VocationData_vt);
                    req.setAttribute("d03RemainVocationData",  d03RemainVocationData);

                    dest = WebUtil.JspURL+"G/G055ApprovalVacation.jsp";
                } // end if
            } else if( jobid.equals("save") ) {

                d03VocationData    = new D03VocationData();
                d03VocationData_vt = new Vector();
                vcAppLineData      = new Vector();
                AppLineData  tempAppLine;
                Vector       vcTempAppLineData = new Vector();
                AppLineData  appLine           = new AppLineData();

                // 휴가 기초 자료
                box.copyToEntity(d03VocationData);
                d03VocationData.UNAME = user.empNo;
                d03VocationData.AEDTM = DataUtil.getCurrentDate();

                // 결재자 정보
                int nRowCount = Integer.parseInt(box.getString("RowCount"));
                String APPU_TYPE = box.get("APPU_TYPE");
                String APPR_SEQN = box.get("APPR_SEQN");
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
                phonenumdata = (PersonData)numfunc.getPersonInfo(d03VocationData.PERNR);

                Properties ptMailBody = new Properties();
                ptMailBody.setProperty("SServer",user.SServer);          // ElOffice 접속 서버
                ptMailBody.setProperty("from_empNo" ,user.empNo);        // 멜 발송자 사번
                ptMailBody.setProperty("ename" ,phonenumdata.E_ENAME);   // (피)신청자명
                ptMailBody.setProperty("empno" ,phonenumdata.E_PERNR);   // (피)신청자 사번
                ptMailBody.setProperty("UPMU_NAME" ,"휴가");             // 문서 이름
                ptMailBody.setProperty("AINF_SEQN" ,AINF_SEQN);          // 신청서 순번

                // 멜 제목
                StringBuffer sbSubject = new StringBuffer(512);

                sbSubject.append("[" + ptMailBody.getProperty("UPMU_NAME") + "] ");
                //sbSubject.append(user.ename  + "님이 ");
                sbSubject.append(user.ename).append("님이 ");

                String msg;
                String msg2 = "";
                String to_empNo = d03VocationData.PERNR;

                if (ars.E_RETURN.equals("S")) {

                    if (appLine.APPL_APPR_STAT.equals("A")) {
                        msg = "msg009";
                        for (int i = 0; i < vcTempAppLineData.size(); i++) {
                            tempAppLine = (AppLineData) vcTempAppLineData.get(i);
                            if (tempAppLine.APPL_APPU_TYPE.equals(APPU_TYPE) && tempAppLine.APPL_APPR_SEQN.equals(APPR_SEQN)) {
                                if (i == vcTempAppLineData.size() -1) {
                                    // 마직막 결재자
                                    ptMailBody.setProperty("FileName" ,"MbNoticeMailApp.html");
                                    sbSubject.append(ptMailBody.getProperty("UPMU_NAME") +"를 승인 하셨습니다..");
                                } else {
                                    // 이후 결재자
                                    tempAppLine = (AppLineData) vcTempAppLineData.get(i+1);
                                    to_empNo = tempAppLine.APPL_APPU_NUMB;
                                    ptMailBody.setProperty("FileName" ,"MbNoticeMailBuild.html");
                                    sbSubject.append(ptMailBody.getProperty("UPMU_NAME") +" 결재를 요청 하셨습니다.");
                                    break;
                                } // end if
                            } // end if
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
                        Vector vcElofficInterfaceData = new Vector(); //ESB 오류 수정
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
                                eof = ddfe.makeDocForReject(AINF_SEQN ,user.SServer,ptMailBody.getProperty("UPMU_NAME") ,d03VocationData.PERNR ,approvers);
                            } // end if
                        } // end if

                        vcElofficInterfaceData.add(eof);

                        //오류 수정방식 변경으로 막음
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
                        msg2 +=  " Eloffic 연동 실패 " ;
                    } // end try
                    //@v1.1 전자결재연동실패로 메일과 위치변경
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

            } else {
                throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
            } // end if
*/
            Logger.debug.println(this, " destributed = " + dest);
            printJspPage(req, res, dest);

        } catch(Exception e) {
            Logger.err.println(DataUtil.getStackTrace(e));
            throw new GeneralException(e);
        }
    }
}
