/*
 * �ۼ��� ��¥: 2012. 04. 13.
 * : ESB �� �߼�
 */
package hris.common;

import com.lgchem.esb.adapter.ESBAdapter;
import com.lgchem.esb.adapter.LGChemESBService;
import com.lgchem.esb.exception.ESBTransferException;
import com.lgchem.esb.exception.ESBValidationException;
import com.sns.jdf.*;
import com.sns.jdf.util.WebUtil;
import hris.common.rfc.EmpListRFC;

import java.util.Hashtable;
import java.util.Vector;

/**
 * @author lsa
 *
 */
   public class SendToESB
   {  
    
	   public String process(Vector vcEof) throws ConfigurationException ,GeneralException
	    {
	        Config conf  = new Configuration();

	           String message = "";  
	           for (int i = 0; i < vcEof.size(); i++) {  
	           ElofficInterfaceData  eof = (ElofficInterfaceData)vcEof.get(i);

	            try {   
	 	           	 
	             	ESBAdapter esbAp = new LGChemESBService("APPINT_ESB" ,conf.getString("com.sns.jdf.eloffice.ESBInfo") );   
	             	Hashtable appParam = new Hashtable();      
	                    //if ( eof.SUBJECT.equals("�Ƿ��")||eof.SUBJECT.equals("�ξ簡��")||eof.SUBJECT.equals("�ξ� ���� ����")||eof.SUBJECT.equals("���б�/���ڱ�")||eof.SUBJECT.equals("���б�/���ڱ� ��û"))  {

	             		Logger.debug.println(this ,"SendToESB^^^^^ ElOfficeInterface</b>[eof:]"+eof.toString());	 
	                   // }
	                    
	                    if(eof.APP_ID.length() > 0)
	                    {
	                        if(eof.APP_ID.indexOf("?eHR=") > 0)
	                        	eof.APP_ID = eof.APP_ID.substring(0,10)  ;  
	                    }
	                    if(eof.URL.length() > 0)
	                    {
	                        if(eof.URL.indexOf("?eHR=") > 0)
	                        eof.URL= WebUtil.replace(eof.URL,"?eHR=","");
	                    }		
	                    appParam.put("CATEGORY"     ,eof.CATEGORY     );    //��ĸ�                
	                    appParam.put("MAIN_STATUS"  ,eof.MAIN_STATUS  );    //���� Main����         
	                    appParam.put("P_MAIN_STATUS",eof.P_MAIN_STATUS);                            
	                    appParam.put("SUB_STATUS"   ,eof.SUB_STATUS   );    //���� Sub����          
	                    appParam.put("REQ_DATE"     ,eof.REQ_DATE     );      //��û��              
	                    appParam.put("EXPIRE_DATE"  ,eof.EXPIRE_DATE  );    //��������              
	                    appParam.put("AUTH_DIV"     ,eof.AUTH_DIV     );    //�����Һμ�            
	                    appParam.put("AUTH_EMP"     ,eof.AUTH_EMP     );    //�����Ұ���            
	                    appParam.put("MODIFY"       ,eof.MODIFY       );    //��������              
	                    appParam.put("F_AGREE"      ,eof.F_AGREE      );    //�ڵ�����

						EmpListRFC empListRFC = new EmpListRFC();
						appParam.put("R_EMP_NO"     ,empListRFC.getElofficePERNR(eof.R_EMP_NO)     );    //����ڻ��
						appParam.put("A_EMP_NO"     ,empListRFC.getElofficePERNR(eof.A_EMP_NO)     );    //�����ڻ��

	                   /* appParam.put("R_EMP_NO"     ,eof.R_EMP_NO     );    //����ڻ��
	                    appParam.put("A_EMP_NO"     ,eof.A_EMP_NO     );    //�����ڻ��            */
	                    appParam.put("SUBJECT"      ,eof.SUBJECT      );    //�������              
	                    appParam.put("APP_ID"       ,eof.APP_ID       );    //���繮��ID            
	                    appParam.put("URL"	    ,eof.URL          );                           
	                    appParam.put("DUMMY1"	    ,eof.DUMMY1       );    //�ظ���ϰ����߰� C20110620_07375
	                    String ret_msg = "";

	                    if (!eof.SUBJECT.equals("������û"))  {
	             	
	                    	if (eof.MODIFY.equals("D"))  {  
	                     // out.println( ret_msg+"<br><b>����</b>[appParam:]"+appParam.toString());    
	                    		ret_msg = esbAp.modifyESB(appParam);
	                    	} else {
	                     //  out.println( ret_msg+"<br><b>����</b>[appParam:]"+appParam.toString());
	                    //Logger.info.println(this ,"^^^^^ ElOfficeInterface</b>[callESB:] before");	  
	                    		ret_msg = esbAp.callESB(appParam);   
	             	 //    Logger.info.println(this ,"^^^^^ ElOfficeInterface</b>[callESB:] after");	     
	                    	}
	                    	Logger.debug(ret_msg);
	                    	String esb_ret_code = ret_msg.substring(0,4); 
	                    //   out.println("<br>[ret_msg:"+ret_msg);             
	                    	if (!esb_ret_code.equals("0000"))  {                                                  
	                    		message += ret_msg + "\\n" + "���հ��� ���� ����" ;
	                        // out.println(ret_msg+"[appParam:]"+appParam.toString());             
	                    	}
	                    } 
	             }catch (ESBValidationException eV){
	         //  out.println(  "[ESBValidationException:]"+eV.toString());    
	             }catch (ESBTransferException eT){
	          // out.println(  "[ESBTransferException:]"+eT.toString());    
	             }catch (Exception e) {
	          // out.println(  "[Exception:]"+i);    
	             }

	        } // end for 
	 
	        return message;
	    }
	      
}
