package hris.A.rfc;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;
import hris.A.A07PunishResultData;

import java.util.Vector;

/**
 * PunishRFC.java
 * ¡�������� �������� RFC�� ȣ���ϴ� Class
 *[CSR ID:2703351] ¡�� ���� �߰� ����
 * @author ������   
 * @version 1.0, 2001/12/17
 */
public class A07PunishResultRFC extends SAPWrap {

    private String functionName = "ZGHR_RFC_DISCIPLINARY_LIST";

    /**
     * ¡�������� �������� RFC�� ȣ���ϴ� Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector<A07PunishResultData> getPunish(String I_PERNR, String I_CFORM) throws GeneralException {
        
        JCO.Client mConnection = null;
        
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setField(function, "I_PERNR", I_PERNR);
            setField(function, "I_CFORM", I_CFORM);

            excute(mConnection, function);

            return getTable(A07PunishResultData.class, function, "T_LIST");

        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    public Vector<A07PunishResultData> getPunish(String I_PERNR, String I_CFORM, String IM_FLAG) throws GeneralException {

        JCO.Client mConnection = null;

        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setField(function, "I_PERNR", I_PERNR);
            setField(function, "I_CFORM", I_CFORM);
            setField(function, "IM_FLAG", IM_FLAG);

            excute(mConnection, function);

            return getTable(A07PunishResultData.class, function, "T_LIST");

        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

}


