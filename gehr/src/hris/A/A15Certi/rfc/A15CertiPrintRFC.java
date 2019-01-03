package hris.A.A15Certi.rfc;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;
import hris.A.A15Certi.A15CertiData;
import hris.A.A15Certi.A15CertiData2;
import org.apache.commons.collections.map.HashedMap;

import java.util.Map;


/**
 * A15CertiPrintRFC.java
 * 재직증명서 본인발행 RFC 를 호출하는 Class                        
 *
 * @author  LSA
 * @version 1.0, 2008/5/8
 */
public class A15CertiPrintRFC extends SAPWrap {

    private String functionName = "ZGHR_RFC_OFFICE_DOC_PRINT";

    /**
     * 재직증명서 조회 RFC 호출하는 Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Map<String, Object> getDetail(String I_DOCGB, String I_PERNR, String I_AINF_SEQN, String I_GUBUN) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setField(function, "I_PERNR", I_PERNR);
            setField(function, "I_AINF_SEQN", I_AINF_SEQN);
            setField(function, "I_GUBUN", I_GUBUN);
            setField(function, "I_DOCGB", I_DOCGB);

            excute(mConnection, function);

            Map<String, Object> resultMap = new HashedMap();

            resultMap.put("T_RESULT", getTable(A15CertiData.class, function, "T_RESULT"));
            resultMap.put("T_RESULT2", getTable(A15CertiData2.class, function, "T_RESULT2"));

            resultMap.put("E_JUSO_TEXT", getField("E_JUSO_TEXT", function));
            resultMap.put("E_KR_REPRES", getField("E_KR_REPRES", function));

            return resultMap;
        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

}


