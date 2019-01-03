package hris.N.bsnrmd;

import com.common.Utils;
import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;
import hris.common.OrganInfoData;

import java.util.Vector;

public class BusinRecommendRFC  extends SAPWrap {
 
    private String functionName = "ZGHR_RFC_GET_ORGEH_LIST";

    /** 
     * 권한에 따른 전체 조직 List를 가져오는 RFC를 호출하는 Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector<OrganInfoData> getOrganList(String I_PERNR, String I_AUTHOR, Vector T_IMPORTA) throws GeneralException {
        
        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setField(function, "I_PERNR", I_PERNR);
            setField(function, "I_AUTHOR", I_AUTHOR);
            setField(function, "I_ORGSG", "3");

            if(Utils.getSize(T_IMPORTA) > 0)
                setTable(function, "T_IMPORTA", T_IMPORTA);

            excute(mConnection, function);

            return getTable(OrganInfoData.class,  function, "T_EXPORTA");
            
        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

}


