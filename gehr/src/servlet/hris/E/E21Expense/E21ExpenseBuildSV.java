/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR ����                                                  */
/*   2Depth Name  : �����ڱ�                                                    */
/*   Program Name : �����ڱ� ��û                                               */
/*   Program ID   : E21ExpenseBuildSV                                           */
/*   Description  : ���ڱ�/���б� ��û�� �� �ֵ��� �ϴ� Class                   */
/*   Note         :                                                             */
/*   Creation     : 2002-01-03  �輺��                                          */
/*   Update       : 2005-03-07  ������                                          */
/*                  2006-02-03  @v1.1 lsa ���ڱݽ�û����(��,����б����б��� ���ļ�ó���Ͽ� ���� ���� ó��) */
/*                  2015-07-31  ������D [CSR ID:2840321] �系�κ� �ڳ� ���ڱ� ��û�� ������û*/
/*                  2017-05-22  eunha [CSR ID:3383001] �ؿ� ����� �����ڱ� ���� ����*/
/*						2018-04-19 cykim [CSR ID:3660657] ���ڱ� ����Ƚ�� üũ ���� ���� ��û�� �� */
/*                                                                              */
/********************************************************************************/

package servlet.hris.E.E21Expense;

import com.common.Utils;
import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;
import hris.A.A04FamilyDetailData;
import hris.A.rfc.A04FamilyDetailRFC;
import hris.E.E17Hospital.rfc.E17CompanyCoupleRFC;
import hris.E.E19Congra.E19CongcondData;
import hris.E.E19Congra.rfc.E19CongMoreRelaRFC;
import hris.E.E21Expense.E21ExpenseChkData;
import hris.E.E21Expense.E21ExpenseData;
import hris.E.E21Expense.rfc.E21ExpenceCheckRFC;
import hris.E.E21Expense.rfc.E21ExpenseBreakRFC;
import hris.E.E21Expense.rfc.E21ExpenseRFC;
import hris.E.E22Expense.E22ExpenseListData;
import hris.E.E22Expense.rfc.E22ExpenseListRFC;
import hris.common.*;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalLineData;
import hris.common.approval.ApprovalBaseServlet.RequestFunction;
import hris.common.rfc.AccountInfoRFC;
import hris.common.rfc.CurrencyCodeRFC;
import hris.common.rfc.PersonInfoRFC;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.util.Vector;

public class E21ExpenseBuildSV extends ApprovalBaseServlet {

    private String UPMU_TYPE ="06";   // ���� ����Ÿ��(���ڱ�/���б�)
    private String UPMU_NAME = "�����ڱ�";

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

            String dest = "";

            String msgFLAG = "";
            String msgTEXT = "";

            String jobid = box.get("jobid", "first");
            String PERNR = getPERNR(box, user); //��û����� ���

            box.put("PERNR", PERNR);
            box.put("I_PERNR", PERNR);

            // �븮 ��û �߰�
            PersonInfoRFC numfunc = new PersonInfoRFC();
            PersonData phonenumdata;
            //[CSR ID:3383001] �ؿ� ����� �����ڱ� ���� ���� start
            //phonenumdata = (PersonData)numfunc.getPersonInfo(PERNR);
            phonenumdata = (PersonData)numfunc.getPersonInfo(PERNR, "X");
          //[CSR ID:3383001] �ؿ� ����� �����ڱ� ���� ���� end

            //[CSR ID:2840321] �系�κ� �ڳ� ���ڱ� ��û�� ������û ����
            E17CompanyCoupleRFC  cc_rfc           = new E17CompanyCoupleRFC();
            String      CompanyCoupleYN = cc_rfc.getData(PERNR);
            //[CSR ID:2840321] �系�κ� �ڳ� ���ڱ� ��û�� ������û ��

