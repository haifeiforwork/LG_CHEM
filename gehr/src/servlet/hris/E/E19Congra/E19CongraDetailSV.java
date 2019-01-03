/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR ����                                                  */
/*   2Depth Name  : ������                                                      */
/*   Program Name : ������ ��û ��ȸ                                            */
/*   Program ID   : E19CongraDetailSV                                           */
/*   Description  : �������� ��û��ȸ�� �� �ֵ��� �ϴ� Class                    */
/*   Note         : ����                                                        */
/*   Creation     : 2001-12-19  �輺��                                          */
/*   Update       : 2005-02-14  �̽���                                          */
/*                  2005-02-24  ������                                          */
/*                  2014-04-24  [CSR ID:C20140416_24713]  ȭȯ��û�� 0007 �ֹ���ü �����߰� , ����ӱ��������� , ��۾�ü���Ϲ߼�,sms�߰�,�ʱⱸ���� �߰�  ,������ ���� �߼�  */
/*                  2014-08-22   ȭȯ��û�� 0007 ���� sms�߰�   */
/*                                                                              */
/********************************************************************************/

package servlet.hris.E.E19Congra;

import hris.A.A04FamilyDetailData;
import hris.A.rfc.A04FamilyDetailRFC;
import hris.E.E19Congra.E19CongFlowerInfoData;
import hris.E.E19Congra.E19CongGrupData;
import hris.E.E19Congra.E19CongcondData;
import hris.E.E19Congra.rfc.E19CongraFlowerInfoRFC;
import hris.E.E19Congra.rfc.E19CongraGrubNumbRFC;
import hris.E.E19Congra.rfc.E19CongraRequestRFC;
import hris.common.MailSendToOutside;
import hris.common.PersonData;
import hris.common.PhoneNumData;
import hris.common.UplusSmsData;
import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalLineData;
import hris.common.db.UplusSmsDB;
import hris.common.rfc.PersonInfoRFC;
import hris.common.rfc.PhoneNumRFC;

import java.sql.SQLException;
import java.util.Properties;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.common.RFCReturnEntity;
import com.common.Utils;
import com.sns.jdf.BusinessException;
import com.sns.jdf.ConfigurationException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.WebUtil;

public class E19CongraDetailSV extends ApprovalBaseServlet
{
    private String UPMU_TYPE ="01";   // ���� ����Ÿ��(������)
    private String UPMU_NAME = "������";

    protected String getUPMU_TYPE() {
        return UPMU_TYPE;
    }

