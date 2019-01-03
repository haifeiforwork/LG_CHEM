/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR ����                                                  */
/*   2Depth Name  : �޿���������                                                */
/*   Program Name : �޿����� ��ȸ                                               */
/*   Program ID   : A14BankDetailSV                                             */
/*   Description  : �޿����¸� ��ȸ�� �� �ֵ��� �ϴ� Class                      */
/*   Note         :                                                             */
/*   Creation     : 2002-01-08  �赵��                                          */
/*   Update       : 2005-03-03  ������                                          */
/*                                                                              */
/********************************************************************************/

package	servlet.hris.A.A14Bank;

import com.common.RFCReturnEntity;
import com.common.Utils;
import com.common.constant.Area;
import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.db.DBUtil;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.WebUtil;
import hris.A.A14Bank.A14BankStockFeeData;
import hris.A.A14Bank.rfc.A14BankCodeRFC;
import hris.A.A14Bank.rfc.A14BankStockFeeRFC;
import hris.common.PersonData;
import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.rfc.PersonInfoRFC;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.sql.Connection;
import java.util.Vector;

public class A14BankDetailSV extends ApprovalBaseServlet {

    private String UPMU_TYPE ="10";     // ���� ����Ÿ��(�޿�)
    private String UPMU_NAME =  "�޿����� ";

    protected String getUPMU_TYPE() {
        return UPMU_TYPE;
    }

    protected String getUPMU_NAME() {
        return UPMU_NAME;
    }

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        Connection con = null;

