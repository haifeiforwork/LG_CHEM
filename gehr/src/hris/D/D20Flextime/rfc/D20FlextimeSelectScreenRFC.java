package	hris.D.D20Flextime.rfc;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;

/**
 * D20FlextimeSelectScreenRFC.java
 * Flextime(부분/완전선택근무제) 화면구분 RFC를 호출하는 Class
 * 2017-05-09  성환희    [WorkTime52] 부분/완전선택 근무제 변경
 * @author 성환희
 * @version 1.0, 2018/05/09
 */
public class D20FlextimeSelectScreenRFC extends SAPWrap {

    private String functionName = "ZGHR_RFC_NTM_FLEXTIME_SCREEN";

    /**
     * Flextime(부분/완전선택근무제) 화면구분 RFC를 호출하는 Method
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