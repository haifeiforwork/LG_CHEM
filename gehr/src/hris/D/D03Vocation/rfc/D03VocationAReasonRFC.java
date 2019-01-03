package hris.D.D03Vocation.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;
import com.sap.mw.jco.*;

import hris.D.D03Vocation.*;

/**
 * D03VocationAReasonRFC.java
 * �ް�����  Code�� �������� RFC�� ȣ���ϴ� Class
 *
 * @author lsa
 * @version 1.0, 2009/10/26
 */
public class D03VocationAReasonRFC extends SAPWrap {

    //private String functionName = "ZHRW_RFC_AREASON";
	private String functionName = "ZGHR_RFC_AREASON";

    /**
     * �������� Code�� �������� RFC�� ȣ���ϴ� Method
     * @param companyCode java.lang.String ȸ���ڵ�
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getSubtyCode(String companyCode,String Pernr,String Subty,String i_datum) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, companyCode,Pernr,Subty,i_datum);
            excute(mConnection, function);
            Vector ret = getTable(hris.D.D03Vocation.D03VocationReasonData.class, function, "T_RESULT");
            return ret;
        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }
    public String getE_BTRTL(String companyCode,String Pernr,String Subty,String i_datum) throws GeneralException {
        JCO.Client mConnection = null ;

        try {
            mConnection = getClient() ;
            JCO.Function function = createFunction( functionName ) ;

            setInput(function, companyCode,Pernr,Subty,i_datum);
            excute(mConnection, function) ;

            String fieldName = "E_BTRTL" ; //�λ� ���� ����
            String ret       = getField( fieldName, function ) ;

            return ret ;
        } catch( Exception ex ) {
            Logger.sap.println( this, " SAPException : " + ex.toString() ) ;
            throw new GeneralException( ex ) ;
        } finally {
            close( mConnection ) ;
        }
    }
    public String getE_OVTYN(String companyCode,String Pernr,String Subty,String i_datum) throws GeneralException {
        JCO.Client mConnection = null ;

        try {
            mConnection = getClient() ;
            JCO.Function function = createFunction( functionName ) ;

            setInput(function, companyCode,Pernr,Subty,i_datum);
            excute(mConnection, function) ;

            String fieldName = "E_OVTYN" ; //�ʰ��ٹ���û����ڿ���
            String ret       = getField( fieldName, function ) ;

            return ret ;
        } catch( Exception ex ) {
            Logger.sap.println( this, " SAPException : " + ex.toString() ) ;
            throw new GeneralException( ex ) ;
        } finally {
            close( mConnection ) ;
        }
    }
    public String getE_PERSKG(String companyCode,String Pernr,String Subty,String i_datum) throws GeneralException {
        JCO.Client mConnection = null ;

        try {
            mConnection = getClient() ;
            JCO.Function function = createFunction( functionName ) ;

            setInput(function, companyCode,Pernr,Subty,i_datum);
            excute(mConnection, function) ;

            String fieldName = "E_PERSKG" ; //��C20120113_33260 �繫������(S):����Ư��,����Ư�ٽ�û���� ,�������(T) : ������û����
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
     * @param companyCode java.lang.String ȸ���ڵ�
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String companyCode,String Pernr,String Subty,String i_datum) throws GeneralException {
        String fieldName = "I_PERNR";
        setField( function, fieldName, Pernr );
        String fieldName1 = "I_DATUM";
        setField( function, fieldName1, i_datum );
        String fieldName2 = "I_SUBTY";
        setField( function, fieldName2, Subty );
    }
}


