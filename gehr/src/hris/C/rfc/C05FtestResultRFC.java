package	hris.C.rfc;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;
import hris.C.C05FtestResult1Data;

import java.util.Vector;

/**
 * C05FtestResultRFC.java
 * ������ ���дɷ� ������ �������� RFC�� ȣ���ϴ� Class
 *
 * @author �赵��
 * @version 1.0, 2002/01/14
 */
public class C05FtestResultRFC extends SAPWrap {

    private String functionName = "ZGHR_RFC_LANGUAGE_ABILITY";

    /**
     * ������ ���дɷ� ������ �������� RFC�� ȣ���ϴ� Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector<C05FtestResult1Data> getFtestResult(String I_PERNR, String I_CFORM) throws GeneralException {
    
        JCO.Client mConnection = null;
        
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;


            setField(function, "I_PERNR", I_PERNR);
            setField(function, "I_CFORM", I_CFORM);

            excute(mConnection, function);

            return getTable(C05FtestResult1Data.class, function, "T_LIST");

        } catch(Exception ex){
            Logger.sap.println(this, " SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

}