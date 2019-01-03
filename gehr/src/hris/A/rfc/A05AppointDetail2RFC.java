package hris.A.rfc ;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;
import hris.A.A05AppointDetail2Data;

import java.util.Vector;

/**
 * A05AppointDetail2RFC.java
 * ����� �±޻��� ������ �������� RFC�� ȣ���ϴ� Class
 *
 * @author �Ѽ���
 * @version 1.0, 2001/12/17
 */
public class A05AppointDetail2RFC extends SAPWrap {

    private String functionName = "ZGHR_RFC_GET_IT0008_KR" ;

    /**
     * ����� �±޻��� ������ �������� RFC�� ȣ���ϴ� Method
     *  @return    java.util.Vector
     *  @exception com.sns.jdf.GeneralException
     */
    public Vector<A05AppointDetail2Data> getAppointDetail2(String empNo, String I_CFORM ) throws GeneralException {

        JCO.Client mConnection = null ;

        try {

            mConnection = getClient() ;
            JCO.Function function = createFunction( functionName ) ;

            setField(function, "I_PERNR", empNo);
            setField(function, "I_CFORM", I_CFORM);

            excute( mConnection, function ) ;

            return getTable(A05AppointDetail2Data.class, function, "T_RESULT");

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
    private void setInput( JCO.Function function, String empNo ) throws GeneralException {

        String fieldName = "PERNR" ;
        setField( function, fieldName, empNo ) ;

    }

    /**
     * RFC ������ Export ���� Vector �� Return �Ѵ�.
     * �ݵ�� com.sns.jdf.SAPWrap.excute( JCO.Client mConnection, JCO.Function function ) �� ȣ����Ŀ� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @return         java.util.Vector
     * @exception      com.sns.jdf.GeneralException
     */
    private Vector getOutput( JCO.Function function ) throws GeneralException {

        String entityName = "hris.A.A05AppointDetail2Data" ;
        String tableName  = "RESULT" ;
        return getTable( entityName, function, tableName ) ;

    }

}
