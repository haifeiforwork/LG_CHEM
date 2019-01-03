/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : �����ؾ��� ����                                             */
/*   2Depth Name  :                                                             */
/*   Program Name : �ʰ��ٹ� ��ҽ�û ����                                      */
/*   Program ID   : G084ApprovalOTCancelSV.java                                 */
/*   Description  :                                                             */
/*   Note         :                                                             */
/*   Creation     : 2005-03-10 �����                                           */
/*   Update       : 2006-01-18 @v1.1 ���ڰ��翬�����з� ���� ���Ϲ߼۰� ��ġ���� */
/*                  2018-06-14 [WorkTime52] I_NTM ���� �߰�                      */
/*                                                                              */
/********************************************************************************/

package servlet.hris.G;

import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;

import hris.G.ApprovalCancelData;
import hris.G.rfc.ApprovalCancelRFC;
import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalHeader;
import hris.common.approval.ApprovalLineData;


@SuppressWarnings("serial")
public class G084ApprovalOTCancelSV extends ApprovalBaseServlet {

    private String UPMU_TYPE = "40";
    private String UPMU_NAME = "�ʰ��ٹ���û ���";

    protected String getUPMU_TYPE() {
        return UPMU_TYPE;
    }

    protected String getUPMU_NAME() {
        return UPMU_NAME;
    }

