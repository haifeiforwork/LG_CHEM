package servlet.hris.J.J04DsortCreate;

import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.WebUtil;
import hris.J.J04DsortCreate.rfc.J04DsortInfoRFC;
import hris.common.WebUserData;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.Vector;

/**
 * J04DsortDetailSV.java
 * ��з� �󼼳��� ���� ��ȸ�Ѵ�. << ��з� ���� >>
 *
 * @author �赵��
 * @version 1.0, 2003/06/25
 */
public class J04DsortDetailSV extends EHRBaseServlet {

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {
        try {

            HttpSession session = req.getSession(false);
            WebUserData user = (WebUserData) session.getAttribute("user");

            Box box = WebUtil.getBox(req);

            J04DsortInfoRFC rfc = new J04DsortInfoRFC();

            Vector j04Result_vt = new Vector();

            String jobid = box.get("jobid");
            String i_objid = box.get("OBJID");              //Objective ID
            String i_sobid = box.get("SOBID");              //��з� ID
            String i_pernr = box.get("PERNR");              //�����ȣ
            String i_begda = box.get("BEGDA");              //Job ������
            String dest = "";
            Logger.debug.println(this, "############## i_objid : " + i_objid);
            Logger.debug.println(this, "############## i_sobid : " + i_sobid);
            Logger.debug.println(this, "############## i_pernr : " + i_pernr);
            Logger.debug.println(this, "############## i_begda : " + i_begda);
            if (jobid.equals("")) {
                jobid = "first";
            }
            Logger.debug.println(this, "[jobid] = " + jobid + " i_sobid : " + i_sobid);

            if (jobid.equals("first")) {           //����ó�� ��û ȭ�鿡 ���°��.
//              ��з� ��ȸ
                j04Result_vt = rfc.getDetail(i_sobid, "99991231");

//              ��з� ����
                req.setAttribute("j04Result_vt", j04Result_vt);
//              Objective ID, ��з� ID
                req.setAttribute("i_objid", i_objid);
                req.setAttribute("i_sobid", i_sobid);
                req.setAttribute("i_pernr", i_pernr);
                req.setAttribute("i_begda", i_begda);

                dest = WebUtil.JspURL + "J/J04DsortCreate/J04DsortDetail.jsp";
            }
            Logger.debug.println(this, " destributed = " + dest);
            printJspPage(req, res, dest);

        } catch (Exception e) {
            throw new GeneralException(e);
        }
    }
}
