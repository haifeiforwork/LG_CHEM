/********************************************************************************/
/*                                                                              */
/*   System Name  :  e-HR                                                        */
/*   1Depth Name  : HR 결재함                                                   */
/*   2Depth Name  : 결재 해야할 문서                                            */
/*   Program Name : 급여 계좌 신청                                              */
/*   Program ID   : G022ApprovalBankSV                                          */
/*   Description  : 급여 계좌 부서장 결재/반려                                  */
/*   Note         : 없음                                                        */
/*   Creation     : 2005-03-14  이승희                                          */
/*   Update       :                                                             */
/*                  : 2016-09-20 통합구축 - 김승철 (해외통합)                    */
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
import hris.A.A14Bank.A14BankStockFeeData;
import hris.A.A14Bank.rfc.A14BankStockFeeRFC;
import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalHeader;
import hris.common.approval.ApprovalLineData;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.Vector;


public class G022ApprovalBankSV extends ApprovalBaseServlet 
{
    private String UPMU_TYPE ="10";     // 결재 업무타입(급여계좌)
    private String UPMU_NAME = "급여계좌 ";

    protected String getUPMU_TYPE() {
        if(g.getSapType().isLocal())  return "10";
        else return  "03";
    }

    protected String getUPMU_NAME() {
        if(g.getSapType().isLocal())  return "급여계좌";
        else return  "Register Salary Account";
    }


    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        String detailImportTableName = "T_ZHRA011T";

