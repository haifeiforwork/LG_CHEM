/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : ����Ϸ� ����                                               		*/
/*   2Depth Name  :                                                             */
/*   Program Name : �ް� ����Ϸ�                                               		*/
/*   Program ID   : F02DeptPositionDutySV                                       */
/*   Description  : �ް� ����Ϸ� ��ȸ�� ���� ����                            		*/
/*   Note         : ����                                                        		*/
/*   Creation     : 2005-03-10 �����                                           		*/
/*   Update       :                                                             */
/*                : 2016-10-10 FD-038 GEHR�����۾�-KSC 							*/
/*                : 2018-05-17 ��ȯ�� [WorkTime52] �����ް� �߰� ��  				*/
/*                                                                              */
/********************************************************************************/

package servlet.hris.D.D03Vocation;

import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;

import hris.D.D03Vocation.D03RemainVocationData;
import hris.D.D03Vocation.D03VocationData;
import hris.D.D03Vocation.rfc.D03RemainVocationOfficeRFC;
import hris.D.D03Vocation.rfc.D03RemainVocationRFC;
import hris.D.D03Vocation.rfc.D03VocationRFC;
import hris.G.ApprovalCancelData;
import hris.G.rfc.ApprovalCancelRFC;
import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalHeader;
import hris.common.approval.ApprovalLineData;
import hris.common.rfc.AuthCheckNTMRFC;

public class D03VocationCancelBuildSV extends ApprovalBaseServlet
{
	private String UPMU_TYPE ="41";            // �ް�������ҽ�û(����Ưȭ)
	private String UPMU_NAME = "�ް� �������";
	private static String ORG_UPMU_TYPE = "18";   // ���� ����Ÿ��(�ް���û)
	private static String NEW_UPMU_TYPE = "41";   // ���� ����Ÿ��(�ް���û)

    protected String getUPMU_TYPE() {
        return UPMU_TYPE;
    }

    protected String getUPMU_NAME() {
        return UPMU_NAME;
    }
    
