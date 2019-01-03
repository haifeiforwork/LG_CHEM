/********************************************************************************/
/*   System Name   : e-HR                                                                                                                         */
/*   1Depth Name   : HR 결재함                                                                                                                */
/*   2Depth Name   : 결재 완료 문서                                                                                                        */
/*   Program Name : 경력 증명 신청                                                                                                        */
/*   Program ID      : G065ApprovalFinishCareerSV                                                                                       */
/*   Description       : 경력 증명 신청 결재 완료                                                                                       */
/*   Note                : 없음                                                                                                                         */
/*   Creation          : 2006-04-17  김대영                                                                                                   */
/*   Update       :                                                                                                                                       */
/*                                                                                                                                                           */
/********************************************************************************/

package servlet.hris.G;

import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;
import hris.A.A09CareerDetailData;
import hris.A.A15Certi.rfc.A15CertiPrintRFC;
import hris.A.A19Career.A19CareerData;
import hris.A.A19Career.rfc.A19CareerRFC;
import hris.A.rfc.A09CareerDetailRFC;
import hris.G.rfc.BizPlaceDataRFC;
import hris.G.rfc.StellRFC;
import hris.common.MappingPernrData;
import hris.common.PersInfoData;
import hris.common.PersonData;
import hris.common.WebUserData;
import hris.common.rfc.MappingPernrRFC;
import hris.common.rfc.PersInfoWithNoRFC;
import hris.common.rfc.PersonInfoRFC;
import hris.common.util.AppUtil;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.Map;
import java.util.Vector;


