/********************************************************************************/
/*                                                                              */
/*   System Name  :  e-HR                                                        */
/*   1Depth Name  : HR ������                                                   */
/*   2Depth Name  : ���� �ؾ��� ����                                            */
/*   Program Name : ������ ��û                                                 */
/*   Program ID   : G004ApprovalCongraSV                                        */
/*   Description  : ������ ��û �μ��� ����/�ݷ�                                */
/*   Note         : ����                                                        */
/*   Creation     : 2005-03-14  �̽���                                          */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/

package servlet.hris.G;
/*
 * �ۼ��� ��¥: 2005. 1. 31.
 *
 */
import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;
import hris.A.A01SelfDetailData;
import hris.A.rfc.A01SelfDetailRFC;
import hris.E.E19Congra.E19CongcondData;
import hris.E.E19Congra.E19CongraDupCheckData;
import hris.E.E19Congra.rfc.E19CongraDupCheckRFC;
import hris.E.E19Congra.rfc.E19CongraRequestRFC;
import hris.common.MailSendToEloffic;
import hris.common.ManageInfoData;
import hris.common.PersonData;
import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalHeader;
import hris.common.approval.ApprovalLineData;
import hris.common.rfc.ManageInfoRFC;
import hris.common.rfc.PersonInfoRFC;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Properties;
import java.util.Vector;
/**
 * @author �̽���
 *
 */
public class G004ApprovalCongraSV extends ApprovalBaseServlet
{
    /* (��Javadoc)
     * @see com.sns.jdf.servlet.EHRBaseServlet#performTask(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse)
     */

    private String UPMU_TYPE ="01";   // ���� ����Ÿ��(������)
    private String UPMU_NAME = "������";

    protected String getUPMU_TYPE() {
        return UPMU_TYPE;
    }

    protected String getUPMU_NAME() {
        return UPMU_NAME;
    }

