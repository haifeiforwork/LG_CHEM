/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR ����                                                  */
/*   2Depth Name  : �ǰ����� �Ǻξ��� ��û                                      */
/*   Program Name : �ǰ����� �Ǻξ��� ���/��� ��û ����                       */
/*   Program ID   : E01MedicareChangeSV                                         */
/*   Description  : �ǰ����� �Ǻξ��� �ڰ�(���/���) ��û�� �����ϴ� Class     */
/*   Note         :                                                             */
/*   Creation     : 2002-01-03  �赵��                                          */
/*   Update       : 2005-03-07  ������                                          */
/*                                                                              */
/********************************************************************************/

package servlet.hris.E.E01Medicare;

import hris.A.A17Licence.A17LicenceData;
import hris.A.A17Licence.rfc.A17LicenceRFC;
import hris.E.E01Medicare.E01HealthGuaranteeData;
import hris.E.E01Medicare.rfc.E01HealthGuarAccqRFC;
import hris.E.E01Medicare.rfc.E01HealthGuarHintchRFC;
import hris.E.E01Medicare.rfc.E01HealthGuarLossRFC;
import hris.E.E01Medicare.rfc.E01HealthGuarReqsRFC;
import hris.E.E01Medicare.rfc.E01HealthGuaranteeRFC;
import hris.E.E01Medicare.rfc.E01TargetNameRFC;
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
import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.db.DBUtil;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;

public class E01MedicareChangeSV extends ApprovalBaseServlet {


    private String UPMU_TYPE ="20";   // ���� ����Ÿ��(�ڰݺ���)
    private String UPMU_NAME = "�ǰ����� �Ǻξ���";

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
            String I_APGUB = (String) req.getAttribute("I_APGUB");  //��� ���������� �Գ�? '1' : ������ ���� , '2' : ������ ���� , '3' : ����Ϸ� ����

            final E01HealthGuaranteeRFC e01HealthGuaranteeRFC = new E01HealthGuaranteeRFC();
            e01HealthGuaranteeRFC.setDetailInput(user.empNo, I_APGUB, box.get("AINF_SEQN"));
             Vector<E01HealthGuaranteeData> e01HealthGuaranteeData_vt = e01HealthGuaranteeRFC.getDetail(); //��� ����Ÿ

            Logger.debug.println(this, "�Ǻξ��� �ڰ� ��û ��ȸ : " + e01HealthGuaranteeData_vt.toString());

            final E01HealthGuaranteeData firstData = Utils.indexOf(e01HealthGuaranteeData_vt, 0);

            String begda     = box.get("BEGDA");
            final String ainf_seqn = box.get("AINF_SEQN");


