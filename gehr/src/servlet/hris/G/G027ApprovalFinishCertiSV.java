/*                                                                              */
/*   System Name  : e-HR                                                        */
/*   1Depth Name  : HR 결재함                                                   */
/*   2Depth Name  : 결재 완료 문서                                              */
/*   Program Name : 제 증명 신청                                                */
/*   Program ID   : G027ApprovalFinishCertiSV                                   */
/*   Description  : 제 증명 신청 결재 완료                                      */
/*   Note         : 없음                                                        */
/*   Creation     : 2005-03-14  이승희                                          */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/
  
package servlet.hris.G;

import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;
import hris.A.A15Certi.A15CertiData;
import hris.A.A15Certi.rfc.A15CertiPrintRFC;
import hris.A.A15Certi.rfc.A15CertiRFC;
import hris.G.rfc.BizPlaceDataRFC;
import hris.G.rfc.StellRFC;
import hris.common.PersInfoData;
import hris.common.PersonData;
import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.rfc.PersInfoWithNoRFC;
import hris.common.rfc.PersonInfoRFC;
import hris.common.util.AppUtil;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Map;
import java.util.Vector;

public class G027ApprovalFinishCertiSV extends ApprovalBaseServlet {

    protected String getUPMU_TYPE() {
        if(g.getSapType().isLocal())  return "16";
        else return  "05";
    }

    protected String getUPMU_NAME() {

        if(g.getSapType().isLocal())  return "재직증명서";
        else return  "Internal Certificate"; // 결재 업무타입(자격면허등록)
    }

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        
        try{
            WebUserData user = WebUtil.getSessionUser(req);
            
            Vector  vcAppLineData;

            A15CertiData  a15CertiData;
            
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

            A15CertiRFC func = new A15CertiRFC();
            func.setDetailInput(user.empNo, "16", AINF_SEQN);
            Vector vcA15CertiData = func.getDetail();

            if( jobid.equals("search") ) {


                Logger.debug.println(this, vcA15CertiData);
                
                if( vcA15CertiData.size() < 1 ){
                    String msg = "System Error! \n\n 조회할 항목이 없습니다.";
                    req.setAttribute("msg", msg);
                    dest = WebUtil.JspURL+"common/caution.jsp";
                }else{
                    // 재직 증명
                    a15CertiData      = (A15CertiData)vcA15CertiData.get(0);
                    // 결재자 정보
                    vcAppLineData = AppUtil.getAppChangeVt(AINF_SEQN);
                    
                    PersInfoWithNoRFC   piRfc   = new PersInfoWithNoRFC();
                    PersInfoData        pid     = (PersInfoData) piRfc.getApproval(a15CertiData.PERNR).get(0);
                    req.setAttribute("PersInfoData" ,pid );
                    
                    // 사업장 주소 가져오기
                    Vector vcBizPlaceCodeEntity =  (new BizPlaceDataRFC()).getBizPlacesCodeEntity(a15CertiData.PERNR,"16");
                    
                   
                    // 직무 코드 가져오기
                    Vector vcStellCodeEntity = (Vector) (new StellRFC()).getStellCodeEntity();
                    
                    req.setAttribute("a15CertiData", a15CertiData);
                    req.setAttribute("vcAppLineData" , vcAppLineData);
                    req.setAttribute("vcBizPlaceCodeEntity" , vcBizPlaceCodeEntity);
                    req.setAttribute("vcStellCodeEntity" , vcStellCodeEntity);
                    
                    dest = WebUtil.JspURL+"G/G027ApprovalFinishCerti.jsp";
                } // end if
            } else if( jobid.equals("print_certi") ) {               //새창띠움(빈페이지)

                // 재직 증명
                a15CertiData      = (A15CertiData)vcA15CertiData.get(0);
                req.setAttribute("AINF_SEQN", AINF_SEQN);
                req.setAttribute("PERNR" ,       a15CertiData.PERNR );
                req.setAttribute("MENU" ,      "CERTI"); 
                req.setAttribute("GUEN_TYPE" ,  ""); 
                req.setAttribute("print_page_name", WebUtil.ServletURL+"hris.G.G027ApprovalFinishCertiSV?AINF_SEQN="+AINF_SEQN+"&jobid=print_certi_print");
                dest = WebUtil.JspURL+"common/printFrame_Acerti.jsp";

            } else if( jobid.equals("print_certi_print") ) {
                // 재직 증명
                a15CertiData      = (A15CertiData)vcA15CertiData.get(0);
                // 결재자 정보
                PersonData phonenumdata;
                PersonInfoRFC numfunc			=	new PersonInfoRFC();
//              프린트는 1회로 출력을 제한한다.
     //           func.updateFlag(a15CertiData.PERNR, AINF_SEQN);
// 프린트는 1회로 출력을 제한한다.
                A15CertiPrintRFC rfc_print = new A15CertiPrintRFC();
                Map<String, Object> ret         = rfc_print.getDetail("1", a15CertiData.PERNR, AINF_SEQN,"1");
                Vector T_RESULT    = (Vector) ret.get("T_RESULT");
                String E_JUSO_TEXT = (String) ret.get("E_JUSO_TEXT");
                String E_KR_REPRES = (String) ret.get("E_KR_REPRES");

                phonenumdata    =   (PersonData)numfunc.getPersonInfo(a15CertiData.PERNR, "X");
                
                req.setAttribute("PersInfoData" ,phonenumdata );

                req.setAttribute("T_RESULT",    T_RESULT);
                req.setAttribute("E_JUSO_TEXT", E_JUSO_TEXT);
                req.setAttribute("E_KR_REPRES", E_KR_REPRES);

                dest = WebUtil.JspURL+"A/A15Certi/A15CertiPrintCerti.jsp";
                
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