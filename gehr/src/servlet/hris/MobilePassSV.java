/******************************************************************************/
/*
/*   System Name  : e-HR
/*   1Depth Name  : Work Center
/*   2Depth Name  : ����� �α���ó��
/*   Program Name : �����  ���ڰ����� �������� CLICK�� ����
/*   Program ID   : MobilePassSV.java
/*   Description  : ����Ͽ��� ��������� �α��� ó��
/*   Note         : 
/*   Creation     : 2011-05-11 JMK
/*   Update       :   
/*                :  2015-08-20 ������ [CSR ID:] ehr�ý�������༺���� ����                       */
/********************************************************************************/
package servlet.hris;

import com.sns.jdf.Config;
import com.sns.jdf.Configuration;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.mobile.EncryptionTool;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;
import hris.common.PersonData;
import hris.common.WebUserData;
import hris.common.rfc.PersonInfoRFC;
import hris.common.util.DocumentInfo;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class MobilePassSV extends EHRBaseServlet
{
    protected void performPreTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        try{
            performTask(req, res);
        }catch(GeneralException e){
            throw new GeneralException (e);
        }
    }

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        //Connection conn = null;
    	
        boolean isCommit = false;
       
        try{
        	Logger.debug.println("MobilePassSV  start++++++++++++++++++++++++++++++++++++++" );
            HttpSession session = req.getSession(true);
            
            String msg = ""; //[CSR ID:] ehr�ý�������༺���� ����
            WebUserData user = new WebUserData();
            Box box = WebUtil.getBox(req);
            Logger.debug.println("##########box####################>"+box);
            String empNo = box.getString("empNo");
            empNo = EncryptionTool.decrypt(empNo);
            empNo = DataUtil.fixEndZero( empNo ,8);
            String AINF_SEQN =box.getString("AINF_SEQN");
            user.empNo = empNo;
            
            Logger.debug.println("#############################empNo:"+empNo);
            Logger.debug.println("#########################AINF_SEQN:"+AINF_SEQN);
            
            //String dest = "";
            //String dest = WebUtil.JspURL+"common/mobileResult.jsp";
            
            String returnPage = "";
            boolean isNotApp = false ;
            String dest = makeDetailPageURL(AINF_SEQN ,empNo ,returnPage ,isNotApp);
            
            
            try{
                PersonInfoRFC personInfoRFC        = new PersonInfoRFC();
                PersonData personData   = new PersonData();
                personData = (PersonData)personInfoRFC.getPersonInfo(empNo, "X");
                if( personData.E_BUKRS == null|| personData.E_BUKRS.equals("") ) {

                    //String msg = "�����ȣ�� Ȯ���Ͽ� �ֽʽÿ�.";
                    msg = "���� �� ������ �߻��Ͽ����ϴ�."; //[CSR ID:] ehr�ý�������༺���� ����
                    String url = "histroy.back(-1);";
                    req.setAttribute("msg", msg);
                    req.setAttribute("url", url);
                    dest =  WebUtil.JspURL +"common/msg.jsp";
                } else {

                    Config conf           = new Configuration();
                    user.clientNo         = conf.get("com.sns.jdf.sap.SAP_CLIENT");

                    user.login_stat       = "Y";

                    personInfoRFC.setSessionUserData(personData, user);

                    user.loginPlace       = "ElOffice";
                    user.empNo            = empNo;
                    //user.SServer          = SServer;
                    

                    //@v1.0 �޴����� db�� oracle���� sap�� �̰�
                    /*SysAuthGroupRFC rfc_Auth         = new SysAuthGroupRFC();
                    user.user_group = (new SysAuthGroupRFC()).getAuthGroup(user.e_authorization);*/

                    isCommit = true;

                    DataUtil.fixNull(user);
                    session = req.getSession(true);

                    int maxSessionTime = Integer.parseInt(conf.get("com.sns.jdf.SESSION_MAX_INACTIVE_INTERVAL"));
                    session.setMaxInactiveInterval(maxSessionTime);
                    session.setAttribute("user",user);
                  
                } // end if
            }catch(Exception ex){
                Logger.err.println(this,"Data Not Found");
                //String msg = "���� �� ������ �߻��Ͽ����ϴ�.";
                msg = "���� �� ������ �߻��Ͽ����ϴ�."; //[CSR ID:] ehr�ý�������༺���� ����
                String url = "histroy.back(-1);";
                req.setAttribute("msg", msg);
                req.setAttribute("url", url);
                dest =  WebUtil.JspURL +"common/msg.jsp";
            } // end try & catch
            
            printJspPage(req, res, dest);
        }catch(Exception ConfigurationException){
            throw new GeneralException(ConfigurationException);
        } finally {
            //DBUtil.close(conn ,isCommit);
        } // end try
    }
    private String makeDetailPageURL(String AINF_SEQN ,String empNo ,String requestName,boolean isNotApp) throws GeneralException
    {
        StringBuffer detailPage = new StringBuffer(256);
        // ���� ������ ����
        try{
	        DocumentInfo docInfo = new DocumentInfo(AINF_SEQN ,empNo ,isNotApp);
	        if (!docInfo.isHaveAuth()) {
	            Logger.info.println(this ,empNo + "��  " + AINF_SEQN + " ������ ������ �� �����ϴ�");
	            return    WebUtil.JspURL +"err/error.jsp";
	          
	        } // end if
//            return WebUtil.makeGotoUrl(docInfo.getUPMU_TYPE() ,docInfo.getType() ,AINF_SEQN ,requestName);

            return WebUtil.approvalMappingURL(docInfo, AINF_SEQN, requestName);

        } catch (Exception e) {
            throw new GeneralException(AINF_SEQN + " ���������� �������� �ʽ��ϴ�");
        } // end if
    }
}