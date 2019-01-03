package hris.D.D12Rotation.rfc ;

import hris.D.D12Rotation.D12RotationCnData;
import java.util.* ;
import com.sap.mw.jco.* ;
import com.sns.jdf.* ;
import com.sns.jdf.sap.* ;

/**
 * D12RotationCnRFC.java
 * 일일 근태 조회(남경PI) RFC를 호출하는 Class
 * @author
 * @version
 */
public class D12RotationCnRFC extends SAPWrap {

    private String functionName = "ZGHR_RFC_GET_DWD_NJ" ;

    /**
     * 일일 근태 조회(남경PI) RFC를 호출하는 Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getRotation(String  I_ORGEH, String I_LOWERYN, String I_DATUM) throws GeneralException {

        JCO.Client mConnection = null;

        try{
            mConnection = getClient();
            JCO.Function function = createFunction( functionName ) ;

            setField(function, "I_ORGEH", I_ORGEH);
            setField(function, "I_LOWERYN", I_LOWERYN);
            setField(function, "I_DATUM", I_DATUM);

            excute( mConnection, function );
            return getTable(D12RotationCnData.class, function, "T_RESULT");
        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

}