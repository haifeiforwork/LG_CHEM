package hris.D.D11TaxAdjust.rfc ;

import java.util.* ;

import com.sap.mw.jco.* ;
import com.sns.jdf.* ;
import com.sns.jdf.sap.* ;
import com.sns.jdf.util.* ;

import hris.D.D11TaxAdjust.* ;

/**
 * D11TaxAdjustPreWorkRFC.java
 * 연말정산 - 전근무지 신청/수정/조회 RFC를 호출하는 Class
 *
 * @author  김도신
 * @version 1.0, 2005/12/01
 */
public class D11TaxAdjustPreWorkRFC extends SAPWrap {

    private String functionName = "ZSOLYR_RFC_YEAR_PRE_WORK" ;

    /**
     * 연말정산 - 전근무지 조회 RFC 호출하는 Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getPreWork( String empNo, String targetYear ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, "1", empNo, targetYear );
            excute(mConnection, function);

            Vector ret = getOutput(function);

            for( int i = 0 ; i < ret.size() ; i++ ){
                D11TaxAdjustPreWorkData data = (D11TaxAdjustPreWorkData)ret.get(i);
                if(data.BET01.equals("")){ data.BET01=""; }else{ data.BET01=Double.toString(Double.parseDouble(data.BET01) * 100.0); }  // 금액
                if(data.BET02.equals("")){ data.BET02=""; }else{ data.BET02=Double.toString(Double.parseDouble(data.BET02) * 100.0); }  // 금액
                if(data.BET03.equals("")){ data.BET03=""; }else{ data.BET03=Double.toString(Double.parseDouble(data.BET03) * 100.0); }  // 금액
                if(data.BET04.equals("")){ data.BET04=""; }else{ data.BET04=Double.toString(Double.parseDouble(data.BET04) * 100.0); }  // 금액
                if(data.BET05.equals("")){ data.BET05=""; }else{ data.BET05=Double.toString(Double.parseDouble(data.BET05) * 100.0); }  // 금액
                if(data.BET06.equals("")){ data.BET06=""; }else{ data.BET06=Double.toString(Double.parseDouble(data.BET06) * 100.0); }  // 금액
                if(data.BET07.equals("")){ data.BET07=""; }else{ data.BET07=Double.toString(Double.parseDouble(data.BET07) * 100.0); }  // 금액
                if(data.BET08.equals("")){ data.BET08=""; }else{ data.BET08=Double.toString(Double.parseDouble(data.BET08) * 100.0); }  // 금액
                if(data.BET09.equals("")){ data.BET09=""; }else{ data.BET09=Double.toString(Double.parseDouble(data.BET09) * 100.0); }  // 금액
                if(data.BET10.equals("")){ data.BET10=""; }else{ data.BET10=Double.toString(Double.parseDouble(data.BET10) * 100.0); }  // 금액
                if(data.BET11.equals("")){ data.BET11=""; }else{ data.BET11=Double.toString(Double.parseDouble(data.BET11) * 100.0); }  // 금액
                if(data.BET12.equals("")){ data.BET12=""; }else{ data.BET12=Double.toString(Double.parseDouble(data.BET12) * 100.0); }  // 금액
                if(data.BET13.equals("")){ data.BET13=""; }else{ data.BET13=Double.toString(Double.parseDouble(data.BET13) * 100.0); }  // 금액
                if(data.BET14.equals("")){ data.BET14=""; }else{ data.BET14=Double.toString(Double.parseDouble(data.BET14) * 100.0); }  // 금액
                if(data.BET15.equals("")){ data.BET15=""; }else{ data.BET15=Double.toString(Double.parseDouble(data.BET15) * 100.0); }  // 금액
                if(data.BET16.equals("")){ data.BET16=""; }else{ data.BET16=Double.toString(Double.parseDouble(data.BET16) * 100.0); }  // 금액
                if(data.BET17.equals("")){ data.BET17=""; }else{ data.BET17=Double.toString(Double.parseDouble(data.BET17) * 100.0); }  // 금액
                if(data.BET18.equals("")){ data.BET18=""; }else{ data.BET18=Double.toString(Double.parseDouble(data.BET18) * 100.0); }  // 금액
                if(data.BET19.equals("")){ data.BET19=""; }else{ data.BET19=Double.toString(Double.parseDouble(data.BET19) * 100.0); }  // 금액
                if(data.BET20.equals("")){ data.BET20=""; }else{ data.BET20=Double.toString(Double.parseDouble(data.BET20) * 100.0); }  // 금액
                if(data.BET21.equals("")){ data.BET21=""; }else{ data.BET21=Double.toString(Double.parseDouble(data.BET21) * 100.0); }  // 금액
                if(data.BET22.equals("")){ data.BET22=""; }else{ data.BET22=Double.toString(Double.parseDouble(data.BET22) * 100.0); }  // 금액
                if(data.BET23.equals("")){ data.BET23=""; }else{ data.BET23=Double.toString(Double.parseDouble(data.BET23) * 100.0); }  // 금액
                if(data.BET24.equals("")){ data.BET24=""; }else{ data.BET24=Double.toString(Double.parseDouble(data.BET24) * 100.0); }  // 금액
                if(data.BET25.equals("")){ data.BET25=""; }else{ data.BET25=Double.toString(Double.parseDouble(data.BET25) * 100.0); }  // 금액
                if(data.BET26.equals("")){ data.BET26=""; }else{ data.BET26=Double.toString(Double.parseDouble(data.BET26) * 100.0); }  // 금액
                if(data.BET27.equals("")){ data.BET27=""; }else{ data.BET27=Double.toString(Double.parseDouble(data.BET27) * 100.0); }  // 금액
                if(data.BET28.equals("")){ data.BET28=""; }else{ data.BET28=Double.toString(Double.parseDouble(data.BET28) * 100.0); }  // 금액
                if(data.BET29.equals("")){ data.BET29=""; }else{ data.BET29=Double.toString(Double.parseDouble(data.BET29) * 100.0); }  // 금액
                if(data.BET30.equals("")){ data.BET30=""; }else{ data.BET30=Double.toString(Double.parseDouble(data.BET30) * 100.0); }  // 금액
                if(data.BET31.equals("")){ data.BET31=""; }else{ data.BET31=Double.toString(Double.parseDouble(data.BET31) * 100.0); }  // 금액
                if(data.BET32.equals("")){ data.BET32=""; }else{ data.BET32=Double.toString(Double.parseDouble(data.BET32) * 100.0); }  // 금액
                if(data.BET33.equals("")){ data.BET33=""; }else{ data.BET33=Double.toString(Double.parseDouble(data.BET33) * 100.0); }  // 금액
                if(data.BET34.equals("")){ data.BET34=""; }else{ data.BET34=Double.toString(Double.parseDouble(data.BET34) * 100.0); }  // 금액
                if(data.BET35.equals("")){ data.BET35=""; }else{ data.BET35=Double.toString(Double.parseDouble(data.BET35) * 100.0); }  // 금액
                if(data.BET36.equals("")){ data.BET36=""; }else{ data.BET36=Double.toString(Double.parseDouble(data.BET36) * 100.0); }  // 금액
                if(data.BET37.equals("")){ data.BET37=""; }else{ data.BET37=Double.toString(Double.parseDouble(data.BET37) * 100.0); }  // 금액
                if(data.BET38.equals("")){ data.BET38=""; }else{ data.BET38=Double.toString(Double.parseDouble(data.BET38) * 100.0); }  // 금액
                if(data.BET39.equals("")){ data.BET39=""; }else{ data.BET39=Double.toString(Double.parseDouble(data.BET39) * 100.0); }  // 금액
                if(data.BET40.equals("")){ data.BET40=""; }else{ data.BET40=Double.toString(Double.parseDouble(data.BET40) * 100.0); }  // 금액
                if(data.BET41.equals("")){ data.BET41=""; }else{ data.BET41=Double.toString(Double.parseDouble(data.BET41) * 100.0); }  // 금액
                if(data.BET42.equals("")){ data.BET42=""; }else{ data.BET42=Double.toString(Double.parseDouble(data.BET42) * 100.0); }  // 금액
                if(data.BET43.equals("")){ data.BET43=""; }else{ data.BET43=Double.toString(Double.parseDouble(data.BET43) * 100.0); }  // 금액
                if(data.BET44.equals("")){ data.BET44=""; }else{ data.BET44=Double.toString(Double.parseDouble(data.BET44) * 100.0); }  // 금액
                if(data.BET45.equals("")){ data.BET45=""; }else{ data.BET45=Double.toString(Double.parseDouble(data.BET45) * 100.0); }  // 금액
             }

            return ret;

        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }
    public Vector getPreWorkHeaderNm( String empNo, String targetYear ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, "1", empNo, targetYear );
            excute(mConnection, function);

            Vector ret = getOutput1(function);

            return ret;

        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }
    /**
     * 연말정산 - 전근무지 입력 RFC 호출하는 Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public void build( String empNo, String targetYear, Vector preWork_vt ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            for( int i = 0 ; i < preWork_vt.size() ; i++ ){
                D11TaxAdjustPreWorkData data = (D11TaxAdjustPreWorkData)preWork_vt.get(i);
                if(data.BET01.equals("")){ data.BET01=""; }else{ data.BET01=Double.toString(Double.parseDouble(data.BET01) / 100.0); }  // 금액
                if(data.BET02.equals("")){ data.BET02=""; }else{ data.BET02=Double.toString(Double.parseDouble(data.BET02) / 100.0); }  // 금액
                if(data.BET03.equals("")){ data.BET03=""; }else{ data.BET03=Double.toString(Double.parseDouble(data.BET03) / 100.0); }  // 금액
                if(data.BET04.equals("")){ data.BET04=""; }else{ data.BET04=Double.toString(Double.parseDouble(data.BET04) / 100.0); }  // 금액
                if(data.BET05.equals("")){ data.BET05=""; }else{ data.BET05=Double.toString(Double.parseDouble(data.BET05) / 100.0); }  // 금액
                if(data.BET06.equals("")){ data.BET06=""; }else{ data.BET06=Double.toString(Double.parseDouble(data.BET06) / 100.0); }  // 금액
                if(data.BET07.equals("")){ data.BET07=""; }else{ data.BET07=Double.toString(Double.parseDouble(data.BET07) / 100.0); }  // 금액
                if(data.BET08.equals("")){ data.BET08=""; }else{ data.BET08=Double.toString(Double.parseDouble(data.BET08) / 100.0); }  // 금액
                if(data.BET09.equals("")){ data.BET09=""; }else{ data.BET09=Double.toString(Double.parseDouble(data.BET09) / 100.0); }  // 금액
                if(data.BET10.equals("")){ data.BET10=""; }else{ data.BET10=Double.toString(Double.parseDouble(data.BET10) / 100.0); }  // 금액
                if(data.BET11.equals("")){ data.BET11=""; }else{ data.BET11=Double.toString(Double.parseDouble(data.BET11) / 100.0); }  // 금액
                if(data.BET12.equals("")){ data.BET12=""; }else{ data.BET12=Double.toString(Double.parseDouble(data.BET12) / 100.0); }  // 금액
                if(data.BET13.equals("")){ data.BET13=""; }else{ data.BET13=Double.toString(Double.parseDouble(data.BET13) / 100.0); }  // 금액
                if(data.BET14.equals("")){ data.BET14=""; }else{ data.BET14=Double.toString(Double.parseDouble(data.BET14) / 100.0); }  // 금액
                if(data.BET15.equals("")){ data.BET15=""; }else{ data.BET15=Double.toString(Double.parseDouble(data.BET15) / 100.0); }  // 금액
                if(data.BET16.equals("")){ data.BET16=""; }else{ data.BET16=Double.toString(Double.parseDouble(data.BET16) / 100.0); }  // 금액
                if(data.BET17.equals("")){ data.BET17=""; }else{ data.BET17=Double.toString(Double.parseDouble(data.BET17) / 100.0); }  // 금액
                if(data.BET18.equals("")){ data.BET18=""; }else{ data.BET18=Double.toString(Double.parseDouble(data.BET18) / 100.0); }  // 금액
                if(data.BET19.equals("")){ data.BET19=""; }else{ data.BET19=Double.toString(Double.parseDouble(data.BET19) / 100.0); }  // 금액
                if(data.BET20.equals("")){ data.BET20=""; }else{ data.BET20=Double.toString(Double.parseDouble(data.BET20) / 100.0); }  // 금액
                if(data.BET21.equals("")){ data.BET21=""; }else{ data.BET21=Double.toString(Double.parseDouble(data.BET21) / 100.0); }  // 금액
                if(data.BET22.equals("")){ data.BET22=""; }else{ data.BET22=Double.toString(Double.parseDouble(data.BET22) / 100.0); }  // 금액
                if(data.BET23.equals("")){ data.BET23=""; }else{ data.BET23=Double.toString(Double.parseDouble(data.BET23) / 100.0); }  // 금액
                if(data.BET24.equals("")){ data.BET24=""; }else{ data.BET24=Double.toString(Double.parseDouble(data.BET24) / 100.0); }  // 금액
                if(data.BET25.equals("")){ data.BET25=""; }else{ data.BET25=Double.toString(Double.parseDouble(data.BET25) / 100.0); }  // 금액
                if(data.BET26.equals("")){ data.BET26=""; }else{ data.BET26=Double.toString(Double.parseDouble(data.BET26) / 100.0); }  // 금액
                if(data.BET27.equals("")){ data.BET27=""; }else{ data.BET27=Double.toString(Double.parseDouble(data.BET27) / 100.0); }  // 금액
                if(data.BET28.equals("")){ data.BET28=""; }else{ data.BET28=Double.toString(Double.parseDouble(data.BET28) / 100.0); }  // 금액
                if(data.BET29.equals("")){ data.BET29=""; }else{ data.BET29=Double.toString(Double.parseDouble(data.BET29) / 100.0); }  // 금액
                if(data.BET30.equals("")){ data.BET30=""; }else{ data.BET30=Double.toString(Double.parseDouble(data.BET30) / 100.0); }  // 금액
                if(data.BET31.equals("")){ data.BET31=""; }else{ data.BET31=Double.toString(Double.parseDouble(data.BET31) / 100.0); }  // 금액
                if(data.BET32.equals("")){ data.BET32=""; }else{ data.BET32=Double.toString(Double.parseDouble(data.BET32) / 100.0); }  // 금액
                if(data.BET33.equals("")){ data.BET33=""; }else{ data.BET33=Double.toString(Double.parseDouble(data.BET33) / 100.0); }  // 금액
                if(data.BET34.equals("")){ data.BET34=""; }else{ data.BET34=Double.toString(Double.parseDouble(data.BET34) / 100.0); }  // 금액
                if(data.BET35.equals("")){ data.BET35=""; }else{ data.BET35=Double.toString(Double.parseDouble(data.BET35) / 100.0); }  // 금액
                if(data.BET36.equals("")){ data.BET36=""; }else{ data.BET36=Double.toString(Double.parseDouble(data.BET36) / 100.0); }  // 금액
                if(data.BET37.equals("")){ data.BET37=""; }else{ data.BET37=Double.toString(Double.parseDouble(data.BET37) / 100.0); }  // 금액
                if(data.BET38.equals("")){ data.BET38=""; }else{ data.BET38=Double.toString(Double.parseDouble(data.BET38) / 100.0); }  // 금액
                if(data.BET39.equals("")){ data.BET39=""; }else{ data.BET39=Double.toString(Double.parseDouble(data.BET39) / 100.0); }  // 금액
                if(data.BET40.equals("")){ data.BET40=""; }else{ data.BET40=Double.toString(Double.parseDouble(data.BET40) / 100.0); }  // 금액
                if(data.BET41.equals("")){ data.BET41=""; }else{ data.BET41=Double.toString(Double.parseDouble(data.BET41) / 100.0); }  // 금액
                if(data.BET42.equals("")){ data.BET42=""; }else{ data.BET42=Double.toString(Double.parseDouble(data.BET42) / 100.0); }  // 금액
                if(data.BET43.equals("")){ data.BET43=""; }else{ data.BET43=Double.toString(Double.parseDouble(data.BET43) / 100.0); }  // 금액
                if(data.BET44.equals("")){ data.BET44=""; }else{ data.BET44=Double.toString(Double.parseDouble(data.BET44) / 100.0); }  // 금액
                if(data.BET45.equals("")){ data.BET45=""; }else{ data.BET45=Double.toString(Double.parseDouble(data.BET45) / 100.0); }  // 금액
             }

            setInput(function, "5", empNo, targetYear);

            setInput(function, preWork_vt, "RESULT");

            excute(mConnection, function);

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
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String cont_type, String empNo, String targetYear) throws GeneralException {
        String fieldName1 = "P_CONF_TYPE";
        setField( function, fieldName1, cont_type );
        String fieldName2 = "I_PERNR";
        setField( function, fieldName2, empNo );
        String fieldName3 = "I_YEAR";
        setField( function, fieldName3, targetYear );
        String fieldName4 = "I_BEGDA";
        setField( function, fieldName4, "" );
        String fieldName5 = "I_ENDDA";
        setField( function, fieldName5, "" );
        String fieldName6 = "P_FLAG";
        setField( function, fieldName6, "" );
        String fieldName7 = "D_FLAG";
        setField( function, fieldName7, "" );
    }

    // Import Parameter 가 Vector(Table) 인 경우
    /**
     * RFC 실행전에 Import 값을 setting 한다.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출되기 전에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @param entityVector java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, Vector entityVector, String tableName) throws GeneralException {
        setTable(function, tableName, entityVector);
    }

    /**
     * RFC 실행후 Export 값을 Vector 로 Return 한다.
     * 반드시 com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출된후에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutput(JCO.Function function) throws GeneralException {
        String entityName = "hris.D.D11TaxAdjust.D11TaxAdjustPreWorkData";
        String tableName  = "RESULT";

        return getTable(entityName, function, tableName);
    }

    private Vector getOutput1(JCO.Function function) throws GeneralException {
        String entityName = "hris.D.D11TaxAdjust.D11TaxAdjustPreWorkNmData";
        String tableName  = "R_T511M";

        return getTable(entityName, function, tableName);
    }    
}
