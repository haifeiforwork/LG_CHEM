/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR ����                                                  */
/*   2Depth Name  : ������                                                      */
/*   Program Name : ������ ��û ����                                            */
/*   Program ID   : E19CongraChangeSV                                           */
/*   Description  : �������� ������ �� �ֵ��� �ϴ� Class                        */
/*   Note         : ����                                                        */
/*   Creation     : 2001-12-19  �輺��                                          */
/*   Update       : 2005-02-14  �̽���                                          */
/*                  2005-02-24  ������                                          */
/*                  2014-04-24  [CSR ID:C20140416_24713]  ȭȯ��û�� 0007 �ֹ���ü �����߰� , ����ӱ��������� , ��۾�ü���Ϲ߼�,sms�߰�,�ʱⱸ���� �߰�  ,������ ���� �߼�  */
/*                  2014-08-27  [CSR ID:2599072] ����ȭȯ ��û�� ���µ�� ���� ������ �ݿ��� ��   */
/*					 2017-07-03  eunha [CSR ID:3423281] ����ȭȯ �����Ļ� �޴� �߰�  */
/*                  2017-12-01 ������ [CSR ID:3546961] ����ȭȯ ��û ������ ��*/
/********************************************************************************/

package servlet.hris.E.E19Congra;

import hris.A.A17Licence.A17LicenceData;
import hris.A.A17Licence.rfc.A17LicenceRFC;
import hris.E.E19Congra.E19CongCodeCheckData;
import hris.E.E19Congra.E19CongFlowerInfoData;
import hris.E.E19Congra.E19CongGrupData;
import hris.E.E19Congra.E19CongcondData;
import hris.E.E19Congra.rfc.E19CongCodeCheckRFC;
import hris.E.E19Congra.rfc.E19CongMoreRelaRFC;
import hris.E.E19Congra.rfc.E19CongRateRFC;
import hris.E.E19Congra.rfc.E19CongraDupCheckRFC;
import hris.E.E19Congra.rfc.E19CongraFlowerInfoRFC;
import hris.E.E19Congra.rfc.E19CongraGrubNumbRFC;
import hris.E.E19Congra.rfc.E19CongraRequestRFC;
import hris.common.*;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalHeader;
import hris.common.approval.ApprovalLineData;
import hris.common.approval.ApprovalBaseServlet.ChangeFunction;
import hris.common.db.AppLineDB;
import hris.common.rfc.ESSExceptCheckRFC;
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
import com.sns.jdf.ConfigurationException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.db.DBUtil;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;

public class E19CongraChangeSV extends ApprovalBaseServlet
{
    private String UPMU_TYPE ="01";   // ���� ����Ÿ��(������)
    private String UPMU_NAME = "������";

    protected String getUPMU_TYPE() {
        return UPMU_TYPE;
    }

    protected String getUPMU_NAME() {
        return UPMU_NAME;
    }


