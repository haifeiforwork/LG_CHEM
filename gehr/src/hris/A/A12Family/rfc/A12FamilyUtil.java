package hris.A.A12Family.rfc;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;
import hris.A.*;

import java.util.HashMap;
import java.util.Map;
import java.util.Vector;

public class A12FamilyUtil extends SAPWrap {
	private String functionName = "ZGHR_RFC_FAMILYHK_F4";
	
	public Map<String, Vector> getElements(String empNo)throws GeneralException{
        JCO.Client mConnection = null;
        
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setField(function, "I_PERNR", empNo);

            excute(mConnection, function);

            Map<String, Vector> resultMap = new HashMap<String, Vector>();
            resultMap.put("T_ITAB", getTable(A12FamilyData.class, function, "T_ITAB"));
            resultMap.put("T_ITAB1", getTable(A12FamilyData1.class, function, "T_ITAB1"));
            resultMap.put("T_ITAB3", getTable(A12FamilyData3.class, function, "T_ITAB3"));
            resultMap.put("T_ITAB4", getTable(A12FamilyData4.class, function, "T_ITAB4"));
            resultMap.put("T_ITAB5", getTable(A12FamilyData5.class, function, "T_ITAB5"));

            return resultMap;

        } catch(Exception ex){
            Logger.error(ex);
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
        
      }
}
