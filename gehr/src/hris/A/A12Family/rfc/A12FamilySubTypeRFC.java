package	hris.A.A12Family.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;

import hris.A.A12Family.*;

/**
 * A12FamilySubTypeRFC.java
 * ���� ���� �ڵ�, ���� �������� RFC�� ȣ���ϴ� Class
 *
 * @author �赵��
 * @version 1.0, 2001/12/26
 */
public class A12FamilySubTypeRFC extends SAPWrap {

    private String functionName = "HR_GET_ESS_SUBTYPES";

    /**
     * ���� ���� �ڵ�, ���� �������� RFC�� ȣ���ϴ� Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getFamilySubType() throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setField( function, "INFTY", "0021" );
            setField( function, "MOLGA", "41" );
            excute(mConnection, function);
            Vector ret = getOutput(function);
            
            return ret;
        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    /**
     * RFC ������ Export ���� Vector �� Return �Ѵ�.
     * �ݵ�� com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ����Ŀ� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutput(JCO.Function function) throws GeneralException {
        String tableName = "SUBTYTAB";
        Vector ret       = new Vector();
        Vector temp_vt   = getCodeVector(function, tableName);

        for( int i=0 ; i < temp_vt.size() ; i++ ) {
            com.sns.jdf.util.CodeEntity ck = (com.sns.jdf.util.CodeEntity)temp_vt.get(i);
            
            //if( ck.code.equals("8") ) {
                // ������ ���ܽ�Ų��.
           // } else {
                ret.addElement(ck);
           // }
        }
        
        Logger.sap.println(this, "��������(��������) : " + ret.toString());
        
        return ret;
    }
}