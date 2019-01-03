package hris.A.rfc ;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;
import hris.A.A05AppointDetail1Data;

import java.util.Vector;

/**
 * A05AppointDetail1RFC.java
 * ����� �߷ɻ��� ������ �������� RFC�� ȣ���ϴ� Class
 *
 * @author �Ѽ���
 * @version 1.0, 2001/12/17
 * update [CSR ID:3436191] G Mobile �λ����� �޴� ��������  eunha 2017-07-18
 * 2018/05/21 rdcamel [CSR ID:3687969] �λ��Ϻλ� �ؿܹ��θ� �ѱۺ��� ��û�� ��
 */
public class A05AppointDetail1RFC extends SAPWrap {

    private String functionName = "ZGHR_RFC_ACTION_LIST" ;
    // [CSR ID:3436191] G Mobile �λ����� �޴� ��������  eunha 2017-07-18
    private String functionNameM = "ZGHR_RFC_ACTION_LIST_M" ;

    /**
     * ����� �߷ɻ��� ������ �������� RFC�� ȣ���ϴ� Method
     *  @return    java.util.Vector
     *  @exception com.sns.jdf.GeneralException
     */
    public Vector<A05AppointDetail1Data> getAppointDetail1( String empNo, String I_CFORM) throws GeneralException {

        return getAppointDetail1(empNo, I_CFORM, null);
    }

    public Vector<A05AppointDetail1Data> getAppointDetail1( String empNo, String I_CFORM, String I_CFORG) throws GeneralException {

        JCO.Client mConnection = null ;

        try {
            mConnection = getClient() ;
            JCO.Function function = createFunction( functionName ) ;

            setField(function, "I_PERNR", empNo);
            setField(function, "I_CFORM", I_CFORM);
            if(I_CFORG != null) setField(function, "I_CFORG", I_CFORG);

            excute( mConnection, function ) ;

            return getTable(A05AppointDetail1Data.class, function, "T_LIST");

        } catch( Exception ex ) {
            Logger.sap.println( this, " SAPException : " + ex.toString() ) ;
            throw new GeneralException( ex ) ;
        } finally {
            close( mConnection ) ;
        }

    }
    
    /**
     * ����� �߷ɻ��� ������ �������� RFC�� ȣ���ϴ� Method(���� ��� ���� text �߰�����)
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     * @author rdcamel [CSR ID:3687969] �λ��Ϻλ� �ؿܹ��θ� �ѱۺ��� ��û�� ��
     */
    public Vector<A05AppointDetail1Data> getAppointDetailLong1( String empNo, String I_CFORM, String I_CFORG) throws GeneralException {

        JCO.Client mConnection = null ;

        try {
            mConnection = getClient() ;
            JCO.Function function = createFunction( functionName ) ;

            setField(function, "I_PERNR", empNo);
            setField(function, "I_CFORM", I_CFORM);
            if(I_CFORG != null) setField(function, "I_CFORG", I_CFORG);
            setField(function, "I_ORGKR", "X");//�λ��Ϻ� �� �ؿܹ��θ� �ѱ� ǥ�õǵ��� flag(�ش� ���� ������ ���θ� ������)

            excute( mConnection, function ) ;

            return getTable(A05AppointDetail1Data.class, function, "T_LIST");

        } catch( Exception ex ) {
            Logger.sap.println( this, " SAPException : " + ex.toString() ) ;
            throw new GeneralException( ex ) ;
        } finally {
            close( mConnection ) ;
        }

    }
    
    // [CSR ID:3436191] G Mobile �λ����� �޴� ��������  eunha 2017-07-18 start
    public Vector<A05AppointDetail1Data> getAppointDetail1M( String empNo, String I_CFORM) throws GeneralException {

        return getAppointDetail1M(empNo, I_CFORM, null);
    }

    public Vector<A05AppointDetail1Data> getAppointDetail1M( String empNo, String I_CFORM, String I_CFORG) throws GeneralException {

        JCO.Client mConnection = null ;

        try {
            mConnection = getClient() ;
            JCO.Function function = createFunction( functionNameM ) ;

            setField(function, "I_PERNR", empNo);
            setField(function, "I_CFORM", I_CFORM);
            if(I_CFORG != null) setField(function, "I_CFORG", I_CFORG);

            excute( mConnection, function ) ;

            return getTable(A05AppointDetail1Data.class, function, "T_LIST");

        } catch( Exception ex ) {
            Logger.sap.println( this, " SAPException : " + ex.toString() ) ;
            throw new GeneralException( ex ) ;
        } finally {
            close( mConnection ) ;
        }

    }

 // [CSR ID:3436191] G Mobile �λ����� �޴� ��������  eunha 2017-07-18 end

}
