/******************************************************************************/
/*                                                                              */
/*   System Name  : ESS                                                         */
/*   1Depth Name  : HR 결재함                                               */
/*   2Depth Name  : 퇴직연금 신청 결재                                           */
/*   Program Name : 퇴직연금 신청 결재                              */
/*   Program ID   : G077ApprovalFinishRetireRegistSV                                         */
/*   Description  : 퇴직연금 신청 결재 완료                             */
/*   Note         :                                               */
/*   Creation     : 2010-07-07 박민영                                           */
/*   Update       : 2010-07-12 siyakim                                                            */
/*                                                                              */
/*                                                                              */
/********************************************************************************/

package servlet.hris.G;

import hris.E.E03Retire.E03RetireRegistInfoData;
import hris.E.E03Retire.rfc.E03RetireBusinessListRFC;
import hris.E.E03Retire.rfc.E03RetireMBegdaRFC;
import hris.E.E03Retire.rfc.E03RetireRegistRFC;
import hris.E.E03Retire.rfc.E03RetireRegistResnRFC;
import hris.common.PersInfoData;
import hris.common.WebUserData;
import hris.common.rfc.PersInfoWithNoRFC;
import hris.common.util.AppUtil;

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

public class G077ApprovalFinishRetireRegistSV extends EHRBaseServlet
{
    private String UPMU_TYPE ="51";	//업무유형코드
    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        try{
            HttpSession session = req.getSession(false);
            WebUserData user = WebUtil.getSessionUser(req);

            Vector          vcAppLineData      = null;
            Vector          e03RetireRegistInfoData_vt = null;
            E03RetireRegistInfoData e03RetireRegistInfoData    = null;

            String dest  = "";
            String jobid = "";

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
            	//시작일 입력란 유/무
            	String m_begda = new E03RetireMBegdaRFC().getRetireMBegdaInfo(UPMU_TYPE);
            	req.setAttribute("m_begda" ,m_begda );
            	
	            E03RetireRegistInfoData    RegistData    = new E03RetireRegistInfoData();
	            E03RetireRegistRFC      rfc       = new E03RetireRegistRFC();
	            
	            Vector E03RetireRegistData_vt  = null;
	            
	            //신청 정보
	            E03RetireRegistData_vt = rfc.detail(AINF_SEQN);
	            
	            if(E03RetireRegistData_vt.size() > 0)
	            	RegistData = (E03RetireRegistInfoData)E03RetireRegistData_vt.get(0);
	            
	            Logger.debug.println(this, "E03RetireRegistData_vt : " + E03RetireRegistData_vt.toString());
            	            
	            vcAppLineData = AppUtil.getAppChangeVt(AINF_SEQN);

                if(E03RetireRegistData_vt.size() < 1){
                    String msg = "조회될 항목의 데이터를 읽어들이던 중 오류가 발생했습니다.";
                    String url = "history.back();";
                    req.setAttribute("msg", msg);
                    req.setAttribute("url", url);
                    dest = WebUtil.JspURL+"common/msg.jsp";
                }else{
                	//퇴직연금 코드 리스트
                    Vector ResnList_vt = new E03RetireRegistResnRFC().getRetireTypeList();
                    // 결재자리스트
                    Logger.debug.println(this, "AppLineData_vt : "+ vcAppLineData.toString());
                    
                    PersInfoData  pid = (PersInfoData)new PersInfoWithNoRFC().getApproval(RegistData.PERNR).get(0);

                    req.setAttribute("PersInfoData" ,pid );
                    
                    req.setAttribute("ResnList_vt", ResnList_vt);
                    req.setAttribute("RegistInfoData", RegistData);                //변경신청 내용
                    req.setAttribute("AppLineData_vt", vcAppLineData);

    	          	//DC인 경우 선택하는 연금 사업자 리스트
                    Vector BusinessList_vt = new E03RetireBusinessListRFC().getRetireBusinessList(user.companyCode);   
                    req.setAttribute("BusinessList_vt", BusinessList_vt);      
                    
                    dest = WebUtil.JspURL+"G/G077ApprovalFinishRetireRegist.jsp";
                } // end if
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