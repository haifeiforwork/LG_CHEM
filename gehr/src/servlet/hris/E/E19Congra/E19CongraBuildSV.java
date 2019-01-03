/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR ����                                                  */
/*   2Depth Name  : ������                                                      */
/*   Program Name : ������ ��û                                                 */
/*   Program ID   : E19CongraBuildSV                                            */
/*   Description  : �������� ��û�� �� �ֵ��� �ϴ� Class                        */
/*   Note         : ����                                                        */
/*   Creation     : 2001-12-19  �輺��                                          */
/*   Update       : 2005-02-14  �̽���                                          */
/*                  2005-03-07  ������                                          */
/*                  2006-06-20  @v1.1     üũ�����߰�                          */
/*                  2014-04-21  CSR ID: 20140416_24713 ȭȯ��ü�߰�                     */
/*                  2014-08-27  [CSR ID:2599072] ����ȭȯ ��û�� ���µ�� ���� ������ �ݿ��� ��   */
/*					 2017-07-03  eunha [CSR ID:3423281] ����ȭȯ �����Ļ� �޴� �߰�  */
/*					 2017-07-26  eunha [CSR ID:3444623] ������ ��û ȭ�� ��ũ��Ʈ ���� ����  */
/*                  2017-12-01  ������ [CSR ID:3546961] ����ȭȯ ��û ������ ��*/
/********************************************************************************/

package servlet.hris.E.E19Congra;

import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.Properties;
import java.util.Vector;

import javax.servlet.http.*;

import org.apache.commons.lang.math.NumberUtils;

import com.common.Utils;
import com.sns.jdf.*;
import com.sns.jdf.util.*;
import com.sns.jdf.servlet.*;

import hris.common.*;
import hris.common.util.*;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalLineData;
import hris.common.approval.ApprovalBaseServlet.RequestFunction;
import hris.common.db.UplusSmsDB;
import hris.common.rfc.*;
import hris.A.A17Licence.A17LicenceData;
import hris.A.A17Licence.rfc.A17LicenceRFC;
import hris.D.D03Vocation.D03RemainVocationData;
import hris.D.D03Vocation.rfc.D03RemainVocationRFC;
import hris.E.E19Congra.rfc.*;
import hris.E.E19Congra.*;

public class E19CongraBuildSV extends ApprovalBaseServlet
{
    private String UPMU_TYPE ="01";   // ���� ����Ÿ��(������)
    private String UPMU_NAME = "������";

    protected String getUPMU_TYPE() {
        return UPMU_TYPE;
    }

    protected String getUPMU_NAME() {
        return UPMU_NAME;
    }

