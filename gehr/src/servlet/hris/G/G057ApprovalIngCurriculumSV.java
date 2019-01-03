/********************************************************************************/
/*                                                                              */
/*   System Name  : e-HR                                                        */
/*   1Depth Name  : HR 결재함                                                   */
/*   2Depth Name  : 결재 해야할 문서                                            */
/*   Program Name : 교육신청                                                    */
/*   Program ID   : G057ApprovalCurriculumSV                                    */
/*   Description  : 교육신청 신청 부서장 결재/반려                              */
/*   Note         : 없음                                                        */
/*   Creation     : 2005-03-14  이승희                                          */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/

package servlet.hris.G;

import hris.C.C02Curri.C02CurriApplData;
import hris.C.C02Curri.C02CurriInfoData;
import hris.C.C02Curri.rfc.C02CurriApplRFC;
import hris.C.C02Curri.rfc.C02CurriGetFlagRFC;
import hris.G.ApprovalReturnState;
import hris.G.rfc.EducationInfoRFC;
import hris.G.rfc.G001ApprovalProcessRFC;
import hris.common.*;
import hris.common.PersonData;
import hris.common.rfc.PersInfoWithNoRFC;
import hris.common.rfc.PersonInfoRFC;
import hris.common.util.AppUtil;

import java.util.Properties;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;


