package hris.D.D09Bond.rfc ;

import java.util.* ;

import com.sap.mw.jco.* ;
import com.sns.jdf.* ;
import com.sns.jdf.sap.* ;
import com.sns.jdf.util.* ;

import hris.D.D09Bond.* ;

/**
 * D09BondDeductionRFC.java
 * ä�� �з� ���� ��Ȳ�� �������� RFC�� ȣ���ϴ� Class
 *
 * @author �Ѽ���
 * @version 1.0, 2002/01/23
 */
public class D09BondDeductionRFC extends SAPWrap {

    private String functionName = "ZGHR_RFC_BOND_DEDUCTION" ;

    /**
     * ä�� �з� ���� ��Ȳ�� �������� RFC�� ȣ���ϴ� Method
     *  @param     java.lang.String �����ȣ
     *  @return    java.util.Vector
     *  @exception com.sns.jdf.GeneralException
     */
    public Vector getBondDeduction( String empNo, String BEGDA, String ENDDA ) throws GeneralException {
        JCO.Client mConnection = null ;

        try {
            mConnection = getClient() ;
            JCO.Function function = createFunction( functionName ) ;

            setInput( function, empNo, BEGDA, ENDDA ) ;
            excute( mConnection, function ) ;

            Vector ret = getOutput( function ) ;

            for( int i = 0 ; i < ret.size() ; i++ ) {
                D09BondDeductionData data = ( D09BondDeductionData ) ret.get( i ) ;

                data.BETRG01 = Double.toString( Double.parseDouble( data.BETRG01 ) * 100.0 ) ;  // ���Ա޿�
                data.BETRG02 = Double.toString( Double.parseDouble( data.BETRG02 ) * 100.0 ) ;  // ���Ի�
                data.BETRG04 = Double.toString( Double.parseDouble( data.BETRG04 ) * 100.0 ) ;  // �����Ի�
                data.BETRG03 = Double.toString( Double.parseDouble( data.BETRG03 ) * 100.0 ) ;  // ������
                data.G_SUM   = Double.toString( Double.parseDouble( data.G_SUM   ) * 100.0 ) ;  // �����װ�
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
        String entityName = "hris.D.D09Bond.D09BondDeductionData" ;
        String tableName  = "T_IT" ;

        return getTable( entityName, function, tableName ) ;
    }

}
