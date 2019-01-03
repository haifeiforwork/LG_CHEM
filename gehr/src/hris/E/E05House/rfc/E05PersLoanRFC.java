package hris.E.E05House.rfc;

import java.util.*;

import com.sap.mw.jco.*;
import com.sns.jdf.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;

import hris.E.E05House.*;

/**
 * E05PersLoanRFC.java
 * 주택융자에 관한 사원정보를 가져오는 RFC를 호출하는 Class
 *
 * @author 김성일
 * @version 1.0, 2001/12/13
 */
public class E05PersLoanRFC extends SAPWrap {

    //private String functionName ="ZHRW_RFC_GET_INFTY_0045";
    private String functionName ="ZGHR_RFC_GET_INFTY_0045";

    /**
     * 주택융자에 관한 사원정보를 가져오는 RFC를 호출하는 Method
     *  @param java.lang.String 사원번호
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
     * 주택융자에 관한 진행중인건의 사원정보를 가져오는 RFC를 호출하는 Method
     *  @param java.lang.String 사원번호
     *  @return java.util.Vector
     * @exception com.sns.jdf.GeneralException  ※진행중인건 C20110808_41085
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
     * 인사영역을 가져오는 RFC를 호출하는 Method
     *  @param     java.lang.String 사원번호
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
     * RFC 실행전에 Import 값을 setting 한다.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출되기 전에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String empNo) throws GeneralException {
        String fieldName = "I_PERNR";
        setField( function, fieldName, empNo );
    }

    /**
     * RFC 실행후 Export 값을 Vector 로 Return 한다.
     * 반드시 com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출된후에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutput(JCO.Function function) throws GeneralException {
        String entityName = "hris.E.E05House.E05PersLoanData";
        String tableName = "T_LOAN_TAB";
        return getTable(entityName, function, tableName);
    }
    // ※ 진행중인건 C20110808_41085
    private Vector getOutput1(JCO.Function function) throws GeneralException {
        //String entityName = "hris.E.E05House.E05PersLoanData";
        //String tableName = "T_LOAN_ING_TAB";
        return getTable(E05PersLoanData.class, function, "T_LOAN_ING_TAB");
    }
}
