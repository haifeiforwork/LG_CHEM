package hris.C.C02Curri.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;
import com.sap.mw.jco.*;

import hris.C.C02Curri.*;

/**
 * C02CurriFileDownRFC.java
 * �������� �������ϸ� �������� RFC�� ȣ���ϴ� Class
 *
 * @author �ڿ���   
 * @version 1.0, 2002/01/14
 */
public class C02CurriFileDownRFC extends SAPWrap {

    private String functionName = "ZHRS_RFC_OPEN_FILES";

    /**
     * �������� ������ũ�� �������� RFC�� ȣ���ϴ� Method
     * @param java.lang.String
     * @return java.lang.String
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getFile( String P_PHIO_ID, String P_STOR_CAT ) throws GeneralException {
        
        JCO.Client mConnection = null;
        
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            
            setInput( function, P_PHIO_ID, P_STOR_CAT );
            excute(mConnection, function);
            return getOutput(function);
        } catch(Exception ex) {
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
     * @param entity java.lang.Object
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String key1, String key2) throws GeneralException{
        String fieldName = "P_PHIO_ID";
        setField(function, fieldName, key1);
        String fieldName2 = "P_STOR_CAT";
        setField(function, fieldName2, key2);
    }

    /**
     * RFC ������ Export ���� Vector �� Return �Ѵ�.
     * �ݵ�� com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ����Ŀ� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    protected Vector getOutput(JCO.Function function ) throws GeneralException{
        Vector retvt = new Vector();
        try{
            JCO.Table table = function.getTableParameterList().getTable("G_CONTENT_BIN");
            JCO.Table table1 = function.getTableParameterList().getTable("G_CONTENT_CHAR");

            if( table.getNumRows() > 0 ) {
                String temp = "BINARY";
                retvt.addElement(temp);
                for (int i = 0; i < table.getNumRows(); i++) {
                    table.setRow(i);

                    byte[] data = table.getByteArray("LINE");

                    retvt.addElement(data);
                }
            } else {
                String temp = "CHAR";
                retvt.addElement(temp);
                for (int i = 0; i < table1.getNumRows(); i++) {
                    table.setRow(i);

                    String data = table1.getString("LINE");

                    retvt.addElement(data);
                }
            }
            Logger.debug.println(this, retvt.toString());
        } catch ( Exception ex ){
            Logger.debug.println(this, "getTable(String entityName, JCO.Function function, String functionName)���� ���ܹ߻� " );
            Logger.debug.println(this, "entityName�� Package ��ΰ� �����־���� .. Ȯ�ο� " );
            throw new GeneralException(ex);
        }
        return retvt;
    }
}



    