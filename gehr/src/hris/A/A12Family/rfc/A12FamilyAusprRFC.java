/**
 *2018.01.04 cykim   [CSR ID:3569665] 2017�� �������� ��ȭ�� ���� ��û�� ��
 */
package	hris.A.A12Family.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;

import hris.A.A12Family.*;

/**
 * A12FamilySubTypeRFC.java
 * ������ Possible Entry RFC�� ȣ���ϴ� Class
 *
 * @author ���ֿ�
 * @version 1.0, 2018/01/04
 */
public class A12FamilyAusprRFC extends SAPWrap {

    private String functionName = "ZGHR_RFC_FAMILY_ORDER_PE";

    /**
     * ������ Possible Entry�� �������� RFC�� ȣ���ϴ� Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getFamilyAuspr() throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setField( function, "EIGSH", "2" );
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
        String tableName = "T_LIST";
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

        Logger.sap.println(this, "�ڳ�� : " + ret.toString());

        return ret;
    }
}