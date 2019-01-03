package hris.E.E17Hospital.rfc ;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;
import com.sns.jdf.util.CodeEntity;

import java.util.Vector;

/**
 * E17RcptCodeRFC.java
 *  영수증 구분 Code를 가져오는 RFC를 호출하는 Class
 *
 * @author 김성일
 * @version 1.0, 2002/01/09
 */
public class E17RcptCodeRFC extends SAPWrap {

    private String functionName = "ZGHR_RFC_RCPT_CODE";             //  ZHRS044S

    /**
     * 영수증 구분 Code를 가져오는 RFC를 호출하는 Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector<CodeEntity> getRcptCode() throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            excute(mConnection, function);

            return getCodeVector( function, "T_RESULT");
        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }
}


