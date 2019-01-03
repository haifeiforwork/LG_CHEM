package hris.E.E05House.rfc;

import java.util.*;

import com.sap.mw.jco.*;
import com.sns.jdf.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;

import hris.E.E05House.*;
import hris.common.approval.ApprovalSAPWrap;

/**
 * E05PersInfoRFC.java
 * 사원의 주소와 근속년수를 가져오는 RFC를 호출하는 Class
 *
 * @author 김성일
 * @version 1.0, 2001/12/13
 */
public class E05PersInfoRFC extends ApprovalSAPWrap {

    //private String functionName = "ZHRA_RFC_GET_PERS_INFO";
    private String functionName = "ZGHR_RFC_GET_PERS_INFO";

    /**
     * 사원의 주소와 근속년수를 가져오는 RFC를 호출하는 Method
     * @param java.lang.String 사원번호
     * @return hris.E.E05House.E05PersInfoData
     * @exception com.sns.jdf.GeneralException
     */
    public Object getPersInfo(String empNo) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, empNo);

            excute(mConnection, function);
            Object ret = getFields( ( new E05PersInfoData() ), function );//getOutput(function, ( new E05PersInfoData() ));

            return ret;
        }catch(Exception ex){
            //Logger.sap.println(this, "SAPException : "+ex.toString());
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
    private void setInput(JCO.Function function, String empNo) throws GeneralException {
        String fieldName1 = "I_PERNR";
        setField( function, fieldName1, empNo );
        String fieldName2 = "I_DATE";
        setField( function, fieldName2, DataUtil.getCurrentDate() );
    }


}
