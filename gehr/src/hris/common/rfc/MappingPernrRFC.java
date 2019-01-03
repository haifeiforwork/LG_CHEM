package hris.common.rfc;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;
import hris.common.MappingPernrData;

import java.util.Vector;

/**
 * MappingPernrRFC.java
 * 재입사자 사번을 가져오는 RFC를 호출하는 Class
 * @author 윤정현
 * @version 1.0, 2004/11/18
 */
public class MappingPernrRFC extends SAPWrap {

    private String functionName = "ZGHR_RFC_MAPPING_PERNR";

    /**
     * 주소검색 List 를 가져오는 RFC를 호출하는 Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector<MappingPernrData> getPernr( String I_PERNR) throws GeneralException {

        JCO.Client mConnection = null;

        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setField(function, "I_PERNR", I_PERNR);

            excute(mConnection, function);

            return getTable(MappingPernrData.class, function, "T_LIST");

        } catch(Exception ex) {
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }
}
