package	hris.D.D11TaxAdjust.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;

import hris.A.A12Family.*;

/**
 * D11FamilyRelationRFC.java
 * ���� ���� �ڵ�, ���� �������� RFC�� ȣ���ϴ� Class
 *
 * @author �赵��
 * @version 1.0, 2002/02/04
 */
public class D11FamilyRelationRFC extends SAPWrap {

    private static String functionName = "ZSOLYR_RFC_RELATION_PE";

    /**
     * ���� ���� �ڵ�, ���� �������� RFC�� ȣ���ϴ� Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getFamilyRelation( String subty ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            setField( function, "I_SUBTY", subty ); 
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
        String tableName = "TAB";
        return getCodeVector(function, tableName);
    }
}