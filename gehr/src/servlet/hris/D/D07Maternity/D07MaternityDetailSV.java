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

/**
 * D07MaternityDetailSV.java
 * 산전후 휴가신청에 대한 상세내용을 조회하여 D07MaternityDetail.jsp 값을 넘겨주는 class
 * jobid가 first일 경우는 AppLineDB.class를 호출하여 값을 jsp페이지로 넘겨주고,
 * jobid가 delete일 경우는 AppLineDB.class를 호출하여 DB에 값을 delete 시킨다.
 *
 * @author  김도신   
 * @version 1.0, 2004/10/27
 **/
public class D07MaternityDetailSV extends EHRBaseServlet {

    private String UPMU_TYPE ="32";            // 결재 업무타입(산전후 휴가신청)

	protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        Connection con = null;

        try{
            HttpSession session = req.getSession(false);
            WebUserData user = WebUtil.getSessionUser(req);

            String dest         = "";
            String jobid        = "";

            Box box = WebUtil.getBox(req);
            jobid = box.get("jobid");
            if( jobid.equals("") ){
                jobid = "first";
            }
            Logger.debug.println(this, "[jobid] = "+jobid + " [user] : "+user.toString());
            
            if( jobid.equals("first") ) {
                
                D03VocationRFC rfc                 = new D03VocationRFC();
                Vector         d03VocationData_vt  = null;
                Vector         AppLineData_vt      = null;
                String         ainf_seqn           = box.get("AINF_SEQN");
                
                // 산전후 휴가신청 조회
                d03VocationData_vt = rfc.getVocation( user.empNo, ainf_seqn );

//  XxxDetailSV.java 와 XxxDetail.jsp 에 '목록' 버튼 활성화 여부를 가려주는 부분            
                String ThisJspName = box.get("ThisJspName");
                req.setAttribute("ThisJspName", ThisJspName);
//  XxxDetailSV.java 와 XxxDetail.jsp 에 '목록' 버튼 활성화 여부를 가려주는 부분 
          
                // 결재자리스트
                AppLineData_vt = AppUtil.getAppDetailVt(ainf_seqn);

                req.setAttribute("d03VocationData_vt", d03VocationData_vt);
                req.setAttribute("AppLineData_vt", AppLineData_vt);

                dest = WebUtil.JspURL+"D/D07Maternity/D07MaternityDetail.jsp";

            } else if( jobid.equals("delete") ) {
                
                /////////////////////////////////////////////////////////////////////////////
                // 산전후 휴가신청 삭제..
                D03VocationRFC rfc            = new D03VocationRFC();
                Vector         AppLineData_vt = new Vector();
                String         ainf_seqn      = box.get("AINF_SEQN");
                
                // 결재정보 삭제..
                AppLineData  appLine = new AppLineData();
                appLine.APPL_MANDT     = user.clientNo;
                appLine.APPL_BUKRS     = user.companyCode;
                appLine.APPL_PERNR     = user.empNo;
                appLine.APPL_UPMU_TYPE = UPMU_TYPE;
                appLine.APPL_AINF_SEQN = box.get("AINF_SEQN");

// 2002.07.25.---------------------------------------------------------------------------
//              신청건 삭제시 메일 보내기 위해 필요한 결재자 정보를 가져온다.
//              결재
                int rowcount = box.getInt("RowCount");
                for( int i = 0; i < rowcount; i++) {
                    AppLineData app = new AppLineData();
                    String      idx     = Integer.toString(i);

                    app.APPL_APPR_SEQN = box.get("APPL_APPR_SEQN"+idx);
                    app.APPL_APPU_TYPE = box.get("APPL_APPU_TYPE"+idx);
                    app.APPL_APPU_NUMB = box.get("APPL_APPU_NUMB"+idx);
                    
                    AppLineData_vt.addElement(app);
                }
                Logger.debug.println(this, "AppLineData : " + AppLineData_vt.toString());
//              신청건 삭제시 메일 보내기 위해 필요한 결재자 정보를 가져온다.
// 2002.07.25.---------------------------------------------------------------------------

                con             = DBUtil.getTransaction();
                AppLineDB appDB = new AppLineDB(con);
                
                if( appDB.canUpdate(appLine) ) {
                    appDB.delete(appLine);
                    rfc.delete( user.empNo, ainf_seqn );
                    con.commit();

// 2002.07.25.---------------------------------------------------------------------------
//                  신청건 삭제시 메일 보내기.
                    String upmu = "산전후 휴가신청";
                    MailMgr.sendMailDel(user,AppLineData_vt,upmu);
//                  신청건 삭제시 메일 보내기.
// 2002.07.25.---------------------------------------------------------------------------

                    String msg = "msg003";
                    String url = "location.href = '" + WebUtil.ServletURL+"hris.D.D07Maternity.D07MaternityBuildSV';";
//  삭제 실행후 삭제전 페이지로 이동하기 위한 구분            
                    String ThisJspName = box.get("ThisJspName");
                    if( ThisJspName.equals("A16ApplList.jsp") ){
                        url = "location.href = '" + WebUtil.ServletURL+"hris.A.A16Appl.A16ApplListSV';";
                    }
//  삭제 실행후 삭제전 페이지로 이동하기 위한 구분            
                    req.setAttribute("msg", msg);
                    req.setAttribute("url", url);
                    dest = WebUtil.JspURL+"common/msg.jsp";
                } else {
                    String msg = "msg005";
                    String url = "location.href = '" + WebUtil.ServletURL+"hris.D.D07Maternity.D07MaternityDetailSV?AINF_SEQN="+ainf_seqn+"';";
                    req.setAttribute("msg", msg);
                    req.setAttribute("url", url);
                    dest = WebUtil.JspURL+"common/msg.jsp";
                }
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