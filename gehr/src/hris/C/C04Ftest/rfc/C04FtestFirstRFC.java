package	hris.C.C04Ftest.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;

import hris.C.C04Ftest.*;

/**
 * C04FtestFirstRFC.java
 * ���дɷ� ���� ������ �������� class
 *
 * @author ������
 * @version 1.0, 2002/01/04
 */
public class C04FtestFirstRFC extends SAPWrap {

    private String functionName = "ZHRE_RFC_LANGUAGE_FIRST";

    /**
     * ���дɷ����� ������ �������� RFC�� ȣ���ϴ� Method
     * @param java.lang.String�����ȣ java.lang.String �����ڵ�
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getFtestFirst(String empNo, String lang_code) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, empNo, lang_code);
            
            excute(mConnection, function);
            
            Vector ret = getOutput(function);
            Logger.debug.println(this, "ret"+ret.toString());
            return ret;
        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }
    
 
    /**
     * RFC �������� Import ���� setting �Ѵ�.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ��Ǳ� ���� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function java.lang.String java.lang.String
     * @param entityVector java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
   private void setInput(JCO.Function function, String empNo, String lang_code) throws GeneralException {
        String fieldName1 = "PERNR"          ;
        setField(function, fieldName1, empNo);

        String fieldName2 = "LANG_CODE"          ;
        setField(function, fieldName2, lang_code);
           
    }

    /**
     * RFC ������ Export ���� Vector �� Return �Ѵ�.
     * �ݵ�� com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ����Ŀ� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutput(JCO.Function function) throws GeneralException {
        String entityName = "hris.C.C04Ftest.C04FtestFirstData";
        String tableName  = "ITAB";
        return getTable(entityName, function, tableName);
    }
}
