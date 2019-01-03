/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR ����                                                  */
/*   2Depth Name  : �����ڱ�                                                    */
/*   Program Name : �����ڱ� ����                                               */
/*   Program ID   : E21ExpenseChangeSV                                          */
/*   Description  : ���ڱ�/���б� ������ �� �ֵ��� �ϴ� Class                   */
/*   Note         :                                                             */
/*   Creation     : 2002-01-03  �輺��                                          */
/*   Update       : 2005-03-07  ������                                          */
/*                  2006-02-03  @v1.1 lsa ���ڱݽ�û����(��,����б����б��� ���ļ�ó���Ͽ� ���� ���� ó��) */
/*                  2015-07-31  ������D [CSR ID:2840321] �系�κ� �ڳ� ���ڱ� ��û�� ������û*/
/*                  2017-05-22  eunha [CSR ID:3383001] �ؿ� ����� �����ڱ� ���� ����*/
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
import hris.E.E21Expense.rfc.E21ExpenseRFC;
import hris.E.E22Expense.E22ExpenseListData;
import hris.E.E22Expense.rfc.E22ExpenseListRFC;
import hris.common.*;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalHeader;
import hris.common.approval.ApprovalLineData;
import hris.common.approval.ApprovalBaseServlet.ChangeFunction;
import hris.common.rfc.CurrencyCodeRFC;
import hris.common.rfc.PersonInfoRFC;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.Vector;

public class E21ExpenseChangeSV extends ApprovalBaseServlet {

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
        	HttpSession session = req.getSession(false);
        	final WebUserData user = WebUtil.getSessionUser(req);
			final Box box = WebUtil.getBox(req);

			String dest = "";
			String jobid = box.get("jobid", "first");
			String PERNR = box.get("PERNR", user.empNo);//getPERNR(box, user); //��û����� ���

			String I_APGUB = (String) req.getAttribute("I_APGUB");  //��� ���������� �Գ�? '1' : ������ ���� , '2' : ������ ���� , '3' : ����Ϸ� ����
			String AINF_SEQN = box.get("AINF_SEQN");

			String msgFLAG = "";
            String msgTEXT = "";

			E21ExpenseRFC e21Rfc = new E21ExpenseRFC();
			e21Rfc.setDetailInput(user.empNo, I_APGUB, AINF_SEQN); // set DetailInput

            E21ExpenseData firstData = new E21ExpenseData();
            Vector E21ExpenseData_vt = new Vector();

            E21ExpenseData_vt = e21Rfc.detail(AINF_SEQN, "");
            Logger.debug.println(this, "�����ڱ� ��ȸ  : " + E21ExpenseData_vt);

            firstData = (E21ExpenseData)E21ExpenseData_vt.get(0);

            // �븮 ��û �߰�
            PersonInfoRFC numfunc = new PersonInfoRFC();
            PersonData phonenumdata;
            //[CSR ID:3383001] �ؿ� ����� �����ڱ� ���� ���� start
           // phonenumdata = (PersonData)numfunc.getPersonInfo(firstData.PERNR);
            phonenumdata = (PersonData)numfunc.getPersonInfo(firstData.PERNR, "X");
          //[CSR ID:3383001] �ؿ� ����� �����ڱ� ���� ���� end
            req.setAttribute("PersonData" , phonenumdata );


