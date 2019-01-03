package hris.E.E17Hospital.rfc ;

import java.util.* ;

import com.sap.mw.jco.* ;
import com.sns.jdf.* ;
import com.sns.jdf.sap.* ;
import com.sns.jdf.util.* ;

import hris.E.E17Hospital.* ;

/**
 * E17CompanyCoupleRFC.java
 *  �系 ����� ���θ� �������� RFC�� ȣ���ϴ� Class
 *  [CSR ID:2839626] �Ƿ�� ��û �� �系Ŀ�� ���� üũ ���� �߰�
 * @author �輺��
 * @version 1.0, 2002/01/08
 */
public class E17CompanyCoupleRFC extends SAPWrap {

    //private String functionName = "ZHRA_RFC_CHECK_COMPANY_COUPLE" ;
    private String functionName = "ZGHR_RFC_CHECK_COMPANY_COUPLE" ;

    /**
     * �系 ����� ���θ� �������� RFC ȣ���ϴ� Method
     * @param java.lang.String �����ȣ
     * @return hris.E.E05House.E05PersInfoData
     * @exception com.sns.jdf.GeneralException
     */
    public String getData(String empNo) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            String return_str = "";

            setInput(function, empNo);
            excute(mConnection, function);
            return_str = getField("E_FLAG",  function);// getOutput(function);

            return return_str;
        }catch(Exception ex){
            //Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    /**
     * ([CSR ID:2839626] �Ƿ�� ��û �� �系Ŀ�� ���� üũ ���� �߰�)
     * RFC �������� Import ���� setting �Ѵ�.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ��Ǳ� ���� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @param PERNR java.lang.String ���
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String PERNR) throws GeneralException {
        String fieldName = "I_PERNR";
        setField( function, fieldName, PERNR );
    }


}