            if( jobid.equals("first")|| jobid.equals("add") ) {           //����ó�� ���� ȭ�鿡 ���°��.

            	Vector<E01HealthGuaranteeData> changeE01HealthGuaranteeData_vt = new Vector();
                detailApporval(req, res, e01HealthGuaranteeRFC);

                E01TargetNameRFC       rfc_name   = new E01TargetNameRFC();
                E01HealthGuarAccqRFC   rfc_accq   = new E01HealthGuarAccqRFC();
                E01HealthGuarLossRFC   rfc_loss   = new E01HealthGuarLossRFC();
                E01HealthGuarHintchRFC rfc_hintch = new E01HealthGuarHintchRFC();

                Vector e01TargetNameData_vt       = null;
                Vector e01HealthGuarAccqData_vt   = null;
                Vector e01HealthGuarLossData_vt   = null;
                Vector e01HealthGuarHintchData_vt = null;


                // ��������Ʈ�� �����Ѵ�.
                e01TargetNameData_vt = rfc_name.getTargetName(firstData.PERNR);

                if( e01TargetNameData_vt.size() == 0 ) {
                    Logger.debug.println(this, "�������׵����� : FamilyDetail Data Not Found");
                    String msg = "���������� ���� ����ϼ���.";
                    String url = "location.href = '" + WebUtil.ServletURL+"hris.A.A12Family.A12FamilyBuildSV';";
                    req.setAttribute("msg", msg);
                    req.setAttribute("url", url);
                    dest = WebUtil.JspURL+"common/caution.jsp";
                } else {
                    // ������
                    e01HealthGuarAccqData_vt   = rfc_accq.getHealthGuarAccq();

                    // ��ǻ���
                    e01HealthGuarLossData_vt   = rfc_loss.getHealthGuarLoss();

                    // ����� ������ȣ
                    e01HealthGuarHintchData_vt = rfc_hintch.getHealthGuarHintch();


                    Logger.debug.println(this, "��������Ʈ : "+ e01TargetNameData_vt.toString());
                    Logger.debug.println(this, "������ : "+ e01HealthGuarAccqData_vt.toString());
                    Logger.debug.println(this, "��ǻ��� : "+ e01HealthGuarLossData_vt.toString());
                    Logger.debug.println(this, "����� ������ȣ : "+ e01HealthGuarHintchData_vt.toString());
                    Logger.debug.println(this, "�Ǻξ��� �ڰ� ��û ���� ��ȸ : " + e01HealthGuaranteeData_vt.toString());

                    //-----��� ������ ��츦 ����Ͽ� ��û����, �����ȣ�� �̸� �����صξ��ٰ� .jsp�������� �Ѱ��ش�.
                    req.setAttribute("begda",                      begda);
                    req.setAttribute("ainf_seqn",                  ainf_seqn);
                    //-----��� ������ ��츦 ����Ͽ� ��û����, �����ȣ�� �̸� �����صξ��ٰ� .jsp�������� �Ѱ��ش�.

                    int rowcount_data = box.getInt("RowCount_data");
                    for( int i = 0; i < rowcount_data; i++) {
                        E01HealthGuaranteeData e01HealthGuaranteeData = new E01HealthGuaranteeData();
                        String                 idx                    = Integer.toString(i);

                        //-----��� ������ ��츦 ����Ͽ� ��û����, �����ȣ�� �̸� �����صξ��ٰ� .jsp�������� �Ѱ��ش�.

                        //-----��� ������ ��츦 ����Ͽ� ��û����, �����ȣ�� �̸� �����صξ��ٰ� .jsp�������� �Ѱ��ش�.
                        if( box.get("use_flag"+idx).equals("N") ) continue;

                        e01HealthGuaranteeData.BEGDA          = begda;                          // ��û����
                        e01HealthGuaranteeData.AINF_SEQN      = ainf_seqn;                      // �����ȣ
                        e01HealthGuaranteeData.APPL_TYPE      = box.get("APPL_TYPE"+idx);       // �ǰ����� �Ǻξ��� �ڰ�/��� ��û����
                        e01HealthGuaranteeData.SUBTY          = box.get("SUBTY"+idx);           // �Ϻ�����
                        e01HealthGuaranteeData.OBJPS          = box.get("OBJPS"+idx);           // ������Ʈ�ĺ�
                        e01HealthGuaranteeData.ACCQ_LOSS_DATE = box.get("ACCQ_LOSS_DATE"+idx);  // ���/�������
                        e01HealthGuaranteeData.ACCQ_LOSS_TYPE = box.get("ACCQ_LOSS_TYPE"+idx);  // �ǰ����� �Ǻξ��� �ڰ� ��û(���/���)����
                        e01HealthGuaranteeData.HITCH_TYPE     = box.get("HITCH_TYPE"+idx);      // ����� ���� ��ȣ
                        e01HealthGuaranteeData.HITCH_GRADE    = box.get("HITCH_GRADE"+idx);     // ��ֵ��
                        e01HealthGuaranteeData.HITCH_DATE     = box.get("HITCH_DATE"+idx);      // ��ֵ����
                        e01HealthGuaranteeData.APPL_TEXT      = box.get("APPL_TEXT"+idx);       // �ǰ����� �Ǻξ��� ��û���� �ؽ�Ʈ
                        e01HealthGuaranteeData.ACCQ_LOSS_TEXT = box.get("ACCQ_LOSS_TEXT"+idx);  // �ǰ����� �Ǻξ��� ��� ��� �ؽ�Ʈ
                        e01HealthGuaranteeData.HITCH_TEXT     = box.get("HITCH_TEXT"+idx);      // ����� ���� ��ȣ ��� �ؽ�Ʈ
                        e01HealthGuaranteeData.ENAME          = box.get("ENAME"+idx);           // ����� �̸�
                        e01HealthGuaranteeData.APRT_CODE      = box.get("APRT_CODE"+idx);       // �������߱޿���

                        changeE01HealthGuaranteeData_vt.addElement(e01HealthGuaranteeData);
                    }
                    Logger.debug.println(this, changeE01HealthGuaranteeData_vt.toString());

                    if(jobid.equals("add")){
                    	req.setAttribute("e01HealthGuaranteeData_vt", changeE01HealthGuaranteeData_vt);
                    }else {
                    	req.setAttribute("e01HealthGuaranteeData_vt", e01HealthGuaranteeData_vt);
                    }


                    req.setAttribute("e01HealthGuaranteeData",     firstData);
                    req.setAttribute("isUpdate", true); //��� ���� ����
                    req.setAttribute("e01TargetNameData_vt", e01TargetNameData_vt);
                    req.setAttribute("e01HealthGuarAccqData_vt", e01HealthGuarAccqData_vt);
                    req.setAttribute("e01HealthGuarLossData_vt", e01HealthGuarLossData_vt);
                    req.setAttribute("e01HealthGuarHintchData_vt", e01HealthGuarHintchData_vt);
                    req.setAttribute("e01HealthGuarReqsData_vt", new E01HealthGuarReqsRFC().getHealthGuarReqs());

                    req.setAttribute("begda",                     begda);
                    req.setAttribute("ainf_seqn",                 ainf_seqn);

//                  XxxDetailSV.java �� XxxDetail.jsp �� '���/��ȭ��' ��ư Ȱ��ȭ ���θ� �����ִ� �κ�
                    String ThisJspName = box.get("ThisJspName");
                    req.setAttribute("ThisJspName", ThisJspName);
//  XxxDetailSV.java �� XxxDetail.jsp �� '���/��ȭ��' ��ư Ȱ��ȭ ���θ� �����ִ� �κ�

                    dest = WebUtil.JspURL+"E/E01Medicare/E01MedicareBuild.jsp";
                    Logger.debug.println(this, dest);

                }
                printJspPage(req, res, dest);

            } else if( jobid.equals("change") ) {

                /* ���� ��û �κ� */
                dest = changeApproval(req, box, E01HealthGuaranteeData.class, e01HealthGuaranteeRFC, new ChangeFunction<E01HealthGuaranteeData>(){

                    public String porcess(E01HealthGuaranteeData inputData, ApprovalHeader approvalHeader, Vector<ApprovalLineData> approvalLineDatas) throws GeneralException {

                    	Vector changeE01HealthGuaranteeData_vt  = new Vector();

                        /* ���� ��û RFC ȣ�� */
                    	E01HealthGuaranteeRFC changeRFC = new E01HealthGuaranteeRFC();
                        changeRFC.setChangeInput(user.empNo, UPMU_TYPE, approvalHeader.AINF_SEQN);

                        String begda          = "";
                        //  XxxDetailSV.java �� XxxDetail.jsp �� '���/��ȭ��' ��ư Ȱ��ȭ ���θ� �����ִ� �κ�
                        String ThisJspName = box.get("ThisJspName");
                        //  XxxDetailSV.java �� XxxDetail.jsp �� '���/��ȭ��' ��ư Ȱ��ȭ ���θ� �����ִ� �κ�

                        /////////////////////////////////////////////////////////////////////////////
                        // �ǰ����� �Ǻξ��� �ڰ�(���/���) ��û
                        int rowcount_data = box.getInt("RowCount_data");
                        Logger.debug.println("rowcount_datarowcount_datarowcount_data"+rowcount_data);
                        for( int i = 0; i < rowcount_data; i++) {
                            E01HealthGuaranteeData e01HealthGuaranteeData = new E01HealthGuaranteeData();
                            String idx = Integer.toString(i);

                            e01HealthGuaranteeData.MANDT          = user.clientNo;
                            e01HealthGuaranteeData.PERNR          = firstData.PERNR;
                            e01HealthGuaranteeData.AINF_SEQN      = ainf_seqn;
                            e01HealthGuaranteeData.BEGDA          = DataUtil.removeStructur(box.get("BEGDA"), "."); // ��û����
                            e01HealthGuaranteeData.INDX_NUMB      = (i+1)+"";                        // ����
                            e01HealthGuaranteeData.APPL_TYPE      = box.get("APPL_TYPE"+idx);        // �ǰ����� �Ǻξ��� �ڰ�/��� ��û����
                            e01HealthGuaranteeData.SUBTY          = box.get("SUBTY"+idx);            // �Ϻ�����
                            e01HealthGuaranteeData.OBJPS          = box.get("OBJPS"+idx);            // ������Ʈ�ĺ�
                            e01HealthGuaranteeData.ACCQ_LOSS_DATE = DataUtil.removeStructur(box.get("ACCQ_LOSS_DATE"+idx), ".");   // ���/�������
                            e01HealthGuaranteeData.ACCQ_LOSS_TYPE = box.get("ACCQ_LOSS_TYPE"+idx);   // �ǰ����� �Ǻξ��� �ڰ� ��û(���/���)����
                            e01HealthGuaranteeData.HITCH_TYPE     = box.get("HITCH_TYPE"+idx);       // ����� ���� ��ȣ
                            e01HealthGuaranteeData.HITCH_GRADE    = box.get("HITCH_GRADE"+idx);      // ��ֵ��
                            e01HealthGuaranteeData.HITCH_DATE     = DataUtil.removeStructur(box.get("HITCH_DATE"+idx), ".");       // ��ֵ����
                            e01HealthGuaranteeData.APPL_TEXT      = box.get("APPL_TEXT"+idx);        // �ǰ����� �Ǻξ��� ��û���� �ؽ�Ʈ
                            e01HealthGuaranteeData.ACCQ_LOSS_TEXT = box.get("ACCQ_LOSS_TEXT"+idx);   // �ǰ����� �Ǻξ��� ��� ��� �ؽ�Ʈ
                            e01HealthGuaranteeData.HITCH_TEXT     = box.get("HITCH_TEXT"+idx);       // ����� ���� ��ȣ ��� �ؽ�Ʈ
                            e01HealthGuaranteeData.ENAME          = box.get("ENAME"+idx);            // ����� �̸�
                            e01HealthGuaranteeData.APRT_CODE      = box.get("APRT_CODE"+idx);        // �������߱޿���
                            e01HealthGuaranteeData.ZPERNR         = firstData.ZPERNR;                // ��û�� ���(�븮��û, ���� ��û)
                            e01HealthGuaranteeData.UNAME          = user.empNo;                      // ������ ���(�븮��û, ���� ��û)
                            e01HealthGuaranteeData.AEDTM          = DataUtil.getCurrentDate();       // ������(���糯¥)

                            // ���� �����Ϳ� ������ ��û��..
                            begda                                 = DataUtil.removeStructur(box.get("BEGDA"), ".");
                            changeE01HealthGuaranteeData_vt.addElement(e01HealthGuaranteeData);
                        }
                        Logger.debug.println(this, "�ǰ����� �Ǻξ��� �ڰ� ��û ���� : " + changeE01HealthGuaranteeData_vt.toString());

                        changeRFC.build(changeE01HealthGuaranteeData_vt, box, req);

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
