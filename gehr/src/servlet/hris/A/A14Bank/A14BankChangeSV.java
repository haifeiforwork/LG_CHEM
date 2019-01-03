/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR ����                                                  */
/*   2Depth Name  : �޿���������                                                */
/*   Program Name : �޿����� ����                                               */
/*   Program ID   : A14BankChangeSV                                             */
/*   Description  : �޿����¸� ������ �� �ֵ��� �ϴ� Class                      */
/*   Note         :                                                             */
/*   Creation     : 2002-01-08  �赵��                                          */
/*   Update       : 2005-03-03  ������                                          */
/*                  : 2016-09-20 ���ձ��� - ���ö                     */
/*                      //@PJ.�߽��� ���� Rollout ������Ʈ �߰� ����(Area = MX("32")) 2018/02/09 rdcamel                                                         */
/********************************************************************************/

package	servlet.hris.A.A14Bank;

import java.sql.Connection;
import java.util.Vector;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.common.Utils;
import com.common.constant.Area;
import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.WebUtil;

import hris.A.A14Bank.A14BankCodeData;
import hris.A.A14Bank.A14BankStockFeeData;
import hris.A.A14Bank.rfc.A14BankCodeRFC;
import hris.A.A14Bank.rfc.A14BankStockFeeRFC;
import hris.common.PersonData;
import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalHeader;
import hris.common.approval.ApprovalLineData;
import hris.common.rfc.PersonInfoRFC;

public class A14BankChangeSV extends ApprovalBaseServlet {

    private String UPMU_TYPE ="10";     // ���� ����Ÿ��(�޿�����)
    private String UPMU_NAME = "�޿����� ";

    protected String getUPMU_TYPE() {
        return UPMU_TYPE;
    }

