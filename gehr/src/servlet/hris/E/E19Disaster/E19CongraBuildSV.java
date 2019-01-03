/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR ����                                                  */
/*   2Depth Name  : ���ؽ�û                                                    */
/*   Program Name : ���ؽ�û                                                    */
/*   Program ID   : E19CongraBuildSV                                            */
/*   Description  : ���ظ� ��û�� �� �ֵ��� �ϴ� Class                          */
/*   Note         :                                                             */
/*   Creation     : 2001-12-19  �輺��                                          */
/*   Update       : 2005-02-18  ������                                          */
/*  CSR ID : 2511881 ���ؽ�û �ý��� ������û 20140327 ������D  1) ���ؽ�û���� < ��û�� validation
 * 																				      2) ��û���� �������� �ƴϰ�, ���ؽ�û���ڰ� BEGDA
 * 																					  3) ���ؽ�û���� �Է� ȭ�� ����(�������ؽŰ��� �ű�)  */
/*                                                                              */
/********************************************************************************/

package servlet.hris.E.E19Disaster;

import hris.A.A17Licence.A17LicenceData;
import hris.E.E19Disaster.E19CongcondData;
import hris.E.E19Disaster.E19DisasterData;
import hris.E.E19Disaster.rfc.E19CongMoreRelaRFC;
import hris.E.E19Disaster.rfc.E19CongraRequestRFC;
import hris.common.AccountData;
import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalLineData;

import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.common.Utils;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;

public class E19CongraBuildSV extends ApprovalBaseServlet {

    private String UPMU_TYPE ="09";  // ���� ����Ÿ��(������)
    private String UPMU_NAME = "����";

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

            final Box box = WebUtil.getBox(req);

            final String dest;
            final String PERNR = getPERNR(box, user); //��û����� ���
            String disast_day;

            String jobid = box.get("jobid", "first");


