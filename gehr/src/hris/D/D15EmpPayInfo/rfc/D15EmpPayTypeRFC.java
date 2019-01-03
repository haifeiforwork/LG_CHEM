package hris.D.D15EmpPayInfo.rfc;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;
import hris.D.D15EmpPayInfo.D15EmpPayTypeData;

import java.util.Vector;

public class D15EmpPayTypeRFC extends SAPWrap {
	private String functionName = "ZGHR_RFC_ERI" ;

	/**
	 * 사원임금유형정보를 가져옴
	 * @param I_DATUM
	 * @param I_PERNR
	 * @return
	 * @throws GeneralException
	 */
	public Vector<D15EmpPayTypeData> getEmpPayType(String I_DATUM, String I_PERNR) throws GeneralException {

        JCO.Client mConnection = null;
        try{

            mConnection = getClient();
            JCO.Function function = createFunction( functionName ) ;

            setField( function, "I_DATUM", I_DATUM );
            setField( function, "I_PERNR", I_PERNR );

            excute( mConnection, function );

            return getTable(D15EmpPayTypeData.class, function, "T_RESULT");

        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }
	
}
