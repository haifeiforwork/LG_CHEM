package hris.D.D25WorkTime.rfc;

import java.util.Vector;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;

import hris.D.D25WorkTime.D25WorkTimeP9810Data;

/**
 * D25WorkTimeP9810RFC.java
 * 인포타입 9810에 대한 HR 마스터레코드를 조회하는 RFC
 * 2018-08-03  성환희    [WorkTime52] 실 근로시간 레포트
 * @author 성환희
 * @version 1.0, 2018/08/03
 */
public class D25WorkTimeP9810RFC extends SAPWrap {
	
	private String functionName = "ZGHR_RFC_NTM_GET_P9810";
	
	public Vector<D25WorkTimeP9810Data> getP9810(String PERNR, String DATUM) throws GeneralException {
		
		JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName);

            setField(function, "I_PERNR", PERNR);
            setField(function, "I_DATUM", DATUM);

            excute(mConnection, function);
            
            Vector<D25WorkTimeP9810Data> T_P9810 = getTable(hris.D.D25WorkTime.D25WorkTimeP9810Data.class,  function, "T_P9810");
            
            return T_P9810;
        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
		
	}

}
