/********************************************************************************/
/*                                                                              																*/
/*   System Name  : ESS                                                         														*/
/*   1Depth Name  : �ް�/����                                                        															*/
/*   2Depth Name  : Flextime                                                        													*/
/*   Program Name : Flextime ����                                                   															*/
/*   Program ID   : D20FlextimeChangeSV                                         													*/
/*   Description  : Flextime ����  �Ҽ� �ֵ��� �ϴ� Class                            												*/
/*   Note         :                                                             																*/
/*   Creation     : 2017-08-01  eunha    [CSR ID:3438118] flexible time �ý��� ��û                                            */
/*   Update       : 2017-11-08  eunha    [CSR ID:3525213] Flextime �ý��� ���� ��û									*/
/*   Update       : 2018-05-10  ��ȯ��   [WorkTime52] �κ�/�������� �ٹ��� ����									*/
/********************************************************************************/
package servlet.hris.D.D20Flextime;

import hris.D.D20Flextime.D20FlextimeData;
import hris.D.D20Flextime.D20FlextimeScreen;
import hris.D.D20Flextime.rfc.D20FlextimeAuthCheckRFC;
import hris.D.D20Flextime.rfc.D20FlextimeCheckRFC;
import hris.D.D20Flextime.rfc.D20FlextimeRFC;
import hris.D.D20Flextime.rfc.D20FlextimeSelectScreenRFC;
import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalHeader;
import hris.common.approval.ApprovalLineData;

import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.common.RFCReturnEntity;
import com.common.Utils;
import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;

public class D20FlextimeChangeSV extends ApprovalBaseServlet {

    private String UPMU_TYPE ="42";            // ���� ����Ÿ��(Flextime)

	private String UPMU_NAME = "Flextime";

    protected String getUPMU_TYPE() {
        return UPMU_TYPE;
    }

    protected String getUPMU_NAME() {
        return UPMU_NAME;
    }

	protected void performTask(final HttpServletRequest req, HttpServletResponse res) throws GeneralException {

        try{
            final WebUserData user = WebUtil.getSessionUser(req);

            final Box box = WebUtil.getBox(req);

            String dest;

            String jobid = box.get("jobid", "first");
            String AINF_SEQN = box.get("AINF_SEQN");

            //**********���� ��.****************************

            String I_APGUB = (String) req.getAttribute("I_APGUB");  //��� ���������� �Գ�? '1' : ������ ���� , '2' : ������ ���� , '3' : ����Ϸ� ����

            /* �� ���� ��ȸ */
            final D20FlextimeRFC d20FlextimeRFC = new D20FlextimeRFC();
            d20FlextimeRFC.setDetailInput(user.empNo, I_APGUB, AINF_SEQN);

            Vector<D20FlextimeData> resultList = d20FlextimeRFC.getDetail(); //��� ����Ÿ
            D20FlextimeData resultData = Utils.indexOf(resultList, 0);
            //�����üũ
            D20FlextimeAuthCheckRFC d20FlextimeAuthCheckRFC = new D20FlextimeAuthCheckRFC();
        	final String E_AVAILABLE = d20FlextimeAuthCheckRFC.getE_AVAILABLE(resultData.PERNR);
        	req.setAttribute("E_AVAILABLE" , E_AVAILABLE );
        	
        	// ���ñٹ��� ����� üũ
        	// A:�κм��ñٹ��� B:�������ñٹ���
        	D20FlextimeSelectScreenRFC d20FlextimeSelectScreenRFC = new D20FlextimeSelectScreenRFC();
        	String E_SCREEN = d20FlextimeSelectScreenRFC.getE_SCREEN(resultData.PERNR, AINF_SEQN);
        	final D20FlextimeScreen d20FlextimeScreen = D20FlextimeScreen.lookup(E_SCREEN);

            if( jobid.equals("first") ) {  //����ó�� ���� ȭ�鿡 ���°��.
                req.setAttribute("resultData", resultData);

                req.setAttribute("isUpdate", true); //��� ���� ����

                detailApporval(req, res, d20FlextimeRFC);

                switch (d20FlextimeScreen) {
					case A:
						printJspPage(req, res, WebUtil.JspURL+"D/D20Flextime/D20FlextimeBuild.jsp");
						
						break;
					case B:
						printJspPage(req, res, WebUtil.JspURL+"D/D20Flextime/D20FlextimeSelectBuild.jsp");
						
						break;
					case NONE: default:
						break;
				}

            } else if( jobid.equals("change") ) {

                /* ���� ��û �κ� */
                dest = changeApproval(req, box, D20FlextimeData.class, d20FlextimeRFC, new ChangeFunction<D20FlextimeData>(){

                    public String porcess(D20FlextimeData inputData, ApprovalHeader approvalHeader, Vector<ApprovalLineData> approvalLineDatas) throws GeneralException {

                    	Utils.setFieldValue(inputData, "BEGDA", DataUtil.removeStructur(inputData.BEGDA));
                    	//[CSR ID:3525213] Flextime �ý��� ���� ��û start
                    	//Utils.setFieldValue(inputData, "FLEX_BEG", DataUtil.removeStructur(inputData.FLEX_BEG));
                    	//Utils.setFieldValue(inputData, "FLEX_END", DataUtil.removeStructur(inputData.FLEX_END));
                    	Utils.setFieldValue(inputData, "FLEX_BEGDA", DataUtil.removeStructur(inputData.FLEX_BEGDA));
                    	Utils.setFieldValue(inputData, "FLEX_ENDDA", DataUtil.removeStructur(inputData.FLEX_ENDDA));
                    	//[CSR ID:3525213] Flextime �ý��� ���� ��û end

                    	//��û�� üũ����
                    	D20FlextimeCheckRFC d20FlextimeCheckRFC = new D20FlextimeCheckRFC();
                        RFCReturnEntity returnEntity = d20FlextimeCheckRFC.check( inputData,"3");

                        if(!returnEntity.isSuccess()) {
                            throw new GeneralException(returnEntity.MSGTX);
                        }

                    	/* ���� ��û RFC ȣ�� */
                    	D20FlextimeRFC changeRFC = new D20FlextimeRFC();
                        changeRFC.setChangeInput(user.empNo, getUPMU_TYPE(), approvalHeader.AINF_SEQN);

                        Logger.debug("-------- AINF_SEQN " + inputData.AINF_SEQN);

                        changeRFC.build(Utils.asVector(inputData), box, req);

                        if(!changeRFC.getReturn().isSuccess()) {
                            throw new GeneralException(changeRFC.getReturn().MSGTX);
                        }

                        return inputData.AINF_SEQN;
                        /* ������ �ۼ� �κ� �� */
                    }
                });

                printJspPage(req, res, dest);
            } else {
                throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
            }

        } catch(Exception e) {
            throw new GeneralException(e);
        }
	}
}