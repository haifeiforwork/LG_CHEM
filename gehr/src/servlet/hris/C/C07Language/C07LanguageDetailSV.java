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
 * C07LanguageDetailSV.java
 * ���������ݾ� ��û�� ��ȸ�� �� �ֵ��� �ϴ� Class
 *
 * @author  �赵��
 * @version 1.0, 2003/04/14
 */
public class C07LanguageDetailSV extends EHRBaseServlet {

    private String UPMU_TYPE ="31";            // ���� ����Ÿ��(�������� ��û)

	  protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {
        Connection con = null;

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

            if( jobid.equals("first") ) {           //����ó�� ��û ȭ�鿡 ���°��.

                C07LanguageRFC rfc                = new C07LanguageRFC();
                Vector         c07LanguageData_vt = null;
                Vector         AppLineData_vt     = null;
                String         ainf_seqn          = box.get("AINF_SEQN");
                
                c07LanguageData_vt = rfc.getDetail( user.empNo, ainf_seqn );
                Logger.debug.println(this, "�������� ����ȸ : " + c07LanguageData_vt.toString());
                
//  XxxDetailSV.java �� XxxDetail.jsp �� '���' ��ư Ȱ��ȭ ���θ� �����ִ� �κ�            
                String ThisJspName = box.get("ThisJspName");
                req.setAttribute("ThisJspName", ThisJspName);
//  XxxDetailSV.java �� XxxDetail.jsp �� '���' ��ư Ȱ��ȭ ���θ� �����ִ� �κ� 
          
                AppLineData_vt = AppUtil.getAppDetailVt(ainf_seqn);

                req.setAttribute("c07LanguageData_vt", c07LanguageData_vt);
                req.setAttribute("AppLineData_vt"    , AppLineData_vt);

                dest = WebUtil.JspURL+"C/C07Language/C07LanguageDetail.jsp";

            } else if( jobid.equals("delete") ) {       
                
                /////////////////////////////////////////////////////////////////////////////
                // �������� ����..
                C07LanguageRFC rfc            = new C07LanguageRFC();
                Vector         AppLineData_vt = new Vector();
                String         ainf_seqn      = box.get("AINF_SEQN");
                
                /////////////////////////////////////////////////////////////////////////////
                // �������� ����..
                AppLineData  appLine   = new AppLineData();
                appLine.APPL_MANDT     = user.clientNo;
                appLine.APPL_BUKRS     = user.companyCode;
                appLine.APPL_PERNR     = user.empNo;
                appLine.APPL_UPMU_TYPE = UPMU_TYPE;
                appLine.APPL_AINF_SEQN = box.get("AINF_SEQN");

//              ��û�� ������ ���� ������ ���� �ʿ��� ������ ������ �����´�.
//              ����
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

                con             = DBUtil.getTransaction();
                AppLineDB appDB = new AppLineDB(con);
                
                if( appDB.canUpdate(appLine) ) {
                    appDB.delete(appLine);
                    rfc.delete(user.empNo, ainf_seqn );
                    con.commit();

//                  ��û�� ������ ���� ������.
                    String upmu = "�������� ��û";
                    MailMgr.sendMailDel(user,AppLineData_vt,upmu);

                    String msg = "msg003";
                    String url = "location.href = '" + WebUtil.ServletURL+"hris.C.C07Language.C07LanguageBuildSV';";
//  ���� ������ ������ �������� �̵��ϱ� ���� ����            
                    String ThisJspName = box.get("ThisJspName");
                    if( ThisJspName.equals("A16ApplList.jsp") ){
                        url = "location.href = '" + WebUtil.ServletURL+"hris.A.A16Appl.A16ApplListSV';";
                    }
//  ���� ������ ������ �������� �̵��ϱ� ���� ����            
                    req.setAttribute("msg", msg);
                    req.setAttribute("url", url);
                    dest = WebUtil.JspURL+"common/msg.jsp";
                } else {
                    String msg = "msg005";
                    String url = "location.href = '" + WebUtil.ServletURL+"hris.C.C07Language.C07LanguageDetailSV?AINF_SEQN="+ainf_seqn+"';";
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
