/*
 * 작성된 날짜: 2012. 04. 13.
 * : ESB 에 발송
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
	                    //if ( eof.SUBJECT.equals("의료비")||eof.SUBJECT.equals("부양가족")||eof.SUBJECT.equals("부양 가족 여부")||eof.SUBJECT.equals("장학금/학자금")||eof.SUBJECT.equals("장학금/학자금 신청"))  {

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
	                    appParam.put("CATEGORY"     ,eof.CATEGORY     );    //양식명                
	                    appParam.put("MAIN_STATUS"  ,eof.MAIN_STATUS  );    //결재 Main상태         
	                    appParam.put("P_MAIN_STATUS",eof.P_MAIN_STATUS);                            
	                    appParam.put("SUB_STATUS"   ,eof.SUB_STATUS   );    //결재 Sub상태          
	                    appParam.put("REQ_DATE"     ,eof.REQ_DATE     );      //요청일              
	                    appParam.put("EXPIRE_DATE"  ,eof.EXPIRE_DATE  );    //보존년한              
	                    appParam.put("AUTH_DIV"     ,eof.AUTH_DIV     );    //공개할부서            
	                    appParam.put("AUTH_EMP"     ,eof.AUTH_EMP     );    //공개할개인            
	                    appParam.put("MODIFY"       ,eof.MODIFY       );    //삭제구분              
	                    appParam.put("F_AGREE"      ,eof.F_AGREE      );    //자동합의

						EmpListRFC empListRFC = new EmpListRFC();
						appParam.put("R_EMP_NO"     ,empListRFC.getElofficePERNR(eof.R_EMP_NO)     );    //기안자사번
						appParam.put("A_EMP_NO"     ,empListRFC.getElofficePERNR(eof.A_EMP_NO)     );    //결재자사번

	                   /* appParam.put("R_EMP_NO"     ,eof.R_EMP_NO     );    //기안자사번
	                    appParam.put("A_EMP_NO"     ,eof.A_EMP_NO     );    //결재자사번            */
	                    appParam.put("SUBJECT"      ,eof.SUBJECT      );    //양식제목              
	                    appParam.put("APP_ID"       ,eof.APP_ID       );    //결재문서ID            
	                    appParam.put("URL"	    ,eof.URL          );                           
	                    appParam.put("DUMMY1"	    ,eof.DUMMY1       );    //※모바일결재추가 C20110620_07375
	                    String ret_msg = "";

	                    if (!eof.SUBJECT.equals("교육신청"))  {
	             	
	                    	if (eof.MODIFY.equals("D"))  {  
	                     // out.println( ret_msg+"<br><b>삭제</b>[appParam:]"+appParam.toString());    
	                    		ret_msg = esbAp.modifyESB(appParam);
	                    	} else {
	                     //  out.println( ret_msg+"<br><b>생성</b>[appParam:]"+appParam.toString());
	                    //Logger.info.println(this ,"^^^^^ ElOfficeInterface</b>[callESB:] before");	  
	                    		ret_msg = esbAp.callESB(appParam);   
	             	 //    Logger.info.println(this ,"^^^^^ ElOfficeInterface</b>[callESB:] after");	     
	                    	}
	                    	Logger.debug(ret_msg);
	                    	String esb_ret_code = ret_msg.substring(0,4); 
	                    //   out.println("<br>[ret_msg:"+ret_msg);             
	                    	if (!esb_ret_code.equals("0000"))  {                                                  
	                    		message += ret_msg + "\\n" + "통합결재 연동 실패" ;
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
