package hris.D.D03Vocation.rfc ;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;

import hris.D.D03Vocation.D03VacationUsedData;

import java.util.Vector;

/**
 * D03VacationUsedRFC.java
 * �ϰ��ް� ����ϼ��� ��ȸ�ϴ� RFC
 *
 * @author �赵��
 * @version 1.0, 2002/11/20
 */
public class D03VacationUsedRFC extends SAPWrap {

   // private String functionName = "ZHRP_RFC_VACATION_USED" ;
	 private String functionName = "ZGHR_RFC_VACATION_USED" ;

    /**
     * �ϰ��ް� ����ϼ�
     * @exception com.sns.jdf.GeneralException
     */
    public String getE_ABRTG( String empNo ) throws GeneralException {
        JCO.Client mConnection = null ;

        try {
            mConnection = getClient() ;
            JCO.Function function = createFunction( functionName ) ;

            setInput(function, empNo) ;
            excute(mConnection, function) ;

            String fieldName = "E_ABRTG" ;
            String ret       = getField( fieldName, function ) ;

            return ret ;
        } catch( Exception ex ) {
            Logger.sap.println( this, " SAPException : " + ex.toString() ) ;
            throw new GeneralException( ex ) ;
        } finally {
            close( mConnection ) ;
        }
    }

	public Vector getVacationUsed( String empNo ) throws GeneralException {
        JCO.Client mConnection = null ;

        try {
            mConnection = getClient() ;
            JCO.Function function = createFunction( functionName ) ;

            setInput(function, empNo) ;
            excute(mConnection, function) ;

            Vector ret       = getTable(D03VacationUsedData.class, function, "T_IT");
            /*for ( int i = 0; i<ret.size(); i++ ){
                D03VacationUsedData data = (D03VacationUsedData)ret.get(i);
            }*/

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
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ��Ǳ� ���� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String empNo) throws GeneralException {
        String fieldName1 = "I_PERNR";
        setField( function, fieldName1, empNo );
    }

    // Import Parameter �� Vector(Table) �� ���
// ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
    /**
     * RFC �������� Import ���� setting �Ѵ�.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ��Ǳ� ���� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @param entityVector java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, Vector entityVector, String tableName) throws GeneralException {
        setTable(function, tableName, entityVector);
    }



}