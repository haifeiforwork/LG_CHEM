/********************************************************************************/
/*                                                                              																*/
/*   System Name  : ESS                                                         														*/
/*   1Depth Name  : �ް�/����                                                        															*/
/*   2Depth Name  : Flextime                                                        													*/
/*   Program Name : Flextime  ��                                                 															*/
/*   Program ID   : D20FlextimeDetailSV                                         													*/
/*   Description  : Flextime ����ȸ Class                            												                */
/*   Note         :                                                             																*/
/*   Creation     : 2017-08-01  eunha    [CSR ID:3438118] flexible time �ý��� ��û                                            */
/*   Update       : 2018-05-10  ��ȯ��   	 [WorkTime52] �κ�/�������� �ٹ��� ����										*/
/********************************************************************************/
package servlet.hris.D.D20Flextime;

import hris.D.D20Flextime.D20FlextimeData;
import hris.D.D20Flextime.D20FlextimeScreen;
import hris.D.D20Flextime.rfc.D20FlextimeRFC;
import hris.D.D20Flextime.rfc.D20FlextimeSelectScreenRFC;
import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;

import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.common.RFCReturnEntity;
import com.common.Utils;
import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.WebUtil;

public class D20FlextimeDetailSV extends ApprovalBaseServlet {

    private String UPMU_TYPE ="42";            // ���� ����Ÿ��(�ް���û)

	private String UPMU_NAME = "Flextime";

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
            String AINF_SEQN = box.get("AINF_SEQN");

            /* �ڰ� ���� ��ȸ */
            final D20FlextimeRFC d20FlextimeRFC = new D20FlextimeRFC();
            d20FlextimeRFC.setDetailInput(user.empNo, I_APGUB, AINF_SEQN);
            Vector<D20FlextimeData> resultList = d20FlextimeRFC.getDetail(); //��� ����Ÿ
            
            // ���ñٹ��� ����� üũ
        	// A:�κм��ñٹ��� B:�������ñٹ���
        	D20FlextimeSelectScreenRFC d20FlextimeSelectScreenRFC = new D20FlextimeSelectScreenRFC();
        	String E_SCREEN = d20FlextimeSelectScreenRFC.getE_SCREEN(user.empNo, AINF_SEQN);
        	final D20FlextimeScreen d20FlextimeScreen = D20FlextimeScreen.lookup(E_SCREEN);

            if (jobid.equals("first")) {           //����ó�� ��û ȭ�鿡 ���°��.

                req.setAttribute("resultData", Utils.indexOf(resultList, 0));

                if (!detailApporval(req, res, d20FlextimeRFC))
                    return;
                
                switch (d20FlextimeScreen) {
					case A:
						printJspPage(req, res, WebUtil.JspURL+"D/D20Flextime/D20FlextimeDetail.jsp");
						
						break;
					case B:
						printJspPage(req, res, WebUtil.JspURL+"D/D20Flextime/D20FlextimeSelectDetail.jsp");
						
						break;
					case NONE: default:
						break;
				}

            } else if (jobid.equals("delete")) {           /*���� */

                String dest = deleteApproval(req, box, d20FlextimeRFC, new DeleteFunction() {
                    public boolean porcess() throws GeneralException {

                    	D20FlextimeRFC deleteRFC = new D20FlextimeRFC();
                        deleteRFC.setDeleteInput(user.empNo, getUPMU_TYPE(), d20FlextimeRFC.getApprovalHeader().AINF_SEQN);

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
