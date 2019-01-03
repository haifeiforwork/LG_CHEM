/******************************************************************************/
/*
/*   System Name  : e-HR
/*   1Depth Name  :
/*   2Depth Name  :
/*   Program Name : 비밀번호 초기화 팝업
/*   Program ID   : InitPasswordSV.java
/*   Note         : 없음
/*   Creation     :   20140716 [CSR ID:2574807] SAP 암호화 로직변경에 따른 E-hr WEB 수정.
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
             *  @$ 웹보안진단 marco257
             *  주민번호 -> 생년월일로 변경
             *******************************/
            String regNo   = box.getString("regno");
            //regNo          = DataUtil.removeStructur(regNo, "-");

            // 암호를 풀어서 원래사번으로 만들기 "" 값이 리턴되면 유효하지 않은 사번이다
            //Logger.debug.print(this ," secretEmpNo : [" + secretEmpNo + "] \t user.empNo : [" + user.empNo + "]");
            //Logger.debug.print(this ," secretEmpNo : [" + secretEmpNo + "] \t  calculateEmpNo(secretEmpNo): [" +  calculateEmpNo(secretEmpNo) + "]");
              
            //sso 인증연계후 변경처리함 05.10.24 lsa(기존에는 elo에서 암호하된사번이 넘어왔으나  
            //sso인증처리후 인증이 된경우에만 세션정보값system_id에 값이 있으므로 이값만 읽어 처리하면 됨 (SSO민병운과장 왈)
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
                String msg = "유효한 사원번호가 아닙니다.";
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
	         * @$ 웹보안진단 marco257
	         * 주민번호를 앞자리만(생년월일) 체크함 
	         **************************************************************/
            String se_regno = user.e_regno.substring(0,6);
            if ( empName.equals(DataUtil.removeBlank(user.ename)) && regNo.equals(se_regno) ) {
				//Vector getUD = getPassword(originEmpNo);
                RFCReturnEntity initResult = initPassword(originEmpNo);

                Properties ptMailBody = new Properties();
                
                ptMailBody.setProperty("PassWord", initResult.MSGTX);//sap의 return 문장이 메일로 그대로 전송됨(비밀번호가 LGCHEM0000으로 저장되었습니다. )
                ptMailBody.setProperty("E_NAME"  , personData.E_ENAME);
                ptMailBody.setProperty("ResponseURL",conf.getString("com.sns.jdf.mail.ResponseURL"));
                ptMailBody.setProperty("ImageURL",WebUtil.ImageURL);
                
                if (initResult.MSGTY == null || initResult.MSGTY.length() < 1) {
                    Logger.debug.print(this ," 검색비밀번호사번 : [" + originEmpNo + "] \t return 메시지 : [" + initResult.MSGTX + "]");
                } // end if
                String msg = "비밀번호가 메일로 전달되었습니다.";
                if (personData.E_MAIL.equals("") || personData.E_MAIL.length() == 0 ){
                	msg = "메일ID가 등록되지 않았습니다.해당 사업장 인사팀에 메일ID입력 요청하시기 바랍니다. " + initResult.MSGTX;
                }else if(initResult.isSuccess()){
                   sendMail(personData.E_MAIL, "e-HR 비밀번호 초기화 요청에 대한 답변 ",  ptMailBody);
                }else{//Error의 경우
                	msg = initResult.MSGTY;
                }
			    
			    String url = "self.close();";
			    req.setAttribute("msg", msg);
			    req.setAttribute("url", url);
                printJspPage(req, res, WebUtil.JspURL +"common/msg.jsp");

            } else if ( !empName.equals(DataUtil.removeBlank(user.ename)) ) {
			    String msg = "성명이 일치하지 않습니다.";
			    String url = "history.back();";
			    req.setAttribute("msg", msg);
			    req.setAttribute("url", url);
                printJspPage(req, res, WebUtil.JspURL +"common/msg.jsp");

            } else if ( !regNo.equals(se_regno) ) {
			    String msg = "주민번호가 일치하지 않습니다.";
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
