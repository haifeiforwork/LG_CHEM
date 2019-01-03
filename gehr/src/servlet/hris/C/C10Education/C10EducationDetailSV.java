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
 * ����������û ��ȸ�� �Ҽ� �ֵ��� �ϴ� Class
 *
 * @author  �赵��   
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

            i_objid_L = box.get("OBJID_L");           // ����Ͻ� �̺�Ʈ �׷� ID
//          Page�� Interface �߰�
            idx_Radio = box.get("idx_Radio");         // ���� ��Ͽ��� ���õ� ����� ��ư
            page      = box.get("page");              // ���� ��Ͽ��� ���õ� page

            if( jobid.equals("first") ) {
                C02CurriApplRFC func = new C02CurriApplRFC();
                Vector C02CurriApplData_vt = func.getDetail( box.get("AINF_SEQN") );
                req.setAttribute("C02CurriApplData_vt", C02CurriApplData_vt);
                
    //  XxxDetailSV.java �� XxxDetail.jsp �� '���' ��ư Ȱ��ȭ ���θ� �����ִ� �κ�            
                String ThisJspName = box.get("ThisJspName");
                req.setAttribute("ThisJspName", ThisJspName);
    //  XxxDetailSV.java �� XxxDetail.jsp �� '���' ��ư Ȱ��ȭ ���θ� �����ִ� �κ� 
    
                req.setAttribute("i_objid_L",   i_objid_L);
                req.setAttribute("idx_Radio",   idx_Radio);         // ���� ��Ͽ��� ���õ� ����� ��ư
                req.setAttribute("page",        page);              // ���� ��Ͽ��� ���õ� page

                
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
//              ��û�� ������ ���� ������ ���� �ʿ��� ������ ������ �����´�.
// 2002.07.25.---------------------------------------------------------------------------

                con             = DBUtil.getTransaction();
                AppLineDB appDB = new AppLineDB(con);
                if( appDB.canUpdate(appLine) ) {
                    appDB.delete(appLine);
                    func.delete( box.get("AINF_SEQN") );
                    con.commit();

// 2002.07.25.---------------------------------------------------------------------------
//                  ��û�� ������ ���� ������.
                    String upmu = "�������� ��û";
                    MailMgr.sendMailDel(user,AppLineData_vt,upmu);
//                  ��û�� ������ ���� ������.
// 2002.07.25.---------------------------------------------------------------------------

                    String msg = "msg003";
                    String url = "location.href = '" + WebUtil.JspURL+"C/C10Education/C10EducationMatrix.jsp';";
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
                    String msg = "���� ���Ŀ��� �����ڸ� ����Ҽ� �ֽ��ϴ�.";
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