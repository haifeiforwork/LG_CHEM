package hris.G.G20Outpt.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;
import com.sap.mw.jco.*;

import hris.G.G20Outpt.G20EcmtPrintHeaderData;
import hris.G.G20Outpt.G20EcmtPrintIncomeData;
import hris.G.G20Outpt.G20EcmtPrintItemData;
import hris.G.G20Outpt.G20EcmtPrintFamilyData;
import hris.G.G20Outpt.*;


/**
 * G20EcmtPrintRFC.java
 * �ٷμҵ� ��õ¡�� ������ ���� RFC �� ȣ���ϴ� Class                       
 *
 * @author  
 * @version 
 */
public class G20EcmtPrintRFC extends SAPWrap {

    private String functionName = "ZHRP_RFC_READ_YEA_RESULT_PRIN";

    /**
     * ���ټ� ���� RFC ȣ���ϴ� Method
     * @return java.util.Vector
     */
    public Vector getEcmtPrint( Object key ,String gubun) throws GeneralException {
        
        JCO.Client mConnection = null;
        
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            
            Logger.debug.println("============================================");            
            Logger.debug.println(key.toString());
            Logger.debug.println("============================================");            

            G20EcmtPrintKey key1 = new G20EcmtPrintKey(); 
            setFields(function ,key);
                 
           excute(mConnection, function);
            
           Logger.debug.println("==excute==============================");            
           Vector ret = new Vector();

            if("HEADER".equals(gubun)) { 
            	ret = getOutput_Header(function);
            	
            }else if("INCOME".equals(gubun)) { 
            	ret = getOutput_Income(function);
            	
            }else if("ITEM".equals(gubun)) { 
            	ret = getOutput_Item(function);
            	
            }else if("FAMILY".equals(gubun)) { 
            	ret = getOutput_Family(function);
            	
            }else if("NTX".equals(gubun)) { 
            	ret = getOutput_NTX(function);
            	
            }else if("NTX_INCOME_PRV".equals(gubun)) { 
            	ret = getOutput_NTX_PRV(function);
            	
            }
            
            Logger.debug.println("============================================");            
            Logger.debug.println(ret.size() );
            Logger.debug.println(ret.toString() );            
            Logger.debug.println("============================================");   
            
        /*
            for ( int i = 0 ; i < ret.size() ; i++ ){
            	F10IndvdlListData data = (F10IndvdlListData)ret.get(i);
                data.BEGDA = com.sns.jdf.util.DataUtil.removeStructur(data.BEGDA, "-");
            }
	    */
            return ret;
        } catch(Exception ex) {
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    /**
     * RFC �������� Import ���� setting �Ѵ�.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ��Ǳ� ���� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @param entity java.lang.Object
     * @exception com.sns.jdf.GeneralException
     */
 
    private void setInput(JCO.Function function, Object key) throws GeneralException{
    	 setFields(function, key);       
    }

    /**
     * RFC ������ Export ���� Vector �� Return �Ѵ�.
     * �ݵ�� com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ����Ŀ� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutput_Header(JCO.Function function) throws GeneralException {
        String entityName = "hris.G.G20Outpt.G20EcmtPrintHeaderData";
        String tableName = "T_HEADER";
        return getTable(entityName, function, tableName);
    }
    
    private Vector getOutput_Income(JCO.Function function) throws GeneralException {
        String entityName = "hris.G.G20Outpt.G20EcmtPrintIncomeData";
        String tableName = "T_INCOME";
        return getTable(entityName, function, tableName);
    }
    
    private Vector getOutput_Item(JCO.Function function) throws GeneralException {
        String entityName = "hris.G.G20Outpt.G20EcmtPrintItemData";
        String tableName = "T_ITEM";
        return getTable(entityName, function, tableName);
    }  
    
    private Vector getOutput_Family(JCO.Function function) throws GeneralException {
        String entityName = "hris.G.G20Outpt.G20EcmtPrintFamilyData";
        String tableName = "T_FAMILY";
        return getTable(entityName, function, tableName);
    }   
    
    private Vector getOutput_NTX(JCO.Function function) throws GeneralException {
        String entityName = "hris.G.G20Outpt.G20EcmtPrintNtxData";
        String tableName = "T_NTX_INCOME";
        return getTable(entityName, function, tableName);
    }    
    private Vector getOutput_NTX_PRV(JCO.Function function) throws GeneralException {
        String entityName = "hris.G.G20Outpt.G20EcmtPrintNtxPrvData";
        String tableName = "T_NTX_INCOME_PRV";
        return getTable(entityName, function, tableName);
    }    
}

