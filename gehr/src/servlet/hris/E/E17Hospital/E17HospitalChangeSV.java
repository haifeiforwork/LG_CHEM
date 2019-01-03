/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR ����                                                  */
/*   2Depth Name  : �Ƿ��                                                      */
/*   Program Name : �Ƿ�� ����                                                 */
/*   Program ID   : E17HospitalChangeSV                                         */
/*   Description  : �Ƿ�� ������ �� �ֵ��� �ϴ� Class                        */
/*   Note         :                                                             */
/*   Creation     : 2002-01-08  �輺��                                          */
/*   Update       : 2005-02-23  ������                                          */
/*                  2005-12-27  @v1.1 C2005121301000001097 �ſ�ī��/���ݱ����߰�*/
/*                  2014-08-26  ������D [CSR ID:2598080] �Ƿ�� �����ѵ� ���� ���� �����, �ڳ� �ջ� 1000���� */
/*                  2015-07-31  ������D [CSR ID:2839626] �Ƿ�� ��û �� �系Ŀ�� ���� üũ ���� �߰� */
/*					 2018-04-20  cykim  [CSR ID:3658652] �Ƿ������ ��û �޴� ���� ��û�� �� */
/********************************************************************************/

package servlet.hris.E.E17Hospital;

import com.common.Utils;
import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.CodeEntity;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;
import hris.E.E17Hospital.E17BillData;
import hris.E.E17Hospital.E17HospitalData;
import hris.E.E17Hospital.E17HospitalResultData;
import hris.E.E17Hospital.E17SickData;
import hris.E.E17Hospital.rfc.*;
import hris.E.E18Hospital.E18HospitalListData;
import hris.E.E18Hospital.rfc.E18HospitalListRFC;
import hris.common.PersonData;
import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalHeader;
import hris.common.approval.ApprovalLineData;
import hris.common.rfc.CurrencyCodeRFC;
import hris.common.rfc.PersonInfoRFC;
import org.apache.commons.lang.StringUtils;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Map;
import java.util.Vector;


public class E17HospitalChangeSV extends ApprovalBaseServlet {

    private String UPMU_TYPE ="03";  // ���� ����Ÿ��(�Ƿ��)
    private String UPMU_NAME = "�Ƿ��";

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
            final String AINF_SEQN = box.get("AINF_SEQN");

            //**********���� ��.****************************

            String I_APGUB = (String) req.getAttribute("I_APGUB");  //��� ���������� �Գ�? '1' : ������ ���� , '2' : ������ ���� , '3' : ����Ϸ� ����

            /*  ���� ��ȸ */
            final E17HospitalRFC hospitalRFC = new E17HospitalRFC();
            hospitalRFC.setDetailInput(user.empNo, I_APGUB, AINF_SEQN);
            E17HospitalResultData resultData = hospitalRFC.detail(); //��� ����Ÿ

            final Vector<E17SickData> E17SickData_vt     = resultData.T_ZHRA006T;
            Vector<E17HospitalData> E17HospitalData_vt = resultData.T_ZHRW005A;
            Vector<E17BillData> E17BillData_vt     = resultData.T_ZHRW006A;

            final E17SickData e17SickData = Utils.indexOf(E17SickData_vt, 0);

            if(e17SickData == null) {
                moveMsgPage(req, res, "������ �׸��� �����͸� �о���̴� �� ������ �߻��߽��ϴ�.", "history.back();");
            }

            final String PERNR = e17SickData.PERNR;
            final String CTRL_NUMB = e17SickData.CTRL_NUMB;

