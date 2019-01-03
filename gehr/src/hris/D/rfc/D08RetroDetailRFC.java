package hris.D.rfc;

import java.util.Vector;

import com.common.constant.Area;
import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;

import hris.D.D08RetroDetailData;

/**
 * D08RetroDetailRFC.java
 * 소급결과내역조회하는 RFC를 호출하는 Class
 *
 * @author 최영호   
 * @version 1.0, 2002/01/23
 */
public class D08RetroDetailRFC extends SAPWrap {

    private String functionName = "ZGHR_RFC_SOGUP_LIST";
       
    /**
     * 소급결과내역조회하는 RFC를 호출하는 Method
     * @param java.lang.String 사번
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getRetroDetail( String empNo, String year, String ocrsn1, Area area) throws GeneralException {
        
        JCO.Client mConnection = null;
        
        try{
        	
        	if(area==Area.TW )         		functionName = functionName+"_TP";        	
        	else if(area==Area.HK)   		functionName = functionName+"_HK";
        	
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            
            setField(function,  "I_PERNR", empNo);
            setField(function,  "I_DATE", year);
            setField(function,  "I_OCRSN", ocrsn1.substring(0,2));
            excute(mConnection, function);
            
            Vector ret =  getTable(hris.D.D08RetroDetailData.class, function,  "T_TAB");
            
            for ( int i = 0 ; i < ret.size() ; i++ ) {
            	
                D08RetroDetailData data = (D08RetroDetailData)ret.get(i);
																												                /*
																												                data.SOGUP_BEFORE = Double.toString( Double.parseDouble(data.SOGUP_BEFORE) * 100.0 ) ;
																												                data.SOGUP_AFTER = Double.toString( Double.parseDouble(data.SOGUP_AFTER) * 100.0 ) ;
																												                data.SOGUP_AMNT = Double.toString( Double.parseDouble(data.SOGUP_AMNT) * 100.0 ) ;
																												             	*/
                data.SOGUP_BEFORE = DataUtil.changeLocalAmount(data.SOGUP_BEFORE, area);
                data.SOGUP_AFTER = DataUtil.changeLocalAmount(data.SOGUP_AFTER, area) ;
                data.SOGUP_AMNT = DataUtil.changeLocalAmount(data.SOGUP_AMNT, area) ;
                
              if(data.FPPER.equals("000000")){
                data.FPPER = (WebUtil.printDate(data.PAYDT,"")).substring(0,6);
               }
              
            }
            
            return ret;
            
        } catch(Exception ex) {
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
            
        } finally {
            close(mConnection);
        }
    }

}

