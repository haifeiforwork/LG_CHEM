package hris.E.E37Meal.rfc ;

import java.util.* ;

import com.sap.mw.jco.* ;
import com.sns.jdf.* ;
import com.sns.jdf.sap.* ;
import com.sns.jdf.util.* ;

import hris.E.E37Meal.* ;

/**
 * E37MealRFC.java
 *  ����� �Ĵ� ��û/��û��ȸ/��û����/������ �����ϴ� RFC�� ȣ���ϴ� Class
 *
 * @author lsa
 * @version 1.0, 2009/11/25
 */
public class E37MealRFC extends SAPWrap {

    private String functionName = "ZHRA_RFC_MEAL_APP" ;

    /**
     * �Ĵ� ��û��ȸ RFC ȣ���ϴ� Method
     * @return java.util.Vector
     * @param keycode java.lang.String ���������ȣ
     * @exception com.sns.jdf.GeneralException
     */
    public Vector detail(  String orgeh,String Idate, String aplyFlag ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, orgeh,Idate,aplyFlag, "S");
            excute(mConnection, function);
            Vector ret = getOutput(function);

            Vector E37MealData_vt  = (Vector)ret.get(0);
            for( int i = 0 ; i < E37MealData_vt.size() ; i++ ){
                E37MealData data = (E37MealData)E37MealData_vt.get(i);
                
                    if(data.TKCT_WONX.equals("")){ data.TKCT_WONX=""; }else{ data.TKCT_WONX=Double.toString(Double.parseDouble(data.TKCT_WONX) * 100.0 ) ; }  // �������޾�
                    if(data.CASH_WONX.equals("")){ data.CASH_WONX=""; }else{ data.CASH_WONX=Double.toString(Double.parseDouble(data.CASH_WONX) * 100.0 ) ; }  // ���ݺ����
                    if(data.THNG_MONY.equals("")){ data.THNG_MONY=""; }else{ data.THNG_MONY=Double.toString(Double.parseDouble(data.THNG_MONY) * 100.0 ) ; }  // ���� (1���� �ݾ�)
                    if(data.CASH_MONY.equals("")){ data.CASH_MONY=""; }else{ data.CASH_MONY=Double.toString(Double.parseDouble(data.CASH_MONY) * 100.0 ) ; }  // �������� ���رݾ� 
            }
            
            return ret;
        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    public Vector newdetail(  String orgeh,String Idate, String aplyFlag ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, orgeh,Idate,aplyFlag, "I");
            excute(mConnection, function);
            Vector ret = getOutput(function);