            /**
             * �⺻ ��ȸ ��
             */
            if(jobid.equals("first") || jobid.equals("change_guen") || jobid.equals("AddOrDel")) {
                req.setAttribute("isUpdate", true); //��� ���� ����

                //�������, ���� ��� ���� ��ȸ
                detailApporval(req, res, hospitalRFC);

                        //[CSR ID:2839626] �Ƿ�� ��û �� �系Ŀ�� ���� üũ ���� �߰� ����
                E17CompanyCoupleRFC  cc_rfc           = new E17CompanyCoupleRFC();
                String      companyCoupleYN = cc_rfc.getData(PERNR);
                req.setAttribute("companyCoupleYN"    , companyCoupleYN);	//[CSR ID:2839626] �Ƿ�� ��û �� �系Ŀ�� ���� üũ ���� �߰�

                req.setAttribute("currencyList", (new CurrencyCodeRFC()).getCurrencyCode());


                req.setAttribute("MediCode_vt", (new E17MediCodeRFC()).getMediCode());  //"code", "desc"
                req.setAttribute("RcptCode_vt", (new E17RcptCodeRFC()).getRcptCode());

                req.setAttribute("MedicTrea_vt", (new E17MedicTreaRFC()).getMedicTrea());

                Map<String, Vector> guenMap = (new E17GuenCodeRFC()).getGuenCode(PERNR);

                //  2003.03.14 ����� �����ѵ� ������ CHECK ���� �߰� - ������(E_FLAG = 'Y')�� �����ѵ��� CHECK���� �ʴ´�.
                req.setAttribute("E_FLAG", (new E17MedicCheckYNRFC()).getE_FLAG(DataUtil.getCurrentYear(), PERNR));


                req.setAttribute("guenCodeList", guenMap.get("T_RESULT"));
                req.setAttribute("E17ChildData_vt", guenMap.get("T_CHILD"));
                //[CSR ID:3658652] �Ƿ������ ��û �޴� ���� ��û�� �� @ T_DATE :: ��ȥ�����, �Ի����� �޾ƿ�.
                req.setAttribute("E17FAMDate", guenMap.get("T_DATE"));

                Vector<CodeEntity> currency_vt = (new hris.common.rfc.CurrencyDecimalRFC()).getCurrencyDecimal();
                for(CodeEntity codeEnt : currency_vt) {
                    if( e17SickData.WAERS.equals(codeEnt.code) ){
                        req.setAttribute("currencyValue"          , Double.parseDouble(codeEnt.value));
                        break;
                    }
                }
            }

