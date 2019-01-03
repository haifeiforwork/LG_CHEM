package hris.A.A18Deduct.rfc;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;

import java.util.Vector;

/**
 * A18GuenTypeRFC.java
 * ��õ¡�� ������, ���� ���� �����͸� �������� RFC�� ȣ���ϴ� Class
 *
 * @author  �赵��
 * @version 1.0, 2002/10/22
 */
public class A18GuenTypeRFC extends SAPWrap {

    private String functionName = "ZGHR_RFC_GUEN_TYPE_F4";

    /**
     * ����,����� ���� �����͸� �������� RFC�� ȣ���ϴ� Method
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

