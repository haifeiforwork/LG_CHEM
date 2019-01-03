/******************************************************************************/
/*
/*   System Name  : e-HR
/*   1Depth Name  : Work Center
/*   2Depth Name  : 모바일 로그인처리
/*   Program Name : 모바일  전자결재의 원문보기 CLICK시 연결
/*   Program ID   : MobilePassSV.java
/*   Description  : 모바일에서 원문보기시 로그인 처리
/*   Note         : 
/*   Creation     : 2011-05-11 JMK
/*   Update       :   
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
            
            String msg = ""; //[CSR ID:] ehr시스템웹취약성진단 수정
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
                    

                    //@v1.0 메뉴관련 db를 oracle에서 sap로 이관
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
    private String makeDetailPageURL(String AINF_SEQN ,String empNo ,String requestName,boolean isNotApp) throws GeneralException
    {
        StringBuffer detailPage = new StringBuffer(256);
        // 현재 결재자 구분
        try{
	        DocumentInfo docInfo = new DocumentInfo(AINF_SEQN ,empNo ,isNotApp);
	        if (!docInfo.isHaveAuth()) {
	            Logger.info.println(this ,empNo + "는  " + AINF_SEQN + " 문서에 접근할 수 없습니다");
	            return    WebUtil.JspURL +"err/error.jsp";
	          
	        } // end if
//            return WebUtil.makeGotoUrl(docInfo.getUPMU_TYPE() ,docInfo.getType() ,AINF_SEQN ,requestName);

            return WebUtil.approvalMappingURL(docInfo, AINF_SEQN, requestName);

        } catch (Exception e) {
            throw new GeneralException(AINF_SEQN + " 문서정보가 존재하지 않습니다");
        } // end if
    }
}