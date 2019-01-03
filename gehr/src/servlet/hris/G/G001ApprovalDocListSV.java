/* 작성된 날짜 : 2005. 1. 28.*/
/*				   :  2017-04-03 김은하  [CSR ID:3340999]  대만 당월근태기간동안 46시간 제한*/
/*				   :  2017-04-19 김은하  [CSR ID:3359686]   남경 결재 5일제어*/
/*				   :  2017-06-29 eunha [CSR ID:3420113] 인사시스템 신청 및 결재 메일 UI 표준작업*/
/*				   :  2017-10-20 eunha [CSR ID:3500559] 의료비지원 기준 변경에 대한 요청의 건*/
/*				   :  2018-03-19 강동민  @PJ.광저우 법인(G570) Roll-Out */
/*				   :  2018-08-01 변지현  @PJ.우시법인(G620) Roll-out */
package servlet.hris.G;

import com.common.Utils;
import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.PageUtil;
import com.sns.jdf.util.WebUtil;

import hris.D.D01OT.D01OTData;
import hris.D.D01OT.rfc.D010TOvertimeGlobalRFC;
import hris.D.D01OT.rfc.D01OTCheckGlobalRFC;
import hris.D.D01OT.rfc.D01OTRFC;
import hris.D.D03Vocation.D03VocationData;
import hris.D.D03Vocation.rfc.D03VocationGlobalRFC;
import hris.D.D19Duty.rfc.D19DutyRFC;
import hris.D.rfc.D20ActTimeCardRFC;
import hris.G.ApprovalReturnState;
import hris.G.G001Approval.ApprovalDocList;
import hris.G.G001Approval.ApprovalListKey;
import hris.G.G001Approval.rfc.G001ApprovalDocListRFC;
import hris.G.rfc.G001ApprovalProcessRFC;
import hris.common.*;
import hris.common.approval.ApprovalLineData;
import hris.common.approval.ApprovalLineInput;
import hris.common.approval.ApprovalLineRFC;
import hris.common.rfc.PersonInfoRFC;
import hris.common.rfc.UpmuCodeRFC;
import hris.common.util.AppUtil;
import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.collections.Predicate;
import org.apache.commons.lang.StringUtils;
import org.apache.commons.lang.time.DateFormatUtils;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.*;

/**
 * @author 이승희
 */
public class G001ApprovalDocListSV extends EHRBaseServlet {

