package hris.A.A10Annual.rfc;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;
import hris.A.A10Annual.A10AnnualData;

import java.util.Vector;

/**
 * A10AnnualRFC.java
 * 연봉계약 List 를 가져오는 RFC를 호출하는 Class
 *
 * @author 박영락   
 * @version 1.0, 2002/01/10
 *  [CSR ID:3006173] 임원 연봉계약서 Online화를 위한 시스템 구축 요청
 *  2015/05/25 rdcamel 2018/05/21 [CSR ID:3687969] 인사기록부상 해외법인명 한글병기 요청의 건
 */
public class A10AnnualRFC extends SAPWrap {

    private String functionName = "ZGHR_RFC_ANNUAL_SALARY_KR";

    /**
     * 연봉계약 List 를 가져오는 RFC를 호출하는 Method
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
     * 연봉계약 List 를 가져오는 RFC를 호출하는 Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     * @author rdcamel [CSR ID:3687969] 인사기록부상 해외법인명 한글병기 요청의 건
     */
    public Vector getAnnualListLong( String I_PERNR ) throws GeneralException {
        
        JCO.Client mConnection = null;
        
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, I_PERNR);
            setField(function, "I_ORGKR", "X");//인사기록부 상 해외법인명 한글 표시되도록 flag(해당 값이 없으면 약어로만 보여줌)

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
     * 2004년 연봉계약 상세정보를 가져오는 RFC를 호출하는 Method
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
     * RFC 실행전에 Import 값을 setting 한다.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출되기 전에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String key1) throws GeneralException{
        String fieldName1 = "I_PERNR";
        setField(function, fieldName1, key1);
    }

    /**
     * RFC 실행후 Export 값을 Vector 로 Return 한다.
     * 반드시 com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출된후에 실행되어야하는 메소드
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
     * RFC 실행후 Export 값을 Vector 로 Return 한다.
     * 반드시 com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출된후에 실행되어야하는 메소드
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

