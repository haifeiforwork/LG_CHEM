package hris.E.Global.E18Hospital.rfc ;

import java.util.* ;

import com.sap.mw.jco.* ;
import com.sns.jdf.* ;
import com.sns.jdf.sap.* ;
import com.sns.jdf.util.* ;

import hris.E.E18Hospital.* ;

/**
 * E18HospitalDetailRFC.java
 *  ����� �Ƿ�� �� ������ �������� RFC�� ȣ���ϴ� Class
 *
 * @author �Ѽ���
 * @version 1.0, 2002/01/03
 */
public class E18HospitalDetailRFC extends SAPWrap {

    private String functionName = "ZHRW_RFC_MEDIC_DETAIL" ;

    /**
     * ����� �Ƿ�� �� ������ �������� RFC�� ȣ���ϴ� Method
     *  @param     java.lang.String �����ȣ
     *             java.lang.String ������ȣ
     *  @return    java.util.Vector
     *  @exception com.sns.jdf.GeneralException
     */
    public Vector getHospitalDetail( String empNo, String CTRL_NUMB, String GUEN_CODE , String REGNO ) throws GeneralException {
        JCO.Client mConnection = null ;

        try {
            mConnection = getClient() ;
            JCO.Function function = createFunction( functionName ) ;

            setInput( function, empNo, CTRL_NUMB, GUEN_CODE,REGNO ) ;
            excute( mConnection, function ) ;

            Vector ret = getOutput( function ) ;

            for( int i = 0 ; i < ret.size() ; i++ ) {
                E18HospitalDetailData data = ( E18HospitalDetailData ) ret.get( i ) ;

                if( data.WAERS.equals("KRW") ) {          // KRW�� ��쿡�� 100�� ���Ѵ�.
                    data.EMPL_WONX = Double.toString( Double.parseDouble( data.EMPL_WONX ) * 100.0 ) ;  // ���� �ǳ��ξ�
                    if(data.YTAX_WONX.equals("")){ data.YTAX_WONX=""; }else{ data.YTAX_WONX=Double.toString(Double.parseDouble(data.YTAX_WONX) * 100.0 ) ; }  // ��������ݿ���
                }
            }

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
     * com.sns.jdf.SAPWrap.excute( JCO.Client mConnection, JCO.Function function ) �� ȣ��Ǳ� ���� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @exception      com.sns.jdf.GeneralException
     */
    private void setInput( JCO.Function function, String empNo, String CTRL_NUMB, String GUEN_CODE, String REGNO ) throws GeneralException {
        String fieldName = "PERNR" ;
        setField( function, fieldName, empNo ) ;
        String fieldNam1 = "CTRL_NUMB" ;
        setField( function, fieldNam1, CTRL_NUMB ) ;
        String fieldNam2 = "GUEN_CODE" ;
        setField( function, fieldNam2, GUEN_CODE ) ;
        String fieldNam3 = "REGNO" ;
        setField( function, fieldNam3, REGNO ) ;
    }

    /**
     * RFC ������ Export ���� Vector �� Return �Ѵ�.
     * �ݵ�� com.sns.jdf.SAPWrap.excute( JCO.Client mConnection, JCO.Function function ) �� ȣ����Ŀ� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @return         java.util.Vector
     * @exception      com.sns.jdf.GeneralException
     */
    private Vector getOutput( JCO.Function function ) throws GeneralException {
        String entityName = "hris.E.E18Hospital.E18HospitalDetailData" ;
        String tableName  = "RESULT" ;

        return getTable( entityName, function, tableName ) ;
    }

}
