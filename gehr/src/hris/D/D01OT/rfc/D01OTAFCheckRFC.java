package hris.D.D01OT.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;
import com.sap.mw.jco.*;

import hris.D.D01OT.*;


/**
 * D01OTAFCheckRFC.java
 * 초과근무 해당여부를 첵크하는 RFC 를 호출하는 Class
 *
 * @author 강동민
 * @version 1.0, 2018/05/23
 */
public class D01OTAFCheckRFC extends SAPWrap {

    private String functionName = "ZGHR_RFC_NTM_AFTOT_AVAIL_CHECK";

    /**
     * 초과근무 사후신청 체크 RFC 호출하는 Method
     * @return java.util.Vector
     * @param java.lang.String I_SPRSL	언어키
     * @exception com.sns.jdf.GeneralException
     */
    public Vector AFCheck(Vector T_RESULT) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setTable(function, "T_RESULT", T_RESULT);

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
	 * @param java.lang.String SPRSL
     * @exception com.sns.jdf.GeneralException
     * , String SPRSL
     */
    private void setInput(JCO.Function function, Vector entityVector) throws GeneralException {

    	setTable(function, "T_RESULT", entityVector);

    }

    /**
     * RFC 실행전에 Import 값을 setting 한다.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출되기 전에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @param entityVector java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutput(JCO.Function function) throws GeneralException {

        Vector ret = new Vector();
    	ret.addElement(getReturn().MSGTY);
    	ret.addElement(getReturn().MSGTX);
        return ret ;
    }
}


