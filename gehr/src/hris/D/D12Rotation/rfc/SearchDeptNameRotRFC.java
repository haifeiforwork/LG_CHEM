/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : 공통                                                        */
/*   2Depth Name  :                                                             */
/*   Program Name : 부서명 검색                                                 */
/*   Program ID   : SearchDeptNameRFC                                           */
/*   Description  : 부서명 검색하는 RFC 파일                                    */
/*   Note         : 없음                                                        */
/*   Creation     : 2005-02-20 유용원                                           */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/


package  hris.D.D12Rotation.rfc;
import java.util.*;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;


/**
 * SearchDeptNameRotRFC
 * 권한에 따른 부서명을 가져오는 RFC를 호출하는 Class
 *
 * @author  유용원
 * @version 1.0,
 */
public class SearchDeptNameRotRFC extends SAPWrap {

    private String functionName = "ZGHR_RFC_ORGNAVI";//ZHRW_RFC_ORGNAVI

    /**
     * 권한에 따른 부서명을 가져오는 RFC를 호출하는 Method
     * @param java.lang.String 조직ID, 권한코드
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getPernrDeptName(String i_pernr, String i_objtxt, String i_pernrs) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput1(function,i_pernr, i_objtxt, "",i_pernrs);
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
    public Vector getDeptName(String i_pernr, String i_objtxt, String i_ename) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, i_pernr, i_objtxt, i_ename );
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
    public Vector setDept(String i_pernr, String i_objtxt, String i_ename,Vector p_zhra114) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, i_pernr, i_objtxt, i_ename,p_zhra114);
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
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String i_pernr, String i_objtxt, String i_ename  ) throws GeneralException {
        String fieldName  = "I_PERNR";
        setField(function, fieldName, i_pernr);
        String fieldName1 = "I_ENAME";
        setField(function, fieldName1, i_ename);
        String fieldName2 = "I_OTEXT";
        setField(function, fieldName2, i_objtxt);
    }
    private void setInput1(JCO.Function function, String i_pernr, String i_objtxt, String i_ename,String i_pernrs ) throws GeneralException {
        String fieldName  = "I_PERNR";
        setField(function, fieldName, i_pernr);
        String fieldName1 = "I_ENAME";
        setField(function, fieldName1, i_ename);
        String fieldName2 = "I_OTEXT";
        setField(function, fieldName2, i_objtxt);
        String fieldName3  = "I_PERNRS";
        setField(function, fieldName3, i_pernrs);
    }
    /**
     * RFC 실행전에 Import 값을 setting 한다.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출되기 전에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String i_pernr, String i_objtxt, String i_ename,Vector p_zhra114) throws GeneralException {
        String fieldName  = "I_PERNR";
        setField(function, fieldName, i_pernr);
        String fieldName1 = "I_ENAME";
        setField(function, fieldName1, i_ename);
        String fieldName2 = "I_OTEXT";
        setField(function, fieldName2, i_objtxt);
    	setTable(function, "T_EXPORTA", p_zhra114);
    }

    /**
     * RFC 실행후 Export 값을 String 로 Return 한다.
     * 반드시 com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출된후에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.lang.String
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutput(JCO.Function function) throws GeneralException {
    	Vector ret = new Vector();

    	// Table 결과 조회
    	String entityName = "hris.D.D12Rotation.D12RotationSearchData";
    	Vector T_EXPORTA   = getTable(entityName,  function, "T_EXPORTA");
    	ret.addElement(T_EXPORTA);

    	return ret;
    }

}


