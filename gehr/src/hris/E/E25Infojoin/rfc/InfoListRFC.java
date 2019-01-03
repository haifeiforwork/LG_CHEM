package	hris.E.E25Infojoin.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;

import hris.E.E25Infojoin.*;

/**
 * InformalListRFC.java
 * 인포멀 리스트를 가져오는 class
 *
 * @author 이형석
 * @version 1.0, 2002/01/04
 */
public class InfoListRFC extends SAPWrap {

    //private String functionName = "ZHRH_RFC_P_INFORMAL_LIST";
	private String functionName = "ZGHR_RFC_P_INFORMAL_LIST";

    /**
     * 어학능력점정 일정을 가져오는 RFC를 호출하는 Method
     * @param java.lang.String사원번호 java.lang.String 시험코드
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getInfoList(String empNo) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, empNo);

            excute(mConnection, function);

            Vector ret = getTable(InfoListData.class, function, "T_RESULT");
            Logger.debug.println(this, "ret"+ret.toString());
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
     * @param function com.sap.mw.jco.JCO.Function java.lang.String java.lang.String
     * @param entityVector java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
   private void setInput(JCO.Function function, String empNo) throws GeneralException {
        String fieldName = "I_PERNR"          ;
        setField(function, fieldName, empNo);
    }

}