    protected String getUPMU_NAME() {
        return UPMU_NAME;
    }
    protected void performTask(final HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
//        Connection con = null;

        try{
            final WebUserData user = WebUtil.getSessionUser(req);

            /**         * Start: ������ �б�ó��             */
            String fdUrl = ".";
            
            ////@PJ.�߽��� ���� Rollout ������Ʈ �߰� ����(Area = MX("32")) 2018/02/09 rdcamel 
           if (user.area.equals(Area.CN) || user.area.equals(Area.TW) || user.area.equals(Area.HK) || user.area.equals(Area.US) || user.area.equals(Area.MX)) {	// Ÿ�̿�,ȫ���� �߱�ȭ������
               fdUrl = "hris.A.A14Bank.A14BankChangeGlobalSV";
//			} else if (user.area.equals(Area.PL) || user.area.equals(Area.DE)) { // PL ������, DE ���� �� ����ȭ������ 
//        	   fdUrl = "hris.A.A14Bank.A14BankChangeEurpSV";
			} 

           Logger.debug.println(this, "-------------[user.area] = "+user.area + " fdUrl: " + fdUrl );
           
            if( !".".equals(fdUrl )){
            	printJspPage(req, res, WebUtil.ServletURL+fdUrl);
		       	return;
           }
            /**             * END: ������ �б�ó��             */
            
            String dest     = WebUtil.JspURL+"common/msg.jsp";
            String jobid    = "";
            final String bankflag = "01";

            final Box box = WebUtil.getBox(req);
            jobid = box.get("jobid", "first");
            Logger.debug.println(this, "[jobid] = "+jobid + " [user] : "+user.toString());

            A14BankStockFeeRFC  rfc       = new A14BankStockFeeRFC();
            //A14BankStockFeeData firstData = new A14BankStockFeeData();

            Vector a14BankStockFeeData_vt = null;
            final String AINF_SEQN              = box.get("AINF_SEQN");


            //**********���� ��.****************************

            String I_APGUB = (String) req.getAttribute("I_APGUB");  //��� ���������� �Գ�? '1' : ������ ���� , '2' : ������ ���� , '3' : ����Ϸ� ����

            // ���� ������ ���ڵ�..
            rfc.setDetailInput(user.empNo, I_APGUB, AINF_SEQN); // ���������
            
            a14BankStockFeeData_vt = rfc.getBankStockFee( "", AINF_SEQN, bankflag );
            if(!rfc.getReturn().isSuccess()){
                req.setAttribute("msg", rfc.getReturn().MSGTX);                    
                req.setAttribute("url", "history.back();");
                printJspPage(req, res, dest);
                return;
            }
            
            Logger.debug.println(this, "�޿����� ����ȸ : " + a14BankStockFeeData_vt.toString());

            req.setAttribute("a14BankStockFeeData_vt", a14BankStockFeeData_vt);

            final A14BankStockFeeData firstData = (A14BankStockFeeData)Utils.indexOf(a14BankStockFeeData_vt,0);

            // �븮 ��û �߰�
            if(firstData!=null){
	            PersonInfoRFC numfunc = new PersonInfoRFC();
	            PersonData phonenumdata;
	            phonenumdata = (PersonData)numfunc.getPersonInfo(firstData.PERNR);
	            req.setAttribute("PersonData" , phonenumdata );
            }

            if( jobid.equals("first") ) {    //����ó�� ��û ȭ�鿡 ���°��.

//                Vector AppLineData_vt = null;

                // �޿����� ����Ʈ�� �����Ѵ�.
                A14BankCodeRFC  rfc_bank           = new A14BankCodeRFC();
                A14BankCodeData data               = new A14BankCodeData();
                Vector          a14BankCodeData_vt = rfc_bank.getBankCode(firstData.PERNR);
                

                if( a14BankCodeData_vt.size() == 0 ) {  // �����̱⶧���� �� ������ �����ϱ�� ����ڴ�.
                    String msg = "������ �޿����� ������ �������� �ʽ��ϴ�.";
                    String url = "history.back();";
                    req.setAttribute("msg", msg);
                    req.setAttribute("url", url);
                    dest = WebUtil.JspURL+"common/msg.jsp";
                } else {
                    // �޿����� ����Ʈ
                    req.setAttribute("a14BankCodeData_vt", a14BankCodeData_vt);

                    // �����ڸ���Ʈ
                    //AppLineData_vt = AppUtil.getAppChangeVt(AINF_SEQN);
                    req.setAttribute("isUpdate", true); //��� ���� ����   <- �����ʿ��� �ݵ�� �ʿ���
                    //req.setAttribute("AppLineData_vt", AppLineData_vt);
                    
                    detailApporval(req, res, rfc);
                    dest = WebUtil.JspURL+"A/A14Bank/A14BankBuild_KR.jsp";	// ��û+����
                }

            } else if( jobid.equals("change") ) {

                /* ���� ���� �κ� */
                dest = changeApproval(req, box, A14BankStockFeeData.class, rfc, new ChangeFunction<A14BankStockFeeData>(){

                    public String porcess(A14BankStockFeeData inputData, ApprovalHeader approvalHeader, Vector<ApprovalLineData> approvalLineDatas)
                			throws GeneralException {
                        /* ���� ��û RFC ȣ�� */
                    	A14BankStockFeeRFC changeRFC = new A14BankStockFeeRFC();
                        changeRFC.setChangeInput(user.empNo, UPMU_TYPE, approvalHeader.AINF_SEQN);

                        Logger.debug("-------- AINF_SEQN " + inputData.AINF_SEQN);

                        changeRFC.build(firstData.PERNR, AINF_SEQN, bankflag, Utils.asVector(inputData), box, req);

                        if(!changeRFC.getReturn().isSuccess()) {
                            req.setAttribute("msg", "������ ���� �Ͽ����ϴ�.\n" + changeRFC.getReturn().MSGTX);   //���� �޼��� ó�� - �ӽ�
                            return null;
                        }

                        return inputData.AINF_SEQN;
                        /* ������ �ۼ� �κ� �� */
                    }
                });
                
  /*
                
                A14BankStockFeeData a14BankStockFeeData = new A14BankStockFeeData();
                Vector              AppLineData_vt      = new Vector();

                // �޿����� ����..
                a14BankStockFeeData.AINF_SEQN = AINF_SEQN;             // �������� �Ϸù�ȣ
                a14BankStockFeeData.PERNR     = firstData.PERNR;       // �����ȣ
                a14BankStockFeeData.BEGDA     = box.get("BEGDA");      // ��û��
                a14BankStockFeeData.BANK_FLAG = box.get("BANK_FLAG");  // ����(����/����)
                a14BankStockFeeData.BANK_CODE = box.get("BANK_CODE");  // ����/���� ȸ��
                a14BankStockFeeData.BANK_NAME = box.get("BANK_NAME");  // ����/���� ȸ���
                a14BankStockFeeData.BANKN     = box.get("BANKN");      // ����/���� ����
                a14BankStockFeeData.ZPERNR    = user.empNo;            // ��û�� ��� ����(�븮��û ,���� ��û)

                Logger.debug.println(this, "�޿����� ���� : " + a14BankStockFeeData.toString());

                 // �������� ����..
                int rowcount = box.getInt("RowCount");
                for( int i = 0; i < rowcount; i++ ) {
                    AppLineData appLine = new AppLineData();
                    String      idx     = Integer.toString(i);

                    // ���� �̸����� ������ ������
                    box.copyToEntity(appLine ,i);

                    appLine.APPL_MANDT     = user.clientNo;
                    appLine.APPL_BUKRS     = user.companyCode;
                    appLine.APPL_PERNR     = firstData.PERNR;
                    appLine.APPL_BEGDA     = a14BankStockFeeData.BEGDA;
                    appLine.APPL_AINF_SEQN = AINF_SEQN;
                    appLine.APPL_UPMU_TYPE = UPMU_TYPE;

                    AppLineData_vt.addElement(appLine);
                }
                Logger.debug.println(this, AppLineData_vt.toString());

                con = DBUtil.getTransaction();
                AppLineDB appDB = new AppLineDB(con);

                String msg;
                String msg2 = null;

                if( appDB.canUpdate((AppLineData)AppLineData_vt.get(0)) ) {

                   // ���� ������ ����Ʈ
                    Vector orgAppLineData_vt = AppUtil.getAppChangeVt(AINF_SEQN);

                    appDB.change(AppLineData_vt);
                    Vector ret =  rfc.change( firstData.PERNR, AINF_SEQN, bankflag, a14BankStockFeeData );
                     
                    A14BankMessageData a14BankMessageData = new A14BankMessageData();  //return message

                    a14BankMessageData = (A14BankMessageData)ret.get(0); 

                	if(a14BankMessageData.CODE.equals("S")){
	                    con.commit();
	
	                    msg = "msg002";
	
	                    AppLineData oldAppLine = (AppLineData) orgAppLineData_vt.get(0);
	                    AppLineData newAppLine = (AppLineData) AppLineData_vt.get(0);
	
	                    Logger.debug.println(this ,oldAppLine);
	                    Logger.debug.println(this ,newAppLine);
	
	                    if (!newAppLine.APPL_APPU_NUMB.equals(oldAppLine.APPL_PERNR)) {
	
	                        // ������ ����� �� ������ ,ElOffice ���� ���̽�
	                        phonenumdata = (PersonData)numfunc.getPersonInfo(firstData.PERNR);
	
	                        // �̸��� ������
	                        Properties ptMailBody = new Properties();
	                        ptMailBody.setProperty("SServer",user.SServer);             // ElOffice ���� ����
	                        ptMailBody.setProperty("from_empNo" ,user.empNo);           // �� �߼��� ���
	                        ptMailBody.setProperty("to_empNo" ,oldAppLine.APPL_PERNR);  // �� ������ ���
	
	                        ptMailBody.setProperty("ename" ,phonenumdata.E_ENAME);      // (��)��û�ڸ�
	                        ptMailBody.setProperty("empno" ,phonenumdata.E_PERNR);      // (��)��û�� ���
	
	                        ptMailBody.setProperty("UPMU_NAME" ,"�޿�����");            // ���� �̸�
	                        ptMailBody.setProperty("AINF_SEQN" ,AINF_SEQN);             // ��û�� ����
	
	                        // �� ����
	                        StringBuffer sbSubject = new StringBuffer(512);
	
	                        sbSubject.append("[" + ptMailBody.getProperty("UPMU_NAME") + "] ");
	                        sbSubject.append( ptMailBody.getProperty("ename") + "���� ��û�� �����ϼ̽��ϴ�.");
	                        ptMailBody.setProperty("subject" ,sbSubject.toString());
	
	                        ptMailBody.setProperty("FileName" ,"NoticeMail5.html");
	
	                        MailSendToEloffic   maTe = new MailSendToEloffic(ptMailBody);
	                        // ���� ������ �� ����
	                        if (!maTe.process()) {
	                            msg2 = msg2 + " ���� " + maTe.getMessage();
	                        } // end if
	
	                        // �� ����
	                        sbSubject = new StringBuffer(512);
	                        sbSubject.append("[" + ptMailBody.getProperty("UPMU_NAME") + "] ");
	                        sbSubject.append(ptMailBody.getProperty("ename") +"���� ��û�ϼ̽��ϴ�.");
	                        
	                        ptMailBody.setProperty("subject" ,sbSubject.toString());
	                        ptMailBody.remove("FileName");
	                        ptMailBody.setProperty("to_empNo" ,newAppLine.APPL_APPU_NUMB);
	
	                        maTe = new MailSendToEloffic(ptMailBody);
	                        // �ű� ������ �� ����
	                        if (!maTe.process()) {
	                            msg2 = msg2 +" \\n ��û " + maTe.getMessage();
	                        } // end if
	
	//                      ElOffice �������̽�
	                        try {
	                            DraftDocForEloffice ddfe = new DraftDocForEloffice();
	                            ElofficInterfaceData eof = ddfe.makeDocForChange(AINF_SEQN ,user.SServer , phonenumdata.E_PERNR, ptMailBody.getProperty("UPMU_NAME") ,oldAppLine.APPL_PERNR);
	                            Vector vcElofficInterfaceData = new Vector();
	                            vcElofficInterfaceData.add(eof);
	
	                            ElofficInterfaceData eofD = ddfe.makeDocContents(AINF_SEQN ,user.SServer,ptMailBody.getProperty("UPMU_NAME"));
	                            vcElofficInterfaceData.add(eofD);
	                            
	                            req.setAttribute("vcElofficInterfaceData", vcElofficInterfaceData);
	                            dest = WebUtil.JspURL+"common/ElOfficeInterface.jsp";
	                        } catch (Exception e) {
	                            dest = WebUtil.JspURL+"common/msg.jsp";
	                            msg2 = msg2 + "\\n" + " Eloffic ���� ����" ;
	                        } // end try
	                    } else {
	                        msg = "msg002";
	                        dest = WebUtil.JspURL+"common/msg.jsp";
	                    } // end if
                    } else { 

                    	con.rollback();                    	
                        msg = a14BankMessageData.MESSAGE; 
                        dest = WebUtil.JspURL+"common/msg.jsp";
                    } // end if
                    
                } else {
                    msg = "msg005";
                    dest = WebUtil.JspURL+"common/msg.jsp";
                } // end if
*/
               
               

            } else {
                throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
            }
            Logger.debug.println(this, "destributed = " + dest);
            printJspPage(req, res, dest);

        } catch(Exception e) {
            throw new GeneralException(e);
        } finally {
//            DBUtil.close(con);
//            if (con != null) try {con.close();} catch (Exception e){
//                Logger.debug.println(this, "finally   "+e  );
//                Logger.err.println(e, e);
//            }
        }
    }
}
