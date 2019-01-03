package hris.D.D11TaxAdjust.rfc ;

import java.util.* ;

import com.sap.mw.jco.* ;
import com.sns.jdf.* ;
import com.sns.jdf.sap.* ;
import com.sns.jdf.util.* ;

import hris.D.D11TaxAdjust.* ;

/**
 * D11TaxAdjustTaxRFC.java
 * �������� - ��Ÿ/���װ��� ��û/����/��ȸ RFC�� ȣ���ϴ� Class
 *
 * @author �赵��
 * @version 1.0, 2002/11/20
 */
public class D11TaxAdjustTaxRFC extends SAPWrap {

    private String functionName = "ZSOLYR_RFC_YEAR_TAX" ;

    /**
     * �������� - ��Ÿ/���װ��� ��ȸ RFC ȣ���ϴ� Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getTax( String empNo, String targetYear,String Gubun ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, empNo, targetYear, "1",Gubun);
            excute(mConnection, function);
            
            Vector ret = getOutput(function);

            for( int i = 0 ; i < ret.size() ; i++ ){
                D11TaxAdjustDeductData data = (D11TaxAdjustDeductData)ret.get(i);
                
                if(data.ADD_BETRG.equals("")) { data.ADD_BETRG=""; } else{ data.ADD_BETRG=Double.toString(Double.parseDouble(data.ADD_BETRG)   * 100.0); }  // �⺻����  
                if(data.ACT_BETRG.equals("")) { data.ACT_BETRG=""; } else{ data.ACT_BETRG=Double.toString(Double.parseDouble(data.ACT_BETRG)   * 100.0); }  // �����    
                if(data.AUTO_BETRG.equals("")){ data.AUTO_BETRG=""; }else{ data.AUTO_BETRG=Double.toString(Double.parseDouble(data.AUTO_BETRG) * 100.0); }  // ��ο��  
            }
            
            return ret;

        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    /**
     * �������� - ��Ÿ/���װ��� ��ȸ, ��û ���� FLAG�� ��ȸ
     *  @exception com.sns.jdf.GeneralException
     */
    public String getE_FLAG( String empNo, String targetYear ) throws GeneralException {
        JCO.Client mConnection = null ;

        try {
            mConnection = getClient() ;
            JCO.Function function = createFunction( functionName ) ;

            setInput(function, empNo, targetYear, "1","") ;
            excute(mConnection, function) ;

            String fieldName = "E_FLAG" ;
            String ret       = getField( fieldName, function ) ;

            return ret ;
        } catch( Exception ex ) {
            Logger.sap.println( this, " SAPException : " + ex.toString() ) ;
            throw new GeneralException( ex ) ;
        } finally {
            close( mConnection ) ;
        }
    }
    
    /**
     * �������� - ��Ÿ/���װ��� ��û RFC ȣ���ϴ� Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */ 
    public void build( String empNo, String targetYear, Vector deduct_vt ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            for( int i = 0 ; i < deduct_vt.size() ; i++ ){
                D11TaxAdjustDeductData data = (D11TaxAdjustDeductData)deduct_vt.get(i);
                
                if(data.ADD_BETRG.equals("")) { data.ADD_BETRG=""; } else{ data.ADD_BETRG=Double.toString(Double.parseDouble(data.ADD_BETRG)   / 100.0); }  // �⺻����  
                if(data.ACT_BETRG.equals("")) { data.ACT_BETRG=""; } else{ data.ACT_BETRG=Double.toString(Double.parseDouble(data.ACT_BETRG)   / 100.0); }  // �����    
                if(data.AUTO_BETRG.equals("")){ data.AUTO_BETRG=""; }else{ data.AUTO_BETRG=Double.toString(Double.parseDouble(data.AUTO_BETRG) / 100.0); }  // ��ο��  
            }

            setInput(function, empNo, targetYear, "2","");

            setInput(function, deduct_vt, "O_RESULT");

            excute(mConnection, function);

        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }
    
    /**
     * �������� - ��Ÿ/���װ��� ���� RFC ȣ���ϴ� Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public void change( String empNo, String targetYear, Vector deduct_vt ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            for( int i = 0 ; i < deduct_vt.size() ; i++ ){
                D11TaxAdjustDeductData data = (D11TaxAdjustDeductData)deduct_vt.get(i);
                
                if(data.ADD_BETRG.equals("")) { data.ADD_BETRG=""; } else{ data.ADD_BETRG=Double.toString(Double.parseDouble(data.ADD_BETRG)   / 100.0); }  // �⺻����  
                if(data.ACT_BETRG.equals("")) { data.ACT_BETRG=""; } else{ data.ACT_BETRG=Double.toString(Double.parseDouble(data.ACT_BETRG)   / 100.0); }  // �����    
                if(data.AUTO_BETRG.equals("")){ data.AUTO_BETRG=""; }else{ data.AUTO_BETRG=Double.toString(Double.parseDouble(data.AUTO_BETRG) / 100.0); }  // ��ο��  
            }
            
            setInput(function, empNo, targetYear, "5","");

            setInput(function, deduct_vt, "O_RESULT");

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
    private void setInput(JCO.Function function, String empNo, String targetYear, String cont_type,String Gubun) throws GeneralException {
        String fieldName1 = "I_PERNR";
        setField( function, fieldName1, empNo );
        String fieldName2 = "I_YEAR";
        setField( function, fieldName2, targetYear );
        String fieldName3 = "P_CONT_TYPE";
        setField( function, fieldName3, cont_type );
        String fieldName4 = "I_FORM";
        setField( function, fieldName4, Gubun );
    }

    // Import Parameter �� Vector(Table) �� ���
// ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
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
        String entityName = "hris.D.D11TaxAdjust.D11TaxAdjustDeductData";
        String tableName  = "O_RESULT";
        
        return getTable(entityName, function, tableName);
    }
}