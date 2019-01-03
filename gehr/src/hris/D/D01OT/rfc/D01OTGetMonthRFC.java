package hris.D.D01OT.rfc;

import hris.common.approval.ApprovalSAPWrap;
import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;


/**
 * D01OTGetMonthRFC.java
 * �ʰ��ٹ���û�� �ش���¿� ���½��� ��ȸ�� ��ȸ����� ���� ������ �����ϴ� RFC �� ȣ���ϴ� Class
 *
 * @author ������
 * @version 1.0, 2017/08/24
 */
public class D01OTGetMonthRFC extends ApprovalSAPWrap {

    private String functionName = "ZGHR_RFC_GET_TIME_MONTH";

    public String getMonth( String P_PERNR, String P_BEGDA ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            setField( function, "I_PERNR", P_PERNR );
            setField( function, "I_BEGDA", P_BEGDA );
            excute(mConnection, function);
            String E_Month   = getField( "E_YYYY", function )+getField( "E_MONTH", function ) ;
            return E_Month;
        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

}


