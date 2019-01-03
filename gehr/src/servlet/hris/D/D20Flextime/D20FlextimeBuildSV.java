/********************************************************************************/
/*   System Name  : ESS                                                         														*/
/*   1Depth Name  : �ް�/����                                                 																	*/
/*   2Depth Name  : Flextime                                                        													*/
/*   Program Name : Flextime ��û                                 																			*/
/*   Program ID   : D20FlextimeBuildSV                                        														*/
/*   Description  : Flextime�� ��û�� �� �ֵ��� �ϴ� Class                          												*/
/*   Note         :                                                             																*/
/*   Creation     : 2017-08-01  eunha    [CSR ID:3438118] flexible time �ý��� ��û                                            */
/*   Update       : 2018-05-09  ��ȯ��	 [WorkTime52] �κ�/�������� �ٹ��� ����									*/
/********************************************************************************/

package servlet.hris.D.D20Flextime ;

import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;

import com.common.RFCReturnEntity;
import com.common.Utils;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;

import hris.D.D20Flextime.D20FlextimeData;
import hris.D.D20Flextime.D20FlextimeScreen;
import hris.D.D20Flextime.rfc.D20FlextimeAuthCheckRFC;
import hris.D.D20Flextime.rfc.D20FlextimeCheckRFC;
import hris.D.D20Flextime.rfc.D20FlextimeRFC;
import hris.D.D20Flextime.rfc.D20FlextimeSelectScreenRFC;
import hris.common.PersonData;
import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalLineData;
import hris.common.rfc.PersonInfoRFC;

public class D20FlextimeBuildSV extends ApprovalBaseServlet {

    private String UPMU_TYPE ="42";

    private String UPMU_NAME = "Flextime";

    protected String getUPMU_TYPE() {
        return UPMU_TYPE;
    }