    protected void performTask(final HttpServletRequest req, final HttpServletResponse res) throws GeneralException
    {
        Connection con = null;

        try{

            final WebUserData user = WebUtil.getSessionUser(req);

            final Box box = WebUtil.getBox(req);

            String dest = "";


            String jobid = box.get("jobid", "first");
            final String AINF_SEQN = box.get("AINF_SEQN");

            String I_APGUB = (String) req.getAttribute("I_APGUB");  //��� ���������� �Գ�? '1' : ������ ���� , '2' : ������ ���� , '3' : ����Ϸ� ����

            Vector E19CongcondData_rate = null;
            Vector AppLineData_vt       = null;
            Vector e19CongraDupCheck_vt = null;

            final E19CongcondData   firstData;
            //[CSR ID:3051290] ��ȭȯ ���� ��û ���� �ý��� ����  2016.07.13 �����S
            // jsp���� �� ���������� CONG_CODE �� ��´�
            String CONG_CODE = "";
            CONG_CODE = box.get("CONG_CODE");

            final E19CongraRequestRFC e19CongraRequestRFC = new E19CongraRequestRFC();
            e19CongraRequestRFC.setDetailInput(user.empNo, I_APGUB, box.get("AINF_SEQN"));
            Vector<E19CongcondData> resultList = e19CongraRequestRFC.getDetail(); //��� ����Ÿ
            firstData = resultList.get(0);
            //[CSR ID:3423281] ����ȭȯ �����Ļ� �޴� �߰� 20170703 eunha start
            String isFlower = "N";
            if (firstData.CONG_CODE.equals("0007") || firstData.CONG_CODE.equals("0010")){
            	isFlower = "Y";
            }
          //[CSR ID:3423281] ����ȭȯ �����Ļ� �޴� �߰� 20170703 eunha end
            req.setAttribute("isFlower" , isFlower );
            // �븮 ��û �߰�
            PersonInfoRFC numfunc = new PersonInfoRFC();
            final PersonData phonenumdata;
            phonenumdata = (PersonData)numfunc.getPersonInfo(firstData.PERNR);
            req.setAttribute("PersonData" , phonenumdata );


            if( jobid.equals("first") ) {    //���� ó�� ���� ȭ�鿡 ���°��.


                E19CongcondData_rate = (new E19CongRateRFC()).getCongRate(firstData.PERNR);

                // 2003.02.20 - �������� �ߺ���û�� .jsp���� �������ؼ� �߰���.
                e19CongraDupCheck_vt = (new E19CongraDupCheckRFC()).getCheckList( firstData.PERNR );

                /**** ��������(���¹�ȣ,�����)�� ���ΰ����´�. ����:2002/01/22 ****/
                hris.common.rfc.AccountInfoRFC accountInfoRFC = new hris.common.rfc.AccountInfoRFC();
                Vector AccountData_pers_vt = accountInfoRFC.getPersAccountInfo(firstData.PERNR);
                
                //[CSR ID:3546961] start--------------------------------
                ESSExceptCheckRFC essExcptChk = new ESSExceptCheckRFC();
                String exceptChk = essExcptChk.essExceptcheck(firstData.PERNR, "E0"+UPMU_TYPE).MSGTY;
                Logger.debug.println("������ ���� ���� ��� : "+firstData.PERNR+", ���� �ڵ� : "+exceptChk);
                req.setAttribute("ESS_EXCPT_CHK" , exceptChk );
                //[CSR ID:3546961] end--------------------------------

                AccountData AccountData_hidden = new AccountData();
                DataUtil.fixNull(AccountData_hidden);
                req.setAttribute("AccountData_hidden" , AccountData_hidden );

                req.setAttribute("AccountData_pers_vt", AccountData_pers_vt);
                /**** ��������(���¹�ȣ,�����)�� ���ΰ����´�.****/
Logger.debug.println("firstData----------------"+firstData);
                req.setAttribute("resultData", Utils.indexOf(resultList, 0));
                req.setAttribute("e19CongcondData",  firstData);
                req.setAttribute("E19CongcondData_rate", E19CongcondData_rate);
                req.setAttribute("e19CongraDupCheck_vt", e19CongraDupCheck_vt);
                req.setAttribute("isUpdate", true); //��� ���� ����

                detailApporval(req, res, e19CongraRequestRFC);


                dest = WebUtil.JspURL+"E/E19Congra/E19CongraBuild.jsp";

            } else if( jobid.equals("change") ) { //
                /* ���� ��û �κ� */
                dest = changeApproval(req, box, E19CongcondData.class, e19CongraRequestRFC, new ChangeFunction<E19CongcondData>(){

                    public String porcess(E19CongcondData inputData, ApprovalHeader approvalHeader, Vector<ApprovalLineData> approvalLineDatas) throws GeneralException {
                    	String dest="";
                    	inputData.PERNR     = firstData.PERNR;

                        /**** ��û�ȱݾ��� �Աݵ� ���������� �ִ��� üũ ******************************************/
//                      [CSR ID:2599072] ����ȭȯ ��û�� ���µ�� ���� ������ �ݿ��� ��
                        if(!inputData.CONG_CODE.equals("0007")){
        	                hris.common.rfc.AccountInfoRFC accountInfoRFC = new hris.common.rfc.AccountInfoRFC();
        	                if( ! accountInfoRFC.hasPersAccount(firstData.PERNR) ){
        	                    String msg = "msg006";
        	                    req.setAttribute("msg", msg);
        	                    dest = WebUtil.JspURL+"common/caution.jsp";
        	                    throw new GeneralException(msg);
        	                }
                        }
                        /**** ��û�ȱݾ��� �Աݵ� ���������� �ִ��� üũ ******************************************/

                        Vector e19CongCodeCheck_vt  = null;  // @v1.1
                        E19CongCodeCheckData Check_vt  = (E19CongCodeCheckData)(new E19CongCodeCheckRFC()).getCongCodeCheck( "C100", inputData.CONG_DATE,inputData.CONG_CODE,inputData.RELA_CODE,inputData.PERNR );

                  Logger.debug.println("Check_vt = " + Check_vt.toString());
                        if(  !Check_vt.E_FLAG.equals("Y")  ){
                            String msg = Check_vt.E_MESSAGE;
                            req.setAttribute("msg", msg);
                            dest = WebUtil.JspURL+"common/caution.jsp";
                            throw new GeneralException(msg);
                        }


                          /* ���� ��û RFC ȣ�� */
                    	E19CongraRequestRFC changeRFC = new E19CongraRequestRFC();
                        changeRFC.setChangeInput(user.empNo, UPMU_TYPE, approvalHeader.AINF_SEQN);

                        Logger.debug("-------- AINF_SEQN " + inputData.AINF_SEQN);

                        changeRFC.build(inputData, box, req);

                        if(!changeRFC.getReturn().isSuccess()) {
                            throw new GeneralException(changeRFC.getReturn().MSGTX);
                        }


                        // [C20140416_24713] �ֹ� ��ü ���� ���� �߼�  start
                        if (inputData.CONG_CODE.equals("0007") || inputData.CONG_CODE.equals("0010")) { //ȭ��, ��ȭȯ ��û�ø�
    	                 	   //�ٹ�������Ʈ
    	                 	   Vector E19CongraGrubNumb_vt  = (new E19CongraGrubNumbRFC()).getGrupCode(user.companyCode,"010");
    	                 	   String ZGRUP_NUMB_O_NM="";
    	                 	   String ZGRUP_NUMB_R_NM="";
    	                 	   for( int i = 0 ; i < E19CongraGrubNumb_vt.size() ; i++ ){
    	                 		   E19CongGrupData  data = (E19CongGrupData)E19CongraGrubNumb_vt.get(i);
    	                 		   if (inputData.ZGRUP_NUMB_O.equals( data.GRUP_NUMB)){
    	                 			   ZGRUP_NUMB_O_NM=data.GRUP_NAME;
    	                 		   }
    	                 		   if (inputData.ZGRUP_NUMB_R.equals( data.GRUP_NUMB)){
    	                 			   ZGRUP_NUMB_R_NM=data.GRUP_NAME;
    	                 		   }
    	                 	   }
    	                         //CSR ID: 20140416_24713 ȭȯ��ü
    	                 	    //[CSR ID:3051290] ��ȭȯ ���� ��û ���� �ý��� ����  2016.07.13 �����S
    	                         Vector e19CongFlowerInfoData_vt = (new E19CongraFlowerInfoRFC()).getFlowerInfoCode(inputData.CONG_CODE);
    	                         String msg2="";
    	                         String msg;
    	                     	for( int i = 0 ; i < e19CongFlowerInfoData_vt.size() ; i++ ){
    	                     	   E19CongFlowerInfoData  data = (E19CongFlowerInfoData)e19CongFlowerInfoData_vt.get(i);


    	         	                Properties ptMailBody1 = new Properties();
    	         	                ptMailBody1.setProperty("SServer",user.SServer);              // ElOffice ���� ����
    	         	                ptMailBody1.setProperty("from_empNo" ,user.empNo);            // �� �߼��� ���
    	         	                ptMailBody1.setProperty("to_empNo" ,data.ZEMAIL);  // �ڸ� ������ ����id ���� �ֱ�


    	         	                ptMailBody1.setProperty("ename_R" ,user.ename);       // (��)��û�ڸ�

    	         	                //[CSR ID:3051290] ��ȭȯ ���� ��û ���� �ý��� ����  2016.07.13 �����S
    	         	               if(inputData.CONG_CODE.equals("0007")) {
    	         	                ptMailBody1.setProperty("UPMU_NAME" ,"LGȭ�� ȭȯ ��û ���� ����");               // ���� �̸�
    	         	               } else if(inputData.CONG_CODE.equals("0010")) {
    	         	            	  ptMailBody1.setProperty("UPMU_NAME" ,"LGȭ�� ��ȭȯ ��û ���� ����");
    	         	               }

    	         	                ptMailBody1.setProperty("AINF_SEQN" ,AINF_SEQN);              // ��û�� ����
    	         	                ptMailBody1.setProperty("ZGRUP_NUMB_O" ,ZGRUP_NUMB_O_NM);              // ��û�� �ٹ���
    	         	                ptMailBody1.setProperty("ZPHONE_NUM" ,inputData.ZPHONE_NUM);              // ��û�� ��ȭ��ȣ
    	         	                ptMailBody1.setProperty("ZCELL_NUM" ,inputData.ZCELL_NUM);              // ��û�� �ڵ���

    	         	                ptMailBody1.setProperty("ename" ,inputData.ZUNAME_R);       //�����(������)
    	         	                ptMailBody1.setProperty("empno" ,inputData.PERNR);       // (��)��û�� ���
    	         	                ptMailBody1.setProperty("ZCELL_NUM_R" ,inputData.ZCELL_NUM_R);              // ����� ����ó

    			 	                ptMailBody1.setProperty("RELA_NAME" ,inputData.RELA_NAME);              // ��������� ����
    			 	                ptMailBody1.setProperty("EREL_NAME" ,inputData.EREL_NAME);              // ��������� ����


    	         	                ptMailBody1.setProperty("ZGRUP_NUMB_R" ,ZGRUP_NUMB_R_NM);              // ����� �ٹ���
    	         	                ptMailBody1.setProperty("E_ORGTX" ,phonenumdata.E_ORGTX);              // ����� �μ�
    	         	                ptMailBody1.setProperty("E_PTEXT" ,phonenumdata.E_PTEXT);              // �ź�
    	         	                ptMailBody1.setProperty("E_CFLAG" ,  inputData.ZUNION_FLAG.equals("X") ? "���տ�: Y" : ""   );              // ���տ�����
    	         	                ptMailBody1.setProperty("ZTRANS_DATE" ,WebUtil.printDate(inputData.ZTRANS_DATE,"."));              // �������
    	         	                ptMailBody1.setProperty("ZTRANS_TIME" ,WebUtil.printTime( inputData.ZTRANS_TIME ) );              // ��۽ð�

    	         	                ptMailBody1.setProperty("ZTRANS_ADDR" ,inputData.ZTRANS_ADDR);              // ����� �ּ�
    	         	                ptMailBody1.setProperty("ZTRANS_ETC" ,inputData.ZTRANS_ETC);              // ��Ÿ �䱸����

    	         	                //[CSR ID:3051290] ��ȭȯ ���� ��û ���� �ý��� ����  2016.07.13 �����S
    	         	               if(inputData.CONG_CODE.equals("0007")) {
    	         	            	   ptMailBody1.setProperty("title" ,"ȭȯ ��û ������ �Ʒ��� ���� ����Ǿ����ϴ�.");              // ����Ÿ��Ʋ
    	         	               } else if(inputData.CONG_CODE.equals("0010")) {
    	         	            	  ptMailBody1.setProperty("title" ,"��ȭȯ ��û ������ �Ʒ��� ���� ����Ǿ����ϴ�.");
    	         	               }
    	         	                //��û�� ������ ���� ������.
    	         	                // 2002.07.25.------------------------------------------------------------------------

    	         	                // �� ����
    	         	                StringBuffer sbSubject1 = new StringBuffer(512);

    	         	                sbSubject1.append("[" + ptMailBody1.getProperty("UPMU_NAME") + "] ");

    	         	                //[CSR ID:3051290] ��ȭȯ ���� ��û ���� �ý��� ����  2016.07.13 �����S
    	         	               if(inputData.CONG_CODE.equals("0007")) {
    	         	            	   sbSubject1.append( ptMailBody1.getProperty("ename") + "���� ȭȯ ��û ���������� ����Ǿ����ϴ�.");
    	         	               } else if(inputData.CONG_CODE.equals("0010")) {
    	         	            	   sbSubject1.append( ptMailBody1.getProperty("ename") + "���� ��ȭȯ ��û ���������� ����Ǿ����ϴ�.");
    	         	               }

    	         	                ptMailBody1.setProperty("subject" ,sbSubject1.toString());    // �� ���� ����

    	         	                ptMailBody1.setProperty("FileName" ,"FlowerMailBuild.html");

    	         	                MailSendToOutside maTe1;
									try {
										maTe1 = new MailSendToOutside(ptMailBody1);
									} catch (ConfigurationException e) {
										throw new GeneralException(e);
									}

    	         	                if (!maTe1.process()) {
    	         	                    msg2 = msg2+maTe1.getMessage();
    	         	                } // end if
    	         	               msg ="���� �Ǿ����ϴ�.�ֹ���ü�� ���� ���� ������ �߼۵Ǿ����ϴ�.";

    		         	              Logger.debug.println(this, "====���� ��ü ����  msg =[  " + msg+"]]]]]data.ZEMAIL:"+data.ZEMAIL);
    	                     	}
                        }
                        // [C20140416_24713] �ֹ� ��ü ���� ���� �߼�  end
                        return inputData.AINF_SEQN;
                        /* ������ �ۼ� �κ� �� */
                    }
                });
            }else if(jobid.equals("change_code")) {//��ûȭ�鿡�� ȭȯ �� ��ȭȭ�� �����Ͽ��� ��, �������� ������ ���� ������ �ѹ� ź��


                E19CongcondData_rate = (new E19CongRateRFC()).getCongRate(firstData.PERNR);

                // 2003.02.20 - �������� �ߺ���û�� .jsp���� �������ؼ� �߰���.
                e19CongraDupCheck_vt = (new E19CongraDupCheckRFC()).getCheckList( firstData.PERNR );

                /**** ��������(���¹�ȣ,�����)�� ���ΰ����´�. ����:2002/01/22 ****/
                hris.common.rfc.AccountInfoRFC accountInfoRFC = new hris.common.rfc.AccountInfoRFC();
                Vector AccountData_pers_vt = accountInfoRFC.getPersAccountInfo(firstData.PERNR);

              //[CSR ID:3051290] ��ȭȯ ���� ��û ���� �ý��� ����  2016.07.13 �����S
                String CONG_CODE_SV = "";
                if( CONG_CODE.equals("0007") ) { //ȭȯ �������� ���
                 		CONG_CODE_SV = CONG_CODE;

                 	} else if( CONG_CODE.equals("0010")) { //��ȭȯ �������� ���
                 		CONG_CODE_SV = CONG_CODE;
                 	}

                 req.setAttribute("CONG_CODE_SV" , CONG_CODE_SV );
                 firstData.CONG_CODE = CONG_CODE_SV;
                 
                 //[CSR ID:3546961] start--------------------------------
                 ESSExceptCheckRFC essExcptChk = new ESSExceptCheckRFC();
                 String exceptChk = essExcptChk.essExceptcheck(firstData.PERNR, "E0"+UPMU_TYPE).MSGTY;
                 Logger.debug.println("������ ���� ���� ��� : "+firstData.PERNR+", ���� �ڵ� : "+exceptChk);
                 req.setAttribute("ESS_EXCPT_CHK" , exceptChk );
                 //[CSR ID:3546961] end--------------------------------

                AccountData AccountData_hidden = new AccountData();
                DataUtil.fixNull(AccountData_hidden);
                req.setAttribute("AccountData_hidden" , AccountData_hidden );

                req.setAttribute("AccountData_pers_vt", AccountData_pers_vt);
                /**** ��������(���¹�ȣ,�����)�� ���ΰ����´�.****/

                req.setAttribute("e19CongcondData",  firstData);
                req.setAttribute("E19CongcondData_rate", E19CongcondData_rate);
                req.setAttribute("e19CongraDupCheck_vt", e19CongraDupCheck_vt);


                dest = WebUtil.JspURL+"E/E19Congra/E19CongraBuild.jsp";


            } else {
                throw new GeneralException("���θ��(jobid)�� �ùٸ��� �ʽ��ϴ�. ");
            }
            Logger.debug.println(this, " destributed = " + dest);
            printJspPage(req, res, dest);

        } catch(Exception e) {
            throw new GeneralException(e);
        }
    }
}

