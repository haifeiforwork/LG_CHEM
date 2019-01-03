/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 주택자금 상환신청                                           */
/*   Program Name : 주택자금 상환신청                                           */
/*   Program ID   : E06RehouseRFC                                               */
/*   Description  : 주택자금 상환신청에 대한 데이터를 가져오는 RFC를 호출하는 Class  */
/*   Note         : [관련 RFC] : ZHRW_GET_BASE_LOAN_DATA                        */
/*   Creation     : 2001-12-20  이형석                                          */
/*   Update       : 2005-03-04  윤정현                                          */
/*                                                                              */
/********************************************************************************/

package hris.E.E06Rehouse.rfc;

import com.sap.mw.jco.*;
import com.sns.jdf.*;
import com.sns.jdf.sap.*;

import hris.E.E06Rehouse.*;

public class E06RehouseRFC extends SAPWrap {
    
    private String functionName = "ZHRW_GET_BASE_LOAN_DATA";
    
    /**
     * 주택자금 신청에 대한 데이터를 가져오는 RFC를 호출하는 Method 
     * @param java.lang.Object E06RehouseKey
     * @return hris.E.E06Rehouse.E06RehouseData
     * @exception com.sns.jdf.GeneralException
     */
    public E06RehouseData getBaseLoanData(Object key) throws GeneralException {
        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            setInput(function, key);
            excute(mConnection, function);
            E06RehouseData ret = (E06RehouseData)getOutput(function, ( new E06RehouseData() ));
            
            ret.E_INTR_AMNT     = Double.toString(Double.parseDouble(ret.E_INTR_AMNT) * 100.0 );
            ret.E_TOTAL_AMNT    = Double.toString(Double.parseDouble(ret.E_TOTAL_AMNT) * 100.0 );
            ret.E_RPAY_AMNT     = Double.toString(Double.parseDouble(ret.E_RPAY_AMNT) * 100.0 );
            ret.E_DARBT         = Double.toString(Double.parseDouble(ret.E_DARBT) * 100.0 );    
            ret.E_ALREADY_AMNT  = Double.toString(Double.parseDouble(ret.E_ALREADY_AMNT) * 100.0 );
            ret.E_REMAIN_AMNT   = Double.toString(Double.parseDouble(ret.E_REMAIN_AMNT) * 100.0 );
            
            ret.RPAY_AMNT       = ret.E_RPAY_AMNT;
            ret.INTR_AMNT       = ret.E_INTR_AMNT;
            ret.TOTL_AMNT       = ret.E_TOTAL_AMNT;
            ret.DARBT           = ret.E_DARBT;
            ret.ALREADY_AMNT    = ret.E_ALREADY_AMNT;
            ret.REMAIN_AMNT     = ret.E_REMAIN_AMNT;
            ret.DATBW           = ret.E_DATBW;
            ret.ZZSECU_FLAG     = ret.E_ZZSECU_FLAG;
            
            Logger.debug.println(this, ret.toString());
            return ret;
            
        }catch(Exception ex){
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
     * @param data java.lang.Object
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, Object key) throws GeneralException{
        setFields(function, key);
    }
    
    /**
     * RFC 실행후 Export 값을 Object 로 Return 한다.
     * 반드시 com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출된후에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @param data java.lang.Object
     * @return java.lang.Object
     * @exception com.sns.jdf.GeneralException
     */
    private Object getOutput(JCO.Function function, Object data) throws GeneralException {
        return getFields( data, function );
    }
}

