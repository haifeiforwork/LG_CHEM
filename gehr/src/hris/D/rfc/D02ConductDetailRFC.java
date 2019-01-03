package hris.D.rfc ;

import java.util.* ;

import com.sap.mw.jco.* ;
import com.sns.jdf.* ;
import com.sns.jdf.sap.* ;
import com.sns.jdf.util.* ;

import hris.D.* ;

/**
 * D02ConductDetailRFC.java
 * ���� ������ �������� RFC�� ȣ���ϴ� Class
 *
 * @author �Ѽ���
 * @version 1.0, 2002/02/01
 */
public class D02ConductDetailRFC extends SAPWrap {

    private String functionName = "ZGHR_RFC_TIME_DISPLAY" ;

    /**
     * ���� ������ �������� RFC�� ȣ���ϴ� Method
     *  @param     java.lang.String �����ȣ
     *  @return    java.util.Vector
     *  @exception com.sns.jdf.GeneralException
     */
    public Vector getConductDetail( String empNo, String BEGDA, String ENDDA ) throws GeneralException {
        JCO.Client mConnection = null ;

        try {
            mConnection = getClient() ;
            JCO.Function function = createFunction( functionName ) ;

            setInput( function, empNo, BEGDA, ENDDA ) ;
            excute( mConnection, function ) ;

            Vector ret = getOutput( function ) ;
/*
            for( int i = 0 ; i < ret.size() ; i++ ) {
                D02ConductDetailData data = ( D02ConductDetailData ) ret.get( i ) ;
            }
*/
            return ret ;
        } catch( Exception ex ) {
            Logger.sap.println( this, " SAPException : " + ex.toString() ) ;
            throw new GeneralException( ex ) ;
        } finally {
            close( mConnection ) ;
        }
    }

    /**
     * RFC �������� Import ���� setting �Ѵ�.
     * com.sns.jdf.SAPWrap.excute( JCO.Client mConnection, JCO.Function function ) �� ȣ��Ǳ� ���� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @exception      com.sns.jdf.GeneralException
     */
    private void setInput( JCO.Function function, String empNo, String BEGDA, String ENDDA ) throws GeneralException {
        String fieldName = "I_PERNR" ;
        setField( function, fieldName, empNo ) ;

        String fieldNam1 = "I_BEGDA" ;
        setField( function, fieldNam1, BEGDA ) ;

        String fieldNam2 = "I_ENDDA" ;
        setField( function, fieldNam2, ENDDA ) ;
    }

    /**
     * RFC ������ Export ���� Vector �� Return �Ѵ�.
     * �ݵ�� com.sns.jdf.SAPWrap.excute( JCO.Client mConnection, JCO.Function function ) �� ȣ����Ŀ� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @return         java.util.Vector
     * @exception      com.sns.jdf.GeneralException
     */
    private Vector getOutput( JCO.Function function ) throws GeneralException {
        String entityName = "hris.D.D02ConductDetailData" ;
        String tableName  = "T_IT" ;

        return getTable( entityName, function, tableName ) ;
    }

}
