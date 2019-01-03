package hris.D.D11TaxAdjust.rfc ;

import java.util.* ;

import com.sap.mw.jco.* ;
import com.sns.jdf.* ;
import com.sns.jdf.sap.* ;
import com.sns.jdf.util.* ;

import hris.D.D11TaxAdjust.* ;

/**
 * D11TaxAdjustPePersonRFC.java
 * �������� - ���� ��ȸ RFC�� ȣ���ϴ� Class
 *          I_GUBUN :1 - ����� 2- �Ƿ��  3-������ 4-�ſ�ī��
 * @author l sa
 * @version 1.0, 2005/11/24
 */
public class D11TaxAdjustPePersonRFC extends SAPWrap {

    private String functionName = "ZSOLYR_RFC_YEAR_PERSON_PE" ;

    /**
     * �������� - �ξ簡������ ��ȸ RFC ȣ���ϴ� Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getPePerson(String Gubun , String empNo, String targetYear) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, Gubun,empNo,targetYear);
            excute(mConnection, function);
            Vector ret =  new Vector(); 
            ret = getOutput(function);
 
            return ret;

        } catch(GeneralException gex){
            // NO_DATA_FOUND ������ ����͸� ���� Object�� �����Ѵ�.com.sap.mw.jco.JCO$AbapException
            String exMsg = "com.sap.mw.jco.JCO$AbapException: (126) NO_DATA_FOUND: �ش� ���ڿ� INFOTYPE ���� ����";
            StackTraceElement[] stackTraceBuffer = gex.getStackTrace();
          
            if( exMsg.equals(stackTraceBuffer.toString( )) ){
                Vector ret = new Vector();
                return ret;
            } else {
                throw new GeneralException(gex);
            }
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
    private void setInput(JCO.Function function,   String conftype, String empNo, String targetYear) throws GeneralException {
        String fieldName1 = "I_GUBUN";
        setField( function, fieldName1, conftype );
        String fieldName2 = "I_PERNR";
        setField( function, fieldName2, empNo );
        String fieldName3 = "I_YEAR";
        setField( function, fieldName3, targetYear );
        String fieldName4 = "I_SAP";
        setField( function, fieldName4, "" );
    }

    // Import Parameter �� Vector(Table) �� ���
    /**
     * RFC �������� Import ���� setting �Ѵ�.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ��Ǳ� ���� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @param entityVector java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, Vector entityVector, String tableName) throws GeneralException {
        setTable(function, tableName, entityVector);
    }

    /**
     * RFC ������ Export ���� Vector �� Return �Ѵ�.
     * �ݵ�� com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ����Ŀ� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutput(JCO.Function function) throws GeneralException {
        String entityName = "hris.D.D11TaxAdjust.D11TaxAdjustPrePersonData";
        String tableName  = "O_RESULT";

        return getTable(entityName, function, tableName);
    }
}