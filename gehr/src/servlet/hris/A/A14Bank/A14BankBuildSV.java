/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR ����                                                  */
/*   2Depth Name  : �޿���������                                                */
/*   Program Name : �޿����� ��û                                               */
/*   Program ID   : A14BankBuildSV                                              */
/*   Description  : �޿����¸� ��û�� �� �ֵ��� �ϴ� Class                      */
/*   Note         :                                                             */
/*   Creation     : 2002-01-08  �赵��                                          */
/*   Update       : 2005-03-03  ������                                          */
/*                  : 2016-09-21 ���ձ���(Eurp ����) - ���ö                      */
/*                                                                              */
/********************************************************************************/

package	servlet.hris.A.A14Bank;

import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.common.Utils;
import com.common.constant.Area;
import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.WebUtil;

import hris.A.A03AccountDetail1Data;
import hris.A.A14Bank.A14BankCodeData;
import hris.A.A14Bank.A14BankStockFeeData;
import hris.A.A14Bank.rfc.A14BankCodeRFC;
import hris.A.A14Bank.rfc.A14BankStockFeeRFC;
import hris.A.rfc.A03AccountDetailRFC;
import hris.common.PersonData;
import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalLineData;
import hris.common.rfc.PersonInfoRFC;

public class A14BankBuildSV extends ApprovalBaseServlet {

    private String UPMU_TYPE ="10";            // ���� ����Ÿ��(�޿�����)
    private String UPMU_NAME = "Bank Account ";

    protected String getUPMU_TYPE() {
        return UPMU_TYPE;
    }

    protected String getUPMU_NAME() {
        return UPMU_NAME;
    }

