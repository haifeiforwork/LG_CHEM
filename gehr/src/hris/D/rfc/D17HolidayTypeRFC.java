package	hris.D.rfc;

import hris.D.D17HolidayTypeData;

import java.util.Vector;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;
import com.sns.jdf.util.CodeEntity;

/**
 * Global 전용
 * @author kimscvalue
 *
 */
 
public class D17HolidayTypeRFC extends SAPWrap {

    private String functionName = "ZGHR_RFC_HOLIDAY_ENTRY";//ZHRW_RFC_HOLIDAY_ENTRY

 
    
    public Vector getHolidayType(String empNo) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setField( function, "I_PERNR", empNo );
            excute(mConnection, function);
            Vector ret = getOutput(function);
            Vector Sret = new Vector();
            for(int i=0; i<ret.size(); i++){
            	D17HolidayTypeData data = (D17HolidayTypeData)ret.get(i);
            	CodeEntity entity = new CodeEntity();
            	if(data.TIME_REQU.equals("X")){
            		entity.code = data.AWART+"X";
            		
            	}else{
            		entity.code = data.AWART ;
            	}
            	entity.value = data.ATEXT;	
            	entity.value1 = data.UPMU_CODE;	//2008-02-20.
            	Sret.addElement(entity);
            }
            Logger.debug.println(this, ret.toString());
            return Sret;
          
        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }
    
    public Vector getHolidayType1(String empNo) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setField( function, "I_PERNR", empNo );
            excute(mConnection, function);
            Vector ret = getOutput(function);
            Vector Sret = new Vector();
            for(int i=0; i<ret.size(); i++){
            	D17HolidayTypeData data = (D17HolidayTypeData)ret.get(i);
            	CodeEntity entity = new CodeEntity();
       		    entity.code = data.AWART ;
             	entity.value = data.ATEXT;	
            	Sret.addElement(entity);
            }
            Logger.debug.println(this, ret.toString());
            return Sret;
        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }
    
    /********************************************************

    *    Leave : 휴가유형에 따른 selectbox 업무코드.(value1)		
    *    
    *    2008-02-20. - jungin.
    *
    ********************************************************/
    public Vector getHolidayType2(String empNo) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setField( function, "I_PERNR", empNo );
            excute(mConnection, function);
            Vector ret = getOutput(function);
            Vector Sret = new Vector();
            for(int i=0; i<ret.size(); i++){
            	D17HolidayTypeData data = (D17HolidayTypeData)ret.get(i);
            	CodeEntity entity = new CodeEntity();
             	entity.value1 = data.UPMU_CODE;
            	Sret.addElement(entity);
            }
            Logger.debug.println(this, ret.toString());
            return Sret;
        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }
    
    /**
     * RFC 실행후 Export 값을 Vector 로 Return 한다.
     * 반드시 com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출된후에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutput(JCO.Function function) throws GeneralException {
        String entityName = "hris.D.D17HolidayTypeData";
        String tableName = "T_ITAB";
        return getTable(entityName, function, tableName);
    }
    private Vector getOutput1(JCO.Function function) throws GeneralException {
        String tableName = "T_ITAB";//ITAB
        Vector sum = new Vector();
        Vector obj = getCodeVector(function, tableName);
        sum.addElement(obj);
        return sum;
    }
 
}