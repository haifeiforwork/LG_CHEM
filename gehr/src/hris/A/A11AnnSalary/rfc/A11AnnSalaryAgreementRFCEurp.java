/********************************************************************************/
/*   System Name  : ESS                                                         	*/
/*   1Depth Name  : Personal HR Info                                              */
/*   2Depth Name  : Personal Info                                 */
/*   Program Name : Annual Salary Agreement                                      */
/*   Program ID   : A11AnnSalaryAgreementRFCEurp                           */
/*   Description  : 연봉정보을 가져오는 RFC를 호출하는 Class       */
/*   Note         : [관련 RFC] : ZHR_RFC_ANNUAL_SALARY             */
/*   Creation     : 2010-07-20  yji                                          			*/
/********************************************************************************/

package hris.A.A11AnnSalary.rfc;

import java.util.HashMap;
import java.util.Vector;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;

public class A11AnnSalaryAgreementRFCEurp extends SAPWrap {

    private String functionName = "ZHR_RFC_ANNUAL_SALARY" ;

    /**
     *  연봉정보를 조회한다.
     *  
     *  연봉정보를 가져오는 RFC를 호출하는 Method
     *  @param     java.lang.String 사원번호
     *  @return    java.util.Vector
     *  @exception GeneralException
     */
    public HashMap getAnnSalaryList( String empNo , String i_ptype ) throws GeneralException {
        JCO.Client mConnection = null ;

        try {
            mConnection = getClient() ;
            JCO.Function function = createFunction( functionName ) ;

            setInput( function, empNo , i_ptype) ;
            excute( mConnection, function ) ;

            Vector ret = null;
            HashMap mapData = new HashMap();
            
            //연봉조회 - I_PTYPE이 "D" 일 경우 - Display
            if(i_ptype.equals("D")){
            	ret = getOutput( function ) ;
            
            //연봉조회뷰어 - I_PTYPE이 "A"일 경우 - Agreemen
            }else if(i_ptype.equals("A")){
            	ret = getOutput2( function ) ;
            }
            
            Vector EXPVAL = getOutputExport( function );
            
            mapData.put("AgreeData", ret);
            mapData.put("ExportData", EXPVAL);
            
            Logger.debug.println("[getAnnSalaryList AgreeData Value]" + ret);
            Logger.debug.println("[getAnnSalaryList EXPVAL Value]" + EXPVAL);
            
            return mapData ;
        } catch( Exception ex ) {
            Logger.sap.println( this, " SAPException : " + ex.toString() ) ;
            throw new GeneralException( ex ) ;
        } finally {
            close( mConnection ) ;
        }
    }
    
    /**
     * 연봉에 해당하는 년도, 사원이름을 가져오는 RFC 호출하는 Method
     * @return java.util.Vector
     * @param companyCode java.lang.String 회사코드
     * @exception GeneralException
     */ 
    public Vector getPersonInfoListForSalary(String empNo , String i_ptype) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput( function, empNo , i_ptype) ;
            excute( mConnection, function ) ;
            
            Vector ret = getOutput3(function);
            return ret;

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
     * @exception GeneralException
     */
    private Vector getOutput3(JCO.Function function) throws GeneralException {
        String ES_RETURN  = getField("ES_RETURN", function );   
        String E_YEAR  = getField("E_YEAR", function );
        String E_DEAR  = getField("E_DEAR", function );
        String E_BUTTON  = getField("E_BUTTON", function );    
        
        Vector vt = new Vector(3);
        vt.addElement(ES_RETURN);
        vt.addElement(E_YEAR);
        vt.addElement(E_DEAR);
        vt.addElement(E_BUTTON);
        return vt;
    }
    
    
    /**
     * RFC 실행전에 Import 값을 setting 한다.
     * com.sns.jdf.SAPWrap.excute( JCO.Client mConnection, JCO.Function function ) 가 호출되기 전에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @exception      GeneralException
     */
    private void setInput( JCO.Function function, String empNo , String i_ptype) throws GeneralException {
        String fieldName = "I_PERNR" ;
        setField( function, fieldName, empNo ) ;

        String fieldName2 = "I_PTYPE" ;
        setField( function, fieldName2, i_ptype ) ;        
    }

    /**
     * 연봉조회 - I_PTYPE이 D일 경우
     * 
     * RFC 실행후 Export 값을 Vector 로 Return 한다.
     * 반드시 com.sns.jdf.SAPWrap.excute( JCO.Client mConnection, JCO.Function function ) 가 호출된후에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @return         java.util.Vector
     * @exception      GeneralException
     */
    private Vector getOutput( JCO.Function function ) throws GeneralException {
        String entityName = "hris.A.A10Annual.A11AnnSalaryAgreementDataEurp" ;
        String tableName  = "ITAB" ;

        return getTable( entityName, function, tableName ) ;
    }
    
    /**
     * 연봉조회뷰어 - I_PTYPE이 A일 경우
     * 
     * RFC 실행후 Export 값을 Vector 로 Return 한다.
     * 반드시 com.sns.jdf.SAPWrap.excute( JCO.Client mConnection, JCO.Function function ) 가 호출된후에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @return         java.util.Vector
     * @exception      GeneralException
     */
    private Vector getOutput2( JCO.Function function ) throws GeneralException {
        String entityName = "hris.A.A10Annual.A11AnnSalaryAgreementDataEurp" ;
        String tableName  = "ITAB2" ;

        return getTable( entityName, function, tableName ) ;
    }    

    /**
     * Export Parameter값 리턴
     * 
     * RFC 실행후 Export 값을 Vector 로 Return 한다.
     * 반드시 com.sns.jdf.SAPWrap.excute( JCO.Client mConnection, JCO.Function function ) 가 호출된후에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @return         java.util.Vector
     * @exception      GeneralException
     */
    private Vector getOutputExport( JCO.Function function ) throws GeneralException {
        String ES_RETURN  = getField("ES_RETURN", function );   
        String E_YEAR  = getField("E_YEAR", function );
        String E_DEAR  = getField("E_DEAR", function );
        String E_BUTTON  = getField("E_BUTTON", function );    
        
        Vector vt = new Vector(3);
        vt.addElement(ES_RETURN);
        vt.addElement(E_YEAR);
        vt.addElement(E_DEAR);
        vt.addElement(E_BUTTON);
        return vt;
    }

}