    //[CSR ID:3423281] ����ȭȯ �����Ļ� �޴� �߰� 20170703 start
    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {
    	process(req, res, "N");
	}
      //protected void process(final HttpServletRequest req, HttpServletResponse res) throws GeneralException
    protected void process(final HttpServletRequest req, HttpServletResponse res, String isFlower) throws GeneralException
    //[CSR ID:3423281] ����ȭȯ �����Ļ� �޴� �߰� 20170703 end
    {

        try {

            final WebUserData user = WebUtil.getSessionUser(req);

            final Box box = WebUtil.getBox(req);

            String dest = "";

            // [CSR ID:3051290] ��ȭȯ ���� ��û ���� �ý��� ����  2016.07.13 �����S
            // jsp���� �Ѿ�� ���������� ��Ƶδ� ���� CONG_CODE ����
            String CONG_CODE = "";
            String jobid = box.get("jobid", "first");
            CONG_CODE = box.get("CONG_CODE");


           final String PERNR = getPERNR(box, user); //��û����� ���

            // �븮 ��û �߰�
            PersonInfoRFC numfunc = new PersonInfoRFC();
            final PersonData phonenumdata;
            phonenumdata    =   (PersonData)numfunc.getPersonInfo(PERNR);
             req.setAttribute("PersonData" , phonenumdata );

            Logger.debug.println("=============PersonData:"+phonenumdata );
            req.setAttribute("isFlower" , isFlower); //[CSR ID:3423281] ����ȭȯ �����Ļ� �޴� �߰� 20170703

            if( jobid.equals("first") ) {           //����ó�� ��û ȭ�鿡 ���°��.

                Vector E19CongcondData_more = null;
                Vector e19CongraDupCheck_vt = null;
                Vector e19CongraLifnr_vt    = null;  // �μ���������



                if ( phonenumdata.E_RECON.equals("")) {
                    // ����
                	 getApprovalInfo(req, PERNR);

                } else {
                    // ������ �����϶��� �������� �Ϸ��� ��¥�� I_DATE �� �־��ش�. 2005.04.15 �߰�
                    String reday = DataUtil.removeStructur(phonenumdata.E_REDAY, "-");
                    getApprovalInfo(req, PERNR,DataUtil.addDays(reday, -1));

                }

                E19CongcondData_more = (new E19CongMoreRelaRFC()).getCongMoreRela( PERNR, DataUtil.getCurrentDate() ,"1");
                E19CongcondData e19CongcondData = (E19CongcondData)E19CongcondData_more.get(0);
                e19CongcondData.PERNR = PERNR;

                // 2003.02.20 - �������� �ߺ���û�� .jsp���� �������ؼ� �߰���.
                e19CongraDupCheck_vt = (new E19CongraDupCheckRFC()).getCheckList( PERNR );

                // ��������(���¹�ȣ,�����)�� ���ΰ����´�. ����:2002/01/22
                hris.common.rfc.AccountInfoRFC accountInfoRFC = new hris.common.rfc.AccountInfoRFC();
                Vector AccountData_pers_vt = accountInfoRFC.getPersAccountInfo(PERNR);

                AccountData AccountData_hidden = new AccountData();
                DataUtil.fixNull(AccountData_hidden);
                
                //[CSR ID:3546961] start--------------------------------
                ESSExceptCheckRFC essExcptChk = new ESSExceptCheckRFC();
                String exceptChk = essExcptChk.essExceptcheck(PERNR, "E0"+UPMU_TYPE).MSGTY;
                Logger.debug.println("������ ��û ���� ��� : "+PERNR+", ���� �ڵ� : "+exceptChk);
                req.setAttribute("ESS_EXCPT_CHK" , exceptChk );
                //[CSR ID:3546961] end--------------------------------
                
                req.setAttribute("AccountData_hidden" , AccountData_hidden );
                req.setAttribute("AccountData_pers_vt", AccountData_pers_vt);
                // ��������(���¹�ȣ,�����)�� ���ΰ����´�.
                req.setAttribute("e19CongcondData",      e19CongcondData);
                Logger.debug.println(this,e19CongcondData );
                req.setAttribute("e19CongraDupCheck_vt", e19CongraDupCheck_vt);

                dest = WebUtil.JspURL+"E/E19Congra/E19CongraBuild.jsp";

           //[CSR ID:3444623] ������ ��û ȭ�� ��ũ��Ʈ ���� ���� start
            } else if (jobid.equals("check")) {	//��¥ üũ.

			    String i_CONG_DATE = req.getParameter("CONG_DATE");
			    String i_PERNR     = req.getParameter("PERNR");
			    String i_CONG_CODE = req.getParameter("CONG_CODE");
			    String i_RELA_CODE = req.getParameter("RELA_CODE");

			    Vector E19CongcondData_vt = (new E19CongMoreRelaRFC()).getCongMoreRela(i_PERNR, i_CONG_DATE,"1");

			    if( E19CongcondData_vt.size() > 0 ){
			        E19CongcondData e19CongcondData = (E19CongcondData)E19CongcondData_vt.get(0);

			    Vector e19CongCodeCheck_vt  = null;  // @v1.1
			    E19CongCodeCheckData Check_vt  = (E19CongCodeCheckData)(new E19CongCodeCheckRFC()).getCongCodeCheck( "C100", i_CONG_DATE,i_CONG_CODE,i_RELA_CODE,i_PERNR );

			    PrintWriter out = res.getWriter();

				out.println(Check_vt.E_FLAG + "||" + Check_vt.E_MESSAGE+ "||"); // fail

				out.println(e19CongcondData.WORK_YEAR + "||" + e19CongcondData.WORK_MNTH+ "||" + WebUtil.printNumFormat(e19CongcondData.WAGE_WONX) );

					Logger.debug.println("[#####]	JOBID	 :	[ " + jobid + " ]	0) Check_vt.E_FLAG		 			 :	[ " + Check_vt.E_FLAG + " ]");
					Logger.debug.println("[#####]	JOBID	 :	[ " + jobid + " ]	1) Check_vt.E_MESSAGE 	 :	[ " + Check_vt.E_MESSAGE  + " ]");
					Logger.debug.println("[#####]	JOBID	 :	[ " + jobid + " ]	2) e19CongcondData.WORK_YEAR 		 :	[ " + e19CongcondData.WORK_YEAR  + " ]");
					Logger.debug.println("[#####]	JOBID	 :	[ " + jobid + " ]	3) e19CongcondData.WORK_MNTH		 :	[ " + e19CongcondData.WORK_MNTH + " ]");
					Logger.debug.println("[#####]	JOBID	 :	[ " + jobid + " ]	4) e19CongcondData.WAGE_WONX		 :	[ " + WebUtil.printNumFormat(e19CongcondData.WAGE_WONX) + " ]");
				}

				return;
			//[CSR ID:3444623] ������ ��û ȭ�� ��ũ��Ʈ ���� ���� end
            }else if( jobid.equals("create") ) {

                /* ���� ��û �κ� */
                dest = requestApproval(req, box, E19CongcondData.class, new RequestFunction<E19CongcondData>() {
                    public String porcess(E19CongcondData inputData, Vector<ApprovalLineData> approvalLine) throws GeneralException {
                    	String dest="";

                        Vector e19CongCodeCheck_vt  = null;  // @v1.1
                        E19CongCodeCheckData Check_vt  = (E19CongCodeCheckData)(new E19CongCodeCheckRFC()).getCongCodeCheck( "C100", inputData.CONG_DATE,inputData.CONG_CODE,inputData.RELA_CODE,inputData.PERNR );

                        if(  !Check_vt.E_FLAG.equals("Y")  ){
                            String msg = Check_vt.E_MESSAGE;
                            req.setAttribute("msg", msg);
                            dest = WebUtil.JspURL+"common/caution.jsp";
                            throw new GeneralException(msg);
                        }

                        /**** ��û�ȱݾ��� �Աݵ� ���������� �ִ��� üũ ****************************************************/
                        //[CSR ID:2599072] ����ȭȯ ��û�� ���µ�� ���� ������ �ݿ��� ��
                        if(!inputData.CONG_CODE.equals("0007")){
        	                hris.common.rfc.AccountInfoRFC accountInfoRFC = new hris.common.rfc.AccountInfoRFC();
        	                if( ! accountInfoRFC.hasPersAccount(PERNR) ){
        	                    String msg = "msg006";
        	                    req.setAttribute("msg", msg);
        	                    dest = WebUtil.JspURL+"common/caution.jsp";
        	                    Logger.debug.println(this, " destributed = " + dest);
        	                    throw new GeneralException(msg);
        	                }
                        }
                        /**** ��û�ȱݾ��� �Աݵ� ���������� �ִ��� üũ ****************************************************/

                        /* ���� ��û RFC ȣ�� */
                        E19CongraRequestRFC e19CongraRequestRFC = new E19CongraRequestRFC();
                        e19CongraRequestRFC.setRequestInput(user.empNo, UPMU_TYPE);
                        String AINF_SEQN = e19CongraRequestRFC.build(inputData, box, req);

                        if(!e19CongraRequestRFC.getReturn().isSuccess()) {
                            throw new GeneralException(e19CongraRequestRFC.getReturn().MSGTX);
                        };
                        String msg = "msg001";
                        String msg2 = "";

                        ////////////////�ֹ���ü ���Ϲ߼� sms ///////////////////////////////
                  	   //�ٹ�������Ʈ

                         // [C20140416_24713] �ֹ� ��ü ���� ���� �߼�  start
                         //[CSR ID:3051290] ��ȭȯ ���� ��û ���� �ý��� ����  2016.07.13 �����S
                         //ȭȯ�� ��쿡 �ش��ϴ� ������ ��ȭȯ�� ����
                         if (inputData.CONG_CODE.equals("0007") || inputData.CONG_CODE.equals("0010")){ //ȭ��, ��ȭȯ ��û�ø�

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

         		                 UplusSmsDB smsDB = new UplusSmsDB(); //SMS
         		                 UplusSmsData smsData = new UplusSmsData(); //SMS

         		           //      String msg2 = null;

         		                 //[CSR ID:3051290] ��ȭȯ ���� ��û ���� �ý��� ����  2016.07.13 �����S
         		                 //��ȭȯ�� ���� ȭȯ�� �ٸ� ���ڰ� ������ ����
         		             	for( int i = 0 ; i < e19CongFlowerInfoData_vt.size() ; i++ ){
         		             		if(i==0) {
         		             	   E19CongFlowerInfoData  data = (E19CongFlowerInfoData)e19CongFlowerInfoData_vt.get(i);


         		 	                Properties ptMailBody1 = new Properties();
         		 	                ptMailBody1.setProperty("SServer",user.SServer);              // ElOffice ���� ����
         		 	                ptMailBody1.setProperty("from_empNo" ,user.empNo);            // �� �߼��� ���
         		 	                ptMailBody1.setProperty("to_empNo" ,data.ZEMAIL);  // �ڸ� ������ ����id ���� �ֱ�


         		 	                ptMailBody1.setProperty("ename_R" ,user.ename);       // (��)��û�ڸ�

         		 	                //��ȭȯ�� ���� ȭȯ�� �ٸ� ���ڰ� ������ ����
         		 	                if(inputData.CONG_CODE.equals("0007")) {
         		 	                ptMailBody1.setProperty("UPMU_NAME" ,"LGȭ�� ȭȯ ��û ����");               // ���� �̸�
         		 	               } else if(inputData.CONG_CODE.equals("0010")) {
         		 	            	  ptMailBody1.setProperty("UPMU_NAME" ,"LGȭ�� ��ȭȯ ��û ����");
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
         		 	                //��ȭȯ�� ���� ȭȯ�� �ٸ� ���ڰ� ������ ����
         		 	                if(inputData.CONG_CODE.equals("0007")) {
         		 	                ptMailBody1.setProperty("title" ,"ȭȯ ��û�� �Ʒ��� �������� �����Ǿ����ϴ�.");              // ����Ÿ��Ʋ
         		 	               } else if(inputData.CONG_CODE.equals("0010")) {
         		 	            	  ptMailBody1.setProperty("title" ,"��ȭȯ ��û�� �Ʒ��� �������� �����Ǿ����ϴ�.");
         		 	               }

         		 	                //��û�� ������ ���� ������.
         		 	                // 2002.07.25.------------------------------------------------------------------------

         		 	                // �� ����
         		 	                StringBuffer sbSubject1 = new StringBuffer(512);

         		 	                sbSubject1.append("[" + ptMailBody1.getProperty("UPMU_NAME") + "] ");
         		 	                //[CSR ID:3051290] ��ȭȯ ���� ��û ���� �ý��� ����  2016.07.13 �����S
         		 	                //��ȭȯ�� ���� ȭȯ�� �ٸ� ���ڰ� ������ ����
         		 	               if(inputData.CONG_CODE.equals("0007")) {
         		 	            	   sbSubject1.append( ptMailBody1.getProperty("ename") + "���� ȭȯ ��û�� �����Ǿ����ϴ�.");
         		 	               } else if(inputData.CONG_CODE.equals("0010")) {
         		 	            	  sbSubject1.append( ptMailBody1.getProperty("ename") + "���� ��ȭȯ ��û�� �����Ǿ����ϴ�.");
         		 	               }

         		 	                ptMailBody1.setProperty("subject" ,sbSubject1.toString());    // �� ���� ����

         		 	                ptMailBody1.setProperty("FileName" ,"FlowerMailBuild.html");

         		 	                MailSendToOutside maTe1;
									try {
										maTe1 = new MailSendToOutside(ptMailBody1);

										if (!maTe1.process()) {
											msg2 = maTe1.getMessage();
										} // end if
									} catch (ConfigurationException e) {
										throw new GeneralException(e);
									}


         		 	                smsData.TR_SENDSTAT = "0"; 					//�߼ۻ��� 0:�߼۴��
         		 	                smsData.TR_MSGTYPE = "0"; 						//������������ 0:�Ϲ�
         		 	                smsData.TR_PHONE = data.ZCELL_NUM;		//������ �ڵ�����ȣ
         		 	                smsData.TR_CALLBACK = inputData.ZCELL_NUM;//�۽��� ��ȭ��ȣ


         		             		}
         		             	}

         		                 msg = "��û �Ǿ����ϴ�."+ "\\n" + "�ֹ���ü�� ���Ϲ߼� ";
         		                 //[CSR ID:3051290] ��ȭȯ ���� ��û ���� �ý��� ����  2016.07.13 �����S
         		                 //��ȭȯ�� ���� ȭȯ�� �ٸ� ���ڰ� ������ ����
         		                 if(inputData.CONG_CODE.equals("0007")) {
         		                	 smsData.TR_MSG = "LGȭ�� "+inputData.ZUNAME_R+"���� ȭȯ ��û�� �����Ǿ����ϴ�. ���� Ȯ���� ȸ�� �ٶ��ϴ�. [��û��:"+user.ename+"]";
         		                 } else if(inputData.CONG_CODE.equals("0010")) {
         		                	 smsData.TR_MSG = "LGȭ�� "+inputData.ZUNAME_R+"���� ��ȭȯ ��û�� �����Ǿ����ϴ�. ���� Ȯ���� ȸ�� �ٶ��ϴ�. [��û��:"+user.ename+"]";
         		                 }

         		                 Logger.debug.println(this, " smsData = " + smsData.toString());
         		                 try {
									if(smsDB.buildSms(smsData).equals("Y")){
									 	msg=msg+ "\\n" + "�� SMS�߼� �Ϸ�Ǿ����ϴ�.";
									 }else{
									     dest = WebUtil.JspURL+"common/msg.jsp";
									     msg2 = msg2 + "\\n" + " SMS �߼� ����" ;
									 }
								} catch (Exception e) {

									//throw new GeneralException(e);
								}
         		                 // sms

         		                 // [C20140416_24713] �ֹ� ��ü SMS �߼�  end
         		                 //String url = "location.href = '" + WebUtil.ServletURL+"hris.E.E19Congra.E19CongraDetailSV?AINF_SEQN=" + box.get("AINF_SEQN") + "';";
         		                 //req.setAttribute("msg", msg);
         		                 //req.setAttribute("url", url);
         		                 //dest = WebUtil.JspURL+"common/msg.jsp";
                          }
                          //////////////�ֹ���ü ���Ϲ߼� sms end //////////////////////////////////




                        return AINF_SEQN;
                        /* ������ �ۼ� �κ� �� */
                    }
                });
            }else if(jobid.equals("change_code")) {//��ûȭ�鿡�� ȭȯ �� ��ȭȭ�� �����Ͽ��� ��, �������� ������ ���� ������ �ѹ� ź��
            	Vector E19CongcondData_more = null;
                Vector e19CongraDupCheck_vt = null;
                Vector e19CongraLifnr_vt    = null;  // �μ���������

                E19CongcondData     e19CongcondData = new E19CongcondData();

                box.copyToEntity(e19CongcondData);

                if ( phonenumdata.E_RECON.equals("")) {
                    // ����
                	 getApprovalInfo(req, PERNR);

                } else {
                    // ������ �����϶��� �������� �Ϸ��� ��¥�� I_DATE �� �־��ش�. 2005.04.15 �߰�
                    String reday = DataUtil.removeStructur(phonenumdata.E_REDAY, "-");
                    getApprovalInfo(req, PERNR,DataUtil.addDays(reday, -1));

                }

                E19CongcondData_more = (new E19CongMoreRelaRFC()).getCongMoreRela( PERNR, DataUtil.getCurrentDate() ,"1");

                e19CongcondData = (E19CongcondData)E19CongcondData_more.get(0);

                e19CongcondData.PERNR = PERNR;

                // 2003.02.20 - �������� �ߺ���û�� .jsp���� �������ؼ� �߰���.
                e19CongraDupCheck_vt = (new E19CongraDupCheckRFC()).getCheckList( PERNR );

                // ��������(���¹�ȣ,�����)�� ���ΰ����´�. ����:2002/01/22
                hris.common.rfc.AccountInfoRFC accountInfoRFC = new hris.common.rfc.AccountInfoRFC();
                Vector AccountData_pers_vt = accountInfoRFC.getPersAccountInfo(PERNR);

                AccountData AccountData_hidden = new AccountData();
                DataUtil.fixNull(AccountData_hidden);

               //[CSR ID:3051290] ��ȭȯ ���� ��û ���� �ý��� ����  2016.07.13 �����S
               // ������ ���������� �ٽ� jsp�� �Ѱ��ֱ� ���� ���� CONG_CODE_SV �� ���� �����Ѵ�
               String CONG_CODE_SV = "";
               if( CONG_CODE.equals("0007") ) { //ȭȯ �������� ���
                		CONG_CODE_SV = CONG_CODE;

                	} else if( CONG_CODE.equals("0010")) { //��ȭȯ �������� ���
                		CONG_CODE_SV = CONG_CODE;
                	}

                req.setAttribute("CONG_CODE_SV" , CONG_CODE_SV );
                
                //[CSR ID:3546961] start--------------------------------
                ESSExceptCheckRFC essExcptChk = new ESSExceptCheckRFC();
                String exceptChk = essExcptChk.essExceptcheck(PERNR, "E0"+UPMU_TYPE).MSGTY;
                Logger.debug.println("������ ��û ���� ��� : "+PERNR+", ���� �ڵ� : "+exceptChk);
                req.setAttribute("ESS_EXCPT_CHK" , exceptChk );
                //[CSR ID:3546961] end--------------------------------


                req.setAttribute("AccountData_hidden" , AccountData_hidden );
                req.setAttribute("AccountData_pers_vt", AccountData_pers_vt);
                // ��������(���¹�ȣ,�����)�� ���ΰ����´�.

                req.setAttribute("e19CongcondData",      e19CongcondData);
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