        try{
            HttpSession session = req.getSession(false);
            final WebUserData user = WebUtil.getSessionUser(req);
            

            /**         * Start: ������ �б�ó��            
            String fdUrl = ".";
            
           if (user.area.equals(Area.CN) || user.area.equals(Area.TW) || user.area.equals(Area.HK) || user.area.equals(Area.US)) {	// Ÿ�̿�,ȫ���� �߱�ȭ������
               fdUrl = "hris.A.A14Bank.A14BankDetailGlobalSV";
			} else if (user.area.equals(Area.PL) || user.area.equals(Area.DE)) { // PL ������, DE ���� �� ����ȭ������ 
        	   fdUrl = "hris.A.A14Bank.A14BankDetailEurpSV";
			} 

           Logger.debug.println(this, "-------------[user.area] = "+user.area + " fdUrl: " + fdUrl );
           
            if( !".".equals(fdUrl )){
            	printJspPage(req, res, fdUrl);
		       	return;
           }
            /**             * END: ������ �б�ó��             */
            
            
            String dest      = "";
            String jobid     = "";

            Box box = WebUtil.getBox(req);
            jobid = box.get("jobid", "first");
           	final String bankflag = (user.area == Area.KR )?"01":box.get("BNKSA");
            
            Logger.debug.println(this, "[jobid] = "+jobid + " [user] : "+user.toString());

            String I_APGUB = (String) req.getAttribute("I_APGUB");  //��� ���������� �Գ�? '1' : ������ ���� , '2' : ������ ���� , '3' : ����Ϸ� ����

            final A14BankStockFeeRFC   rfc       = new A14BankStockFeeRFC();
            final String     ainf_seqn                       = box.get("AINF_SEQN");
            rfc.setDetailInput(user.empNo, I_APGUB, ainf_seqn);
            Vector             a14BankStockFeeData_vt  = null;
           // Vector             AppLineData_vt          = null;

            a14BankStockFeeData_vt = rfc.getBankStockFee( "", ainf_seqn, bankflag );
            Logger.debug.println(this, "�޿����� ����ȸ : " + Utils.indexOf(a14BankStockFeeData_vt, 0));

            final A14BankStockFeeData  firstData = (A14BankStockFeeData) Utils.indexOf(a14BankStockFeeData_vt, 0);

            	// �븮 ��û �߰�
            if(firstData!=null){
	            PersonInfoRFC numfunc = new PersonInfoRFC();
	            PersonData phonenumdata;
	            phonenumdata = (PersonData)numfunc.getPersonInfo(firstData.PERNR);
	            req.setAttribute("PersonData" , phonenumdata );
            }

            if( jobid.equals("first") ) {

                req.setAttribute("a14BankStockFeeData_vt", a14BankStockFeeData_vt);
                if(user.area != Area.KR ){
                    String PERNR =   rfc.getApprovalHeader().PERNR; //getPERNR(box, user); //box.get("PERNR", user.empNo);
                    A14BankCodeRFC rfc_bank = new A14BankCodeRFC();
                    Vector a14BankValueData_vt = rfc_bank.getBankValue(PERNR);
                    req.setAttribute("a14BankValueData_vt", a14BankValueData_vt);
                }

                if (!detailApporval(req, res, rfc))                    return;

                if (user.area.equals(Area.KR) || user.area.equals(Area.PL)) {
                	dest = WebUtil.JspURL+"A/A14Bank/A14BankDetail_KR.jsp";
//                }else if(user.area.equals(Area.PL)) {
//                	dest = WebUtil.JspURL+"A/A14Bank/A14BankDetail_PL.jsp";
                }else{
                	dest = WebUtil.JspURL+"A/A14Bank/A14BankDetail_Global.jsp";
                }
            } else if( jobid.equals("delete") ) {

                // �޿����� ����..

                dest = deleteApproval(req, box, rfc, new DeleteFunction() {
                    public boolean porcess() throws GeneralException {

                    	A14BankStockFeeRFC deleteRFC = new A14BankStockFeeRFC();
                        deleteRFC.setDeleteInput(user.empNo, UPMU_TYPE, rfc.getApprovalHeader().AINF_SEQN);

                        RFCReturnEntity returnEntity = deleteRFC.delete(firstData.PERNR, ainf_seqn, "01");

                        if(!returnEntity.isSuccess()) {
                            throw new GeneralException(returnEntity.MSGTX);
                        }

                        return true;
                    }
                });
                
/*                
                AppLineData_vt = new Vector();

                // �������� ����..
                AppLineData  appLine = new AppLineData();
                appLine.APPL_MANDT     = user.clientNo;
                appLine.APPL_BUKRS     = user.companyCode;
                appLine.APPL_PERNR     = firstData.PERNR;
                appLine.APPL_UPMU_TYPE = UPMU_TYPE;
                appLine.APPL_AINF_SEQN = ainf_seqn;

                // 2002.07.25.---------------------------------------------------------------------------
                // ��û�� ������ ���� ������ ���� �ʿ��� ������ ������ �����´�.
                // ����
                int rowcount = box.getInt("RowCount");
                for( int i = 0; i < rowcount; i++) {
                    AppLineData app = new AppLineData();
                    String      idx     = Integer.toString(i);

                    // ���� �̸����� ������ ������
                    box.copyToEntity(app ,i);

                    AppLineData_vt.addElement(app);
                }
                Logger.debug.println(this, "AppLineData : " + AppLineData_vt.toString());
                //              ��û�� ������ ���� ������ ���� �ʿ��� ������ ������ �����´�.
                // 2002.07.25.---------------------------------------------------------------------------

                con = DBUtil.getTransaction();
                AppLineDB appDB    = new AppLineDB(con);

                if( appDB.canUpdate(appLine) ) {
                    appDB.delete(appLine);
                    rfc.delete( firstData.PERNR, ainf_seqn, bankflag  );
                    con.commit();

                    // ��û�� ������ ���� ������.
                    appLine = (AppLineData)AppLineData_vt.get(0);
                    Properties ptMailBody = new Properties();
                    ptMailBody.setProperty("SServer",user.SServer);              // ElOffice ���� ����
                    ptMailBody.setProperty("from_empNo" ,user.empNo);            // �� �߼��� ���
                    ptMailBody.setProperty("to_empNo" ,appLine.APPL_APPU_NUMB);  // �� ������ ���

                    ptMailBody.setProperty("ename" ,phonenumdata.E_ENAME);       // (��)��û�ڸ�
                    ptMailBody.setProperty("empno" ,phonenumdata.E_PERNR);       // (��)��û�� ���

                    ptMailBody.setProperty("UPMU_NAME" ,"�޿�����");             // ���� �̸�
                    ptMailBody.setProperty("AINF_SEQN" ,ainf_seqn);              // ��û�� ����
                    // ��û�� ������ ���� ������.

                    // �� ����
                    StringBuffer sbSubject = new StringBuffer(512);

                    sbSubject.append("[" + ptMailBody.getProperty("UPMU_NAME") + "] ");
                    sbSubject.append( ptMailBody.getProperty("ename") + "���� ��û�� �����ϼ̽��ϴ�.");
                    ptMailBody.setProperty("subject" ,sbSubject.toString());    // �� ���� ����

                   ptMailBody.setProperty("FileName" ,"NoticeMail5.html");

                    MailSendToEloffic   maTe = new MailSendToEloffic(ptMailBody);

                    String msg2 = null;
                    if (!maTe.process()) {
                        msg2 = maTe.getMessage();
                    } // end if

                    try {
                        DraftDocForEloffice ddfe = new DraftDocForEloffice();
                        ElofficInterfaceData eof = ddfe.makeDocForRemove(ainf_seqn ,user.SServer ,ptMailBody.getProperty("UPMU_NAME") 
                                ,firstData.PERNR ,appLine.APPL_APPU_NUMB);
                        
                        Vector vcElofficInterfaceData = new Vector();
                        vcElofficInterfaceData.add(eof);
                        req.setAttribute("vcElofficInterfaceData", vcElofficInterfaceData);
                        dest = WebUtil.JspURL+"common/ElOfficeInterface.jsp";
                    } catch (Exception e) {
                        dest = WebUtil.JspURL+"common/msg.jsp";
                        msg2 = msg2 + "\\n" + " Eloffic ���� ����" ;
                    } // end try
                    String msg = "msg003";
                    String url ;

                    //  ���� ������ ������ �������� �̵��ϱ� ���� ����
                    if(RequestPageName != null &&  !RequestPageName.equals("") ){
                        url = "location.href = '" + RequestPageName.replace('|','&') + "';";
                    } else {
                        url = "location.href = '" + WebUtil.ServletURL+"hris.A.A03AccountDetailSV';";
                    } // end if
                    //  ���� ������ ������ �������� �̵��ϱ� ���� ����

                    req.setAttribute("msg", msg);
                    req.setAttribute("url", url);

                } else {
                    String msg = "msg005";
                    String url = "location.href = '" + WebUtil.ServletURL+"hris.A.A14Bank.A14BankDetailSV?AINF_SEQN="+ainf_seqn+"';";
                    req.setAttribute("msg", msg);
                    req.setAttribute("url", url);
                    dest = WebUtil.JspURL+"common/msg.jsp";
                }
   */
            } else {
                throw new BusinessException(g.getMessage("MSG.COMMON.0016"));//���θ��(jobid)�� �ùٸ��� �ʽ��ϴ�.
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