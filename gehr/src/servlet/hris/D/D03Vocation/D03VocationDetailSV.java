/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : ��û                                                        		*/
/*   2Depth Name  : ����                                                        		*/
/*   Program Name : �ް� ��                                                   		*/
/*   Program ID   : D03VocationDetailSV                                         */
/*   Description  : �ް� ��ȸ/���� �Ҽ� �ֵ��� �ϴ� Class                       	*/
/*   Note         :                                                             */
/*   Creation     : 2002-01-04  �赵��                                          		*/
/*   Update       : 2005-03-04  �����                                          		*/
/*                : 2016-10-10 FD-038 GEHR�����۾�-KSC 							*/
/*                : 2017-05-17 ��ȯ�� [WorkTime52] �����ް� �߰� �� 				*/
/*                                                                              */
/********************************************************************************/
package servlet.hris.D.D03Vocation;

import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.common.RFCReturnEntity;
import com.common.Utils;
import com.common.constant.Area;
import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.WebUtil;

import hris.D.D03Vocation.D03RemainVocationData;
import hris.D.D03Vocation.D03VocationData;
import hris.D.D03Vocation.rfc.D03RemainVocationOfficeRFC;
import hris.D.D03Vocation.rfc.D03RemainVocationRFC;
import hris.D.D03Vocation.rfc.D03VocationRFC;
import hris.common.PersonData;
import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.rfc.AuthCheckNTMRFC;
import hris.common.rfc.PersonInfoRFC;

public class D03VocationDetailSV extends ApprovalBaseServlet {

    private String UPMU_TYPE ="18";            // ���� ����Ÿ��(�ް���û)

	private String UPMU_NAME = "�ް�";

    protected String getUPMU_TYPE() {
        return UPMU_TYPE;
    }