            if( jobid.equals("first") ) {     //����ó�� ��û ȭ�鿡 ���°��.

//                String P_Flag         = ""; <-- 2005.05.30(KDS) : ���� ���� ������� �ݿ�

                E18HospitalListRFC func_E18 = new E18HospitalListRFC();

                Vector E18HospitalData_vt = new Vector();
                String l_CTRL_NUMB        = "";
                double COMP_sum          = 0.0;
                double totEMPL_WONX = 0;

                // �������׸� ���Ϳ� ������꼭 ������ �����͸� ��ġ ��Ŵ
                Vector new_vt = new Vector();
                for( int i = 0 ; i < E17HospitalData_vt.size(); i++ ){
                    E17HospitalData e17HospitalData = (E17HospitalData)E17HospitalData_vt.get(i);
                    boolean isExist = false;
                    for( int k = 0 ; k < E17BillData_vt.size(); k++ ){
                        E17BillData e17BillData = (E17BillData)E17BillData_vt.get(k);
                        if(e17HospitalData.RCPT_NUMB.equals(e17BillData.RCPT_NUMB)){
                            new_vt.addElement(e17BillData);
                            isExist = true;
                            break;
                        }
                    }
                    if( ! isExist ){
                        E17BillData temp_data = new E17BillData();
                        DataUtil.fixNull(temp_data);
                        new_vt.addElement(temp_data);
                    }
                }
                E17BillData_vt = new_vt;

                // -------------����, �����, �ڳ��� ��� ȸ�������Ѿ��� �����ֱ� ���ؼ� �Ѿ��� ����Ѵ�.
                E18HospitalData_vt = func_E18.getHospitalList( e17SickData.PERNR ) ;

                for ( int i = 0 ; i < E18HospitalData_vt.size() ; i++ ) {
                    E18HospitalListData data_18 = ( E18HospitalListData ) E18HospitalData_vt.get( i ) ;
                    l_CTRL_NUMB = data_18.CTRL_NUMB.substring(0, 4);
                    //@v1.5 2008.07.01 �ѵ�üũ�� data�� �޶������
                    //if( data_18.GUEN_CODE.equals(e17SickData.GUEN_CODE) && l_CTRL_NUMB.equals(DataUtil.getCurrentYear()) ) {
                    //    COMP_sum = COMP_sum + Double.parseDouble( data_18.COMP_WONX );
                    //}
//                      [CSR ID:2598080] �Ƿ�� �����ѵ� ���� ����
                    if(e17SickData.GUEN_CODE.equals("0001")){//���ν�û
                        if( data_18.GUEN_CODE.equals(e17SickData.GUEN_CODE)    && l_CTRL_NUMB.equals(DataUtil.getCurrentYear()) ) {
                            COMP_sum = COMP_sum + Double.parseDouble( data_18.COMP_WONX );
                        }
                        Logger.debug.println(this, "data_18.OBJPS_21 : " + data_18.OBJPS_21+"e17SickData.OBJPS_21:"+e17SickData.OBJPS_21+"COMP_sum:"+COMP_sum);
                    }else{//����� or �ڳ�
                         if( (data_18.GUEN_CODE.equals("0002") || data_18.GUEN_CODE.equals("0003"))    && l_CTRL_NUMB.equals(DataUtil.getCurrentYear()) ) {
                            COMP_sum = COMP_sum + Double.parseDouble( data_18.COMP_WONX );
                        }
                    }
                    totEMPL_WONX += Double.parseDouble(data_18.EMPL_WONX);
                }
                //  -----------------------------------------------------------------------------------------

                req.setAttribute("last_RCPT_NUMB"    , "");
                req.setAttribute("e17SickData"       , e17SickData);
                req.setAttribute("E17HospitalData_vt", E17HospitalData_vt);
                req.setAttribute("E17BillData_vt"    , E17BillData_vt);
//                    req.setAttribute("P_Flag"            , P_Flag);
                req.setAttribute("COMP_sum"          , COMP_sum );
                req.setAttribute("totEMPL_WONX"      , totEMPL_WONX);


                // �븮 ��û �߰�
                PersonInfoRFC numfunc = new PersonInfoRFC();
                PersonData personInfo = numfunc.getPersonInfo(e17SickData.PERNR);

                req.setAttribute("personInfo" , personInfo );


                dest = WebUtil.JspURL+"E/E17Hospital/E17HospitalBuild.jsp";

                printJspPage(req, res, dest);
            } else if( jobid.equals("change") ) { // DB update �����κ�

                /* ���� ��û �κ� */
                dest = changeApproval(req, box, e17SickData, hospitalRFC, new ChangeFunction<E17SickData>(){

                    public String porcess(E17SickData inputData, ApprovalHeader approvalHeader, Vector<ApprovalLineData> approvalLineDatas) throws GeneralException {

                        e17SickData.CTRL_NUMB = CTRL_NUMB;

                        Vector E17HospitalData_vt = new Vector();
                        Vector E17BillData_vt     = new Vector();
                        Vector E17SickData_vt     = new Vector();
                        E17SickRFC sick_rfc       = new E17SickRFC();

                        String PROOF          = box.get("PROOF");
                        int    new_RCPT_NUMB  = 0;
                        String new_CTRL_NUMB  = null;
                        String old_CTRL_NUMB  = null;

                        new_RCPT_NUMB = Integer.parseInt(sick_rfc.getRCPT_NUMB(inputData.PERNR, inputData.GUEN_CODE, inputData.OBJPS_21, inputData.REGNO));

                        inputData.MANDT     = user.clientNo;
                        inputData.PROOF     = PROOF;
                        inputData.CTRL_NUMB     = e17SickData.CTRL_NUMB;
                        old_CTRL_NUMB = e17SickData.CTRL_NUMB;

                        // �Ƿ��
                        //int rowcount_hospital = box.getInt("RowCount_hospital");
                        int rowcount_hospital = box.getInt("medi_count");
                        for( int i = 0; i < rowcount_hospital; i++) {
                            E17HospitalData e17HospitalData = new E17HospitalData();

                            e17HospitalData.MANDT     = user.clientNo;
                            //e17HospitalData.BEGDA     = box.get("BEGDA")        ;    // ������
                            e17HospitalData.PERNR    = e17SickData.PERNR              ;    // �����ȣ
                            e17HospitalData.CTRL_NUMB = old_CTRL_NUMB           ;    // ������ȣ
                            //if( e17SickData.is_new_num.equals("Y") ){
                            //    e17HospitalData.RCPT_NUMB = Integer.toString(i+1);   // ��������ȣ
                            //}else if( e17SickData.is_new_num.equals("N") ){
                            e17HospitalData.RCPT_NUMB = new_RCPT_NUMB + (i + 1) + ""  ;// ��������ȣ
                            //}else{
                            //    Logger.debug.println(this, "E17HospitalBuild.jsp ���Ͽ��� Field 'is_new_num' �� ���� 'Y'�Ǵ� 'N'���� �Ѵ�");
                            //}
                            e17HospitalData.AINF_SEQN = AINF_SEQN               ;    // �������� �Ϸù�ȣ
                            e17HospitalData.MEDI_NAME = box.get("MEDI_NAME"+i);    // �Ƿ���
                            e17HospitalData.TELX_NUMB = box.get("TELX_NUMB"+i);    // ��ȭ��ȣ
                            e17HospitalData.EXAM_DATE = box.get("EXAM_DATE"+i);    // ������
                            e17HospitalData.MEDI_CODE = box.get("MEDI_CODE"+i);    // �Կ�/�ܷ�
                            e17HospitalData.MEDI_TEXT = box.get("MEDI_TEXT"+i);    // �Կ�/�ܷ�
                            e17HospitalData.RCPT_CODE = box.get("RCPT_CODE"+i);    // ������ ����
                            e17HospitalData.RCPT_TEXT = box.get("RCPT_TEXT"+i);    // ������ ����
                            //e17HospitalData.RCPT_NUMB = box.get("RCPT_NUMB"+i);  // No. ��������ȣ
                            e17HospitalData.EMPL_WONX = box.get("EMPL_WONX"+i);    // ���� �ǳ��ξ�
                            e17HospitalData.WAERS     = box.get("WAERS");            // ��ȭŰ
//                  2004�� �������� ���� ����ڵ�Ϲ�ȣ �ʵ� �߰� (3.7)
                            e17HospitalData.MEDI_NUMB = box.get("MEDI_NUMB"+i);    // �Ƿ��� ����ڵ�Ϲ�ȣ
                            e17HospitalData.MEDI_MTHD = box.get("MEDI_MTHD"+i);    // @v1.1 ������� (1:����, 2:�ſ�ī��)
                            e17HospitalData.YTAX_WONX = box.get("YTAX_WONX"+i);    // @v1.2 ��������ݿ���

                            //                  �� �Ƿ���׸��� ���Ϳ� ���� �ʴ´�.
                            if(e17HospitalData.EMPL_WONX == null || e17HospitalData.EMPL_WONX.equals("")){ continue; }
                            //                  �� �Ƿ���׸��� ���Ϳ� ���� �ʴ´�.

                            E17HospitalData_vt.addElement(e17HospitalData);
                        }
                        Logger.debug.println(this, "E17HospitalData : " + E17HospitalData_vt.toString());

                        // �����
                        //int rowcount_report = box.getInt("RowCount_report");
                        int rowcount_report = box.getInt("medi_count");
                        for( int i = 0; i < rowcount_report; i++) {
                            // �� �Ƿ���׸��� ���Ϳ� ���� �ʴ´�.
                            if(StringUtils.isBlank(box.get("EMPL_WONX"+i)))  continue;
                            // �� �Ƿ���׸��� ���Ϳ� ���� �ʴ´�.


                            E17BillData e17BillData = new E17BillData();

                            e17BillData.MANDT     = user.clientNo;
                            //e17BillData.BEGDA    = box.get("BEGDA")        ;    // ������
                            e17BillData.PERNR    = e17SickData.PERNR              ;    // �����ȣ
                            e17BillData.CTRL_NUMB = old_CTRL_NUMB           ;    // ������ȣ
                            //if( e17SickData.is_new_num.equals("Y") ){
                            //e17BillData.CTRL_NUMB = new_CTRL_NUMB       ;    // ������ȣ
                            //    e17BillData.RCPT_NUMB = Integer.toString(i+1);   // ��������ȣ
                            //}else if( e17SickData.is_new_num.equals("N") ){
                            //e17BillData.CTRL_NUMB = old_CTRL_NUMB       ;    // ������ȣ
                            e17BillData.RCPT_NUMB = new_RCPT_NUMB + (i + 1) + ""  ;// ��������ȣ
                            //}else{
                            //    Logger.debug.println(this, "E17HospitalBuild.jsp ���Ͽ��� Field 'is_new_num' �� ���� 'Y'�Ǵ� 'N'���� �Ѵ�");
                            //}
                            //e17BillData.RCPT_NUMB = new_RCPT_NUMB + i + "";    // ��������ȣ
                            e17BillData.AINF_SEQN = AINF_SEQN               ;    // �������� �Ϸù�ȣ
                            e17BillData.TOTL_WONX = box.get("TOTL_WONX"+i);    // �� �����
                            e17BillData.ASSO_WONX = box.get("ASSO_WONX"+i);    // ���� �δ��
                            e17BillData.EMPL_WONX = box.get("x_EMPL_WONX"+i);  // ���� �δ��
                            // �� �Ƿ���׸��� ���Ϳ� ���� �ʴ´�.
                            // if(e17BillData.EMPL_WONX == null || e17BillData.EMPL_WONX.equals("")) continue;
                            e17BillData.MEAL_WONX = box.get("MEAL_WONX"+i);    // �Ĵ�
                            e17BillData.APNT_WONX = box.get("APNT_WONX"+i);    // ���� �����
                            e17BillData.ROOM_WONX = box.get("ROOM_WONX"+i);    // ��� ���Ƿ� ����
                            e17BillData.CTXX_WONX = box.get("CTXX_WONX"+i);    // C T �˻��
                            e17BillData.MRIX_WONX = box.get("MRIX_WONX"+i);    // M R I �˻��
                            e17BillData.SWAV_WONX = box.get("SWAV_WONX"+i);    // ������ �˻��
                            e17BillData.DISC_WONX = box.get("DISC_WONX"+i);    // ���αݾ�
                            e17BillData.ETC1_WONX = box.get("ETC1_WONX"+i);    // ��Ÿ1 �� �ݾ�
                            e17BillData.ETC1_TEXT = box.get("ETC1_TEXT"+i);    // ��Ÿ1 �� �׸��
                            e17BillData.ETC2_WONX = box.get("ETC2_WONX"+i);    // ��Ÿ2 �� �ݾ�
                            e17BillData.ETC2_TEXT = box.get("ETC2_TEXT"+i);    // ��Ÿ2 �� �׸��
                            e17BillData.ETC3_WONX = box.get("ETC3_WONX"+i);    // ��Ÿ3 �� �ݾ�
                            e17BillData.ETC3_TEXT = box.get("ETC3_TEXT"+i);    // ��Ÿ3 �� �׸��
                            e17BillData.ETC4_WONX = box.get("ETC4_WONX"+i);    // ��Ÿ4 �� �ݾ�
                            e17BillData.ETC4_TEXT = box.get("ETC4_TEXT"+i);    // ��Ÿ4 �� �׸��
                            e17BillData.ETC5_WONX = box.get("ETC5_WONX"+i);    // ��Ÿ5 �� �ݾ�
                            e17BillData.ETC5_TEXT = box.get("ETC5_TEXT"+i);    // ��Ÿ5 �� �׸��
                            e17BillData.WAERS     = box.get("WAERS");            // ��ȭŰ


                            E17BillData_vt.addElement(e17BillData);
                        }
                        Logger.debug.println(this, "E17BillData : " + E17BillData_vt.toString());


                        E17HospitalResultData resultData = new E17HospitalResultData();
                        resultData.T_ZHRA006T = Utils.asVector(inputData);
                        resultData.T_ZHRW005A = E17HospitalData_vt;
                        resultData.T_ZHRW006A = E17BillData_vt;

 /* ���� ��û RFC ȣ�� */
                        E17HospitalRFC changeRFC = new E17HospitalRFC();
                        changeRFC.setChangeInput(user.empNo, UPMU_TYPE, approvalHeader.AINF_SEQN);

                        changeRFC.build(resultData, box, req);

                        if(!changeRFC.getReturn().isSuccess()) {
                            throw new GeneralException(changeRFC.getReturn().MSGTX);
                        }

                        return inputData.AINF_SEQN;
                        /* ������ �ۼ� �κ� �� */
                    }
                });
                printJspPage(req, res, dest);

            } else if( jobid.equals("AddOrDel") ) {     // �Ƿ�� �׸� �Է� �� �߰�

                E17HospitalData_vt = new Vector();
                E17BillData_vt     = new Vector();
                Vector AppLineData_vt = new Vector();

                // �Ƿ�� ���ڷ�  *��û�ÿ� �߰��Ǿ�� �� �׸��
                box.copyToEntity(e17SickData);
                Logger.debug.println(this, e17SickData.toString());

                // �Ƿ��
                int rowcount_hospital = box.getInt("RowCount_hospital");
                for( int i = 0; i < rowcount_hospital; i++) {
                    E17HospitalData e17HospitalData = new E17HospitalData();
                    String          idx             = Integer.toString(i);

                    if( box.get("use_flag"+idx).equals("N") ) continue;
                    e17HospitalData.CTRL_NUMB = box.get("CTRL_NUMB"    );  // ������ȣ
                    e17HospitalData.MEDI_NAME = box.get("MEDI_NAME"+idx);  // �Ƿ���
                    e17HospitalData.TELX_NUMB = box.get("TELX_NUMB"+idx);  // ��ȭ��ȣ
                    e17HospitalData.EXAM_DATE = box.get("EXAM_DATE"+idx);  // ������
                    e17HospitalData.MEDI_CODE = box.get("MEDI_CODE"+idx);  // �Կ�/�ܷ�
                    e17HospitalData.MEDI_TEXT = box.get("MEDI_TEXT"+idx);  // �Կ�/�ܷ�
                    e17HospitalData.RCPT_CODE = box.get("RCPT_CODE"+idx);  // ������ ����
                    e17HospitalData.RCPT_TEXT = box.get("RCPT_TEXT"+idx);  // ������ ����
                    e17HospitalData.RCPT_NUMB = box.get("RCPT_NUMB"+idx);  // No. ��������ȣ
                    e17HospitalData.EMPL_WONX = box.get("EMPL_WONX"+idx);  // ���� �ǳ��ξ�
                    e17HospitalData.WAERS     = box.get("WAERS");          // ��ȭŰ
//                  2004�� �������� ���� ����ڵ�Ϲ�ȣ �ʵ� �߰� (3.7)
                    e17HospitalData.MEDI_NUMB = box.get("MEDI_NUMB"+idx);    // �Ƿ��� ����ڵ�Ϲ�ȣ
                    e17HospitalData.MEDI_MTHD = box.get("MEDI_MTHD"+idx);    // @v1.1 ������� (1:����, 2:�ſ�ī��)
                    e17HospitalData.YTAX_WONX = box.get("YTAX_WONX"+idx);    // @v1.2 ��������ݿ���

                    E17HospitalData_vt.addElement(e17HospitalData);
                }
                Logger.debug.println(this, E17HospitalData_vt.toString());

                // �����
                //int rowcount_report = box.getInt("RowCount_report");
                int rowcount_report = box.getInt("RowCount_hospital");
                for( int i = 0; i < rowcount_report; i++) {
                    E17BillData e17BillData = new E17BillData();
                    String      idx         = Integer.toString(i);

                    if( box.get("use_flag"+idx).equals("N") ) continue;
                    e17BillData.CTRL_NUMB = box.get("CTRL_NUMB"    );    // ������ȣ
                    e17BillData.RCPT_NUMB = box.get("x_RCPT_NUMB"+idx);  // ��������ȣ
                    e17BillData.TOTL_WONX = box.get("TOTL_WONX"+idx);    // �� �����
                    e17BillData.ASSO_WONX = box.get("ASSO_WONX"+idx);    // ���� �δ��
                    e17BillData.EMPL_WONX = box.get("x_EMPL_WONX"+idx);  // ���� �δ��
                    e17BillData.MEAL_WONX = box.get("MEAL_WONX"+idx);    // �Ĵ�
                    e17BillData.APNT_WONX = box.get("APNT_WONX"+idx);    // ���� �����
                    e17BillData.ROOM_WONX = box.get("ROOM_WONX"+idx);    // ��� ���Ƿ� ����
                    e17BillData.CTXX_WONX = box.get("CTXX_WONX"+idx);    // C T �˻��
                    e17BillData.MRIX_WONX = box.get("MRIX_WONX"+idx);    // M R I �˻��
                    e17BillData.SWAV_WONX = box.get("SWAV_WONX"+idx);    // ������ �˻��
                    e17BillData.DISC_WONX = box.get("DISC_WONX"+idx);    // ���αݾ�
                    e17BillData.ETC1_WONX = box.get("ETC1_WONX"+idx);    // ��Ÿ1 �� �ݾ�
                    e17BillData.ETC1_TEXT = box.get("ETC1_TEXT"+idx);    // ��Ÿ1 �� �׸��
                    e17BillData.ETC2_WONX = box.get("ETC2_WONX"+idx);    // ��Ÿ2 �� �ݾ�
                    e17BillData.ETC2_TEXT = box.get("ETC2_TEXT"+idx);    // ��Ÿ2 �� �׸��
                    e17BillData.ETC3_WONX = box.get("ETC3_WONX"+idx);    // ��Ÿ3 �� �ݾ�
                    e17BillData.ETC3_TEXT = box.get("ETC3_TEXT"+idx);    // ��Ÿ3 �� �׸��
                    e17BillData.ETC4_WONX = box.get("ETC4_WONX"+idx);    // ��Ÿ4 �� �ݾ�
                    e17BillData.ETC4_TEXT = box.get("ETC4_TEXT"+idx);    // ��Ÿ4 �� �׸��
                    e17BillData.ETC5_WONX = box.get("ETC5_WONX"+idx);    // ��Ÿ5 �� �ݾ�
                    e17BillData.ETC5_TEXT = box.get("ETC5_TEXT"+idx);    // ��Ÿ5 �� �׸��
                    e17BillData.WAERS     = box.get("WAERS");            // ��ȭŰ

                    E17BillData_vt.addElement(e17BillData);
                }
                Logger.debug.println(this, E17BillData_vt.toString());

                Logger.debug.println(this, AppLineData_vt.toString());

                req.setAttribute("e17SickData"       , e17SickData);
                req.setAttribute("E17HospitalData_vt", E17HospitalData_vt);
                req.setAttribute("E17BillData_vt"    , E17BillData_vt);
                req.setAttribute("AppLineData_vt"    , AppLineData_vt);

//  XxxDetailSV.java �� XxxDetail.jsp �� '���/��ȭ��' ��ư Ȱ��ȭ ���θ� �����ִ� �κ�
//                    String ThisJspName = box.get("ThisJspName");
//                    req.setAttribute("ThisJspName", ThisJspName);
//  XxxDetailSV.java �� XxxDetail.jsp �� '���/��ȭ��' ��ư Ȱ��ȭ ���θ� �����ִ� �κ�

                printJspPage(req, res, WebUtil.JspURL+"E/E17Hospital/E17HospitalBuild.jsp");
            } else {
                throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
            }


        } catch(Exception e) {
            Logger.error(e);
            throw new GeneralException(e);
        } finally {
        }
    }
}
