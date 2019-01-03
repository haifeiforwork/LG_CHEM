package hris.common.rfc;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;

/**
 * GetMobileMSSAuthCheckRFC.java
 * G-mobile���� �λ� ��ȸ ������ �ִ����� Ȯ���ϴ� function
 *
 * @author ������
 * @version 1.0, 2016-01-27
 * @[CSR ID:2991671] g-mobile �� �λ����� ��ȸ ��� �߰� ���� ��û
 *
 */
public class GetMobileMSSAuthCheckRFC extends SAPWrap {

    private String functionName = "ZGHR_RFC_MOBILE_AUTH_CHECK";

    public String getMbMssAuthChk( String webUserId ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, webUserId);

            excute(mConnection, function);
            return getOutput(function);

        } catch(Exception ex) {
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
     * @exception com.sns.jdf.GeneralException
     *
     */
    private void setInput(JCO.Function function, String webUserId) throws GeneralException{
        String fieldName = "I_PERNR";
        setField(function, fieldName, webUserId);
    }

    /**
     * RFC ������ Export ���� String �� Return �Ѵ�.
     * �ݵ�� com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ����Ŀ� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.lang.String
     * @exception com.sns.jdf.GeneralException
     */
    private String getOutput(JCO.Function function) throws GeneralException {
        //String fieldName = "E_FLAG";      // RFC Export ������� ����
        //return getField(fieldName, function);
    	String fieldName = "E_FLAG";

		String E_FLAG    = getField(fieldName,    function);  // Y.N
        return E_FLAG;

    }
}

