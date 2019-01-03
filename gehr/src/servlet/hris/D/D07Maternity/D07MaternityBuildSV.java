package servlet.hris.D.D07Maternity;

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
import hris.D.D03Vocation.*;
import hris.D.D03Vocation.rfc.*;
import hris.D.*;
import hris.D.rfc.*;

/**
 * D07MaternityBuildSV.java
 * 산전후 휴가를 신청할 수 있도록 하는 Class
 *
 * @author  김도신   
 * @version 1.0, 2004/10/26
 */
public class D07MaternityBuildSV extends EHRBaseServlet {

    private String UPMU_TYPE ="32";            // 결재 업무타입(산전후 휴가신청)

	  protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        /*Connection con = null;

        try{
            WebUserData user = WebUtil.getSessionUser(req);
            
            String dest = "";
            String jobid = "";

            Box box = WebUtil.getBox(req);
            jobid = box.get("jobid");
            if( jobid.equals("") ){
                jobid = "first";
            }
            Logger.debug.println(this, "[jobid] = "+jobid + " [user] : "+user.toString());

            if( jobid.equals("first") ) {               //제일처음 신청 화면에 들어온경우.

                Vector AppLineData_vt = null;
                
                // 결재자리스트
                AppLineData_vt = AppUtil.getAppVector( user.empNo, UPMU_TYPE );

                req.setAttribute("jobid",                 jobid);
                req.setAttribute("AppLineData_vt",        AppLineData_vt);

                dest = WebUtil.JspURL+"D/D07Maternity/D07MaternityBuild.jsp";

            } else if( jobid.equals("create") ) {       //산전후 휴가 신청
                
                NumberGetNextRFC      func                  = new NumberGetNextRFC();
                D03VocationRFC        rfc                   = new D03VocationRFC();
                D03VocationData       d03VocationData       = new D03VocationData();

                Vector                d03VocationData_vt    = new Vector();
                Vector                AppLineData_vt        = new Vector();
                String                ainf_seqn             = func.getNumberGetNext();
                
//              << 산전후 휴가 정보 >>
                d03VocationData.AINF_SEQN   = ainf_seqn;                // 결재정보 일련번호   
                d03VocationData.PERNR       = user.empNo;    				    // 사원번호          
                d03VocationData.BEGDA       = box.get("BEGDA");         // 신청일
                d03VocationData.AWART       = box.get("AWART");         // 근무/휴무 유형 - 산전산후휴가
                d03VocationData.APPL_FROM   = box.get("APPL_FROM");   	// 휴가시작일
                d03VocationData.APPL_TO     = box.get("APPL_TO");       // 휴가종료일
                d03VocationData.RMDDA       = box.get("RMDDA");         // 출산예정일
//              달력일수, 휴무일수을 저장한다.
                d03VocationData.DEDUCT_DATE = box.get("DEDUCT_DATE");   // 휴무일수
                d03VocationData.PBEZ4       = box.get("PBEZ4");         // 달력일수
//              << 결재자 정보 >>
                int rowcount = box.getInt("RowCount");
                for( int i = 0; i < rowcount; i++) {
                    AppLineData appLine = new AppLineData();
                    String      idx     = Integer.toString(i);

                    appLine.APPL_MANDT     = user.clientNo;
                    appLine.APPL_BUKRS     = user.companyCode;
                    appLine.APPL_PERNR     = user.empNo;
                    appLine.APPL_BEGDA     = d03VocationData.BEGDA;;
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

                con = DBUtil.getTransaction();

                AppLineDB appDB    = new AppLineDB(con);
                appDB.create(AppLineData_vt);

                rfc.build(user.empNo, ainf_seqn, d03VocationData);
                con.commit();
                
                String upmu = "산전후 휴가 신청";
                MailMgr.sendMail(user,AppLineData_vt,upmu);
                
                String msg = "msg001";
                String url = "location.href = '" + WebUtil.ServletURL+"hris.D.D07Maternity.D07MaternityDetailSV?AINF_SEQN="+ainf_seqn+"';";
                req.setAttribute("msg", msg);
                req.setAttribute("url", url);

                dest = WebUtil.JspURL+"common/msg.jsp";
            } else {
                throw new BusinessException("내부명령(jobid)이 올바르지 않습니다.");
            }
            Logger.debug.println(this, " destributed = " + dest);
            printJspPage(req, res, dest);

        } catch(Exception e) {
            throw new GeneralException(e);
        } finally {
            DBUtil.close(con);
        }*/
	  }
}
