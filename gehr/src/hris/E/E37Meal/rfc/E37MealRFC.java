package hris.E.E37Meal.rfc ;

import java.util.* ;

import com.sap.mw.jco.* ;
import com.sns.jdf.* ;
import com.sns.jdf.sap.* ;
import com.sns.jdf.util.* ;

import hris.E.E37Meal.* ;

/**
 * E37MealRFC.java
 *  사원의 식대 신청/신청조회/신청수정/삭제를 수행하는 RFC를 호출하는 Class
 *
 * @author lsa
 * @version 1.0, 2009/11/25
 */
public class E37MealRFC extends SAPWrap {

    private String functionName = "ZHRA_RFC_MEAL_APP" ;

    /**
     * 식대 신청조회 RFC 호출하는 Method
     * @return java.util.Vector
     * @param keycode java.lang.String 결재고유번호
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
                
                    if(data.TKCT_WONX.equals("")){ data.TKCT_WONX=""; }else{ data.TKCT_WONX=Double.toString(Double.parseDouble(data.TKCT_WONX) * 100.0 ) ; }  // 현물지급액
                    if(data.CASH_WONX.equals("")){ data.CASH_WONX=""; }else{ data.CASH_WONX=Double.toString(Double.parseDouble(data.CASH_WONX) * 100.0 ) ; }  // 현금보상액
                    if(data.THNG_MONY.equals("")){ data.THNG_MONY=""; }else{ data.THNG_MONY=Double.toString(Double.parseDouble(data.THNG_MONY) * 100.0 ) ; }  // 현물 (1끼당 금액)
                    if(data.CASH_MONY.equals("")){ data.CASH_MONY=""; }else{ data.CASH_MONY=Double.toString(Double.parseDouble(data.CASH_MONY) * 100.0 ) ; }  // 현물보상 기준금액 
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
                
                    if(data.TKCT_WONX.equals("")){ data.TKCT_WONX=""; }else{ data.TKCT_WONX=Double.toString(Double.parseDouble(data.TKCT_WONX) * 100.0 ) ; }  // 현물지급액
                    if(data.CASH_WONX.equals("")){ data.CASH_WONX=""; }else{ data.CASH_WONX=Double.toString(Double.parseDouble(data.CASH_WONX) * 100.0 ) ; }  // 현금보상액
                    
                    if(data.THNG_MONY.equals("")){ data.THNG_MONY=""; }else{ data.THNG_MONY=Double.toString(Double.parseDouble(data.THNG_MONY) * 100.0 ) ; }  // 현물 (1끼당 금액)
                    if(data.CASH_MONY.equals("")){ data.CASH_MONY=""; }else{ data.CASH_MONY=Double.toString(Double.parseDouble(data.CASH_MONY) * 100.0 ) ; }  // 현물보상 기준금액 
                    
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
     * 식대 신청 RFC 호출하는 Method
     * @return java.util.Vector
     * @param keycode java.lang.String 결재고유번호
     * @param keycode java.util.Vector 결재고유번호
     * @param keycode java.util.Vector 결재고유번호
     * @exception com.sns.jdf.GeneralException
     */
    public Vector build( String orgeh,String Idate, String aplyFlag,  Vector mealVector, Vector mealApprVector ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
        
            for( int i = 0 ; i < mealVector.size() ; i++ ){
                E37MealData data = (E37MealData)mealVector.get(i);
                if(data.TKCT_WONX.equals("")){ data.TKCT_WONX=""; }else{ data.TKCT_WONX=Double.toString(Double.parseDouble(data.TKCT_WONX) / 100.0 ) ; }  // 현물지급액
                if(data.CASH_WONX.equals("")){ data.CASH_WONX=""; }else{ data.CASH_WONX=Double.toString(Double.parseDouble(data.CASH_WONX) / 100.0 ) ; }  // 현금보상액
                if(data.THNG_MONY.equals("")){ data.THNG_MONY=""; }else{ data.THNG_MONY=Double.toString(Double.parseDouble(data.THNG_MONY) / 100.0 ) ; }  // 현물 (1끼당 금액)
                if(data.CASH_MONY.equals("")){ data.CASH_MONY=""; }else{ data.CASH_MONY=Double.toString(Double.parseDouble(data.CASH_MONY) / 100.0 ) ; }  // 현물보상 기준금액 
                
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
     * 식대 신청 수정 RFC 호출하는 Method
     * @return java.util.Vector
     * @param companyCode java.lang.String 회사코드
     * @exception com.sns.jdf.GeneralException
     */
    public void change(  String orgeh,String Idate, String aplyFlag,  Vector mealVector, Vector mealApprVector  ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            for( int i = 0 ; i < mealApprVector.size() ; i++ ){
                E37MealData data = (E37MealData)mealApprVector.get(i);
                if(data.TKCT_WONX.equals("")){ data.TKCT_WONX=""; }else{ data.TKCT_WONX=Double.toString(Double.parseDouble(data.TKCT_WONX) / 100.0 ) ; }  // 현물지급액
                if(data.CASH_WONX.equals("")){ data.CASH_WONX=""; }else{ data.CASH_WONX=Double.toString(Double.parseDouble(data.CASH_WONX) / 100.0 ) ; }  // 현금보상액
                if(data.THNG_MONY.equals("")){ data.THNG_MONY=""; }else{ data.THNG_MONY=Double.toString(Double.parseDouble(data.THNG_MONY) / 100.0 ) ; }  // 현물 (1끼당 금액)
                if(data.CASH_MONY.equals("")){ data.CASH_MONY=""; }else{ data.CASH_MONY=Double.toString(Double.parseDouble(data.CASH_MONY) / 100.0 ) ; }  // 현물보상 기준금액 
                
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
     * 식대 삭제 RFC 호출하는 Method
     * @return java.util.Vector
     * @param companyCode java.lang.String 회사코드
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
     * RFC 실행전에 Import 값을 setting 한다.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출되기 전에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @param keycode java.lang.String 결재정보 일련번호
     * @param job java.lang.String 기능정보
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String orgeh,String Idate, String aplyFlag, String job) throws GeneralException {
        String fieldName = "I_ORGEH";
        setField( function, fieldName, orgeh );
        String fieldName1 = "I_DATE";
        setField( function, fieldName1, Idate );
        String fieldName2 = "I_APLY_FLAG"; // X:정기/'':수시
        setField( function, fieldName2, aplyFlag );
        String fieldName3 = "I_TYPE"; // S/I/C/D
        setField( function, fieldName3, job );
    }

// Import Parameter 가 Vector(Table) 인 경우
// ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
    /**
     * RFC 실행전에 Import 값을 setting 한다.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출되기 전에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @param entityVector java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, Vector entityVector, String tableName) throws GeneralException {
        setTable(function, tableName, entityVector);
    }

    /**
     * RFC 실행후 Export 값을 Vector 로 Return 한다.
     * 반드시 com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출된후에 실행되어야하는 메소드
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


