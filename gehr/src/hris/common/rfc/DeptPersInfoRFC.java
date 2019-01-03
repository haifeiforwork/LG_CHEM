package hris.common.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;

import hris.common.*;

/**
 * DeptPersInfoRFC.java
 * 사원 이름으로 개인정보를 가져오는 RFC를 호출하는 Class
 *
 * @author 김성일
 * @version 1.0, 2001/12/13
 */
public class DeptPersInfoRFC extends SAPWrap {

   // private String functionName = "ZHRA_RFC_GET_DEPT_PERSONS";
	 private String functionName = "ZGHR_RFC_GET_DEPT_PERSONS";

    /**
     * 사원 이름으로 개인정보를 가져오는 RFC를 호출하는 Method
     * @param java.lang.String 사원이름
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getPersons( String i_dept, String i_pernr, String i_ename, String i_gubun, String i_retir ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, i_dept, i_pernr, i_ename, i_gubun, i_retir);
            excute(mConnection, function);
            Vector ret =  getTable(DeptPersInfoData.class, function, "T_RESULT");

            return ret;
        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    public Vector getPersons( String i_dept, String i_pernr, String i_ename, String i_gubun, String i_retir, String I_IMWON ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, i_dept, i_pernr, i_ename, i_gubun, i_retir);

            setField(function, "I_IMWON", I_IMWON);

            excute(mConnection, function);
            Vector ret =  getTable(DeptPersInfoData.class, function, "T_RESULT");

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
    private void setInput(JCO.Function function, String i_dept, String i_pernr, String i_ename, String i_gubun, String i_retir) throws GeneralException {
        String fieldName  = "I_DEPT";
        setField(function, fieldName,  i_dept);
        String fieldName1 = "I_PERNR";
        setField(function, fieldName1, i_pernr);
        String fieldName2 = "I_ENAME";
        setField(function, fieldName2, i_ename);
        String fieldName3 = "I_GUBUN";
        setField(function, fieldName3, i_gubun);
        String fieldName4 = "I_RETIR";
        setField(function, fieldName4, i_retir);
    }

}


