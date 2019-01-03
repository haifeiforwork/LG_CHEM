/********************************************************************************/
/*                                                                              */
/*   System Name  : ㅡ                                                                                                                     */
/*   1Depth Name  :                                                             */
/*   2Depth Name  : 모바일용                                                                                                           */
/*   Program Name : 모바일  autoLogin, 통합결재연동                                                                  */
/*   Program ID   : MobileApprovalSV                                            */
/*   Description  :                                                             */
/*   Note         :                                                             */
/*   Creation     : 2011-05-17  JMK                                             */
/*   Update       :                                                             */
/*                :  2015-08-20 이지은 [CSR ID:] ehr시스템웹취약성진단 수정                       */
/********************************************************************************/

package servlet.hris;

import com.lgchem.esb.adapter.ESBAdapter;
import com.lgchem.esb.adapter.LGChemESBService;
import com.lgchem.esb.exception.ESBTransferException;
import com.lgchem.esb.exception.ESBValidationException;
import com.sns.jdf.Config;
import com.sns.jdf.Configuration;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.mobile.EncryptionTool;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;
import hris.common.ElofficInterfaceData;
import hris.common.MobileReturnData;
import hris.common.PersonData;
import hris.common.WebUserData;
import hris.common.rfc.PersonInfoRFC;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.Hashtable;
import java.util.Vector;

public class MobileCommonSV  {

