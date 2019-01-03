package hris.J.J03JobCreate.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;
import com.sap.mw.jco.*;

import hris.J.J03JobCreate.*;

/**
 * J03FileDownLoadRFC.java
 * KSEA, Process PPT File�� �������� �ٿ�ε��ϴ� RFC�� ȣ���ϴ� Class
 *
 * @author  �赵��
 * @version 1.0, 2003/07/01
 */
public class J03FileDownLoadRFC extends SAPWrap {

    private String functionName = "ZHRH_RFC_PPT_DOWNLOAD";

    /**
     * KSEA, Process PPT File�� �������� �ٿ�ε��ϴ� RFC�� ȣ���ϴ� Method
     * @param java.lang.String
     * @return java.lang.String
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getFile(String i_gubun, String i_filename) throws GeneralException {
        
        JCO.Client mConnection = null;
        
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            
            setInput( function, i_gubun, i_filename );
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
    private void setInput(JCO.Function function, String i_gubun, String i_filename) throws GeneralException{
        String fieldName = "I_WK_KIND";
        setField(function, fieldName, i_gubun);
        String fieldName2 = "I_FILENAME";
        setField(function, fieldName2, i_filename);
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
            JCO.Table table = function.getTableParameterList().getTable("P_BITMAP");

            String temp = "BINARY";
            retvt.addElement(temp);
            for( int i = 0 ; i < table.getNumRows() ; i++ ) {
                table.setRow(i);

                byte[] data = table.getByteArray("LINE");

                retvt.addElement(data);
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



    