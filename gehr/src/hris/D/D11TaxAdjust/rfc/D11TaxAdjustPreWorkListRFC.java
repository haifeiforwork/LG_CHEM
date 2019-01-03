package hris.D.D11TaxAdjust.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;

import hris.D.D11TaxAdjust.*;

/**
 * D11TaxAdjustPreWorkListRFC.java
 * ���ٹ��� ��ȣ possible entry�� ������� RFC�� ȣ���ϴ� Class                        
 *
 * @author  �赵��
 * @version 1.0, 2005/12/01
 */
public class D11TaxAdjustPreWorkListRFC extends SAPWrap {

    private String functionName = "ZSOLYR_RFC_YEAR_PRE_WORK_PE1";

    /**
     * ���ٹ��� ��ȣ possible entry RFC ȣ���ϴ� Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getEntry() throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            //setInput(function, i_bukrs);
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
        String tableNamem = "RESULT";
        return getCodeVector( function, tableNamem, "BIZNO", "COMNM");
    }
}