package	hris.D.D06Ypay.rfc;

import java.util.Vector;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;

import hris.D.D06Ypay.D06FpayDetailData;

/**
 * D06YpayDetailRFC.java
 * 개인의 국내급여 내역 정보를 가져오는 RFC를 호출하는 Class
 *
 * @author 최영호
 * @version 1.0, 2002/02/01
 */
public class D06FpayDetailRFC extends SAPWrap {

//    private String functionName = "ZHRP_GET_PAY_INFO";
    private String functionName = "ZGHR_GET_PAY_INFO";

    /**
     * 개인의 국내급여 내역 정보를 가져오는 RFC를 호출하는 Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
 
    public Object getFpayDetail(String empNo, String year, String ocrsn, String flag) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, empNo, year, ocrsn, flag);
            excute(mConnection, function);
            Object ret = getStructor(  ( new D06FpayDetailData() ), function, "S_PERSON_INFO"); // 급여명세표 - 개인정보/환율 내역
/*                
               D06FpayDetailData data = (D06FpayDetailData)ret;
               
                if(data.BET01.equals("")){ data.BET01=""; }else{data.BET01 = Double.toString( Double.parseDouble(data.BET01) * 100.0 );}
                if(data.BET02.equals("")){ data.BET02=""; }else{data.BET02 = Double.toString( Double.parseDouble(data.BET02) * 100.0 );}
                if(data.BET03.equals("")){ data.BET03=""; }else{data.BET03 = Double.toString( Double.parseDouble(data.BET03) * 100.0 );}
                if(data.BET04.equals("")){ data.BET04=""; }else{data.BET04 = Double.toString( Double.parseDouble(data.BET04) * 100.0 );}
                if(data.BET05.equals("")){ data.BET05=""; }else{data.BET05 = Double.toString( Double.parseDouble(data.BET05) * 100.0 );}
                if(data.BET06.equals("")){ data.BET06=""; }else{data.BET06 = Double.toString( Double.parseDouble(data.BET06) * 100.0 );}
                if(data.BET07.equals("")){ data.BET07=""; }else{data.BET07 = Double.toString( Double.parseDouble(data.BET07) * 100.0 );}
                if(data.BET08.equals("")){ data.BET08=""; }else{data.BET08 = Double.toString( Double.parseDouble(data.BET08) * 100.0 );}
                if(data.BET09.equals("")){ data.BET09=""; }else{data.BET09 = Double.toString( Double.parseDouble(data.BET09) * 100.0 );}
                if(data.BET10.equals("")){ data.BET10=""; }else{data.BET10 = Double.toString( Double.parseDouble(data.BET10) * 100.0 );}
                if(data.BET11.equals("")){ data.BET11=""; }else{data.BET11 = Double.toString( Double.parseDouble(data.BET11) * 100.0 );}
                if(data.BET12.equals("")){ data.BET12=""; }else{data.BET12 = Double.toString( Double.parseDouble(data.BET12) * 100.0 );}
                if(data.BET13.equals("")){ data.BET13=""; }else{data.BET13 = Double.toString( Double.parseDouble(data.BET13) * 100.0 );}
                if(data.BET14.equals("")){ data.BET14=""; }else{data.BET14 = Double.toString( Double.parseDouble(data.BET14) * 100.0 );}
*/            
            
            return ret;
            
        }catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }  

     public Vector getMpayDetail( String empNo, String year, String ocrsn, String flag) throws GeneralException {
    
        JCO.Client mConnection = null;
        
      try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            
            setInput(function, empNo, year, ocrsn, flag);
            excute(mConnection, function);
            
            Vector ret = null;
                        
             ret = getTable(hris.D.D06Ypay.D06FpayDetailData1.class, function,  "T_PAYLST");

            return ret;
            
        } catch(Exception ex){
            Logger.sap.println(this, " SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }
        
    /**
     * RFC 실행전에 Import 값을 setting 한다.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출되기 전에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @param value java.lang.String 사번
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String value, String value1, String value2, String value3) throws GeneralException {

        setField(function, "I_PERNR", value);
        setField(function, "I_DATE", value1);
        setField(function, "I_ZOCRSN", value2);
        setField(function, "I_FLAG", value3);
        
    }
  
   
}