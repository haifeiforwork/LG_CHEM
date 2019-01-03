package hris.D.D09Bond.rfc ;

import java.util.* ;

import com.sap.mw.jco.* ;
import com.sns.jdf.* ;
import com.sns.jdf.sap.* ;
import com.sns.jdf.util.* ;

import hris.D.D09Bond.* ;

/**
 * D09BondCortRFC.java
 * ä�� �̷� ��Ȳ�� �������� RFC�� ȣ���ϴ� Class
 *
 * @author �Ѽ���
 * @version 1.0, 2002/02/28
 */
public class D09BondCortRFC extends SAPWrap {

    private String functionName = "ZGHR_RFC_BOND_CORT" ;

    /**
     * ä�� �̷� ��Ȳ�� �������� RFC�� ȣ���ϴ� Method
     *  @param     java.lang.String �����ȣ
     *             java.lang.String ä���� ID
     *             java.lang.String �Ϸù�ȣ
     *  @return    java.util.Vector
     *  @exception com.sns.jdf.GeneralException
     */
    public Vector getBondCort( String empNo, String CRED_NUMB, String SEQN_NUMB ) throws GeneralException {
        JCO.Client mConnection = null ;

        try {
            mConnection = getClient() ;
            JCO.Function function = createFunction( functionName ) ;

            setInput( function, empNo, CRED_NUMB, SEQN_NUMB ) ;
            excute( mConnection, function ) ;

            Vector ret = getOutput( function ) ;

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
    private void setInput( JCO.Function function, String empNo, String CRED_NUMB, String SEQN_NUMB ) throws GeneralException {
        String fieldName = "I_PERNR" ;
        setField( function, fieldName, empNo ) ;

        String fieldNam1 = "I_CRED_NUMB" ;
        setField( function, fieldNam1, CRED_NUMB ) ;

        String fieldNam2 = "I_SEQN_NUMB" ;
        setField( function, fieldNam2, SEQN_NUMB ) ;
    }

    /**
     * RFC ������ Export ���� Vector �� Return �Ѵ�.
     * �ݵ�� com.sns.jdf.SAPWrap.excute( JCO.Client mConnection, JCO.Function function ) �� ȣ����Ŀ� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @return         java.util.Vector
     * @exception      com.sns.jdf.GeneralException
     */
    private Vector getOutput( JCO.Function function ) throws GeneralException {
        String entityName = "hris.D.D09Bond.D09BondCortData" ;
        String tableName  = "T_IT" ;

        return getTable( entityName, function, tableName ) ;
    }

}