            if( jobid.equals("first") ) {     //����ó�� ��û ȭ�鿡 ���°��.

            	//[CSR ID:2840321] �系�κ� �ڳ� ���ڱ� ��û�� ������û ����
                E17CompanyCoupleRFC  cc_rfc           = new E17CompanyCoupleRFC();
                String      CompanyCoupleYN = cc_rfc.getData(firstData.PERNR);
                //[CSR ID:2840321] �系�κ� �ڳ� ���ڱ� ��û�� ������û ��

            	E21ExpenseData e21ExpenseData = new E21ExpenseData();

                // 2003.03.19 �Ի����� �ټ� 6���� �̸��� ��� ��û�� ���� �ʵ��� �Ѵ�.
                if( user.companyCode.equals("C100") ) {
                    Vector E19Congra_vt = (new E19CongMoreRelaRFC()).getCongMoreRela(firstData.PERNR, DataUtil.getCurrentDate(),"");
                    int    work_year    = 0;
                    int    work_mnth    = 0;

                    if( E19Congra_vt.size() > 0 ) {
                        E19CongcondData e19Data = (E19CongcondData)E19Congra_vt.get(0);
                        if( !e19Data.WORK_YEAR.equals("") && !e19Data.WORK_YEAR.equals("00") ) {
                            work_year = Integer.parseInt(e19Data.WORK_YEAR);
                        }
                        if( !e19Data.WORK_MNTH.equals("") && !e19Data.WORK_MNTH.equals("00") ) {
                            work_mnth = Integer.parseInt(e19Data.WORK_MNTH);
                        }

                        if( (work_year < 1) && (work_mnth < 6) ) {   // 6�����̸�
                            //String msg = "�ټ� 6���� �̸��� ��� ��û ����� �ƴմϴ�.";
                            msgFLAG = "C";
                            msgTEXT = "�ټ� 6���� �̸��� ��� ��û ����� �ƴմϴ�.";
                        }
                    }
                }
                // 2003.03.19 �Ի����� �ټ� 6���� �̸��� ��� ��û�� ���� �ʵ��� �Ѵ�.

                A04FamilyDetailRFC A_rfc          = new A04FamilyDetailRFC();

                Vector E21ExpenseChkData_vt   = null;
                Vector data_vt                = (new E22ExpenseListRFC()).getExpenseList( firstData.PERNR );
                Vector data1_vt                = (new E22ExpenseListRFC()).getExpenseList1( firstData.PERNR );
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

                Vector A04FamilyDetailData_vt = null;
                Vector temp                   = new Vector();
                box.put("I_PERNR", firstData.PERNR);
                A04FamilyDetailData_vt = A_rfc.getFamilyDetail(box);
                for( int i = 0 ; i < A04FamilyDetailData_vt.size() ; i++ ){
                    A04FamilyDetailData data = (A04FamilyDetailData)A04FamilyDetailData_vt.get(i);
                    if( data.SUBTY.equals("2") ){
                        temp.addElement(data);
                    }
                }
                A04FamilyDetailData_vt = temp;
                Logger.debug.println(this,A04FamilyDetailData_vt.toString());

                //����Ƚ�� �� ��������
                E21ExpenseChkData_vt = getCountTable(firstData.PERNR, A04FamilyDetailData_vt, data_vt, phonenumdata.E_OVERSEA);
                Logger.debug.println(this,E21ExpenseChkData_vt.toString());

                if( E21ExpenseData_vt.size() < 1 ){
                    //String msg = "System Error! \n\n ��û�� �׸��� �����ϴ�.";
                    msgFLAG = "C";
                    msgTEXT = "System Error! ��û�� �׸��� �����ϴ�.";
                }else if(A04FamilyDetailData_vt.size() < 0){
                    //String msg = "���ڱ�/���б� ��û ��� �ڳడ �����ϴ�.";
                    msgFLAG = "C";
                    msgTEXT = "���ڱ�/���б� ��û ��� �ڳడ �����ϴ�.";
                }

                e21ExpenseData = (E21ExpenseData)E21ExpenseData_vt.get(0);
                Vector currencyCodeList = new CurrencyCodeRFC().getCurrencyCode();

                req.setAttribute("isUpdate", true); //��� ���� ����
                req.setAttribute("msgFLAG", msgFLAG);
                req.setAttribute("msgTEXT", msgTEXT);
                req.setAttribute("e21ExpenseData" ,         e21ExpenseData);
                req.setAttribute("currencyCodeList", currencyCodeList);
                req.setAttribute("resultData" ,         e21ExpenseData);
                req.setAttribute("A04FamilyDetailData_vt",  A04FamilyDetailData_vt);
                req.setAttribute("E21ExpenseChkData_vt",    E21ExpenseChkData_vt);
                req.setAttribute("E22ExpenseListData_vt",   data_vt);
                req.setAttribute("E22ExpenseListDataFull_vt",   E22ExpenseListdata_vt);
                req.setAttribute("CompanyCoupleYN"    , CompanyCoupleYN);	//[CSR ID:2840321] �系�κ� �ڳ� ���ڱ� ��û�� ������û

                req.setAttribute("subty",      box.get("subty"));//�������� ýũ
                req.setAttribute("objps",      box.get("objps"));//�������� ýũ
                req.setAttribute("subf_type",  box.get("subf_type"));//�������� ýũ

                detailApporval(req, res, e21Rfc);

                printJspPage(req, res, WebUtil.JspURL + "E/E21Expense/E21ExpenseChange.jsp");

            } else if( jobid.equals("change") ) {

            	/* ���� ��û �κ� */
				dest = changeApproval(req, box, E21ExpenseData.class, e21Rfc, new ChangeFunction<E21ExpenseData>(){

					public String porcess(E21ExpenseData inputData, ApprovalHeader approvalHeader, Vector<ApprovalLineData> approvalLine) throws GeneralException {

        				inputData.PERNR  = inputData.PERNR;
        				inputData.ZPERNR = inputData.ZPERNR;    // ��û�� ���(�븮��û, ���� ��û)
        				inputData.UNAME  = user.empNo;          // ������ ���(�븮��û, ���� ��û)
    	                inputData.AEDTM  = DataUtil.getCurrentDate();  // ������(���糯¥)

    	                if( inputData.WAERS.equals("KRW") ) {
                    		inputData.PROP_AMNT = Double.toString(Double.parseDouble(inputData.PROP_AMNT) / 100 ) ;  // ��û��
                        }

                    	box.put("I_GTYPE", "3");

                    	/* ���� ��û RFC ȣ�� */
                    	E21ExpenseRFC changeRFC = new E21ExpenseRFC();
                		changeRFC.setChangeInput(user.empNo, UPMU_TYPE, approvalHeader.AINF_SEQN);

                        changeRFC.build(Utils.asVector(inputData), box, req);
                        //e21Rfc.change( AINF_SEQN, firstData.PERNR, e21ExpenseData );

                    	 //Logger.debug.println(this, "====changeRFC.getReturn().isSuccess()======== : " +  changeRFC.getReturn().isSuccess() );
                         //Logger.debug.println(this, "====changeRFC.getReturn().isSuccess()======== : " +  changeRFC.getReturn() );

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

            //printJspPage(req, res, dest);

        } catch(Exception e) {
            throw new GeneralException(e);
        }
    }

    //����Ƚ�� �� ��������
    private Vector getCountTable(String empNo, Vector A04FamilyDetailData_vt, Vector data_vt, String e_oversea) throws GeneralException {
        Vector return_vt = new Vector();

        for( int i = 0 ; i < A04FamilyDetailData_vt.size(); i++ ) {
            A04FamilyDetailData ja_data = (A04FamilyDetailData)A04FamilyDetailData_vt.get(i);
            String subty = ja_data.SUBTY;
            String objps = ja_data.OBJPS;

            String gubn = "";
            String hak = "";

            if( ja_data.FASAR.equals("D1") ){ //�߰��
                gubn = "2";
                hak = "��";
            } else if( ja_data.FASAR.equals("E1") ) {
                gubn = "2";
                hak = "��";
            } else if( ja_data.FASAR.equals("F1") || ja_data.FASAR.equals("G1")
                    || ja_data.FASAR.equals("G2") || ja_data.FASAR.equals("H1")) { //���л�
                gubn = "3";
                hak = "��";
            }

            //          2002.07.27. �ؿܱٹ����� ��� ��ġ��, �ʵ��л��� ���ڱ� ��û �����ϰ�
            if( e_oversea.equals("X") ) {
                if( ja_data.FASAR.equals("B1") || ja_data.FASAR.equals("C1") ){ //��ġ��, �ʵ��л�
                    gubn = "2";
                    hak = "��";       // �ӽ���ó��
                }
            }
            //          2002.07.27. �ؿܱٹ����� ��� ��ġ��, �ʵ��л��� ���ڱ� ��û �����ϰ�

            String count = "";
            String enter = "";

            for( int j = 0; j < data_vt.size(); j++ ) {
                E22ExpenseListData data = (E22ExpenseListData)data_vt.get(j);

                if( ja_data.FASAR.equals("B1") || ja_data.FASAR.equals("C1") ) {            //��ġ��, �ʵ��л�
                    if( subty.equals(data.FAMSA) && objps.equals(data.OBJC_CODE) && gubn.equals(data.SUBF_TYPE) &&
                            (data.ACAD_CARE.equals("B1") || data.ACAD_CARE.equals("C1")) ) {
                        if( !data.ENTR_FIAG.equals("X")&& !data.RFUN_FLAG.equals("X") ) {  //���б��� �ƴ� ��� @v1.2�߰� �� ����Ƚ���������ΰ� �ƴ� ���
                            count = data.P_COUNT;
                            break;
                        }
                    }
                    /*
                } else if( ja_data.FASAR.equals("D1") || ja_data.FASAR.equals("E1") ) {    //���л�, ����л�
                    if( subty.equals(data.FAMSA) && objps.equals(data.OBJC_CODE) && gubn.equals(data.SUBF_TYPE) &&
                            (data.ACAD_CARE.equals("D1") || data.ACAD_CARE.equals("E1")) ) {
                        if( !data.ENTR_FIAG.equals("X")&& !data.RFUN_FLAG.equals("X") ) {  //���б��� �ƴ� ���
                            count = data.P_COUNT;
                            break;
                        }
                    }*/
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
                            break;
                        }
                    }
                }
            }

            for( int j = 0; j < data_vt.size(); j++ ) {
                E22ExpenseListData data = (E22ExpenseListData)data_vt.get(j);

                if( ja_data.FASAR.equals("B1") || ja_data.FASAR.equals("C1") ) {            //��ġ��, �ʵ��л�
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
                      //@v1.1      (data.ACAD_CARE.equals("D1") || data.ACAD_CARE.equals("E1")) ) {
                        if( data.ENTR_FIAG.equals("X") ) {  //���б��� ���
                            enter = data.P_COUNT;
                            break;
                        }
                    }
                } else if( ja_data.FASAR.equals("F1") || ja_data.FASAR.equals("G1") ||
                        ja_data.FASAR.equals("G2") || ja_data.FASAR.equals("H1") ) {    //���л�
                    if( subty.equals(data.FAMSA) && objps.equals(data.OBJC_CODE) && gubn.equals(data.SUBF_TYPE) &&
                            (data.ACAD_CARE.equals("F1") || data.ACAD_CARE.equals("G1") || data.ACAD_CARE.equals("G2") || data.ACAD_CARE.equals("H1")) ) {
                        if( data.ENTR_FIAG.equals("X") ) {  //���б��� ���
                            enter = data.P_COUNT;
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
