/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 개인연금                                                    */
/*   Program Name : 개인연금/마이라이프 조회                                    */
/*   Program ID   : E11PersonalDetailSV                                         */
/*   Description  : 개인연금/마이라이프를 조회하여 jsp로 넘겨주는 class         */
/*   Note         :                                                             */
/*   Creation     : 2002-02-01  박영락                                          */
/*   Update       : 2005-02-21  윤정현                                          */
/*                                                                              */
/********************************************************************************/

package servlet.hris.E.E11Personal;

import java.util.Vector;
import javax.servlet.http.*;

import com.sns.jdf.*;
import com.sns.jdf.util.*;
import com.sns.jdf.servlet.*;

import hris.E.E11Personal.E11PersonalData;
import hris.E.E11Personal.rfc.*;
import hris.common.PersonData;
import hris.common.WebUserData;
import hris.common.rfc.PersonInfoRFC;

public class E11PersonalDetailSV extends EHRBaseServlet {
    
    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        try{
            
            HttpSession session = req.getSession(false);
            WebUserData user   = (WebUserData)session.getAttribute("user");
            
            String jobid = "";
            String dest = "";
            String PERNR;
            
            Box box = WebUtil.getBox(req);
            jobid = box.get("jobid");
            
            if( jobid.equals("") ){
                jobid = "first";
            }
            Logger.debug.println(this, "[jobid] = "+jobid + " [user] : "+user.toString());
            
            PERNR = box.get("PERNR");
            if (PERNR == null || PERNR.equals("")) {
                PERNR = user.empNo;
            } // end if

            // 대리 신청 추가
            PersonInfoRFC numfunc = new PersonInfoRFC();
            PersonData phonenumdata;
            phonenumdata = (PersonData)numfunc.getPersonInfo(PERNR);
            
            req.setAttribute("PERNR" , PERNR );
            req.setAttribute("PersonData" , phonenumdata );
           
            if( jobid.equals("first") ) {
                
                E11PersonalDetailRFC func1              = new E11PersonalDetailRFC();
                Vector               E11PersonalData_vt = func1.getDetail(PERNR, "", "");
                
                Logger.debug.println(this, E11PersonalData_vt.toString() );
                
                req.setAttribute("E11PersonalData_vt", E11PersonalData_vt);
                
                dest = WebUtil.JspURL+"E/E11Personal/E11PersonalList.jsp";
                
            } else if( jobid.equals("detail") ) {
                
                E11PersonalData      detailData = new E11PersonalData();
                E11PersonalDetailRFC func1      = new E11PersonalDetailRFC();
                
                Vector E11PersonalData_vt = func1.getDetail(PERNR, box.get("PENT_TYPE"), box.get("ENTR_DATE"));
                
                if( E11PersonalData_vt.size() > 0 ) {
                    detailData  = (E11PersonalData)E11PersonalData_vt.get(0);
                }
                
                Logger.debug.println(this, E11PersonalData_vt.toString() );
                
                req.setAttribute("detailData", detailData);
                
                dest = WebUtil.JspURL+"E/E11Personal/E11PersonalDetail.jsp";
                
            } else {
                throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
            }
            
            printJspPage(req, res, dest);
            Logger.debug.println(this, " destributed = " + dest);
        } catch(Exception e) {
            throw new GeneralException(e);
        } 
    }
}
