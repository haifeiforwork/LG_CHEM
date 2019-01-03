package servlet.hris.C.C07Language;

import java.io.*;
import java.sql.*;
import java.util.Vector;
import javax.servlet.*;
import javax.servlet.http.*;

import com.sns.jdf.*;
import com.sns.jdf.db.*;
import com.sns.jdf.util.*;
import com.sns.jdf.servlet.*;

import hris.common.*;
import hris.common.db.*;
import hris.common.mail.*;
import hris.common.util.*;
import hris.common.rfc.*;
import hris.C.C07Language.*;
import hris.C.C07Language.rfc.*;

/**
 * C07LanguageBuildSV.java
 * 어학지원금액을 신청할 수 있도록 하는 Class
 *
 * @author  김도신
 * @version 1.0, 2003/04/14
 * 2018/07/25 rdcamel 사용 안함
 */
public class C07LanguageBuildSV extends EHRBaseServlet {

    private String UPMU_TYPE ="31";            // 결재 업무타입(어학지원 신청)

	  protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {
        Connection con = null;

        try {
            WebUserData user = WebUtil.getSessionUser(req);
            
            String dest = "";
            String jobid = "";

            Box box = WebUtil.getBox(req);
            jobid = box.get("jobid");
            if( jobid.equals("") ) {
                jobid = "first";
            }
            Logger.debug.println(this, "[jobid] = "+jobid + " [user] : "+user.toString());

            if( jobid.equals("first") ) {           //제일처음 신청 화면에 들어온경우.

                Vector AppLineData_vt     = null;
                Vector c07LangDupCheck_vt = null;
                
//              결재자리스트
                AppLineData_vt = AppUtil.getAppVector( user.empNo, UPMU_TYPE );
                                    
//              어학지원의 중복신청을 막기위해서 .jsp에서 처리함.
                c07LangDupCheck_vt = (new C07LangDupCheckRFC()).getCheckList( user.empNo );

                req.setAttribute("AppLineData_vt",     AppLineData_vt);
                req.setAttribute("c07LangDupCheck_vt", c07LangDupCheck_vt);

                dest = WebUtil.JspURL+"C/C07Language/C07LanguageBuild.jsp";
                
            } else if( jobid.equals("create") ) {       
                
                NumberGetNextRFC func            = new NumberGetNextRFC();
                C07LanguageRFC   rfc             = new C07LanguageRFC();
                C07LanguageData  c07LanguageData = new C07LanguageData();
                Vector           AppLineData_vt  = new Vector();
                String           ainf_seqn       = func.getNumberGetNext();
                                                
                box.copyToEntity(c07LanguageData);
                c07LanguageData.AINF_SEQN = ainf_seqn;    				                  // 결재정보 일련번호
                c07LanguageData.PERNR     = user.empNo;    				                  // 사원번호         
                
                Logger.debug.println(this, "어학지원 신청 = " + c07LanguageData.toString());

                // 결재정보 저장..
                int rowcount = box.getInt("RowCount");
                for( int i = 0; i < rowcount; i++ ) {
                    AppLineData appLine = new AppLineData();
                    String      idx     = Integer.toString(i);

                    appLine.APPL_MANDT     = user.clientNo;
                    appLine.APPL_BUKRS     = user.companyCode;
                    appLine.APPL_PERNR     = user.empNo;
                    appLine.APPL_BEGDA     = c07LanguageData.BEGDA;
                    appLine.APPL_AINF_SEQN = ainf_seqn;
                    appLine.APPL_UPMU_FLAG = box.get("APPL_UPMU_FLAG"+idx);
                    appLine.APPL_UPMU_TYPE = UPMU_TYPE;
                    appLine.APPL_APPR_TYPE = box.get("APPL_APPR_TYPE"+idx);
                    appLine.APPL_APPU_TYPE = box.get("APPL_APPU_TYPE"+idx);
                    appLine.APPL_APPR_SEQN = box.get("APPL_APPR_SEQN"+idx);
                    appLine.APPL_OTYPE     = box.get("APPL_OTYPE"+idx);
                    appLine.APPL_OBJID     = box.get("APPL_OBJID"+idx);
                    appLine.APPL_APPU_NUMB = box.get("APPL_APPU_NUMB"+idx);

                    AppLineData_vt.addElement(appLine);
                }
                Logger.debug.println(this, AppLineData_vt.toString());

                con = DBUtil.getTransaction();

                AppLineDB appDB    = new AppLineDB(con);
                appDB.create(AppLineData_vt);
                rfc.build( user.empNo, ainf_seqn , c07LanguageData );
                con.commit();
                
                String upmu = "어학지원 신청";
                MailMgr.sendMail(user,AppLineData_vt,upmu);

                String msg = "msg001";
                String url = "location.href = '" + WebUtil.ServletURL+"hris.C.C07Language.C07LanguageDetailSV?AINF_SEQN="+ainf_seqn+"';";
                
                req.setAttribute("msg", msg);
                req.setAttribute("url", url);
                
                dest = WebUtil.JspURL+"common/msg.jsp";

            } else {
                throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
            }
            Logger.debug.println(this, " destributed = " + dest);
            printJspPage(req, res, dest);

        } catch(Exception e) {
            throw new GeneralException(e);
        } finally {
            DBUtil.close(con);
        }
	  }
}