    /* (비Javadoc)
     * @see com.sns.jdf.servlet.EHRBaseServlet#performTask(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse)
     */
    protected void performTask(HttpServletRequest req, HttpServletResponse res)
            throws GeneralException {


        try {

            req.setAttribute("isLocal", WebUtil.isLocal(req));
            String dest  = "";
            /*HttpSession session = req.getSession(false);
            WebUserData user = WebUtil.getSessionUser(req);

            String dest  = "";
            String jobid = "";
            ApprovalDocList adl = null;

            ApprovalListKey aplk    =   new ApprovalListKey();
            Vector vcApprovalDocList = null;

            Box box = WebUtil.getBox(req);
            jobid = box.get("jobid");

            String page  = box.get("page");

            if( jobid ==null || jobid.equals("login") || jobid.equals("")){
                jobid = "search";
                aplk.I_BEGDA  =   DataUtil.getAfterDate( DataUtil.getCurrentDate() , -30);
                aplk.I_ENDDA  =   DataUtil.getCurrentDate();
            } else {
                box.copyToEntity(aplk);
            } // end if

            aplk.I_AGUBN  =   "1";
            aplk.I_PERNR  =   user.empNo;

            //    Logger.debug.println(this ," jobid:"+jobid+"#############  user.empNo:"+  aplk.PERNR);*/
            WebUserData user = WebUtil.getSessionUser(req);

            ApprovalListKey aplk = new ApprovalListKey();

            Box box = WebUtil.getBox(req);
            String jobid = box.get("jobid", "search");
            String page = box.get("page");

            if (jobid.equals("search")) {

                if (StringUtils.isBlank(req.getParameter("jobid"))) {
                    aplk.I_BEGDA = DataUtil.getAfterDate(DataUtil.getCurrentDate(), -30);
                    aplk.I_ENDDA = DataUtil.getCurrentDate();
                } else {
                    box.copyToEntity(aplk);
                } // end if

                aplk.I_AGUBN = "1";
                aplk.I_PERNR = user.empNo;

                G001ApprovalDocListRFC aplRFC = new G001ApprovalDocListRFC();
                Vector<ApprovalDocList> resultList = aplRFC.getApprovalDocList(aplk);

                Vector<UpmuCode> upmuList = ((new UpmuCodeRFC()).getUpmuCode(user.companyCode, user.empNo));

                PageUtil pu = new PageUtil(Utils.getSize(resultList), page, 10, 10);

                if(g.getSapType().isLocal()) {
                    //입학축하금신청:05,개인연금신청:02,개인연금해약신청:26,가족수당신청:24,가족수당해약신청:29
                    if(upmuList != null) {
                        List<String> exceptList = Arrays.asList("05", "02", "26", "24", "29");
                        Vector<UpmuCode> removeList = new Vector<UpmuCode>();
                        for (UpmuCode code : upmuList) {
                            if (exceptList.contains(code.getUPMU_TYPE())) {
                                removeList.add(code);
                            }
                        }
                        upmuList.removeAll(removeList);
                    }
                    //[CSR ID:3500559] 의료비지원 기준 변경에 대한 요청의 건 start
                    for (ApprovalDocList approvalDocList : resultList) {
                        if ("03".equals(approvalDocList.UPMU_TYPE) && !"01".equals(approvalDocList.APPU_TYPE)) {
                        	req.setAttribute("isHospital", true);
                        }
                    }
                    //[CSR ID:3500559] 의료비지원 기준 변경에 대한 요청의 건 end
                } else {
                    //*******************************************************************************
                    // BOHAI법인 통문시간 체크.		2009-12-23		jungin		@v1.3 [C20091222_81370]
                    // DAGU법인 통문시간 체크.  	2010-04-28		jungin		@v1.4 [C20100427_55533]
                    // BOTIAN법인 통문시간 체크.  	2011-01-19		liukuo		@v1.5 [C20110118_09919]
                    // 광저우법인(G570) 추가           2018-03-19    강동민     @PJ.광저우 법인(G570) Roll-Out

                    // begin="${pu.from}" end="${pu.to > 0 ? pu.to - 1 : pu.to} 로 변경해야 함
                	for(ApprovalDocList row : resultList) {
                		// 2018-03-12 KDM  @@PJ.광저우 법인(G570) Roll-Out Start
                		// 2018-08-01 변지현 @PJ.우시법인(G620) Roll-out
                        if ( (row.BUKRS.equals("G110") || row.BUKRS.equals("G180") ||  row.BUKRS.equals("G280") || row.BUKRS.equals("G370") || row.BUKRS.equals("G570") || row.BUKRS.equals("G620"))
                                && (row.UPMU_TYPE.equals("01") || row.UPMU_TYPE.equals("07") || row.UPMU_TYPE.equals("08")) ) {
                        // 2018-03-12 KDM  @@PJ.광저우 법인(G570) Roll-Out Start
                            String I_TYPE = "";
                            if (row.UPMU_TYPE.equals("01")) {
                                I_TYPE = "O";
                            }else{
                                I_TYPE = "D";
                            }

                            Vector vc20ActTimeCardData = null;

                            D20ActTimeCardRFC rfc3 = new D20ActTimeCardRFC();
                            vc20ActTimeCardData = rfc3.getActTimeCard(row.PERNR, row.APPL_DATE, row.BEGUZ, row.ENDUZ, I_TYPE);

                            row.I_BEGTIME = (String)vc20ActTimeCardData.get(0);
                            row.I_ENDTIME = (String)vc20ActTimeCardData.get(1);
                            row.I_BEGDATE = (String)vc20ActTimeCardData.get(2);
                            row.I_ENDDATE = (String)vc20ActTimeCardData.get(3);
                        }
                      //[CSR ID:3359686]   남경 결재 5일제어 START
                        if( row.BUKRS.equals("G180")){

                        	D01OTCheckGlobalRFC  d01OTCheckGlobalRFC           = new D01OTCheckGlobalRFC();
                        	D03VocationGlobalRFC rfc = new D03VocationGlobalRFC();
                        	if("01".equals(row.UPMU_TYPE)) {
                        		 d01OTCheckGlobalRFC.checkApprovalPeriod(req,row.PERNR,"A",row.APPL_DATE,   row.UPMU_TYPE,"" );
                                 row.E_7OVER_NOT_APPROVAL =  d01OTCheckGlobalRFC.getReturn().MSGTY;
                        	}else if(StringUtils.startsWith(row.UPMU_TYPE,"02")) {
                        		 rfc.setDetailInput(row.PERNR, "1", row.AINF_SEQN);
                        		 D03VocationData d03VocationData = Utils.indexOf(rfc.getVocation(row.PERNR, row.AINF_SEQN), 0);
                        	    d01OTCheckGlobalRFC.checkApprovalPeriod(req,row.PERNR,"A",row.APPL_DATE,   row.UPMU_TYPE,  d03VocationData.AWART );
                        	    row.E_7OVER_NOT_APPROVAL =  d01OTCheckGlobalRFC.getReturn().MSGTY;
                        	 }
                        }
                      //[CSR ID:3359686]   남경 결재 5일제어 END

                        if( row.BUKRS.equals("G110")||row.BUKRS.equals("G220")) {
                            if("01".equals(row.UPMU_TYPE)) {
                                row.IFlag = "Y";        // 신청시는 'N', 결제시는 'Y'

                                D010TOvertimeGlobalRFC rfc1 = new D010TOvertimeGlobalRFC();
                                row.E_ANZHL = rfc1.check(row.PERNR, row.APPL_DATE, row.IFlag);        // 신청자사번, 신청일, 결제Y

                                // 교대조 구분값
                                Vector AppLineData_vt = AppUtil.getAppVector(row.PERNR, row.UPMU_TYPE, row.APPL_DATE, row.E_ANZHL);
                                row.SHIFT = (String) AppLineData_vt.get(1);
                                D01OTRFC rfc = new D01OTRFC();
                                rfc.setDetailInput(row.PERNR, "1", row.AINF_SEQN);
                                row.d01OTData = Utils.indexOf(rfc.getDetail(row.AINF_SEQN, row.PERNR), 0);
                              //2017-04-03 김은하  [CSR ID:3340999]  대만 당월근태기간동안 46시간 제한 START
                                D01OTCheckGlobalRFC  d01OTCheckGlobalRFC           = new D01OTCheckGlobalRFC();
                                d01OTCheckGlobalRFC.checkOvertimeTp46Hours(req, row.d01OTData.PERNR,  "A", row.d01OTData.AINF_SEQN , row.d01OTData.WORK_DATE,  row.d01OTData.STDAZ );
                                row.E_46OVER_NOT_APPROVAL =  d01OTCheckGlobalRFC.getReturn().MSGTY;
                                //2017-04-03 김은하  [CSR ID:3340999]  대만 당월근태기간동안 46시간 제한 END
                                // 개인정보
                                row.personData = (new PersonInfoRFC()).getPersonInfo(row.PERNR);
                            } else if("02".equals(row.UPMU_TYPE) || "07".equals(row.UPMU_TYPE) || "08".equals(row.UPMU_TYPE)) {

                            }
                        }
                        if( row.BUKRS.equals("G110") && row.UPMU_TYPE.equals("01") ) {    // DAGU법인 OVerTime
                            //2016-04-19 pang xiaolin @v2.2 [C20160324_18938]全法人增加leave的批量?批功能 end
                            Vector vcAppLineData;

                            vcAppLineData = AppUtil.getAppChangeVt(row.AINF_SEQN);
                            AppLineData appLineData = (AppLineData) vcAppLineData.get(0);
                            DataUtil.fixNull(appLineData);

                            if( appLineData.APPL_PERNR .equals(user.empNo)){
                                row.no = "1";
                            }else{
                                row.no = "2";
                            }

                            D19DutyRFC rfc = new D19DutyRFC();
                            row.d19DutyData = Utils.indexOf(rfc.getDetail1( row.AINF_SEQN, row.PERNR, row.no), 0);
                        }



                    }
                }

                req.setAttribute("upmuList", upmuList);

                req.setAttribute("resultList", resultList);
                req.setAttribute("inputData", aplk);
                req.setAttribute("page", page);

                req.setAttribute("pu", pu);

                if(g.getSapType().isLocal())
                    printJspPage(req, res, WebUtil.JspURL + "G/G001ApprovalDocList.jsp");
                else
                    printJspPage(req, res, WebUtil.JspURL + "G/G001ApprovalDocList_GLOBAL.jsp");

            } else if (jobid.equals("save")) {

                String msg = "msg009";
                String msg2 = "";

                Vector<ApprovalDocList> vcApprovalDocList = box.getVector(ApprovalDocList.class);

                String[] seqns = req.getParameterValues("approvalSeq");

                if(seqns == null || Utils.getSize(vcApprovalDocList) == 0) {
                    moveMsgPage(req, res, g.getMessage("MSG.APPROVAL.NO.DATA"), "history.back();");
                    return;
                }

                List<String> seqnList = new ArrayList<String>();
                CollectionUtils.addAll(seqnList, seqns);

                Vector vcAppLineData = new Vector();

                for(final ApprovalDocList row : vcApprovalDocList) {

                    boolean exist = CollectionUtils.exists(seqnList, new Predicate() {
                        public boolean evaluate(Object o) {
                            return row.AINF_SEQN.equals(o);
                        }
                    });

                    if(exist) {

                        Logger.debug(row);
                        /* 일괄 결재 가능 여부 확인 */
                        if(!WebUtil.isMultiApproval(g.getSapType(), row.UPMU_TYPE, row.APPU_TYPE, row.APPR_SEQN)) {
                            moveMsgPage(req, res, g.getMessage("MSG.APPROVAL.MULTIAPPROVAL.DISABLE"), "history.back();");
                            return;
                        }

                        if(!g.getSapType().isLocal() &&
                                ("01".equals(row.UPMU_TYPE) || "07".equals(row.UPMU_TYPE) || "08".equals(row.UPMU_TYPE))) {

                            String flag = (new D01OTCheckGlobalRFC()).check1(row.APPU_NUMB, DataUtil.removeSeparate(row.APPR_DATE), row.UPMU_TYPE);        // 신청자사번, 신청날짜, 업무타입

                            if (!"Y".equals(flag)) {        // 근태마감일 Y일 경우
                                msg = "You can not apply this data in payroll period.";
                                continue;
                            }
                         }

                        AppLineData    appLine  	=   new AppLineData();
                        appLine.APPL_BUKRS      	=   row.BUKRS;
                        appLine.APPL_PERNR      	=   row.PERNR;
                        appLine.APPL_BEGDA      	=   row.BEGDA;
                        appLine.APPL_AINF_SEQN	=   row.AINF_SEQN;
                        appLine.APPL_APPU_TYPE	=   row.APPU_TYPE;
                        appLine.APPL_APPR_SEQN	=   row.APPR_SEQN;
                        appLine.APPL_APPU_NUMB	=   user.empNo;
                        appLine.APPL_APPR_DATE  =   DataUtil.getCurrentDate(req);
                        appLine.APPL_APPR_TIME  =   DataUtil.getDate(req);
                        appLine.APPL_APPR_STAT	=   "A";
                        appLine.APPL_BIGO_TEXT	=   "";

                        vcAppLineData.addElement(appLine);
                    }
                }


                G001ApprovalProcessRFC Apr = new G001ApprovalProcessRFC();
                Vector vcRet = Apr.setApprovalStatutsList(vcAppLineData);
                Logger.debug.println(this, vcRet);


                Vector vcElofficInterfaceData = new Vector();

                String reqDate = DateFormatUtils.format(DataUtil.getDate(req), "yyyyMMddHHmm");

                for (int i = 0; i < vcRet.size(); i++) {

                    ApprovalReturnState ars = (ApprovalReturnState) vcRet.get(i);
                    if (ars.E_RETURN.equals("S")) {

                        /*ApprovalDocList apl = (ApprovalDocList) vcApprovalDocList.get(i);*/
                        ApprovalDocList apl = findApproval(vcApprovalDocList, ars.E_AINF_SEQN);
                        if(apl == null) continue;

                        /* 결재라인을 읽어와 메일을 어디로 보낼지 결정한다. 최종 건일 경우 신청자 한테 */
                        /* 기본적으로 최종완료 일 경우 */
                        String toEmpNo = apl.PERNR;
                     // [CSR ID:3420113] 인사시스템 신청 및 결재 메일 UI 표준작업  2017-06-29 eunha start
                        String fileName = g.getSapType().isLocal() ? "NoticeMail2.html" : "NoticeMail2_GLOBAL.html";

                        String title = g.getMessage("MSG.APPROVAL.0004", apl.getUPMU_NAME()); //{0}님이 {1}를 승인 하셨습니다.
                     // [CSR ID:3420113] 인사시스템 신청 및 결재 메일 UI 표준작업  2017-06-29 eunha end
                        ApprovalLineRFC approvalLineRFC = new ApprovalLineRFC();
                        ApprovalLineInput approvalLineInput = new ApprovalLineInput();
                        approvalLineInput.I_AINF_SEQN = apl.AINF_SEQN;
                        approvalLineInput.I_PERNR = apl.PERNR;
                        Vector<ApprovalLineData> approvalLine = approvalLineRFC.getApprovalLine(approvalLineInput);

                        ApprovalLineData approvalNext = null;
                            /* 다음 결재자 가져오기 */
                        for(ApprovalLineData approvalLineData : approvalLine) {
                            if(StringUtils.isBlank(approvalLineData.APPR_STAT)) {
                                approvalNext = approvalLineData;
                                break;
                            }
                        }
                        if(approvalNext != null) {
                            //이후 결재자
                        	//전자결재 UI통합 eunha start
                            toEmpNo = approvalNext.APPU_NUMB;
                            fileName = g.getSapType().isLocal() ? "NoticeMail1.html" : "NoticeMail1_GLOBAL.html";
                            title = g.getMessage("MSG.APPROVAL.0002",apl.getUPMU_NAME());  //[HR] 결재요청 ({0})
                        }

                        Properties ptMailBody = new Properties();
                        ptMailBody.setProperty("SServer", user.SServer);                 // ElOffice 접속 서버
                        ptMailBody.setProperty("from_empNo", user.empNo);               // 멜 발송자 사번
                        ptMailBody.setProperty("to_empNo", toEmpNo);                  // 멜 수신자 사번

                        ptMailBody.setProperty("ename", apl.ENAME);                     // (피)신청자명
                        ptMailBody.setProperty("empno", apl.PERNR);                     // (피)신청자 사번

                        ptMailBody.setProperty("UPMU_NAME", apl.UPMU_NAME);                  // 문서 이름
                        ptMailBody.setProperty("AINF_SEQN", apl.AINF_SEQN);             // 신청서 순번

                        ptMailBody.setProperty("FileName", fileName);

                        // 멜 제목
                        StringBuffer sbSubject = new StringBuffer(512);

                        // [CSR ID:3420113] 인사시스템 신청 및 결재 메일 UI 표준작업  2017-06-29 eunha
                        // sbSubject.append("[" + ptMailBody.getProperty("UPMU_NAME") + "] "); //
                        sbSubject.append(title); //님이 승인 하셨습니다.

                        ptMailBody.setProperty("subject", sbSubject.toString());    // 멜 제목 설정
                        MailSendToEloffic maTe = new MailSendToEloffic(ptMailBody);

                        if (!maTe.process()) {
                            msg2 = maTe.getMessage() + " \\n";
                        } // end if

                        try {
                            if (!apl.UPMU_TYPE.equals("23")) {
                                DraftDocForEloffice ddfe = new DraftDocForEloffice();
                                ElofficInterfaceData eof;
                                Logger.debug.println(this, "====chem [[신청시 결재자 ]]:apl.APPU_NUMB" + apl.APPU_NUMB + "로그인결재자  user.empNo:" + user.empNo);
                                Logger.debug.println(this, "===i:" + i + "   [[[apl" + apl.toString());


                                if (!apl.APPU_NUMB.equals(user.empNo)) {
                                    Logger.debug.println(this, "==== [[신청시 결재자가 현재 결재자와 다른경우  ]]:apl.APPU_NUMB" + apl.APPU_NUMB + "로그인결재자  user.empNo:" + user.empNo);
                                    //결재올려진 결재자 외의 테스크를 가지고 있는 결재자가 결재할때 처리:현재 전자결재에 들어가있는 DATA를 삭제후 다시 처리
                                    ElofficInterfaceData eofD = ddfe.makeDocForDelete(apl.AINF_SEQN, user.SServer, apl.PERNR, ptMailBody.getProperty("UPMU_NAME"), apl.APPU_NUMB);
                                    eofD.REQ_DATE = reqDate;
                                    vcElofficInterfaceData.add(eofD);
                                    ElofficInterfaceData eofI = ddfe.makeDocForInsert(apl.AINF_SEQN, user.SServer, apl.PERNR, ptMailBody.getProperty("UPMU_NAME"));
                                    eofI.REQ_DATE = reqDate;
                                    vcElofficInterfaceData.add(eofI);
                                    Logger.debug.println(this, "==== [[vcElofficInterfaceData ]]: " + vcElofficInterfaceData.toString());
                                }
                                Logger.debug.println(this, "일괄결재 전 ]]:vcElofficInterfaceData:" + vcElofficInterfaceData.toString());

                                eof = ddfe.makeDocContents(apl.AINF_SEQN, user.SServer, ptMailBody.getProperty("UPMU_NAME"));
                                eof.REQ_DATE = reqDate;
                                vcElofficInterfaceData.add(eof);
                                Logger.debug.println(this, "일괄결재목록:vcElofficInterfaceData:" + vcElofficInterfaceData.toString());

                            } // end if
                        } catch (Exception e) {
                            msg2 = msg2 + g.getMessage("MSG.COMMON.0020") +"\\n";  //Eloffice 연동 실패
                        } // end try
                    } else {
                        msg2 = msg2 + ars.E_MESSAGE + "\\n";
                    } // end if
                } // end for
                String url = "location.href = '" + g.getRequestPageName(req) + "';";
                req.setAttribute("msg", msg);
                req.setAttribute("msg2", msg2);
                req.setAttribute("url", url);

                if (vcElofficInterfaceData.size() > 0) {
                    // 오류 수정방식 변경으로 막음
                    //req.setAttribute("vcElofficInterfaceData", vcElofficInterfaceData);
                    //dest = WebUtil.JspURL+"common/ElOfficeInterface.jsp";


                    //통합결재 잦은오류로 인해 서버실행으로 변경함  2012.11.07
                    try {


                        SendToESB esb = new SendToESB();
                        String esbmsg = esb.process(vcElofficInterfaceData);
                        Logger.debug.println(this, "[일괄 결재 esbmsg]  :" + esbmsg);
                        req.setAttribute("message", esbmsg);
                        dest = WebUtil.JspURL + "common/EsbResult.jsp";

                    } catch (Exception e) {
                        dest = WebUtil.JspURL + "common/msg.jsp";
                        msg2 += "\\n" + "esb.process Eloffice fail";
                    }


                } else {
                    dest = WebUtil.JspURL + "common/msg.jsp";
                } // end if

                printJspPage(req, res, dest);

            } else {
                throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
            } // end if

            Logger.debug.println(this, this.getClass().getName());

            Logger.debug.println(this, " destributed = " + dest);

        } catch (Exception e) {
            Logger.error(e);
            throw new GeneralException(e);
        } finally {

        }

    }

    private ApprovalDocList findApproval(Vector<ApprovalDocList> vcApprovalDocList, String AINF_SEQN ) {

        for(ApprovalDocList row : vcApprovalDocList) {
            if(StringUtils.equals(row.AINF_SEQN, AINF_SEQN)) return row;
        }

        return null;
    }
}
