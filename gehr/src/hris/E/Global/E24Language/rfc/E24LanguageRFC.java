package hris.E.Global.E24Language.rfc;

import hris.E.Global.E24Language.E24LanguageData;

import java.util.Vector;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;

public class E24LanguageRFC extends SAPWrap {
	//private String functionName = "ZHR_RFC_LANGUAGE_FEE_DISPLAY";
	private String functionName = "ZGHR_RFC_LANGUAGE_FEE_DISPLAY";

    public Vector getLanguageList(String keycode) throws GeneralException {

        JCO.Client mConnection = null;
        Vector<E24LanguageData> resultList = null;

        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, keycode);

            excute(mConnection, function);

            //Vector ret = getOutput(function);

            /** º¯°æ **/
            resultList = getTable(E24LanguageData.class, function, "T_ITAB");

            return resultList;
        } catch(Exception ex){
            //Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    private void setInput(JCO.Function function, String keycode) throws GeneralException {
        String fieldName1 = "I_PERNR"            ;
        setField(function, fieldName1, keycode);
    }

    /*private Vector getOutput(JCO.Function function) throws GeneralException {
        String entityName = "hris.E.Global.E24Language.E24LanguageData";
        String tableName  = "T_ITAB";
        return getTable(entityName, function, tableName);
    }*/
}
