package hris.E.E18Hospital.rfc ;

import java.util.* ;

import com.sap.mw.jco.* ;
import com.sns.jdf.* ;
import com.sns.jdf.sap.* ;
import com.sns.jdf.util.* ;

import hris.E.E18Hospital.* ;

/**
 * E18BillDetailRFC.java
 *  ����� ����� ��꼭 ������ �������� RFC�� ȣ���ϴ� Class
 *
 * @author �Ѽ���
 * @version 1.0, 2002/01/03
 */
public class E18BillDetailRFC extends SAPWrap {

    //private String functionName = "ZHRW_RFC_MEDIC_BILL" ;
    private String functionName = "ZGHR_RFC_MEDIC_BILL" ;

    /**
     * ����� ����� ��꼭 ������ �������� RFC�� ȣ���ϴ� Method
     *  @param     java.lang.String �����ȣ
     *             java.lang.String ������ȣ
     *             java.lang.String ��������ȣ
     *  @return    java.util.Vector
     *  @exception com.sns.jdf.GeneralException
     */
    public Vector getBillDetail( String empNo, String CTRL_NUMB, String RCPT_NUMB, String GUEN_CODE ) throws GeneralException {
        JCO.Client mConnection = null ;

        try {
            mConnection = getClient() ;
            JCO.Function function = createFunction( functionName ) ;

            setInput( function, empNo, CTRL_NUMB, RCPT_NUMB, GUEN_CODE ) ;
            excute( mConnection, function ) ;

            Vector ret = getTable( E18BillDetailData.class, function, "T_RESULT" );//getOutput( function ) ;

            for( int i = 0 ; i < ret.size() ; i++ ) {
                E18BillDetailData data = ( E18BillDetailData ) ret.get( i ) ;

                if( data.WAERS.equals("KRW") ) {          // KRW�� ��쿡�� 100�� ���Ѵ�.
                    data.TOTL_WONX = Double.toString( Double.parseDouble( data.TOTL_WONX ) * 100.0 ) ;  // �� �����
                    data.ASSO_WONX = Double.toString( Double.parseDouble( data.ASSO_WONX ) * 100.0 ) ;  // ���� �δ��
                    data.EMPL_WONX = Double.toString( Double.parseDouble( data.EMPL_WONX ) * 100.0 ) ;  // ���� �δ��
                    data.MEAL_WONX = Double.toString( Double.parseDouble( data.MEAL_WONX ) * 100.0 ) ;  // �Ĵ�
                    data.APNT_WONX = Double.toString( Double.parseDouble( data.APNT_WONX ) * 100.0 ) ;  // ���� �����
                    data.ROOM_WONX = Double.toString( Double.parseDouble( data.ROOM_WONX ) * 100.0 ) ;  // ��� ���Ƿ� ����
                    data.CTXX_WONX = Double.toString( Double.parseDouble( data.CTXX_WONX ) * 100.0 ) ;  // C T
                    data.MRIX_WONX = Double.toString( Double.parseDouble( data.MRIX_WONX ) * 100.0 ) ;  // M R I
                    data.SWAV_WONX = Double.toString( Double.parseDouble( data.SWAV_WONX ) * 100.0 ) ;  // ������
                    data.DISC_WONX = Double.toString( Double.parseDouble( data.DISC_WONX ) * 100.0 ) ;  // ���αݾ�
                    data.ETC1_WONX = Double.toString( Double.parseDouble( data.ETC1_WONX ) * 100.0 ) ;  // ��Ÿ1 �� �ݾ�
                    data.ETC2_WONX = Double.toString( Double.parseDouble( data.ETC2_WONX ) * 100.0 ) ;  // ��Ÿ2 �� �ݾ�
                    data.ETC3_WONX = Double.toString( Double.parseDouble( data.ETC3_WONX ) * 100.0 ) ;  // ��Ÿ3 �� �ݾ�
                    data.ETC4_WONX = Double.toString( Double.parseDouble( data.ETC4_WONX ) * 100.0 ) ;  // ��Ÿ4 �� �ݾ�
                    data.ETC5_WONX = Double.toString( Double.parseDouble( data.ETC5_WONX ) * 100.0 ) ;  // ��Ÿ5 �� �ݾ�
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
    private void setInput( JCO.Function function, String empNo, String CTRL_NUMB, String RCPT_NUMB, String GUEN_CODE ) throws GeneralException {
        String fieldName = "I_PERNR" ;
        setField( function, fieldName, empNo ) ;
        String fieldNam1 = "I_CTRL_NUMB" ;
        setField( function, fieldNam1, CTRL_NUMB ) ;
        String fieldNam2 = "I_RCPT_NUMB" ;
        setField( function, fieldNam2, RCPT_NUMB ) ;
        String fieldNam3 = "I_GUEN_CODE" ;
        setField( function, fieldNam3, GUEN_CODE ) ;
    }

    /**
     * RFC ������ Export ���� Vector �� Return �Ѵ�.
     * �ݵ�� com.sns.jdf.SAPWrap.excute( JCO.Client mConnection, JCO.Function function ) �� ȣ����Ŀ� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @return         java.util.Vector
     * @exception      com.sns.jdf.GeneralException
     */
    private Vector getOutput( JCO.Function function ) throws GeneralException {
        //String entityName = "hris.E.E18Hospital.E18BillDetailData" ;
        //String tableName  = "RESULT" ;

        return getTable( E18BillDetailData.class, function, "T_RESULT" ) ;
    }

}
