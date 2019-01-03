package	hris.C.C04Ftest.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;

import hris.C.C04Ftest.*;

/**
 * PlanguageRFC.java
 * ���а��� ��ҿ� ���� ������ �������� RFC�� ȣ���ϴ� Class
 *
 * @author ������
 * @version 1.0, 2002/01/04
 */
public class PlanguageRFC extends SAPWrap {

    private String functionName = "ZHRE_RFC_P_LANGUAGE_LIST";

    /**
     * ���а��� ��ҿ� ���� ������ �������� RFC�� ȣ���ϴ� Method
     * @param  java.lang.String ȸ���ڵ�  java.lang.String ������ �����ڵ�  
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getPlanguage(String p_burks, String p_lang_code) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, p_burks, p_lang_code);
            
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
     * @param function com.sap.mw.jco.JCO.Function java.lang.String ȸ���ڵ�  java.lang.String ������ �����ڵ�  
     * @exception com.sns.jdf.GeneralException
     */
   private void setInput(JCO.Function function, String p_burks, String p_lang_code) throws GeneralException {
      String fieldName1 = "P_BUKRS"          ;
      setField(function, fieldName1, p_burks);

      String fieldName2 = "P_LANG_CODE"          ;
      setField(function, fieldName2, p_lang_code);
           
    }

    /**
     * RFC ������ Export ���� Vector �� Return �Ѵ�.
     * �ݵ�� com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ����Ŀ� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
     private Vector getOutput(JCO.Function function) throws GeneralException {
        String tableName = "P_RESULT";      // RFC Export ������� ����
        return getCodeVector( function, tableName);
    }
}


