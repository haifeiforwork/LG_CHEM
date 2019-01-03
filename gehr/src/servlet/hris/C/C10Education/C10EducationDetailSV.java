package servlet.hris.C.C10Education;

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

import hris.C.C02Curri.*;
import hris.C.C02Curri.rfc.*;

import hris.C.C10Education.*;
import hris.C.C10Education.rfc.*;

/**
 * C10EducationDetailSV.java
 * 교육과정신청 조회를 할수 있도록 하는 Class
 *
 * @author  김도신   
 * @version 1.0, 2004/05/28
 */
public class C10EducationDetailSV extends EHRBaseServlet {

    private String UPMU_TYPE ="08";

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        Connection con = null;

        try{
            WebUserData user = WebUtil.getSessionUser(req);
            
            String dest      = "";
            String jobid     = "";
            String i_objid_L = "";
            String idx_Radio = "";
            String page      = "";

            Box box = WebUtil.getBox(req);
            jobid = box.get("jobid");

            if( jobid.equals("") ){
                jobid = "first";
            }
            Logger.debug.println(this, "[jobid] = "+jobid + " [user] : "+user.toString());

            i_objid_L = box.get("OBJID_L");           // 비즈니스 이벤트 그룹 ID
//          Page별 Interface 추가
            idx_Radio = box.get("idx_Radio");         // 과정 목록에서 선택된 래디오 버튼
            page      = box.get("page");              // 과정 목록에서 선택된 page

            if( jobid.equals("first") ) {
                C02CurriApplRFC func = new C02CurriApplRFC();
                Vector C02CurriApplData_vt = func.getDetail( box.get("AINF_SEQN") );
                req.setAttribute("C02CurriApplData_vt", C02CurriApplData_vt);
                
    //  XxxDetailSV.java 와 XxxDetail.jsp 에 '목록' 버튼 활성화 여부를 가려주는 부분            
                String ThisJspName = box.get("ThisJspName");
                req.setAttribute("ThisJspName", ThisJspName);
    //  XxxDetailSV.java 와 XxxDetail.jsp 에 '목록' 버튼 활성화 여부를 가려주는 부분 
    
                req.setAttribute("i_objid_L",   i_objid_L);
                req.setAttribute("idx_Radio",   idx_Radio);         // 과정 목록에서 선택된 래디오 버튼
                req.setAttribute("page",        page);              // 과정 목록에서 선택된 page

                
                dest = WebUtil.JspURL+"C/C10Education/C10EducationDetail.jsp";

            } else if( jobid.equals("delete") ) {

                C02CurriApplRFC func           = new C02CurriApplRFC();
                Vector          AppLineData_vt = new Vector();
                String          AINF_SEQN      = box.get("AINF_SEQN");

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
                    func.delete( box.get("AINF_SEQN") );
                    con.commit();

// 2002.07.25.---------------------------------------------------------------------------
//                  신청건 삭제시 메일 보내기.
                    String upmu = "교육과정 신청";
                    MailMgr.sendMailDel(user,AppLineData_vt,upmu);
//                  신청건 삭제시 메일 보내기.
// 2002.07.25.---------------------------------------------------------------------------

                    String msg = "msg003";
                    String url = "location.href = '" + WebUtil.JspURL+"C/C10Education/C10EducationMatrix.jsp';";
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
                    String msg = "결재 이후에는 결재자만 취소할수 있습니다.";
                    String url = "location.href = '" + WebUtil.ServletURL+"hris.C.C10Education.C10EducationDetailSV?AINF_SEQN=" + box.get("AINF_SEQN") + "';";
                    req.setAttribute("msg", msg);
                    req.setAttribute("url", url);
                    dest = WebUtil.JspURL+"common/caution.jsp";
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