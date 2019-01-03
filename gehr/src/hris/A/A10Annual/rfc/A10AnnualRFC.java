package hris.A.A10Annual.rfc;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;
import hris.A.A10Annual.A10AnnualData;

import java.util.Vector;

/**
 * A10AnnualRFC.java
 * ������� List �� �������� RFC�� ȣ���ϴ� Class
 *
 * @author �ڿ���   
 * @version 1.0, 2002/01/10
 *  [CSR ID:3006173] �ӿ� ������༭ Onlineȭ�� ���� �ý��� ���� ��û
 *  2015/05/25 rdcamel 2018/05/21 [CSR ID:3687969] �λ��Ϻλ� �ؿܹ��θ� �ѱۺ��� ��û�� ��
 */
public class A10AnnualRFC extends SAPWrap {

    private String functionName = "ZGHR_RFC_ANNUAL_SALARY_KR";

    /**
     * ������� List �� �������� RFC�� ȣ���ϴ� Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getAnnualList( String I_PERNR ) throws GeneralException {
        
        JCO.Client mConnection = null;
        
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, I_PERNR);

            excute(mConnection, function);

            Vector ret = getOutput(function);
            for ( int i = 0; i<ret.size(); i++ ){
                A10AnnualData data = (A10AnnualData)ret.get(i);
                data.BETRG = Double.toString(Double.parseDouble( data.BETRG ) * 100.0 );
                data.BET01 = Double.toString(Double.parseDouble( data.BET01 ) * 100.0 );
                data.ANSAL = Double.toString(Double.parseDouble( data.ANSAL ) * 100.0 );
            }

            return ret;
        } catch(Exception ex) {
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }
    
    /**
     * ������� List �� �������� RFC�� ȣ���ϴ� Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     * @author rdcamel [CSR ID:3687969] �λ��Ϻλ� �ؿܹ��θ� �ѱۺ��� ��û�� ��
     */
    public Vector getAnnualListLong( String I_PERNR ) throws GeneralException {
        
        JCO.Client mConnection = null;
        
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, I_PERNR);
            setField(function, "I_ORGKR", "X");//�λ��Ϻ� �� �ؿܹ��θ� �ѱ� ǥ�õǵ��� flag(�ش� ���� ������ ���θ� ������)

            excute(mConnection, function);

            Vector ret = getOutput(function);
            for ( int i = 0; i<ret.size(); i++ ){
                A10AnnualData data = (A10AnnualData)ret.get(i);
                data.BETRG = Double.toString(Double.parseDouble( data.BETRG ) * 100.0 );
                data.BET01 = Double.toString(Double.parseDouble( data.BET01 ) * 100.0 );
                data.ANSAL = Double.toString(Double.parseDouble( data.ANSAL ) * 100.0 );
            }

            return ret;
        } catch(Exception ex) {
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    /**
     * 2004�� ������� �������� �������� RFC�� ȣ���ϴ� Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getAnnualDetail( String I_PERNR ) throws GeneralException {
        
        JCO.Client mConnection = null;
        
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            
            setInput(function, I_PERNR);

            excute(mConnection, function);

            Vector ret = getOutput1(function);
            for ( int i = 0; i<ret.size(); i++ ){
                A10AnnualData data = (A10AnnualData)ret.get(i);
                data.BETRG = Double.toString(Double.parseDouble( data.BETRG ) * 100.0 );
                data.BET01 = Double.toString(Double.parseDouble( data.BET01 ) * 100.0 );
                data.ANSAL = Double.toString(Double.parseDouble( data.ANSAL ) * 100.0 );
                data.TRFAR = Double.toString(Double.parseDouble( data.TRFAR ) * 100.0 );// [CSR ID:3006173]
            }

            return ret;
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
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String key1) throws GeneralException{
        String fieldName1 = "I_PERNR";
        setField(function, fieldName1, key1);
    }

    /**
     * RFC ������ Export ���� Vector �� Return �Ѵ�.
     * �ݵ�� com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ����Ŀ� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutput(JCO.Function function) throws GeneralException {
        String entityName = "hris.A.A10Annual.A10AnnualData";
        String tableName = "T_ANSAL";
        return getTable(entityName, function, tableName);
    }

    /**
     * RFC ������ Export ���� Vector �� Return �Ѵ�.
     * �ݵ�� com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ����Ŀ� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutput1(JCO.Function function) throws GeneralException {
        String entityName = "hris.A.A10Annual.A10AnnualData";
        String tableName = "T_ANSAL2";
        return getTable(entityName, function, tableName);
    }
}

