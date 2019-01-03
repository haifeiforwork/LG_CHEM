package hris.B.rfc ;

import java.util.* ;

import com.sap.mw.jco.* ;
import com.sns.jdf.* ;
import com.sns.jdf.sap.* ;
import com.sns.jdf.util.* ;

import hris.B.* ;

/**
 * B03DevelopListRFC.java.java
 *  인재개발협의결과를 가져오는 RFC를 호출하는 Class
 *
 * @author 김성일
 * @version 1.0, 2002/01/15
 */
public class B03DevelopListRFC extends SAPWrap {

    private String functionName = "ZHRE_RFC_DEVELOP_LIST" ;

    /**
     * 인재개발협의결과를 가져오는 RFC를 호출하는 Method
     *  @param   empNo  java.lang.String 사원번호
     *  @return    java.util.Vector
     *  @exception com.sns.jdf.GeneralException
     */
    public Vector getDevelopList( String empNo, String begDa, String seqnr, String gubun ) throws GeneralException {

        JCO.Client mConnection = null ;
        try {
            mConnection = getClient() ;
            JCO.Function function = createFunction( functionName ) ;

            setInput( function, empNo, begDa, seqnr ) ;
            excute( mConnection, function ) ;
			if(gubun.equals("1")){
				Vector ret = getOutput( function ) ;
				return ret ;
			} else if(gubun.equals("2")){
				Vector ret = getOutput( function ) ;
				return ret ;
			} else {
				Vector ret = getOutput2( function ) ;
				return ret ;
			}
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
     * @param empNo java.lang.String 사원번호
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String empNo , String begDa, String seqnr) throws GeneralException {
        String fieldName = "I_PERNR";
		String fieldName2 = "I_BEGDA";
		String fieldName3 = "I_SEQNR";
        setField( function, fieldName, empNo );
		setField( function, fieldName2, begDa );
		setField( function, fieldName3, seqnr );
        
    }

    /**
     * RFC 실행후 Export 값을 Vector 로 Return 한다.
     * 반드시 com.sns.jdf.SAPWrap.excute( JCO.Client mConnection, JCO.Function function ) 가 호출된후에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @return         java.util.Vector
     * @exception      com.sns.jdf.GeneralException
     */
    private Vector getOutput( JCO.Function function ) throws GeneralException {
        String entityName = "hris.B.B03DevelopData" ;
        String tableName  = "L_TAB" ;
        return getTable( entityName, function, tableName ) ;
    }
    private Vector getOutput2( JCO.Function function ) throws GeneralException {
        String entityName = "hris.B.B03DevelopData2" ;
        String tableName  = "L_TAB2" ;
        return getTable( entityName, function, tableName ) ;
    }
}
