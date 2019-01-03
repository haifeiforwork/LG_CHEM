package hris.common.rfc;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;
import hris.common.UpmuCode;

import java.util.Vector;

/**
 * UpmuCodeRFC.java
 * �����ڵ� �������� RFC�� ȣ���ϴ� Class
 *
 * @author �輺��   
 * @version 1.0, 2001/12/13
 */
public class UpmuCodeRFC extends SAPWrap {

    private String functionName = "ZGHR_RFC_UPMU_F4";

    /**
     *  �����ڵ� �������� RFC�� ȣ���ϴ� Method
     *  @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector<UpmuCode> getUpmuCode(String I_BUKRS, String I_PERNR) throws GeneralException {
        
        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setField(function, "I_BUKRS", I_BUKRS);
            setField(function, "I_PERNR", I_PERNR);

            excute(mConnection, function);

            return getTable(UpmuCode.class, function, "T_RESULT");
        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

}


