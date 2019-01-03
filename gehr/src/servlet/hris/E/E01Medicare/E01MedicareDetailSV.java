/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR ����                                                  */
/*   2Depth Name  : �ǰ����� �Ǻξ��� ��ȸ                                      */
/*   Program Name : �ǰ����� �Ǻξ��� ���/��� ��ȸ                            */
/*   Program ID   : E01MedicareDetailSV                                         */
/*   Description  : �ǰ����� �Ǻξ��� �ڰ�(���/���) ��û�� ���� �󼼳�����    */
/*                  ��ȸ�Ͽ� E01MedicareDetail.jsp ���� �Ѱ��ִ� class          */
/*                  jobid�� first�� ���� AppLineDB.class�� ȣ���Ͽ� ����      */
/*                  jsp�������� �Ѱ��ְ�,                                       */
/*                  jobid�� delete�� ���� AppLineDB.class�� ȣ���Ͽ� DB��     */
/*                  ���� delete ��Ų��.                                         */
/*   Note         :                                                             */
/*   Creation     : 2002-01-04  �赵��                                          */
/*   Update       : 2005-02-28  ������                                          */
/*                                                                              */
/********************************************************************************/

package servlet.hris.E.E01Medicare;

import java.sql.*;
import java.util.Properties;
import java.util.Vector;
import javax.servlet.http.*;

import com.common.RFCReturnEntity;
import com.common.Utils;
import com.common.constant.Area;
import com.sns.jdf.*;
import com.sns.jdf.db.*;
import com.sns.jdf.util.*;
import com.sns.jdf.servlet.*;

import hris.common.*;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalBaseServlet.DeleteFunction;
import hris.common.db.*;
import hris.common.util.*;
import hris.common.rfc.*;
import hris.A.A17Licence.A17LicenceData;
import hris.A.A17Licence.rfc.A17LicenceRFC;
import hris.E.E01Medicare.E01HealthGuaranteeData;
import hris.E.E01Medicare.rfc.*;

public class E01MedicareDetailSV extends ApprovalBaseServlet {

    private String UPMU_TYPE ="20";   // ���� ����Ÿ��(�ڰݺ���)
    private String UPMU_NAME = "�ǰ����� �Ǻξ���";

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

            final E01HealthGuaranteeRFC e01HealthGuaranteeRFC = new E01HealthGuaranteeRFC();
            e01HealthGuaranteeRFC.setDetailInput(user.empNo, I_APGUB, box.get("AINF_SEQN"));
            Vector<E01HealthGuaranteeData> e01HealthGuaranteeData_vt = e01HealthGuaranteeRFC.getDetail(); //��� ����Ÿ


            Logger.debug.println(this, "�Ǻξ��� �ڰ� ��û ��ȸ : " + e01HealthGuaranteeData_vt.toString());

            E01HealthGuaranteeData firstData = Utils.indexOf(e01HealthGuaranteeData_vt, 0);


            Logger.debug.println(this, "[jobid] = "+jobid + " [user] : "+user.toString());
            // XxxDetailSV.java �� XxxDetail.jsp �� '���' ��ư Ȱ��ȭ ���θ� �����ִ� �κ�
            String ThisJspName = box.get("ThisJspName");
            req.setAttribute("ThisJspName", ThisJspName);
            //XxxDetailSV.java �� XxxDetail.jsp �� '���' ��ư Ȱ��ȭ ���θ� �����ִ� �κ�

            if( jobid.equals("first") ) {

            	 req.setAttribute("e01HealthGuaranteeData_vt", e01HealthGuaranteeData_vt);
            	 req.setAttribute("firstData", firstData);

                if (!detailApporval(req, res, e01HealthGuaranteeRFC))
                    return;
                printJspPage(req, res, WebUtil.JspURL+"E/E01Medicare/E01MedicareDetail.jsp");

//---------------------------------------------------------------------------------------------------------
            } else if (jobid.equals("delete")) {           //����ó�� ��û ȭ�鿡 ���°��.

                String dest = deleteApproval(req, box, e01HealthGuaranteeRFC, new DeleteFunction() {
                    public boolean porcess() throws GeneralException {

                    	E01HealthGuaranteeRFC deleteRFC = new E01HealthGuaranteeRFC();
                        deleteRFC.setDeleteInput(user.empNo, UPMU_TYPE, e01HealthGuaranteeRFC.getApprovalHeader().AINF_SEQN);

                        RFCReturnEntity returnEntity = deleteRFC.delete();

                        if(!returnEntity.isSuccess()) {
                            throw new GeneralException(returnEntity.MSGTX);
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

