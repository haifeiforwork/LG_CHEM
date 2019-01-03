package hris.E.E05House.rfc;

import java.util.*;

import com.sap.mw.jco.*;
import com.sns.jdf.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;

import hris.E.E05House.*;
import hris.common.approval.ApprovalSAPWrap;

/**
 * E05PersInfoRFC.java
 * ����� �ּҿ� �ټӳ���� �������� RFC�� ȣ���ϴ� Class
 *
 * @author �輺��
 * @version 1.0, 2001/12/13
 */
public class E05PersInfoRFC extends ApprovalSAPWrap {

    //private String functionName = "ZHRA_RFC_GET_PERS_INFO";
    private String functionName = "ZGHR_RFC_GET_PERS_INFO";

    /**
     * ����� �ּҿ� �ټӳ���� �������� RFC�� ȣ���ϴ� Method
     * @param java.lang.String �����ȣ
     * @return hris.E.E05House.E05PersInfoData
     * @exception com.sns.jdf.GeneralException
     */
    public Object getPersInfo(String empNo) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, empNo);

            excute(mConnection, function);
            Object ret = getFields( ( new E05PersInfoData() ), function );//getOutput(function, ( new E05PersInfoData() ));

            return ret;
        }catch(Exception ex){
            //Logger.sap.println(this, "SAPException : "+ex.toString());
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
     */
    private void setInput(JCO.Function function, String empNo) throws GeneralException {
        String fieldName1 = "I_PERNR";
        setField( function, fieldName1, empNo );
        String fieldName2 = "I_DATE";
        setField( function, fieldName2, DataUtil.getCurrentDate() );
    }


}
