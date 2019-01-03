package hris.D.D11TaxAdjust.rfc ;

import java.util.* ;

import com.sap.mw.jco.* ;
import com.sns.jdf.* ;
import com.sns.jdf.sap.* ;
import com.sns.jdf.util.* ;

import hris.D.D11TaxAdjust.* ;

/**
 * D11TaxAdjustPersonRFC.java
 * �������� - �������� ��ȸ RFC�� ȣ���ϴ� Class
 *
 * @author �赵��
 * @version 1.0, 2002/11/20
* @version 2.0, 2013/12/10  CSR ID :C20140106_63914 �Ѻθ����߰�
 */
public class D11TaxAdjustPersonRFC extends SAPWrap {

    private String functionName = "ZSOLYR_RFC_YEAR_PERSON" ;

    /**
     * �������� - �������� ��ȸ RFC ȣ���ϴ� Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getPerson( String empNo, String targetYear ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, empNo, targetYear, "1");
            excute(mConnection, function);

            Vector ret = getOutput(function);

            for( int i = 0 ; i < ret.size() ; i++ ){
                D11TaxAdjustPersonData data = (D11TaxAdjustPersonData)ret.get(i);

                if(data.BETRG01.equals("")){ data.BETRG01=""; }else{ data.BETRG01=Double.toString(Double.parseDouble(data.BETRG01) * 100.0); }  // �⺻����
                if(data.BETRG02.equals("")){ data.BETRG02=""; }else{ data.BETRG02=Double.toString(Double.parseDouble(data.BETRG02) * 100.0); }  // ��ο��
                if(data.BETRG03.equals("")){ data.BETRG03=""; }else{ data.BETRG03=Double.toString(Double.parseDouble(data.BETRG03) * 100.0); }  // �����
                if(data.BETRG04.equals("")){ data.BETRG04=""; }else{ data.BETRG04=Double.toString(Double.parseDouble(data.BETRG04) * 100.0); }  // �γ���
                if(data.BETRG05.equals("")){ data.BETRG05=""; }else{ data.BETRG05=Double.toString(Double.parseDouble(data.BETRG05) * 100.0); }  // �ڳ������
                if(data.BETRG06.equals("")){ data.BETRG06=""; }else{ data.BETRG06=Double.toString(Double.parseDouble(data.BETRG06) * 100.0); }  // CSR ID:1361257 ��ꡤ�Ծ�
                if(data.BETRG07.equals("")){ data.BETRG07=""; }else{ data.BETRG07=Double.toString(Double.parseDouble(data.BETRG07) * 100.0); }  // CSR ID:C20140106_63914 �Ѻθ���
            }

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
     * �������� - �������� �Է� RFC ȣ���ϴ� Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public void build( String empNo, String targetYear, Vector person_vt ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, empNo, targetYear, "5");

            setInput(function, person_vt, "O_RESULT");

            excute(mConnection, function);

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
    private void setInput(JCO.Function function, String empNo, String targetYear, String conftype) throws GeneralException {
        String fieldName1 = "I_PERNR";
        setField( function, fieldName1, empNo );
        String fieldName2 = "I_YEAR";
        setField( function, fieldName2, targetYear );
        String fieldName3 = "I_BEGDA";
        setField( function, fieldName3, "" );
        String fieldName4 = "I_ENDDA";
        setField( function, fieldName4, "" );
        String fieldName5 = "P_CONF_TYPE";
        setField( function, fieldName5, conftype );
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
        String entityName = "hris.D.D11TaxAdjust.D11TaxAdjustPersonData";
        String tableName  = "O_RESULT";

        return getTable(entityName, function, tableName);
    }
}