  	private final String APPR_SYSTEM_ID_GEA = "EHR";
	
    
    //통합결재 연동
    /**
     * 통합결재 연동
     * @return
     */
    public MobileReturnData ElofficInterface(Vector vcElofficInterfaceData, WebUserData user) {
    	Logger.debug.println(this ,"ElofficInterface  =++++++++++++++++++++>start");
    	//리턴값 setting 
    	MobileReturnData retunMsg = new MobileReturnData();
    	retunMsg.CODE = "";
    	retunMsg.VALUE = "";
    	Logger.debug.println(this ,"vcElofficInterfaceData=++++++++++++++++++++>"+vcElofficInterfaceData.toString());
    	try {  //try 1
    	
		    Vector vcEof = vcElofficInterfaceData;
		    com.sns.jdf.Config conf = new com.sns.jdf.Configuration();
		    boolean isDev = conf.getBoolean("com.sns.jdf.eloffice.ISDEVELOP");
		    
		    //String mobileUrl = "http://"+conf.getString("com.sns.jdf.eloffice.ResponseURL")+WebUtil.ServletURL+"hris.MobileDetailSV?"; //문서번호와 사번은 Mobile에서 던져준다
		    
		    //MobileDetailSV
		    //Logger.debug.println(this ,"mobileUrl=++++++++++++++++++++>"+mobileUrl);
		    Logger.debug.println(this ,"vcEof.size()=++++++++++++++++++++>"+vcEof.size());
	        for (int i = 0; i < vcEof.size(); i++) { 
		     ElofficInterfaceData  eof = (ElofficInterfaceData)vcEof.get(i);
		    
		        try { 
		         	 
		         	ESBAdapter esbAp = new LGChemESBService("APPINT_ESB" ,conf.getString("com.sns.jdf.eloffice.ESBInfo") );   
		        	Hashtable appParam = new Hashtable();      
	                //if ( eof.SUBJECT.equals("의료비")||eof.SUBJECT.equals("부양가족")||eof.SUBJECT.equals("부양 가족 여부")||eof.SUBJECT.equals("장학금/학자금")||eof.SUBJECT.equals("장학금/학자금 신청"))  {
	
	                Logger.debug.println(this ,"^^^^^ ElOfficeInterface</b>[eof:]"+eof.toString());	
	               // }
	                
	                if(eof.APP_ID.length() > 0)
	                {
	                    if(eof.APP_ID.indexOf("?eHR=") > 0)
	                    	eof.APP_ID = eof.APP_ID.substring(0,10)  ;  
	                }
	                if(eof.URL.length() > 0)
	                {
	                    if(eof.URL.indexOf("?eHR=") > 0)
	                    	eof.URL = eof.URL.replaceAll("\\?eHR=","")   ;
	                }		
	                appParam.put("CATEGORY"     ,eof.CATEGORY     );    //양식명                
	                appParam.put("MAIN_STATUS"  ,eof.MAIN_STATUS  );    //결재 Main상태         
	                appParam.put("P_MAIN_STATUS",eof.P_MAIN_STATUS);                            
	                appParam.put("SUB_STATUS"   ,eof.SUB_STATUS   );    //결재 Sub상태          
	                appParam.put("REQ_DATE"     ,eof.REQ_DATE     );    //요청일              
	                appParam.put("EXPIRE_DATE"  ,eof.EXPIRE_DATE  );    //보존년한              
	                appParam.put("AUTH_DIV"     ,eof.AUTH_DIV     );    //공개할부서            
	                appParam.put("AUTH_EMP"     ,eof.AUTH_EMP     );    //공개할개인            
	                appParam.put("MODIFY"       ,eof.MODIFY       );    //삭제구분              
	                appParam.put("F_AGREE"      ,eof.F_AGREE      );    //자동합의              
	                appParam.put("R_EMP_NO"     ,eof.R_EMP_NO     );    //기안자사번            
	                appParam.put("A_EMP_NO"     ,eof.A_EMP_NO     );    //결재자사번            
	                appParam.put("SUBJECT"      ,eof.SUBJECT      );    //양식제목              
	                appParam.put("APP_ID"       ,eof.APP_ID       );    //결재문서ID            
	                appParam.put("URL"	        ,eof.URL          );                            
	                appParam.put("DUMMY1"	    ,eof.DUMMY1       );     //모바일URL    
	                String ret_msg = "";
		
		         	if (eof.MODIFY.equals("D"))  {  
		                 // out.println( ret_msg+"<br><b>삭제</b>[appParam:]"+appParam.toString());    
		         	    ret_msg = esbAp.modifyESB(appParam);                                     
		         	} else {
		                 //  out.println( ret_msg+"<br><b>생성</b>[appParam:]"+appParam.toString());  
		         	    ret_msg = esbAp.callESB(appParam);       
		         	}
		         	
	                String esb_ret_code = ret_msg.substring(0,4); 
	                //   out.println("<br>[ret_msg:"+ret_msg);             
	                if (!esb_ret_code.equals("0000"))  {                                                  
	                	retunMsg.CODE = esb_ret_code ;
	                	retunMsg.VALUE = ret_msg + "\\n" + "통합결재 연동 실패" ;
	                }
		             
	                //성공일
	                retunMsg.CODE = "0" ;
                	retunMsg.VALUE = "";
                	
		         }catch (ESBValidationException eV){
		         	retunMsg.CODE ="400" ;
		        	retunMsg.VALUE = eV.getMessage() + "\\n" + "ESBValidationException 통합결재 연동 실패" ;
		        	return retunMsg;
		        	
		         }catch (ESBTransferException eT){
		         	retunMsg.CODE ="400" ;
		        	retunMsg.VALUE = eT.getMessage() + "\\n" + "ESBTransferException 통합결재 연동 실패" ;
		        	return retunMsg;
		         }catch (Exception e) {
		         	Logger.error(e);
		         	retunMsg.CODE ="400" ;
		        	retunMsg.VALUE = e.getMessage() + "\\n" + "Exception 통합결재 연동 실패" ;
		        	return retunMsg;
		         }
		
		    } // end for 
        
	    }catch (Exception e) {
	     	Logger.error(e);
	     	retunMsg.CODE ="400" ;
        	retunMsg.VALUE = e.getMessage() + "\\n" + "통합결재 연동 실패" ;
        	return retunMsg;
	    } //try 1
	    return retunMsg;
    }
    public void autoLogin(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        //Connection conn = null;
        boolean isCommit = false;
       
        try{
        	Logger.debug.println("MobileCommonSV] autoLogin  start++++++++++++++++++++++++++++++++++++++" );
            HttpSession session = req.getSession(true);
            String msg = ""; //[CSR ID:] ehr시스템웹취약성진단 수정
            
            WebUserData user = new WebUserData();
            Box box = WebUtil.getBox(req);
            Logger.debug.println("##########box####################>"+box);
            String empNo = box.getString("empNo");
            Logger.debug.println("#  decrypt" );
            empNo = EncryptionTool.decrypt(empNo);

            Logger.debug.println("# # empNo.length():"+ empNo.length());
            //String dest = "";
            String dest = WebUtil.JspURL+"common/mobileResult.jsp";
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
            
            user.empNo = DataUtil.fixEndZero( empNo ,8);
            Logger.debug.println("#############################empNo:"+empNo);
            
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
                        user.empNo            = DataUtil.fixEndZero(empNo,8);
                        //user.SServer          = SServer;

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
            
          
        }catch(Exception ConfigurationException){
            throw new GeneralException(ConfigurationException);
        } finally {
            //DBUtil.close(conn ,isCommit);
        } // end try
    }
 
}

