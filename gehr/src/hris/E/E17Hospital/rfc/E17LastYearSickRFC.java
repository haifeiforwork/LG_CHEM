package hris.E.E17Hospital.rfc ;

import java.util.* ;

import com.sap.mw.jco.* ;
import com.sns.jdf.* ;
import com.sns.jdf.sap.* ;
import com.sns.jdf.util.* ;

import hris.E.E17Hospital.* ;

/**
 * E17SickRFC.java
 *  사원의 의료비 신청을 위한 마지막 진료일로부터 1년이내의 상병명(진단명) 리스트을 가져오는 RFC를 호출하는 Class
 *
 * @author lsa
 * @version 1.0, 2009/01/06
 */
public class E17LastYearSickRFC extends SAPWrap {

    private String functionName = "ZHRW_RFC_READ_9406" ;

    private Vector return_vt = null;     // 마지막 항목의 관리번호에 해당하는 상병명, 구체적 증상등의 데이터.
    
    /**
     * 마지막 항목의 관리번호에 해당하는 상병명, 구체적 증상등의 데이터를 가져오는 Method
     * @param java.lang.String 사원번호
     * @return java.util.Vector 
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getSickData(String empNo, String Guen_code, String Objps_21, String Regno) throws GeneralException {
        if(return_vt==null){
            getData(empNo, Guen_code, Objps_21, Regno);
        }

        return return_vt;
    }
    /** 
     * 사원의 의료비 신청을 위한 상병/증상을 가져오는 RFC 호출하는 Method
     * @param java.lang.String 사원번호
     * @return hris.E.E05House.E05PersInfoData
     * @exception com.sns.jdf.GeneralException
     */
    private void getData(String empNo, String Guen_code, String Objps_21, String Regno) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, empNo, Guen_code, Objps_21, Regno);
            excute(mConnection, function);
            return_vt = getOutput(function);
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
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String empNo, String Guen_code, String Objps_21, String Regno) throws GeneralException {
        String fieldName  = "I_PERNR";
        setField( function, fieldName,  empNo );
        String fieldName1 = "I_GUEN_CODE";
        setField( function, fieldName1, Guen_code );
        String fieldName2 = "I_OBJPS_21";
        setField( function, fieldName2, Objps_21 );
        String fieldName3 = "I_REGNO";
        setField( function, fieldName3, Regno );
    }

    /**
     * RFC 실행후 Export 값을 Vector 로 Return 한다.
     * 반드시 com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출된후에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutput(JCO.Function function) throws GeneralException {
        String entityName = "hris.E.E17Hospital.E17SickData";
        String tableName  = "E_9406";
        return getTable(entityName, function, tableName);
    }
}
