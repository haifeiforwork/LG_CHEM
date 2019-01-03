package hris.A.rfc ;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;
import hris.A.A05AppointDetail2Data;

import java.util.Vector;

/**
 * A05AppointDetail2RFC.java
 * 사원의 승급사항 내역을 가져오는 RFC를 호출하는 Class
 *
 * @author 한성덕
 * @version 1.0, 2001/12/17
 */
public class A05AppointDetail2RFC extends SAPWrap {

    private String functionName = "ZGHR_RFC_GET_IT0008_KR" ;

    /**
     * 사원의 승급사항 내역을 가져오는 RFC를 호출하는 Method
     *  @return    java.util.Vector
     *  @exception com.sns.jdf.GeneralException
     */
    public Vector<A05AppointDetail2Data> getAppointDetail2(String empNo, String I_CFORM ) throws GeneralException {

        JCO.Client mConnection = null ;

        try {

            mConnection = getClient() ;
            JCO.Function function = createFunction( functionName ) ;

            setField(function, "I_PERNR", empNo);
            setField(function, "I_CFORM", I_CFORM);

            excute( mConnection, function ) ;

            return getTable(A05AppointDetail2Data.class, function, "T_RESULT");

        } catch( Exception ex ) {

            Logger.sap.println( this, " SAPException : " + ex.toString() ) ;
            throw new GeneralException( ex ) ;

        } finally {

            close( mConnection ) ;
        }

    }

    /**
     * RFC 실행전에 Import 값을 setting 한다.
     * com.sns.jdf.SAPWrap.excute( JCO.Client mConnection, JCO.Function function ) 가 호출되기 전에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @exception      com.sns.jdf.GeneralException
     */
    private void setInput( JCO.Function function, String empNo ) throws GeneralException {

        String fieldName = "PERNR" ;
        setField( function, fieldName, empNo ) ;

    }

    /**
     * RFC 실행후 Export 값을 Vector 로 Return 한다.
     * 반드시 com.sns.jdf.SAPWrap.excute( JCO.Client mConnection, JCO.Function function ) 가 호출된후에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @return         java.util.Vector
     * @exception      com.sns.jdf.GeneralException
     */
    private Vector getOutput( JCO.Function function ) throws GeneralException {

        String entityName = "hris.A.A05AppointDetail2Data" ;
        String tableName  = "RESULT" ;
        return getTable( entityName, function, tableName ) ;

    }

}
