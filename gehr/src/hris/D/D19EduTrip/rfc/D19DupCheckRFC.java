package hris.D.D19EduTrip.rfc;

import java.util.*;

import com.common.RFCReturnEntity;
import com.sns.jdf.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;
import com.sap.mw.jco.*;

import hris.D.D19EduTrip.*;


/**
 * D19DupCheckRFC.java
 * ����,�����û���ɿ��� üũ�ϴ� Class
 *
 * @author  lsa
 * @version 1.0, 2006/08/18
 */
public class D19DupCheckRFC extends SAPWrap {

  //  private String functionName = "ZHRW_RFC_CHECK_ATTD_APPLY";
	  private String functionName = "ZGHR_RFC_CHECK_ATTD_APPLY";

    /**
     * ����,�����û���ɿ��� üũ RFC ȣ���ϴ� Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public RFCReturnEntity check( D19EduTripData d19EduTripData) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            setInput( function, d19EduTripData );
            excute(mConnection, function);
            return getReturn();
        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    /**
     * RFC �������� Import ���� setting �Ѵ�.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ��Ǳ� ���� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
	   * @param java.lang.String �����ȣ
     * @param java.lang.String �������� �Ϸù�ȣ
     * @param job java.lang.String �������
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput( JCO.Function function, D19EduTripData d19EduTripData) throws GeneralException {
        String fieldName1 = "I_PERNR";
        setField( function, fieldName1, d19EduTripData.PERNR );
        String fieldName2 = "I_APPL_FROM";
        setField( function, fieldName2, d19EduTripData.APPL_FROM );
        String fieldName3 = "I_APPL_TO";
        setField( function, fieldName3, d19EduTripData.APPL_TO );
        String fieldName4 = "I_AINF_SEQN";
        setField( function, fieldName4, d19EduTripData.AINF_SEQN );
    }
    /**
     * RFC ������ Export ���� Vector �� Return �Ѵ�.
     * �ݵ�� com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ����Ŀ� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */

    private Object getOutput(JCO.Function function,D19DupCheckData data) throws GeneralException {
            return getFields(data, function);
    }

}


