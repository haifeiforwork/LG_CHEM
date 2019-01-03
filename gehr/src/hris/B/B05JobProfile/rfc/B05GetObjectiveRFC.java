package hris.B.B05JobProfile.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;
import com.sap.mw.jco.*;

import hris.B.B05JobProfile.*;

/**
 * B05GetObjectiveRFC.java
 * 사번으로 Objective를 조회하는 RFC를 호출하는 Class                        
 *
 * @author 김도신
 * @version 1.0, 2003/02/13
 */
public class B05GetObjectiveRFC extends SAPWrap {

    private String functionName = "ZHRH_RFC_GET_OBJECTIVE";

    /**
     * Objective ID를 조회하는 RFC를 호출하는 Method
     *  @exception com.sns.jdf.GeneralException
     */
    public String getE_OBJID( String i_pernr ) throws GeneralException {
        JCO.Client mConnection = null ;

        try {
            mConnection = getClient() ;
            JCO.Function function = createFunction( functionName ) ;

            setInput( function, i_pernr ) ;
            excute( mConnection, function ) ;

            String fieldName = "E_OBJID" ;
            String ret       = getField( fieldName, function ) ;

            return ret ;
        } catch( Exception ex ) {
            Logger.sap.println( this, " SAPException : " + ex.toString() ) ;
            throw new GeneralException( ex ) ;
        } finally {
            close( mConnection ) ;
        }
    }

    /**
     * RFC 실행전에 Import 값을 setting 한다.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출되기 전에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @param value java.lang.String 사번
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String i_pernr ) throws GeneralException {
        String fieldName1 = "I_PERNR";
        setField(function, fieldName1, i_pernr);
    }

}