            if (jobid.equals("first")) {   //����ó�� ��û ȭ�鿡 ���°��.
                //�������, ���� ��� ���� ��ȸ
                getApprovalInfo(req, PERNR);

                //��û���� -> ���ع߻����� ���� ����
                if(box.get("CONG_DATE").equals("")||box.get("CONG_DATE").trim() == ""){
                	disast_day = DataUtil.getCurrentDate();
                }else{
                	disast_day = WebUtil.replace(box.get("CONG_DATE"), ".", "");
                }

                Vector E19CongcondData_more = (new E19CongMoreRelaRFC()).getCongMoreRela(PERNR,  disast_day);
                E19CongcondData e19CongcondData = (E19CongcondData)E19CongcondData_more.get(0);
                e19CongcondData.PERNR = PERNR;

                /**** ��������(���¹�ȣ,�����)�� ���ΰ����´�. ����:2002/01/22 ****/
                hris.common.rfc.AccountInfoRFC accountInfoRFC = new hris.common.rfc.AccountInfoRFC();
                Vector AccountData_pers_vt = accountInfoRFC.getPersAccountInfo(PERNR);

                AccountData AccountData_hidden = new AccountData();
                DataUtil.fixNull(AccountData_hidden);
                req.setAttribute("AccountData_hidden" , AccountData_hidden );

                req.setAttribute("AccountData_pers_vt", AccountData_pers_vt);
                /**** ��������(���¹�ȣ,�����)�� ���ΰ����´�.****/

                req.setAttribute("resultData", e19CongcondData);
                req.setAttribute("E19DisasterData_vt", new Vector());
                req.setAttribute("PERNR",PERNR);
                req.setAttribute("isUpdate", box.get("isUpdate"));
                dest = WebUtil.JspURL + "E/E19Disaster/E19CongraBuild.jsp";

            }  else if (jobid.equals("create")) {

                /* ���� ��û �κ� */
                dest = requestApproval(req, box, E19CongcondData.class, new RequestFunction<E19CongcondData>() {
                    public String porcess(E19CongcondData inputData,Vector<ApprovalLineData> approvalLine) throws GeneralException {

                        /* ���� ��û RFC ȣ�� */
                    	E19CongraRequestRFC e19CongraRequestRFC = new E19CongraRequestRFC();
                    	e19CongraRequestRFC.setRequestInput(user.empNo, UPMU_TYPE);
                    	Vector E19DisasterData_vt = new Vector();

                    	   // �������ؽŰ�
                        int rowcount_report = box.getInt("RowCount_report");

                        Logger.debug.println("rowcount_report00----"+rowcount_report);
                        for( int i = 0; i < rowcount_report; i++ ) {
                        	E19DisasterData e19DisasterData = new E19DisasterData();
                            String          idx             = Integer.toString(i);

                            e19DisasterData.DISA_RESN  = box.get("DISA_RESN"+idx);   // ���س����ڵ�20030922�߰�cyh
                            e19DisasterData.DISA_CODE  = box.get("DISA_CODE"+idx);   // ���ر����ڵ�
                            e19DisasterData.DREL_CODE  = box.get("DREL_CODE"+idx);   // ���ش���� �����ڵ�
                            e19DisasterData.DISA_RATE  = box.get("DISA_RATE"+idx);   // ������
                            e19DisasterData.CONG_DATE  = box.get("CONG_DATE");       // �����߻���
                            e19DisasterData.DISA_DESC1 = box.get("DISA_DESC1"+idx);  // ���س���1
                            e19DisasterData.DISA_DESC2 = box.get("DISA_DESC2"+idx);  // ���س���2
                            e19DisasterData.DISA_DESC3 = box.get("DISA_DESC3"+idx);  // ���س���3
                            e19DisasterData.DISA_DESC4 = box.get("DISA_DESC4"+idx);  // ���س���4
                            e19DisasterData.DISA_DESC5 = box.get("DISA_DESC5"+idx);  // ���س���5
                            e19DisasterData.EREL_NAME  = box.get("EREL_NAME"+idx);   // ������󼺸�
                            e19DisasterData.INDX_NUMB  = (i+1)+"";                   // ����
                            e19DisasterData.PERNR      = PERNR;                      // ���
                            e19DisasterData.REGNO      = box.get("REGNO"+idx);       // �ѱ���Ϲ�ȣ
                            e19DisasterData.STRAS      = box.get("STRAS"+idx);       // �ּ�
                            E19DisasterData_vt.addElement(e19DisasterData);

                        }
                        Logger.debug.println("rowcount_report----"+rowcount_report);
                        Logger.debug.println("���ؽ�û�� size1----"+E19DisasterData_vt.size());
                        if(Utils.getFieldValue(inputData,"CONG_CODE").equals("0007") ){
                            /**** ��û�ȱݾ��� �Աݵ� ���������� �ִ��� üũ **************************************/
                            hris.common.rfc.AccountInfoRFC accountInfoRFC = new hris.common.rfc.AccountInfoRFC();
                            if( ! accountInfoRFC.hasDepartAccount((String)Utils.getFieldValue(inputData,"LIFNR")) ){
                            	 throw new GeneralException("���¹�ȣ�� ��ϵǾ� ���� �ʽ��ϴ�.");
                            }
                            /**** ��û�ȱݾ��� �Աݵ� ���������� �ִ��� üũ **************************************/
                        } else {
                            /**** ��û�ȱݾ��� �Աݵ� ���������� �ִ��� üũ **************************************/
                            hris.common.rfc.AccountInfoRFC accountInfoRFC = new hris.common.rfc.AccountInfoRFC();
                            if( ! accountInfoRFC.hasPersAccount(PERNR) ){
                            	throw new GeneralException("���¹�ȣ�� ��ϵǾ� ���� �ʽ��ϴ�.");
                            }
                            /**** ��û�ȱݾ��� �Աݵ� ���������� �ִ��� üũ **************************************/
                        }
                        String AINF_SEQN = e19CongraRequestRFC.build(E19DisasterData_vt,inputData, box, req);

                        if(!e19CongraRequestRFC.getReturn().isSuccess()) {
                            throw new GeneralException(e19CongraRequestRFC.getReturn().MSGTX);
                        };

                        return AINF_SEQN;
                        /* ������ �ۼ� �κ� �� */
                    }
                });

            } else {
                throw new GeneralException("���θ��(jobid)�� �ùٸ��� �ʽ��ϴ�. ");
            }
            Logger.debug.println(this, " destributed = " + dest);
            printJspPage(req, res, dest);

        } catch (Exception e) {
            Logger.error(e);
            throw new GeneralException(e);
        }
    }
}