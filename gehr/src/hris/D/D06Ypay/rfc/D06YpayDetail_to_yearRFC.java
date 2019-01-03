package	hris.D.D06Ypay.rfc;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;

import java.util.Vector;

/**
 * D06YpayDetail_to_yearRFC.java
 * 2003/01/13  ������������ ���� ���޿� ����
 * ������ ���޿� ���� ������ �������� RFC�� ȣ���ϴ� Class
 * @author �ֿ�ȣ
 * @version 1.0, 2003/01/13
 *   Update       : 2013-06-24 [CSR ID:2353407] sap�� �߰��ϰ��� �߰� ��  
 */
public class D06YpayDetail_to_yearRFC extends SAPWrap { 

    private String functionName = "ZGHR_RFC_GET_TOTAL_SALARY2";
    
    /**
     * ������ ���޿� ���� ������ �������� RFC�� ȣ���ϴ� Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getYpayDetail( String empNo, String from_year,String  to_year ,String webUserId) throws GeneralException {
    
        JCO.Client mConnection = null;

        if(!g.getSapType().isLocal()) functionName="ZGHR_RFC_GET_TOTAL_SALARY";
        
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            
            setInput(function, empNo, from_year, to_year,webUserId); // [CSR ID:2353407]
            excute(mConnection, function);
            
            Vector ret = getTable(hris.D.D06Ypay.D06YpayDetailData_to_year.class, function, "T_TOTAL");
                        
              return ret;
            
        } catch(Exception ex){
            Logger.sap.println(this, " SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }
 
    /**
     * RFC �������� Import ���� setting �Ѵ�.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ��Ǳ� ���� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @param value java.lang.String ���
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String value, String value1, String value2,String value3) throws GeneralException {
       
        setField(function,  "I_PERNR", value);
        setField(function, "I_BEGYM", value1);
        setField(function, "I_ENDYM", value2);
        setField(function, "I_ID", value3);
    }
    
    
    
    
}