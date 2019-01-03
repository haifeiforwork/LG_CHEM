package hris.A.A18Deduct.rfc;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;

import java.util.Vector;

/**
 * A18GuenTypeRFC.java
 * 원천징수 영수증, 증명서 구분 데이터를 가져오는 RFC를 호출하는 Class
 *
 * @author  김도신
 * @version 1.0, 2002/10/22
 */
public class A18GuenTypeRFC extends SAPWrap {

    private String functionName = "ZGHR_RFC_GUEN_TYPE_F4";

    /**
     * 본인,배우자 구분 데이터를 가져오는 RFC를 호출하는 Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getGuenType() throws GeneralException {
        
        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            excute(mConnection, function);

            return getCodeVector(function, "T_RESULT", "GUEN_TYPE", "GUEN_TEXT");

        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

}

