/******************************************************************************/
/*
/*   System Name  : e-HR
/*   1Depth Name  :
/*   2Depth Name  :
/*   Program Name : ��й�ȣ �ʱ�ȭ �˾�
/*   Program ID   : InitPasswordSV.java
/*   Note         : ����
/*   Creation     :   20140716 [CSR ID:2574807] SAP ��ȣȭ �������濡 ���� E-hr WEB ����.
/*   Update       : 
/*
/********************************************************************************/

package servlet.hris;

import com.common.RFCReturnEntity;
import com.sns.jdf.Config;
import com.sns.jdf.Configuration;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;
import hris.common.PersonData;
import hris.common.WebUserData;
import hris.common.mail.MailEntity;
import hris.common.mail.MailMrg3;
import hris.common.mail.MakeMailBody;
import hris.common.rfc.InitPasswordRFC;
import hris.common.rfc.PersonInfoRFC;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.Properties;

//import hris.common.rfc.ChgPasswordRFC;
//import hris.common.rfc.GetPasswordRFC;

public class InitPasswordSV extends EHRBaseServlet {

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
        try{
            Config conf      = new Configuration();
            HttpSession session = req.getSession(true);
            
			Box box = WebUtil.getBox(req);
            WebUserData user = new WebUserData();
            box.copyToEntity(user);

			String secretEmpNo = user.empNo;
            String originEmpNo = null;
            String jobid = box.get("jobid");
            if( jobid.equals("") ){
                jobid = "first";
            }
            Logger.debug.println(this, "[jobid] = "+jobid + " [user] : "+user.toString());

			PersonInfoRFC personInfoRFC        = new PersonInfoRFC();
            PersonData personData   = new PersonData();
           
            String empName = box.getString("empname");
            empName = DataUtil.removeBlank(empName);
            
            /*******************************
             *  @$ ���������� marco257
             *  �ֹι�ȣ -> ������Ϸ� ����
             *******************************/
            String regNo   = box.getString("regno");
            //regNo          = DataUtil.removeStructur(regNo, "-");

            // ��ȣ�� Ǯ� ����������� ����� "" ���� ���ϵǸ� ��ȿ���� ���� ����̴�
            //Logger.debug.print(this ," secretEmpNo : [" + secretEmpNo + "] \t user.empNo : [" + user.empNo + "]");
            //Logger.debug.print(this ," secretEmpNo : [" + secretEmpNo + "] \t  calculateEmpNo(secretEmpNo): [" +  calculateEmpNo(secretEmpNo) + "]");
              
            //sso ���������� ����ó���� 05.10.24 lsa(�������� elo���� ��ȣ�ϵȻ���� �Ѿ������  
            //sso����ó���� ������ �Ȱ�쿡�� ����������system_id�� ���� �����Ƿ� �̰��� �о� ó���ϸ� �� (SSO�κ������ ��)
            originEmpNo = (String)session.getAttribute("SYSTEM_ID");  
            //if (conf.getBoolean("com.sns.jdf.decode")) {
            //    originEmpNo = calculateEmpNo(secretEmpNo);
            //         Logger.debug.print(this ," calculateEmpNo(secretEmpNo) a1: [" + calculateEmpNo(secretEmpNo) );
            //    
            //} else {
            //    originEmpNo = secretEmpNo;
            //         Logger.debug.print(this ," secretEmpNo a2: [" + secretEmpNo );
            //    
            //} // end if
            
            if (originEmpNo == null || originEmpNo.trim().length() < 1) {
                String msg = "��ȿ�� �����ȣ�� �ƴմϴ�.";
                    //Logger.debug.print(this ," originEmpNo 1: [" + originEmpNo );
                throw new GeneralException(msg);
            } else {
                originEmpNo = DataUtil.fixEndZero(originEmpNo, 8);
                    //Logger.debug.print(this ," originEmpNo 2: [" + originEmpNo );
            } // end if

            personData = (PersonData)personInfoRFC.getPersonInfo(originEmpNo, "X");

            user.login_stat  = "Y";
            user.companyCode = personData.E_BUKRS ;
            
            user.clientNo    = conf.get("com.sns.jdf.sap.SAP_CLIENT");
            user.empNo       = originEmpNo;
            personInfoRFC.setSessionUserData(personData, user);

            DataUtil.fixNull(user);
            /*************************************************************
	         * @$ ���������� marco257
	         * �ֹι�ȣ�� ���ڸ���(�������) üũ�� 
	         **************************************************************/
            String se_regno = user.e_regno.substring(0,6);
            if ( empName.equals(DataUtil.removeBlank(user.ename)) && regNo.equals(se_regno) ) {
				//Vector getUD = getPassword(originEmpNo);
                RFCReturnEntity initResult = initPassword(originEmpNo);

                Properties ptMailBody = new Properties();
                
                ptMailBody.setProperty("PassWord", initResult.MSGTX);//sap�� return ������ ���Ϸ� �״�� ���۵�(��й�ȣ�� LGCHEM0000���� ����Ǿ����ϴ�. )
                ptMailBody.setProperty("E_NAME"  , personData.E_ENAME);
                ptMailBody.setProperty("ResponseURL",conf.getString("com.sns.jdf.mail.ResponseURL"));
                ptMailBody.setProperty("ImageURL",WebUtil.ImageURL);
                
                if (initResult.MSGTY == null || initResult.MSGTY.length() < 1) {
                    Logger.debug.print(this ," �˻���й�ȣ��� : [" + originEmpNo + "] \t return �޽��� : [" + initResult.MSGTX + "]");
                } // end if
                String msg = "��й�ȣ�� ���Ϸ� ���޵Ǿ����ϴ�.";
                if (personData.E_MAIL.equals("") || personData.E_MAIL.length() == 0 ){
                	msg = "����ID�� ��ϵ��� �ʾҽ��ϴ�.�ش� ����� �λ����� ����ID�Է� ��û�Ͻñ� �ٶ��ϴ�. " + initResult.MSGTX;
                }else if(initResult.isSuccess()){
                   sendMail(personData.E_MAIL, "e-HR ��й�ȣ �ʱ�ȭ ��û�� ���� �亯 ",  ptMailBody);
                }else{//Error�� ���
                	msg = initResult.MSGTY;
                }
			    
			    String url = "self.close();";
			    req.setAttribute("msg", msg);
			    req.setAttribute("url", url);
                printJspPage(req, res, WebUtil.JspURL +"common/msg.jsp");

            } else if ( !empName.equals(DataUtil.removeBlank(user.ename)) ) {
			    String msg = "������ ��ġ���� �ʽ��ϴ�.";
			    String url = "history.back();";
			    req.setAttribute("msg", msg);
			    req.setAttribute("url", url);
                printJspPage(req, res, WebUtil.JspURL +"common/msg.jsp");

            } else if ( !regNo.equals(se_regno) ) {
			    String msg = "�ֹι�ȣ�� ��ġ���� �ʽ��ϴ�.";
			    String url = "history.back();";
			    req.setAttribute("msg", msg);
			    req.setAttribute("url", url);
                printJspPage(req, res, WebUtil.JspURL +"common/msg.jsp");
            }
        }catch(Exception e){
            throw new GeneralException(e);
        }
    }
    
    private boolean sendMail(String eMailAddr, String subject, Properties ptMailBody) 
    {
        MailEntity   me          =    new MailEntity();
        String       fileName   = "NoticePasswdMail.html";         
        boolean     isSuccess  = false; 
        
        try {
            Config conf     = new Configuration();
            me.setFrom(conf.getString("com.sns.jdf.mail.MAILFROM"));
            
            String[]    to = new String[1];
            to[0] = eMailAddr;
            me.setTo(to);
            me.setSubject(subject);
            
            if (ptMailBody != null) {
                String tempPath     = conf.get("com.sns.jdf.mail.TEMPPATH") + fileName;
                MakeMailBody mmb = new MakeMailBody(tempPath ,ptMailBody);
                me.setContent(mmb.MakeContents());
            } else {
                me.setContent(" ");
            } // end if
            
            (new MailMrg3()).sendMailToUsers(me);
            
            isSuccess  = true;
        } catch (Exception e) {
            Logger.err.println(this ,DataUtil.getStackTrace(e));
            isSuccess  = false;
        }
        return isSuccess;
    }

    private RFCReturnEntity initPassword(String webUserId) throws GeneralException{
    	InitPasswordRFC rfc = new InitPasswordRFC();
        return rfc.initPassword(webUserId);
    }
   
}
