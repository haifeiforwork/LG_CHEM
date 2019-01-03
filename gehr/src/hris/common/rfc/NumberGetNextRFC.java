package hris.common.rfc;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;

import hris.common.*;

/**
 * NumberGetNextRFC.java
 * 결재정보에 대한 고유번호를 따오는 RFC를 호출하는 Class
 *
 * @author 김성일
 * @version 1.0, 2001/12/13
 */
public class NumberGetNextRFC extends SAPWrap {

    private String functionName ="ZHRA_RFC_NUMBER_GET_NEXT";
    //private String functionName ="ZGHR_RFC_NUMBER_GET_NEXT";

    /**
     * 결재정보에 대한 고유번호를 따오는 RFC를 호출하는 Method
     * @return java.lang.String
     * @exception com.sns.jdf.GeneralException
     */
    public String getNumberGetNext() throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            excute(mConnection, function);
            String ret = getField("E_AINF_SEQN", function);

            return ret;
        }catch(Exception ex){
            Logger.sap.println(this," SAPException :" +ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

 
}

