package hris.E.E17Hospital.rfc;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;
import com.sns.jdf.util.CodeEntity;

import java.util.Vector;

/**
 * E17MedicTreaRFC.java
 * ����� �����͸� �������� RFC�� ȣ���ϴ� Class
 *
 * @author lsa
 * @version 1.0, 2006/02/23
 */
public class E17MedicTreaRFC extends SAPWrap {

    private String functionName = "ZGHR_RFC_P_MEDIC_TREA";

    /**
     * ����� �����͸� �������� RFC�� ȣ���ϴ� Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector<CodeEntity> getMedicTrea() throws GeneralException {
        
        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            excute(mConnection, function);

            return getCodeVector( function,"T_EXPORT");

        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

}

