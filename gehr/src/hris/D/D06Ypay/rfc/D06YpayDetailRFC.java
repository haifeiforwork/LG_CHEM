package	hris.D.D06Ypay.rfc;

import java.util.Vector;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;

/**
 * D06YpayDetailRFC.java
 * 개인의 연급여 내역 정보를 가져오는 RFC를 호출하는 Class
 *
 * @author 최영호
 * @version 1.0, 2002/01/30
 *   Update       : 2013-06-24 [CSR ID:2353407] sap에 추가암검진 추가 건  
 */
public class D06YpayDetailRFC extends SAPWrap {

    private String functionName = "ZGHR_RFC_GET_TOTAL_SALARY";

    /**
     * 개인의 연급여 내역 정보를 가져오는 RFC를 호출하는 Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getYpayDetail( String empNo, String from_year, String to_year  ,String  webUserId) throws GeneralException {
    
        JCO.Client mConnection = null; 
        
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            
            setField(function, "I_PERNR", empNo);
            setField(function, "I_BEGYM", from_year);
            setField(function, "I_ENDYM", to_year);
            setField(function, "I_ID", webUserId);
            
            excute(mConnection, function);
            
            Vector ret = getTable(hris.D.D06Ypay.D06YpayDetailData.class, function, "T_TOTAL");
/*                
            for ( int i = 0 ; i < ret.size() ; i++ ) {
                D06YpayDetailData data = (D06YpayDetailData)ret.get(i);
                
                if(data.BET01.equals("")){ data.BET01=""; }else{data.BET01 = Double.toString( Double.parseDouble(data.BET01) * 100.0 );}
                if(data.BET02.equals("")){ data.BET02=""; }else{data.BET02 = Double.toString( Double.parseDouble(data.BET02) * 100.0 );}
                if(data.BET03.equals("")){ data.BET03=""; }else{data.BET03 = Double.toString( Double.parseDouble(data.BET03) * 100.0 );}
                if(data.BET04.equals("")){ data.BET04=""; }else{data.BET04 = Double.toString( Double.parseDouble(data.BET04) * 100.0 );}
                if(data.BET05.equals("")){ data.BET05=""; }else{data.BET05 = Double.toString( Double.parseDouble(data.BET05) * 100.0 );}
                if(data.BET06.equals("")){ data.BET06=""; }else{data.BET06 = Double.toString( Double.parseDouble(data.BET06) * 100.0 );}
                if(data.BET07.equals("")){ data.BET07=""; }else{data.BET07 = Double.toString( Double.parseDouble(data.BET07) * 100.0 );}
                if(data.BET08.equals("")){ data.BET08=""; }else{data.BET08 = Double.toString( Double.parseDouble(data.BET08) * 100.0 );}
                if(data.BET09.equals("")){ data.BET09=""; }else{data.BET09 = Double.toString( Double.parseDouble(data.BET09) * 100.0 );}
            }    
*/                        
              return ret;
            
        } catch(Exception ex){
            Logger.sap.println(this, " SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }
 
}