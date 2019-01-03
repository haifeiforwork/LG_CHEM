package	hris.C.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;

import hris.C.*;

/**
 * C05FtestResultRFC.java
 * ������ ���дɷ� ������ �������� RFC�� ȣ���ϴ� Class
 * G-Mobile ���дɷ� ��ȸ RFC
 *
 * @author ������
 * @version 1.0, 2016-01-27
 * @[CSR ID:2991671] g-mobile �� �λ����� ��ȸ ��� �߰� ���� ��û
 */
public class C05FtestResultRFC2 extends SAPWrap {

    private String functionName = "ZHRE_RFC_LANGUAGE_ABILITY2";

    /**
     * ������ ���дɷ� ������ �������� RFC�� ȣ���ϴ� Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getFtestResult( String empNo, String gubun ) throws GeneralException {

        JCO.Client mConnection = null;

        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, empNo);
            excute(mConnection, function);

            Vector ret = null;

            if( gubun == "1" ) {            // ���дɷ�
              ret = getOutput1(function);
            } else if( gubun == "2" ) {     // ���дɷ� ���
              ret = getOutput2(function);
            }

            return ret;
        } catch(Exception ex){
            Logger.sap.println(this, " SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    /**
     * RFC �������� Import ���� setting �Ѵ�.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ��Ǳ� ���� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @param value java.lang.String ���
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String value) throws GeneralException {
        String fieldName = "P_PERNR";
        setField(function, fieldName, value);
    }

    /**
     * RFC ������ Export ���� Vector �� Return �Ѵ�.
     * �ݵ�� com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ����Ŀ� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutput1(JCO.Function function) throws GeneralException {
        String entityName = "hris.C.C05FtestResult1Data";
        String tableName  = "P_TOTL_RESULT";
        return getTable(entityName, function, tableName);
    }

    private Vector getOutput2(JCO.Function function) throws GeneralException {
        String entityName = "hris.C.C05FtestResult2Data";
        String tableName  = "P_STAT_RESULT";
        return getTable(entityName, function, tableName);
    }
}