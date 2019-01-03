/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR ����                                                  */
/*   2Depth Name  : ���ؽ�û                                                    */
/*   Program Name : ���ؽ�û ��ȸ                                               */
/*   Program ID   : E19CongraDetailSV                                           */
/*   Description  : ���� ��û�� ��ȸ�� �� �ֵ��� �ϴ� Class                     */
/*   Note         :                                                             */
/*   Creation     : 2001-12-19  �輺��                                          */
/*   Update       : 2005-02-25  ������                                          */
/*                                                                              */
/********************************************************************************/

package servlet.hris.E.E19Disaster;

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
import hris.common.rfc.PersonInfoRFC;
import hris.common.util.*;
import hris.A.A17Licence.A17LicenceData;
import hris.A.A17Licence.rfc.A17LicenceRFC;
import hris.E.E19Disaster.E19CongcondData;
import hris.E.E19Disaster.rfc.*;

public class E19CongraDetailSV extends ApprovalBaseServlet {

    private String UPMU_TYPE ="09";  // ���� ����Ÿ��(������)
    private String UPMU_NAME = "����";

    protected String getUPMU_TYPE() {
        return UPMU_TYPE;
    }

    protected String getUPMU_NAME() {
        return UPMU_NAME;
    }

    protected void performTask(final HttpServletRequest req, HttpServletResponse res) throws GeneralException {
        try {

            final WebUserData user = WebUtil.getSessionUser(req);
            Box box = WebUtil.getBox(req);

            String jobid = box.get("jobid", "first");

            String I_APGUB = (String) req.getAttribute("I_APGUB");  //��� ���������� �Գ�? '1' : ������ ���� , '2' : ������ ���� , '3' : ����Ϸ� ����

            /* ��ȸ */
            E19CongcondData     e19CongcondData = null;
            final E19CongraRequestRFC e19CongraRequestRFC = new E19CongraRequestRFC();
            e19CongraRequestRFC.setDetailInput(user.empNo, I_APGUB, box.get("AINF_SEQN"));
            Vector resultList = e19CongraRequestRFC.getDetail(); //��� ����Ÿ

            Vector E19CongcondData_vt = (Vector)resultList.get(0);

            Vector E19DisasterData_vt = (Vector)resultList.get(1);
            Logger.debug.println(this, "E19CongcondData_vt---"+E19CongcondData_vt.toString());
            Logger.debug.println(this, "E19DisasterData_vt---"+E19DisasterData_vt.toString());
            for( int i = 0 ; i < E19CongcondData_vt.size() ; i++ ){
                e19CongcondData = (E19CongcondData)E19CongcondData_vt.get(i);
                e19CongcondData.WAGE_WONX = Double.toString(Double.parseDouble(e19CongcondData.WAGE_WONX) * 100.0 ) ;  // ����ӱ�
                e19CongcondData.CONG_WONX = Double.toString(Double.parseDouble(e19CongcondData.CONG_WONX) * 100.0 ) ;  // ������
            }

            if (jobid.equals("first")) {           //����ó�� ��û ȭ�鿡 ���°��.

                req.setAttribute("e19CongcondData", e19CongcondData);
                req.setAttribute("E19DisasterData_vt", E19DisasterData_vt);
                req.setAttribute("resultData", e19CongcondData);

                if (!detailApporval(req, res, e19CongraRequestRFC))
                    return;


                printJspPage(req, res, WebUtil.JspURL + "E/E19Disaster/E19CongraDetail.jsp");

            } else if (jobid.equals("delete")) {           //����ó�� ��û ȭ�鿡 ���°��.

                String dest = deleteApproval(req, box, e19CongraRequestRFC, new DeleteFunction() {
                    public boolean porcess() throws GeneralException {

                    	E19CongraRequestRFC deleteRFC = new E19CongraRequestRFC();
                        deleteRFC.setDeleteInput(user.empNo, UPMU_TYPE, e19CongraRequestRFC.getApprovalHeader().AINF_SEQN);

                        RFCReturnEntity returnEntity = deleteRFC.delete();

                        if(!returnEntity.isSuccess()) {
                            throw new GeneralException(e19CongraRequestRFC.getReturn().MSGTX);
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
