package hris.B.rfc ;

import java.util.* ;

import com.sap.mw.jco.* ;
import com.sns.jdf.* ;
import com.sns.jdf.sap.* ;
import com.sns.jdf.util.* ;

import hris.B.* ;

/**
 * B03DevelopListRFC.java.java
 *  ���簳�����ǰ���� �������� RFC�� ȣ���ϴ� Class
 *
 * @author �輺��
 * @version 1.0, 2002/01/15
 */
public class B03DevelopListRFC extends SAPWrap {

    private String functionName = "ZHRE_RFC_DEVELOP_LIST" ;

    /**
     * ���簳�����ǰ���� �������� RFC�� ȣ���ϴ� Method
     *  @param   empNo  java.lang.String �����ȣ
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
     * RFC �������� Import ���� setting �Ѵ�.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ��Ǳ� ���� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @param empNo java.lang.String �����ȣ
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
     * RFC ������ Export ���� Vector �� Return �Ѵ�.
     * �ݵ�� com.sns.jdf.SAPWrap.excute( JCO.Client mConnection, JCO.Function function ) �� ȣ����Ŀ� ����Ǿ���ϴ� �޼ҵ�
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
