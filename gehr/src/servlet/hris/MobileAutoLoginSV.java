/******************************************************************************/
/*
/*   System Name  : e-HR
/*   1Depth Name  : Work Center
/*   2Depth Name  : 모바일 로그인처리
/*   Program Name : ELOFFICE의 전자결재의 목록CLICK시 연결
/*   Program ID   : ESBApprovalAutoLoginSV.java
/*   Description  : 모바일에서 접근시 로그인처리
/*   Note         : 
/*   Creation     :  
/*   Update       : 2011-05-11  
/*                :  2015-08-20 이지은 [CSR ID:] ehr시스템웹취약성진단 수정                       */
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
import hris.D.D03Vocation.rfc.D03VocationAReasonRFC;
import hris.common.PersonData;
import hris.common.WebUserData;
import hris.common.rfc.PersonInfoRFC;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
public class MobileAutoLoginSV extends EHRBaseServlet
{
    protected void performPreTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        try{
        	Logger.debug.println("MobileAutoLoginSV super start++++++++++++++++++++++++++++++++++++++" );
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
        	Logger.debug.println("MobileAutoLoginSV  start++++++++++++++++++++++++++++++++++++++" );
            HttpSession session = req.getSession(true);
            
            WebUserData user = new WebUserData();
            Box box = WebUtil.getBox(req);
            Logger.debug.println("##########box####################>"+box);
            String empNo = box.getString("empNo");
            empNo = EncryptionTool.decrypt(empNo);
            String msg = ""; //[CSR ID:] ehr시스템웹취약성진단 수정
            

            String dest = WebUtil.JspURL+"common/mobileResult.jsp";

            Logger.debug.println("# # empNo.length():"+ empNo.length());
            if (empNo.length()<9) {
                user.empNo = DataUtil.fixEndZero( empNo ,8);
            }else{

                Logger.debug.println("# ####사원번호를 확인하여 주십시요.###empNo:"+empNo);
                //String msg = "사원번호를 확인하여 주십시요.";
                msg = "접속 중 오류가 발생하였습니다."; //[CSR ID:] ehr시스템웹취약성진단 수정
                String url = "histroy.back(-1);";
                req.setAttribute("msg", msg);
                req.setAttribute("url", url);
                dest =  WebUtil.JspURL +"common/msg.jsp";
            }
            Logger.debug.println("#############################empNo:"+empNo);
            //String dest = "";
            
                try{
                    PersonInfoRFC personInfoRFC        = new PersonInfoRFC();
                    PersonData personData   = new PersonData();
                    personData = (PersonData)personInfoRFC.getPersonInfo(empNo, "X");
                    if( personData.E_BUKRS == null|| personData.E_BUKRS.equals("") ) {

                        //String msg = "사원번호를 확인하여 주십시요.";
                        msg = "접속 중 오류가 발생하였습니다."; //[CSR ID:] ehr시스템웹취약성진단 수정
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

                      //[CSR ID:3004032] 인사하위영역 추가
                        String DATUM     = DataUtil.getCurrentDate();
                        String e_btrtl  = (new D03VocationAReasonRFC()).getE_BTRTL(user.companyCode,user.empNo, "2005",DATUM);
                        user.e_btrtl = e_btrtl;
                        
                        //@v1.0 메뉴관련 db를 oracle에서 sap로 이관
                        /*SysAuthGroupRFC rfc_Auth         = new SysAuthGroupRFC();
                        user.user_group = rfc_Auth.getAuthGroup(user.e_authorization);*/

                        isCommit = true;

                        DataUtil.fixNull(user);
                        session = req.getSession(true);

                        int maxSessionTime = Integer.parseInt(conf.get("com.sns.jdf.SESSION_MAX_INACTIVE_INTERVAL"));
                        session.setMaxInactiveInterval(maxSessionTime);
                        session.setAttribute("user",user);
                      
                    } // end if
                }catch(Exception ex){
                    Logger.err.println(this,"Data Not Found");
                    //String msg = "접속 중 오류가 발생하였습니다.";
                    msg = "접속 중 오류가 발생하였습니다."; //[CSR ID:] ehr시스템웹취약성진단 수정
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
 
}