public class G065ApprovalFinishCareerSV extends EHRBaseServlet 
{
    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
    	
        
        try{
            HttpSession session = req.getSession(false);
            WebUserData user = WebUtil.getSessionUser(req);
            
            Vector  vcAppLineData;
            Vector  vcA19CareerData; 
            
            A19CareerData  a19CareerData;
            
            String dest  = "";
            String jobid = "";
            String bankflag  = "01";
            
            Box box = WebUtil.getBox(req);
            
            String  AINF_SEQN  = box.get("AINF_SEQN");
            
            // 처리 후 돌아 갈 페이지
            String RequestPageName = box.get("RequestPageName");
            req.setAttribute("RequestPageName", RequestPageName);
            
            jobid = box.get("jobid");
            String PRINT_GUBUN = box.get("PRINT_GUBUN");
            
            if(jobid == null || jobid.equals("") ){
                jobid = "search";
            }// end if
            
            if( jobid.equals("search") ) {

                A19CareerRFC func = new A19CareerRFC();
                
                vcA19CareerData = func.getDetail();
                Logger.debug.println(this, vcA19CareerData);
                
                if( vcA19CareerData.size() < 1 ){
                    String msg = "System Error! \n\n 조회할 항목이 없습니다.";
                    req.setAttribute("msg", msg);
                    dest = WebUtil.JspURL+"common/caution.jsp";
                }else{
                    // 경력 증명
                    a19CareerData      = (A19CareerData)vcA19CareerData.get(0);
                    // 결재자 정보
                    vcAppLineData = AppUtil.getAppChangeVt(AINF_SEQN);
                    
                    PersInfoWithNoRFC   piRfc   = new PersInfoWithNoRFC();
                    PersInfoData        pid     = (PersInfoData) piRfc.getApproval(a19CareerData.PERNR).get(0);
                    req.setAttribute("PersInfoData" ,pid );
                    
                    // 사업장 주소 가져오기
                    Vector vcBizPlaceCodeEntity =  (new BizPlaceDataRFC()).getBizPlacesCodeEntity(a19CareerData.PERNR ,"16");
                         
                    // 직무 코드 가져오기
                    Vector vcStellCodeEntity = (Vector) (new StellRFC()).getStellCodeEntity();
                    
                    req.setAttribute("a19CareerData", a19CareerData);
                    req.setAttribute("vcAppLineData" , vcAppLineData);
                    req.setAttribute("vcBizPlaceCodeEntity" , vcBizPlaceCodeEntity);
                    req.setAttribute("vcStellCodeEntity" , vcStellCodeEntity);
                    
                    dest = WebUtil.JspURL+"G/G065ApprovalFinishCareer.jsp.delete";
                } // end if
            } else if( jobid.equals("print_certi") ) {               //새창띠움(빈페이지)

                A19CareerRFC func = new A19CareerRFC();
                vcA19CareerData = func.getDetail();
                // 경력 증명
                a19CareerData    = (A19CareerData)vcA19CareerData.get(0);
                req.setAttribute("AINF_SEQN", AINF_SEQN);
                req.setAttribute("PERNR" ,       a19CareerData.PERNR );
                req.setAttribute("MENU" ,      "CAREER"); 
                req.setAttribute("GUEN_TYPE" ,  PRINT_GUBUN); 
                
                req.setAttribute("print_page_name", WebUtil.ServletURL+"hris.G.G065ApprovalFinishCareerSV?AINF_SEQN="+AINF_SEQN+"&jobid=print_certi_print");
                dest = WebUtil.JspURL+"common/printFrame_Acerti.jsp";

            } else if( jobid.equals("print_certi_print") ) {

                A19CareerRFC func = new A19CareerRFC();
                              
                A15CertiPrintRFC rfc_print = new A15CertiPrintRFC();
                
                vcA19CareerData = func.getDetail();

                Logger.debug.println(this,"dddd:"+ vcA19CareerData);
                a19CareerData      = (A19CareerData)vcA19CareerData.get(0);
//              프린트는 1회로 출력을 제한한다.
               // func.updateFlag(a19CareerData.PERNR, AINF_SEQN);
// 프린트는 1회로 출력을 제한한다.
                Map<String, Object> ret         = rfc_print.getDetail("2", a19CareerData.PERNR, AINF_SEQN,"1");
                Vector T_RESULT    = (Vector) ret.get("T_RESULT");
                String E_JUSO_TEXT = (String) ret.get("E_JUSO_TEXT");
                String E_KR_REPRES = (String) ret.get("E_KR_REPRES");
                
                PersonData phonenumdata;
                PersonInfoRFC numfunc			=	new PersonInfoRFC();
                phonenumdata    =   (PersonData)numfunc.getPersonInfo(a19CareerData.PERNR,"X");
               
                //이동발령 신청시 개인 경력사항 

                MappingPernrRFC  mapfunc = null ;
                MappingPernrData mapData = new MappingPernrData();
                Vector mapData_vt    = new Vector() ;
                Vector careerData_vt = new Vector() ;                
                mapfunc    = new MappingPernrRFC() ;
                mapData_vt = mapfunc.getPernr( a19CareerData.PERNR ) ;

                Vector             a09CareerDetailData_vt = new Vector();
                A09CareerDetailRFC func1                  = null;
                if ( mapData_vt != null && mapData_vt.size() > 0 ) {  // 재입사자 처리
                    A09CareerDetailData data = new A09CareerDetailData();

                    for ( int i=0; i < mapData_vt.size(); i++) {
                        mapData = (MappingPernrData)mapData_vt.get(i);

                        func1         = new A09CareerDetailRFC() ;
                        careerData_vt = func1.getCareerDetail( mapData.PERNR , "" ) ;

                        for( int j = 0 ; j < careerData_vt.size() ; j++ ) {
                            data = (A09CareerDetailData)careerData_vt.get(j);
                            a09CareerDetailData_vt.addElement(data);
                        }
                    }
                } else {
                    func1                  = new A09CareerDetailRFC();
                    a09CareerDetailData_vt = func1.getCareerDetail(a19CareerData.PERNR , "");
                }

                Logger.debug.println(this, "a09CareerDetailData_vt : "+ a09CareerDetailData_vt.toString());
                req.setAttribute("a09CareerDetailData_vt", a09CareerDetailData_vt);              
                //              이동발령 신청시 개인 경력사항 

                req.setAttribute("a19CareerData", a19CareerData);
                req.setAttribute("PersInfoData" ,phonenumdata );
                req.setAttribute("T_RESULT",    T_RESULT);
                req.setAttribute("E_JUSO_TEXT", E_JUSO_TEXT);
                req.setAttribute("E_KR_REPRES", E_KR_REPRES);


                if (PRINT_GUBUN.equals("2")) {
                    dest = WebUtil.JspURL+"A/A19Career/A19CareerPrintCareer02.jsp";
                } else {
                	dest = WebUtil.JspURL+"A/A19Career/A19CareerPrintCareer01.jsp";
                }
                
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