            Vector E37MealData_vt  = (Vector)ret.get(0);
            for( int i = 0 ; i < E37MealData_vt.size() ; i++ ){
                E37MealData data = (E37MealData)E37MealData_vt.get(i);
                
                    if(data.TKCT_WONX.equals("")){ data.TKCT_WONX=""; }else{ data.TKCT_WONX=Double.toString(Double.parseDouble(data.TKCT_WONX) * 100.0 ) ; }  // �������޾�
                    if(data.CASH_WONX.equals("")){ data.CASH_WONX=""; }else{ data.CASH_WONX=Double.toString(Double.parseDouble(data.CASH_WONX) * 100.0 ) ; }  // ���ݺ����
                    
                    if(data.THNG_MONY.equals("")){ data.THNG_MONY=""; }else{ data.THNG_MONY=Double.toString(Double.parseDouble(data.THNG_MONY) * 100.0 ) ; }  // ���� (1���� �ݾ�)
                    if(data.CASH_MONY.equals("")){ data.CASH_MONY=""; }else{ data.CASH_MONY=Double.toString(Double.parseDouble(data.CASH_MONY) * 100.0 ) ; }  // �������� ���رݾ� 
                    
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
     * �Ĵ� ��û RFC ȣ���ϴ� Method
     * @return java.util.Vector
     * @param keycode java.lang.String ���������ȣ
     * @param keycode java.util.Vector ���������ȣ
     * @param keycode java.util.Vector ���������ȣ
     * @exception com.sns.jdf.GeneralException
     */
    public Vector build( String orgeh,String Idate, String aplyFlag,  Vector mealVector, Vector mealApprVector ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
        
            for( int i = 0 ; i < mealVector.size() ; i++ ){
                E37MealData data = (E37MealData)mealVector.get(i);
                if(data.TKCT_WONX.equals("")){ data.TKCT_WONX=""; }else{ data.TKCT_WONX=Double.toString(Double.parseDouble(data.TKCT_WONX) / 100.0 ) ; }  // �������޾�
                if(data.CASH_WONX.equals("")){ data.CASH_WONX=""; }else{ data.CASH_WONX=Double.toString(Double.parseDouble(data.CASH_WONX) / 100.0 ) ; }  // ���ݺ����
                if(data.THNG_MONY.equals("")){ data.THNG_MONY=""; }else{ data.THNG_MONY=Double.toString(Double.parseDouble(data.THNG_MONY) / 100.0 ) ; }  // ���� (1���� �ݾ�)
                if(data.CASH_MONY.equals("")){ data.CASH_MONY=""; }else{ data.CASH_MONY=Double.toString(Double.parseDouble(data.CASH_MONY) / 100.0 ) ; }  // �������� ���رݾ� 
                
            }    
            setInput(function,   orgeh,Idate,aplyFlag, "C");
 

            setInput(function, mealVector,     "T_RESULT");
            setInput(function, mealApprVector, "T_APPR"); 
            
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
     * �Ĵ� ��û ���� RFC ȣ���ϴ� Method
     * @return java.util.Vector
     * @param companyCode java.lang.String ȸ���ڵ�
     * @exception com.sns.jdf.GeneralException
     */
    public void change(  String orgeh,String Idate, String aplyFlag,  Vector mealVector, Vector mealApprVector  ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            for( int i = 0 ; i < mealApprVector.size() ; i++ ){
                E37MealData data = (E37MealData)mealApprVector.get(i);
                if(data.TKCT_WONX.equals("")){ data.TKCT_WONX=""; }else{ data.TKCT_WONX=Double.toString(Double.parseDouble(data.TKCT_WONX) / 100.0 ) ; }  // �������޾�
                if(data.CASH_WONX.equals("")){ data.CASH_WONX=""; }else{ data.CASH_WONX=Double.toString(Double.parseDouble(data.CASH_WONX) / 100.0 ) ; }  // ���ݺ����
                if(data.THNG_MONY.equals("")){ data.THNG_MONY=""; }else{ data.THNG_MONY=Double.toString(Double.parseDouble(data.THNG_MONY) / 100.0 ) ; }  // ���� (1���� �ݾ�)
                if(data.CASH_MONY.equals("")){ data.CASH_MONY=""; }else{ data.CASH_MONY=Double.toString(Double.parseDouble(data.CASH_MONY) / 100.0 ) ; }  // �������� ���رݾ� 
                
            }                                                                                                                                  
 
            setInput(function,  orgeh,Idate,aplyFlag, "C");
 
            setInput(function, mealVector,     "T_RESULT");
            setInput(function, mealApprVector, "T_APPR");
            
            excute(mConnection, function);

        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }
    /**
     * �Ĵ� ���� RFC ȣ���ϴ� Method
     * @return java.util.Vector
     * @param companyCode java.lang.String ȸ���ڵ�
     * @exception com.sns.jdf.GeneralException
     */
    public Vector delete(   String orgeh,String Idate, String aplyFlag,  Vector mealVector, Vector mealApprVector  ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
 

            setInput(function,  orgeh,Idate,aplyFlag, "D"); 
            setInput(function, mealVector,     "T_RESULT");
            setInput(function, mealApprVector, "T_APPR"); 
            
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
     * @param keycode java.lang.String �������� �Ϸù�ȣ
     * @param job java.lang.String �������
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String orgeh,String Idate, String aplyFlag, String job) throws GeneralException {
        String fieldName = "I_ORGEH";
        setField( function, fieldName, orgeh );
        String fieldName1 = "I_DATE";
        setField( function, fieldName1, Idate );
        String fieldName2 = "I_APLY_FLAG"; // X:����/'':����
        setField( function, fieldName2, aplyFlag );
        String fieldName3 = "I_TYPE"; // S/I/C/D
        setField( function, fieldName3, job );
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
        Vector ret = new Vector();

        String entityName1 = "hris.E.E37Meal.E37MealData";
        Vector T_RESULT = getTable(entityName1, function, "T_RESULT");

        String entityName2 = "hris.E.E37Meal.E37MealApprData";
        Vector T_APPR = getTable(entityName2, function, "T_APPR");


        String E_TYPE     = getField("E_TYPE",  function);  // Error Type
        String E_MESSAGE  = getField("E_MESSAGE",  function);  // Error Message
        
        ret.addElement(T_RESULT);
        ret.addElement(T_APPR);
        ret.addElement(E_TYPE);
        ret.addElement(E_MESSAGE);

        return ret ;
    }
}


