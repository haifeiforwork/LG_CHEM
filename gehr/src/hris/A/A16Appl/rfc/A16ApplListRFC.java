package hris.A.A16Appl.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;

import hris.A.A16Appl.*;

/**
 * AppListRFC.java
 * 결재정보 List 를 가져오는 RFC를 호출하는 Class
 *
 * @author 김성일
 * @version 1.0, 2001/12/13
 */
public class A16ApplListRFC extends SAPWrap {

    //private String functionName = "ZHRA_RFC_GET_APPL_LIST";
    private String functionName = "ZGHR_RFC_GET_APPL_LIST";

    /**
     * 결재정보 List 를 가져오는 RFC를 호출하는 Method
     * @param java.lang.Object hris.common.AppListKey Object.
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getAppList( Object key ) throws GeneralException {

        JCO.Client mConnection = null;

        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, key);
            excute(mConnection, function);
            Vector ret = getTable(A16ApplListData.class, function, "T_APPL_TAB");//getOutput(function);

            for ( int i = 0 ; i < ret.size() ; i++ ){
                A16ApplListData data = (A16ApplListData)ret.get(i);
                data.BEGDA = com.sns.jdf.util.DataUtil.removeStructur(data.BEGDA, "-");
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
     * @param entity java.lang.Object
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, Object key) throws GeneralException{
        setFields(function, key);
    }


}

