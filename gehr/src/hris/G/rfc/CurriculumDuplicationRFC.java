/*
 * ÀÛ¼ºµÈ ³¯Â¥: 2005. 3. 10.
 *
 */
package hris.G.rfc;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.sap.SAPWrap;

/**
 * @author ÀÌ½ÂÈñ
 *
 */
public class CurriculumDuplicationRFC extends SAPWrap
{
    private String functionName = "ZHRE_RFC_CHECK_YYMMDD";
    

    public String  getIsDuplication(String E_PERNR ,String E_BEGDA ,String E_ENDDA) throws GeneralException
    {
        String szRet; 
        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            setField(function ,"E_PERNR" ,E_PERNR);
            setField(function ,"E_BEGDA" ,E_BEGDA);
            setField(function ,"E_ENDDA" ,E_ENDDA);
            excute(mConnection ,function);
            szRet = getField("YNO_FLAG" ,function);
        } finally {
            close(mConnection);
        } // end try & catch
        return szRet;
    }

}
