package hris.E.E18Hospital.rfc ;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.sap.SAPWrap;
import hris.E.E18Hospital.E18HospitalListData;

import java.util.Vector;

/**
 * E18HospitalListRFC.java
 *  ����� �Ƿ�� ����(����������)�� �������� RFC�� ȣ���ϴ� Class
 *
 * @author lsa
 * @version 1.0, 2013/09/04 @CSR1 �ѵ�üũ ����� ��������
 */
public class E18HospitalIngListRFC extends SAPWrap {

    private String functionName = "ZGHR_RFC_MEDIC_CHK" ;

    /**
     * ����� �Ƿ�� ����(����������)�� �������� RFC�� ȣ���ϴ� Method
     *  @return    java.util.Vector
     *  @exception com.sns.jdf.GeneralException
     */
    public Vector<E18HospitalListData> getHospitalList( String I_PERNR,String I_ZBEGDA ) throws GeneralException {
        JCO.Client mConnection = null ;

        try {
            mConnection = getClient() ;
            JCO.Function function = createFunction( functionName ) ;

            setField( function, "I_PERNR", I_PERNR ) ;
            setField( function, "I_ZBEGDA", I_ZBEGDA ) ;

            excute( mConnection, function ) ;

            Vector<E18HospitalListData> ret = getTable(E18HospitalListData.class, function, "T_RESULT_CHK");

            for( int i = 0 ; i < ret.size() ; i++ ) {
                E18HospitalListData data = ( E18HospitalListData ) ret.get( i ) ;

                if( data.WAERS.equals("KRW") ) {          // KRW�� ��쿡�� 100�� ���Ѵ�.
                    data.EMPL_WONX = Double.toString( Double.parseDouble( data.EMPL_WONX ) * 100.0 ) ;  // ���γ��ξ�
                    data.COMP_WONX = Double.toString( Double.parseDouble( data.COMP_WONX ) * 100.0 ) ;  // ȸ��������
                    data.YTAX_WONX = Double.toString( Double.parseDouble( data.YTAX_WONX ) * 100.0 ) ;  // ��������ݿ���
                    data.RFUN_AMNT = Double.toString( Double.parseDouble( data.RFUN_AMNT ) * 100.0 ) ;  // �ݳ���
                }
            }

            return ret;

        } catch( Exception ex ) {
            //Logger.sap.println( this, " SAPException : " + ex.toString() ) ;
            throw new GeneralException( ex ) ;
        } finally {
            close( mConnection ) ;
        }
    }


}
