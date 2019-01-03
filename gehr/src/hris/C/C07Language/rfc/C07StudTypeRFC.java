package hris.C.C07Language.rfc;

import java.util.Vector;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;

import hris.C.C07Language.*;

/**
 * C07StudTypeRFC.java
 * 학습형태 구분 데이터를 가져오는 RFC를 호출하는 Class
 *
 * @author  김도신
 * @version 1.0, 2003/04/14
 */
public class C07StudTypeRFC extends SAPWrap {

    private String functionName = "ZHRE_RFC_P_STUD_TYPE";   

    /**
     * 본인,배우자 구분 데이터를 가져오는 RFC를 호출하는 Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getDetail() throws GeneralException {
        
        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

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
     * RFC 실행후 Export 값을 Vector 로 Return 한다.
     * 반드시 com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출된후에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutput(JCO.Function function) throws GeneralException {
        String tableName = "P_CODE";      // RFC Export 구성요소 참조
        return getCodeVector( function,tableName, "AREA_CODE", "AREA_DESC");
    }
}

