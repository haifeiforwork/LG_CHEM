package servlet.hris.D;

import java.io.*;
import java.sql.*;
import java.util.Vector;
import javax.servlet.*;
import javax.servlet.http.*;

import com.sns.jdf.*;
import com.sns.jdf.util.*;
import com.sns.jdf.servlet.*;
import hris.common.*;
import hris.common.util.*;

import hris.D.*;
import hris.D.rfc.*;

/**
 * D14TaxAdjustDetail_k_SV.java
 * (�ؿܱٹ���)������ ����������� �����ȸ �� �� �ֵ��� �ϴ� Class
 *
 * @author �� ��ȣ    
 * @version 1.0, 2003/03/03
 */
public class D14TaxAdjustDetail_k_SV extends EHRBaseServlet {

    //private String UPMU_TYPE ="";            // ���� ����Ÿ��(�����������)
	protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        //Connection con = null;
        try{
            HttpSession  session          = req.getSession(false);
            WebUserData  user             = (WebUserData)session.getAttribute("user");
            Box          box              = WebUtil.getBox(req);
            
            String dest       = "";
            String jobid      = "";
            jobid = box.get("jobid");
            if( jobid.equals("") ){
                jobid = "first";
            }

            String targetYear = box.get("targetYear");   //[?????]  targetYear => ��� ������ �ٲ���� ����
            if( targetYear.equals("") ){
                targetYear = ((TaxAdjustFlagData)session.getAttribute("taxAdjust")).targetYear;
            }

            //(�ؿܱٹ���) ���� �ҵ�, (�ؿܱٹ���)���� ������ҵ���� �����͸� ��������
            D14TaxAdjustDetail_k_RFC  rfc  = new D14TaxAdjustDetail_k_RFC();
            D14TaxAdjustData_k d14TaxAdjustData_k = (D14TaxAdjustData_k)rfc.detail( user.empNo, targetYear );

            Logger.debug.println(this,d14TaxAdjustData_k.toString());
            req.setAttribute( "targetYear"      , targetYear);
            req.setAttribute( "d14TaxAdjustData_k", d14TaxAdjustData_k);
            
            dest = WebUtil.JspURL+"D/D14TaxAdjustDetail_k.jsp";
            Logger.debug.println(this, " destributed = " + dest);
            printJspPage(req, res, dest);

        } catch(Exception e) {
            throw new GeneralException(e);
        } finally {
            //DBUtil.close(con);
        }
	}
}
