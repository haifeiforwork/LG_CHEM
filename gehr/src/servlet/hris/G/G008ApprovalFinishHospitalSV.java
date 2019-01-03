/********************************************************************************/
/*                                                                              */
/*   System Name  : e-HR                                                        */
/*   1Depth Name  : HR 결재함                                                   */
/*   2Depth Name  : 결재 완료 문서                                              */
/*   Program Name : 의료비 신청                                                 */
/*   Program ID   : G008ApprovalFinishHospitalSV                                */
/*   Description  : 의료비 신청 결재 완료                                       */
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
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;
import hris.E.E17Hospital.E17HospitalResultData;
import hris.E.E17Hospital.E17SickData;
import hris.E.E17Hospital.rfc.E17HospitalRFC;
import hris.E.E17Hospital.rfc.E17MedicCheckYNRFC;
import hris.E.E18Hospital.E18HospitalListData;
import hris.E.E18Hospital.rfc.E18HospitalListRFC;
import hris.common.PersInfoData;
import hris.common.WebUserData;
import hris.common.rfc.PersInfoWithNoRFC;
import hris.common.util.AppUtil;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.Vector;


public class G008ApprovalFinishHospitalSV extends EHRBaseServlet 
{

	protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        try{
            HttpSession session = req.getSession(false);
            WebUserData user = WebUtil.getSessionUser(req);

            Vector              vcAppLineData;
            E17SickData         e17SickData;
            E17HospitalResultData returnAll;
            Vector              vcE17SickData;
            Vector              vcE17HospitalData;
            
            
            String dest  = "";
            String jobid = "";
            Box box = WebUtil.getBox(req);
            
            String  AINF_SEQN  = box.get("AINF_SEQN");
            
            String RequestPageName = box.get("RequestPageName");
            req.setAttribute("RequestPageName", RequestPageName);
            
            jobid = box.get("jobid");
            if(jobid == null || jobid.equals("") ){
                jobid = "search";
            }// end if

            if( jobid.equals("search") ) {

                E17HospitalRFC      rfc                = new E17HospitalRFC();
                PersInfoWithNoRFC   piRfc              = new PersInfoWithNoRFC();
                Vector              E17BillData_vt;
                
                String             l_CTRL_NUMB         = "";
                String             P_Flag              = "";
                double            dWCOMP_SUM            = 0.0;
                double            dSCOMP_SUM            = 0.0;
                

                returnAll = rfc.detail();
                Logger.debug.println(this, returnAll);

                vcE17SickData       = (Vector)returnAll.T_ZHRA006T;
                vcE17HospitalData   = (Vector)returnAll.T_ZHRW005A;
                vcAppLineData       = AppUtil.getAppChangeVt(AINF_SEQN);

                if(vcE17SickData.size() < 1){
                    String msg = "조회될 항목의 데이터를 읽어들이던 중 오류가 발생했습니다.";
                    String url = "history.back();";
                    req.setAttribute("msg", msg);
                    req.setAttribute("url", url);
                    dest = WebUtil.JspURL+"common/msg.jsp";
                }else{
                    e17SickData = (E17SickData)vcE17SickData.get(0);
                    
                    E17MedicCheckYNRFC checkYN = new E17MedicCheckYNRFC();
                    P_Flag  = checkYN.getE_FLAG( DataUtil.getCurrentYear(), e17SickData.PERNR );
                   
                    //  회사지원 총액을 보여주기 위해서 총액을 계산한다.
                    E18HospitalListRFC func_E18            = new E18HospitalListRFC();
                    Vector             E18HospitalData_vt  = new Vector();
                    E18HospitalData_vt = func_E18.getHospitalList( e17SickData.PERNR) ;
                    
                    for ( int i = 0 ; i < E18HospitalData_vt.size() ; i++ ) {
                        E18HospitalListData data_18 = ( E18HospitalListData ) E18HospitalData_vt.get( i ) ;
                        l_CTRL_NUMB = data_18.CTRL_NUMB.substring(0, 4);
                        if( data_18.GUEN_CODE.equals("0001") && l_CTRL_NUMB.equals(e17SickData.BEGDA.substring(0, 4)) ) {
                            dSCOMP_SUM = dSCOMP_SUM + Double.parseDouble( data_18.COMP_WONX );
                        } else if( data_18.GUEN_CODE.equals("0002") && l_CTRL_NUMB.equals(e17SickData.BEGDA.substring(0, 4)) ) {
                            dWCOMP_SUM = dWCOMP_SUM + Double.parseDouble( data_18.COMP_WONX );
                        } // end if
                    } // end for
                    
                    PersInfoData    pid = (PersInfoData) piRfc.getApproval(e17SickData.PERNR).get(0);
                    
                    req.setAttribute("PersInfoData" ,pid );
                    req.setAttribute("e17SickData"       , e17SickData);
                    req.setAttribute("vcE17HospitalData", vcE17HospitalData);
                    req.setAttribute("vcAppLineData"     , vcAppLineData);
                    
                    req.setAttribute("P_Flag"           , P_Flag);
                    req.setAttribute("WCOMP_SUM"        , Double.toString(dWCOMP_SUM));
                    req.setAttribute("SCOMP_SUM"        , Double.toString(dSCOMP_SUM));
                    
                    dest = WebUtil.JspURL+"G/G008ApprovalFinishHospital.jsp";
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