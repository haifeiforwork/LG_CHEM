/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR ����                                                  */
/*   2Depth Name  : ��������                                                    */
/*   Program Name : �������� ��û                                               */
/*   Program ID   : D19EduTripDetailSV.java                                     */
/*   Description  : ���������û�� �ϴ� Class                                   */
/*   Note         :                                                             */
/*   Creation     : 2010-31-31 lsa                                              */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/
package servlet.hris.D.D19EduTrip;

import hris.D.D19EduTrip.D19EduTripData;
import hris.D.D19EduTrip.rfc.D19EduTripRFC;
import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;

import java.sql.Connection;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.common.RFCReturnEntity;
import com.common.Utils;
import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.db.DBUtil;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.WebUtil;

/**
 * D19EduTripDetailSV.java
 * ����,�����û�� ���� �󼼳����� ��ȸ�Ͽ� D19EduTripDetail.jsp ���� �Ѱ��ִ� class
 * jobid�� first�� ���� AppLineDB.class�� ȣ���Ͽ� ���� jsp�������� �Ѱ��ְ�,
 * jobid�� delete�� ���� AppLineDB.class�� ȣ���Ͽ� DB�� ���� delete ��Ų��.
 *
 * @author �赵��
 * @version 1.0, 2002/01/04
 **/
public class D19EduTripDetailSV extends ApprovalBaseServlet {

    private String UPMU_TYPE ="35";            // ���� ����Ÿ��(����,�����û)
    private String UPMU_NAME = "����/���� ��û";

    protected String getUPMU_TYPE() {
        return UPMU_TYPE;
    }

    protected String getUPMU_NAME() {
        return UPMU_NAME;
    }


	protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        Connection con = null;

        try{
            final WebUserData user = WebUtil.getSessionUser(req);
            Box box = WebUtil.getBox(req);

            String jobid = box.get("jobid", "first");

            String I_APGUB = (String) req.getAttribute("I_APGUB");  //��� ���������� �Գ�? '1' : ������ ���� , '2' : ������ ���� , '3' : ����Ϸ� ����

            /* �������� ���� ��ȸ */
            final D19EduTripRFC d19EduTripRFC = new D19EduTripRFC();
            d19EduTripRFC.setDetailInput(user.empNo, I_APGUB, box.get("AINF_SEQN"));
            Vector<D19EduTripData> resultList = d19EduTripRFC.getVocation(); //��� ����Ÿ


            //**********���� ��.****************************
            if( jobid.equals("first") ) {


                req.setAttribute("resultData", Utils.indexOf(resultList, 0));
                req.setAttribute("D19EduTripData_vt", resultList);
                if (!detailApporval(req, res, d19EduTripRFC))
                    return;
                printJspPage(req, res, WebUtil.JspURL+"D/D19EduTrip/D19EduTripDetail.jsp");

            } else if( jobid.equals("delete") ) {
                String dest = deleteApproval(req, box, d19EduTripRFC, new DeleteFunction() {
                    public boolean porcess() throws GeneralException {

                    	D19EduTripRFC deleteRFC = new D19EduTripRFC();
                        deleteRFC.setDeleteInput(user.empNo, UPMU_TYPE, d19EduTripRFC.getApprovalHeader().AINF_SEQN);

                        RFCReturnEntity returnEntity = deleteRFC.delete();

                        if(!returnEntity.isSuccess()) {
                            throw new GeneralException(d19EduTripRFC.getReturn().MSGTX);
                        }

                        return true;
                    }
                });

                printJspPage(req, res, dest);

            } else {
                throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
            }

        } catch(Exception e) {
            throw new GeneralException(e);
        } finally {
            DBUtil.close(con);
        }
	}
}