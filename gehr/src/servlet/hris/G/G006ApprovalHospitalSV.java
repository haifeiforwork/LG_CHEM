/********************************************************************************/
/*                                                                              */
/*   System Name  :  e-HR                                                        */
/*   1Depth Name  : HR ������                                                   */
/*   2Depth Name  : ���� �ؾ��� ����                                            */
/*   Program Name : �Ƿ�� ��û                                                 */
/*   Program ID   : G006ApprovalHospitalSV                                      */
/*   Description  : �Ƿ�� ��û �μ��� ,����� ,���μ��� ����/�ݷ�            */
/*   Note         : ����                                                        */
/*   Creation     : 2005-03-14  �̽���                                          */
/*   Update       : 2005-10-28  LSA   �ڳ��� ��쿡 300�����ѵ�üũ������ ���� �־� �߰���CSR:C2005102601000000764  */
/*                   : 2013/09/04 @CSR1 �ѵ�üũ ����� �������� ���������� �ݾ׵� �ջ��Ͽ� �ѵ�üũ�� ����   */
/*                   : 2014/05/19 @CSR2 �ð������� (�繫��(4H), �繫��(6H), �����(4H), �����(6H)) �Ƿ��/���ڱ� ��û �� �˸� popup �߰�    */
/*                                                                              */
/*                                                                              */
/********************************************************************************/

package servlet.hris.G;

import com.common.Utils;
import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;
import hris.E.E17Hospital.E17BillData;
import hris.E.E17Hospital.E17HospitalData;
import hris.E.E17Hospital.E17HospitalResultData;
import hris.E.E17Hospital.E17SickData;
import hris.E.E17Hospital.rfc.E17HospitalRFC;
import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalHeader;
import hris.common.approval.ApprovalImport;
import hris.common.approval.ApprovalLineData;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Vector;

public class G006ApprovalHospitalSV extends ApprovalBaseServlet {

    private String UPMU_TYPE ="03";  // ���� ����Ÿ��(�Ƿ��)
    private String UPMU_NAME = "�Ƿ��";

    protected String getUPMU_TYPE() {
        return UPMU_TYPE;
    }

    protected String getUPMU_NAME() {
        return UPMU_NAME;
    }

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {

        try{
            final WebUserData user = WebUtil.getSessionUser(req);

            String dest  = "";

            final Box box = WebUtil.getBox(req);

            String  AINF_SEQN  = box.get("AINF_SEQN");

            String jobid = box.get("jobid");
            /* ���� �ݷ� �� */

            final E17HospitalRFC hospitalRFC = new E17HospitalRFC();
            hospitalRFC.setDetailInput(user.empNo, "1", box.get("AINF_SEQN"));
            E17HospitalResultData resultData = hospitalRFC.detail(); //��� ����Ÿ

            Vector<E17SickData> E17SickData_vt = resultData.T_ZHRA006T;
            Vector<E17HospitalData> E17HospitalData_vt = resultData.T_ZHRW005A;
            Vector<E17BillData> E17BillData_vt = resultData.T_ZHRW006A;

            final E17SickData e17SickData = Utils.indexOf(E17SickData_vt, 0);

            /* ���� �� */
            if("A".equals(jobid)) {

                /* ������ ���� �� */
                dest = accept(req, box, "T_ZHRA006T", e17SickData, hospitalRFC, new ApprovalFunction<E17SickData>() {
                    public boolean porcess(E17SickData inputData, ApprovalHeader approvalHeader, Vector<ApprovalLineData> approvalLineDatas) throws GeneralException {
                         /* ����Ǵ� ���� �׸� */


// �Ƿ�� ���� �ڷ�
                        box.copyToEntity(e17SickData);

                        e17SickData.COMP_WONX = DataUtil.changeGlobalAmount(e17SickData.COMP_WONX, e17SickData.WAERS);  // ����ӱ�
                        e17SickData.YTAX_WONX = DataUtil.changeGlobalAmount(e17SickData.YTAX_WONX, e17SickData.WAERS);  // ������
                            //e17SickData.YTAX_WONX = Double.toString(Double.parseDouble(e17SickData.YTAX_WONX) / 100.0) ;  // ������

                        e17SickData.UNAME   =   user.empNo;
                        e17SickData.AEDTM   =   DataUtil.getCurrentDate();

                        Vector vcE17HospitalData = new Vector();

                        int nRowCount = Integer.parseInt(box.getString("HospitalRowCount"));
                        for (int i = 0; i < nRowCount; i++) {
                            E17HospitalData e17HospitalData = new E17HospitalData();
                            box.copyToEntity(e17HospitalData ,i);
                            e17HospitalData.BEGDA   =   e17SickData.BEGDA;
                            e17HospitalData.COMP_WONX = e17SickData.COMP_WONX;

                            e17HospitalData.EMPL_WONX = DataUtil.changeGlobalAmount(e17HospitalData.EMPL_WONX, e17SickData.WAERS);
                            e17HospitalData.YTAX_WONX = DataUtil.changeGlobalAmount(e17HospitalData.YTAX_WONX, e17SickData.WAERS);

                            vcE17HospitalData.add(e17HospitalData);
                        } // end for

                        box.put(APPROVAL_IMPORT, new ApprovalImport("T_ZHRW005A", vcE17HospitalData));

                        return true;
                    }
                });

            /* �ݷ��� */
            } else if("R".equals(jobid)) {
                dest = reject(req, box, null, e17SickData, hospitalRFC, null);
            } else if("C".equals(jobid)) {
                dest = cancel(req, box, null, e17SickData, hospitalRFC, null);
            } else {
                throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
            }

            printJspPage(req, res, dest);

        } catch(Exception e) {
            Logger.err.println(DataUtil.getStackTrace(e));
            throw new GeneralException(e);
        }
	}
}