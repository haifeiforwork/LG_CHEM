package hris.C.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;
import com.sap.mw.jco.*;

import hris.C.C07Language.*;

/**
 * C08LanguageListRFC.java
 * ���������� ��ȸ RFC �� ȣ���ϴ� Class                        
 *
 * @author  �赵��
 * @version 1.0, 2003/04/15
 */
public class C08LanguageListRFC extends SAPWrap {

    private String functionName = "ZHRE_RFC_LANGUAGE_SUPP_LIST";

    /**
     * ��������ȸ RFC ȣ���ϴ� Method
     * @param empNo java.lang.String �����ȣ
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getLangList( String empNo ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, empNo);
            excute(mConnection, function);
            Vector ret = getOutput(function);

            for ( int i = 0 ; i < ret.size() ; i++ ) {
                C07LanguageData data = (C07LanguageData)ret.get(i);
                
                data.SETL_WONX = Double.toString(Double.parseDouble(data.SETL_WONX) * 100.0 ) ;  // �����ݾ�
                data.CMPY_WONX = Double.toString(Double.parseDouble(data.CMPY_WONX) * 100.0 ) ;  // ȸ�������ݾ�
            }
            
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
     * @param function com.sap.mw.jco.JCO.Function
     * @param empNo java.lang.String �����ȣ
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String empNo) throws GeneralException {
        String fieldName = "PERNR";
        setField( function, fieldName, empNo );
    }

    /**
     * RFC ������ Export ���� Vector �� Return �Ѵ�.
     * �ݵ�� com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ����Ŀ� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutput(JCO.Function function) throws GeneralException {
        String entityName = "hris.C.C07Language.C07LanguageData";
        String tableName = "RESULT";
        return getTable(entityName, function, tableName);
    }
}


