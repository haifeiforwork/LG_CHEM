package hris.D.rfc ;

import java.util.Vector;

import com.common.constant.Area;
import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;
import com.sns.jdf.util.WebUtil;

/**
 *  D16OTHDDupCheckRFC.java
 *  초과근무, 휴가, 개인연금 신청시 중복 체크를 위해 RFC를 호출하여 이미 신청된 건을 읽어온다.
 *
 * @author 배민규
 * @version 1.0, 2003/10/17
 */
public class D16OTHDDupCheckRFC extends SAPWrap {

    private String functionName = "ZGHR_RFC_OTHD_DUP_CHECK"; //ZHRW_RFC_OTHD_DUP_CHECK

    /**
     * 초과근무와 휴가 신청시 중복 체크를 위한 RFC를 호출하는 Method
     * @param empNo java.lang.String 사원번호
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getCheckList( String empNo, String UPMU_TYPE, Area area ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, empNo, UPMU_TYPE);
            excute(mConnection, function);
            Vector ret = new Vector();
            if (UPMU_TYPE.equals("17") || !area.equals( Area.KR)) {         // 초과근무 신청
                ret = getOutput(function);
            } else if (UPMU_TYPE.equals("18")) {  // 휴가 신청
                ret = getOutput2(function);
            } else if ( UPMU_TYPE.equals("02")) { // 개인연금 신청
                ret = getOutput3(function);
            }
            return ret;
        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }


    public String getCheckField( String empNo, String UPMU_TYPE ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, empNo, UPMU_TYPE);
            excute(mConnection, function);

            String fieldName = "E_FLAG" ;

            return getField( fieldName, function ) ;
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
     * @param empNo java.lang.String 사원번호
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String empNo, String UPMU_TYPE) throws GeneralException {
        
        setField( function, "I_PERNR", empNo ); //PERNR
        
        setField( function, "I_UPMU_TYPE", UPMU_TYPE ); //UPMU_TYPE
    }

    /**
     * RFC 실행후 Export 값을 Vector 로 Return 한다.
     * 반드시 com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출된후에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutput(JCO.Function function) throws GeneralException {
        String entityName = "hris.D.D16OTHDDupCheckData";
        String tableName  = "T_OTRESULT"; //OTRESULT
        return getTable(entityName, function, tableName);
    }

    private Vector getOutput2(JCO.Function function) throws GeneralException {
        String entityName = "hris.D.D16OTHDDupCheckData2";
        String tableName  = "T_HDRESULT";//HDRESULT
        return getTable(entityName, function, tableName);
    }

    private Vector getOutput3(JCO.Function function) throws GeneralException {
        String entityName = "hris.D.D16OTHDDupCheckData3";
        String tableName  = "T_PPRESULT";//PPRESULT
        return getTable(entityName, function, tableName);
    }


//    private Object getOutput2(JCO.Function function, D16OTHDDupCheckData2 data2) throws GeneralException {
//        return getFields( data2, function );
//    }
}