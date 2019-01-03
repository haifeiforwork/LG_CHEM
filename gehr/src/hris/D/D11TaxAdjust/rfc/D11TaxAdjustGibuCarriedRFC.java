package hris.D.D11TaxAdjust.rfc ;

import java.util.* ;

import com.sap.mw.jco.* ;
import com.sns.jdf.* ;
import com.sns.jdf.sap.* ;
import com.sns.jdf.util.* ;

import hris.D.D11TaxAdjust.* ;

/**
 * D11TaxAdjustGibuCarriedRFC.java
 * �������� - �̿� ��α� ���� list RFC�� ȣ���ϴ� Class
 *
 * @author  rdcamel
 * @version 1.0, 2018/01/05 [CSR ID:3569665] 2017�� �������� ��ȭ�� ���� ��û�� ��
 */
public class D11TaxAdjustGibuCarriedRFC extends SAPWrap {

    private static String functionName = "ZSOLYR_RFC_YEAR_DON_CARRIED" ;
 
    /**
     * �������� - �̿� ��α� ���� list RFC ȣ���ϴ� Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getGibuCarried( String empNo, String targetYear ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, empNo, targetYear );
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
     * RFC �������� Import ���� setting �Ѵ�.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ��Ǳ� ���� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String empNo, String targetYear) throws GeneralException {
    	String curDate  = DataUtil.removeStructur(DataUtil.getCurrentDate(),"-");
        String fieldName1 = "I_PERNR";
        setField( function, fieldName1, empNo );
        String fieldName2 = "I_ZYEAR";
        setField( function, fieldName2, targetYear );
        String fieldName3 = "I_DATUM";
        setField( function, fieldName3, curDate);
    }


    /**
     * RFC ������ Export ���� Vector �� Return �Ѵ�.
     * �ݵ�� com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ����Ŀ� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutput(JCO.Function function) throws GeneralException {
        String entityName = "hris.D.D11TaxAdjust.D11TaxAdjustGibuCarriedData";
        String tableName  = "DT_RESULT";

        return getTable(entityName, function, tableName);
    }
}