    @SuppressWarnings("rawtypes")
    protected void performTask(final HttpServletRequest req, final HttpServletResponse res) throws GeneralException {
        try {
            final WebUserData user = WebUtil.getSessionUser(req);

            ApprovalCancelRFC appRfc = new ApprovalCancelRFC();
            Vector appCancelVt = null;

            String dest = "";
            String jobid = "";

            final Box box = WebUtil.getBox(req);
            String AINF_SEQN = box.get("AINF_SEQN");

            // ó�� �� ���� �� ������
            String RequestPageName = box.get("RequestPageName");
            req.setAttribute("RequestPageName", RequestPageName);

            jobid = box.get("jobid", "search");

            /** ���ο���� ���� **/
            appRfc.setDetailInput(user.empNo, "1", AINF_SEQN);
            appCancelVt = appRfc.get(user.empNo, AINF_SEQN);
            ApprovalCancelData appData = new ApprovalCancelData();
            appData = (ApprovalCancelData) appCancelVt.get(0);

            /* ���� �� */
            if ("A".equals(jobid)) {
                /* ������ ���� �� */
                dest = accept(req, box, "T_ZHRA040T", appData, appRfc, new ApprovalFunction<ApprovalCancelData>() {
                    public boolean porcess(ApprovalCancelData inputData, ApprovalHeader approvalHeader, Vector<ApprovalLineData> approvalLineDatas) throws GeneralException {

                        /* ������ ���� ���� */
                        // box.copyToEntity(inputData); //����ڰ� �Է��� ����Ÿ�� ������Ʈ
                        // inputData = d01sv.doWithData(inputData);

                        inputData.APPL_REAS = box.get("APPL_REAS");
                        inputData.UNAME = user.empNo;
                        inputData.AEDTM = DataUtil.getCurrentDate();
                        inputData.I_NTM = "X"; // [WorkTime52]

                        return true;
                    }
                });

                /* �ݷ��� */
            } else if ("R".equals(jobid)) {
                dest = reject(req, box, null, appCancelVt, appRfc, null);
            } else if ("C".equals(jobid)) {
                dest = cancel(req, box, null, appCancelVt, appRfc, null);
            } else {
                throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
            }

            /* ���ο���� ��          
                        
            if(jobid == null || jobid.equals("") ){
                jobid = "search";
            }// end if
            
            if( jobid.equals("search") ) {
            //            	�ʰ��ٹ����������ȸ            	
            	appCancelVt = appRfc.get(user.empNo, AINF_SEQN);
            	if(appCancelVt.size()>0){
            		ApprovalCancelData appData = new ApprovalCancelData();
            		appData = (ApprovalCancelData)appCancelVt.get(0);
            		//������ �ʰ��ٹ���ȸ
            		String ORG_AINF_SEQN = appData.ORG_AINF_SEQN;
            		//�ʰ��ٹ�
            		D01OTRFC  otRfc       = new D01OTRFC();
            		d01OTData_vt = otRfc.getDetail(ORG_AINF_SEQN, appData.PERNR);
                    if( d01OTData_vt.size() < 1 ){
                        String msg = "System Error! \n\n ��ȸ�� �׸��� �����ϴ�.";
                        req.setAttribute("msg", msg);
                        dest = WebUtil.JspURL+"common/caution.jsp";
                    }else{
                        // ORG������ ����
                        orgVcAppLineData = AppUtil.getAppChangeVt(ORG_AINF_SEQN);
                        vcAppLineData = AppUtil.getAppChangeVt(AINF_SEQN);
                        // ���� ����.
                       PersInfoWithNoRFC piRfc = new PersInfoWithNoRFC();
                       PersInfoData      pid   = (PersInfoData) piRfc.getApproval(appData.PERNR).get(0);
                       //����������
                       d01OTData = (D01OTData)d01OTData_vt.get(0);
                        req.setAttribute("PersInfoData" ,pid );
                        req.setAttribute("orgVcAppLineData" , orgVcAppLineData);
                        req.setAttribute("d01OTData", d01OTData);
                        req.setAttribute("vcAppLineData" , vcAppLineData);
                        req.setAttribute("appCancelVt", appCancelVt);
                    } // end if
            
                    dest = WebUtil.JspURL+"G/G084ApprovalOTCancel.jsp";
                } // end if
            } else if( jobid.equals("save") ) {
            	
            	d01OTData    = new D01OTData();
            	d01OTData_vt = new Vector();
                vcAppLineData      = new Vector();
                AppLineData  tempAppLine;
                Vector       vcTempAppLineData = new Vector();
                AppLineData  appLine           = new AppLineData();
            
                // �ʰ��ٹ� ���� �ڷ�
                box.copyToEntity(d01OTData);
                d01OTData.UNAME = user.empNo;
                d01OTData.AEDTM = DataUtil.getCurrentDate();
                
                // ������ ����
                int nRowCount = Integer.parseInt(box.getString("RowCount"));
                String APPU_TYPE = box.get("APPU_TYPE");
                String APPR_SEQN = box.get("APPR_SEQN");
                String currApprNumb = "";  //ESB ���� ����
            
                for (int i = 0; i < nRowCount; i++) {
                    tempAppLine = new AppLineData();
                    box.copyToEntity(tempAppLine ,i);
                    vcTempAppLineData.add(tempAppLine);
                    if (tempAppLine.APPL_APPR_STAT.equals("�̰�") && currApprNumb.equals("")){
                    	currApprNumb = tempAppLine.APPL_APPU_NUMB;
                    }  
                    if (tempAppLine.APPL_APPU_TYPE.equals(APPU_TYPE) && tempAppLine.APPL_APPR_SEQN.equals(APPR_SEQN)) {
                        appLine.APPL_BUKRS = box.getString("BUKRS");
                        appLine.APPL_PERNR = box.getString("PERNR");
                        appLine.APPL_BEGDA = box.getString("BEGDA");
                        appLine.APPL_AINF_SEQN = box.getString("AINF_SEQN");
                        appLine.APPL_APPU_TYPE = APPU_TYPE;
                        appLine.APPL_APPR_SEQN = APPR_SEQN;
                        appLine.APPL_APPU_NUMB = user.empNo;
                        appLine.APPL_APPR_STAT = box.getString("APPR_STAT");
                        appLine.APPL_BIGO_TEXT = box.getString("BIGO_TEXT");
                        appLine.APPL_APPR_DATE = DataUtil.getCurrentDate();
                    } // end if
                } // end for
            
                Logger.debug.println(this ,vcTempAppLineData);
                Logger.debug.println(this ,appLine);
                vcAppLineData.add(appLine);
                G001ApprovalProcessRFC  Apr = new G001ApprovalProcessRFC();
                Vector vcRet = Apr.setApprovalStatutsList(vcAppLineData );
            
                Logger.debug.println(this ,vcRet);
                ApprovalReturnState ars = (ApprovalReturnState) vcRet.get(0);
            
                PersonInfoRFC numfunc = new PersonInfoRFC();
                PersonData phonenumdata;
                phonenumdata = (PersonData)numfunc.getPersonInfo(d01OTData.PERNR);
            
                Properties ptMailBody = new Properties();
                ptMailBody.setProperty("SServer",user.SServer);          // ElOffice ���� ����
                ptMailBody.setProperty("from_empNo" ,user.empNo);        // �� �߼��� ���
                ptMailBody.setProperty("ename" ,phonenumdata.E_ENAME);   // (��)��û�ڸ�
                ptMailBody.setProperty("empno" ,phonenumdata.E_PERNR);   // (��)��û�� ���
                ptMailBody.setProperty("UPMU_NAME" ,"�ʰ��ٹ� �������");             // ���� �̸�
                ptMailBody.setProperty("AINF_SEQN" ,AINF_SEQN);          // ��û�� ����
            
                // �� ����
                StringBuffer sbSubject = new StringBuffer(512);
            
                sbSubject.append("[" + ptMailBody.getProperty("UPMU_NAME") + "] ");
                //sbSubject.append(user.ename  + "���� ");
                sbSubject.append(user.ename).append("���� ");
                
                String msg;
                String msg2 = "";
                String to_empNo = d01OTData.PERNR;
                String lastYn = "N";
                if (ars.E_RETURN.equals("S")) {
            
                    if (appLine.APPL_APPR_STAT.equals("A")) {
                        msg = "msg009";
                        for (int i = 0; i < vcTempAppLineData.size(); i++) {
                            tempAppLine = (AppLineData) vcTempAppLineData.get(i);
                            if (tempAppLine.APPL_APPU_TYPE.equals(APPU_TYPE) && tempAppLine.APPL_APPR_SEQN.equals(APPR_SEQN)) {
                                if (i == vcTempAppLineData.size() -1) {
                                    // ������ ������
                                	lastYn = "Y";
                                    ptMailBody.setProperty("FileName" ,"MbNoticeMailApp.html");
                                    sbSubject.append(ptMailBody.getProperty("UPMU_NAME") +"�� ���� �ϼ̽��ϴ�..");
                                } else {
                                    // ���� ������
                                    tempAppLine = (AppLineData) vcTempAppLineData.get(i+1);
                                    to_empNo = tempAppLine.APPL_APPU_NUMB;
                                    ptMailBody.setProperty("FileName" ,"MbNoticeMailBuild.html");
                                    sbSubject.append(ptMailBody.getProperty("UPMU_NAME") +" ���縦 ��û �ϼ̽��ϴ�.");
                                    break;
                                } // end if
                            } // end if
                        } // end for
                    } else {
                        msg = "msg010";
                        if (APPU_TYPE.equals("02") && Integer.parseInt(APPR_SEQN) > 1) {
                            for (int i = 0; i < vcTempAppLineData.size(); i++) {
                                tempAppLine = (AppLineData) vcTempAppLineData.get(i);
                                if (tempAppLine.APPL_APPU_TYPE.equals("02") && tempAppLine.APPL_APPR_SEQN.equals("01")) {
                                    tempAppLine = (AppLineData) vcTempAppLineData.get(i);
                                    to_empNo = tempAppLine.APPL_APPU_NUMB;
                                } // end if
                            } // end for
                        } // end if
                        ptMailBody.setProperty("FileName" ,"MbNoticeMailRej.html");
                        sbSubject.append(ptMailBody.getProperty("UPMU_NAME") +"�� �ݷ� �ϼ̽��ϴ�.");
                    } // end if
            
                    ptMailBody.setProperty("to_empNo" ,to_empNo);                   // �� ������ ���
                    ptMailBody.setProperty("subject" ,sbSubject.toString());        // �� ���� ����
                    MailSendToEloffic   maTe = new MailSendToEloffic(ptMailBody);
            
                    try {
                        DraftDocForEloffice ddfe = new DraftDocForEloffice();
                        ElofficInterfaceData eof;
                        Vector vcElofficInterfaceData = new Vector(); //ESB ���� ����
                    	//ESB ���� ����
                    	if (!currApprNumb.equals(user.empNo)) {                    		
                        	//����÷��� ������ ���� �׽�ũ�� ������ �ִ� �����ڰ� �����Ҷ� ó��:���� ���ڰ��翡 ���ִ� DATA�� ������ �ٽ� ó��  
                        	ElofficInterfaceData eofD = ddfe.makeDocForDelete(AINF_SEQN ,user.SServer , phonenumdata.E_PERNR, ptMailBody.getProperty("UPMU_NAME") , currApprNumb);
                        	
                        	vcElofficInterfaceData.add(eofD); 
                           	ElofficInterfaceData eofI = ddfe.makeDocForInsert(AINF_SEQN ,user.SServer , phonenumdata.E_PERNR,  ptMailBody.getProperty("UPMU_NAME")  );
                            vcElofficInterfaceData.add(eofI); 
                	    }                        
                        if (appLine.APPL_APPR_STAT.equals("A")) {                        	
                            eof = ddfe.makeDocContents(AINF_SEQN ,user.SServer,ptMailBody.getProperty("UPMU_NAME"));                            
                        } else {
                            if (APPU_TYPE.equals("02") && Integer.parseInt(APPR_SEQN) > 1) {
                            	eof = ddfe.makeDocForMangerReject(AINF_SEQN ,user.SServer,ptMailBody.getProperty("UPMU_NAME") ,vcTempAppLineData);
                            } else {
                            	int nRejectLength = 0;
                                for (int i = vcTempAppLineData.size() - 1; i >= 0; i--) {
                                    tempAppLine = (AppLineData) vcTempAppLineData.get(i);
                                    if (tempAppLine.APPL_APPU_TYPE.equals(APPU_TYPE) && tempAppLine.APPL_APPR_SEQN.equals(APPR_SEQN)) {
                                        nRejectLength = i + 1;
                                        break;
                                    } // end if
                                } // end for
            
                                String approvers[] = new String[nRejectLength];
                                for (int i = 0; i < approvers.length; i++) {
                                    tempAppLine = (AppLineData) vcTempAppLineData.get(i);
                                    approvers[i]    =   tempAppLine.APPL_APPU_NUMB;
                                } // end for
                                if (!currApprNumb.equals(user.empNo)) {  
                                    approvers[approvers.length-1] =user.empNo; //ESB ���� ���� 
                                }                                  
                                eof = ddfe.makeDocForReject(AINF_SEQN ,user.SServer,ptMailBody.getProperty("UPMU_NAME") ,d01OTData.PERNR ,approvers);
                            } // end if
                        } // end if
             
                        vcElofficInterfaceData.add(eof);
                        
                        //�������� �ݷ�ó��
                        if(lastYn.equals("Y")){
                            appCancelVt = appRfc.get(user.empNo, AINF_SEQN);
                            ApprovalCancelData data = new ApprovalCancelData();
                            data = (ApprovalCancelData)appCancelVt.get(0);
                            orgVcAppLineData = AppUtil.getAppChangeVt(data.ORG_AINF_SEQN);
                            orgVcAppLineData.get(orgVcAppLineData.size()-1);
                            AppLineData  orgAppLine           = new AppLineData();
                            orgAppLine = (AppLineData)orgVcAppLineData.get(orgVcAppLineData.size()-1);
                            
                            //�����������
                            ElofficInterfaceData eofD = ddfe.makeDocForChange(data.ORG_AINF_SEQN ,user.SServer , phonenumdata.E_PERNR,  "�ʰ��ٹ�", orgAppLine.APPL_PERNR);
                            vcElofficInterfaceData.add(eofD);
                            
                            //��û�� ��������
                            String rEmpNo = phonenumdata.E_PERNR; //��û��
                            String aEmpNo = "";	//������
                            String[] approvers =  new String[orgVcAppLineData.size()];
                            for(int i=0;i<orgVcAppLineData.size();i++){
                            	AppLineData app = (AppLineData)orgVcAppLineData.get(i);
                            	
                            	aEmpNo = app.APPL_PERNR;
                            	if(i==0){
                            		vcElofficInterfaceData.add(ddfe.makeDocOrg(data.ORG_AINF_SEQN ,user.SServer,"R" , "", aEmpNo, rEmpNo, "�ʰ��ٹ�", "��û" ));                            	
                            	} else {
                            		vcElofficInterfaceData.add(ddfe.makeDocOrg(data.ORG_AINF_SEQN ,user.SServer,"M" , "", aEmpNo, rEmpNo, "�ʰ��ٹ�", "������" )); 
                            	}
                            	rEmpNo = aEmpNo;
                            	approvers[i] = app.APPL_PERNR;
                            }                            
                            //���
                        	vcElofficInterfaceData.add(ddfe.makeDocForReject(data.ORG_AINF_SEQN ,user.SServer, "�ʰ��ٹ�", rEmpNo , approvers));
                            Logger.debug.println("�������� �ݷ�ó��:"+vcElofficInterfaceData.toString());
                        }
                        
                        //���հ��� ���������� ���� ������������ ������  2012.11.07                         
                        try { 
                        	
                        	SendToESB esb = new SendToESB();                
                        	String esbmsg = esb.process(vcElofficInterfaceData );
                            Logger.debug.println(this ,"[esbmsg]  :"+esbmsg); 
                        	req.setAttribute("message", esbmsg);
                        	dest = WebUtil.JspURL+"common/EsbResult.jsp";
                        } catch (Exception e) {
                        	//Logger.error(e);
                           dest = WebUtil.JspURL+"common/msg.jsp";
                           msg2 += "\\n" + "esb.process Eloffice ���� ����" ;
                       }                         
                        
                        
                    } catch (Exception e) {
                    	//Logger.error(e);
                        dest = WebUtil.JspURL+"common/msg.jsp";
                        msg2 +=  " Eloffic ���� ���� " ;
                    } // end try
                    //@v1.1 ���ڰ��翬�����з� ���ϰ� ��ġ����                        
                    if (!maTe.process()) {
                        msg2 = maTe.getMessage() + "\\n";
                    } // end if
                    
                } else {
                    msg = ars.E_MESSAGE;
                    dest = WebUtil.JspURL+"common/msg.jsp";
                } // end if
            
                String url = "location.href = \"" + RequestPageName.replace('|','&') + "\";";
            
                req.setAttribute("msg", msg);
                req.setAttribute("msg2", msg2);
                req.setAttribute("url", url);
            
            } else {
                throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
            } // end if
            
             ���� ���� �� */

            Logger.debug.println(this, " destributed = " + dest);

            printJspPage(req, res, dest);

        } catch (Exception e) {
            Logger.err.println(DataUtil.getStackTrace(e));

            throw new GeneralException(e);

        }
    }

}