public class G057ApprovalIngCurriculumSV extends EHRBaseServlet 
{
    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        try{
            HttpSession session = req.getSession(false);
            WebUserData user = WebUtil.getSessionUser(req);

            Vector vcC02CurriApplData;
            Vector vcAppLineData;
            
            C02CurriApplData c02CurriApplData;
            
            String dest  = "";
            String jobid = "";
            String bankflag  = "01";
            
            Box box = WebUtil.getBox(req);
            
            String  AINF_SEQN  = box.get("AINF_SEQN");
            
            // 처리 후 돌아 갈 페이지
            String RequestPageName = box.get("RequestPageName");
            req.setAttribute("RequestPageName", RequestPageName);
            
            jobid = box.get("jobid");
            
            if(jobid == null || jobid.equals("") ){
                jobid = "search";
            }// end if
            
            if( jobid.equals("search") ) {
                
                String isDuplication ;
                
                C02CurriApplRFC func = new C02CurriApplRFC();
                vcC02CurriApplData = func.getDetail( AINF_SEQN );
                
                Logger.debug.println(this ,vcC02CurriApplData);

                if( vcC02CurriApplData.size() < 1 ){
                    String msg = "System Error! \n\n 조회할 항목이 없습니다.";
                    req.setAttribute("msg", msg);
                    dest = WebUtil.JspURL+"common/caution.jsp";
                }else{
                    // 교육신청
                    c02CurriApplData = (C02CurriApplData)vcC02CurriApplData.get(0);
                    
                    // 결재자 정보
                    vcAppLineData = AppUtil.getAppChangeVt(AINF_SEQN);
                    
                    PersInfoWithNoRFC   piRfc   = new PersInfoWithNoRFC();
                    PersInfoData        pid     = (PersInfoData) piRfc.getApproval(c02CurriApplData.PERNR).get(0);
                    req.setAttribute("PersInfoData" ,pid );
                    
                    // 신청하려는 교육과 기간이 중복되는 교육이 있는지를 체크한다.
                    isDuplication  = (new C02CurriGetFlagRFC()).check( c02CurriApplData.PERNR, c02CurriApplData.GBEGDA, c02CurriApplData.GENDDA, c02CurriApplData.CHAID );
                    
                    // 교육 정보
                    C02CurriInfoData c02CurriInfoData = (C02CurriInfoData)(new EducationInfoRFC()).getEducationInfo(c02CurriApplData.GWAID ,c02CurriApplData.CHAID);
                    
                    req.setAttribute("c02CurriApplData", c02CurriApplData);
                    req.setAttribute("c02CurriInfoData", c02CurriInfoData);
                    req.setAttribute("isDuplication" , isDuplication );
                    req.setAttribute("vcAppLineData" , vcAppLineData);

                    dest = WebUtil.JspURL+"G/G057ApprovalIngCurriculum.jsp";
                } // end if
            } else if( jobid.equals("save") ) {
                
                c02CurriApplData     = new C02CurriApplData();
                vcC02CurriApplData   = new Vector();
                
                // 건강보험 재발급 신청 
                box.copyToEntity(c02CurriApplData);
                c02CurriApplData.UNAME     = user.empNo;
                c02CurriApplData.AEDTM     = DataUtil.getCurrentDate();
                
                vcC02CurriApplData.add(c02CurriApplData);
                
                // 결재자 정보
                vcAppLineData       = new Vector();
                AppLineData    appLine     = new AppLineData();
                
                Vector vcTempAppLineData   = new Vector();
                AppLineData         tempAppLine;
                 
                int nRowCount = Integer.parseInt(box.getString("RowCount"));
                
                String APPU_TYPE   =  box.get("APPU_TYPE");
                String APPR_SEQN   =  box.get("APPR_SEQN");
                
                for (int i = 0; i < nRowCount; i++) {
                    tempAppLine = new AppLineData();
                    box.copyToEntity(tempAppLine ,i);
                    vcTempAppLineData.add(tempAppLine);
                    
                    if (tempAppLine.APPL_APPU_TYPE.equals(APPU_TYPE) && tempAppLine.APPL_APPR_SEQN.equals(APPR_SEQN)) {
                        appLine.APPL_BUKRS = box.getString("BUKRS");
                        appLine.APPL_PERNR = box.getString("PERNR");
                        appLine.APPL_BEGDA = box.getString("BEGDA1");
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
                phonenumdata    =   (PersonData)numfunc.getPersonInfo(c02CurriApplData.PERNR);
                
                Properties ptMailBody = new Properties();
                ptMailBody.setProperty("SServer",user.SServer);                 // ElOffice 접속 서버
                ptMailBody.setProperty("from_empNo" ,user.empNo);               // 멜 발송자 사번
                
                ptMailBody.setProperty("ename" ,phonenumdata.E_ENAME);          // (피)신청자명 
                ptMailBody.setProperty("empno" ,phonenumdata.E_PERNR);          // (피)신청자 사번
                
                ptMailBody.setProperty("UPMU_NAME" ,"교육신청");            // 문서 이름
                ptMailBody.setProperty("AINF_SEQN" ,AINF_SEQN);                 // 신청서 순번
                
                // 멜 제목
                StringBuffer sbSubject = new StringBuffer(512);
                
                sbSubject.append("[" + ptMailBody.getProperty("UPMU_NAME") + "] ");
                sbSubject.append(user.ename  + "님이 ");
                
                String msg;
                String msg2 = "";
                String to_empNo = c02CurriApplData.PERNR;
                
                if (ars.E_RETURN.equals("S")) {
                    
                    ptMailBody.setProperty("FileName" ,"NoticeMail5.html");
                    
                    msg = "msg011";
                    
                    for (int i = 0; i < vcTempAppLineData.size(); i++) {
                        tempAppLine = (AppLineData) vcTempAppLineData.get(i);
                        if (tempAppLine.APPL_APPU_TYPE.equals(APPU_TYPE) && tempAppLine.APPL_APPR_SEQN.equals(APPR_SEQN)) {
                            // 이후 결재자
                            tempAppLine = (AppLineData) vcTempAppLineData.get(i+1);
                            to_empNo = tempAppLine.APPL_APPU_NUMB;
                            break;
                        } else {
                            
                        } // end if
                    } // end for
                    
                    sbSubject.append("삭제 하셨습니다.");
                    
                    ptMailBody.setProperty("to_empNo" ,to_empNo);                   // 멜 수신자 사번
                    ptMailBody.setProperty("subject"  ,sbSubject.toString());       // 멜 제목 설정
                    MailSendToEloffic   maTe = new MailSendToEloffic(ptMailBody);

                    if (!maTe.process()) {
                        msg2 = maTe.getMessage() + "\\n";
                    } // end if
/*
                    try {
                        DraftDocForEloffice ddfe = new DraftDocForEloffice();
                        
                        ElofficInterfaceData eof = ddfe.makeDocForCancel(AINF_SEQN ,user.SServer,ptMailBody.getProperty("UPMU_NAME") ,to_empNo);
                        
                        Vector vcElofficInterfaceData = new Vector();
                        vcElofficInterfaceData.add(eof);
                        req.setAttribute("vcElofficInterfaceData", vcElofficInterfaceData);
                        dest = WebUtil.JspURL+"common/ElOfficeInterface.jsp";
                    } catch (Exception e) {
                        dest = WebUtil.JspURL+"common/msg.jsp";
                        msg2 = msg2 +  " Eloffic 연동 실패 " ;
                    } // end try
                    */
                } else {
                    dest = WebUtil.JspURL+"common/msg.jsp";
                    msg = ars.E_MESSAGE;
                } // end if
                
                String url = "location.href = \"" + RequestPageName.replace('|','&') + "\";";
                
                req.setAttribute("msg", msg);
                req.setAttribute("msg2", msg2);
                req.setAttribute("url", url);
                
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