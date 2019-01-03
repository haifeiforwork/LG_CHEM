/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : �����ְ�����Ȳ                                              */
/*   Program Name : �����ְ�����Ȳ                                              */
/*   Program ID   : E26InfosecessionDetailSV                                    */
/*   Description  : ������ Ż���û�� ���� �������� ������ jsp�� �Ѱ��ִ�Class*/
/*   Note         :                                                             */
/*   Creation     : 2002-01-04  ������                                          */
/*   Update       : 2005-03-02  ������                                          */
/*                                                                              */
/********************************************************************************/

package servlet.hris.E.E26InfoState;

import java.sql.*;
import java.util.Properties;
import java.util.Vector;
import javax.servlet.http.*;

import com.common.RFCReturnEntity;
import com.common.Utils;
import com.sns.jdf.*;
import com.sns.jdf.db.*;
import com.sns.jdf.util.*;
import com.sns.jdf.servlet.*;

import hris.common.*;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalBaseServlet.DeleteFunction;
import hris.common.db.*;
import hris.common.rfc.*;

import hris.E.E25Infojoin.*;
import hris.E.E25Infojoin.rfc.*;
import hris.E.E26InfoState.E26InfoStateData;
import hris.E.E26InfoState.rfc.*;

public class E26InfosecessionDetailSV extends ApprovalBaseServlet {

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

            final WebUserData user = WebUtil.getSessionUser(req);
            Box box = WebUtil.getBox(req);

            String jobid = box.get("jobid", "first");

            String I_APGUB = (String) req.getAttribute("I_APGUB");  //��� ���������� �Գ�? '1' : ������ ���� , '2' : ������ ���� , '3' : ����Ϸ� ����

            final E26InfosecessionRFC e26InfosecessionRFC = new E26InfosecessionRFC();
            e26InfosecessionRFC.setDetailInput(user.empNo, I_APGUB, box.get("AINF_SEQN"));
            Vector<E26InfoStateData> resultJoinList = e26InfosecessionRFC.getDetail(); //��� ����Ÿ

            final E25InfoSettRFC e25InfoSettRFC = new E25InfoSettRFC();
            e25InfoSettRFC.setDetailInput(user.empNo, I_APGUB, box.get("AINF_SEQN"));
            Vector<E25InfoSettData> resultSettList = e25InfoSettRFC.getDetail(); //��� ����Ÿ

            if (jobid.equals("first")) {           //����ó�� ��û ȭ�鿡 ���°��.

                req.setAttribute("e26InfoStateData", Utils.indexOf(resultJoinList, 0));
                req.setAttribute("e25InfoSettData", Utils.indexOf(resultSettList, 0));

                if (!detailApporval(req, res, e26InfosecessionRFC))
                    return;

                printJspPage(req, res, WebUtil.JspURL + "E/E26InfoState/E26InfosecessionDetail.jsp");

            } else if (jobid.equals("delete")) {           //����ó�� ��û ȭ�鿡 ���°��.

                String dest = deleteApproval(req, box, e26InfosecessionRFC, new DeleteFunction() {
                    public boolean porcess() throws GeneralException {

                    	E26InfosecessionRFC deleteJoinRFC = new E26InfosecessionRFC();
                    	deleteJoinRFC.setDeleteInput(user.empNo, UPMU_TYPE, e26InfosecessionRFC.getApprovalHeader().AINF_SEQN);

                    	RFCReturnEntity returnJoinEntity = deleteJoinRFC.delete();
                        if(!returnJoinEntity.isSuccess()) {
                            throw new GeneralException(returnJoinEntity.MSGTX);
                        }
                        return true;
                    }
                });

                printJspPage(req, res, dest);

            } else {
                throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
            }


        } catch (Exception e) {
            Logger.error(e);
            throw new GeneralException(e);
        }
    }

}
