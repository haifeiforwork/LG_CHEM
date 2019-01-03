package hris.D.rfc ;

import java.util.* ;

import com.sap.mw.jco.* ;
import com.sns.jdf.* ;
import com.sns.jdf.sap.* ;
import com.sns.jdf.util.* ;

import hris.D.* ;

/**
 *  D13TaxAdjustSimulRFC.java
 *  �������� Simulation�� ���� �����ڷḦ �������� RFC�� ȣ���ϴ� Class
 *
 * @author �輺��
 * @version 1.0, 2002/01/28
 */
public class D13TaxAdjustSimulRFC extends SAPWrap {

    private String functionName = "ZSOLYR_RFC_SIM_YEA" ;

    /**
     * �������� Simulation�� ���� �����ڷḦ �������� RFC ȣ���ϴ� Method
     * @return java.util.Vector
     * @param empNo java.lang.String �����ȣ
     * @param beginDate java.lang.String ������
     * @param endDate java.lang.String ������
     * @exception com.sns.jdf.GeneralException
     */
    public Object detail( String empNo, String beginDate, String endDate ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, empNo, beginDate, endDate);
            excute(mConnection, function);
            D13TaxAdjustSimulData data = (D13TaxAdjustSimulData)getOutput( function, new D13TaxAdjustSimulData() );
            /*
            D13TaxAdjustSimulData retData = new D13TaxAdjustSimulData();

            if(!data.O_GROSS    .equals("")){retData.O_GROSS     =Double.toString(Double.parseDouble(data.O_GROSS    ) * 100.0 ) ; } // �Ѿ�              
            if(!data.O_TOTINCOM .equals("")){retData.O_TOTINCOM  =Double.toString(Double.parseDouble(data.O_TOTINCOM ) * 100.0 ) ; } // �������ӱ�        
            if(!data.O_TAXGROSS .equals("")){retData.O_TAXGROSS  =Double.toString(Double.parseDouble(data.O_TAXGROSS ) * 100.0 ) ; } // �Ѱ����ҵ�        
            if(!data.O_NTAXGROSS.equals("")){retData.O_NTAXGROSS =Double.toString(Double.parseDouble(data.O_NTAXGROSS) * 100.0 ) ; } // �Ѻ�����ҵ�      
            if(!data.O_INCOMTAX .equals("")){retData.O_INCOMTAX  =Double.toString(Double.parseDouble(data.O_INCOMTAX ) * 100.0 ) ; } // �ѱٷμҵ漼      
            if(!data.O_RESTAX   .equals("")){retData.O_RESTAX    =Double.toString(Double.parseDouble(data.O_RESTAX   ) * 100.0 ) ; } // ���ֹμ�          
            if(!data.O_SPTAX    .equals("")){retData.O_SPTAX     =Double.toString(Double.parseDouble(data.O_SPTAX    ) * 100.0 ) ; } // ��Ư����          
            */
            return data;
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
     * @param empNo java.lang.String ���
     * @param beginDate java.lang.String ������
     * @param endDate java.lang.String ������
     * @param job java.lang.String �������
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String empNo, String beginDate, String endDate ) throws GeneralException {
        String fieldName1 = "PERNR";
        setField( function, fieldName1, empNo );
        String fieldName2 = "TAX_BEGDA";
        setField( function, fieldName2, beginDate );
        String fieldName3 = "TAX_ENDDA";
        setField( function, fieldName3, endDate );
    }

// Export Return type�� Object �� ��� 2
// ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
    /**
     * RFC ������ Export ���� Object �� Return �Ѵ�.
     * �ݵ�� com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ����Ŀ� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @param data java.lang.Object
     * @return java.lang.Object
     * @exception com.sns.jdf.GeneralException
     */
    private Object getOutput(JCO.Function function, Object data) throws GeneralException {
        return getFields(data, function);
    }
}