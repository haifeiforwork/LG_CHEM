package hris.D.D07TimeSheet.rfc;

import hris.D.D07TimeSheet.D07TimeSheetWBSDataUsa;

import java.util.Vector;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;

/**
 * D07TimeSheetWBSRFCUsa.java
 * Time Sheet�� WBS ������ �������� RFC�� ȣ���ϴ� Class
 *
 * @author jungin
 * @version 1.0, 2010/10/12
 */
public class D07TimeSheetWBSRFCUsa extends SAPWrap {

    private String functionName = "ZGHR_RFC_F4_WBS";

    /**
     * Pay Date Raage ������ �������� RFC�� ȣ���ϴ� Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */

    public Vector getWbsList(String I_DATLO, String I_BUKRS, String I_POSID, String I_POST1) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setField (function, "I_DATLO", I_DATLO);
            setField (function, "I_BUKRS", I_BUKRS);
            //setField (function, "I_ACTIV", I_ACTIV);
            setField (function, "I_POSID", I_POSID);
            setField (function, "I_POST1", I_POST1);
            excute(mConnection, function);
            Vector ret = getOutput(function);

            return ret;
        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    /**
     * RFC ������ Export ���� Vector �� Return �Ѵ�.
     * �ݵ�� com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ����Ŀ� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutput(JCO.Function function) throws GeneralException {
    	Vector ts_WBS = new Vector();

        ts_WBS = getTable(D07TimeSheetWBSDataUsa.class, function,  "T_WBS");

        return ts_WBS;
    }

}
