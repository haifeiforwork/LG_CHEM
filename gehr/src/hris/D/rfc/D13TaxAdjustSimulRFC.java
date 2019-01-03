package hris.D.rfc ;

import java.util.* ;

import com.sap.mw.jco.* ;
import com.sns.jdf.* ;
import com.sns.jdf.sap.* ;
import com.sns.jdf.util.* ;

import hris.D.* ;

/**
 *  D13TaxAdjustSimulRFC.java
 *  연말정산 Simulation을 위한 기초자료를 가져오는 RFC를 호출하는 Class
 *
 * @author 김성일
 * @version 1.0, 2002/01/28
 */
public class D13TaxAdjustSimulRFC extends SAPWrap {

    private String functionName = "ZSOLYR_RFC_SIM_YEA" ;

    /**
     * 연말정산 Simulation을 위한 기초자료를 가져오는 RFC 호출하는 Method
     * @return java.util.Vector
     * @param empNo java.lang.String 사원번호
     * @param beginDate java.lang.String 시작일
     * @param endDate java.lang.String 종료일
     * @exception com.sns.jdf.GeneralException
     */
    public Object detail( String empNo, String beginDate, String endDate ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, empNo, beginDate, endDate);
            excute(mConnection, function);
            D13TaxAdjustSimulData data = (D13TaxAdjustSimulData)getOutput( function, new D13TaxAdjustSimulData() );
            /*
            D13TaxAdjustSimulData retData = new D13TaxAdjustSimulData();

            if(!data.O_GROSS    .equals("")){retData.O_GROSS     =Double.toString(Double.parseDouble(data.O_GROSS    ) * 100.0 ) ; } // 총액              
            if(!data.O_TOTINCOM .equals("")){retData.O_TOTINCOM  =Double.toString(Double.parseDouble(data.O_TOTINCOM ) * 100.0 ) ; } // 총지급임금        
            if(!data.O_TAXGROSS .equals("")){retData.O_TAXGROSS  =Double.toString(Double.parseDouble(data.O_TAXGROSS ) * 100.0 ) ; } // 총과세소득        
            if(!data.O_NTAXGROSS.equals("")){retData.O_NTAXGROSS =Double.toString(Double.parseDouble(data.O_NTAXGROSS) * 100.0 ) ; } // 총비과세소득      
            if(!data.O_INCOMTAX .equals("")){retData.O_INCOMTAX  =Double.toString(Double.parseDouble(data.O_INCOMTAX ) * 100.0 ) ; } // 총근로소득세      
            if(!data.O_RESTAX   .equals("")){retData.O_RESTAX    =Double.toString(Double.parseDouble(data.O_RESTAX   ) * 100.0 ) ; } // 총주민세          
            if(!data.O_SPTAX    .equals("")){retData.O_SPTAX     =Double.toString(Double.parseDouble(data.O_SPTAX    ) * 100.0 ) ; } // 총특별세          
            */
            return data;
        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    /**
     * RFC 실행전에 Import 값을 setting 한다.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출되기 전에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @param empNo java.lang.String 사번
     * @param beginDate java.lang.String 시작일
     * @param endDate java.lang.String 종료일
     * @param job java.lang.String 기능정보
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String empNo, String beginDate, String endDate ) throws GeneralException {
        String fieldName1 = "PERNR";
        setField( function, fieldName1, empNo );
        String fieldName2 = "TAX_BEGDA";
        setField( function, fieldName2, beginDate );
        String fieldName3 = "TAX_ENDDA";
        setField( function, fieldName3, endDate );
    }

// Export Return type이 Object 인 경우 2
// ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
    /**
     * RFC 실행후 Export 값을 Object 로 Return 한다.
     * 반드시 com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출된후에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @param data java.lang.Object
     * @return java.lang.Object
     * @exception com.sns.jdf.GeneralException
     */
    private Object getOutput(JCO.Function function, Object data) throws GeneralException {
        return getFields(data, function);
    }
}