    protected void performTask(final HttpServletRequest req, final HttpServletResponse res)
            throws GeneralException
    {
        try{
            final WebUserData user = WebUtil.getSessionUser(req);

           String dest  = "";

           final Box box = WebUtil.getBox(req);

           final E19CongcondData     e19CongcondData ;

           String  AINF_SEQN  = box.get("AINF_SEQN");

           String jobid = box.get("jobid");

           final E19CongraRequestRFC e19CongraRequestRFC  = new E19CongraRequestRFC();
           e19CongraRequestRFC.setDetailInput(user.empNo, "1", AINF_SEQN);
           Vector<E19CongcondData> resultList = e19CongraRequestRFC.getDetail(); //��� ����Ÿ
           e19CongcondData = resultList.get(0);

           PersonInfoRFC numfunc = new PersonInfoRFC();
           final PersonData phonenumdata;
           phonenumdata    =   (PersonData)numfunc.getPersonInfo(e19CongcondData.PERNR);

           //�������� ���ϳ����� ��������� GET ���� 2012.12.04
           A01SelfDetailRFC			piRfc				=	new A01SelfDetailRFC();
           A01SelfDetailData    pid = (A01SelfDetailData) piRfc.getPersInfo(e19CongcondData.PERNR, user.area.getMolga(), "").get(0);


           /* ���� �� */
           if("A".equals(jobid)) {
               /* ������ ���� �� */
               dest = accept(req, box, "T_ZHRA002T", e19CongcondData, e19CongraRequestRFC, new ApprovalFunction<E19CongcondData>() {
                   public boolean porcess(E19CongcondData inputData, ApprovalHeader approvalHeader, Vector<ApprovalLineData> approvalLineDatas) throws GeneralException {
                	       inputData.PROOF = box.get("PROOF");
                	       inputData.REASON_CD = box.get("REASON_CD");
                           inputData.WAGE_WONX = DataUtil.changeGlobalAmount(box.get("WAGE_WONX"), user.area) ;  // ����ӱ�
                           inputData.CONG_WONX = DataUtil.changeGlobalAmount(box.get("CONG_WONX"), user.area) ;  // ������
                           inputData.UNAME     = user.empNo;
                           inputData.AEDTM     = DataUtil.getCurrentDate();


                       Vector e19CongraDupCheck_vt = null;

                       e19CongraDupCheck_vt = (new E19CongraDupCheckRFC()).getCheckList( e19CongcondData.PERNR );


                       //��û�� ������ üũ�� �ȵǾ� ����� dup üũ������ �߰��� 2009.09.25

                       for( int i = 0 ; i < e19CongraDupCheck_vt.size() ; i++ ) {
                           E19CongraDupCheckData c_Data = (E19CongraDupCheckData)e19CongraDupCheck_vt.get(i);
                           if(c_Data.CONG_CODE.equals(e19CongcondData.CONG_CODE) &&  c_Data.RELA_CODE.equals(e19CongcondData.RELA_CODE)
                                   && c_Data.EREL_NAME.equals(e19CongcondData.EREL_NAME) ) {
                                 if( c_Data.INFO_FLAG.equals("I") ) {
                                     String msg = "�ش� ���������� �̹� ������ ��������ڰ� �ֽ��ϴ�.";
                                     String url = "history.back();";
                                     req.setAttribute("msg", msg);
                                     req.setAttribute("url", url);
                                     printJspPage(req, res, WebUtil.JspURL+"common/msg.jsp");
                                     return false;
                                 }
                           }
                       }


                       return true;
                   }
               });
               /*------������ ȸ�� ����� ȸ���� 1�� �̻� ���� ���� ����ڸ� ����� ��������ڿ��� ���Ϲ߼� START----*/

               String SIXTH_DATE   =  box.get("SIXTH_DATE"); //ȸ����
               String Check_from    = DataUtil.addDays(SIXTH_DATE,-30);
               String Check_to       = DataUtil.addDays(SIXTH_DATE,30);

               Logger.debug.println(this ,"SIXTH_DATE:"+SIXTH_DATE+"Check_from:"+Check_from+"Check_to:"+Check_to);

               StringBuffer mangerMailTitle = new StringBuffer(512);
               StringBuffer mangerMailUpmuName = new StringBuffer(512);
               StringBuffer sbGuideText = new StringBuffer(512);

               if (  e19CongcondData.CONG_CODE.equals("0002") && e19CongcondData.REGNO  != "" &&
	                    ( Integer.parseInt(DataUtil.delDateGubn(e19CongcondData.CONG_DATE ) )  <   Integer.parseInt(Check_from) ||  Integer.parseInt( DataUtil.delDateGubn(e19CongcondData.CONG_DATE ) )  >  Integer.parseInt(Check_to ) )
	                    )
	            {
               	mangerMailTitle.append("�������ڿ� ������� ���� �ȳ�");
               	mangerMailUpmuName.append("������ ȸ�� ���� ���� Ȯ��");
               	sbGuideText.append("�ȳ��Ͻʴϱ�? ������ ���� ������ ���簡 ����Ǿ�����,<br>�������ڿ� ������� ���̰� �߻� �Ǿ����� ���� ��� Ȯ���� �Ͻñ� �ٶ��ϴ�.<br>");
	            }
               //�ӿ�: 11 �ӿ�, 12 ��������  �ΰ�� ����ڿ��� ���Ϲ߼�
               if (  phonenumdata.E_PERSK.equals("11") || phonenumdata.E_PERSK.equals("12") ){
               	if ( mangerMailTitle.length()>0 ){

	                	mangerMailTitle.append(" �� ");
	                	mangerMailUpmuName.append(" �� ");
	                	sbGuideText.append("<br>");
               	}else{
	                	sbGuideText.append("�ȳ��Ͻʴϱ�? ������ ���� ");
               	}
               	mangerMailTitle.append("�ӿ������� ����Ϸ� �ȳ�");
               	mangerMailUpmuName.append("�ӿ� ������ ����Ϸ�");
               	sbGuideText.append("�ӿ� ������ ���簡 �Ϸ�Ǿ����ϴ�.<br>");
               }

               if (mangerMailTitle.length()>0 )
               {


           		Properties ptMailBody2 = new Properties();
                   ptMailBody2.setProperty("SServer",user.SServer);                 // ElOffice ���� ����
                   ptMailBody2.setProperty("from_empNo" ,user.empNo);               // �� �߼��� ���
                   ptMailBody2.setProperty("to_empNo" ,e19CongcondData.PERNR);      // �� ������ ���

                   ptMailBody2.setProperty("ename" ,phonenumdata.E_ENAME);          // (��)��û�ڸ�
                   ptMailBody2.setProperty("empno" ,phonenumdata.E_PERNR);         // (��)��û�� ���

                   ptMailBody2.setProperty("UPMU_NAME" , mangerMailUpmuName.toString());// ���� �̸�
                   ptMailBody2.setProperty("AINF_SEQN" ,AINF_SEQN);                 // ��û�� ����

                   // �� ����
                   StringBuffer sbSubject1 = new StringBuffer(512);

                   sbSubject1.append("[" + ptMailBody2.getProperty("UPMU_NAME") + "] ");
                   sbSubject1.append(phonenumdata.E_ENAME  + "����  ");

                   ptMailBody2.setProperty("FileName" ,"WarningCongraMail1.html");
                   sbSubject1.append(mangerMailTitle);
                   ptMailBody2.setProperty("subject" ,sbSubject1.toString());        // �� ���� ����
                   ptMailBody2.setProperty("sbGuideText" ,sbGuideText.toString());        // �� ù��  �ȳ� ����
                   ptMailBody2.setProperty("CONG_DATE" ,e19CongcondData.CONG_DATE);        // ��������
                   ptMailBody2.setProperty("CONG_NAME" ,e19CongcondData.CONG_NAME);       // ������
                   ptMailBody2.setProperty("RELA_TEXT" , box.get("RELA_TEXT")  );       // �����
                   ptMailBody2.setProperty("EREL_NAME" , e19CongcondData.EREL_NAME);       // ����ڼ���

                   ptMailBody2.setProperty("REGNO" ,e19CongcondData.REGNO.substring(0,6)+"-*******");       // ����������ֹι�ȣ
                   ptMailBody2.setProperty("WAGE_WONX" ,WebUtil.printNumFormat(Double.toString(Double.parseDouble(e19CongcondData.WAGE_WONX) * 100.0) ));       // ����ӱ�
                   ptMailBody2.setProperty("CONG_RATE" ,e19CongcondData.CONG_RATE);       // ���޷�
                   ptMailBody2.setProperty("CONG_WONX" ,WebUtil.printNumFormat(Double.toString(Double.parseDouble(e19CongcondData.CONG_WONX) * 100.0)));       // �����ݾ�
                   ptMailBody2.setProperty("BANK_NAME" , e19CongcondData.BANK_NAME);       // ��ü�����
                   ptMailBody2.setProperty("BANKN" ,e19CongcondData.BANKN);       // ������¹�ȣ
                   ptMailBody2.setProperty("LIFNR" ,e19CongcondData.LIFNR);       // �μ����¹�ȣ
                   ptMailBody2.setProperty("HOLI_CONT" ,Integer.toString(Integer.parseInt(e19CongcondData.HOLI_CONT)));       // �����ް��ϼ�
                   ptMailBody2.setProperty("WORK_YEAR_TEXT" ,box.get("WORK_YEAR_TEXT"));       // �ټӳ��
                   ptMailBody2.setProperty("BEGDA" ,e19CongcondData.BEGDA);       // ��û��
                   ptMailBody2.setProperty("PROOF" ,box.get("PROOF").equals("X")?"Yes":"" );       //  ��ǿ���Ȯ��

                   ptMailBody2.setProperty("E_ORGTX" , pid.ORGTX);       // ��û��������
                   ptMailBody2.setProperty("BTEXT" , pid.BTEXT);       // ��û�ڻ����
                   ptMailBody2.setProperty("REASON_TEXT" ,box.get("REASON_TEXT")  );       //���̻���
                   ptMailBody2.setProperty("BIGO_TEXT" , box.get("BIGO_TEXT")  );       // ����

                   //------------���Ϲ߼� ����� list  �� �� �� �� �� ��
                   String to_empNo="";
                   String msg2 = "";
                   ManageInfoRFC  Minfo = new ManageInfoRFC();
                   Vector ManageInfo_vt = Minfo.getManageInfo("01");
                   for (int i = 0; i < ManageInfo_vt.size(); i++) {
                   	ManageInfoData data = (ManageInfoData) ManageInfo_vt.get(i);

                       to_empNo = data.PERNR;
	                    ptMailBody2.setProperty("to_empNo" ,to_empNo);                   // �� ������ ���
	                    MailSendToEloffic   maTe2 = new MailSendToEloffic(ptMailBody2);

	                    if (!maTe2.process()) {
	                    	msg2  += maTe2.getMessage() + "\\n";
	                    } // end if

                   } // end for


                   Logger.debug.println(this ,"ptMailBody2:"+ptMailBody2.toString());
                   Logger.debug.println(this ,"==========���� ȸ�� warning ���� ����ڻ�� to_empNo:"+to_empNo);
               }

               /*------������ ȸ�� ����� ȸ���� 1�� �̻� ���� ���� ����ڸ� ����� ��������ڿ��� ���Ϲ߼� END----*/
           /* �ݷ��� */
           } else if("R".equals(jobid)) {
               dest = reject(req, box,  null, e19CongcondData, e19CongraRequestRFC, null);
           } else if("C".equals(jobid)) {
               dest = cancel(req, box,  null, e19CongcondData, e19CongraRequestRFC, null);
           }  else {
               throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
           }

           Logger.debug.println(this, " destributed = " + dest);
           printJspPage(req, res, dest);

       } catch(Exception e) {
           Logger.err.println(DataUtil.getStackTrace(e));
           throw new GeneralException(e);
       }
   }
}