    protected String getUPMU_NAME() {
        return UPMU_NAME;
    }
    protected void performTask(final HttpServletRequest req, final HttpServletResponse res) throws GeneralException
    {

        try{
            final WebUserData user = WebUtil.getSessionUser(req);

            String dest = "";
            final Box box = WebUtil.getBox(req);
            final String jobid = box.get("jobid", "first");

            final String PERNR =  getPERNR(box, user);

            // �븮 ��û �߰�
            PersonInfoRFC numfunc = new PersonInfoRFC();

            final PersonData phonenumdata    = (PersonData)numfunc.getPersonInfo(PERNR, "X" );
            req.setAttribute("PersonData" , phonenumdata );

            //�����üũ
            D20FlextimeAuthCheckRFC d20FlextimeAuthCheckRFC = new D20FlextimeAuthCheckRFC();
        	final String E_AVAILABLE = d20FlextimeAuthCheckRFC.getE_AVAILABLE(PERNR);
        	req.setAttribute("E_AVAILABLE" , E_AVAILABLE );
        	req.setAttribute("E_AVAILABLE_MSG", d20FlextimeAuthCheckRFC.getReturn().MSGTX);
        	
        	// ���ñٹ��� ����� üũ
        	// A:�κм��ñٹ��� B:�������ñٹ���
        	D20FlextimeSelectScreenRFC d20FlextimeSelectScreenRFC = new D20FlextimeSelectScreenRFC();
        	String E_SCREEN = d20FlextimeSelectScreenRFC.getE_SCREEN(PERNR, null);
        	final D20FlextimeScreen d20FlextimeScreen = D20FlextimeScreen.lookup(E_SCREEN);

            if( jobid.equals("first") ) {            //����ó�� ��û ȭ�鿡 ���°��.

            	getApprovalInfo(req, PERNR);    //<--�ʼ�
            	
            	switch (d20FlextimeScreen) {
					case A:
						dest = WebUtil.JspURL+"D/D20Flextime/D20FlextimeBuild.jsp";
						
						break;
					case B:
						dest = WebUtil.JspURL+"D/D20Flextime/D20FlextimeSelectBuild.jsp";
						
						break;
					case NONE: default:
						dest = WebUtil.JspURL+"D/D20Flextime/D20FlextimeSelectBuild.jsp";
						
						break;
				}
        	} else if (jobid.equals("check")) {

        		D20FlextimeData d20FlextimeData = new D20FlextimeData();
        		d20FlextimeData = box.createEntity(D20FlextimeData.class);
        		Utils.setFieldValue(d20FlextimeData, "BEGDA", DataUtil.removeStructur(d20FlextimeData.BEGDA));
        		Utils.setFieldValue(d20FlextimeData, "FLEX_BEGDA", DataUtil.removeStructur(d20FlextimeData.FLEX_BEGDA));
        		Utils.setFieldValue(d20FlextimeData, "FLEX_ENDDA", DataUtil.removeStructur(d20FlextimeData.FLEX_ENDDA));

            	D20FlextimeCheckRFC d20FlextimeCheckRFC = new D20FlextimeCheckRFC();
            	RFCReturnEntity returnEntity = d20FlextimeCheckRFC.check(d20FlextimeData, box.get("I_GTYPE"));
        		
                String msg = returnEntity.MSGTY + "," +  returnEntity.MSGTX;
				res.getWriter().print(msg);
        		
				return;

            } else if (jobid.equals("create")) {

                /* ���� ��û �κ� */
                dest = requestApproval(req, box, D20FlextimeData.class, new RequestFunction<D20FlextimeData>() {
                    public String porcess(D20FlextimeData inputData, Vector<ApprovalLineData> approvalLine) throws GeneralException {

                    	Utils.setFieldValue(inputData, "BEGDA", DataUtil.removeStructur(inputData.BEGDA));
                    	//[CSR ID:3525213] Flextime �ý��� ���� ��û start
                    	//Utils.setFieldValue(inputData, "FLEX_BEG", DataUtil.removeStructur(inputData.FLEX_BEG));
                    	//Utils.setFieldValue(inputData, "FLEX_END", DataUtil.removeStructur(inputData.FLEX_END));
                    	Utils.setFieldValue(inputData, "FLEX_BEGDA", DataUtil.removeStructur(inputData.FLEX_BEGDA));
                    	Utils.setFieldValue(inputData, "FLEX_ENDDA", DataUtil.removeStructur(inputData.FLEX_ENDDA));
                    	//[CSR ID:3525213] Flextime �ý��� ���� ��û end

                    	//�����üũ
                    	if(!StringUtils.equals(E_AVAILABLE, "Y"))  throw new GeneralException(g.getMessage("MSG.D.D15.0211"));// ����ڰ� �ƴմϴ�.

                    	//��û�� üũ����
        				D20FlextimeCheckRFC d20FlextimeCheckRFC = new D20FlextimeCheckRFC();
        				RFCReturnEntity returnEntity = d20FlextimeCheckRFC.check(inputData, "2");

                        if(!returnEntity.isSuccess()) {
                           throw new GeneralException(returnEntity.MSGTX);
                        }

                        /* ���� ��û RFC ȣ�� */
        				D20FlextimeRFC d20FlextimeRFC = new D20FlextimeRFC();
                        d20FlextimeRFC.setRequestInput(user.empNo, getUPMU_TYPE());
                        String AINF_SEQN = d20FlextimeRFC.build(Utils.asVector(inputData), box, req);

                        if(!d20FlextimeRFC.getReturn().isSuccess()) {
                            throw new GeneralException(d20FlextimeRFC.getReturn().MSGTX);
                        };
                        
                        return AINF_SEQN;
                        /* ������ �ۼ� �κ� �� */
                    }
                });
            } else {
                throw new GeneralException(g.getMessage("MSG.COMMON.0016"));
            }
            Logger.debug.println(this, " destributed = " + dest);
            printJspPage(req, res, dest);

        } catch (Exception e) {
            Logger.error(e);
            throw new GeneralException(e);
        }
    }

}

