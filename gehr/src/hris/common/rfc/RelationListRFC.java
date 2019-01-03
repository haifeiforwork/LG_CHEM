package hris.common.rfc;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;
import com.sns.jdf.util.CodeEntity;

import java.util.Vector;

/**
 * RelationListRFC.java
 * Selected Code 정보를 가져오는 RFC를 호출하는 공통 Class
 *
 * @author jungin
 * @version 1.0, 2010/10/04
 */
public class RelationListRFC extends SAPWrap {
	
    private String functionName = "ZGHR_RFC_RLSHP_F4";

    /**
     * Select Code 정보를 가져오는 RFC를 호출하는 Method
     * @return java.util.Vector
     * @exception GeneralException
     */

    public Vector<CodeEntity> getRelationList() throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName);

            excute(mConnection, function);

            return getCodeVector(function, "T_RESULT");

        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

}
