package	hris.D.D20Flextime.rfc;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;

/**
 * D20FlextimeSelectScreenRFC.java
 * Flextime(�κ�/�������ñٹ���) ȭ�鱸�� RFC�� ȣ���ϴ� Class
 * 2017-05-09  ��ȯ��    [WorkTime52] �κ�/�������� �ٹ��� ����
 * @author ��ȯ��
 * @version 1.0, 2018/05/09
 */
public class D20FlextimeSelectScreenRFC extends SAPWrap {

    private String functionName = "ZGHR_RFC_NTM_FLEXTIME_SCREEN";

    /**
     * Flextime(�κ�/�������ñٹ���) ȭ�鱸�� RFC�� ȣ���ϴ� Method
     * @return String
     * @exception com.sns.jdf.GeneralException
     */
    public String getE_SCREEN(String I_PERNR, String I_AINF_SEQN) throws GeneralException {

    	JCO.Client mConnection = null ;

        try {
            mConnection = getClient() ;
            JCO.Function function = createFunction( functionName ) ;

            setField(function, "I_PERNR", I_PERNR);
            if(I_AINF_SEQN != null) setField(function, "I_AINF_SEQN", I_AINF_SEQN);

            excute(mConnection, function) ;

            return getField( "E_SCREEN", function ) ;

        } catch( Exception ex ) {
            Logger.sap.println( this, " SAPException : " + ex.toString() ) ;
            throw new GeneralException( ex ) ;
        } finally {
            close( mConnection ) ;
        }
    }
}