    protected String getUPMU_NAME() {
        return UPMU_NAME;
    }
    protected void performTask(final HttpServletRequest req, final HttpServletResponse res) throws GeneralException
    {
       // Connection con = null;

        try{
            HttpSession session = req.getSession(false);
            final WebUserData user    = (WebUserData)session.getAttribute("user");

            String dest         = "";
            String jobid        = "";

            final Box box = WebUtil.getBox(req);
            jobid = box.get("jobid", "first");

            /**         * Start: ������ �б�ó�� */
           if (user.area.equals(Area.KR) ) {
			} else if (user.area.equals(Area.PL) || user.area.equals(Area.DE)) { // PL ������, DE ���� �� ����ȭ������
        	   printJspPage(req, res, WebUtil.ServletURL+"hris.D.D03Vocation.D03VocationDetailEurpSV" );
		       	return;
			} else{
				printJspPage(req, res, WebUtil.ServletURL+"hris.D.D03Vocation.D03VocationDetailGlobalSV" );
		       	return;
			}
            /**             * END: ������ �б�ó��             */

			//final String PERNR = box.get("PERNR", user.empNo);

            Logger.debug.println(this, "[jobid] = "+jobid + " [user] : "+user.toString());

            //**********���� ���� (20050304:�����)**********
            final String          AINF_SEQN           = box.get("AINF_SEQN");

            String I_APGUB = (String) req.getAttribute("I_APGUB");  //��� ���������� �Գ�? '1' : ������ ���� , '2' : ������ ���� , '3' : ����Ϸ� ����


            final D03VocationRFC  rfc                 = new D03VocationRFC();
            //D03VocationData d03VocationData     = new D03VocationData();

            Vector          d03VocationData_vt  = null;

            rfc.setDetailInput(user.empNo, I_APGUB, AINF_SEQN);
            //�ް���û ��ȸ
            d03VocationData_vt = rfc.getVocation( user.empNo, AINF_SEQN );

            if( d03VocationData_vt.size() < 1 ){
                String msg = "��ȸ�� �׸��� �����ϴ�.";
                req.setAttribute("msg", msg);
                dest = WebUtil.JspURL+"common/caution.jsp";
                printJspPage(req, res, dest);
                return ;
            }

            final D03VocationData  firstData           = (D03VocationData)Utils.indexOf(d03VocationData_vt, 0);
            Logger.debug.println(this, "�ް���û ��ȸ : " + d03VocationData_vt.toString());

            // �븮 ��û �߰�
            PersonInfoRFC numfunc         = new PersonInfoRFC();
            PersonData phonenumdata    = null;
            phonenumdata  = (PersonData)numfunc.getPersonInfo(firstData.PERNR, "X");
            req.setAttribute("PersonData" , phonenumdata );

            //**********���� ��.****************************

            if( jobid.equals("first") ) {

            	// �����ް� ����üũ
                AuthCheckNTMRFC authCheckNTMRFC = new AuthCheckNTMRFC();
            	String E_AUTH = authCheckNTMRFC.getAuth(firstData.PERNR, "S_ESS");
            	req.setAttribute("E_AUTH", E_AUTH);
            	
                // �ܿ��ް��ϼ�, ��ġ����ٹ��� üũ
                D03RemainVocationData d03RemainVocationData    = new D03RemainVocationData();
                
                if("Y".equals(E_AUTH)) {	//�繫��
                	String vocaType = (firstData.AWART.equals("0111") 
                						|| firstData.AWART.equals("0112") 
                						|| firstData.AWART.equals("0113")) ? "B" : "A";
                	D03RemainVocationOfficeRFC  rfcRemain = new D03RemainVocationOfficeRFC();
                	d03RemainVocationData = (D03RemainVocationData)rfcRemain.getRemainVocation(firstData.PERNR, firstData.APPL_FROM, vocaType);
                } else {
                	D03RemainVocationRFC rfcRemain             = new D03RemainVocationRFC();
                	d03RemainVocationData = (D03RemainVocationData)rfcRemain.getRemainVocation(firstData.PERNR, firstData.APPL_FROM);
                }

                Logger.debug.println(this, "�ް����� ��ȸ : " + d03VocationData_vt.toString());

                req.setAttribute("d03RemainVocationData",  d03RemainVocationData);
                req.setAttribute("d03VocationData_vt", d03VocationData_vt);

                if (!detailApporval(req, res, rfc))                    return;

                dest = WebUtil.JspURL+"D/D03Vocation/D03VocationDetail.jsp";

                /////////////////////////////////////////////////////////////////////////////
                // �ް���û ����..
                /////////////////////////////////////////////////////////////////////////////

            } else if( jobid.equals("delete") ) {


                dest = deleteApproval(req, box, rfc, new DeleteFunction() {
                    public boolean porcess() throws GeneralException {

                    	//D01OTRFC deleteRFC = new D01OTRFC();
                        rfc.setDeleteInput(user.empNo, UPMU_TYPE, rfc.getApprovalHeader().AINF_SEQN);

                        RFCReturnEntity returnEntity = rfc.delete( firstData.PERNR, AINF_SEQN  );

                        if(!returnEntity.isSuccess()) {
                            throw new GeneralException(returnEntity.MSGTX);
                        }

                        return true;
                    }
                });


// 2002.07.25.---------------------------------------------------------------------------
//              ��û�� ������ ���� ������ ���� �ʿ��� ������ ������ �����´�.
//              ����
//              ��û�� ������ ���� ������ ���� �ʿ��� ������ ������ �����´�.
// 2002.07.25.---------------------------------------------------------------------------
/*

                    String url ;

                    //  ���� ������ ������ �������� �̵��ϱ� ���� ����
                    if(RequestPageName != null &&  !RequestPageName.equals("") ){
                        url = "location.href = '" + RequestPageName.replace('|','&') + "';";
                    } else {
                        url = "location.href = '" + WebUtil.ServletURL+"hris.D.D03Vocation.D03VocationBuildSV';";
                    } // end if
                    //**********���� ��.****************************
*/
            } else {
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