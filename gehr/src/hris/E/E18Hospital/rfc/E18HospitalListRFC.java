package hris.E.E18Hospital.rfc ;

import java.util.* ;

import com.sap.mw.jco.* ;
import com.sns.jdf.* ;
import com.sns.jdf.sap.* ;
import com.sns.jdf.util.* ;

import hris.E.E18Hospital.* ;

/**
 * E18HospitalListRFC.java
 *  ����� �Ƿ�� ������ �������� RFC�� ȣ���ϴ� Class
 *
 * @author �Ѽ���
 * @version 1.0, 2002/01/03
 */
public class E18HospitalListRFC extends SAPWrap {

    //private String functionName = "ZHRW_RFC_MEDIC" ;
    private String functionName = "ZGHR_RFC_MEDIC" ;

    /**
     * ����� �Ƿ�� ������ �������� RFC�� ȣ���ϴ� Method
     *  @param     java.lang.String �����ȣ
     *  @return    java.util.Vector
     *  @exception com.sns.jdf.GeneralException
     */
    public Vector<E18HospitalListData> getHospitalList( String empNo ) throws GeneralException {
        JCO.Client mConnection = null ;

        try {
            mConnection = getClient() ;
            JCO.Function function = createFunction( functionName ) ;

            setInput( function, empNo ) ;
            excute( mConnection, function ) ;

            //String E_RETURN   = getReturn().MSGTY;
        	//String E_MESSAGE   = getReturn().MSGTX;

            Vector<E18HospitalListData> ret = getTable( E18HospitalListData.class, function, "T_RESULT" ); //getOutput( function ) ;

            for( int i = 0 ; i < ret.size() ; i++ ) {
                E18HospitalListData data = ( E18HospitalListData ) ret.get( i ) ;

                if( data.WAERS.equals("KRW") ) {          // KRW�� ��쿡�� 100�� ���Ѵ�.
                    data.EMPL_WONX = Double.toString( Double.parseDouble( data.EMPL_WONX ) * 100.0 ) ;  // ���γ��ξ�
                    data.COMP_WONX = Double.toString( Double.parseDouble( data.COMP_WONX ) * 100.0 ) ;  // ȸ��������
                    data.YTAX_WONX = Double.toString( Double.parseDouble( data.YTAX_WONX ) * 100.0 ) ;  // ��������ݿ���
                    data.RFUN_AMNT = Double.toString( Double.parseDouble( data.RFUN_AMNT ) * 100.0 ) ;  // �ݳ���
                }
            }

            return ret ;
        } catch( Exception ex ) {
            //Logger.sap.println( this, " SAPException : " + ex.toString() ) ;
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
        String fieldName = "I_PERNR" ;
        setField( function, fieldName, empNo ) ;
    }


}
