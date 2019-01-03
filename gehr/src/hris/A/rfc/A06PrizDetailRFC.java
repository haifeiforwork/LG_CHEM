package hris.A.rfc;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;
import hris.A.A06PrizDetailData;

import java.util.Vector;

/**
 * ReWardRFC.java
 * 결재정보 List 를 가져오는 RFC를 호출하는 Class
 *
 * @author 최영호   
 * @version 1.0, 2001/12/17
 */
public class A06PrizDetailRFC extends SAPWrap {

    private String functionName = "ZGHR_RFC_AWARD_LIST";

    /**
     * 결재정보 List 를 가져오는 RFC를 호출하는 Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector<A06PrizDetailData> getPrizDetail(String I_PERNR, String I_CFORM, String I_CFMAN, String I_CFREC) throws GeneralException {
        
        JCO.Client mConnection = null;
        
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setField(function, "I_PERNR", I_PERNR);
            setField(function, "I_CFORM", I_CFORM);
            /*if("X".equals(I_CFORM))
                setField(function, "I_CFMAN", null);*/
            /*if(I_CFMAN != null)*/ setField(function, "I_CFMAN", I_CFMAN);
            if(I_CFREC != null) setField(function, "I_CFREC", I_CFREC);

            excute(mConnection, function);

            return getTable(A06PrizDetailData.class, function, "T_LIST");

        } catch(Exception ex) {
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }
}

