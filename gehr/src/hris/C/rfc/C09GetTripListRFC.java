package hris.C.rfc;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;
import hris.C.C09GetTripListData;

import java.util.Vector;

/**
 * C04HrdLearnDetailRFC.java
 * HRD시스템에서 사용하고 있는 사원의 교육 이력 사항을 가져오는 RFC를 호출하는 Class
 *
 * @author lsa
 * @version 1.0, 2008/08/12
 */
public class C09GetTripListRFC extends SAPWrap {

    private String functionName = "ZGHR_RFC_GET_TRIP_LIST" ;

    public Vector<C09GetTripListData> getTripList(String I_PERNR) throws GeneralException {
        JCO.Client mConnection = null ;

        try {
            mConnection = getClient() ;
            JCO.Function function = createFunction( functionName ) ;

            setField(function, "I_PERNR", I_PERNR);

            excute( mConnection, function ) ;

            return getTable(C09GetTripListData.class, function, "T_LIST");

        } catch( Exception ex ) {
            Logger.sap.println( this, " SAPException : " + ex.toString() ) ;
            throw new GeneralException( ex ) ;
        } finally {
            close( mConnection ) ;
        }
    }



}