    protected String getUPMU_NAME() {
        return UPMU_NAME;
    }

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {


        try{

            final WebUserData user = WebUtil.getSessionUser(req);
            Box box = WebUtil.getBox(req);


            String jobid = box.get("jobid", "first");

            String I_APGUB = (String) req.getAttribute("I_APGUB");  //��� ���������� �Գ�? '1' : ������ ���� , '2' : ������ ���� , '3' : ����Ϸ� ����



            final E19CongcondData     e19CongcondData ;

            String  firstYn = "";
            if(firstYn==null|| firstYn.equals("") ){
            	firstYn = "";
            } // end if
            // �븮 ��û �߰�


            final E19CongraRequestRFC e19CongraRequestRFC = new E19CongraRequestRFC();
            e19CongraRequestRFC.setDetailInput(user.empNo, I_APGUB, box.get("AINF_SEQN"));
            Vector<E19CongcondData> resultList = e19CongraRequestRFC.getDetail(); //��� ����Ÿ
            e19CongcondData = resultList.get(0);



            PersonInfoRFC numfunc = new PersonInfoRFC();
            final PersonData phonenumdata;
            phonenumdata    =   (PersonData)numfunc.getPersonInfo(e19CongcondData.PERNR);
             req.setAttribute("PersonData" , phonenumdata );


            if (jobid.equals("first")) {           //����ó�� ��û ȭ�鿡 ���°��.

                req.setAttribute("resultData", Utils.indexOf(resultList, 0));

                if (!detailApporval(req, res, e19CongraRequestRFC))
                    return;

                req.setAttribute("e19CongcondData", Utils.indexOf(resultList, 0));
                req.setAttribute("firstYn", firstYn); //  C20140416_24713   ��û���� ��ȸ�� Y

                //����� ���
                //��û ����� ���� ������( ȸ�� ����� �������+60�� �� ��¥���� +-1������ �������)
                A04FamilyDetailRFC a04FamilyDetailRFC                  = new A04FamilyDetailRFC();
                box.put("I_PERNR", e19CongcondData.PERNR);
                Vector             a04FamilyDetailData_vt = a04FamilyDetailRFC.getFamilyDetail(box) ;
                Vector vcA04FamilyData = new Vector();

                for( int i = 0 ; i < a04FamilyDetailData_vt.size() ; i++ ) {
                	A04FamilyDetailData  Data = (A04FamilyDetailData)a04FamilyDetailData_vt.get(i);

                    if (Data.REGNO.equals(e19CongcondData.REGNO )) {
                    	vcA04FamilyData.add(Data);
                    }
                }

                //60��°����
                String YearTmp="";
                if  (e19CongcondData.REGNO.substring(6,7).equals("1")  ||e19CongcondData.REGNO.substring(6,7).equals("2") ){
                	YearTmp="19";
                }else {
                	YearTmp="20";
                }
                String CheckYy = YearTmp+e19CongcondData.REGNO.substring(0,2);
                String CheckYear =  String.valueOf (Integer.parseInt(CheckYy)+60) ;
                String Sixth_birth =CheckYear+e19CongcondData.REGNO.substring(2,4)+e19CongcondData.REGNO.substring(4,6);

                req.setAttribute("SIXTH_DATE" ,Sixth_birth);
                req.setAttribute("vcA04FamilyData" ,vcA04FamilyData);
            	boolean app = false;
            	Vector  vcAppLineData = e19CongraRequestRFC.getApprovalLine();


            	for (int i = 0; i < vcAppLineData.size(); i++) {
            		ApprovalLineData ald = (ApprovalLineData) vcAppLineData.get(i);
//            		out.println( ald.APPL_PERNR );
//            		out.println( user.empNo );
//            		out.println( e19CongcondData.PERNR );

            		if (ald.APPU_NUMB.equals( user.empNo ) ) {
            			app = true;
//                	    out.println( app );
            			break;
            		}
            	} // end for
            	req.setAttribute("app" ,app);
                printJspPage(req, res, WebUtil.JspURL + "E/E19Congra/E19CongraDetail.jsp");

            } else if (jobid.equals("delete")) {           //����ó�� ��û ȭ�鿡 ���°��.

                final String dest = deleteApproval(req, box, e19CongraRequestRFC, new DeleteFunction() {
                    public boolean porcess() throws GeneralException {
                    	String dest="";
                    	E19CongraRequestRFC deleteRFC = new E19CongraRequestRFC();
                        deleteRFC.setDeleteInput(user.empNo, UPMU_TYPE, e19CongraRequestRFC.getApprovalHeader().AINF_SEQN);

                        RFCReturnEntity returnEntity = deleteRFC.delete();

                        if(!returnEntity.isSuccess()) {
                            throw new GeneralException(returnEntity.MSGTX);
                        }
                        String msg = "msg003";
                        // [C20140416_24713] �ֹ� ��ü ���� ���� �߼�  start
                        //[CSR ID:3051290] ��ȭȯ ���� ��û ���� �ý��� ����  2016.07.13 �����S
                        //��ȭȯ�� ȭȯó�� ���� �߼��ϵ���
                        if (e19CongcondData.CONG_CODE.equals("0007") || e19CongcondData.CONG_CODE.equals("0010")){ //ȭ��, ��ȭȯ ��û�ø�

    		                 UplusSmsDB smsDB = new UplusSmsDB(); //SMS
    		                 UplusSmsData smsData = new UplusSmsData(); //SMS
    		             	   //�ٹ�������Ʈ
    		             	   Vector E19CongraGrubNumb_vt  = (new E19CongraGrubNumbRFC()).getGrupCode(user.companyCode,"010");
    		             	   String ZGRUP_NUMB_O_NM="";
    		             	   String ZGRUP_NUMB_R_NM="";
    		             	   for( int i = 0 ; i < E19CongraGrubNumb_vt.size() ; i++ ){
    		             		   E19CongGrupData  data = (E19CongGrupData)E19CongraGrubNumb_vt.get(i);
    		             		   if (e19CongcondData.ZGRUP_NUMB_O.equals( data.GRUP_NUMB)){
    		             			   ZGRUP_NUMB_O_NM=data.GRUP_NAME;
    		             		   }
    		             		   if (e19CongcondData.ZGRUP_NUMB_R.equals( data.GRUP_NUMB)){
    		             			   ZGRUP_NUMB_R_NM=data.GRUP_NAME;
    		             		   }
    		             	   }
    		                     //CSR ID: 20140416_24713 ȭȯ��ü
    		             	   	//[CSR ID:3051290] ��ȭȯ ���� ��û ���� �ý��� ����  2016.07.13 �����S
    		                     Vector e19CongFlowerInfoData_vt = (new E19CongraFlowerInfoRFC()).getFlowerInfoCode(e19CongcondData.CONG_CODE);
    		                     String msg2="";
    		                    //[CSR ID:3051290] ��ȭȯ ���� ��û ���� �ý��� ����  2016.07.13 �����S
    		                 	for( int i = 0 ; i < e19CongFlowerInfoData_vt.size() ; i++ ){

    		                 		if(i==0) {
    		                 		E19CongFlowerInfoData  data = (E19CongFlowerInfoData)e19CongFlowerInfoData_vt.get(i);


    		     	                Properties ptMailBody1 = new Properties();
    		     	                ptMailBody1.setProperty("SServer",user.SServer);              // ElOffice ���� ����
    		     	                ptMailBody1.setProperty("from_empNo" ,user.empNo);            // �� �߼��� ���
    		     	                ptMailBody1.setProperty("to_empNo" ,data.ZEMAIL);  // �ڸ� ������ ����id ���� �ֱ�


    		     	                ptMailBody1.setProperty("ename_R" ,user.ename);       // (��)��û�ڸ�
    		     	                //[CSR ID:3051290] ��ȭȯ ���� ��û ���� �ý��� ����  2016.07.13 �����S
    		     	               if (e19CongcondData.CONG_CODE.equals("0007")) {
    		     	                ptMailBody1.setProperty("UPMU_NAME" ,"LGȭ�� ȭȯ ��û ���� ����");               // ���� �̸�
    		     	               } else if (e19CongcondData.CONG_CODE.equals("0010")) {
    		     	            	  ptMailBody1.setProperty("UPMU_NAME" ,"LGȭ�� ��ȭȯ ��û ���� ����");
    		     	               }

    		     	                ptMailBody1.setProperty("AINF_SEQN" ,e19CongraRequestRFC.getApprovalHeader().AINF_SEQN);              // ��û�� ����
    		     	                ptMailBody1.setProperty("ZGRUP_NUMB_O" ,ZGRUP_NUMB_O_NM);              // ��û�� �ٹ���
    		     	                ptMailBody1.setProperty("ZPHONE_NUM" ,e19CongcondData.ZPHONE_NUM);              // ��û�� ��ȭ��ȣ
    		     	                ptMailBody1.setProperty("ZCELL_NUM" ,e19CongcondData.ZCELL_NUM);              // ��û�� �ڵ���

    		     	                ptMailBody1.setProperty("ename" ,e19CongcondData.ZUNAME_R);       //�����(������)
    		     	                ptMailBody1.setProperty("empno" ,e19CongcondData.PERNR);       // (��)��û�� ���
    		     	                ptMailBody1.setProperty("ZCELL_NUM_R" ,e19CongcondData.ZCELL_NUM_R);              // ����� ����ó

    		     	                ptMailBody1.setProperty("ZGRUP_NUMB_R" ,ZGRUP_NUMB_R_NM);              // ����� �ٹ���
    		     	                ptMailBody1.setProperty("E_ORGTX" ,phonenumdata.E_ORGTX);              // ����� �μ�
    		     	                ptMailBody1.setProperty("E_PTEXT" ,phonenumdata.E_PTEXT);              // �ź�
    		     	                ptMailBody1.setProperty("E_CFLAG" ,  e19CongcondData.ZUNION_FLAG.equals("X") ? "���տ�: Y" : ""   );              // ���տ�����
    		     	                ptMailBody1.setProperty("ZTRANS_DATE" ,WebUtil.printDate(e19CongcondData.ZTRANS_DATE,"."));              // �������
    		     	                ptMailBody1.setProperty("ZTRANS_TIME" ,WebUtil.printTime( e19CongcondData.ZTRANS_TIME ) );              // ��۽ð�

    		     	                ptMailBody1.setProperty("ZTRANS_ADDR" ,e19CongcondData.ZTRANS_ADDR);              // ����� �ּ�
    		     	                ptMailBody1.setProperty("ZTRANS_ETC" ,e19CongcondData.ZTRANS_ETC);              // ��Ÿ �䱸����

    		     	                //[CSR ID:3051290] ��ȭȯ ���� ��û ���� �ý��� ����  2016.07.13 �����S
    		     	               if(e19CongcondData.CONG_CODE.equals("0007")) {
    		     	            	   ptMailBody1.setProperty("title" ,"�Ʒ��� ȭȯ ��û ������ �����Ǿ����ϴ�.");              // ����Ÿ��Ʋ
    		     	               } else if(e19CongcondData.CONG_CODE.equals("0010")) {
    		     	            	  ptMailBody1.setProperty("title" ,"�Ʒ��� ��ȭȯ ��û ������ �����Ǿ����ϴ�.");
    		     	               }
    		     	                //��û�� ������ ���� ������.
    		     	                // 2002.07.25.------------------------------------------------------------------------

    		     	                // �� ����
    		     	                StringBuffer sbSubject1 = new StringBuffer(512);



    		     	                sbSubject1.append("[" + ptMailBody1.getProperty("UPMU_NAME") + "] ");

    		     	                //[CSR ID:3051290] ��ȭȯ ���� ��û ���� �ý��� ����  2016.07.13 �����S
    		     	               if(e19CongcondData.CONG_CODE.equals("0007")) {
    		     	            	   sbSubject1.append( ptMailBody1.getProperty("ename") + "���� ȭȯ ��û �������� �����Ǿ����ϴ�.");
    		     	               } else if(e19CongcondData.CONG_CODE.equals("0010")) {
    		     	            	  sbSubject1.append( ptMailBody1.getProperty("ename") + "���� ��ȭȯ ��û �������� �����Ǿ����ϴ�.");
    		     	               }

    		     	                ptMailBody1.setProperty("subject" ,sbSubject1.toString());    // �� ���� ����

    		     	                ptMailBody1.setProperty("FileName" ,"FlowerMailBuild.html");

    		     	                MailSendToOutside maTe1 = null;
									try {
										maTe1 = new MailSendToOutside(ptMailBody1);
									} catch (ConfigurationException e) {

										throw new GeneralException(e);
									}


    		     	                if (!maTe1.process()) {
    		     	                    msg2 = maTe1.getMessage();
    		     	                } // end if
    		     	               msg="���� �Ǿ����ϴ�. �ֹ���ü�� ���� ������ �߼۵Ǿ����ϴ�.";


    			 	                smsData.TR_SENDSTAT = "0"; 					//�߼ۻ��� 0:�߼۴��
    			 	                smsData.TR_MSGTYPE = "0"; 						//������������ 0:�Ϲ�
    			 	                smsData.TR_PHONE = data.ZCELL_NUM;		//������ �ڵ�����ȣ
    			 	                smsData.TR_CALLBACK = e19CongcondData.ZCELL_NUM;//�۽��� ��ȭ��ȣ

    		                 	}
                        	}

    		                 	//[CSR ID:3051290] ��ȭȯ ���� ��û ���� �ý��� ����  2016.07.13 �����S
    		                 	 if(e19CongcondData.CONG_CODE.equals("0007")) {
    		                 		 smsData.TR_MSG = "LGȭ�� "+e19CongcondData.ZUNAME_R+"���� ȭȯ ��û�� �����Ǿ����ϴ�. ���� Ȯ���� ȸ�� �ٶ��ϴ�. [������:"+user.ename+"]";
    		                 	 } else if(e19CongcondData.CONG_CODE.equals("0010")) {
    		                 		 smsData.TR_MSG = "LGȭ�� "+e19CongcondData.ZUNAME_R+"���� ��ȭȯ ��û�� �����Ǿ����ϴ�. ���� Ȯ���� ȸ�� �ٶ��ϴ�. [������:"+user.ename+"]";
    		                 	 }

    			                 Logger.debug.println(this, " smsData = " + smsData.toString());
    			                 try {
									if(smsDB.buildSms(smsData).equals("Y")){
									 	msg=msg+ "\\n" + "�� ����SMS�߼� �Ϸ�Ǿ����ϴ�.";
									 }else{
									     dest = WebUtil.JspURL+"common/msg.jsp";
									     msg2 = msg2 + "\\n" + " SMS �߼� ����" ;
									 }
								} catch (Exception e) {
									//throw new GeneralException(e);
								}
    			                 // sms

                        }
                        // [C20140416_24713] �ֹ� ��ü ���� ���� �߼�  end
                        return true;
                    }
                });

                printJspPage(req, res, dest);

            } else {
                throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
            }


        } catch (Exception e) {
            Logger.error(e);
            throw new GeneralException(e);
        }
    }

}




