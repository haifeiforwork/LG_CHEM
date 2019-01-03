package	hris.A.rfc;

import java.util.Vector;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;

import hris.A.A03AccountDetail1Data;

/**
 * A03AccountDetailRFC.java
 * 은행계좌 조회 정보를 가져오는 RFC를 호출하는 Class
 *
 * @author 김도신
 * @version 1.0, 2002/01/07
 */
public class A03AccountDetailRFC extends SAPWrap {

    private String functionName = "ZGHR_RFC_BANK_STOCK_LIST";

    /**
     * 급여계좌정보를 가져오는 해외RFC를 호출하는 Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */

    public Vector getAccountDetail(String keycode) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, keycode);
            
            excute(mConnection, function);
            
            Vector ret = null;
            ret = getOutputGlobal(function);
//            20160204 start
            if(ret.size()!=0){
            A03AccountDetail1Data ret1 = new A03AccountDetail1Data();
            	ret1 = (A03AccountDetail1Data)ret.get(0);
                ret1.VORNA = ret1.VORNA.replaceAll("#", " ");
                ret.set(0, ret1) ;
            }
            
//            20160204 end
            
            return ret;
        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    /**
     * 급여계좌정보를 가져오는 국내전용RFC를 호출하는 Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */

    public Vector getAccountDetail(String keycode, String flag) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, keycode);
            
            excute(mConnection, function);
            
            Vector ret = null;
            
            if( flag == "10" ) {			// 급여계좌
              ret = getOutput(function);
            } else if( flag == "08" ) {		// 증권계좌
              ret = getOutput1(function);
            } else if( flag == "05" ) {		// F/B개인계좌
			  ret = getOutput2(function);
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
     * RFC 실행전에 Import 값을 setting 한다.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출되기 전에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @param value java.lang.String 사번
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String keycode) throws GeneralException {
        String fieldName1 = "I_PERNR"            ;
        setField(function, fieldName1, keycode);
    }
    
    /**
     * RFC 실행후 Export 값을 Vector 로 Return 한다.
     * 반드시 com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출된후에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutputGlobal(JCO.Function function) throws GeneralException {
        String entityName = "hris.A.A03AccountDetail1Data";
        String tableName  = "T_ITAB"; // Global
        return getTable(entityName, function, tableName);
    }
    private Vector getOutput(JCO.Function function) throws GeneralException {
        String entityName = "hris.A.A03AccountDetail1Data";
        String tableName  = "T_RESULT";  // Local
        return getTable(entityName, function, tableName);
    }

    private Vector getOutput1(JCO.Function function) throws GeneralException {
        String entityName = "hris.A.A03AccountDetail2Data";
        String tableName  = "T_RESULT1";// Local
        return getTable(entityName, function, tableName);
    }

    private Vector getOutput2(JCO.Function function) throws GeneralException {
        String entityName = "hris.A.A03AccountDetail3Data";
        String tableName  = "T_RESULT2";// Local
        return getTable(entityName, function, tableName);
    }
}