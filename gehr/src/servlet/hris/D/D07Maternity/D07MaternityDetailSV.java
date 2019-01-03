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
 * ������ �ް���û�� ���� �󼼳����� ��ȸ�Ͽ� D07MaternityDetail.jsp ���� �Ѱ��ִ� class
 * jobid�� first�� ���� AppLineDB.class�� ȣ���Ͽ� ���� jsp�������� �Ѱ��ְ�,
 * jobid�� delete�� ���� AppLineDB.class�� ȣ���Ͽ� DB�� ���� delete ��Ų��.
 *
 * @author  �赵��   
 * @version 1.0, 2004/10/27
 **/
public class D07MaternityDetailSV extends EHRBaseServlet {

    private String UPMU_TYPE ="32";            // ���� ����Ÿ��(������ �ް���û)

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
                
                // ������ �ް���û ��ȸ
                d03VocationData_vt = rfc.getVocation( user.empNo, ainf_seqn );

//  XxxDetailSV.java �� XxxDetail.jsp �� '���' ��ư Ȱ��ȭ ���θ� �����ִ� �κ�            
                String ThisJspName = box.get("ThisJspName");
                req.setAttribute("ThisJspName", ThisJspName);
//  XxxDetailSV.java �� XxxDetail.jsp �� '���' ��ư Ȱ��ȭ ���θ� �����ִ� �κ� 
          
                // �����ڸ���Ʈ
                AppLineData_vt = AppUtil.getAppDetailVt(ainf_seqn);

                req.setAttribute("d03VocationData_vt", d03VocationData_vt);
                req.setAttribute("AppLineData_vt", AppLineData_vt);

                dest = WebUtil.JspURL+"D/D07Maternity/D07MaternityDetail.jsp";

            } else if( jobid.equals("delete") ) {
                
                /////////////////////////////////////////////////////////////////////////////
                // ������ �ް���û ����..
                D03VocationRFC rfc            = new D03VocationRFC();
                Vector         AppLineData_vt = new Vector();
                String         ainf_seqn      = box.get("AINF_SEQN");
                
                // �������� ����..
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
                    rfc.delete( user.empNo, ainf_seqn );
                    con.commit();

// 2002.07.25.---------------------------------------------------------------------------
//                  ��û�� ������ ���� ������.
                    String upmu = "������ �ް���û";
                    MailMgr.sendMailDel(user,AppLineData_vt,upmu);
//                  ��û�� ������ ���� ������.
// 2002.07.25.---------------------------------------------------------------------------

                    String msg = "msg003";
                    String url = "location.href = '" + WebUtil.ServletURL+"hris.D.D07Maternity.D07MaternityBuildSV';";
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