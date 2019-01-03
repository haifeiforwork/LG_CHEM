/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : �����ְ�����Ȳ                                              */
/*   Program Name : �����ְ�����Ȳ                                              */
/*   Program ID   : E26InfoStateSV                                              */
/*   Description  : ������ ������ �����ֿ� ���� ������ ��ȸ�ϴ� Class           */
/*   Note         :                                                             */
/*   Creation     : 2002-01-04  ������                                          */
/*   Update       : 2005-03-02  ������                                          */
/*                                                                              */
/********************************************************************************/

package servlet.hris.E.E26InfoState;

import java.util.Vector;
import javax.servlet.http.*;

import com.sns.jdf.*;
import com.sns.jdf.util.*;
import com.sns.jdf.servlet.*;

import hris.common.*;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.rfc.PersonInfoRFC;
import hris.E.E26InfoState.E26InfoStateData;
import hris.E.E26InfoState.rfc.*;

public class E26InfoStateSV extends ApprovalBaseServlet {

    private String UPMU_NAME = "������ Ż��";

    private String UPMU_TYPE = "27";     // ���� ����Ÿ��(������ ����)


    protected String getUPMU_TYPE() {
        return UPMU_TYPE;
    }

    protected String getUPMU_NAME() {
        return UPMU_NAME;
    }

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        try{
            HttpSession session = req.getSession(false);
            WebUserData user = WebUtil.getSessionUser(req);

            String dest  = "";

            Box box = WebUtil.getBox(req);

            String jobid = box.get("jobid", "first");
            Logger.debug.println(this, "[jobid] = "+jobid + " [user] : "+user.toString());

            String PERNR = getPERNR(box, user); //��û����� ���
            // �븮 ��û �߰�
            PersonInfoRFC numfunc = new PersonInfoRFC();
            PersonData phonenumdata;
            phonenumdata = (PersonData)numfunc.getPersonInfo(PERNR);

            req.setAttribute("PERNR" , PERNR );
            req.setAttribute("PersonData" , phonenumdata );

            if( jobid.equals("first") ) {

                Vector E26InfofirstData_vt = new Vector();
                E26InfofirstData_vt = (new E26InfoFirstRFC()).getInfoFirst(PERNR);

                Logger.debug.println(this,"E26InfofirstData_vt" + E26InfofirstData_vt.toString());

                req.setAttribute("E26InfofirstData_vt", E26InfofirstData_vt);

                dest = WebUtil.JspURL+"E/E26InfoState/E26InfoState.jsp";

            }else {
                throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
            }

            Logger.debug.println(this, " destributed = " + dest);
            printJspPage(req, res, dest);

        } catch(Exception e) {
            throw new GeneralException(e);
        } finally {

        }
    }
}