        try{
            HttpSession session = req.getSession(false);
            final WebUserData user = WebUtil.getSessionUser(req);
            String bankflag  = "01";
            
            /* 해외 업무 타입*/
           if(user.area != Area.KR) {
               UPMU_NAME = "Register Salary Account";
               UPMU_TYPE ="03";
               detailImportTableName = "T_ZHR0044T";
               bankflag  = "0";
           } else {
               UPMU_TYPE ="10";     // 결재 업무타입(급여계좌)
               UPMU_NAME = "급여계좌 ";
               detailImportTableName = "T_ZHRA011T";
               bankflag  = "01";
           }
           
//            Vector  vcAppLineData;
            Vector  vcA14BankStockFeeData ;
            
            A14BankStockFeeData a14BankStockFeeData;
            
            String dest  = "";
            String jobid = "";
            
            final Box box = WebUtil.getBox(req);
            
            String  AINF_SEQN  = box.get("AINF_SEQN");
            
            // 처리 후 돌아 갈 페이지
//            String RequestPageName = box.get("RequestPageName");
//            req.setAttribute("RequestPageName", RequestPageName);
            
            jobid = box.get("jobid", "search");
            

            final A14BankStockFeeRFC rfc  = new A14BankStockFeeRFC();
            rfc.setDetailInput(user.empNo, "1", AINF_SEQN);
            vcA14BankStockFeeData = rfc.getBankStockFee("", AINF_SEQN, bankflag );
            Logger.debug.println(this, vcA14BankStockFeeData);
            a14BankStockFeeData = (A14BankStockFeeData)Utils.indexOf(vcA14BankStockFeeData,0);


            /* 승인 시 */
            if("A".equals(jobid)) {
                /* 개발자 영역 끝 */
                dest = accept(req, box, detailImportTableName, a14BankStockFeeData, rfc, new ApprovalFunction<A14BankStockFeeData>() {
                    public boolean porcess(A14BankStockFeeData inputData, ApprovalHeader approvalHeader, Vector<ApprovalLineData> approvalLineDatas) throws GeneralException {
//                        if(approvalHeader. isChargeArea()) {
//                        	box.copyToEntity(inputData);
                        	inputData.AEDTM   =   DataUtil.getCurrentDate();
                        	inputData.UNAME   =   user.empNo;
                        	inputData.CERT_DATE = box.get("CERT_DATE");
                        	inputData.CERT_FLAG = box.get("CERT_FLAG");
//                            Logger.debug.println(this, "CERT_DATE-------------------"+box.get("CERT_DATE")+inputData.CERT_DATE);
//                            Logger.debug.println(this, "CERT_FLAG-------------------"+box.get("CERT_FLAG"));
//                            Logger.debug.println(this, "inputData-------------------"+inputData);
//                        }

                        return true;
                    }
                });

            /* 반려시 */
            } else if("R".equals(jobid)) {
                dest = reject(req, box, null, a14BankStockFeeData, rfc, null);
            } else if("C".equals(jobid)) {
                dest = cancel(req, box, null, a14BankStockFeeData, rfc, null);
/*            
            
            if( jobid.equals("search") ) {

                A14BankStockFeeRFC rfc                     = new A14BankStockFeeRFC();

                vcA14BankStockFeeData = rfc.getBankStockFee("", AINF_SEQN, bankflag );
                Logger.debug.println(this, vcA14BankStockFeeData);
                
                if( vcA14BankStockFeeData.size() < 1 ){
                    String msg = "System Error! \n\n 조회할 항목이 없습니다.";
                    req.setAttribute("msg", msg);
                    dest = WebUtil.JspURL+"common/caution.jsp";
                }else{
                    // 재해 상세 내역
                    a14BankStockFeeData = (A14BankStockFeeData)vcA14BankStockFeeData.get(0);
                    // 결재자 정보
                    vcAppLineData = AppUtil.getAppChangeVt(AINF_SEQN);
                    
                   
                    PersInfoWithNoRFC   piRfc   = new PersInfoWithNoRFC();
                    PersInfoData        pid     = (PersInfoData) piRfc.getApproval(a14BankStockFeeData.PERNR).get(0);
                    req.setAttribute("PersInfoData" ,pid );
                    
                    req.setAttribute("a14BankStockFeeData", a14BankStockFeeData);
                    req.setAttribute("vcAppLineData" , vcAppLineData);
                    
                    dest = WebUtil.JspURL+"G/G022ApprovalBank.jsp";
                } // end if
                
            } else if( jobid.equals("save") ) {
                
                a14BankStockFeeData = new A14BankStockFeeData();
                vcA14BankStockFeeData = new Vector();
                
                vcAppLineData       = new Vector();
                
                AppLineData         tempAppLine;
                
                Vector vcTempAppLineData   = new Vector();
                AppLineData    appLine        = new AppLineData();
                
                // 은행 계좌 신청 기초 자료
                box.copyToEntity(a14BankStockFeeData);
              
                // 결재자 정보 
                int nRowCount = Integer.parseInt(box.getString("RowCount"));
                
                String APPU_TYPE   =  box.get("APPU_TYPE");
                String APPR_SEQN   =  box.get("APPR_SEQN");
                String currApprNumb = "";
                
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
                phonenumdata    =   (PersonData)numfunc.getPersonInfo(a14BankStockFeeData.PERNR);
                
                Properties ptMailBody = new Properties();
                ptMailBody.setProperty("SServer",user.SServer);                 // ElOffice 접속 서버
                ptMailBody.setProperty("from_empNo" ,user.empNo);               // 멜 발송자 사번
                
                ptMailBody.setProperty("ename" ,phonenumdata.E_ENAME);          // (피)신청자명 
                ptMailBody.setProperty("empno" ,phonenumdata.E_PERNR);          // (피)신청자 사번
                
                ptMailBody.setProperty("UPMU_NAME" ,"급여계좌신청");            // 문서 이름
                ptMailBody.setProperty("AINF_SEQN" ,AINF_SEQN);                 // 신청서 순번
                
                // 멜 제목
                StringBuffer sbSubject = new StringBuffer(512);
                
                sbSubject.append("[" + ptMailBody.getProperty("UPMU_NAME") + "] ");
                sbSubject.append(user.ename  + "님이 ");
                
                String msg;
                String msg2 = "";
                String to_empNo = a14BankStockFeeData.PERNR;
                
                if (ars.E_RETURN.equals("S")) {
                    if (appLine.APPL_APPR_STAT.equals("A")) {
                        msg = "msg009";
                        for (int i = 0; i < vcTempAppLineData.size(); i++) {
                            tempAppLine = (AppLineData) vcTempAppLineData.get(i);
                            if (tempAppLine.APPL_APPU_TYPE.equals(APPU_TYPE) && tempAppLine.APPL_APPR_SEQN.equals(APPR_SEQN)) {
                                if (i == vcTempAppLineData.size() -1) {
                                    // 마직막 결재자
                                    ptMailBody.setProperty("FileName" ,"NoticeMail2.html");
                                    sbSubject.append(ptMailBody.getProperty("UPMU_NAME") +"를 승인 하셨습니다.");
                                } else {
                                    // 이후 결재자
                                    tempAppLine = (AppLineData) vcTempAppLineData.get(i+1);
                                    to_empNo = tempAppLine.APPL_APPU_NUMB;
                                    sbSubject.append("결재를 요청 하셨습니다.");
                                    break;
                                } // end if
                            } else {

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
                        ptMailBody.setProperty("FileName" ,"NoticeMail3.html");
                        sbSubject.append(ptMailBody.getProperty("UPMU_NAME") +"를 반려 하셨습니다.");
                    } // end if
                    
                    ptMailBody.setProperty("to_empNo" ,to_empNo);                   // 멜 수신자 사번
                    ptMailBody.setProperty("subject" ,sbSubject.toString());        // 멜 제목 설정
                    MailSendToEloffic   maTe = new MailSendToEloffic(ptMailBody);

                    if (!maTe.process()) {
                        msg2 = maTe.getMessage() + "\\n";
                    } // end if

                    try {
                        DraftDocForEloffice ddfe = new DraftDocForEloffice();
                        ElofficInterfaceData eof;

                        Vector vcElofficInterfaceData = new Vector();
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
                                eof = ddfe.makeDocForReject(AINF_SEQN ,user.SServer,ptMailBody.getProperty("UPMU_NAME") ,a14BankStockFeeData.PERNR ,approvers);
                            } // end if
                        } // end if
                        
                        vcElofficInterfaceData.add(eof);
                        req.setAttribute("vcElofficInterfaceData", vcElofficInterfaceData);
                        dest = WebUtil.JspURL+"common/ElOfficeInterface.jsp";
                    } catch (Exception e) {
                        dest = WebUtil.JspURL+"common/msg.jsp";
                        msg2 = msg2 +  " Eloffic 연동 실패 " ;
                    } // end try
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
        } finally {
            
        }
    }
}