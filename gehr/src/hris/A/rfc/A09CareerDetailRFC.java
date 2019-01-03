package	hris.A.rfc;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;
import hris.A.A09CareerDetailData;

import java.util.Vector;

/**
 * A09CareerDetailRFC.java
 * 근무경력 정보를 가져오는 RFC를 호출하는 Class
 *
 * @author 김도신
 * @version 1.0, 2001/12/19
 */
public class A09CareerDetailRFC extends SAPWrap {

    private String functionName = "ZGHR_RFC_CAREER_LIST";

    /**
     * 가족사항 정보를 가져오는 RFC를 호출하는 Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector<A09CareerDetailData> getCareerDetail(String I_PERNR, String I_CFORM) throws GeneralException {
    
        JCO.Client mConnection = null;
        
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setField(function, "I_PERNR", I_PERNR);
            setField(function, "I_CFORM", I_CFORM);

            excute(mConnection, function);

            return getTable(A09CareerDetailData.class, function, "T_LIST");

        } catch(Exception ex){
            Logger.sap.println(this, " SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }
       
}