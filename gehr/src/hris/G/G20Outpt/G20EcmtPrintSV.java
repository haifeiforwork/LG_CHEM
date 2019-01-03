package hris.G.G20Outpt;

import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.WebUtil;
import hris.G.G20Outpt.rfc.G20EcmtPrintRFC;
import hris.common.WebUserData;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.Vector;

/**
 * G20EcmtPrintSV.java
 * 근로소득 원천징수 영수증 출력을 할수 있도록 하는 Class
 *
 */
public class G20EcmtPrintSV extends EHRBaseServlet {

    // private String UPMU_TYPE ="28";

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        try{
            
            HttpSession session = req.getSession(false);
            WebUserData user = WebUtil.getSessionUser(req);

            String dest       = "";	// 리턴 URL
            String jobid      = "";	// 작업구분
			
			String i_gubun	  	= ""; 
            String i_pernr	  	= "";	
			String i_ainf_seqn	= "";
			String i_print		= "";
			String i_print_num	= "";			

            G20EcmtPrintKey key = new G20EcmtPrintKey();
            Vector G10CertiPrintData_vt  = new Vector(); 
            
            Box box = WebUtil.getBox(req);
            jobid      	= box.get("jobid");  
            i_gubun    	= box.get("i_gubun");
            i_pernr    	= box.get("i_pernr");
            i_ainf_seqn = box.get("i_ainf_seqn");
            i_print  	= box.get("i_print");
            i_print_num	= box.get("i_print_num");
			
            if(jobid.equals("")) {
                jobid = "print";
            }
            
            if( jobid.equals("print") ) {
            	
            	Thread.sleep(3000);
            	
				key.I_GUBUN   = "1";
                key.I_PERNR   = user.empNo;
				key.I_AINF_SEQN = i_ainf_seqn;
				key.I_PRINT		= i_print;
				
                G20EcmtPrintRFC func = new G20EcmtPrintRFC();
                Vector G20EcmtPrintData_Header_vt 	= func.getEcmtPrint( key ,"HEADER" );
                Vector G20EcmtPrintData_Income_vt 	= func.getEcmtPrint( key ,"INCOME" );
                Vector G20EcmtPrintData_Item_vt 	= func.getEcmtPrint( key ,"ITEM" );
                Vector G20EcmtPrintData_Family_vt 	= func.getEcmtPrint( key ,"FAMILY" );
                Vector G20EcmtPrintData_NTX_vt 		= func.getEcmtPrint( key ,"NTX" );                
                
                Logger.debug.println( this, "=======================================================" );
                Logger.debug.println( this, "key.toString()-->"+key.toString() );
                Logger.debug.println( this, "G20EcmtPrintData_Header_vt.toString()-->"+G20EcmtPrintData_Header_vt.toString() );    
                Logger.debug.println( this, "G20EcmtPrintData_Income_vt.toString()-->"+G20EcmtPrintData_Income_vt.toString() );  
                Logger.debug.println( this, "G20EcmtPrintData_Item_vt.toString()-->"+G20EcmtPrintData_Item_vt.toString() );  
                Logger.debug.println( this, "G20EcmtPrintData_Family_vt.toString()-->"+G20EcmtPrintData_Family_vt.toString() );
                Logger.debug.println( this, "G20EcmtPrintData_NTX_vt.toString()-->"+G20EcmtPrintData_NTX_vt.toString() );                   
                Logger.debug.println( this, "=======================================================" );
                
                String ThisJspName = box.get("ThisJspName");
                req.setAttribute("ThisJspName", ThisJspName);
                req.setAttribute("i_ainf_seqn", i_ainf_seqn);
                req.setAttribute("i_print", i_print);                
                req.setAttribute("i_print_num", i_print_num);
                req.setAttribute("G20EcmtPrintData_Header_vt", G20EcmtPrintData_Header_vt);
                req.setAttribute("G20EcmtPrintData_Income_vt", G20EcmtPrintData_Income_vt);   
                req.setAttribute("G20EcmtPrintData_Item_vt", G20EcmtPrintData_Item_vt);
                req.setAttribute("G20EcmtPrintData_Family_vt", G20EcmtPrintData_Family_vt);
                req.setAttribute("G20EcmtPrintData_NTX_vt", G20EcmtPrintData_NTX_vt);
                
                dest = WebUtil.JspURL+"G/G20Outpt/G20EcmtPrintForm.jsp";

            } else {
                throw new BusinessException("내부명령(jobid)이 올바르지 않습니다.");
            }
            Logger.debug.println(this, "destributed = " + dest);
            printJspPage(req, res, dest);

        } catch(Exception e) {
            throw new GeneralException(e);
        } finally {
        }
    }
}