            if( jobid.equals("first") ) {       //����ó�� ��û ȭ�鿡 ���°��.

            	//�������, ���� ��� ���� ��ȸ
                getApprovalInfo(req, PERNR);

                req.setAttribute("PERNR" , PERNR );
                req.setAttribute("PersonData" , phonenumdata );

                // �����ڱ� ������ CHECK - FLAG �� 'X'�� �����ڷ� �����ڱݽ�û�ǵ��� ��. -2004.09.06
                E21ExpenceCheckRFC    except_rfc  = new E21ExpenceCheckRFC();
                String eflag = except_rfc.getExceptFLAG( PERNR, "" );

                // 2003.03.19 �Ի����� �ټ� 6���� �̸��� ��� ��û�� ���� �ʵ��� �Ѵ�.
                if( user.companyCode.equals("C100") ) {
                    Vector E19Congra_vt = (new E19CongMoreRelaRFC()).getCongMoreRela(PERNR, DataUtil.getCurrentDate(),"");

                    E21ExpenseBreakRFC    chk_rfc  = new E21ExpenseBreakRFC();

                    String flag = chk_rfc.check(PERNR);

                    int work_year = 0;
                    int work_mnth = 0;

                    if( E19Congra_vt.size() > 0 ) {
                        E19CongcondData e19Data = (E19CongcondData)E19Congra_vt.get(0);
                        if( !e19Data.WORK_YEAR.equals("") && !e19Data.WORK_YEAR.equals("00") ) {
                            work_year = Integer.parseInt(e19Data.WORK_YEAR);
                        }
                        if( !e19Data.WORK_MNTH.equals("") && !e19Data.WORK_MNTH.equals("00") ) {
                            work_mnth = Integer.parseInt(e19Data.WORK_MNTH);
                        }

                        if( (work_year < 1) && (work_mnth < 6) && !eflag.equals("X")) {  // 6�����̸�
                            //String msg = "�ټ� 6���� �̸��� ��� ��û ����� �ƴմϴ�.";
                            msgFLAG = "C";
                            msgTEXT = g.getMessage("MSG.E.E22.0019");// "�ټ� 6���� �̸��� ��� ��û ����� �ƴմϴ�.";
                        }
                    }

                    if( flag.equals("N") ){
                        //String msg = "�����Ⱓ���� �����ڱ��� ��û�� �� �����ϴ�. ����ڿ��� ���� �ٶ��ϴ�.";
                        msgFLAG = "C";
                        msgTEXT = g.getMessage("MSG.E.E22.0020");//"�����Ⱓ���� �����ڱ��� ��û�� �� �����ϴ�. ����ڿ��� ���� �ٶ��ϴ�.";
                    }
                }
                // 2003.03.19 �Ի����� �ټ� 6���� �̸��� ��� ��û�� ���� �ʵ��� �Ѵ�.

                A04FamilyDetailRFC rfc = new A04FamilyDetailRFC();

                Vector A04FamilyDetailData_vt = null;
                Vector temp                   = new Vector();
                Vector E21ExpenseChkData_vt   = null;
                Vector data_vt                  = (new E22ExpenseListRFC()).getExpenseList( PERNR );

                Vector data1_vt                = (new E22ExpenseListRFC()).getExpenseList1( PERNR );
                Vector E22ExpenseListdata_vt = new Vector();

                E22ExpenseListData e22ExpenseListdata = new E22ExpenseListData();
                for( int j = 0 ; j < data_vt.size() ; j++ ) {
                	e22ExpenseListdata = (E22ExpenseListData)data_vt.get(j);
                	E22ExpenseListdata_vt.addElement(e22ExpenseListdata);
                }

                for( int j = 0 ; j < data1_vt.size() ; j++ ) {
                	e22ExpenseListdata = (E22ExpenseListData)data1_vt.get(j);
                	E22ExpenseListdata_vt.addElement(e22ExpenseListdata);
                }

                //Logger.debug.println(this,"====E22ExpenseListdata_vt 2222==="+ E22ExpenseListdata_vt.toString());

                A04FamilyDetailData_vt = rfc.getFamilyDetail(box);

                for( int i = 0 ; i < A04FamilyDetailData_vt.size() ; i++ ){
                    A04FamilyDetailData data = (A04FamilyDetailData)A04FamilyDetailData_vt.get(i);
                    if( data.SUBTY.equals("2") ){
                        temp.addElement(data);
                    }
                }

                A04FamilyDetailData_vt = temp;

                //����Ƚ�� �� ��������
                E21ExpenseChkData_vt = getCountTable(PERNR, A04FamilyDetailData_vt, data_vt, phonenumdata.E_OVERSEA);

                //Logger.debug.println(this,"====E21ExpenseChkData_vt==="+ E21ExpenseChkData_vt);

                if(A04FamilyDetailData_vt.size()==0){
                    //String msg = "���ڱ�/���б� ��û ��� �ڳడ �����ϴ�.";
                    msgFLAG = "C";
                    msgTEXT = g.getMessage("MSG.E.E22.0021");// "���ڱ�/���б� ��û ��� �ڳడ �����ϴ�.";
                }

                Vector currencyCodeList = new CurrencyCodeRFC().getCurrencyCode();

                req.setAttribute("eflag", eflag);
                req.setAttribute("msgFLAG", msgFLAG);
                req.setAttribute("msgTEXT", msgTEXT);
                req.setAttribute("currencyCodeList", currencyCodeList);
                req.setAttribute("A04FamilyDetailData_vt", A04FamilyDetailData_vt);
                req.setAttribute("E21ExpenseChkData_vt",   E21ExpenseChkData_vt);
                //req.setAttribute("E22ExpenseListData_vt",  data_vt);
                req.setAttribute("E22ExpenseListDataFull_vt",   E22ExpenseListdata_vt);
                req.setAttribute("CompanyCoupleYN"    , CompanyCoupleYN);	//[CSR ID:2840321] �系�κ� �ڳ� ���ڱ� ��û�� ������û

                dest = WebUtil.JspURL+"E/E21Expense/E21ExpenseBuild.jsp";
            } else if( jobid.equals("create") ) {


            	/* ���� ��û �κ� */
                dest = requestApproval(req, box, E21ExpenseData.class, new RequestFunction<E21ExpenseData>() {
                    public String porcess(E21ExpenseData inputData, Vector<ApprovalLineData> approvalLine) throws GeneralException {

                    	 /**** ��û�ȱݾ��� �Աݵ� ���������� �ִ��� üũ ******************/
                        AccountInfoRFC accountInfoRFC = new AccountInfoRFC();

                        if(! accountInfoRFC.hasPersAccount(box.get("PERNR")) ) {
                        	throw new GeneralException(g.getMessage("MSG.COMMON.0006")); //throw new GeneralException("���¹�ȣ�� ��ϵ��� ���� �ʽ��ϴ�.");
                       }
                        /**** ��û�ȱݾ��� �Աݵ� ���������� �ִ��� üũ ******************/

                        /* ���� ��û RFC ȣ�� */
                    	E21ExpenseRFC e21Rfc = new E21ExpenseRFC();
                    	e21Rfc.setRequestInput(user.empNo, UPMU_TYPE);

                    	//inputData.PERNR  = box.get("PERNR");
                    	inputData.ZPERNR = user.empNo;     // ��û�� ���(�븮��û, ���� ��û)
                    	inputData.UNAME  = user.empNo;     // ��û�� ���(�븮��û, ���� ��û)
                    	inputData.AEDTM  = DataUtil.getCurrentDate();  // ������(���糯¥)

                    	if( inputData.WAERS.equals("KRW") ) {
                    		inputData.PROP_AMNT = Double.toString(Double.parseDouble(inputData.PROP_AMNT) / 100 ) ;  // ��û��
                        }

        				box.put("I_GTYPE", "2");  // insert

                        //String AINF_SEQN = e21Rfc.build(box.get("PERNR"), "", E21ExpenseData_vt);
                        String AINF_SEQN = e21Rfc.build(Utils.asVector(inputData), box, req);

                        if(!e21Rfc.getReturn().isSuccess()) {
                        	 throw new GeneralException(e21Rfc.getReturn().MSGTX);
                        }
                        return AINF_SEQN;

                        /* ������ �ۼ� �κ� �� */
                    }
                });

            } else {
                throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
            }
            //Logger.debug.println(this, " destributed = " + dest);
            printJspPage(req, res, dest);

        } catch(Exception e) {
            throw new GeneralException(e);
        }

    }

    private Vector getCountTable(String empNo, Vector A04FamilyDetailData_vt, Vector data_vt, String e_oversea) throws GeneralException {
        Vector return_vt = new Vector();

        for( int i = 0 ; i < A04FamilyDetailData_vt.size(); i++ ) {
            A04FamilyDetailData ja_data = (A04FamilyDetailData)A04FamilyDetailData_vt.get(i);
            String subty = ja_data.SUBTY;
            String objps = ja_data.OBJPS;

            String gubn = "";
            String hak = "";

            if( ja_data.FASAR.equals("D1") ){  //�߰��
                gubn = "2";
                hak = "��";
            } else if( ja_data.FASAR.equals("E1") ) {
                gubn = "2";
                hak = "��";
            } else if( ja_data.FASAR.equals("F1") || ja_data.FASAR.equals("G1")
                    || ja_data.FASAR.equals("G2") || ja_data.FASAR.equals("H1")) {  //���л�
                gubn = "3";
                hak = "��";
            }

            // 2002.07.27. �ؿܱٹ����� ��� ��ġ��, �ʵ��л��� ���ڱ� ��û �����ϰ�
            if( e_oversea.equals("X") ) {
                if( ja_data.FASAR.equals("B1") || ja_data.FASAR.equals("C1") ){  //��ġ��, �ʵ��л�
                    gubn = "2";
                    hak = "��";   // �ӽ���ó��
                }
            }
            // 2002.07.27. �ؿܱٹ����� ��� ��ġ��, �ʵ��л��� ���ڱ� ��û �����ϰ�

            String count = "";
            String enter = "";

            for( int j = 0; j < data_vt.size(); j++ ) {
                E22ExpenseListData data = (E22ExpenseListData)data_vt.get(j);

                if( ja_data.FASAR.equals("B1") || ja_data.FASAR.equals("C1") ) {   //��ġ��, �ʵ��л�
                    if( subty.equals(data.FAMSA) && objps.equals(data.OBJC_CODE) && gubn.equals(data.SUBF_TYPE) &&
                            (data.ACAD_CARE.equals("B1") || data.ACAD_CARE.equals("C1")) ) {
                        if( !data.ENTR_FIAG.equals("X")&& !data.RFUN_FLAG.equals("X") ) {  //���б��� �ƴ� ��� @v1.2�߰� �� ����Ƚ���������ΰ� �ƴ� ���
                            count = data.P_COUNT;
                            break;
                        }
                    }
                } else if( ja_data.FASAR.equals("D1") ) {    //���л�
                    if( subty.equals(data.FAMSA) && objps.equals(data.OBJC_CODE) && gubn.equals(data.SUBF_TYPE) &&
                            data.ACAD_CARE.equals("D1"  ) ) {
                        if( !data.ENTR_FIAG.equals("X")&& !data.RFUN_FLAG.equals("X") ) {  //���б��� �ƴ� ���
                            count = data.P_COUNT;
                            break;
                        }
                    }
                } else if(  ja_data.FASAR.equals("E1") ) {    //����л�
                    if( subty.equals(data.FAMSA) && objps.equals(data.OBJC_CODE) && gubn.equals(data.SUBF_TYPE) &&
                            data.ACAD_CARE.equals("E1") ) {
                        if( !data.ENTR_FIAG.equals("X")&& !data.RFUN_FLAG.equals("X") ) {  //���б��� �ƴ� ���
                            count = data.P_COUNT;
                            break;
                        }
                    }
                } else if( ja_data.FASAR.equals("F1") || ja_data.FASAR.equals("G1") ||
                        ja_data.FASAR.equals("G2") || ja_data.FASAR.equals("H1") ) {    //���л�
                    if( subty.equals(data.FAMSA) && objps.equals(data.OBJC_CODE) && gubn.equals(data.SUBF_TYPE) &&
                            (data.ACAD_CARE.equals("F1") || data.ACAD_CARE.equals("G1") || data.ACAD_CARE.equals("G2") || data.ACAD_CARE.equals("H1")) ) {
                        if( !data.ENTR_FIAG.equals("X")&& !data.RFUN_FLAG.equals("X") ) {  //���б��� �ƴ� ���
                            count = data.P_COUNT;
                         //   Logger.debug.println(this, "------count = "+count + " [data] : "+data.toString());
                            break;
                        }
                    }
                }

                //Logger.debug.println(this, "[[[[[[[[count] = "+count + " [data] : "+data.toString());
            }

            for( int j = 0; j < data_vt.size(); j++ ) {
                E22ExpenseListData data = (E22ExpenseListData)data_vt.get(j);

                if( ja_data.FASAR.equals("B1") || ja_data.FASAR.equals("C1") ) {    //��ġ��, �ʵ��л�
                    if( subty.equals(data.FAMSA) && objps.equals(data.OBJC_CODE) && gubn.equals(data.SUBF_TYPE) &&
                            (data.ACAD_CARE.equals("B1") || data.ACAD_CARE.equals("C1")) ) {
                        if( data.ENTR_FIAG.equals("X") ) {  //���б��� ���
                            enter = data.P_COUNT;
                            break;
                        }
                    }
                } else if( ja_data.FASAR.equals("D1") || ja_data.FASAR.equals("E1") ) {    //���л�, ����л�
                    if( subty.equals(data.FAMSA) && objps.equals(data.OBJC_CODE) && gubn.equals(data.SUBF_TYPE) &&
                          (data.ACAD_CARE.equals(ja_data.FASAR)) ) {
                      //@v1.1 (data.ACAD_CARE.equals("D1") || data.ACAD_CARE.equals("E1")) ) {
                        if( data.ENTR_FIAG.equals("X") ) {  //���б��� ���
                            enter = data.P_COUNT;
                         //   Logger.debug.println(this, "[count======] = "+count  );
                            break;
                        }
                    }
                } else if( ja_data.FASAR.equals("F1") || ja_data.FASAR.equals("G1") ||
                        ja_data.FASAR.equals("G2") || ja_data.FASAR.equals("H1") ) {    //���л�
                    if( subty.equals(data.FAMSA) && objps.equals(data.OBJC_CODE) && gubn.equals(data.SUBF_TYPE) &&
                            (data.ACAD_CARE.equals("F1") || data.ACAD_CARE.equals("G1") || data.ACAD_CARE.equals("G2") || data.ACAD_CARE.equals("H1")) ) {
                        if( data.ENTR_FIAG.equals("X") ) {  //���б��� ���
                            enter = data.P_COUNT;
                            //[CSR ID:3660657] ���ڱ� ����Ƚ�� üũ ���� ���� ��û�� �� start
                            // ����Ƚ���� ���б� (1ȸ) Ƚ�� ���� ���б� ����Ƚ���� �Ѱ���. data_vt ����Ʈ�� ���б� �Ѱ��� ��� ����Ƚ�� count �ʵ忡 ���� �ȴ�� �ְ� �ֱ� ������ ����Ƚ�� ������ count�� ���� �����.
                            count = data.P_COUNT;
                            //[CSR ID:3660657] ���ڱ� ����Ƚ�� üũ ���� ���� ��û�� �� end
                            break;
                        }
                    }
                }
            }

            E21ExpenseChkData ret_data = new E21ExpenseChkData();
            ret_data.subty     = subty;
            ret_data.objps     = objps;
            ret_data.grade     = hak;
            ret_data.subf_type = gubn;
            ret_data.count     = count;
            ret_data.enter     = enter;

            return_vt.addElement(ret_data);
        }

        return return_vt;
    }
}
