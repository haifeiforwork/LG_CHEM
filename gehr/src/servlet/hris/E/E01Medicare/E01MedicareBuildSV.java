/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR ����                                                  */
/*   2Depth Name  : �ǰ����� �Ǻξ��� ��û                                      */
/*   Program Name : �ǰ����� �Ǻξ��� ���/��� ��û                            */
/*   Program ID   : E01MedicareBuildSV                                          */
/*   Description  : �ǰ����� �Ǻξ��� �ڰ�(���/���)��û �ϴ� Class            */
/*   Note         :                                                             */
/*   Creation     : 2002-01-03  �赵��                                          */
/*   Update       : 2005-03-07 ������                                          */
/*                                                                              */
/********************************************************************************/

package servlet.hris.E.E01Medicare;

import java.sql.*;
import java.util.Properties;
import java.util.Vector;
import javax.servlet.http.*;

import com.common.Utils;
import com.sns.jdf.*;
import com.sns.jdf.db.*;
import com.sns.jdf.util.*;
import com.sns.jdf.servlet.*;

import hris.common.*;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalLineData;
import hris.common.approval.ApprovalBaseServlet.RequestFunction;
import hris.common.db.*;
import hris.common.util.*;
import hris.common.rfc.*;
import hris.A.A17Licence.A17LicenceData;
import hris.A.A17Licence.rfc.A17LicenceRFC;
import hris.A.rfc.A04FamilyDetailRFC;
import hris.D.D07TimeSheet.D07TimeSheetDetailDataUsa;
import hris.E.E01Medicare.E01HealthGuaranteeData;
import hris.E.E01Medicare.rfc.*;

public class E01MedicareBuildSV extends ApprovalBaseServlet {


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

            String dest = "";

            String subty = "";
            String objps = "";

            final Box box = WebUtil.getBox(req);

            subty = box.get("SUBTY");
            objps = box.get("OBJPS");
            Logger.debug.println(this, "[SUBTY] = "+subty );
            Logger.debug.println(this, "[OBJPS] = "+objps);
            String jobid = box.get("jobid", "first");

            Logger.debug.println(this, "[jobid] = "+jobid + " [user] : "+user.toString());

            final String PERNR =  getPERNR(box, user); //��û����� ���


