package hris.D.D09Bond.rfc ;

import java.util.* ;

import com.sap.mw.jco.* ;
import com.sns.jdf.* ;
import com.sns.jdf.sap.* ;
import com.sns.jdf.util.* ;

import hris.D.D09Bond.* ;

/**
 * D09BondListRFC.java
 * ä�� �з� ��Ȳ�� �������� RFC�� ȣ���ϴ� Class
 *
 * @author �Ѽ���
 * @version 1.0, 2002/02/27
 */
public class D09BondListRFC extends SAPWrap {

    //private String functionName = "ZHRP_RFC_BOND_PRESENTSTATE" ;
	private String functionName = "ZGHR_RFC_BOND_PRESENTSTATE" ;

    /**
     * ä�� �з� ��Ȳ�� �������� RFC�� ȣ���ϴ� Method
     *  @param     java.lang.String �����ȣ
     *  @return    java.util.Vector
     *  @exception com.sns.jdf.GeneralException
     */
    public Vector getBondList( String empNo ) throws GeneralException {
        JCO.Client mConnection = null ;

        try {
            mConnection = getClient() ;
            JCO.Function function = createFunction( functionName ) ;

            setInput( function, empNo ) ;
            excute( mConnection, function ) ;

            Vector ret = getOutput( function ) ;

            for( int i = 0 ; i < ret.size() ; i++ ) {
                D09BondListData data = ( D09BondListData ) ret.get( i ) ;

                data.CRED_AMNT = Double.toString( Double.parseDouble( data.CRED_AMNT ) * 100.0 ) ;  // ���з���
                data.GIVE_AMNT = Double.toString( Double.parseDouble( data.GIVE_AMNT ) * 100.0 ) ;  // ���޾�
                data.REST_AMNT = Double.toString( Double.parseDouble( data.REST_AMNT ) * 100.0 ) ;  // ���з��ܾ�
                data.DPOT_CHRG = Double.toString( Double.parseDouble( data.DPOT_CHRG ) * 100.0 ) ;  // ��Ź������
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
     * ��Ź�����Ḧ �������� RFC�� ȣ���ϴ� Method
     *  @param     java.lang.String �����ȣ
     *  @return    java.util.Vector
     *  @exception com.sns.jdf.GeneralException
     */
    public String getG_DPOT_CHRG( String empNo ) throws GeneralException {
        JCO.Client mConnection = null ;

        try {
            mConnection = getClient() ;
            JCO.Function function = createFunction( functionName ) ;

            setInput( function, empNo ) ;
            excute( mConnection, function ) ;

            String fieldName = "E_G_DPOT_CHRG" ;
            String ret       = getField( fieldName, function ) ;

            Logger.debug.println( this, "E_G_DPOT_CHRG : " + ret ) ;

            ret = Double.toString( Double.parseDouble( ret ) * 100.0 ) ;  // ��Ź������

            Logger.debug.println( this, "E_G_DPOT_CHRG : " + ret ) ;

            return ret ;
        } catch( Exception ex ) {
            Logger.sap.println( this, " SAPException : " + ex.toString() ) ;
            throw new GeneralException( ex ) ;
        } finally {
            close( mConnection ) ;
        }
    }

    /**
     * �̹���Ź���� �������� RFC�� ȣ���ϴ� Method
     *  @param     java.lang.String �����ȣ
     *  @return    java.util.Vector
     *  @exception com.sns.jdf.GeneralException
     */
    public String getG_DPOT_REST( String empNo ) throws GeneralException {
        JCO.Client mConnection = null ;

        try {
            mConnection = getClient() ;
            JCO.Function function = createFunction( functionName ) ;

            setInput( function, empNo ) ;
            excute( mConnection, function ) ;

            String fieldName = "E_G_DPOT_REST" ;
            String ret       = getField( fieldName, function ) ;

            Logger.debug.println( this, "E_G_DPOT_REST : " + ret ) ;

            ret = Double.toString( Double.parseDouble( ret ) * 100.0 ) ;  // �̹���Ź��

            Logger.debug.println( this, "E_G_DPOT_REST : " + ret ) ;

            return ret ;
        } catch( Exception ex ) {
            Logger.sap.println( this, " SAPException : " + ex.toString() ) ;
            throw new GeneralException( ex ) ;
        } finally {
            close( mConnection ) ;
        }
    }

    /**
     * ���з� �ܾ� �踦 �������� RFC�� ȣ���ϴ� Method
     *  @param     java.lang.String �����ȣ
     *  @return    java.util.Vector
     *  @exception com.sns.jdf.GeneralException
     */
    public String getG_REST_AMNT( String empNo ) throws GeneralException {
        JCO.Client mConnection = null ;

        try {
            mConnection = getClient() ;
            JCO.Function function = createFunction( functionName ) ;

            setInput( function, empNo ) ;
            excute( mConnection, function ) ;

            String fieldName = "E_G_REST_AMNT" ;
            String ret       = getField( fieldName, function ) ;

            Logger.debug.println( this, "E_G_REST_AMNT : " + ret ) ;

            ret = Double.toString( Double.parseDouble( ret ) * 100.0 ) ;  // ���з� �ܾ� �踦

            Logger.debug.println( this, "E_G_REST_AMNT : " + ret ) ;

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
        String fieldName = "I_PERNR" ;
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
        String entityName = "hris.D.D09Bond.D09BondListData" ;
        //String tableName  = "IT" ;
        String tableName  = "T_IT" ;

        return getTable( entityName, function, tableName ) ;
        //return getTable( getExportFields(entityName, function,""), function, tableName ) ;
    }

}
