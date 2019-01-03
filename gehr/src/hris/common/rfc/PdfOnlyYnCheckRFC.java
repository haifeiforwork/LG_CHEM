package hris.common.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;

import hris.common.*;

/**
 * PdfOnlyYnCheckRFC.java
 * ���� pdf ���� upload �Ѱ��� �ƴѰ��� ���ο� ���� ���� �������� RFC�� ȣ���ϴ� Class(@2014 �������� �ҵ�����Ű��� �߰��� �׸�)
 *
 * @author ������   
 * @version 1.0, 2014/12/18
 *
 */
public class PdfOnlyYnCheckRFC extends SAPWrap {

    private String functionName = "ZSOLYR_RFC_NON_PDF";

    public String getOnlyPdfYN( String webUserId, String targetYear ) throws GeneralException {
        
        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, webUserId, targetYear);

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
    private void setInput(JCO.Function function, String webUserId, String targetYear) throws GeneralException{
        String fieldName = "I_PERNR";
        setField(function, fieldName, webUserId);
		String fieldName2 = "I_YEAR";
        setField(function, fieldName2, targetYear);
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
    	String fieldName = "E_CHK";

		String E_CHK    = getField(fieldName,    function);  // Y.N 
        return E_CHK;
    	
    }
}