            if( jobid.equals("first") || jobid.equals("add")) {           //����ó�� ��û ȭ�鿡 ���°��.
            	getApprovalInfo(req, PERNR);
                E01TargetNameRFC       rfc_name   = new E01TargetNameRFC();
                E01HealthGuarAccqRFC   rfc_accq   = new E01HealthGuarAccqRFC();
                E01HealthGuarLossRFC   rfc_loss   = new E01HealthGuarLossRFC();
                E01HealthGuarHintchRFC rfc_hintch = new E01HealthGuarHintchRFC();

                Vector e01TargetNameData_vt       = null;
                Vector e01HealthGuarAccqData_vt   = null;
                Vector e01HealthGuarLossData_vt   = null;
                Vector e01HealthGuarHintchData_vt = null;

                Vector e01HealthGuaranteeData_vt  = new Vector();


                E01HealthGuaranteeData e01Data = new E01HealthGuaranteeData();
                e01Data.PERNR = PERNR;
                req.setAttribute("e01HealthGuaranteeData" , e01Data );



                // ��������Ʈ�� �����Ѵ�.
                e01TargetNameData_vt = rfc_name.getTargetName(PERNR);

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

                    req.setAttribute("e01TargetNameData_vt", e01TargetNameData_vt);
                    req.setAttribute("isUpdate", box.get("isUpdate"));
                    req.setAttribute("e01HealthGuarAccqData_vt", e01HealthGuarAccqData_vt);
                    req.setAttribute("e01HealthGuarLossData_vt", e01HealthGuarLossData_vt);
                    req.setAttribute("e01HealthGuarHintchData_vt", e01HealthGuarHintchData_vt);
                    req.setAttribute("e01HealthGuarReqsData_vt", new E01HealthGuarReqsRFC().getHealthGuarReqs());

                    int rowcount_data = box.getInt("RowCount_data");
                    for( int i = 0; i < rowcount_data; i++) {
                        E01HealthGuaranteeData e01HealthGuaranteeData = new E01HealthGuaranteeData();
                        String                 idx                    = Integer.toString(i);

                        if( box.get("use_flag"+idx).equals("N") ) continue;

                        e01HealthGuaranteeData.PERNR          = PERNR;
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

                        e01HealthGuaranteeData_vt.addElement(e01HealthGuaranteeData);
                    }
                    Logger.debug.println(this, e01HealthGuaranteeData_vt.toString());

                    req.setAttribute("e01HealthGuaranteeData_vt", e01HealthGuaranteeData_vt);

                    // XxxDetailSV.java �� XxxDetail.jsp �� '���/��ȭ��' ��ư Ȱ��ȭ ���θ� �����ִ� �κ�
                    String ThisJspName = box.get("ThisJspName");
                    req.setAttribute("ThisJspName", ThisJspName);
                    //  XxxDetailSV.java �� XxxDetail.jsp �� '���/��ȭ��' ��ư Ȱ��ȭ ���θ� �����ִ� �κ�

                    if( ThisJspName.equals("A04FamilyDetail_KR.jsp") ) {    // �������� �ű��Է� Ȯ�ο��� ��û�Ұ��..
                      req.setAttribute("subty", subty);
                      req.setAttribute("objps", objps);
                    }

                    dest = WebUtil.JspURL+"E/E01Medicare/E01MedicareBuild.jsp";
                }
                /*--------------- 2002.06.05. �������� �ѹ��� ��û�ϵ��� ���� ---------------*/

            } else if (jobid.equals("create")) {

                /* ���� ��û �κ� */
                dest = requestApproval(req, box, E01HealthGuaranteeData.class, new RequestFunction<E01HealthGuaranteeData>() {
                    public String porcess(E01HealthGuaranteeData inputData, Vector<ApprovalLineData> approvalLine) throws GeneralException {

                        /* ���� ��û RFC ȣ�� */
                    	E01HealthGuaranteeRFC  e01HealthGuaranteeRFC  = new E01HealthGuaranteeRFC();
                    	Vector e01HealthGuaranteeData_vt = new Vector();

                    	e01HealthGuaranteeRFC.setRequestInput(user.empNo, UPMU_TYPE);
                    	 String ThisJspName = box.get("ThisJspName");

                         int rowcount_data = box.getInt("RowCount_data");
                         for( int i = 0; i < rowcount_data; i++) {
                             E01HealthGuaranteeData e01HealthGuaranteeData = new E01HealthGuaranteeData();
                             String                 idx                    = Integer.toString(i);
                             e01HealthGuaranteeData.MANDT          = user.clientNo;
                             e01HealthGuaranteeData.PERNR          = PERNR;
                             e01HealthGuaranteeData.BEGDA          = box.get("BEGDA");               // ��û����
                             e01HealthGuaranteeData.INDX_NUMB      = (i+1)+"";                       // ����
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
                             e01HealthGuaranteeData.ZPERNR         = user.empNo;                     // ��û�� ���(�븮��û, ���� ��û)
                             e01HealthGuaranteeData.UNAME          = user.empNo;                     // ��û�� ���(�븮��û, ���� ��û)
                             e01HealthGuaranteeData.AEDTM          = DataUtil.getCurrentDate();      // ������(���糯¥)
                             e01HealthGuaranteeData_vt.addElement(e01HealthGuaranteeData);
                         }
                         Logger.debug.println(this, "�ǰ����� �Ǻξ��� �ڰ� ��û : " + e01HealthGuaranteeData_vt.toString());

                        String AINF_SEQN = e01HealthGuaranteeRFC.build(e01HealthGuaranteeData_vt, box, req);
                        Logger.debug.println(this, "AINF_SEQNAINF_SEQNAINF_SEQNAINF_SEQN : " + AINF_SEQN);

                        if(!e01HealthGuaranteeRFC.getReturn().isSuccess()) {
                            throw new GeneralException(e01HealthGuaranteeRFC.getReturn().MSGTX);
                        };

                        return AINF_SEQN;
                        /* ������ �ۼ� �κ� �� */
                    }
                });
            } else {
            	Logger.debug.println(this, "[jobid] = "+jobid + " [user] : "+user.toString());
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


