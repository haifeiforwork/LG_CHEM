package hris.D.D11TaxAdjust.rfc ;

import java.util.* ;

import com.sap.mw.jco.* ;
import com.sns.jdf.* ;
import com.sns.jdf.sap.* ;
import com.sns.jdf.util.* ;

import hris.D.D11TaxAdjust.* ;

/**
 * D11TaxAdjustRentTypeRFC.java
 * �������� - ����  Ÿ�� ��ȸ RFC�� ȣ���ϴ� Class
 *
 * @author jieun lee
 * @version 1.0, 1.0, 2014/12/15
 */
public class D11TaxAdjustRentTypeRFC extends SAPWrap {

    private String functionName = "ZSOLYR_RFC_YEAR_MON_RENT_PE" ;

    /**
     * ������������ �������� RFC�� ȣ���ϴ� Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getRentType() throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

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
        String tableName = "RESULT";
        return getCodeVector(function, tableName);
    }
}