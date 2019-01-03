package	hris.A.A12Family.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;

import hris.A.A12Family.*;

/**
 * A12FamilySubTypeRFC.java
 * 가족 유형 코드, 명을 가져오는 RFC를 호출하는 Class
 *
 * @author 김도신
 * @version 1.0, 2001/12/26
 */
public class A12FamilySubTypeRFC extends SAPWrap {

    private String functionName = "HR_GET_ESS_SUBTYPES";

    /**
     * 가족 유형 코드, 명을 가져오는 RFC를 호출하는 Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getFamilySubType() throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setField( function, "INFTY", "0021" );
            setField( function, "MOLGA", "41" );
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
        String tableName = "SUBTYTAB";
        Vector ret       = new Vector();
        Vector temp_vt   = getCodeVector(function, tableName);

        for( int i=0 ; i < temp_vt.size() ; i++ ) {
            com.sns.jdf.util.CodeEntity ck = (com.sns.jdf.util.CodeEntity)temp_vt.get(i);
            
            //if( ck.code.equals("8") ) {
                // 지인을 제외시킨다.
           // } else {
                ret.addElement(ck);
           // }
        }
        
        Logger.sap.println(this, "가족유형(지인제외) : " + ret.toString());
        
        return ret;
    }
}