    protected void performTask(final HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
    	
        //Connection con = null;

        try{
            final WebUserData user = WebUtil.getSessionUser(req);
            final String bankflag = "01";
            final Box box = WebUtil.getBox(req);

            /***********     Start: ������ �б�ó��       **********************************************************/
            
            		String fdUrl = ".";
		            
//		           if (user.area.equals(Area.CN) || user.area.equals(Area.TW) || user.area.equals(Area.HK) || user.area.equals(Area.US)) {	// Ÿ�̿�,ȫ���� �߱�ȭ������
		           if (!user.area.equals(Area.KR)) {	// Ÿ�̿�,ȫ���� �߱�ȭ������
		               printJspPage(req, res,  WebUtil.ServletURL+"hris.A.A14Bank.A14BankBuildGlobalSV");
		               return;
		//			} else if (user.area.equals(Area.PL) || user.area.equals(Area.DE)) { // PL ������, DE ���� �� ����ȭ������ 
		//        	   fdUrl = "hris.A.A14Bank.A14BankBuildEurpSV";
					} 
		
		       
		            
            /**************    END: ������ �б�ó��        *********************************************************/
            
            String dest     = "";
            String jobid    = "";
            String PERNR;

            jobid =  box.get("jobid", "first");
           
            Logger.debug.println(this, "[jobid] = "+jobid + " [user] : "+user.toString());
            Logger.debug.println(this, "[box] = "+box );

            PERNR = getPERNR(box, user); //��û����� ���
            
//          @���������� 20151124
            String reSabunCk = user.e_representative;
            if (PERNR.equals("") || !reSabunCk.equals("Y")) {
                PERNR = user.empNo;
            } // end if

            // �븮 ��û �߰�
//            if (user.area.equals(Area.PL) || user.area.equals(Area.DE)) { // PL ������, DE ����
//    			PhoneNumRFC numfunc = new PhoneNumRFC();
//    			PhoneNumData phonenumdata;
//    			phonenumdata = (PhoneNumData) numfunc.getPhoneNum(PERNR);
//    			req.setAttribute("PhoneNumData", phonenumdata);
//            }else{
	            PersonInfoRFC numfunc = new PersonInfoRFC();
	            PersonData phonenumdata;
	            phonenumdata = (PersonData)numfunc.getPersonInfo(PERNR);
	            req.setAttribute("PersonData" , phonenumdata );
//            }

            req.setAttribute("PERNR" , PERNR );

/*************************************************
 *                 �޿����½�û: First
 *************************************************/
            if( jobid.equals("first") ) {   //����ó�� ��û ȭ�鿡 ���°��.

//                Vector  AppLineData_vt = null;

                //**********  �������, ���� ��� ���� ��ȸ ****************
                getApprovalInfo(req, PERNR);    //<-- �ݵ�� �߰�
                
                // �޿����� ����Ʈ�� �����Ѵ�.
                A14BankCodeRFC  rfc_bank           = new A14BankCodeRFC();
//                if (user.area.equals(Area.PL) || user.area.equals(Area.DE)) { // PL ������, DE ����
//                	Vector a14BankValueData_vt = rfc_bank.getBankValue(PERNR);
//					req.setAttribute("a14BankValueData_vt", a14BankValueData_vt);
//                }
                A14BankCodeData data               = new A14BankCodeData();
				
                Vector          a14BankCodeData_vt = rfc_bank.getBankCode(PERNR);

                if( a14BankCodeData_vt.size() == 0 ) {		
                    String msg = g.getMessage("MSG.A.A14.0011");
                    String url = "history.back();";
                    req.setAttribute("msg", msg);
                    req.setAttribute("url", url);
                    dest = WebUtil.JspURL+"common/msg.jsp";
                } else {
                    Logger.debug.println(this, "�޿����� ����Ʈ : "+ a14BankCodeData_vt.toString());

                    // ���� ��ϵ� �޿����¸� �ʱ⿡ �������ֱ� ���ؼ�..
                    A03AccountDetailRFC func1    = new A03AccountDetailRFC();
                    Vector              adata_vt = 
                    		(user.area == Area.KR) ? func1.getAccountDetail(PERNR, "10") : func1.getAccountDetail(PERNR) ;  // �޿����� ������, �ؿܿ�

                    if( adata_vt.size() > 0 ) {
                        A03AccountDetail1Data adata = (A03AccountDetail1Data)Utils.indexOf(adata_vt,0);
                        adata.PERNR = PERNR;
                        Logger.debug.println(this,"����������"+adata.toString());
                        req.setAttribute("A03AccountDetail1Data", adata);
                    }

                    req.setAttribute("a14BankCodeData_vt", a14BankCodeData_vt);

                    // �����ڸ���Ʈ
                    //AppLineData_vt = AppUtil.getAppVector( PERNR, UPMU_TYPE );
                    //Logger.debug.println(this, "������ ����Ʈ : "+ AppLineData_vt.toString());

                    //req.setAttribute("AppLineData_vt",  AppLineData_vt);

                    dest = WebUtil.JspURL+"A/A14Bank/A14BankBuild_KR.jsp";
                }

/*************************************************
 *                 �޿����½�û: Create
 *************************************************/
            } else if( jobid.equals("create") ) {       //

                dest = requestApproval(req, box,  A14BankStockFeeData.class, new RequestFunction<A14BankStockFeeData>() {
                                    public String porcess(A14BankStockFeeData inputData, Vector<ApprovalLineData> approvalLine) throws GeneralException {

                           /* üũ ���� �ʿ��� ��� 
                           if(checkDup(user, inputData))
                               throw new GeneralException("�̹� �ߺ��� ��û���� �ֽ��ϴ�.");*/

                            /* ���� ��û RFC ȣ�� */                    
                            A14BankStockFeeRFC  rfc                 = new A14BankStockFeeRFC();
                            // �޿����� ����..
                            box.copyToEntity(inputData);
                            inputData.ZPERNR    = user.empNo;            // ��û�� ��� ����(�븮��û ,���� ��û)

                            rfc.setRequestInput(user.empNo, UPMU_TYPE);
                            String ainf_seqn =  rfc.build( user.empNo, null, bankflag, inputData ,box, req); 
                            Logger.debug.println(this,"�����ȣ  ainf_seqn="+ainf_seqn.toString());
                            if(!rfc.getReturn().isSuccess() || ainf_seqn==null) {
                                throw new GeneralException(rfc.getReturn().MSGTX);
                            };
                            
                            /* ��û �� msg ó�� �� �̵� ������ ���� */
                            req.setAttribute("url", "location.href = '" + WebUtil.ServletURL+"hris.A.A14Bank.A14BankDetailSV?AINF_SEQN="+ainf_seqn+"';");

                            return ainf_seqn;
                            /* ������ �ۼ� �κ� �� */
                        }
                    });
            	
            	
//            	@����༺ ������ ������ ���� üũ 2015-08-25-------------------------------------------------------
                /*            	
            	Vector   AppLine_vt     = null;
            	String		appLineCheck = "Y";
            	AppLine_vt = AppUtil.getAppVector( PERNR, UPMU_TYPE );
            	for (int i = 0; i < AppLine_vt.size(); i++){
            		AppLineData appLine = new AppLineData();
            		appLine = (AppLineData)AppLine_vt.get(i);
            		if(!appLine.APPL_APPU_TYPE.equals("01")){//���� ������ ������ ����
            			Logger.debug.println(this, "appLine.APPL_PERNR : " + appLine.APPL_PERNR.toString());
            			Logger.debug.println(this, "box.get(APPL_APPU_NUMBi) : " + box.get("APPL_APPU_NUMB"+i));
            			if(!appLine.APPL_PERNR.equals(box.get("APPL_APPU_NUMB"+i))){
            				appLineCheck = "N";
            			}
            		}
            	}
            	
            	if(appLineCheck.equals("N")){
            		String msg = "msg020";
                    req.setAttribute("msg", msg);
                    dest = WebUtil.JspURL+"common/caution.jsp";
                    Logger.debug.println(this, " destributed = " + dest);
                    printJspPage(req, res, dest);
                    return;
            	}
*/
//@����༺ ������ ������ ���� üũ ��-------------------------------------------------------
            	
            	
            	/*
                NumberGetNextRFC    func                = new NumberGetNextRFC();
                A14BankStockFeeRFC  rfc                 = new A14BankStockFeeRFC();
                A14BankStockFeeData a14BankStockFeeData = new A14BankStockFeeData();
                Vector              AppLineData_vt      = new Vector();
                String              ainf_seqn           = func.getNumberGetNext();
                // �޿����� ����..
                a14BankStockFeeData.AINF_SEQN = ainf_seqn;             // �������� �Ϸù�ȣ
                a14BankStockFeeData.PERNR     = PERNR;    // �����ȣ
                a14BankStockFeeData.BEGDA     = box.get("BEGDA");      // ��û��
                a14BankStockFeeData.BANK_FLAG = box.get("BANK_FLAG");  // ����(����/����)
                a14BankStockFeeData.BANK_CODE = box.get("BANK_CODE");  // ����/���� ȸ��
                a14BankStockFeeData.BANK_NAME = box.get("BANK_NAME");  // ����/���� ȸ���
                a14BankStockFeeData.BANKN     = box.get("BANKN");      // ����/���� ����
                a14BankStockFeeData.ZPERNR    = user.empNo;            // ��û�� ��� ����(�븮��û ,���� ��û)

                Logger.debug.println(this, "�޿����� ��û : " + a14BankStockFeeData.toString());

                // �������� ����..
                int rowcount = box.getInt("RowCount");
                for( int i = 0; i < rowcount; i++ ) {
                    AppLineData appLine = new AppLineData();
                    String      idx     = Integer.toString(i);

                    // ������ �ڷ� �Է�(Web)
                    box.copyToEntity(appLine ,i);

                    appLine.APPL_MANDT     = user.clientNo;
                    appLine.APPL_BUKRS     = user.companyCode;
                    appLine.APPL_PERNR     = a14BankStockFeeData.PERNR;
                    appLine.APPL_BEGDA     = a14BankStockFeeData.BEGDA;
                    appLine.APPL_AINF_SEQN = ainf_seqn;
                    appLine.APPL_UPMU_TYPE = UPMU_TYPE;

                    AppLineData_vt.addElement(appLine);
                }
                
                Logger.debug.println(this, AppLineData_vt.toString());

                con = DBUtil.getTransaction();

                AppLineDB appDB    = new AppLineDB(con);

                appDB.create(AppLineData_vt);
                Vector ret =  rfc.build( user.empNo, ainf_seqn, bankflag, a14BankStockFeeData ); 
                A14BankMessageData a14BankMessageData = new A14BankMessageData();  //return message
                a14BankMessageData = (A14BankMessageData)ret.get(0); 

            	if(a14BankMessageData.CODE.equals("S")){
	            		
		                con.commit();
		
		//              ���� ������ ��� ,
		                AppLineData appLine = (AppLineData)AppLineData_vt.get(0);
		
		                Properties ptMailBody = new Properties();
		                ptMailBody.setProperty("SServer",user.SServer);              // ElOffice ���� ����
		                ptMailBody.setProperty("from_empNo" ,user.empNo);            // �� �߼��� ���
		                ptMailBody.setProperty("to_empNo" ,appLine.APPL_APPU_NUMB);  // �� ������ ���
		
		                ptMailBody.setProperty("ename" ,phonenumdata.E_ENAME);       // (��)��û�ڸ�
		                ptMailBody.setProperty("empno" ,phonenumdata.E_PERNR);       // (��)��û�� ���
		
		                ptMailBody.setProperty("UPMU_NAME" ,UPMU_NAME);              // ���� �̸�
		                ptMailBody.setProperty("AINF_SEQN" ,ainf_seqn);
		                // ��û�� ����
		
		                // �� ����
		                StringBuffer sbSubject = new StringBuffer(512);
		
		                sbSubject.append("[" + ptMailBody.getProperty("UPMU_NAME") + "] ");
		                sbSubject.append(ptMailBody.getProperty("ename") +"���� ��û�ϼ̽��ϴ�.");
		                
		                ptMailBody.setProperty("subject" ,sbSubject.toString());
		
		                MailSendToEloffic  maTe = new MailSendToEloffic(ptMailBody);
		
		                String msg = "msg001";;
		                String msg2 = "";
		
		                if (!maTe.process()) {
		                    msg2 = maTe.getMessage();
		                } // end if
		
		                try {
		                    DraftDocForEloffice ddfe = new DraftDocForEloffice();
		                    
		                    ElofficInterfaceData eof = ddfe.makeDocContents(ainf_seqn ,user.SServer,ptMailBody.getProperty("UPMU_NAME"));
		
		                    Vector vcElofficInterfaceData = new Vector();
		                    vcElofficInterfaceData.add(eof);
		                    req.setAttribute("vcElofficInterfaceData", vcElofficInterfaceData);
		                    dest = WebUtil.JspURL+"common/ElOfficeInterface.jsp";
		                } catch (Exception e) {
		                    dest = WebUtil.JspURL+"common/msg.jsp";
		                    msg2 = msg2 + "\\n" + " Eloffic ���� ����" ;
		                } // end try  
		                
		                String url = "location.href = '" + WebUtil.ServletURL+"hris.A.A14Bank.A14BankDetailSV?AINF_SEQN="+ainf_seqn+"';";
		                req.setAttribute("msg", msg);
		                req.setAttribute("msg2", msg2);
		                req.setAttribute("url", url);
		                
	                
            	}else{ 
	                	
	                	con.rollback();
	                	
	                    String msg = a14BankMessageData.MESSAGE; 
	                    // �޿����� ����Ʈ�� �����Ѵ�.
	                    A14BankCodeRFC  rfc_bank           = new A14BankCodeRFC(); 
	                    Vector          a14BankCodeData_vt = rfc_bank.getBankCode(PERNR);
	
	
	                    // ���� ��ϵ� �޿����¸� �ʱ⿡ �������ֱ� ���ؼ�..
	                    A03AccountDetailRFC func1    = new A03AccountDetailRFC();
	                    Vector              adata_vt = func1.getAccountDetail(PERNR, "10");  // �޿�����
	
	                    if( adata_vt.size() > 0 ) {
	                        A03AccountDetail1Data adata = (A03AccountDetail1Data)adata_vt.get(0);
	                        adata.PERNR = PERNR; 
	                        req.setAttribute("A03AccountDetail1Data", adata);
	                    }
	
	                    req.setAttribute("a14BankCodeData_vt", a14BankCodeData_vt);
	
	                    // �����ڸ���Ʈ
	                    AppLineData_vt = AppUtil.getAppVector( PERNR, UPMU_TYPE ); 
	
	                    req.setAttribute("AppLineData_vt",  AppLineData_vt);
	
	                    req.setAttribute("message", msg);
	                    dest = WebUtil.JspURL+"A/A14Bank/A14BankBuild_KR.jsp"; 
        
            	}
*/
            	
            } else {
                throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
            }
            
            Logger.debug.println(this, " destributed = " + dest);
            printJspPage(req, res, dest);

        } catch(Exception e) {
            throw new GeneralException(e);

        } finally {
//            DBUtil.close(con);
//            if (con != null) try {con.close();} catch (Exception e){
//                Logger.err.println(e, e);
//            }
        }
    }
}
