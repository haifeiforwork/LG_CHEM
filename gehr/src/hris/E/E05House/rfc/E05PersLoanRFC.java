package hris.E.E05House.rfc;

import java.util.*;

import com.sap.mw.jco.*;
import com.sns.jdf.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;

import hris.E.E05House.*;

/**
 * E05PersLoanRFC.java
 * �������ڿ� ���� ��������� �������� RFC�� ȣ���ϴ� Class
 *
 * @author �輺��
 * @version 1.0, 2001/12/13
 */
public class E05PersLoanRFC extends SAPWrap {

    //private String functionName ="ZHRW_RFC_GET_INFTY_0045";
    private String functionName ="ZGHR_RFC_GET_INFTY_0045";

    /**
     * �������ڿ� ���� ��������� �������� RFC�� ȣ���ϴ� Method
     *  @param java.lang.String �����ȣ
     *  @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getPersLoan( String empNo ) throws GeneralException {
        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction( functionName ) ;

            setInput( function, empNo );
            excute( mConnection, function );

            Vector ret = getTable(E05PersLoanData.class, function, "T_LOAN_TAB"); //getOutput(function);

            for ( int i = 0 ; i < ret.size() ; i++ ) {
                E05PersLoanData data = (E05PersLoanData)ret.get(i);
                data.DARBT = Double.toString(Double.parseDouble(data.DARBT) * 100.0 ) ;
            }

            return ret;
        }catch(Exception ex){
            //Logger.sap.println(this," SAPException : " +ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }
    /**
     * �������ڿ� ���� �������ΰ��� ��������� �������� RFC�� ȣ���ϴ� Method
     *  @param java.lang.String �����ȣ
     *  @return java.util.Vector
     * @exception com.sns.jdf.GeneralException  ���������ΰ� C20110808_41085
     */
    public Vector getIngPersLoan( String empNo ) throws GeneralException {
        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction( functionName ) ;

            setInput( function, empNo );
            excute( mConnection, function );

            Vector ret = getTable(E05PersLoanData.class, function, "T_LOAN_ING_TAB"); //getOutput1(function);

            for ( int i = 0 ; i < ret.size() ; i++ ) {
                E05PersLoanData data = (E05PersLoanData)ret.get(i);
                data.DARBT = Double.toString(Double.parseDouble(data.DARBT) * 100.0 ) ;
            }

            return ret;
        }catch(Exception ex){
            //Logger.sap.println(this," SAPException : " +ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    /**
     * �λ翵���� �������� RFC�� ȣ���ϴ� Method
     *  @param     java.lang.String �����ȣ
     *  @return    java.util.Vector
     *  @exception com.sns.jdf.GeneralException
     */
    public String getE_WERKS( String empNo ) throws GeneralException {
        JCO.Client mConnection = null ;

        try {
            mConnection = getClient() ;
            JCO.Function function = createFunction( functionName ) ;

            setInput( function, empNo ) ;
            excute( mConnection, function ) ;

            String fieldName = "E_WERKS" ;
            String e_werks   = getField( fieldName, function ) ;

            return e_werks ;
        } catch( Exception ex ) {
            //Logger.sap.println( this, " SAPException : " + ex.toString() ) ;
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
        String fieldName = "I_PERNR";
        setField( function, fieldName, empNo );
    }

    /**
     * RFC ������ Export ���� Vector �� Return �Ѵ�.
     * �ݵ�� com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ����Ŀ� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutput(JCO.Function function) throws GeneralException {
        String entityName = "hris.E.E05House.E05PersLoanData";
        String tableName = "T_LOAN_TAB";
        return getTable(entityName, function, tableName);
    }
    // �� �������ΰ� C20110808_41085
    private Vector getOutput1(JCO.Function function) throws GeneralException {
        //String entityName = "hris.E.E05House.E05PersLoanData";
        //String tableName = "T_LOAN_ING_TAB";
        return getTable(E05PersLoanData.class, function, "T_LOAN_ING_TAB");
    }
}
