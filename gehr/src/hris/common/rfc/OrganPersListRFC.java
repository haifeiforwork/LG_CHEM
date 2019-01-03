/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : 공통                                                        */
/*   2Depth Name  :                                                             */
/*   Program Name : 사원 검색                                                   */
/*   Program ID   : OrganPersListRFC.java                                       */
/*   Description  : 조직도에서 사원목록을 검색하는 RFC 파일                     */
/*   Note         : 없음                                                        */
/*   Creation     : 2005-01-21 유용원                                           */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/

package hris.common.rfc;

import hris.common.OrganPersListData;

import java.util.*;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;


/**
 * OrganPersListRFC.java
 * 조직도에서 사원목록을 가져오는 RFC를 호출하는 Class
 *
 * @author 유용원
 * @version 1.0, 2005/01/21
 * @version 1.0, 2013/11/08  사번추가 C20140121_73638
 */
public class OrganPersListRFC extends SAPWrap {

  //  private String functionName = "ZHRA_RFC_GET_ORGEH_PERS_LIST";
	  private String functionName = "ZGHR_RFC_GET_ORGEH_PERS_LIST";

    /**
     * 조직ID로 개인정보를 가져오는 RFC를 호출하는 Method
     * @param java.lang.String 조직ID
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getPersonList( String i_orgeh, String pernr ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, i_orgeh,pernr);
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

    public Vector getPersonList( String i_orgeh, String pernr, String I_IMWON ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, i_orgeh,pernr);
            setField(function, "I_IMWON" ,I_IMWON);

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
    private void setInput(JCO.Function function, String i_orgeh, String pernr) throws GeneralException {
        String fieldName  = "I_ORGEH";
        setField(function, fieldName,  i_orgeh);
        String fieldName1  = "I_DEPT";
        setField(function, fieldName1,  pernr);

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

    	// Export 변수 조회
    	String E_RETURN   =getReturn().MSGTY;
    	String E_MESSAGE  =getReturn().MSGTX;

    	// Table 결과 조회
    	Vector T_EXPORTA  = getTable(OrganPersListData.class,  function, "T_RESULT");

    	ret.addElement(E_RETURN);
    	ret.addElement(E_MESSAGE);
    	ret.addElement(T_EXPORTA);

    	return ret;
    }
}


