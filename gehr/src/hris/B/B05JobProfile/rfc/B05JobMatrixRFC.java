package hris.B.B05JobProfile.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;
import com.sap.mw.jco.*;

import hris.B.B05JobProfile.*;

/**
 * B05JobMatrixRFC.java
 * Job Matrix�� ��ȸ�ϴ� RFC�� ȣ���ϴ� Class                        
 *
 * @author �赵��
 * @version 1.0, 2003/02/11
 */
public class B05JobMatrixRFC extends SAPWrap {

    private String functionName = "ZHRH_RFC_GET_JOB_MATRIX";

    public Vector getDetail( String i_sobid, String gubun ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, i_sobid);
            excute(mConnection, function);

            Vector ret = new Vector();
            
            if( gubun.equals("P_RESULT") ) {             // ��з� - Level List
                ret = getOutput(function);
            } else if( gubun.equals("P_RESULT_D") ) {    // ��з� List
                ret = getOutput_D(function);
            }
            
            return ret;
        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    /**
     * Objective ���� ��ȸ�ϴ� RFC�� ȣ���ϴ� Method
     *  @exception com.sns.jdf.GeneralException
     */
    public String getE_STEXT( String i_sobid ) throws GeneralException {
        JCO.Client mConnection = null ;

        try {
            mConnection = getClient() ;
            JCO.Function function = createFunction( functionName ) ;

            setInput( function, i_sobid ) ;
            excute( mConnection, function ) ;

            String fieldName = "E_STEXT" ;
            String ret       = getField( fieldName, function ) ;

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
     * @param value java.lang.String ���
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String i_sobid ) throws GeneralException {
        String fieldName1 = "I_SOBID";
        setField(function, fieldName1, i_sobid);
    }
    
    /**
     * RFC ������ Export ���� Vector �� Return �Ѵ�.
     * �ݵ�� com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ����Ŀ� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutput(JCO.Function function) throws GeneralException {
        String entityName = "hris.B.B05JobProfile.B05JobMatrixData";
        String tableName  = "P_RESULT";
        return getTable(entityName, function, tableName);
    }

    /**
     * RFC ������ Export ���� Vector �� Return �Ѵ�.
     * �ݵ�� com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ����Ŀ� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutput_D(JCO.Function function) throws GeneralException {
        String entityName = "hris.B.B05JobProfile.B05JobMatrixData";
        String tableName  = "P_RESULT_D";
        return getTable(entityName, function, tableName);
    }

}

