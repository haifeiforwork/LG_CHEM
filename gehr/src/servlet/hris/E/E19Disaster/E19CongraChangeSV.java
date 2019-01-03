/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR ����                                                  */
/*   2Depth Name  : ���ؽ�û                                                    */
/*   Program Name : ���ؽ�û ����                                               */
/*   Program ID   : E19CongraChangeSV                                           */
/*   Description  : ���� ��û�� ������ �� �ֵ��� �ϴ� Class                     */
/*   Note         :                                                             */
/*   Creation     : 2001-12-19  �輺��                                          */
/*   Update       : 2005-02-25  ������                                          */
/*                                                                              */
/********************************************************************************/

package servlet.hris.E.E19Disaster;

import hris.A.A17Licence.A17LicenceData;
import hris.A.A17Licence.rfc.A17LicenceGradeRFC;
import hris.A.A17Licence.rfc.A17LicenceRFC;
import hris.E.E19Disaster.E19CongcondData;
import hris.E.E19Disaster.E19DisasterData;
import hris.E.E19Disaster.rfc.E19CongRateRFC;
import hris.E.E19Disaster.rfc.E19CongraRequestRFC;
import hris.common.*;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalHeader;
import hris.common.approval.ApprovalLineData;
import hris.common.approval.ApprovalBaseServlet.ChangeFunction;
import hris.common.db.AppLineDB;
import hris.common.rfc.PersonInfoRFC;
import hris.common.util.AppUtil;

import java.sql.Connection;
import java.util.Properties;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import servlet.hris.A.A17Licence.A17LicenceBuildSV;

import com.common.Utils;
import com.common.constant.Area;
import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.db.DBUtil;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;

public class E19CongraChangeSV extends ApprovalBaseServlet {

    private String UPMU_TYPE ="09";  // ���� ����Ÿ��(������)
    private String UPMU_NAME = "����";

    protected String getUPMU_TYPE() {
        return UPMU_TYPE;
    }

    protected String getUPMU_NAME() {
        return UPMU_NAME;
    }

    protected void performTask(final HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        try{
            final WebUserData user = WebUtil.getSessionUser(req);

            final Box box = WebUtil.getBox(req);

            String dest;

            String jobid = box.get("jobid", "first");
            final String AINF_SEQN = box.get("AINF_SEQN");

            //**********���� ��.****************************

            String I_APGUB = (String) req.getAttribute("I_APGUB");  //��� ���������� �Գ�? '1' : ������ ���� , '2' : ������ ���� , '3' : ����Ϸ� ����


            final E19CongraRequestRFC e19CongraRequestRFC = new E19CongraRequestRFC();
            e19CongraRequestRFC.setDetailInput(user.empNo, I_APGUB, box.get("AINF_SEQN"));
            Vector resultList = e19CongraRequestRFC.getDetail(); //��� ����Ÿ
            E19CongcondData     e19CongcondData = null;
            Vector E19CongcondData_vt = (Vector)resultList.get(0);
            for( int i = 0 ; i < E19CongcondData_vt.size() ; i++ ){
                e19CongcondData = (E19CongcondData)E19CongcondData_vt.get(i);
                e19CongcondData.WAGE_WONX = Double.toString(Double.parseDouble(e19CongcondData.WAGE_WONX) * 100.0 ) ;  // ����ӱ�
                e19CongcondData.CONG_WONX = Double.toString(Double.parseDouble(e19CongcondData.CONG_WONX) * 100.0 ) ;  // ������
            }

            final String PERNR = e19CongcondData.PERNR; //��û����� ���

            Vector E19DisasterData_vt = (Vector)resultList.get(1);
            Logger.debug.println(this, "E19CongcondData_vt---"+E19CongcondData_vt.toString());
            Logger.debug.println(this, "E19DisasterData_vt---"+E19DisasterData_vt.toString());



            if( jobid.equals("first") ) {  //����ó�� ���� ȭ�鿡 ���°��.
                /**** ��������(���¹�ȣ,�����)�� ���ΰ����´�. ����:2002/01/22 ****/
                hris.common.rfc.AccountInfoRFC accountInfoRFC = new hris.common.rfc.AccountInfoRFC();
                Vector AccountData_pers_vt = accountInfoRFC.getPersAccountInfo(PERNR);

                AccountData AccountData_hidden = new AccountData();
                DataUtil.fixNull(AccountData_hidden);
                req.setAttribute("e19CongcondData", e19CongcondData);
                req.setAttribute("E19DisasterData_vt", E19DisasterData_vt);
                req.setAttribute("resultData", e19CongcondData);
                req.setAttribute("AccountData_hidden" , AccountData_hidden );
                req.setAttribute("AccountData_pers_vt", AccountData_pers_vt);
                req.setAttribute("PERNR",PERNR);
                req.setAttribute("isUpdate", true); //��� ���� ����

                /**** ��������(���¹�ȣ,�����)�� ���ΰ����´�.****/
                detailApporval(req, res, e19CongraRequestRFC);

                printJspPage(req, res, WebUtil.JspURL + "E/E19Disaster/E19CongraBuild.jsp");

            } else if( jobid.equals("change") ) {

                /* ���� ��û �κ� */
                dest = changeApproval(req, box, E19CongcondData.class, e19CongraRequestRFC, new ChangeFunction<E19CongcondData>(){

                    public String porcess(E19CongcondData inputData, ApprovalHeader approvalHeader, Vector<ApprovalLineData> approvalLineDatas) throws GeneralException {
                        /* ���� ��û RFC ȣ�� */
                    	E19CongraRequestRFC changeRFC = new E19CongraRequestRFC();
                        changeRFC.setChangeInput(user.empNo, UPMU_TYPE, approvalHeader.AINF_SEQN);

                        Logger.debug("-------- AINF_SEQN " + inputData.AINF_SEQN);
                    	   // �������ؽŰ�
                        int rowcount_report = box.getInt("RowCount_report");
                        Vector E19DisasterData_vt = new Vector();

                        for( int i = 0; i < rowcount_report; i++ ) {
                            E19DisasterData e19DisasterData = new E19DisasterData();
                            String          idx             = Integer.toString(i);
                            e19DisasterData.AINF_SEQN  =AINF_SEQN;   // ���س����ڵ�20030922�߰�cyh
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

                        changeRFC.build(E19DisasterData_vt,inputData, box, req);

                        if(!changeRFC.getReturn().isSuccess()) {
                            throw new GeneralException(changeRFC.getReturn().MSGTX);
                        }
                        Logger.debug.println(this, "inputData.AINF_SEQN : " + inputData.AINF_SEQN);
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
