package hris.D.D09Bond.rfc ;

import java.util.* ;

import com.sap.mw.jco.* ;
import com.sns.jdf.* ;
import com.sns.jdf.sap.* ;
import com.sns.jdf.util.* ;

import hris.D.D09Bond.* ;

/**
 * D09BondProvisionRFC.java
 * ä�� �з� ���� ��Ȳ�� �������� RFC�� ȣ���ϴ� Class
 *
 * @author �Ѽ���
 * @version 1.0, 2002/01/24
 */
public class D09BondProvisionRFC extends SAPWrap {

    private String functionName = "ZGHR_RFC_BOND_RECEIPT" ;


    /**
     * ä�� �з� ���� ��Ȳ�� �������� RFC�� ȣ���ϴ� Method
     *  @param     java.lang.String �����ȣ
     *  @return    java.util.Vector
     *  @exception com.sns.jdf.GeneralException
     */
    public Vector getBondProvision( String empNo ) throws GeneralException {
        JCO.Client mConnection = null ;

        try {
            mConnection = getClient() ;
            JCO.Function function = createFunction( functionName ) ;

            setInput( function, empNo ) ;
            excute( mConnection, function ) ;

            Vector ret = getOutput( function ) ;

            for( int i = 0 ; i < ret.size() ; i++ ) {
                D09BondProvisionData data = ( D09BondProvisionData ) ret.get( i ) ;

                data.GIVE_AMNT = Double.toString( Double.parseDouble( data.GIVE_AMNT ) * 100.0 ) ;  // ����(����)��
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
     * �����Ѿ��� �������� RFC�� ȣ���ϴ� Method
     *  @param     java.lang.String �����ȣ
     *  @return    java.util.Vector
     *  @exception com.sns.jdf.GeneralException
     */
    public String getG_SUM( String empNo ) throws GeneralException {
        JCO.Client mConnection = null ;

        try {
            mConnection = getClient() ;
            JCO.Function function = createFunction( functionName ) ;

            setInput( function, empNo ) ;
            excute( mConnection, function ) ;

            String fieldName = "E_G_SUM" ;
            String ret       = getField( fieldName, function ) ;
            ret = Double.toString( Double.parseDouble( ret ) * 100.0 ) ;  // �����Ѿ�

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
        String entityName = "hris.D.D09Bond.D09BondProvisionData" ;
        String tableName  = "T_IT" ;

        return getTable( entityName, function, tableName ) ;
    }
}