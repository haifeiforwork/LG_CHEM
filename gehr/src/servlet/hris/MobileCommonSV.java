/********************************************************************************/
/*                                                                              */
/*   System Name  : ��                                                                                                                     */
/*   1Depth Name  :                                                             */
/*   2Depth Name  : ����Ͽ�                                                                                                           */
/*   Program Name : �����  autoLogin, ���հ��翬��                                                                  */
/*   Program ID   : MobileApprovalSV                                            */
/*   Description  :                                                             */
/*   Note         :                                                             */
/*   Creation     : 2011-05-17  JMK                                             */
/*   Update       :                                                             */
/*                :  2015-08-20 ������ [CSR ID:] ehr�ý�������༺���� ����                       */
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
	
    
    //���հ��� ����
    /**
     * ���հ��� ����
     * @return
     */
    public MobileReturnData ElofficInterface(Vector vcElofficInterfaceData, WebUserData user) {
    	Logger.debug.println(this ,"ElofficInterface  =++++++++++++++++++++>start");
    	//���ϰ� setting 
    	MobileReturnData retunMsg = new MobileReturnData();
    	retunMsg.CODE = "";
    	retunMsg.VALUE = "";
    	Logger.debug.println(this ,"vcElofficInterfaceData=++++++++++++++++++++>"+vcElofficInterfaceData.toString());
    	try {  //try 1
    	
		    Vector vcEof = vcElofficInterfaceData;
		    com.sns.jdf.Config conf = new com.sns.jdf.Configuration();
		    boolean isDev = conf.getBoolean("com.sns.jdf.eloffice.ISDEVELOP");
		    
		    //String mobileUrl = "http://"+conf.getString("com.sns.jdf.eloffice.ResponseURL")+WebUtil.ServletURL+"hris.MobileDetailSV?"; //������ȣ�� ����� Mobile���� �����ش�
		    
		    //MobileDetailSV
		    //Logger.debug.println(this ,"mobileUrl=++++++++++++++++++++>"+mobileUrl);
		    Logger.debug.println(this ,"vcEof.size()=++++++++++++++++++++>"+vcEof.size());
	        for (int i = 0; i < vcEof.size(); i++) { 
		     ElofficInterfaceData  eof = (ElofficInterfaceData)vcEof.get(i);
		    
		        try { 
		         	 
		         	ESBAdapter esbAp = new LGChemESBService("APPINT_ESB" ,conf.getString("com.sns.jdf.eloffice.ESBInfo") );   
		        	Hashtable appParam = new Hashtable();      
	                //if ( eof.SUBJECT.equals("�Ƿ��")||eof.SUBJECT.equals("�ξ簡��")||eof.SUBJECT.equals("�ξ� ���� ����")||eof.SUBJECT.equals("���б�/���ڱ�")||eof.SUBJECT.equals("���б�/���ڱ� ��û"))  {
	
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
	                appParam.put("CATEGORY"     ,eof.CATEGORY     );    //��ĸ�                
	                appParam.put("MAIN_STATUS"  ,eof.MAIN_STATUS  );    //���� Main����         
	                appParam.put("P_MAIN_STATUS",eof.P_MAIN_STATUS);                            
	                appParam.put("SUB_STATUS"   ,eof.SUB_STATUS   );    //���� Sub����          
	                appParam.put("REQ_DATE"     ,eof.REQ_DATE     );    //��û��              
	                appParam.put("EXPIRE_DATE"  ,eof.EXPIRE_DATE  );    //��������              
	                appParam.put("AUTH_DIV"     ,eof.AUTH_DIV     );    //�����Һμ�            
	                appParam.put("AUTH_EMP"     ,eof.AUTH_EMP     );    //�����Ұ���            
	                appParam.put("MODIFY"       ,eof.MODIFY       );    //��������              
	                appParam.put("F_AGREE"      ,eof.F_AGREE      );    //�ڵ�����              
	                appParam.put("R_EMP_NO"     ,eof.R_EMP_NO     );    //����ڻ��            
	                appParam.put("A_EMP_NO"     ,eof.A_EMP_NO     );    //�����ڻ��            
	                appParam.put("SUBJECT"      ,eof.SUBJECT      );    //�������              
	                appParam.put("APP_ID"       ,eof.APP_ID       );    //���繮��ID            
	                appParam.put("URL"	        ,eof.URL          );                            
	                appParam.put("DUMMY1"	    ,eof.DUMMY1       );     //�����URL    
	                String ret_msg = "";
		
		         	if (eof.MODIFY.equals("D"))  {  
		                 // out.println( ret_msg+"<br><b>����</b>[appParam:]"+appParam.toString());    
		         	    ret_msg = esbAp.modifyESB(appParam);                                     
		         	} else {
		                 //  out.println( ret_msg+"<br><b>����</b>[appParam:]"+appParam.toString());  
		         	    ret_msg = esbAp.callESB(appParam);       
		         	}
		         	
	                String esb_ret_code = ret_msg.substring(0,4); 
	                //   out.println("<br>[ret_msg:"+ret_msg);             
	                if (!esb_ret_code.equals("0000"))  {                                                  
	                	retunMsg.CODE = esb_ret_code ;
	                	retunMsg.VALUE = ret_msg + "\\n" + "���հ��� ���� ����" ;
	                }
		             
	                //������
	                retunMsg.CODE = "0" ;
                	retunMsg.VALUE = "";
                	
		         }catch (ESBValidationException eV){
		         	retunMsg.CODE ="400" ;
		        	retunMsg.VALUE = eV.getMessage() + "\\n" + "ESBValidationException ���հ��� ���� ����" ;
		        	return retunMsg;
		        	
		         }catch (ESBTransferException eT){
		         	retunMsg.CODE ="400" ;
		        	retunMsg.VALUE = eT.getMessage() + "\\n" + "ESBTransferException ���հ��� ���� ����" ;
		        	return retunMsg;
		         }catch (Exception e) {
		         	Logger.error(e);
		         	retunMsg.CODE ="400" ;
		        	retunMsg.VALUE = e.getMessage() + "\\n" + "Exception ���հ��� ���� ����" ;
		        	return retunMsg;
		         }
		
		    } // end for 
        
	    }catch (Exception e) {
	     	Logger.error(e);
	     	retunMsg.CODE ="400" ;
        	retunMsg.VALUE = e.getMessage() + "\\n" + "���հ��� ���� ����" ;
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
            String msg = ""; //[CSR ID:] ehr�ý�������༺���� ����
            
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

                Logger.debug.println("# ####�����ȣ�� Ȯ���Ͽ� �ֽʽÿ�.###empNo:"+empNo);
                //String msg = "�����ȣ�� Ȯ���Ͽ� �ֽʽÿ�.";
                msg = "���� �� ������ �߻��Ͽ����ϴ�."; //[CSR ID:] ehr�ý�������༺���� ����
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
                        user.empNo            = DataUtil.fixEndZero(empNo,8);
                        //user.SServer          = SServer;

                        //@v1.0 �޴����� db�� oracle���� sap�� �̰�
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
                    //String msg = "���� �� ������ �߻��Ͽ����ϴ�.";
                    msg = "���� �� ������ �߻��Ͽ����ϴ�."; //[CSR ID:] ehr�ý�������༺���� ����
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

