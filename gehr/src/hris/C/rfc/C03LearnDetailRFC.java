package hris.C.rfc ;

import java.util.* ;

import com.sap.mw.jco.* ;
import com.sns.jdf.* ;
import com.sns.jdf.sap.* ;
import com.sns.jdf.util.* ;

import hris.C.* ;

/**
 * C03LearnDetailRFC.java
 * ����� ���� �̷� ������ �������� RFC�� ȣ���ϴ� Class
 *
 * @author �Ѽ���
 * @version 1.0, 2001/12/20
 */
public class C03LearnDetailRFC extends SAPWrap {

    private String functionName = "ZHRE_RFC_EDUCATION" ;

    /**
     * ����� ���� �̷� ������ �������� RFC�� ȣ���ϴ� Method
     *  @param     java.lang.String �����ȣ
     *  @return    java.util.Vector
     *  @exception com.sns.jdf.GeneralException
     */
    public Vector getLearnDetail( String empNo) throws GeneralException {
        JCO.Client mConnection = null ;

        try {
            mConnection = getClient() ;
            JCO.Function function = createFunction( functionName ) ;

            setInput( function, empNo ) ;
            excute( mConnection, function ) ;

            Vector ret = getOutput( function ) ;

            for( int i = 0 ; i < ret.size() ; i++ ) {
                C03LearnDetailData data = ( C03LearnDetailData ) ret.get( i ) ;
            }

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
    private void setInput( JCO.Function function, String empNo ) throws GeneralException {
        String fieldName = "PERNR" ;
        setField( function, fieldName, empNo ) ;
    }

    /**
     * RFC ������ Export ���� Vector �� Return �Ѵ�.
     * �ݵ�� com.sns.jdf.SAPWrap.excute( JCO.Client mConnection, JCO.Function function ) �� ȣ����Ŀ� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @return         java.util.Vector
     * @exception      com.sns.jdf.GeneralException
     */
    private Vector getOutput( JCO.Function function ) throws GeneralException {
        String entityName = "hris.C.C03LearnDetailData" ;
        String tableName  = "IT" ;

        return getTable( entityName, function, tableName ) ;
    }

}
