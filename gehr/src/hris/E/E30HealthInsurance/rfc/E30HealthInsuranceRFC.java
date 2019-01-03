package hris.E.E30HealthInsurance.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;
import com.sap.mw.jco.*;

import hris.E.E30HealthInsurance.*;

/**
 * E30HealthInsuranceRFC.java
 * �ǰ����� ���� ������ ��ȸ�ϴ� RFC �� ȣ���ϴ� Class
 *
 * @author  �赵��
 * @version 1.0, 2003/02/19
 */
public class E30HealthInsuranceRFC extends SAPWrap {

    //private String functionName = "ZHRW_RFC_GET_HEALTH_INSURANCE";
	private String functionName = "ZGHR_RFC_GET_HEALTH_INSURANCE";

    /**
     * �ǰ����� ���� ������ ��ȸ RFC ȣ���ϴ� Method
     * @param empNo java.lang.String �����ȣ
     * @return java.object E30HealthInsuranceData
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getDetail( String empNo ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, empNo);
            excute(mConnection, function);

            Vector ret = getOutput(function);

            return ret;
        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    /**
     * (�������) ����� ��ȣ�� ��ȸ�ϴ� RFC�� ȣ���ϴ� Method
     * @exception com.sns.jdf.GeneralException
     */
    public String getE_MINUM( String empNo ) throws GeneralException {
        JCO.Client mConnection = null ;

        try {
            mConnection = getClient() ;
            JCO.Function function = createFunction( functionName ) ;

            setInput( function, empNo ) ;
            excute( mConnection, function ) ;

            String fieldName = "E_MINUM" ;
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
     * (�������) �ǷẸ��ī���ȣ�� ��ȸ�ϴ� RFC�� ȣ���ϴ� Method
     * @exception com.sns.jdf.GeneralException
     */
    public String getE_MICNR( String empNo ) throws GeneralException {
        JCO.Client mConnection = null ;

        try {
            mConnection = getClient() ;
            JCO.Function function = createFunction( functionName ) ;

            setInput( function, empNo ) ;
            excute( mConnection, function ) ;

            String fieldName = "E_MICNR" ;
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
     * @param empNo java.lang.String �����ȣ
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
        Vector ret = new Vector();

        Vector P_RESULT    = getTable(E30HealthInsuranceData.class, function, "T_RESULT");

        Vector P_RESULT_21 = getTable(E30HealthInsuranceData.class, function, "T_RESULT_21");


        ret.addElement(P_RESULT);
        ret.addElement(P_RESULT_21);

        return ret;
    }

}
