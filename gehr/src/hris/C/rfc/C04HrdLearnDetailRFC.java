package hris.C.rfc ;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;
import hris.C.C03LearnDetailData;

import java.util.Vector;
 
/**
 * C04HrdLearnDetailRFC.java
 * HRD시스템에서 사용하고 있는 사원의 교육 이력 사항을 가져오는 RFC를 호출하는 Class
 *
 * @author lsa
 * @version 1.0, 2008/08/12
 */
public class C04HrdLearnDetailRFC extends SAPWrap {

    private String functionName = "ZGHR_RFC_TRAINING_LIST" ;

    public Vector<C03LearnDetailData> getTrainingList( String I_PERNR, String I_BEGDA, String I_ENDDA, String I_PRVENT, String I_CFORM) throws GeneralException {
        JCO.Client mConnection = null ;

        try {
            mConnection = getClient() ;
            JCO.Function function = createFunction( functionName ) ;

            setField(function, "I_PERNR", I_PERNR);
            setField(function, "I_BEGDA", I_BEGDA);
            setField(function, "I_ENDDA", I_ENDDA);
            setField(function, "I_PRVENT", I_PRVENT);   //입사전 교육이력 'X'
            setField(function, "I_CFORM", I_CFORM);

            excute( mConnection, function ) ;

            return getTable(C03LearnDetailData.class, function, "T_LIST");

        } catch( Exception ex ) {
            Logger.sap.println( this, " SAPException : " + ex.toString() ) ;
            throw new GeneralException( ex ) ;
        } finally {
            close( mConnection ) ;
        }
    }

    public Vector<C03LearnDetailData> getTrainingList( String I_PERNR, String I_CFORM, String I_CFMAN) throws GeneralException {
        JCO.Client mConnection = null ;

        try {
            mConnection = getClient() ;
            JCO.Function function = createFunction( functionName ) ;

            setField(function, "I_PERNR", I_PERNR);
            setField(function, "I_CFORM", I_CFORM);
            if(I_CFMAN != null) setField(function, "I_CFMAN", I_CFMAN);
            /*if("X".equals(I_CFORM)) setField(function, "I_CFMAN", "X");*/



            excute( mConnection, function ) ;

            return getTable(C03LearnDetailData.class, function, "T_LIST");

        } catch( Exception ex ) {
            Logger.sap.println( this, " SAPException : " + ex.toString() ) ;
            throw new GeneralException( ex ) ;
        } finally {
            close( mConnection ) ;
        }
    }

}