    protected void performTask(final HttpServletRequest req, final HttpServletResponse res) throws GeneralException
    {
        try{
            HttpSession session = req.getSession(false);
            final WebUserData user = WebUtil.getSessionUser(req);

            Vector          d03VocationData_vt = null;
            D03VocationData d03VocationData    = null;

            String dest = WebUtil.JspURL+"D/D03Vocation/D03VocationCancelBuild.jsp";
            
            
            final Box box = WebUtil.getBox(req);
            final String  AINF_SEQN  = box.get("AINF_SEQN");

            final String jobid = box.get("jobid", "search");

            String I_APGUB = (String) req.getAttribute("I_APGUB");  //��� ���������� �Գ�? '1' : ������ ���� , '2' : ������ ���� , '3' : ����Ϸ� ����

            final String PERNR =  getPERNR(box, user); //box.get("PERNR", user.empNo);

            D03VocationRFC  rfc = new D03VocationRFC();
            rfc.setDetailInput(user.empNo, I_APGUB, AINF_SEQN);
           
            if( jobid.equals("search") || jobid.equals("after")) {

                
            	if(jobid.equals("after")){
            		req.setAttribute("jobid", "create");
            	}
                //�ް� ��ȸ
                //rfc.setChangeInput(user.empNo, UPMU_TYPE, AINF_SEQN);
                d03VocationData_vt = rfc.getVocation( user.empNo, AINF_SEQN );
                Logger.debug.println(this, "�ް����� ��ȸ : " + d03VocationData_vt.toString());
               
                if( d03VocationData_vt.size() < 1 ){
                    String msg = "��ȸ�� �׸��� �����ϴ�.";
                    req.setAttribute("msg", msg);
                    dest = WebUtil.JspURL+"common/caution.jsp";
                }else{
                    // �ް�
                    d03VocationData  = (D03VocationData)d03VocationData_vt.get(0);
                    
                    // �����ް� ����üũ
                    AuthCheckNTMRFC authCheckNTMRFC = new AuthCheckNTMRFC();
                	String E_AUTH = authCheckNTMRFC.getAuth(d03VocationData.PERNR, "S_ESS");
                	req.setAttribute("E_AUTH", E_AUTH);

                    // �ܿ��ް��ϼ�, ��ġ����ٹ��� üũ
                    D03RemainVocationData d03RemainVocationData    = new D03RemainVocationData();

                    if("Y".equals(E_AUTH)) {	//�繫��
                    	String vocaType = (d03VocationData.AWART.equals("0111") 
                    						|| d03VocationData.AWART.equals("0112") 
                    						|| d03VocationData.AWART.equals("0113")) ? "B" : "A";
                    	D03RemainVocationOfficeRFC  rfcRemain = new D03RemainVocationOfficeRFC();
                    	d03RemainVocationData = (D03RemainVocationData)rfcRemain.getRemainVocation(d03VocationData.PERNR, d03VocationData.APPL_FROM, vocaType);
                    } else {
                    	D03RemainVocationRFC rfcRemain             = new D03RemainVocationRFC();
                    	d03RemainVocationData = (D03RemainVocationData)rfcRemain.getRemainVocation(d03VocationData.PERNR, d03VocationData.APPL_FROM);
                    }

                    /*
                    // ������ ����
                    vcAppLineData = AppUtil.getAppChangeVt(AINF_SEQN);

                    // ���� ����.
                    PersInfoWithNoRFC piRfc = new PersInfoWithNoRFC();
                    PersInfoData      pid   = (PersInfoData) piRfc.getApproval(d03VocationData.PERNR).get(0);

                    req.setAttribute("PersInfoData" ,pid );
                    req.setAttribute("vcAppLineData" , vcAppLineData);                    
                    */

                    //�������, ���� ��� ���� ��ȸ
                    UPMU_TYPE = ORG_UPMU_TYPE; 
                    getApprovalInfo(req, PERNR);    //<-- �ݵ�� �߰�
                    UPMU_TYPE =NEW_UPMU_TYPE; 
                    ApprovalHeader approvalHeader = (ApprovalHeader)req.getAttribute("approvalHeader");
                    approvalHeader.setUPMU_TYPE(getUPMU_TYPE());  
                    req.setAttribute("approvalHeader", approvalHeader);
                    req.setAttribute("d03VocationData_vt", d03VocationData_vt);
                    req.setAttribute("d03RemainVocationData",  d03RemainVocationData);
                    if (!detailApporval(req, res, rfc))                    return;
                    
                } // end if
                
                

/***********************************************
 * 					Create ��ҿ�ûó��
 *  
 **************************************************/
                
            } else if( jobid.equals("create") ) {
        	                        	

            	UPMU_TYPE = NEW_UPMU_TYPE; 
        	    dest = requestApproval(req, box,  ApprovalCancelData.class, new RequestFunction<ApprovalCancelData>() {
        	                        public String porcess(ApprovalCancelData data, Vector<ApprovalLineData> approvalLine) throws GeneralException {

	            	ApprovalCancelRFC    rfc               = new ApprovalCancelRFC();
	            	Vector approvalCancelVt = new Vector();
	            	
	            	data.PERNR = PERNR;
	            	data.BEGDA = DataUtil.getCurrentDate();
	            	data.CANC_REASON = box.get("CANC_REASON");
	            	data.ORG_AINF_SEQN = AINF_SEQN;
	            	data.ORG_BEGDA = box.get("BEGDA");
	            	data.ORG_UPMU_TYPE = ORG_UPMU_TYPE;
	            	data.AEDTM = DataUtil.getCurrentDate();    
	            	data.ZPERNR = PERNR;
	            	data.UNAME = PERNR;
	            	data.I_NTM = "X";
	            	approvalCancelVt.addElement(data);
	            	
	            	//UPMU_TYPE = OLD_UPMU_TYPE;	            	
	                rfc.setRequestInput(user.empNo, UPMU_TYPE);
	                String new_AINF_SEQN = rfc.build(data.PERNR, data.AINF_SEQN,  approvalCancelVt, box, req);
	
	                if(!rfc.getReturn().isSuccess() || new_AINF_SEQN==null) {
	                    throw new GeneralException(rfc.getReturn().MSGTX);
	                };
	                Logger.debug.print("new_AINF_SEQN:"+new_AINF_SEQN);
	                return new_AINF_SEQN;
                }});	
                
                
            	
/*            	
            	NumberGetNextRFC  func              = new NumberGetNextRFC();
            	ApprovalCancelRFC    rfc               = new ApprovalCancelRFC();
            	Vector approvalCancelVt = new Vector();
            	Vector appLineDataVt = new Vector();
            	ApprovalCancelData data = new ApprovalCancelData();
            	data.AINF_SEQN = func.getNumberGetNext();
            	data.PERNR = PERNR;
            	data.BEGDA = DataUtil.getCurrentDate();
            	data.CANC_REASON = box.get("CANC_REASON");
            	data.ORG_AINF_SEQN = AINF_SEQN;
            	data.ORG_UPMU_TYPE = ORG_UPMU_TYPE;
            	data.AEDTM = DataUtil.getCurrentDate();    
            	data.ZPERNR = PERNR;
            	data.UNAME = PERNR;
            	approvalCancelVt.addElement(data);
            	
            	int rowcount = box.getInt("RowCount");
            	for( int i = 0; i < rowcount; i++) {
            		AppLineData appLine = new AppLineData();
                    //String      idx     = Integer.toString(i);

                    // ������ �ڷ� �Է�(Web)
                    box.copyToEntity(appLine ,i);

                    appLine.APPL_MANDT    = user.clientNo;
                    appLine.APPL_BUKRS     = user.companyCode;
                    appLine.APPL_PERNR     = PERNR;
                    appLine.APPL_BEGDA     = data.BEGDA;
                    appLine.APPL_AINF_SEQN = data.AINF_SEQN;
                    appLine.APPL_UPMU_TYPE = UPMU_TYPE;

                    appLineDataVt.addElement(appLine);
            	}
            	Logger.debug.println( this, approvalCancelVt.toString() );
                Logger.debug.println( this, "�������� : "+appLineDataVt.toString() );
                con = DBUtil.getTransaction();
                AppLineDB appDB    = new AppLineDB(con);
                appDB.create(appLineDataVt);

                Vector          vcRet             = new Vector(); 
                Logger.debug.println(this, "rfc.build before" );
                vcRet =  rfc.build(data.PERNR, data.AINF_SEQN,  approvalCancelVt);
                String E_RETURN    = (String)rfc.getReturn().MSGTX;
                String E_MESSAGE = (String)rfc.getReturn().MSGTY;

                Logger.debug.println(this, "E_RETURN : " +E_RETURN );
                Logger.debug.println(this, "E_MESSAGE : " +E_MESSAGE );
                
                if ( rfc.getReturn().isSuccess() ) {
                	con.commit();
//                	 ���� ������ ��� ,
                    AppLineData appLine = (AppLineData)appLineDataVt.get(0);

                    Properties ptMailBody = new Properties();
                    ptMailBody.setProperty("SServer",user.SServer);                 // ElOffice ���� ����
                    ptMailBody.setProperty("from_empNo" ,user.empNo);               // �� �߼��� ���
                    ptMailBody.setProperty("to_empNo", appLine.APPL_APPU_NUMB);     // �� ������ ���

                    ptMailBody.setProperty("ename" ,user.ename);          // (��)��û�ڸ�
                    ptMailBody.setProperty("empno" ,user.empNo);          // (��)��û�� ���

                    ptMailBody.setProperty("UPMU_NAME" ,UPMU_NAME);                 // ���� �̸�
                    ptMailBody.setProperty("AINF_SEQN", data.AINF_SEQN);
                    // ��û�� ����
                    // �� ����
                    StringBuffer sbSubject = new StringBuffer(512);

                    sbSubject.append("[" + ptMailBody.getProperty("UPMU_NAME") + "] ");
                    sbSubject.append(ptMailBody.getProperty("ename") +"���� ��û�ϼ̽��ϴ�.");

                    ptMailBody.setProperty("subject" ,sbSubject.toString());
                    ptMailBody.setProperty("FileName" ,"MbNoticeMailBuild.html");
                    
                    String msg = "msg001";
                    String msg2 = "";

                    MailSendToEloffic  maTe = new MailSendToEloffic(ptMailBody);

                    if (!maTe.process()) {
                        msg2 = maTe.getMessage();
                    } // end if

                    try {
                        DraftDocForEloffice ddfe = new DraftDocForEloffice();

                        ElofficInterfaceData eof = ddfe.makeDocContents(data.AINF_SEQN ,user.SServer,ptMailBody.getProperty("UPMU_NAME"));

                        Vector vcElofficInterfaceData = new Vector();
                        vcElofficInterfaceData.add(eof);
                        //req.setAttribute("vcElofficInterfaceData", vcElofficInterfaceData);
                        //dest = WebUtil.JspURL+"common/ElOfficeInterface.jsp";
                        //���հ��� ���������� ���� ������������ ������  2012.11.07                         
                        try {                         	
                        	SendToESB esb = new SendToESB();                
                        	String esbmsg = esb.process(vcElofficInterfaceData );
                            Logger.debug.println(this ,"[esbmsg]  :"+esbmsg); 
                        	req.setAttribute("message", esbmsg);
                        	dest = WebUtil.JspURL+"common/EsbResult.jsp";
    	                } catch (Exception e) {
    	                	Logger.error(e);
                           dest = WebUtil.JspURL+"common/msg.jsp";
                           msg2 = msg2 + "\\n" + " Eloffic ���� ����" ;
                       }           
                    } catch (Exception e) {
                        dest = WebUtil.JspURL+"common/msg.jsp";
                        //msg2 = msg2 + "\\n" + " Eloffic ���� ����" ;
                        msg = msg + "\\n" + " Eloffic ���� ����" ;
                    } // end try
                    
                    String url = "location.href = \'" + WebUtil.ServletURL+"hris.D.D03Vocation.D03VocationCancelBuildSV?AINF_SEQN="+AINF_SEQN+"&jobid=after\'";
                    req.setAttribute("msg", msg);
                    req.setAttribute("msg2", msg2);
                    req.setAttribute("url", url);
                } else {
                	con.rollback();
                	String msg = E_MESSAGE; 
                	req.setAttribute("", jobid);
                    req.setAttribute("message", msg);
                    dest = WebUtil.ServletURL+"hris.D.D03Vocation.D03VocationCancelBuildSV?AINF_SEQN="+AINF_SEQN+"';";
                }
*/
            } else {
                throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
            } // end if

            Logger.debug.println(this, " destributed = " + dest);
            printJspPage(req, res, dest);

        } catch(Exception e) {
        	Logger.error(e);
            Logger.err.println(DataUtil.getStackTrace(e));
            throw new GeneralException(e);
        } finally {
//            DBUtil.close(con);
//            try{ con.close(); } catch(Exception e){
//                Logger.err.println(e, e);
//            }
        }
    }
}
